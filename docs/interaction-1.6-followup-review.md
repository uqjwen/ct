# Interaction 1.6 LSU 复核与断言落地

## 1. 结论

本轮以仓库提交 `43254d9`（`int-1.6`）为基线，并继续使用官方 openC910 提交 `b91c90914c19f114d35c8f6b73408eb241ed847c` 做继承对照。README 中的设计说明视为待核对合同，不替代源码和动态验证。

1. **CTRL-RR-03 部分断言已经写入 RTL。** `xx_lsu_lrq` 现在逐 bank、逐 entry 检查：任何可见 wakeup 必须命中 live entry；create-accept 不能和同 bit 的可见旧 wakeup 重叠（`srcs/xx_lsu_lrq.sv:1476-1524`）。当前 producer 端口只有 bitmap，没有 `producer_owner_iid/pending`，因此精确的 owner-IID 等式仍需验证环境导出元数据后绑定，不能由现有端口伪造。
2. **DC-RR-03 断言已经写入 RTL。** live、cacheable 且 D-cache enabled 的 load 必须满足 `$onehot0(ldc_hit_way)`；miss 的全 0 合法，多路同时命中立即报错（`srcs/xx_lsu_ld_dc.sv:1919-1930`）。
3. **RB-RR-02 可按本次明确的 debug-recovery 用途豁免。** async flush 用于 outstanding 长期不返回时强制进入 debug；它不承诺被丢弃请求最终响应，也不承诺从该点无损继续执行。若产品要求不复位 interconnect 就从 debug 恢复正常执行，仍须增加 drain/tombstone/ID-reuse 合同。
4. **RB-RR-04 仅能按“已签核 C910 IP + 周边 ID 所有权未改变”条件豁免。** 本地 RB 的 B-ID 命中方程与 C910 一致，WMB 也只在正式 request 后置 B-ID valid；源码继承证据本身不是“C910 已证明无错”的证明文件。
5. **WB-RR-04 不能仅以 C910 继承直接豁免。** 官方 C910 是单 WB 通道固定优先级；本工程新增 `xx_lsu_wb_arbiter`，把共享 WMB/VMB/RB 分配到 3 条 lane，拓扑并非原样继承。组合安全性已穷举关闭，持续高优先级流量下的 bounded liveness 仍依赖系统级最终让路合同。
6. **WB-RR-01/02 的 Interaction 1.5 残留已由最新代码关闭。** `rb_data_halt_info_update_vld` 现在也打开 data clock（`srcs/xx_lsu_ld_wb.sv:1044-1051`），使 update 在下一拍自清零（`1815-1823`）；随后 completion clock 由 `ld_wb_halt_info_effect` 再开一拍并清掉 effect（`1003-1020`、`1677-1688`）。静态三拍模型从 `(update,effect)=(0,0)` 收敛为 `(1,0)->(0,1)->(0,0)`。
7. **新 AG 设计未发现功能反例，按明确合同条件关闭。** 普通无 stall 请求的一拍 PMP access-fault 在 DA 与 DC 指令对齐采样（`srcs/mmu/xx_mmu_dutlb_read.v:777-801`；`srcs/xx_lsu_ld_da.sv:2408-2415`）；只有 AG 因 backpressure 或 unit-stride 两拍流程停留时，才由 `lag_bkcon_*` 保存 fault（`srcs/xx_lsu_ld_ag.sv:1352-1427`）。TLB miss 会使 EX1 失效并 restart；page/access fault 会停止后续 MMU request，并在 stall 解除后以异常进入 DC（`2433-2471`、`2678-2704`、`2762-2869`）。US 的 tag-request、way-capture、data-request 顺序成立（`1397-1427`、`2623-2635`），fault overlap 不会消费错误 way/data。

仓库没有完整 filelist/testbench，当前环境也没有 Verilator、Icarus、Slang、Surelog 或同类 SV elaborator。因此本轮完成的是源码级断言落地、Python 回归、布尔/逐拍模型和上游对照，不是动态 RTL 签核。

