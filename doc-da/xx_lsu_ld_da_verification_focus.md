# `xx_lsu_ld_da` 详细验证方案

## 1. Scoreboard 与事务键

以 `{lane, IID, stage_epoch}` 为主键，记录 `{source(cache/TCM/SQ/WMB/RB), four_128b_blocks, byte_mask, ECC_phase, RB_entry_epoch, debug_cancel}`。completion、data writeback、RB create/merge、LQ pop、LRQ bitmap 和辅助训练事件分别计数，但必须关联同一活动 epoch；flush/restart 后旧 epoch 不得再产生功能 side effect。

## 2. DA-RR-01：四块 ECC replay 定向验证

| 周期 | 激励/状态 | 期望 |
|---|---|---|
| T0 | 标量 unit-stride load，四块为 `A/B/C/D`，`A/B/C/D` 两两不同 | DA 分别保存四块 |
| T1 | 注入任一可恢复 data/tag ECC，使事务进入 stall | completion/data 被屏蔽，事务保持 |
| T2 | `lda_ecc_stall_already=1`，允许 RB create/merge | `data_ori0..3 == A/B/C/D`，绝不能为 `A/B/C/C` |
| T3+ | RB 返回并完成写回 | 512-bit payload 与原事务逐 bit 相等，completion 只出现一次 |

同一测试复制到 LSDA0/LSDA1，并增加 scalar-vs-LSDA 等价比较；修复前标量 lane 应稳定暴露 DA-RR-01，修复后 3 lane 同时通过。

## 3. DA-RR-02 至 DA-RR-05 必跑矩阵

| 风险 ID | 激励 | 必查结果 |
|---|---|---|
| DA-RR-02 | SQ full/partial/bypass forward × ECC first/stall-already/fatal 全交叉 | 规格若声明互斥则零次同时有效；否则明确 discard/reissue，不能跨 epoch 合并 cache/SQ 数据 |
| DA-RR-03 | RB empty/one-left/full、create/merge、ECC mask、index hit/discard 与 flush 同拍 | 每个 miss 恰好 `accept XOR restart`；RB entry 的 IID/epoch/payload 与 DA 保存事务相同 |
| DA-RR-04 | debug address halt 与 prefetch/no-spec/HPCP/cache-buffer/RB/WB 同拍 | 架构禁止的 side effect 全部为 0；允许保留项与书面合同逐项一致 |
| DA-RR-05 | 合法/非法 `vmew`、rot、X 注入与 lint/X-prop | 合法编码不传播 X；非法编码由 assertion 报告；无宽度告警 |

另需覆盖 scalar/vector、boundary first/second、FOF first/non-first、LR/AMO、TCM、SQ/WMB forward、RB data-check、full/check flush，以及 `req/dp/gate` 的所有合法组合。

## 4. 建议绑定的关键断言

以下 assertion 需要放在能观察内部信号的 bind/testbench 层；`transaction_epoch_live` 与 `rb_accept_same_epoch` 由验证环境 scoreboard 提供。

```systemverilog
a_da_rr01_replay_block3_identity:
assert property (@(posedge ctrl_ld_clk) disable iff (!cpurst_b)
  lda_ecc_stall_already
  |-> lda_rb_ex3_data_ori3 == lda_lwb_ex3_data3);

a_da_rr01_four_block_identity:
assert property (@(posedge ctrl_ld_clk) disable iff (!cpurst_b)
  lda_ecc_stall_already && lda_rb_ex3_create_vld
  |-> {lda_rb_ex3_data_ori3, lda_rb_ex3_data_ori2,
       lda_rb_ex3_data_ori1, lda_rb_ex3_data_ori}
      == expected_four_block_payload);

a_da_rr02_sq_ecc_contract:
assert property (@(posedge ctrl_ld_clk) disable iff (!cpurst_b)
  lda_ecc_stall_already
  |-> !(ld_da_fwd_sq_vld || ld_da_fwd_sq_bypass));

a_da_rr03_accept_or_restart:
assert property (@(posedge ctrl_ld_clk) disable iff (!cpurst_b)
  ld_da_rb_create_vld_unmask
  |-> (rb_accept_same_epoch ^ ld_da_data_rb_restart));

a_da_rr03_side_effect_epoch_live:
assert property (@(posedge ctrl_ld_clk) disable iff (!cpurst_b)
  (lda_lwb_ex3_cmplt_req || lda_lwb_ex3_data_req ||
   lda_rb_ex3_create_vld || lda_rb_ex3_merge_vld)
  |-> transaction_epoch_live);

a_da_req_implies_dp:
assert property (@(posedge ctrl_ld_clk) disable iff (!cpurst_b)
  lda_lwb_ex3_data_req |-> lda_lwb_ex3_data_req_dp);

a_da_dp_implies_gate:
assert property (@(posedge ctrl_ld_clk) disable iff (!cpurst_b)
  lda_lwb_ex3_data_req_dp |-> lda_lwb_ex3_data_req_gateclk_en);

a_da_flush_blocks_old_queue_side_effects:
assert property (@(posedge ctrl_ld_clk) disable iff (!cpurst_b)
  !lda_ex3_inst_vld
  |-> !(|lda_ex3_lq_entry_pop || |lda_idu_ex3_pop_entry ||
        |lda_idu_ex3_secd || |lda_idu_ex3_spec_fail));

a_da_rr04_halt_blocks_forbidden_aux:
assert property (@(posedge ctrl_ld_clk) disable iff (!cpurst_b)
  lda_ex3_inst_vld && dtu_lsu_addr_halt_info[0]
  |-> !(forbidden_prefetch_side_effect ||
        forbidden_no_spec_side_effect ||
        forbidden_hpcp_side_effect));
```

## 5. 覆盖点与签核门槛

- DA-RR-01：3 lanes × 16 ECC banks × `{tag,data,TCM}` × `{correctable,fatal}` × 4 个互异数据块。
- DA-RR-02：SQ forward `{none,full,bypass}` × ECC phase × restart/flush。
- DA-RR-03：RB capacity `{empty,one-left,full}` × `{create,merge,index-hit}` × 3 lanes。
- DA-RR-04：halt bit `{01,10,11}` × 每类功能/辅助 side effect。
- DA-RR-05：所有合法 `vmew/rot` 编码与非法/X 负向注入。

只有在标量 ECC replay 不再复制 block2、SQ/ECC 合同有唯一解释、RB accept/restart 零次丢失或双收、debug 副作用符合书面合同、所有 assertion 为零失败后，DA-RR-01 至 DA-RR-04 才可关闭。
