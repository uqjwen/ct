# `xx_lsu_ld_ag` VCS 验证环境与结果

## 1. 验证目标与基线

- README 任务：interaction 1.9 第 1 项。
- RTL 基线：`eed0c287fae12ab41372a109c49ab422bc84040b`。
- DUT：未修改的 `srcs/xx_lsu_ld_ag.sv`。
- 功能基线：`doc-ag/xx_lsu_ld_ag_feature_test_plan.md` 的 12 行功能点。
- 验证方法：directed stimulus、确定性 random 循环、scoreboard、
  SystemVerilog assertion、cover property、VCS code/assert coverage 和
  URG merge。

环境位于 `verif/xx_lsu_ld_ag/`。它的目标是让一台已经安装 Synopsys
VCS/URG 且具有许可证的 Linux 主机可以从仓库根目录直接编译和回归。

## 2. 为什么需要 standalone compatibility layer

仓库没有提供以下生产依赖：

- 工程宏定义头文件；
- `gated_clk_cell`；
- `xx_lsu_compare_iid`；
- `xx_lsu_vmask_gen`；
- `xx_lsu_vreg_mask`；
- `xx_lsu_us_bytes_gen`；
- `xx_lsu_ld_vreg_rot`。

因此直接对当前 `srcs/xx_lsu_ld_ag.sv` 做 standalone elaboration 会出现
未定义宏/module。`tb/xx_lsu_ld_ag_defs.svh` 和
`tb/xx_lsu_ld_ag_deps.sv` 提供了验证专用定义，使 AG 的活动控制和
数据选择逻辑可以独立测试。

边界必须明确：这些 helper model 只用于隔离 AG，不能证明生产 vector
helper、IID 环形比较器或门控时钟 cell 的内部实现正确。对应
AG-FP-10/11 保持 `PENDING_FULL_CHIP`，完整工程应替换为生产定义后再跑。

## 3. 环境结构

| 文件 | 作用 |
|---|---|
| `Makefile` | preflight、VCS compile、单测、回归和 URG coverage |
| `filelist.f` | 宏、依赖、DUT、assertion、testbench 的固定编译顺序 |
| `tools/gen_dut_if.py` | 从 non-ANSI DUT 声明生成 258-port interface/named connection |
| `tools/check_completeness.py` | 检查 12/12 功能点均有 test/check/coverage/closure |
| `tools/reference_model.py` | 地址、mask、MMU owner、canonical 和源码 finding 的本地模型 |
| `tb/xx_lsu_ld_ag_if.sv` | 自动生成的 DUT interface 和输入 idle task |
| `tb/xx_lsu_ld_ag_connect.svh` | 自动生成的 258 个 named-port connection |
| `tb/xx_lsu_ld_ag_deps.sv` | 六个缺失生产依赖的验证专用模型 |
| `tb/xx_lsu_ld_ag_assertions.sv` | 12 组 checker 和 12 组 cover property |
| `tb/xx_lsu_ld_ag_tb.sv` | 12 个 testcase、driver、scoreboard、known-finding 记录 |
| `coverage_matrix.csv` | 功能点到 testcase/checker/coverage/result 的追踪矩阵 |
| `tests.list` | 回归 testcase 清单 |

## 4. 运行方法

从仓库根目录执行。

也可以先进入环境目录，再使用短命令：

```bash
cd verif/xx_lsu_ld_ag
make preflight
make compile
make run TEST=tc_mmu_fault_persistence SEED=19
make regress SEED=19
make coverage SEED=19
```

### 4.1 不需要 VCS 的前置检查

```bash
make -C verif/xx_lsu_ld_ag preflight
```

等价的关键命令是：

```bash
python3 verif/xx_lsu_ld_ag/tools/gen_dut_if.py --check
python3 verif/xx_lsu_ld_ag/tools/check_completeness.py
python3 verif/xx_lsu_ld_ag/tools/reference_model.py
```

