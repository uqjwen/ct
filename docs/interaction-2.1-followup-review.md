# Interaction 2.1 静态完备性复核记录

## 1. 结论与签核边界

interaction-2.1 已形成七个可重复生成、可静态检查的 LSU 模块环境。聚合门禁为
`INTERACTION_2_1_PREFLIGHT_PASS environments=7 features=85 scenarios=534`。
该结论证明端口、逐拍场景、testcase、checker、coverage 名称、文档行和依赖边界
一致，不等价于 VCS 编译、仿真、功能覆盖率或代码覆盖率通过。

当前主机没有 Synopsys VCS/URG。所有需要仿真/VDB 的结果保持
`BLOCKED_NO_VCS`；standalone compatibility model 以及缺失生产 helper 的结果保持
`PENDING_FULL_CHIP`。动态签核只能在有许可证且能提供生产依赖的 full-chip 主机关闭。

## 2. 环境清单与批准下界

|模块|环境目录|真实端口|功能点|逐拍场景|每功能点下界|testcase|
|---|---|---:|---:|---:|---:|---:|
|AG|`verif/xx_lsu_ld_ag`|258|12|96|8|12|
|DC|`verif/xx_lsu_ld_dc`|279|12|72|6|12|
|DA|`verif/xx_lsu_ld_da`|367|12|72|6|12|
|WB|`verif/xx_lsu_ld_wb`|169|12|72|6|12|
|RB|`verif/xx_lsu_rb`|396|12|72|6|12|
|LRQ|`verif/xx_lsu_lrq`|608|12|72|6|12|
|LFB|`verif/xx_lsu_lfb`|145|13|78|6|13|
|合计|七个环境|2222|85|534|—|85|

每个环境均包含 `module.json`、`Makefile`、`coverage_matrix.csv`、
`detailed_test_plan.csv`、`tests.list`、`filelist.f`、自动生成的interface/connect、
testbench、命名assertion/cover和VCS运行说明。聚合preflight会校验环境集合以及上述批准
下界，缺少模块或降到下界以下会返回非零。

## 3. README 点名路径与源码 finding

README 点名的AG组合落在 `AG-FP-05-S07`：fresh owner先形成
`lag_ex1_stall_ori=1`，下一拍 `idu_lsu_rf_older_vld=1`、
`mmu_lsu_pa_vld=0`，由已建立owner的延迟access-fault形成
`lsu_mmu_abort=1`；预期 `lsu_lrq_create_frz=0` 且
`lag_ex1_stall_restart_entry` 非零。该路径由真实MMU输入驱动，未直接强制DUT输出。

AG reference model本地执行211个case，并机械确认三个源码finding：

1. RTU high-half helper对halfword地址加2；
2. LRQ entry没有保存replay `halt_info`，存在owner来源风险；
3. 四个unit-stride data index均选择同一64-byte line，跨line访问存在风险。

这些是静态源码finding；其中testbench使用 `KNOWN_DESIGN_ERROR` 追踪，但本机没有VCS
日志，不能表述成动态复现结果。

## 4. 生产源与 standalone 依赖边界

- RB纳入生产 `srcs/xx_lsu_rb_entry.sv`；编码器、ID FIFO、pending-address、
  rotate、`xx_lsu_rb_data`、clock/IID helper仍为 `PENDING_FULL_CHIP`。
- LRQ纳入生产 `srcs/xx_lsu_lrq_entry.sv`；clock/IID helper仍为
  `PENDING_FULL_CHIP`。
- LFB纳入生产 `srcs/xx_lsu_lfb_addr_entry.sv`。仓库未提供
  `srcs/xx_lsu_lfb_data_entry.sv`，同名兼容模型仅用于standalone结构边界，不能作为
  data-entry生产签核。expand、ECC encode、pending-address及clock helper同样为
  `PENDING_FULL_CHIP`。
- AG、DC、DA和WB清单中的clock、IID compare、vector mask/rotate及ECC helper均在
  各自 `module.json` 显式登记；不得静默替代生产定义。

## 5. Waiver 清单

`waive/interaction_2_1_code_waiver_manifest.csv` 从
`waive/07_xxx_代码与功能覆盖率排除说明文档.docx` 的第1.x节提取并与工作簿逐行
核对，共197条：line 7、branch 9、condition 156、toggle 20、FSM 5。原文中的
“同理排除”引用保持在同一条记录中，历史 `wk_lsu_*` 对象与本仓库可定位的
`srcs/xx_lsu_*` 映射同时保留。

`waive/08-xxx_代码与功能覆盖率排除列表.xlsx` 的“代码waiver”与manifest精确一致，
已清除CP0示例；“功能waiver”仅保留双层17列表头。DOCX第二章只有模板占位，因此
功能waiver数据行为0，没有补造需求编号、责任人、审核人或审批结论。

## 6. 本地静态复核命令

```bash
python3 -m unittest discover -s tests -v
python3 verif/common/tools/preflight.py --all
make -C verif/common preflight
python3 tools/check_interaction_2_1_waiver.py
git diff --check
```

预期关键标记：

```text
REFERENCE_MODEL_PASS cases=211 source_findings=3
INTERACTION_2_1_PREFLIGHT_PASS environments=7 features=85 scenarios=534
WAIVER_WORKBOOK_PASS code_rows=197 function_rows=0 line=7 branch=9 condition=156 toggle=20 fsm=5
```

## 7. 有许可证主机的动态命令

```bash
make -C verif/common compile VCS=/path/to/vcs
make -C verif/common regress VCS=/path/to/vcs
make -C verif/common coverage VCS=/path/to/vcs URG=/path/to/urg
```

动态关闭还必须审查每个compile/test日志、所有85个testcase结果、VDB merge、
功能/代码/assertion coverage及full-chip生产依赖替换。任何一项缺失时，不能把本报告的
静态PASS升级为动态签核PASS。
