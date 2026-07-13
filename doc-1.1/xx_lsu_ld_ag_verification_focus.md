# `xx_lsu_ld_ag` 重点验证方案

## 1. 验证目标

本方案面向 interaction 1.1 新增的两项机制：

- MMU 内部 miss queue 缓存、合并并唤醒 miss 请求；
- LSU 内部 LRQ 保存请求并 replay，不再依赖 IDU 重新发射。

验证的核心不是“某个波形看起来合理”，而是以下端到端不变量：

1. 每个未被 flush 的 load 请求恰好到达一个终态：正常完成、确定异常或架构允许的取消。
2. 每个被 flush 的请求不得在 flush 后产生 DC 接受、写回、异常、调试触发或 predictor 更新。
3. 每个 LRQ entry 的 create、freeze、wakeup、replay、complete/pop 必须属于同一事务，不得丢失、重复或串到 entry 复用后的新事务。
4. replay 的功能元数据必须与原始请求相同；任一 valid-qualified payload 不得包含 `X/Z`。
5. MMU 请求、响应、stall、abort 和 wakeup 必须满足明确且可断言的接口合同。

## 2. 建议验证环境

### 2.1 两层环境

- **AG/LRQ 模块级环境**：允许观察 `lag_ex1_inst_vld`、`ld_ag_stall_vld`、`lag_lrq_create_already`、`lag_bkcon_*`、`lag_lrq_*` 等内部状态，用于快速复现风险和绑定断言。
- **LSU 集成环境**：至少包含 `xx_lsu_lrq`、`xx_lsu_ld_ag`、`xx_lsu_ld_dc`、`xx_lsu_ld_da`、controller、D-cache 仲裁和可编程 MMU miss queue 模型，用于验证真实 accept/wakeup/flush 路径。

仅做 AG 单模块随机激励不足以证明新 replay 架构正确。

### 2.2 事务 scoreboard

建议用 `{pipe_id, IID, LRQ_onehot_id, flush_epoch}` 作为事务键，记录：

1. IDU/RF issue；
2. AG capture；
3. LRQ create/accept；
4. MMU request accept；
5. DC accept；
6. MMU immediate/async wakeup；
7. LRQ replay；
8. DA/WB complete、exception 或 flush kill。

不能只用 IID，因为 IID 会回绕；不能只用 LRQ bit，因为 entry 会复用。

### 2.3 MMU 模型能力

MMU 模型至少支持：

- 同拍 hit；
- miss 入队后 N 拍完成；
- queue full/not-ready；
- 同 VA 多请求 merge；
- immediate wakeup 和 async bitmap wakeup；
- page fault、access fault；
- 响应只脉冲一拍和响应保持到接受两种模式；
- abort 对“同拍未接受请求”和“已入队请求”的两种语义开关；
- flush 后迟到响应/迟到 wakeup 注入。

## 3. P0：必须首先执行的定向测试

这些测试直接对应 `xx_lsu_ld_ag_risk_review.md` 中的高优先级风险。

这里的 **P0/P1 表示验证执行顺序**，不同于风险报告中表示设计后果的 P1/P2/P3。P0 是大规模回归前必须先跑的诊断用例，因此也会覆盖部分设计风险 P2。

