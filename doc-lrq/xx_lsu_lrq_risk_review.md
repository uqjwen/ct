# `xx_lsu_lrq` / `xx_lsu_lrq_entry` 设计风险审查

## 1. 范围与结论

本轮基于提交 `a81c012` 完成初审，并在 Interaction 1.4 提交 `6260f4a` 上复核三组独立 LRQ bank 的 create、freeze、wakeup、issue、pop、flush、age-vector 和 replay payload。新增 MMU/LFB/SQ/WMB/LSDA 源码已纳入 flush-epoch 追踪；仿真清单、helper、IDU/SFP 与完整集成 testbench 仍缺失。

未发现三 bank 之间的直接分配碰撞：每个 bank 有独立 valid/free pointer，跨 bank 只共享全局年龄关系。保留 1 个已确认调试功能问题、2 个合同依赖的事务风险和 2 个清理/配置问题。

| ID | 优先级 | 置信度 | 状态 | 摘要 |
|---|---:|---|---|---|
| LRQ-RR-01 | P2 | 已确认 | 开放 | replay 未保存 `halt_info`，AG 改取当前 IDU 总线 |
| LRQ-RR-02 | P1 | 合同依赖 | 条件关闭待断言 | no-space 预留和 flush 同步 kill 保证 create/pop 原子性 |
| LRQ-RR-03 | P1 | 源码+合同 | 源码缩小，边界待断言 | MMU/LFB/SQ/WMB 本地 flush 后清 bitmap；LRQ 无 generation tag，仍需集成 epoch 证明 |
| LRQ-RR-04 | P3 | 已确认 | 清理项 | 条件 payload 在非 US create 时保留上个 entry 的旧值 |
| LRQ-RR-05 | P3 | 已给定配置 | 约束项 | 多处表达式要求 `LRQENTRY>=LSIQENTRY`，正式配置又要求二者相等 |

## 2. Entry 生命周期与优先级

- valid 优先级为 reset → full flush → partial flush → create → pop（`srcs/xx_lsu_lrq_entry.sv:485-495`），所以被 flush 的旧事务不能被同拍 create 复活。
- issue grant 将 entry 置 frozen；内部全部等待条件解除或 controller/MMU wakeup 才清 frozen（`srcs/xx_lsu_lrq_entry.sv:769-822`）。create 优先于 issue，issue 优先于普通 wakeup。
- ready 为 `vld && !frz`，并用 local age-vector 选本 bank 最老项（`srcs/xx_lsu_lrq_entry.sv:853-859`）；三 bank 的 issue 独立，跨 bank 年龄只参与 barrier/old 判定。
- create 与 pop 同拍时，free pointer基于拍前 valid，已占 entry 不会被同拍复用；吞吐少一拍但没有直接覆盖。

## 3. 详细风险

### LRQ-RR-01：replay 的调试 metadata 缺失

LRQ entry 的 create payload 与 read payload覆盖地址、IID、PC、寄存器、split/vector 和 replay 状态（`srcs/xx_lsu_lrq_entry.sv:366-465`、`srcs/xx_lsu_lrq_entry.sv:871-929`），但没有 `halt_info`。top 在 AG 端把 `idu_lsu_rf_halt_info` 直接接当前 IDU 总线（`srcs/xx_lsu_top.sv:5392-5395`），AG 在 replay 有效时仍锁存并产生调试请求（`srcs/xx_lsu_ld_ag.sv:3102-3135`）。

触发条件是 replay 与另一条 IDU 候选指令同拍，或 IDU payload 无效。结果是被 replay load 漏报/误报 trigger，或携带另一事务的 halt 上下文。应把 `halt_info` 纳入 LRQ payload，或提供按 LRQ ID 索引的专用调试 metadata。

### LRQ-RR-02：容量安全完全依赖上游合同

`lrq*_create_success` 只检查 create 与 flush，不检查 `lrq*_full`（`srcs/xx_lsu_lrq.sv:1444-1474`）。full 时 free pointer 为全 0，因而 create vector 为 0；与此同时 IDU pop 使用 raw `lsu*_lrq_create_vld`（`srcs/xx_lsu_lrq.sv:1692-1708`）。如果上游在 full 拍产生 create，请求会被 pop 却没有 entry 接收。

正常路径用 `lrq*_no_space` 阻止 RF issue（`srcs/xx_lsu_lrq.sv:1628-1683`），Interaction 1.3 又明确 fresh 请求在进入 AG 前已经预留容量，所以本项可按“任何 create 都来自先前容量检查接受的唯一事务”条件关闭。create-success 相比 raw create 只额外过滤 full/check flush；IDU pop 仍用 raw create（`srcs/xx_lsu_lrq.sv:1692-1708`），因此 flush 同拍依赖上游对应项也被同一 flush 无效化。必须断言 `raw create && !flush -> onehot(ptr)`、`raw create && flush -> upstream killed`；把 IDU pop 直接收敛到真实 create-accept 仍会更稳健。

