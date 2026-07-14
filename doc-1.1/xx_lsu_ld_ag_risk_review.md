# `xx_lsu_ld_ag` 设计风险与例化连线审查

## 1. 审查范围与结论

初版审查基于仓库提交 `ec421e9`；本次根据 interaction 1.1 的六项澄清，在提交 `8f770ac` 上继续复核，并新增阅读 controller：

- `srcs/xx_lsu_ld_ag.sv`
- `srcs/xx_lsu_lrq.sv`
- `srcs/xx_lsu_lrq_entry.sv`
- `srcs/xx_lsu_top.sv`
- `srcs/xx_lsu_ld_dc.sv`
- `srcs/xx_lsu_ld_da.sv`
- `srcs/xx_lsu_ctrl.sv`
- 基线文件 `srcs/ct_lsu_ld_ag.v`

结论如下：

1. RR-05、RR-06、RR-07 的原始触发条件已由新合同关闭；RR-08 被缩小为 flush 同拍的 create/pop 一致性问题；RR-09 降为遗留接口清理；RR-12 的二值 case 覆盖结论成立，但四态 X-prop 风险仍保留。
2. controller 证明 `lag_stall_ori_tlbmiss_not_abort` 会在 MMU 未持有请求时选择立即重发、在已接受 TLB miss 时等待 MMU 唤醒；README 描述的旧丢请求错误在当前“已建项/replay”路径已修正。
3. 继续追踪后发现一个新的 P1 缺口：fresh 请求首次进入 AG、MMU 已接受 miss、又被更老 RF 请求覆盖时，新建 LRQ entry 仍被写成非 frozen，可在原 MMU 请求完成前再次 replay。
4. controller 的 MMU async wakeup 只携带 LRQ bitmap，直接清 freeze，没有 IID/flush epoch；同拍 create 的 wakeup 又会被 create 优先级吞掉。该项是否触发依赖 MMU 对 flush、entry 复用和最短 wakeup 延迟的合同。
5. 对当前提供的七个主要模块做 named-port 集合复查，均未发现漏接、多接或重复端口；仍存在参数宽度耦合、遗留输入和时钟门控问题。

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
| RR-01 | P1 | 高置信/合同依赖 | 开放 | fresh `no_spec_exist` 被丢弃，LRQ 字段又承载内部 no-spec wait 状态 |
| RR-02 | P1 | 高置信 | 开放 | replay 时 `inst_ldr`、向量 VL/mask 等仍被使用的字段为 `X` |
| RR-03 | P2 | 已确认 | 开放 | replay 的调试 `halt_info` 取自当前 IDU 指令，而不是被 replay 的指令 |
| RR-04 | — | 已给定合同 | 条件关闭 | 目标集成规定 `mmu_lsu_stall==0`；top 仍暴露输入，需 integration assertion |
| RR-05 | — | 已给定合同 | 已关闭 | AF 在请求下一拍返回，此时 `lag_bkcon_stall_already==1`，现有捕获对拍 |
| RR-06 | — | RTL+合同 | 原场景关闭 | stall tie-off 排除 not-ready；controller 已使用 abort-aware 判定，fresh 首拍缺口另列 RR-13 |
| RR-07 | — | 已给定合同 | 已关闭 | 合法接口保证 `page_fault -> pa_vld` 且同拍 |
| RR-08 | P2 | 高置信/合同依赖 | 缩小后开放 | 容量由 `no_space` 预留；create 与 flush 同拍时 allocation/pop 资格仍不一致 |
| RR-09 | P3 | 已解释 | 功能关闭/清理项 | replay 状态已迁入 LRQ；九个 top 输入为过时接口 |
| RR-10 | P2 | 已确认 | 开放 | 非默认参数下 LRQ ID、PC、VMB ID、split number 存在截断/扩展风险 |
| RR-11 | P2 | 合同依赖 | 开放 | D-cache 请求允许在 PA 无效、非 cacheable 或 fault 未决时投机发出 |
| RR-12 | P3 | 已确认 | 缩小后开放 | LRQ PA/属性复用路径失活；二值 case 完整，但无 default 的四态 X-prop 风险仍在 |
| RR-13 | P1 | 高置信 | 新发现 | fresh accepted-miss 被更老 RF 覆盖时，LRQ entry 错误地以非 frozen 状态创建 |
| RR-14 | P1 | 合同依赖 | 新发现 | MMU wakeup 仅按可复用 LRQ bit 清 freeze；无 epoch，且 create 同拍 wakeup 会被吞掉 |
| RR-15 | P2 | 已确认/潜在 | 新发现 | `pfu_part_empty=0` 使 special clock 常开并掩盖多项缺失/重复 gate enable |

