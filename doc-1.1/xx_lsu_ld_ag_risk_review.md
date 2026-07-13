# `xx_lsu_ld_ag` 设计风险与例化连线审查

## 1. 审查范围与结论

本次审查基于仓库提交 `ec421e9`，重点阅读了：

- `srcs/xx_lsu_ld_ag.sv`
- `srcs/xx_lsu_lrq.sv`
- `srcs/xx_lsu_lrq_entry.sv`
- `srcs/xx_lsu_top.sv`
- `srcs/xx_lsu_ld_dc.sv`
- `srcs/xx_lsu_ld_da.sv`
- 基线文件 `srcs/ct_lsu_ld_ag.v`

结论如下：

1. 确认 fresh-IDU 的 `no_spec_exist` 输入被丢弃、replay 的 `no_spec` 为 `X`；前者的功能影响仍取决于新 no-spec 接口语义，后者属于有效路径 X 风险。
2. 找到 2 组高置信 replay 元数据问题：若干仍被 AG 使用的字段在 replay 时为 `X`，调试 `halt_info` 则错误地取自当前 IDU 总线。
3. 找到多项依赖 MMU、D-cache、LRQ 接口时序约定的 P1 风险。它们是否必然成为硅后 bug，取决于当前代码没有给出的接口合同；必须由设计方确认并用断言固化。
4. 对 `xx_lsu_ld_ag` 顶层实例的 258 个 named port 做了集合检查，未发现漏接、多接或重复端口；但存在参数宽度耦合、无效输入和疑似跨 lane 命名笔误。

优先级定义：

- **P1**：可能导致错误执行、异常丢失、事务永久等待或关键预测状态破坏，流片前必须关闭。
- **P2**：特定功能、调试、非默认参数或低概率并发条件下错误，应在完整回归前关闭。
- **P3**：当前默认路径未必出错，但存在死代码、X 扩散或可维护性问题。

置信度定义：

- **已确认**：仅由当前 RTL 即可证明数据被丢失、取错事务或在有效路径上传播 `X`。
- **高置信**：问题机制明确，但最终架构影响还依赖后级或缺失 helper 模块。
- **合同依赖**：只有在某种合法上游时序下触发；必须先确认接口合同。

## 2. 风险汇总

| ID | 优先级 | 置信度 | 风险摘要 |
|---|---:|---|---|
| RR-01 | P1 | 高置信/合同依赖 | fresh `no_spec_exist` 被丢弃，LRQ 字段又承载内部 no-spec wait 状态 |
| RR-02 | P1 | 高置信 | replay 时 `inst_ldr`、向量 VL/mask 等仍被使用的字段为 `X` |
| RR-03 | P2 | 已确认 | replay 的调试 `halt_info` 取自当前 IDU 指令，而不是被 replay 的指令 |
| RR-04 | P1 | 合同依赖 | `mmu_lsu_stall` 未按本端 valid 限定，空闲期可能制造“幽灵”AG 指令 |
| RR-05 | P1 | 合同依赖 | 首个 backpressure 周期的一拍 `access_fault` 可能丢失 |
| RR-06 | P1 | 合同依赖 | MMU not-ready 与结构 backpressure 同拍会被记成 TLB miss，恢复依赖缺失源码的 controller |
| RR-07 | P2 | 合同依赖 | page fault 只有与 `mmu_lsu_pa_vld` 同拍才会被识别和保存 |
| RR-08 | P2 | 合同依赖 | AG→LRQ create 没有 ready/accept；LRQ 分配与 LSIQ pop 的资格条件不一致 |
| RR-09 | P2 | 合同依赖 | fresh-IDU 的 `already_da/spec_fail/unal2nd` 九个 top 输入完全未使用 |
| RR-10 | P2 | 已确认 | 非默认参数下 LRQ ID、PC、VMB ID、split number 存在截断/扩展风险 |
| RR-11 | P2 | 合同依赖 | D-cache 请求允许在 PA 无效、非 cacheable 或 fault 未决时投机发出 |
| RR-12 | P3 | 已确认 | LRQ PA/属性复用路径当前失活，且一个组合 case 缺少 default |

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

