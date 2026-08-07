# WK CP0 系统、中断与异常详细设计（验证导向）

> 基线：`473b3c23794a7841f3c31fc667a4964fda9a28d4`；更新规则：每次 CP0 RTL、宏定义或接口改变后，先运行本文末尾合同检查器，再人工复核本页锚点。读者为系统级中断、异常、特权、低功耗与 AIA 验证人员。
>
> 范围边界：本文仅描述 `wk_cp0_top/iui/regs/lpmd` 中可观察的合同，不修改 RTL，也不把静态审查写成编译、仿真或覆盖率签核。仓库缺少完整 CP0 filelist、外部宏/模块（含 `WK_MAJOR_*`）及系统级集成环境；这些均不得由本文推断为已通过。

## 1. 证据等级、架构和时钟复位

本文以四种标签陈述每个结论：

|标签|含义与验证处理|
|---|---|
|**RTL实现**|由本次四个 RTL 文件直接观察到；可据此写静态检查、断言或参考模型。|
|**接口合同**|端口或下游/上游必须满足的约定；CP0 文件本身不能单独证明对方实现。|
|**验证要求**|必须由 testbench、formal 或系统仿真验证的行为，不等于已签核。|
|**待集成确认**|源码可见但语义、宏配置或时序依赖外部模块；保留问题，不擅自修复或认定为 bug。|

### 1.1 总体流和职责

```text
BIU/HPCP/ECC/AIA source
          |                 IU system instruction
          v                         |
  wk_cp0_regs: pending/enable/delegation <--- wk_cp0_iui: decode/privilege/FSM
          |                                   |
          +--> int_sel[14:0] --> registered active-low request/vector --> RTU
                                                                     |
RTU trap vector/EPC/TVAL/valid ------------------------------------+
          v
  wk_cp0_regs: xEPC/xCAUSE/xTVAL, xPP/xPIE/xIE, privilege, VBR
          |                                                  |
          +--> IFU vector base / IU xRET halfword PC <------+
          |
          +--> regs_lpmd_int_vld --> cp0_biu_int_vld --> BIU --> biu_cp0_int_wakeup
```

|模块|**RTL实现**职责|主要锚点|
|---|---|---|
|`wk_cp0_top`|仅组合本设计涉及的 IUI、REGS、LPMD 三子模块和端口连线。|`cp0/wk_cp0_top.v:1042`, `:1162`, `:1475`|
|`wk_cp0_iui`|系统指令前端、IDLE/EX1/EX2/EX3、CSR 合法性、CP0 本地 illegal-instruction、固定中断编码与寄存请求。|`cp0/wk_cp0_iui.v:928-1027`, `:1406-1505`, `:1680-1805`, `:1967-2054`|
|`wk_cp0_regs`|CSR、pending/enable/delegation、M/S trap 状态、当前特权、xRET/向量、ECC 与 AIA。|`cp0/wk_cp0_regs.v:2144-2247`, `:2280-2371`, `:2382-2481`, `:2531-2944`, `:3207-3268`|
|`wk_cp0_lpmd`|WFI 的 no-op 会合、低功耗请求、门钟和四类唤醒。|`cp0/wk_cp0_lpmd.v:161-265`|

|时钟/复位对象|时钟|复位|**RTL实现**含义|
|---|---|---|---|
|IUI 控制|`cpuclk`（由 CP0 ICG 导出）|异步低有效 `cpurst_b`|执行 IDLE/EX1/EX2/EX3 与 CP0 本地异常寄存。|
|REGS 事务/状态|`forever_cpuclk`、`regs_flush_clk`（具体 CSR 块不同）|异步低有效 `cpurst_b`|保存 CSR、pending、trap 状态和特权模式。|
|LPMD FSM|门控 `cpuclk`；`lpmd_b` 在 `forever_cpuclk`|异步低有效 `cpurst_b`|先排空再关钟；唤醒路径不依赖被关的 `cpuclk`。|

### 1.2 关键接口合同

下表的宽度为源码中可确定的最小有效位宽；`1` 表示单比特。除 `*_b` 外，各有效/中断信号按高有效理解。采样边沿须以连接模块实际时钟为准。

|接口组|方向（相对 CP0）|宽度/极性/域|意义与合同|
|---|---|---|---|
|`biu_cp0_me_int/ms_int/mt_int/se_int/st_int/ss_int`|输入|1，高有效，`forever_cpuclk` 相关|BIU 外部/软件/定时源；`ss_int` 进入 sticky `mvssip`，不能以输入回落替代软件清除。|
|`biu_cp0_int_wakeup`, `biu_cp0_event_wakeup`, `dtu_cp0_wake_up`, `rtu_yy_xx_dbgon`|输入|1，高有效，常开唤醒逻辑|四类 WFI 唤醒；它们与可取 trap 的资格不同。|
|`hpcp_cp0_int_vld`|输入|1，高有效|对应 cause 13（MOIP）。|
|`rtu_cp0_epc`, `rtu_cp0_expt_mtval`|输入|64|RTU 提供的 trap EPC/TVAL。|
|`rtu_yy_xx_expt_vec`|输入|6，高位为 interrupt、低 5 位 cause|RTU 已完成其它系统异常/中断分类；CP0 据此写 cause。|
|`rtu_cp0_expt_vld`, `rtu_yy_xx_expt_vld`|输入|各 1，高有效|前者控制 trap CSR/status，后者参与当前特权更新；双有效周期一致性是**待集成确认**。|
|`rtu_cp0_int_ack`|输入|1，高有效|**RTL实现**：没有内部消费者；不得假定 ack 清 pending 或撤销请求。|
|`cp0_rtu_xx_int_b`, `cp0_lsu_xx_int_b`|输出|1，低有效、`forever_cpuclk` 寄存|有任一 `int_sel` 时下一状态为 0；无选中时为 1。|
|`cp0_rtu_xx_vec`|输出|5，寄存保持|优先命中的 cause；无新请求时保持上一值。|
|`cp0_dtu_mexpt_vld`, `cp0_dtu_priv_mode`|输出|1/2|M 目标 trap 可见性与当前特权给 debug；前者由 `rtu_yy_xx_expt_vld & ~mdeleg_vld`。|
|`cp0_iu_ex3_expt_vld/vec/mtval`|输出|1/5/32|CP0 本地非法指令：cause 2，TVAL=opcode；valid 保持至 flush 或下一 EX2 更新。|
|`cp0_iu_ex3_mret/sret`, `cp0_iu_ex3_efpc[_vld]`|输出|1/1/`PC-1`|IUI 类型输出与 REGS xRET 返回半字地址；return 类型与 privilege 门控关系见第 7 节。|
|`cp0_ifu_vbr`|输出|`WK_PC_WIDTH`|当前 M/S 目标 `mtvec/stvec` base 加 mode[0]；完整向量 offset 属下游合同。|
|`cp0_biu_int_vld`|输出|1，高有效、常开低功耗路径|CP0 对 BIU 的 local-enabled pending 通知；它本身不直接唤醒 CP0，BIU 若决定唤醒须回送 `biu_cp0_int_wakeup`。|
|`cp0_biu_lpmd_b`, `cp0_yy_clk_en`|输出|2，低有效编码 / 1|低功耗请求 `00` 与核心时钟使能；BIU 必须配合 no-op。|
|`regs_iui_pm`, `regs_iui_v`|REGS→IUI|2/1|当前特权 M=`11`、S=`01`、U=`00` 和虚拟模式资格输入。|

