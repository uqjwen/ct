# `xx_lsu_ld_ag` 设计风险与例化连线审查

## 1. 审查范围与结论

初版审查基于仓库提交 `ec421e9`，interaction 1.1/1.1.1/1.1.2 复核分别基于 `8f770ac`/`6700d48`/`218df2d`；本轮根据 interaction 1.1.3 的 replay 澄清，在提交 `9928a13` 上继续复核。除重新检查 MMU→LRQ 所有权外，本轮还把 replay 元数据追到 DC、DA、WB、RTU/SFP 输出和最终数据旋转消费者：

- `srcs/xx_lsu_ld_ag.sv`
- `srcs/xx_lsu_lrq.sv`
- `srcs/xx_lsu_lrq_entry.sv`
- `srcs/xx_lsu_top.sv`
- `srcs/xx_lsu_ld_dc.sv`
- `srcs/xx_lsu_ld_da.sv`
- `srcs/xx_lsu_ld_wb.sv`
- `srcs/xx_lsu_ctrl.sv`
- 基线文件 `srcs/ct_lsu_ld_ag.v`

结论如下：

1. RR-13 已由新 `create_frz` 方程修复：在 `stall && older` 时，只有 `pa_vld || abort` 才创建为 ready；真正的 accepted miss（`!pa_vld && !abort`）保持 frozen。16 组二态输入穷举与所有权期望完全一致。
2. RR-12 的“未匹配时保留旧值”已由 `bytes_vld1` 的显式 default 修复。对 selector 的 `{0,1,X}` 27 组穷举表明：19 个含 X 组合中，16 个输出 X，`00X/1X0/1X1` 因 `casez ?` 仍输出确定值；若 interaction 1.1.1 的“case 出现 X 就传播”是字面上的 any-X 政策，修改尚未完全满足。
3. RR-14/RR-16 按 interaction 1.1.2 的外部合同关闭：`mmu_lsu_imme_wakeup` 永久 tie 0，合法唤醒只有 async bitmap；full/partial flush 会在 LRQ bit 可复用前直接删除匹配 MMU pending。由于 MMU 源码未提供，这两项仍需 integration assertion，而不是由当前仓库 RTL 自证。
4. RR-02 按 interaction 1.1.3 进一步收窄为条件关闭：新的 SFP/IDU 标签合同使 replay 后 AG 内的旧 `no_spec` 分类无功能意义；当前活动 RVV1.0 路径又由 helper 使用已保存的 `split_num/vmew` 重建 `element_cnt/rot_sel`。不过仓库缺少 SFP/IDU 与两个 vector helper 的定义，且旧 `no_spec` X 仍可到达 DA、SFP/RTU 接口，因此关闭依赖 integration assertion，不是当前源码自证。
5. RR-03 仍开放，且设计方已确认 `halt_info` 应保留；RR-12 的 literal any-X 政策也仍待确认。本轮没有新增独立 P1 风险编号。lane0 修复可由现有源码证明；lane2/lane3 AG/DC wrapper 源码缺失，必须在完整工程确认同一方程和合同。对当前提供的七个主要模块做 named-port 集合复查，仍未发现漏接、多接或重复端口。

优先级定义：

- **P1**：可能导致错误执行、异常丢失、事务永久等待或关键预测状态破坏，流片前必须关闭。
- **P2**：特定功能、调试、非默认参数或低概率并发条件下错误，应在完整回归前关闭。
- **P3**：当前默认路径未必出错，但存在死代码、X 扩散或可维护性问题。

置信度定义：

- **已确认**：仅由当前 RTL 即可证明数据被丢失、取错事务或在有效路径上传播 `X`。
- **高置信**：问题机制明确，但最终架构影响还依赖后级或缺失 helper 模块。
- **合同依赖**：只有在某种合法上游时序下触发；必须先确认接口合同。

## 2. 风险汇总

| ID | 优先级 | 置信度 | 当前状态 | 风险摘要 |
|---|---:|---|---|---|
| RR-01 | P3 | 已给定合同 | 功能关闭/接口清理 | `no_spec_exist` 在 LSU 内有意改义；旧 predictor 输入和注释成为遗留接口 |
| RR-02 | — | 已给定合同 | 条件关闭/死路径约束 | SFP/IDU 负责新 no-spec 标签；活动 vector helper 只需已保存的 `split_num/vmew`，但缺失模块仍需集成断言 |
| RR-03 | P2 | 已确认/设计方认可 | 开放，等待修改 | replay 的调试 `halt_info` 取自当前 IDU 指令，而不是被 replay 的指令 |
| RR-04 | — | 已给定合同 | 条件关闭 | 目标集成规定 `mmu_lsu_stall==0`；top 仍暴露输入，需 integration assertion |
| RR-05 | — | 已给定合同 | 已关闭 | AF 在请求下一拍返回，此时 `lag_bkcon_stall_already==1`，现有捕获对拍 |
| RR-06 | — | RTL+合同 | 已关闭 | stall tie-off 排除 not-ready；controller 使用 abort-aware 判定，fresh 首拍所有权已由 RR-13 修复 |
| RR-07 | — | 已给定合同 | 已关闭 | 合法接口保证 `page_fault -> pa_vld` 且同拍 |
| RR-08 | — | 已给定合同 | 已关闭 | flush 同拍时上游 LSIQ 也被 flush，且 flush 优先于 raw pop |
| RR-09 | P3 | 已解释 | 功能关闭/清理项 | replay 状态已迁入 LRQ；九个 top 输入为过时接口 |
| RR-10 | P3 | 已给定配置 | 功能关闭/约束项 | 仅支持固定参数组合；RTL 尚缺静态 elaboration 限制 |
| RR-11 | — | 已给定合同 | 已关闭 | 投机 D-cache 读无副作用，miss/fault/CA=0 的读出结果不会被消费 |
| RR-12 | P3 | RTL+穷举 | 主问题已修复/政策待确认 | 新 default 消除旧值保留；`00X/1X0/1X1` 仍被 `?` 屏蔽，literal any-X 政策尚未满足 |
| RR-13 | — | RTL+穷举 | 已修复 | accepted miss 现在保持 frozen；只有未被 MMU pending 持有的覆盖场景才创建为 ready |
| RR-14 | — | 已给定合同 | 条件关闭 | full/partial flush 在 bit 复用前删除对应 MMU pending，旧 async wake 不再合法 |
| RR-15 | P3 | 已给定配置 | 功能关闭/功耗取舍 | `pfu_part_empty=0` 永久开 special clock；当前无功能缺口，但失去门控收益 |
| RR-16 | — | 已给定合同 | 条件关闭/死逻辑清理 | MMU 永久 tie 低 immediate wake，合法唤醒只走 async bitmap；DC immediate 路径不可达 |

