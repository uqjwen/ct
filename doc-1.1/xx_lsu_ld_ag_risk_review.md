# `xx_lsu_ld_ag` 设计风险与例化连线审查

## 1. 审查范围与结论

初版审查基于仓库提交 `ec421e9`，interaction 1.1 复核基于 `8f770ac`；本轮根据 interaction 1.1.1 的 16 项澄清，在提交 `6700d48` 上继续复核。RTL 相对上一轮没有变化，本轮重点是把新增接口合同与实际 producer→top→consumer 方程逐项对照：

- `srcs/xx_lsu_ld_ag.sv`
- `srcs/xx_lsu_lrq.sv`
- `srcs/xx_lsu_lrq_entry.sv`
- `srcs/xx_lsu_top.sv`
- `srcs/xx_lsu_ld_dc.sv`
- `srcs/xx_lsu_ld_da.sv`
- `srcs/xx_lsu_ctrl.sv`
- 基线文件 `srcs/ct_lsu_ld_ag.v`

结论如下：

1. 新合同足以关闭 RR-08、RR-11、RR-01 的原 predictor 语义、RR-10 的支持配置功能风险、4.2 的 lane2/lane3 SQ 唤醒疑问，以及 RR-15 的当前功能风险；RR-14 的“create 与 wakeup 同拍”子场景也被一拍延迟合同关闭。
2. README 对 RR-13 的解释与当前 RTL 直接矛盾：`lag_ex1_stall_restart_entry=0` 只关闭 controller 的本地 wakeup，并不会清零独立的 `lag_ldc_ex1_lsid`。结合新给出的 MMU accept 条件，MMU 在 RR-13 触发拍会记录 fresh free pointer，而 LRQ entry 同时以 `frz=0` 创建，所有权分裂仍然成立。
3. RR-12 的设计目标已经明确为“让 X 传播”，但无 default 的 `casez` 在未匹配 X 输入下会保留旧值，并不会产生 X；RR-02/RR-03 的 replay metadata 问题也未被 D-cache 无副作用合同覆盖。
4. 本轮新增确认 RR-16：MMU `imme_wakeup` 虽在 DC 打一拍，却又被 `ldc_ex2_inst_vld` 门控。D-cache 结构反压使请求不进入 DC 时，该 valid 为 0，立即唤醒被丢弃；若 entry 以 `frz=1` 创建且 MMU 不再发 async wakeup，事务永久等待。
5. RR-14 仍保留 flush 后旧 async wakeup 命中复用 LRQ bit 的合同风险；当前 bitmap 无 IID、generation 或 flush epoch。对当前提供的七个主要模块做 named-port 集合复查，未发现漏接、多接或重复端口。

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
| RR-02 | P1 | 高置信 | 开放 | replay 时 `inst_ldr`、向量 VL/mask 等仍被使用的字段为 `X` |
| RR-03 | P2 | 已确认 | 开放 | replay 的调试 `halt_info` 取自当前 IDU 指令，而不是被 replay 的指令 |
| RR-04 | — | 已给定合同 | 条件关闭 | 目标集成规定 `mmu_lsu_stall==0`；top 仍暴露输入，需 integration assertion |
| RR-05 | — | 已给定合同 | 已关闭 | AF 在请求下一拍返回，此时 `lag_bkcon_stall_already==1`，现有捕获对拍 |
| RR-06 | — | RTL+合同 | 原场景关闭 | stall tie-off 排除 not-ready；controller 已使用 abort-aware 判定，fresh 首拍缺口另列 RR-13 |
| RR-07 | — | 已给定合同 | 已关闭 | 合法接口保证 `page_fault -> pa_vld` 且同拍 |
| RR-08 | — | 已给定合同 | 已关闭 | flush 同拍时上游 LSIQ 也被 flush，且 flush 优先于 raw pop |
| RR-09 | P3 | 已解释 | 功能关闭/清理项 | replay 状态已迁入 LRQ；九个 top 输入为过时接口 |
| RR-10 | P3 | 已给定配置 | 功能关闭/约束项 | 仅支持固定参数组合；RTL 尚缺静态 elaboration 限制 |
| RR-11 | — | 已给定合同 | 已关闭 | 投机 D-cache 读无副作用，miss/fault/CA=0 的读出结果不会被消费 |
| RR-12 | P3 | 已确认 | 开放 | 无 default 的 `casez` 在未匹配 X 输入下保留旧值，违反明确的 X-prop 目标 |
| RR-13 | P1 | 已确认/高置信影响 | 开放，澄清与 RTL 矛盾 | fresh accepted-miss 的 lsid 会被 MMU 记录，而 LRQ entry 同时以非 frozen 状态创建 |
| RR-14 | P1 | 合同依赖 | 缩小后开放 | 一拍最短延迟关闭同拍子场景；flush 后旧 async bitmap 仍可能命中复用 entry |
| RR-15 | P3 | 已给定配置 | 功能关闭/功耗取舍 | `pfu_part_empty=0` 永久开 special clock；当前无功能缺口，但失去门控收益 |
| RR-16 | P1 | 已确认/合同依赖影响 | 新发现 | 结构反压阻止请求进入 DC 时，打一拍的 MMU immediate wake 被 DC valid 门控丢失 |