## 2. 指令控制和 CP0 本地异常

### 2.1 IUI 流水状态

|状态|**RTL实现**动作|提交/flush 合同|
|---|---|---|
|IDLE|等待 `idu_cp0_rf_sel`。|收到 RF 选择进入 EX1。|
|EX1|锁存/读取 CSR 需要的数据。|等 `cp0_read_cmplt` 后去 EX2。|
|EX2|等待完成，`iui_ex2_commit` 要求 `commit0` 的 IID 与 EX1 IID 相等。|仅 `cp0_ex2_select && commit` 允许 CSR 写或合法 xRET；older flush 回 IDLE。|
|EX3|请求回写/结果总线。|`cp0_iu_ex3_inst_vld` 仅在 EX3 select；下一拍 IDLE。|

**RTL实现**：`rtu_yy_xx_flush`、RF/EX1/EX2 中对应 older flush 都清 FSM；`cp0_select` 是阶段选择并在 EX3 加 `iui_flop_commit`。CSR 地址无效、特权级、只读写、FS/VS、TW/TVM/TSR、计数器和可选 AIA IMSIC 合法性共同形成 `iui_privilege`。M/S/U 判定为 `11/01/00`；S 访问 M CSR/MRET、受 TSR/TW/TVM 限制的操作为非法，U 访问 S/M CSR、xRET/WFI 为非法。见 `wk_cp0_iui.v:1406-1505`, `:1680-1805`。

### 2.2 本地 illegal-instruction 路径

**RTL实现**：`!iui_privilege && cp0_ex2_select` 产生本地异常；`cp0_iu_ex3_expt_vec=5'h2`，`cp0_iu_ex3_mtval=iui_opcode[31:0]`。`cp0_expt_vld` 在 reset/`rtu_yy_xx_flush` 清零，在任何 EX2 被下一值覆盖，否则保持。**验证要求**：消费者必须用流水线 valid/flush 约束该保持行为，不能把其当成单拍脉冲。

## 3. 中断：源、资格、优先级和请求

### 3.1 source-to-pending 与局部使能

|cause|名称|**RTL实现** pending 源|局部 enable / pending CSR|
|---:|---|---|---|
|1|SSIP|`mvssip`（`biu_cp0_ss_int` 可置位保存）|`ssie`；`MIP/SIP` 位 1|
|3|MSIP|`biu_cp0_ms_int`|`msie`；`MIP` 位 3|
|5|STIP|`stip_s | biu_cp0_st_int`|`stie`；`MIP/SIP` 位 5|
|7|MTIP|`biu_cp0_mt_int`|`mtie`；`MIP` 位 7|
|9|SEIP|`seip_s | biu_cp0_se_int`|`seie`；`MIP/SIP` 位 9|
|11|MEIP|`biu_cp0_me_int`|`meie`；`MIP` 位 11|
|13|MOIP|`hpcp_cp0_int_vld`|直接 `moie && moip` 进入 enable/priority/select；CSR alias/delegation 见下方**待集成确认**。|
|23|MCIP|`ecc_int_vld = ecc_vld && (dcache_ecc_vld || err_fatal)`|直接 `mcie && mcip` 进入 enable/priority/select；CSR alias/delegation 见下方**待集成确认**。|

**RTL实现**：cause 1/3/5/7/9/11 的 CSR pending/enable 路径按 MIP/MIE（及可见的 SIP/SIE）组合；表中 source 由机械检查器提取。对 cause 13/23，`moip/mcip`、`moie/mcie`、`*_en`、`*_nodeleg_vld`/`*_deleg_vld` 与 `int_sel` 有无条件的直接实现，故 source→enable→priority/select 可独立验证。

**RTL实现 / 待集成确认（cause 13/23 CSR/delegation）**：13/23 在 `MIE/MIP/SIE/SIP` 的 CSR alias/readback 以及 `mideleg[13/23]` 的可写/委托值使用 AIA major arrays；这些 arrays 由仓库外 `WK_MAJOR_INT_NUM`、`WK_MAJOR_SUPER_INT_MASK`、`WK_MAJOR_HYPER_INT_MASK`（以及 virtual mask）生成，本工作树不能证明实际 mask 配置。另有一个不依赖宏取值的结构事实：请求侧 `mcip_deleg_vld` 可由 `mideleg_value[23]` 选入 S 槽，但 trap 侧 `mideleg_vld` 仅计算 `vec_num[18:0] & mideleg_value[18:0]`，且 `vec_num` 没有 cause 23 decode。因此 RTU 回送 interrupt cause 23 时 `mideleg_vld=0`，trap CSR/status/`pm` 按 M 目标更新，即使该请求来自 delegated MCIP 槽。动态验证应分别按实际宏配置比对 CSR/readback/request delegation，并把 cause-23 request target 与 returned-trap target 分开建模。关键赋值在 `wk_cp0_regs.v:2295-2371`, `:2610-2714`, `:2731-2792`, `:2925-2944`, `:5597-5735`，ECC 在 `:3966-4036`。

