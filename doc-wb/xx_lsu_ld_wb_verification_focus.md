# `xx_lsu_ld_wb` 重点验证方案

## 1. 双通道 scoreboard

completion scoreboard 追踪 `{IID, source, expt, vstart, no_spec, halt_info}`；data scoreboard 追踪 `{source, destination, payload, bus_err, vmb_id}`。每个 requester 必须 hold-until-grant，grant 与 payload source one-hot，一条 transaction 的 completion/data 可以分拍但身份不得串项。

## 2. 必跑用例

| ID | 激励 | 必查结果 |
|---|---|---|
| WB-V01 | DA/RB completion 00/01/10/11，连续争用 | DA 优先符合规格；RB 保持到 grant；IID/expt/vstart 不串项 |
| WB-V02 | DA/WMB/VMB/RB data 16 种请求组合 | grant onehot，payload/destination 与 winner 一致，loser 不丢请求 |
| WB-V03 | 刻意制造 DA `req/dp/gate` 非法组合 | 接口断言立即失败；合法 dp-only bubble 有界 |
| WB-V04 | RB data-trigger update 与无 completion、flush、后续新 completion 交叉 | halt-info update 不因关钟丢失，也不污染新 IID |
| WB-V05 | halt bit0/bit1 单独和组合，RTU 接收/flush 延迟 | completion 次数符合 level/脉冲合同，halt-info 有确定清除点 |
| WB-V06 | scalar/FP/vector/US，vmew 和 4×128-bit 花纹 | sign extend、VR0/VR1、VMB 512-bit data和 byte masks 正确 |
| WB-V07 | RB bus error，VMB merge，async exception | 不写错误数据；exception 地址、merge/async valid 一致 |
| WB-V08 | 持续高优先级流量夹带 RB 请求 | 在规定上界内 grant，或正式触发 starvation 监控 |

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

a_halt_update_clocked:
assert property (@(posedge forever_cpuclk) disable iff (!cpurst_b)
  rb_data_halt_info_update_vld |-> ld_wb_cmplt_clk_en);

a_no_stale_halt_completion:
assert property (@(posedge ctrl_ld_clk) disable iff (!cpurst_b)
  lsu_rtu_ex4_cmplt && !lwb_ex4_inst_vld
  |-> halt_level_handshake_live);

a_request_held_until_grant:
assert property (@(posedge ctrl_ld_clk) disable iff (!cpurst_b)
  rb_lwb_ex3_data_req && !lwb_rb_ex3_data_grnt
  |=> rb_lwb_ex3_data_req && $stable(rb_payload_bundle));
```

## 4. Sign-off

所有 completion/data 争用组合、连续流量、debug halt、bus error、scalar/vector/US 和 flush 点覆盖；0 次 payload/source 错配；每个低优先级请求在合同上界内获 grant；DTU update 0 次丢失后方可签核。