### 2.1 interaction 1.1.1 澄清逐项处置（历史基线）

| README 项 | 对应项 | 处置 | RTL/合同结论 |
|---:|---|---|---|
| 1 | RR-08 | 关闭 | 接受“上游 LSIQ 同时 flush，且 flush 优先于 pop”的合同；raw pop 与 allocation 虽不一致，但不再产生存活事务丢失。 |
| 2 | RR-11 | 关闭 | 接受“D-cache 读无副作用，`!pa_vld`、fault、`CA=0` 的 data/tag 不会被使用”的合同。 |
| 3 | RR-12 | 保留并确认 | 目标是 X 传播；当前无 default `casez` 在未匹配时保留旧值，恰好不能实现该目标。 |
| 4 | RR-13 | **与 RTL 矛盾** | restart bitmap 与 MMU lsid 是两条独立路径；`stall_restart_entry=0` 不能推出 MMU 不记录 lsid。 |
| 5 | RR-14/RR-16 | 部分关闭并新增风险 | 一拍延迟关闭 create/wakeup 同拍；但实际延迟路径会被 DC valid 门控，形成 RR-16。 |
| 6 | §4.2 SQ 唤醒 | 关闭 | lane2 信号是共享语义，应同时唤醒 lane2/lane3；建议仅改为 lane-neutral 命名。 |
| 7 | MMU accept/RR-13 | 合同确认 | `mmu_accept = lsu_mmu_va_vld && !lsu_mmu_abort`，当拍记录、下一拍生效；该合同强化 RR-13 反例。 |
| 8 | abort/RR-13/RR-14 | 合同确认 | abort 不能追溯取消已接受项；恢复所有权不能依赖后拍 abort。 |
| 9 | RR-13 | **与 RTL 矛盾** | 与第 4 项相同。 |
| 10 | RR-14 | 部分关闭 | 与第 5 项相同；只关闭最短延迟，不回答 flush 后旧 wakeup。 |
| 11 | RR-08 | 关闭 | 与第 1 项相同。 |
| 12 | 原 §5.6 replay metadata | **答非所问** | “同 RR-11”只解释 D-cache 读，不解释 `inst_ldr/no_spec/VL/vmask/halt_info` 的有效下游消费；RR-02/RR-03 保留。 |
| 13 | RR-01 | 功能关闭 | `no_spec_exist` 在 LSU 内有意改义；原 predictor 直通要求撤销，旧输入/注释列为清理项。 |
| 14 | RR-10 | 功能关闭 | 正式只支持 `LRQENTRY==LSIQENTRY`、`PC_LEN=15`、`VMBENTRY=8`、9-bit split；保留静态限制建议。 |
| 15 | D-cache accept | 关闭疑问 | `dcache_arb_lag_ex1_sel` 同时表示选择与接受。 |
| 16 | RR-15 | 功能关闭 | `pfu_part_empty` 永久 tie 0 是有意放松钟控；当前功能安全，代价是 special clock 常开。 |

### 2.2 interaction 1.1.2 澄清逐项处置（当前结论）

本表覆盖并取代 2.1 中与 RR-12/RR-13/RR-14/RR-16 及 replay metadata 有关的旧处置。

| README 项 | 对应项 | 当前处置 | RTL/合同结论 |
|---:|---|---|---|
| 1 | RR-13 | **RTL 已修复** | 新方程与 `mmu_owns = !pa_vld && !abort` 等价；accepted miss 创建为 `frz=1`，hit/abort 覆盖场景才为 `frz=0`。 |
| 2 | RR-14 | **合同关闭** | 结合第 3/6 项：无 immediate wake，且 flush 删除 MMU pending 后才允许 LRQ bit 复用，旧 async wake 不再属于合法时序。 |
| 3 | RR-16 | **合同关闭** | `mmu_lsu_imme_wakeup==0` 使原触发条件不可达；保留 tie-off assertion，并把 DC immediate 链列为死逻辑。 |
| 4 | 原问题 5.1/RR-13 | **已澄清** | `lsu_mmu_lsid0` 与 restart bitmap 确为不同路径；修复点改在 `create_frz`，不再依赖错误的等同关系。 |
| 5 | 原问题 5.2/RR-16 | **合同确认** | 与第 3 项相同；目标回归不得再激励 immediate wake，负向注入只用于验证 tie-off assertion。 |
| 6 | 原问题 5.3/RR-14 | **合同确认** | 接受“full/partial flush 直接删除匹配 pending”的外部合同；必须验证 flush kill 优先于 async wake 与 bit 复用。 |
| 7 | 原问题 5.4/RR-02/RR-03 | **部分接受** | saved VA/boundary/byte masks 关闭部分旧疑问；`halt_info` 确需保存。`no_spec` 及 vector `element_cnt/rot_sel` 仍有可见路径，不能整体关闭 RR-02。 |
| 8 | 原问题 5.5/RR-12 | **主问题已修复/范围待确认** | 新 default 消除了未匹配时保留旧值；但 `casez ?` 仍令 `00X/1X0/1X1` 输出确定值。若原“case 出现 X”是 literal any-X 要求，需再加 `$isunknown` 前置判断。 |

### 2.3 interaction 1.1.3 澄清逐项处置（本轮结论）

本表覆盖并取代 2.2 中 RR-02 的旧处置。

| README 澄清 | 对应项 | 当前处置 | RTL/合同结论 |
|---|---|---|---|
| replay 后 `no_spec` 在 AG 无意义，标签改由 SFP 维护并供 IDU 使用 | RR-02/no-spec | **合同关闭** | 接受新的系统级所有权合同。当前 RTL 的 replay `2'bxx` 仍经 AG/DC/DA 到达 SFP 与 RTU 输出，因此完整集成必须证明 replay completion 不消费这组旧反馈，或把死路径改为确定值。 |
| `element_cnt` 只基于 `split_cnt/vmew`，两者 replay 均保存 | RR-02/vector | **合同关闭** | 活动 RVV1.0 路径确实把 `ld_ag_split_cnt`、`lag_ldc_ex1_vmew`送入 `xx_lsu_vmask_gen`，LRQ entry 也保存并恢复 9-bit split 和 2-bit vmew。helper 源码未提供，仍需等价断言。 |
| `rot_sel` 可由已保存字段重建 | RR-02/vector | **合同关闭并纠正文档链** | README 提到的 `lag_ldc_ex1_vsew` 链位于已注释的旧实现；活动实现由 `xx_lsu_ld_vreg_rot(split_cnt, vmew, element_cnt)` 产生 `reg_element_rot`。因此关闭依据应写成活动 helper 链，而不是已停用的 vsew 链。 |