将每个 cause 的候选写为：

```text
P[c] = source/csr-pending[c]
L[c] = P[c] && local_enable[c]               // MIE/SIE 对应位
M_eligible[c] = L[c] && !mideleg[c] && (pm==M ? mstatus.MIE : 1)
S_request_eligible[c] = L[c] && mideleg[c] && (pm==S ? sstatus.SIE : pm==U)
```

上式只计算 request 侧：非委托路径在 M 当前模式须 `MIE=1`，在 S/U 可达；委托请求路径仅在 S/U 可达，在 S 当前模式须 `SIE=1`。实际 RTL 对 M 专属 cause（MEI/MSI/MTI）以 M 路选择，对 S/major cause 使用相应 nodeleg/deleg 选择；比较必须以 `int_sel` 为最终裁决。RTU 回送后的 trap 目标必须再由 `mideleg_vld` 独立计算，不能沿用 request 槽目标。

|当前模式|`mideleg[c]`|M request 槽|S request 槽|request 侧说明|
|---|---:|---|---|---|
|M|0|`MIE && L`|否|M 不产生 S 委托请求。|
|M|1|否|否|**RTL实现**委托 S request 仅 S/U 允许。|
|S|0|`L`|否|高特权 M 中断无需 SIE。|
|S|1|否|`SIE && L`|委托到 S。|
|U|0|`L`|否|非委托转 M。|
|U|1|否|`L`|委托转 S。|

|RTU 回送 interrupt cause|`vec_num` one-hot / `mideleg_vld`|trap 目标|
|---:|---|---|
|1、5、9、13（相应 `mideleg` 位有效）|有对应 one-hot；在 S/U 可与 `mideleg_value[18:0]` 相交|S；否则 M。|
|23|无 cause-23 one-hot；不能参与 19-bit 相交|固定分类为 M。|

### 3.2 15 槽固定优先级

`int_sel[14:0]` 从 bit14 到 bit0 的第一命中即为 cause。必须保留所有 15 decode 行，而不是压缩成 13 行；slots 13 和 4 是硬连 0、在当前实现不可达，但 casez 仍含 code 18 行。

|slot / `int_sel` bit|casez 首选 cause|live|来源/目标|
|---:|---:|---|---|
|14|23|是|MCIP 非委托（M）|
|13|18|否，硬连 0|MHIP decode 遗留行|
|12|11|是|MEIP|
|11|3|是|MSIP|
|10|7|是|MTIP|
|9|9|是|SEIP 非委托（M）|
|8|1|是|SSIP 非委托（M）|
|7|5|是|STIP 非委托（M）|
|6|13|是|MOIP 非委托（M）|
|5|23|是|MCIP 委托 request 槽；RTU 回送 cause 23 后 trap 仍分类为 M|
|4|18|否，硬连 0|MHIP decode 遗留行|
|3|9|是|SEIP 委托（S）|
|2|1|是|SSIP 委托（S）|
|1|5|是|STIP 委托（S）|
|0|13|是|MOIP 委托（S）|

**RTL实现**：`int_vld=|int_sel`；`iui_int_vld_b` 与 `iui_int_vec` 均在 `forever_cpuclk` 寄存。若本拍有任何选择，下一状态 `*_int_b=0` 且向量更新为首命中 cause；若没有选择，`*_int_b=1`，`iui_int_vec` 保持。因此 vector 在请求期间及其后可保持，scoreboard 应只在有效低时比对新 cause。锚点：`wk_cp0_regs.v:2646-2714`, `:5006-5014`；`wk_cp0_iui.v:2004-2054`。

**接口合同**：`rtu_cp0_int_ack` 不参与 CP0 内部清除、去请求或向量更新。外部电平中断由源端撤销；软件 pending 依 CSR 写路径清除。**验证要求**：施加 ack 而不改变源时，应证明请求仍由 `int_sel` 决定；不要错误把 ack 当清除信号。

### 3.3 WFI wake 与 trap 资格分离

`regs_lpmd_int_vld = meip_en || mtip_en || msip_en || seip_en || stip_en || ssip_en || mcip_en || moip_en`，只看 pending/local enable，不使用上述 `pm`/global-enable/delegation trap 门控。**RTL实现**：LPMD 仅将它转发为 `cp0_biu_int_vld` 通知 BIU；真正把 `lpmd_b` 恢复为 `11` 的 interrupt 输入是 BIU 回送的 `biu_cp0_int_wakeup`，另有 event/debug/DTU 三类输入。故 BIU 是否因通知产生 wake 是**接口合同**，`regs_lpmd_int_vld` 不直接唤醒 CP0；wake 也不等于立即向 RTU 送 trap。此区别必须独立覆盖。

## 4. 异常、trap entry、向量和 xRET

### 4.1 两条异常入口与委托

|入口|产生/携带者|**RTL实现**处理|
|---|---|---|
|CP0 本地非法 CSR/系统指令|IUI|cause 2、32-bit opcode MTVAL 到 IU；其后由系统 trap 流程接收。|
|RTU 系统 trap|RTU|`rtu_yy_xx_expt_vec[5:0]`、EPC、MTVAL 与 valid 输入 REGS；CP0 不重新判上游异常优先级。|

