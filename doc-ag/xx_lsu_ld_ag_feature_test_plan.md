# `xx_lsu_ld_ag` 详细功能点与 Test Plan

## 1. 使用方法与时序约定

本计划把 `AG-FP-01`～`AG-FP-12` 展开为 96 个可直接落入现有 VCS
testcase task 的场景。机器可读源为
`verif/xx_lsu_ld_ag/detailed_test_plan.csv`，本文给工程师提供逐拍驱动、
触发条件、预期输出、checker、coverage 和关闭标准。

- `C0`：在时钟负沿后驱动输入，保证下一个正沿满足setup。
- `C1/C2/C3`：对应后续正沿后 `#1` 采样；连续stall场景每拍都检查owner。
- “当”列只写触发合同；“则”列写可直接转成 `expect_true` 或SVA的结果。
- `drive_signals` 和 `expected_signals` 必须使用RTL/接口原名，不能用自然语言别名。
- 96表示**详细计划场景数**，不是96个场景已经在本机VCS动态执行；现有12个
  testcase是实现落点，动态结果仍受 `BLOCKED_NO_VCS` 和
  `PENDING_FULL_CHIP` 边界约束。

## 2. 功能级追踪入口

以下五列摘要保留interaction 1.7约定的文档schema；后续逐场景表进一步给出
可直接编码的信号与周期条件。

| 二级功能点 | 三级功能点 | 功能点描述 | 测试方法和配置说明 | 优先级 |
|---|---|---|---|---|
| 流水级控制 | RF请求锁存 | fresh/replay复用AG，flush与stall决定owner保持；见 `srcs/xx_lsu_ld_ag.sv:1074` | 执行AG-FP-01-S01～S08，逐拍检查IID、payload、stall和flush优先级 | P0 |
| 地址生成 | 标量VA与跨页 | base、offset、shift、size生成VA、mask和4KiB crossing；见 `srcs/xx_lsu_ld_ag.sv:1257` | 执行AG-FP-02-S01～S08，遍历size/低位并检查正负跨页 | P0 |
| MMU接口 | hit/miss/abort | MMU返回PA、miss或fault时转移AG owner；见 `srcs/xx_lsu_ld_ag.sv:2415` | 执行AG-FP-03-S01～S08，分别配置同拍hit、miss、PF和下一拍AF | P0 |
| MMU异常 | PF/AF保存 | backpressure期间保存page fault和下一拍access fault；见 `srcs/xx_lsu_ld_ag.sv:1354` | 执行AG-FP-04-S01～S08，覆盖1/N拍保存和新owner清除 | P0 |
| Stall/Restart | backconnect恢复 | 结构stall、TLB miss和fault选择hold、restart或abort；见 `srcs/xx_lsu_ld_ag.sv:2762` | 执行AG-FP-05-S01～S08，检查fresh/replay owner与restart bitmap | P0 |
| D-cache请求 | tag/data bank | cache属性与PA低位控制tag、16路data request和bank index；见 `srcs/xx_lsu_ld_ag.sv:2574` | 执行AG-FP-06-S01～S08，覆盖四bank、disabled、NC/SO与borrow | P1 |
| Unit-stride | 两拍way获取 | 512-bit unit-stride先读tag再保存命中way访问data；见 `srcs/xx_lsu_ld_ag.sv:1391` | 执行AG-FP-07-S01～S08，覆盖one-hot way、两相位、模式切换与跨line | P0 |
| 异常判定 | 对齐与属性 | misalign、PF、AF和LDAMO非CA形成不同异常编码；见 `srcs/xx_lsu_ld_ag.sv:2662` | 执行AG-FP-08-S01～S08，逐项检查子类、aggregate和DC屏蔽 | P0 |
| LRQ协同 | 创建与freeze | fresh创建LRQ，replay不重复创建，flush取消迟到create；见 `srcs/xx_lsu_ld_ag.sv:3031` | 执行AG-FP-09-S01～S08，检查create唯一性、freeze和owner IID | P0 |
| TCM/Atomic | 特殊访问 | TCM来源及atomic commit改变请求与monitor初始化；见 `srcs/xx_lsu_ld_ag.sv:2935` | 执行AG-FP-10-S01～S08，并在full-chip替换生产TCM逻辑重跑 | P1 |
| 向量访问 | split与byte mask | vmew、split、vl和vmask生成四组byte/reg-byte mask；见 `srcs/xx_lsu_ld_ag.sv:1692` | 执行AG-FP-11-S01～S08，按vmew=0..3逐bit对比生产helper | P1 |
| Flush/Clock | 清除与门控 | full/check flush清owner，ICG与scan控制状态捕获；见 `srcs/xx_lsu_ld_ag.sv:1074` | 执行AG-FP-12-S01～S08，覆盖full/selective flush、scan和迟到fault | P0 |

|ID | 二级/三级功能点 | Testcase | Checker / Coverage | 优先级 |
|---|---|---|---|---|
|AG-FP-01 | 流水控制 / fresh与replay owner | `tc_rf_capture_replay` | `CHK_FP01_OWNER_STABLE` / `COV_FP01_OWNER` | P0 |
|AG-FP-02 | 地址生成 / VA、mask与跨页 | `tc_scalar_va_cross_page` | `CHK_FP02_ADDR_MASK` / `COV_FP02_ADDR_SIZE` | P0 |
|AG-FP-03 | MMU接口 / hit、miss与abort | `tc_mmu_hit_miss_abort` | `CHK_FP03_MMU_OWNER` / `COV_FP03_MMU_RESULT` | P0 |
|AG-FP-04 | MMU异常 / PF与AF保存 | `tc_mmu_fault_persistence` | `CHK_FP04_FAULT_TRANSFER` / `COV_FP04_FAULT_DELAY` | P0 |
|AG-FP-05 | Stall/Restart / owner恢复 | `tc_stall_restart_owner` | `CHK_FP05_RESTART_OWNER` / `COV_FP05_STALL_REASON` | P0 |
|AG-FP-06 | D-cache / tag、data与bank | `tc_dcache_bank_requests` | `CHK_FP06_DC_REQ_VALID` / `COV_FP06_BANK_INDEX` | P1 |
|AG-FP-07 | Unit-stride / tag与way两相位 | `tc_unit_stride_two_phase` | `CHK_FP07_US_SEQUENCE` / `COV_FP07_US_WAY` | P0 |
|AG-FP-08 | 异常判定 / 对齐与页面属性 | `tc_exception_priority` | `CHK_FP08_EXCEPTION_AGGREGATES` / `COV_FP08_EXCEPTION_KIND` | P0 |
|AG-FP-09 | LRQ协同 / create与freeze | `tc_lrq_create_freeze` | `CHK_FP09_LRQ_OWNER` / `COV_FP09_LRQ_STATE` | P0 |
|AG-FP-10 | TCM/Atomic / commit合同 | `tc_tcm_atomic_commit` | `CHK_FP10_ATOMIC_COMMIT` / `COV_FP10_SPECIAL_SOURCE` | P1 |
|AG-FP-11 | Vector / split与mask | `tc_vector_masks` | `CHK_FP11_VECTOR_KNOWN` / `COV_FP11_VECTOR_MODE` | P1 |
|AG-FP-12 | Flush/Clock / 清除与门控 | `tc_flush_clock_gating` | `CHK_FP12_FLUSH_CLEARS` / `COV_FP12_FLUSH_POINT` | P0 |

