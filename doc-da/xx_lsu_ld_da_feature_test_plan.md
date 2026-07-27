# `xx_lsu_ld_da` 功能点与 Test Plan

范围为 DA 数据选择、forward/merge、ECC、异常、RB/LQ/LRQ/LFB 协同和 WB 请求。scoreboard 以 `{lane, IID, generation}` 保存四个 128-bit block、数据源、byte mask 和副作用集合。

| 二级功能点 | 三级功能点 | 功能点描述 | 测试方法和配置说明 | 优先级 |
|---|---|---|---|---|
| 数据选择 | D-cache 16 bank | 根据 way/bank/rot 组合普通 128-bit 与 unit-stride 512-bit 数据；bank 输入见 `srcs/xx_lsu_ld_da.sv:60`～`75` | 16 bank 和四 way 使用互异花纹，穷举 rot/vmew；逐 bit 对比软件拼接模型 | P0 |
| Forward | SQ/WMB/旁路 | SQ、WMB、store-data bypass 与 cache 数据按 byte mask 合并；接口见 `srcs/xx_lsu_ld_da.sv:207`～`227` | none/full/partial forward，冲突源负向激励，检查最新 owner、byte 粒度合并和 PE 标志 | P0 |
| ECC | 检错与 replay | tag/data ECC 可触发 stall、discard、RB 保存，四个 128-bit block 必须完整；ECC 控制见 `srcs/xx_lsu_ld_da.sv:115` | 16 bank × correctable/fatal × 四块互异数据，检查 replay 后 512-bit 无复制/丢块且 completion 一次 | P0 |
| MMU 异常 | 后级 access fault | 请求后一拍 `mmu_lsu_access_fault0` 在 DA 归属当前事务；输入见 `srcs/xx_lsu_ld_da.sv:182` | back-to-back 互异 IID，AF 对每拍单独注入；断言 fault 不串项、错误事务不写数据 | P0 |
| LQ | entry pop | 正常完成、restart/exception 按合同产生 LQ pop，输出见 `srcs/xx_lsu_ld_da.sv:282` | create 后在完成、flush、restart 边界弹出，entry 立即复用；generation scoreboard 阻止旧 pop 杀新 owner | P0 |
| RB | create/merge | cache miss、NC/SO/atomic/ECC 等形成 RB judge/DP/function create 或 merge；接口见 `srcs/xx_lsu_ld_da.sv:308`～`330` | RB 0/1/N 空位，lane 竞争、index hit/merge fail、flush 同拍；检查 winner payload和一次 accept | P0 |
| WB completion | 完成请求 | 正常/异常/no-spec/vector 元数据形成 completion 请求；输出见 `srcs/xx_lsu_ld_da.sv:370`～`383` | completion grant 反压 0/1/N 拍，检查 IID/expt/vstart/halt-info 稳定并恰好一次 | P0 |
| WB data | 标量/向量写回 | DA 发出 data req/DP/gate及四块数据，DP 可宽于功能 req；见 `srcs/xx_lsu_ld_da.sv:372`～`378` | req、DP、gate 合法组合，scalar/FP/vector/US 数据；断言 req implies DP implies gate，DP-only 无写回 valid | P0 |
| 异常/重启 | 优先级与屏蔽 | misalign/PF/AF/ECC/RB full/forward discard 决定 exception、restart、completion；控制集中于 `srcs/xx_lsu_ld_da.sv:4986` | 两两和三项冲突，reference model 检查唯一终态：完成、异常、RB 接收或重启 | P0 |
| LFB/LRQ | 依赖唤醒 | miss/merge/discard 更新 LFB wakeup queue、LRQ bitmap和 late dependency；相关接口见 `srcs/xx_lsu_ld_da.sv:177` | create→miss→LFB response→replay，并在 flush 后复用 LRQ bit；负向旧 wake 必须触发 owner assertion | P1 |
| Debug | halt-info 副作用 | 地址/数据 trigger halt-info 可屏蔽功能和辅助副作用；halt 接口见 `srcs/xx_lsu_ld_da.sv:383` | halt bit 01/10/11，交叉 cache hit/miss/ECC/forward；检查书面合同规定的所有副作用集合 | P1 |
| Flush/Clock | 清除与门控 | full/check flush 在 DA、RB create、WB request 各边界杀死年轻事务；flush 输入见 `srcs/xx_lsu_ld_da.sv:188`～`190` | 每个 side effect 前后注入 flush，ICG on/off/scan；检查旧 owner零次 completion/data/create/pop | P0 |

DA 的 P0 签核必须使用四块互异数据花纹，并分别统计 completion、data、RB create、LQ pop 和异常，避免只靠最终寄存器值掩盖重复副作用。
