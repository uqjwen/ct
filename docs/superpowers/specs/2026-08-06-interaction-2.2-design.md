# Interaction 2.2 设计说明

## 1. 目标

本轮关闭 README `interaction 2.2` 的两个问题：

1. 明确 AG-FP-05 中“真实 MMU 输入驱动、未直接强制 DUT 输出”的含义，并回答该路径是否属于 DUT 功能点；
2. 按新增 CP0 覆盖率排除说明文档，完善 CP0 专用 Excel 工作簿。

交付必须可追踪、可重复生成、可机械检查。静态文档和工作簿检查不替代 VCS/URG 动态签核。

## 2. 权威输入与范围

权威输入为：

- `README.md` 中的 `interaction 2.2`；
- `srcs/xx_lsu_ld_ag.sv`；
- `verif/xx_lsu_ld_ag/tb/xx_lsu_ld_ag_tb.sv` 与 assertion 文件；
- `waive/08-cp0_代码与功能覆盖率排除列表.docx`；
- `waive/08-cp0_代码与功能覆盖率排除列表.xlsx`。

不修改生产 RTL，不重新设计 AG 逻辑，不补造 CP0 需求编号、提出人、审核人、审批人或日期。仓库中的 Office 临时锁文件不属于本任务，不作处理。

## 3. 方案决策

采用逐条可追踪方案：一个 DOCX 编号项或一个独立 toggle 对象形成一条 manifest 记录。该方案相较按章节合并，能直接对应覆盖率工具中的 waiver；相较把“同理排除”全部拆散，能保持源文档的分组语义。

规则如下：

- `同 line 覆盖率排除`：为 Branch 类型复用对应的 Line 条目，形成独立 Branch 记录；
- `同理排除`：与主条目保留在同一记录内，不拆成缺少上下文的孤立行；
- `无`：不生成数据行；
- 第二章“未覆盖功能点情况”为“无”，因此功能 waiver 工作表数据行数为 0。

## 4. AG-FP-05 澄清设计

### 4.1 结论

AG-FP-05-S07 是 DUT 功能点和可执行的 DUT 场景。原文中的“未直接强制 DUT 输出”只描述 testbench 的驱动方法，不表示该场景在 DUT 之外。

### 4.2 信号边界

环境驱动以下 DUT 输入以形成真实因果链：

- `dcache_arb_lag_ex1_sel=0`：建立结构 stall；
- `idu_lsu_rf_older_vld=1`：更老 RF 请求覆盖当前 owner；
- `mmu_lsu_pa_vld=0`：MMU 尚未返回有效 PA；
- `mmu_lsu_access_fault=1`：在已建立 stall owner 后返回延迟 access fault；
- `lrq_lsu_ex1_lrqid`：提供创建 LRQ owner 的 entry id。

DUT 内部从这些输入计算：

- `ld_ag_stall_mask`；
- `lag_bkcon_stall_already` 与 `lag_mmu_acfault`；
- `lag_lrq_create_already` 与已保存的 LRQ id。

testbench 只观察、不驱动以下 DUT 输出：

- `lsu_mmu_abort=1`；
- `lsu_lrq_create_frz=0`；
- `lag_ex1_stall_restart_entry != 0`。

因此该场景验证的是：当纯 TLB miss 因独立 abort 原因转为 aborted miss 时，LRQ owner 必须从 frozen 状态切换为可立即重发，且 restart bitmap 必须指向已创建 owner。

### 4.3 文档和测试变更

- 在 AG 功能点/test plan 中加入输入、内部派生、输出三类信号说明；
- 在 VCS 运行说明中解释“不 force 输出”的验证原则；
- 把 testbench 中容易产生歧义的注释改为“驱动上游输入并观察 DUT 输出”；
- 添加静态回归测试，验证三类信号方向、因果链和 `BLOCKED_NO_VCS` 动态边界均有明确文字。

## 5. CP0 waiver 数据模型

### 5.1 数量合同

|覆盖率类型|wk_cp0_regs|wk_cp0_iui|wk_cp0_lpmd|合计|
|---|---:|---:|---:|---:|
|Line|1|2|1|4|
|Branch|2|2|1|5|
|Condition|7|3|1|11|
|Toggle|19|6|0|25|
|FSM|0|0|0|0|
|合计|29|13|3|45|

### 5.2 Manifest 字段

新增 `waive/interaction_2_2_cp0_code_waiver_manifest.csv`，包含以下 11 列且顺序固定：

- `coverage_type`；
- `source_object`；
- `module`；
- `source_section`；
- `condition`；
- `reason`；
- `impact`；
- `alternative`；
- `property`；
- `term`；
- `remarks`。

