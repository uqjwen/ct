# Interaction 1.3 LSU 复核总表

## 1. 总结

本轮基于提交 `a81c012`，逐项复核 README Interaction 1.3 的 17 个问题。结论是：没有复现 RB/LQ 所担心的“高优先级 lane 未真正创建，却污染低优先级成功 entry payload”的经典错误；可见 LD 流水也没有发现 flush 后迟到 LQ pop 或 LRQ bitmap。部分结论依赖仓库外合同，不能标为源码证明。

Interaction 1.2 已确认的问题并未因本轮澄清自动消失。优先级最高的确定问题仍包括 DA ECC replay 第 4 块误接、WB debug halt-info 关钟丢更新、DC debug address valid 粘住和 LRQ replay 未保存 halt-info。

状态定义：

- **源码关闭：** 当前仓库可见 RTL 足以证明。
- **合同关闭：** README 给出的系统约束足以关闭场景，但缺失 producer/consumer 源码，仍需 assertion/scoreboard。
- **正确性关闭/性能保留：** 未发现数据或事务错误，但存在保守阻塞、气泡或性能观察项。
- **仍开放：** 存在已确认实现问题或合同尚不足。

## 2. 17 点处置矩阵

| README 点 | 对应项 | 处置 | 核心证据/剩余条件 |
|---:|---|---|---|
| 1 | RB-RR-01 | 正确性关闭，性能保留 | per-entry dp 先经过 pointer/`!full`；容量方程在 pointer 可能重合时阻止低优先级 success。LSDA producer 仍需 `judge -> dp -> vld` 断言。 |
| 2 | RB-RR-02 | 合同关闭 | 可见 SO 等 commit、RID 分类编码；RTU/LFB ID 不复用与 async flush 排空规则需完整模块 scoreboard。 |
| 3 | RB-RR-03 | 合同关闭 | RB 本地只用 1-bit US beat counter且无 `r_last`；依赖 BIU 恰好两拍、无 replay/truncation，CA=0/SO 的非法 US 在上游报 `access_fault_with_page`。 |
| 4 | RB-RR-04 | 合同关闭 | B hit 未按 state/request 资格化；依赖 WMB 固定 ID 串行、正式 request 前无无关 B response。 |
| 5 | WB-RR-03 | 数据正确性源码关闭，活性保留 | DA 产生式证明 `req -> dp -> gate`；dp-only 会真实屏蔽 WMB/VMB/RB，需有界解除和 loser hold。 |
| 6 | WB-RR-04 | 合同关闭待系统验证 | issue-queue 反压和三 lane bus arb 可形成前进闭环，但相关源码缺失；仍需 bounded-grant assertion。 |
| 7 | DC-RR-02 | 合同关闭 | `xx_lsu_dcache_arb` 声明 valid/gate 等价；该模块缺失，边界需断言双向相等。 |
| 8 | DC-RR-03 | 合同关闭 | 一致性系统保证 tag hit one-hot；DC 仍应本地断言 `$onehot0(ldc_hit_way)`，避免只靠最终数据比对发现。 |
| 9 | LQ-RR-01 | 功能关闭，性能观察 | 最低物理 index PC 被接受为 any-match SFP 训练策略；保留多匹配率计数。 |
| 10 | LQ-RR-02 | 正确性关闭，性能并入 LQ-RR-05 | 枚举空位/flush 后，低优先级 winner 与高优先级 dp 不会在同 entry 冲突；raw create 可造成保守重试。 |
| 11 | LQ-RR-03 | 可见 LD 源码关闭，LSDA 合同关闭 | DC 保存真实 create pointer，DA 只由 live EX3+saved pointer 产生 restart-pop，flush 清 DA valid；LSDA DC/DA 源码缺失。 |
| 12 | LRQ-RR-02 | 合同关闭 | no-space 预留确保非 flush create 有 slot；flush 同拍 raw IDU pop 依赖上游同项也被 flush kill。 |
| 13 | LRQ-RR-03 | 合同关闭 | MMU 必须在 flush 删除旧 pending；consumer 无 generation tag，需负向 epoch 注入。 |
| 14 | CTRL-RR-01 | VMB 笔误源码关闭，剩余门控条件关闭 | `vmb_create1` 已补；ICC/LSDA 三个 enable 仍遗漏，但 `pfu_part_empty=0` 使父时钟常开。 |
| 15 | CTRL-RR-02 | 合同关闭 | `LSIQENTRY == LRQENTRY` 已确认；仍应用 elaboration static assertion 固化。 |
| 16 | CTRL-RR-03 | 可见 DA 路径源码关闭，外部 producer 合同关闭 | DA bitmap 来自 live stage/saved LSID，未见提前释放/迟到修改；MMU/LFB/SQ/WMB 源码缺失，仍需 IID/epoch 所有权证明。 |
| 17 | DA-RR-01..05 | 已补充显式索引 | DA 分析在 `doc_da/xx_lsu_ld_da_risk_review.md`，验证在同目录 `xx_lsu_ld_da_verification_focus.md`；本轮已增加 Interaction 1.3 交叉复核。 |