## 3. 逐场景测试计划

### AG-FP-01：fresh/replay owner与流水锁存

|场景 | 前置、逐拍驱动 | 当 | 则 | 检查与关闭 |
|---|---|---|---|---|
|`AG-FP-01-S01` | 复位释放无反压；C0驱动fresh IID=0x11；C1采样 | 当 `idu_lsu_rf_gateclk_sel=1`、`idu_lsu_rf_sel=1` 且 `rtu_lsu_flush_fe=0` 时 | 则 C1 `lag_ex1_inst_vld=1` 且 `lag0_ex1_iid=idu_lsu_rf_iid` | `CHK_FP01_OWNER_STABLE`；IID必须为0x11 |
|`AG-FP-01-S02` | 已有IID 0x11；C0置bkcon=1并驱动新IID 0x22；C1/C2采样 | 当 `lag_ex1_inst_vld=1` 且 `dcache_arb_lag_ex1_bkcon=1` 时又出现 `idu_lsu_rf_sel=1` 的新请求 | 则 C1至C2 `lag_ex1_stall_ori=1` 且 `lag0_ex1_iid` 保持原owner 0x11 | 连续N拍owner/payload稳定，解除后仅转移一次 |
|`AG-FP-01-S03` | scoreboard保存replay halt_info=0x12A5；C0驱动冲突IDU值0x0555；C1采样 | 当 `lrq_lsu_rf_replay_vld=1` 且当前 `idu_lsu_rf_halt_info` 与scoreboard保存的replay值不同时 | 则 C1 `ld_ag_halt_info` 应等于replay owner参考值，若等于当前IDU值则记录已知设计错误 | 当前RTL错误必须输出 `KNOWN_DESIGN_ERROR`，不能误报通过 |
|`AG-FP-01-S04` | C0同拍驱动full flush和fresh IID；C1/C2采样 | 当 `rtu_lsu_flush_fe=1` 与 `idu_lsu_rf_sel=1` 同拍成立时 | 则 C1 `lag_ex1_inst_vld=0`，且C2不得迟到捕获被flush的 `idu_lsu_rf_iid` | flush优先于capture，无迟到owner副作用 |

### AG-FP-02：标量VA、byte mask与4 KiB crossing

|场景 | 前置、逐拍驱动 | 当 | 则 | 检查与关闭 |
|---|---|---|---|---|
|`AG-FP-02-S01` | MMU命中；C0遍历size=0..3、低4位=0..15和offset=3；C1采样 | 当 `idu_lsu_rf_off_zext=1` 且 `idu_lsu_rf_inst_size`、`idu_lsu_rf_src0[3:0]` 遍历合法组合时 | 则 C1 `ld_ag_va=idu_lsu_rf_src0+idu_lsu_rf_offset` 且 `lag_ldc_ex1_bytes_vld` 等于按size左移的16位参考mask | 64组组合逐bit匹配独立模型 |
|`AG-FP-02-S02` | base=0x30001000；C0驱动offset=0xFFC、shift=k；C1采样 | 当 `idu_lsu_rf_off_zext=0`、`idu_lsu_rf_offset=12'hFFC` 且 `idu_lsu_rf_shift=k` 时 | 则 C1 `ld_ag_va=idu_lsu_rf_src0-(64'd4<<k)`，高位必须按符号扩展 | k=0..3均匹配手算期望 |
|`AG-FP-02-S03` | base页内0xFFE、offset=4、size=word；C1采样 | 当地址加法使 `idu_lsu_rf_src0[11:0]+idu_lsu_rf_offset` 产生第12位进位时 | 则 C1 `ld_ag_cross_4k=1` 且有效owner计入 `lsu_hpcp_ld_stall_cross_4k` | 向前跨页进入跨页restart路径 |
|`AG-FP-02-S04` | base页内0x002、offset=-4；C1采样 | 当 `idu_lsu_rf_off_zext=0` 且负offset使地址从当前页下溢到前一页时 | 则 C1 `ld_ag_va=idu_lsu_rf_src0-4` 且 `ld_ag_cross_4k=1` | 前一页下溢与正向进位同等覆盖 |

### AG-FP-03：MMU hit、miss、fault与owner转移

|场景 | 前置、逐拍驱动 | 当 | 则 | 检查与关闭 |
|---|---|---|---|---|
|`AG-FP-03-S01` | C0发请求并置pa_vld=1、fault=0；C1采样 | 当 `lsu_mmu_va_vld=1`、`mmu_lsu_pa_vld=1` 且page/access fault均为0时 | 则 C1 `lag_ldc_ex1_utlb_miss=0`、`lsu_mmu_abort=0` 且 `lag_ex1_pa` 使用MMU页号和VA页内偏移 | PA和owner只转移一次 |
|`AG-FP-03-S02` | C0置pa_vld=0、bkcon=1；C1采样miss；C2采样restart后DC valid | 当 `lag_bkcon_stall_vld=1` 且 `mmu_lsu_pa_vld=0` 时 | 则 C1 `lag_ldc_ex1_utlb_miss=1`，C2 `lag_ldc_ex1_inst_vld=0` 并转等待异步owner唤醒 | stall中miss无效PA不得进入DC |
|`AG-FP-03-S03` | C0置pa_vld=1、page_fault=1且无反压；C1采样 | 当 `mmu_lsu_pa_vld=1` 且 `mmu_lsu_page_fault=1` 命中有效AG owner时 | 则 C1 `lag_ldc_ex1_expt_page_fault=1` 且 `lag_ldc_ex1_expt_vld=1`，异常随当前owner进入DC | speculative cache读不得产生架构副作用 |
|`AG-FP-03-S04` | C0建立MMU请求和stall；C1脉冲access fault；C2采样 | 当有效MMU访问的下一拍 `mmu_lsu_access_fault=1` 且原owner仍被AG保存时 | 则 C2 `lag_ldc_ex1_expt_vld=1` 且 `lsu_mmu_abort=1`，异常归属于原IID | 延迟fault不串到后续owner |

### AG-FP-04：stall期间PF/AF保存

