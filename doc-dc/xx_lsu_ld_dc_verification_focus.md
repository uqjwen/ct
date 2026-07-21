# `xx_lsu_ld_dc` 重点验证方案

## 1. Stage scoreboard

以 `{IID, observer_generation, inst/borrow, addr, hit_way, restart_reason, payload_hash}` 追踪 AG accept、DC 寄存、D-cache 选择和 DA accept。borrow 单独记录 `valid/gate/payload_owner`；observer generation 只由验证环境维护。调试地址请求记录每次脉冲和 payload，禁止 valid 跨事务粘连。

## 2. 必跑用例

| ID | 激励 | 必查结果 |
|---|---|---|
| DC-V01 | 普通 load、debug load、普通 load 连续三拍 | DTU valid 只对 debug load 脉冲一次，地址和 halt-info 不重复 |
| DC-V02 | 分别在 VB、SNQ、ICC、WMB、MCIC、PRQ 激励 borrow valid/gate 的合法及负向组合 | SNQ 只允许 00/11；VB 允许 gate-only 01，但禁止 valid-only 10；arbiter `valid -> gate` 且有效 payload owner 一致 |
| DC-V03 | 四 way 单 hit、miss、双 hit和 X tag 注入 | 正式场景 onehot0；双 hit 不得静默选择任意 data |
| DC-V04 | full/check flush 与 AG valid、borrow 同拍 | 被 kill 的指令不进入 DA；borrow 所有权不被指令 payload 覆盖 |
| DC-V05 | LQ full、dependency restart、uTLB miss全组合 | restart 原因、DA valid、immediate wakeup bitmap 一致且只发生一次 |
| DC-V06 | US 后接 scalar，所有 vmew/rot/mask | scalar 不消费旧 US mask；US 四个 128-bit region 对齐正确 |
| DC-V07 | cacheable/non-cacheable、四 way hit及 ECC 注入 | hit/data/ECC way 使用同一 settle-way，不串 line |

## 3. 关键断言

```systemverilog
a_dtu_valid_is_pulse:
assert property (@(posedge ctrl_ld_clk) disable iff (!cpurst_b)
  ld_dc_dtu_addr_vld |-> $past(lag_ex1_inst_vld && ld_ag_dtu_vld));

a_borrow_valid_implies_gate:
assert property (@(posedge ctrl_ld_clk) disable iff (!cpurst_b)
  dcache_arb_ldc_borrow_vld |-> dcache_arb_ldc_borrow_vld_gate);

a_vb_borrow_valid_implies_gate:
assert property (@(posedge forever_cpuclk) disable iff (!cpurst_b)
  vb_dcache_arb_ld_borrow_req |-> vb_dcache_arb_ld_borrow_req_gate);

a_snq_borrow_req_gate_equal:
assert property (@(posedge forever_cpuclk) disable iff (!cpurst_b)
  snq_dcache_arb_ld_borrow_req == snq_dcache_arb_ld_borrow_req_gate);

a_cache_hit_onehot0:
assert property (@(posedge ctrl_ld_clk) disable iff (!cpurst_b)
  $onehot0(ldc_hit_way));

a_restart_blocks_da:
assert property (@(posedge ctrl_ld_clk) disable iff (!cpurst_b)
  ldc_restart_vld |-> !ldc_lda_ex2_inst_vld);

a_imme_wakeup_tied_off:
assert property (@(posedge ctrl_ld_clk) !mmu_lsu_imme_wakeup);

a_non_us_upper_masks_not_consumed:
assert property (@(posedge ctrl_ld_clk) disable iff (!cpurst_b)
  ldc_ex2_inst_vld && !ldc_lda_ex2_inst_us
  |-> !(consumer_uses_bytes_vld2_to3 ||
        consumer_uses_reg_bytes_vld1_to3 ||
        consumer_uses_upper_128b_data));
```

## 4. Sign-off

所有 stage/flush/restart 边覆盖；DTU 请求数与输入 debug accept 数相等；borrow payload owner 0 次错配且 VB gate-only 不产生 borrow；正式 cache hit 始终 onehot0；US→scalar 交叉覆盖证明旧高位字段零次消费后方可签核。

## 5. Interaction 1.6 已实现断言的定向验证

`a_ldc_hit_way_onehot0` 已写入 `srcs/xx_lsu_ld_dc.sv`。回归至少注入 `{0,1,2,4}` 路 valid tag 命中：0/1 路不得失败，2/4 路必须失败；同时覆盖 cache disabled、non-CA、flush 后 invalid 和 unit-stride way replay，确认资格化既不漏正式 multi-hit，也不对非适用周期误报。