`condition` 和 `reason` 保留 DOCX 的技术含义；截图中的可读行号作为对象位置补充，但不把图片外推成源文档未声明的结论。

统一边界字段为：

- `impact`：仅影响所列代码覆盖率统计，不替代功能正确性或动态回归签核；
- `alternative`：静态代码审查，并按 tie-off、保留域、未实现特性或协议不变量选择相应定向验证；
- `property`：`DOCX代码覆盖率排除项`；
- `term`：`待项目评审确认`；
- `remarks`：记录 CP0 DOCX 文件名、来源章节和“同理排除/同 line”关系。

### 5.3 Excel 映射

`代码waiver` 工作表按以下顺序填充 17 列：

1. 对象名称：coverage 类型；
2. 对象位置：源对象和可读代码位置；
3. 所属模块/子系统：`wk_cp0_regs`、`wk_cp0_iui` 或 `wk_cp0_lpmd`；
4. 规范/需求编号：CP0 DOCX 来源章节；
5. 排除条件描述；
6. 排除原因；
7. 影响评估；
8. 替代验证手段；
9. 属性；
10. 计划期限；
11–16. 提出、审核、审批角色/姓名/日期：全部留空；
17. 备注：来源与分组关系。

`功能waiver` 工作表清除模板示例，只保留双层 17 列表头。不得保留 `张三`、`李四`、`王五` 或 `xxx`。

## 6. 工作簿生成与样式

使用 `@oai/artifact-tool` 导入并修改现有工作簿，不使用 `openpyxl`、`xlsxwriter`、pandas 或通用 Excel 写入库。经用户明确选择方案 A，允许一个窄范围标准库 OOXML 后处理器：它只能向两个工作表写入冻结前两行的 `sheetViews/pane`，不得改动任何单元格、样式、合并关系、共享字符串、工作表名称或其他 ZIP 条目内容。生成流程执行以下步骤：

1. 导入 CP0 XLSX；
2. 保存修改前两个工作表的渲染证据；
3. 清除第 3 行之后的模板示例和旧内容；
4. 复制模板数据行格式，写入 45 条 manifest 数据；
5. 保留双层表头、合并单元格、宋体、蓝色表头、边框和 17 列顺序；
6. 按内容长度设置 wrap、列宽和自适应行高；
7. 调用 Artifact Tool 冻结 API；
8. 扫描公式错误、渲染代码表首段/末段和功能表，并导出回原 CP0 XLSX 路径；
9. 由窄范围 OOXML 后处理器补写 Artifact Tool 2.8.39 未能序列化的两处冻结窗格，并验证除两个 worksheet XML 外的 ZIP 条目内容均未变化。

管理审批列必须为空。视觉修复不得改变模板的整体视觉语言。

## 7. 可重复检查

新增独立检查器和回归测试，至少验证：

- manifest 正好 45 行；
- 类型计数为 Line 4、Branch 5、Condition 11、Toggle 25、FSM 0；
- 模块计数为 29、13、3；
- 工作簿 `代码waiver` 与 manifest 逐行一致；
- `功能waiver` 数据行为 0；
- K–P 列全部为空；
- 示例姓名和 `xxx` 已清除；
- 两层表头、17 列和关键 merge 保留；
- 两个工作表均包含 `ySplit=2`、`topLeftCell=A3` 的冻结窗格；
- 冻结窗格后处理只改变两个 worksheet XML，其他 ZIP 条目内容哈希不变；
- 无公式错误；
- AG 文档明确该路径是 DUT 功能点，且 testbench 未 force DUT 输出；
- 现有 interaction 1.6–2.1 测试继续通过。

## 8. 错误处理与签核边界

- 源文档条目数、manifest 数量或工作簿数量不一致时，生成器/检查器返回非零；
- 不把空审批字段当作错误，它们是经用户确认的真实性边界；
- 本机没有 VCS/URG 时，AG 动态状态继续为 `BLOCKED_NO_VCS`；
- 不以 Python 单元测试、静态 preflight 或工作簿检查宣称仿真/覆盖率已通过；
- 最终在合并后的 `main` 上重新运行完整测试和工作簿检查，随后非强制推送。

## 9. 预期交付文件

- `docs/interaction-2.2-followup-review.md`；
- AG 功能点与 VCS 说明的澄清修改；
- testbench 注释澄清；
- `waive/interaction_2_2_cp0_code_waiver_manifest.csv`；
- `waive/08-cp0_代码与功能覆盖率排除列表.xlsx`；
- `tools/build_interaction_2_2_cp0_waiver.mjs`；
- `tools/check_interaction_2_2_cp0_waiver.py`；
- `tests/test_interaction_2_2_ag_clarification.py`；
- `tests/test_interaction_2_2_cp0_waiver.py`。