### RR-04：空闲期 `mmu_lsu_stall` 可能制造幽灵 valid

**证据**

- `mmu_lsu_stall` 直接成为 `ld_ag_mmu_stall_req`：`srcs/xx_lsu_ld_ag.sv:2765`。
- 它进入 `lag_ex1_stall_ori` 和 `ld_ag_stall_vld` 时没有 `lag_ex1_inst_vld` 或 `lsu_mmu_va_vld` 资格：`srcs/xx_lsu_ld_ag.sv:2799-2811`。
- 控制寄存器看到 `ld_ag_stall_vld=1` 后会把 `lag_ex1_inst_vld` 置为 1：`srcs/xx_lsu_ld_ag.sv:1074-1087`。

**触发方式**

若 MMU miss queue 满时允许全局拉高 `mmu_lsu_stall`，即使该 load 端口当前没有请求，并且该周期 `ctrl_ld_clk` 仍有有效时钟沿，则空 AG、无 RF 发射也能在下一拍得到 `lag_ex1_inst_vld=1`，而数据寄存器没有装入新事务。

**影响**

旧 payload 可能被当作新 load，继而创建 LRQ entry、发 MMU/D-cache 请求或产生提前唤醒。

**安全所需合同/建议**

接口必须保证 `mmu_lsu_stall -> lsu_mmu_va_vld && !lsu_mmu_abort`，或另行证明空闲期 `ctrl_ld_clk` 不会触发且不会造成控制/数据时钟分歧。更稳妥的 RTL 做法是在本地用当前有效请求资格化 stall，并加入“空闲不能产生 stall/valid”的断言。

### RR-05：首次 backpressure 周期的一拍 access fault 可能丢失

**证据**

- `lag_bkcon_stall_already` 在首次 `lag_bkcon_stall_vld` 的时钟沿才置 1：`srcs/xx_lsu_ld_ag.sv:1352-1358`。
- `lag_bkcon_acfault` 只有旧值 `lag_bkcon_stall_already=1` 时才锁存 fault：`srcs/xx_lsu_ld_ag.sv:1361-1367`。
- 组合异常也要求 `lag_bkcon_stall_already=1`：`srcs/xx_lsu_ld_ag.sv:1369-1370`。
- 该结果控制 MMU abort、uTLB miss masking 和异常 valid：`srcs/xx_lsu_ld_ag.sv:2441`、`srcs/xx_lsu_ld_ag.sv:2468-2470`、`srcs/xx_lsu_ld_ag.sv:2699-2703`。

**触发方式**

在 D-cache 未接受 AG 的第一个周期，MMU 同拍仅脉冲一次 `mmu_lsu_access_fault`；下一拍 fault 撤销。

**影响**

该 fault 既未进入 DC，也没有被 AG sticky 保存，事务可能随后被当作普通 miss/replay 处理。

**安全所需合同/建议**

必须确认 MMU 是否保证 fault 保持到 AG 被接受或请求被 abort。若允许一拍响应，应在首个 `lag_bkcon_stall_vld` 周期就捕获，并只在新事务/flush 时清除。

### RR-06：MMU not-ready 与结构 backpressure 可被误记为 TLB miss

**证据与时间线**