## 3. 详细问题

### RR-01：`no_spec_exist` 有意改义，原功能风险关闭

interaction 1.1.1 明确：`no_spec_exist` 进入 LSU 后不再保留 IDU predictor 语义，而是承载 LRQ 内部 no-spec wait 历史。因此以下 RTL 事实现在属于约定行为，而不是功能错误：

- fresh-IDU 分支把旧输入清 0：`srcs/xx_lsu_lrq.sv:1794`、`srcs/xx_lsu_lrq.sv:1866`、`srcs/xx_lsu_lrq.sv:1951`；
- LRQ entry 从 `lrq_create_no_spec_chk` 建立内部 `no_spec_exist/no_spec_chk` 状态：`srcs/xx_lsu_lrq_entry.sv:721-740`、`srcs/xx_lsu_lrq_entry.sv:871`。

原“必须直通 predictor `no_spec_exist`”要求撤销。仍建议删除或标记 deprecated 的三路旧 top/LRQ 输入，并更新保留旧直通写法的注释，防止集成方继续按旧语义驱动。与此独立，replay 的 2-bit `no_spec` 仍直接为 `2'bxx` 且被 DA 消费；interaction 1.1.3 已在 RR-02 中用新的 SFP/IDU 所有权合同将其条件关闭。

### RR-02：interaction 1.1.3 将剩余 replay 字段按系统合同关闭

interaction 1.1.2 第 7 项已关闭 saved VA、boundary 和 byte/reg-byte mask；interaction 1.1.3 又明确了剩余两类字段的系统合同：

- LRQ entry 保存最终 VA、boundary、四组 byte mask 和四组 reg-byte mask，见 `srcs/xx_lsu_lrq_entry.sv:419-422`、`srcs/xx_lsu_lrq_entry.sv:469-480`、`srcs/xx_lsu_lrq_entry.sv:872-883`；replay mux 与 AG 又显式选择这些值，见 `srcs/xx_lsu_lrq.sv:1771-1780`、`srcs/xx_lsu_ld_ag.sv:1226-1235`、`srcs/xx_lsu_ld_ag.sv:1449-1471`、`srcs/xx_lsu_ld_ag.sv:2137-2177`、`srcs/xx_lsu_ld_ag.sv:2396-2408`。
- replay 的 `inst_ldr=1'bx` 虽进入 `ld_ag_boundary_stall`，但真正产生二次访问 stall 的方程含 `!lag_lrq_replay_vld`，见 `srcs/xx_lsu_ld_ag.sv:2745-2756`；replay VA 又由外层 mux 直接选 saved VA。因此原“replay LDR 因 `inst_ldr=X` 错误多/少做一拍”的子结论撤销。

当前源码仍保留两条需要由合同约束的可见路径：

1. **2-bit `no_spec` 仍为 X，但所有权已迁出 replay LSU。** LRQ replay 仍输出 `2'bxx`（`srcs/xx_lsu_lrq.sv:1792`），AG/DC 依次锁存（`srcs/xx_lsu_ld_ag.sv:1201`、`srcs/xx_lsu_ld_dc.sv:1386`），DA 又生成 no-spec 分类（`srcs/xx_lsu_ld_da.sv:5318-5372`），WB 最终输出到 RTU（`srcs/xx_lsu_ld_wb.sv:997-1000`、`srcs/xx_lsu_ld_wb.sv:1593-1596`）。interaction 1.1.3 明确新标签由 SFP 维护并由 IDU 读取，因此这些 replay 反馈属于遗留死路径；完整工程必须断言 replay completion 时其消费者忽略这些值，或直接将死路径确定化。
2. **vector 派生值由已保存字段重建。** 活动 RVV1.0 逻辑把 `ld_ag_split_cnt` 和 `lag_ldc_ex1_vmew`送入 `xx_lsu_vmask_gen` 产生 `ag_vmsk_elemnt_cnt`（`srcs/xx_lsu_ld_ag.sv:1692-1756`），再由 `xx_lsu_ld_vreg_rot` 使用 `split_cnt/vmew/element_cnt` 产生 `reg_element_rot`（`srcs/xx_lsu_ld_ag.sv:2250-2260`）。LRQ entry 明确保存这两个字段（`srcs/xx_lsu_lrq_entry.sv:435`、`srcs/xx_lsu_lrq_entry.sv:443`、`srcs/xx_lsu_lrq_entry.sv:901`、`srcs/xx_lsu_lrq_entry.sv:911`），replay mux 明确恢复（`srcs/xx_lsu_lrq.sv:1805`、`srcs/xx_lsu_lrq.sv:1822`）。README 所述 `vsew` 链只存在于 `/* ... */` 包围的旧实现，不能作为当前 RTL 的证明依据。

仓库没有提供 SFP/IDU 与上述 vector helper 的定义，因此当前仓库不能独立完成系统级证明。基于 interaction 1.1.3 的明确合同，RR-02 改为**条件关闭**；若完整工程无法证明“replay no-spec 旧反馈不被消费”以及“相同 `split_num/vmew` 必然重建相同 `element_cnt/rot_sel`”，本项自动重新开放为 P1。

**必须保留的集成检查**

- replay completion 的旧 no-spec SFP/RTU 反馈不得更新当前标签、预测状态或触发 flush；
- 对同一 vector transaction，create 与 replay 的 `split_num/vmew` 相同必须推出 `element_cnt/rot_sel` 相同且二态。

**清理建议**

- 把 replay `no_spec` 从 `2'bxx` 改成确定的无效编码，或在 DA/WB 显式按 replay 屏蔽，减少无意义 X 扩散。
- 对 saved VA/byte mask 和 vector helper 输出建立 create-vs-replay scoreboard；在完整工程绑定 SFP/IDU 所有权断言。
- 更新 README 中的 `vsew` 旧链描述，使其与活动的 `split_num/vmew -> helper -> element_cnt/rot_sel` 实现一致。