## 3. 详细问题

### RR-01：fresh `no_spec_exist` 被丢弃，replay 字段语义需确认

**证据**

1. top 已把三路 IDU 的 `no_spec_exist` 输入接到 LRQ：`srcs/xx_lsu_top.sv:146`、`srcs/xx_lsu_top.sv:192`、`srcs/xx_lsu_top.sv:252`，对应实例连接为 `srcs/xx_lsu_top.sv:4489`、`srcs/xx_lsu_top.sv:4530`、`srcs/xx_lsu_top.sv:4585`。
2. LRQ 也声明了这三路输入：`srcs/xx_lsu_lrq.sv:62`、`srcs/xx_lsu_lrq.sv:105`、`srcs/xx_lsu_lrq.sv:162`。
3. 但 fresh-IDU 分支没有直通输入，而是把输出硬接为 0：`srcs/xx_lsu_lrq.sv:1794`、`srcs/xx_lsu_lrq.sv:1866`、`srcs/xx_lsu_lrq.sv:1951`。三处上一行的注释版本仍保留了正确的 IDU 直通写法。
4. replay 分支读取 `LRQ_NOSPEC_EXIST`；entry 没有从原始 IDU `no_spec_exist` 创建该 bit，而是把 `lrq_create_no_spec_chk` 同时写入 `no_spec_exist` 和 `no_spec_chk`：`srcs/xx_lsu_lrq_entry.sv:721-740`、`srcs/xx_lsu_lrq_entry.sv:871`。其中 `no_spec_chk` 可在 wakeup 时清除，而 `no_spec_exist` 保留，这可能是有意的“等待结束后仍需 DA 检查”语义，也可能是字段复用错误，当前源码无法单独判定。
5. 与上述语义问题独立，原始 2-bit `no_spec` 没有保存，replay 时直接输出 `2'bxx`：`srcs/xx_lsu_lrq.sv:1792`、`srcs/xx_lsu_lrq.sv:1864`、`srcs/xx_lsu_lrq.sv:1949`。
6. pipe0 的值在 AG 无条件锁存：`srcs/xx_lsu_ld_ag.sv:1201-1202`，DC 继续锁存：`srcs/xx_lsu_ld_dc.sv:1386-1387`；DA 使用它们做 spec/target/pair 分类和恢复判定：`srcs/xx_lsu_ld_da.sv:5318-5328`、`srcs/xx_lsu_ld_da.sv:5350-5372`。

**触发方式**

- Fresh 路径：IDU 发出 `no_spec_exist=1` 的 load，LRQ 选择 IDU 后把该 bit 变为 0。如果 DA 仍要求消费原 predictor 状态，则 `ld_da_spec_chk_req` 会被抑制；如果新协议规定 fresh 必须忽略此输入，则 top 端口和注释已经过时。
- Replay 路径：该 load 因 TLB miss、cache backpressure 或资源冲突进入 LRQ；恢复执行时 `no_spec=XX`，而 `no_spec_exist` 来自内部 `create_no_spec_chk` 路径。

**影响**

确定事实是 fresh 输入被丢弃以及 replay `no_spec` 为 X；是否必须保留原 `no_spec_exist` 需要接口合同确认。在 DA 仍消费原 predictor 语义的前提下，`cp0_lsu_nsfe=1` 时可能漏做依赖检查，或错误产生/漏产生 no-spec miss/hit/mispredict。

