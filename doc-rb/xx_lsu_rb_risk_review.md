# `xx_lsu_rb` / `xx_lsu_rb_entry` 设计风险审查

## 1. 范围与结论

审查提交 `9928a13` 的 RB 多路 create/merge、容量保留、状态机、BIU/LFB request-response、SO ID FIFO、bus error、vector/FOF、WB completion/data 仲裁和 flush。当前缺少 BIU/LFB/WMB 协议实现，以下跨模块项按合同依赖分类。

| ID | 优先级 | 置信度 | 状态 | 摘要 |
|---|---:|---|---|---|
| RB-RR-01 | P1 | 合同依赖 | 开放待断言 | lane3 pointer 由 lane2 dp-valid 决定，但容量/success 用 judge/vld |
| RB-RR-02 | P1 | 合同依赖 | 条件关闭 | async flush 可释放 WAIT_RESP entry，必须同步取消旧 response/ID |
| RB-RR-03 | P2 | 合同依赖 | 条件关闭 | US response 用本地 1-bit beat counter，不检查 `r_last`/response 次数 |
| RB-RR-04 | P2 | 高置信 | 开放待合同 | B response set 仅按 ID，未以 WAIT_RESP/本 entry request 资格化 |
| RB-RR-05 | P2 | 已确认 | 配置项 | RB response ECC 被永久 tie 0，`rb_mcic_ecc_err` 不可触发 |
| RB-RR-06 | P3 | 已给定配置 | 约束项 | debug state 只固定导出 entry 0..7，参数变化无静态保护 |

## 2. 状态机摘要

活动状态为 IDLE、WAIT_RDY、REQ_BIU、WAIT_RESP、REQ_WB、WAIT_DATA_FF、WAIT_MERGE、FLUSH_FF（`srcs/xx_lsu_rb_entry.sv:1887-1961`）。partial flush 在 request 前转 FLUSH_FF；request 发出后保留 entry 接收 response并以 `dest_vld=0` 丢弃；async flush 则可在 WAIT_RESP/REQ_WB 直接回 IDLE。

BIU request pointer先在 entry/新 create 间仲裁并锁存，grant 时把 pointer发回 entry（`srcs/xx_lsu_rb.sv:1597-1745`）。SO 共享 ID 用 ID FIFO把 response重新映射到 entry（`srcs/xx_lsu_rb.sv:810-848`）。

## 3. 详细风险

### RB-RR-01：并发分配控制信号不一致

lane3 使用 `lsda0_rb_ex3_create_dp_vld ? rb_create_ptr3 : rb_create_ptr2`（`srcs/xx_lsu_rb.sv:1511-1514`），但 lane2/3 full 与 success 由 `create_judge_vld`、`create_vld` 和 old 条件决定（`srcs/xx_lsu_rb.sv:1430-1498`）。如果 dp-valid 可以在 lane2 未实际 accept 时为 1，lane3 会错误假定 ptr2 已占用；只剩一个普通 entry 时可出现 `rb_create_ls1_success=1` 而 create vector 为 0。

必须证明 `lsda0_rb_ex3_create_dp_vld -> rb_create_ls0_success` 在 lane3 同时 accept 的所有边界容量条件下成立，或改由 `rb_create_ls0_success` 控制 ptr3_fix。此风险同样影响锁存 BIU request pointer（`srcs/xx_lsu_rb.sv:1648-1660`）。

### RB-RR-02：async flush 后的 response 所有权

WAIT_RESP 和 REQ_WB 遇 `rtu_lsu_async_flush` 可直接回 IDLE（`srcs/xx_lsu_rb_entry.sv:1919-1935`），entry 随后可以复用；response 命中主要按保存的 5-bit ID 判断（`srcs/xx_lsu_rb_entry.sv:2045-2067`）。若 BIU/LFB 仍返回旧 response，固定 SO/sync/atomic ID或被复用的 ID可能命中新事务。

需要“async flush 在 entry 复用前取消/排空所有旧 BIU、LFB 和 SO-ID-FIFO 状态”的外部合同，并用 epoch scoreboard验证。若总线不能取消，entry 必须保留 tombstone直到旧 response被吸收。

### RB-RR-03：US beat 完成依赖固定两拍合同

US request 发出 `ar_len=1`，本地 `rb_entry_us_cnt` 在首个 matching R response 后置 1（`srcs/xx_lsu_rb_entry.sv:1359-1370`）；只有旧值为 1 的后续 response 才置完成（`srcs/xx_lsu_rb_entry.sv:2060-2065`）。接口未输入/检查 `r_last`。因此正确性依赖 BIU 对该 ID严格返回恰好两拍、无重放/截断。应在总线边界断言 beat 0/1 与 last，错误响应也不得改变拍数。

### RB-RR-04：B response 可提前置位

`rb_entry_biu_b_resp_set = rb_entry_b_id_hit` 没有 state 或 request-issued 条件（`srcs/xx_lsu_rb_entry.sv:2048-2067`），寄存器一旦置 1 会保持到下次 create（`srcs/xx_lsu_rb_entry.sv:1772-1782`）。sync/fence completion 又要求保存的 R/B 两响应（`srcs/xx_lsu_rb_entry.sv:2344-2359`）。若共享 ID 的无关 B response 在本 entry 正式 request 前到达，可能使后续只收到 R 就提前完成。需要证明固定 B ID 全局串行且不存在这种窗口，或把 set 资格化为 WAIT_RESP + request epoch。

### RB-RR-05：ECC 输出永久关闭

`rb_r_resp_ecc_err` 固定为 0（`srcs/xx_lsu_rb.sv:2241-2245`），`rb_mcic_ecc_err` 直接取该值（`srcs/xx_lsu_rb.sv:2309-2312`）。若目标 BIU没有独立 response ECC，本项按配置关闭；若 MCIC 需要端到端 ECC 报告，当前接口无法实现。

### RB-RR-06：固定 debug 观察宽度

RB 对外只导出 `state_0..7` 和 `fence[7:0]`（`srcs/xx_lsu_rb.sv:2325-2332`），与参数化 `RBENTRY` 不一致。正式参数需至少 8；若要求观察全部 entry，应改为数组端口。

## 4. 结构与建议

generate entry named-port 集合一致，WB completion/data 均先形成 one-hot pointer再选择 payload；文本复查未见重复端口。建议优先统一 create accept/pointer语义，随后固化 async-flush response cancellation、SO ID FIFO 与 US beat 合同，再处理 B response state qualification和 ECC 配置。
