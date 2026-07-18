# `xx_lsu_lrq` / `xx_lsu_lrq_entry` 重点验证方案

## 1. Scoreboard

以 `{lane, IID, lrqid, flush_epoch}` 为事务键，记录 create request/accept、freeze 原因、每次 wakeup、issue、AG accept、secd/already_da/spec_fail 更新、pop 与 flush。LRQ bit 复用时 epoch 必须递增；旧 epoch 的 response/wakeup 不得改变新 entry。

## 2. 必跑定向用例

| ID | 激励 | 必查结果 |
|---|---|---|
| LRQ-V01 | 每 bank empty/one-left/full，交叉 IDU oldest、no-space 预留与 AG 延迟 | 非 flush raw create 的 pointer 恰好 one-hot；full 不得出现 raw pop 无 allocation |
| LRQ-V02 | 三 bank 同拍 create、不同 IID 排列及 IID 回绕 | global/local age-vector无环；每 bank只 issue 自己最老 ready 项 |
| LRQ-V03 | 每种 freeze 原因单独及组合，逐一 wake | 只有全部等待条件解除才 ready；issue 后立即重新 frozen |
| LRQ-V04 | accepted MMU miss → flush → 同 bit 立即复用 → 注入旧 wake | 合法环境不产生旧 wake；负向注入必须触发 epoch assertion |
| LRQ-V05 | create 与 full/partial flush、pop、wakeup 同拍 | flush kill 时 raw IDU pop 只作用于同一被 kill 上游项；非 flush 时 pop 与 accept 一致；create/pop 优先级不串 epoch |
| LRQ-V06 | scalar、boundary、US/non-US vector create→replay | 所有适用 payload 与 create 值一致；非适用旧 mask 不可被消费 |
| LRQ-V07 | replay 同拍改变当前 IDU `halt_info` | replay 调试结果只来自原事务；当前 RTL应暴露 LRQ-RR-01 |
| LRQ-V08 | no-spec 与 barrier 多 entry、跨 bank 年龄排列 | 只在真正的前序目标消失后 wake；不得形成 age-vector 环 |
| LRQ-V09 | 可见 DA already-da/secd/spec-fail/pop 与 full/check flush 逐拍交叉 | 所有 bitmap 来自 live DA + saved LSID；flush 后零次迟到修改 |
| LRQ-V10 | MMU/LFB/SQ/WMB 各 producer 执行 check/full flush→同 LRQ bit 复用→旧 wake 负向注入 | flush 拍只唤醒旧 epoch并同步清保存状态；复用后零次旧 wake，强制旧 wake 立即触发 epoch/IID assertion |

## 3. 关键断言

```systemverilog
a_create_has_slot:
assert property (@(posedge forever_cpuclk) disable iff (!cpurst_b)
  lsu0_lrq_create_vld && !rtu_lsu_flush_fe &&
  !(rtu_ck_flush && rtu_ck_flush_iid_older_lsu0_iid)
  |-> $onehot(lrq0_create_ptr0));

a_flush_raw_pop_matches_kill:
assert property (@(posedge forever_cpuclk) disable iff (!cpurst_b)
  lsu0_lrq_create_vld && !lrq0_create_success
  |-> (rtu_lsu_flush_fe || rtu_ck_flush && rtu_ck_flush_iid_older_lsu0_iid) &&
      upstream_lsiq_entry_killed);

a_create_accept_is_onehot:
assert property (@(posedge forever_cpuclk) disable iff (!cpurst_b)
  lrq0_create_success |-> $onehot(lrq0_create_vld));

a_issue_is_ready:
assert property (@(posedge forever_cpuclk) disable iff (!cpurst_b)
  |lrq0_entry_issue_grnt |->
    ($onehot(lrq0_entry_issue_grnt) &&
     !(|(lrq0_entry_issue_grnt & ~rdy_pre0))));

a_no_replay_recreate:
assert property (@(posedge forever_cpuclk) disable iff (!cpurst_b)
  (lag_ex1_inst_vld && lag_lrq_replay_vld) |-> !lsu0_lrq_create_vld);

// txn_epoch 由验证 scoreboard 维护。
a_wakeup_epoch_matches:
assert property (@(posedge forever_cpuclk) disable iff (!cpurst_b)
  |lsu0_lrq_exx_tlb_wakeup |-> wake_epoch == txn_epoch);

a_mmu_flush_consumes_saved_lsid:
assert property (@(posedge forever_cpuclk) disable iff (!cpurst_b)
  rtu_ck_flush |=> !(|tmq_entry_lsid_for_flushed_epoch));

a_lfb_sq_wmb_flush_clears_saved_wakeup:
assert property (@(posedge forever_cpuclk) disable iff (!cpurst_b)
  rtu_ck_flush |=> !(|lfb_old_wakeup_queue ||
                     |sq_old_wakeup_queue ||
                     |wmb_old_wakeup_queue));

a_rf_valid_has_data_clock:
assert property (@(posedge forever_cpuclk) disable iff (!cpurst_b)
  lrq_lsu0_rf_sel |-> lrq_lsu0_rf_gateclk_sel);
```

lane2/lane3 必须复制同类 assertion；参数层增加 `initial assert (LRQENTRY == LSIQENTRY);`。

## 4. 覆盖与 sign-off

- 覆盖 3 lanes × 8 freeze 原因 × `{0,1,N}` 等待 × 4 flush 点 × IID wrap。
- 所有 bank 的 empty→full→empty、同拍三 create、同拍三 pop、create+pop 都命中。
- 适用 replay payload X-prop 0 failure；旧 `no_spec` 只按 interaction 1.1.3 的 SFP/IDU 非消费合同检查。
- LRQ-RR-01 修复，容量预留/flush-kill/accept-pop 一致，DA/MMU/LFB/SQ/WMB bitmap 所有权通过，旧 epoch wakeup 0 次，assertion 0 failure 后方可 sign-off。
