# `xx_lsu_ld_da` 设计风险审查

## 1. 范围与结论

审查提交 `9928a13` 的 DC→DA 流水、D-cache/TCM/forward 数据选择、ECC stall/replay、RB create/merge、completion/data writeback、vector/FOF、prefetch 与 debug cancel。缺失的 SQ/WMB/VMB/MCIC 行为按合同依赖分类。

| ID | 优先级 | 置信度 | 状态 | 摘要 |
|---|---:|---|---|---|
| DA-RR-01 | P2 | 已确认 | 开放 | ECC replay 时 `data_ori3` 错接 `data2` |
| DA-RR-02 | P2 | 高置信 | 开放待规格 | SQ forward ECC discard 逻辑被永久 tie 0，与本地注释相反 |
| DA-RR-03 | P2 | 合同依赖 | 开放待断言 | RB create/full/restart 必须原子接受，避免保存数据丢失 |
| DA-RR-04 | P2 | 合同依赖 | 开放待资格化 | debug address halt 未统一屏蔽 prefetch/no-spec 辅助副作用 |
| DA-RR-05 | P3 | 已确认 | 清理项 | 多处不可能值/X 和零扩展宽度写法降低 lint 可判定性 |

## 2. 流水与完成摘要

DA 在 ECC stall 时保持 EX3 事务，否则只从 `ldc_lda_ex2_inst_vld` 接收新事务（`srcs/xx_lsu_ld_da.sv:1969-2012`）。completion 由 exception/vector-nop/load/FOF/AMO/LR 条件形成，再由 ECC、restart 和 boundary mask 资格化（`srcs/xx_lsu_ld_da.sv:4948-4977`）；data request 另行以数据有效、exception、forward/restart 和 check-flush 资格化（`srcs/xx_lsu_ld_da.sv:4986-5024`）。

## 3. 详细风险

### DA-RR-01：ECC replay 的第 4 个数据块复制错误

正常保存路径分别保存 `data0..3`（`srcs/xx_lsu_ld_da.sv:3396-3403`），replay/RB 输出也分别为四个 128-bit 块；但 `lda_rb_ex3_data_ori3` 在 `lda_ecc_stall_already` 时选择的是 `lda_lwb_ex3_data2`，而不是 `data3`（`srcs/xx_lsu_ld_da.sv:3425-3438`）。

触发 unit-stride 512-bit load 的 ECC stall/replay 后，如果事务需要创建或更新 RB，第 384..511 bit 会复制 256..383 bit，最终 vector 数据和 byte lane 身份被破坏。该行应改为 `lda_lwb_ex3_data3`，并用四个互异数据花纹覆盖 replay。

### DA-RR-02：SQ forward + ECC 冲突策略被关闭

注释明确写明 WMB forward 可以 stall、SQ forward 应取消 ECC stall，因为 SQ 不支持 partial forward；原实现也按 `ecc_stall_already && (fwd_sq_vld || fwd_sq_bypass)` 产生 discard，但当前被注释并永久赋 0（`srcs/xx_lsu_ld_da.sv:4726-4739`）。这同时让 `lsu_idu_ex3_wait_old` 的对应路径成为死逻辑。

若系统保证 SQ forward 与 ECC replay 永不重叠，应写成正式互斥断言；否则必须恢复 discard/reissue 策略，并证明不会把修正后的 cache 数据与不同 epoch 的 SQ 数据合并。

### DA-RR-03：RB 容量与保存数据的接受合同

DA 先在 `ld_da_data_delay_vld` 下保存 miss/merge 数据（`srcs/xx_lsu_ld_da.sv:3396-3415`），RB create 最终又由 full/restart 条件控制。正确性依赖 `lda_rb_ex3_create_vld`、RB full 和 entry create success 在同一拍一致：full 必须使 DA restart，success 必须唯一且保存同一 transaction payload。应以 `{IID, entry_epoch}` 断言 create request 不是“DA 认为已接收、RB 实际未分配”。

### DA-RR-04：debug halt 对辅助副作用的屏蔽不统一

debug bit0 被并入 `ld_da_expt_vld_cancel`/`ld_da_expt_ori_cancel`（`srcs/xx_lsu_ld_da.sv:5413-5420`），主要 cache-buffer、RB 和 WB data side effect 多数使用该组合信号屏蔽；但 prefetch 输出仍只检查原始 `ld_da_expt_ori`（`srcs/xx_lsu_ld_da.sv:4901-4922`），no-spec 统计/训练输出也未统一检查 debug cancel（`srcs/xx_lsu_ld_da.sv:5320-5372`）。

若 debug halt 必须精确阻断被停指令的所有推测性副作用，这些输出可能在 halt 同拍继续训练或分配 prefetch。需由架构合同明确哪些辅助副作用允许保留，并对禁止项统一使用 cancel 后信号。

### DA-RR-05：X/default 与宽度清理

源中仍有面向仿真的 `2'b??` case 模式（`srcs/xx_lsu_ld_da.sv:3495-3496`），以及把 `256'b0` 赋给 64-bit 目标的写法（`srcs/xx_lsu_ld_da.sv:5250-5251`）。功能上零截断无差异，但综合/lint 策略若禁止 wildcard-X 或宽度不匹配，应统一为显式合法编码和目标宽度常量；非法 `vmew/rot_sel` 应用 assertion 报错，不应只传播 X。

## 4. 已排除项

DC 的 ahead-WB valid 不会在 restart 时误入 DA，因为 DA 锁存受 `ldc_lda_ex2_inst_vld` 资格化。常规 exception/restart 也同时屏蔽 completion/data request。当前最高优先级是 DA-RR-01 的确定数据破坏，其次确认 SQ-forward/ECC 合同。
