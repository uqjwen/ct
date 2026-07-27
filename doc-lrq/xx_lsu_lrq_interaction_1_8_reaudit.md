# `xx_lsu_lrq` / `xx_lsu_lrq_entry` Interaction 1.8 第二轮设计审查

## 1. 范围与基线

- 审查基线：`4a8223a2d80a5da6a7198c6fc89d97790b9729c3`。
- 审查对象：`xx_lsu_lrq`、`xx_lsu_lrq_entry`，覆盖三 bank allocation/age/issue、create/pop、freeze/wakeup、replay payload、flush/reuse 和停用 PA cache。
- 重新核对每个 replay 字段的 create→entry→read-data→AG 链，并检查三 bank 对称性和 owner 生命周期。
- 无完整 producer owner metadata 与仿真环境，动态签核未完成。

## 2. 结论

| ID | 优先级 | 状态 | 结论 |
|---|---:|---|---|
| LRQ-I18-01 | P2 | 已确认，仍开放 | `xx_lsu_lrq_entry` 未保存 `halt_info`，replay 的 debug metadata 仍可能来自当前 IDU owner。 |
| LRQ-I18-02 | P1 影响 | 合同依赖/验证义务 | 本地 assertion 已覆盖 wakeup 指向 live entry 和 create 拍无旧 wakeup；精确 producer-owner IID 仍不可见。 |
| LRQ-I18-03 | P3 | 已确认，清理项 | PA/属性 cache 的输入端口保留，但 entry 存储全部注释，read payload固定为无效/0。 |
| LRQ-I18-04 | P3 | 已确认，参数约束 | `LRQENTRY>=LSIQENTRY` 及正式配置相等关系没有 elaboration assertion。 |

本轮未发现新增的 bank 碰撞、age 方向颠倒或 payload bit-slice 串线。

## 3. 详细复核

### LRQ-I18-01：replay 缺少原事务 halt-info

entry create payload在 `srcs/xx_lsu_lrq_entry.sv:366`～`480` 保存地址、IID、PC、mask、vector 和控制字段，但没有 `halt_info`。replay mux 从 `srcs/xx_lsu_lrq.sv:1819` 起恢复这些字段，同样没有 debug metadata 输出。结果是 AG replay 只能继续使用当前 IDU 侧输入。该项是已确认 P2 debug 功能缺陷。

### LRQ-I18-02：本地生命周期检查已实现，精确 owner 仍需 producer 元数据

三 bank 的 create 与 flush kill 位于 `srcs/xx_lsu_lrq.sv:1443`～`1474`。`srcs/xx_lsu_lrq.sv:1476`～`1523` 已生成六组 assertion，检查 wakeup 只能命中 live entry、accepted create 不能与旧可见 wakeup 同拍。由于输入只有 bitmap、没有 producer IID/pending generation，这些 assertion 不能证明 `producer_owner_iid == entry_iid`，所以保持验证义务而不是要求 RTL 必须增加 epoch。

### LRQ-I18-03：PA cache 是半删除接口

`xx_lsu_lrq_entry` 的 PA valid/address/attribute 寄存逻辑全部停用（`srcs/xx_lsu_lrq_entry.sv:825`～`850`），read payload在 `srcs/xx_lsu_lrq_entry.sv:927`～`929` 固定输出无效和 0。当前设计等价于 replay 重新访问 MMU，功能可成立；保留输入/内部声明只增加误接风险。

### LRQ-I18-04：参数关系缺少静态保护

replay ID 扩展直接使用 `{{LRQENTRY-LSIQENTRY{1'b0}}, ...}`，例如 `srcs/xx_lsu_lrq.sv:1881`。当 `LRQENTRY<LSIQENTRY` 时表达式非法；正式设计还要求两者相等。应在 elaboration 阶段明确失败，而不是只靠集成约定。

## 4. 动态关闭条件

- LRQ-I18-01：把 `halt_info` 加入 create/read payload，replay 与另一 IDU 请求使用互异值，AG/DTU 输出必须属于原 owner。
- LRQ-I18-02：验证环境为 MMU/LFB/SQ/WMB wakeup 导出 `{entry_id, producer_iid, generation}`，断言 owner 一致；跑 flush→立即复用压力序列。
- LRQ-I18-03：删除 PA cache 残留，或加入 compile-time configuration 并分别验证 cache on/off。
- LRQ-I18-04：增加静态 assertion，支持组合通过，不支持组合在 elaboration 明确失败。
