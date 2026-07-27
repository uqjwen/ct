# `xx_lsu_rb` / `xx_lsu_rb_entry` 功能点与 Test Plan

范围包含 RB allocation/merge/仲裁，以及 `xx_lsu_rb_entry` 从 create、BIU request/response、LFB、completion/data writeback 到释放的完整生命周期。scoreboard 键为 `{entry, IID, generation, BIU ID, owner}`。

| 二级功能点 | 三级功能点 | 功能点描述 | 测试方法和配置说明 | 优先级 |
|---|---|---|---|---|
| 容量管理 | pointer/保留项 | 普通、MMU和多 lane请求依据空闲项生成不重叠 create pointer及 full反馈；模块入口见 `srcs/xx_lsu_rb.sv:31` | 0/1/2/3 空位和保留项，三 lane同拍 create；断言 success对应唯一 pointer且普通请求不占保留项 | P0 |
| Create | winner payload | judge、DP、function valid逐级收紧，低优先级成功项必须采样自己的 payload；创建输入见 `srcs/xx_lsu_rb.sv:222`～`251` | 高优先级 DP 有效但功能 create失败、低优先级成功；entry内使用互异 IID/data 检查 owner | P0 |
| Entry 状态机 | create→request→response | `xx_lsu_rb_entry` 保存事务并推进 BIU、wait response、WB和pop状态；模块见 `srcs/xx_lsu_rb_entry.sv:25` | 每条状态边随机反压0/1/N拍，断言合法转移、无跳态和每事务只释放一次 | P0 |
| Merge | cache line/boundary | 同 line请求可 merge或保存 boundary second part，byte mask/data owner不丢；merge输出见 `srcs/xx_lsu_rb.sv:224` | hit/miss/merge fail、first/secd、不同 mask和互异数据，逐 byte对比 reference line model | P1 |
| BIU 请求 | AR 属性/ID | CA/NC/SO/atomic/sync类型决定地址、size、burst、ID和发出条件；BIU输出区见 `srcs/xx_lsu_rb.sv:380` | 每种属性单独与资源反压，检查 request稳定到grant、ID唯一且禁止非法 US NC/SO进入总线 | P0 |
| LFB 协同 | create/hit ID | cacheable miss申请 LFB，RID按 LFB项编码并处理 hit-existing；LFB接口见 `srcs/xx_lsu_rb.sv:163`～`175` | LFB empty/full/hit same line，分配后延迟响应；检查 ID、owner和回收顺序一致 | P0 |
| R response | beat/错误 | entry按 ID接收 R beat，unit-stride要求恰好两拍并处理 response error；response逻辑见 `srcs/xx_lsu_rb_entry.sv:1250` | 正常2拍、缺拍、多拍、错 ID、每拍 error；协议负向激励必须触发 assertion | P0 |
| B response | paired owner | sync/fence/atomic 与 WMB共享的 B response只可归属已接受 paired write；B response逻辑见 `srcs/xx_lsu_rb_entry.sv:1540` | B在 request前/同拍/后到达，插入无关固定 ID响应；检查 owner匹配或明确报错 | P0 |
| SO 队列 | ID FIFO | SO多 outstanding通过 FIFO把 response映射到最老 entry；SO输入见 `srcs/xx_lsu_rb.sv:200` | FIFO empty/full/wrap，多 entry响应顺序与乱序负向场景；检查队首映射和无旧 owner | P1 |
| WB | completion/data grant | ready entry分别申请 completion/data并保持 payload到grant；WB接口由 `srcs/xx_lsu_rb.sv:380` 后部汇总 | 多 entry同 ready、WB反压0/1/N拍；断言 grant onehot、公平合同和 payload稳定 | P0 |
| Flush | sync/async 差异 | full/check flush处理年轻请求；debug async flush可不等待卡死 outstanding，但 resume需隔离旧响应；输入见 `srcs/xx_lsu_rb.sv:180`、`197` | request前后注入三类 flush；debug-only允许未响应进入debug，resume场景检查旧 RID不命中新 entry | P0 |
| Clock/Reset | entry门控 | create、response、state和WB grant每次状态更新都需对应 gateclk；entry状态位于 `srcs/xx_lsu_rb_entry.sv:190` | ICG on/off/scan和reset边界，功能事件孤立一拍；比较 enable、实际 clock pulse和寄存变化 | P1 |

RB-RR-04 类继承设计只有在本工程的 ID 编码、唯一 outstanding 和 paired owner合同等价时才可引用 C910 waiver；本计划保留负向 response-owner 检查。
