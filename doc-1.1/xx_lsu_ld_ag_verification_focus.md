# `xx_lsu_ld_ag` 重点验证方案

## 1. 验证目标

本方案面向 interaction 1.1/1.1.1/1.1.2 的两项机制、两处最新 RTL 修复与新增接口合同：

- MMU 内部 miss queue 缓存、合并并唤醒 miss 请求；
- LSU 内部 LRQ 保存请求并 replay，不再依赖 IDU 重新发射。

验证的核心不是“某个波形看起来合理”，而是以下端到端不变量：

1. 每个未被 flush 的 load 请求恰好到达一个终态：正常完成、确定异常或架构允许的取消。
2. 每个被 flush 的请求不得在 flush 后产生 DC 接受、写回、异常、调试触发或 predictor 更新。
3. 每个 LRQ entry 的 create、freeze、wakeup、replay、complete/pop 必须属于同一事务，不得丢失、重复或串到 entry 复用后的新事务。
4. replay 的功能元数据必须与原始请求相同；任一 valid-qualified payload 不得包含 `X/Z`。
5. MMU 请求、响应、stall、abort 和 wakeup 必须满足明确且可断言的接口合同。

目标环境固定采用以下合法合同：`mmu_lsu_stall==0`；access fault 在请求后一拍返回；`page_fault -> pa_vld` 且同拍；fresh IDU 在进入 AG 前已由 LRQ `no_space` 完成容量预留；`mmu_accept = lsu_mmu_va_vld && !lsu_mmu_abort` 且当拍记录、下一拍生效；只有 `!pa_vld && !abort` 形成 MMU pending，accept 后 abort 不可追溯取消；`mmu_lsu_imme_wakeup==0`，合法 MMU 唤醒只走 async bitmap；full/partial flush 在 LRQ bit 复用前删除匹配 pending 且不得残留 wake；flush 优先于 raw pop；D-cache 投机读无副作用且无效结果不可消费；`pfu_part_empty` 永久 tie 0；只支持 README 指定的固定参数组合。违反这些合同的激励不再作为目标功能用例，而应由 assumption/assertion 在边界处拒绝。

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
6. MMU async wakeup 或 flush-cancel；
7. LRQ replay；
8. DA/WB complete、exception 或 flush kill。

不能只用 IID，因为 IID 会回绕；不能只用 LRQ bit，因为 entry 会复用。

### 2.3 MMU 模型能力

MMU 模型至少支持：

- 同拍 hit；
- miss 入队后 N 拍完成；
- accepted miss（目标接口不使用 `mmu_lsu_stall` 表示 not-ready）；
- 同 VA 多请求 merge；
- 三路 immediate wakeup 端口永久输出 0；所有合法唤醒只通过 async bitmap；
- page fault 与同拍 `pa_vld`；
- 请求后一拍 access fault；
- 同拍 abort 阻止 accept，accept 后的后拍 abort 不得追溯取消；
- full/partial flush 精确删除匹配 pending，并保证被 kill lsid 不再产生迟到 wake；负向单元可故意注入迟到 wake 以证明合同断言会失败。

## 3. P0：必须首先执行的定向测试

这些测试直接对应 `xx_lsu_ld_ag_risk_review.md` 中的高优先级风险。

这里的 **P0/P1 表示验证执行顺序**，不同于风险报告中表示设计后果的 P1/P2/P3。P0 是大规模回归前必须先跑的诊断用例，因此也会覆盖部分设计风险 P2。

