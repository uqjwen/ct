# Interaction 1.4 LSU 复核总表

## 1. 总结

本轮基于远端提交 `6260f4a`，逐项核对 README Interaction 1.4 的 7 点回复、两处声称修改及 44 个新增/更新 RTL 文件。结论不是“全部关闭”：新增 MMU/LFB/SQ/WMB/LSDA 源码显著缩小了外部合同范围，但 DA-RR-01 的修改没有落到标量 `xx_lsu_ld_da.sv`，WB-RR-01 的门控修复只覆盖了后半段时钟链，WB-RR-02 的自动清零仍有独立门控缺口。

本轮只提交审查文档，没有修改 README 或 RTL。状态定义：

- **源码关闭：** 当前仓库可见 RTL 足以证明原场景不可达或已正确修复。
- **源码缩小：** 已证明本模块不保存迟到状态，但仍需边界 assertion 或缺失模块证明。
- **合同保留：** README 描述合理，但可见源码不足以证明。
- **仍开放：** 当前 RTL 仍可见原问题，或声称的修改尚未闭合根因链。

## 2. Interaction 1.4 七点处置矩阵

| 点 | 对应项 | 处置 | 核心证据与后续动作 |
|---:|---|---|---|
| 1 | LRQ-RR-01 | **仍开放，双方一致** | `xx_lsu_lrq_entry` 仍未保存 `halt_info`，replay 仍使用当前 IDU 总线。等待后续 RTL；验证需覆盖 replay 与另一 IDU 候选同拍。 |
| 2 | WB-RR-01 | **修复未闭合** | `ld_wb_cmplt_clk_en` 已加入 `rb_data_halt_info_update_vld`（`srcs/xx_lsu_ld_wb.sv:1005-1007`），但该 valid 自身由 `ld_wb_data_clk` 采样（`1813-1820`），而 data clock enable 仍只含新的 data request（`1044-1047`）。当 DTU 两级延迟事件到达且无新 data request 时，update valid 仍不能产生。 |
| 3 | DC-RR-01 | **仍开放，双方一致** | `ld_dc_dtu_addr_vld` 仍只有置 1 分支、无正常清零（`srcs/xx_lsu_ld_dc.sv:2263-2273`）。等待后续 RTL。 |
| 4 | DA-RR-01 | **声称修改未落到标量模块** | 标量 `lda_rb_ex3_data_ori3` 仍在 ECC replay 选择 `lda_lwb_ex3_data2`（`srcs/xx_lsu_ld_da.sv:3438`）；正确的 `data3` 只出现在新增 LSDA 对照模块（`srcs/xx_lsu_ls_ld_da.sv:2667`）。 |
| 5 | WB-RR-02 | **仍开放，回复没有覆盖门控事实** | 即使 DTU 保证 halt-info `[1:0]=2'b11`，清零分支 `ld_wb_halt_info_effect=bit1` 也必须等 `ld_wb_cmplt_clk` 开启；当前 clock enable 没有包含 effect（`1005-1007`、`1675-1686`），所以“bit0 只维持一拍”不能由当前 RTL推出。 |
| 6 | DA-RR-02/04 详细报告 | **已完成** | 新报告位于 [`doc-da/xx_lsu_ld_da_detailed_risk_review.md`](../doc-da/xx_lsu_ld_da_detailed_risk_review.md)，验证方案位于 [`doc-da/xx_lsu_ld_da_verification_focus.md`](../doc-da/xx_lsu_ld_da_verification_focus.md)。目录按 README 使用 `doc-da`，不再依赖旧 `doc_da` 路径。 |
| 7 | 补充 module | **部分源码关闭，部分仍缺失** | MMU/LFB/SQ/WMB wakeup 生命周期得到源码支持；D-cache borrow equality 仍依赖 VB/SNQ producer；三 lane WB 活性仍缺真正的 `xx_lsu_wb_arbiter` 实现。 |

