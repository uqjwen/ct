# Interaction 2.3 CP0 交付闭环审查

## 结论与范围

`README.md` 中 Interaction 2.3 的“详细设计文档”交付由[CP0 系统、中断与异常详细设计](../doc-cp0/wk_cp0_system_interrupt_exception_detailed_design.md)闭环。本审查的源码基线是 `473b3c23794a7841f3c31fc667a4964fda9a28d4`；人工和机械审查的唯一 CP0 RTL 输入为 `cp0/wk_cp0_top.v`、`cp0/wk_cp0_iui.v`、`cp0/wk_cp0_regs.v` 与 `cp0/wk_cp0_lpmd.v`。

本分支没有修改生产 RTL、`srcs/` 或 `README.md`。这里的“闭环”是文档、静态合同和既有 preflight 的闭环，不是 CP0 的编译、仿真、回归、断言、代码覆盖率或功能覆盖率签核。

## 可复跑静态证据

以下命令于本分支仓库根目录重新执行；数字是本次执行的实际计数。

|检查|命令|本次结果|
|---|---|---|
|CP0 静态合同|`python3 tools/check_interaction_2_3_cp0_contract.py`|`CP0_CONTRACT_PASS modules=4 submodules=3 interrupt_sources=8 priority_slots=15 live_slots=13 delegable_exceptions=12 ack_consumers=0`|
|CP0 单元/变异测试|`python3 -m unittest tests.test_interaction_2_3_cp0_contract -v`|6 tests，0 failures，`OK`|
|全仓 Python 单元测试|`python3 -m unittest discover -s tests -v`|83 tests，0 failures，`OK`|
|既有 LSU preflight|`make -C verif/common preflight`|7 environments、85 features、534 scenarios；`LSU_PREFLIGHT_PASS` 与 `INTERACTION_2_1_PREFLIGHT_PASS`|
|空白错误|`git diff --check`|exit 0，无输出|
|生产范围|`git diff 473b3c2...HEAD -- cp0 srcs README.md`|exit 0，无输出（0 个 CP0/`srcs`/README 变更）|
|分支状态（创建本报告前）|`git status --short --branch`|`## review/interaction-2.3-v1`；clean baseline，无工作树条目|

合同 marker 证明检查器从当前四个 RTL 文件抽取并核对：四模块/三子模块拓扑、八类中断源、15 个优先级槽（13 live）、12 个有效异常委托 cause、以及 `rtu_cp0_int_ack` 的 0 个语义消费者。它不证明外部宏、完整 CP0 filelist、上游/下游接口时序或动态行为。

## 链接和源码锚点审计

对详细设计与本报告执行只读的 Python 标准库 Markdown-link 审计：逐个解析 `[]()` 中的仓库相对目标，并以仓库根目录归一化后检查存在性。详细设计有 0 个 Markdown 链接；本报告有 5 个，均解析到现存仓库文件（5/5）。

同时对详细设计每个一级章节至少抽样一个已列出的 RTL 锚点，并以当前文件行号读取：§1 `wk_cp0_top.v:1042`、§2 `wk_cp0_iui.v:1406`、§3 `wk_cp0_regs.v:2646`、§4 `wk_cp0_regs.v:2144`、§5 `wk_cp0_lpmd.v:161`、§6 `wk_cp0_iui.v:2004`、§7 `wk_cp0_regs.v:3207`、§8 `wk_cp0_regs.v:5597`。8/8 样本均在当前文件范围内且为非空 RTL 行；此审计只确认定位与源码可读，不能替代语义仿真。

可复跑的只读审计逻辑见本任务执行证据；其输入是本文和详细设计，且不写入仓库文件。

## 动态签核边界与待集成问题

静态源码审查不能替代 CP0 compile/simulation/coverage signoff。仓库仍缺完整 CP0 filelist、外部模块和 `WK_MAJOR_*` 宏配置；因此以下九项保持“待集成确认”，直到系统 owner review 和动态测试关闭，且均不认定为已确认 bug：

1. `rtu_cp0_int_ack` 无消费者，request 撤销是否完全依赖 source/pending。
2. `cp0_mret/cp0_sret` 类型输出未直接带 `iui_privilege`，非法 xRET 是否避免 return-path 副作用。
3. `cp0_expt_vld` 在 flush 或后续 EX2 更新前保持，IU 消费端的 valid/flush 合同。
4. `medeleg` 的 bit 0 可写而 cause 0 无 one-hot decode，cause 0 不委托是否符合预期。
5. `mtvec/stvec` 的 mode[1] 在 CSR readback/VBR 被清零，非法 vector-mode 的 WARL 可见行为。
6. `rtu_cp0_expt_vld` 与 `rtu_yy_xx_expt_vld` 控制不同状态，dual-valid 周期一致性。
7. `ADD_AIA`、IMSIC 与仓库外 `WK_MAJOR_*` 宏的 filelist/configuration/function closure。
8. `cp0_ifu_vbr` 仅给 base/mode，IFU/下游 vector offset、对齐和采样时刻。
9. `biu_cp0_ss_int` 置位后的 `mvssip` sticky 行为，软件清除、重复置位和输入回落协议。

## 紧凑工件索引

|工件|用途|
|---|---|
|[详细设计](../doc-cp0/wk_cp0_system_interrupt_exception_detailed_design.md)|实现路径、验证合同、9 项集成问题和 RTL 锚点。|
|[静态检查器](../tools/check_interaction_2_3_cp0_contract.py)|从四个权威 CP0 RTL 文件提取并核对机械合同。|
|[检查器测试](../tests/test_interaction_2_3_cp0_contract.py)|真实 RTL 正例与 priority/topology/ack/source 变异拒绝。|
|[README](../README.md)|Interaction 2.3 的原始交付入口。|
