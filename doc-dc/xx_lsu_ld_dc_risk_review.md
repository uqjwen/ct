# `xx_lsu_ld_dc` 设计风险审查

## 1. 范围与结论

基于提交 `a81c012` 完成初审，并在 Interaction 1.5 提交 `443384a` 上复核 AG→DC 流水、borrow、D-cache tag/data 选择、restart、RVV unit-stride 元数据和调试地址触发接口。D-cache arbiter 与 MMU 已补充；VB/SNQ borrow producer、门控时钟单元和完整一致性环境仍按合同依赖分类。

| ID | 优先级 | 置信度 | 状态 | 摘要 |
|---|---:|---|---|---|
| DC-RR-01 | P2 | 已确认 | 开放 | `ld_dc_dtu_addr_vld` 置 1 后没有正常清零路径 |
| DC-RR-02 | — | 已给定合同 | 条件关闭 | 正确功能条件是 `valid -> gate`；SNQ 相等、VB `req -> gate` 已满足该条件 |
| DC-RR-03 | P1 | 合同依赖 | 条件关闭 | 多 way tag hit 被 OR 编码，必须保证 `$onehot0` |
| DC-RR-04 | P3 | 已给定配置 | 清理项 | MMU immediate-wakeup 已永久拉低，但 DC 仍保留活动逻辑 |
| DC-RR-05 | P3 | 源码+合同 | 功能关闭/功耗意图 | US-only 掩码保留旧值，但 DC→DA→RB→WB 全链路只在 `inst_us` 时更新或消费高位字段 |

## 2. 流水与选择摘要

`ldc_ex2_inst_vld` 在 reset、front-end flush、check-flush 和正常输入间有显式优先级（`srcs/xx_lsu_ld_dc.sv:1113-1155`）；DC 只在 `ldc_restart_vld` 为 0 时向 DA 发送有效事务。borrow valid 在公共控制时钟上采样，payload 则在独立 borrow 门控时钟上采样。D-cache 四路 tag 独立比较后合成 hit，并把 hit way 编成 2-bit settle-way（`srcs/xx_lsu_ld_dc.sv:1887-1920`、`srcs/xx_lsu_ld_dc.sv:1250`）。

## 3. 详细风险

### DC-RR-01：调试地址 valid 粘住

`ld_dc_dtu_addr_vld` reset 后仅在 `lag_ex1_inst_vld && ld_ag_dtu_vld` 时写 1，没有对应的 `else` 清零（`srcs/xx_lsu_ld_dc.sv:2263-2273`）。同一个 `ldc_inst_clk` 会由每条 `lag_ex1_inst_vld` 打开（`srcs/xx_lsu_ld_dc.sv:1055-1064`），但后一条非调试 load 也不会清除旧 valid。top 又直接把该 valid 导出（`srcs/xx_lsu_top.sv:6983-6990`）。

触发一次地址检查后，DTU 可能持续看到旧地址、旧 byte mask 和旧 halt-info 的有效请求，造成重复或错误触发。应把 valid 改为每个活动 DC 周期赋 `lag_ex1_inst_vld && ld_ag_dtu_vld`，并让 payload 只在同一 accept 条件下更新。

### DC-RR-02：borrow valid/payload 的正确合同是单向蕴含

`ldc_ex2_borrow_vld` 直接在 `ctrl_ld_clk` 上采样 `dcache_arb_ldc_borrow_vld`（`srcs/xx_lsu_ld_dc.sv:1157-1166`），borrow payload 的门控时钟却由 `dcache_arb_ldc_borrow_vld_gate` 打开（`srcs/xx_lsu_ld_dc.sv:1072-1081`），并且只有真实 valid 为 1 才更新 payload（`srcs/xx_lsu_ld_dc.sv:1215-1248`）。

若 `borrow_vld=1` 而 gate=0，下一拍会带有效 borrow 和旧 payload 进入 DA。Interaction 1.4 新增的 `xx_lsu_dcache_arb` 显示，两条表达式的 ICC/WMB/MCIC/PRQ 项相同，但 VB/SNQ 项分别使用 `vb/snq_*_borrow_req` 与 `vb/snq_*_borrow_req_gate`（`srcs/xx_lsu_dcache_arb.sv:533-543`）。因此 arbiter 输出不必双向相等，真正的功能安全条件是 `borrow_vld -> borrow_vld_gate`。

