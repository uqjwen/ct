# `xx_lsu_ld_ag` Interaction 1.8 第二轮设计审查

## 1. 范围、基线与方法

- 审查基线：`4a8223a2d80a5da6a7198c6fc89d97790b9729c3`。
- 审查对象：`xx_lsu_ld_ag`，并沿 MMU、LRQ、DC 接口追踪 fresh/replay、stall、fault、unit-stride 和 debug metadata。
- 方法：重新检查地址单位、窄字段扩展、stall 保持、异常捕获、raw/DP/function valid 分层、replay owner、门控时钟与新增长位宽路径；重点避免把外部合同或保守阻塞误判为功能 bug。
- 限制：仓库没有完整 filelist、宏环境、vector helper 定义和 testbench，本结论是静态审查，不声称完成动态签核。

## 2. 第二轮结论

| ID | 优先级 | 状态 | 结论 |
|---|---:|---|---|
| AG-I18-01 | P2 | 已确认，历史问题仍开放 | LRQ replay 没有保存原事务 `halt_info`，AG 仍可能采样当前 IDU 指令的 debug metadata。 |
| AG-I18-02 | P1 影响 | 合同依赖/验证义务 | 512-bit unit-stride 数据访问只索引一个 64-byte cache line；合法请求若可跨 64-byte 边界，当前可见逻辑不足以取得第二条 line。 |
| AG-I18-03 | — | 反例关闭 | `lag_bkcon_pgfault/tlbmiss` 非 sticky 写法不会在已捕获后被下一拍覆盖，因为捕获值进入 `lsu_mmu_abort`，反过来关闭 `lag_bkcon_stall_vld`。 |
| AG-I18-04 | P3 | 已确认，清理项 | LRQ PA cache 写使能和 entry 存储逻辑处于停用状态，但相关端口与 bypass mux 仍保留。 |

本轮未发现新增的、可仅凭 `xx_lsu_ld_ag` 当前源码证明的 P0 功能错误；保留一个 P1 影响的 unit-stride 边界合同风险。

## 3. 证据与判断

### AG-I18-01：replay debug owner 仍不完整

AG 在 RF 有效时锁存普通事务信息，并在 replay 周期仍形成 debug 请求；相关消费位于 `srcs/xx_lsu_ld_ag.sv:3102`～`3135`。LRQ/entry 保存的 payload 不含 `halt_info`，因此 replay 与另一条 IDU 候选同拍时，当前 IDU 总线可能污染被 replay 的 load。该项与 LRQ-I18-01 是同一缺陷的 consumer/producer 两端，不重复计数。

### AG-I18-02：unit-stride 跨 line 能力必须有明确上游合同

AG 源码自己留下“可能支持跨 512-bit boundary”的未完成说明，位置为 `srcs/xx_lsu_ld_ag.sv:2150`。活动数据索引在 `srcs/xx_lsu_ld_ag.sv:2636`～`2639` 对 unit-stride 四组 bank 全部使用同一个 `{PA[13:6], way}`，即一次只读取一条 64-byte line；四组 byte mask 只能屏蔽该 line 内字节，不能提供下一条 line 的数据。

因此需要二选一：

1. IDU/vector split producer 保证每个送入 AG 的 512-bit unit-stride micro-op 不跨 64-byte line，并对跨界访问拆成两个 owner 完整的 micro-op；
2. LSU 增加第二条 line 的地址、tag/data、fault 与合并流程。

在 producer 源码和动态波形缺失时，本项保持合同依赖，不能直接宣称架构 bug，也不能因存在 byte mask 就关闭。

### AG-I18-03：stall fault 保存的表面覆盖风险不成立

`lag_bkcon_pgfault` 和 `lag_bkcon_tlbmiss` 在 `srcs/xx_lsu_ld_ag.sv:1371`～`1386` 随 `lag_bkcon_stall_vld` 更新，看起来可能在长 stall 中被后续 MMU 值清掉。但二者一旦置位就进入 `lsu_mmu_abort`，而 `lag_bkcon_stall_vld` 又要求 `!lsu_mmu_abort`（`srcs/xx_lsu_ld_ag.sv:2762`～`2764`），所以下一拍更新条件关闭，寄存器保持。该可疑点按反例关闭，不列为新 bug。

### AG-I18-04：停用的 LRQ PA cache 接口

AG 的 PA-set 路径被固定关闭，replay 默认重新访问 MMU；对应选择位于 `srcs/xx_lsu_ld_ag.sv:2418`～`2467`。功能在当前配置下可成立，但半删除接口会误导集成和覆盖率分析，作为 P3 清理项保留。

## 4. 动态关闭条件

- AG-I18-01：LRQ 保存并恢复原事务 `halt_info`，用两条互异 metadata 指令交叉 replay，地址 trigger/DTU scoreboard 零错配。
- AG-I18-02：提供 producer assertion：`unit_stride_issue -> (start_offset + active_bytes <= 64)`；若允许跨界，则以两条 cache line 使用互异数据、第二页 fault 和 replay/flush 交叉证明拆分正确。
- AG-I18-03：断言捕获 PF/TLB miss 后直到事务离开 AG 值保持，并覆盖 1/N 拍结构反压。
- AG-I18-04：删除停用端口，或断言 PA-cache enable 恒 0 且所有 replay 都重新走 MMU。
