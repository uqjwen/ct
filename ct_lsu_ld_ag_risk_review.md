# `ct_lsu_ld_ag` 设计风险与潜在 Bug 审阅

## 1. 审阅范围与结论口径

- 审阅对象：`ct_lsu_ld_ag.v`，1462 行，SHA-256 `7c62256e615d66ed54bf96e10373e2636206832cc33d5749e789257f9bb8a010`。
- 上游对照：本文件与 XuanTie OpenC910 `main` 分支中的同名文件逐字节一致：<https://github.com/XUANTIE-RV/openc910/blob/main/C910_RTL_FACTORY/gen_rtl/lsu/rtl/ct_lsu_ld_ag.v>。
- “风险”不等于“已确认 Bug”。本文把问题分为：RTL 内部可直接证明的问题、依赖接口契约的集成风险、可维护性/可验证性风险，以及需要设计方确认的问题。
- 严重度含义：P0 = 可能导致体系结构错误且易触发；P1 = 满足特定协议条件时可能导致功能错误；P2 = 主要影响鲁棒性、X 传播、性能或后续维护；P3 = 清理项或低风险疑点。

## 2. 风险摘要

| ID | 严重度 | 类型 | 摘要 | 当前判断 |
|---|---|---|---|---|
| R1 | P1 | 集成协议 | `mmu_lsu_stall0` 未由 `ld_ag_inst_vld` 门控，若空闲期拉高可能制造“幽灵”有效指令 | 上游当前 DUTLB 将该信号常置 0；模块复用/接口演进时有风险 |
| R2 | P1 | 功能/性能 | `ld_ag_ahead_predict` 带 TODO 且恒为 1，所有合格 load 都按可三拍回写预测 | 需要确认后级取消/回放是否覆盖所有误预测 |
| R3 | P1 | 集成协议 | DCACHE tag/data array 请求不等待 PA 有效、cacheable 属性或异常结果 | 可能是有意投机读；必须验证无效读不会提交或污染状态 |
| R4 | P1 | 异常协议 | 聚合 `ld_ag_expt_vld` 不包含 `ld_ag_expt_ldamo_not_ca` | 下级另行锁存专用异常；仍需确认所有消费者不会只看聚合异常 |
| R5 | P1 | 边界访问 | `ld_ag_acclr_en` 与真正下传的 `ld_ag_dc_acclr_en` 条件不同，但 load-valid 判定使用前者 | MMU 无效/非 cacheable 情形可能出现分类不一致 |
| R6 | P2 | 位宽契约 | 7 位 `idu_lsu_rf_pipe3_vreg` 仅保存低 6 位，随后最高位固定补 0 | 若 bit 6 有编码意义会发生别名；若保留位则应写入接口规范 |
| R7 | P2 | 编码鲁棒性 | `idu_lsu_rf_pipe3_shift` 被当成 one-hot 使用，但没有合法性检查 | 多热/全零会生成错误 offset，而不是选择单一移位量 |
| R8 | P2 | X 传播 | `ld_ag_base`、`ld_ag_offset` 等关键数据寄存器无复位，空闲期多个组合输出可为 X | 依赖 valid 门控；仿真、形式验证和低功耗集成需约束 |
| R9 | P2 | 属性有效性 | `page_ca/page_so` 由 `pa_vld` 门控，而 `page_buf/sec/share` 未门控 | 无效翻译周期的属性语义不一致，消费者必须严格按 valid 采样 |
| R10 | P2 | 时钟/时序 | valid 使用 `ctrl_ld_clk`，数据使用门控 `ld_ag_clk` | 两个时钟的相位/使能一致性是关键集成假设 |
| R11 | P2 | 地址协议 | MMU 请求地址为 `ld_ag_base`，页内偏移来自最终 `ld_ag_va` | 设计依赖“基址与最终 VA 同页；跨页先重放”的契约 |
| R12 | P3 | 无效态语义 | `ld_ag_dc_mmu_req = !lsu_mmu_abort0`、`ld_ag_utlb_miss = !pa_vld` 均未由指令 valid 门控 | 单独观察时空闲态可能为 1；目前 DC 只在 AG valid 时锁存 |
| R13 | P3 | 死代码/漂移 | 大段 vector mask 逻辑只剩工具标记，多项功能恒 0；QWORD 分支不可由 2 位 size 到达 | 容易让规格与实现误判，建议明确裁剪范围 |

## 3. 详细发现

### R1 - MMU stall 未门控可能在空闲期制造有效指令（P1）

**代码证据**

- `ld_ag_mmu_stall_req = mmu_lsu_stall0`：L1285。
- `ld_ag_stall_vld` 可由该信号形成：L1298-L1316。
- AG valid 寄存器在 `ld_ag_stall_vld` 为 1 时无条件置 1：L582-L591；条件中没有要求旧的 `ld_ag_inst_vld` 为 1。

