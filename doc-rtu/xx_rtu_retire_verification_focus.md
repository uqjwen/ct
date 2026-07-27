# `xx_rtu_retire` 重点验证方案

## 1. 验证目标

围绕 `RTU-RR-01`～`RTU-RR-06` 建立 retire/flush/debug/CSR 的事务级 scoreboard。退休包以 `{retire_cycle, slot, IID, PC}` 标识；异常和 debug 请求额外记录 `{request_cycle, cause, tval, consumed_cycle}`。核心不变量是：每个有效退休槽只产生一次架构副作用，任何异常/flush 的功能 valid 与门控资格同拍一致，程序顺序最后一条 CSR 写决定最终状态。

## 2. P0 定向测试

| ID | 关联风险 | 激励 | 必查结果 | 关闭条件 |
|---|---|---|---|---|
| RTU-V01 | RTU-RR-01 | 流水线完全空闲后产生 LSU async exception，关闭其它 retire/debug/change-flow 时钟来源 | `retire_async_expt_vld` 同拍打开 retire clock 和 ROB flush gate；下一拍 IFU/CP0 收到 cause=5 和正确地址 | 门级 ICG 仿真通过，连续 1000 次随机空闲间隔零丢失 |
| RTU-V02 | RTU-RR-01 | async exception 与 normal retire、flush FSM 非空闲、debug halt 分别同拍 | 优先级唯一；异常不重复，flush FSM 最终回 idle | 所有交叉覆盖命中且 assertion 零失败 |
| RTU-V03 | RTU-RR-02 | MMU 开启，低半区/高半区 PC 的普通 instruction page/access fault | EPC、MTVAL 均为同一 canonical 字节 PC；高半区高位全为 sign bit | 软件参考模型逐 bit 一致 |
| RTU-V04 | RTU-RR-02 | 32-bit 指令从字节地址 `0xFFE` 等页末半字开始，令下一页高半字异常；高半区和低半区各测一次 | 输入半字地址 `cur_pc=0x7FF` 时，`mtval=0x1000`，绝不能得到当前错误值 `0x801`；其它地址满足 canonical byte PC `+2` | 页边界矩阵全部通过 |
| RTU-V05 | RTU-RR-02 | trigger t0 IFU、t1 LSU、普通 debug halt，MMU 开/关交叉 | IFU/PC 型 TVAL 用 canonical PC，LSU 型 TVAL 保留访问地址 | DTU scoreboard 零错配 |
| RTU-V06 | RTU-RR-03 | 同步 halt/group halt/sync flush/resume 只脉冲 1 拍，ROB 分别空闲 0/1/N 拍 | 若合同允许脉冲，请求保持到消费；若要求 level，接口断言应立即拒绝非法脉冲 | DTU hold-until-consumed 合同或 sticky RTL 明确并证明 |
| RTU-V07 | RTU-RR-04 | 1～6 条连续退休，slot0 注入 exception、t0 halt、inst flush | exception/halt 包中年轻 slot 无任何 PST/IFU/HPCP/DTU 副作用 | ROB 合同 assertion 和副作用 scoreboard 均通过 |
| RTU-V08 | RTU-RR-05 | 同拍 2～6 条 `vsetvli`，每条使用互异 `vl/vsew/vlmul/vma/vta` | CP0 最终值等于最年轻有效 slot | 全部 slot 组合与顺序覆盖通过 |
| RTU-V09 | RTU-RR-05 | slot0 `vsetvlx` 的 normal/illegal/mispred/FOF/split 组合 | `vl/vtype/vill/vstart/flush` 精确符合编码和优先级 | 特殊路径覆盖且无重复 flush |
| RTU-V10 | RTU-RR-06 | lint/elaboration 使用所有正式顶层连线 | 不存在误以为 `mmu_xx_mmu_en` 或 RAS 参与功能的配置 | 死接口删除或 waiver 写明 |

## 3. 建议断言

以下为 bind 级示意，信号名可按集成层可见性调整。

