# `xx_lsu_lq` / `xx_lsu_lq_entry` 设计风险审查

## 1. 范围与结论

审查提交 `9928a13` 的三路 LQ create、entry commit/restart pop、partial/full flush、RAR/RAW 地址比较、snoop 标记、age-vector 和 SFP spec-fail PC。保留 1 个高置信 SFP 选择风险、2 个接口合同风险及 2 个配置/清理项。

| ID | 优先级 | 置信度 | 状态 | 摘要 |
|---|---:|---|---|---|
| LQ-RR-01 | P2 | 高置信 | 开放待合同 | 多个 spec-fail entry 时返回最低物理 index 的 PC，而不是按程序年龄选择 |
| LQ-RR-02 | P1 | 合同依赖 | 开放待断言 | lane3 pointer 用 raw lane2 valid 决定，success/full 却使用另一组条件 |
| LQ-RR-03 | P1 | 合同依赖 | 条件关闭 | restart-pop 未以 entry valid 资格化，要求只指向仍存活 entry |
| LQ-RR-04 | P3 | 已给定配置 | 约束项 | SFP PC 固定 15 bit，没有 `PC_LEN` 参数 |
| LQ-RR-05 | P3 | 已确认 | 性能/清理 | flush-killed 前序 create 仍参与后续 lane 容量保留，可制造伪 full |

## 2. Entry 生命周期

valid 优先级是 reset → pop/global flush → partial flush → create（`srcs/xx_lsu_lq_entry.sv:249-261`）。payload、age-vector 和 snoop 位按 create dp-valid 更新（`srcs/xx_lsu_lq_entry.sv:266-340`）。commit 或 DA restart-pop 清 entry（`srcs/xx_lsu_lq_entry.sv:346-373`）。地址比较均以 valid、IID 年龄、line/byte overlap 资格化（`srcs/xx_lsu_lq_entry.sv:381-516`）。

## 3. 详细风险

### LQ-RR-01：spec-fail PC 的选择不是年龄优先

每个满足 RAR/RAW 条件的 entry 都直接拉高 `lsu*_spec_fail_1hot_x`（`srcs/xx_lsu_lq_entry.sv:538-543`）；top-level LQ 随后只对物理 index 做 first-one，返回最低 index entry 的 PC（`srcs/xx_lsu_lq.sv:660-686`）。被注释的 age-vector 屏蔽表明这里曾考虑年龄选择，但活动逻辑没有使用它。

当同一拍有多个 younger load 与检查请求冲突时，返回 PC 与程序年龄无关，并会随 entry 分配位置变化。如果 SFP 必须训练“最老违规 load”，当前实现会训练错误 PC；若合同允许任意一个违规 PC，本项可关闭。应让 SFP 合同明确，并优先用 age-vector 选 oldest matching entry。

### LQ-RR-02：lane3 分配依赖两套不一致的 create 语义

lane3 指针由 `lsdc0_lq_ex2_create_vld ? ptr3 : ptr2` 决定（`srcs/xx_lsu_lq.sv:617-625`），而 lane2/3 success 还受 flush 和容量条件过滤（`srcs/xx_lsu_lq.sv:559-587`）。若 raw lane2 valid 在被 flush/拒绝时仍为 1，lane3 会假定 lane2 占用了 ptr2；在边界容量下可能选择 0 或不必要地跳过唯一空位。

必须证明 `lsdc0_lq_ex2_create_vld` 与“本拍实际占用 ptr2”完全等价，或把 `lq_create_ptr3_fix` 改为由 `lq_create2_success` 控制。断言 `lq_create3_success |-> $onehot(lq_entry_create3_vld)` 可直接捕获事务丢失。

### LQ-RR-03：restart-pop 的存活性合同

`lq_entry_pop_vld` 对 commit hit 进行 valid 资格化，但三个 DA restart-pop one-hot 直接 OR 入（`srcs/xx_lsu_lq_entry.sv:346-373`）。若 flush 后出现迟到 restart-pop，且同 bit 被新 create 选中，pop 的更高优先级会吞掉新 create。完整流水必须保证 restart-pop 只指向当前存活且同 epoch 的 entry。

### LQ-RR-04：固定 PC 宽度

模块和 entry 的 PC 端口/寄存器全部固定为 15 bit（`srcs/xx_lsu_lq.sv:34-142`、`srcs/xx_lsu_lq_entry.sv:43-141`），而 top 有 `PC_LEN` 参数。正式 `PC_LEN=15` 时功能关闭；应增加静态 assertion 或参数化，避免非默认配置截断。

### LQ-RR-05：raw create 造成保守阻塞

lane2/3 success/full 方程使用未经过 partial-flush 过滤的前序 `*_create_vld`（`srcs/xx_lsu_lq.sv:572-587`、`srcs/xx_lsu_lq.sv:698-711`）。被 flush-kill 的 lane0/2 仍可能占用容量预算，使存活的 older lane 延迟重试。通常不丢事务，但会产生伪 full；重复冲突时需验证前进性。

## 4. 结构结论与建议

所有 entry receive 同一组 create vectors并以 one-hot bit实例化，未发现 named-port 漏接。建议先统一 raw/dp/success 为单一 `create_accept[2:0]`，再用 accept 同时驱动 pointer reservation、valid、payload clock 与 age update；随后明确 SFP 多匹配选择合同，并为 restart-pop 加 epoch/valid assertion。
