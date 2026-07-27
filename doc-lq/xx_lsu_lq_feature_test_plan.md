# `xx_lsu_lq` / `xx_lsu_lq_entry` 功能点与 Test Plan

范围包含三 lane LQ allocation、age vector、RAR/RAW检查、spec-fail选择、pop/flush，以及 `xx_lsu_lq_entry` 的地址、mask、IID、PC和 snoop 状态。

| 二级功能点 | 三级功能点 | 功能点描述 | 测试方法和配置说明 | 优先级 |
|---|---|---|---|---|
| 容量管理 | free pointer/full | valid bitmap生成 lane0/2/3 create pointer、full及 IDU not-full；信号见 `srcs/xx_lsu_lq.sv:155`～`167` | empty/one-left/full，三 lane同拍 create/pop；断言每个 success pointer onehot且不重叠 | P0 |
| Create | winner payload | raw/DP/function valid分别控制 gate、数据采样和真正建立 entry；create向量见 `srcs/xx_lsu_lq.sv:168`～`179` | 高优先级 DP但未成功、低优先级成功，使用互异 IID/PC/PA/mask检查 payload来自 winner | P0 |
| Entry payload | 地址/IID/PC | `xx_lsu_lq_entry` 保存比较地址、byte mask、IID、PC、US/secd等；模块见 `srcs/xx_lsu_lq_entry.sv:25` | 每字段互异花纹，创建后随机等待和snoop；readback/比较输出逐 bit与scoreboard一致 | P0 |
| Age vector | 三 lane年龄 | create时建立全局年龄关系并在 entry释放后维护无环顺序；age逻辑见 `srcs/xx_lsu_lq.sv:199`～`207` | IID正常/wrap及 lane年龄六种排列，多轮 fill/drain；软件有向图检查无环和传递一致 | P0 |
| RAR 检查 | load-load冲突 | 根据地址、byte overlap、age和 snooped状态产生 RAR spec fail；信号见 `srcs/xx_lsu_lq.sv:184` | same/different line、部分/无 byte overlap、US 64B、corr disable；reference model逐项比对 | P0 |
| RAW 检查 | store-load冲突 | store地址检查所有存活年轻 load，按 byte overlap产生 RAW失败；entry compare见 `srcs/xx_lsu_lq_entry.sv:430` | store/load地址低位和mask穷举，交叉secd/US/snoop；检查无漏报和无伪报 | P0 |
| Spec-fail | PC选择 | 多个 entry同拍失败时输出一个合法违规 PC，当前实现允许按物理优先级选择；选择向量见 `srcs/xx_lsu_lq.sv:209`～`220` | 2/N个匹配并交换物理 index，检查输出属于匹配集合并统计多匹配率 | P1 |
| Pop | complete/restart | DA/LSDA pop释放对应 live entry，不能让迟到旧 pop杀死复用后的新 owner；pop汇总见 `srcs/xx_lsu_lq.sv:208` | pop与create同 bit同拍、旧 entry释放后最早复用，负向旧 pop由generation assertion捕获 | P0 |
| Snoop | snped 生命周期 | snoop/VB invalidate命中 live entry后保存 snped，pop/create时正确重置；entry逻辑见 `srcs/xx_lsu_lq_entry.sv:360` | snoop发生在create前/同拍/后和复用边界；检查新 owner不继承旧 snped | P1 |
| Flush | full/check清除 | full flush清全部，check flush按 IID年龄杀年轻 entry和同拍 create；输入见 `srcs/xx_lsu_lq.sv:61`～`63` | IID older/equal/newer、wrap，交叉create/pop/spec fail；killed owner不再产生violation | P0 |
| Clock/Reset | valid/data门控 | entry valid、create payload、snoop和age更新必须打开对应时钟；LQ总时钟说明见 `srcs/xx_lsu_lq.sv:224` | ICG on/off/scan、孤立create/snoop/pop、reset释放；检查寄存变化与门控资格一致 | P1 |
| 参数 | LQENTRY边界 | pointer、agevec和priority encoder按 `LQENTRY` 参数展开；参数见 `srcs/xx_lsu_lq.sv:27` | 正式参数及最小/非2幂配置elaboration，静态宽度检查并运行fill/drain reference model | P2 |

动态环境必须对“任一合法违规 PC”与“最老违规 PC”两种规格作明确选择；若采用前者，测试不得把物理优先级误判为功能错误。
