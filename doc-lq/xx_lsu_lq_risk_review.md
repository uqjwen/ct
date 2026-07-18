# `xx_lsu_lq` / `xx_lsu_lq_entry` 设计风险审查

## 1. 范围与结论

基于提交 `a81c012` 复核三路 LQ create、entry commit/restart pop、partial/full flush、RAR/RAW 地址比较、snoop 标记、age-vector 和 SFP spec-fail PC。Interaction 1.3 关闭了 3 个正确性疑问，但保留 raw create 的保守阻塞、参数和 epoch 断言。

| ID | 优先级 | 置信度 | 状态 | 摘要 |
|---|---:|---|---|---|
| LQ-RR-01 | P3 | 已确认权衡 | 功能关闭，性能观察 | 多匹配返回最低物理 index PC，接受为 SFP 训练策略 |
| LQ-RR-02 | P3 | 源码+合同 | 正确性关闭，性能项并入 RR-05 | winner 与高优先级 dp 不会在同 entry 冲突 |
| LQ-RR-03 | P2 | 源码+合同 | 条件关闭 | 可见 LD 路径 flush 后不产生迟到 restart-pop；LSDA 路径待合同 |
| LQ-RR-04 | P3 | 已给定配置 | 约束项 | SFP PC 固定 15 bit，没有 `PC_LEN` 参数 |
| LQ-RR-05 | P3 | 已确认 | 性能/清理 | flush-killed 前序 create 仍参与后续 lane 容量保留，可制造伪 full |

## 2. Entry 生命周期

valid 优先级是 reset → pop/global flush → partial flush → create（`srcs/xx_lsu_lq_entry.sv:249-261`）。payload、age-vector 和 snoop 位按 create dp-valid 更新（`srcs/xx_lsu_lq_entry.sv:266-340`）。commit 或 DA restart-pop 清 entry（`srcs/xx_lsu_lq_entry.sv:346-373`）。地址比较均以 valid、IID 年龄、line/byte overlap 资格化（`srcs/xx_lsu_lq_entry.sv:381-516`）。

## 3. 详细风险

### LQ-RR-01：spec-fail PC 的选择不是年龄优先

每个满足 RAR/RAW 条件的 entry 都直接拉高 `lsu*_spec_fail_1hot_x`（`srcs/xx_lsu_lq_entry.sv:538-543`）；top-level LQ 随后只对物理 index 做 first-one，返回最低 index entry 的 PC（`srcs/xx_lsu_lq.sv:660-686`）。被注释的 age-vector 屏蔽表明这里曾考虑年龄选择，但活动逻辑没有使用它。

当同一拍有多个 younger load 与检查请求冲突时，返回 PC 与程序年龄无关，并会随 entry 分配位置变化。Interaction 1.3 已接受这一时序/性能权衡，等价于把 SFP 合同明确为“任一违规 PC 均合法”，因此功能风险关闭。仍建议保留多匹配计数器，确认实测低频假设在工作负载和参数变化后继续成立；若未来要求 oldest，才使用 age-vector 重构。

### LQ-RR-02：lane3 分配与 payload 来源复核

lane3 指针由 `lsdc0_lq_ex2_create_vld ? ptr3 : ptr2` 决定（`srcs/xx_lsu_lq.sv:617-625`），entry payload 则按 lane0→lane2→lane3 的 per-entry dp-valid 优先级选择（`srcs/xx_lsu_lq_entry.sv:266-310`）。与 RB 不同，LQ 的 dp vectors 没有 `success`/`!full` 掩码（`srcs/xx_lsu_lq.sv:590-626`），所以边界容量下多个 dp 可以指向同一空 entry，必须证明实际 winner 的 payload 来源仍唯一。

本轮枚举 0/1/2/3 个空位和 partial-flush 后得到：

- 只剩 1 项时，lane0/lane2 pointer 可重合，但只要 lane0 raw create 有效，lane2 success 就被 `lq_less2 && ldc0_lq_ex2_create_vld` 阻止；lane3 同理被前序 raw create 阻止（`srcs/xx_lsu_lq.sv:572-587`）。若高优先级被 partial flush 杀死，低优先级也保守重试，不会在同 entry 成功。
- 剩 2 项且 lane2 raw create 有效时，lane3 使用与 ptr2 分离的 ptr3；若 ptr3 与 lane0 的 ptr0 重合，lane0+lane2 同时 raw valid 又会阻止 lane3 success。
- 剩 3 项以上时三个 pointer 分离。可见 LD lane 的 `create_vld == create_dp_vld` 由 DC 源码直接保证（`srcs/xx_lsu_ld_dc.sv:1565-1580`）；LSDA0/1 producer 未提供，需合同保证相同关系。

因此没有出现“低优先级 create 成功但 entry 被高优先级失败 dp 写 payload”的正确性错误。剩余问题是被 flush-kill 的 raw create 仍会保守占容量，归入 LQ-RR-05；验证应断言每个真实 winner 的同 entry 高优先级 dp 为 0，而不能错误要求全部 dp vectors 永远 one-hot。

### LQ-RR-03：restart-pop 的存活性合同

`lq_entry_pop_vld` 对 commit hit 进行 valid 资格化，但三个 DA restart-pop one-hot 直接 OR 入（`srcs/xx_lsu_lq_entry.sv:345-375`），且 pop 优先于 create（`srcs/xx_lsu_lq_entry.sv:249-261`）。可见 LD 路径中，DC 只把真实 `lq_entry_create_vld` 保存到 DA（`srcs/xx_lsu_ld_dc.sv:1565-1608`），DA 又只在 live EX3 且 `restart_no_cache` 时生成 pop（`srcs/xx_lsu_ld_da.sv:4873-4877`）；full flush 和针对该 IID 的 check flush 会清掉 DA stage valid（`srcs/xx_lsu_ld_da.sv:1981-2012`）。此外 allocator 按拍前 valid 选空项，正在被 pop 的 live entry 同拍不会被 create pointer复用。

因此可见 LD 路径没有 flush 后迟到 pop 吞新 create 的窗口。LSDA0/1 的 DC/DA 源码未提供，只能按同样的 `create accepted -> saved pointer -> live DA restart` 合同条件关闭；仍建议保留 `restart-pop -> live matching entry epoch` assertion。

### LQ-RR-04：固定 PC 宽度

模块和 entry 的 PC 端口/寄存器全部固定为 15 bit（`srcs/xx_lsu_lq.sv:34-142`、`srcs/xx_lsu_lq_entry.sv:43-141`），而 top 有 `PC_LEN` 参数。正式 `PC_LEN=15` 时功能关闭；应增加静态 assertion 或参数化，避免非默认配置截断。

### LQ-RR-05：raw create 造成保守阻塞

lane2/3 success/full 方程使用未经过 partial-flush 过滤的前序 `*_create_vld`（`srcs/xx_lsu_lq.sv:572-587`、`srcs/xx_lsu_lq.sv:698-711`）。被 flush-kill 的 lane0/2 仍可能占用容量预算，使存活的 older lane 延迟重试。通常不丢事务，但会产生伪 full；重复冲突时需验证前进性。

## 4. 结构结论与建议

所有 entry receive 同一组 create vectors并以 one-hot bit实例化，未发现 named-port 漏接。本轮未发现新的 payload 串线或迟到 restart-pop 正确性错误。若后续优化，仍建议把 raw/dp/success 收敛为显式 `create_accept[2:0]`，减少保守伪 full；同时保留 winner/payload identity、restart-pop epoch 和 SFP 多匹配频率检查。