`make preflight` 会确认 258 个端口没有漂移、12/12 功能点完整映射，并
执行 211 个 reference cases。任何缺少的 testcase/checker/coverage
条目都会使命令非零退出。

### 4.2 VCS 编译

```bash
make -C verif/xx_lsu_ld_ag compile
```

若 VCS 不在 `PATH`：

```bash
make -C verif/xx_lsu_ld_ag compile VCS=/opt/synopsys/vcs/bin/vcs
```

默认启用：

```text
-full64 -sverilog -debug_access+all -kdb -lca
-cm line+cond+fsm+tgl+branch+assert
```

编译日志保存在 `verif/xx_lsu_ld_ag/build/logs/compile.log`。

### 4.3 单个 testcase

```bash
make -C verif/xx_lsu_ld_ag run TEST=tc_mmu_fault_persistence SEED=19
```

其它例子：

```bash
make -C verif/xx_lsu_ld_ag run TEST=tc_rf_capture_replay
make -C verif/xx_lsu_ld_ag run TEST=tc_unit_stride_two_phase
```

testbench 使用 `+TEST=$(TEST)` 选择任务。普通 checker 失败调用 `$fatal`；
已由源码确认、专门用于抓取现有错误的情形打印
`KNOWN_DESIGN_ERROR`，使其能进入同一次 coverage regression，而不会被
误写成“RTL 已修复”。

### 4.4 完整回归与 coverage

```bash
make -C verif/xx_lsu_ld_ag regress SEED=19
make -C verif/xx_lsu_ld_ag coverage SEED=19
```

`make regress` 顺序运行 `tests.list` 的 12 个 testcase，每个 testcase
使用独立 VDB 和日志。`make coverage` 再调用 URG 合并，HTML/text 报告
位于：

```text
verif/xx_lsu_ld_ag/build/urg_report/
```

清理命令：

```bash
make -C verif/xx_lsu_ld_ag clean
```

## 5. 12/12 功能点完备性

| ID | Testcase | Checker | Coverage | 当前结果 |
|---|---|---|---|---|
| AG-FP-01 | `tc_rf_capture_replay` | `CHK_FP01_OWNER_STABLE` | `COV_FP01_OWNER` | `BLOCKED_NO_VCS` |
| AG-FP-02 | `tc_scalar_va_cross_page` | `CHK_FP02_ADDR_MASK` | `COV_FP02_ADDR_SIZE` | `BLOCKED_NO_VCS` |
| AG-FP-03 | `tc_mmu_hit_miss_abort` | `CHK_FP03_MMU_OWNER` | `COV_FP03_MMU_RESULT` | `BLOCKED_NO_VCS` |
| AG-FP-04 | `tc_mmu_fault_persistence` | `CHK_FP04_FAULT_TRANSFER` | `COV_FP04_FAULT_DELAY` | `BLOCKED_NO_VCS` |
| AG-FP-05 | `tc_stall_restart_owner` | `CHK_FP05_RESTART_OWNER` | `COV_FP05_STALL_REASON` | `BLOCKED_NO_VCS` |
| AG-FP-06 | `tc_dcache_bank_requests` | `CHK_FP06_DC_REQ_VALID` | `COV_FP06_BANK_INDEX` | `BLOCKED_NO_VCS` |
| AG-FP-07 | `tc_unit_stride_two_phase` | `CHK_FP07_US_SEQUENCE` | `COV_FP07_US_WAY` | `BLOCKED_NO_VCS` |
| AG-FP-08 | `tc_exception_priority` | `CHK_FP08_EXCEPTION_AGGREGATES` | `COV_FP08_EXCEPTION_KIND` | `BLOCKED_NO_VCS` |
| AG-FP-09 | `tc_lrq_create_freeze` | `CHK_FP09_LRQ_OWNER` | `COV_FP09_LRQ_STATE` | `BLOCKED_NO_VCS` |
| AG-FP-10 | `tc_tcm_atomic_commit` | `CHK_FP10_ATOMIC_COMMIT` | `COV_FP10_SPECIAL_SOURCE` | `PENDING_FULL_CHIP` |
| AG-FP-11 | `tc_vector_masks` | `CHK_FP11_VECTOR_KNOWN` | `COV_FP11_VECTOR_MODE` | `PENDING_FULL_CHIP` |
| AG-FP-12 | `tc_flush_clock_gating` | `CHK_FP12_FLUSH_CLEARS` | `COV_FP12_FLUSH_POINT` | `BLOCKED_NO_VCS` |

