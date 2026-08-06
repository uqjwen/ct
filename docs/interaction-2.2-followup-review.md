# Interaction 2.2 收尾复核

## 结论

`AG-FP-05-S07` 是 DUT 功能点；“由真实 MMU 输入驱动、未直接强制 DUT 输出”说明的是验证方法，而不是把该场景排除在 DUT 功能之外。testbench 通过上游输入形成因果链，三个目标输出均由 DUT 产生：`lsu_mmu_abort`、`lsu_lrq_create_frz` 与 `lag_ex1_stall_restart_entry` 只被观察，不由 testbench 直接赋值或 `force`。本机证据是静态 driver/assertion/cover 与结构检查，AG 动态状态仍为 `BLOCKED_NO_VCS`。

CP0 工作簿已通过内容和归档结构检查：`CP0_WAIVER_WORKBOOK_PASS code_rows=45 function_rows=0 line=4 branch=5 condition=11 toggle=25 fsm=0`。`CP0_WAIVER_PANES_PASS sheets=2 rows=2` 证明两个工作表均已序列化冻结前两行。工作簿内容与样式由 Artifact Tool 生成；用户明确选择方案 A 后，标准库终结器仅向两个解析到的 worksheet XML payload 补写冻结窗格，并在替换前后证明其余 ZIP payload 字节不变。K–P 管理字段按用户确认保持空白，模板示例已清除。

这些结论不等于 VCS/URG 动态签核。本机静态测试、preflight 和工作簿检查均不能替代 VCS 编译、仿真、功能覆盖率或代码覆盖率；在具备许可的主机取得 VCS 日志及 VDB/URG 结果前，AG 仍为 `BLOCKED_NO_VCS`。

## 范围与可追踪输入

- 用户问题和验收边界：[README.md](../README.md) 的 `interaction 2.2` 段落。
- AG 设计边界与动态签核限制：[设计说明](superpowers/specs/2026-08-06-interaction-2.2-design.md) 第 4、6、8 节。
- AG 方案和可执行场景：[AG 功能点计划](../doc-ag/xx_lsu_ld_ag_feature_test_plan.md) 的 `AG-FP-05-S07 的 DUT 边界`；运行方法见 [AG VCS 说明](../doc-ag/xx_lsu_ld_ag_vcs_verification.md)。
- 方向、真实输入刺激和 observation-only 输出的独立静态检查：[tools/check_interaction_2_2_ag_boundary.py](../tools/check_interaction_2_2_ag_boundary.py)。
- CP0 源说明、45 行追踪表和最终工作簿：[CP0 DOCX](../waive/08-cp0_代码与功能覆盖率排除列表.docx)、[manifest](../waive/interaction_2_2_cp0_code_waiver_manifest.csv)、[XLSX](../waive/08-cp0_代码与功能覆盖率排除列表.xlsx)。
- CP0 独立读取检查与窄范围 pane 终结器：[check_interaction_2_2_cp0_waiver.py](../tools/check_interaction_2_2_cp0_waiver.py)、[finalize_interaction_2_2_cp0_waiver.py](../tools/finalize_interaction_2_2_cp0_waiver.py)。

## AG-FP-05-S07 的输入、内部状态与输出

|类别|信号与职责|边界|
|---|---|---|
|上游输入|`dcache_arb_lag_ex1_sel=0` 建立结构 stall；`idu_lsu_rf_older_vld=1` 覆盖当前 owner；`mmu_lsu_pa_vld=0` 与 `mmu_lsu_access_fault=1` 形成延迟 aborted miss；`lrq_lsu_ex1_lrqid` 提供已创建 LRQ owner|testbench 驱动 DUT 输入。|
|DUT 内部派生|`ld_ag_stall_mask`、`lag_bkcon_stall_already`、`lag_mmu_acfault`、`lag_lrq_create_already` 与已保存的 LRQ id|由 RTL 从输入和时序状态计算。|
|DUT 输出|`lsu_mmu_abort=1`、`lsu_lrq_create_frz=0`、`lag_ex1_stall_restart_entry != 0`|testbench 只观察；不得直接赋值或 `force`。|

因此，纯 TLB miss 与 aborted miss 的差异由 DUT 因果链判定：前者保持 frozen；后者在独立 access fault 使 abort 产生后，允许既有 LRQ owner 立即重发，并以非零 restart bitmap 指向该 owner。独立检查器的本次结果为：

```text
AG_FP05_DUT_BOUNDARY_PASS inputs=4 outputs=3
```

## CP0 waiver 结果与授权边界

`代码waiver` 有 45 条数据：line 4、branch 5、condition 11、toggle 25、fsm 0；`功能waiver` 有 0 条数据。两张表保留双层 17 列表头和既有样式，数据行 K–P 均为空，`张三`、`李四`、`王五`、`xxx` 等模板示例不在交付内容中。