```systemverilog
// RTU-RR-01：功能 valid 不能脱离门控资格。
a_async_expt_opens_retire_clock:
assert property (@(posedge forever_cpuclk) disable iff (!cpurst_b)
  retire_async_expt_vld |-> retire_clk_en);

a_async_expt_opens_flush_gate:
assert property (@(posedge forever_cpuclk) disable iff (!cpurst_b)
  retire_async_expt_vld |-> retire_inst0_flush_gateclk &&
                            retire_rob_flush_gateclk);

a_async_expt_reaches_ifu:
assert property (@(posedge forever_cpuclk) disable iff (!cpurst_b)
  retire_async_expt_vld && !dbg_mode_on && !halt_req
  |=> rtu_ifu_xx_expt_vld && rtu_ifu_xx_expt_vec == 6'd5);

// RTU-RR-04：ROB 提供连续退休包，slot0 异常时年轻槽无效。
a_retire_valid_contiguous:
assert property (@(posedge forever_cpuclk) disable iff (!cpurst_b)
  rob_retire_inst5_vld |-> rob_retire_inst4_vld &&
                           rob_retire_inst3_vld &&
                           rob_retire_inst2_vld &&
                           rob_retire_inst1_vld &&
                           rob_retire_inst0_vld);

a_oldest_exception_has_no_younger:
assert property (@(posedge forever_cpuclk) disable iff (!cpurst_b)
  rob_retire_inst0_vld && retire_expt_inst
  |-> !(rob_retire_inst1_vld || rob_retire_inst2_vld ||
        rob_retire_inst3_vld || rob_retire_inst4_vld ||
        rob_retire_inst5_vld));

// RTU-RR-03：若采用 level 合同，请求在消费前必须保持。
a_sync_halt_held_until_consumed:
assert property (@(posedge forever_cpuclk) disable iff (!cpurst_b)
  dtu_rtu_sync_halt_req && !rtu_dtu_halt_ack
  |=> dtu_rtu_sync_halt_req || rtu_dtu_halt_ack);

// RTU-RR-02：cur_pc 是半字地址；高半字异常必须先补 bit0，再加 2。
a_high_half_mtval_uses_byte_address:
assert property (@(posedge forever_cpuclk) disable iff (!cpurst_b)
  retire_expt_pc_high_hw
  |-> retire_expt_tval == canonical_byte_pc(rob_retire_inst0_cur_pc) + 64'd2);

// RTU-RR-05：同拍多条 vsetvli 时选择最年轻有效槽。
a_vsetvli_selects_youngest:
assert property (@(posedge forever_cpuclk) disable iff (!cpurst_b)
  retire_inst5_vsetvli |-> rtu_cp0_vsetvl_vl == rob_retire_inst5_vl);
```

PC 扩展建议用 64-bit reference function 检查：

```systemverilog
function automatic logic [63:0] canonical_byte_pc(
  input logic [`WK_PC_LEN-1:0] cur_pc
);
  canonical_byte_pc = cp0_yy_mmu_en
                    ? {{(64-`WK_PC_LEN-1){cur_pc[`WK_PC_LEN-1]}},
                       cur_pc, 1'b0}
                    : {{(64-`WK_PC_LEN-1){1'b0}}, cur_pc, 1'b0};
endfunction
```

这里特意把“半字地址”恢复成“字节地址”；高半字 fault reference 为 `canonical_byte_pc(cur_pc) + 64'd2`。`0xFFE / 0x7FF / 0x801 / 0x1000` 定向用例应保留为防回归测试。

## 4. 覆盖模型

- 退休宽度：`0..6` 条；slot0 type × slot1～5 type。
- slot0 事件：normal、interrupt、sync exception、async exception、mispredict、inst flush、t0/t1 halt、resume。
- flush FSM：IDLE、IS、FE、BE；事件发生在进入/停留/离开各边。
- PC：MMU off/on × sign bit 0/1 × 页内普通/最后半字。
- debug：四类请求 × pulse/level × ROB 空闲 0/1/N 拍 × debug mode on/off。
- vector：有效 `vsetvli` slot 子集 × 每个 payload 字段互异 × vsetvlx 特殊原因。
- ICG：功能开关、scan enable 和真正 clock pulse 均观察，不能只检查组合 `*_clk_en`。

## 5. 动态关闭条件

- `RTU-RR-01`：RTL 补齐两处漏项，ICG 仿真证明孤立 async exception 100% 到达 IFU/CP0/ROB。
- `RTU-RR-02`：先证明所有跨页高半字异常均从半字地址正确恢复字节地址并加 2；再让高半区 PC 矩阵逐 bit 通过。若系统不支持高半区，地址范围 assertion 只能关闭独立的 canonical 扩展子项，不能关闭地址单位缺陷。
- `RTU-RR-03`：提供 DTU level/ack 合同 assertion，或改为 sticky-until-consumed 并通过 N 拍空闲测试。
- `RTU-RR-04`：ROB 连续 valid、异常只在 slot0、年轻槽被屏蔽的 assertion 全部通过。
- `RTU-RR-05`：2～6 条同拍 CSR 更新与程序顺序 reference model 一致。
- `RTU-RR-06`：死接口删除或形成明确 lint waiver。

本轮静态审查不能代替上述门控时钟仿真；在动态关闭条件完成前，RTU-RR-01/02 不应标记为已验证修复。