**建议**

- 先由设计方明确 DA 所需的是“原 predictor exist”还是“LRQ wait 曾经存在”。
- 若需要原 predictor 状态，fresh 分支应直通对应 `idu_lsu*_rf_no_spec_exist`，LRQ entry 应分别保存原始 `{no_spec[1:0], no_spec_exist}` 与内部调度用的 `no_spec_chk`。
- 若新协议明确不需要原输入，应删除 top 死端口、更新命名，并用断言证明 replay 的 `no_spec=XX` 在所有有效下游均不可观察；否则仍应保存该 2-bit 字段。

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

### RR-08：LRQ create、实际分配和 LSIQ pop 的条件不一致

**证据**

- AG 的 `lsu_lrq_create_vld` 只按 AG valid、非 replay 和去重状态生成，没有 ready/accept 或 flush 资格：`srcs/xx_lsu_ld_ag.sv:3030-3035`。
- LRQ 的 `lrq0_create_success` 会额外屏蔽 full flush/partial flush，但不显式检查 full：`srcs/xx_lsu_lrq.sv:1443-1452`。
- 对 IDU 的 pop valid 却直接使用原始 `lsu0_lrq_create_vld`，而不是 `lrq0_create_success`：`srcs/xx_lsu_lrq.sv:1692-1693`。
- 容量侧已有缓解：每条 lane 有独立的 free pointer：`srcs/xx_lsu_lrq.sv:1411-1441`，`lrq*_no_space` 和 issue gating 会阻止 full/保留阈值下的新 fresh-IDU 请求进入：`srcs/xx_lsu_lrq.sv:1443-1470`、`srcs/xx_lsu_lrq.sv:1628-1683`。三 lane 同拍 create 不竞争同一个 pointer。

**风险场景**

- create 与 full/partial flush 同拍：LRQ 不分配，但 IDU pop 仍拉高。
- README 指出的 `lrq0_no_space` 确实在 fresh IDU 进入 AG 前完成容量预留，因此正常非 flush 流程下，不再把“无空闲 entry”列为独立 bug。

剩余问题被缩小为 flush 同拍语义：LRQ allocation 使用 `lrq0_create_success`，IDU pop 却使用 raw `lsu0_lrq_create_vld`。只有在上游明确规定 flush 周期无条件忽略该 pop 时才安全；当前接口没有把这一合同编码在 pop 信号中。

**建议**

统一定义 `create_accept = create_vld && has_entry && !flush_kill`，分配、LSIQ pop、MMU lsid 和 AG `create_already` 都使用同一个 accept 事件。除 one-hot pointer 外，还应分别断言 allocation、pop 和 `create_already` 只由同一个 accept 触发，并显式排除 full/partial-flush kill。

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

### RR-10：非默认参数存在宽度截断

| 路径 | AG 宽度 | LRQ/top 宽度 | 风险 |
|---|---|---|---|
| `lch_entry` | `LSIQENTRY`，`srcs/xx_lsu_ld_ag.sv:388` | `LRQENTRY`，`srcs/xx_lsu_top.sv:3896` | `LRQENTRY > LSIQENTRY` 时高位 LRQ ID 被截断 |
| `lrqid` | `LSIQENTRY`，`srcs/xx_lsu_ld_ag.sv:429` | `LRQENTRY`，`srcs/xx_lsu_top.sv:3937` | 高位 entry 无法正确标识 |
| `pop_entry` | `LSIQENTRY`，`srcs/xx_lsu_ld_ag.sv:599` | `LRQENTRY`，`srcs/xx_lsu_top.sv:3873` | pop bitmap 扩展/截断语义不明确 |
| PC | 参数 `PC_LEN`，`srcs/xx_lsu_ld_ag.sv:397` | top/LRQ 固定 15 bit，`srcs/xx_lsu_top.sv:3905`、`srcs/xx_lsu_lrq.sv:480` | `PC_LEN != 15` 时截断或扩展 |
| VMB ID | 参数 `VMBENTRY`，`srcs/xx_lsu_ld_ag.sv:417` | top/LRQ 固定 8 bit，`srcs/xx_lsu_top.sv:3925`、`srcs/xx_lsu_lrq.sv:500` | `VMBENTRY != 8` 时错误 |
| split number | 固定 9 bit，`srcs/xx_lsu_ld_ag.sv:405` | top 使用 ``SPILT_NUM_WIDTH``，`srcs/xx_lsu_top.sv:3913` | 宏不等于 9 时错误 |