|场景 | 前置、逐拍驱动 | 当 | 则 | 检查与关闭 |
|---|---|---|---|---|
|`AG-FP-04-S01` | C0建立bkcon stall；C1单拍PF；C2撤销并采样 | 当 `lag_ex1_stall_ori=1` 时 `mmu_lsu_page_fault=1` 与 `mmu_lsu_pa_vld=1` 仅同拍出现一次 | 则 C2 `lag_bkcon_pgfault=1` 且 `lag_ldc_ex1_expt_page_fault=1`，即使输入fault已撤销 | PF跨1拍反压保持 |
|`AG-FP-04-S02` | PF被捕获后bkcon随机保持2..8拍，每拍采样 | 当page fault被 `lag_bkcon_stall_vld` 捕获后 `dcache_arb_lag_ex1_bkcon` 连续保持N拍时 | 则 C2至解除stall前 `lag_bkcon_pgfault=1` 且 `lag0_ex1_iid` 始终不变 | N=2..8无fault丢失或owner漂移 |
|`AG-FP-04-S03` | C0建立请求；C1返回AF；C2清AF；C3采样 | 当 `lag_bkcon_stall_already=1` 且下一拍 `mmu_lsu_access_fault=1` 时 | 则 C2至stall解除前 `lag_bkcon_acfault=1` 且 `lag_ldc_ex1_expt_vld=1` | AF不依赖输入持续拉高 |
|`AG-FP-04-S04` | 先完成旧fault事务；C1驱动无fault fresh；C2采样 | 当 `ld_ag_stall_vld=0` 且新的 `idu_lsu_rf_gateclk_sel=1` 请求进入时 | 则 C2 `lag_bkcon_pgfault=0`、`lag_bkcon_acfault=0`，旧fault不得污染新owner | 事务边界清状态，无幽灵异常 |

### AG-FP-05：stall/restart仲裁

|场景 | 前置、逐拍驱动 | 当 | 则 | 检查与关闭 |
|---|---|---|---|---|
|`AG-FP-05-S01` | fresh owner；C0置D-cache sel=0；C1/C2采样 | 当 `lag_ex1_inst_vld=1` 且 `dcache_arb_lag_ex1_sel=0` 时 | 则 C1 `lag_ex1_stall_ori=1` 且fresh owner只以当前IID产生一次 `lsu_lrq_create_vld` | stall owner稳定且create不重复 |
|`AG-FP-05-S02` | LRQ replay携带entry bit；C0置D-cache sel=0；C1采样 | 当 `lrq_lsu_rf_replay_vld=1` 且 `dcache_arb_lag_ex1_sel=0` 时 | 则 C1 `lag_ex1_stall_ori=1`，需要restart时 `lag_ex1_stall_restart_entry` 只指向该replay entry | replay不新建LRQ且bitmap不串项 |
|`AG-FP-05-S03` | AG先stall；C1置pa_vld=0；C2采样 | 当 `lag_bkcon_stall_vld=1` 后检测到 `mmu_lsu_pa_vld=0` 时 | 则 C2 `lag_ex1_stall_ori=0`、`ld_ag_stall_restart=1` 且 `lag_ldc_ex1_utlb_miss=1` | TLB miss转唯一restart路径 |
|`AG-FP-05-S04` | AG先stall；C1注入PF或延迟AF；C2采样 | 当stall owner的 `lag_bkcon_pgfault=1` 或 `lag_bkcon_acfault=1` 时 | 则 C2 `lsu_mmu_abort=1`、`lag_ldc_ex1_expt_vld=1` 且不得作为正常load进入DC | fault只传递一次异常owner |

### AG-FP-06：D-cache tag/data/bank请求

|场景 | 前置、逐拍驱动 | 当 | 则 | 检查与关闭 |
|---|---|---|---|---|
|`AG-FP-06-S01` | D-cache开且CA；C0遍历PA[7:6]；C1采样 | 当 `cp0_lsu_dcache_en=1`、`mmu_lsu_ca=1` 且有效load进入AG时 | 则 C1 tag request有效、data request非零且 `lag_dcache_arb_ex1_bank_idx=lag_ex1_pa[7:6]` | 四个bank全部覆盖 |
|`AG-FP-06-S02` | C0置dcache_en=0并发load；C1采样 | 当 `cp0_lsu_dcache_en=0` 且普通load有效时 | 则 C1 `lag_dcache_arb_ex1_ld_tag_req=0` 且 `lag_dcache_arb_ex1_data_req=16'h0000` | cache关闭周期无阵列访问 |
|`AG-FP-06-S03` | D-cache开；分别配置CA=0或SO=1；C1采样属性和speculative request | 当 `mmu_lsu_pa_vld=1` 且 `mmu_lsu_ca=0` 或 `mmu_lsu_so=1` 时 | 则 C1 当CA=0时 `lag_ldc_ex1_page_ca=0`，当SO=1时 `lag_ldc_ex1_page_so=1`；AG允许的speculative cache request不得被后级架构性消费 | full-chip检查无写回或架构副作用 |
|`AG-FP-06-S04` | 先建立owner；C1施加borrow和bkcon；C2采样 | 当 `dcache_arb_lag_ex1_borrow_addr_vld=1` 且 `dcache_arb_lag_ex1_bkcon=1` 时 | 则 C2 `lag_ldc_ex1_addr0` 选择borrow地址且stall期间 `lag0_ex1_iid` 保持不变 | borrow只改变地址选择，不重复消费owner |

### AG-FP-07：512-bit unit-stride两相位

|场景 | 前置、逐拍驱动 | 当 | 则 | 检查与关闭 |
|---|---|---|---|---|
|`AG-FP-07-S01` | 依次强制四种one-hot way；C1 tag；C2保存；C3采样 | 当 `lag_ldc_ex1_inst_vls=1`、`ld_ag_unit_stride=1` 且 `lag_us_tag_hit_way` 为one-hot时 | 则 C2 `lag_ex1_us_way=lag_us_tag_hit_way` 且C3 `lag_ldc_ex1_us_way` 保持同一路 | 四路均无X/multi-hot |
|`AG-FP-07-S02` | 无额外stall；C0发请求；C1/C2/C3依次采样 | 当有效unit-stride请求首次进入AG且 `lag_us_tag_req_success=0` 时 | 则 C1 `lag_us_tag_req_stall=1`，C2保存命中路，C3才允许data request有效 | tag/data相位各一次且顺序固定 |
|`AG-FP-07-S03` | 完成way=1000后C1紧发标量；C2采样 | 当 `idu_lsu_rf_inst_vls=0` 的标量请求紧随unit-stride owner进入时 | 则 C2 `lag_ldc_ex1_inst_us=0` 且data index按标量PA计算，不继承旧unit-stride way | 模式切换无旧状态泄漏 |
|`AG-FP-07-S04` | 强制起始PA低6位0x3F、way=0001；C1组合采样 | 当 `lag_ldc_ex1_inst_vls=1`、`ld_ag_unit_stride=1` 且 `lag_ex1_pa[5:0]=6'h3F` 时 | 则 `lag_dcache_arb_ex1_data_0_idx` 至 `lag_dcache_arb_ex1_data_3_idx` 不应全部指向同一64-byte line；若完全相等则记录已知跨line设计错误 | 按producer拆分合同或RTL修复关闭当前finding |

### AG-FP-08：异常子类与属性编码