| ID | 场景与激励 | 必查结果 | 关联源码/风险 |
|---|---|---|---|
| V0-NS-FRESH | 三条 load lane 分别发送不同 predictor `no_spec_exist`，覆盖 `no_spec=00/01/10/11` | 证明旧 predictor exist 输入在 LSU 内不可观察；fresh 输出按新合同清零，内部 `no_spec_exist` 只由 LRQ wait 状态建立 | `srcs/xx_lsu_lrq.sv:1792-1794`；已关闭 RR-01 |
| V0-NS-REPLAY | 同一组 no-spec 请求 create 后随机等待 0/1/N 拍再 replay | valid replay 的 2-bit `no_spec` 不得为 X；改义后的 `no_spec_exist` 必须准确表示内部 wait 历史，不要求等于旧 predictor 输入 | `srcs/xx_lsu_lrq_entry.sv:721-740`；RR-02 |
| V0-REPLAY-X | scalar、boundary LDR、vector indexed、vector US 分别 replay，开启 X-prop | saved VA/boundary/byte/reg-byte mask 与 create 时一致；valid `no_spec/element_cnt/rot_sel` 不含 X，rotation、FOF VL/vstart 与参考模型一致 | `srcs/xx_lsu_lrq.sv:1771-1818`、`srcs/xx_lsu_ld_ag.sv:2392-2408`；缩小后 RR-02 |
| V0-CASE-X | 对 `bytes_vld1` selector 穷举 `{0,1,X}` 27 组，并把每个 X 展开成二值细化 | 8 个二值组合正确；16 个未匹配含 X 组合显式输出 X 且不保留上拍值；记录 `00X/1X0/1X1` 仍输出确定值，并由设计方选择 functional-ambiguity 或 literal any-X 政策 | `srcs/xx_lsu_ld_ag.sv:2158-2167`；RR-12 主问题已修复/范围待确认 |
| V0-HALT | 开启地址 trigger；LRQ replay 同拍在 IDU bus 放另一条不同 `halt_info` 指令 | replay 指令的 trigger/halt 结果只能取原事务 metadata，不得受当前 IDU 污染 | `srcs/xx_lsu_top.sv:5392-5395`；RR-03 |
| V0-MMU-CONTRACT | 集成层保持 `mmu_lsu_stall==0`；另在接口断言单元故意注入 1 | 目标回归中该信号永远为 0；负向注入必须立即触发合同断言，而不是继续验证未定义行为 | `srcs/xx_lsu_top.sv:421-424`、`srcs/xx_lsu_ld_ag.sv:2766`；RR-04 |
| V0-FRESH-MISS-OVERRIDE | fresh A 遇到结构/D-cache stall，更老 RF B 同拍覆盖；交叉 `{pa_vld,abort}={00,10,01}` | `00` accepted miss 必须 `create_frz=1` 且 async wake 前不 replay；hit/abort 行必须 `create_frz=0` 并只重发一次；三 lane 方程一致 | `srcs/xx_lsu_ld_ag.sv:2828-2855`、`srcs/xx_lsu_ld_ag.sv:3031-3036`；已修复 RR-13 |
| V0-MMU-IMME-TIEOFF | 三条 lane 在 idle、hit、miss、merge、结构反压和 flush 周期持续观察 immediate 输入；负向接口单元各注入一次 1 | 正式回归中三路 immediate 永远为 0；任一负向注入必须立即触发合同断言，不能作为功能 wake 使用 | `srcs/xx_lsu_top.sv:431-433`；条件关闭 RR-16 |
| V0-DCACHE-SPEC | 交叉 `pa_vld=0`、PF/AF、`CA=0` 与 tag/data hit/miss，并监测替换/训练/LQ/WB | 投机读不更新任何状态；无效 tag/data 不得进入 LQ、WB、异常之外的架构路径；D-cache select 同拍即 accept | `srcs/xx_lsu_ld_ag.sv:2549-2570`；已关闭 RR-11 合同回归 |
| V0-FAULT-BKCON | 请求遇到 D-cache backpressure；AF 仅在请求后一拍脉冲，PF 与 `pa_vld=1` 同拍；backpressure 覆盖 1/N 拍 | 合法响应不得漏异常或串事务；另以负向断言单元验证“同拍 AF”及 `PF && !pa_vld` 会被合同检查拒绝 | `srcs/xx_lsu_ld_ag.sv:1352-1378`；已关闭 RR-05/RR-07 |
| V0-ABORT-RESTART | A 因非 MMU 原因 abort 且被更老 RF B 覆盖；分别覆盖 fresh、已建项和 replay；再单独覆盖 accepted miss | MMU 未登记 A 时 controller 必须用正确 LRQ bit 立即解冻；MMU 已登记 miss 时不得立即解冻，只能等待 async wakeup | `srcs/xx_lsu_ld_ag.sv:2847-2855`、`srcs/xx_lsu_ctrl.sv:849-853`；RR-06 回归/RR-13 |
| V0-CREATE-FLUSH | LRQ create 与 full flush、partial flush 分别同拍 | 被 kill 时不得分配；raw pop 可以拉高，但上游必须由 flush 优先杀掉同一 LSIQ 项，且不得留下“仅 pop、未 flush”的存活事务 | `srcs/xx_lsu_lrq.sv:1448-1452`、`srcs/xx_lsu_lrq.sv:1692-1693`；已关闭 RR-08 合同回归 |
| V0-CREATE-FULL | 无 flush 下，每条 lane 独立覆盖 empty、one-left、reserved-threshold、full；再叠加三 lane 同拍 create/pop | `no_space` 必须阻止已满 lane 发射；每个 accepted create 的本 lane free pointer 为 one-hot，allocation/pop 对应同一事务；三 lane 之间不得串 entry | `srcs/xx_lsu_lrq.sv:1411-1470`、`srcs/xx_lsu_lrq.sv:1628-1683`；容量合同回归 |
| V0-WAKE-OWNERSHIP | 只使用 N 拍 async wake；覆盖 full/partial flush、partial-keep、LRQ bit 立即复用及负向旧 wake 注入 | 未 flush pending 最终只 wake 原事务一次；被 flush pending 在复用前取消且之后无 wake；负向旧 wake 必须触发合同断言 | `srcs/xx_lsu_ctrl.sv:949-988`、`srcs/xx_lsu_lrq_entry.sv:817-822`；合同关闭 RR-14 |
| V0-SPECIAL-CLK | 在 ICG on/off 与 scan 模式下检查永久 `pfu_part_empty=0` 配置 | `lsu_special_clk_en` 在支持配置下恒有效，所有消费者正常采样；只记录功耗，不再要求 idle 停钟 | `srcs/xx_lsu_ctrl.sv:539-563`、`srcs/xx_lsu_top.sv:3761`；已关闭 RR-15 |
| V0-PARAM | elaboration 正式固定组合，并分别尝试 `LRQENTRY!=LSIQENTRY`、`PC_LEN!=15`、`VMBENTRY!=8`、split width 非 9 | 支持组合无截断；每个不支持组合必须由静态检查明确失败，而不是静默 elaboration | 已关闭 RR-10/配置检查 |