top 把 `LRQENTRY` 和 `LSIQENTRY` 暴露成两个参数：`srcs/xx_lsu_top.sv:27`、`srcs/xx_lsu_top.sv:42`。默认值满足 `LRQENTRY=LSIQENTRY=12`、`PC_LEN=15`、`VMBENTRY=8`，所以默认配置没有直接宽度不匹配；但接口实际上要求这些参数取固定关系。

**建议**

要么把所有相关路径完整参数化，要么在 elaboration 阶段用静态 assertion 明确限制：`LRQENTRY == LSIQENTRY`、`PC_LEN == 15`、`VMBENTRY == 8`、``SPILT_NUM_WIDTH == 9``。

### RR-11：D-cache 在翻译/异常未决时允许投机读

`ag_dcache_arb_ld_req` 只检查 AG valid、TCM、内部 mask 和 dcache enable：`srcs/xx_lsu_ld_ag.sv:2548-2569`。代码中对 `mmu_lsu_pa_vld`、page cacheable 和异常的资格均被注释，`lag_mmu_acfault` 也因时序被从 mask 删除。

该做法可能是只读阵列的有意投机优化，但 MMU miss queue 让“PA 未就绪时仍有 AG valid”的情况更常见。必须确认：

- 错误/旧 PA 的 tag/data 读不会更新替换状态或任何架构状态；
- miss/fault 请求不能凭错误 tag hit 进入 LQ、提前回写或影响 unit-stride way 选择；
- 后级 cancel 一定早于任何消费者使用投机结果。

若不能证明这些性质，应恢复 PA/CA/exception 资格或增加明确的投机结果 kill。

### RR-12：失活路径与组合 X 风险

1. `lsu_lrq_ex1_pa_set` 被永久置 0：`srcs/xx_lsu_ld_ag.sv:2417-2420`；LRQ entry 的 PA、PA-valid 和属性读回也永久为 0：`srcs/xx_lsu_lrq_entry.sv:927-929`。但 AG 仍保留 `lag_lrq_pa_vld` 为真时绕过 MMU 的分支：`srcs/xx_lsu_ld_ag.sv:2427-2466`。当前集成中 replay 必然重新访问 MMU；未来若只恢复一半 PA cache 逻辑，可能得到未充分资格化的异常/属性路径。
2. `lag_ldc_ex1_bytes_vld1` 的 `casez` 确实覆盖二值 `000`～`111`，所以不存在缺少某个合法二值分支的问题：`srcs/xx_lsu_ld_ag.sv:2158-2166`。不过它仍没有 default；在四态仿真中，case 表达式含 `X` 且未匹配时，组合块不能给出确定赋值。相邻 `bytes_vld` 逻辑有明确 default：`srcs/xx_lsu_ld_ag.sv:2137-2146`。因此只保留 P3 X-prop/编码卫生问题，不再称为二值功能覆盖缺口。

### RR-13：fresh accepted-miss 在 RF 覆盖时被错误地创建为 ready

**触发条件**

同一拍满足：

- 当前 AG 是 fresh IDU 请求：`lag_ex1_inst_vld=1`、`lag_lrq_replay_vld=0`、`lag_lrq_create_already=0`；
- D-cache/结构 backpressure 令 `lag_ex1_stall_ori=1`；
- 更老 RF 请求 B 要覆盖当前请求 A，令 `ld_ag_stall_mask=idu_lsu_rf_older_vld=1`：`srcs/xx_lsu_ld_ag.sv:2827-2829`；
- MMU 已接受 A 的 miss：`mmu_lsu_pa_vld=0`、`lsu_mmu_abort=0`，即 `lag_stall_ori_tlbmiss_not_abort=1`：`srcs/xx_lsu_ld_ag.sv:2846-2848`。

