# `xx_lsu_ld_da` 详细设计风险审查

## 1. 审查范围与总判断

本报告按 README Interaction 1.4 第 6 点重新生成，目录严格使用 `doc-da/`，并在 Interaction 1.5 提交 `443384a` 上继续复核。审查对象是标量 load lane 的 `srcs/xx_lsu_ld_da.sv`；`srcs/xx_lsu_ls_ld_da.sv` 仅作为 LSDA 对照实现，不能替代标量模块的结论。

审查覆盖 DC→DA EX3 保持、D-cache/TCM/SQ/WMB 数据选择、ECC stall/replay、RB create/merge、completion/data writeback、LQ/LRQ 生命周期、vector/FOF、prefetch/no-spec 与 debug cancel。仓库没有 testbench、宏定义头文件和完整 elaboration filelist，因此结论来自静态数据流与跨模块接口复核，不声称已经完成动态签核。

| ID | 优先级 | 状态 | Interaction 1.5 结论 |
|---|---:|---|---|
| DA-RR-01 | P1 | **源码已修，待动态回归** | 标量 `lda_rb_ex3_data_ori3` 已改为 `data3`；原问题会破坏架构 512-bit load 数据，故历史优先级从 P2 改为 P1 |
| DA-RR-02 | P2 | **仍开放待规格/互斥证明** | SQ-forward ECC discard 仍永久 tie 0，与同处注释描述的策略相反 |
| DA-RR-03 | P2 影响 | **未发现具体 bug，转为验证义务** | EX3 stall 保持、RB 资格化与 restart 路径不要求 RTL epoch；保留 live IID 的 accept-or-restart 检查 |
| DA-RR-04 | P2 | **仍开放待副作用合同** | debug address halt 已屏蔽主要功能 side effect，但 prefetch/no-spec 辅助输出未统一使用 cancel 后信号 |
| DA-RR-05 | P3 | **清理项** | wildcard-X 与宽度不匹配写法仍在，影响 lint/X-prop 可判定性 |

## 2. 流水与数据所有权

DA 在 `lda_ecc_stall` 时保持当前 EX3 事务，否则只在 `ldc_lda_ex2_inst_vld` 下接收新事务（`srcs/xx_lsu_ld_da.sv:1969-2012`）。用于 RB 延迟保存的四块数据分别写入 `ld_da_data_ff/1/2/3`（`srcs/xx_lsu_ld_da.sv:3385-3403`），输入也分别来自 `lda_lwb_ex3_data0/1/2/3`（`srcs/xx_lsu_ld_da.sv:3420-3427`）。因此四块数据在保存点仍保持独立身份。

completion 与 data request 分开资格化：completion 检查 exception、vector-nop、FOF、AMO/LR、ECC、restart 与 boundary（`srcs/xx_lsu_ld_da.sv:4948-4977`）；data request 另外检查真实数据有效、forward/discard、flush 与 data-check（`srcs/xx_lsu_ld_da.sv:4979-5024`）。`req -> dp -> gateclk_en` 在合法输入下成立，但 `dp && !req` 是设计允许的保守仲裁状态，必须配套活性验证。

## 3. 详细风险

### DA-RR-01：标量 DA 的 ECC replay 第 4 块误接已修复

**源码事实。** 正常保存路径把 `data2` 和 `data3` 分别保存到 `ld_da_data_ff2`、`ld_da_data_ff3`（`srcs/xx_lsu_ld_da.sv:3399-3402`）。Interaction 1.5 已把 replay 重组的 `data_ori3` 从错误的 `lda_lwb_ex3_data2` 改为对应的 `lda_lwb_ex3_data3`（`srcs/xx_lsu_ld_da.sv:3435-3438`），标量路径与两个 LSDA 对照路径恢复一致。

**修改核对。** `git diff 013c366..443384a -- srcs/xx_lsu_ld_da.sv` 只包含该处 `data2 -> data3` 修正，没有依赖其他隐含变化。源码级错误已关闭，但仓库没有可执行回归，不能把 source-fixed 等同于动态 sign-off。

**回归序列。** 让四个 128-bit 区块为互异花纹 `A/B/C/D`，对需要保留四块数据的 unit-stride load 注入可恢复 ECC stall；首拍保存 `A/B/C/D`，replay 拍 `lda_ecc_stall_already=1` 时 RB 必须仍看到 `A/B/C/D`。只用全零、全一或 `C==D` 的数据会掩盖历史问题。

**优先级说明。** 修复前 replay 后创建/更新 RB 会使 bits `[511:384]` 被 `[383:256]` 复制，这是可达的架构数据完整性错误。缺陷是否来自一行笔误、修复是否简单，都不降低其影响；因此 DA-RR-01 应从 P2 改为 P1 历史缺陷。

**关闭条件。** 以四块互异花纹对标量 lane 与两个 LSDA lane 做 ECC replay 等价回归；源码修复已完成，回归零失败后最终关闭。

### DA-RR-02：SQ forward 与 ECC replay 的冲突策略仍被关闭