### 2.1 interaction 1.1.1 澄清逐项处置

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

## 3. 详细问题

### RR-01：`no_spec_exist` 有意改义，原功能风险关闭

interaction 1.1.1 明确：`no_spec_exist` 进入 LSU 后不再保留 IDU predictor 语义，而是承载 LRQ 内部 no-spec wait 历史。因此以下 RTL 事实现在属于约定行为，而不是功能错误：

- fresh-IDU 分支把旧输入清 0：`srcs/xx_lsu_lrq.sv:1794`、`srcs/xx_lsu_lrq.sv:1866`、`srcs/xx_lsu_lrq.sv:1951`；
- LRQ entry 从 `lrq_create_no_spec_chk` 建立内部 `no_spec_exist/no_spec_chk` 状态：`srcs/xx_lsu_lrq_entry.sv:721-740`、`srcs/xx_lsu_lrq_entry.sv:871`。

原“必须直通 predictor `no_spec_exist`”要求撤销。仍建议删除或标记 deprecated 的三路旧 top/LRQ 输入，并更新保留旧直通写法的注释，防止集成方继续按旧语义驱动。与此独立，replay 的 2-bit `no_spec` 仍直接为 `2'bxx` 且被 DA 消费，该问题归入 RR-02，不能由本项的字段改义合同关闭。

### RR-02：replay payload 不完整，多个有效字段为 `X`

**证据**

pipe0 replay mux 对以下字段直接给 `X`：

- `inst_ldr`：`srcs/xx_lsu_lrq.sv:1786`
- `no_spec`：`srcs/xx_lsu_lrq.sv:1792`
- 两组 vector mask source：`srcs/xx_lsu_lrq.sv:1810-1811`
- `vl`：`srcs/xx_lsu_lrq.sv:1814`
- `vmask_vld`：`srcs/xx_lsu_lrq.sv:1818`

AG 在 replay 进入时仍锁存这些字段：`srcs/xx_lsu_ld_ag.sv:1198`、`srcs/xx_lsu_ld_ag.sv:1201`、`srcs/xx_lsu_ld_ag.sv:1205`、`srcs/xx_lsu_ld_ag.sv:1218-1219`。它们并非全部无用：

- `ld_ag_inst_ldr` 参与 boundary 二次访问 stall：`srcs/xx_lsu_ld_ag.sv:2744`。
- VL、vmask 和 mask source 进入 `xx_lsu_vmask_gen`：`srcs/xx_lsu_ld_ag.sv:1695-1708`，并进入 `xx_lsu_vreg_mask`：`srcs/xx_lsu_ld_ag.sv:2189-2202`。
- 生成结果继续影响 `element_cnt`、旋转和字节有效信息：`srcs/xx_lsu_ld_ag.sv:1692`、`srcs/xx_lsu_ld_ag.sv:2391-2407`。

README 第 12 项以“同 RR-11”回答原 §5.6，但 RR-11 的 D-cache 无副作用合同只覆盖错误 tag/data 读，不能覆盖上述 AG、mask generator、DA 和 Debug 消费。因此该回答与问题不匹配，RR-02 和 RR-03 均不关闭。

**触发方式**

- boundary LDR 发生 replay；或
- masked/indexed/unit-stride vector load 发生 replay，且后级仍需要重新计算 element count、rotation 或 byte mask。

**影响**

标量 LDR 可能错误多做/少做第二半访问；向量 replay 可能产生错误的元素计数、旋转或有效字节。仓库没有提供 `xx_lsu_vmask_gen`、`xx_lsu_vreg_mask`、`xx_lsu_us_bytes_gen` 的定义，因此无法证明每一种向量指令都必然出错，但在 valid payload 上输入 `X` 已是高风险设计。

**建议**