1. T0：请求有效并同时遇到 D-cache/结构 backpressure 与 `mmu_lsu_stall=1`；`lag_bkcon_stall_vld` 没有排除 MMU stall：`srcs/xx_lsu_ld_ag.sv:2761-2765`。
2. 同拍 `mmu_lsu_pa_vld=0` 时，时钟沿把 `lag_bkcon_tlbmiss` 置 1：`srcs/xx_lsu_ld_ag.sv:1380-1387`；fresh 请求还会 create 一个 frozen LRQ entry：`srcs/xx_lsu_ld_ag.sv:3030-3035`。
3. T1：`lag_bkcon_tlbmiss` 直接拉高 `lsu_mmu_abort`：`srcs/xx_lsu_ld_ag.sv:2432-2442`。top 只有在 `va_vld && !abort` 时向 MMU 提供 LRQ ID：`srcs/xx_lsu_top.sv:3774`。
4. AG 也生成 `lag_ex1_stall_restart_entry`：`srcs/xx_lsu_ld_ag.sv:2846-2854`，该信号进入缺失定义的 controller：`srcs/xx_lsu_top.sv:12133-12135`；controller 的 wakeup 再回到 LRQ freeze-clear：`srcs/xx_lsu_top.sv:12405`、`srcs/xx_lsu_top.sv:4667`。

**风险**

如果 `mmu_lsu_stall` 表示“请求未 accept”，T0 实际没有 MMU 待完成项，却已建立 frozen LRQ 并记录 tlbmiss；正确恢复完全依赖 controller 在 T1 精确唤醒并重试。如果 stall 仍允许请求入队，则还要确认 T1 abort 是否会追溯取消该项。由于 `xx_lsu_ctrl` 未提供，不能据现有源码断言 deadlock，但“不得丢失、不得重复、最终必须 retry”是 P1 验证点。

**建议**

明确 MMU 的 request-accept 和 abort 时序。结果捕获最好使用显式 `mmu_accept/response_valid`，不要把 `!pa_vld` 在 MMU not-ready 周期直接当作 tlbmiss；同时断言该并发序列最终只 retry 一次，且 controller freeze-clear 与同一 LRQ ID 对齐。

### RR-07：page fault 依赖与 `pa_vld` 同拍的接口合同

**证据**

backpressure 捕获条件要求 `mmu_lsu_page_fault && mmu_lsu_pa_vld` 同拍成立：`srcs/xx_lsu_ld_ag.sv:1371-1378`；直接 page-fault 输出也使用相同资格：`srcs/xx_lsu_ld_ag.sv:2677-2679`。若 `page_fault=1` 但 `pa_vld=0`，该周期会更像普通 uTLB miss，fault 本身不会被保存。

**触发方式**

MMU 用一拍 `page_fault=1, pa_vld=0` 表示 fault，下一拍两者都撤销。

**建议**

必须确认 MMU 是否保证 page fault 与 `pa_vld` 同拍。若保证，当前已捕获的 fault 会在下一拍通过 `lsu_mmu_abort` 阻止 `lag_bkcon_stall_vld` 再次更新，因此不会被后续 stall 覆盖；若不保证，应增加独立 fault-valid/response-valid 资格，而不是把 fault 和 PA valid 绑定。

### RR-08：LRQ create、实际分配和 LSIQ pop 的条件不一致

**证据**

- AG 的 `lsu_lrq_create_vld` 只按 AG valid、非 replay 和去重状态生成，没有 ready/accept 或 flush 资格：`srcs/xx_lsu_ld_ag.sv:3030-3035`。
- LRQ 的 `lrq0_create_success` 会额外屏蔽 full flush/partial flush，但不显式检查 full：`srcs/xx_lsu_lrq.sv:1443-1452`。
- 对 IDU 的 pop valid 却直接使用原始 `lsu0_lrq_create_vld`，而不是 `lrq0_create_success`：`srcs/xx_lsu_lrq.sv:1692-1693`。
- 容量侧已有缓解：每条 lane 有独立的 free pointer：`srcs/xx_lsu_lrq.sv:1411-1441`，`lrq*_no_space` 和 issue gating 会阻止 full/保留阈值下的新 fresh-IDU 请求进入：`srcs/xx_lsu_lrq.sv:1443-1470`、`srcs/xx_lsu_lrq.sv:1628-1683`。三 lane 同拍 create 不竞争同一个 pointer。

**风险场景**

- create 与 full/partial flush 同拍：LRQ 不分配，但 IDU pop 仍拉高。
- 如果 lane 内容量预留不变量被上游并发或时序破坏，full 时 free pointer 为全 0，而 AG 没有 accept 反馈，仍可能认为 entry 已创建。