**失败机制**

1. A 会创建 LRQ entry：`lsu_lrq_create_vld=1`，见 `srcs/xx_lsu_ld_ag.sv:3030-3032`。
2. fresh 首拍的 MMU lsid 选择 LRQ 当前 free pointer：`srcs/xx_lsu_ld_ag.sv:2856-2860`；top 只以 `va_vld && !abort` 资格化，因此 MMU 同拍获得该新 entry 的 one-hot lsid：`srcs/xx_lsu_top.sv:3774`。
3. 但 `lsu_lrq_create_frz = !(lag_ex1_stall_ori && ld_ag_stall_mask)` 只因 RF 覆盖就变为 0，没有考虑 miss 已由 MMU 持有：`srcs/xx_lsu_ld_ag.sv:3035`。
4. fresh 首拍的 `lag_lrq_create_already=0`，所以 `lag_ex1_stall_restart_entry` 也为 0：`srcs/xx_lsu_ld_ag.sv:2850-2854`；controller 不会立即补救。
5. LRQ entry 在 create 时装入 `frz=0`，随后立即满足 ready 前置条件：`srcs/xx_lsu_lrq_entry.sv:817-822`、`srcs/xx_lsu_lrq_entry.sv:853-859`。
6. LRQ 只在当前 EX1 仍 stall 且该 entry 不比 EX1 更老时阻止发射；B 下一拍正常前进后，A 即可被选中 replay：`srcs/xx_lsu_lrq.sv:1644`、`srcs/xx_lsu_lrq.sv:1835-1836`。

此时同一未完成请求同时被“MMU pending miss”和“ready LRQ replay”拥有。LRQ 可在原 MMU wakeup 前再次发送 A，导致重复 MMU 请求、重复 merge/bitmap 登记，或在 abort/flush 交叉下形成更复杂的丢失和错误唤醒。

**建议**

fresh create 的 freeze 决策必须体现所有权：若 `lag_stall_ori_tlbmiss_not_abort=1`，entry 应保持 frozen 等待 MMU；只有确认 MMU 未登记该请求时，才允许 controller/ready LRQ 立即重发。按现有信号语义，一个待设计确认的最小修正形式是 `create_frz = !(stall_ori && stall_mask) || mmu_owns_request`。更推荐显式生成 `mmu_owns_request`，统一驱动 `create_frz` 与 `stall_restart_entry`，并断言一个未 flush 事务不能同时处于 MMU pending 与 LRQ ready。

### RR-14：MMU async wakeup 没有 generation，且 create 同拍会丢 wakeup

controller 把 `mmu_lsu_async_wakeup0/2/3` 直接 OR 到各 lane wakeup：`srcs/xx_lsu_ctrl.sv:949-988`；top 再把 bitmap 原样接到 LRQ freeze-clear：`srcs/xx_lsu_top.sv:12405`、`srcs/xx_lsu_top.sv:12425`、`srcs/xx_lsu_top.sv:12445`。该接口只有可复用的 LRQ bit，没有 IID、generation 或 flush epoch。

LRQ entry 的优先级又是 create 高于普通 freeze-clear：`srcs/xx_lsu_lrq_entry.sv:817-822`。因此存在两类合同依赖风险：

- MMU wakeup 与 frozen entry create 同拍时，create 写入 `frz=1`，该次 wakeup 被吞掉；若 MMU 不重发，entry 永久 frozen。
- flush 清除旧 entry 后，同一 bit 被新事务复用，若旧 MMU wakeup 迟到，它会直接清除新 entry 的 freeze。

若 MMU 明确保证“wakeup 不早于 create 后一拍、flush 会同步删除所有 pending lsid、删除完成前 LRQ bit 不可复用”，当前设计可以依赖该合同；仓库没有编码或证明这些条件。更稳妥的接口应携带 generation/epoch，或由 MMU/LSU 维护 pending-valid tag 后再接受 wakeup。

