# Interaction 2.1 AG 复核记录

## 1. 本轮补齐内容

AG 的12个父功能点均由4个场景扩展为8个叶级场景，共96行。新增场景覆盖边界值、
反压、flush、owner切换、迟到响应和相邻真值表结果；CSV、Markdown、testcase、
checker、coverage和关闭状态继续使用同一追踪链。

README点名的组合落在 `AG-FP-05-S07`：先让fresh owner因D-cache拒绝形成
`lag_ex1_stall_ori=1` 并保存LRQ id；下一拍由更老RF请求拉高
`idu_lsu_rf_older_vld`，同时令 `mmu_lsu_pa_vld=0`，并通过已建立owner的
延迟access-fault输入产生 `lsu_mmu_abort=1`。组合观察点必须得到
`lsu_lrq_create_frz=0` 和非零 `lag_ex1_stall_restart_entry`。

该路径没有直接驱动DUT输出 `lsu_mmu_abort`。testbench驱动真实MMU输入，
`CHK_FP05_MASK_ABORT_REPLAY` 检查立即重发不被冻结，
`COV_FP05_MASK_ABORT_TABLE` 记录指定真值表组合。

## 2. 本地证据与边界

- 共享端口生成检查：258个AG端口一致；
- 场景契约：12个feature、96个scenario、每feature至少8行；
- interaction 1.9/2.0回归合同保留为下界，不因2.1扩展而失效；
- reference model仍执行211个case，并保留3个已知源码finding；
- 本机没有VCS/URG，因此SV driver、SVA和cover只完成静态结构检查，动态状态为
  `BLOCKED_NO_VCS`；生产helper替换后的回归仍为 `PENDING_FULL_CHIP`。

不得把静态preflight或Python测试结果表述成VCS simulation、functional
coverage或code coverage已通过。