**触发条件**

AG 空闲、RF 没有新指令，同时 `mmu_lsu_stall0=1`，且 `ld_ag_stall_mask=0`。

**潜在影响**

下一个 `ctrl_ld_clk` 周期 `ld_ag_inst_vld` 可能从 0 变为 1，但数据寄存器没有装入新指令，形成陈旧/X 数据对应的“幽灵”load。

**缓解证据与剩余风险**

OpenC910 当前 `ct_mmu_dutlb_read.v` 明确 `assign mmu_lsu_stall_x = 1'b0;`，所以原集成中该路径不可触发。风险出现在模块独立验证、MMU 替换或接口演进后。

**建议验证**

定向强制 `mmu_lsu_stall0=1` 且 `ld_ag_inst_vld=0`、`idu_lsu_rf_pipe3_sel=0`，检查下一周期 valid 是否错误拉高。建议断言：

```systemverilog
assert property (@(posedge ctrl_ld_clk) disable iff (!cpurst_b)
  !$past(ld_ag_inst_vld) && !$past(idu_lsu_rf_pipe3_sel)
  |-> !ld_ag_inst_vld);
```

若协议保证空闲时 stall 恒 0，应把该保证写成 assume/assert 并纳入接口规格。

### R2 - ahead prediction 恒为 1（P1）

**代码证据**

- L1355 保留 TODO：“predict result for 3 write back”。
- L1357 将 `ld_ag_ahead_predict` 常置 1。
- L1364-L1368、L1423-L1426、L1434-L1438 使用它生成 ahead/load valid。

**潜在影响**

所有满足其他条件的 load 都被预测为可提前回写。如果 cache miss、TLB miss、bank conflict、异常或转发冲突的取消/回放不完整，可能造成过早唤醒依赖指令；即使功能正确，也会增加回放或错误唤醒压力。

**建议验证**

覆盖 cache hit/miss、uTLB miss、page fault、边界访问、DA forwarding disable、vector load，并证明每个误预测都在依赖者消费数据前被取消。建议由设计方说明真正的预测器是否在其他模块实现，或该常量是否是固定的体系结构策略。

### R3 - DCACHE 阵列请求是投机的（P1，协议依赖）

**代码证据**

- L1128-L1129 的请求只由 `ld_ag_inst_vld && cp0_lsu_dcache_en` 产生。
- 被注释掉的条件包括 `!ld_ag_expt_vld`、`ld_ag_page_ca`、`mmu_lsu_pa0_vld`：L1130-L1133。
- tag/data index 直接来自 `ld_ag_pa`：L1138、L1189-L1190。

**潜在影响**

在翻译尚未有效、页属性为 non-cacheable 或异常成立时仍可能读取阵列；若 PA 高位无效/陈旧，可能造成无意义切换、X 扩散，或在下游门控不严时污染比较/命中结果。

**建议验证**

对 `pa_vld=0`、page fault、SO/non-cacheable、reset release 后首条访问分别检查：阵列可被读，但不得产生 architectural hit、数据转发、替换状态或异常提交。功耗验证应统计这类投机访问是否符合预算。

### R4 - LDAMO non-cacheable 异常未并入聚合异常（P1，消费者依赖）

**代码证据**

- 专用异常 `ld_ag_expt_ldamo_not_ca` 在 L1221-L1223 产生。
- 聚合 `ld_ag_expt_vld` 仅 OR misalign、access-fault-with-page 和 page-fault：L1238-L1241。
- 上游 `ct_lsu_ld_dc.v` 会在 AG valid 时单独锁存 `ld_ag_expt_ldamo_not_ca`，说明它可能有独立处理路径。

**潜在影响**

任何只根据 `ld_ag_expt_vld` 取消请求或阻止 ahead 行为的消费者都不会看到该异常。

**建议验证**

构造 AMO 到 non-cacheable 页，追踪 AG、DC、DA、WB 各级：异常必须精确提交，且不得形成可见 cache/总线副作用。列出所有 `ld_ag_expt_vld` 消费者，确认它们是否还同时检查专用 LDAMO 异常。

### R5 - 边界加速资格与实际使能条件不一致（P1）

**代码证据**

- 预资格 `ld_ag_acclr_en`：L1072-L1078，不含 `mmu_lsu_pa0_vld` 与 `ld_ag_page_ca`。
- 实际下传 `ld_ag_dc_acclr_en`：L1081-L1083，额外要求 PA valid 且 cacheable。
- `ld_ag_dc_load_inst_vld` 的边界过滤使用 `ld_ag_acclr_en` 而不是 `ld_ag_dc_acclr_en`：L1358-L1361。

**潜在影响**