| ID | 场景与激励 | 必查结果 | 关联源码/风险 |
|---|---|---|---|
| V0-NS-FRESH | 三条 load lane 分别发送 `no_spec_exist=1`，覆盖 `no_spec=00/01/10/11` | 先记录当前 RTL 会清零 fresh `no_spec_exist`；若接口合同要求保留原 predictor 状态，则 LRQ mux、AG/DC/DA 必须逐位直通；若合同明确忽略它，则证明该输入不可观察/输出恒 0，并删除或约束死端口 | `srcs/xx_lsu_lrq.sv:1792-1794`；RR-01 |
| V0-NS-REPLAY | 同一组 no-spec 请求 create 后随机等待 0/1/N 拍再 replay | valid replay 的 `no_spec` 不得为 X；`no_spec_exist` 必须符合设计方确认的 predictor/wait-state 语义，只有确认其代表原 predictor metadata 时才要求与 create 输入逐位相等 | `srcs/xx_lsu_lrq_entry.sv:721-740`；RR-01/RR-02 |
| V0-REPLAY-X | scalar、boundary LDR、vector indexed、vector US 分别 replay，开启 X-prop | valid 的 AG→DC、AG→MMU、AG→IDU payload 不含 X；地址、mask、element count、rotation 与参考模型一致 | `srcs/xx_lsu_lrq.sv:1786-1818`；RR-02 |
| V0-HALT | 开启地址 trigger；LRQ replay 同拍在 IDU bus 放另一条不同 `halt_info` 指令 | replay 指令的 trigger/halt 结果只能取原事务 metadata，不得受当前 IDU 污染 | `srcs/xx_lsu_top.sv:5392-5395`；RR-03 |
| V0-IDLE-STALL | AG/RF 空闲、control clock 可达时，让 `mmu_lsu_stall=1` 保持 1/N 拍；另跑真实门控时钟配置 | 不得凭空产生 `lag_ex1_inst_vld`、LRQ create、MMU request、D-cache request 或 early wake；门控配置不得掩盖控制/数据状态分歧 | `srcs/xx_lsu_ld_ag.sv:2765`、`srcs/xx_lsu_ld_ag.sv:2799-2811`；RR-04 |
| V0-NOTREADY-BKCON | fresh valid 同拍施加 `mmu_lsu_stall=1`、D-cache/结构 backpressure 和 `mmu_lsu_pa_vld=0`；controller freeze-clear 分别及时、延迟 N 拍 | 无请求丢失、重复或永久 frozen；原 LRQ ID 最终且仅重试一次。若该输入组合非法，必须由接口 assume 明确排除 | `srcs/xx_lsu_ld_ag.sv:1380-1387`、`srcs/xx_lsu_ld_ag.sv:2761-2765`、`srcs/xx_lsu_ld_ag.sv:2846-2854`；RR-06 |
| V0-FAULT-BKCON | 首个 D-cache backpressure 周期分别只脉冲一拍 access fault/page fault；PF 交叉 `pa_vld=0/1`，再跑“保持到接受”版本 | 合法 MMU 响应模式不得漏异常或串事务；若协议要求 `PF -> pa_vld`，非法组合应由 assume 拦截 | `srcs/xx_lsu_ld_ag.sv:1352-1378`；RR-05/RR-07 |
| V0-MISS-ABORT | T0 miss 被 MMU 接受并携带 LRQ ID，T1 观察/驱动 abort，N 拍后 wakeup | 已接受事务不能被错误取消；LRQ 最终醒来并且只 replay 一次 | `srcs/xx_lsu_ld_ag.sv:1380-1387`、`srcs/xx_lsu_ld_ag.sv:2432-2442`；RR-06 |
| V0-CREATE-FLUSH | LRQ create 与 full flush、partial flush 分别同拍 | 被 kill 时不得分配，也不得向 IDU 产生有效 pop；未被 kill 时 create/pop 必须共同成功 | `srcs/xx_lsu_lrq.sv:1448-1452`、`srcs/xx_lsu_lrq.sv:1692-1693`；RR-08 |
| V0-CREATE-FULL | 每条 lane 独立覆盖 empty、one-left、reserved-threshold、full；再叠加三 lane 同拍 create/pop | `no_space` 必须阻止已满 lane 发射；每个被接受请求的本 lane free pointer 为 one-hot，allocation/pop 与统一 accept 一致；三 lane 之间不得串 entry，但不假设它们竞争同一 pointer | `srcs/xx_lsu_lrq.sv:1411-1470`、`srcs/xx_lsu_lrq.sv:1628-1683`；RR-08 |
| V0-FRESH-STATE | 三 lane 分别令 fresh `already_da/spec_fail/unal2nd=1` | 若协议允许为 1，必须直通；若协议要求恒 0，接口断言必须明确拒绝该输入 | `srcs/xx_lsu_lrq.sv:1781`、`srcs/xx_lsu_lrq.sv:1803`、`srcs/xx_lsu_lrq.sv:1812`；RR-09 |
| V0-PARAM | 分别 elaboration 默认值、`LRQENTRY>LSIQENTRY`、`PC_LEN!=15`、`VMBENTRY!=8`、split width 非 9 | 支持配置必须无截断；不支持配置必须在 elaboration 明确失败 | RR-10 |

