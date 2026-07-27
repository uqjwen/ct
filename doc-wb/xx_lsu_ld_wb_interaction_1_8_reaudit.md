# `xx_lsu_ld_wb` Interaction 1.8 第二轮设计审查

## 1. 范围与基线

- 审查基线：`4a8223a2d80a5da6a7198c6fc89d97790b9729c3`。
- 审查对象：`xx_lsu_ld_wb` 的 completion/data 仲裁、标量/向量/512-bit 数据选择、门控时钟、halt-info 生命周期、VMB merge 和 RTU 输出。
- 重新检查四块数据索引、grant/payload 一致性、DP-only 影响和修复后的三拍 debug 状态。
- 无完整门级 ICG 仿真环境，本报告为静态结论。

## 2. 结论

| ID | 优先级 | 状态 | 结论 |
|---|---:|---|---|
| WB-I18-01 | P2 历史影响 | 源码已修，验证义务 | halt-info update 现在能自开 data clock，effect 又能开 completion clock，静态可收敛到清零。 |
| WB-I18-02 | P1 影响 | 合同依赖 | 三 lane shared writer 的组合选择安全，但无状态固定优先级仍不能从本模块证明 bounded grant。 |
| WB-I18-03 | P3 | 已确认，清理项 | preg clock enable 有重复 RB 项，仅造成功耗/维护问题。 |
| WB-I18-04 | — | 未发现新增 | DA/RB/VMB 的四个 128-bit block 与高三组 byte mask 的 winner 选择未见复制或跨 owner。 |

第二轮未发现新增的 WB 功能 bug；历史门控修复仍需实际 ICG 波形关闭。

## 3. 详细复核

### WB-I18-01：halt-info 自清链已闭合

completion clock enable 包含 `ld_wb_halt_info_effect` 和 registered update（`srcs/xx_lsu_ld_wb.sv:1005`～`1008`）；data clock enable也包含 `ld_dtu2_vld` 与 `rb_data_halt_info_update_vld`（`srcs/xx_lsu_ld_wb.sv:1045`～`1050`）。update 寄存器在下一次 data clock 没有新输入时清 0（`srcs/xx_lsu_ld_wb.sv:1816`～`1823`），halt-info 再由 effect 分支清 0（`srcs/xx_lsu_ld_wb.sv:1678`～`1689`）。静态三拍为 `(update,effect)=(0,0)->(1,0)->(0,1)->(0,0)`。

### WB-I18-02：组合 safety 不等于有界活性

本地 winner payload 都由 grant 选择，例如四块数据在 `srcs/xx_lsu_ld_wb.sv:911`～`939`，元数据在 `srcs/xx_lsu_ld_wb.sv:941`～`993`。已有布尔穷举支持单拍无碰撞、无重复 grant。但 arbiter 不保存 age/轮转状态，持续高优先级流量可让低优先级 VMB/RB 长期等待；只有系统提供有限时间让路/反压无环合同才能关闭。

### WB-I18-03：重复开钟项

该项不改变功能数据，只会造成无意义开钟和 lint 噪声，应在功耗清理中去重，优先级 P3。

### WB-I18-04：512-bit 数据与 mask 第二轮检查

data0～3 对 DA/RB/VMB 都按相同 winner 选择（`srcs/xx_lsu_ld_wb.sv:928`～`939`）；高三块只在 512-bit clock 和 `inst_us` 下锁存（`srcs/xx_lsu_ld_wb.sv:1353`～`1365`），高三组 mask 同样资格化（`srcs/xx_lsu_ld_wb.sv:1419`～`1429`）。最终 VMB 数据/mask 四区映射位于 `srcs/xx_lsu_ld_wb.sv:1533`～`1572`，未发现 block2/block3 复制。

## 4. 动态关闭条件

- WB-I18-01：无后续 data traffic 的孤立 halt-info update，观察真实 gated clocks 和四拍状态，确认最终清零且无重复 RTU effect。
- WB-I18-02：给出可验证上界 `N`，断言任一持续 request 在 `N` 拍内 grant；若无法证明，仲裁增加 age/round-robin。
- WB-I18-03：去重后跑 lint/功耗等价检查。
- WB-I18-04：DA/RB/VMB 使用互异四块数据和互异 mask，穷举 winner/loser 组合，scoreboard 检查 payload 与 grant owner 一致。