边界 load 在预资格为真、但 MMU 结果无效或 non-cacheable 时，可能仍被归类为普通 load-valid，而实际 128-bit acceleration 未使能。是否出错取决于 DC 阶段如何对 split、MMU miss 和 SO 请求二次分类。

**建议验证**

覆盖 16-byte 边界访问与以下交叉：uTLB miss、page fault、cacheable=0、SO=1、`cp0_lsu_cb_aclr_dis=1`、跨 4 KiB。检查 load/ahead valid、split/restart 和最终字节合并一致。

### R6 - vector register 索引高位被丢弃（P2）

**代码证据**

- 输入 `idu_lsu_rf_pipe3_vreg[6:0]`：L202。
- AG 仅保存 `[5:0]`：L650-L653、L682-L685。
- IDU duplicate 输出重新补零为 7 位：L1440-L1443。

**潜在影响**

若输入 bit 6 区分寄存器组、重命名空间或特殊寄存器，则两个不同编码会在 AG 别名；若 bit 6 保证为 0，则当前实现正确但接口缺少显式约束。

**建议验证**

驱动 bit 6 为 0/1 且低 6 位相同，检查设计方期望。建议增加 `assert (!idu_lsu_rf_pipe3_sel || !idu_lsu_rf_pipe3_vreg[6]);`，或把 AG/输出位宽统一为 7 位。

### R7 - shift 输入依赖 one-hot 合法性（P2）

**代码证据**

L789-L792 使用四个复制掩码后按位 OR，实现 `offset << 0/1/2/3` 的 one-hot 选择；没有 `$onehot`/`$onehot0` 检查。

**潜在影响**

多热时得到多个移位结果的按位 OR，并非任一合法乘法结果；全零时 offset 被清为 0。

**建议验证**

在 RF 接收条件下遍历 16 种 shift 编码。对合法 one-hot 检查 VA；对非法编码明确设计选择：断言禁止、定义优先级或安全回退。

### R8 - 数据寄存器无复位带来的 X 传播（P2）

**代码证据**

`ld_ag_offset[63:32]`、`[31:0]` 与 `ld_ag_base` 的 always 块没有 reset 分支：L728-L751、L771-L777。大量组合输出直接依赖这些寄存器。

**潜在影响**

复位后无有效指令时，VA/PA/index/MMU address 等可能是 X。按有效位采样的同步系统通常可以接受，但门级仿真、X-prop、形式工具或错误的旁路消费者会暴露问题。

**建议验证**

开启 X-prop，在复位释放后保持无指令若干周期，证明任何状态更新、外部请求或 architectural event 都不依赖这些 X。若功耗/DFT 要求确定值，考虑复位或在 valid=0 时钳位输出。

### R9 - 页属性有效性门控不一致（P2）

**代码证据**

- `ld_ag_page_so`、`ld_ag_page_ca` 与 `mmu_lsu_pa0_vld` 相与：L1049-L1051。
- `ld_ag_page_buf/sec/share` 直接传递 MMU 信号：L1052-L1054。

**潜在影响**

同一接口组中，部分属性在翻译无效时强制为 0，部分可能保留组合/陈旧值。消费者若把这些信号视为同等有效，会出现不一致。

**建议验证**

制定统一采样契约：所有页属性仅在 `mmu_lsu_pa0_vld && ld_ag_inst_vld` 时有效；增加接口断言或统一门控。

### R10 - control clock 与 gated data clock 的一致性假设（P2）

**代码证据**

- valid 在 `ctrl_ld_clk` 更新：L582。
- 其余数据在 `ld_ag_clk` 更新；`ld_ag_clk` 由 `forever_cpuclk` 经 local/module/global enable 生成：L551-L560。

**潜在影响**

如果 `ctrl_ld_clk` 和 `forever_cpuclk` 相位、停钟条件或 scan 行为不一致，可能出现 valid 更新但数据未捕获，或数据更新而 valid 未同步。

**建议验证**

由时钟/低功耗规格确认两者关系；进行 ICG enable 边界、全局停钟、scan enable、复位同时变化的时序和门级仿真。断言 valid 接收事件必然伴随数据时钟有效。

### R11 - MMU 只翻译 base page 的设计契约（P2）

**代码证据**

- 最终 VA 为 base 加 offset/offset_plus：L789-L808。
- MMU 接口地址却是 `ld_ag_base`：L1035-L1036。
- PA 由 MMU PPN 与最终 VA 的低 12 位拼接：L1065。
- 跨 4 KiB 时通过 stall/replay 更新 base：L1256-L1282、L773-L776。

**潜在影响**

逻辑依赖跨页检测绝不漏报；否则可能把旧页 PPN 与新页 offset 拼接成错误 PA。

**建议验证**