有效异常委托不是“所有 medeleg 位可写”这一泛化说法。对非 interrupt 的 `vec_num` 路径，**RTL实现**有效可委托集合为 `{1,2,3,4,5,6,7,8,9,12,13,15}`。cause `0,10,11,14` 没有对应 decode；cause 16/17/18 虽然在 19-bit `vec_num` 中有 one-hot decode，但 `medeleg_vld` 计算为 `|(vec_num[15:0] & edeleg[15:0])`，高三位在此截断，故仍不能有效委托；其余 `>=19` 不被该 decode 枚举。`medeleg` 写掩码虽包括 bit 0，却没有对应 one-hot decode，故 cause 0 实际不委托（第 7 节保留为待确认项）。同一 `vec_num` 也供 interrupt 的 `mideleg_vld` 使用；因此 cause 23 无 decode 会造成上一节所述的 request/trap 目标不一致。

|cause 范围|`medeleg[c]=1` 的有效性|目标规则|
|---|---|---|
|1–9, 12, 13, 15|有效|来自 S/U 的非中断 trap 进入 S；否则 M。|
|0, 10, 11, 14|非有效|进入 M。|
|16–18|有 `vec_num` decode、但在 `vec_num[15:0] & edeleg[15:0]` 被截断，非有效|进入 M。|
|>=19|无该 `vec_num` decode，非有效|进入 M；扩展行为须另行集成证实。|

### 4.2 trap CSR 与状态栈写入

|目标|xEPC|xCAUSE|xTVAL|状态栈|当前特权|
|---|---|---|---|---|---|
|M（`!mdeleg_vld`）|`mepc[63:1] <= rtu_cp0_epc[63:1]`，读回 bit0=0|`mintr <= vec[5]`; `m_vector<=vec[4:0]`|`mtval_upd_data`|`MPP<=pm`; `MPIE<=MIE`; `MIE<=0`|M (`11`)|
|S（`mdeleg_vld`）|`sepc[63:1] <= rtu_cp0_epc[63:1]`，读回 bit0=0|`sintr <= vec[5]`; `s_vector<=vec[4:0]`|`stval_upd_data`|`SPP<=pm[0]`; `SPIE<=SIE`; `SIE<=0`|S (`01`)|

这些更新以 `rtu_cp0_expt_vld`/`mdeleg_vld` 控制（状态/CSR），而当前 `pm` 的更新使用 `rtu_yy_xx_expt_vld` 或 xRET。**待集成确认**：两个 RTU valid 必须对同一 trap 周期一致，避免 CSR 已写但 mode 未切换或相反。源锚点：`wk_cp0_regs.v:2144-2247`, `:2531-2714`, `:2731-2944`, `:3207-3268`。

### 4.3 同拍并发优先级

**RTL实现（当前特权 `pm`）**：当 `pm_wen` 为 1，`pm_wdata` 的精确优先级为 `rtu_cp0_exit_debug` > `rtu_cp0_enter_debug` > `iui_regs_inst_mret` > `iui_regs_inst_sret` > RTU trap target（`!mdeleg_vld`→M，`mdeleg_vld`→S）。因此同拍 debug exit/enter、xRET 与 trap 不能按“先后到达”的抽象规则比较，必须按此组合链采样。

**RTL实现（status-stack）**：各 M 状态栈寄存器（MPP/MPIE/MIE）的优先级为 M trap > MRET > 对应 status CSR write；各 S 状态栈寄存器（SPP/SPIE/SIE）为 S trap > SRET > 对应 status CSR write。

**RTL实现（trap CSR）**：MEPC/MCAUSE/MTVAL 的优先级为 M trap > 对应 CSR write；SEPC/SCAUSE/STVAL 为 S trap > 对应 CSR write。xRET 只读取 xEPC 并更新 status-stack/`pm`，不是这些 trap CSR 的竞争写入者。故同拍 matching trap+xRET 时 status-stack 取 trap 值；trap CSR 也仅因 trap 覆盖同拍 CSR write，而非“trap 胜 xRET”。`pm` 仍按上表的 debug/xRET/trap 链更新。这种 dual-valid/并发组合必须由集成 testbench 显式约束或覆盖。锚点：`wk_cp0_regs.v:2144-2247`, `:2531-2600`, `:2846-2912`, `:3207-3268`。

|事件|前置|状态转移|返回/后效|
|---|---|---|---|
|M trap|RTU trap、未有效委托|`pm -> M`；保存原 `pm` 到 MPP；`MPIE<-MIE, MIE<-0`|IFU 读取 M `mtvec`。|
|S trap|RTU trap、有效委托、来自 S/U|`pm -> S`；`SPP<-pm[0]`; `SPIE<-SIE, SIE<-0`|IFU 读取 S `stvec`。|
|MRET|IUI 资格通过、EX2|`pm<-MPP`; `MIE<-MPIE`; `MPIE<-1`; `MPP<-U(00)`|`efpc=mepc[PC-1:1]`。|
|SRET|IUI 资格通过、EX2|`pm<-{0,SPP}`; `SIE<-SPIE`; `SPIE<-1`; `SPP<-0`|`efpc=sepc[PC-1:1]`。|

**验证要求**：非法 MRET/SRET 应走 cause-2 路径；由于 IUI 的 `cp0_mret/cp0_sret` 类型输出本身没有直接附加 `iui_privilege`，必须观察 REGS 的 `iui_regs_inst_*ret` 门控及 trap 优先级，不能只看类型脚。

### 4.4 vector 与返回 PC

`mtvec/stvec` 内部保存 base 与两位 mode，但 CSR readback `mtvec_value/stvec_value={base,1'b0,mode[0]}` 强制 mode bit1 为 0；读给 IFU 的 `cp0_ifu_vbr` 同样选择当前 `pm` 的 base、保留 mode[0]、强制 mode[1]=0。`mepc/sepc` 写入/读回清 bit0；`cp0_iu_ex3_efpc` 以半字地址输出 `mepc/sepc[WK_PC_WIDTH-1:1]`，`efpc_vld=cp0_mret||cp0_sret`。锚点：`wk_cp0_regs.v:2461-2481`, `:2772-2792`, `:5006-5014`, `:5145-5186`。

