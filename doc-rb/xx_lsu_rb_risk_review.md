# `xx_lsu_rb` / `xx_lsu_rb_entry` 设计风险审查

## 1. 范围与结论

基于提交 `a81c012` 完成初审，并在 Interaction 1.5 提交 `443384a` 上复核 RB 多路 create/merge、容量保留、状态机、BIU/LFB request-response、SO ID FIFO、bus error、vector/FOF、WB completion/data 仲裁和 flush。本轮另外固定对照官方 T-Head openC910 提交 [`b91c909`](https://github.com/T-head-Semi/openc910/tree/b91c90914c19f114d35c8f6b73408eb241ed847c) 的 LSU/RTU/BIU；继承方程已确认，修改后系统的全局 response ownership 仍按合同依赖分类。

| ID | 优先级 | 置信度 | 状态 | 摘要 |
|---|---:|---|---|---|
| RB-RR-01 | P3 | 源码+合同 | 正确性关闭，保留性能检查 | 未复现 payload 串线；失败的高优先级 dp 最多造成保守占位/气泡 |
| RB-RR-02 | P1 | 源码+上游+合同 | C910 同源，系统合同仍保留 | C910 也会 async-flush WAIT_RESP；其 RTU 方程未用 all-commit-data 限定，且本地普通 NC ID 编码已修改 |
| RB-RR-03 | P2 | 合同依赖 | 条件关闭 | US response 用本地 1-bit beat counter，不检查 `r_last`/response 次数 |
| RB-RR-04 | P2 | 源码+上游+合同 | C910 同源，固定 ID 边界保留 | 未按 state 限定的 B hit 是继承行为，可接 paired WMB 早到 B；仍需证明全局同 ID 无无关 outstanding |
| RB-RR-05 | P2 | 已确认 | 配置项 | RB response ECC 被永久 tie 0，`rb_mcic_ecc_err` 不可触发 |
| RB-RR-06 | P3 | 已给定配置 | 约束项 | debug state 只固定导出 entry 0..7，参数变化无静态保护 |

## 2. 状态机摘要

活动状态为 IDLE、WAIT_RDY、REQ_BIU、WAIT_RESP、REQ_WB、WAIT_DATA_FF、WAIT_MERGE、FLUSH_FF（`srcs/xx_lsu_rb_entry.sv:1887-1961`）。partial flush 在 request 前转 FLUSH_FF；request 发出后保留 entry 接收 response并以 `dest_vld=0` 丢弃；async flush 则可在 WAIT_RESP/REQ_WB 直接回 IDLE。

BIU request pointer先在 entry/新 create 间仲裁并锁存，grant 时把 pointer发回 entry（`srcs/xx_lsu_rb.sv:1597-1745`）。SO 共享 ID 用 ID FIFO把 response重新映射到 entry（`srcs/xx_lsu_rb.sv:810-848`）。

## 3. 详细风险

### RB-RR-01：并发分配与 payload 来源复核

lane3 使用 `lsda0_rb_ex3_create_dp_vld ? rb_create_ptr3 : rb_create_ptr2`（`srcs/xx_lsu_rb.sv:1511-1514`），而 entry payload 以 `ld0 -> ls0 -> ls1` 的 per-entry dp-valid 优先级选择（`srcs/xx_lsu_rb_entry.sv:1040-1184`）。Interaction 1.3 特别要求检查“高优先级 dp 有效但未真正 create，低优先级 create 成功却锁存高优先级 payload”的经典错误。

本轮没有复现该正确性错误，原因有两层：

1. 送入 entry 的不是全局 raw dp-valid，而是 `pointer & !full & lane_dp_vld`（`srcs/xx_lsu_rb.sv:1517-1535`）。
2. 在 `judge -> dp -> vld` 合同成立时，可能重合 pointer 的容量边界会把低优先级 lane 的 `full` 拉高。只剩 1 项时，lane2 dp 蕴含 lane2 judge，`rb_lsda1_ex3_full` 必为 1（`srcs/xx_lsu_rb.sv:1466-1474`）；两项边界下，lane0/lane2 judge 的组合也会阻止 lane3 在与高优先级 pointer 重合时成功。

因此，若低优先级 `rb_entry_*_create_vld[i]` 真正置位，同 entry 上优先于它的 dp-valid 不会同时有效。高优先级 dp 后续因 ECC/discard 未形成 create 时，可能保守占用一个 pointer并让低优先级 lane 重试，但不会把高优先级 payload 写进已成功创建的低优先级 entry。LD0 侧 `dp -> judge` 可由 DA 产生式核对（`srcs/xx_lsu_ld_da.sv:3515-3520`、`srcs/xx_lsu_ld_da.sv:3522-3543`、`srcs/xx_lsu_ld_da.sv:3599-3605`）；Interaction 1.4 新增的 LSDA 也可见 `judge/unmask/dp/vld` 分层（`srcs/xx_lsu_ls_ld_da.sv:2743-2772`、`2827-2834`）。三 lane 本地产生式均支持该蕴含关系，仍保留接口断言以防 wrapper/top 接线或后续修改破坏合同。

### RB-RR-02：async flush 后的 response 所有权

WAIT_RESP 和 REQ_WB 遇 `rtu_lsu_async_flush` 可直接回 IDLE（`srcs/xx_lsu_rb_entry.sv:1919-1935`），entry 随后可以复用；response 命中主要按保存的 5-bit ID 判断（`srcs/xx_lsu_rb_entry.sv:2045-2067`）。若 BIU/LFB 仍返回旧 response，固定 SO/sync/atomic ID或被复用的 ID可能命中新事务。

Interaction 1.3 给出的 RTU/LFB/SO/SYNC/ATOMIC-NC 所有权规则可以条件关闭此项：未提交请求不释放 LFB ID，SO/atomic/sync-fence 在提交或 WMB fence 条件满足后才发送。可见源码支持 SO 等待 commit（`srcs/xx_lsu_rb_entry.sv:2017-2027`）和按 LFB/fixed class 编码 RID（`srcs/xx_lsu_rb.sv:1829-1837`）。

Interaction 1.5 要求参考 C910。固定版本对照结果是：上游 RB 同样在 WAIT_RESP/REQ_WB 遇 `rtu_lsu_async_flush` 直接回 IDLE（[上游 `ct_lsu_rb_entry.v:1136-1149`](https://github.com/T-head-Semi/openc910/blob/b91c90914c19f114d35c8f6b73408eb241ed847c/C910_RTL_FACTORY/gen_rtl/lsu/rtl/ct_lsu_rb_entry.v#L1136-L1149)）；上游 RTU 把 async debug request 延迟一拍后直接输出 `rtu_lsu_async_flush`（[上游 `ct_rtu_retire.v:1993-2016`](https://github.com/T-head-Semi/openc910/blob/b91c90914c19f114d35c8f6b73408eb241ed847c/C910_RTL_FACTORY/gen_rtl/rtu/rtl/ct_rtu_retire.v#L1993-L2016)），该方程没有使用 `lsu_rtu_all_commit_data_vld`。所以 C910 证明的是“该行为确实为继承设计”，不是“async flush 前所有 response 已返回”的源码证明。

此外，本地普通 non-cacheable 分支已把上游固定 `BIU_R_NC_ID=24` 改为 `lfb_rb_create_id`（本地 `srcs/xx_lsu_rb.sv:1829-1836` 对比[上游 `ct_lsu_rb.v:2488-2507`](https://github.com/T-head-Semi/openc910/blob/b91c90914c19f114d35c8f6b73408eb241ed847c/C910_RTL_FACTORY/gen_rtl/lsu/rtl/ct_lsu_rb.v#L2488-L2507)），不能直接继承上游 ID 复用证明。若本工程能提供 debug 停机期间的 drain/tombstone 与 ID reuse 合同，本项条件关闭；否则 entry 必须保留旧 request owner 直到 response 被吸收。

### RB-RR-03：US beat 完成依赖固定两拍合同

US request 发出 `ar_len=1`，本地 `rb_entry_us_cnt` 在首个 matching R response 后置 1（`srcs/xx_lsu_rb_entry.sv:1359-1370`）；只有旧值为 1 的后续 response 才置完成（`srcs/xx_lsu_rb_entry.sv:2060-2065`）。接口未输入/检查 `r_last`。Interaction 1.3 已明确 BIU 对该 ID 严格返回恰好两拍、无重放/截断，且 CA=0 或 SO 空间的 US 请求应在上游转为 `access_fault_with_page`；因此本项按合同条件关闭。错误映射和 BIU 实现均不在当前源码中，仍应在边界断言 beat 0/1 与 last，并确认非法属性请求不进入 RB 的 US 两拍状态机。

### RB-RR-04：B response 可提前置位

`rb_entry_biu_b_resp_set = rb_entry_b_id_hit` 没有 state 或 request-issued 条件（`srcs/xx_lsu_rb_entry.sv:2048-2067`），寄存器一旦置 1 会保持到下次 create（`srcs/xx_lsu_rb_entry.sv:1772-1782`）。sync/fence completion 又要求保存的 R/B 两响应（`srcs/xx_lsu_rb_entry.sv:2344-2359`）。

Interaction 1.4 新增的 WMB 源码显示，WMB entry 只有在 `write_biu_req`/mem-set request 后才置 `biu_b_id_vld`，命中 response 后清除（`srcs/xx_lsu_wmb_entry.sv:983-992`、`2031-2050`）；RB fence/sync 又等待 `wmb_sync_fence_biu_req_success` 才进入 request-ready（`srcs/xx_lsu_rb_entry.sv:2007-2015`）。这与“先 paired WMB AW、再 RB AR”的本地顺序合同一致，也解释了 RB 为什么不能简单加 `state==WAIT_RESP`：属于当前事务的 B 可能在 RB 的 R request 正式进入 WAIT_RESP 前到达并需要保存。

C910 固定版本使用完全相同的未限定方程（[上游 `ct_lsu_rb_entry.v:1236-1249`](https://github.com/T-head-Semi/openc910/blob/b91c90914c19f114d35c8f6b73408eb241ed847c/C910_RTL_FACTORY/gen_rtl/lsu/rtl/ct_lsu_rb_entry.v#L1236-L1249)），上游 WMB 也只在实际 request 后置 B-ID valid（[上游 `ct_lsu_wmb_entry.v:2013-2041`](https://github.com/T-head-Semi/openc910/blob/b91c90914c19f114d35c8f6b73408eb241ed847c/C910_RTL_FACTORY/gen_rtl/lsu/rtl/ct_lsu_wmb_entry.v#L2013-L2041)）；BIU write channel仅缓冲并转发 BID（[上游 `ct_biu_write_channel.v:964-1003`](https://github.com/T-head-Semi/openc910/blob/b91c90914c19f114d35c8f6b73408eb241ed847c/C910_RTL_FACTORY/gen_rtl/biu/rtl/ct_biu_write_channel.v#L964-L1003)）。继承关系与早到 B 意图已确认，但上游这些局部方程仍没有证明“同固定 ID 只属于该 paired transaction”。正确 assertion 应是 `B hit -> live entry && paired write request accepted && owner matches`，而不是过严的 `state==WAIT_RESP`。

### RB-RR-05：ECC 输出永久关闭

`rb_r_resp_ecc_err` 固定为 0（`srcs/xx_lsu_rb.sv:2241-2245`），`rb_mcic_ecc_err` 直接取该值（`srcs/xx_lsu_rb.sv:2309-2312`）。若目标 BIU没有独立 response ECC，本项按配置关闭；若 MCIC 需要端到端 ECC 报告，当前接口无法实现。

### RB-RR-06：固定 debug 观察宽度

RB 对外只导出 `state_0..7` 和 `fence[7:0]`（`srcs/xx_lsu_rb.sv:2325-2332`），与参数化 `RBENTRY` 不一致。正式参数需至少 8；若要求观察全部 entry，应改为数组端口。

## 4. 结构与建议

generate entry named-port 集合一致，WB completion/data 均先形成 one-hot pointer再选择 payload；文本复查未见重复端口。本轮未发现 Interaction 1.3 所担心的 create payload 串线。建议保留 create-winner/payload-source identity assertion，随后固化 async-flush response drain/tombstone、SO ID FIFO、US 两拍和 paired WMB/RB 固定 ID ownership，再处理 ECC 配置。