Artifact Tool 负责导入、内容写入、样式、合并关系、共享字符串和工作簿元数据。其冻结 API 未将 pane 写入 XLSX 时，用户方案 A 仅授权一个标准库 OOXML 后处理步骤。该终结器：

- 只通过 `xl/workbook.xml` 和 `xl/_rels/workbook.xml.rels` 定位 `代码waiver`、`功能waiver`；
- 仅在两个 worksheet XML 中插入一处 `sheetViews/sheetView/pane`，其 `ySplit=2`、`topLeftCell=A3`、`activePane=bottomLeft`、`state=frozen`；
- 拒绝既有 view/pane、重复 ZIP 条目、非预期 sheet 集或目标；
- 保持 ZIP 条目顺序、ZipInfo 元数据和 archive comment，并在原子替换前后比较解压 payload：改变集必须且只能是这两个 worksheet XML。

这不是对 XLSX 内容或样式的第二套作者工具；它是用户批准的、范围固定的 pane 序列化终结器。独立检查器的本次标记为：

```text
CP0_WAIVER_WORKBOOK_PASS code_rows=45 function_rows=0 line=4 branch=5 condition=11 toggle=25 fsm=0
```

## 本机验证证据

以下命令均从仓库根目录执行；除 compile probe 外退出码均为 0。

|命令|本次结果|
|---|---|
|`python3 tools/check_interaction_2_2_ag_boundary.py`|`AG_FP05_DUT_BOUNDARY_PASS inputs=4 outputs=3`。|
|`python3 -m unittest tests.test_interaction_2_2_ag_clarification tests.test_interaction_2_2_cp0_waiver -v`|13 tests，0 failures，`OK`。|
|`python3 -m unittest discover -s tests -v`|53 tests，0 failures，`OK`。|
|`make -C verif/common preflight`|7 environments、85 features、534 scenarios：`LSU_PREFLIGHT_PASS` 与 `INTERACTION_2_1_PREFLIGHT_PASS`。|
|`python3 tools/check_interaction_2_1_waiver.py`|`WAIVER_WORKBOOK_PASS code_rows=197 function_rows=0 line=7 branch=9 condition=156 toggle=20 fsm=5`。|
|`python3 tools/check_interaction_2_2_cp0_waiver.py`|45/0 行及 4/5/11/25/0 计数 marker。|
|`unzip -t "waive/08-cp0_代码与功能覆盖率排除列表.xlsx"`|9 个 archive entries 均为 `OK`；压缩数据未发现错误。|
|`git diff --check`|退出 0，无 whitespace error。|

聚合 preflight 的逐环境结果为：AG 12/96、DA 12/72、DC 12/72、WB 12/72、LFB 13/78、LRQ 12/72、RB 12/72（features/scenarios）；合计正好 85/534。

## VCS/URG 环境边界与许可主机步骤

本机执行 `make -C verif/common compile` 的 make 退出码为 2。该目标先完成全部静态 preflight，随后在 VCS 可执行文件探测处输出：

```text
ERROR: Synopsys VCS not found; set VCS=/path/to/vcs on a licensed host.
make: *** [compile] Error 127
```

这是一项预期的环境边界，不是 compile PASS，也没有产生编译、仿真、VDB、功能覆盖率或代码覆盖率通过证据。应在已配置许可的主机上从仓库根目录执行：

```bash
make -C verif/common preflight
make -C verif/common compile VCS=/path/to/vcs
make -C verif/common regress VCS=/path/to/vcs SEED=19
make -C verif/common coverage VCS=/path/to/vcs URG=/path/to/urg SEED=19
```

在保存每个环境的 compile/run 日志、回归结果和 URG/VDB 覆盖率报告之前，不得把 `BLOCKED_NO_VCS` 改为 PASS。

## 收尾范围复核

提交本报告前执行：

```bash
git diff origin/main...HEAD -- srcs
git status -sb
git diff --check
```

验收要求是 `srcs/` 没有生产 RTL 差异，且状态中没有未跟踪的 QA 图片、PDF、`node_modules` 或 artifact 目录。本报告只记录证据和限制；它不修改 RTL、源 DOCX、manifest、workbook、builder、checker 或测试。

## 结论性限制

- 静态回归、preflight 和 Office archive 检查通过，只证明其各自的静态合同。
- CP0 的审批/管理字段 K–P 的空白是经用户确认的真实性边界，不是待补的测试失败。
- pane 终结器的唯一允许变更是两个 worksheet XML 的视图 pane；这不扩大到单元格、样式、合并、共享字符串、工作表名称、其他 ZIP payload 或生产 RTL。
- VCS/URG 许可工具不可用仍是唯一阻断动态签核的环境边界；AG 状态为 `BLOCKED_NO_VCS`。