### RR-03：设计方确认需保留 `halt_info`，当前 RTL 仍取错事务

**证据**

interaction 1.1.2 第 7 项明确认可 `halt_info` 应保留；本提交尚未修改对应 LRQ payload 或 mux，因此该认可不等于风险已关闭。

- AG 的普通 RF 数据来自 LRQ/IDU mux，但 `idu_lsu_rf_halt_info` 在 top 中直接连接当前 IDU 总线 `idu_lsu_ld0_rf_halt_info`：`srcs/xx_lsu_top.sv:5392-5395`。
- LRQ 和 LRQ entry 没有保存 `halt_info`。
- replay 周期 `ld_rf_inst_vld` 有效时，AG 仍会锁存该原始 IDU 总线：`srcs/xx_lsu_ld_ag.sv:3102-3108`，并产生 DTU 请求：`srcs/xx_lsu_ld_ag.sv:3127-3135`。
- DC 会在有效调试请求时继续锁存：`srcs/xx_lsu_ld_dc.sv:2251-2259`。

**触发方式**

开启地址触发器，让 LRQ replay 与另一条 IDU 候选指令并存，或让 IDU bus 处于无效/旧值状态。

**影响**

被 replay 的 load 可能漏报断点、错误命中断点，或携带另一条指令的 halt 上下文。该问题主要影响 Debug 功能，所以定为 P2。

**建议**

把 `halt_info` 作为 LRQ metadata 保存和恢复，或为 replay 提供专用 mux；验证 replay 前后 trigger 命中结果必须等价。

### RR-04：`mmu_lsu_stall` 在目标集成中 tie 0，原风险条件关闭

RTL 事实仍与初版一致：`mmu_lsu_stall` 未经本端 valid 资格化就进入 `lag_ex1_stall_ori`，见 `srcs/xx_lsu_ld_ag.sv:2766`、`srcs/xx_lsu_ld_ag.sv:2800-2812`。但 README 已明确目标集成把该信号 tie 0，因此“空闲期制造幽灵 valid”的原触发条件不合法。

需要保留一个集成检查：当前提供的 top 仍把 lane0 `mmu_lsu_stall` 作为输入并接到 AG，而不是在本仓库内 tie 0，见 `srcs/xx_lsu_top.sv:421-424`、`srcs/xx_lsu_top.sv:5369`。因此本项按目标合同条件关闭，但必须在 SoC top 或 bind 中断言 `mmu_lsu_stall==0`；若未来解除 tie-off，原 P1 风险自动重新开放。

### RR-05：下一拍 access fault 与现有捕获逻辑对齐，已关闭

`lag_bkcon_stall_already` 在请求遇到 backpressure 的首拍边沿置 1：`srcs/xx_lsu_ld_ag.sv:1352-1358`。新合同规定 access fault 在 MMU 请求发起后的下一拍返回，因此响应出现时旧值 `lag_bkcon_stall_already==1`，`lag_bkcon_acfault` 和组合 `lag_mmu_acfault` 均可看到该 fault：`srcs/xx_lsu_ld_ag.sv:1361-1370`。

故初版假设的“请求同拍只脉冲一次 AF”不是合法接口时序，本项关闭。验证仍应把“一拍后返回”固化成断言，并覆盖 backpressure 持续 1/N 拍，防止以后 MMU 延迟合同改变而没有同步修改 AG。

### RR-06：原 not-ready 场景关闭，abort-aware controller 路径成立

新提供的 controller 使恢复链可以完整检查：

1. 目标集成规定 `mmu_lsu_stall==0`，因此“不接受请求却把 `!pa_vld` 记为 miss”的原场景被排除。
2. AG 使用 `lag_stall_ori_tlbmiss_not_abort = !cross_page && !pa_vld && !abort` 判断 MMU 是否真正拥有后续唤醒责任：`srcs/xx_lsu_ld_ag.sv:2847-2849`。
3. 对 replay 或已经创建过 LRQ entry 的请求，只有 `!lag_stall_ori_tlbmiss_not_abort` 才产生 restart bitmap：`srcs/xx_lsu_ld_ag.sv:2851-2855`。
4. controller 再以“更老 RF 有效且 AG 原始 stall”资格化立即唤醒：`srcs/xx_lsu_ctrl.sv:849-853`，并与 `mmu_lsu_async_wakeup0` 合并：`srcs/xx_lsu_ctrl.sv:949-958`；top 把结果回接到 LRQ freeze-clear：`srcs/xx_lsu_top.sv:12405`。

这与 README 描述一致：已接受 miss 由 MMU 唤醒；abort 或其他非 miss stall 不会等待一个 MMU 从未登记的请求，而由 controller 立即重发。原 RR-06 关闭。fresh 请求首次创建时虽不进入上述 restart bitmap，但 interaction 1.1.2 已通过修正 `create_frz` 方程补齐该所有权场景，见 RR-13。

### RR-07：`page_fault -> pa_vld` 同拍合同成立，已关闭

backpressure 捕获和直接异常输出都以 `mmu_lsu_page_fault && mmu_lsu_pa_vld` 为条件：`srcs/xx_lsu_ld_ag.sv:1371-1378`、`srcs/xx_lsu_ld_ag.sv:2678-2680`。README 明确 `page_fault=1` 时 `pa_vld=1` 且同拍，因此合法响应不会被遗漏；捕获后的 `lag_bkcon_pgfault` 又进入 `lsu_mmu_abort`，避免停顿期间再次访问 MMU：`srcs/xx_lsu_ld_ag.sv:2440-2442`。

本项关闭，并应以 `mmu_lsu_page_fault |-> mmu_lsu_pa_vld` 的接口断言保护。

### RR-08：flush 优先合同关闭 raw pop 不一致的功能风险

RTL 仍然存在可见的不对称：LRQ allocation 使用带 full/partial-flush kill 的 `lrq0_create_success`（`srcs/xx_lsu_lrq.sv:1448-1452`），IDU pop 却直接使用 raw `lsu0_lrq_create_vld`（`srcs/xx_lsu_lrq.sv:1692-1693`）。容量侧则由每 lane 独立 free pointer、`lrq*_no_space` 与 issue gating 保证 fresh 请求进入前已有空间：`srcs/xx_lsu_lrq.sv:1411-1470`、`srcs/xx_lsu_lrq.sv:1628-1683`。

