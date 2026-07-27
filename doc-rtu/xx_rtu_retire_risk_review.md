# `xx_rtu_retire` 详细设计审查

## 1. 审查范围与基线

- 被审文件：`srcs/xx_rtu_retire.v`，仓库基线 `acf8463addbedc8c07f24be526e6eba429149741`。
- 参考文件：OpenC910 `C910_RTL_FACTORY/gen_rtl/rtu/rtl/ct_rtu_retire.v`，参考提交 `b91c90914c19f114d35c8f6b73408eb241ed847c`。
- 方法：逐项比较异常、flush、门控时钟、debug、六发射扩展、向量 CSR 更新和性能计数路径；另做端口/声明一致性、输出驱动、0～5 lane 完整性、跨 lane 引用和未使用信号扫描。
- 限制：仓库未提供可独立 elaboration 的完整 RTU 依赖、宏定义和 testbench，因此本报告完成的是静态审查；动态关闭条件见配套验证方案。

## 2. 结论摘要

| ID | 优先级 | 状态 | 结论 |
|---|---:|---|---|
| RTU-RR-01 | P1 | 已确认 | 异步异常在两个关键门控使能中漏项，空闲核上可能丢失 IFU 异常寄存和 ROB flush 的门控资格。 |
| RTU-RR-02 | P1 | 已确认，配置相关 | MMU 开启时，取指异常 `mtval` 和 debug `tval` 对高半区 canonical PC 仍做零扩展；若允许高半区虚拟地址，值错误。 |
| RTU-RR-03 | P2 | 合同依赖 | DTU 同步/组 halt、sync flush、resume 若仅脉冲一拍，保存请求下一拍会被零覆盖；只有 hold-until-consumed 合同才能关闭。 |
| RTU-RR-04 | P2 | 验证义务 | 六退休扩展的组合路径静态完整，但正确性依赖 ROB 保证 valid 连续、异常只位于 slot0、年轻 slot 不在老指令异常时有效。 |
| RTU-RR-05 | P2 | 验证义务 | 同拍多个 `vsetvli` 采用 slot5→slot0 的最年轻优先级；静态未发现漏 lane，仍需与 ROB 年龄顺序合同共同验证。 |
| RTU-RR-06 | P3 | 已确认 | `mmu_xx_mmu_en`、`rob_retire_inst0_ras` 只留在接口，`ifu_dbg_mode_on` 仅声明；属于迁移后的死接口/死寄存器。 |

## 3. 详细发现

### RTU-RR-01：异步异常没有打开 retire/flush 门控

**证据**

1. `retire_async_expt_vld` 在异步异常状态机的 `AE_EXPT` 状态产生：`srcs/xx_rtu_retire.v:3223`。
2. 实际功能 flush 已包含它：`retire_inst0_flush` 的最后一项位于 `srcs/xx_rtu_retire.v:2909`～`2917`。
3. `retire_clk_en` 位于 `srcs/xx_rtu_retire.v:1806`～`1816`，未包含 `retire_async_expt_vld`。
4. `retire_inst0_flush_gateclk` 位于 `srcs/xx_rtu_retire.v:2928`～`2937`，同样未包含该项；其结果继续形成 `retire_rob_flush_gateclk`：`srcs/xx_rtu_retire.v:3034`～`3036`。
5. IFU 异常 valid/vector 使用 `retire_clk` 寄存：`srcs/xx_rtu_retire.v:2115`～`2141`。
6. OpenC910 参考设计在 `retire_clk_en` 和 `retire_inst0_flush_gateclk` 两处都显式包含异步异常。

**风险场景**

当流水线已经空闲，`rob_retire_inst0_vld=0`，也没有 debug/change-flow 等其它 retire 时钟来源时，状态机进入 `AE_EXPT`。`sm_clk` 会因异步异常状态非空闲继续运行，但 `retire_clk` 可能仍关闭；同时实际 ROB flush 为 1、gateclk 资格为 0。这样会形成“功能 valid 有效但消费者门控未打开”的不一致，且 `AE_EXPT` 只停留一拍。

**建议修复**

在以下两个表达式中补入 `retire_async_expt_vld`：

```verilog
assign retire_clk_en = ... | retire_async_expt_vld | ...;
assign retire_inst0_flush_gateclk = ... | retire_async_expt_vld | ...;
```

这是从参考模块扩展/替换 debug 逻辑时产生的简单漏项，建议按 P1 处理。

### RTU-RR-02：高半区虚拟 PC 的 `mtval/dtval` 没有符号扩展

**证据**

- MMU 开启时的取指异常 `mtval` 在 `srcs/xx_rtu_retire.v:2049`～`2055` 生成。普通取指异常分支只在 PC 前放一个 sign bit，其余高位仍填 0；高半字异常分支使用由窄 PC 零扩展后加 2 得到的 `retire_expt_pc_high_hw_expt`：`srcs/xx_rtu_retire.v:3662`。
- debug 非 LSU trigger 的 `retire_dtval` 在 `srcs/xx_rtu_retire.v:3552`～`3561` 生成；`cp0_yy_mmu_en` 的 if/else 两个分支完全相同，均为零扩展。
- 同一文件的 EPC/DPC 已给出正确对照：`rtu_cp0_epc` 在 `srcs/xx_rtu_retire.v:2181`～`2183` 复制 PC sign bit，`retire_dpc` 在 `srcs/xx_rtu_retire.v:3570`～`3574` 也做符号扩展。
- OpenC910 参考设计在 MMU 开启且非异步异常时复制 `mtval_src` 的最高位到高位。