容量侧有明确 gating，剩余合同是“进入 AG 的请求一定已经预留 entry”以及“IDU 在 flush 周期是否忽略 raw pop”。

**建议**

统一定义 `create_accept = create_vld && has_entry && !flush_kill`，分配、LSIQ pop、MMU lsid 和 AG `create_already` 都使用同一个 accept 事件。除 one-hot pointer 外，还应分别断言 allocation、pop 和 `create_already` 只由同一个 accept 触发，并显式排除 full/partial-flush kill。

### RR-09：三路 fresh-IDU 状态输入被完全丢弃

**证据**

top 声明了三路 `already_da/spec_fail/unal2nd` 输入：

- lane0：`srcs/xx_lsu_top.sv:129`、`srcs/xx_lsu_top.sv:156`、`srcs/xx_lsu_top.sv:163`
- lane2：`srcs/xx_lsu_top.sv:175`、`srcs/xx_lsu_top.sv:202`、`srcs/xx_lsu_top.sv:209`
- lane3：`srcs/xx_lsu_top.sv:235`、`srcs/xx_lsu_top.sv:262`、`srcs/xx_lsu_top.sv:269`

这些名称在 top 中只有声明，没有实例连接；LRQ 也没有对应 IDU 输入端口。fresh-IDU mux 对应字段全部置 0，pipe0 见 `srcs/xx_lsu_lrq.sv:1781`、`srcs/xx_lsu_lrq.sv:1803`、`srcs/xx_lsu_lrq.sv:1812`，pipe2/3 同样处理。

pipe0 输出进入 AG：`srcs/xx_lsu_top.sv:5164`、`srcs/xx_lsu_top.sv:5189`、`srcs/xx_lsu_top.sv:5196`，并在 `srcs/xx_lsu_ld_ag.sv:1187-1189` 锁存。`spec_fail` 会在 DC 参与判断：`srcs/xx_lsu_ld_dc.sv:1784-1786`。

**判断**

“输入数据被丢弃”是确定事实；是否为功能 bug 取决于新架构是否规定所有 fresh 请求这三位必须为 0、状态只由 LRQ 内部产生。若该规定成立，应删除 top 死端口并添加输入恒 0 的接口断言；否则应把输入加入 LRQ mux。

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
2. `lag_ldc_ex1_bytes_vld1` 的 `always @* casez` 没有 default：`srcs/xx_lsu_ld_ag.sv:2158-2167`。二值输入组合被覆盖，但 X-prop 仿真遇到未知控制位时会保留旧值，而相邻 `bytes_vld` 逻辑有明确 default：`srcs/xx_lsu_ld_ag.sv:2137-2146`。建议补 default 或改成完整的组合赋值。

## 4. 模块例化与连线检查

### 4.1 named-port 集合检查

对 top 中完整实例进行静态解析，结果如下：

| 模块 | formal 数 | 实例连接数 | 缺失 | 未知 | 重复 named port |
|---|---:|---:|---:|---:|---:|
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
- **合同依赖**：RR-09 的九个 top 输入为死接口。
- **疑似命名/连线笔误**：`srcs/xx_lsu_top.sv:4837` 把 `.lsu3_lrq_exx_sq_not_full` 接到 `lsu2_lrq_exx_sq_not_full`；独立声明的 lane3 信号在 `srcs/xx_lsu_top.sv:3815` 没有使用。若 SQ-not-full 本来是全局状态，建议改成 lane-neutral 名称；若应按 lane 区分，则该连接是明确笔误。

### 4.3 静态检查边界

另有三项低风险的死接口/固定配置需要设计方确认：