- 明确列出 replay 所需的最小 metadata，并全部存入 LRQ entry；或让 replay 路径只使用已保存的最终派生结果。
- 禁止对任何 valid-qualified 下游 payload 使用 `X`；用确定的安全值只能在形式证明“字段不可观察”后采用。
- 对 scalar、LDR、vector non-US、vector US 分别做 create/replay 全字段 scoreboard 比较和 X-prop 回归。

### RR-03：replay 的 debug `halt_info` 取错事务

**证据**

- AG 的普通 RF 数据来自 LRQ/IDU mux，但 `idu_lsu_rf_halt_info` 在 top 中直接连接当前 IDU 总线 `idu_lsu_ld0_rf_halt_info`：`srcs/xx_lsu_top.sv:5392-5395`。
- LRQ 和 LRQ entry 没有保存 `halt_info`。
- replay 周期 `ld_rf_inst_vld` 有效时，AG 仍会锁存该原始 IDU 总线：`srcs/xx_lsu_ld_ag.sv:3101-3107`，并产生 DTU 请求：`srcs/xx_lsu_ld_ag.sv:3126-3134`。
- DC 会在有效调试请求时继续锁存：`srcs/xx_lsu_ld_dc.sv:2251-2259`。

**触发方式**

开启地址触发器，让 LRQ replay 与另一条 IDU 候选指令并存，或让 IDU bus 处于无效/旧值状态。

**影响**

被 replay 的 load 可能漏报断点、错误命中断点，或携带另一条指令的 halt 上下文。该问题主要影响 Debug 功能，所以定为 P2。

**建议**

把 `halt_info` 作为 LRQ metadata 保存和恢复，或为 replay 提供专用 mux；验证 replay 前后 trigger 命中结果必须等价。

### RR-04：`mmu_lsu_stall` 在目标集成中 tie 0，原风险条件关闭

RTL 事实仍与初版一致：`mmu_lsu_stall` 未经本端 valid 资格化就进入 `lag_ex1_stall_ori`，见 `srcs/xx_lsu_ld_ag.sv:2765`、`srcs/xx_lsu_ld_ag.sv:2799-2811`。但 README 已明确目标集成把该信号 tie 0，因此“空闲期制造幽灵 valid”的原触发条件不合法。

需要保留一个集成检查：当前提供的 top 仍把 lane0 `mmu_lsu_stall` 作为输入并接到 AG，而不是在本仓库内 tie 0，见 `srcs/xx_lsu_top.sv:421-424`、`srcs/xx_lsu_top.sv:5369`。因此本项按目标合同条件关闭，但必须在 SoC top 或 bind 中断言 `mmu_lsu_stall==0`；若未来解除 tie-off，原 P1 风险自动重新开放。

### RR-05：下一拍 access fault 与现有捕获逻辑对齐，已关闭

`lag_bkcon_stall_already` 在请求遇到 backpressure 的首拍边沿置 1：`srcs/xx_lsu_ld_ag.sv:1352-1358`。新合同规定 access fault 在 MMU 请求发起后的下一拍返回，因此响应出现时旧值 `lag_bkcon_stall_already==1`，`lag_bkcon_acfault` 和组合 `lag_mmu_acfault` 均可看到该 fault：`srcs/xx_lsu_ld_ag.sv:1361-1370`。

故初版假设的“请求同拍只脉冲一次 AF”不是合法接口时序，本项关闭。验证仍应把“一拍后返回”固化成断言，并覆盖 backpressure 持续 1/N 拍，防止以后 MMU 延迟合同改变而没有同步修改 AG。

### RR-06：原 not-ready 场景关闭，abort-aware controller 路径成立

新提供的 controller 使恢复链可以完整检查：

1. 目标集成规定 `mmu_lsu_stall==0`，因此“不接受请求却把 `!pa_vld` 记为 miss”的原场景被排除。
2. AG 使用 `lag_stall_ori_tlbmiss_not_abort = !cross_page && !pa_vld && !abort` 判断 MMU 是否真正拥有后续唤醒责任：`srcs/xx_lsu_ld_ag.sv:2846-2848`。
3. 对 replay 或已经创建过 LRQ entry 的请求，只有 `!lag_stall_ori_tlbmiss_not_abort` 才产生 restart bitmap：`srcs/xx_lsu_ld_ag.sv:2850-2854`。
4. controller 再以“更老 RF 有效且 AG 原始 stall”资格化立即唤醒：`srcs/xx_lsu_ctrl.sv:849-853`，并与 `mmu_lsu_async_wakeup0` 合并：`srcs/xx_lsu_ctrl.sv:949-958`；top 把结果回接到 LRQ freeze-clear：`srcs/xx_lsu_top.sv:12405`。