## 4. MMU miss queue 与 replay 生命周期

### 4.1 基本矩阵

每一种请求来源都执行以下矩阵：

- 来源：`{fresh IDU, LRQ replay}`
- MMU：`{hit, miss accepted, queue full/stall, page fault, access fault}`
- D-cache：`{同拍接受, backpressure 1 拍, backpressure N 拍}`
- 更老 RF 请求：`{无, 有}`
- flush：`{无, full, partial-kill, partial-keep}`

检查点：

- hit 时 PA 必须等于 `{mmu_lsu_pa, VA[11:0]}`；
- miss 时不能产生架构副作用，且 LRQ ID 必须随请求被 MMU 接受；
- queue full 时，无更老请求应本地保持，有更老请求应安全转入 LRQ；
- fault 必须归属于原 IID/LRQ ID；
- replay 不得再次 create 新 LRQ entry：`srcs/xx_lsu_ld_ag.sv:3030-3032`；
- 当前集成的 LRQ PA cache 关闭，正常 replay 应重新访问 MMU：`srcs/xx_lsu_ld_ag.sv:2417-2427`、`srcs/xx_lsu_lrq_entry.sv:927-929`。

### 4.2 必须命中的端到端 sequence

1. `MMU miss -> LRQ frozen -> async wake -> replay -> DC accept -> complete/pop`。
2. `MMU miss -> immediate wakeup -> replay`，wakeup 延迟覆盖 0/1/N。
3. `同 VA 两请求 -> MMU merge -> 多 bit wakeup -> 两事务各 replay 一次`。
4. `miss -> full flush -> 同一 LRQ bit 立即复用 -> 旧 wakeup 迟到`，旧 wakeup 不得解冻新事务。
5. `AG D-cache stall -> 更老 RF 覆盖 -> 当前 entry 变 ready -> 后续 replay`。
6. `MMU queue full -> stall 解除 -> 原事务继续`，期间请求字段保持稳定。

### 4.3 MMU 请求稳定性

一旦定义 accept 条件，例如：

```text
mmu_accept = lsu_mmu_va_vld && !mmu_lsu_stall && !lsu_mmu_abort
```

就应检查：

- 从 request 出现到 accept 前，`va/id/lsid/st_inst` 保持稳定；
- 每个请求最多 accept 一次；
- accept 后，后续端口 abort 不得意外取消已接受项，除非 abort 明确携带同一事务 tag；
- wakeup bitmap 只命中仍有效且属于同一 flush epoch 的 entry。

## 5. Stall、优先级与 flush

### 5.1 Stall 来源交叉

单独和两两组合注入：

- atomic-not-commit；
- fence/bar wait；
- no-spec wait；
- cross-page/boundary LDR；
- D-cache select/backconnect；
- unit-stride tag-request/tag-ack stall；
- MMU stall。

核对三层语义：

- `ld_ag_stall_restart`：请求不能进入 DC；
- `lag_ex1_stall_ori`：AG 当前事务需要本地保持或转入可调度 LRQ；
- `ld_ag_stall_vld`：是否真的阻止 AG 寄存器被 RF 覆盖。

相关逻辑位于 `srcs/xx_lsu_ld_ag.sv:2709-2811`。重点覆盖：

- atomic/bar/no-spec 与 cross-page 同拍；
- MMU stall 与 D-cache stall 同拍；
- `mmu_lsu_pa_vld=0` 时检查 `tlbmiss -> abort -> controller freeze-clear -> 单次 retry` 的完整链路，不得永久 frozen；
- stall 时 `idu_lsu_rf_older_vld=0/1`；
- replay 请求遇到新 stall；
- 每一个优先级冲突只能选择一种恢复动作。

