# Interaction 1.5 LSU 复核总表

## 1. 总结

本轮以本仓库提交 `443384a`（`interaction-1.5`）为本地基线，并把继承关系固定对照到官方 [T-Head openC910 提交 `b91c909`](https://github.com/T-head-Semi/openc910/tree/b91c90914c19f114d35c8f6b73408eb241ed847c)。README 是待验证的设计合同，不作为 RTL 正确性的替代证明。

结论先列如下：

1. DA-RR-01 已在标量模块修正；原问题应按 **P1** 记录，因为可恢复 ECC replay 会确定性破坏架构 512-bit load 数据，优先级不由修改行数或“笔误”性质决定。
2. CTRL-RR-03、DA-RR-03、LRQ-RR-03 都不要求 RTL 必须增加 epoch。当前可见源码没有发现释放后迟到事件命中新事务的具体路径；正确性依赖“旧 owner 的 producer 状态在 entry 复用前已经清除”这一生命周期不变量，验证环境可以用 generation/epoch 作为观察键。
3. DC-RR-02 只要求 `borrow_vld -> borrow_vld_gate`。README 给出的 SNQ 相等、VB `req -> gate` 合同足以关闭功能风险；VB 的 gate-only 状态只会保守开钟，不会把 payload 标成 valid。
4. DC-RR-05/LRQ-RR-04 的旧高位 mask 是有意保留的非适用字段。DC、DA、RB、WB 的更新和最终消费均由 `inst_us` 资格化，功能风险关闭，保留“非 US 不得消费高位字段”断言，不要求清零。
5. RB-RR-02/RB-RR-04 的关键方程确实与 C910 同源，但官方 C910 本身仍依赖系统级 debug-stop、outstanding 与固定 ID 所有权。继承证据不能证明修改后的 RTU/BIU/LFB/WMB 环境保留全部合同，故两项继续按合同边界管理。
6. WB-RR-01/02 的两处原门控遗漏已补，但补丁形成新的残留：`rb_data_halt_info_update_vld` 可置 1，却不能在无后续 data traffic 时获得清零时钟；它又优先于 `ld_wb_halt_info_effect`，会使 update/completion 保持。WB-RR-01 仍是已确认 P2，WB-RR-02 的本地 effect 开钟修复被该粘连阻塞。
7. 新 `xx_lsu_wb_arbiter` 的 64 组 data 输入和 32 组 completion 输入与“按 WMB→VMB→RB 顺序装入首个空闲 lane”的参考模型完全一致，碰撞安全关闭；它是无状态固定优先级，不能单独证明 VMB/RB 的 bounded grant，WB-RR-04 的活性部分仍开放。

仓库没有可执行 testbench、完整 filelist 与全部宏/helper，当前环境也没有 Verilator、Icarus、Slang 或 svlint；因此本轮结果是静态数据流、官方上游对照和布尔穷举证据，不是动态签核。

## 2. Interaction 1.5 十一点处置矩阵

| README 项 | 对应风险 | 当前处置 | 证据与结论 |
|---:|---|---|---|
| 1 | CTRL-RR-03 | **未发现具体 bug，条件关闭** | CTRL 只 OR entry bitmap（`srcs/xx_lsu_ctrl.sv:949-989`），但 LRQ allocator 按拍前 valid 选空项，flush 拍释放的项不能同拍复用；MMU/LFB/SQ/WMB 的保存 bitmap 均在 full/check flush 时发送并清除。RTL 不必有 epoch，须断言复用前 producer 旧 owner 状态已空。 |
| 2 | DA-RR-01 | **源码已修，历史优先级改为 P1** | `lda_rb_ex3_data_ori3` 已改为选择 `lda_lwb_ex3_data3`（`srcs/xx_lsu_ld_da.sv:3438`）。原反例会把 `A/B/C/D` 变为 `A/B/C/C`，属于架构数据破坏；仍需四块互异数据的 ECC replay 回归后动态关闭。 |
| 3 | DA-RR-03 | **未发现 epoch 缺口，转为验证义务** | DA EX3 在 ECC stall 时保持同一 IID，保存数据由该 live 事务产生（`srcs/xx_lsu_ld_da.sv:3385-3415`）；RB real create 由 full/index/ECC 条件资格化（`3515-3605`），full/index 冲突显式形成 restart（`4601-4603`）。不要求硬件 epoch，仍检查每个 live transaction 恰好 accept 或 restart。 |
| 4 | DC-RR-02 | **按给定合同条件关闭** | borrow valid 与 payload gate 只有 VB/SNQ 输入不同（`srcs/xx_lsu_dcache_arb.sv:533-543`）。SNQ `req==gate`、VB `req->gate` 可推出 arbiter `borrow_vld->borrow_vld_gate`；反向 `gate->valid` 不是功能要求。 |
| 5 | DC-RR-05 | **功能关闭，确认功耗意图** | 高位 mask 只在 US 请求更新（`srcs/xx_lsu_ld_dc.sv:1409-1426`），vector-nop、四路 D-cache data 和下游 WB 的高位消费均由保存的 `inst_us` 限定（`1543-1550`、`1829-1840`；`srcs/xx_lsu_ld_wb.sv:1420-1427`、`1532-1568`）。 |
| 6 | LRQ-RR-03 | **未发现具体 bug，条件关闭** | entry valid 的 flush/create/pop 优先级与拍前分配阻止“flush 释放并同拍复用”（`srcs/xx_lsu_lrq_entry.sv:485-495`、`srcs/xx_lsu_lrq.sv:1411-1474`）；所有可见 delayed producer 均有 flush 清理。保留 owner-IID/lifetime assertion。 |
| 7 | LRQ-RR-04 | **功能关闭，确认功耗意图** | LRQ 仅对 `unit_stride && vls` create 更新高位 mask（`srcs/xx_lsu_lrq_entry.sv:467-480`）；replay 后 DC/DA/RB/WB 只在 saved `inst_us` 为 1 时锁存或消费它们。非 US 旧值是死字段。 |
| 8 | RB-RR-02 | **C910 同源已确认，系统合同仍保留** | C910 RB 同样在 WAIT_RESP/REQ_WB 遇 async flush 回 IDLE（[上游 RB entry](https://github.com/T-head-Semi/openc910/blob/b91c90914c19f114d35c8f6b73408eb241ed847c/C910_RTL_FACTORY/gen_rtl/lsu/rtl/ct_lsu_rb_entry.v#L1136-L1149)）；其 RTU 将 debug request 延迟一拍直接形成 LSU async flush（[上游 RTU](https://github.com/T-head-Semi/openc910/blob/b91c90914c19f114d35c8f6b73408eb241ed847c/C910_RTL_FACTORY/gen_rtl/rtu/rtl/ct_rtu_retire.v#L1993-L2016)），没有在该方程中使用 `lsu_rtu_all_commit_data_vld`。故必须由本工程确认 debug 停机期间旧 response 被排空/吸收且 ID 不复用。 |
| 9 | RB-RR-04 | **C910 同源已确认，固定 ID 合同仍保留** | C910 也使用未按 state 限定的 `rb_entry_biu_b_resp_set = rb_entry_b_id_hit`（[上游 RB entry](https://github.com/T-head-Semi/openc910/blob/b91c90914c19f114d35c8f6b73408eb241ed847c/C910_RTL_FACTORY/gen_rtl/lsu/rtl/ct_lsu_rb_entry.v#L1236-L1249)）；WMB 只在实际 request 后置 B-ID valid（[上游 WMB entry](https://github.com/T-head-Semi/openc910/blob/b91c90914c19f114d35c8f6b73408eb241ed847c/C910_RTL_FACTORY/gen_rtl/lsu/rtl/ct_lsu_wmb_entry.v#L2013-L2041)），BIU 则直接转发 BID（[上游 BIU](https://github.com/T-head-Semi/openc910/blob/b91c90914c19f114d35c8f6b73408eb241ed847c/C910_RTL_FACTORY/gen_rtl/biu/rtl/ct_biu_write_channel.v#L964-L1003)）。这支持“允许捕获 paired WMB 的早到 B”意图，但仍须证明同固定 ID 无无关 outstanding。 |
| 10 | WB-RR-01/02 | **仍有已确认残留** | `ld_dtu2_vld` 已加入 data clock，effect 已加入 completion clock（`srcs/xx_lsu_ld_wb.sv:1005-1008`、`1045-1049`）。但 update 寄存器自身不在 data clock enable 内（`1815-1823`）：它置 1 后在空闲期无法执行 else-clear，并持续压过 effect clear（`1677-1688`）。最小修正是让 registered update 自己打开一次 data clock，或改为可靠时钟域的一拍 pulse。 |
| 11 | WB-RR-04 | **安全关闭，活性开放** | 64 组 data + 32 组 completion 穷举均与参考 greedy allocator 一致，且 top request/grant 连线一一对应（`srcs/xx_lsu_wb_arbiter.sv:66-147`、`srcs/xx_lsu_top.sv:10594-10627`）。持续 `{lane0 busy,lane1 busy,lane2 free,WMB=1,VMB/RB=1}` 时低优先级永不获 grant，故“issue queue 最终压停高优先级”必须写成系统级 bounded-quiescence 合同，不能由该组合模块推出。 |

## 3. 无 epoch 设计的精确关闭条件

本报告中的 `generation/epoch` 是 testbench scoreboard 的观察变量，不是要求增加到 RTL 的字段。无 epoch 实现成立需要同时满足：

1. 一个 LRQ bit 从 create-accept 到 terminal pop 期间只对应一个 IID；
2. flush kill 的 bit 不能在同一拍重新分配给新事务；
3. MMU/LFB/SQ/WMB/DA/LSDA 保存的旧 owner bitmap 在该 bit 下一次 create-accept 前已经清空；
4. 任意 wakeup 必须对应当前 live entry 和其保存 IID；
5. DA→RB 每个 live miss 只能是唯一 accept 或明确 restart，不能零次接收或双收。

当前可见源码支持 1、2、3，未找到反例；4、5 跨 wrapper/验证环境，因此保持 assertion，而不是据此要求 RTL 增加 epoch。

## 4. WB halt-info 残留的逐拍反例

| 拍 | `ld_dtu2_vld` | `rb_data_halt_info_update_vld` | data clock | completion clock | 结果 |
|---|---:|---:|---|---|---|
| T0 | 1 | 0 | 开 | 关/无关 | raw event 已到达 |
| T1 边沿 | 1→0 | 0→1 | 开（由旧 `ld_dtu2_vld`） | 关/无关 | update 成功置位 |
| T2 边沿 | 0 | 保持 1 | **关** | 开（由 update） | halt-info 被重复写入；update 无时钟清零 |
| T3+ | 0 | 1 | **关** | 开 | update 分支持续优先于 effect，空闲期无法自动收敛 |

因此 Interaction 1.5 修正了“事件到不了寄存器”和“effect 无时钟”两个原始缺口，却还没有形成完整的一拍 update 生命周期。

## 5. WB arbiter 穷举与活性边界

把 lane0/1/2 的 dedicated request 视为已有占用，把 WMB、VMB、RB 按固定优先级依次放入首个空闲 lane：

- data：`2^6 = 64` 组输入，RTL 与参考模型 mismatch 为 0；
- completion：`2^5 = 32` 组输入，RTL 与参考模型 mismatch 为 0；
- 每个 shared source 至多选择一条 lane，每条 lane 至多接收一个 shared source，grant 与请求一致；
- 以上是单拍 safety/work-conservation 证明，不是跨拍 fairness 证明。

若系统希望关闭 WB-RR-04，至少要给出可验证的界 `N`：任一 WMB/VMB/RB request 持续保持时，专用 lane 流量或更高优先级 shared 流量必须在 `N` 拍内让出一个可用 lane；否则应在 arbiter 中加入 age/round-robin 机制。

## 6. 当前开放项与所需信息

| 优先级 | 项目 | 关闭条件 |
|---:|---|---|
| P1 | WB-RR-04 bounded liveness | 系统级有限流量/资源无环证明和 bounded-grant 回归，或公平仲裁修正 |
| P1 影响/合同 | CTRL-RR-03、LRQ-RR-03 owner lifetime | producer-owner assertion 与 flush→reuse 压力回归零失败；当前未确认 RTL bug |
| P1 影响/合同 | RB-RR-02 async-flush response ownership | 本工程 RTU/BIU debug-stop、drain/tombstone/ID-reuse 合同及动态验证 |
| P2 | WB-RR-01/02 halt-info 生命周期 | update 自清零且 effect 最终执行；空闲无后续流量用例通过 |
| P2 | RB-RR-04 fixed-ID ownership | paired WMB/RB 的 request/response 时序与同 ID 全局唯一 outstanding 证明 |

DA-RR-01 的源码缺陷已经修正，但其 P1 回归仍需四块互异数据覆盖；DC-RR-02、DC-RR-05、LRQ-RR-04 按 Interaction 1.5 合同功能关闭。
