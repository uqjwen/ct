# `xx_lsu_ld_wb` 设计风险审查

## 1. 范围与结论

审查提交 `9928a13` 的 DA/RB completion 仲裁、DA/WMB/VMB/RB data 仲裁、标量/向量写回、VMB merge、exception/no-spec/vstart 和 debug data-trigger 流水。缺失的请求保持、公平性与 RTU 接收协议按合同依赖分类。

| ID | 优先级 | 置信度 | 状态 | 摘要 |
|---|---:|---|---|---|
| WB-RR-01 | P2 | 已确认 | 开放 | RB data-trigger halt-info 更新没有打开 completion payload 时钟 |
| WB-RR-02 | P2 | 高置信 | 开放待合同 | halt bit0 无显式消费清零，却可绕过 `inst_vld` 持续产生 completion |
| WB-RR-03 | P1 | 合同依赖 | 开放待断言 | DA data 的 `req/dp/gate` 必须满足严格蕴含关系 |
| WB-RR-04 | P1 | 合同依赖 | 条件关闭 | 固定优先级仲裁需要 lower-priority 请求保持和前进性保证 |
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

若 `req=1 && dp=0`，WB 会锁存“有效”但 DA payload 未被选择；若 `dp=1 && req=0`，DA 会阻塞所有低优先级请求而本拍无有效写回。必须在 DA/WB 边界断言 `req -> dp -> gateclk_en`，并把 dp-only reservation 的最大持续时间纳入前进性检查。

### WB-RR-04：固定优先级可能饿死低优先级请求

completion 始终 DA 优先 RB，data 始终 DA、WMB、VMB、RB 优先（`srcs/xx_lsu_ld_wb.sv:746-806`）。低优先级有 grant 返回，但源码未包含 producer 的 hold-until-grant 或公平性实现。若 DA/WMB 持续占用，RB response data 可长期不返回并占满 RB。需要系统级证明流量有界且 producer 保持 payload；若无法证明，应增加轮转/年龄仲裁或 starvation counter。

### WB-RR-05：preg 时钟 enable 重复项

`ld_wb_preg_clk_en` 中 `rb_lwb_ex3_data_req` 连续出现两次，其中第一项无 `!inst_vfls` 资格（`srcs/xx_lsu_ld_wb.sv:1063-1068`）。因此所有 RB vector data request 也会打开 preg 时钟，虽寄存器本身仍由 `ld_wb_pre_preg_wb_vld` 保护，不构成功能错误，但增加动态功耗并掩盖原意。应删除无条件重复项。

## 4. 结论

数据选择在合法 grant one-hot 和 request 保持合同下结构一致；VMB 512-bit 拼接与 byte-mask 分区清晰。首要修复为 WB-RR-01，随后确认 halt bit0 的 RTU level/脉冲语义和 DA req/dp/gate 合同。
