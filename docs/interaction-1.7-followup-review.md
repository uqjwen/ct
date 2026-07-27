# Interaction 1.7 完成报告

## README 第 1 项：`xx_rtu_retire` 设计审查

已对 `srcs/xx_rtu_retire.v` 完成基于 OpenC910 `ct_rtu_retire.v` 的静态差分审查，并输出：

- `doc-rtu/xx_rtu_retire_risk_review.md`
- `doc-rtu/xx_rtu_retire_verification_focus.md`

本轮识别出两项需优先处理的设计问题：

1. `RTU-RR-01`：异步异常缺少 retire clock 和 flush gate 两处门控使能，属于已确认 P1 漏项。
2. `RTU-RR-02`：MMU 开启时高半区 PC 的 instruction `mtval` 和 debug `tval` 没有 canonical 符号扩展，属于配置相关 P1。

另记录 DTU 请求保持合同、六退休 ROB 资格合同、多 `vsetvli` 同拍优先级和死接口清理等验证义务。静态扫描未发现 port 声明缺失、output 未驱动、slot3～5 信号族漏接或连续赋值跨 lane 取错字段。

## README 第 2 项：功能点与 test plan

已按指定五列格式生成以下 Markdown：

- `doc-ag/xx_lsu_ld_ag_feature_test_plan.md`：`xx_lsu_ld_ag`
- `doc-dc/xx_lsu_ld_dc_feature_test_plan.md`：`xx_lsu_ld_dc`
- `doc-da/xx_lsu_ld_da_feature_test_plan.md`：`xx_lsu_ld_da`
- `doc-wb/xx_lsu_ld_wb_feature_test_plan.md`：`xx_lsu_ld_wb`
- `doc-lrq/xx_lsu_lrq_feature_test_plan.md`：`xx_lsu_lrq`、`xx_lsu_lrq_entry`
- `doc-rb/xx_lsu_rb_feature_test_plan.md`：`xx_lsu_rb`、`xx_lsu_rb_entry`
- `doc-lq/xx_lsu_lq_feature_test_plan.md`：`xx_lsu_lq`、`xx_lsu_lq_entry`
- `doc-lfb/xx_lsu_lfb_feature_test_plan.md`：`xx_lsu_lfb`、`xx_lsu_lfb_addr_entry`

每个功能点都包含可执行的测试方法/配置和 P0～P3 优先级，并以当前源码行号建立追踪。

## 验证边界

- 已完成：README 产物合同自动检查、既有 Interaction 1.6 assertion 回归、源码结构/对称性/未使用接口静态检查。
- 尚需项目环境完成：带宏和依赖的 SystemVerilog elaboration、门控时钟仿真、UVM/形式动态验证。
- 因仓库当前没有完整 RTU testbench 和可用 HDL 编译器，本提交不声称动态签核；各报告已经给出 assertion、覆盖项和动态关闭条件。
