# `xx_lsu_ld_da` Interaction 1.8 第二轮设计审查

## 1. 范围与基线

- 审查基线：`4a8223a2d80a5da6a7198c6fc89d97790b9729c3`。
- 审查对象：`xx_lsu_ld_da` 的数据选择/ECC、SQ/WMB forward、RB create/merge、LQ pop、completion/data writeback、debug cancel、prefetch/no-spec 副作用。
- 重点重新检查 512-bit block 索引、保存/重放 owner、raw/DP/function valid 蕴含和 cancel 资格化。
- 仓库缺少可执行 DA 环境，结论为静态审查。

## 2. 结论

| ID | 优先级 | 状态 | 结论 |
|---|---:|---|---|
| DA-I18-01 | P1 历史影响 | 源码已修，验证义务 | ECC replay 的第 4 个 128-bit block 已选择 `data3`，不再复制 block2；仍缺动态回归。 |
| DA-I18-02 | P2 | 合同依赖，开放 | 注释要求 SQ forward 时取消/丢弃 ECC stall，但活动实现把 `ld_da_sq_fwd_ecc_discard` 固定为 0。 |
| DA-I18-03 | P2 | 合同依赖，开放 | debug address halt 对主要功能 side effect 使用 cancel 后信号，prefetch/no-spec 等辅助输出的资格化仍不统一。 |
| DA-I18-04 | — | 未发现新增 | RB judge→DP→function create 的收紧关系成立；stall 保存数据仍归属同一 live EX3 owner。 |

本轮未发现新的、可独立于现有 DA-I18-02/03 证明的 P0/P1 bug。

## 3. 详细复核

### DA-I18-01：四块 ECC replay 修复存在但未动态关闭

保存寄存器分别锁存四个互异 128-bit block（`srcs/xx_lsu_ld_da.sv:3385`～`3403`），恢复选择在 `srcs/xx_lsu_ld_da.sv:3435`～`3438` 已正确使用 `data0/data1/data2/data3`。历史错误会把 `A/B/C/D` 变成 `A/B/C/C`；当前静态表达式已修，但没有门控时钟波形和 ECC replay 回归，状态仍为验证义务。

### DA-I18-02：SQ forward/ECC 冲突策略仍被 tie-off

源码注释说明 WMB forward 可 stall，而 SQ forward 应取消 ECC stall；紧随其后的活动赋值却是常 0（`srcs/xx_lsu_ld_da.sv:4726`～`4739`）。如果系统保证 SQ forward 与可恢复 ECC stall 互斥，本项可用 assertion 关闭；否则必须明确是丢弃、重放还是合并，不能默认让 cache replay 数据与 SQ owner 关系自行成立。

### DA-I18-03：debug cancel 对辅助副作用不统一

主 RB create、cache-buffer、writeback data 和 spec-fail 路径使用 `ld_da_expt_vld_cancel` 资格化，例如 `srcs/xx_lsu_ld_da.sv:3515`～`3529`、`4883`～`4891`、`4986`～`5000`。但 prefetch 输出仍检查原始 `ld_da_expt_ori`（`srcs/xx_lsu_ld_da.sv:4902`～`4922`），而 cancel 版本把 `dtu_lsu_addr_halt_info[0]` 合入异常/取消条件（`srcs/xx_lsu_ld_da.sv:5413`～`5420`）。no-spec 分类也直接由 live EX3 条件形成（`srcs/xx_lsu_ld_da.sv:5318`～`5372`）。

这是否为功能错误取决于 debug halt 时允许保留哪些训练/prefetch side effect；没有书面副作用合同前保持 P2 合同依赖。

### DA-I18-04：create 分层与 live owner 复核

RB judge 是最宽条件（`srcs/xx_lsu_ld_da.sv:3515`～`3520`），DP 等于经过 flush/fence/ECC 等条件的 unmask create（`srcs/xx_lsu_ld_da.sv:3522`～`3543`、`3603`），function create 再屏蔽 ECC mask 与 index discard（`srcs/xx_lsu_ld_da.sv:3599`～`3601`）。第二轮没有发现 DP/function 反向或 payload owner 串线。

## 4. 动态关闭条件

- DA-I18-01：三 lane、四块互异数据、16 bank、tag/data ECC 与 1/N 拍 stall 全交叉，scoreboard 逐 bit 比较 `A/B/C/D`。
- DA-I18-02：证明 `SQ_forward && recoverable_ECC_stall` 不可达；若可达，给出唯一重放/丢弃策略并验证每事务恰好一个终态。
- DA-I18-03：列出 debug address halt 允许/禁止的全部 side effect，对 RB/WB/LQ/cache-buffer/prefetch/no-spec/HPCP 逐项断言。
- DA-I18-04：断言 `function_create -> DP -> judge`，并以 `{lane,IID,observer_generation}` 检查 accept XOR restart。