## 2. Interaction 1.6 处置矩阵

| README 项 | 对应风险 | 当前处置 | 关键依据 |
|---:|---|---|---|
| 1 | CTRL-RR-03 / LRQ-RR-03 | **可见边界已实现；精确 owner 证明仍需集成元数据** | `srcs/xx_lsu_lrq.sv` 中 6 组 generate SVA 覆盖 lane0/2/3；现有 wakeup 输入只有 entry bitmap，没有 producer IID/pending。 |
| 2 | DC-RR-03 | **断言已实现** | `srcs/xx_lsu_ld_dc.sv` 对 live cacheable access 断言 `$onehot0(ldc_hit_way)`；0-hit 合法，multi-hit 非法。 |
| 3 | RB-RR-02 | **按 debug-recovery 范围豁免** | 本地及 C910 都允许 WAIT_RESP/REQ_WB 在 async flush 回 IDLE；本次合同明确不等待未完成 outstanding。 |
| 4a | WB-RR-04 | **安全关闭，活性仍为条件项** | 本地三 lane arbiter不是 C910 单通道 RTL 的原样继承；64 组 data 与 32 组 completion 组合已和 greedy 参考模型一致，但固定优先级不推出 bounded grant。 |
| 4b | RB-RR-04 | **C910 签核继承条件豁免** | RB 未按 state 限定的 B-hit、WMB request 后 B-ID valid 和 BIU BID 转发与 C910 同源；仍要求相同固定 ID 下全局唯一 outstanding。 |
| 5 | AG stall/MMU/US | **未发现具体 bug，条件关闭** | 无 stall AF 由 DA 对齐采样；stall AF 由 AG 保存；TLB miss/PF/AF 与 US 两拍的逐拍路径均闭合。投机 D-cache 读仍依赖既有“无副作用且异常结果不消费”合同。 |

## 3. CTRL-RR-03 断言的可证明边界

RTL 已实现以下可直接观察的性质，三条 lane 分别展开到每个 LRQ bit：

```systemverilog
(lsuN_lrq_exx_tlb_wakeup[bit] || lsuN_lrq_frz_clr[bit])
|-> lrqN_entry_vld[bit];

lrqN_create_vld[bit]
|-> !(lsuN_lrq_exx_tlb_wakeup[bit] || lsuN_lrq_frz_clr[bit]);
```

它们能抓到“wakeup 命中已释放 bit”和“新 owner 接受拍仍有旧 wakeup”两类错误，但不能区分“live entry 上的正确 owner wakeup”和“恰好命中同一 live bit 的旧 owner wakeup”。完整写法需要每个 producer 向验证层提供 owner 元数据：

```systemverilog
wakeup[bit]
|-> entry_vld[bit] && producer_owner_iid[bit] == entry_iid[bit];

create_accept[bit]
|-> !old_owner_producer_pending[bit];
```

`producer_owner_iid` 和 `old_owner_producer_pending` 应来自 MMU/LFB/SQ/WMB/DA/LSDA 的 verification-only bind/scoreboard，而不应在 LRQ 内根据同一个 bitmap反推。

在当前 allocator 中 create pointer 只选拍前 invalid entry，因此第二条 create/no-wakeup 可由第一条 wakeup/live 与 allocator 不变量推出；保留独立 label 的价值是故障定位，以及防止以后分配/复用时序调整时静默破坏该边界。它不增加 owner-IID 证明能力。

## 4. DC-RR-03 断言

实际实现使用 `forever_cpuclk` 观察组合 tag-compare 结果，并以 reset、live EX2、cacheable page 和 D-cache enable 资格化：

```systemverilog
(ldc_ex2_inst_vld && ldc_lda_ex2_page_ca && cp0_lsu_dcache_en)
|-> $onehot0(ldc_hit_way);
```