### RR-15：special clock 被常开，且掩盖 gate-enable 漏项

controller 的 `lsu_special_clk_en` 包含 `!pfu_part_empty`：`srcs/xx_lsu_ctrl.sv:539-556`；top 却固定 `pfu_part_empty=1'b0`：`srcs/xx_lsu_top.sv:3761`。因此 local enable 恒为 1，当前 `lsu_special_clk` 实际无法门控，属于已确认的功耗问题。

该常开还掩盖了 controller 中的可疑漏项：表达式末尾两次使用 `idu_lsu_vmb_create0_gateclk_en`，完全没有使用 `idu_lsu_vmb_create1_gateclk_en`；`icc_vb_create_gateclk_en`、`lsda0_ex3_special_gateclk_en`、`lsda1_ex3_special_gateclk_en` 也只声明/连入而未消费，见 `srcs/xx_lsu_ctrl.sv:36`、`srcs/xx_lsu_ctrl.sv:50-51`、`srcs/xx_lsu_ctrl.sv:287`、`srcs/xx_lsu_ctrl.sv:303`。

若以后为了功耗把 `pfu_part_empty` 接回真实 empty 而没有同时补齐所有 special-clock 请求，依赖该时钟的 LRQ/VB/VMB/RB 元数据可能漏采。当前功能影响被常开条件遮蔽；建议先列出 `lsu_special_clk` 的全部消费者和启动事件，再一起修复 tie-off 与 enable 表达式，并做门级 clock-gating 回归。

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

RR-10 所列 AG↔LRQ 路径在仓库默认参数关系下数值对齐；非默认参数会暴露截断风险。由于宏定义和 helper 模块不完整，本次没有把静态端口集合检查等同于完整位宽 elaboration。

### 4.2 已确认/疑似语义连线问题

- **高置信/合同依赖**：RR-01 的 fresh `no_spec_exist` 输入确实被清零；只有接口合同要求保留原 predictor 状态时，这才是功能错误。
- **已确认**：RR-03 的 replay `halt_info` 绕过 LRQ mux。
- **已解释/待清理**：RR-09 的九个 top 输入为 replay 迁移后的死接口，不再列为功能风险。
- **高置信**：RR-13 的 fresh accepted-miss 所有权分裂由 AG、controller 和 LRQ 方程共同确定。
- **合同依赖**：RR-14 的 raw MMU wakeup bitmap 没有 generation/epoch。
- **已确认/潜在**：RR-15 当前使 special clock 常开，并掩盖多个未消费的 gate-enable 输入。
- **疑似命名/连线笔误**：`srcs/xx_lsu_top.sv:4837` 把 `.lsu3_lrq_exx_sq_not_full` 接到 `lsu2_lrq_exx_sq_not_full`；独立声明的 lane3 信号在 `srcs/xx_lsu_top.sv:3815` 没有使用。若 SQ-not-full 本来是全局状态，建议改成 lane-neutral 名称；若应按 lane 区分，则该连接是明确笔误。

### 4.3 静态检查边界

另有三项低风险的死接口/固定配置需要设计方确认：

- `cp0_lsu_nsfe` 已由 top 接入：`srcs/xx_lsu_top.sv:5143`，但 AG 内除端口声明 `srcs/xx_lsu_ld_ag.sv:357` 外没有使用；当前 no-spec 建项检查只能依赖上游已把相关 hit 信号关闭。
- `sfp_hit_no_spec_tbl` 在 top 被固定为 0：`srcs/xx_lsu_top.sv:5217`，AG 内除声明 `srcs/xx_lsu_ld_ag.sv:432` 外没有使用，属于残留接口。
- `cp0_lsu_cb_aclr_dis` 在 top 固定为 1：`srcs/xx_lsu_top.sv:5137`，因此 `srcs/xx_lsu_ld_ag.sv:2486-2493` 的 boundary acceleration 永久关闭。若这是当前产品配置，应以参数/注释明确；若仍计划启用，则是接线错误。