interaction 1.1.1 明确给出缺失合同：create 与 flush 同拍时，上游 LSIQ 项也被 flush，且 flush 优先级高于 pop。因此 allocation 被 kill、raw pop 仍拉高不会删除任何应继续存活的事务，RR-08 按目标集成功能关闭。

为减少接口误用，仍建议把 allocation/pop/`create_already` 收敛到统一 `create_accept`，或至少用跨模块断言固化“`flush && pop` 时上游必须忽略 pop”。该建议属于接口清晰度与回归保护，不再作为开放设计 bug。

### RR-09：replay 状态已迁入 LRQ，旧 top 输入应清理

**证据**

top 声明了三路 `already_da/spec_fail/unal2nd` 输入：

- lane0：`srcs/xx_lsu_top.sv:129`、`srcs/xx_lsu_top.sv:156`、`srcs/xx_lsu_top.sv:163`
- lane2：`srcs/xx_lsu_top.sv:175`、`srcs/xx_lsu_top.sv:202`、`srcs/xx_lsu_top.sv:209`
- lane3：`srcs/xx_lsu_top.sv:235`、`srcs/xx_lsu_top.sv:262`、`srcs/xx_lsu_top.sv:269`

这些名称在 top 中只有声明，没有实例连接；LRQ 也没有对应 IDU 输入端口。fresh-IDU mux 对应字段全部置 0，pipe0 见 `srcs/xx_lsu_lrq.sv:1781`、`srcs/xx_lsu_lrq.sv:1803`、`srcs/xx_lsu_lrq.sv:1812`，pipe2/3 同样处理。

pipe0 输出进入 AG：`srcs/xx_lsu_top.sv:5164`、`srcs/xx_lsu_top.sv:5189`、`srcs/xx_lsu_top.sv:5196`，并在 `srcs/xx_lsu_ld_ag.sv:1187-1189` 锁存。`spec_fail` 会在 DC 参与判断：`srcs/xx_lsu_ld_dc.sv:1784-1786`。

**复核结论**

README 已说明 replay 责任从 IDU 迁入 LRQ，这三组状态现在由 LRQ entry 保存和输出，例如 `already_da/spec_fail/unal2nd` 在 `srcs/xx_lsu_lrq_entry.sv:780-807` 内维护。由此，fresh mux 置 0 是新架构的预期行为，原功能风险关闭。

但 top 仍保留九个不再消费的输入，声明位置如上，容易让集成方误以为它们仍有功能。建议删除这些死端口，或至少在接口说明中标记 deprecated；本项降为 P3 清理项。

### RR-10：固定支持配置关闭当前功能风险，保留静态限制

| 路径 | AG 宽度 | LRQ/top 宽度 | 风险 |
|---|---|---|---|
| `lch_entry` | `LSIQENTRY`，`srcs/xx_lsu_ld_ag.sv:388` | `LRQENTRY`，`srcs/xx_lsu_top.sv:3896` | `LRQENTRY > LSIQENTRY` 时高位 LRQ ID 被截断 |
| `lrqid` | `LSIQENTRY`，`srcs/xx_lsu_ld_ag.sv:429` | `LRQENTRY`，`srcs/xx_lsu_top.sv:3937` | 高位 entry 无法正确标识 |
| `pop_entry` | `LSIQENTRY`，`srcs/xx_lsu_ld_ag.sv:599` | `LRQENTRY`，`srcs/xx_lsu_top.sv:3873` | pop bitmap 扩展/截断语义不明确 |
| PC | 参数 `PC_LEN`，`srcs/xx_lsu_ld_ag.sv:397` | top/LRQ 固定 15 bit，`srcs/xx_lsu_top.sv:3905`、`srcs/xx_lsu_lrq.sv:480` | `PC_LEN != 15` 时截断或扩展 |
| VMB ID | 参数 `VMBENTRY`，`srcs/xx_lsu_ld_ag.sv:417` | top/LRQ 固定 8 bit，`srcs/xx_lsu_top.sv:3925`、`srcs/xx_lsu_lrq.sv:500` | `VMBENTRY != 8` 时错误 |
| split number | 固定 9 bit，`srcs/xx_lsu_ld_ag.sv:405` | top 使用 ``SPILT_NUM_WIDTH``，`srcs/xx_lsu_top.sv:3913` | 宏不等于 9 时错误 |

top 把 `LRQENTRY` 和 `LSIQENTRY` 暴露成两个参数：`srcs/xx_lsu_top.sv:27`、`srcs/xx_lsu_top.sv:42`。interaction 1.1.1 已明确正式支持集合只有 `LRQENTRY==LSIQENTRY`、`PC_LEN=15`、`VMBENTRY=8`、9-bit split；在该集合内不存在宽度不匹配，RR-10 的当前功能风险关闭。

RTL 仍把不支持的值暴露成可配置参数且不会主动报错。建议在 elaboration 阶段用静态 assertion 明确限制上述关系，使误配置立即失败；该项降为 P3 配置健壮性问题。

### RR-11：D-cache 无副作用合同关闭投机读风险

`ag_dcache_arb_ld_req` 只检查 AG valid、TCM、内部 mask 和 dcache enable：`srcs/xx_lsu_ld_ag.sv:2549-2570`。代码中对 `mmu_lsu_pa_vld`、page cacheable 和异常的资格均被注释，`lag_mmu_acfault` 也因时序被从 mask 删除。

interaction 1.1.1 已确认这是继承自原 C910 的有意投机读取：D-cache 读本身无副作用；`!pa_vld` 表示 TLB miss 并由 LDC 重发；异常或 `CA=0` 时读出的 data/tag 不会被使用。结合 `dcache_arb_lag_ex1_sel` 同时表示选择与接受的合同，RR-11 功能关闭。

验证环境仍应把这些条件写成断言/scoreboard 检查，防止后续 D-cache 实现加入替换状态、prefetch 训练或其他读副作用后破坏该合同。

### RR-12：旧值保留已修复，literal any-X 政策仍需确认

interaction 1.1.2 在 `lag_ldc_ex1_bytes_vld1` 的 `casez` 末尾增加 `default: {16{1'bx}}`，见 `srcs/xx_lsu_ld_ag.sv:2158-2167`。这已经消除原 RR-12 的确定缺陷：任何未匹配组合都会显式赋 X，不再沿用上拍 procedural variable。

对 `{replay_vld, inst_vls, inst_us}` 的 `{0,1,X}` 共 27 组机械枚举得到：