这与 README 描述一致：已接受 miss 由 MMU 唤醒；abort 或其他非 miss stall 不会等待一个 MMU 从未登记的请求，而由 controller 立即重发。原 RR-06 关闭。fresh 请求首次创建时没有进入上述 restart bitmap 的情况不在该修复覆盖范围内，另见 RR-13。

### RR-07：`page_fault -> pa_vld` 同拍合同成立，已关闭

backpressure 捕获和直接异常输出都以 `mmu_lsu_page_fault && mmu_lsu_pa_vld` 为条件：`srcs/xx_lsu_ld_ag.sv:1371-1378`、`srcs/xx_lsu_ld_ag.sv:2677-2679`。README 明确 `page_fault=1` 时 `pa_vld=1` 且同拍，因此合法响应不会被遗漏；捕获后的 `lag_bkcon_pgfault` 又进入 `lsu_mmu_abort`，避免停顿期间再次访问 MMU：`srcs/xx_lsu_ld_ag.sv:2439-2441`。

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

`ag_dcache_arb_ld_req` 只检查 AG valid、TCM、内部 mask 和 dcache enable：`srcs/xx_lsu_ld_ag.sv:2548-2569`。代码中对 `mmu_lsu_pa_vld`、page cacheable 和异常的资格均被注释，`lag_mmu_acfault` 也因时序被从 mask 删除。

interaction 1.1.1 已确认这是继承自原 C910 的有意投机读取：D-cache 读本身无副作用；`!pa_vld` 表示 TLB miss 并由 LDC 重发；异常或 `CA=0` 时读出的 data/tag 不会被使用。结合 `dcache_arb_lag_ex1_sel` 同时表示选择与接受的合同，RR-11 功能关闭。

验证环境仍应把这些条件写成断言/scoreboard 检查，防止后续 D-cache 实现加入替换状态、prefetch 训练或其他读副作用后破坏该合同。

### RR-12：无 default `casez` 不能实现已确认的 X 传播目标

