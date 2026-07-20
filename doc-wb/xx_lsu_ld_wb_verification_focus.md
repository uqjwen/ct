# `xx_lsu_ld_wb` 重点验证方案

## 1. 双通道 scoreboard

completion scoreboard 追踪 `{IID, source, expt, vstart, no_spec, halt_info}`；data scoreboard 追踪 `{source, destination, payload, bus_err, vmb_id}`。每个 requester 必须 hold-until-grant，grant 与 payload source one-hot，一条 transaction 的 completion/data 可以分拍但身份不得串项。

## 2. 必跑用例

| ID | 激励 | 必查结果 |
|---|---|---|
| WB-V01 | DA/RB completion 00/01/10/11，连续争用 | DA 优先符合规格；RB 保持到 grant；IID/expt/vstart 不串项 |
| WB-V02 | DA/WMB/VMB/RB data 16 种请求组合 | grant onehot，payload/destination 与 winner 一致，loser 不丢请求 |
| WB-V03 | 覆盖 data-check、ECC mask/stall、SQ-ECC discard 等全部 dp-only 原因，并负向强制 `req && !dp`/`dp && !gate` | 非法蕴含立即失败；合法 dp-only 不产生 writeback valid，且在合同上界内解除 |
| WB-V04 | 单个 RB data-check 后停止所有 DA/RB/VMB/WMB data request，等待 DTU 两级返回 | `ld_dtu2_vld` 打开 source clock；registered update 严格一拍并自行获得清零边沿；当前 RTL 应稳定暴露粘连 |
| WB-V05 | halt bit0/bit1 单独和组合，随后停止所有 completion/update 流量 | update 清零后 bit1 effect 自行开 completion clock；`11` 按规格有界清零，旧 bit0 不得重复 completion |
| WB-V06 | scalar/FP/vector/US，vmew 和 4×128-bit 花纹 | sign extend、VR0/VR1、VMB 512-bit data和 byte masks 正确 |
| WB-V07 | RB bus error，VMB merge，async exception | 不写错误数据；exception 地址、merge/async valid 一致 |
| WB-V08 | 穷举所有 dedicated/WMB/VMB/RB 单拍组合；再持续两条 dedicated lane和高优先级 shared 流量，夹带 VMB/RB | 96 组组合与 greedy 参考模型一致；低优先级 request 必须在系统合同上界内获 grant，否则 starvation monitor 触发 |

## 3. 关键断言

```systemverilog
a_data_grant_onehot:
assert property (@(posedge ctrl_ld_clk) disable iff (!cpurst_b)
  $onehot0({ld_wb_da_data_grnt, lwb_wmb_ex3_data_grnt,
            ld_wb_vmb_data_grnt, lwb_rb_ex3_data_grnt}));

a_da_req_dp_gate_contract:
assert property (@(posedge ctrl_ld_clk) disable iff (!cpurst_b)
  lda_lwb_ex3_data_req
  |-> lda_lwb_ex3_data_req_dp && lda_lwb_ex3_data_req_gateclk_en);

a_da_dp_has_gate:
assert property (@(posedge ctrl_ld_clk) disable iff (!cpurst_b)
  lda_lwb_ex3_data_req_dp |-> lda_lwb_ex3_data_req_gateclk_en);

a_dp_only_has_no_writeback:
assert property (@(posedge ctrl_ld_clk) disable iff (!cpurst_b)
  lda_lwb_ex3_data_req_dp && !lda_lwb_ex3_data_req
  |-> !ld_wb_pre_data_vld);

a_halt_update_clocked:
assert property (@(posedge forever_cpuclk) disable iff (!cpurst_b)
  rb_data_halt_info_update_vld |-> ld_wb_cmplt_clk_en);

a_halt_raw_update_source_clocked:
assert property (@(posedge forever_cpuclk) disable iff (!cpurst_b)
  |rb_entry_data_halt_info_update_vld |-> ld_wb_data_clk_en);

a_halt_update_pulse_can_clear:
assert property (@(posedge forever_cpuclk) disable iff (!cpurst_b)
  rb_data_halt_info_update_vld |-> ld_wb_data_clk_en);

a_halt_update_is_one_pulse:
assert property (@(posedge forever_cpuclk) disable iff (!cpurst_b)
  rb_data_halt_info_update_vld && !(|rb_entry_data_halt_info_update_vld)
  |=> !rb_data_halt_info_update_vld);

a_halt_effect_clocked:
assert property (@(posedge forever_cpuclk) disable iff (!cpurst_b)
  ld_wb_halt_info_effect |-> ld_wb_cmplt_clk_en);

a_no_stale_halt_completion:
assert property (@(posedge ctrl_ld_clk) disable iff (!cpurst_b)
  lsu_rtu_ex4_cmplt && !lwb_ex4_inst_vld
  |-> halt_level_handshake_live);

a_request_held_until_grant:
assert property (@(posedge ctrl_ld_clk) disable iff (!cpurst_b)
  rb_lwb_ex3_data_req && !lwb_rb_ex3_data_grnt
  |=> rb_lwb_ex3_data_req && $stable(rb_payload_bundle));

a_shared_source_selects_at_most_one_lane:
assert property (@(posedge forever_cpuclk) disable iff (!cpurst_b)
  $onehot0({arb_lwb0_rb_data_req,
            arb_lswb0_rb_data_req,
            arb_lswb1_rb_data_req}));

a_lane_has_at_most_one_shared_source:
assert property (@(posedge forever_cpuclk) disable iff (!cpurst_b)
  $onehot0({arb_lswb1_wmb_data_req,
            arb_lswb1_vmb_data_req,
            arb_lswb1_rb_data_req}));

a_rb_bounded_grant:
assert property (@(posedge forever_cpuclk) disable iff (!cpurst_b)
  rb_ld_wb_data_req_pre |-> ##[0:WB_GRANT_BOUND] arb_rb_data_grnt);
```

## 4. Sign-off

所有 completion/data 争用组合、连续流量、debug halt、bus error、scalar/vector/US 和 flush 点覆盖；96 组 arbiter Boolean 组合 mismatch 0；0 次 payload/source 错配；每个低优先级请求在合同上界内获 grant；DTU update 严格单拍且 effect 最终清零后方可签核。