**接口合同 / 待集成确认**：CP0 没有计算 `BASE + 4*cause`；下游 IFU/vector 逻辑必须定义 vectored offset、何时采用 mode 和对齐。`mode[1]` 的被清行为使非法 mode 的 WARL 语义只能按此实现验证，不能借通用规范臆断。

## 5. WFI、ECC、Debug、AIA、复位和时序

### 5.1 WFI/LPMD

|状态|进入条件|输出/离开|
|---|---|---|
|IDLE (`00`)|reset、flush 或没有 WFI|`inst_lpmd_ex1_ex2` 时入 SWAIT。|
|SWAIT (`01`)|前一拍有效 WFI 使 FSM 从 IDLE 进入|`*_no_op_req` 来自已寄存的 `lpmd_in_wait_state`；仅 `ifu && lsu && biu && mmu` 四个 no-op 都为 1 时进 LPMD。|
|LPMD (`10`)|得到 `lpmd_ack`|若 `cpu_in_lpmd` 解除则回 IDLE，并给 `lpmd_cmplt`。|

**RTL实现**：`lpmd_ack` 包含四个确认，`lpmd_b` reset=`11`，在 ack+有效 WFI 时写 `00`；BIU interrupt wake、event wake、RTU debug-on 或 DTU wake 之一使其恢复 `11`；`cp0_yy_clk_en=lpmd_b[1]&lpmd_b[0]`。`regs_lpmd_int_vld` 只经 `cp0_biu_int_vld` 通知 BIU，RTL 没有将它直接接到 `lpmd_b` 的 wake 条件；BIU 反馈 `biu_cp0_int_wakeup` 才是 interrupt wake。WFI/flush 在 SWAIT 的竞争以源码优先级为准。锚点：`wk_cp0_lpmd.v:161-265`。

### 5.2 ECC、Debug 和 AIA

- **RTL实现（ECC）**：ECC 状态由选择/粘滞记录、修正计数和 fatal 状态构成；`ecc_int_vld=ecc_vld&&(dcache_ecc_vld||err_fatal)`，最终成为 cause 23/MCIP。软件清除/选择应以 CSR local-enable 写路径验证，不能用 source 回落替代。锚点 `wk_cp0_regs.v:3966-4036`。
- **RTL实现（Debug）**：特权模式更新中 debug enter/exit 与 trap/xRET 同在 `pm_wen` 路径；`cp0_dtu_mexpt_vld=rtu_yy_xx_expt_vld & ~mdeleg_vld`。测试必须同时刺激 debug 与 trap/xRET 检验优先级。锚点 `wk_cp0_regs.v:3207-3268`, `:5574-5579`。
- **RTL实现（AIA）**：`ADD_AIA` 条件编译 IMSIC bridge、原始 `mip_raw/sip_raw` 和部分 CSR 非法资格；major-interrupt 选择/`MVIEN/MVIP/MTOPI/STOPI` 逻辑仍无条件写在 REGS，`MTOPI/STOPI` 固定按其各自选择数组优先编码。**待集成确认**：本仓库不含所需 `WK_MAJOR_*` 宏和完整 filelist，不能证明 `ADD_AIA` 开/关均可编译或功能闭合。锚点 `wk_cp0_regs.v:5597-6104`。

### 5.3 reset 清单与逐拍观测

|对象|reset 可见值（**RTL实现**）|
|---|---|
|当前 `pm`|M (`11`)；`mpp=11`, `spp=1`|
|全局/保存 IE|`MIE/SIE/MPIE/SPIE=0`|
|trap CSR|`mepc/sepc`, cause、tval 为 0|
|vector CSR|`mtvec/stvec` base/mode 为 0|
|local enable 与软件 pending|实现的 MIE/SIE/pending 状态均清 0；`mvssip=0`|
|低功耗|LPMD state=IDLE，`lpmd_b=11`，clock enable=1|

|事务|cycle N|cycle N+1 / 可观测点|
|---|---|---|
|中断检测|组合 `P/L/eligible/int_sel` 出现|`*_int_b=0`、vec 更新；撤源后下一状态 `*_int_b=1`，vec 保持。|
|RTU trap 写入|RTU valid+vec/EPC/TVAL 采样|对应 M/S CSR、status stack 写入；`rtu_yy_xx_expt_vld` 驱动 mode 更新。|
|xRET|合法 IUI 在 EX2，REGS `inst_*ret`|恢复 IE/privilege，输出半字 `efpc` 与 valid。|
|WFI|EX1/EX2 有效 WFI 使下一状态进入 SWAIT|SWAIT 已寄存后拉 no-op request；四 ack 后 `lpmd_b=00`/clock off；CP0 只由 BIU 回送 `biu_cp0_int_wakeup` 或 event/debug/DTU wake 回 `11`/完成。|

## 6. 可实施验证合同

### 6.1 独立参考模型伪代码

以下模型不得复用 DUT `int_sel`、`casez` 或 DUT CSR；它以采样的端口/CSR 镜像独立算出期望，再在请求低有效、RTU trap 和 xRET 事务边界采样。