## 4. MMU miss queue 与 replay 生命周期

### 4.1 基本矩阵

每一种请求来源都执行以下矩阵：

- 来源：`{fresh IDU, LRQ replay}`
- MMU：`{hit, miss accepted, page fault+pa_vld, next-cycle access fault}`
- D-cache：`{同拍接受, backpressure 1 拍, backpressure N 拍}`
- 更老 RF 请求：`{无, 有}`
- flush：`{无, full, partial-kill, partial-keep}`

检查点：

- hit 时 PA 必须等于 `{mmu_lsu_pa, VA[11:0]}`；
- miss 时不能产生架构副作用，且 LRQ ID 必须随请求被 MMU 接受；
- `mmu_lsu_stall` 在所有目标集成周期均为 0；
- fault 必须归属于原 IID/LRQ ID；
- replay 不得再次 create 新 LRQ entry：`srcs/xx_lsu_ld_ag.sv:3031-3033`；
- 当前集成的 LRQ PA cache 关闭，正常 replay 应重新访问 MMU：`srcs/xx_lsu_ld_ag.sv:2418-2428`、`srcs/xx_lsu_lrq_entry.sv:927-929`。

### 4.2 必须命中的端到端 sequence

1. `MMU miss -> LRQ frozen -> async wake -> replay -> DC accept -> complete/pop`。
2. `非 MMU stall/abort -> controller 本地 restart bitmap -> replay`，验证 abort-aware `lag_stall_ori_tlbmiss_not_abort`；该路径不是 MMU immediate wake。
3. `同 VA 两请求 -> MMU merge -> 多 bit wakeup -> 两事务各 replay 一次`。
4. `miss -> full/partial-kill flush -> MMU pending cancel -> 同一 LRQ bit 复用`，被 kill lsid 后续不得出现 async wake；另注入非法旧 wake 证明 assertion 能捕获。
5. `accepted miss + AG D-cache stall + 更老 RF 覆盖 -> 新建 entry 保持 frozen -> MMU wake -> 单次 replay`。
6. `非 miss AG stall + 更老 RF 覆盖 -> 新建/已有 entry 立即 ready -> 单次 replay`。
7. `vector/no-spec replay -> saved VA/byte mask -> DC/DA/WB`，`no_spec/element_cnt/rot_sel` 必须属于原事务且不含 X；FOF fault 的 VL/vstart 必须正确。

### 4.3 MMU 请求稳定性

正式 accept 条件为：

```text
mmu_accept = lsu_mmu_va_vld && !lsu_mmu_abort
```

在该合同下应检查：

- accept 拍的 `va/id/lsid/st_inst` 全部属于同一事务，且 miss queue 对同一 `{IID, lsid}` 不重复建项；
- accept 后，后续端口 abort 不得取消已接受项；
- 三路 `imme_wakeup` 在所有周期恒 0；任一 1 都是接口合同违例；
- accepted miss 必须满足新 `create_frz` 所有权方程，async wake 前不得成为 ready；
- async wakeup bitmap 只命中仍有效的 pending entry；flush-killed pending 在 bit 复用前取消，之后不得再产生 wake。

## 5. Stall、优先级与 flush

