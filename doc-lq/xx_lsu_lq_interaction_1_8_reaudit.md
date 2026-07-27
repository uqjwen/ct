# `xx_lsu_lq` / `xx_lsu_lq_entry` Interaction 1.8 第二轮设计审查

## 1. 范围与基线

- 审查基线：`4a8223a2d80a5da6a7198c6fc89d97790b9729c3`。
- 审查对象：`xx_lsu_lq`、`xx_lsu_lq_entry` 的三 lane allocation/payload、age vector、RAR/RAW、snoop、flush/pop 与 spec-fail PC。
- 重新检查 pointer 重合时的 DP/function owner、迟到 pop、固定宽度和多匹配选择。
- 当前无动态 LQ/LSDA 环境，报告为静态审查。

## 2. 结论

| ID | 优先级 | 状态 | 结论 |
|---|---:|---|---|
| LQ-I18-01 | — | 未发现新增，正确性关闭 | lane3 pointer 与 payload 优先级在合法 producer 蕴含下不会串 owner。 |
| LQ-I18-02 | P3 | 已确认，性能项 | flush-killed 的前序 raw create 仍参与后续 lane 容量预留，可制造保守伪 full。 |
| LQ-I18-03 | P3 | 已确认权衡 | 多个 spec-fail 同拍时返回最低物理 index PC，而不是年龄最老 PC。 |
| LQ-I18-04 | P2 影响 | 验证义务 | restart-pop 不带 generation；可见三 lane生产链未发现迟到 pop，但仍需 owner assertion。 |
| LQ-I18-05 | P3 | 已确认，参数约束 | PC 固定 15 bit，没有与顶层 `PC_LEN` 的静态一致性检查。 |

## 3. 详细复核

### LQ-I18-01：pointer/DP payload 串线未复现

三 lane success/full 方程位于 `srcs/xx_lsu_lq.sv:559`～`587`；真实 create、DP 和 gate vectors 位于 `srcs/xx_lsu_lq.sv:590`～`626`。entry payload按 lane0→lane2→lane3 选择（`srcs/xx_lsu_lq_entry.sv:266`～`310`）。只剩 1/2 项时，高优先级 raw create 会让低优先级 success 失败；高优先级若被 partial flush kill，低优先级也保守重试，不会成功后采样错误 payload。

### LQ-I18-02：raw create 造成伪 full

lane2/3 的 success/full 仍使用未经过 partial-flush kill 的前序 raw create（`srcs/xx_lsu_lq.sv:572`～`587`、`698`～`713`）。这不会丢失存活事务，但可能让本可成功的 older lane 多重试一拍；重复冲突时应验证前进性。

### LQ-I18-03：spec-fail 选择是物理优先级

top 对每 lane 的 violation bitmap做 first-one，并返回最低 index entry 的 PC（`srcs/xx_lsu_lq.sv:660`～`687`）。若接口合同允许返回任一违规 PC，则是已接受的性能权衡；若要求 oldest offender，则需要用 age vector 选择。

### LQ-I18-04：pop owner 需要动态固化

entry valid 清除优先于 create（`srcs/xx_lsu_lq_entry.sv:249`～`261`），commit hit 受 live/IID 资格化，但 DA restart-pop bitmap直接 OR 入（`srcs/xx_lsu_lq_entry.sv:345`～`375`）。可见 LD/LSDA producer都只对 live DA 和保存 pointer 产生 pop，拍前 allocator也不会同拍复用正在 pop 的 live entry；静态未找到具体 bug，保留验证义务。

### LQ-I18-05：固定 PC 宽度

entry payload把 PC 固定为 15 bit，例如 `srcs/xx_lsu_lq_entry.sv:275`、`283`～`309`。正式 `PC_LEN=15` 时功能成立，非默认参数可能静默截断。

## 4. 动态关闭条件

- LQ-I18-01：枚举 0/1/2/3 空位、三 lane raw/DP/function 与 partial flush，检查 winner pointer onehot且 payload owner一致。
- LQ-I18-02：持续 partial-flush/三 lane竞争下证明每个未 flush 请求在有限拍内成功或被合法重启。
- LQ-I18-03：记录多匹配率；若规格要求 oldest，用软件 age model逐拍比对返回 PC。
- LQ-I18-04：以 `{lane,lq_id,IID,generation}` 检查 `restart_pop -> live matching owner`，覆盖 flush→最早复用。
- LQ-I18-05：增加 `PC_LEN==15` 静态 assertion，或参数化全部 PC 字段。
