# `xx_lsu_lfb` / `xx_lsu_lfb_addr_entry` 功能点与 Test Plan

范围包含 LFB 地址/数据项分配、RB/PFU create、BIU linefill response、VB replacement、D-cache refill、依赖唤醒和回收。仓库提供 `xx_lsu_lfb_addr_entry`，但 `xx_lsu_lfb` 所实例化的 `xx_lsu_lfb_data_entry` 源码缺失；补齐该模块并完成 elaboration 是执行以下 data-entry 测试前的硬性前置条件。

| 二级功能点 | 三级功能点 | 功能点描述 | 测试方法和配置说明 | 优先级 |
|---|---|---|---|---|
| 地址项分配 | RB/PFU create | RB和PFU请求选择空闲地址项并返回 create ID，entry保存 line地址与来源；入口见 `srcs/xx_lsu_lfb.sv:68`～`84` | empty/one-left/full，RB/PFU同拍竞争和互异地址；断言 success ID唯一、winner payload正确 | P0 |
| Entry 生命周期 | valid/create/pop | `xx_lsu_lfb_addr_entry` 在create置 valid，在linefill或data pop时释放；见 `srcs/xx_lsu_lfb_addr_entry.sv:230`～`239`、`499` | create、response、pop、立即复用同拍交叉；generation scoreboard检查旧事件不清新 owner | P0 |
| 地址命中 | request merge/hit | live地址项比较 RB/PFU/WMB/SNQ请求的 cache line，阻止重复 outstanding或支持bypass；见 `srcs/xx_lsu_lfb_addr_entry.sv:531`～`566` | same/different line、地址边界和多 entry匹配负向场景；正式场景命中 onehot0且 source一致 | P0 |
| 数据项分配 | address/data绑定 | BIU response按 ID绑定地址项和可用数据项，保存 beat/data/share/last；数据指针见 `srcs/xx_lsu_lfb.sv:192`～`203` | 两数据项 empty/one-left/full，交叉两地址项响应；检查 addr ID、data ID和payload不串项 | P0 |
| BIU R通道 | ID/beat/response | 根据 `biu_lsu_r_id/r_last/r_resp/r_user` 接收linefill数据并处理错误；接口见 `srcs/xx_lsu_lfb.sv:42`～`47` | 正常beat序列、错 ID、early/late last、response error、随机背压；协议错误触发assertion | P0 |
| VB 协同 | replacement完成 | 地址项申请VB选择refill way并保存hit/dirty/rcl_done；entry逻辑见 `srcs/xx_lsu_lfb_addr_entry.sv:289`～`325` | VB grant 0/1/N拍、hit clean/dirty/miss和多请求竞争；检查选择结果属于原地址项 | P0 |
| Refill | D-cache tag/data写 | linefill状态机按way把数据/ECC、tag、dirty写回D-cache；数据输出见 `srcs/xx_lsu_lfb.sv:1506`～`1513` | 四 way、所有data word、互异花纹、D-cache随机grant；逐 bit对比line reference model | P0 |
| Response完成 | all response/NC empty | 每地址项记录response，汇总all_resp及NC empty给flush/总线控制；见 `srcs/xx_lsu_lfb.sv:1653`～`1656` | 混合CA/NC项、乱序响应和error，检查all_resp只在全部live项完成后有效 | P1 |
| 依赖队列 | LRQ/LSIQ wakeup | load miss把依赖bitmap并入队列，refill/pop/flush产生一次wake并清除；见 `srcs/xx_lsu_lfb.sv:1522`～`1605` | 多依赖merge、部分/full flush、bit立即复用和负向旧wake；owner assertion检查零串项 | P0 |
| SNQ bypass | share/data ID | 已响应line可向SNQ提供bypass数据和share属性；逻辑见 `srcs/xx_lsu_lfb.sv:1724`～`1728` | 两data项互异花纹，SNQ同/不同line和多hit负向场景；检查data ID、share和有效期 | P1 |
| Flush | 队列与outstanding | full/check flush清依赖队列，但已发总线事务仍须安全回收且不唤醒被杀owner；清除见 `srcs/xx_lsu_lfb.sv:1547`～`1552` | 在create、VB、R beat、refill、pop各点flush；响应继续/停止两种模型检查无迟到功能副作用 | P0 |
| 容量/空闲 | full/less2/empty | 地址项和数据项分别生成full、less2、empty并参与系统反压；汇总见 `srcs/xx_lsu_lfb.sv:1730`～`1739` | fill→full→drain全状态，create/pop同拍和长期背压；reference counter逐拍一致 | P0 |
| Clock/Reset | entry/state门控 | entry valid/create、VB结果、response和wakeup队列更新需对应gateclk；entry clock见 `srcs/xx_lsu_lfb_addr_entry.sv:189`～`223` | ICG on/off/scan、孤立一拍事件、reset释放；检查实际clock pulse和寄存状态变化 | P1 |

LFB动态签核需把地址项、数据项和BIU/VB/D-cache三侧同时纳入scoreboard；仅验证最终cache line数据不能发现ID串项或被flush依赖的迟到唤醒。