|场景 | 前置、逐拍驱动 | 当 | 则 | 检查与关闭 |
|---|---|---|---|---|
|`AG-FP-08-S01` | atomic doubleword奇地址；C1采样 | 当 `lag_ldc_ex1_atomic=1` 且 `ld_ag_unalign=1` 时 | 则 C1 misalign与aggregate valid均为1且 `lag_ldc_ex1_inst_vld=0` | misalign不逃逸到正常DC |
|`AG-FP-08-S02` | 自然对齐；C0置page fault；C1采样 | 当 `mmu_lsu_pa_vld=1`、`mmu_lsu_page_fault=1` 且无misalign时 | 则 C1 `lag_ldc_ex1_expt_page_fault=1` 且 `lag_ldc_ex1_expt_vld=1` | PF绑定当前owner |
|`AG-FP-08-S03` | C0建立stall；C1返回AF；C2采样 | 当 `lag_bkcon_stall_already=1` 且 `mmu_lsu_access_fault=1` 时 | 则 C2 `lag_bkcon_acfault=1` 并使 `lag_ldc_ex1_expt_vld=1` | 延迟AF进入aggregate |
|`AG-FP-08-S04` | atomic已commit且CA=0；C2采样 | 当 `lag_ldc_ex1_atomic=1`、`mmu_lsu_pa_vld=1` 且 `mmu_lsu_ca=0` 时 | 则 C2 `lag_ldc_ex1_expt_ldamo_not_ca=1` 且该编码只能在atomic owner上出现 | 不误要求专用编码单独拉高aggregate valid |

### AG-FP-09：LRQ create/freeze/flush

|场景 | 前置、逐拍驱动 | 当 | 则 | 检查与关闭 |
|---|---|---|---|---|
|`AG-FP-09-S01` | fresh、MMU miss、D-cache拒绝；C1采样 | 当fresh `lag_ex1_inst_vld=1`、`lag_lrq_replay_vld=0` 且MMU未返回PA时 | 则 C1 `lsu_lrq_create_vld=1`、`lsu_lrq_create_frz=1` 且create IID等于AG owner IID | accepted miss创建一次冻结entry |
|`AG-FP-09-S02` | fresh、MMU hit、结构stall且older_vld=1；C1/C2采样 | 当fresh owner发生结构stall、`idu_lsu_rf_older_vld=1` 且 `mmu_lsu_pa_vld=1` 时 | 则 C1 `lsu_lrq_create_vld=1`、`lsu_lrq_create_frz=0` 且IID匹配，C2不得重复create | 已接受PA的entry创建为ready且脉冲唯一 |
|`AG-FP-09-S03` | 已有entry从replay端口进入；C1/C2采样 | 当 `lrq_lsu_rf_replay_vld=1` 且replay owner有效时 | 则 C1至C2 `lsu_lrq_create_vld=0`，已有entry不得被重复分配 | replay路径零create脉冲 |
|`AG-FP-09-S04` | fresh待create；C1发full flush；C2采样 | 当 `rtu_lsu_flush_fe=1` 命中尚未完成的fresh AG owner时 | 则 C2 `lag_ex1_inst_vld=0` 且 `lsu_lrq_create_vld=0`，不得迟到创建已flush IID | flush后无LRQ泄漏或幽灵create |

### AG-FP-10：TCM边界与atomic commit

|场景 | 前置、逐拍驱动 | 当 | 则 | 检查与关闭 |
|---|---|---|---|---|
|`AG-FP-10-S01` | standalone helper环境发普通load；C1采样 | 当 `idu_lsu_rf_sel=1` 且standalone环境未提供生产TCM命中源时 | 则 C1 `lag_ldc_ex1_dtcm_hit=0` 且 `lag_ldc_ex1_itcm_hit=0`，该结果仅证明tie-off边界 | 必须在full-chip替换生产TCM后重跑 |
|`AG-FP-10-S02` | atomic IID=0x75且commit全0；C1采样monitor与restart | 当 `lag_ldc_ex1_atomic=1` 且所有匹配commit信号为0时 | 则 C1 `lag_lm_ex1_init_vld=0` 且 `ld_ag_stall_restart=1`，atomic owner等待matching commit | 未提交不得提前初始化monitor |
|`AG-FP-10-S03` | atomic等待；C1驱动matching commit；C2采样 | 当 `rtu_yy_xx_commit0=1` 且 `rtu_yy_xx_commit0_iid=lag0_ex1_iid` 时 | 则 C2 `lag_lm_ex1_init_vld=1` 且有效owner保持atomic属性 | matching commit只初始化一次 |
|`AG-FP-10-S04` | atomic等待；C1驱动不同IID commit；C2采样 | 当 `rtu_yy_xx_commit0=1` 但 `rtu_yy_xx_commit0_iid!=lag0_ex1_iid` 时 | 则 C2 `lag_lm_ex1_init_vld=0` 且等待中的atomic owner IID不变 | 其他事务commit不得唤醒当前owner |

### AG-FP-11：vector split与mask

|场景 | 前置、逐拍驱动 | 当 | 则 | 检查与关闭 |
|---|---|---|---|---|
|`AG-FP-11-S01` | unit-stride、split=1、vmew=0、mask全1；C1采样 | 当 `idu_lsu_rf_inst_vls=1`、`idu_lsu_rf_unit_stride=1`、`idu_lsu_rf_split=1` 且 `idu_lsu_rf_vmew=0` 时 | 则 C1 `lag_ldc_ex1_bytes_vld`、`lag_ldc_ex1_bytes_vld1` 和 `lag_ldc_ex1_reg_bytes_vld` 均为二态并符合vmew0 helper参考模型 | 生产helper逐bit重跑后关闭 |
|`AG-FP-11-S02` | unit-stride、split=1、vmew=1、mask全1；C1采样 | 当 `idu_lsu_rf_inst_vls=1`、`idu_lsu_rf_unit_stride=1`、`idu_lsu_rf_split=1` 且 `idu_lsu_rf_vmew=1` 时 | 则 C1 `lag_ldc_ex1_bytes_vld`、`lag_ldc_ex1_bytes_vld1` 和 `lag_ldc_ex1_reg_bytes_vld` 均为二态并符合vmew1 helper参考模型 | 覆盖边界位与split轮转 |
|`AG-FP-11-S03` | unit-stride、split=1、vmew=2、mask全1；C1采样 | 当 `idu_lsu_rf_inst_vls=1`、`idu_lsu_rf_unit_stride=1`、`idu_lsu_rf_split=1` 且 `idu_lsu_rf_vmew=2` 时 | 则 C1 `lag_ldc_ex1_bytes_vld`、`lag_ldc_ex1_bytes_vld2` 和 `lag_ldc_ex1_reg_bytes_vld` 均为二态并符合vmew2 helper参考模型 | 覆盖多组mask和element边界 |
|`AG-FP-11-S04` | unit-stride、split=1、vmew=3、mask全1；C1采样 | 当 `idu_lsu_rf_inst_vls=1`、`idu_lsu_rf_unit_stride=1`、`idu_lsu_rf_split=1` 且 `idu_lsu_rf_vmew=3` 时 | 则 C1 `lag_ldc_ex1_bytes_vld`、`lag_ldc_ex1_bytes_vld3` 和 `lag_ldc_ex1_reg_bytes_vld3` 均为二态并符合vmew3 helper参考模型 | 覆盖最高mask组且无X传播 |