**影响边界**

若实现允许 `PC[WK_PC_LEN-1]=1` 的高半区 canonical 地址，则 instruction page/access fault 的 `mtval` 和 PC 类 debug `tval` 会落入错误的低地址；异常处理程序和调试器得到错误现场。若系统书面限制只执行低半区虚拟地址，该问题可降为 P2，但表达式本身仍是复制/扩展笔误。

**建议修复**

统一复用 EPC/DPC 的 canonical 扩展方式；高半字异常应先在 `WK_PC_LEN+1` 有符号/地址域内计算 `PC+2`，再按 MMU 模式扩展到 64 bit。增加高半区最后半字跨页测试。

### RTU-RR-03：一拍 DTU 请求可能在可消费前被清除

`retire_have_debug_req` 汇总四类请求：`srcs/xx_rtu_retire.v:3267`～`3270`。保存逻辑在 `srcs/xx_rtu_retire.v:3271`～`3287` 中以 `retire_have_debug_req | retire_have_debug_req_f` 为更新条件；当输入只高一拍时，下一拍 `_f=1` 会把四个保存位全部写成当前输入 0。同步/组 halt 的真正消费又要求 `t1_retire_vld`：`srcs/xx_rtu_retire.v:3379`～`3386`。

因此，若请求在 ROB 暂无可退休指令时只脉冲一拍，它最多保存一个额外周期，之后可能消失。以下任一合同成立即可关闭：

1. DTU 在 `rtu_dtu_halt_ack/enter_debug/exit_debug` 等确认前持续保持请求；
2. RTU 保存位改为 set-until-consumed，消费/取消时显式清除。

在没有 DTU producer 代码或接口协议前，本项保持“合同依赖”，不能直接判定为功能 bug。

### RTU-RR-04：六退休扩展依赖 ROB 资格合同

静态扫描确认 slot0～slot5 在 branch/load/store、trace、HPCP、PCFIFO、向量 dirty 和异步异常 no-commit/no-retire 汇总中均完整出现，例如：

- 六路 normal-retire：`srcs/xx_rtu_retire.v:1907`～`1917`；
- 六路 branch/load/store 反馈：`srcs/xx_rtu_retire.v:2394`～`2517`；
- 六路 HPCP valid：`srcs/xx_rtu_retire.v:2726`～`2733`；
- 异步异常等待六路全部空闲：`srcs/xx_rtu_retire.v:3141`～`3155`。

未发现 slot3～5 漏接、跨 lane 取错字段或汇总少一项。但 slot1～5 的 normal-retire 直接等于 ROB valid，没有再次用 slot0 exception/flush 资格屏蔽。因此必须断言 ROB 输出满足连续 valid 和“slot0 异常/暂停时年轻 slot 全无效”的合同。

### RTU-RR-05：多 `vsetvli` 同拍更新取最年轻项

六路 `vsetvli` valid 位于 `srcs/xx_rtu_retire.v:2232`～`2244`；CSR payload mux 在 `srcs/xx_rtu_retire.v:2318`～`2373` 中按 slot0 特殊 `vsetvlx`、再 slot5→slot1、最后 slot0 排序。对于同拍按 slot0 最老、slot5 最年轻的退休包，该顺序能保留最年轻的最终向量状态。静态检查未发现 lane 字段交叉。

关闭本项需要动态覆盖两到六条 `vsetvli` 同拍、slot0 `vsetvlx` 串行约束和非法/FOF 特殊路径，并断言最终 `vl/vtype/vma/vta` 等于程序顺序最后一条有效写。

### RTU-RR-06：迁移后死接口与死寄存器

- `mmu_xx_mmu_en` 仅在端口/声明和已注释旧代码出现：`srcs/xx_rtu_retire.v:43`、`567`、`1127`。
- `rob_retire_inst0_ras` 仅在端口/声明出现：`srcs/xx_rtu_retire.v:137`、`621`、`1288`。
- `ifu_dbg_mode_on` 仅声明：`srcs/xx_rtu_retire.v:1033`。

这不会单独造成当前功能错误，但会误导集成、掩盖连线遗漏并增加 lint 噪声。建议确认 DTU 已不再需要 RAS 分类、MMU enable 已统一为 `cp0_yy_mmu_en` 后删除。

## 4. 未发现的问题

- 513 个 module port 均有匹配的 input/output 声明，未发现重复、缺失或方向冲突。
- 所有 output 都有连续赋值、过程赋值或子模块驱动。
- 六 lane 信号族未发现只覆盖 0～2 而漏掉 3～5 的情况，连续赋值中未发现错误跨 lane 引用。
- VSETVL payload mux 的敏感列表覆盖全部被读字段和选择信号，未发现 latch。
- lane0 的正常退休资格、jump/return 和异常处理与 lane1～5 的不对称均能由“异常只在最老 slot”解释。

以上“未发现”仅代表本轮静态差分和结构扫描没有证据，不替代配套动态验证。
