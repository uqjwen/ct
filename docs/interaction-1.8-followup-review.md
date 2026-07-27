# Interaction 1.8 跟进审查总报告

## 1. 范围与结论

本轮基于提交 `4a8223a2d80a5da6a7198c6fc89d97790b9729c3` 完成 README 第 1 项的 RTU-RR-02 纠偏，以及 README 第 2 项要求的 LSU 第二轮潜在 bug 审查。审查对象为：

- `xx_lsu_ld_ag`、`xx_lsu_ld_dc`、`xx_lsu_ld_da`、`xx_lsu_ld_wb`；
- `xx_lsu_lrq`、`xx_lsu_lrq_entry`；
- `xx_lsu_rb`、`xx_lsu_rb_entry`；
- `xx_lsu_lq`、`xx_lsu_lq_entry`；
- `xx_lsu_lfb`、`xx_lsu_lfb_addr_entry`，以及顶层实际实例化但仓库缺失的 `xx_lsu_lfb_data_entry`。

核心结论：

1. 用户对 RTU-RR-02 的判断正确。此前报告没有把主要机制说清楚：`cur_pc` 是半字地址，`retire_expt_pc_high_hw_expt` 却直接在该值上 `+2`，没有先补最低位 0 恢复字节地址。该错误对跨页高半字 fault 无条件成立。
2. 以前报告强调的高半区 canonical 符号扩展问题也存在，但它是独立、配置相关的第二个缺陷，不能替代地址单位错误。
3. LSU 重审发现一个新的确定交付缺陷：`xx_lsu_lfb` 实例化两个 `xx_lsu_lfb_data_entry`，仓库没有该 module 定义，当前 LFB 源码集无法 elaboration，也无法完成 data-entry 核心状态审查。
4. 其它模块没有发现新的、可由当前静态源码独立证明的 P0 功能错误；保留既有 confirmed bug、合同风险和动态验证义务，详见各分报告。

## 2. README 第 1 项：RTU-RR-02 纠偏

### 2.1 主缺陷是半字地址没有转换为字节地址

普通取指异常 `mtval` 使用 `{rob_retire_inst0_cur_pc,1'b0}`，EPC 也补回 bit0，证明 `cur_pc` 的单位是 2-byte halfword。高半字辅助表达式却在 `srcs/xx_rtu_retire.v:3662` 直接计算：

```verilog
rob_retire_inst0_cur_pc + 64'd2
```

页末 32-bit 指令的定向例子：

| 项目 | 数值 |
|---|---:|
| 指令起始字节 PC | `0xFFE` |
| 保存的半字 `cur_pc` | `0x7FF` |
| 当前错误表达式 | `0x7FF + 2 = 0x801` |
| 正确高半字 fault VA | `{0x7FF,1'b0} + 2 = 0x1000` |

所以 README 所说“没有左移 1 位”就是 RTU-RR-02 的主要 bug。若把错误 `mtval=0x801` 交给 OS，页表处理、fault 地址判断或信号生成可能针对错误地址，应用最终可能被错误终止。

建议逻辑语义是：

```verilog
canonical_byte_pc(rob_retire_inst0_cur_pc) + 64'd2
```

其中 `canonical_byte_pc` 先拼接 `1'b0` 恢复字节地址，再根据 MMU 模式做 64-bit canonical 扩展。不要只依靠“把 2 改为 1”的代数等价写法掩盖地址单位。

### 2.2 独立的 canonical 扩展缺陷

普通 instruction fault `mtval` 和 PC 类 debug `dtval` 对高半区窄 PC 仍存在零扩展/不完整符号扩展，证据在 `srcs/xx_rtu_retire.v:2049`～`2055`、`3552`～`3561`。若产品只允许低半区地址，可用可执行范围 assertion关闭这一子项；该限制不能关闭前述跨页高半字地址单位错误。

修正后的完整分析和测试分别位于：

- `doc-rtu/xx_rtu_retire_risk_review.md`
- `doc-rtu/xx_rtu_retire_verification_focus.md`

## 3. README 第 2 项：LSU 第二轮审查结果