```text
function pending(s):
  return {1:s.mvssip, 3:s.biu_ms, 5:s.stip_s|s.biu_st, 7:s.biu_mt,
          9:s.seip_s|s.biu_se, 11:s.biu_me, 13:s.hpcp,
          23:s.ecc_vld & (s.dcache_ecc_vld | s.err_fatal)}

function request_eligible(c, s):
  local = pending(s)[c] & s.local_enable[c]
  if !local: return NONE
  if s.mideleg[c] == 0:
     return M if (s.pm != M || s.mstatus_mie) else NONE
  # Delegation is only effective for S/U execution, not M.
  return S if (s.pm == U || (s.pm == S && s.sstatus_sie)) else NONE

function select_interrupt(s):
  slots = [(23,M),(18,UNREACHABLE),(11,M),(3,M),(7,M),(9,M),(1,M),(5,M),(13,M),
           (23,S),(18,UNREACHABLE),(9,S),(1,S),(5,S),(13,S)]
  for c,target in slots:
     if target != UNREACHABLE and request_eligible(c,s) == target: return (c,target)
  return NONE

function trap_target(vec, s):
  c=vec[4:0]
  if vec[5]==0 and c not in {1,2,3,4,5,6,7,8,9,12,13,15}: return M
  if vec[5]==1:
     # RTL mideleg_vld requires the cause's vec_num one-hot inside bits 18:0.
     # Cause 23 has no vec_num row, so even a delegated MCIP request returns to M.
     if c==23 or c not in VEC_NUM_CAUSES: return M
     return S if s.pm in {S,U} and s.mideleg[c] else M
  return S if s.pm in {S,U} and s.medeleg[c] else M

function apply_trap(s, vec, epc, tval):
  t=trap_target(vec,s)
  if t==M: write(mepc=epc&~1, mcause=vec, mtval=tval, MPP=s.pm, MPIE=s.MIE, MIE=0, pm=M)
  else:    write(sepc=epc&~1, scause=vec, stval=tval, SPP=s.pm[0], SPIE=s.SIE, SIE=0, pm=S)

function apply_xret(s, kind):
  if kind==MRET: return {pc:s.mepc>>1, pm:s.MPP, MIE:s.MPIE, MPIE:1, MPP:U}
  if kind==SRET: return {pc:s.sepc>>1, pm:{0,s.SPP}, SIE:s.SPIE, SPIE:1, SPP:0}

function apply_concurrent_pm(s, e):
  # Exact DUT priority, evaluated only when pm_wen is true.
  if e.exit_debug:  return e.dcsr_prv
  if e.enter_debug: return e.dbg_pm
  if e.mret:        return s.MPP
  if e.sret:        return {0,s.SPP}
  return S if e.trap && e.mdeleg_vld else M   # RTU trap target

function apply_status_stack(s, e):
  # Status-stack only: matching trap > matching xRET > status CSR write.
  M = trap_M(e) ? trap_M_values(s,e) : e.mret ? mret_values(s) : csr_M_values(s,e)
  S = trap_S(e) ? trap_S_values(s,e) : e.sret ? sret_values(s) : csr_S_values(s,e)
  return {M,S}

function apply_trap_csrs(s, e):
  # xRET is read-only for xEPC/xCAUSE/xTVAL: trap > matching CSR write.
  M = trap_M(e) ? trap_M_csrs(e) : csr_M_trap_values(s,e)
  S = trap_S(e) ? trap_S_csrs(e) : csr_S_trap_values(s,e)
  return {M,S}

# WFI notification/wake contract: cp0_biu_int_vld = regs_lpmd_int_vld.
# This notification does not update lpmd_b; model BIU policy separately and
# require biu_cp0_int_wakeup to return before CP0 exits interrupt low-power.
# Registered interface rule: request_b(next)=0 iff select_interrupt(current)!=NONE;
# vec(next)=selected cause iff request asserted, otherwise retain vec(current).
```

### 6.2 定向场景（至少一项/行）

|ID|setup|event|期望与观察点|
|---|---|---|---|
|D01|M、MIE=0、MEIP pending+MEIE|运行一拍|无 `int_sel` M request，`cp0_rtu_xx_int_b=1`。|
|D02|M、MIE=1、MEIP+MEIE|运行一拍|下一拍 `int_b=0, vec=11`。|
|D03|S、MIE 任意、MEIP+MEIE|运行一拍|非委托 M target 仍可达，vec=11。|
|D04|S、SIE=0、SEIP+SEIE、mideleg[9]=1|运行一拍|无 S request。|
|D05|S、SIE=1、SEIP+SEIE、mideleg[9]=1|运行一拍|vec=9，S slot 3。|
|D06|U、SSIP+SSIE、mideleg[1]=1|运行一拍|vec=1，S target，不需 SIE。|
|D07|U、STIP+STIE、mideleg[5]=0|运行一拍|vec=5，M target。|
|D08|M、MCIP 和 MEIP 同时有效|运行一拍|vec=23，slot14 胜 slot12。|
|D09|S、SIE=1，`mideleg[23]=1`，MCIP/SEIP/SSIP/STIP/MOIP 同时有效|先观察 request，再由 RTU 回送 interrupt cause 23|下一拍 request `vec=23`、slot5 优先；回送 trap 时因 `vec_num` 无 cause23，`mideleg_vld=0`，写 M trap CSR/status 且 `pm->M`，不得期待 S trap。|
|D10|构造所有 live slot 各一次|扫描|13 个 cause/slot 映射与表一致；bit13/4 永不选中。|
|D11|D02 后不改变 pending，仅拉 `rtu_cp0_int_ack`|ack pulse|request 仍由源/enable 决定；ack 不清源。|
|D12|BIU MEI level 置后回落|源回落|pending/request 在后续采样撤销；vec 可保持。|
|D13|`biu_cp0_ss_int` 置位后回落|CSR 未清|`mvssip` 仍置位；再 CSR clear 才撤销。|
|D14|RTU 非委托**中断** `vec=6'h2b`（`1_01011`，cause 11）、EPC odd、TVAL|trap valid|M CSR: `MCAUSE` 的 interrupt bit=1、cause=11，MEPC bit0=0、MTVAL、MPP/MPIE/MIE 与表一致。|
|D15|RTU 委托 exception cause=2、S/U|trap valid|S CSR: SEPC bit0=0、SCAUSE=2、STVAL、SPP/SPIE/SIE 与表一致。|
|D16|MRET/SRET 各设置不同 xPP/xPIE/xIE/xEPC|合法 xRET|mode/IE 恢复、xPIE=1、xPP 清、`efpc=xepc>>1`。|
|D17|U 发 MRET；S 受 TSR 发 SRET|EX2|IUI local cause=2、opcode MTVAL；不得出现有效 REGS return 更新。|
|D18|WFI + 四 no-op 未齐|SWAIT|三类 request 均拉、仍不进 LPMD。|
|D19|WFI + 四 no-op 齐|ack 后|`lpmd_b=00`, `clk_en=0`；分别测试 BIU-int/event/debug/DTU 四 wake 到 `11`。|
|D20|MIE=0 但 MEIP+MEIE，已处 LPMD|先观察 `regs_lpmd_int_vld=1` 与 `cp0_biu_int_vld=1`；按接口模型令 BIU 回送 `biu_cp0_int_wakeup`|通知本身不改变 `lpmd_b`；仅返回 wake 后 `lpmd_b=11`。同时 D01 仍证明无 trap。|
|D21|ECC select/correctable/fatal 与软件 clear|逐项触发|sticky/clear 及 fatal-to-cause23 受 `ecc_int_vld` 约束。|
|D22|Debug enter/exit 与同拍 M/S trap/xRET|组合刺激|按 `exit > enter > MRET > SRET > trap` 检查 `pm`，并检查 `cp0_dtu_mexpt_vld`。|
|D23|`ADD_AIA` 关闭/开启可用环境|AIA CSR/major src|分别验证 IMSIC bridge 资格、MVIEN/MVIP、MTOPI/STOPI；缺宏则标阻塞，不宣称编译通过。|
|D24|`mtvec/stvec` mode=2/3 和多 cause|CSR write/read + trap entry|同时检查 CSR readback 与 `cp0_ifu_vbr` 都强制 mode[1]=0、保留 mode[0]；下游 offset 未在 CP0 断言，记录集成结果。|
|D25|同拍 `exit_debug/enter_debug/MRET/SRET/trap`；另做 matching trap+xRET+status CSR write 与 matching trap+trap CSR write|在 `regs_flush_clk` 采样|`pm` 按 `exit > enter > MRET > SRET > trap`；M/S status-stack 按 matching trap > matching xRET > status CSR write；MEPC/MCAUSE/MTVAL、SEPC/SCAUSE/STVAL 按 matching trap > trap CSR write，xRET 不参与该竞争。|

