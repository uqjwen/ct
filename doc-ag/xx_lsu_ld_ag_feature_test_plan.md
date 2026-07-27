# `xx_lsu_ld_ag` 功能点与 Test Plan

范围为 AG 寄存、地址生成、MMU、D-cache 请求、异常、stall/restart、unit-stride 和 LRQ 创建。测试环境以 `{lane, IID, LRQ ID, observer generation}` 建 scoreboard，并对合法 MMU 合同启用 assertion。

| 二级功能点 | 三级功能点 | 功能点描述 | 测试方法和配置说明 | 优先级 |
|---|---|---|---|---|
| 流水级控制 | RF 请求锁存 | fresh 请求与 LRQ replay 复用 AG，flush、stall 和更老 RF 请求决定寄存保持/覆盖；入口见 `srcs/xx_lsu_ld_ag.sv:1074` | 连续发送 fresh/replay 互异 IID 和地址，交叉 full/check flush、stall 0/1/N 拍；scoreboard 检查 owner 不串项 | P0 |
| 地址生成 | 标量 VA 与跨页 | 根据 base、offset、size、split/secd 生成 VA、16B byte mask 和 4 KiB crossing；核心区见 `srcs/xx_lsu_ld_ag.sv:1257` | 穷举 size、VA 低 4 位、页尾偏移和正负 offset，用 64-bit 软件模型逐 bit 对比地址与 mask | P0 |
| MMU 接口 | hit/miss/abort | 发出 VA 请求，区分同拍 PA hit、accepted miss 和 abort；uTLB miss 输出位于 `srcs/xx_lsu_ld_ag.sv:2469` | MMU 模型配置 hit、N 拍 miss、merge、abort；断言 accepted miss 只能由 async bitmap 唤醒且 replay 一次 | P0 |
| MMU 异常 | PF/AF 保存 | backpressure 期间保存 page fault 与下一拍 access fault，组合异常见 `srcs/xx_lsu_ld_ag.sv:1354`～`1386`、`2700` | stall 1/N 拍，分别注入同拍 PF 和请求后一拍 AF；检查异常 IID、地址、优先级和无 D-cache 副作用 | P0 |
| Stall/Restart | backconnect 恢复 | D-cache/结构/跨页/unit-stride stall 形成 `lag_ex1_stall_ori`，miss/fault 改写恢复路径；见 `srcs/xx_lsu_ld_ag.sv:2762`～`2812` | 两两交叉 stall 原因、更老 RF 覆盖和 fresh/replay；断言每事务恰好一次 hold、LRQ freeze 或 restart | P0 |
| D-cache 请求 | tag/data bank | 生成 tag request 和 16 bank data enable；输出见 `srcs/xx_lsu_ld_ag.sv:2574`、`2622` | VA 低位遍历所有 bank，交叉 cache enable、PA valid、CA/NC、borrow backpressure；检查 onehot bank 与无效周期无消费 | P1 |
| Unit-stride | 两拍 way 获取 | 512-bit unit-stride 先读 tag，再保存四 way 命中并进入 data 访问；见 `srcs/xx_lsu_ld_ag.sv:1391`～`1424`、`2628` | 四 way 单 hit、miss、多 hit和 ICG 配置；检查固定两拍时序、way 保存和 scalar 紧随时不继承旧 way | P0 |
| 异常判定 | 对齐与属性 | 对 atomic/load 的 misalign、page fault、access fault、LDAMO 非 CA 进行优先编码；见 `srcs/xx_lsu_ld_ag.sv:2662`～`2704` | size/align/CA/SO/atomic/PF/AF 全交叉；reference model 检查异常种类、mtval 与后级 valid 屏蔽 | P0 |
| LRQ 协同 | 创建与 freeze | fresh 请求创建 LRQ，replay 不重复创建；freeze 由 stall/MMU ownership 决定；见 `srcs/xx_lsu_ld_ag.sv:3031`～`3057` | empty/one-left/full 和 flush 同拍，覆盖 accepted miss、local abort、普通 stall；检查 create/pop/owner 一致 | P0 |
| TCM/Atomic | 特殊访问 | DTCM/ITCM hit、LR/AMO commit 条件改变 cache 请求、异常和 stall；相关逻辑见 `srcs/xx_lsu_ld_ag.sv:2935`～`2975` | 分别配置 TCM 开关与 atomic/LR/SC/普通 load，交叉 commit 早晚和地址属性；检查唯一数据源和不重复请求 | P1 |
| 向量访问 | split 与 byte mask | vector indexed/strided/unit-stride 根据 split、vmew、element count 形成四组 byte/reg-byte mask；见 `srcs/xx_lsu_ld_ag.sv:1692` | 合法 vmew/vlmul/split 编码和边界 mask 全覆盖，replay 与 fresh 对比等价，X-prop 检查 valid payload 二态 | P1 |
| Flush/Clock | 清除与门控 | full/check flush 清除年轻 AG owner，gateclk 必须覆盖所有可能状态更新；flush 比较见 `srcs/xx_lsu_ld_ag.sv:1074` | 在 capture、MMU pending、stall、LRQ create、DC accept 各点注入 flush；ICG on/off/scan 下检查零迟到副作用 | P0 |

优先执行 P0 定向用例，再运行 constrained-random 组合；P1 用例需纳入回归，P2/P3 留给功耗和清理专项。