### AG-FP-12：flush与clock gating

|场景 | 前置、逐拍驱动 | 当 | 则 | 检查与关闭 |
|---|---|---|---|---|
|`AG-FP-12-S01` | AG已有stall owner；C1发full flush并采样abort；C2撤销后采样owner | 当 `lag_ex1_inst_vld=1` 且 `rtu_lsu_flush_fe=1` 时 | 则 C1 `lsu_mmu_abort=1`，C2 `lag_ex1_inst_vld=0` 且 `lsu_lrq_create_vld=0` | full flush无LRQ/MMU迟到副作用 |
|`AG-FP-12-S02` | 配置ck_flush IID更老；C1驱动并采样abort；C2撤销后采样owner | 当 `rtu_ck_flush=1` 且 `rtu_ck_flush_iid_older_than_ex1_iid=1` 时 | 则 C1 `lsu_mmu_abort=1`，C2 `lag_ex1_inst_vld=0`；未命中年龄条件的owner不得误清 | 命中/不命中IID各跑一次 |
|`AG-FP-12-S03` | icg_en=0、scan_en=1；C0发fresh；C1采样 | 当 `cp0_lsu_icg_en=0`、`pad_yy_icg_scan_en=1` 且 `idu_lsu_rf_gateclk_sel=1` 时 | 则 C1 gated clock仍捕获请求并使 `lag_ex1_inst_vld=1`、IID正确 | scan路径无X或重复capture |
|`AG-FP-12-S04` | C0建owner；C1 flush；C2迟到fault；C3采样 | 当owner已被 `rtu_lsu_flush_fe=1` 清除后才出现 `mmu_lsu_page_fault=1` 或 `mmu_lsu_access_fault=1` 时 | 则 C3 `lag_ex1_inst_vld=0`、`lag_ldc_ex1_expt_vld=0` 且 `lsu_lrq_create_vld=0` | 迟到MMU响应不复活owner或制造幽灵异常 |

<!-- INTERACTION-2.1-SUPPLEMENT-BEGIN -->
## 4. interaction 2.1 补充叶级场景（S05～S08）

下表补齐每个功能点的反例、边界、owner切换和flush/反压组合。
所有行与CSV逐字对应；其中AG-FP-05-S05～S08形成PA/abort/replay真值表。