### 5.1 Stall 来源交叉

单独和两两组合注入：

- atomic-not-commit；
- fence/bar wait；
- no-spec wait；
- cross-page/boundary LDR；
- D-cache select/backconnect；
- unit-stride tag-request/tag-ack stall；
- MMU accepted miss；`mmu_lsu_stall` 只作为必须恒 0 的集成合同检查，不参与合法交叉。

核对三层语义：

- `ld_ag_stall_restart`：请求不能进入 DC；
- `lag_ex1_stall_ori`：AG 当前事务需要本地保持或转入可调度 LRQ；
- `ld_ag_stall_vld`：是否真的阻止 AG 寄存器被 RF 覆盖。

相关逻辑位于 `srcs/xx_lsu_ld_ag.sv:2710-2812`。重点覆盖：

- atomic/bar/no-spec 与 cross-page 同拍；
- MMU accepted miss 与 D-cache stall 同拍，并分别覆盖有/无更老 RF；
- `mmu_lsu_pa_vld=0 && !lsu_mmu_abort` 时检查“MMU ownership -> frozen -> async wake -> 单次 retry”；`lsu_mmu_abort=1` 时检查“controller ownership -> local restart -> 单次 retry”；
- 三路 MMU immediate 输入在 D-cache stall、hit/miss、flush 等全部交叉中始终为 0；
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

相关源码：`srcs/xx_lsu_ld_ag.sv:1257-1336`、`srcs/xx_lsu_ld_ag.sv:1505-1653`、`srcs/xx_lsu_ld_ag.sv:2723-2756`。

### 6.2 Boundary LDR

对 `inst_ldr=1` 覆盖：

- 跨/不跨 16-byte boundary；
- 跨/不跨 4 KiB；
- 第一半/第二半遇到 MMU miss、fault、D-cache stall、flush；
- create 后 replay。

每个事务必须恰好完成所需的两个半部，地址相差 16，mask、异常 VA 和最终写回归属一致。replay mux 允许 `inst_ldr=1'bx`（`srcs/xx_lsu_lrq.sv:1786`），因此验证目标不是强迫该死字段二态，而是证明 saved VA/boundary 被选择，且所有由 `inst_ldr` 控制的二次 stall 都被 `!lag_lrq_replay_vld` 屏蔽（`srcs/xx_lsu_ld_ag.sv:1449-1471`、`srcs/xx_lsu_ld_ag.sv:2745-2756`）。

## 7. 向量与 unit-stride

### 7.1 必测组合

- indexed/strided 与 unit-stride；
- mask 全 0、部分 1、全 1；
- `vmew/vlmul/vls_size/split_num/vstart` 边界值；
- `bytes_vld[0:3]` 和 `reg_bytes_vld[0:3]` 覆盖完整 64-byte 范围；
- FOF 首元素/非首元素异常；
- 每种组合各跑无 replay 和 1/N 次 replay。

检查：

- create 与 replay 的 saved VA、boundary、bytes mask、reg mask、VMB ID 完全一致；重新生成的 element count、rotation 与参考模型一致且不含 X；
- masked-off 元素不得产生异常或写回；
- FOF 非首元素按架构更新 VL，而不是普通 trap；
- replay 时即使 LRQ 的 `VL/vmask/source mask` 为 X，valid `element_cnt/rot_sel` 也不得为 X；若 helper 确实依赖这些字段，必须改为保存/恢复最终派生值；
- unit-stride tag request→way capture→data request 的三阶段不能跨事务串 way。

相关源码：`srcs/xx_lsu_ld_ag.sv:1692-1757`、`srcs/xx_lsu_ld_ag.sv:2115-2177`、`srcs/xx_lsu_ld_ag.sv:2190-2246`、`srcs/xx_lsu_ld_ag.sv:2392-2408`。

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

检查 `lag_ldc_ex1_expt_*`、DC 编码、DA 最终异常码、mtval/VA 和 IID 均唯一正确。AG 聚合位于 `srcs/xx_lsu_ld_ag.sv:2662-2704`，DA 还会单独采样 MMU access fault，因此必须验证 fault 信号与该事务的 DC/DA 时序对齐。

### 8.2 AMO/LR

覆盖：

- atomic 未 commit，随后 0/1/N 拍由 commit0..5 中正确 IID 放行；
- 错误 IID commit 不得改变 entry；
- AMO wait-old 与 cross-page、MMU accepted miss、bar/no-spec、flush 同拍；
- LR 和 LDAMO 分别交叉 aligned/misaligned、CA/non-CA、SO、PF、AF；
- commit 后仍遇到 D-cache backpressure。