### 6.3 断言/性质描述

1. **寄存请求极性/时序**：以 `forever_cpuclk` 为采样时钟，`disable iff (!cpurst_b)`，并用 `$past(cpurst_b)` 屏蔽 reset 释放后的首个采样；之后 `cp0_rtu_xx_int_b == !(|$past(regs_iui_int_sel))`，`cp0_lsu_xx_int_b` 同值。也就是说本拍 `regs_iui_int_sel` 只决定下一拍低有效请求，不能写成同拍组合断言。
2. **寄存向量更新/保持**：使用与性质 1 相同的 reset 和首个 post-reset guard；若 `$past(|regs_iui_int_sel)`，本拍 `cp0_rtu_xx_vec` 等于对 `$past(regs_iui_int_sel)` 首个 live slot 编码的 cause；若 `$past(|regs_iui_int_sel)==0`，则本拍必须满足 `$stable(cp0_rtu_xx_vec)`。reset 期间只检查向量清零，不在首个 post-reset 样本使用无定义的 `$past`。
3. **优先级**：任意两个 live source 同时有效时，较小表行号（slot14→0）胜出。
4. **不可达槽**：`int_sel[13]==0 && int_sel[4]==0`，不得输出 cause 18。
5. **非委托资格**：M 当前模式下 `MIE=0` 阻断每个 nondelegated local-enabled pending。
6. **委托 request 与 trap 分离**：S 当前模式下 `SIE=0` 阻断 delegated request，U 当前模式可达；对 MCIP 还必须断言 `mideleg_value[23]` 可使 request 选择 slot5，但 RTU 回送 interrupt cause23 时 `mideleg_vld==0`、M trap 状态获写。其它可委托 cause 按其 `vec_num` one-hot 检查 S/M trap target。
7. **状态栈 M**：M trap 后 `MPP==$past(pm), MPIE==$past(MIE), MIE==0`。
8. **状态栈 S**：S trap 后 `SPP==$past(pm[0]), SPIE==$past(SIE), SIE==0`。
9. **xRET 恢复**：合法 MRET/SRET 恢复 xIE、置 xPIE、清 xPP，并使 `efpc` 为对应 xEPC 的半字地址。
10. **ack 独立**：在 source/CSR 不变时，仅切换 `rtu_cp0_int_ack` 不改变 pending、选择或撤请求。
11. **source clear**：外部 level 源撤销后相应 pending 随源变化；`mvssip` 只有 CSR path/reset 才能清除（输入回落不清）。
12. **非法系统指令**：无 privilege 的 CSR/xRET/WFI 在 EX2 发 cause2+opcode MTVAL，valid 至 flush/下一 EX2 更新前保持。
13. **WFI wake**：`biu_cp0_int_wakeup`（而非 `regs_lpmd_int_vld/cp0_biu_int_vld` 直接作用）以及 event/debug/DTU 任一 wake 使 `lpmd_b` 回 `11`；四 no-op 不全时不得写 `00`。
14. **dual-valid 一致性**：若集成规定同拍 valid，任何 `rtu_cp0_expt_vld xor rtu_yy_xx_expt_vld` 都应报接口违例（不是 CP0 已修复的设计结论）。
15. **并发优先级**：驱动 D25 的所有互斥/重叠组合；`pm` 必须满足 `exit > enter > MRET > SRET > trap`；matching M/S status-stack 必须满足 trap > xRET > status CSR write；MEPC/MCAUSE/MTVAL 与 SEPC/SCAUSE/STVAL 必须满足 trap > trap CSR write，xRET 不得被建模为该类 CSR 写竞争者。

### 6.4 覆盖与采样/签核

