# `xx_lsu_ld_wb` 设计风险审查

## 1. 范围与结论

基于提交 `a81c012` 完成初审，并在 Interaction 1.5 提交 `443384a` 上复核 DA/RB completion 仲裁、DA/WMB/VMB/RB data 仲裁、标量/向量写回、VMB merge、exception/no-spec/vstart、debug data-trigger 流水和新增三 lane `xx_lsu_wb_arbiter`。仓库没有可执行 testbench/filelist，当前结论来自静态数据流与 96 组布尔穷举。

| ID | 优先级 | 置信度 | 状态 | 摘要 |
|---|---:|---|---|---|
| WB-RR-01 | P2 | 已确认 | 仍开放，残留变为 update 粘连 | `ld_dtu2_vld` 已让 update 能置位，但 registered update 自身不能打开 data clock执行清零 |
| WB-RR-02 | P2 | 已确认 | 局部已修，被 WB-RR-01 阻塞 | effect 已加入 completion clock；粘住的高优先级 update 分支持续压过 effect clear |
| WB-RR-03 | P2 | 源码+合同 | 数据正确性关闭，活性待断言 | 源码证明 `req -> dp -> gate`；dp-only 会真实占用仲裁 |
| WB-RR-04 | P1 | 源码+穷举+合同 | 单拍安全关闭，bounded liveness 开放 | 64 组 data + 32 组 completion 与 greedy allocator 一致；无状态固定优先级仍有持续饥饿反例 |
| WB-RR-05 | P3 | 已确认 | 清理项 | preg 时钟 enable 含重复 RB 项，造成无意义开钟 |

## 2. 仲裁摘要

completion 固定 DA 高于 RB（`srcs/xx_lsu_ld_wb.sv:744-783`）。data 固定 DA-dp、WMB、VMB、RB 顺序（`srcs/xx_lsu_ld_wb.sv:792-812`），payload 由 grant 选择（`srcs/xx_lsu_ld_wb.sv:911-993`）。completion 和 data 使用独立 EX4 valid，full flush 清零；data 不使用 check-flush，源码注释说明 RB IID 可能无效，因此由 producer request-owner 生命周期合同保护（`srcs/xx_lsu_ld_wb.sv:1235-1307`）。

## 3. 详细风险

### WB-RR-01：RB data-trigger halt-info update valid 可能粘连

`rb_data_halt_info_update_vld` 由两级 DTU 流水后的 raw event 再经 `ld_wb_data_clk` 寄存产生（`srcs/xx_lsu_ld_wb.sv:1731-1741`、`1753-1823`），随后在 `ld_wb_cmplt_clk` 上更新 `ld_wb_halt_info`（`srcs/xx_lsu_ld_wb.sv:1677-1688`）。Interaction 1.5 已把 `ld_dtu2_vld` 加入 data clock enable、把注册后的 update valid 加入 completion clock enable（`srcs/xx_lsu_ld_wb.sv:1005-1008`、`1045-1049`），所以 raw event 现在能够置位 update，原来的“事件丢失”缺口已修。

残留问题发生在下一拍：update 寄存器的 always block每次有 data clock 时执行 `raw ? 1 : 0`（`srcs/xx_lsu_ld_wb.sv:1815-1823`），但 `ld_wb_data_clk_en` 不包含 `rb_data_halt_info_update_vld` 本身。`ld_dtu2_vld` 在置位 update 的同一边沿清零后，若没有新 DA/RB/VMB/WMB 请求，下一拍 data clock 关闭，update 不能执行 else-clear并保持 1。它又持续打开 completion clock并反复选择 halt-info update 分支。

最小修正是把 registered `rb_data_halt_info_update_vld` 加入 `ld_wb_data_clk_en`，使其在 raw event 消失后再获得一个清零边沿；或在持续可用的 debug/forever clock 域生成严格一拍 pulse。修复后必须验证“无任何后续 data traffic”场景。

### WB-RR-02：halt bit0 可形成粘住的 completion

`ld_wb_halt_info` 只有新 completion、新 RB data update 或 `ld_wb_halt_info_effect` 时改写，而 effect 等于 bit1（`srcs/xx_lsu_ld_wb.sv:1675-1686`）。与此同时 `lsu_rtu_ex4_cmplt` 在 bit0 为 1 时无条件为 1，`abnormal` 也直接包含 bit0（`srcs/xx_lsu_ld_wb.sv:1581-1591`）。

Interaction 1.5 已把 `ld_wb_halt_info_effect` 加入 `ld_wb_cmplt_clk_en`（`srcs/xx_lsu_ld_wb.sv:1005-1008`），所以 effect 单独存在时会得到清零边沿，原始门控缺口已局部修复。