- 8 个纯二值组合选择预期数据源；
- 19 个含 X 组合中，16 个未匹配并由 default 输出 X；
- `00X`、`1X0`、`1X1` 被 case item 的 `?` 匹配，分别输出 base、LRQ saved 和 unit-stride mask，而不是 X；
- 当前实现比严格 decision consensus 还更悲观：例如 `X11` 的两种二值细化都选择 unit-stride mask，但因首位 X 无法匹配仍输出 X。

因此可以确认“保留旧值”主问题已修复，也可以确认所有会改变数据源选择的 X 都会传播；但 interaction 1.1.1 的原话是“case 出现 X 时希望 X 传播”。若这句话按字面要求 selector 任一位为 X 都输出 X，当前修改仍漏掉上述 3 组。设计方应明确是 functional ambiguity 还是 literal any-X 政策；后者需在 `casez` 前显式检查 `$isunknown({replay_vld,inst_vls,inst_us})`。

与本修复无关，LRQ PA cache 仍处于半删除状态：`lsu_lrq_ex1_pa_set` 永久为 0（`srcs/xx_lsu_ld_ag.sv:2418-2421`），LRQ PA/属性读回也为 0（`srcs/xx_lsu_lrq_entry.sv:927-929`），但 AG 保留 bypass 分支（`srcs/xx_lsu_ld_ag.sv:2428-2467`）。当前配置不可达，只保留 P3 清理记录。

### RR-13：fresh accepted-miss 所有权分裂已由新方程修复

新 RTL 为：

```systemverilog
assign lsu_lrq_create_frz = !(lag_ex1_stall_ori
                           && ld_ag_stall_mask
                           && (mmu_lsu_pa_vld || lsu_mmu_abort));
```

源码见 `srcs/xx_lsu_ld_ag.sv:3031-3036`。在正式二态合同下可化简为：

```text
create_frz = !(stall_ori && older) || (!pa_vld && !abort)
           = no_override || mmu_owns_miss
```

16 组 `{stall_ori, older, pa_vld, abort}` 穷举全部符合该所有权目标；关键三行如下：

| `stall && older` | `pa_vld` | `abort` | MMU pending | 新 `create_frz` | 结论 |
|---:|---:|---:|---:|---:|---|
| 1 | 0 | 0 | 1 | 1 | accepted miss 保持 frozen，等待 async wake |
| 1 | 1 | 0 | 0 | 0 | translation 已完成，可由 ready LRQ 重发 D-cache stall |
| 1 | 0/1 | 1 | 0 | 0 | 请求未被 MMU 记录，可本地重发 |

MMU lsid 路径仍按 `lsu_mmu_va_vld && !lsu_mmu_abort` 接收 free pointer（`srcs/xx_lsu_ld_ag.sv:2857-2861`、`srcs/xx_lsu_top.sv:3774`），但该事实现在与 LRQ frozen 状态一致，不再形成双 owner。LRQ entry 的 create/ready 方程位于 `srcs/xx_lsu_lrq_entry.sv:817-822`、`srcs/xx_lsu_lrq_entry.sv:853-859`。

RR-13 对 lane0 关闭。仍需断言 create 有效时 `pa_vld/abort` 不含 X，并在完整工程确认 lane2/lane3 wrapper 使用同一修复；本仓库没有提供其 AG 实现。

### RR-14：flush 删除 MMU pending 合同关闭旧 async wake 复用风险

controller 仍把 `mmu_lsu_async_wakeup0/2/3` 直接 OR 到各 lane wakeup（`srcs/xx_lsu_ctrl.sv:949-988`），top 再把 bitmap 原样送入 LRQ freeze-clear（`srcs/xx_lsu_top.sv:12405`、`srcs/xx_lsu_top.sv:12425`、`srcs/xx_lsu_top.sv:12445`）；bitmap 本身没有 IID/generation。

interaction 1.1.2 第 6 项补充了足以关闭原反例的外部合同：full/partial flush 会直接删除匹配 MMU pending。结合 immediate wake tie 0 和 create/wakeup 不同拍，旧事务在 LRQ bit 可复用前已失去产生 async wake 的资格，因此不再需要 LSU 侧 generation 才能保证当前目标集成正确。

RR-14 按合同关闭，但该结论必须由集成断言保护：

- flush-killed pending 不得在之后产生 async wake；
- partial flush 只删除被 kill 的 IID/lsid，保留项仍必须最终 wake；
- 同拍 flush、async wake 与新 create 时，flush cancellation 必须先于 bit 复用生效。

若 MMU 的“直接刷掉”仅清 queue valid、但输出端仍可能保留已形成的 wake pulse，本项立即重新开放。

### RR-15：special clock 永久常开是已确认的功耗取舍

controller 的 `lsu_special_clk_en` 包含 `!pfu_part_empty`：`srcs/xx_lsu_ctrl.sv:539-556`；top 固定 `pfu_part_empty=1'b0`：`srcs/xx_lsu_top.sv:3761`。因此 local enable 恒为 1，`lsu_special_clk` 永远打开。

该常开还掩盖了 controller 中的可疑漏项：表达式末尾两次使用 `idu_lsu_vmb_create0_gateclk_en`，完全没有使用 `idu_lsu_vmb_create1_gateclk_en`；`icc_vb_create_gateclk_en`、`lsda0_ex3_special_gateclk_en`、`lsda1_ex3_special_gateclk_en` 也只声明/连入而未消费，见 `srcs/xx_lsu_ctrl.sv:36`、`srcs/xx_lsu_ctrl.sv:50-51`、`srcs/xx_lsu_ctrl.sv:287`、`srcs/xx_lsu_ctrl.sv:303`。

interaction 1.1.1 明确该 tie-off 是永久的放松钟控，不会恢复真实 empty。因此缺失/重复 gate-enable 在支持配置下不会关钟，也不会造成当前功能错误；RR-15 的功能风险关闭。保留 P3 记录仅用于说明功耗代价、死输入和误导性表达式。若未来改变“永久 tie 0”合同，必须重新开放本项并先补齐全部启动事件。

### RR-16：MMU immediate wake 永久 tie 低，原触发条件不可达

interaction 1.1.2 第 3/5 项明确：MMU 侧永久保证 `mmu_lsu_imme_wakeup==0`，MMU→LSU 唤醒只使用 `mmu_lsu_async_wakeup`。因此原“结构反压令 `ldc_ex2_inst_vld=0`，从而吃掉 immediate wake”的反例不属于合法目标配置，RR-16 条件关闭。