功能覆盖至少包含：`source(8) × pm(M/S/U) × mideleg(0/1) × global-enable(0/1)`（对不适用组合标 ignore）；同时源集合和获胜 slot；`trap_target(M/S) × cause`；MRET/SRET 的 xPP/xPIE 恢复；WFI 的 CP0→BIU notification 与 BIU→CP0 interrupt wake（加 event/debug/DTU 三类）；ECC {none, correctable, fatal, clear}；AIA {ADD_AIA off/on, IMSIC/major/MTOPI/STOPI}；D25 的并发获胜事件。cross 必须保留 slot13/4 的 illegal bin，命中即失败。

scoreboard 在 `forever_cpuclk` 后采 pending/request/vector，在 `regs_flush_clk` 后采 trap CSR/status/pm，在 IUI EX2/EX3 采本地异常与 xRET，在 `lpmd_b` 常开逻辑后采 wake。静态签核门：合同检查器、链接、diff/check 和人工锚点复核通过。动态签核门：有完整 filelist/宏/外部模块、可执行编译和回归、断言零失败及覆盖目标闭合。当前交付只可满足静态门。

## 7. 集成问题（不认定为已确认 bug）

以下为源码观察到的九项**待集成确认**，均应转为接口 review 或动态场景；它们不是本文对 RTL 的修复建议，也不表示已经确认缺陷。

1. `rtu_cp0_int_ack` 当前无消费者：确认 request 撤销是否完全依赖 source/pending 变化。
2. `cp0_mret/cp0_sret` 类型输出未直接带 `iui_privilege`：确认非法 xRET 的 local exception 不会被 return-type 下游副作用覆盖。
3. `cp0_expt_vld` 在 flush 或后续 EX2 更新前保持：确认 IU 消费端的有效/flush 合同。
4. `medeleg` 写掩码可写 bit0、而 cause0 无 one-hot decode：确认 cause0 实际不委托是否为预期。
5. `mtvec/stvec` 内部存两位 mode，但 CSR readback 与 VBR 都仅输出 mode[0]、清 mode[1]：确认非法 vector-mode 的 WARL 可见行为。
6. `rtu_cp0_expt_vld` 与 `rtu_yy_xx_expt_vld` 分别驱动 CSR/status 与 `pm`：确认二者 dual-valid 周期一致性。
7. AIA/major-interrupt 合同：`ADD_AIA` 条件 IMSIC bridge 与仓库外 `WK_MAJOR_*` 宏决定两套配置的 filelist、CSR mask 和功能闭合；同时确认 MCIP request 侧允许 `mideleg_value[23]` 选择 slot5、但 trap 侧因 `vec_num` 无 cause23 而固定分类 M 的行为是否为系统预期，并覆盖 request-target/trap-target 不一致。
8. `cp0_ifu_vbr` 只给 base/mode：确认 IFU/下游的 vector offset 计算、align 和采样时刻。
9. `biu_cp0_ss_int` 置位 `mvssip` 后为 sticky：确认软件清除、重复置位和输入回落的系统协议。

## 8. 源锚点与机械检查

|主题|权威 RTL 锚点|
|---|---|
|topology / 子模块|[`cp0/wk_cp0_top.v:1042`](../cp0/wk_cp0_top.v), [`:1162`](../cp0/wk_cp0_top.v), [`:1475`](../cp0/wk_cp0_top.v)|
|IUI decode/FSM/privilege|[`cp0/wk_cp0_iui.v:928-1027`](../cp0/wk_cp0_iui.v), [`:1406-1505`](../cp0/wk_cp0_iui.v), [`:1680-1805`](../cp0/wk_cp0_iui.v)|
|IUI 本地异常与中断 request|[`cp0/wk_cp0_iui.v:1967-2054`](../cp0/wk_cp0_iui.v)|
|status stack/delegation/enable/pending|[`cp0/wk_cp0_regs.v:2144-2247`](../cp0/wk_cp0_regs.v), [`:2280-2371`](../cp0/wk_cp0_regs.v), [`:2382-2481`](../cp0/wk_cp0_regs.v), [`:2531-2714`](../cp0/wk_cp0_regs.v)|
|S trap state|[`cp0/wk_cp0_regs.v:2731-2792`](../cp0/wk_cp0_regs.v), [`:2846-2944`](../cp0/wk_cp0_regs.v)|
|privilege, return, VBR/efpc|[`cp0/wk_cp0_regs.v:2461-2481`](../cp0/wk_cp0_regs.v), [`:2772-2792`](../cp0/wk_cp0_regs.v), [`:3207-3268`](../cp0/wk_cp0_regs.v), [`:5006-5014`](../cp0/wk_cp0_regs.v), [`:5145-5186`](../cp0/wk_cp0_regs.v), [`:5574-5579`](../cp0/wk_cp0_regs.v)|
|ECC/AIA|[`cp0/wk_cp0_regs.v:3966-4036`](../cp0/wk_cp0_regs.v), [`:5597-6104`](../cp0/wk_cp0_regs.v)|
|WFI|[`cp0/wk_cp0_lpmd.v:161-265`](../cp0/wk_cp0_lpmd.v)|

机械合同检查命令：

```bash
python3 tools/check_interaction_2_3_cp0_contract.py --json
```

成功 JSON 包含四模块、八个 interrupt sources、15 个 priority slots（13 live、2 hardwired-zero）、预期 exception delegation 集合、精确五项 `key_paths`、`ack_consumers: 0`，以及 `mcip_delegation={cause:23, request_selects_supervisor:true, trap_classifies_supervisor:false}`。ACK 计数仅覆盖 `wk_cp0_regs` module body：忽略注释、字符串文本和无初始化声明，但保留 `wire/reg ... = rtu_cp0_int_ack` 初始化右值及独立语句中的语义引用。该 JSON 只证明抽取到的静态合同，不证明 CP0 编译、RTL 仿真、断言、代码覆盖或功能覆盖通过。