源码注释说明 WMB forward 可以随 ECC stall 保持，而 SQ 不支持 partial forward，应取消/丢弃该次 ECC stall；紧随其后的原策略却被注释，`ld_da_sq_fwd_ecc_discard` 固定为 0（`srcs/xx_lsu_ld_da.sv:4726-4739`）。该信号又参与 RB create/merge、completion/data request 和 IDU wait-old 资格化，所以 tie 0 使整条 discard/reissue 分支失效。

如果架构合同保证 `lda_ecc_stall_already` 与 `ld_da_fwd_sq_vld || ld_da_fwd_sq_bypass` 永不同时出现，应以正式 assertion 固化；否则需恢复 discard/reissue 策略，并证明 cache 修正数据不会与不同 owner 的 SQ 数据合并。仅凭当前源码不能在两种解释中选择一种。

### DA-RR-03：保存数据与 RB 接受的 live-transaction 原子性

DA 在 `ld_da_data_delay_vld` 下保存 live EX3 事务数据（`srcs/xx_lsu_ld_da.sv:3385-3415`），而 RB create 由 `ld_da_rb_create_vld_unmask` 再经过 ECC mask 与 index-discard 形成（`srcs/xx_lsu_ld_da.sv:3515-3543`、`3597-3605`）。EX3 在 ECC stall 时保持、不接收新事务（`srcs/xx_lsu_ld_da.sv:2408-2478`）；full/index 冲突进入 restart（`srcs/xx_lsu_ld_da.sv:3771-3798`、`4601-4603`）。三个 lane 都采用 `judge/dp/real-create` 分层，RB allocator 以 pointer/full 防止低优先级成功项锁存高优先级 payload。

Interaction 1.5 将本项类比为“没有 epoch”。这里不需要给 RTL 增加 epoch：只要 EX3 保持期间 IID/payload 稳定，RB 接收或 restart 都针对该 live transaction，就不存在旧事务复用。当前源码没有发现零接收或双收的具体反例，本项从设计 bug 降为验证义务。验证环境仍应用 `{lane,IID,observer_generation}` 检查 accept-or-restart 恰好一次；observer generation 只是 scoreboard 键，不是 RTL 必需字段。

### DA-RR-04：debug halt 对辅助副作用的资格化不统一

`dtu_lsu_addr_halt_info[0]` 已并入 `ld_da_expt_ori_cancel` 与 `ld_da_expt_vld_cancel`（`srcs/xx_lsu_ld_da.sv:5413-5420`），主要 RB/WB/功能 side effect 多数使用 cancel 后信号屏蔽。但 prefetch 输出仍以原始 `ld_da_expt_ori` 为主（`srcs/xx_lsu_ld_da.sv:4901-4922`），no-spec 检查、训练与预测统计也没有统一检查 debug cancel（`srcs/xx_lsu_ld_da.sv:5322-5372`）。

这不必然是架构错误：实现可以允许被 halt 指令保留部分非架构训练副作用。但必须书面列出允许保留的 prefetch/no-spec/HPCP 事件；对要求精确停止的事件，应统一使用 cancel 后信号。没有该合同前，本项不能关闭。

### DA-RR-05：wildcard-X 与宽度不匹配降低可验证性

`casez` 中使用 `2'b??` 覆盖非向量分支（`srcs/xx_lsu_ld_da.sv:3495-3496`），另有把 `256'b0` 赋给更窄目标的写法（`srcs/xx_lsu_ld_da.sv:5250-5251`）。综合后的合法输入可能没有功能差异，但 X-prop/lint 会更难区分非法编码与 don't-care。建议按目标宽度显式赋零，并为非法 `vmew/rot_sel` 增加 assertion。

## 4. 已排除或已缩小的场景

1. DC 的 ahead-WB valid 不会绕过 restart 直接进入 DA，因为 DA 锁存仍由 `ldc_lda_ex2_inst_vld` 资格化。
2. 可见标量 DA 的 LQ restart-pop、LRQ already-da/pop/spec-fail/secd 都来自 live `lda_ex3_inst_vld` 与已保存 pointer/LSID（`srcs/xx_lsu_ld_da.sv:4873-4877`、`5167-5223`）；full/check flush 清 DA valid 后，没有发现本模块自行产生迟到旧 bitmap。
3. LFB/SQ/WMB/MMU producer 均在 `rtu_ck_flush` 拍发送并清空已保存 wakeup bitmap，full flush 则直接清空，因此 DA-RR-03 的剩余重点是 live IID 的 RB accept identity，而不是要求增加硬件 epoch。

## 5. 关闭条件与还需补充的信息

DA 签核前至少需要：

1. 标量 `lda_rb_ex3_data_ori3` 已修到 `data3`；仍需提供四块互异数据的 ECC replay 波形或回归结果，完成 DA-RR-01 动态关闭。
2. 给出 SQ-forward 与 ECC 的互斥规格；若不互斥，给出 discard/reissue 的正式时序。
3. 提供可绑定的 RB accept/restart identity 或 testbench scoreboard 接口；不要求 RTL 增加 epoch 字段。
4. 明确 debug halt 对 prefetch、no-spec、HPCP 训练/计数的允许副作用集合。
5. 提供宏定义头文件、`gated_clk_cell`/helper RTL、完整 filelist 与 testbench，以进行 elaboration、lint、X-prop 和动态回归。