仓库内仍保留整条 immediate 路径：top 输入位于 `srcs/xx_lsu_top.sv:431-433`，DC 锁存并以 `ldc_ex2_inst_vld` 门控（`srcs/xx_lsu_ld_dc.sv:1365`、`srcs/xx_lsu_ld_dc.sv:1381`、`srcs/xx_lsu_ld_dc.sv:2213-2218`）。这些逻辑在支持配置下是死路径，不再要求功能修复；应在 SoC 集成层断言三个 lane 的 immediate 输入恒 0，并可后续删除死端口/逻辑以免未来误用。若任何 MMU 版本解除 tie-off，原 RR-16 自动重新开放。

## 4. 模块例化与连线检查

### 4.1 named-port 集合检查

对 top 中完整实例进行静态解析，结果如下：

| 模块 | formal 数 | 实例连接数 | 缺失 | 未知 | 重复 named port |
|---|---:|---:|---:|---:|---:|
| `xx_lsu_ctrl` | 339 | 339 | 0 | 0 | 0 |
| `xx_lsu_ld_ag` | 258 | 258 | 0 | 0 | 0 |
| `xx_lsu_ld_dc` | 279 | 279 | 0 | 0 | 0 |
| `xx_lsu_ld_da` | 367 | 367 | 0 | 0 | 0 |
| `xx_lsu_lrq` | 608 | 608 | 0 | 0 | 0 |
| `xx_lsu_lq` | 99 | 99 | 0 | 0 | 0 |
| `xx_lsu_rb` | 396 | 396 | 0 | 0 | 0 |

RR-10 所列 AG↔LRQ 路径在正式支持的固定参数关系下数值对齐；不支持的参数值会暴露截断，但应由静态限制拒绝。由于宏定义和 helper 模块不完整，本次没有把静态端口集合检查等同于完整位宽 elaboration。

### 4.2 已确认/疑似语义连线问题

- **已给定合同/待清理**：RR-01 的 fresh `no_spec_exist` 输入被清零是有意改义；旧 predictor 输入与注释应清理。
- **条件关闭**：RR-02 的 saved VA/byte mask 已闭环；interaction 1.1.3 把 replay no-spec 所有权迁到 SFP/IDU，并确认 vector helper 只依赖已保存字段。缺失模块必须用集成断言补证。
- **已确认**：RR-03 的 replay `halt_info` 绕过 LRQ mux。
- **已解释/待清理**：RR-09 的九个 top 输入为 replay 迁移后的死接口，不再列为功能风险。
- **RTL 主问题已修复/政策待确认**：RR-12 新 default 不再保留旧值，但 literal any-X 仍漏 `00X/1X0/1X1`；RR-13 新 `create_frz` 方程让 MMU pending 与 LRQ ready 互斥。
- **合同关闭**：RR-14 依赖 full/partial flush 在 bit 复用前删除 MMU pending；需集成断言固化该顺序。
- **已给定配置**：RR-15 的 special clock 永久常开，当前没有功能缺口，只有功耗与死接口问题。
- **合同关闭/待清理**：RR-16 的 underlying DC 门控仍存在，但 immediate 输入永久 tie 0，合法唤醒只走 async。
- **已解释/命名待清理**：`srcs/xx_lsu_top.sv:4837` 把 `.lsu3_lrq_exx_sq_not_full` 接到 `lsu2_lrq_exx_sq_not_full`；README 已确认该状态对 lane2/lane3 是共享语义，不是功能笔误，但应改为 lane-neutral 名称并删除未用 lane3 别名。

### 4.3 静态检查边界

另有三项低风险的死接口/固定配置需要设计方确认：

- `cp0_lsu_nsfe` 已由 top 接入：`srcs/xx_lsu_top.sv:5143`，但 AG 内除端口声明 `srcs/xx_lsu_ld_ag.sv:357` 外没有使用；当前 no-spec 建项检查只能依赖上游已把相关 hit 信号关闭。
- `sfp_hit_no_spec_tbl` 在 top 被固定为 0：`srcs/xx_lsu_top.sv:5217`，AG 内除声明 `srcs/xx_lsu_ld_ag.sv:432` 外没有使用，属于残留接口。
- `cp0_lsu_cb_aclr_dis` 在 top 固定为 1：`srcs/xx_lsu_top.sv:5137`，因此 `srcs/xx_lsu_ld_ag.sv:2487-2494` 的 boundary acceleration 永久关闭。若这是当前产品配置，应以参数/注释明确；若仍计划启用，则是接线错误。

仓库已经提供 `xx_lsu_ctrl`，但仍没有以下 helper 的定义：`gated_clk_cell`、`xx_lsu_compare_iid`、`xx_lsu_vmask_gen`、`xx_lsu_us_bytes_gen`、`xx_lsu_vreg_mask`、`xx_lsu_ld_vreg_rot`，以及 top 中的其他部分模块。当前环境也没有完整宏/include 与工程 filelist。因此：

- 本报告完成的是源码级 named-port、宽度表达式和语义链检查；
- 不能把“named-port 集合一致”解释为完整 elaboration/compile 已通过；
- helper 模块端口宽度、宏展开值、clock-cell 版本和完整跨模块时序仍需在工程环境中编译确认。
- lane2/lane3 通过未提供定义的 AG/DC wrapper 产生 `lsu2/3_lrq_create_frz` 和相关 wakeup；本轮只能证明 lane0 的 RR-13 修复，完整工程必须确认另外两 lane 使用相同所有权方程，并同时断言三路 immediate 输入为 0。

## 5. 已确认合同与仍需回答的问题

已由 README 确认并应转成 assertion/配置检查的合同：

