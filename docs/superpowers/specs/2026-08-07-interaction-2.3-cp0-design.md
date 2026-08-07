# Interaction 2.3 CP0 详细设计文档方案

## 1. 目标

依据 `README.md` 的 `interaction 2.3`，从本次新增的四个 CP0 RTL 文件生成一份可供系统级中断/异常验证人员直接使用的详细设计文档。文档必须区分“RTL 已实现行为”“上游/下游接口合同”“编译配置相关行为”和“待系统集成确认项”，不能把静态源码审查表述为动态仿真通过。

本轮不修改生产 RTL，不补造微架构需求，不把 RISC-V 规范中的通用规则覆盖到与源码不一致的实现上。设计基线为提交 `473b3c23794a7841f3c31fc667a4964fda9a28d4`。

## 2. 权威输入与读者

权威输入为：

- `README.md` 的 `interaction 2.3`；
- `cp0/wk_cp0_top.v`；
- `cp0/wk_cp0_iui.v`；
- `cp0/wk_cp0_regs.v`；
- `cp0/wk_cp0_lpmd.v`。

主要读者是开发系统级中断、异常、特权级切换、xRET、WFI 和 AIA 场景的验证人员。文档应使读者能够建立参考模型、选择采样点、编写断言和覆盖、定位失败路径，而不必先通读约一万行 CP0 RTL。

## 3. 方案比较与决策

### 方案 A：单篇验证导向、源码锚定的详细设计

在一篇 Markdown 中统一描述模块边界、时钟/复位、CSR、输入到 pending、使能、全局门控、委托、优先级、RTU trap 回写、向量入口、xRET、WFI、ECC、Debug 和 AIA，并在末尾提供验证场景、断言、覆盖及源码锚点。

优点是验证人员检索路径最短，流程上下文不被拆散；缺点是文档较长。它最符合 README 对“该设计文档”的单数表述和系统验证读者的使用方式。

### 方案 B：架构说明与验证指南拆分

将 RTL 设计和验证计划拆成两篇。维护边界清晰，但同一中断路径需要跨文档查找，且容易发生两篇之间的版本漂移。

### 方案 C：自动信号清单加短说明

自动提取端口、赋值和 case 表，再配一篇概述。生成成本低且容易刷新，但难以解释特权级、委托、状态栈和逐拍握手的组合语义，不能满足“详细设计”目标。

### 决策

采用方案 A。另提供一个小型可执行 RTL 合同检查器，机械提取并核对模块拓扑、中断源映射、中断优先级槽位和异常委托集合；详细语义仍由人工逐段源码复核。用户已明确后续安全步骤无需逐次批准，因此按该推荐方案直接执行。

## 4. 最终文档结构

最终文件为 `doc-cp0/wk_cp0_system_interrupt_exception_detailed_design.md`，至少包含：

1. 文档基线、适用范围和证据等级；
2. CP0 顶层架构图与三个子模块职责；
3. 时钟域、门控时钟、异步低有效复位和状态机；
4. 系统中断/异常相关顶层接口表，含方向、宽度、极性、采样域和接口合同；
5. CSR 指令、MRET/SRET/WFI 解码及非法指令异常路径；
6. 中断源到 pending、局部使能、全局使能、委托、优先级和 RTU 请求的完整路径；
7. RTU trap 元数据回写到 M/S trap CSR、状态栈和当前特权级的路径；
8. `mtvec/stvec`、`mepc/sepc` 与 xRET 返回路径；
9. WFI 排空、进入低功耗、唤醒和完成路径；
10. ECC、HPCP、Debug 与条件编译 AIA 路径；
11. 复位值与关键时序表；
12. 可直接实现的参考模型、断言、定向场景和覆盖建议；
13. 源码已观察到但需要集成确认的合同/风险；
14. 关键符号到 RTL 文件和行号的追踪表。

文档使用“实现行为”“接口合同”“验证要求”“待确认”四种标签，避免把推断写成既定设计。

## 5. 源码事实模型

### 5.1 模块拓扑

`wk_cp0_top` 只实例化三个 CP0 子模块：

- `wk_cp0_iui`：CSR/系统指令前端、IDLE/EX1/EX2/EX3 状态机、权限检查、CP0 本地非法指令异常、中断优先级编码及 RTU/LSU 中断请求；
- `wk_cp0_regs`：CSR 状态、pending/enable、委托、trap CSR、特权级、向量入口、xRET 返回 PC、ECC/AIA 状态；
- `wk_cp0_lpmd`：WFI 的 IDLE/SWAIT/LPMD 状态机、各单元 no-op 握手、时钟关闭和唤醒。

