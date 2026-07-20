# `xx_lsu_ctrl` / `xx_lsu_top` 集成重点验证方案

## 1. 时钟与 owner-lifetime scoreboard

为每个父/子门控时钟记录 enable reason；验证环境为每个 LRQ/LSIQ entry 记录 `{lane, entry, observer_generation, IID, freeze_reasons}`。`observer_generation` 只用于发现 bit 复用，不要求加入 RTL；所有 wakeup 必须属于当前 owner 并只清除对应 reason，所有 clocked update 必须有父时钟覆盖。

## 2. 必跑用例

| ID | 激励 | 必查结果 |
|---|---|---|
| CTRL-V01 | special clock 当前配置及恢复真实 `pfu_part_empty` 两种模式 | 当前常开；VMB0/1 已由源码覆盖；门控模式下 ICC→VB、LD/LSDA special 事件也必须开父时钟，当前 RTL 应暴露剩余遗漏 |
| CTRL-V02 | lane0/2/3 各类 restart/wakeup 单独和同拍组合 | 只修改目标 lane/entry，OR 合并不丢 reason |
| CTRL-V03 | flush 后以最早合法拍复用 entry，再分别观察并负向注入 MMU/LFB/SQ/WMB 旧 wakeup；同时覆盖 DA/LSDA already-da/secd/spec-fail/pop | flush 拍不能同拍复用；下一次 create-accept 前 producer 旧 owner bitmap 已清空；DA/LSDA 向量均来自 live stage/保存 LSID |
| CTRL-V04 | `LRQENTRY/LSIQENTRY` 相等与刻意不等配置 | 正式配置通过；不等配置在 elaboration/static assertion 失败 |
| CTRL-V05 | load/LS0/LS1 的 request、WB 和 borrow 事件覆盖 | 每个 sequential consumer 的父 pipe clock在需要拍开启；LS1 borrow 保持配置 tie 0 |
| CTRL-V06 | LRQ mode 的 old IDU 输出、internal CTRL→LRQ 状态 | 外部 IDU 不依赖 tie-0 信号；LRQ freeze/replay 完整替代旧路径 |
| CTRL-V07 | 所有可见 module/entry instance 重新运行 named-port 检查，并补入 `xx_lsu_wb_arbiter` | 端口集合、重复端口、参数宽度合同全部通过；缺失模块在 elaboration 前即报告 |

## 3. 关键断言

```systemverilog
a_special_child_covered:
assert property (@(posedge forever_cpuclk)
  (idu_lsu_vmb_create0_gateclk_en || idu_lsu_vmb_create1_gateclk_en ||
   icc_vb_create_gateclk_en || lsda0_ex3_special_gateclk_en ||
   lsda1_ex3_special_gateclk_en) |-> lsu_special_clk_en);

a_lrq_lsiq_same_depth:
initial assert (LRQENTRY == LSIQENTRY);

a_wakeup_owner_live:
assert property (@(posedge forever_cpuclk) disable iff (!cpurst_b)
  |lsu0_idu_exx_wakeup
  |-> target_entry_vld && producer_saved_iid == target_entry_iid);

a_reuse_has_no_old_owner_pending:
assert property (@(posedge forever_cpuclk) disable iff (!cpurst_b)
  lrq0_create_accept
  |-> !(mmu_old_owner_pending || lfb_old_owner_pending ||
        sq_old_owner_pending || wmb_old_owner_pending));

a_ls1_borrow_tied_off:
assert property (@(posedge forever_cpuclk)
  !lsdc1_ex2_borrow_vld && !lsda1_ex3_borrow_vld);

a_pipe_update_has_parent_clock:
assert property (@(posedge forever_cpuclk) disable iff (!cpurst_b)
  any_ld0_sequential_update |-> ctrl_ld0_clk_en);
```

## 4. 结构检查清单

- 对 module header 和每个 named-port instance 做集合相等检查，包括新 `xx_lsu_wb_arbiter`。
- 对 generate entry 检查每个实例的 port set 相同。
- 对 top 中间 net检查 producer 数、consumer 数和参数化宽度。
- 在完整源码环境补跑预处理、lint、elaboration、CDC/RDC 和 clock-gating check。

## 5. Sign-off

父/子时钟覆盖 assertion 0 failure；旧 owner wakeup 0 次生效；lane0/2/3 全来源交叉覆盖；VMB 修正和 ICC/LSDA 剩余门控项均验证；LRQ mode 外部合同和参数相等合同书面确认；完整环境 elaboration 通过后方可最终签核。