## 3. 三个未闭合修改的根因链

### 3.1 WB-RR-01：consumer clock 已补，producer clock 仍可能不开

RB data-trigger 信息经过 `ld_dtu_data_clk` 的两级流水后形成 `rb_entry_data_halt_info_update_vld`（`srcs/xx_lsu_ld_wb.sv:1731-1741`、`1753-1811`）。随后另一个寄存器必须在 `ld_wb_data_clk` 上把它采成 `rb_data_halt_info_update_vld`（`1813-1820`）。

新增修改只让已经存在的 `rb_data_halt_info_update_vld` 打开 completion clock。问题在于 DTU 延迟事件到达时，原始 RB data request 通常已经离开 EX3；若没有碰巧出现新的 DA/RB/VMB/WMB data request，`ld_wb_data_clk_en` 为 0，注册 update pulse 根本不会置 1。因此正确修复必须覆盖完整的“原始事件 → update valid → halt-info consumer”时钟链，而不只覆盖最后一级。

建议方案之一是把 raw update event 与已注册 update valid 都纳入 source clock enable，使它能置位并在下一拍清零；更清晰的方案是让 update pulse在 `ld_dtu_data_clk` 或无门控控制时钟域产生，再做明确的单脉冲跨域/门控采样。具体实现需由设计方选择，但必须以“无后续写回流量”定向用例验证。

### 3.2 WB-RR-02：`11` 只说明 clear 条件存在，不说明 clear 时钟存在

halt-info 在 completion clock 上更新，优先级为新 completion、RB data update、`ld_wb_halt_info_effect` 清零（`srcs/xx_lsu_ld_wb.sv:1675-1686`）。`effect` 等于 bit1，因此 `[1:0]=11` 的确会让组合清零条件为 1；但门控时钟 enable 并不包含 effect。若下一拍没有 DA/RB completion 或 update pulse，寄存器不会执行清零分支，bit0/bit1 可继续保持，`lsu_rtu_ex4_cmplt` 又能只由旧 bit0 拉高（`srcs/xx_lsu_ld_wb.sv:1583`）。

所以本项应从“待 DTU 合同”提升为“可见门控缺口”。至少需要 `ld_wb_halt_info_effect -> ld_wb_cmplt_clk_en`，并验证 `11` 只产生规定次数的 completion；若 RTU 使用 level/ack 协议，则还需提供该协议和 ack 清除路径。

### 3.3 DA-RR-01：正确改动出现在相似模块，不在问题模块

新增的 `xx_lsu_ls_ld_da.sv` 为 LSDA lane，`lsda_rb_ex3_data_ori3` 已正确选择 `lsda_lswb_ex3_data3`。然而标量 `xx_lsu_ld_da.sv` 没有本轮 diff，仍使用 `data2`。这属于相似模块之间的修复遗漏。详细触发序列和三 lane 等价回归见 `doc-da` 报告。

## 4. 新增模块对 Interaction 1.3 第 5 点的影响

