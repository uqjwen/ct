# `xx_lsu_lq` / `xx_lsu_lq_entry` 重点验证方案

## 1. 参考模型

scoreboard 保存 `{IID, entry, flush_epoch, PA-line, byte-mask, secd, inst_us, PC, snped}`。每拍根据三个 create accept、commit/restart pop 和 flush 更新集合；RAR/RAW 参考模型枚举所有存活 younger entry，并分别输出“是否失败”和按正式 SFP 合同选择的 PC。

## 2. 定向矩阵

| ID | 激励 | 必查结果 |
|---|---|---|
| LQ-V01 | 0/1/2/3 个空位，三 lane create 全组合 | 每个 success 对应唯一非零 pointer；指针互斥；无伪 accept |
| LQ-V02 | partial flush 分别 kill lane0/2/3 create，保留其余 lane | pointer reservation 只看 surviving accept；older lane不得因 killed create 丢失 |
| LQ-V03 | create 与 commit/restart-pop/full flush 同 bit 同拍 | 旧事务优先清除且新事务不被迟到旧 epoch pop 误杀 |
| LQ-V04 | IID wrap、同 line 不同 byte、addr1、US 64B compare | RAR/RAW 与软件 byte-overlap 模型一致 |
| LQ-V05 | 同拍 2/N 个 spec-fail entry，交换物理 index | 输出 PC 满足正式 oldest/any-match 合同，不能无说明地随 index 改变 |
| LQ-V06 | snoop/VB invalidate 在 create、commit、flush 边界 | `snped` 只归属目标事务，entry 复用不继承旧值 |
| LQ-V07 | `cp0_lsu_corr_dis` 0/1 与 snped 交叉 | RAR 抑制策略严格符合合同；RAW 不被误抑制 |

## 3. 关键断言

```systemverilog
a_accept_has_pointer:
assert property (@(posedge forever_cpuclk) disable iff (!cpurst_b)
  lq_create3_success |-> $onehot(lq_entry_create3_vld));

a_create_pointers_disjoint:
assert property (@(posedge forever_cpuclk) disable iff (!cpurst_b)
  !(|(lq_entry_create0_vld & lq_entry_create2_vld)) &&
  !(|(lq_entry_create0_vld & lq_entry_create3_vld)) &&
  !(|(lq_entry_create2_vld & lq_entry_create3_vld)));

a_lane3_reservation_uses_accept:
assert property (@(posedge forever_cpuclk) disable iff (!cpurst_b)
  (lsdc0_lq_ex2_create_vld && !lq_create2_success && lq_create3_success)
  |-> (lq_create_ptr3_fix == lq_create_ptr2));

a_restart_pop_is_live:
assert property (@(posedge forever_cpuclk) disable iff (!cpurst_b)
  |{lda0_ex3_lq_entry_pop,lsda0_ex3_lq_entry_pop,lsda1_ex3_lq_entry_pop}
  |-> restart_pop_epoch_matches_live_entry);
```

## 4. Sign-off

边界容量与三 create/flush 的所有组合必须全覆盖；spec-fail 多匹配选择合同需书面确认；X-prop 下 valid compare payload必须二态；one-hot、epoch、reference-model assertion 0 failure 后方可签核。
