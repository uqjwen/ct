# `xx_lsu_ld_dc` 设计风险审查

## 1. 范围与结论

基于提交 `a81c012` 完成初审，并在 Interaction 1.4 提交 `6260f4a` 上复核 AG→DC 流水、borrow、D-cache tag/data 选择、restart、RVV unit-stride 元数据和调试地址触发接口。D-cache arbiter 与 MMU 已补充；VB/SNQ borrow producer、门控时钟单元和完整一致性环境仍按合同依赖分类。

| ID | 优先级 | 置信度 | 状态 | 摘要 |
|---|---:|---|---|---|
| DC-RR-01 | P2 | 已确认 | 开放 | `ld_dc_dtu_addr_vld` 置 1 后没有正常清零路径 |
| DC-RR-02 | P1 | 源码+合同 | 合同保留 | arbiter 两表达式的 VB/SNQ 项使用不同输入，等价性仍需 producer 证明 |
| DC-RR-03 | P1 | 合同依赖 | 条件关闭 | 多 way tag hit 被 OR 编码，必须保证 `$onehot0` |
| DC-RR-04 | P3 | 已给定配置 | 清理项 | MMU immediate-wakeup 已永久拉低，但 DC 仍保留活动逻辑 |
| DC-RR-05 | P3 | 高置信 | 开放待资格化 | US-only 掩码在非 US 指令时保留旧值 |

## 2. 流水与选择摘要

`ldc_ex2_inst_vld` 在 reset、front-end flush、check-flush 和正常输入间有显式优先级（`srcs/xx_lsu_ld_dc.sv:1113-1155`）；DC 只在 `ldc_restart_vld` 为 0 时向 DA 发送有效事务。borrow valid 在公共控制时钟上采样，payload 则在独立 borrow 门控时钟上采样。D-cache 四路 tag 独立比较后合成 hit，并把 hit way 编成 2-bit settle-way（`srcs/xx_lsu_ld_dc.sv:1887-1920`、`srcs/xx_lsu_ld_dc.sv:1250`）。

## 3. 详细风险

### DC-RR-01：调试地址 valid 粘住

`ld_dc_dtu_addr_vld` reset 后仅在 `lag_ex1_inst_vld && ld_ag_dtu_vld` 时写 1，没有对应的 `else` 清零（`srcs/xx_lsu_ld_dc.sv:2263-2273`）。同一个 `ldc_inst_clk` 会由每条 `lag_ex1_inst_vld` 打开（`srcs/xx_lsu_ld_dc.sv:1055-1064`），但后一条非调试 load 也不会清除旧 valid。top 又直接把该 valid 导出（`srcs/xx_lsu_top.sv:6983-6990`）。

触发一次地址检查后，DTU 可能持续看到旧地址、旧 byte mask 和旧 halt-info 的有效请求，造成重复或错误触发。应把 valid 改为每个活动 DC 周期赋 `lag_ex1_inst_vld && ld_ag_dtu_vld`，并让 payload 只在同一 accept 条件下更新。

### DC-RR-02：borrow valid/payload 时钟合同未固化

`ldc_ex2_borrow_vld` 直接在 `ctrl_ld_clk` 上采样 `dcache_arb_ldc_borrow_vld`（`srcs/xx_lsu_ld_dc.sv:1157-1166`），borrow payload 的门控时钟却由 `dcache_arb_ldc_borrow_vld_gate` 打开（`srcs/xx_lsu_ld_dc.sv:1072-1081`），并且只有真实 valid 为 1 才更新 payload（`srcs/xx_lsu_ld_dc.sv:1215-1248`）。

若 `borrow_vld=1` 而 gate=0，下一拍会带有效 borrow 和旧 payload 进入 DA。Interaction 1.4 新增的 `xx_lsu_dcache_arb` 显示，两条表达式的 ICC/WMB/MCIC/PRQ 项相同，但 VB/SNQ 项分别使用 `vb/snq_*_borrow_req` 与 `vb/snq_*_borrow_req_gate`（`srcs/xx_lsu_dcache_arb.sv:533-543`）。因此“在 arbiter 中赋值等价”并不成立；等价性已经被下推到两个未提供的 producer。

本项保持合同风险：必须补充 VB/SNQ 产生逻辑，或在 producer→arbiter 和 arbiter→DC 两个边界同时断言双向相等。只证明 `valid -> gate` 还不足以排除 gate-only 造成无意义开钟/旧 payload 组合。

### DC-RR-03：多 hit 时 settle-way 不唯一

四路 valid/tag hit 分别形成 `ldc_hit_way[3:0]`（`srcs/xx_lsu_ld_dc.sv:1887-1918`），`dcache_hit` 只做 OR（`srcs/xx_lsu_ld_dc.sv:1920`），而 settle-way 使用 OR 编码 `{way3|way2, way3|way1}`（`srcs/xx_lsu_ld_dc.sv:1250`）。两个或更多 way 同时命中时，编码会落到某一路但不报告重复 tag，后续 data/ECC 选择可能读取错误 cache line。

Interaction 1.3 已确认 LFB/一致性逻辑保证同 set 同 tag 最多一路有效，因此本项按合同关闭；缓存一致性数据比对能在系统级发现副本错误，但 DC 的 OR 编码仍可能把根因推迟成数据错。建议在 DC 入口直接加 `$onehot0(ldc_hit_way)` assertion，并用重复 tag 负向注入验证即时可见性。

### DC-RR-04：永久拉低后的 immediate-wakeup 残留

DC 仍保存 `mmu_lsu_imme_wakeup`（`srcs/xx_lsu_ld_dc.sv:1379-1382`）并把它并入 immediate restart（`srcs/xx_lsu_ld_dc.sv:1771-1778`）。README 1.1.2 已声明上游永久输出 0，因此功能上条件关闭，但建议在集成层断言 tie-off，或删除残留状态和分支以免未来误接后静默改变 restart 行为。

### DC-RR-05：US-only 掩码保留旧值

`bytes_vld2/3`、`reg_bytes_vld1/2/3` 和 `us_way` 仅在 US 指令时更新，非 US 指令没有清零分支（`srcs/xx_lsu_ld_dc.sv:1409-1426`）。当前消费者必须始终以 `inst_us` 资格化这些字段；否则普通 load 紧跟 US load 时会看到旧高位 mask。建议补零或对全部消费点加 `!inst_us -> fields==0` 的接口断言。

## 4. 已排除项

borrow 地址不是独立 bug：AG 在 borrow address valid 时已经把 arbiter 地址复用到 `lag_ldc_ex1_addr0`，DC 再统一采样。DC 的 ahead-WB 预测也不会绕过 restart，因为 DA 只在 `ldc_lda_ex2_inst_vld` 下锁存该 valid。Interaction 1.4 没有改变已确认的 DC-RR-01；当前首要修复仍是调试 valid 粘住，然后补充 VB/SNQ producer，在完整 dcache/一致性环境固化 borrow 等价和 tag one-hot 合同。