仓库已经提供 `xx_lsu_ctrl`，但仍没有以下 helper 的定义：`gated_clk_cell`、`xx_lsu_compare_iid`、`xx_lsu_vmask_gen`、`xx_lsu_us_bytes_gen`、`xx_lsu_vreg_mask`、`xx_lsu_ld_vreg_rot`，以及 top 中的其他部分模块。当前环境也没有完整宏/include 与工程 filelist。因此：

- 本报告完成的是源码级 named-port、宽度表达式和语义链检查；
- 不能把“named-port 集合一致”解释为完整 elaboration/compile 已通过；
- helper 模块端口宽度、宏展开值、clock-cell 版本和完整跨模块时序仍需在工程环境中编译确认。
- controller 还接收 `lsag0/lsag1` 的 restart bitmap，但对应 store-AG 源码未提供；RR-13 的同类缺口只能在已提供的 load-AG 路径上确认，store 两路需要在完整工程中复查同一所有权不变量。

## 5. 已确认合同与仍需回答的问题

已由 README 确认并应转成 assertion/配置检查的合同：

1. 目标集成中 `mmu_lsu_stall==0`。
2. access fault 在请求后一拍返回。
3. `mmu_lsu_page_fault |-> mmu_lsu_pa_vld`，且两者同拍。
4. fresh 请求进入 AG 前，LRQ `no_space` 已保证本 lane 有可创建 entry。
5. `already_da/spec_fail/unal2nd` 的 replay 状态由 LRQ 而非 IDU 提供。

仍需设计方回答：

1. MMU 请求的正式 accept 条件是什么？`va/id/lsid/st_inst` 在接受前后各需稳定多久？
2. MMU 接受 miss 后，`lsu_mmu_abort` 是否可能追溯取消该 pending 项？
3. RR-13 场景中，为什么 MMU 已持有 miss 时 fresh LRQ entry 仍允许 `create_frz=0`？是否存在未提供的仲裁合同，能阻止其在 wakeup 前 replay？
4. MMU async wakeup 的最短延迟是多少？能否与 LRQ create 同拍？flush 如何取消 pending lsid，如何防止旧 wakeup 命中复用 bit？
5. create 与 full/partial flush 同拍时，IDU 是否明确忽略 raw pop？为什么 allocation 与 pop 不共享同一 `create_accept`？
6. replay 时哪些字段允许不保存？请特别确认 `inst_ldr`、`no_spec`、VL、vmask、vector mask source 和 debug halt info。
7. `no_spec_exist` 的 IDU predictor 语义与 LRQ 内部 `no_spec_chk` 是否应为两个独立状态？
8. 是否明确只支持 `LRQENTRY==LSIQENTRY`、`PC_LEN==15`、`VMBENTRY==8` 和 9-bit split number？
9. `dcache_arb_lag_ex1_sel` 表示真正接受还是仅表示仲裁选择？D-cache 投机读是否保证完全无副作用？
10. `pfu_part_empty=0` 是否只是临时 bring-up tie-off？恢复真实 empty 时，谁负责补齐 VMB1、VB、store-DA 和 LRQ create 等 special-clock enable？

## 6. 建议修复顺序

1. 先修复/证明 RR-13：MMU accepted miss 与 LRQ ready 必须互斥；再关闭 RR-14 的 create/wakeup/flush/reuse 合同。
2. 确认 RR-01 的 no-spec predictor/wait-state 合同；若两者语义独立，则拆分并完整保存 predictor metadata 与 LRQ wait 状态，否则删除/约束失效输入并证明其不可观察。
3. 补齐 RR-02/RR-03 的 replay metadata，先保证 valid payload 无 X、无跨事务取值。
4. 统一 RR-08 的 LRQ create/accept/pop 事件，给 flush 并发加断言。
5. 修复 RR-15 的 special-clock tie-off/enable 集合，并执行真实门控回归。
6. 添加参数静态限制或完成全链路参数化。
7. 在完整工程环境执行 elaboration、lint、X-prop、形式断言和端到端回归。

本次任务仅形成审查文档，没有修改提供的 RTL。