对正/负 offset、四种 shift、offset_plus、地址回绕、4 KiB 边界两侧逐点验证。形式属性应比较数学上的 `(base + effective_offset)` 页号与实际选择的 MMU 页号/重放行为。

### R12 - 若干输出在空闲态为高（P3）

**代码证据**

- `ld_ag_dc_mmu_req = !lsu_mmu_abort0`：L1345；空闲且无 abort 时为 1。
- `ld_ag_utlb_miss = !mmu_lsu_pa0_vld`：L1056；空闲时通常为 1。
- `ct_lsu_ld_dc.v` 只在 `ld_ag_inst_vld` 时锁存 `ld_ag_dc_mmu_req`，降低了原集成风险。

**建议**

规格中明确这些是“伴随信号”，必须与 valid 一起采样；独立模块验证不要把高电平本身计为请求/事件。

### R13 - 死代码与实现漂移（P3）

**代码证据**

- L986-L1027 的 vector mask 区只剩生成工具标记。
- `ld_ag_inst_vls`、`ld_ag_inst_fof`、`ld_ag_vmb_merge_vld` 恒为 0：L832-L835。
- `ld_ag_dc_vload_ahead_inst_vld` 恒为 0：L1382。
- QWORD 访问大小/forward bypass 分支存在，但 2 位 `ld_ag_inst_size` 只映射到 DWORD：L842-L865、L1089-L1097。
- 参数 `VMB_ENTRY` 在本模块未使用：L539。

**潜在影响**

验证团队可能误以为这些功能可达，产生无效覆盖洞；后续合并 vector 版本时也容易只恢复部分逻辑。

**建议**

在 spec 中把这些项标为“本版本不可达/裁剪”，并对恒定输出建立静态检查。若无恢复计划，删除死代码或用明确的 feature macro 隔离。

## 4. 建议优先执行的验证

1. **P1-01：空闲 MMU stall 注入** - 验证 R1，确认是否会产生幽灵 valid。
2. **P1-02：AMO + non-cacheable** - 验证专用异常、聚合异常、DC/DA/WB 提交和副作用抑制。
3. **P1-03：边界 load × MMU 属性矩阵** - 交叉 `boundary`、`pa_vld`、`page_ca`、`page_so`、`aclr_dis`。
4. **P1-04：ahead mispredict 清除** - cache miss、TLB miss、异常、bank conflict、flush 场景。
5. **P1-05：投机 DCACHE 读无副作用** - PA 无效和异常场景下检查 tag/data 读结果不能提交。
6. **P2-01：跨 4 KiB 形式/穷举检查** - 覆盖正负 offset 和四种合法 shift。
7. **P2-02：非法 shift 与 vreg bit 6** - 明确上游编码契约并固化断言。
8. **P2-03：X-prop 与时钟门控** - reset release、空闲、ICG/scan 边界。

## 5. 需要设计方确认的问题

1. `mmu_lsu_stall0` 是否由接口规范保证恒为 0，还是未来允许拉高？若允许，空闲态是否保证为 0？
2. `idu_lsu_rf_pipe3_shift[3:0]` 是否严格 one-hot？非法值由谁阻止？
3. `idu_lsu_rf_pipe3_vreg[6]` 是否保留位并保证为 0？
4. `ld_ag_ahead_predict=1` 是否是最终设计策略？误预测由哪些后级信号取消？
5. DCACHE tag/data array 的提前访问是否明确允许在 `pa_vld=0`、page fault 或 non-cacheable 时发生？哪些下级门控保证无副作用？
6. `ld_ag_expt_ldamo_not_ca` 是否故意不并入 `ld_ag_expt_vld`？所有聚合异常消费者是否已审计？
7. 边界访问的 load-valid 判定使用 `ld_ag_acclr_en` 而不是 `ld_ag_dc_acclr_en` 是否有意？
8. MMU 是否保证 page fault 周期同时令 `mmu_lsu_pa0_vld=1`？上游当前实现通过 exception-match/VA-illegal 路径使 PA valid，但该行为应写入接口契约。
9. `ctrl_ld_clk` 与 `forever_cpuclk/ld_ag_clk` 的相位和停钟关系是什么？
10. 恒 0 的 vector/FOF/VMB/ahead-vector 功能是永久裁剪，还是等待后续恢复？

## 6. 总结

本次未发现无需接口上下文即可断言为必现体系结构错误的 P0 问题。最需要优先闭环的是 R1-R5：其中 R1 在当前 OpenC910 上游集成中被“MMU stall 恒 0”缓解，但模块级接口本身仍不稳健；R2-R5 则依赖后级取消、异常汇聚和边界访问协议。建议把第 5 节问题作为验证环境建模前的接口澄清清单，并把第 4 节八项测试纳入回归。
