# `xx_lsu_rb` / `xx_lsu_rb_entry` 设计风险审查

## 1. 范围与结论

基于提交 `a81c012` 完成初审，并在 Interaction 1.4 提交 `6260f4a` 上复核 RB 多路 create/merge、容量保留、状态机、BIU/LFB request-response、SO ID FIFO、bus error、vector/FOF、WB completion/data 仲裁和 flush。新增 LFB/WMB 实现已纳入判断；BIU/RTU 全局 response ownership 仍按合同依赖分类。

| ID | 优先级 | 置信度 | 状态 | 摘要 |
|---|---:|---|---|---|
| RB-RR-01 | P3 | 源码+合同 | 正确性关闭，保留性能检查 | 未复现 payload 串线；失败的高优先级 dp 最多造成保守占位/气泡 |
| RB-RR-02 | P1 | 合同依赖 | 条件关闭 | async flush 可释放 WAIT_RESP entry，必须同步取消旧 response/ID |
| RB-RR-03 | P2 | 合同依赖 | 条件关闭 | US response 用本地 1-bit beat counter，不检查 `r_last`/response 次数 |
| RB-RR-04 | P2 | 源码+合同 | 源码缩小，BIU 边界保留 | WMB 只在实际 request 后置 B-ID valid，RB 仍只按固定 ID 命中 |
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

Interaction 1.3 给出的 RTU/LFB/SO/SYNC/ATOMIC-NC 所有权规则足以条件关闭此项：未提交请求不释放 LFB ID，SO/atomic/sync-fence 在提交或 WMB fence 条件满足后才发送。可见源码支持 SO 等待 commit（`srcs/xx_lsu_rb_entry.sv:2017-2027`）和按 LFB/fixed class 编码 RID（`srcs/xx_lsu_rb.sv:1829-1837`）；Interaction 1.4 已补充 LFB/WMB 本地实现，但 RTU 对 async flush 的全局 response 取消规则与 BIU 的 outstanding ownership 仍不可见。因此仍须用 epoch scoreboard 验证；若合同不成立，entry 必须保留 tombstone 直到旧 response 被吸收。

### RB-RR-03：US beat 完成依赖固定两拍合同

US request 发出 `ar_len=1`，本地 `rb_entry_us_cnt` 在首个 matching R response 后置 1（`srcs/xx_lsu_rb_entry.sv:1359-1370`）；只有旧值为 1 的后续 response 才置完成（`srcs/xx_lsu_rb_entry.sv:2060-2065`）。接口未输入/检查 `r_last`。Interaction 1.3 已明确 BIU 对该 ID 严格返回恰好两拍、无重放/截断，且 CA=0 或 SO 空间的 US 请求应在上游转为 `access_fault_with_page`；因此本项按合同条件关闭。错误映射和 BIU 实现均不在当前源码中，仍应在边界断言 beat 0/1 与 last，并确认非法属性请求不进入 RB 的 US 两拍状态机。

### RB-RR-04：B response 可提前置位

`rb_entry_biu_b_resp_set = rb_entry_b_id_hit` 没有 state 或 request-issued 条件（`srcs/xx_lsu_rb_entry.sv:2048-2067`），寄存器一旦置 1 会保持到下次 create（`srcs/xx_lsu_rb_entry.sv:1772-1782`）。sync/fence completion 又要求保存的 R/B 两响应（`srcs/xx_lsu_rb_entry.sv:2344-2359`）。

Interaction 1.4 新增的 WMB 源码显示，WMB entry 只有在 `write_biu_req`/mem-set request 后才置 `biu_b_id_vld`，命中 response 后清除（`srcs/xx_lsu_wmb_entry.sv:983-992`、`2031-2050`）；RB fence/sync 又等待 `wmb_sync_fence_biu_req_success` 才进入 request-ready（`srcs/xx_lsu_rb_entry.sv:2007-2015`）。这与“先 AW、再 RB AR”的本地顺序合同一致。

但 RB 自身的 B response set 仍未按 WAIT_RESP/request epoch 资格化，仓库也缺 BIU 对固定 ID 的全局 outstanding/返回规则，无法排除上一事务迟到的同 ID response。因此本项从“WMB 完全缺失”缩小为“WMB 本地顺序已证，BIU 边界保留”，继续绑定 `B hit -> live WAIT_RESP request epoch`。

### RB-RR-05：ECC 输出永久关闭

`rb_r_resp_ecc_err` 固定为 0（`srcs/xx_lsu_rb.sv:2241-2245`），`rb_mcic_ecc_err` 直接取该值（`srcs/xx_lsu_rb.sv:2309-2312`）。若目标 BIU没有独立 response ECC，本项按配置关闭；若 MCIC 需要端到端 ECC 报告，当前接口无法实现。

### RB-RR-06：固定 debug 观察宽度

RB 对外只导出 `state_0..7` 和 `fence[7:0]`（`srcs/xx_lsu_rb.sv:2325-2332`），与参数化 `RBENTRY` 不一致。正式参数需至少 8；若要求观察全部 entry，应改为数组端口。

## 4. 结构与建议

generate entry named-port 集合一致，WB completion/data 均先形成 one-hot pointer再选择 payload；文本复查未见重复端口。本轮未发现 Interaction 1.3 所担心的 create payload 串线。建议保留 create-winner/payload-source identity assertion，随后固化 async-flush response cancellation、SO ID FIFO、US 两拍和 BIU 固定 ID ownership，再处理 ECC 配置。
