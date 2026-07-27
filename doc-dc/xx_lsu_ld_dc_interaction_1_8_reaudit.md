# `xx_lsu_ld_dc` Interaction 1.8 第二轮设计审查

## 1. 范围与基线

- 审查基线：`4a8223a2d80a5da6a7198c6fc89d97790b9729c3`。
- 审查对象：`xx_lsu_ld_dc` 的 EX1→EX2 保存、borrow owner、D-cache tag/data、LQ create、restart、unit-stride metadata 和 debug 地址通道。
- 对 raw/DP/function valid、旧字段保留、组合 OR/mux、lane/way 复制与门控更新逐项复查。
- 无完整 elaboration/testbench，本报告为静态结论。

## 2. 结论

| ID | 优先级 | 状态 | 结论 |
|---|---:|---|---|
| DC-I18-01 | P2 | 已确认，仍开放 | `ld_dc_dtu_addr_vld` 只有 reset 和置 1 路径，没有正常清零，debug 地址请求可重复保持。 |
| DC-I18-02 | P1 影响 | 验证义务 | 多 way tag hit 已有 `$onehot0` RTL assertion；设计错误检测已就地实现，但尚无动态运行证据。 |
| DC-I18-03 | — | 合同依赖，功能关闭 | borrow 正确功能合同是 `valid -> gate`，gate-only 只保守开 payload 时钟，不会建立有效 owner。 |
| DC-I18-04 | P3 | 未发现新增功能错误 | 非 unit-stride 不更新高三组 mask 是功耗意图；所有已检查消费者均以 `inst_us` 资格化。 |

第二轮未发现新增 P0/P1 正确性 bug；已确认的 DC-I18-01 仍未修改。

## 3. 详细复核

### DC-I18-01：debug valid 粘住

payload 只在新 debug 地址请求时更新（`srcs/xx_lsu_ld_dc.sv:2251`～`2273`）。`ld_dc_dtu_addr_vld` 的寄存器在 `srcs/xx_lsu_ld_dc.sv:2275`～`2285` 只有 reset 清零和请求时写 1，没有对应的 `else` 清零或消费者握手。一次合法请求之后，valid 可持续为 1，并让后级把旧地址当成连续请求。

建议把它实现为严格一拍 pulse，或增加 ready/accept 后清零；修复时 payload 与 valid 必须同一 owner。

### DC-I18-02：tag multi-hit 由本地 assertion 检测

四路命中在 `srcs/xx_lsu_ld_dc.sv:1909`～`1918` 形成；`srcs/xx_lsu_ld_dc.sv:1920`～`1929` 已对 live、cacheable、D-cache enabled 的访问断言 `$onehot0(ldc_hit_way)`。0-hit 合法，2～4 hit 会直接报告。该措施能避免仅靠最终数据错间接发现 duplicate tag，但没有仿真结果前只能标为验证义务。

### DC-I18-03：borrow gate-only 不会污染功能 owner

borrow payload 的保存受真实 borrow valid 资格化，见 `srcs/xx_lsu_ld_dc.sv:1215`～`1248`；进入 DA 的指令有效又统一受 restart 屏蔽（`srcs/xx_lsu_ld_dc.sv:1845`～`1846`）。因此 producer 提供 `borrow_vld -> borrow_vld_gate` 即足够；反向不成立只会多开钟，不会消费旧 payload。

### DC-I18-04：US-only 旧 mask 是非适用字段

高三组 mask 只在 live unit-stride 事务时更新（`srcs/xx_lsu_ld_dc.sv:1409`～`1426`），vector-nop 判断也只有 `inst_us` 才读取四组（`srcs/xx_lsu_ld_dc.sv:1543`～`1550`）。本轮再次沿 DA/RB/WB 追踪，未发现非 US 读取高三组旧值的路径。

## 4. 动态关闭条件

- DC-I18-01：跑 `debug / normal / debug` 连续序列，断言每次 request 只出现一个 valid pulse，空闲拍 valid 为 0，flush 后无迟到旧地址。
- DC-I18-02：在完整 cache 一致性环境运行 assertion，并做 duplicate-tag 负向注入证明 2～4 hit 均可见。
- DC-I18-03：断言每个 borrow source `valid -> gate`，并用互异 payload 检查 gate-only 拍不进入 DA。
- DC-I18-04：断言 `!inst_us` 时高三组 mask 不影响 vector-nop、data enable、RB payload 或 WB byte enable。