这里的“12/12”表示**结构追踪完备**：每一项都有激励、检查、覆盖目标和
关闭标准。它不表示已经取得 100% functional/code coverage。本机没有
VCS/URG，真实覆盖率只能在上述命令完成后由 URG 报告证明。

动态签核还要求：

1. 12 个 testcase 全部完成且没有普通 `$fatal`；
2. 每行矩阵指定的 cover property 命中；
3. P0 功能覆盖 100%，P1 waiver 有书面理由；
4. code coverage 的未覆盖 branch/condition 逐项审查，不用总百分比掩盖；
5. 换回生产 helper、宏和 ICG cell 后重复回归。

## 6. 验证环境针对的现有设计问题

### AG-VE-01：replay `halt_info` owner 错误

`tc_rf_capture_replay` 给 replay owner 和同时存在的 IDU bus 使用互异
`halt_info`。当前 LRQ entry 不保存该字段，AG 在
`srcs/xx_lsu_ld_ag.sv:3102`～`3135` 继续采样 IDU 侧值。testbench 将
打印：

```text
KNOWN_DESIGN_ERROR: replay halt_info is sourced from the current IDU bus instead of LRQ
```

这是已由源码确认的 P2 debug 功能错误；当前主机未运行 VCS，因此结果
状态仍为 `BLOCKED_NO_VCS`，不是伪造的动态失败。

### AG-VE-02：512-bit unit-stride 跨 64-byte line

`tc_unit_stride_two_phase` 除四个 way 的两拍流程外，还将起始地址放在
line 尾部。当前四组 data index 在 `srcs/xx_lsu_ld_ag.sv:2636`～
`2639` 全部选择同一个 `{PA[13:6],way}`，测试会记录：

```text
KNOWN_DESIGN_ERROR: cross-line 512-bit unit-stride access exposes only one line index
```

若系统合同保证 producer 在 AG 前拆分所有跨 line 请求，应在完整工程
加入 producer assertion，并将该项按合同关闭；否则当前 AG 不足以取回
第二条 line，属于 P1 影响的功能错误。

### AG-VE-03：当前源码交付不能原样 standalone elaboration

六个 module 和工程宏头缺失是确定的源码交付/集成问题。验证环境用明确
标注的 model 绕过该阻塞，但这不能替代把生产文件加入正式 filelist。
尤其 TCM 当前在 AG 内固定不命中，vector helper 又不在仓库，因此
AG-FP-10/11 必须在完整工程重跑。

## 7. 当前主机实际执行结果

| 检查 | 实际结果 |
|---|---|
| `command -v vcs/urg/verdi` | 均未找到 |
| 自动 wrapper | 258/258 ports 一致 |
| feature traceability | 12/12 rows 有 testcase/checker/coverage/closure |
| reference model | 211 cases 通过，3 个源码 finding 被机械确认 |
| VCS compile/simulation | `BLOCKED_NO_VCS` |
| URG functional/code coverage | `BLOCKED_NO_VCS` |
| 生产 helper/full-chip 回归 | `PENDING_FULL_CHIP` |

因此本报告能证明验证环境和完备性机制已经构建，但不能在没有商业工具的
Mac 主机上声称 VCS regression 或覆盖率已经通过。
