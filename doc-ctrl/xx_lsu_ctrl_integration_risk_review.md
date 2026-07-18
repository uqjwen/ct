# `xx_lsu_ctrl` / `xx_lsu_top` 集成风险审查

## 1. 范围与结论

基于提交 `a81c012` 完成初审，并在 Interaction 1.4 提交 `6260f4a` 上复核全局/pipe 门控时钟、LRQ 迁移后的 restart/wakeup bitmap、flush/参数合同和新增 MMU/LFB/SQ/WMB/LSDA producer。仓库仍缺部分 top 实例模块、宏头文件、helper 和 testbench，因此只能完成 source-level 结构审查，不能声称已完整 elaboration。

| ID | 优先级 | 置信度 | 状态 | 摘要 |
|---|---:|---|---|---|
| CTRL-RR-01 | P2 | 已确认 | VMB 笔误已修，剩余遗漏当前配置关闭 | create1 已补；ICC/LSDA special enable 仍未进入父门控 |
| CTRL-RR-02 | P1 | 已给定合同 | 条件关闭待静态保护 | CTRL→LRQ bitmap 要求 `LRQENTRY == LSIQENTRY` |
| CTRL-RR-03 | P1 | 源码+合同 | producer 本地源码缩小，集成边界保留 | MMU/LFB/SQ/WMB flush 后清 bitmap，consumer仍仅按 entry bit OR |
| CTRL-RR-04 | P2 | 已给定配置 | 迁移边界 | top 对外 IDU 状态多数 tie 0，内部状态改送 LRQ |
| CTRL-RR-05 | P3 | 结构确认 | 工具边界 | 已提供 13 个 instance 的 named-port 集合一致，但不等于完整编译成功 |

## 2. 时钟结构

`ctrl_ld0_clk` 覆盖 load pipe、WB arbitration 和 borrow；`ctrl_ls0_clk` 覆盖 LS0 load/store 及 borrow；LS1 borrow 输入在 top 明确 tie 0，所以 `ctrl_ls1_clk_en` 不含 borrow 项与当前配置一致（`srcs/xx_lsu_ctrl.sv:569-671`、`srcs/xx_lsu_top.sv:7424-7437`）。restart/wakeup 的活动 lane 为 0、2、3，lane1 代码已整体停用，映射与 top/IDU lane 编号一致（`srcs/xx_lsu_ctrl.sv:849-869`、`srcs/xx_lsu_ctrl.sv:949-994`）。

## 3. 详细风险

### CTRL-RR-01：special-clock enable 清单不完整

Interaction 1.3 提交已把尾部重复的 `idu_lsu_vmb_create0_gateclk_en` 修为 `idu_lsu_vmb_create1_gateclk_en`（`srcs/xx_lsu_ctrl.sv:539-556`），VMB0/1 均已覆盖。继续扫描发现 `icc_vb_create_gateclk_en`、`lsda0_ex3_special_gateclk_en` 和 `lsda1_ex3_special_gateclk_en` 仍在整个 CTRL 中没有消费者，而 top 确实把这些真实信号接入 CTRL（`srcs/xx_lsu_top.sv:12119-12132`、`srcs/xx_lsu_top.sv:12305-12323`）。

当前 top 把 `pfu_part_empty=0`（`srcs/xx_lsu_top.sv:3761`），所以 `!pfu_part_empty` 让 special clock 永久在线，剩余遗漏暂不造成功能丢拍；代价是门控失效。若未来恢复 PFU empty 的真实值，ICC→VB create 或 LSDA 特殊寄存可能在唯一事件拍关钟。恢复门控前必须补齐这 3 个 enable，并断言每个 special-clock 子门控请求都蕴含父时钟 enable。

### CTRL-RR-02：LRQ/LSIQ 参数相等是隐藏硬合同

top 默认 `LRQENTRY=LSIQENTRY`（`srcs/xx_lsu_top.sv:27-42`），但 CTRL 输出是 `LSIQENTRY` 宽，LRQ 的 freeze/restart/status 输入是 `LRQENTRY` 宽（`srcs/xx_lsu_lrq.sv:249-268`）。top 使用 `LRQENTRY` 宽中间 net把 CTRL 输出直接接入 LRQ（`srcs/xx_lsu_top.sv:3779-3789`、`srcs/xx_lsu_top.sv:12388-12445`）。

