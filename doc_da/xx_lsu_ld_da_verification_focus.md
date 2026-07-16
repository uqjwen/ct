# `xx_lsu_ld_da` 重点验证方案

## 1. 数据与事务 scoreboard

以 `{IID, stage_epoch, source(cache/TCM/SQ/WMB/RB), four_128b_blocks, byte_mask, ECC_phase, RB_entry_epoch}` 追踪 EX3 数据。completion 与 data request 分开计数，但必须关联同一 IID；flush、restart、boundary second 和 FOF 都不得产生重复或跨 epoch side effect。

## 2. 必跑用例

| ID | 激励 | 必查结果 |
|---|---|---|
| DA-V01 | `data0..3` 四种互异花纹，16 个 bank 逐一注入 correctable ECC | stall/replay 后四块顺序不变，`data3` 绝不等于被复制的 `data2` |
| DA-V02 | tag/data/TCM ECC fatal/correctable 与 RB full 同拍 | stall、restart、MCIC、completion/data 互斥和优先级正确 |
| DA-V03 | SQ full/partial/bypass forward 与 ECC replay 全交叉 | 合同互斥或明确 discard/reissue；无跨 epoch 数据 merge |
| DA-V04 | RB create/merge，full 在请求同拍变化 | 每个未命中 load 要么唯一 accept，要么 restart；无静默丢失 |
| DA-V05 | scalar/vector、boundary、FOF first/non-first、vstart/vl | exception、completion、data、VMB merge 与 element count 一致 |
| DA-V06 | debug address halt 与 prefetch/no-spec/cache-buffer 同拍 | 架构禁止的辅助副作用全部被屏蔽，允许项有书面合同 |
| DA-V07 | full/check flush 覆盖正常、ECC 保持和 borrow | 被 kill epoch 不产生 WB/RB/LQ/IDU side effect |

## 3. 关键断言

```systemverilog
a_replay_block3_identity:
assert property (@(posedge ctrl_ld_clk) disable iff (!cpurst_b)
  lda_ecc_stall_already |-> lda_rb_ex3_data_ori3 == lda_lwb_ex3_data3);

a_rb_create_accept_or_restart:
assert property (@(posedge ctrl_ld_clk) disable iff (!cpurst_b)
  ld_da_rb_create_vld_unmask
  |-> (lda_rb_ex3_create_vld ^ ld_da_data_rb_restart));

a_no_wb_on_restart:
assert property (@(posedge ctrl_ld_clk) disable iff (!cpurst_b)
  ld_da_restart_vld |-> !(lda_lwb_ex3_cmplt_req || lda_lwb_ex3_data_req));

a_side_effect_epoch_live:
assert property (@(posedge ctrl_ld_clk) disable iff (!cpurst_b)
  (lda_lwb_ex3_cmplt_req || lda_lwb_ex3_data_req || lda_rb_ex3_create_vld)
  |-> transaction_epoch_live);

a_sq_ecc_policy:
assert property (@(posedge ctrl_ld_clk) disable iff (!cpurst_b)
  lda_ecc_stall_already |-> !(ld_da_fwd_sq_vld || ld_da_fwd_sq_bypass));
```

## 4. Sign-off

ECC bank/way/phase、四数据块、forward source、RB full、boundary/FOF 和 flush 交叉覆盖完整；每个 IID completion/data 次数满足规格；所有输出 payload 都匹配活动 epoch 后方可签核。