这里使用 `$onehot0` 而不是 `$onehot`，因为合法 cache miss 必须允许四位全 0。断言位于 `` `ifndef SYNTHESIS`` 内，不改变综合网表。

## 5. AG 新设计逐拍复核

### 5.1 普通请求的一拍 access-fault

| 周期 | AG/DC/DA 位置 | MMU/PMP | 异常处理 |
|---|---|---|---|
| C0 | 请求在 AG，若无 backpressure 则送 DC（`srcs/xx_lsu_ld_ag.sv:2865-2869`） | `dutlb_pmp_chk_vld` 接受 PA/type（`srcs/mmu/xx_mmu_dutlb_read.v:777-801`） | AG 不需要等待 fault |
| C1 | 同一请求在 DC（`srcs/xx_lsu_ld_dc.sv:1139-1154`） | `pmp_flg_vld` 产生该请求的 access-fault（`srcs/mmu/xx_mmu_dutlb_read.v:520-526`） | fault 与 DC 请求同事务对齐 |
| C2 边沿 | 请求进入 DA | DA 在 `ldc_ex2_inst_vld` 下锁存 `mmu_lsu_access_fault0`（`srcs/xx_lsu_ld_da.sv:2408-2415`） | DA 在 `2666-2708` 生成 load/AMO access-fault |

因此 `lag_bkcon_stall_already==0` 时 AG 不捕获 access-fault是有意分工，不是漏异常。

### 5.2 backpressure 下的 MMU 结果

- 首个有效 stall 拍令 `lag_bkcon_stall_already` 置 1（`srcs/xx_lsu_ld_ag.sv:1352-1358`）；MMU abort 方程已删除结构 stall（`2433-2443`）。
- `!mmu_lsu_pa_vld` 在 stall 中被保存为 `lag_bkcon_tlbmiss`（`1380-1386`）。下一拍它同时进入 restart 并屏蔽 `lag_ex1_stall_ori`（`2780-2812`），使 EX1 失效；不会把 miss 当异常送 DC。
- `page_fault && pa_vld` 被保存为 `lag_bkcon_pgfault`（`1371-1377`）。它进入 `lsu_mmu_abort`，但不进入 `ld_ag_stall_restart`；其他 backpressure 解除后，异常由 `lag_ldc_ex1_expt_page_fault` 进入 DC（`2678-2704`）。
- 下一拍 access-fault先由 `mmu_lsu_access_fault && lag_bkcon_stall_already` 组合可见；若结构 stall 仍在，则 `lag_bkcon_acfault` 锁存（`1361-1370`）。随后同样 abort MMU，并在 stall 解除后通过 `lag_ldc_ex1_expt_vld` 进入 DC（`2433-2443`、`2700-2704`、`2865-2869`）。
- fault 之后仍可能发生无副作用的投机 tag/data read，因为 `lag_mmu_acfault` 为时序原因没有进入 `ld_ag_data_req_mask`（`2552-2574`）；DC 的 exception valid 会禁止结果成为有效架构数据（`srcs/xx_lsu_ld_dc.sv:1291-1352`、`1469-1533`）。该点依赖既有“D-cache 读无副作用、fault 结果不消费”合同，必须做负向回归。

### 5.3 512-bit unit-stride

| 拍 | 关键状态 | 必须结果 |
|---|---|---|
| US0 | `lag_us_tag_req_stall=1`，tag request 被 arbiter 接受后置 success（`srcs/xx_lsu_ld_ag.sv:1397-1405`） | data request 被屏蔽（`2623`） |
| US1 | `lag_us_tag_req_success_flop=1`，`lag_us_tag_ack_stall=1`（`1406-1416`） | 锁存同步 tag 输出对应的 `lag_us_tag_hit_way`（`1418-1424`、`2628-2631`） |
| US2 | 两个 US stall 均解除 | 使用已锁存 way 形成 512-bit data index并进入 DC（`2634-2640`） |

若 US0 遇 TLB miss，保存 miss 后 EX1 失效，US way 不会被消费；若遇 page fault，abort MMU并在两拍流程退出后送异常；一拍 access-fault在 US1 可见并被保存，US2 送异常。未发现跨事务 way 串扰：新 RF load 与 reset 都清 success/way 状态，stall 覆盖时旧事务通过 LRQ 重发。

## 6. RB/WB 豁免边界

### RB-RR-02

本次明确的使用场景是“核因 outstanding 长期无响应卡死，debug 发起 async flush 以查看状态”。在这个恢复范围内，等待一个本来就可能永不返回的 response 与目标矛盾，因此可以豁免 response drain。该豁免不等价于以下更强保证：

- flush 后旧 response 一定被系统吸收；
- 无 interconnect reset 就能安全恢复正常执行；
- 被释放 ID 可立即复用且绝不被迟到 response 命中。

如果产品需要这些能力，必须恢复 RB-RR-02 的 drain/tombstone/epoch 检查。

### RB-RR-04

本地 RB 的 `rb_entry_biu_b_resp_set = rb_entry_b_id_hit`（`srcs/xx_lsu_rb_entry.sv:2048-2067`）与 [C910 RB entry](https://github.com/T-head-Semi/openc910/blob/b91c90914c19f114d35c8f6b73408eb241ed847c/C910_RTL_FACTORY/gen_rtl/lsu/rtl/ct_lsu_rb_entry.v#L1236-L1249) 一致；本地 WMB 用 B-ID-valid 限制 paired response（`srcs/xx_lsu_wmb_entry.sv:983-992`、`2031-2050`），上游也采用相同结构（[C910 WMB entry](https://github.com/T-head-Semi/openc910/blob/b91c90914c19f114d35c8f6b73408eb241ed847c/C910_RTL_FACTORY/gen_rtl/lsu/rtl/ct_lsu_wmb_entry.v#L2013-L2041)）。故在以下条件同时成立时可按已签核 IP 继承豁免：C910 的验证/量产签核被项目接受、RB/WMB/BIU 固定 ID 编码与唯一 outstanding 合同未改、debug flush 不要求可恢复。缺少任一项时仍应保留 ID ownership assertion。

### WB-RR-04

C910 [`ct_lsu_ld_wb`](https://github.com/T-head-Semi/openc910/blob/b91c90914c19f114d35c8f6b73408eb241ed847c/C910_RTL_FACTORY/gen_rtl/lsu/rtl/ct_lsu_ld_wb.v#L511-L545) 只有一个 WB destination，优先级为 DA→WMB/VMB→RB；本工程新增三 destination 的 `xx_lsu_wb_arbiter`（`srcs/xx_lsu_wb_arbiter.sv:66-147`）。虽然策略同属固定优先级，新的 lane packing 逻辑不是同一 RTL，不能仅引用 C910 签核。当前结论仍是：

- 单拍 source/lane one-hot、work-conserving 和 grant/request 一致性已静态穷举关闭；
- 若专用 lane 与更高优先级 shared source 永不让路，VMB/RB 可无限等待；
- 只有系统级 `WB_GRANT_BOUND`/最终 quiescence 合同或公平仲裁 RTL 才能关闭活性项。

## 7. 验证结果与限制

已执行：

- `python3 -m unittest tests/test_interaction_1_6_assertions.py`：3 项通过；
- 断言修改前同一检查按预期失败，证明测试能观察缺失功能；
- WB halt-info 三拍状态模型：`(0,0)->(1,0)->(0,1)->(0,0)`；
- LRQ 可见单拍义务 8 组二态穷举；
- `git diff --check`：通过。

仍需在完整工程执行：SV compile/elaboration、断言仿真或 formal、AG `stall source × MMU result × US phase` 交叉、debug async-flush 系统测试、WB bounded-grant 证明，以及 DC 多副本负向注入。
