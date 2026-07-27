# `xx_rtu_retire` 详细设计审查

## 1. 审查范围与基线

- 被审文件：`srcs/xx_rtu_retire.v`；初审基线 `acf8463addbedc8c07f24be526e6eba429149741`，Interaction 1.8 纠偏复核基线 `4a8223a2d80a5da6a7198c6fc89d97790b9729c3`。
- 参考文件：OpenC910 `C910_RTL_FACTORY/gen_rtl/rtu/rtl/ct_rtu_retire.v`，参考提交 `b91c90914c19f114d35c8f6b73408eb241ed847c`。
- 方法：逐项比较异常、flush、门控时钟、debug、六发射扩展、向量 CSR 更新和性能计数路径；另做端口/声明一致性、输出驱动、0～5 lane 完整性、跨 lane 引用和未使用信号扫描。
- 限制：仓库未提供可独立 elaboration 的完整 RTU 依赖、宏定义和 testbench，因此本报告完成的是静态审查；动态关闭条件见配套验证方案。

## 2. 结论摘要

| ID | 优先级 | 状态 | 结论 |
|---|---:|---|---|
| RTU-RR-01 | P1 | 已确认 | 异步异常在两个关键门控使能中漏项，空闲核上可能丢失 IFU 异常寄存和 ROB flush 的门控资格。 |
| RTU-RR-02 | P1 | 已确认 | 跨页 32-bit 指令的高半字异常地址把“半字地址”直接当成“字节地址”加 2，`mtval` 无条件错误；此外高半区 canonical PC 仍有独立的符号扩展缺陷。 |
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

### RTU-RR-02：高半字异常地址丢失地址单位转换，并伴随独立的 canonical 扩展缺陷

**证据**

1. `rob_retire_inst0_cur_pc` 是删去最低位 0 的半字地址，而不是完整字节地址。同文件普通取指异常路径在 `srcs/xx_rtu_retire.v:2049`～`2051` 使用 `{rob_retire_inst0_cur_pc,1'b0}`，EPC 路径在 `srcs/xx_rtu_retire.v:2181`～`2183` 也明确补回 `1'b0`。
2. 高半字路径却在 `srcs/xx_rtu_retire.v:3662` 直接执行 `rob_retire_inst0_cur_pc + 64'd2`，既没有先左移一位恢复字节地址，又在错误的地址单位上加了 2。
3. 例如 32-bit 指令从字节地址 `0xFFE` 开始，保存的 `cur_pc` 为 `0x7FF`。当前表达式给出 `0x7FF + 2 = 0x801`，而发生异常的高半字实际位于 `0x1000`；正确计算应为 `{0x7FF,1'b0} + 2 = 0x1000`。因此用户指出的“未左移 1”就是本项的主要设计 bug，且只要走跨页高半字异常路径就会发生，不依赖高/低半区地址配置。
4. 另有一个彼此独立的缺陷：MMU 开启时，普通取指异常 `mtval` 在 `srcs/xx_rtu_retire.v:2049`～`2055` 只复制一次 sign bit，其余高位补 0；debug 非 LSU trigger 的 `retire_dtval` 在 `srcs/xx_rtu_retire.v:3552`～`3561` 也始终零扩展。`rtu_cp0_epc`（`srcs/xx_rtu_retire.v:2181`～`2183`）和 `retire_dpc`（`srcs/xx_rtu_retire.v:3570`～`3574`）已经给出 canonical 符号扩展的正确对照。
5. OpenC910 参考设计会在 MMU 开启且非异步异常时复制 `mtval_src` 的最高位到高位，支持上述 canonical 扩展判断；但它不能消除本仓库新增高半字辅助表达式中的地址单位错误。

**影响边界**

- 地址单位错误：跨页 32-bit 指令的后半字触发 instruction page/access fault 时，`mtval` 不是 faulting virtual address。OS 按错误 `mtval` 查页、判断故障地址或生成信号时可能错误终止进程；该风险对低半区地址同样成立。
- canonical 扩展错误：若实现允许 `PC[WK_PC_LEN-1]=1` 的高半区虚拟地址，普通 instruction page/access fault 的 `mtval` 和 PC 类 debug `tval` 还会落入错误低地址。若系统书面限制只执行低半区，可单独降低这一子项优先级，但不能关闭前述地址单位错误。

**建议修复**

先用 `{rob_retire_inst0_cur_pc,1'b0}` 恢复字节地址，再加 `64'd2`，随后统一复用 EPC/DPC 的 canonical 扩展方式。不要只把常数 2 改为 1：虽然 `{cur_pc + 1'b1,1'b0}` 在普通范围内数值等价，但“恢复字节地址后加 2”更清楚，也更容易用 reference model 检查。增加页末 `0xFFE`、高/低半区和 MMU 开/关交叉测试，并断言高半字 `mtval` 等于 canonical byte PC 加 2。

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
