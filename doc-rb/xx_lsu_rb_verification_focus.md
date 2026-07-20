# `xx_lsu_rb` / `xx_lsu_rb_entry` 重点验证方案

## 1. 协议 scoreboard

以 `{entry, IID, observer_generation, BIU_ID, request_owner}` 追踪 create/merge、AR/AW accept、每个 R/B beat、LFB ownership、WB completion/data grant、flush 和复用。SO ID FIFO另建队列模型，paired WMB/RB 固定 ID 另建 owner 模型；observer generation 只存在于验证环境。

## 2. 必跑用例

| ID | 激励 | 必查结果 |
|---|---|---|
| RB-V01 | 普通区 0/1/2/3 空位及 MMU 保留位，三 lane create 全组合 | 每个 success 有唯一 pointer；普通请求不占 MMU 保留位；无 accept-zero-pointer |
| RB-V02 | 0/1/2/3 个空位，三 lane 的 `judge/dp/vld` 合法及非法组合；高优先级 dp 有效但 create 失败 | 合同非法组合立即报错；任一低优先级成功 entry 的 payload/IID 必来自该 winner，不被更高优先级 dp 污染 |
| RB-V03 | 每个状态注入 partial/full/async flush，再以最早合法拍复用 entry/ID | request 前立即 kill；request 后旧 response被 drain、tombstone 吸收或禁止 ID 复用；旧 owner 不击中新 entry |
| RB-V04 | WMB sync/fence/atomic AW grant 前后、RB AR grant 前后排列 B response；共享 B ID 前导/迟到噪声负向注入 | paired transaction 的早到 B 可在 RB WAIT_RESP 前合法捕获；未接受 paired write 或 owner 不匹配的 B 必须被拒绝/触发 assertion |
| RB-V05 | US 两 beat正常、缺 beat、多 beat、错 ID、错误 response；CA=0/SO 的 US 请求 | 合法请求严格 beat0/beat1；非法属性在进入 RB 前报 `access_fault_with_page`；协议负向激励触发断言 |
| RB-V06 | boundary first/merge/secd，各 beat bus error | 数据 merge、byte mask、exception、mtval、一次 completion/data 正确 |
| RB-V07 | FOF first/non-first element bus error，vmew 全组合 | first 产生 exception且不写数据；non-first更新 VL/vstart并按合同完成 |
| RB-V08 | WB completion 与 data grant反压 0/1/N 拍，多 entry 同时 ready | one-hot公平仲裁；payload/IID不串项；entry只释放一次 |
| RB-V09 | SO 多 outstanding 与 ID FIFO wrap | response严格映射队首 entry；flush 后队列无旧映射 |

## 3. 关键断言

```systemverilog
a_create_success_has_ptr:
assert property (@(posedge lsu_special_clk) disable iff (!cpurst_b)
  rb_create_ls1_success |-> $onehot(rb_entry_ls1_create_vld));

a_create_ptrs_disjoint:
assert property (@(posedge lsu_special_clk) disable iff (!cpurst_b)
  !(|(rb_entry_ld0_create_vld & rb_entry_ls0_create_vld)) &&
  !(|(rb_entry_ld0_create_vld & rb_entry_ls1_create_vld)) &&
  !(|(rb_entry_ls0_create_vld & rb_entry_ls1_create_vld)));

// 对每个 entry i 复制。低优先级 winner 不得被更高优先级 dp 抢 payload。
a_ls0_winner_owns_payload:
assert property (@(posedge lsu_special_clk) disable iff (!cpurst_b)
  rb_entry_ls0_create_vld[i]
  |-> rb_entry_ls0_create_dp_vld[i] && !rb_entry_ld0_create_dp_vld[i]);

a_ls1_winner_owns_payload:
assert property (@(posedge lsu_special_clk) disable iff (!cpurst_b)
  rb_entry_ls1_create_vld[i]
  |-> rb_entry_ls1_create_dp_vld[i] &&
      !rb_entry_ld0_create_dp_vld[i] && !rb_entry_ls0_create_dp_vld[i]);

a_lsda0_create_vld_has_dp:
assert property (@(posedge lsu_special_clk) disable iff (!cpurst_b)
  lsda0_rb_ex3_create_vld |-> lsda0_rb_ex3_create_dp_vld);

a_lsda0_dp_has_judge:
assert property (@(posedge lsu_special_clk) disable iff (!cpurst_b)
  lsda0_rb_ex3_create_dp_vld |-> lsda0_rb_ex3_create_judge_vld);

// LSDA1 复制同样两条蕴含断言。

a_b_resp_owned:
assert property (@(posedge lsu_special_clk) disable iff (!cpurst_b)
  rb_entry_biu_b_resp_set |->
    (rb_entry_vld && rb_entry_expects_b_resp &&
     paired_write_request_accepted && b_response_owner_matches));

a_us_second_beat_is_last:
assert property (@(posedge lsu_special_clk) disable iff (!cpurst_b)
  (rb_entry_r_id_hit && rb_entry_inst_us && rb_entry_us_cnt)
  |-> biu_lsu_r_last);

a_response_owner_matches:
assert property (@(posedge lsu_special_clk) disable iff (!cpurst_b)
  rb_entry_r_id_hit |-> response_owner == entry_request_owner);

a_wb_grant_onehot:
assert property (@(posedge lsu_special_clk) disable iff (!cpurst_b)
  $onehot0(rb_entry_wb_cmplt_grnt) && $onehot0(rb_entry_wb_data_grnt));
```

## 4. Sign-off

所有状态边、request 类型、flush 点、response 排列和容量边界均覆盖；旧 owner response 0 次命中新 entry；create winner/payload identity 与 WB one-hot assertion 0 failure；RTU/LFB drain 或 tombstone、BIU US 两拍、非法属性错误映射及 paired WMB/RB 固定 ID 唯一 outstanding 合同书面确认后方可签核。
