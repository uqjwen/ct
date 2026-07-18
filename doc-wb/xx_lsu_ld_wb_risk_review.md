# `xx_lsu_ld_wb` 设计风险审查

## 1. 范围与结论

基于提交 `a81c012` 完成初审，并在 Interaction 1.4 提交 `6260f4a` 上复核 DA/RB completion 仲裁、DA/WMB/VMB/RB data 仲裁、标量/向量写回、VMB merge、exception/no-spec/vstart 和 debug data-trigger 流水。新增 WMB/LSDA/top 源码已纳入判断；真正的 `xx_lsu_wb_arbiter`、VMB producer 和 RTU 接收协议仍按合同依赖分类。

| ID | 优先级 | 置信度 | 状态 | 摘要 |
|---|---:|---|---|---|
| WB-RR-01 | P2 | 已确认 | 修复未闭合 | completion clock 已补 update valid，但 update valid 的 source data clock仍可能不开 |
| WB-RR-02 | P2 | 已确认 | 开放 | bit1 虽形成 clear 条件，completion clock enable 未覆盖该 clear 事件 |
| WB-RR-03 | P2 | 源码+合同 | 数据正确性关闭，活性待断言 | 源码证明 `req -> dp -> gate`；dp-only 会真实占用仲裁 |
| WB-RR-04 | P1 | 合同依赖 | 仍开放待 arbiter | top 实例化的三 lane `xx_lsu_wb_arbiter` 未提供，新增 bus arb不是该模块 |
| WB-RR-05 | P3 | 已确认 | 清理项 | preg 时钟 enable 含重复 RB 项，造成无意义开钟 |

## 2. 仲裁摘要

completion 固定 DA 高于 RB（`srcs/xx_lsu_ld_wb.sv:744-783`）。data 固定 DA-dp、WMB、VMB、RB 顺序（`srcs/xx_lsu_ld_wb.sv:792-812`），payload 由 grant 选择（`srcs/xx_lsu_ld_wb.sv:911-993`）。completion 和 data 使用独立 EX4 valid，full flush 清零；data 不使用 check-flush，源码注释说明 RB IID 可能无效，因此由 producer epoch 合同保护（`srcs/xx_lsu_ld_wb.sv:1235-1307`）。

## 3. 详细风险

### WB-RR-01：RB data-trigger halt-info 更新可能丢失

`rb_data_halt_info_update_vld` 由两级 DTU 流水后的 raw event 再经 `ld_wb_data_clk` 寄存产生（`srcs/xx_lsu_ld_wb.sv:1731-1741`、`1753-1820`），随后在 `ld_wb_cmplt_clk` 上更新 `ld_wb_halt_info`（`srcs/xx_lsu_ld_wb.sv:1675-1684`）。Interaction 1.4 已把注册后的 update valid 并入 completion clock enable（`srcs/xx_lsu_ld_wb.sv:1005-1007`），因此 consumer 端门控缺口得到修正。

但 source 端仍有一层同类问题：`ld_wb_data_clk_en` 只包含当前 DA/RB/VMB/WMB data request（`srcs/xx_lsu_ld_wb.sv:1044-1047`），没有 raw `rb_entry_data_halt_info_update_vld` 或已注册 update valid。DTU 延迟事件到达时，原 RB data request 通常已经离开；若没有碰巧出现新 data request，source clock 不开，`rb_data_halt_info_update_vld` 仍无法置 1。修复必须覆盖 raw event 的置位与下一拍清零，再由 completion clock可靠采样；或把 update pulse 移到持续覆盖该事件的时钟域。

### WB-RR-02：halt bit0 可形成粘住的 completion

`ld_wb_halt_info` 只有新 completion、新 RB data update 或 `ld_wb_halt_info_effect` 时改写，而 effect 等于 bit1（`srcs/xx_lsu_ld_wb.sv:1675-1686`）。与此同时 `lsu_rtu_ex4_cmplt` 在 bit0 为 1 时无条件为 1，`abnormal` 也直接包含 bit0（`srcs/xx_lsu_ld_wb.sv:1581-1591`）。