每个 AMO/LR 事务只允许一次 local-monitor init 和一次架构终态。相关逻辑见 `srcs/xx_lsu_ld_ag.sv:2525-2543`、`srcs/xx_lsu_ld_ag.sv:2710-2712`、`srcs/xx_lsu_ld_ag.sv:2974-2990`。

### 8.3 投机 D-cache 读与 early wake

交叉 `pa_vld`、CA、SO、PF、AF、dcache enable、boundary acceleration。当前请求没有用 PA valid/CA/异常资格：`srcs/xx_lsu_ld_ag.sv:2549-2570`。必须证明在 `!pa_vld || !CA || fault` 时：

- 没有架构可见 cache side effect；
- 错误 tag hit 不会创建错误 LQ/完成；
- 不会使用错误数据提前回写；
- 任一 early wake 均有及时且同事务的 cancel/replay；
- `ld_ag_acclr_en` 的预资格与真正 `lag_ldc_ex1_acclr_en` 不一致时，后级分类仍正确，见 `srcs/xx_lsu_ld_ag.sv:2485-2499`、`srcs/xx_lsu_ld_ag.sv:2881-2909`。

## 9. 时钟门控与四态验证

### 9.1 接口关系

AG valid 用 `idu_lsu_rf_sel` 更新，而 payload 时钟由 `idu_lsu_rf_gateclk_sel` 打开：`srcs/xx_lsu_ld_ag.sv:1039-1045`、`srcs/xx_lsu_ld_ag.sv:1074-1087`。必须确认并断言至少满足：

```text
idu_lsu_rf_sel -> idu_lsu_rf_gateclk_sel
```

还要覆盖 reset、full/partial flush、local stall、cross-page 状态、LRQ replay 在 ICG on/off 和 scan enable 下的行为；清除状态不能依赖一个可能关闭的时钟。

`lsu_special_clk` 按正式配置不做 idle 门控。`lsu_special_clk_en` 包含 `!pfu_part_empty`，top 又永久把 `pfu_part_empty` 固定为 0，所以时钟恒开：`srcs/xx_lsu_ctrl.sv:539-563`、`srcs/xx_lsu_top.sv:3761`。验证目标改为证明 tie-off/时钟常开合同在 ICG on/off 与 scan 下成立，所有消费者都能采样；不再测试恢复真实 empty。controller 中重复 create0、遗漏 create1 等表达式仅列死代码/功耗清理，除非未来正式改变永久 tie-off 合同。

### 9.2 X-prop

开启 pessimistic X-prop，至少覆盖：

- 复位后首条请求；
- idle MMU 输出为 X；
- replay 的 `no_spec`、VL/vmask/source mask 为 X；
- `lag_ldc_ex1_bytes_vld1` selector 穷举 `{0,1,X}`，分别检查 8 个二值、16 个 default-X 和 3 个 wildcard-X 组合；
- helper 输入含 X 时检查 valid `element_cnt/rot_sel`，同时证明 saved VA/byte masks 不受影响。

所有 valid-qualified MMU、D-cache、DC、IDU、DTU payload 都应绑定 `$isunknown` 检查。

## 10. 建议断言模板

以下是意图模板；时钟域、层级名和 accept 定义应按完整工程调整。

```systemverilog
// 目标集成合同：该端口永久 tie 0
a_target_mmu_stall_tieoff:
assert property (@(posedge forever_cpuclk) disable iff (!cpurst_b)
  !mmu_lsu_stall);

// 正式 MMU accept 定义；miss queue scoreboard 应以该事件记账。
wire mmu_accept = lsu_mmu_va_vld && !lsu_mmu_abort;

// top 发给 MMU 的 lsid 必须与 accept 拍 AG 选择的 lsid 完全一致。
a_mmu_accept_lsid:
assert property (@(posedge forever_cpuclk) disable iff (!cpurst_b)
  mmu_accept |-> (lsu_mmu_lsid0 == lag_ldc_ex1_lsid));

// 永久放松钟控与固定参数合同。
a_pfu_part_empty_tieoff:
assert property (@(posedge forever_cpuclk) disable iff (!cpurst_b)
  !pfu_part_empty);

initial begin
  assert (LRQENTRY == LSIQENTRY);
  assert (PC_LEN == 15);
  assert (VMBENTRY == 8);
  assert (`SPILT_NUM_WIDTH == 9);
end

// 合法 page fault 必须与 pa_vld 同拍
a_page_fault_has_pa_valid:
assert property (@(posedge forever_cpuclk) disable iff (!cpurst_b)
  mmu_lsu_page_fault |-> mmu_lsu_pa_vld);