### 5.2 中断事实

检查器和文档共同固化以下源码合同：

- 基础源映射：MEI/MTI/MSI 来自 BIU，SEI/STI 与软件/AIA pending 合并，SSI 经 `mvssip` 保存，code 13 来自 HPCP，code 23 来自 ECC fatal 状态；
- `MIE/SIE` 提供局部使能，`mstatus.MIE/sstatus.SIE` 结合当前特权级控制是否可达；
- `mideleg` 同时参与 S 类和主要中断的 request 选择；trap 目标由返回 cause 经 `vec_num` 与 `mideleg_value[18:0]` 再分类，不能把 request 槽直接当 trap 目标；
- `int_sel[14:0]` 有 15 个优先级槽位，其中两个槽位硬连 0，IUI `casez` 从 bit 14 到 bit 0 固定优先级；
- `cp0_rtu_xx_int_b` 与 `cp0_lsu_xx_int_b` 为寄存后的低有效请求，`cp0_rtu_xx_vec` 为 5 bit cause；
- `rtu_cp0_int_ack` 目前只有端口/连线，没有参与 CP0 内部清 pending 或请求撤销；外部电平源必须由源端撤销，软件 pending 由 CSR 规则处理。

### 5.3 异常与 trap 事实

- IUI 对 CSR 地址、特权级、只读写、FS/VS/TW/TVM/TSR 及 AIA 非法条件进行资格检查；失败路径向 IU 送 illegal-instruction cause 2 和 32 bit opcode `mtval`；
- 其余系统异常/中断已经由 RTU 分类后，以 `rtu_yy_xx_expt_vec[5:0]`、`rtu_cp0_epc`、`rtu_cp0_expt_mtval` 和有效信号送入 CP0；CP0 不重新决定上游异常优先级；
- bit 5 表示 interrupt，低 5 bit 表示 cause；
- M 模式不委托。S/U 模式下，异常使用 `medeleg`、中断 trap 使用 `vec_num[18:0] & mideleg_value[18:0]`；MCIP request 可由 `mideleg_value[23]` 选入委托槽，但 cause 23 无 `vec_num` 行，所以 RTU 回送 cause 23 后实际分类为 M trap；
- trap 到 M 时更新 MPP/MPIE/MIE、MEPC/MCAUSE/MTVAL 和当前特权级；trap 到 S 时更新 SPP/SPIE/SIE、SEPC/SCAUSE/STVAL 和当前特权级；
- MRET/SRET 恢复当前特权级和全局使能，并输出半字地址形式的返回 PC；
- 向量地址由 `cp0_ifu_vbr` 输出当前目标特权级的 `mtvec/stvec` 值，CP0 内部没有形成 `BASE + 4*cause` 的完整地址，因此向量偏移属于下游合同。

### 5.4 WFI 事实

WFI 先要求 IFU/LSU/MMU/BIU 全部 no-op，再将 `lpmd_b` 置为 `00` 并关闭核心时钟。BIU 中断唤醒、事件唤醒、Debug 状态或 DTU 唤醒均可将 `lpmd_b` 恢复为 `11`。`regs_lpmd_int_vld` 只反映 pending 与局部使能，不套用当前特权级全局中断门控，这一行为必须与“唤醒不等于立即取 trap”分开验证。

## 6. 验证导向表达

最终文档按以下层次描述每条路径：

```text
source -> pending -> local enable -> privilege/global gate
       -> delegation/target -> fixed priority -> registered int request
       -> RTU accept/classify -> CP0 trap CSR/status update -> vector entry
       -> handler -> source clear -> xRET
```

验证参考模型需要逐项计算：

1. 每个 pending 源；
2. `pending && local_enable`；
3. 当前模式下非委托/委托路径是否允许；
4. 15 槽位向量和第一命中 cause；
5. 低有效请求的下一拍可见性；
6. RTU 回送 trap 后 M/S 目标、CSR 写值和状态栈；
7. xRET 恢复值和返回 PC；
8. pending 未清除时的重复请求行为。

定向场景至少覆盖：八种实现 cause、所有当前特权级、全局使能 0/1、委托 0/1、同拍多源优先级、源撤销、trap CSR 精确值、MRET/SRET、非法 CSR/非法 xRET/WFI、WFI 唤醒、ECC sticky/clear、AIA 打开/关闭两种编译配置和 Debug 进入/退出优先级。

