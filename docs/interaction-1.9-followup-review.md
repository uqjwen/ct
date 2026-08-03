# Interaction 1.9 完成报告

## 1. README 第 1 项：`xx_lsu_ld_ag` VCS 验证环境

已在 `verif/xx_lsu_ld_ag/` 建立 VCS-ready 验证工程，DUT 为未修改的
`srcs/xx_lsu_ld_ag.sv`。环境包含：

- 258-port 自动 interface/named connection；
- 缺失宏和六个 dependency 的 standalone verification model；
- 12 个 directed/random testcase；
- 12 组 assertion/checker 与 12 组 coverage item；
- feature-to-test/check/coverage/result 矩阵；
- VCS compile、单测、regression 和 URG merge 命令；
- 不依赖 VCS 的 completeness gate 和 211-case reference model。

完整说明和运行命令位于
`doc-ag/xx_lsu_ld_ag_vcs_verification.md`。

### 验证完备性的准确边界

`coverage_matrix.csv` 对
`doc-ag/xx_lsu_ld_ag_feature_test_plan.md` 的 12 行实现了 12/12
结构追踪，每一行都有 testcase、checker、coverage 和动态关闭标准。
这证明没有漏掉已列功能点，但不等价于实际 VCS coverage 已完成。

当前 macOS 主机没有 VCS、URG、Verdi 或许可证，故 VCS/URG 结果明确为
`BLOCKED_NO_VCS`。本机实际执行范围是 wrapper regeneration、矩阵完整性、
reference model 和 Python repository regression。生产 helper 与 TCM/
vector 集成还标记为 `PENDING_FULL_CHIP`。

### 当前锁定的设计问题

1. replay 的 `halt_info` 没有保存到 LRQ，AG 会采样同时存在的当前 IDU
   bus；`tc_rf_capture_replay` 使用互异 metadata 定向捕获。
2. 512-bit unit-stride 跨 64-byte line 时，四组 data index 仍只指向同一
   line；`tc_unit_stride_two_phase` 记录该现象。若 producer 保证拆分，
   必须用集成 assertion 关闭，否则属于 P1 影响的功能错误。
3. 仓库缺少 AG 依赖的六个 module 和工程宏头，原始源码集不能直接
   standalone elaboration；环境中的 model 是验证隔离层，不是生产修复。

上述前两项是源码确认并等待 VCS/full-integration 波形闭合的设计问题；
没有把未运行的仿真包装成动态结论。

## 2. README 第 2 项：RTU-RR-02 canonical 实例

已新增 `doc-rtu/xx_rtu_retire_canonical_example.md`，用
`WK_PC_LEN=39` 的具体现场说明：

```text
真实 fault PC        = 0xffffff8000001000
ROB cur_pc           = 0x4000000800
正确 mtval           = 0xffffff8000001000
当前普通 fault mtval = 0x0000018000001000
当前 debug dtval     = 0x0000008000001000
```

低半区 PC 的 sign bit 为 0，所以零扩展和符号扩展数值相同，常规低地址
测试看不出问题；高半区 PC 的 sign bit 为 1，必须填满 `[63:40]`。

文档还单独说明了跨页高半字问题：从
`0xffffff8000000ffe` 跨到 `0xffffff8000001000` 时，当前 helper 对
halfword 编码 `0x40000007ff` 直接加 2，得到完全错误的
`0x0000004000000801`。该地址单位错误与 canonical 扩展错误需要分别
修复。