### 5.2 Flush 点

full 和 partial flush 都要覆盖以下同拍位置：

1. RF→AG capture；
2. AG local stall；
3. LRQ create；
4. MMU pending；
5. wakeup；
6. LRQ issue/replay；
7. DC accept；
8. DA/WB complete。

partial flush 要覆盖 IID older/equal/newer 和 IID 回绕。被 kill 事务必须满足：

- AG valid 清除：`srcs/xx_lsu_ld_ag.sv:1074-1087`；
- LRQ entry 清除；
- 不产生迟到 DC valid、early wake、writeback、exception、debug hit 或 predictor 更新；
- MMU旧响应和旧 wakeup 不能命中复用 entry。

## 6. 地址、跨页、boundary 与字节掩码

### 6.1 标量地址参考模型

覆盖：

- size：byte/half/word/dword；
- `VA[3:0] = 0..15`；
- base 页内偏移：`0, 1, 7, 8, 15, 16, 0xff0, 0xff8, 0xfff`；
- offset：`-4097, -4096, -1, 0, 1, 4095, 4096`；
- one-hot shift 四种取值；
- split、secd、offset_plus。

用 64-bit 软件参考模型计算最终 VA、4 KiB crossing、16-byte boundary 和两半 byte mask。检查：

- `ld_ag_cross_4k` 与真实页号变化一致；
- 第一次跨页访问不能把旧页 PPN 与新页 offset 组合后送入 DC；
- 两半 mask 的并集等于原访问字节集合，且无丢失/重复；
- 本地二拍和“转 LRQ 后 replay”两条路径结果一致。

相关源码：`srcs/xx_lsu_ld_ag.sv:1257-1336`、`srcs/xx_lsu_ld_ag.sv:1505-1653`、`srcs/xx_lsu_ld_ag.sv:2722-2755`。

### 6.2 Boundary LDR

对 `inst_ldr=1` 覆盖：

- 跨/不跨 16-byte boundary；
- 跨/不跨 4 KiB；
- 第一半/第二半遇到 MMU miss、fault、D-cache stall、flush；
- create 后 replay。

每个事务必须恰好完成所需的两个半部，地址相差 16，mask、异常 VA 和最终写回归属一致。特别检查 replay 时 `inst_ldr` 不得为 X，关联 `srcs/xx_lsu_lrq.sv:1786` 和 `srcs/xx_lsu_ld_ag.sv:2744`。

## 7. 向量与 unit-stride

### 7.1 必测组合

- indexed/strided 与 unit-stride；
- mask 全 0、部分 1、全 1；
- `vmew/vlmul/vls_size/split_num/vstart` 边界值；
- `bytes_vld[0:3]` 和 `reg_bytes_vld[0:3]` 覆盖完整 64-byte 范围；
- FOF 首元素/非首元素异常；
- 每种组合各跑无 replay 和 1/N 次 replay。

检查：

- create 与 replay 的 VA、boundary、bytes mask、reg mask、element count、rotation、VMB ID 完全一致；
- masked-off 元素不得产生异常或写回；
- FOF 非首元素按架构更新 VL，而不是普通 trap；
- replay 时 LRQ 给出的 `VL/vmask/source mask` 不得在有效计算链上传播 X；
- unit-stride tag request→way capture→data request 的三阶段不能跨事务串 way。

相关源码：`srcs/xx_lsu_ld_ag.sv:1692-1757`、`srcs/xx_lsu_ld_ag.sv:2115-2176`、`srcs/xx_lsu_ld_ag.sv:2189-2245`、`srcs/xx_lsu_ld_ag.sv:2391-2407`。

## 8. 异常、AMO/LR 与 cache 属性

### 8.1 异常优先级

分别和两两同拍注入：

- misalign-no-page；
- page fault；
- misalign-with-page；
- vector strong-order access fault；
- generic MMU access fault；
- LDAMO non-cacheable；
- ECC fatal。

