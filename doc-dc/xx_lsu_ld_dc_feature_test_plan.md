# `xx_lsu_ld_dc` 功能点与 Test Plan

范围为 DC 流水寄存、D-cache tag 判定、borrow、LQ 创建、restart、forward 元数据和 DA 接口。scoreboard 以 `{IID, generation, inst/borrow, addr, hit way}` 追踪。

| 二级功能点 | 三级功能点 | 功能点描述 | 测试方法和配置说明 | 优先级 |
|---|---|---|---|---|
| 流水级控制 | EX1→EX2 锁存 | AG 请求在 DC 保存 payload，full/check flush 可杀年轻指令；比较与清除见 `srcs/xx_lsu_ld_dc.sv:1109`～`1131` | 连续互异 IID 请求交叉 stall、full/check flush 和 borrow；检查 killed owner 不进入 DA | P0 |
| Borrow | owner 与 gate | VB/SNQ/ICC/WMB/MMU/PRQ 等可借用读口，valid 与 gate/payload owner 必须一致；状态见 `srcs/xx_lsu_ld_dc.sv:1157` | 每个来源单独和合法竞争，另负向注入 valid-only；断言 valid implies gate 且仅一个 payload owner | P0 |
| D-cache tag | 四 way 命中 | tag 比较形成四 way `ldc_hit_way` 和 settle way；选择见 `srcs/xx_lsu_ld_dc.sv:1250` | 四 way 单 hit、miss、多 hit、X tag，交叉 cache disable/NC；正式场景断言 onehot0 | P0 |
| Unit-stride | way 保存 | unit-stride 与 borrow 都能决定后级 settle way，必须与 AG 保存的 tag 结果一致；见 `srcs/xx_lsu_ld_dc.sv:1250` | unit-stride 四 way 花纹后紧随 scalar，检查 way 不粘连、512-bit 数据只使用目标 way | P0 |
| Byte mask | 四区传递 | 向 DA 传递四组 bytes/reg-bytes valid，标量只消费第一区；输出声明与逻辑见 `srcs/xx_lsu_ld_dc.sv:1279` | US/non-US/scalar 连续切换，四区使用互异 mask；检查适用字段逐 bit 保真和非适用字段不被消费 | P1 |
| LQ 创建 | 指针与资格 | DC 对 load 形成 LQ create DP/gate/function valid，并传递 one-hot entry；创建逻辑见 `srcs/xx_lsu_ld_dc.sv:1559` | LQ empty/one-left/full，create 与 flush/restart 同拍；检查 accept 对应唯一 entry，失败不进入 DA | P0 |
| Restart | LQ full/TLB busy | LQ full、依赖失败、uTLB busy 等阻止 DA valid并产生重启；TLB gate 输出见 `srcs/xx_lsu_ld_dc.sv:581` | 每种原因单独与两两交叉，检查原因优先级、一次 wake/restart、无 completion | P0 |
| 异常传播 | AF mask/extra | 将 AG 异常与 DC 新 MMU access fault 组合，并在适用条件下 mask；见 `srcs/xx_lsu_ld_dc.sv:1469`～`1472` | misalign/PF/AF/NC/borrow 交叉，检查异常不丢失、不重复且 mtval owner 正确 | P0 |
| Forward 元数据 | SQ/WMB 选择 | 保存 SQ/WMB forward valid 和 byte mask供 DA 合并；接口见 `srcs/xx_lsu_ld_dc.sv:532`～`534` | SQ-only、WMB-only、无 forward 和冲突负向场景，使用互异数据花纹检查 source/payload 一致 | P1 |
| DA 接口 | inst/borrow 分流 | DC 向 DA 发送指令或 borrow 类型、hit way、数据请求和异常元数据；接口集中于 `srcs/xx_lsu_ld_dc.sv:191`～`286` | back-to-back inst/borrow，DA 随机反压；stage scoreboard 检查每次 accept 的完整 payload hash | P0 |
| Debug | 地址采集脉冲 | debug load 可建立地址 trace/circular buffer 请求；创建输出见 `srcs/xx_lsu_ld_dc.sv:304`～`307` | debug/normal/debug 连续三拍，检查 valid 为单次脉冲、地址不重复且 flush 后无迟到 | P1 |
| Clock/Reset | gate 覆盖 | inst、borrow、LQ create、TLB busy 和 debug payload 更新都必须有对应 gateclk；相关输出见 `srcs/xx_lsu_ld_dc.sv:176`～`181` | ICG on/off/scan 与 reset 释放边界随机激励，检查功能 valid 高时状态寄存器实际采样 | P1 |

P0 用例必须在集成 `xx_lsu_dcache_arb`、LQ 和 DA 的环境中运行；单模块随机激励不足以证明 borrow owner 合同。