1. `lsu_lrq_ex1_pa_set` 被永久置 0：`srcs/xx_lsu_ld_ag.sv:2417-2420`；LRQ entry 的 PA、PA-valid 和属性读回也永久为 0：`srcs/xx_lsu_lrq_entry.sv:927-929`。但 AG 仍保留 `lag_lrq_pa_vld` 为真时绕过 MMU 的分支：`srcs/xx_lsu_ld_ag.sv:2427-2466`。当前集成中 replay 必然重新访问 MMU；未来若只恢复一半 PA cache 逻辑，可能得到未充分资格化的异常/属性路径。
2. `lag_ldc_ex1_bytes_vld1` 的 `casez` 覆盖全部二值 `000`～`111`，但没有 default：`srcs/xx_lsu_ld_ag.sv:2158-2166`。例如 selector 为 `X00` 时，五个 case item 均不匹配；procedural variable 会保留上一次值，而不是变成 X。`casez` 中的 `?` 还会屏蔽落在 don't-care 位上的 X。相邻 `lag_ldc_ex1_bytes_vld` 已用 default 显式赋 `{16{1'bx}}`：`srcs/xx_lsu_ld_ag.sv:2137-2146`。

README 已明确“case 出现 X 时希望 X 传播”，因此这不再只是待确认的编码风格：当前实现确实违反 X-prop 目标。至少应增加 `default: lag_ldc_ex1_bytes_vld1 = {16{1'bx}};`；若要求任一 selector bit 为 X 都传播，还需在 `casez` 前显式检查 `$isunknown`，因为 `?` 会有意忽略部分位。

### RR-13：fresh accepted-miss 在 RF 覆盖时被错误地创建为 ready

**触发条件**

同一拍满足：

- 当前 AG 是 fresh IDU 请求：`lag_ex1_inst_vld=1`、`lag_lrq_replay_vld=0`、`lag_lrq_create_already=0`；
- D-cache/结构 backpressure 令 `lag_ex1_stall_ori=1`；
- 更老 RF 请求 B 要覆盖当前请求 A，令 `ld_ag_stall_mask=idu_lsu_rf_older_vld=1`：`srcs/xx_lsu_ld_ag.sv:2827-2829`；
- MMU 返回 miss 且没有 abort：`mmu_lsu_pa_vld=0`、`lsu_mmu_abort=0`，即 `lag_stall_ori_tlbmiss_not_abort=1`：`srcs/xx_lsu_ld_ag.sv:2846-2848`。

interaction 1.1.1 给出的正式 accept 条件是 `lsu_mmu_va_vld && !lsu_mmu_abort`，当拍记录 miss queue、下一拍生效（`README.md:10`），且后续 abort 不能追溯取消（`README.md:11`）。RR-13 触发拍中 `lsu_mmu_va_vld=lag_ex1_inst_vld=1`（`srcs/xx_lsu_ld_ag.sv:2427`），结构反压又不属于 abort 条件（`srcs/xx_lsu_ld_ag.sv:2432-2442`），所以 A **必然在该拍被 MMU 接受**。

**失败机制**

1. A 会创建 LRQ entry：`lsu_lrq_create_vld=1`，见 `srcs/xx_lsu_ld_ag.sv:3030-3032`。
2. fresh 首拍的 `lag_ldc_ex1_lsid` 选择 LRQ 当前 free pointer：`srcs/xx_lsu_ld_ag.sv:2856-2860`；top 以完全相同的 accept 条件资格化 `lsu_mmu_lsid0`，因此 MMU 同拍获得该 one-hot lsid：`srcs/xx_lsu_top.sv:3774`。
3. 但 `lsu_lrq_create_frz = !(lag_ex1_stall_ori && ld_ag_stall_mask)` 只因 RF 覆盖就变为 0，没有考虑 miss 已由 MMU 持有：`srcs/xx_lsu_ld_ag.sv:3035`。
4. fresh 首拍的 `lag_lrq_create_already=0`，所以 `lag_ex1_stall_restart_entry=0`：`srcs/xx_lsu_ld_ag.sv:2850-2854`。但该信号只进入 controller 的本地立即唤醒路径（`srcs/xx_lsu_ctrl.sv:849-853`），与步骤 2 的 MMU lsid 路径独立。
5. LRQ entry 在 create 时装入 `frz=0`，随后立即满足 ready 前置条件：`srcs/xx_lsu_lrq_entry.sv:817-822`、`srcs/xx_lsu_lrq_entry.sv:853-859`。
6. LRQ 只在当前 EX1 仍 stall 且该 entry 不比 EX1 更老时阻止发射；B 下一拍正常前进后，A 即可被选中 replay：`srcs/xx_lsu_lrq.sv:1644`、`srcs/xx_lsu_lrq.sv:1835-1836`。

机械代入当前方程可得到：

| 周期 | MMU/AG 事件 | LRQ 状态 |
|---|---|---|
| T0 | `va_vld=1, abort=0, lsid=free_ptr`，MMU 记录 A；更老 B 覆盖 AG | A 以 `vld=1, frz=0` 创建 |
| T1 | B 若正常前进，`lsu0_lrq_ex1_stall_vld=0` | A 满足 `rdy_pre`，可被选中 replay |
| T2 | 若原 miss 尚未 wake，A 再次发出同一 MMU 请求 | 同一事务同时存在原 pending 与新 accept/merge |

因此 README 第 4/9 项“`stall_restart_entry=0`，所以 MMU 不会记录 lsid”的因果关系与 RTL 不成立。已确认事实是同一未完成请求同时被“MMU pending miss”和“ready LRQ replay”拥有；最终是否造成重复 queue entry、重复 merge bitmap 或错误 wakeup 还依赖仓库外 MMU 的同 lsid merge 规则，但所有权不变量已经被破坏。

**建议**

fresh create 的 freeze 决策必须体现所有权：若 `lag_stall_ori_tlbmiss_not_abort=1`，entry 应保持 frozen 等待 MMU；只有确认 MMU 未登记该请求时，才允许 controller/ready LRQ 立即重发。按现有信号语义，一个待设计确认的最小修正形式是 `create_frz = !(stall_ori && stall_mask) || mmu_owns_request`。更推荐显式生成 `mmu_owns_request`，统一驱动 `create_frz` 与 `stall_restart_entry`，并断言一个未 flush 事务不能同时处于 MMU pending 与 LRQ ready。

### RR-14：同拍子场景关闭，flush/reuse 的旧 async wakeup 仍未闭环

controller 把 `mmu_lsu_async_wakeup0/2/3` 直接 OR 到各 lane wakeup：`srcs/xx_lsu_ctrl.sv:949-988`；top 再把 bitmap 原样接到 LRQ freeze-clear：`srcs/xx_lsu_top.sv:12405`、`srcs/xx_lsu_top.sv:12425`、`srcs/xx_lsu_top.sv:12445`。该接口只有可复用的 LRQ bit，没有 IID、generation 或 flush epoch。

LRQ entry 的 create 优先于普通 freeze-clear：`srcs/xx_lsu_lrq_entry.sv:817-822`。interaction 1.1.1 明确保证 LRQ create 与 MMU wakeup 不同拍，MMU immediate wake 会打一拍，因此原“同拍 create 吞 wakeup”子场景关闭。实际一拍路径另发现 RR-16。

剩余风险是 **旧 async wakeup 的事务归属**：flush 清除旧 entry 后，同一 bit 可被新事务复用；若旧 MMU wakeup 随后迟到，它会直接清除新 entry 的 freeze。README 只回答最短延迟，没有说明 full/partial flush 如何取消已接受且不可由后拍 abort 追溯取消的 miss，也没有给出“旧 pending 清空前禁止 bit 复用”的约束。

因此 RR-14 缩小后保留。必须补充并验证以下任一合同：MMU 在 LRQ bit 可复用前同步完成 flush cancellation；或 wakeup 携带 generation/epoch；或 LSU 用 pending-valid+generation 过滤 bitmap。只有“一拍后 wake”不足以关闭 flush 后 N 拍迟到的旧 wakeup。

### RR-15：special clock 永久常开是已确认的功耗取舍

controller 的 `lsu_special_clk_en` 包含 `!pfu_part_empty`：`srcs/xx_lsu_ctrl.sv:539-556`；top 固定 `pfu_part_empty=1'b0`：`srcs/xx_lsu_top.sv:3761`。因此 local enable 恒为 1，`lsu_special_clk` 永远打开。

该常开还掩盖了 controller 中的可疑漏项：表达式末尾两次使用 `idu_lsu_vmb_create0_gateclk_en`，完全没有使用 `idu_lsu_vmb_create1_gateclk_en`；`icc_vb_create_gateclk_en`、`lsda0_ex3_special_gateclk_en`、`lsda1_ex3_special_gateclk_en` 也只声明/连入而未消费，见 `srcs/xx_lsu_ctrl.sv:36`、`srcs/xx_lsu_ctrl.sv:50-51`、`srcs/xx_lsu_ctrl.sv:287`、`srcs/xx_lsu_ctrl.sv:303`。

interaction 1.1.1 明确该 tie-off 是永久的放松钟控，不会恢复真实 empty。因此缺失/重复 gate-enable 在支持配置下不会关钟，也不会造成当前功能错误；RR-15 的功能风险关闭。保留 P3 记录仅用于说明功耗代价、死输入和误导性表达式。若未来改变“永久 tie 0”合同，必须重新开放本项并先补齐全部启动事件。

### RR-16：结构反压时 MMU immediate wake 被 `ldc_ex2_inst_vld` 吃掉

**触发条件**

- fresh A 在 AG 有效并创建 LRQ；
- D-cache 结构反压令 `ld_ag_struwk_stall_req=1`，但没有更老 RF 覆盖，所以 `ld_ag_stall_mask=0`；
- MMU 同拍返回 `mmu_lsu_imme_wakeup=1`（例如 README/端口注释所述 TMQ full 或 merge-on-complete），并按合同要求下一拍唤醒 LRQ；
- 按 README 已给出的行为只依赖下一拍 immediate wake；README 未承诺随后还会补发一份 async wakeup。

**失败机制**

1. A 仍会创建 entry，且 `lsu_lrq_create_frz = !(stall_ori && stall_mask) = 1`：`srcs/xx_lsu_ld_ag.sv:3030-3035`。
2. 结构反压进入 `ld_ag_stall_restart`，所以 A 不进入 DC：`lag_ldc_ex1_inst_vld=0`，见 `srcs/xx_lsu_ld_ag.sv:2779-2788`、`srcs/xx_lsu_ld_ag.sv:2865-2866`。
3. DC metadata 寄存器却以较宽的 `lag_ex1_inst_vld` 为 enable，能锁存 `mmu_lsu_imme_wakeup` 和 one-hot lsid：`srcs/xx_lsu_ld_dc.sv:1291-1351`、`srcs/xx_lsu_ld_dc.sv:1365`、`srcs/xx_lsu_ld_dc.sv:1381`。
4. 同拍 DC control valid 只在 `lag_ldc_ex1_inst_vld=1` 时置位，因此下一拍 `ldc_ex2_inst_vld=0`：`srcs/xx_lsu_ld_dc.sv:1113-1154`。这不是“时钟没开所以保持旧值”：`ctrl_ld0_clk_en` 明确包含 `lag0_ex1_inst_vld`，见 `srcs/xx_lsu_ctrl.sv:570-586`。
5. 最终 wakeup 又被该 control valid 门控：`ldc_mask_lsid = ldc_ex2_inst_vld & lsid`，`ldc_ex2_imme_wakeup = ldc_tlb_imme_wakeup & ldc_mask_lsid`，见 `srcs/xx_lsu_ld_dc.sv:2213-2218`。结果送往 controller 的 bitmap 为 0。
6. controller 也不会补救：T0 backpressure 把 `lag_bkcon_tlbmiss` 置 1（`srcs/xx_lsu_ld_ag.sv:1380-1386`），T1 的 `lag_ex1_stall_ori` 又显式排除该状态（`srcs/xx_lsu_ld_ag.sv:2799-2808`）；而 controller 的 RF wakeup 必须同时有 older RF 和 `lag0_ex1_stall_ori`（`srcs/xx_lsu_ctrl.sv:849-853`）。本场景两者均不满足。

| T0 输入/状态 | 方程结果 |
|---|---|
| fresh=1, struct_stall=1, older=0 | `create=1, create_frz=1, lag_ldc_ex1_inst_vld=0` |
| `mmu_lsu_imme_wakeup=1, lsid=free_ptr` | metadata 锁存 wake/lsid，但 `ldc_ex2_inst_vld=0` |
| T1 | `ldc_ex2_imme_wakeup=0`，LRQ entry 继续 frozen |

如果该 immediate 条件表示 MMU 不会保留 pending 项并另发 async wakeup，A 将永久 frozen，属于 P1 请求丢失/死锁。lane0 路径由提供源码可确认；lane2/lane3 使用未提供定义的 `xx_lsu_ls_dc_wrapper`，只能看到同名 immediate-wakeup 端口和 controller 输出，必须在完整工程中复查。

**建议**

立即唤醒应以“MMU accept 的有效 lsid”资格化，而不是以“请求成功进入 DC”资格化。可单独打一拍 `{mmu_accept && mmu_lsu_imme_wakeup, lsu_mmu_lsid}` 直达 LRQ/controller，或证明所有 immediate 场景都会另发 async bitmap。必须加入 `struct_stall × older={0,1} × immediate={0,1}` 定向测试；其中 `older=0` 的 frozen entry 必须在下一拍变 ready。

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
- **已确认**：RR-03 的 replay `halt_info` 绕过 LRQ mux。
- **已解释/待清理**：RR-09 的九个 top 输入为 replay 迁移后的死接口，不再列为功能风险。
- **已确认/高置信影响**：RR-13 的 MMU lsid 与 controller restart bitmap 独立；正式 accept 合同确认 fresh miss 已入队，而 LRQ 同时 ready。
- **合同依赖**：RR-14 的 raw MMU async wakeup bitmap 没有 generation/epoch；一拍最短延迟不解决 flush/reuse。
- **已给定配置**：RR-15 的 special clock 永久常开，当前没有功能缺口，只有功耗与死接口问题。
- **已确认**：RR-16 的 lane0 immediate-wakeup 打拍结果被 `ldc_ex2_inst_vld` 门控，结构反压时丢失。
- **已解释/命名待清理**：`srcs/xx_lsu_top.sv:4837` 把 `.lsu3_lrq_exx_sq_not_full` 接到 `lsu2_lrq_exx_sq_not_full`；README 已确认该状态对 lane2/lane3 是共享语义，不是功能笔误，但应改为 lane-neutral 名称并删除未用 lane3 别名。

### 4.3 静态检查边界

另有三项低风险的死接口/固定配置需要设计方确认：

- `cp0_lsu_nsfe` 已由 top 接入：`srcs/xx_lsu_top.sv:5143`，但 AG 内除端口声明 `srcs/xx_lsu_ld_ag.sv:357` 外没有使用；当前 no-spec 建项检查只能依赖上游已把相关 hit 信号关闭。
- `sfp_hit_no_spec_tbl` 在 top 被固定为 0：`srcs/xx_lsu_top.sv:5217`，AG 内除声明 `srcs/xx_lsu_ld_ag.sv:432` 外没有使用，属于残留接口。
- `cp0_lsu_cb_aclr_dis` 在 top 固定为 1：`srcs/xx_lsu_top.sv:5137`，因此 `srcs/xx_lsu_ld_ag.sv:2486-2493` 的 boundary acceleration 永久关闭。若这是当前产品配置，应以参数/注释明确；若仍计划启用，则是接线错误。

仓库已经提供 `xx_lsu_ctrl`，但仍没有以下 helper 的定义：`gated_clk_cell`、`xx_lsu_compare_iid`、`xx_lsu_vmask_gen`、`xx_lsu_us_bytes_gen`、`xx_lsu_vreg_mask`、`xx_lsu_ld_vreg_rot`，以及 top 中的其他部分模块。当前环境也没有完整宏/include 与工程 filelist。因此：

- 本报告完成的是源码级 named-port、宽度表达式和语义链检查；
- 不能把“named-port 集合一致”解释为完整 elaboration/compile 已通过；
- helper 模块端口宽度、宏展开值、clock-cell 版本和完整跨模块时序仍需在工程环境中编译确认。
- controller 还接收 `lsag0/lsag1` 的 restart bitmap，lane2/lane3 又通过未提供定义的 `xx_lsu_ls_dc_wrapper` 传递 MMU immediate wake；RR-13/RR-16 只能在已提供的 lane0 load-AG/DC 路径上确认，store 两路需要在完整工程中复查同一所有权与唤醒不变量。

## 5. 已确认合同与仍需回答的问题

已由 README 确认并应转成 assertion/配置检查的合同：

1. 目标集成中 `mmu_lsu_stall==0`。
2. access fault 在请求后一拍返回。
3. `mmu_lsu_page_fault |-> mmu_lsu_pa_vld`，且两者同拍。
4. fresh 请求进入 AG 前，LRQ `no_space` 已保证本 lane 有可创建 entry。
5. `already_da/spec_fail/unal2nd` 的 replay 状态由 LRQ 而非 IDU 提供。
6. create 与 flush 同拍时，上游 LSIQ 同时被 flush，且 flush 优先于 pop。
7. D-cache 读无副作用；TLB miss、fault、`CA=0` 的投机 data/tag 不被使用；`dcache_arb_lag_ex1_sel` 同时表示选择与接受。
8. case 控制含 X 时，验证目标是让 X 传播，而不是隐藏 X。
9. `mmu_accept = lsu_mmu_va_vld && !lsu_mmu_abort`，当拍记录 miss queue、下一拍生效；后续 abort 不能追溯取消。
10. LRQ create 与 MMU wakeup 不同拍；MMU immediate wake 应打一拍到 LRQ。
11. lane2 的 SQ-not-full bitmap 对 lane2/lane3 是共享语义。
12. `no_spec_exist` 进入 LSU 后有意改为内部语义。
13. 只支持 `LRQENTRY==LSIQENTRY`、`PC_LEN=15`、`VMBENTRY=8`、9-bit split。
14. `pfu_part_empty` 永久 tie 0，special clock 常开是有意的放松钟控。

仍需设计方回答或修正：

1. RR-13：既然 accept 条件与 `lsu_mmu_lsid0` 的资格完全一致，为什么 README 仍认为 `stall_restart_entry=0` 会阻止 MMU 记录 lsid？请提供未给出的 MMU 端过滤方程，或修正 `create_frz`/所有权逻辑。
2. RR-16：MMU immediate wake 是否保证还会另发 async bitmap？若不会，结构反压使 `ldc_ex2_inst_vld=0` 时由哪条未提供路径完成下一拍 LRQ wakeup？
3. RR-14：full/partial flush 如何取消已经 accept 且不能由后拍 abort 追溯取消的 miss？旧 wakeup 在 LRQ bit 复用后如何被过滤？
4. 原 §5.6：README 第 12 项“同 RR-11”没有回答 replay metadata；`inst_ldr`、`no_spec`、VL、vmask、vector mask source 与 `halt_info` 哪些应保存，哪些已被形式证明不可观察？
5. RR-12：请确认修复目标是只在“决策相关 X”时输出 X，还是 selector 任一 bit 为 X 都输出 X；后一种要求不能仅靠带 `?` 的 `casez` default 实现。

## 6. 建议修复顺序

1. 先修复 RR-16 的 immediate-wakeup 丢失，避免合法请求永久 frozen。
2. 修复/证明 RR-13：MMU accepted miss 与 LRQ ready 必须互斥；再闭环 RR-14 的 flush/reuse wakeup 归属。
3. 补齐 RR-02/RR-03 的 replay metadata，保证 valid payload 无 X、无跨事务取值；同时给 RR-12 增加符合目标的显式 X-prop。
4. 将已关闭合同写成 assertion：flush>pop、D-cache 无副作用、固定参数、special clock 常开、MMU accept/abort/一拍 immediate wake。
5. 清理 RR-01/RR-09、共享 SQ-not-full 命名、死 gate-enable，并添加参数静态限制。
6. 在完整工程环境执行 elaboration、lint、X-prop、形式断言和端到端回归。

本次任务仅形成审查文档，没有修改提供的 RTL。
