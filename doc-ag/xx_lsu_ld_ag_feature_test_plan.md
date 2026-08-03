# `xx_lsu_ld_ag` 详细功能点与 Test Plan

## 1. 使用方法与时序约定

本计划把 `AG-FP-01`～`AG-FP-12` 展开为 48 个可直接落入现有 VCS
testcase task 的场景。机器可读源为
`verif/xx_lsu_ld_ag/detailed_test_plan.csv`，本文给工程师提供逐拍驱动、
触发条件、预期输出、checker、coverage 和关闭标准。

- `C0`：在时钟负沿后驱动输入，保证下一个正沿满足setup。
- `C1/C2/C3`：对应后续正沿后 `#1` 采样；连续stall场景每拍都检查owner。
- “当”列只写触发合同；“则”列写可直接转成 `expect_true` 或SVA的结果。
- `drive_signals` 和 `expected_signals` 必须使用RTL/接口原名，不能用自然语言别名。
- 48表示**详细计划场景数**，不是48个场景已经在本机VCS动态执行；现有12个
  testcase是实现落点，动态结果仍受 `BLOCKED_NO_VCS` 和
  `PENDING_FULL_CHIP` 边界约束。

## 2. 功能级追踪入口

以下五列摘要保留interaction 1.7约定的文档schema；后续逐场景表进一步给出
可直接编码的信号与周期条件。

| 二级功能点 | 三级功能点 | 功能点描述 | 测试方法和配置说明 | 优先级 |
|---|---|---|---|---|
| 流水级控制 | RF请求锁存 | fresh/replay复用AG，flush与stall决定owner保持；见 `srcs/xx_lsu_ld_ag.sv:1074` | 执行AG-FP-01-S01～S04，逐拍检查IID、payload、stall和flush优先级 | P0 |
| 地址生成 | 标量VA与跨页 | base、offset、shift、size生成VA、mask和4KiB crossing；见 `srcs/xx_lsu_ld_ag.sv:1257` | 执行AG-FP-02-S01～S04，遍历size/低位并检查正负跨页 | P0 |
| MMU接口 | hit/miss/abort | MMU返回PA、miss或fault时转移AG owner；见 `srcs/xx_lsu_ld_ag.sv:2415` | 执行AG-FP-03-S01～S04，分别配置同拍hit、miss、PF和下一拍AF | P0 |
| MMU异常 | PF/AF保存 | backpressure期间保存page fault和下一拍access fault；见 `srcs/xx_lsu_ld_ag.sv:1354` | 执行AG-FP-04-S01～S04，覆盖1/N拍保存和新owner清除 | P0 |
| Stall/Restart | backconnect恢复 | 结构stall、TLB miss和fault选择hold、restart或abort；见 `srcs/xx_lsu_ld_ag.sv:2762` | 执行AG-FP-05-S01～S04，检查fresh/replay owner与restart bitmap | P0 |
| D-cache请求 | tag/data bank | cache属性与PA低位控制tag、16路data request和bank index；见 `srcs/xx_lsu_ld_ag.sv:2574` | 执行AG-FP-06-S01～S04，覆盖四bank、disabled、NC/SO与borrow | P1 |
| Unit-stride | 两拍way获取 | 512-bit unit-stride先读tag再保存命中way访问data；见 `srcs/xx_lsu_ld_ag.sv:1391` | 执行AG-FP-07-S01～S04，覆盖one-hot way、两相位、模式切换与跨line | P0 |
| 异常判定 | 对齐与属性 | misalign、PF、AF和LDAMO非CA形成不同异常编码；见 `srcs/xx_lsu_ld_ag.sv:2662` | 执行AG-FP-08-S01～S04，逐项检查子类、aggregate和DC屏蔽 | P0 |
| LRQ协同 | 创建与freeze | fresh创建LRQ，replay不重复创建，flush取消迟到create；见 `srcs/xx_lsu_ld_ag.sv:3031` | 执行AG-FP-09-S01～S04，检查create唯一性、freeze和owner IID | P0 |
| TCM/Atomic | 特殊访问 | TCM来源及atomic commit改变请求与monitor初始化；见 `srcs/xx_lsu_ld_ag.sv:2935` | 执行AG-FP-10-S01～S04，并在full-chip替换生产TCM逻辑重跑 | P1 |
| 向量访问 | split与byte mask | vmew、split、vl和vmask生成四组byte/reg-byte mask；见 `srcs/xx_lsu_ld_ag.sv:1692` | 执行AG-FP-11-S01～S04，按vmew=0..3逐bit对比生产helper | P1 |
| Flush/Clock | 清除与门控 | full/check flush清owner，ICG与scan控制状态捕获；见 `srcs/xx_lsu_ld_ag.sv:1074` | 执行AG-FP-12-S01～S04，覆盖full/selective flush、scan和迟到fault | P0 |

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

## 4. 关闭与执行边界

每个场景必须落入CSV指定的现有 testcase task，并将“当”转换为driver前置条件，
将“则”转换为scoreboard/SVA检查。`make -C verif/xx_lsu_ld_ag preflight`
证明48行计划的结构、父功能映射、信号拼写和文档覆盖完整；它不证明VCS动态
执行完成。AG-FP-01～09、12在当前Mac标记为 `BLOCKED_NO_VCS`；AG-FP-10/11
还依赖生产TCM/vector helper，标记为 `PENDING_FULL_CHIP`。
