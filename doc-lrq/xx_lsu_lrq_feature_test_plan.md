# `xx_lsu_lrq` / `xx_lsu_lrq_entry` 功能点与 Test Plan

范围包含三个 LRQ bank 的 allocation/age/issue，以及 `xx_lsu_lrq_entry` 的事务 payload、freeze、wakeup、replay 和 flush 生命周期。scoreboard 使用 `{bank, entry, IID, observer generation}` 防止 entry 复用掩盖旧响应。

| 二级功能点 | 三级功能点 | 功能点描述 | 测试方法和配置说明 | 优先级 |
|---|---|---|---|---|
| 容量管理 | free pointer | 每个 bank 依据 entry valid 生成 create pointer、full/less 条件和 no-space 反馈；allocation 区见 `srcs/xx_lsu_lrq.sv:1411`～`1470` | empty/one-left/full，三 bank 同拍 create/pop；断言 accepted create 指针 onehot且互不重叠 | P0 |
| Create | accept/pop 一致 | AG raw create 通过 flush/full资格后建立 entry，同时只弹出对应上游事务；见 `srcs/xx_lsu_lrq.sv:1448` | create 与 full/check flush 同拍，覆盖 raw/DP/function valid；检查失败只因 flush kill，非 flush 不得 raw pop without accept | P0 |
| Entry payload | fresh 元数据保存 | `xx_lsu_lrq_entry` 保存 VA、IID、mask、vector、debug、split 等 replay 字段；模块见 `srcs/xx_lsu_lrq_entry.sv:25` | 每字段使用互异花纹，fresh create 后等待 N 拍再 replay；适用 payload 与 create 值逐 bit 相同 | P0 |
| Freeze | 等待原因集合 | MMU、barrier、no-spec、old check、LFB/SQ/WMB 等原因共同决定 ready；entry wake 逻辑见 `srcs/xx_lsu_lrq_entry.sv:817` | 每种原因单独与两两组合，逐一解除；只有所有必要条件解除后才能 issue | P0 |
| Wakeup | producer owner | MMU/LFB/SQ/WMB bitmap 只能唤醒仍有效且 IID owner 匹配的 entry；汇总见 `srcs/xx_lsu_lrq.sv:1692` | live、已释放、flush-killed、立即复用四类 bit 注入 wake；旧 owner wake 必须触发 assertion | P0 |
| Issue | oldest ready 仲裁 | 各 bank 从 ready entry 中选择年龄最老者并形成 RF replay；age/issue 区见 `srcs/xx_lsu_lrq.sv:1628`～`1683` | 不同 IID 排列和 wrap，多 ready 同拍；软件 age model 对比 winner且 grant onehot | P0 |
| Replay | RF mux | LRQ entry payload经 replay bus回到 AG，不能再次创建 LRQ；mux 区见 `srcs/xx_lsu_lrq.sv:1786`～`1822` | scalar/boundary/vector/US create→replay；断言 replay accept 时 create_vld 为 0，payload无当前 IDU 污染 | P0 |
| No-spec/Barrier | 前序依赖 | wait-old、barrier、no-spec 只在对应前序条件消失后解冻；状态输出见 `srcs/xx_lsu_lrq.sv:1792` | 多 bank 年龄交叉、前序请求逐拍完成；检查无过早 issue、无永久 freeze和 age 环 | P1 |
| DA 反馈 | secd/already/spec fail | DA 对 live entry 更新 second-part、already-DA、spec-fail与 pop；接口状态见 `srcs/xx_lsu_lrq.sv:204` | 反馈与 flush/pop/create 同拍，entry 随即复用；generation scoreboard 检查旧反馈零次修改新 owner | P0 |
| Flush | full/check 清除 | full flush 清全部，check flush按 IID年龄清年轻 entry并阻止同拍复用；flush 输入见 `srcs/xx_lsu_lrq.sv:40`～`42` | IID older/equal/newer和 wrap，覆盖 create/wakeup/issue 各边；检查 killed entry无迟到 replay | P0 |
| Clock/Reset | entry 数据门控 | entry valid、create和反馈状态更新必须打开相应数据钟；entry clock逻辑见 `srcs/xx_lsu_lrq_entry.sv:227` | ICG on/off/scan，gate-only DP、reset 释放；检查功能 valid 高时 payload实际锁存且清除边沿不丢 | P1 |
| 参数合同 | LRQENTRY/LSIQENTRY | bitmap wakeup和 issue queue隐含相同 entry 数/编码合同；参数见 `srcs/xx_lsu_lrq.sv:29`～`33` | 正式参数 elaboration通过；故意配置不等宽时静态 assertion明确失败而非静默截断 | P2 |

签核必须同时观察 `xx_lsu_lrq` 与 `xx_lsu_lrq_entry`；只看 replay 最终完成无法识别旧 owner wakeup命中新 entry。