// AF 必须能归属到上一拍的有效、未 abort 请求；正式工程应换成精确 mmu_accept
a_access_fault_is_next_cycle_response:
assert property (@(posedge forever_cpuclk) disable iff (!cpurst_b)
  mmu_lsu_access_fault |-> $past(lsu_mmu_va_vld && !lsu_mmu_abort));

// valid 与 payload 门控时钟合同
a_rf_sel_has_data_clock:
assert property (@(posedge forever_cpuclk) disable iff (!cpurst_b)
  idu_lsu_rf_sel |-> idu_lsu_rf_gateclk_sel);

// fresh 的旧 predictor exist 输入在 LSU 内有意失效；内部状态另行检查。
a_fresh_no_spec_exist_repurposed:
assert property (@(posedge forever_cpuclk) disable iff (!cpurst_b)
  (lsu0_issue_sel_idu && lsu0_issue_permit_idu)
  |-> !lrq_lsu0_rf_no_spec_exist);

// replay 不得再次建立 entry
a_replay_no_recreate:
assert property (@(posedge forever_cpuclk) disable iff (!cpurst_b)
  (lag_ex1_inst_vld && lag_lrq_replay_vld)
  |-> !lsu_lrq_create_vld);

// RR-13：fresh 请求已由 MMU miss queue 持有时，新建 entry 必须 frozen；
// interaction 1.1.2 的新方程应通过该回归。
a_fresh_accepted_miss_stays_frozen:
assert property (@(posedge forever_cpuclk) disable iff (!cpurst_b)
  (lsu_lrq_create_vld
   && lag_ex1_stall_ori
   && ld_ag_stall_mask
   && lag_stall_ori_tlbmiss_not_abort)
  |-> lsu_lrq_create_frz);

// lane0 的完整所有权方程；lane2/3 应在完整 wrapper 层绑定同构断言。
a_create_frz_ownership_equation:
assert property (@(posedge forever_cpuclk) disable iff (!cpurst_b)
  lsu_lrq_create_vld
  |-> (lsu_lrq_create_frz
       == (!(lag_ex1_stall_ori && ld_ag_stall_mask)
           || (!mmu_lsu_pa_vld && !lsu_mmu_abort))));

// 每个未 flush 事务在同一拍最多只有一个恢复所有者。
// 四个状态应由 scoreboard 按 {IID,lrqid,flush_epoch} 生成。
a_single_recovery_owner:
assert property (@(posedge forever_cpuclk) disable iff (!cpurst_b)
  txn_live |-> $onehot({txn_mmu_pending,
                        txn_controller_pending,
                        txn_ag_local_hold,
                        txn_lrq_ready}));

// MMU pending 期间不得由 ready LRQ 再次发出同一事务。
a_no_replay_before_mmu_wakeup:
assert property (@(posedge forever_cpuclk) disable iff (!cpurst_b)
  txn_mmu_pending && !txn_mmu_wakeup
  |-> !txn_lrq_issue);

// RR-16 的 interaction 1.1.2 合同：三路 MMU immediate wake 永久 tie 0；
// 合法 MMU wake 只能由 async bitmap 进入 controller/LRQ。
a_mmu_immediate_wakeup_tieoff:
assert property (@(posedge forever_cpuclk) disable iff (!cpurst_b)
  !(mmu_lsu_imme_wakeup0
    || mmu_lsu_imme_wakeup2
    || mmu_lsu_imme_wakeup3));

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

// RR-08 的正式合同允许 flush 拍 raw pop 拉高，但上游 flush 必须优先杀掉源项。
// upstream_lsiq_entry_live 是验证环境按 pop_entry 跟踪的抽象状态。
a_flush_dominates_raw_pop:
assert property (@(posedge forever_cpuclk) disable iff (!cpurst_b)
  (lrq0_create_kill && lrq0_idu_ex3_pop_vld)
  |=> !upstream_lsiq_entry_live);

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
                   lag_ldc_ex1_no_spec, lag_ldc_ex1_element_cnt,
                   lag_ldc_ex1_rot_sel, lag_ldc_ex1_inst_type}));

// replay 已保存的事务字段必须全部确定；该断言应在当前 RTL 通过。
a_replay_saved_payload_known:
assert property (@(posedge forever_cpuclk) disable iff (!cpurst_b)
  (lag_ex1_inst_vld && lag_lrq_replay_vld)
  |-> !$isunknown({lag_lrq_va, lag_lrq_boundary,
                   lag_lrq_bytes_vld, lag_lrq_bytes_vld1,
                   lag_lrq_bytes_vld2, lag_lrq_bytes_vld3,
                   lag_lrq_reg_bytes_vld, lag_lrq_reg_bytes_vld1,
                   lag_lrq_reg_bytes_vld2, lag_lrq_reg_bytes_vld3}));