- `cp0_lsu_nsfe` 已由 top 接入：`srcs/xx_lsu_top.sv:5143`，但 AG 内除端口声明 `srcs/xx_lsu_ld_ag.sv:357` 外没有使用；当前 no-spec 建项检查只能依赖上游已把相关 hit 信号关闭。
- `sfp_hit_no_spec_tbl` 在 top 被固定为 0：`srcs/xx_lsu_top.sv:5217`，AG 内除声明 `srcs/xx_lsu_ld_ag.sv:432` 外没有使用，属于残留接口。
- `cp0_lsu_cb_aclr_dis` 在 top 固定为 1：`srcs/xx_lsu_top.sv:5137`，因此 `srcs/xx_lsu_ld_ag.sv:2486-2493` 的 boundary acceleration 永久关闭。若这是当前产品配置，应以参数/注释明确；若仍计划启用，则是接线错误。

仓库没有提供以下实例的定义：`gated_clk_cell`、`xx_lsu_compare_iid`、`xx_lsu_vmask_gen`、`xx_lsu_us_bytes_gen`、`xx_lsu_vreg_mask`、`xx_lsu_ld_vreg_rot` 以及 top 中的部分 controller/helper。当前环境也没有 Verilator、Icarus、Slang、Surelog 或 svlint。因此：

- 本报告完成的是源码级 named-port、宽度表达式和语义链检查；
- 不能把“258 个端口集合一致”解释为完整 elaboration/compile 已通过；
- helper 模块端口宽度、宏展开值、clock-cell 版本和完整跨模块时序仍需在工程环境中编译确认。

## 5. 需要设计方回答的接口问题

1. `mmu_lsu_stall` 是否保证只在本端 `lsu_mmu_va_vld=1` 且请求尚未接受时有效？
2. MMU 请求的正式 accept 条件是什么？`va/id/lsid/st_inst` 在未 accept 时需要保持多久？
3. `mmu_lsu_pa_vld/pa/attrs/page_fault/access_fault` 是组合值、一拍脉冲，还是保持到 AG/DC 接受？
4. `mmu_lsu_page_fault` 是否保证与 `mmu_lsu_pa_vld` 同拍？
5. `lsu_mmu_abort` 会不会取消上一拍已经进入 miss queue 的请求？
6. immediate wakeup 能否与 LRQ create 同拍？full/partial flush 后如何防止旧 wakeup 命中新复用的 LRQ bit？
7. LRQ create 为什么没有 ready/accept？谁保证 create 时 free pointer 必为 one-hot？
8. replay 时哪些字段允许不保存？请特别确认 `inst_ldr`、`no_spec`、VL、vmask、vector mask source 和 debug halt info。
9. `no_spec_exist` 的 IDU predictor 语义与 LRQ 内部 `no_spec_chk` 是否应为两个独立状态？
10. fresh-IDU 的 `already_da/spec_fail/unal2nd` 是否按新协议恒为 0？若是，为何仍保留 top 输入？
11. 是否明确只支持 `LRQENTRY==LSIQENTRY`、`PC_LEN==15`、`VMBENTRY==8` 和 9-bit split number？
12. `dcache_arb_lag_ex1_sel` 表示真正接受还是仅表示仲裁选择？D-cache 投机读是否保证完全无副作用？
13. `mmu_lsu_stall=1`、结构 backpressure 与 `mmu_lsu_pa_vld=0` 能否合法同拍？若能，谁负责清除新建 LRQ entry 的 freeze，怎样保证同一 LRQ ID 最终只 retry 一次？

## 6. 建议修复顺序

1. 先确认 RR-01 的 no-spec predictor/wait-state 合同；若两者语义独立，则拆分并完整保存 predictor metadata 与 LRQ wait 状态，否则删除/约束失效输入并证明其不可观察。
2. 补齐 RR-02/RR-03 的 replay metadata，先保证 valid payload 无 X、无跨事务取值。
3. 明确 MMU accept/stall/abort/response-hold 合同，再关闭 RR-04～RR-07。
4. 统一 LRQ create/accept/pop 事件，给极限占用和 flush 并发加断言。
5. 添加参数静态限制或完成全链路参数化。
6. 在完整工程环境执行 elaboration、lint、X-prop、形式断言和端到端回归。

本次任务仅形成审查文档，没有修改提供的 RTL。