Interaction 1.3 已把 `LSIQENTRY == LRQENTRY` 明确为集成合同，因此正式配置下功能条件关闭。只要两个参数被独立改写，仍会发生静默截断/零扩展，且 bitmap 的 bit identity 不再有定义；应在 top/CTRL 加 elaboration-time static assertion，避免合同只存在于文字中。

### CTRL-RR-03：wakeup bitmap 缺少 transaction epoch

CTRL 将 RF restart、DC immediate、DA second/ECC、SQ/WMB dependency、MMU async、US restart 和 LFB dependency直接 OR 成 lane bitmap（`srcs/xx_lsu_ctrl.sv:949-989`）。这能保持同拍优先级简单，但信号只携带 entry bit，不携带 IID/epoch。

Interaction 1.3 声明 entry bit 在请求 DA 终止/不再重发前唯一对应 IID，flush 时 producer 会删除旧 pending。可见 LD-DA 路径确实以 `lda_ex3_inst_vld` 和保存的 LSID 生成 already-da/pop/spec-fail/secd 向量（`srcs/xx_lsu_ld_da.sv:5167-5223`），且 full/check flush 会清 DA stage valid（`srcs/xx_lsu_ld_da.sv:1981-2012`），未发现该路径违反规则。

Interaction 1.4 补齐的 producer 显示，MMU TMQ 保存 IID/LSID 并在 check-flush 拍发送后清空 LSID；LFB/SQ/WMB wakeup queue 也采用“check-flush 拍发送当前 bitmap、下一拍清零，full flush 直接清零”的结构（详见 `docs/interaction-1.4-followup-review.md` 第 4 节）。因此没有发现这些 producer 在 flush 后继续保存旧 bit 的本地路径。

consumer 仍只是无 IID/epoch 的 bitmap OR，LRQ 按 bit 清除 freeze（`srcs/xx_lsu_lrq_entry.sv:694-705`），所以 wrapper/top 接线和 entry 立即复用边界仍必须用 epoch scoreboard 证明。本项由“producer 缺失的合同关闭”更新为“producer 本地源码缩小、集成边界保留”。

### CTRL-RR-04：top 的 IDU 接口已迁移到 LRQ 语义

top 对外多个旧 `lsu*_idu_*` backpressure/status 输出固定为 0，wakeup/pop 改由 LRQ 产生（`srcs/xx_lsu_top.sv:4279-4348`）；CTRL 的相应输出在 top 内部接到 LRQ freeze/status 输入，gateclk 输出则有意 floating（`srcs/xx_lsu_top.sv:12388-12445`）。

这不是重复驱动，但属于架构迁移合同：外部 IDU 必须不再依赖被 tie 0 的旧 full/wait/tlb/status 输出，LRQ 必须承担 issue reject、freeze clear 和 replay。若仍存在旧 IDU 集成版本，tie 0 会隐藏 backpressure。建议用版本参数或接口断言明确“LRQ mode”，而不是靠注释和 floating port表达。

### CTRL-RR-05：结构检查边界

既有可见模块的平衡括号和 named-port 集合检查未发现重复端口；Interaction 1.4 又补充了 LS wrapper、MMU/LFB/SQ/WMB 等实现。但 top 实例化的 `xx_lsu_wb_arbiter` 仍没有源文件（`srcs/xx_lsu_top.sv:10594-10627`），clock cell、vector/helper、宏定义也未完整提供。结构文本检查仍不能替代编译/elaboration。

## 4. 处理顺序

现配置首先应保留 `pfu_part_empty=0` 的显式配置断言；若要恢复时钟门控，补齐 ICC/LSDA 三个 enable。随后固化 `LRQENTRY==LSIQENTRY` 和所有异步 wakeup 的 epoch 合同，并在完整 SoC 源码环境运行 lint/elaboration。

## 5. 跨报告对应关系

- AG RR-03 与 LRQ-RR-01 是同一 replay debug-metadata 缺口的 consumer/producer 两端，均保持开放。
- AG RR-16 与 DC-RR-04 是同一 MMU immediate-wakeup tie-off，当前功能条件关闭但保留清理建议。
- LRQ-RR-03 与 CTRL-RR-03 是同一迟到 wakeup/entry 复用合同，前者定位 consumer，后者覆盖全部 producer OR 树。
- LRQ-RR-05 与 CTRL-RR-02 是同一 `LRQENTRY/LSIQENTRY` 参数合同，不重复计为两个独立缺陷。
- DA-RR-01 的错误数据经 RB/WB/VMB 传播；WB 选择本身不会修复或重新排序该块，因此验证必须端到端检查 512-bit identity。