Interaction 1.4 说明 DTU 总让最低两位同时为 1；这只能证明 clear 分支的组合条件会成立，不能证明寄存器下一拍真的执行。当前 `ld_wb_cmplt_clk_en` 不包含 `ld_wb_halt_info_effect`（`srcs/xx_lsu_ld_wb.sv:1005-1007`），若没有新 completion/update，clock 关闭，`11` 会继续保持。因此本项已从“待 RTU 合同”收敛为可见门控缺口；需要 clear event 打开 completion clock，或提供明确 level/ack 清除路径。

### WB-RR-03：DA request/dp/gate 三信号合同

DA grant 用 `lda_lwb_ex3_data_req_dp`，而 EX4 data valid 用真实 `lda_lwb_ex3_data_req`（`srcs/xx_lsu_ld_wb.sv:794-812`）；payload、寄存器门控又分别依赖 grant 和 `data_req_gateclk_en`（`srcs/xx_lsu_ld_wb.sv:928-960`、`srcs/xx_lsu_ld_wb.sv:1041-1108`）。

由 DA 产生式可直接证明 `req -> dp`：真实 request 比 dp 多了 data-check、ECC data mask 和 SQ-ECC discard 等限制（`srcs/xx_lsu_ld_da.sv:4986-5014`），因此 `req=1 && dp=0` 不可达。`dp -> gateclk_en` 也由 data-valid 来源（D-cache/TCM/SQ/WMB/vector-nop/fatal）覆盖（`srcs/xx_lsu_ld_da.sv:3283-3288`、`srcs/xx_lsu_ld_da.sv:5016-5024`）。数据源错选风险据此关闭。

但是 `dp=1 && req=0` 确实可达，而且 WB 用 dp 直接授予 DA并压住 WMB/VMB/RB（`srcs/xx_lsu_ld_wb.sv:794-812`）。ECC stall 时 DA EX3 会保持（`srcs/xx_lsu_ld_da.sv:1989-2009`），所以 dp-only 不一定只是单拍气泡；它不会产生伪写回 valid，但可能延长低优先级等待。功能无损仍依赖 loser hold-until-grant、payload稳定和 dp-only 最终解除，故活性检查保留。

### WB-RR-04：固定优先级可能饿死低优先级请求

completion 始终 DA 优先 RB，data 始终 DA、WMB、VMB、RB 优先（`srcs/xx_lsu_ld_wb.sv:746-806`）。新增 top 显示三 lane 调度由 `xx_lsu_wb_arbiter` 产生 `arb_lwb0/lswb0/lswb1_*_req`（`srcs/xx_lsu_top.sv:10594-10627`），但仓库没有该模块的实现。新增 `xx_lsu_bus_arb.sv` 实际仲裁 BIU AR/AW/W 通道，并不是 writeback lane arbiter；不能据此证明请求可迁移到任意空闲 lane。

WMB entry 在未获 grant 时会保持 `wb_data_success=0` 和 data request（`srcs/xx_lsu_wmb_entry.sv:1034-1043`、`2071-2074`），这关闭了 WMB 本地“loser 立即丢请求”的担忧；但三 lane 选择与有界前进仍缺核心源码。尤其 WB-RR-03 的 ECC dp-only 会在单 lane 屏蔽低优先级 requester，故本项保持开放待 `xx_lsu_wb_arbiter` 和 bounded-grant assertion。

### WB-RR-05：preg 时钟 enable 重复项

`ld_wb_preg_clk_en` 中 `rb_lwb_ex3_data_req` 连续出现两次，其中第一项无 `!inst_vfls` 资格（`srcs/xx_lsu_ld_wb.sv:1063-1068`）。因此所有 RB vector data request 也会打开 preg 时钟，虽寄存器本身仍由 `ld_wb_pre_preg_wb_vld` 保护，不构成功能错误，但增加动态功耗并掩盖原意。应删除无条件重复项。

## 4. 结论

数据选择在合法 grant one-hot 和 request 保持合同下结构一致；VMB 512-bit 拼接与 byte-mask 分区清晰。Interaction 1.3 已关闭 `req=1 && dp=0` 数据错误，但没有消除 dp-only 与固定优先级的活性验证义务。Interaction 1.4 后首要项为同时修正 WB-RR-01 的 source/consumer 时钟链与 WB-RR-02 的 clear 时钟，再补齐 `xx_lsu_wb_arbiter` 做有界前进证明。
