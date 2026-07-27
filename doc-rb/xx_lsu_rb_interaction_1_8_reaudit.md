# `xx_lsu_rb` / `xx_lsu_rb_entry` Interaction 1.8 第二轮设计审查

## 1. 范围与基线

- 审查基线：`4a8223a2d80a5da6a7198c6fc89d97790b9729c3`。
- 审查对象：`xx_lsu_rb`、`xx_lsu_rb_entry`，覆盖三 lane create/full/payload、merge、状态机、BIU/LFB ID、US 两拍 response、B response、ECC 和 flush。
- 重点重做“judge/DP/function valid 不同严格程度”下的容量边界与 payload owner 分析。
- 对照官方 OpenC910 固定提交 `b91c90914c19f114d35c8f6b73408eb241ed847c` 的同源状态机；无动态总线环境。

## 2. 结论

| ID | 优先级 | 状态 | 结论 |
|---|---:|---|---|
| RB-I18-01 | — | 未发现新增，反例关闭 | lane3 的 full/pointer 与 entry payload 优先级没有形成“低优先级成功却采样高优先级失败 payload”的可达反例。 |
| RB-I18-02 | P2 | 已确认，配置相关 | R-response ECC 永久固定为 0，MCIC 无法从 RB 收到 response ECC error。 |
| RB-I18-03 | P2 | 合同依赖 | unit-stride 完成只使用 1-bit beat counter，不检查 `r_last`；依赖 BIU 恰好两拍。 |
| RB-I18-04 | P2 影响 | 合同依赖/条件豁免 | async flush 和固定 B-ID 行为与 C910 同源，但可恢复 resume/ID 复用仍要求系统 owner 合同。 |
| RB-I18-05 | P3 | 已确认，清理项 | `lsda1_rb_ex3_create_judge_vld` 是未消费接口；它不影响 lane1 自身 full 的正确计算。 |

## 3. 详细复核

### RB-I18-01：create payload 串线反例仍不可达

容量方程在 `srcs/xx_lsu_rb.sv:1460`～`1474` 只为当前 lane 预留拍前空位及更高优先级 judge 请求；当前 lane 的自身 judge 不需要加入自身 full。真实 create vectors 又用 pointer、`!full` 和各 lane DP valid 资格化（`srcs/xx_lsu_rb.sv:1493`～`1535`）。entry payload按 LD0→LS0→LS1 的 per-entry DP 顺序选择，见 `srcs/xx_lsu_rb_entry.sv:1097`～`1200`。

只剩一项时，LS0 DP 蕴含 LS0 judge，LS1 full 必定拉高；两项边界也由更高优先级 judge 组合预留。因此没有出现低优先级 function create 成功而同 entry 高优先级 DP 仍有效的情形。仍应保留 `function -> DP -> judge` 和 winner/payload identity assertion。

### RB-I18-02：response ECC 路径固定关闭

`rb_r_resp_ecc_err` 在 `srcs/xx_lsu_rb.sv:2241`～`2245` 固定为 0，`rb_mcic_ecc_err` 在 `srcs/xx_lsu_rb.sv:2309`～`2312` 直接取该值。若 BIU 没有 response ECC，这只是配置；若 MCIC 规格要求端到端报告，则是已确认缺口。

### RB-I18-03：US response 依赖两拍合同

entry 首次 matching response 后把 `rb_entry_us_cnt` 置 1（`srcs/xx_lsu_rb_entry.sv:1359`～`1370`），完成条件要求下一次 response 时旧 counter 为 1（`srcs/xx_lsu_rb_entry.sv:2060`～`2065`）。接口不检查 `r_last`，因此缺拍、多拍、重放都无法由本模块诊断，必须由 BIU 协议 assertion 关闭。

### RB-I18-04：继承行为的豁免边界

WAIT_RESP/REQ_WB 可在 async flush 直接回 IDLE（`srcs/xx_lsu_rb_entry.sv:1919`～`1934`）；B response set 又只按 ID hit（`srcs/xx_lsu_rb_entry.sv:2045`～`2067`）。不可恢复的 hung-outstanding debug 入口可按既有合同豁免；若不复位 interconnect 就 resume，旧 response 命中新 owner 的风险重新开放。

### RB-I18-05：lane1 judge 未使用不是容量 bug

`lsda1_rb_ex3_create_judge_vld` 只在接口声明，活动 full 方程不消费它。原因是 lane1 full 只需计算“在高优先级 lane 请求后是否还给自己剩一项”；自身是否真正请求由后续 create valid 决定。该端口可删除或用于接口 assertion，作为 P3 清理项。

## 4. 动态关闭条件

- RB-I18-01：穷举 0/1/2/3 空位、三 lane judge/DP/function 合法组合，断言每个 successful entry 的 payload owner唯一。
- RB-I18-02：明确 BIU ECC 配置；有 ECC 时接入并注错，无 ECC 时用静态配置 assertion/waiver。
- RB-I18-03：断言 US response 对该 ID 恰好两拍且第二拍 `last=1`，负向缺拍/多拍必须在边界报错。
- RB-I18-04：分别验证不可恢复 debug 与可恢复 resume；后者必须有 drain/tombstone/ID generation。
- RB-I18-05：删除死端口，或断言 lane1 function create 必然蕴含其 judge。