// RR-02：只有进入有效 DC 的 replay 才检查最终被消费的派生字段；
// 当前 no_spec 以及部分 vector replay 预计会暴露失败。
a_replay_consumed_metadata_known:
assert property (@(posedge forever_cpuclk) disable iff (!cpurst_b)
  (lag_ldc_ex1_inst_vld && lag_lrq_replay_vld)
  |-> !$isunknown({lag_ldc_ex1_no_spec,
                   lag_ldc_ex1_element_cnt,
                   lag_ldc_ex1_rot_sel}));

// RR-03：txn_saved_halt_info 由验证 scoreboard 在首次 create 时按事务保存。
a_replay_halt_info_matches_transaction:
assert property (@(posedge forever_cpuclk) disable iff (!cpurst_b)
  (lag_lrq_replay_vld && ld_rf_inst_vld && lsu_any_trig_en)
  |-> (idu_lsu_rf_halt_info == txn_saved_halt_info));

// RR-12 functional-ambiguity 版本：X 会令二值细化选择不同数据源时要求输出 X。
// X11 的两种细化都选 US，不属于 ambiguity；当前 RTL 仍会更悲观地输出 X。
wire bytes_vld1_select_ambiguous =
     ($isunknown(lag_lrq_replay_vld)
      && !((lag_ldc_ex1_inst_vls === 1'b1)
           && (lag_ldc_ex1_inst_us === 1'b1)))
  || ((lag_lrq_replay_vld === 1'b1)
      && $isunknown(lag_ldc_ex1_inst_us))
  || ((lag_lrq_replay_vld === 1'b0)
      && $isunknown(lag_ldc_ex1_inst_vls))
  || ((lag_lrq_replay_vld === 1'b0)
      && (lag_ldc_ex1_inst_vls === 1'b1)
      && $isunknown(lag_ldc_ex1_inst_us));

a_bytes_vld1_x_propagates:
assert property (@(posedge forever_cpuclk) disable iff (!cpurst_b)
  (lag_ex1_inst_vld && bytes_vld1_select_ambiguous)
  |-> $isunknown(lag_ldc_ex1_bytes_vld1));

// 若设计方确认 literal any-X 政策，应启用该更强断言；
// 当前 RTL 会在 selector=00X/1X0/1X1 时失败。
a_bytes_vld1_any_selector_x_propagates:
assert property (@(posedge forever_cpuclk) disable iff (!cpurst_b)
  (lag_ex1_inst_vld
   && $isunknown({lag_lrq_replay_vld,
                  lag_ldc_ex1_inst_vls,
                  lag_ldc_ex1_inst_us}))
  |-> $isunknown(lag_ldc_ex1_bytes_vld1));
```

RR-14 的外部 flush-cancel 合同不能只靠 LRQ bit 写出充分断言；验证环境仍应给每次 entry 分配递增 generation，并把 MMU pending/wakeup 记录到 scoreboard：

```systemverilog
// 伪代码：每个 wakeup 必须命中仍 pending 的同一 generation。
a_wakeup_matches_live_generation:
assert property (@(posedge forever_cpuclk) disable iff (!cpurst_b)
  mmu_wakeup_seen
  |-> (wakeup_pending
       && wakeup_generation == lrq_entry_generation
       && wakeup_flush_epoch == current_flush_epoch));

// full/partial flush 删除的 MMU pending 不得产生任何后续 async wake；
// generation_was_flushed() 查询 MMU/LRQ 联合 scoreboard 的历史集合。
a_flushed_mmu_pending_never_wakes:
assert property (@(posedge forever_cpuclk) disable iff (!cpurst_b)
  mmu_async_wakeup_seen
  |-> !generation_was_flushed(wakeup_generation));

// create 与 MMU wakeup 不同拍；mmu_wakeup_for_entry 在目标配置中仅包含
// 该 entry 的 async 位，不含 controller 本地 restart。
a_no_same_cycle_create_mmu_wakeup:
assert property (@(posedge forever_cpuclk) disable iff (!cpurst_b)
  !(lrq_entry_create_vld && mmu_wakeup_for_entry));
```

## 11. 功能覆盖

### 11.1 必做交叉

- 请求来源 `{IDU, LRQ replay}` × MMU `{hit, accepted miss, PF+pa_vld, next-cycle AF}`。
- replay reason `{TLB miss, D-cache conflict, LQ/RB full, wait-old, fence, no-spec, cross-page}` × 指令类。
- 指令类 `{scalar, boundary LDR, vector non-US, vector US, LR, LDAMO}` × page attr `{CA, non-CA, SO}`。
- 地址 `{aligned, 16B boundary, 4KiB 正向跨页, 4KiB 负向跨页}` × split/secd。
- stall 来源 × `{无更老 RF, 有更老 RF}`。
- flush 点 × `{full, partial-kill, partial-keep}`。
- LRQ occupancy `{empty, one-left, reserved threshold, full}` × `{单 lane create, 三 lane 同拍 create, 同拍 pop}`。
- no-spec `{00,01,10,11}` × 旧 predictor exist `{0,1}` × 内部 wait exist `{0,1}` × `{fresh,replay}` × lane `{0,2,3}`。
- MMU response `{hit/PF 同拍, AF 下一拍, miss N 拍 wake}` × backpressure `{0,1,N}`。
- wakeup `{controller 本地 restart, MMU async one-bit, MMU async multi-bit}` × 合法 async latency `{1,N}` × create/flush/reuse；三路 MMU immediate 只做恒 0 负向合同检查。
- async wake `{0,1}` × D-cache 结构反压 `{0,1}` × 更老 RF `{0,1}` × flush `{none,full,partial-kill,partial-keep}`；被 kill generation 的后续 wake 命中数必须为 0。
- MMU ownership `{none,pending}` × 更老 RF `{0,1}` × LRQ create freeze `{0,1}`，非法的 `pending && ready` 必须 0 hit。
- special clock consumer × 固定 `PFU empty=0` × `{ICG on/off, scan on/off}`。
- `bytes_vld1` selector `{8 个二值,16 个 default-X,3 个 wildcard-X}` × 输出 `{确定值,X,保留旧值}`；保留旧值必须 0，3 个 wildcard-X 的期望由正式政策决定。

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

1. RR-16 的关闭合同已固化：三路 `mmu_lsu_imme_wakeup` 永远为 0，所有合法 MMU 唤醒只走 async bitmap；死的 DC immediate 路径不得被误用。
2. RR-13 新方程在 lane0 及完整工程的 lane2/lane3 均通过所有权断言和 16 行二态穷举，MMU pending 与 LRQ ready 永远互斥。
3. RR-14 的 full/partial-flush 删除 pending 合同已固化；被 flush 的 generation 不得留下 async wake，create 与 MMU wake 不同拍的合同有断言保护。
4. RR-02/RR-03 的剩余 replay metadata（`no_spec`、必要的 `element_cnt/rot_sel`、`halt_info`）已补齐；saved VA/byte masks 与 RR-12 的 27 组定向测试全部通过，且 RR-12 的 any-X/functional-ambiguity 政策已有书面结论。
5. MMU 的 accept、不可追溯 abort、response、async-only wakeup 与 flush-cancel 合同形成书面说明并有断言保护；`mmu_lsu_stall==0` 在集成层已证明。
6. 已关闭合同均通过回归：flush 优先 raw pop、D-cache 投机读无副作用、旧 predictor `no_spec_exist` 不可观察、共享 SQ-not-full 语义正确。
7. `pfu_part_empty=0` 和固定参数组合由静态检查固化；不支持配置明确 elaboration 失败。
8. scalar、LDR、vector、AMO/LR 的 hit/miss/fault/replay 端到端 scoreboard 全部通过。
9. 支持配置完成 compile/elaboration、lint、CDC/clock-gating 检查和 X-prop；assertion 0 failure，功能覆盖目标全部达到。

## 13. 需要设计方在执行回归前确认的问题

1. RR-02：2-bit `no_spec` 应直接作为 LRQ payload 保存，还是可由已保存状态无损重建？请给出 DA 分类/预测反馈的正式等价关系。
2. RR-02：vector replay 的 `element_cnt/rot_sel` 是否能由 helper 对现有 saved 字段唯一重建？若能，请补 helper 源码和断言；若不能，请把最终派生值纳入 LRQ payload。
3. RR-03：`halt_info` 计划保存在哪一级，partial/full flush 与 replay 时如何保证按原事务恢复？
4. RR-13：未提供的 lane2/lane3 AG/DC wrapper 是否使用与 lane0 完全相同的 `create_frz` 所有权方程？
5. RR-12：正式 X-prop 政策是 functional ambiguity 还是 literal any-X？若为后者，`00X/1X0/1X1` 准备如何处理？
6. RR-14/RR-16：请在 MMU 集成层提供三路 immediate tie-off、full/partial-flush 精确删除 pending、flush 优先 async wake 与 bit 复用的可绑定断言。