### LRQ-RR-03：旧 MMU wakeup 与 entry 复用

entry 只按 bit 接受 controller/MMU wakeup（`srcs/xx_lsu_lrq_entry.sv:695-705`、`srcs/xx_lsu_lrq_entry.sv:769-822`），没有 generation/epoch；full/partial flush 清 valid 后该 bit 可再次分配。Interaction 1.3 已明确 MMU 在 flush 时删除旧 pending，且 entry bit 在事务 DA 终止/不再重发前唯一对应 IID。

本轮逐一检查可见实现，没有发现违反该守则的本地路径：

- DA 的 already-da、pop、spec-fail、secd 均由 live `lda_ex3_inst_vld` 与保存的 LSID 形成 one-hot/bitmap（`srcs/xx_lsu_ld_da.sv:5167-5223`）；full/check flush 会清 DA stage valid（`srcs/xx_lsu_ld_da.sv:1981-2012`）。
- DA pop entry 本身已由 `pop_vld` 掩码（`srcs/xx_lsu_ld_da.sv:5195-5202`），LRQ 虽直接使用 vector bit清 valid（`srcs/xx_lsu_lrq.sv:1059`、`srcs/xx_lsu_lrq_entry.sv:485-495`），不会看到未资格化的 LD pop。
- 新 create 在 LRQ entry valid 更新中优先于 pop；allocator 又按拍前 valid 选空项，所以正常 live pop 不会同拍复用其 entry（`srcs/xx_lsu_lrq_entry.sv:485-495`）。

Interaction 1.4 补齐的 producer 进一步缩小了本项：

- MMU TMQ entry 保存 IID 与三 lane LSID；check-flush 会按 IID 清 entry/request，`rtu_ck_flush` 拍汇总所有 live LSID 发 wakeup，entry 内 LSID 同拍清零（`srcs/mmu/xx_mmu_dutlb_tmq_entry.sv:141-180`、`193-228`，`srcs/mmu/xx_mmu_dutlb_tmq.sv:593-601`）。
- LFB 在 check-flush 拍输出保存与同拍新增 bitmap，下一拍清零；full flush 直接清零（`srcs/xx_lsu_lfb.sv:1543-1598`）。
- SQ 与 WMB 的 global/data dependency queue 采用同类“flush 拍发送、下一拍清空”结构（`srcs/xx_lsu_sq.sv:2505-2576`、`srcs/xx_lsu_wmb.sv:3602-3633`、`3747-3777`）。

因此没有发现这些 producer 在 flush 后继续保存旧 entry bit 的本地路径。需要注意，LRQ 的“释放”条件在源码中仍是 DA terminal/non-restart pop，而不是所有类型都先看到 WB completion；consumer 也仍没有 generation tag。故本项从“producer 缺失”改为“本地源码缩小、集成 epoch assertion 必需”，用 `{lane,lrqid,IID,flush_epoch}` scoreboard 验证 bit 复用边界。

### LRQ-RR-04：非适用 payload 保留旧 entry 数据

`bytes_vld2/3` 和 `reg_bytes_vld1/2/3` 只在 `unit_stride && vls` create 时更新；其他 create 不清零（`srcs/xx_lsu_lrq_entry.sv:467-480`）。只要消费者严格以 saved `inst_vls/unit_stride` 资格化，这些旧值是死字段；否则 entry 复用后会把前一事务 mask 带入 replay。建议每次 create 都确定化，或绑定“不适用字段不可消费”的断言。

### LRQ-RR-05：固定参数关系没有 elaboration 保护

replay lch entry 用 `{{LRQENTRY-LSIQENTRY{1'b0}}, ...}` 扩展（`srcs/xx_lsu_lrq.sv:1832`、`srcs/xx_lsu_lrq.sv:1917`、`srcs/xx_lsu_lrq.sv:2002`），要求 `LRQENTRY>=LSIQENTRY`；top 的默认配置令二者相等（`srcs/xx_lsu_top.sv:27-42`）。建议增加静态 assertion，避免非法参数静默失败。

## 4. 结构检查结论

三组 `xx_lsu_lrq_entry` generate 实例的 named-port 集合一致；lane0/2/3 的 create、wakeup、secd、already_da、spec_fail 与 pop 均按本 bank one-hot 展开（`srcs/xx_lsu_lrq.sv:968-1388`）。本轮未发现漏接、重复端口或 bank 交叉接错。该结论是文本结构检查，不替代完整工程 elaboration。

## 5. 修正顺序

1. 补齐 LRQ-RR-01 `halt_info`。
2. 将 IDU pop 和 age update 收敛到真实 `create_accept`，并增加容量预留/flush-kill 断言。
3. 在已补齐的 MMU/LFB/SQ/WMB 与 LRQ 边界绑定 flush epoch、entry-bit/IID 所有权；另补 IDU/SFP 合同。
4. 清零条件 payload并增加参数静态检查。