1. 目标集成中 `mmu_lsu_stall==0`。
2. access fault 在请求后一拍返回。
3. `mmu_lsu_page_fault |-> mmu_lsu_pa_vld`，且两者同拍。
4. fresh 请求进入 AG 前，LRQ `no_space` 已保证本 lane 有可创建 entry。
5. `already_da/spec_fail/unal2nd` 的 replay 状态由 LRQ 而非 IDU 提供。
6. create 与 flush 同拍时，上游 LSIQ 同时被 flush，且 flush 优先于 pop。
7. D-cache 读无副作用；TLB miss、fault、`CA=0` 的投机 data/tag 不被使用；`dcache_arb_lag_ex1_sel` 同时表示选择与接受。
8. `bytes_vld1` 未匹配 selector 必须输出 X，不得保留旧值；若正式政策是 selector 任一位含 X 都输出 X，还需覆盖 `00X/1X0/1X1`。
9. `mmu_accept = lsu_mmu_va_vld && !lsu_mmu_abort`，当拍记录、下一拍生效；只有 `!pa_vld && !abort` 形成 MMU pending，后续 abort 不可追溯取消。
10. `mmu_lsu_imme_wakeup==0` 永久成立，MMU 唤醒 LSU 只通过 async bitmap；create 与 MMU wakeup 不同拍。
11. full/partial flush 在 LRQ bit 可复用前直接删除匹配 MMU pending，且不得残留迟到 async pulse。
12. lane2 的 SQ-not-full bitmap 对 lane2/lane3 是共享语义。
13. `no_spec_exist` 进入 LSU 后有意改为内部语义。
14. 只支持 `LRQENTRY==LSIQENTRY`、`PC_LEN=15`、`VMBENTRY=8`、9-bit split。
15. `pfu_part_empty` 永久 tie 0，special clock 常开是有意的放松钟控。

仍需设计方回答或修正：

1. RR-02：请在完整工程给出 SFP/IDU assertion，证明 replay completion 的旧 DA/WB no-spec 反馈不会更新标签、预测状态或触发 flush；否则应在 LSU 内确定化或屏蔽该死路径。
2. RR-02：请提供 helper 等价检查，证明 create/replay 的相同 `split_num/vmew` 必然得到相同且二态的 `element_cnt/rot_sel`；README 的 `vsew` 旧链描述也应同步更正。
3. RR-03：已确认 `halt_info` 应保留，计划保存到 LRQ 的具体宽度、三 lane 一致性和 replay mux 修改是什么？
4. RR-13：lane2/lane3 wrapper 是否已同步采用 `!(stall && older && (pa_vld || abort))`，以及 create 有效时 `pa_vld/abort` 是否保证二态？
5. RR-12：“case 出现 X 时希望 X 传播”是指只传播会改变选择的数据不确定性，还是 selector 任一位为 X 都必须输出 X？后者要求继续修复 `00X/1X0/1X1`。
6. RR-14/RR-16：请在 MMU 集成层明确同拍 `flush + async wake + LRQ bit reuse` 的优先级，并提供三路 `imme_wakeup==0` 与“flushed pending 不再 wake”的断言。

## 6. 建议修复顺序

1. 先在完整工程补齐 RR-02 的 SFP/IDU 所有权与 vector helper 等价断言；随后按设计方确认补齐仍开放的 RR-03 `halt_info`。
2. 把 RR-12/RR-13 修复转成 truth-table/assertion 回归；明确 RR-12 是 functional-ambiguity 还是 literal any-X 政策，并确认 lane2/lane3 的 RR-13 方程一致。
3. 在 MMU 集成层固化 async-only、三路 immediate tie-off、flush-cancel-before-reuse 与 partial-flush 精确匹配合同。
4. 保留既有合同断言：flush>pop、D-cache 无副作用、固定参数、special clock 常开和 MMU accept/abort。
5. 清理 RR-01/RR-09、共享 SQ-not-full 命名、dead immediate/gate-enable 路径，并添加参数静态限制。
6. 在完整工程环境执行 elaboration、lint、X-prop、形式断言和端到端回归。

截至 Interaction 1.1.3 的该轮 AG 复核只形成审查文档，没有修改 AG RTL；Interaction 1.6 后续在 LRQ/DC 中加入了独立验证断言，但仍未改动 AG 功能数据通路。

## 7. Interaction 1.6：stall 期间继续 MMU 与 unit-stride 复核

本节覆盖并细化 RR-05/RR-07/RR-11 的时序解释。当前未发现新的功能 bug，结论依赖既有“D-cache 投机读无副作用、fault/miss 结果不消费”合同。

### 7.1 一拍 access-fault 的所有权分工

MMU `xx_mmu_dutlb_read` 在 PA/type 接受后用 `pmp_flg_vld` 将 PMP access-fault 延迟一拍。无 AG stall 时，请求同拍进入 DC，下一拍 fault 与 DC 中同一请求对齐，并在 DA 的 `ldc_ex2_inst_vld` 分支直接锁存 `mmu_lsu_access_fault0`；因此 AG 不需要捕获 `stall_already==0` 的 fault。

当 AG 因 D-cache/bkcon/US 停留时，首个 stall 边沿置 `lag_bkcon_stall_already`。下一拍 fault 由 `mmu_lsu_access_fault && lag_bkcon_stall_already` 组合进入 `lag_mmu_acfault`；若 stall 继续，则 `lag_bkcon_acfault` 保存。`lag_mmu_acfault` 进入 `lsu_mmu_abort` 和 `lag_ldc_ex1_expt_vld`，stall 解除后 DC 将其编码为 load/AMO access fault。两条路径分别覆盖“不 stall”和“已 stall”，没有发现漏采或跨事务错配。

### 7.2 TLB miss/page fault

stall 中 `!pa_vld` 保存为 `lag_bkcon_tlbmiss`；它进入 `ld_ag_stall_restart`，同时从 `lag_ex1_stall_ori` 排除，令 EX1 下一拍失效并等待 LRQ/MMU 重发。`page_fault && pa_vld` 保存为 `lag_bkcon_pgfault`；它 abort 后续 MMU request，但不把异常事务当 restart 丢弃，结构 stall 解除后通过 DC/DA 传播。

### 7.3 unit-stride 两拍

US0 以 `lag_us_tag_req_stall` 只请求 tag；arbiter 接受后置 success。US1 以 `lag_us_tag_req_success_flop/lag_us_tag_ack_stall` 锁存同步 tag 输出的 way；US2 才用保存 way 形成 512-bit data index。TLB miss 在 US1 使 EX1 失效；page/access fault被保存并在 US stall 退出后送异常，不消费 way/data。新 RF transaction 会清 success、success-flop 和 way，未发现跨事务串值。

### 7.4 保留验证义务

`lag_mmu_acfault` 没有进入 `ld_ag_data_req_mask`，故 fault 同拍仍可能发生 tag/data 读；这与既有低时序级数设计一致，只能在“D-cache 读无副作用且 exception valid 阻止消费”合同下关闭。完整回归必须负向证明：fault/miss/CA=0 的读出不创建 LQ/RB、不产生 WB data、不更新架构寄存器。
