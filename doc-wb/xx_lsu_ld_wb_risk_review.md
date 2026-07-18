# `xx_lsu_ld_wb` 设计风险审查

## 1. 范围与结论

基于提交 `a81c012` 复核 DA/RB completion 仲裁、DA/WMB/VMB/RB data 仲裁、标量/向量写回、VMB merge、exception/no-spec/vstart 和 debug data-trigger 流水。缺失的 WMB/VMB/RB producer 保持、`xx_lsu_bus_arb` 公平性与 RTU 接收协议按合同依赖分类。

| ID | 优先级 | 置信度 | 状态 | 摘要 |
|---|---:|---|---|---|
| WB-RR-01 | P2 | 已确认 | 开放 | RB data-trigger halt-info 更新没有打开 completion payload 时钟 |
| WB-RR-02 | P2 | 高置信 | 开放待合同 | halt bit0 无显式消费清零，却可绕过 `inst_vld` 持续产生 completion |
| WB-RR-03 | P2 | 源码+合同 | 数据正确性关闭，活性待断言 | 源码证明 `req -> dp -> gate`；dp-only 会真实占用仲裁 |
| WB-RR-04 | P1 | 合同依赖 | 条件关闭待系统验证 | 固定优先级仍需 lower-priority 保持和有界前进保证 |
| WB-RR-05 | P3 | 已确认 | 清理项 | preg 时钟 enable 含重复 RB 项，造成无意义开钟 |

## 2. 仲裁摘要

completion 固定 DA 高于 RB（`srcs/xx_lsu_ld_wb.sv:744-783`）。data 固定 DA-dp、WMB、VMB、RB 顺序（`srcs/xx_lsu_ld_wb.sv:792-812`），payload 由 grant 选择（`srcs/xx_lsu_ld_wb.sv:911-993`）。completion 和 data 使用独立 EX4 valid，full flush 清零；data 不使用 check-flush，源码注释说明 RB IID 可能无效，因此由 producer epoch 合同保护（`srcs/xx_lsu_ld_wb.sv:1235-1307`）。

## 3. 详细风险

### WB-RR-01：RB data-trigger halt-info 更新可能丢失

`rb_data_halt_info_update_vld` 在 data 时钟域由两级 DTU 流水产生（`srcs/xx_lsu_ld_wb.sv:1789-1819`），随后试图在 `ld_wb_cmplt_clk` 上更新 `ld_wb_halt_info`（`srcs/xx_lsu_ld_wb.sv:1674-1683`）。但 completion 时钟 enable 只有 `lda_ex3_inst_vld || rb_lwb_ex3_cmplt_req`（`srcs/xx_lsu_ld_wb.sv:1004-1015`），不包含 `rb_data_halt_info_update_vld`。

当 RB 的 data check 比 completion 晚到且当拍无新 DA/RB completion 时，更新分支存在但时钟不开，halt-info 丢失。应把该 update valid 并入 completion clock enable，或把 halt-info 寄存器移到始终覆盖该事件的时钟域，并加入“update 必被采样”断言。

### WB-RR-02：halt bit0 可形成粘住的 completion

`ld_wb_halt_info` 只有新 completion、新 RB data update 或 `ld_wb_halt_info_effect` 时改写，而 effect 仅等于 bit1（`srcs/xx_lsu_ld_wb.sv:1674-1685`）。与此同时 `lsu_rtu_ex4_cmplt` 在 bit0 为 1 时无条件为 1，`abnormal` 也直接包含 bit0（`srcs/xx_lsu_ld_wb.sv:1581-1591`）。

如果 RTU 把 completion 当单周期事件且没有隐含 level-handshake，bit0 会在 `lwb_ex4_inst_vld` 已清零后继续以旧 IID 重复完成。必须确认 RTU 对该信号的消费合同；更稳健的实现是以活动 completion valid/ack 清除 bit0，并断言无有效事务时 completion 不得只由 stale halt-info 产生。

### WB-RR-03：DA request/dp/gate 三信号合同

DA grant 用 `lda_lwb_ex3_data_req_dp`，而 EX4 data valid 用真实 `lda_lwb_ex3_data_req`（`srcs/xx_lsu_ld_wb.sv:794-812`）；payload、寄存器门控又分别依赖 grant 和 `data_req_gateclk_en`（`srcs/xx_lsu_ld_wb.sv:928-960`、`srcs/xx_lsu_ld_wb.sv:1041-1108`）。

由 DA 产生式可直接证明 `req -> dp`：真实 request 比 dp 多了 data-check、ECC data mask 和 SQ-ECC discard 等限制（`srcs/xx_lsu_ld_da.sv:4986-5014`），因此 `req=1 && dp=0` 不可达。`dp -> gateclk_en` 也由 data-valid 来源（D-cache/TCM/SQ/WMB/vector-nop/fatal）覆盖（`srcs/xx_lsu_ld_da.sv:3283-3288`、`srcs/xx_lsu_ld_da.sv:5016-5024`）。数据源错选风险据此关闭。

但是 `dp=1 && req=0` 确实可达，而且 WB 用 dp 直接授予 DA并压住 WMB/VMB/RB（`srcs/xx_lsu_ld_wb.sv:794-812`）。ECC stall 时 DA EX3 会保持（`srcs/xx_lsu_ld_da.sv:1989-2009`），所以 dp-only 不一定只是单拍气泡；它不会产生伪写回 valid，但可能延长低优先级等待。功能无损仍依赖 loser hold-until-grant、payload稳定和 dp-only 最终解除，故活性检查保留。

### WB-RR-04：固定优先级可能饿死低优先级请求

completion 始终 DA 优先 RB，data 始终 DA、WMB、VMB、RB 优先（`srcs/xx_lsu_ld_wb.sv:746-806`）。Interaction 1.3 给出的 issue-queue 反压和 `xx_lsu_bus_arb` 可选三个空闲 lane 说明了预期闭环，因此本项可按系统合同条件关闭；但当前仓库没有 bus arb、WMB/VMB producer 或 issue queue 源码，无法从本模块证明“持续高优先级流量必然停止”。尤其 WB-RR-03 的 ECC dp-only 会在本 lane 继续屏蔽 lower requester。签核仍需有界 grant/hold-until-grant assertion；若合同无法满足，应增加轮转/年龄仲裁或 starvation counter。

### WB-RR-05：preg 时钟 enable 重复项

`ld_wb_preg_clk_en` 中 `rb_lwb_ex3_data_req` 连续出现两次，其中第一项无 `!inst_vfls` 资格（`srcs/xx_lsu_ld_wb.sv:1063-1068`）。因此所有 RB vector data request 也会打开 preg 时钟，虽寄存器本身仍由 `ld_wb_pre_preg_wb_vld` 保护，不构成功能错误，但增加动态功耗并掩盖原意。应删除无条件重复项。

## 4. 结论

数据选择在合法 grant one-hot 和 request 保持合同下结构一致；VMB 512-bit 拼接与 byte-mask 分区清晰。Interaction 1.3 已关闭 `req=1 && dp=0` 数据错误，但没有消除 dp-only 与固定优先级的活性验证义务。首要修复仍为 WB-RR-01，随后确认 halt bit0 的 RTU level/脉冲语义及系统有界前进合同。