## 7. 可执行合同工具

新增 `tools/check_interaction_2_3_cp0_contract.py`，只使用 Python 标准库。工具读取真实 RTL，输出稳定的 JSON/文本摘要，并在以下合同不成立时返回非零：

- 四个 module 声明存在，顶层准确实例化三个子模块；
- 八类中断源的赋值可解析；
- IUI 优先级 case 有 15 槽位、两个不可达槽位和 13 个有效槽位，cause 顺序与 RTL 基线一致；
- 实际可委托异常集合由 `vec_num` 解码和 `edeleg` 可写掩码交集得到；
- `rtu_cp0_int_ack` 在 `wk_cp0_regs` module body 中没有语义消费者；扫描忽略注释、字符串和无初始化声明，但必须识别 `wire/reg` 声明赋值及独立赋值中的引用；
- 以结构化 JSON 固化 MCIP cause23 的 request-side delegated=true、trap-side delegated=false；
- `key_paths` 必须精确包含五个预期键且均为 true；WFI 路径必须同时包含四个 `lpmd_ack` 输入和四个 wake 输入；
- 无效 CLI 参数也必须只输出单行 `CP0_CONTRACT_FAIL:` 并非零退出。

测试不检查中文句子或文档固定措辞。测试直接运行工具，并通过临时复制/最小变异验证错误的优先级 cause、缺失子模块、ACK 独立赋值/声明赋值消费者、MCIP request/trap 委托结构漂移，以及 WFI BIU ack/debug wake 缺失会被拒绝；注释/字符串不被误报。每个变异对应“设计文档已陈旧却仍被判定有效”这一具体故障。

## 8. 源码观察到的待确认项

最终文档必须显式列出而不擅自修复：

1. `rtu_cp0_int_ack` 当前未使用，请系统集成确认请求撤销完全依赖源 pending 变化；
2. `cp0_mret/cp0_sret` 的类型输出未直接带 `iui_privilege`，而寄存器状态更新带权限门控；非法 xRET 时必须验证异常路径不会被返回路径副作用覆盖；
3. `cp0_expt_vld` 在 flush 或下一次 EX2 更新前保持，消费端必须以流水线有效/flush 合同约束；
4. `medeleg` 写掩码允许 bit 0，但 `vec_num` case 未对 cause 0 生成 one-hot，因此 cause 0 实际不委托；
5. `mtvec/stvec` 保存两位 mode，却只读出 mode[0] 并把 bit 1 强制为 0；非法 mode 的 WARL 语义需按实现验证；
6. `rtu_cp0_expt_vld` 与 `rtu_yy_xx_expt_vld` 分别控制 trap CSR/状态栈和当前特权级更新，两个有效信号的周期一致性属于 RTU-CP0 接口合同；
7. AIA/major-interrupt 集成项：`ADD_AIA` 只条件编译 IMSIC 接口与部分 CSR 地址资格，主要中断数组仍依赖仓库外提供的 `WK_MAJOR_*` 宏；同时 MCIP request 侧可用 `mideleg_value[23]` 选择委托槽，但 trap 侧因 `vec_num` 无 cause23 而分类为 M；需确认两种配置的宏/filelist/功能闭合及该 request/trap 目标不一致是否为系统预期；
8. `cp0_ifu_vbr` 只携带 base 和 mode 低位，向量偏移计算没有出现在本次 CP0 RTL 中；
9. 外部端口 `biu_cp0_ss_int` 被置位保存到 `mvssip`，清除依赖 CSR 路径而不是输入回落，需验证软件清除和重复置位。

这些项目在动态验证前保持“待集成确认”，不能写成已通过或已确认 bug。

## 9. 交付与检查边界

预期交付：

- `doc-cp0/wk_cp0_system_interrupt_exception_detailed_design.md`；
- `tools/check_interaction_2_3_cp0_contract.py`；
- `tests/test_interaction_2_3_cp0_contract.py`；
- `docs/interaction-2.3-followup-review.md`；
- 本设计说明与后续 implementation plan。

静态验收包括：新工具及其变异测试、全仓 Python 单元测试、既有 LSU preflight、`git diff --check`、生产 RTL 零差异、文档链接检查和最终分支/远端一致性。没有完整 CP0 filelist、`WK_MAJOR_*` 宏、外部单元及许可仿真结果时，不宣称 CP0 编译、仿真、代码覆盖率或功能覆盖率通过。