但 always block的优先级为“新 completion → registered update → effect clear”（`srcs/xx_lsu_ld_wb.sv:1677-1688`）。WB-RR-01 中粘住的 update 永远先于 effect，DTU 给出低两位 `11` 也会被每拍重新写入，无法进入 clear 分支。因此 WB-RR-02 不能独立关闭：先让 update 成为一拍 pulse，随后 effect 才能在再下一拍清零 halt-info。

### WB-RR-03：DA request/dp/gate 三信号合同

DA grant 用 `lda_lwb_ex3_data_req_dp`，而 EX4 data valid 用真实 `lda_lwb_ex3_data_req`（`srcs/xx_lsu_ld_wb.sv:794-812`）；payload、寄存器门控又分别依赖 grant 和 `data_req_gateclk_en`（`srcs/xx_lsu_ld_wb.sv:928-960`、`srcs/xx_lsu_ld_wb.sv:1041-1108`）。

由 DA 产生式可直接证明 `req -> dp`：真实 request 比 dp 多了 data-check、ECC data mask 和 SQ-ECC discard 等限制（`srcs/xx_lsu_ld_da.sv:4986-5014`），因此 `req=1 && dp=0` 不可达。`dp -> gateclk_en` 也由 data-valid 来源（D-cache/TCM/SQ/WMB/vector-nop/fatal）覆盖（`srcs/xx_lsu_ld_da.sv:3283-3288`、`srcs/xx_lsu_ld_da.sv:5016-5024`）。数据源错选风险据此关闭。

但是 `dp=1 && req=0` 确实可达，而且 WB 用 dp 直接授予 DA并压住 WMB/VMB/RB（`srcs/xx_lsu_ld_wb.sv:794-812`）。ECC stall 时 DA EX3 会保持（`srcs/xx_lsu_ld_da.sv:1989-2009`），所以 dp-only 不一定只是单拍气泡；它不会产生伪写回 valid，但可能延长低优先级等待。功能无损仍依赖 loser hold-until-grant、payload稳定和 dp-only 最终解除，故活性检查保留。

### WB-RR-04：三 lane 打包安全已证，固定优先级活性仍依赖系统

Interaction 1.5 已提供 `srcs/xx_lsu_wb_arbiter.sv`。它先把 WMB 放入第一个未被 dedicated DA 占用的 lane，再按 VMB、RB 顺序继续装入剩余 lane；completion 对 WMB/RB 使用同类规则（`srcs/xx_lsu_wb_arbiter.sv:66-147`）。top 的三组 request 输出到 LWB0/LSWB0/LSWB1，RB/WMB grant取各 lane OR，VMB 接收每 lane grant，连接身份一致（`srcs/xx_lsu_top.sv:9785-9786`、`10197`、`10246`、`10594-10627`、`10758-10803`、`10894-11159`、`13043-13070`）。

以“dedicated lane 先占用，WMB→VMB→RB 依次选择首个空 lane”为参考模型穷举：data 的 `2^6=64` 组、completion 的 `2^5=32` 组均 mismatch 0。由此可关闭单拍碰撞、重复选择和漏 grant 风险。

该模块没有 age/round-robin 状态，固定优先级活性仍无法由源码证明。持续 `{lane0 busy=1,lane1 busy=1,lane2 busy=0,WMB=1,VMB=1}` 时 WMB 每拍占 lane2，VMB 永不获 grant；把 VMB 换成 RB，或让 VMB 持续压住 RB，也得到同类反例。Interaction 1.3 所述“issue queue 最终填满并压停高优先级”属于系统 eventual-quiescence 合同；必须给出资源依赖无环与有限上界 `N`，否则仍可能形成循环等待。故 WB-RR-04 的 safety 已关闭，P1 bounded-liveness 部分保留。

### WB-RR-05：preg 时钟 enable 重复项

`ld_wb_preg_clk_en` 中 `rb_lwb_ex3_data_req` 连续出现两次，其中第一项无 `!inst_vfls` 资格（`srcs/xx_lsu_ld_wb.sv:1063-1068`）。因此所有 RB vector data request 也会打开 preg 时钟，虽寄存器本身仍由 `ld_wb_pre_preg_wb_vld` 保护，不构成功能错误，但增加动态功耗并掩盖原意。应删除无条件重复项。

## 4. 结论

数据选择在合法 grant one-hot 和 request 保持合同下结构一致；VMB 512-bit 拼接与 byte-mask 分区清晰。Interaction 1.5 后首要项是让 `rb_data_halt_info_update_vld` 自清零，从而让已补齐的 effect clock 真正执行；其次把系统“高优先级最终停止”转成有界、可验证的 forward-progress 合同，或给 arbiter 增加公平机制。