检查 `lag_ldc_ex1_expt_*`、DC 编码、DA 最终异常码、mtval/VA 和 IID 均唯一正确。AG 聚合位于 `srcs/xx_lsu_ld_ag.sv:2661-2703`，DA 还会单独采样 MMU access fault，因此必须验证 fault 信号与该事务的 DC/DA 时序对齐。

### 8.2 AMO/LR

覆盖：

- atomic 未 commit，随后 0/1/N 拍由 commit0..5 中正确 IID 放行；
- 错误 IID commit 不得改变 entry；
- AMO wait-old 与 cross-page、MMU stall、bar/no-spec、flush 同拍；
- LR 和 LDAMO 分别交叉 aligned/misaligned、CA/non-CA、SO、PF、AF；
- commit 后仍遇到 D-cache backpressure。

每个 AMO/LR 事务只允许一次 local-monitor init 和一次架构终态。相关逻辑见 `srcs/xx_lsu_ld_ag.sv:2524-2542`、`srcs/xx_lsu_ld_ag.sv:2709-2711`、`srcs/xx_lsu_ld_ag.sv:2973-2989`。

### 8.3 投机 D-cache 读与 early wake

交叉 `pa_vld`、CA、SO、PF、AF、dcache enable、boundary acceleration。当前请求没有用 PA valid/CA/异常资格：`srcs/xx_lsu_ld_ag.sv:2548-2569`。必须证明在 `!pa_vld || !CA || fault` 时：

- 没有架构可见 cache side effect；
- 错误 tag hit 不会创建错误 LQ/完成；
- 不会使用错误数据提前回写；
- 任一 early wake 均有及时且同事务的 cancel/replay；
- `ld_ag_acclr_en` 的预资格与真正 `lag_ldc_ex1_acclr_en` 不一致时，后级分类仍正确，见 `srcs/xx_lsu_ld_ag.sv:2484-2498`、`srcs/xx_lsu_ld_ag.sv:2880-2908`。

## 9. 时钟门控与四态验证

### 9.1 接口关系

AG valid 用 `idu_lsu_rf_sel` 更新，而 payload 时钟由 `idu_lsu_rf_gateclk_sel` 打开：`srcs/xx_lsu_ld_ag.sv:1039-1045`、`srcs/xx_lsu_ld_ag.sv:1074-1087`。必须确认并断言至少满足：

```text
idu_lsu_rf_sel -> idu_lsu_rf_gateclk_sel
```

还要覆盖 reset、full/partial flush、local stall、cross-page 状态、LRQ replay 在 ICG on/off 和 scan enable 下的行为；清除状态不能依赖一个可能关闭的时钟。

### 9.2 X-prop

开启 pessimistic X-prop，至少覆盖：

- 复位后首条请求；
- idle MMU 输出为 X；
- replay 未保存字段为 X；
- `lag_ldc_ex1_bytes_vld1` case 控制位含 X；
- helper 模块未使用输入含 X。

所有 valid-qualified MMU、D-cache、DC、IDU、DTU payload 都应绑定 `$isunknown` 检查。

## 10. 建议断言模板

以下是意图模板；时钟域、层级名和 accept 定义应按完整工程调整。