|场景|前置与逐拍驱动|当|则|检查与关闭|
|---|---|---|---|---|
|`AG-FP-01-S05`|复位释放，LRQ entry5保存VA和IID；C0: 驱动replay entry5；C1: 采样AG owner|当 `lrq_lsu_rf_replay_vld=1` 且entry5被发射时|则 C1 `lag_ex1_inst_vld=1` 且 `lag0_ex1_iid` 等于replay IID|`CHK_FP01_OWNER_STABLE` / `COV_FP01_OWNER`；replay owner与entry5逐位一致|
|`AG-FP-01-S06`|先完成一个replay，下一拍提供fresh IID 0x26；C0: 完成replay；C1: 切换fresh；C2: 采样|当 `lrq_lsu_rf_replay_vld=0` 且 `idu_lsu_rf_sel=1` 时|则 C2 `lag_ex1_inst_vld=1` 且 `lag0_ex1_iid=idu_lsu_rf_iid`|`CHK_FP01_OWNER_STABLE` / `COV_FP01_OWNER`；fresh不得继承replay IID或payload|
|`AG-FP-01-S07`|AG保存IID 0x27，flush IID年龄条件不命中；C0: 建立stall owner；C1: 发未命中ck_flush；C2: 采样|当 `rtu_ck_flush=1` 且 `rtu_ck_flush_iid_older_than_ex1_iid=0` 时|则 C2 `lag_ex1_inst_vld=1` 且 `lag0_ex1_iid` 保持0x27|`CHK_FP01_OWNER_STABLE` / `COV_FP01_OWNER`；未命中flush不得清除或更换owner|
|`AG-FP-01-S08`|AG空闲且无replay；C0: gateclk_sel=1但sel=0；C1: 采样|当 `idu_lsu_rf_gateclk_sel=1` 但 `idu_lsu_rf_sel=0` 时|则 C1 `lag_ex1_inst_vld=0` 且 `lag0_ex1_iid` 不得捕获输入IID|`CHK_FP01_OWNER_STABLE` / `COV_FP01_OWNER`；门控提示不能单独创建owner|
|`AG-FP-02-S05`|base低位为0x8且MMU命中；C0: offset=0且shift=0；C1: 采样|当 `idu_lsu_rf_offset=0` 且 `idu_lsu_rf_shift=0` 时|则 C1 `ld_ag_va=idu_lsu_rf_src0` 且 `lag_ldc_ex1_bytes_vld=16'hFF00`|`CHK_FP02_ADDR_MASK` / `COV_FP02_ADDR_SIZE`；doubleword mask与base低位精确对应|
|`AG-FP-02-S06`|base位于页内低地址，offset=0x7ff；C0: zext=1且shift=3；C1: 采样|当 `idu_lsu_rf_off_zext=1`、`idu_lsu_rf_offset=12'h7ff` 且 `idu_lsu_rf_shift=3` 时|则 C1 `ld_ag_va` 等于base加零扩展offset左移值且 `ld_ag_cross_4k` 匹配参考模型|`CHK_FP02_ADDR_MASK` / `COV_FP02_ADDR_SIZE`；最大正offset无符号扩展错误|
|`AG-FP-02-S07`|地址低四位为8且size为doubleword；C0: 发低位8的doubleword；C1: 采样mask|当 `idu_lsu_rf_inst_size=2'b11` 且 `ld_ag_va[3:0]=4'h8` 时|则 C1 `lag_ldc_ex1_bytes_vld=16'hFF00` 且 `ld_ag_va[3:0]=4'h8`|`CHK_FP02_ADDR_MASK` / `COV_FP02_ADDR_SIZE`；mask不越过16-byte窗口|
|`AG-FP-02-S08`|base页内0x7f0且访问自然对齐；C0: 发页内访问；C1: 采样cross|当 `ld_ag_va[11:0]=12'h7f0` 且访问末字节仍在本页时|则 C1 `ld_ag_cross_4k=0` 且 `lsu_hpcp_ld_stall_cross_4k=0`|`CHK_FP02_ADDR_MASK` / `COV_FP02_ADDR_SIZE`；页内访问不得产生跨页stall|
|`AG-FP-03-S05`|有效AG owner等待MMU；C0: 置mmu stall；C1: 采样；C2: 再采样；C3: 解除|当 `mmu_lsu_stall=1` 且 `lag_ex1_inst_vld=1` 时|则 C1至C2 `lag_ex1_stall_ori=1` 且 `lag0_ex1_iid` 稳定|`CHK_FP03_MMU_OWNER` / `COV_FP03_MMU_RESULT`；MMU busy期间owner不漂移|
|`AG-FP-03-S06`|LRQ replay包含有效PA和属性；C0: 发带PA replay；C1: 采样|当 `lrq_lsu_rf_replay_vld=1` 且 `lrq_lsu_rf_pa_vld=1` 时|则 C1 `lsu_mmu_va_vld=0` 且 `lag_ex1_pa` 使用LRQ保存PA|`CHK_FP03_MMU_OWNER` / `COV_FP03_MMU_RESULT`；带PA replay不重复请求MMU|
|`AG-FP-03-S07`|AG为空且fault保存状态已清；C0: AG保持空；C1: 脉冲AF；C2: 采样|当 `lag_ex1_inst_vld=0` 时迟到 `mmu_lsu_access_fault=1`|则 C2 `lsu_mmu_abort=0` 且 `lag_ldc_ex1_expt_vld=0`|`CHK_FP03_MMU_OWNER` / `COV_FP03_MMU_RESULT`；无owner响应不得制造异常|
|`AG-FP-03-S08`|有效owner IID 0x38且无结构stall；C0: PA和PF同拍返回；C1: 采样|当 `mmu_lsu_pa_vld=1` 与 `mmu_lsu_page_fault=1` 同拍命中owner时|则 C1 `lag_ldc_ex1_expt_page_fault=1` 且 `lsu_mmu_abort=0` 保持当前IID归属|`CHK_FP03_MMU_OWNER` / `COV_FP03_MMU_RESULT`；PF进入DC异常而不串owner|
|`AG-FP-04-S05`|stall owner已建立并记录IID；C0: 建立stall；C1: 同拍PF和AF；C2: 采样|当 `lag_bkcon_stall_already=1` 且PF与 `mmu_lsu_access_fault=1` 同拍时|则 C2 `lag_bkcon_pgfault=1`、`lag_bkcon_acfault=1` 且 `lag_ldc_ex1_expt_vld=1`|`CHK_FP04_FAULT_TRANSFER` / `COV_FP04_FAULT_DELAY`；两个保存位均绑定同一owner|
|`AG-FP-04-S06`|PF已在stall周期捕获；C0: 捕获PF；C1: 撤PF保持stall；C2-C3: 采样|当输入 `mmu_lsu_page_fault=0` 但原owner仍stall时|则 C2至C3 `lag_bkcon_pgfault=1` 且 `lag0_ex1_iid` 不变|`CHK_FP04_FAULT_TRANSFER` / `COV_FP04_FAULT_DELAY`；PF保存不依赖输入电平持续|
|`AG-FP-04-S07`|stall owner已保存PF和AF；C0: 建立保存位；C1: full flush；C2: 采样|当 `rtu_lsu_flush_fe=1` 清除fault owner时|则 C2 `lag_bkcon_pgfault=0`、`lag_bkcon_acfault=0` 且 `lag_ex1_inst_vld=0`|`CHK_FP04_FAULT_TRANSFER` / `COV_FP04_FAULT_DELAY`；flush后不残留fault状态|
|`AG-FP-04-S08`|旧AF事务完成后立即发新IID；C0: 旧owner退出；C1: 发无fault fresh；C2: 采样|当新的 `idu_lsu_rf_sel=1` 捕获且 `mmu_lsu_access_fault=0` 时|则 C2 `lag_bkcon_acfault=0`、`lag_ldc_ex1_expt_vld=0` 且IID为新owner|`CHK_FP04_FAULT_TRANSFER` / `COV_FP04_FAULT_DELAY`；back-to-back事务异常状态隔离|
|`AG-FP-05-S05`|fresh结构stall已创建LRQ entry；C0: 建立stall；C1: older=1且PA有效；C1组合采样|当 `lag_ex1_stall_ori=1`、`idu_lsu_rf_older_vld=1` 且 `mmu_lsu_pa_vld=1` 时|则 `lsu_lrq_create_frz=0` 且已创建entry可由 `lag_ex1_stall_restart_entry` 唤醒|`CHK_FP05_RESTART_OWNER` / `COV_FP05_STALL_REASON`；PA命中覆盖路径不冻结owner|
|`AG-FP-05-S06`|fresh结构stall已创建LRQ且没有其他abort源；C0: 建立stall；C1: older=1、PA无效且AF=0；C1组合采样|当 `lag_ex1_stall_ori=1`、`idu_lsu_rf_older_vld=1`、`mmu_lsu_pa_vld=0` 且无abort时|则 `lsu_lrq_create_frz=1` 且 `lag_ex1_stall_restart_entry` 保持全零等待MMU|`CHK_FP05_RESTART_OWNER` / `COV_FP05_STALL_REASON`；纯miss与aborted miss结果必须区分|
|`AG-FP-05-S07`|结构stall已连续一拍并保存LRQ id，延迟AF作为独立abort源；C0: 建立结构stall并创建LRQ；C1: 确认create_already；C1负沿驱动older=1、PA无效和延迟AF；C1组合采样；C2: 捕获|当 `lag_ex1_stall_ori=1`、`idu_lsu_rf_older_vld=1`、`mmu_lsu_pa_vld=0` 且由延迟访问异常使 `lsu_mmu_abort=1` 时|则 `lsu_lrq_create_frz=0` 且 `lag_ex1_stall_restart_entry` 立即指向已创建LRQ，`lag_lrq_create_already=1`|`CHK_FP05_RESTART_OWNER` / `COV_FP05_STALL_REASON`；同一组合观察点freeze为0且restart bitmap非零|
|`AG-FP-05-S08`|LRQ replay entry有效且结构stall；C0: 发replay并建立stall；C1: 注入AF；C2: 采样|当 `lag_lrq_replay_vld=1` 的owner因 `mmu_lsu_access_fault=1` abort时|则 `lsu_lrq_create_vld=0` 且 `lag_ex1_stall_restart_entry` 只指向原replay entry|`CHK_FP05_RESTART_OWNER` / `COV_FP05_STALL_REASON`；replay abort不得分配第二个LRQ|
|`AG-FP-06-S05`|cacheable load且D-cache开启；C0: 依次驱动PA bank0和bank3；C1: 各采样|当 `mmu_lsu_pa_vld=1` 且 `lag_ex1_pa[7:6]` 在00与11切换时|则 `lag_dcache_arb_ex1_bank_idx` 精确跟随PA且data request保持one-hot组|`CHK_FP06_DC_REQ_VALID` / `COV_FP06_BANK_INDEX`；首尾bank均被真实请求覆盖|
|`AG-FP-06-S06`|有效cacheable owner无异常；C0: 发有效load；C1: 采样gate与req|当 `lag_dcache_arb_ex1_ld_tag_req=1` 时|则 `lag_dcache_arb_ex1_ld_tag_gateclk_en=1` 且tag request仅持续所属周期|`CHK_FP06_DC_REQ_VALID` / `COV_FP06_BANK_INDEX`；请求不能脱离阵列门控|
|`AG-FP-06-S07`|AG已保存cacheable owner和bank1；C0: 建立bank1 owner；C1: bkcon并改变MMU PA；C2: 采样|当 `dcache_arb_lag_ex1_bkcon=1` 且外部 `mmu_lsu_pa` 改变时|则 `lag_dcache_arb_ex1_bank_idx` 与 `lag0_ex1_iid` 均保持原owner值|`CHK_FP06_DC_REQ_VALID` / `COV_FP06_BANK_INDEX`；stall期间不能采到下一事务PA|
|`AG-FP-06-S08`|D-cache关闭且MMU返回NC；C0: dcache_en=0、CA=0并发load；C1: 采样|当 `cp0_lsu_dcache_en=0` 且 `mmu_lsu_ca=0` 时|则 `lag_dcache_arb_ex1_ld_tag_req=0`、data request为零且 `lag_ldc_ex1_page_ca=0`|`CHK_FP06_DC_REQ_VALID` / `COV_FP06_BANK_INDEX`；双重禁用不产生cache阵列访问|
|`AG-FP-07-S05`|tag相位完成但四路均miss；C0: 发unit-stride；C1: hit_way=0；C2: 采样|当 `lag_us_tag_hit_way=4'b0000` 且unit-stride owner有效时|则 `lag_ex1_us_way=4'b0000` 且 `lag_us_tag_ack_stall=1` 阻止错误data相位|`CHK_FP07_US_SEQUENCE` / `COV_FP07_US_WAY`；all-miss不选择任意way|
|`AG-FP-07-S06`|tag请求已成功但仲裁未ack；C0: 发请求；C1: tag成功后撤sel；C2: 采样|当 `lag_us_tag_ack_stall=1` 时|则 `lag_ex1_stall_ori=1` 且 `lag_us_tag_req_success=1` 保持已完成tag相位|`CHK_FP07_US_SEQUENCE` / `COV_FP07_US_WAY`；ack反压不能重复tag或提前data|
|`AG-FP-07-S07`|unit-stride已完成tag尚未data；C0: tag相位；C1: full flush；C2: 采样|当unit-stride两相位之间 `rtu_lsu_flush_fe=1` 时|则 C2 `lag_ex1_inst_vld=0` 且 `lag_dcache_arb_ex1_data_req=16'h0000`|`CHK_FP07_US_SEQUENCE` / `COV_FP07_US_WAY`；flush后不得发迟到data请求|
|`AG-FP-07-S08`|首owner命中way0，次owner命中way3；C0: 发way0 owner；C1: 完成首个tag；C2: 完成首个data；C3-C5: 完成way3并采样|当两个 `idu_lsu_rf_unit_stride=1` owner背靠背且命中way不同时|则第二事务 `lag_ldc_ex1_us_way=4'b1000` 且IID属于第二owner|`CHK_FP07_US_SEQUENCE` / `COV_FP07_US_WAY`；保存way随owner更新且无旧值泄漏|
|`AG-FP-08-S05`|atomic doubleword为奇地址且MMU报告PF；C0: 同拍建立misalign和PF；C1: 采样|当 `ld_ag_unalign=1` 与 `mmu_lsu_page_fault=1` 同拍时|则异常子类按RTL优先级稳定且 `lag_ldc_ex1_expt_vld=1`|`CHK_FP08_EXCEPTION_AGGREGATES` / `COV_FP08_EXCEPTION_KIND`；组合异常不产生X或正常load副作用|
|`AG-FP-08-S06`|普通load跨页且访问宽度导致不对齐；C0: 构造跨页misalign；C1: 采样|当 `ld_ag_cross_4k=1` 且 `ld_ag_unalign=1` 时|则 `lag_ldc_ex1_expt_misalign_with_page=1` 且no-page分类不重复置位|`CHK_FP08_EXCEPTION_AGGREGATES` / `COV_FP08_EXCEPTION_KIND`；with-page与no-page分类互斥|
|`AG-FP-08-S07`|atomic已matching commit且地址对齐CA=1；C0: 建立atomic；C1: matching commit；C2: 采样|当 `lag_ldc_ex1_atomic=1`、`mmu_lsu_ca=1` 且地址对齐时|则 `lag_ldc_ex1_expt_ldamo_not_ca=0` 且无其他错误时 `lag_ldc_ex1_expt_vld=0`|`CHK_FP08_EXCEPTION_AGGREGATES` / `COV_FP08_EXCEPTION_KIND`；合法LDAMO不误报属性异常|
|`AG-FP-08-S08`|有效owner与PF在flush同拍；C0: 建立owner；C1: flush和PF同拍；C2: 采样|当 `rtu_lsu_flush_fe=1` 与 `mmu_lsu_page_fault=1` 同拍时|则 C2 `lag_ex1_inst_vld=0` 且 `lag_ldc_ex1_inst_vld=0`|`CHK_FP08_EXCEPTION_AGGREGATES` / `COV_FP08_EXCEPTION_KIND`；被flush异常不得进入正常DC事务|
|`AG-FP-09-S05`|fresh结构stall尚未创建第二次；C0: 建立fresh stall；C1: older=1且PA hit；C1组合采样|当 `lag_ex1_stall_ori=1`、`idu_lsu_rf_older_vld=1` 且 `mmu_lsu_pa_vld=1` 时|则首次 `lsu_lrq_create_vld=1` 且 `lsu_lrq_create_frz=0`、IID等于owner|`CHK_FP09_LRQ_OWNER` / `COV_FP09_LRQ_STATE`；ready entry创建一次且不冻结|
|`AG-FP-09-S06`|fresh结构stall且PA尚未返回；C0: 发fresh并stall；C1: older=1且PA miss；C1组合采样|当首次create时 `idu_lsu_rf_older_vld=1` 且 `mmu_lsu_pa_vld=0`、abort为0|则 `lsu_lrq_create_vld=1`、`lsu_lrq_create_frz=1` 且IID精确匹配|`CHK_FP09_LRQ_OWNER` / `COV_FP09_LRQ_STATE`；未完成MMU的entry必须等待而非立即issue|
|`AG-FP-09-S07`|结构stall已持续一拍并记录LRQ id；C0: 首次create；C1: 保持stall并计数；C2-C3: 继续计数|当 `lag_lrq_create_already=1` 且owner继续stall时|则 C1至C3 `lsu_lrq_create_vld=0` 且 `lag_lrq_create_already=1`|`CHK_FP09_LRQ_OWNER` / `COV_FP09_LRQ_STATE`；一个owner仅允许一个create脉冲|
|`AG-FP-09-S08`|fresh待完成且ck_flush年龄命中；C0: 建立owner；C1: 命中ck_flush；C2: 采样|当 `rtu_ck_flush=1` 且 `rtu_ck_flush_iid_older_than_ex1_iid=1` 时|则 C2 `lsu_lrq_create_vld=0`、`lag_ex1_inst_vld=0` 且abort只作用于目标owner|`CHK_FP09_LRQ_OWNER` / `COV_FP09_LRQ_STATE`；selective flush无迟到LRQ分配|
|`AG-FP-10-S05`|atomic owner等待且slot0空闲；C0: 建立atomic；C1: slot1 matching commit；C2: 采样|当 `rtu_yy_xx_commit1=1` 且其IID等于atomic owner时|则 C2 `lag_lm_ex1_init_vld=1` 且 `lag_ldc_ex1_atomic=1`|`CHK_FP10_ATOMIC_COMMIT` / `COV_FP10_SPECIAL_SOURCE`；非slot0 commit同样可初始化monitor|
|`AG-FP-10-S06`|atomic owner等待matching commit；C0: 建立atomic；C1: 单拍commit；C2-C3: 撤销并采样|当matching `rtu_yy_xx_commit0=1` 仅持续一拍时|则 `lag_lm_ex1_init_vld` 仅在对应转移周期有效且 `ld_ag_stall_restart` 随后解除|`CHK_FP10_ATOMIC_COMMIT` / `COV_FP10_SPECIAL_SOURCE`；monitor初始化不重复|
|`AG-FP-10-S07`|未commit atomic处于restart等待；C0: 建立未commit atomic；C1: full flush；C2: 采样|当未commit atomic等待时 `rtu_lsu_flush_fe=1`|则 C2 `lag_ex1_inst_vld=0` 且 `lag_lm_ex1_init_vld=0`|`CHK_FP10_ATOMIC_COMMIT` / `COV_FP10_SPECIAL_SOURCE`；flush不能留下local monitor初始化|
|`AG-FP-10-S08`|普通load IID恰与commit IID相同；C0: 发普通load；C1: matching commit；C2: 采样|当 `lag_ldc_ex1_atomic=0` 即使matching commit有效时|则 `lag_lm_ex1_init_vld=0` 且 `lag_ldc_ex1_atomic=0`|`CHK_FP10_ATOMIC_COMMIT` / `COV_FP10_SPECIAL_SOURCE`；普通load不得初始化atomic monitor|
|`AG-FP-11-S05`|unit-stride split且vmask有效但数据全零；C0: vmask全零；C1: 采样|当 `idu_lsu_rf_vmask_vld=1` 且 `idu_lsu_rf_srcvm_vr0=0` 时|则 `lag_ldc_ex1_bytes_vld=0` 且 `lag_ldc_ex1_reg_bytes_vld=0`|`CHK_FP11_VECTOR_KNOWN` / `COV_FP11_VECTOR_MODE`；mask关闭的元素不产生byte有效位|
|`AG-FP-11-S06`|vmew=1且vmask使用交替位；C0: 驱动交替vmask；C1: 采样四组mask|当 `idu_lsu_rf_vmew=1` 且vmask为交替位图时|则 `lag_ldc_ex1_bytes_vld` 与 `lag_ldc_ex1_reg_bytes_vld` 按vmew1参考映射保持二态|`CHK_FP11_VECTOR_KNOWN` / `COV_FP11_VECTOR_MODE`；稀疏mask逐bit对比helper模型|
|`AG-FP-11-S07`|vmew=2且split_num取0和最大值；C0: split_num=0；C1: 采样；C2: 最大值；C3: 采样|当 `idu_lsu_rf_split=1` 且 `idu_lsu_rf_split_num` 在边界值切换时|则 `lag_ldc_ex1_bytes_vld2` 随split轮转且不含X，主 `lag_ldc_ex1_bytes_vld` 归属正确|`CHK_FP11_VECTOR_KNOWN` / `COV_FP11_VECTOR_MODE`；首尾split索引均覆盖|
|`AG-FP-11-S08`|连续两个vector owner分别vmew0和vmew3；C0: vmew0 owner；C1: 采样；C2: vmew3 owner；C3: 采样|当连续owner的 `idu_lsu_rf_vmew` 从0切换到3时|则第二owner `lag_ldc_ex1_bytes_vld3` 使用vmew3映射且 `lag0_ex1_iid` 已更新|`CHK_FP11_VECTOR_KNOWN` / `COV_FP11_VECTOR_MODE`；vector模式状态不跨owner泄漏|
|`AG-FP-12-S05`|AG空闲，功能门控和scan均关闭；C0: icg=0、scan=0并给请求；C1: 采样|当 `cp0_lsu_icg_en=0` 且 `pad_yy_icg_scan_en=0` 时|则 C1 `lag_ex1_inst_vld=0` 且 `lag0_ex1_iid` 不捕获新值|`CHK_FP12_FLUSH_CLEARS` / `COV_FP12_FLUSH_POINT`；关闭门控时状态保持|
|`AG-FP-12-S06`|cpurst_b保持低且输入端口非零；C0: reset低并脉冲fresh；C1: 采样；C2: 释放reset|当 `cpurst_b=0` 时即使 `idu_lsu_rf_sel=1`|则 C1 `lag_ex1_inst_vld=0` 且 `lsu_lrq_create_vld=0`|`CHK_FP12_FLUSH_CLEARS` / `COV_FP12_FLUSH_POINT`；复位期间无owner或LRQ副作用|
|`AG-FP-12-S07`|AG owner IID比flush边界更老；C0: 建立owner；C1: 发未命中flush；C2: 采样|当 `rtu_ck_flush=1` 且 `rtu_ck_flush_iid_older_than_ex1_iid=0` 时|则 `lsu_mmu_abort=0`、`lag_ex1_inst_vld=1` 且IID不变|`CHK_FP12_FLUSH_CLEARS` / `COV_FP12_FLUSH_POINT`；selective flush只清命中年龄窗口|
|`AG-FP-12-S08`|结构stall owner被older RF覆盖；C0: 建立stall；C1: older和full flush同拍；C2: 采样|当 `lag_ex1_stall_ori=1`、`idu_lsu_rf_older_vld=1` 与 `rtu_lsu_flush_fe=1` 同拍时|则当拍 `lsu_mmu_abort=1`，C2 `lag_ex1_inst_vld=0` 且 `lsu_lrq_create_vld=0`|`CHK_FP12_FLUSH_CLEARS` / `COV_FP12_FLUSH_POINT`；flush优先于masked replay且无幽灵create|
<!-- INTERACTION-2.1-SUPPLEMENT-END -->
## 5. 关闭与执行边界

每个场景必须落入CSV指定的现有 testcase task，并将“当”转换为driver前置条件，
将“则”转换为scoreboard/SVA检查。`make -C verif/xx_lsu_ld_ag preflight`
证明96行计划的结构、父功能映射、信号拼写和文档覆盖完整；它不证明VCS动态
执行完成。AG-FP-01～09、12在当前Mac标记为 `BLOCKED_NO_VCS`；AG-FP-10/11
还依赖生产TCM/vector helper，标记为 `PENDING_FULL_CHIP`。
