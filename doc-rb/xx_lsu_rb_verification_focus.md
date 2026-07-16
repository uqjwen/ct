# `xx_lsu_rb` / `xx_lsu_rb_entry` 重点验证方案

## 1. 协议 scoreboard

以 `{entry, IID, entry_epoch, BIU_ID, request_epoch}` 追踪 create/merge、AR accept、每个 R/B beat、LFB ownership、WB completion/data grant、flush 和复用。SO ID FIFO另建队列模型，要求 create/pop 顺序与共享 ID response 一致。

## 2. 必跑用例

| ID | 激励 | 必查结果 |
|---|---|---|
| RB-V01 | 普通区 0/1/2/3 空位及 MMU 保留位，三 lane create 全组合 | 每个 success 有唯一 pointer；普通请求不占 MMU 保留位；无 accept-zero-pointer |
| RB-V02 | 刻意使 lane2 `dp_vld/judge_vld/create_vld` 不同，lane3 同拍请求 | 若组合不合法立即触发接口断言；合法组合 pointer不丢失/碰撞 |
| RB-V03 | 每个状态注入 partial/full/async flush | request 前立即 kill；request 后旧 response被吸收或取消；旧 epoch 不击中新 entry |
| RB-V04 | cacheable、NC、SO、atomic、sync、fence 的 R/B 顺序排列 | state 只在本 request满足完成条件后迁移；无提前 B 命中 |
| RB-V05 | US 两 beat正常、缺 beat、多 beat、错 ID、错误 response | 正式协议只接受 beat0/beat1+last；负向激励触发断言 |
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

a_b_resp_owned:
assert property (@(posedge lsu_special_clk) disable iff (!cpurst_b)
  rb_entry_biu_b_resp_set |->
    (rb_entry_state == WAIT_RESP && request_epoch_live));

a_us_second_beat_is_last:
assert property (@(posedge lsu_special_clk) disable iff (!cpurst_b)
  (rb_entry_r_id_hit && rb_entry_inst_us && rb_entry_us_cnt)
  |-> biu_lsu_r_last);

a_response_epoch_matches:
assert property (@(posedge lsu_special_clk) disable iff (!cpurst_b)
  rb_entry_r_id_hit |-> response_epoch == entry_request_epoch);

a_wb_grant_onehot:
assert property (@(posedge lsu_special_clk) disable iff (!cpurst_b)
  $onehot0(rb_entry_wb_cmplt_grnt) && $onehot0(rb_entry_wb_data_grnt));
```

## 4. Sign-off

所有状态边、request 类型、flush 点、response 排列和容量边界均覆盖；旧 epoch response 0 次；create/WB one-hot assertion 0 failure；ECC 配置和固定 ID 串行合同书面确认后方可签核。