## 3. 经典 payload-source 反例结论

### RB

RB entry payload 虽按 `ld0 -> ls0 -> ls1` dp-valid 优先选择，但每个 entry 的 dp-valid 已经是 `pointer & !full & lane_dp`。在 `judge -> dp -> vld` 合同下，只有一个/两个空位导致 pointer 可能重合时，full 方程会阻止低优先级 lane 成为 winner。因此可能出现失败 dp 的保守占位，但不会出现低优先级成功 entry 锁存高优先级 payload。

对 1..6 个普通 entry 的所有占用图、old、judge/dp/create 组合做方程级穷举，共检查 64,512 个满足 `judge -> dp -> create` 的状态，未出现 winner 无 pointer 或低优先级 winner 被高优先级 dp 命中同 entry。

### LQ

LQ per-entry dp 没有 success 掩码，合法边界下确实可能有多个失败/高优先级 dp 指向同一空 entry；但容量 success 方程保证，一旦低优先级 lane 成为真实 winner，同 entry 上更高优先级 dp 必为 0。验证不能简单断言所有 dp 永远 one-hot，而应断言 `winner -> own dp && no higher-priority dp on same entry`。

对 1..6 个 entry 的所有占用图、三 lane raw create 和 partial-flush kill 组合做方程级穷举，共检查 8,064 个状态，同样未发现 winner/payload-source 冲突或 success-with-zero-pointer。

## 4. 仍开放的确定问题

本轮澄清没有关闭下列既有问题：

1. **DA-RR-01：** ECC replay 时 `lda_rb_ex3_data_ori3` 错选 `data2`，会破坏 512-bit 第 4 数据块。
2. **WB-RR-01：** RB data-trigger halt-info update 未覆盖 completion payload 时钟 enable，可能丢更新。
3. **DC-RR-01：** `ld_dc_dtu_addr_vld` 缺少正常清零路径，可能重复输出旧 debug 地址请求。
4. **LRQ-RR-01：** LRQ replay 未保存 `halt_info`，AG 可能取到当前 IDU 事务的调试 metadata。
5. **DA-RR-02/04、WB-RR-02 等：** 仍需规格或外部协议确认，详见各模块报告。

## 5. 为源码级关闭仍需补充的信息

如需把“合同关闭”提升为“源码关闭”，请优先补充以下 RTL/规格：

1. `xx_lsu_dcache_arb`：证明 borrow valid/gate 完全等价。
2. `xx_lsu_bus_arb`、WMB/VMB/RB writeback producer 和 issue queue：证明 loser hold、三 lane 迁移及有界 grant。
3. BIU、LFB、WMB fence/ID 管理和 RTU async-flush：证明 response ownership、ID 不提前复用、US 恰好两拍与共享 B ID 串行。
4. LSDA0/1 的 DC/DA producer：证明 LQ/RB create 的 `judge/dp/vld` 关系以及 restart-pop 生命周期与 LD 路径一致。
5. MMU、LFB、SQ、WMB wakeup producer：证明 flush 删除 pending，entry bit 在复用前不再发旧 epoch wakeup。
6. 参数/接口规格：书面固化 `LSIQENTRY == LRQENTRY`、SFP any-match PC 语义、CA=0/SO unit-stride 的 `access_fault_with_page` 映射。

## 6. 对应详细报告

- [RB](../doc-rb/xx_lsu_rb_risk_review.md)
- [WB](../doc-wb/xx_lsu_ld_wb_risk_review.md)
- [DC](../doc-dc/xx_lsu_ld_dc_risk_review.md)
- [LQ](../doc-lq/xx_lsu_lq_risk_review.md)
- [LRQ](../doc-lrq/xx_lsu_lrq_risk_review.md)
- [CTRL](../doc-ctrl/xx_lsu_ctrl_integration_risk_review.md)
- [LD-DA](../doc_da/xx_lsu_ld_da_risk_review.md)