| 模块 | 最高开放项 | 第二轮结果 |
|---|---:|---|
| `xx_lsu_ld_ag` | P1 影响/合同 | unit-stride 一次只读一条 64-byte line；跨 line 请求必须由上游拆分合同关闭。replay `halt_info` P2 已确认仍开放。 |
| `xx_lsu_ld_dc` | P2 | `ld_dc_dtu_addr_vld` 无正常清零路径仍是已确认 bug；multi-way hit assertion 已实现，待动态运行。 |
| `xx_lsu_ld_da` | P2 | SQ-forward/ECC 冲突策略固定关闭、debug halt 辅助副作用资格化不统一，均需合同或动态验证；历史 block3 复制已修。 |
| `xx_lsu_ld_wb` | P1 影响/合同 | 未发现新增数据串线；halt-info 门控链静态闭合。shared writer bounded grant 仍需系统有限让路合同。 |
| `xx_lsu_lrq` / `xx_lsu_lrq_entry` | P2 | replay 未保存 `halt_info` 仍是已确认 bug；本地 wakeup/live assertion 已实现，精确 producer owner 仍待集成元数据。 |
| `xx_lsu_rb` / `xx_lsu_rb_entry` | P2 | create payload 串线反例关闭；response ECC 固定 0 为配置缺口；US 两拍和 response ID owner仍是合同项。 |
| `xx_lsu_lq` / `xx_lsu_lq_entry` | P2 影响/验证 | 未发现新增正确性 bug；raw create伪 full、物理 index spec-fail PC 和固定 15-bit PC 保留为 P3/配置项。 |
| `xx_lsu_lfb` / entry | P1 | 新确认 `xx_lsu_lfb_data_entry` 源码缺失，阻塞 elaboration 与完整审查；visible `xx_lsu_lfb_addr_entry` 未发现新增确定 bug。 |

### 3.1 新发现：LFB data entry 源码缺失

两个实例位于 `srcs/xx_lsu_lfb.sv:715` 和 `srcs/xx_lsu_lfb.sv:755`。全仓库没有 `module xx_lsu_lfb_data_entry`，而官方 OpenC910 对应目录确实单独提供 data-entry 文件。缺失模块承载 BIU R data/user/last、addr/data ID、full/vld/pop、refill 和 SNQ bypass 的核心状态，因此这不仅是文件清单问题，还使 response owner、flush 后迟到 response 和 entry 复用无法被当前源码证明。

关闭条件：

1. 补齐与当前 top 端口、宏和参数一致的 `srcs/xx_lsu_lfb_data_entry.sv`；
2. 加入正式 filelist并完成无 unresolved module 的 elaboration；
3. 用 `{addr_id,data_id,BIU_id,generation}` scoreboard 覆盖两 data entry、乱序响应、last/error、abort/flush 和立即复用。

### 3.2 本轮主动关闭的两个表面疑点

- AG 的 `lag_bkcon_pgfault/tlbmiss` 看似会在长 stall 被覆盖；实际捕获后它们进入 `lsu_mmu_abort`，而 `stall_vld` 要求 `!abort`，下一拍更新条件关闭，因此不是新 bug。
- RB 的 `lsda1_rb_ex3_create_judge_vld` 未参与 lane1 自身 full；full 只需为更高优先级请求预留空间，自身是否创建由后续 valid 决定，因此不是容量 bug，仅是 P3 死接口。

## 4. 分报告索引

- `doc-ag/xx_lsu_ld_ag_interaction_1_8_reaudit.md`
- `doc-dc/xx_lsu_ld_dc_interaction_1_8_reaudit.md`
- `doc-da/xx_lsu_ld_da_interaction_1_8_reaudit.md`
- `doc-wb/xx_lsu_ld_wb_interaction_1_8_reaudit.md`
- `doc-lrq/xx_lsu_lrq_interaction_1_8_reaudit.md`
- `doc-rb/xx_lsu_rb_interaction_1_8_reaudit.md`
- `doc-lq/xx_lsu_lq_interaction_1_8_reaudit.md`
- `doc-lfb/xx_lsu_lfb_interaction_1_8_reaudit.md`

## 5. 静态证据与动态边界

本轮完成源码数据流、地址单位、位宽、lane/entry 对称性、create 分层、状态/门控和固定 OpenC910 参考版本的静态复核；仓库没有可运行的完整 RTL filelist/testbench，常用 HDL simulator/lint 工具也不可用，所以没有伪造动态通过结论。

动态签核至少需要：

1. RTU 页末 `0xFFE -> 0x1000` 的 instruction fault、canonical 高/低半区和 MMU on/off 矩阵；
2. LFB 补齐 data entry后的 elaboration 与 response-owner 压力回归；
3. AG unit-stride 跨 64-byte line 的 producer split assertion或双 line实现验证；
4. DC debug valid 单拍、DA ECC/forward、WB ICG、LRQ wakeup owner、RB beat/ID、LQ pop generation 的定向 assertion。

在这些动态关闭条件完成前，“静态未发现新增”不能解释为模块已经签核。