Interaction 1.5 给出的 producer 合同为 SNQ `req == gate`、VB `req -> gate`。两者与其他相同项做 OR 后，可推出 arbiter `borrow_vld -> borrow_vld_gate`，足以关闭旧 payload 风险。VB 的 `gate=1,valid=0` 只会保守打开 payload clock；payload always block仍由真实 valid 资格化（`srcs/xx_lsu_ld_dc.sv:1215-1248`），同时 `ldc_ex2_borrow_vld=0`，所以旧 payload 不会被消费。保留单向蕴含与 payload-owner assertion，不再要求 VB 双向相等。

### DC-RR-03：多 hit 时 settle-way 不唯一

四路 valid/tag hit 分别形成 `ldc_hit_way[3:0]`（`srcs/xx_lsu_ld_dc.sv:1887-1918`），`dcache_hit` 只做 OR（`srcs/xx_lsu_ld_dc.sv:1920`），而 settle-way 使用 OR 编码 `{way3|way2, way3|way1}`（`srcs/xx_lsu_ld_dc.sv:1250`）。两个或更多 way 同时命中时，编码会落到某一路但不报告重复 tag，后续 data/ECC 选择可能读取错误 cache line。

Interaction 1.3 已确认 LFB/一致性逻辑保证同 set 同 tag 最多一路有效，因此本项按合同关闭；缓存一致性数据比对能在系统级发现副本错误，但 DC 的 OR 编码仍可能把根因推迟成数据错。建议在 DC 入口直接加 `$onehot0(ldc_hit_way)` assertion，并用重复 tag 负向注入验证即时可见性。

### DC-RR-04：永久拉低后的 immediate-wakeup 残留

DC 仍保存 `mmu_lsu_imme_wakeup`（`srcs/xx_lsu_ld_dc.sv:1379-1382`）并把它并入 immediate restart（`srcs/xx_lsu_ld_dc.sv:1771-1778`）。README 1.1.2 已声明上游永久输出 0，因此功能上条件关闭，但建议在集成层断言 tie-off，或删除残留状态和分支以免未来误接后静默改变 restart 行为。

### DC-RR-05：US-only 掩码保留旧值

`bytes_vld2/3`、`reg_bytes_vld1/2/3` 和 `us_way` 仅在 US 指令时更新，非 US 指令没有清零分支（`srcs/xx_lsu_ld_dc.sv:1409-1426`）。Interaction 1.5 说明这是避免非 US 更新高位寄存器、利于综合门控的功耗意图。

消费链复核支持该解释：DC 的 vector-nop 对高位 mask 的检查由 `ldc_lda_ex2_inst_us` 选择（`srcs/xx_lsu_ld_dc.sv:1543-1550`），四路 D-cache data enable 对普通指令只选择其需要的 128-bit region（`1829-1840`）；DA 高位 mask 仅在新 US 事务时锁存（`srcs/xx_lsu_ld_da.sv:2480-2497`），RB entry 和 WB 高位 byte-mask 也只在 `inst_us` 时更新/消费（`srcs/xx_lsu_rb_entry.sv:1304-1355`、`srcs/xx_lsu_ld_wb.sv:1420-1427`、`1532-1568`）。因此旧高位值对 scalar/非 US 是死字段，功能风险关闭。验证应断言“非 US 不消费”，不能要求字段清零而破坏功耗意图。

## 4. 已排除项

borrow 地址不是独立 bug：AG 在 borrow address valid 时已经把 arbiter 地址复用到 `lag_ldc_ex1_addr0`，DC 再统一采样。DC 的 ahead-WB 预测也不会绕过 restart，因为 DA 只在 `ldc_lda_ex2_inst_vld` 下锁存该 valid。Interaction 1.5 没有改变已确认的 DC-RR-01；当前首要修复仍是调试 valid 粘住，并在完整 dcache/一致性环境固化 borrow 单向蕴含、payload owner 和 tag one-hot 合同。
