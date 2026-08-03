# Interaction 2.0 交付说明

## 1. README要求与完成方式

interaction 2.0指出原有功能点/测试计划不足以让工程师直接编写用例，要求按
“当信号满足具体条件时，则触发具体结果”的形式细化。本次范围承接interaction
1.9，仅细化 `xx_lsu_ld_ag`，未修改DUT RTL。

交付采用两层追踪：

- `coverage_matrix.csv` 保留 `AG-FP-01`～`AG-FP-12` 的feature级testcase、
  checker、coverage、优先级和结果边界；
- `detailed_test_plan.csv` 将每个feature展开为4行，共48行。每行明确setup、
  drive signal、C0/C1或更晚的逐拍操作、以“当”开头的触发条件、以“则”开头
  的预期、expected signal、checker、cover property和关闭标准。

工程师可以按 `testcase` 字段找到现有SystemVerilog task，将 `cycle_sequence`
直接翻译为driver操作，将 `trigger_condition` 和 `expected_result` 翻译为
scoreboard或SVA。人读版本位于
`doc-ag/xx_lsu_ld_ag_feature_test_plan.md`。

## 2. 机器完备性

`verif/xx_lsu_ld_ag/tools/check_completeness.py` 新增详细计划门禁，拒绝：

- CSV schema、场景ID或连续编号错误；
- 任一feature少于4个场景；
- testcase、priority、checker、coverage或result与父项不一致；
- 缺少C0/C1时序或“当/则”语法；
- drive/expected列表包含交付源码中不存在的信号；
- Markdown缺少场景ID、触发条件、预期结果或执行边界。

`tests/test_interaction_2_0_detailed_plan.py` 使用真实校验函数进行mutation检查：
未知信号、错误触发/预期语法、错误父testcase都必须导致门禁失败。测试不通过
grep模拟校验结果。

## 3. 文件清单

- `verif/xx_lsu_ld_ag/detailed_test_plan.csv`：48行机器可读逐拍计划；
- `doc-ag/xx_lsu_ld_ag_feature_test_plan.md`：12节工程师可读计划；
- `verif/xx_lsu_ld_ag/tools/check_completeness.py`：场景、信号和父项校验；
- `tests/test_interaction_2_0_detailed_plan.py`：正向及mutation回归；
- `doc-ag/xx_lsu_ld_ag_vcs_verification.md`：实现与运行方法；
- `docs/superpowers/specs/2026-08-03-interaction-2.0-detailed-test-plan-design.md`：设计；
- `docs/superpowers/plans/2026-08-03-interaction-2.0-detailed-test-plan.md`：实施计划。

## 4. 验证命令与证据

本地静态验证入口：

```bash
python3 -m unittest discover -s tests -p 'test_interaction_2_0_detailed_plan.py' -v
make -C verif/xx_lsu_ld_ag preflight
python3 -m unittest discover -s tests -v
```

门禁成功时必须出现：

```text
COMPLETENESS_PASS features=12 tests=12 checkers=12 coverage_items=12
DETAILED_PLAN_PASS scenarios=48 per_feature_min=4
REFERENCE_MODEL_PASS cases=211 source_findings=3
```

本次工作树实际结果：

| 检查 | 结果 |
|---|---|
| interaction 2.0 focused unittest | 5/5通过 |
| repository full unittest | 20/20通过 |
| generated DUT interface | 258/258 ports一致 |
| feature completeness | 12 features / 12 tests / 12 checkers / 12 coverage items |
| detailed plan completeness | 48 scenarios；每个feature 4行 |
| reference model | 211 cases通过，机械确认3个既有source finding |
| Python syntax compile | 通过 |
| VCS compile | `ERROR: Synopsys VCS not found; set VCS=/path/to/vcs on a licensed host.` |

发布前还执行 `git diff --check`，并确认最终commit对 `srcs/` 的diff为空。

## 5. 动态执行边界

48表示详细场景已经达到可直接编码的粒度，不表示48个子场景已在当前主机完成
VCS仿真。当前Mac若找不到Synopsys VCS/URG，AG-FP-01～09和12仍为
`BLOCKED_NO_VCS`；AG-FP-10/11还需要生产TCM/vector helper和full-chip环境，
仍为 `PENDING_FULL_CHIP`。只有在licensed host扩展相应task、取得simulation
log、cover property命中和URG报告后，才能更新动态结果状态。
