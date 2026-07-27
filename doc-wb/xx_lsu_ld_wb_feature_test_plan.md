# `xx_lsu_ld_wb` 功能点与 Test Plan

范围为 completion/data 双通道仲裁、标量/浮点/向量格式化、RTU/IDU 输出、bus error、debug halt-info 和门控。每个 requester 必须满足 hold-until-grant。

| 二级功能点 | 三级功能点 | 功能点描述 | 测试方法和配置说明 | 优先级 |
|---|---|---|---|---|
| Completion 仲裁 | DA/RB 竞争 | DA 与 RB completion 请求选择唯一 winner并返回 grant；输入见 `srcs/xx_lsu_ld_wb.sv:61`、`87` | 00/01/10/11 及连续争用，loser 随机保持 N 拍；检查 grant、IID、expt、vstart 不串项 | P0 |
| Data 仲裁 | DA/WMB/VMB/RB | 四类 data request 竞争共享写回资源；输入分布于 `srcs/xx_lsu_ld_wb.sv:68`～`139` | 穷举 16 种组合并持续高优先级流量，检查 onehot grant、payload winner和有界公平合同 | P0 |
| 请求合同 | req/DP/gate | DA data req 必须蕴含 DP，DP 必须蕴含 gate；接口见 `srcs/xx_lsu_ld_wb.sv:68`～`70` | 合法 DP-only 和负向非法组合；断言 req implies DP、DP implies gate，DP-only 不产生写回 | P0 |
| 标量写回 | PREG 与符号扩展 | 按 size/sign 控制生成 64-bit integer/FP 数据和 preg valid；输出见 `srcs/xx_lsu_ld_wb.sv:159`～`162` | byte/half/word/dword、signed/unsigned、边界值，reference model 逐 bit 检查 | P0 |
| 向量写回 | VR0/VR1/FR | 根据 vector 类型、vmew、sign select 和 4×128-bit payload形成各端口；见 `srcs/xx_lsu_ld_wb.sv:163`～`170` | vector/FP/US、互异四块数据和所有合法 sign select；检查 lane、expand 与 valid 一致 | P0 |
| RTU 完成 | completion/exception | 输出 load pipe completion、exception、flush、preg/vreg有效信息；接口见 `srcs/xx_lsu_ld_wb.sv:177`～`195` | normal/PF/AF/bus error/no-spec/FOF，交叉 completion 与 data 分拍；RTU scoreboard 检查一次终态 | P0 |
| Bus error | 数据抑制 | RB/LFB 返回错误时生成异常并禁止错误数据写入寄存器；RB 输入区见 `srcs/xx_lsu_ld_wb.sv:87`～`116` | R/B response error、boundary 两半、US 两 beat 各位置注错；检查 mtval、exception和 data valid | P0 |
| VMB completion | merge/FOF | VMB completion带 element count、exception、vsetvl、VMB ID和数据；输出见 `srcs/xx_lsu_ld_wb.sv:145`～`150` | merge/non-merge、FOF first/non-first、vsetvl组合；检查 VMB ID、VL/vstart和完成次数 | P1 |
| Debug | halt-info 更新 | DA/RB data trigger 经两级 valid 更新 completion effect；接口见 `srcs/xx_lsu_ld_wb.sv:200`～`215` | halt bit 01/10/11，各打一拍后停止所有流量；检查 update/effect 可自行开钟并有界清零 | P0 |
| Forward | EX4 旁路 | 写回结果同步提供 IDU EX4 preg/vreg forward；输出见 `srcs/xx_lsu_ld_wb.sv:157`～`170` | RAW consumer 紧随 producer，交叉 scalar/vector、grant 反压和 exception；检查旁路仅来自实际 winner | P1 |
| Flush | 年轻请求取消 | full/check flush 禁止被杀请求继续 completion/data；输入见 `srcs/xx_lsu_ld_wb.sv:119`～`121` | 在请求、grant、输出各拍注入 flush，包含 IID wrap；检查旧 owner不写回且合法老请求保留 | P0 |
| Clock/Reset | completion/data ICG | 两类时钟必须覆盖请求、grant和 halt-info 的置位/清除边沿；相关控制由 `srcs/xx_lsu_ld_wb.sv:31` 模块内生成 | ICG on/off/scan、空闲后一拍 trigger、reset 释放；比较组合 enable 与实际 clock pulse和寄存结果 | P0 |

动态签核需同时连接 `xx_lsu_wb_arbiter`，并对每个被反压 requester 检查 payload 稳定；只验证 winner 数据不足以证明请求不会丢失。