```systemverilog
// 空闲不能因为全局 MMU stall 产生 AG 事务
a_no_idle_stall_phantom:
assert property (@(posedge ctrl_ld_clk) disable iff (!cpurst_b)
  (!lag_ex1_inst_vld && !idu_lsu_rf_sel)
  |-> !ld_ag_stall_vld);

// valid 与 payload 门控时钟合同
a_rf_sel_has_data_clock:
assert property (@(posedge forever_cpuclk) disable iff (!cpurst_b)
  idu_lsu_rf_sel |-> idu_lsu_rf_gateclk_sel);

// 仅当设计合同确认 fresh 需要保留原 predictor metadata 时启用；
// 若合同要求忽略该输入，则改为证明输入不可观察且输出为约定安全值。
a_fresh_no_spec_passthrough:
assert property (@(posedge forever_cpuclk) disable iff (!cpurst_b)
  (lsu0_issue_sel_idu && lsu0_issue_permit_idu)
  |-> (lrq_lsu0_rf_no_spec == idu_lsu0_rf_no_spec
       && lrq_lsu0_rf_no_spec_exist == idu_lsu0_rf_no_spec_exist));

// replay 不得再次建立 entry
a_replay_no_recreate:
assert property (@(posedge forever_cpuclk) disable iff (!cpurst_b)
  (lag_ex1_inst_vld && lag_lrq_replay_vld)
  |-> !lsu_lrq_create_vld);

// 先把 full/partial-flush kill 与分配合并成唯一 create_accept。
// 信号名按 LRQ 层级书写；若从 top 绑定，应补相应层级路径。
assign lrq0_create_kill = rtu_lsu_flush_fe
                       || (rtu_ck_flush && rtu_ck_flush_iid_older_lsu0_iid);
assign lrq0_create_accept = lsu0_lrq_create_vld
                         && !lrq0_create_kill
                         && $onehot(lrq0_create_ptr0);

// 只要 create 没有被 flush kill，就必须拥有唯一 entry。
a_lrq_create_has_pointer:
assert property (@(posedge forever_cpuclk) disable iff (!cpurst_b)
  (lsu0_lrq_create_vld && !lrq0_create_kill)
  |-> $onehot(lrq0_create_ptr0));

// 实际 entry allocation 与统一 accept 同拍一致。
a_lrq_allocation_matches_accept:
assert property (@(posedge forever_cpuclk) disable iff (!cpurst_b)
  (|lrq0_create_vld) == lrq0_create_accept);

// LSIQ pop 不能发生在分配失败或 flush kill 的周期。
a_lrq_pop_matches_accept:
assert property (@(posedge forever_cpuclk) disable iff (!cpurst_b)
  lrq0_idu_ex3_pop_vld == lrq0_create_accept);

// AG create_already 和发给 MMU 的 lsid 也应使用同一个 accept/scoreboard 事件核对。

// AG→DC valid 方程
a_dc_valid_equation:
assert property (@(posedge forever_cpuclk) disable iff (!cpurst_b)
  lag_ldc_ex1_inst_vld
  == (lag_ex1_inst_vld && !ld_ag_stall_restart));

// 跨页第一遍不能进入 DC
a_cross_page_blocks_first_pass:
assert property (@(posedge forever_cpuclk) disable iff (!cpurst_b)
  ld_ag_cross_page_ldr_imme_stall_req
  |-> (!lag_ldc_ex1_inst_vld && lsu_mmu_abort));

// 有效 DC payload 不能含 X
a_no_x_on_valid_dc:
assert property (@(posedge forever_cpuclk) disable iff (!cpurst_b)
  lag_ldc_ex1_inst_vld
  |-> !$isunknown({lag0_ex1_iid, lag_ldc_ex1_lsid,
                   lag_ldc_ex1_addr0, lag_ldc_ex1_bytes_vld,
                   lag_ldc_ex1_page_ca, lag_ldc_ex1_page_so,
                   lag_ldc_ex1_no_spec, lag_ldc_ex1_inst_type}));
```

若设计方确认 MMU 响应必须保持，可把合同写成 assume：

```systemverilog
a_mmu_response_stable_while_blocked:
assume property (@(posedge forever_cpuclk) disable iff (!cpurst_b)
  lsu_mmu_va_vld && lag_bkcon_stall_vld && !lsu_mmu_abort
  |=> $stable({mmu_lsu_pa_vld, mmu_lsu_pa,
               mmu_lsu_ca, mmu_lsu_so, mmu_lsu_buf,
               mmu_lsu_sec, mmu_lsu_sh,
               mmu_lsu_page_fault, mmu_lsu_access_fault}));
```

若设计方允许一拍响应，则不能添加上述 assume，必须检查 AG sticky capture。

## 11. 功能覆盖

### 11.1 必做交叉