| 原合同项 | 新源码结论 | 新状态 |
|---|---|---|
| MMU flush 后不得迟到 wake 旧 LRQ bit | TMQ entry 保存 IID/三 lane LSID；check-flush 会按 IID 删除 entry/request，且 `rtu_ck_flush` 拍发送所有保存 LSID 后清零（`srcs/mmu/xx_mmu_dutlb_tmq_entry.sv:141-180`、`193-228`、`srcs/mmu/xx_mmu_dutlb_tmq.sv:593-601`）。 | **源码缩小**：TMQ 本地没有保留旧 bitmap；仍需集成 epoch assertion。 |
| LFB/SQ/WMB wakeup queue flush 生命周期 | 三者都在 check-flush 拍输出当前/同拍新增 bitmap，下一拍清零；full flush 直接清零（LFB `1543-1598`，SQ `2505-2576`，WMB `3602-3633`、`3747-3777`）。 | **本地源码关闭，边界保留**：未见这些 queue 在 flush 后继续保存旧 bit。 |
| D-cache borrow valid/gate 等价 | `xx_lsu_dcache_arb` 的 common terms 相同，但 VB/SNQ 分别使用 `borrow_req` 与 `borrow_req_gate` 两组输入（`srcs/xx_lsu_dcache_arb.sv:533-543`）。VB/SNQ producer 未提供。 | **合同保留**：不能说 arbiter 内部赋值等价；需 producer 源码或边界 equality assertion。 |
| 三个 writeback lane 可任取空闲 lane | top 真正实例化的是 `xx_lsu_wb_arbiter`（`srcs/xx_lsu_top.sv:10594-10627`），但仓库没有该模块文件。新增 `xx_lsu_bus_arb.sv` 仲裁的是 BIU AR/AW/W 通道，AR 还是固定 WMB>RB>PFU（`srcs/xx_lsu_bus_arb.sv:610-640`）。 | **仍缺源码**：WB-RR-04 不能由新增 bus arb 关闭。 |
| LSDA LQ/RB create、restart 与 DA bitmap | `xx_lsu_ls_ld_da.sv`、DC/DA wrapper 已提供，可见 LSDA 的 request/dp/gate、flush masking 和 live LSID 路径与标量设计同类。 | **显著缩小**：旧报告中“LSDA producer 完全缺失”不再成立，仍需 testbench 验证三 lane 同拍交互。 |
| WMB fixed B ID 串行与 RB fence | WMB entry 只在 write request 后置 `biu_b_id_vld`，response 后清除（`srcs/xx_lsu_wmb_entry.sv:983-992`、`2031-2050`）；RB fence/sync 又等待 `wmb_sync_fence_biu_req_success` 才发请求（`srcs/xx_lsu_rb_entry.sv:2007-2015`）。 | **源码缩小**：本地顺序与合同一致，但 BIU 对固定 ID 的全局 outstanding/返回规则仍缺失，RB-RR-04 保留边界 assertion。 |

## 5. 更新后的开放风险优先级

1. **WB-RR-01：** 修复未覆盖 update pulse 的 source clock；无后续 data request 时仍可能丢更新。
2. **WB-RR-02：** halt-info bit1 clear 缺 completion clock enable；`11` 不能保证 bit0 单拍。
3. **DA-RR-01：** 标量 ECC replay block3 仍复制 block2。
4. **DC-RR-01：** debug address valid 仍可能粘住。
5. **LRQ-RR-01：** replay 仍缺原事务 halt-info。
6. **DC-RR-02 / WB-RR-04：** 新增模块尚未提供关键 producer/真正 arbiter，保持合同风险。

## 6. 还需要补充的信息

为把其余合同提升为源码/动态关闭，建议下一批优先提供：

1. `xx_lsu_wb_arbiter` 实现；top 已实例化该模块但本提交没有源文件。
2. VB/SNQ 模块中 `*_borrow_req` 与 `*_borrow_req_gate` 的产生逻辑。
3. BIU 对 R/B ID、`r_last`、固定 fence ID、async flush 后 outstanding response 的协议与 RTL。
4. RTU 对 `lsu_rtu_ex4_cmplt` 的 pulse/level/ack 合同，以及 debug halt-info 的生命周期规格。
5. 完整宏定义、helper/gated-clock RTL、工程 filelist 与最小 testbench，以运行 elaboration、lint、X-prop 和 assertion 回归。

## 7. 验证边界

仓库当前没有可执行 RTL testbench，系统也没有安装 Verilator/Icarus/Slang；新增 `mmu.fl` 还依赖 `${CODE_BASE_PATH}`、外部宏定义和 helper。故本轮完成的是可复查的静态源码/接口审查、路径与文档一致性验证，不是仿真签核。所有“源码缩小”项仍应按文中 assertion 和定向用例进入完整工程回归。
