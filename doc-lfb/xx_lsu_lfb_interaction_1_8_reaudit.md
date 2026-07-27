# `xx_lsu_lfb` / entry Interaction 1.8 第二轮设计审查

## 1. 范围与基线

- 审查基线：`4a8223a2d80a5da6a7198c6fc89d97790b9729c3`。
- 可见对象：`xx_lsu_lfb`、`xx_lsu_lfb_addr_entry`。
- 预期但缺失对象：`xx_lsu_lfb_data_entry`。
- 覆盖 address/data allocation、BIU R response、VB replacement、refill、dependency wakeup、SNQ bypass 和 flush；并对照官方 OpenC910 提交 `b91c90914c19f114d35c8f6b73408eb241ed847c` 的三个 LFB 文件。

## 2. 结论

| ID | 优先级 | 状态 | 结论 |
|---|---:|---|---|
| LFB-I18-01 | P1 | 已确认，集成阻塞 | `xx_lsu_lfb` 实例化两个 `xx_lsu_lfb_data_entry`，仓库却没有该 module 定义，当前源码集无法 elaboration。 |
| LFB-I18-02 | P1 影响 | 验证义务 | 因 data entry 源码缺失，R beat/last、data full、addr/data ID owner、pop 和 SNQ bypass 的核心状态无法完成静态审查。 |
| LFB-I18-03 | P2 影响 | 合同依赖 | visible address entry 的 pop/create、VB result 和 response owner 需用 generation scoreboard 证明；静态未发现新增确定 bug。 |
| LFB-I18-04 | P3 | 已确认，观察项 | HAD wakeup queue 只导出 lane0 bitmap并附一个 MCIC bit，不能代表全部 lane 状态。 |

LFB-I18-01 是本次重新审查发现的新增确定问题。它属于源码交付/集成完整性缺陷；在补齐文件前，不能声称“LFB 含 entry 已完成审查”。

## 3. 详细证据

### LFB-I18-01：data entry module 缺失

`xx_lsu_lfb` 在 `srcs/xx_lsu_lfb.sv:709`～`749` 实例化 data entry 0，在 `srcs/xx_lsu_lfb.sv:752`～`789` 实例化 data entry 1。对 `srcs/` 全目录检索没有任何 `module xx_lsu_lfb_data_entry` 定义；当前仅提供 `srcs/xx_lsu_lfb_addr_entry.sv`。

官方 OpenC910 同一目录同时提供 `ct_lsu_lfb.v`、`ct_lsu_lfb_addr_entry.v` 和 `ct_lsu_lfb_data_entry.v`，说明 data entry 不是可由 top 内部逻辑替代的可选模块。当前仓库至少在编译/展开阶段会报 unresolved module。

### LFB-I18-02：缺失源码正好覆盖核心 response owner

top 把 `biu_lsu_r_data/user/last/vld`、addr ID、create DP/function valid、linefill permit/abort、data pop 和 SNQ invalid 全部送入 data entry（`srcs/xx_lsu_lfb.sv:715`～`748`）。其输出再决定 data full/vld/last、refill state、addr pop 和 bypass data ID。缺失模块使以下问题无法由当前仓库证明：

- 同 ID 的每个 R beat只写入一个 live data entry；
- `last`、full、pop 与 addr ID 生命周期一致；
- flush/abort 后迟到 response 不会修改新 owner；
- 两个 data entry 的 bypass/refill payload 不串项。

### LFB-I18-03：visible address entry 未见新增确定 bug

address entry valid 以 pop 优先于 create（`srcs/xx_lsu_lfb_addr_entry.sv:232`～`239`），create payload在独立 create clock保存（`srcs/xx_lsu_lfb_addr_entry.sv:245`～`284`），VB replacement结果只在 live entry时推进（`srcs/xx_lsu_lfb_addr_entry.sv:291`～`325`）。静态结构与官方来源接近，但正确性仍依赖 data entry 回收和 BIU/VB owner 合同。

### LFB-I18-04：debug 可见性不完整

HAD 输出在 `srcs/xx_lsu_lfb.sv:1741`～`1747` 中只选择 `lfb_wakeup_queue[0]`，没有导出其它 load/store lane 的 dependency bitmap。这不影响功能 datapath，但调试现场可能不完整，列为 P3 观察项。

## 4. 动态关闭条件

- LFB-I18-01：补齐与当前 top 端口/宏一致的 `srcs/xx_lsu_lfb_data_entry.sv`，加入正式 filelist，并完成无 unresolved module 的 elaboration。
- LFB-I18-02：以 `{addr_id,data_id,BIU_id,generation}` 建 scoreboard，覆盖两 data entry、乱序两地址项、early/late last、error、abort、flush 和立即复用。
- LFB-I18-03：断言 create/pop 同拍、VB grant 和 response set 都只作用于 live matching owner。
- LFB-I18-04：若 HAD 要求完整现场，导出全部 lane 或明确采样选择；否则形成 debug waiver。
