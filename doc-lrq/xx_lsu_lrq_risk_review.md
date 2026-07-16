# `xx_lsu_lrq` / `xx_lsu_lrq_entry` 设计风险审查

## 1. 范围与结论

本轮基于提交 `9928a13`，审查三组独立 LRQ bank 的 create、freeze、wakeup、issue、pop、flush、age-vector 和 replay payload，并沿 `xx_lsu_top` 追到 AG/controller。当前仓库没有仿真清单、helper、IDU、MMU 或 SFP 源码，因此合同项不能由本仓库单独关闭。

未发现三 bank 之间的直接分配碰撞：每个 bank 有独立 valid/free pointer，跨 bank 只共享全局年龄关系。保留 1 个已确认调试功能问题、2 个合同依赖的事务风险和 2 个清理/配置问题。

| ID | 优先级 | 置信度 | 状态 | 摘要 |
|---|---:|---|---|---|
| LRQ-RR-01 | P2 | 已确认 | 开放 | replay 未保存 `halt_info`，AG 改取当前 IDU 总线 |
| LRQ-RR-02 | P1 | 合同依赖 | 条件关闭 | create 在 full 时没有本地拒绝，且 raw create 仍可 pop IDU |
| LRQ-RR-03 | P1 | 合同依赖 | 条件关闭 | flush 后 LRQ bit 复用依赖 MMU 同步删除旧 pending/wakeup |
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

正常路径用 `lrq*_no_space` 阻止 RF issue（`srcs/xx_lsu_lrq.sv:1628-1683`），所以本项可按“任何 create 都来自先前被容量检查接受的唯一事务”条件关闭。但必须断言 `lsu*_lrq_create_vld |-> |lrq*_create_ptr0`，并把 pop 改为 `create_success` 会更稳健。

### LRQ-RR-03：旧 MMU wakeup 与 entry 复用

entry 只按 bit 接受 controller/MMU wakeup（`srcs/xx_lsu_lrq_entry.sv:695-704`、`srcs/xx_lsu_lrq_entry.sv:769-822`），没有 generation/epoch。full/partial flush 又会直接清 valid，随后该 bit 可再次分配。因此 correctness 依赖 interaction 1.1.2 的外部合同：MMU 在 bit 复用前删除匹配 pending，且被 kill lsid 永不产生迟到 async wakeup。当前仓库无 MMU 源码，需在集成层用 `{lane, lrqid, flush_epoch}` scoreboard 证明。

### LRQ-RR-04：非适用 payload 保留旧 entry 数据

`bytes_vld2/3` 和 `reg_bytes_vld1/2/3` 只在 `unit_stride && vls` create 时更新；其他 create 不清零（`srcs/xx_lsu_lrq_entry.sv:467-480`）。只要消费者严格以 saved `inst_vls/unit_stride` 资格化，这些旧值是死字段；否则 entry 复用后会把前一事务 mask 带入 replay。建议每次 create 都确定化，或绑定“不适用字段不可消费”的断言。

### LRQ-RR-05：固定参数关系没有 elaboration 保护

replay lch entry 用 `{{LRQENTRY-LSIQENTRY{1'b0}}, ...}` 扩展（`srcs/xx_lsu_lrq.sv:1832`、`srcs/xx_lsu_lrq.sv:1917`、`srcs/xx_lsu_lrq.sv:2002`），要求 `LRQENTRY>=LSIQENTRY`；top 的默认配置令二者相等（`srcs/xx_lsu_top.sv:27-42`）。建议增加静态 assertion，避免非法参数静默失败。

## 4. 结构检查结论

三组 `xx_lsu_lrq_entry` generate 实例的 named-port 集合一致；lane0/2/3 的 create、wakeup、secd、already_da、spec_fail 与 pop 均按本 bank one-hot 展开（`srcs/xx_lsu_lrq.sv:968-1388`）。本轮未发现漏接、重复端口或 bank 交叉接错。该结论是文本结构检查，不替代完整工程 elaboration。

## 5. 修正顺序

1. 补齐 LRQ-RR-01 `halt_info`。
2. 将 IDU pop 和 age update 收敛到真实 `create_accept`，并增加 create-pointer 非零断言。
3. 在 MMU/SFP 完整工程绑定 flush epoch、no-spec 所有权和 vector helper 等价断言。
4. 清零条件 payload并增加参数静态检查。
