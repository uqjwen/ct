# RTU-RR-02 canonical 扩展错误的实际例子

## 1. 先区分两个彼此独立的问题

RTU-RR-02 实际包含两个缺陷：

1. **跨页高半字的地址单位错误**：`rob_retire_inst0_cur_pc` 保存的是
   halfword 地址，`srcs/xx_rtu_retire.v:3662` 却直接对它加 `64'd2`。
   这会把 `0xFFE -> 0x1000` 算成 `0x7FF + 2 = 0x801`。
2. **canonical 符号扩展错误**：即使不是跨页高半字，普通 instruction
   fault 和 PC 类 debug tval 对高半区 PC 也没有把符号位复制到
   64-bit 高位。下面用普通 instruction page fault 单独说明第二项，
   避免与第一项混在一起。

## 2. 当前 PC 编码

从原 C910 注释和当前拼接关系可知，此配置使用 `WK_PC_LEN=39`：

- ROB 的 `cur_pc[38:0]` 保存字节虚拟地址 `VA[39:1]`；
- 字节地址最低位 `VA[0]` 固定为 0，没有存入 ROB；
- `cur_pc[38]` 就是 40-bit 虚拟地址的符号位 `VA[39]`；
- MMU 开启时，正确 64-bit canonical 地址应把 `VA[39]` 复制到
  `[63:40]`。

正确参考表达式是：

```systemverilog
{{(64-WK_PC_LEN-1){cur_pc[WK_PC_LEN-1]}}, cur_pc, 1'b0}
```

当 `WK_PC_LEN=39` 时，就是复制 24 个 sign bit，再拼 39-bit
`cur_pc` 和最低位 0。

## 3. 为什么低半区测试看不出错误

以普通 instruction page fault 的 PC `0x0000000000001000` 为例：

| 项目 | 数值 |
|---|---|
| 字节 PC | `0x0000000000001000` |
| ROB `cur_pc=PC>>1` | `0x0000000000000800` |
| `cur_pc[38]` | `0` |
| 正确 canonical `mtval` | `0x0000000000001000` |
| 当前普通 fault 路径结果 | `0x0000000000001000` |

符号位为 0 时，无论“高位补 0”还是“复制符号位”，结果都相同，所以
只运行低地址程序无法暴露 canonical 扩展错误。

## 4. 高半区普通 instruction fault 的错误现场

现在让一条普通指令位于高半区：

```text
PC = 0xffffff8000001000
```

低 40-bit 虚拟地址为 `0x8000001000`，ROB 保存：

```text
cur_pc = (0x8000001000 >> 1) = 0x4000000800
cur_pc[38] = 1
```

正确恢复过程：

```text
{cur_pc, 1'b0}                 = 0x0000008000001000
复制 VA[39] 到 [63:40]         = 0xffffff8000001000
正确 mtval                     = 0xffffff8000001000
```

但普通 instruction fault 的当前表达式位于
`srcs/xx_rtu_retire.v:2049`～`2051`：

```systemverilog
{{(64-WK_PC_LEN-2){1'b0}},
 cur_pc[WK_PC_LEN-1],
 cur_pc[WK_PC_LEN-1:0],
 1'b0}
```

它只额外放入 **一个** `1`，而不是把符号位填满 `[63:40]`，因此得到：

```text
当前 mtval = 0x0000018000001000
正确 mtval = 0xffffff8000001000
```

两者不是同一个地址。异常处理程序若按当前 `mtval` 查页表，会查询
`0x0000018000001000`，而真正 faulting instruction 位于
`0xffffff8000001000`。前者也不是该 40-bit 虚拟地址规则下的正确
canonical 表示，因此 OS 可能把现场判断为非法地址、无法补页，最终向
进程发送错误信号。

## 5. debug `dtval` 是另一种错误值

PC 类 debug tval 在 `srcs/xx_rtu_retire.v:3552`～`3561` 无论 MMU
是否开启都做零扩展。对同一个 `cur_pc=0x4000000800`，结果是：

```text
当前 debug dtval = 0x0000008000001000
正确 debug dtval = 0xffffff8000001000
```

所以普通 instruction `mtval` 的“只复制一位”和 debug `dtval` 的
“完全零扩展”会生成两个不同的错误地址，但根因相同：没有按
`cur_pc[38]` 完成 64-bit canonical 符号扩展。

## 6. 与跨页高半字问题组合时

若 32-bit 指令从 `0xffffff8000000ffe` 开始，第二个 halfword 在下一页
`0xffffff8000001000` fault：

```text
cur_pc                  = 0x40000007ff
当前 high-half helper   = cur_pc + 2
                         = 0x0000004000000801
正确 fault VA           = canonical({cur_pc,1'b0} + 2)
                         = 0xffffff8000001000
```

这里同时发生“半字/字节单位错误”和“高半区 canonical 扩展错误”。
修复时应先恢复字节地址再加 2，最后统一做 sign extension；不能只修
其中一个步骤。