- 请求来源 `{IDU, LRQ replay}` × MMU `{hit, miss, queue-full, PF, AF}`。
- replay reason `{TLB miss, D-cache conflict, LQ/RB full, wait-old, fence, no-spec, cross-page}` × 指令类。
- 指令类 `{scalar, boundary LDR, vector non-US, vector US, LR, LDAMO}` × page attr `{CA, non-CA, SO}`。
- 地址 `{aligned, 16B boundary, 4KiB 正向跨页, 4KiB 负向跨页}` × split/secd。
- stall 来源 × `{无更老 RF, 有更老 RF}`。
- flush 点 × `{full, partial-kill, partial-keep}`。
- LRQ occupancy `{empty, one-left, reserved threshold, full}` × `{单 lane create, 三 lane 同拍 create, 同拍 pop}`。
- no-spec `{00,01,10,11}` × exist `{0,1}` × `{fresh,replay}` × lane `{0,2,3}`。
- MMU response `{一拍脉冲, 保持}` × backpressure `{0,1,N}` × fault `{PF,AF}`。
- wakeup `{immediate, async one-bit, async multi-bit}` × latency `{0,1,N}` × flush/reuse。

### 11.2 覆盖完成条件

除代码覆盖外，必须满足：

- 上述所有 P0 测试有明确 pass/fail；
- 所有端到端 sequence 命中；
- 所有 P1 风险的接口合同已由设计方确认并转成 assertion/assumption；
- replay 有效路径 X-prop 0 failure；
- 每一种异常和每一对异常优先级均命中；
- IID 回绕、LRQ bit 复用和 flush epoch 交叉命中。

## 12. Sign-off 条件

`xx_lsu_ld_ag` 及新 MMU/LRQ 机制满足以下条件后，才建议关闭验证：

1. RR-01 的 no-spec predictor/wait-state 语义已确认；所有已确认的 replay X 与跨事务 metadata 问题已修复，三 lane 定向测试全部通过。
2. MMU 的 accept/stall/abort/response/wakeup 合同形成书面说明，并有断言保护。
3. LRQ create 有唯一、可观察的 accept 语义；分配、MMU lsid、LSIQ pop 和 `create_already` 一致。
4. full/partial flush 后无旧事务副作用，旧 wakeup 不能污染复用 entry。
5. scalar、LDR、vector、AMO/LR 的 hit/miss/fault/replay 端到端 scoreboard 全部通过。
6. 默认配置完成 compile/elaboration、lint、CDC/clock-gating 检查和 X-prop；支持的非默认参数也必须 elaboration 通过。
7. assertion 0 failure，功能覆盖目标全部达到；任何未达到项都有设计方签字的明确豁免。

## 13. 需要设计方在执行回归前确认的问题

1. `mmu_lsu_stall` 是否只在当前端口请求有效且尚未 accept 时有效？
2. MMU request accept 的精确定义是什么？
3. PA/属性/PF/AF 是一拍脉冲还是保持型响应？
4. abort 是否会取消已经进入 miss queue 的事务？
5. immediate wakeup 能否与 LRQ create 同拍？async bitmap 能否多 bit？
6. flush 后旧 miss queue 项如何携带 generation/epoch，避免命中复用 LRQ bit？
7. LRQ create 的容量预留规则是什么？为什么没有 ready/accept？
8. fresh `already_da/spec_fail/unal2nd` 是否保证恒为 0？
9. replay 必须保存的 metadata 清单是什么？
10. no-spec predictor metadata 与 LRQ wait-no-spec 状态是否为两个独立字段？
11. D-cache 在 PA/异常未决时的 tag/data 读是否完全无副作用？
12. 当前正式支持哪些 `LRQENTRY/LSIQENTRY/PC_LEN/VMBENTRY/split width` 参数组合？
13. `mmu_lsu_stall=1`、结构 backpressure 与 `mmu_lsu_pa_vld=0` 能否合法同拍？若能，controller 的 freeze-clear 最迟何时到达，如何证明原 LRQ ID 只 retry 一次？
