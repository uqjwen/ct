# `ct_lsu_ld_ag.v` 逐行注释

## 文档目的

本文对 `ct_lsu_ld_ag.v` 的 1462 个物理行逐行建立锚点，并给出中文解释。解释严格区分代码事实和接口推断；涉及时序契约的疑点请同时阅读 `ld_ag_spec.docx` 与 `ct_lsu_ld_ag_risk_review.md`。

## 源码基线

- SHA-256：`7c62256e615d66ed54bf96e10373e2636206832cc33d5749e789257f9bb8a010`
- 上游同源文件：<https://github.com/XUANTIE-RV/openc910/blob/main/C910_RTL_FACTORY/gen_rtl/lsu/rtl/ct_lsu_ld_ag.v>
- 覆盖规则：每个物理行（包括空行）在下表中出现一次，行号与源码一一对应。

## 功能总览

`ct_lsu_ld_ag` 是 LSU load 流水线的 AG（address generation）级。它接收 RF pipe3 的基址、offset、大小和指令属性，生成 VA/PA、字节掩码、DCACHE 阵列索引、MMU 请求、异常、stall/restart、load-ahead 以及下游 DC/IDU/LSIQ 伴随信号。

核心流程：`RF 发射 -> AG 寄存 -> VA/边界判断 -> MMU 页翻译 -> PA/阵列索引 -> 异常与 stall 仲裁 -> DC 下传`。

## 分段索引

| 源码范围 | 功能块 |
|---|---|
| L0001-L0015 | 许可证与版权 |
| L0016-L0160 | 模块端口列表 |
| L0161-L0303 | 端口方向与位宽声明 |
| L0304-L0541 | 内部寄存器、连线与参数 |
| L0542-L0569 | RF 映射与门控时钟 |
| L0570-L0778 | AG 流水寄存器与重放数据保持 |
| L0779-L0811 | 虚拟地址生成 |
| L0812-L0835 | 指令类型与预取分类 |
| L0836-L0910 | 访问大小、对齐与 16-byte 边界 |
| L0911-L1030 | 字节有效掩码与旋转 |
| L1031-L1060 | MMU 接口 |
| L1061-L1105 | 物理地址、边界加速与转发 |
| L1106-L1120 | 提交匹配 |
| L1121-L1197 | DCACHE tag/data 阵列请求 |
| L1198-L1242 | 异常生成 |
| L1243-L1337 | stall、restart 与优先级 |
| L1338-L1397 | 下传 DC 与提前唤醒 |
| L1398-L1443 | 本地监控、LSIQ 与 IDU 接口 |
| L1444-L1462 | 性能计数与模块结束 |

## 许可证与版权

| 行号 | 原始代码 | 中文注释 |
|---:|---|---|
| <!-- SRC-LINE:0001 -->L0001 | <code>/*Copyright 2019-2021 T-Head Semiconductor Co., Ltd.</code> | Apache-2.0 版权/许可证块开始。 |
| <!-- SRC-LINE:0002 -->L0002 | &nbsp; | 空行，用于分隔“许可证与版权”中的逻辑块，提高源码可读性。 |
| <!-- SRC-LINE:0003 -->L0003 | <code>Licensed under the Apache License, Version 2.0 (the &quot;License&quot;);</code> | Apache-2.0 许可证原文，规定本 RTL 的使用、分发和免责声明。 |
| <!-- SRC-LINE:0004 -->L0004 | <code>you may not use this file except in compliance with the License.</code> | Apache-2.0 许可证原文，规定本 RTL 的使用、分发和免责声明。 |
| <!-- SRC-LINE:0005 -->L0005 | <code>You may obtain a copy of the License at</code> | Apache-2.0 许可证原文，规定本 RTL 的使用、分发和免责声明。 |
| <!-- SRC-LINE:0006 -->L0006 | &nbsp; | 空行，用于分隔“许可证与版权”中的逻辑块，提高源码可读性。 |
| <!-- SRC-LINE:0007 -->L0007 | <code>    http://www.apache.org/licenses/LICENSE-2.0</code> | Apache-2.0 许可证原文，规定本 RTL 的使用、分发和免责声明。 |
| <!-- SRC-LINE:0008 -->L0008 | &nbsp; | 空行，用于分隔“许可证与版权”中的逻辑块，提高源码可读性。 |
| <!-- SRC-LINE:0009 -->L0009 | <code>Unless required by applicable law or agreed to in writing, software</code> | Apache-2.0 许可证原文，规定本 RTL 的使用、分发和免责声明。 |
| <!-- SRC-LINE:0010 -->L0010 | <code>distributed under the License is distributed on an &quot;AS IS&quot; BASIS,</code> | Apache-2.0 许可证原文，规定本 RTL 的使用、分发和免责声明。 |
| <!-- SRC-LINE:0011 -->L0011 | <code>WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.</code> | Apache-2.0 许可证原文，规定本 RTL 的使用、分发和免责声明。 |
| <!-- SRC-LINE:0012 -->L0012 | <code>See the License for the specific language governing permissions and</code> | Apache-2.0 许可证原文，规定本 RTL 的使用、分发和免责声明。 |
| <!-- SRC-LINE:0013 -->L0013 | <code>limitations under the License.</code> | Apache-2.0 许可证原文，规定本 RTL 的使用、分发和免责声明。 |
| <!-- SRC-LINE:0014 -->L0014 | <code>*/</code> | 版权/许可证块结束。 |
| <!-- SRC-LINE:0015 -->L0015 | &nbsp; | 空行，用于分隔“许可证与版权”中的逻辑块，提高源码可读性。 |

## 模块端口列表

| 行号 | 原始代码 | 中文注释 |
|---:|---|---|
| <!-- SRC-LINE:0016 -->L0016 | <code>// &amp;ModuleBeg; @28</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:0017 -->L0017 | <code>module ct_lsu_ld_ag(</code> | 声明顶层模块 ct_lsu_ld_ag，并开始列举外部端口。 |
| <!-- SRC-LINE:0018 -->L0018 | <code>  ag_dcache_arb_ld_data_gateclk_en,</code> | 将 `ag_dcache_arb_ld_data_gateclk_en` 列入模块端口列表。发往 DCACHE arbiter 的阵列请求、索引或门控。 |
| <!-- SRC-LINE:0019 -->L0019 | <code>  ag_dcache_arb_ld_data_high_idx,</code> | 将 `ag_dcache_arb_ld_data_high_idx` 列入模块端口列表。发往 DCACHE arbiter 的阵列请求、索引或门控。 |
| <!-- SRC-LINE:0020 -->L0020 | <code>  ag_dcache_arb_ld_data_low_idx,</code> | 将 `ag_dcache_arb_ld_data_low_idx` 列入模块端口列表。发往 DCACHE arbiter 的阵列请求、索引或门控。 |
| <!-- SRC-LINE:0021 -->L0021 | <code>  ag_dcache_arb_ld_data_req,</code> | 将 `ag_dcache_arb_ld_data_req` 列入模块端口列表。发往 DCACHE arbiter 的阵列请求、索引或门控。 |
| <!-- SRC-LINE:0022 -->L0022 | <code>  ag_dcache_arb_ld_tag_gateclk_en,</code> | 将 `ag_dcache_arb_ld_tag_gateclk_en` 列入模块端口列表。发往 DCACHE arbiter 的阵列请求、索引或门控。 |
| <!-- SRC-LINE:0023 -->L0023 | <code>  ag_dcache_arb_ld_tag_idx,</code> | 将 `ag_dcache_arb_ld_tag_idx` 列入模块端口列表。发往 DCACHE arbiter 的阵列请求、索引或门控。 |
| <!-- SRC-LINE:0024 -->L0024 | <code>  ag_dcache_arb_ld_tag_req,</code> | 将 `ag_dcache_arb_ld_tag_req` 列入模块端口列表。发往 DCACHE arbiter 的阵列请求、索引或门控。 |
| <!-- SRC-LINE:0025 -->L0025 | <code>  cp0_lsu_cb_aclr_dis,</code> | 将 `cp0_lsu_cb_aclr_dis` 列入模块端口列表。禁止跨 16-byte 边界的 cache-buffer acceleration。 |
| <!-- SRC-LINE:0026 -->L0026 | <code>  cp0_lsu_da_fwd_dis,</code> | 将 `cp0_lsu_da_fwd_dis` 列入模块端口列表。禁止 load ahead/DA forwarding 相关有效信号。 |
| <!-- SRC-LINE:0027 -->L0027 | <code>  cp0_lsu_dcache_en,</code> | 将 `cp0_lsu_dcache_en` 列入模块端口列表。数据缓存使能；门控 tag/data array 请求。 |
| <!-- SRC-LINE:0028 -->L0028 | <code>  cp0_lsu_icg_en,</code> | 将 `cp0_lsu_icg_en` 列入模块端口列表。LSU 模块时钟门控使能。 |
| <!-- SRC-LINE:0029 -->L0029 | <code>  cp0_lsu_mm,</code> | 将 `cp0_lsu_mm` 列入模块端口列表。misaligned load 处理模式配置；为 0 时普通 load 不对齐在 AG 报错。 |
| <!-- SRC-LINE:0030 -->L0030 | <code>  cp0_yy_clk_en,</code> | 将 `cp0_yy_clk_en` 列入模块端口列表。全局时钟使能。 |
| <!-- SRC-LINE:0031 -->L0031 | <code>  cpurst_b,</code> | 将 `cpurst_b` 列入模块端口列表。低有效异步复位。 |
| <!-- SRC-LINE:0032 -->L0032 | <code>  ctrl_ld_clk,</code> | 将 `ctrl_ld_clk` 列入模块端口列表。load 控制时钟，用于更新 AG valid。 |
| <!-- SRC-LINE:0033 -->L0033 | <code>  dcache_arb_ag_ld_sel,</code> | 将 `dcache_arb_ag_ld_sel` 列入模块端口列表。DCACHE arbiter 已选择 load AG 请求；取反形成 cache stall。 |
| <!-- SRC-LINE:0034 -->L0034 | <code>  dcache_arb_ld_ag_addr,</code> | 将 `dcache_arb_ld_ag_addr` 列入模块端口列表。DCACHE arbiter 借用的地址。 |
| <!-- SRC-LINE:0035 -->L0035 | <code>  dcache_arb_ld_ag_borrow_addr_vld,</code> | 将 `dcache_arb_ld_ag_borrow_addr_vld` 列入模块端口列表。DCACHE arbiter 借用地址有效，覆盖下传 DC 地址。 |
| <!-- SRC-LINE:0036 -->L0036 | <code>  forever_cpuclk,</code> | 将 `forever_cpuclk` 列入模块端口列表。未门控的 CPU 基准时钟，作为 AG ICG 输入。 |
| <!-- SRC-LINE:0037 -->L0037 | <code>  idu_lsu_rf_pipe3_already_da,</code> | 将 `idu_lsu_rf_pipe3_already_da` 列入模块端口列表。来自 IDU/RF pipe3 的指令属性或操作数。 |
| <!-- SRC-LINE:0038 -->L0038 | <code>  idu_lsu_rf_pipe3_atomic,</code> | 将 `idu_lsu_rf_pipe3_atomic` 列入模块端口列表。原子类指令标志。 |
| <!-- SRC-LINE:0039 -->L0039 | <code>  idu_lsu_rf_pipe3_bkpta_data,</code> | 将 `idu_lsu_rf_pipe3_bkpta_data` 列入模块端口列表。来自 IDU/RF pipe3 的指令属性或操作数。 |
| <!-- SRC-LINE:0040 -->L0040 | <code>  idu_lsu_rf_pipe3_bkptb_data,</code> | 将 `idu_lsu_rf_pipe3_bkptb_data` 列入模块端口列表。来自 IDU/RF pipe3 的指令属性或操作数。 |
| <!-- SRC-LINE:0041 -->L0041 | <code>  idu_lsu_rf_pipe3_gateclk_sel,</code> | 将 `idu_lsu_rf_pipe3_gateclk_sel` 列入模块端口列表。RF pipe3 门控时钟选择；本模块同时把它视为 RF 数据有效。 |
| <!-- SRC-LINE:0042 -->L0042 | <code>  idu_lsu_rf_pipe3_iid,</code> | 将 `idu_lsu_rf_pipe3_iid` 列入模块端口列表。指令 ID，用于提交和新旧比较。 |
| <!-- SRC-LINE:0043 -->L0043 | <code>  idu_lsu_rf_pipe3_inst_fls,</code> | 将 `idu_lsu_rf_pipe3_inst_fls` 列入模块端口列表。来自 IDU/RF pipe3 的指令属性或操作数。 |
| <!-- SRC-LINE:0044 -->L0044 | <code>  idu_lsu_rf_pipe3_inst_ldr,</code> | 将 `idu_lsu_rf_pipe3_inst_ldr` 列入模块端口列表。寄存器 offset 的 LDR 类地址生成标志。 |
| <!-- SRC-LINE:0045 -->L0045 | <code>  idu_lsu_rf_pipe3_inst_size,</code> | 将 `idu_lsu_rf_pipe3_inst_size` 列入模块端口列表。访问大小编码：BYTE/HALF/WORD/DWORD。 |
| <!-- SRC-LINE:0046 -->L0046 | <code>  idu_lsu_rf_pipe3_inst_type,</code> | 将 `idu_lsu_rf_pipe3_inst_type` 列入模块端口列表。load/atomic 子类型编码。 |
| <!-- SRC-LINE:0047 -->L0047 | <code>  idu_lsu_rf_pipe3_lch_entry,</code> | 将 `idu_lsu_rf_pipe3_lch_entry` 列入模块端口列表。对应 LSIQ entry 的 12-bit one-hot/bitmap。 |
| <!-- SRC-LINE:0048 -->L0048 | <code>  idu_lsu_rf_pipe3_lsfifo,</code> | 将 `idu_lsu_rf_pipe3_lsfifo` 列入模块端口列表。来自 IDU/RF pipe3 的指令属性或操作数。 |
| <!-- SRC-LINE:0049 -->L0049 | <code>  idu_lsu_rf_pipe3_no_spec,</code> | 将 `idu_lsu_rf_pipe3_no_spec` 列入模块端口列表。来自 IDU/RF pipe3 的指令属性或操作数。 |
| <!-- SRC-LINE:0050 -->L0050 | <code>  idu_lsu_rf_pipe3_no_spec_exist,</code> | 将 `idu_lsu_rf_pipe3_no_spec_exist` 列入模块端口列表。来自 IDU/RF pipe3 的指令属性或操作数。 |
| <!-- SRC-LINE:0051 -->L0051 | <code>  idu_lsu_rf_pipe3_off_0_extend,</code> | 将 `idu_lsu_rf_pipe3_off_0_extend` 列入模块端口列表。来自 IDU/RF pipe3 的指令属性或操作数。 |
| <!-- SRC-LINE:0052 -->L0052 | <code>  idu_lsu_rf_pipe3_offset,</code> | 将 `idu_lsu_rf_pipe3_offset` 列入模块端口列表。普通 load 的 12-bit 立即数 offset。 |
| <!-- SRC-LINE:0053 -->L0053 | <code>  idu_lsu_rf_pipe3_offset_plus,</code> | 将 `idu_lsu_rf_pipe3_offset_plus` 列入模块端口列表。split 首拍使用的 13-bit 备选 offset。 |
| <!-- SRC-LINE:0054 -->L0054 | <code>  idu_lsu_rf_pipe3_oldest,</code> | 将 `idu_lsu_rf_pipe3_oldest` 列入模块端口列表。来自 IDU/RF pipe3 的指令属性或操作数。 |
| <!-- SRC-LINE:0055 -->L0055 | <code>  idu_lsu_rf_pipe3_pc,</code> | 将 `idu_lsu_rf_pipe3_pc` 列入模块端口列表。来自 IDU/RF pipe3 的指令属性或操作数。 |
| <!-- SRC-LINE:0056 -->L0056 | <code>  idu_lsu_rf_pipe3_preg,</code> | 将 `idu_lsu_rf_pipe3_preg` 列入模块端口列表。来自 IDU/RF pipe3 的指令属性或操作数。 |
| <!-- SRC-LINE:0057 -->L0057 | <code>  idu_lsu_rf_pipe3_sel,</code> | 将 `idu_lsu_rf_pipe3_sel` 列入模块端口列表。RF pipe3 向 AG 发射/选择有效指示。 |
| <!-- SRC-LINE:0058 -->L0058 | <code>  idu_lsu_rf_pipe3_shift,</code> | 将 `idu_lsu_rf_pipe3_shift` 列入模块端口列表。offset 移位选择，RTL 按 one-hot 编码使用。 |
| <!-- SRC-LINE:0059 -->L0059 | <code>  idu_lsu_rf_pipe3_sign_extend,</code> | 将 `idu_lsu_rf_pipe3_sign_extend` 列入模块端口列表。来自 IDU/RF pipe3 的指令属性或操作数。 |
| <!-- SRC-LINE:0060 -->L0060 | <code>  idu_lsu_rf_pipe3_spec_fail,</code> | 将 `idu_lsu_rf_pipe3_spec_fail` 列入模块端口列表。来自 IDU/RF pipe3 的指令属性或操作数。 |
| <!-- SRC-LINE:0061 -->L0061 | <code>  idu_lsu_rf_pipe3_split,</code> | 将 `idu_lsu_rf_pipe3_split` 列入模块端口列表。来自 IDU/RF pipe3 的指令属性或操作数。 |
| <!-- SRC-LINE:0062 -->L0062 | <code>  idu_lsu_rf_pipe3_src0,</code> | 将 `idu_lsu_rf_pipe3_src0` 列入模块端口列表。地址基址源操作数。 |
| <!-- SRC-LINE:0063 -->L0063 | <code>  idu_lsu_rf_pipe3_src1,</code> | 将 `idu_lsu_rf_pipe3_src1` 列入模块端口列表。LDR 类指令的 offset 源操作数。 |
| <!-- SRC-LINE:0064 -->L0064 | <code>  idu_lsu_rf_pipe3_unalign_2nd,</code> | 将 `idu_lsu_rf_pipe3_unalign_2nd` 列入模块端口列表。split/边界访问第二拍标志，锁存为 ld_ag_secd。 |
| <!-- SRC-LINE:0065 -->L0065 | <code>  idu_lsu_rf_pipe3_vreg,</code> | 将 `idu_lsu_rf_pipe3_vreg` 列入模块端口列表。来自 IDU/RF pipe3 的指令属性或操作数。 |
| <!-- SRC-LINE:0066 -->L0066 | <code>  ld_ag_addr1_to4,</code> | 将 `ld_ag_addr1_to4` 列入模块端口列表。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0067 -->L0067 | <code>  ld_ag_ahead_predict,</code> | 将 `ld_ag_ahead_predict` 列入模块端口列表。load ahead 预测，本版本恒为 1。 |
| <!-- SRC-LINE:0068 -->L0068 | <code>  ld_ag_already_da,</code> | 将 `ld_ag_already_da` 列入模块端口列表。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0069 -->L0069 | <code>  ld_ag_atomic,</code> | 将 `ld_ag_atomic` 列入模块端口列表。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0070 -->L0070 | <code>  ld_ag_boundary,</code> | 将 `ld_ag_boundary` 列入模块端口列表。普通 load 跨 16-byte 边界或处于第二拍。 |
| <!-- SRC-LINE:0071 -->L0071 | <code>  ld_ag_dc_access_size,</code> | 将 `ld_ag_dc_access_size` 列入模块端口列表。从 AG 下传到 load DC stage 的数据或控制。 |
| <!-- SRC-LINE:0072 -->L0072 | <code>  ld_ag_dc_acclr_en,</code> | 将 `ld_ag_dc_acclr_en` 列入模块端口列表。满足 PA valid、cacheable 等条件的边界加速使能。 |
| <!-- SRC-LINE:0073 -->L0073 | <code>  ld_ag_dc_addr0,</code> | 将 `ld_ag_dc_addr0` 列入模块端口列表。从 AG 下传到 load DC stage 的数据或控制。 |
| <!-- SRC-LINE:0074 -->L0074 | <code>  ld_ag_dc_bytes_vld,</code> | 将 `ld_ag_dc_bytes_vld` 列入模块端口列表。当前 16-byte 数据窗口的字节有效掩码。 |
| <!-- SRC-LINE:0075 -->L0075 | <code>  ld_ag_dc_bytes_vld1,</code> | 将 `ld_ag_dc_bytes_vld1` 列入模块端口列表。边界访问低地址侧/合并用途的辅助掩码。 |
| <!-- SRC-LINE:0076 -->L0076 | <code>  ld_ag_dc_fwd_bypass_en,</code> | 将 `ld_ag_dc_fwd_bypass_en` 列入模块端口列表。从 AG 下传到 load DC stage 的数据或控制。 |
| <!-- SRC-LINE:0077 -->L0077 | <code>  ld_ag_dc_inst_vld,</code> | 将 `ld_ag_dc_inst_vld` 列入模块端口列表。发往 DC 的有效，排除所有 stall/restart。 |
| <!-- SRC-LINE:0078 -->L0078 | <code>  ld_ag_dc_load_ahead_inst_vld,</code> | 将 `ld_ag_dc_load_ahead_inst_vld` 列入模块端口列表。从 AG 下传到 load DC stage 的数据或控制。 |
| <!-- SRC-LINE:0079 -->L0079 | <code>  ld_ag_dc_load_inst_vld,</code> | 将 `ld_ag_dc_load_inst_vld` 列入模块端口列表。从 AG 下传到 load DC stage 的数据或控制。 |
| <!-- SRC-LINE:0080 -->L0080 | <code>  ld_ag_dc_mmu_req,</code> | 将 `ld_ag_dc_mmu_req` 列入模块端口列表。从 AG 下传到 load DC stage 的数据或控制。 |
| <!-- SRC-LINE:0081 -->L0081 | <code>  ld_ag_dc_rot_sel,</code> | 将 `ld_ag_dc_rot_sel` 列入模块端口列表。基于 VA 低 4 位的数据旋转选择。 |
| <!-- SRC-LINE:0082 -->L0082 | <code>  ld_ag_dc_vload_ahead_inst_vld,</code> | 将 `ld_ag_dc_vload_ahead_inst_vld` 列入模块端口列表。从 AG 下传到 load DC stage 的数据或控制。 |
| <!-- SRC-LINE:0083 -->L0083 | <code>  ld_ag_dc_vload_inst_vld,</code> | 将 `ld_ag_dc_vload_inst_vld` 列入模块端口列表。从 AG 下传到 load DC stage 的数据或控制。 |
| <!-- SRC-LINE:0084 -->L0084 | <code>  ld_ag_expt_access_fault_with_page,</code> | 将 `ld_ag_expt_access_fault_with_page` 列入模块端口列表。AG 生成的异常条件。 |
| <!-- SRC-LINE:0085 -->L0085 | <code>  ld_ag_expt_ldamo_not_ca,</code> | 将 `ld_ag_expt_ldamo_not_ca` 列入模块端口列表。原子 load/AMO 访问 non-cacheable 页的专用异常。 |
| <!-- SRC-LINE:0086 -->L0086 | <code>  ld_ag_expt_misalign_no_page,</code> | 将 `ld_ag_expt_misalign_no_page` 列入模块端口列表。AG 生成的异常条件。 |
| <!-- SRC-LINE:0087 -->L0087 | <code>  ld_ag_expt_misalign_with_page,</code> | 将 `ld_ag_expt_misalign_with_page` 列入模块端口列表。AG 生成的异常条件。 |
| <!-- SRC-LINE:0088 -->L0088 | <code>  ld_ag_expt_page_fault,</code> | 将 `ld_ag_expt_page_fault` 列入模块端口列表。AG 生成的异常条件。 |
| <!-- SRC-LINE:0089 -->L0089 | <code>  ld_ag_expt_vld,</code> | 将 `ld_ag_expt_vld` 列入模块端口列表。聚合异常：misalign、SO misalign、带页属性 access fault、page fault。 |
| <!-- SRC-LINE:0090 -->L0090 | <code>  ld_ag_iid,</code> | 将 `ld_ag_iid` 列入模块端口列表。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0091 -->L0091 | <code>  ld_ag_inst_type,</code> | 将 `ld_ag_inst_type` 列入模块端口列表。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0092 -->L0092 | <code>  ld_ag_inst_vfls,</code> | 将 `ld_ag_inst_vfls` 列入模块端口列表。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0093 -->L0093 | <code>  ld_ag_inst_vld,</code> | 将 `ld_ag_inst_vld` 列入模块端口列表。AG 当前指令有效；stall 时保持，flush/reset 时清零。 |
| <!-- SRC-LINE:0094 -->L0094 | <code>  ld_ag_ldfifo_pc,</code> | 将 `ld_ag_ldfifo_pc` 列入模块端口列表。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0095 -->L0095 | <code>  ld_ag_lm_init_vld,</code> | 将 `ld_ag_lm_init_vld` 列入模块端口列表。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0096 -->L0096 | <code>  ld_ag_lr_inst,</code> | 将 `ld_ag_lr_inst` 列入模块端口列表。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0097 -->L0097 | <code>  ld_ag_lsid,</code> | 将 `ld_ag_lsid` 列入模块端口列表。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0098 -->L0098 | <code>  ld_ag_lsiq_bkpta_data,</code> | 将 `ld_ag_lsiq_bkpta_data` 列入模块端口列表。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0099 -->L0099 | <code>  ld_ag_lsiq_bkptb_data,</code> | 将 `ld_ag_lsiq_bkptb_data` 列入模块端口列表。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0100 -->L0100 | <code>  ld_ag_lsiq_spec_fail,</code> | 将 `ld_ag_lsiq_spec_fail` 列入模块端口列表。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0101 -->L0101 | <code>  ld_ag_no_spec,</code> | 将 `ld_ag_no_spec` 列入模块端口列表。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0102 -->L0102 | <code>  ld_ag_no_spec_exist,</code> | 将 `ld_ag_no_spec_exist` 列入模块端口列表。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0103 -->L0103 | <code>  ld_ag_old,</code> | 将 `ld_ag_old` 列入模块端口列表。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0104 -->L0104 | <code>  ld_ag_pa,</code> | 将 `ld_ag_pa` 列入模块端口列表。MMU PPN 与最终 VA 低 12 位拼接的物理地址。 |
| <!-- SRC-LINE:0105 -->L0105 | <code>  ld_ag_page_buf,</code> | 将 `ld_ag_page_buf` 列入模块端口列表。MMU 页面属性的 AG 侧输出。 |
| <!-- SRC-LINE:0106 -->L0106 | <code>  ld_ag_page_ca,</code> | 将 `ld_ag_page_ca` 列入模块端口列表。MMU 页面属性的 AG 侧输出。 |
| <!-- SRC-LINE:0107 -->L0107 | <code>  ld_ag_page_sec,</code> | 将 `ld_ag_page_sec` 列入模块端口列表。MMU 页面属性的 AG 侧输出。 |
| <!-- SRC-LINE:0108 -->L0108 | <code>  ld_ag_page_share,</code> | 将 `ld_ag_page_share` 列入模块端口列表。MMU 页面属性的 AG 侧输出。 |
| <!-- SRC-LINE:0109 -->L0109 | <code>  ld_ag_page_so,</code> | 将 `ld_ag_page_so` 列入模块端口列表。MMU 页面属性的 AG 侧输出。 |
| <!-- SRC-LINE:0110 -->L0110 | <code>  ld_ag_pf_inst,</code> | 将 `ld_ag_pf_inst` 列入模块端口列表。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0111 -->L0111 | <code>  ld_ag_preg,</code> | 将 `ld_ag_preg` 列入模块端口列表。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0112 -->L0112 | <code>  ld_ag_raw_new,</code> | 将 `ld_ag_raw_new` 列入模块端口列表。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0113 -->L0113 | <code>  ld_ag_secd,</code> | 将 `ld_ag_secd` 列入模块端口列表。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0114 -->L0114 | <code>  ld_ag_sign_extend,</code> | 将 `ld_ag_sign_extend` 列入模块端口列表。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0115 -->L0115 | <code>  ld_ag_split,</code> | 将 `ld_ag_split` 列入模块端口列表。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0116 -->L0116 | <code>  ld_ag_stall_ori,</code> | 将 `ld_ag_stall_ori` 列入模块端口列表。不含 atomic-no-commit restart 的原始 stall 指示。 |
| <!-- SRC-LINE:0117 -->L0117 | <code>  ld_ag_stall_restart_entry,</code> | 将 `ld_ag_stall_restart_entry` 列入模块端口列表。stall/restart 时选中的 LSIQ entry bitmap。 |
| <!-- SRC-LINE:0118 -->L0118 | <code>  ld_ag_utlb_miss,</code> | 将 `ld_ag_utlb_miss` 列入模块端口列表。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0119 -->L0119 | <code>  ld_ag_vpn,</code> | 将 `ld_ag_vpn` 列入模块端口列表。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0120 -->L0120 | <code>  ld_ag_vreg,</code> | 将 `ld_ag_vreg` 列入模块端口列表。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0121 -->L0121 | <code>  lsu_hpcp_ld_cross_4k_stall,</code> | 将 `lsu_hpcp_ld_cross_4k_stall` 列入模块端口列表。模块接口信号；具体有效条件由相邻控制信号和功能规则限定。 |
| <!-- SRC-LINE:0122 -->L0122 | <code>  lsu_hpcp_ld_other_stall,</code> | 将 `lsu_hpcp_ld_other_stall` 列入模块端口列表。模块接口信号；具体有效条件由相邻控制信号和功能规则限定。 |
| <!-- SRC-LINE:0123 -->L0123 | <code>  lsu_idu_ag_pipe3_load_inst_vld,</code> | 将 `lsu_idu_ag_pipe3_load_inst_vld` 列入模块端口列表。从 LSU/AG 返回 IDU 的调度或目的寄存器信息。 |
| <!-- SRC-LINE:0124 -->L0124 | <code>  lsu_idu_ag_pipe3_preg_dup0,</code> | 将 `lsu_idu_ag_pipe3_preg_dup0` 列入模块端口列表。从 LSU/AG 返回 IDU 的调度或目的寄存器信息。 |
| <!-- SRC-LINE:0125 -->L0125 | <code>  lsu_idu_ag_pipe3_preg_dup1,</code> | 将 `lsu_idu_ag_pipe3_preg_dup1` 列入模块端口列表。从 LSU/AG 返回 IDU 的调度或目的寄存器信息。 |
| <!-- SRC-LINE:0126 -->L0126 | <code>  lsu_idu_ag_pipe3_preg_dup2,</code> | 将 `lsu_idu_ag_pipe3_preg_dup2` 列入模块端口列表。从 LSU/AG 返回 IDU 的调度或目的寄存器信息。 |
| <!-- SRC-LINE:0127 -->L0127 | <code>  lsu_idu_ag_pipe3_preg_dup3,</code> | 将 `lsu_idu_ag_pipe3_preg_dup3` 列入模块端口列表。从 LSU/AG 返回 IDU 的调度或目的寄存器信息。 |
| <!-- SRC-LINE:0128 -->L0128 | <code>  lsu_idu_ag_pipe3_preg_dup4,</code> | 将 `lsu_idu_ag_pipe3_preg_dup4` 列入模块端口列表。从 LSU/AG 返回 IDU 的调度或目的寄存器信息。 |
| <!-- SRC-LINE:0129 -->L0129 | <code>  lsu_idu_ag_pipe3_vload_inst_vld,</code> | 将 `lsu_idu_ag_pipe3_vload_inst_vld` 列入模块端口列表。从 LSU/AG 返回 IDU 的调度或目的寄存器信息。 |
| <!-- SRC-LINE:0130 -->L0130 | <code>  lsu_idu_ag_pipe3_vreg_dup0,</code> | 将 `lsu_idu_ag_pipe3_vreg_dup0` 列入模块端口列表。从 LSU/AG 返回 IDU 的调度或目的寄存器信息。 |
| <!-- SRC-LINE:0131 -->L0131 | <code>  lsu_idu_ag_pipe3_vreg_dup1,</code> | 将 `lsu_idu_ag_pipe3_vreg_dup1` 列入模块端口列表。从 LSU/AG 返回 IDU 的调度或目的寄存器信息。 |
| <!-- SRC-LINE:0132 -->L0132 | <code>  lsu_idu_ag_pipe3_vreg_dup2,</code> | 将 `lsu_idu_ag_pipe3_vreg_dup2` 列入模块端口列表。从 LSU/AG 返回 IDU 的调度或目的寄存器信息。 |
| <!-- SRC-LINE:0133 -->L0133 | <code>  lsu_idu_ag_pipe3_vreg_dup3,</code> | 将 `lsu_idu_ag_pipe3_vreg_dup3` 列入模块端口列表。从 LSU/AG 返回 IDU 的调度或目的寄存器信息。 |
| <!-- SRC-LINE:0134 -->L0134 | <code>  lsu_idu_ld_ag_wait_old,</code> | 将 `lsu_idu_ld_ag_wait_old` 列入模块端口列表。从 LSU/AG 返回 IDU 的调度或目的寄存器信息。 |
| <!-- SRC-LINE:0135 -->L0135 | <code>  lsu_idu_ld_ag_wait_old_gateclk_en,</code> | 将 `lsu_idu_ld_ag_wait_old_gateclk_en` 列入模块端口列表。从 LSU/AG 返回 IDU 的调度或目的寄存器信息。 |
| <!-- SRC-LINE:0136 -->L0136 | <code>  lsu_mmu_abort0,</code> | 将 `lsu_mmu_abort0` 列入模块端口列表。中止当前 MMU port0 请求的组合条件。 |
| <!-- SRC-LINE:0137 -->L0137 | <code>  lsu_mmu_id0,</code> | 将 `lsu_mmu_id0` 列入模块端口列表。发往 MMU port0 的请求、标识或中止信息。 |
| <!-- SRC-LINE:0138 -->L0138 | <code>  lsu_mmu_st_inst0,</code> | 将 `lsu_mmu_st_inst0` 列入模块端口列表。发往 MMU port0 的请求、标识或中止信息。 |
| <!-- SRC-LINE:0139 -->L0139 | <code>  lsu_mmu_va0,</code> | 将 `lsu_mmu_va0` 列入模块端口列表。发往 MMU 的 base VA；页内 offset 在 AG 本地加入。 |
| <!-- SRC-LINE:0140 -->L0140 | <code>  lsu_mmu_va0_vld,</code> | 将 `lsu_mmu_va0_vld` 列入模块端口列表。发往 MMU port0 的请求有效，等于 AG valid。 |
| <!-- SRC-LINE:0141 -->L0141 | <code>  mmu_lsu_buf0,</code> | 将 `mmu_lsu_buf0` 列入模块端口列表。来自 MMU port0 的翻译结果、属性或流控。 |
| <!-- SRC-LINE:0142 -->L0142 | <code>  mmu_lsu_ca0,</code> | 将 `mmu_lsu_ca0` 列入模块端口列表。页属性：cacheable。 |
| <!-- SRC-LINE:0143 -->L0143 | <code>  mmu_lsu_pa0,</code> | 将 `mmu_lsu_pa0` 列入模块端口列表。MMU 返回的物理页号。 |
| <!-- SRC-LINE:0144 -->L0144 | <code>  mmu_lsu_pa0_vld,</code> | 将 `mmu_lsu_pa0_vld` 列入模块端口列表。MMU port0 返回有效；同时限定 CA/SO 和多种异常。 |
| <!-- SRC-LINE:0145 -->L0145 | <code>  mmu_lsu_page_fault0,</code> | 将 `mmu_lsu_page_fault0` 列入模块端口列表。MMU port0 页故障。 |
| <!-- SRC-LINE:0146 -->L0146 | <code>  mmu_lsu_sec0,</code> | 将 `mmu_lsu_sec0` 列入模块端口列表。来自 MMU port0 的翻译结果、属性或流控。 |
| <!-- SRC-LINE:0147 -->L0147 | <code>  mmu_lsu_sh0,</code> | 将 `mmu_lsu_sh0` 列入模块端口列表。来自 MMU port0 的翻译结果、属性或流控。 |
| <!-- SRC-LINE:0148 -->L0148 | <code>  mmu_lsu_so0,</code> | 将 `mmu_lsu_so0` 列入模块端口列表。页属性：strong order。 |
| <!-- SRC-LINE:0149 -->L0149 | <code>  mmu_lsu_stall0,</code> | 将 `mmu_lsu_stall0` 列入模块端口列表。MMU stall；上游当前 DUTLB 实现中常为 0，但本模块未按 valid 门控。 |
| <!-- SRC-LINE:0150 -->L0150 | <code>  pad_yy_icg_scan_en,</code> | 将 `pad_yy_icg_scan_en` 列入模块端口列表。扫描模式下的 ICG 覆盖使能。 |
| <!-- SRC-LINE:0151 -->L0151 | <code>  rtu_yy_xx_commit0,</code> | 将 `rtu_yy_xx_commit0` 列入模块端口列表。来自 RTU 的提交端口信息。 |
| <!-- SRC-LINE:0152 -->L0152 | <code>  rtu_yy_xx_commit0_iid,</code> | 将 `rtu_yy_xx_commit0_iid` 列入模块端口列表。来自 RTU 的提交端口信息。 |
| <!-- SRC-LINE:0153 -->L0153 | <code>  rtu_yy_xx_commit1,</code> | 将 `rtu_yy_xx_commit1` 列入模块端口列表。来自 RTU 的提交端口信息。 |
| <!-- SRC-LINE:0154 -->L0154 | <code>  rtu_yy_xx_commit1_iid,</code> | 将 `rtu_yy_xx_commit1_iid` 列入模块端口列表。来自 RTU 的提交端口信息。 |
| <!-- SRC-LINE:0155 -->L0155 | <code>  rtu_yy_xx_commit2,</code> | 将 `rtu_yy_xx_commit2` 列入模块端口列表。来自 RTU 的提交端口信息。 |
| <!-- SRC-LINE:0156 -->L0156 | <code>  rtu_yy_xx_commit2_iid,</code> | 将 `rtu_yy_xx_commit2_iid` 列入模块端口列表。来自 RTU 的提交端口信息。 |
| <!-- SRC-LINE:0157 -->L0157 | <code>  rtu_yy_xx_flush,</code> | 将 `rtu_yy_xx_flush` 列入模块端口列表。全局 flush，清除 AG valid 并中止 MMU。 |
| <!-- SRC-LINE:0158 -->L0158 | <code>  st_ag_iid</code> | 将 `st_ag_iid` 列入模块端口列表。模块接口信号；具体有效条件由相邻控制信号和功能规则限定。 |
| <!-- SRC-LINE:0159 -->L0159 | <code>);</code> | 结束模块端口列表。 |
| <!-- SRC-LINE:0160 -->L0160 | &nbsp; | 空行，用于分隔“模块端口列表”中的逻辑块，提高源码可读性。 |

## 端口方向与位宽声明

| 行号 | 原始代码 | 中文注释 |
|---:|---|---|
| <!-- SRC-LINE:0161 -->L0161 | <code>// &amp;Ports; @29</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:0162 -->L0162 | <code>input           cp0_lsu_cb_aclr_dis;                </code> | 声明输入 `cp0_lsu_cb_aclr_dis`，1 bit。禁止跨 16-byte 边界的 cache-buffer acceleration。 |
| <!-- SRC-LINE:0163 -->L0163 | <code>input           cp0_lsu_da_fwd_dis;                 </code> | 声明输入 `cp0_lsu_da_fwd_dis`，1 bit。禁止 load ahead/DA forwarding 相关有效信号。 |
| <!-- SRC-LINE:0164 -->L0164 | <code>input           cp0_lsu_dcache_en;                  </code> | 声明输入 `cp0_lsu_dcache_en`，1 bit。数据缓存使能；门控 tag/data array 请求。 |
| <!-- SRC-LINE:0165 -->L0165 | <code>input           cp0_lsu_icg_en;                     </code> | 声明输入 `cp0_lsu_icg_en`，1 bit。LSU 模块时钟门控使能。 |
| <!-- SRC-LINE:0166 -->L0166 | <code>input           cp0_lsu_mm;                         </code> | 声明输入 `cp0_lsu_mm`，1 bit。misaligned load 处理模式配置；为 0 时普通 load 不对齐在 AG 报错。 |
| <!-- SRC-LINE:0167 -->L0167 | <code>input           cp0_yy_clk_en;                      </code> | 声明输入 `cp0_yy_clk_en`，1 bit。全局时钟使能。 |
| <!-- SRC-LINE:0168 -->L0168 | <code>input           cpurst_b;                           </code> | 声明输入 `cpurst_b`，1 bit。低有效异步复位。 |
| <!-- SRC-LINE:0169 -->L0169 | <code>input           ctrl_ld_clk;                        </code> | 声明输入 `ctrl_ld_clk`，1 bit。load 控制时钟，用于更新 AG valid。 |
| <!-- SRC-LINE:0170 -->L0170 | <code>input           dcache_arb_ag_ld_sel;               </code> | 声明输入 `dcache_arb_ag_ld_sel`，1 bit。DCACHE arbiter 已选择 load AG 请求；取反形成 cache stall。 |
| <!-- SRC-LINE:0171 -->L0171 | <code>input   [39:0]  dcache_arb_ld_ag_addr;              </code> | 声明输入 `dcache_arb_ld_ag_addr`，位段 [39:0]。DCACHE arbiter 借用的地址。 |
| <!-- SRC-LINE:0172 -->L0172 | <code>input           dcache_arb_ld_ag_borrow_addr_vld;   </code> | 声明输入 `dcache_arb_ld_ag_borrow_addr_vld`，1 bit。DCACHE arbiter 借用地址有效，覆盖下传 DC 地址。 |
| <!-- SRC-LINE:0173 -->L0173 | <code>input           forever_cpuclk;                     </code> | 声明输入 `forever_cpuclk`，1 bit。未门控的 CPU 基准时钟，作为 AG ICG 输入。 |
| <!-- SRC-LINE:0174 -->L0174 | <code>input           idu_lsu_rf_pipe3_already_da;        </code> | 声明输入 `idu_lsu_rf_pipe3_already_da`，1 bit。来自 IDU/RF pipe3 的指令属性或操作数。 |
| <!-- SRC-LINE:0175 -->L0175 | <code>input           idu_lsu_rf_pipe3_atomic;            </code> | 声明输入 `idu_lsu_rf_pipe3_atomic`，1 bit。原子类指令标志。 |
| <!-- SRC-LINE:0176 -->L0176 | <code>input           idu_lsu_rf_pipe3_bkpta_data;        </code> | 声明输入 `idu_lsu_rf_pipe3_bkpta_data`，1 bit。来自 IDU/RF pipe3 的指令属性或操作数。 |
| <!-- SRC-LINE:0177 -->L0177 | <code>input           idu_lsu_rf_pipe3_bkptb_data;        </code> | 声明输入 `idu_lsu_rf_pipe3_bkptb_data`，1 bit。来自 IDU/RF pipe3 的指令属性或操作数。 |
| <!-- SRC-LINE:0178 -->L0178 | <code>input           idu_lsu_rf_pipe3_gateclk_sel;       </code> | 声明输入 `idu_lsu_rf_pipe3_gateclk_sel`，1 bit。RF pipe3 门控时钟选择；本模块同时把它视为 RF 数据有效。 |
| <!-- SRC-LINE:0179 -->L0179 | <code>input   [6 :0]  idu_lsu_rf_pipe3_iid;               </code> | 声明输入 `idu_lsu_rf_pipe3_iid`，位段 [6:0]。指令 ID，用于提交和新旧比较。 |
| <!-- SRC-LINE:0180 -->L0180 | <code>input           idu_lsu_rf_pipe3_inst_fls;          </code> | 声明输入 `idu_lsu_rf_pipe3_inst_fls`，1 bit。来自 IDU/RF pipe3 的指令属性或操作数。 |
| <!-- SRC-LINE:0181 -->L0181 | <code>input           idu_lsu_rf_pipe3_inst_ldr;          </code> | 声明输入 `idu_lsu_rf_pipe3_inst_ldr`，1 bit。寄存器 offset 的 LDR 类地址生成标志。 |
| <!-- SRC-LINE:0182 -->L0182 | <code>input   [1 :0]  idu_lsu_rf_pipe3_inst_size;         </code> | 声明输入 `idu_lsu_rf_pipe3_inst_size`，位段 [1:0]。访问大小编码：BYTE/HALF/WORD/DWORD。 |
| <!-- SRC-LINE:0183 -->L0183 | <code>input   [1 :0]  idu_lsu_rf_pipe3_inst_type;         </code> | 声明输入 `idu_lsu_rf_pipe3_inst_type`，位段 [1:0]。load/atomic 子类型编码。 |
| <!-- SRC-LINE:0184 -->L0184 | <code>input   [11:0]  idu_lsu_rf_pipe3_lch_entry;         </code> | 声明输入 `idu_lsu_rf_pipe3_lch_entry`，位段 [11:0]。对应 LSIQ entry 的 12-bit one-hot/bitmap。 |
| <!-- SRC-LINE:0185 -->L0185 | <code>input           idu_lsu_rf_pipe3_lsfifo;            </code> | 声明输入 `idu_lsu_rf_pipe3_lsfifo`，1 bit。来自 IDU/RF pipe3 的指令属性或操作数。 |
| <!-- SRC-LINE:0186 -->L0186 | <code>input           idu_lsu_rf_pipe3_no_spec;           </code> | 声明输入 `idu_lsu_rf_pipe3_no_spec`，1 bit。来自 IDU/RF pipe3 的指令属性或操作数。 |
| <!-- SRC-LINE:0187 -->L0187 | <code>input           idu_lsu_rf_pipe3_no_spec_exist;     </code> | 声明输入 `idu_lsu_rf_pipe3_no_spec_exist`，1 bit。来自 IDU/RF pipe3 的指令属性或操作数。 |
| <!-- SRC-LINE:0188 -->L0188 | <code>input           idu_lsu_rf_pipe3_off_0_extend;      </code> | 声明输入 `idu_lsu_rf_pipe3_off_0_extend`，1 bit。来自 IDU/RF pipe3 的指令属性或操作数。 |
| <!-- SRC-LINE:0189 -->L0189 | <code>input   [11:0]  idu_lsu_rf_pipe3_offset;            </code> | 声明输入 `idu_lsu_rf_pipe3_offset`，位段 [11:0]。普通 load 的 12-bit 立即数 offset。 |
| <!-- SRC-LINE:0190 -->L0190 | <code>input   [12:0]  idu_lsu_rf_pipe3_offset_plus;       </code> | 声明输入 `idu_lsu_rf_pipe3_offset_plus`，位段 [12:0]。split 首拍使用的 13-bit 备选 offset。 |
| <!-- SRC-LINE:0191 -->L0191 | <code>input           idu_lsu_rf_pipe3_oldest;            </code> | 声明输入 `idu_lsu_rf_pipe3_oldest`，1 bit。来自 IDU/RF pipe3 的指令属性或操作数。 |
| <!-- SRC-LINE:0192 -->L0192 | <code>input   [14:0]  idu_lsu_rf_pipe3_pc;                </code> | 声明输入 `idu_lsu_rf_pipe3_pc`，位段 [14:0]。来自 IDU/RF pipe3 的指令属性或操作数。 |
| <!-- SRC-LINE:0193 -->L0193 | <code>input   [6 :0]  idu_lsu_rf_pipe3_preg;              </code> | 声明输入 `idu_lsu_rf_pipe3_preg`，位段 [6:0]。来自 IDU/RF pipe3 的指令属性或操作数。 |
| <!-- SRC-LINE:0194 -->L0194 | <code>input           idu_lsu_rf_pipe3_sel;               </code> | 声明输入 `idu_lsu_rf_pipe3_sel`，1 bit。RF pipe3 向 AG 发射/选择有效指示。 |
| <!-- SRC-LINE:0195 -->L0195 | <code>input   [3 :0]  idu_lsu_rf_pipe3_shift;             </code> | 声明输入 `idu_lsu_rf_pipe3_shift`，位段 [3:0]。offset 移位选择，RTL 按 one-hot 编码使用。 |
| <!-- SRC-LINE:0196 -->L0196 | <code>input           idu_lsu_rf_pipe3_sign_extend;       </code> | 声明输入 `idu_lsu_rf_pipe3_sign_extend`，1 bit。来自 IDU/RF pipe3 的指令属性或操作数。 |
| <!-- SRC-LINE:0197 -->L0197 | <code>input           idu_lsu_rf_pipe3_spec_fail;         </code> | 声明输入 `idu_lsu_rf_pipe3_spec_fail`，1 bit。来自 IDU/RF pipe3 的指令属性或操作数。 |
| <!-- SRC-LINE:0198 -->L0198 | <code>input           idu_lsu_rf_pipe3_split;             </code> | 声明输入 `idu_lsu_rf_pipe3_split`，1 bit。来自 IDU/RF pipe3 的指令属性或操作数。 |
| <!-- SRC-LINE:0199 -->L0199 | <code>input   [63:0]  idu_lsu_rf_pipe3_src0;              </code> | 声明输入 `idu_lsu_rf_pipe3_src0`，位段 [63:0]。地址基址源操作数。 |
| <!-- SRC-LINE:0200 -->L0200 | <code>input   [63:0]  idu_lsu_rf_pipe3_src1;              </code> | 声明输入 `idu_lsu_rf_pipe3_src1`，位段 [63:0]。LDR 类指令的 offset 源操作数。 |
| <!-- SRC-LINE:0201 -->L0201 | <code>input           idu_lsu_rf_pipe3_unalign_2nd;       </code> | 声明输入 `idu_lsu_rf_pipe3_unalign_2nd`，1 bit。split/边界访问第二拍标志，锁存为 ld_ag_secd。 |
| <!-- SRC-LINE:0202 -->L0202 | <code>input   [6 :0]  idu_lsu_rf_pipe3_vreg;              </code> | 声明输入 `idu_lsu_rf_pipe3_vreg`，位段 [6:0]。来自 IDU/RF pipe3 的指令属性或操作数。 |
| <!-- SRC-LINE:0203 -->L0203 | <code>input           mmu_lsu_buf0;                       </code> | 声明输入 `mmu_lsu_buf0`，1 bit。来自 MMU port0 的翻译结果、属性或流控。 |
| <!-- SRC-LINE:0204 -->L0204 | <code>input           mmu_lsu_ca0;                        </code> | 声明输入 `mmu_lsu_ca0`，1 bit。页属性：cacheable。 |
| <!-- SRC-LINE:0205 -->L0205 | <code>input   [27:0]  mmu_lsu_pa0;                        </code> | 声明输入 `mmu_lsu_pa0`，位段 [27:0]。MMU 返回的物理页号。 |
| <!-- SRC-LINE:0206 -->L0206 | <code>input           mmu_lsu_pa0_vld;                    </code> | 声明输入 `mmu_lsu_pa0_vld`，1 bit。MMU port0 返回有效；同时限定 CA/SO 和多种异常。 |
| <!-- SRC-LINE:0207 -->L0207 | <code>input           mmu_lsu_page_fault0;                </code> | 声明输入 `mmu_lsu_page_fault0`，1 bit。MMU port0 页故障。 |
| <!-- SRC-LINE:0208 -->L0208 | <code>input           mmu_lsu_sec0;                       </code> | 声明输入 `mmu_lsu_sec0`，1 bit。来自 MMU port0 的翻译结果、属性或流控。 |
| <!-- SRC-LINE:0209 -->L0209 | <code>input           mmu_lsu_sh0;                        </code> | 声明输入 `mmu_lsu_sh0`，1 bit。来自 MMU port0 的翻译结果、属性或流控。 |
| <!-- SRC-LINE:0210 -->L0210 | <code>input           mmu_lsu_so0;                        </code> | 声明输入 `mmu_lsu_so0`，1 bit。页属性：strong order。 |
| <!-- SRC-LINE:0211 -->L0211 | <code>input           mmu_lsu_stall0;                     </code> | 声明输入 `mmu_lsu_stall0`，1 bit。MMU stall；上游当前 DUTLB 实现中常为 0，但本模块未按 valid 门控。 |
| <!-- SRC-LINE:0212 -->L0212 | <code>input           pad_yy_icg_scan_en;                 </code> | 声明输入 `pad_yy_icg_scan_en`，1 bit。扫描模式下的 ICG 覆盖使能。 |
| <!-- SRC-LINE:0213 -->L0213 | <code>input           rtu_yy_xx_commit0;                  </code> | 声明输入 `rtu_yy_xx_commit0`，1 bit。来自 RTU 的提交端口信息。 |
| <!-- SRC-LINE:0214 -->L0214 | <code>input   [6 :0]  rtu_yy_xx_commit0_iid;              </code> | 声明输入 `rtu_yy_xx_commit0_iid`，位段 [6:0]。来自 RTU 的提交端口信息。 |
| <!-- SRC-LINE:0215 -->L0215 | <code>input           rtu_yy_xx_commit1;                  </code> | 声明输入 `rtu_yy_xx_commit1`，1 bit。来自 RTU 的提交端口信息。 |
| <!-- SRC-LINE:0216 -->L0216 | <code>input   [6 :0]  rtu_yy_xx_commit1_iid;              </code> | 声明输入 `rtu_yy_xx_commit1_iid`，位段 [6:0]。来自 RTU 的提交端口信息。 |
| <!-- SRC-LINE:0217 -->L0217 | <code>input           rtu_yy_xx_commit2;                  </code> | 声明输入 `rtu_yy_xx_commit2`，1 bit。来自 RTU 的提交端口信息。 |
| <!-- SRC-LINE:0218 -->L0218 | <code>input   [6 :0]  rtu_yy_xx_commit2_iid;              </code> | 声明输入 `rtu_yy_xx_commit2_iid`，位段 [6:0]。来自 RTU 的提交端口信息。 |
| <!-- SRC-LINE:0219 -->L0219 | <code>input           rtu_yy_xx_flush;                    </code> | 声明输入 `rtu_yy_xx_flush`，1 bit。全局 flush，清除 AG valid 并中止 MMU。 |
| <!-- SRC-LINE:0220 -->L0220 | <code>input   [6 :0]  st_ag_iid;                          </code> | 声明输入 `st_ag_iid`，位段 [6:0]。模块接口信号；具体有效条件由相邻控制信号和功能规则限定。 |
| <!-- SRC-LINE:0221 -->L0221 | <code>output  [7 :0]  ag_dcache_arb_ld_data_gateclk_en;   </code> | 声明输出 `ag_dcache_arb_ld_data_gateclk_en`，位段 [7:0]。发往 DCACHE arbiter 的阵列请求、索引或门控。 |
| <!-- SRC-LINE:0222 -->L0222 | <code>output  [10:0]  ag_dcache_arb_ld_data_high_idx;     </code> | 声明输出 `ag_dcache_arb_ld_data_high_idx`，位段 [10:0]。发往 DCACHE arbiter 的阵列请求、索引或门控。 |
| <!-- SRC-LINE:0223 -->L0223 | <code>output  [10:0]  ag_dcache_arb_ld_data_low_idx;      </code> | 声明输出 `ag_dcache_arb_ld_data_low_idx`，位段 [10:0]。发往 DCACHE arbiter 的阵列请求、索引或门控。 |
| <!-- SRC-LINE:0224 -->L0224 | <code>output  [7 :0]  ag_dcache_arb_ld_data_req;          </code> | 声明输出 `ag_dcache_arb_ld_data_req`，位段 [7:0]。发往 DCACHE arbiter 的阵列请求、索引或门控。 |
| <!-- SRC-LINE:0225 -->L0225 | <code>output          ag_dcache_arb_ld_tag_gateclk_en;    </code> | 声明输出 `ag_dcache_arb_ld_tag_gateclk_en`，1 bit。发往 DCACHE arbiter 的阵列请求、索引或门控。 |
| <!-- SRC-LINE:0226 -->L0226 | <code>output  [8 :0]  ag_dcache_arb_ld_tag_idx;           </code> | 声明输出 `ag_dcache_arb_ld_tag_idx`，位段 [8:0]。发往 DCACHE arbiter 的阵列请求、索引或门控。 |
| <!-- SRC-LINE:0227 -->L0227 | <code>output          ag_dcache_arb_ld_tag_req;           </code> | 声明输出 `ag_dcache_arb_ld_tag_req`，1 bit。发往 DCACHE arbiter 的阵列请求、索引或门控。 |
| <!-- SRC-LINE:0228 -->L0228 | <code>output  [35:0]  ld_ag_addr1_to4;                    </code> | 声明输出 `ld_ag_addr1_to4`，位段 [35:0]。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0229 -->L0229 | <code>output          ld_ag_ahead_predict;                </code> | 声明输出 `ld_ag_ahead_predict`，1 bit。load ahead 预测，本版本恒为 1。 |
| <!-- SRC-LINE:0230 -->L0230 | <code>output          ld_ag_already_da;                   </code> | 声明输出 `ld_ag_already_da`，1 bit。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0231 -->L0231 | <code>output          ld_ag_atomic;                       </code> | 声明输出 `ld_ag_atomic`，1 bit。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0232 -->L0232 | <code>output          ld_ag_boundary;                     </code> | 声明输出 `ld_ag_boundary`，1 bit。普通 load 跨 16-byte 边界或处于第二拍。 |
| <!-- SRC-LINE:0233 -->L0233 | <code>output  [2 :0]  ld_ag_dc_access_size;               </code> | 声明输出 `ld_ag_dc_access_size`，位段 [2:0]。从 AG 下传到 load DC stage 的数据或控制。 |
| <!-- SRC-LINE:0234 -->L0234 | <code>output          ld_ag_dc_acclr_en;                  </code> | 声明输出 `ld_ag_dc_acclr_en`，1 bit。满足 PA valid、cacheable 等条件的边界加速使能。 |
| <!-- SRC-LINE:0235 -->L0235 | <code>output  [39:0]  ld_ag_dc_addr0;                     </code> | 声明输出 `ld_ag_dc_addr0`，位段 [39:0]。从 AG 下传到 load DC stage 的数据或控制。 |
| <!-- SRC-LINE:0236 -->L0236 | <code>output  [15:0]  ld_ag_dc_bytes_vld;                 </code> | 声明输出 `ld_ag_dc_bytes_vld`，位段 [15:0]。当前 16-byte 数据窗口的字节有效掩码。 |
| <!-- SRC-LINE:0237 -->L0237 | <code>output  [15:0]  ld_ag_dc_bytes_vld1;                </code> | 声明输出 `ld_ag_dc_bytes_vld1`，位段 [15:0]。边界访问低地址侧/合并用途的辅助掩码。 |
| <!-- SRC-LINE:0238 -->L0238 | <code>output          ld_ag_dc_fwd_bypass_en;             </code> | 声明输出 `ld_ag_dc_fwd_bypass_en`，1 bit。从 AG 下传到 load DC stage 的数据或控制。 |
| <!-- SRC-LINE:0239 -->L0239 | <code>output          ld_ag_dc_inst_vld;                  </code> | 声明输出 `ld_ag_dc_inst_vld`，1 bit。发往 DC 的有效，排除所有 stall/restart。 |
| <!-- SRC-LINE:0240 -->L0240 | <code>output          ld_ag_dc_load_ahead_inst_vld;       </code> | 声明输出 `ld_ag_dc_load_ahead_inst_vld`，1 bit。从 AG 下传到 load DC stage 的数据或控制。 |
| <!-- SRC-LINE:0241 -->L0241 | <code>output          ld_ag_dc_load_inst_vld;             </code> | 声明输出 `ld_ag_dc_load_inst_vld`，1 bit。从 AG 下传到 load DC stage 的数据或控制。 |
| <!-- SRC-LINE:0242 -->L0242 | <code>output          ld_ag_dc_mmu_req;                   </code> | 声明输出 `ld_ag_dc_mmu_req`，1 bit。从 AG 下传到 load DC stage 的数据或控制。 |
| <!-- SRC-LINE:0243 -->L0243 | <code>output  [3 :0]  ld_ag_dc_rot_sel;                   </code> | 声明输出 `ld_ag_dc_rot_sel`，位段 [3:0]。基于 VA 低 4 位的数据旋转选择。 |
| <!-- SRC-LINE:0244 -->L0244 | <code>output          ld_ag_dc_vload_ahead_inst_vld;      </code> | 声明输出 `ld_ag_dc_vload_ahead_inst_vld`，1 bit。从 AG 下传到 load DC stage 的数据或控制。 |
| <!-- SRC-LINE:0245 -->L0245 | <code>output          ld_ag_dc_vload_inst_vld;            </code> | 声明输出 `ld_ag_dc_vload_inst_vld`，1 bit。从 AG 下传到 load DC stage 的数据或控制。 |
| <!-- SRC-LINE:0246 -->L0246 | <code>output          ld_ag_expt_access_fault_with_page;  </code> | 声明输出 `ld_ag_expt_access_fault_with_page`，1 bit。AG 生成的异常条件。 |
| <!-- SRC-LINE:0247 -->L0247 | <code>output          ld_ag_expt_ldamo_not_ca;            </code> | 声明输出 `ld_ag_expt_ldamo_not_ca`，1 bit。原子 load/AMO 访问 non-cacheable 页的专用异常。 |
| <!-- SRC-LINE:0248 -->L0248 | <code>output          ld_ag_expt_misalign_no_page;        </code> | 声明输出 `ld_ag_expt_misalign_no_page`，1 bit。AG 生成的异常条件。 |
| <!-- SRC-LINE:0249 -->L0249 | <code>output          ld_ag_expt_misalign_with_page;      </code> | 声明输出 `ld_ag_expt_misalign_with_page`，1 bit。AG 生成的异常条件。 |
| <!-- SRC-LINE:0250 -->L0250 | <code>output          ld_ag_expt_page_fault;              </code> | 声明输出 `ld_ag_expt_page_fault`，1 bit。AG 生成的异常条件。 |
| <!-- SRC-LINE:0251 -->L0251 | <code>output          ld_ag_expt_vld;                     </code> | 声明输出 `ld_ag_expt_vld`，1 bit。聚合异常：misalign、SO misalign、带页属性 access fault、page fault。 |
| <!-- SRC-LINE:0252 -->L0252 | <code>output  [6 :0]  ld_ag_iid;                          </code> | 声明输出 `ld_ag_iid`，位段 [6:0]。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0253 -->L0253 | <code>output  [1 :0]  ld_ag_inst_type;                    </code> | 声明输出 `ld_ag_inst_type`，位段 [1:0]。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0254 -->L0254 | <code>output          ld_ag_inst_vfls;                    </code> | 声明输出 `ld_ag_inst_vfls`，1 bit。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0255 -->L0255 | <code>output          ld_ag_inst_vld;                     </code> | 声明输出 `ld_ag_inst_vld`，1 bit。AG 当前指令有效；stall 时保持，flush/reset 时清零。 |
| <!-- SRC-LINE:0256 -->L0256 | <code>output  [14:0]  ld_ag_ldfifo_pc;                    </code> | 声明输出 `ld_ag_ldfifo_pc`，位段 [14:0]。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0257 -->L0257 | <code>output          ld_ag_lm_init_vld;                  </code> | 声明输出 `ld_ag_lm_init_vld`，1 bit。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0258 -->L0258 | <code>output          ld_ag_lr_inst;                      </code> | 声明输出 `ld_ag_lr_inst`，1 bit。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0259 -->L0259 | <code>output  [11:0]  ld_ag_lsid;                         </code> | 声明输出 `ld_ag_lsid`，位段 [11:0]。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0260 -->L0260 | <code>output          ld_ag_lsiq_bkpta_data;              </code> | 声明输出 `ld_ag_lsiq_bkpta_data`，1 bit。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0261 -->L0261 | <code>output          ld_ag_lsiq_bkptb_data;              </code> | 声明输出 `ld_ag_lsiq_bkptb_data`，1 bit。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0262 -->L0262 | <code>output          ld_ag_lsiq_spec_fail;               </code> | 声明输出 `ld_ag_lsiq_spec_fail`，1 bit。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0263 -->L0263 | <code>output          ld_ag_no_spec;                      </code> | 声明输出 `ld_ag_no_spec`，1 bit。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0264 -->L0264 | <code>output          ld_ag_no_spec_exist;                </code> | 声明输出 `ld_ag_no_spec_exist`，1 bit。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0265 -->L0265 | <code>output          ld_ag_old;                          </code> | 声明输出 `ld_ag_old`，1 bit。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0266 -->L0266 | <code>output  [39:0]  ld_ag_pa;                           </code> | 声明输出 `ld_ag_pa`，位段 [39:0]。MMU PPN 与最终 VA 低 12 位拼接的物理地址。 |
| <!-- SRC-LINE:0267 -->L0267 | <code>output          ld_ag_page_buf;                     </code> | 声明输出 `ld_ag_page_buf`，1 bit。MMU 页面属性的 AG 侧输出。 |
| <!-- SRC-LINE:0268 -->L0268 | <code>output          ld_ag_page_ca;                      </code> | 声明输出 `ld_ag_page_ca`，1 bit。MMU 页面属性的 AG 侧输出。 |
| <!-- SRC-LINE:0269 -->L0269 | <code>output          ld_ag_page_sec;                     </code> | 声明输出 `ld_ag_page_sec`，1 bit。MMU 页面属性的 AG 侧输出。 |
| <!-- SRC-LINE:0270 -->L0270 | <code>output          ld_ag_page_share;                   </code> | 声明输出 `ld_ag_page_share`，1 bit。MMU 页面属性的 AG 侧输出。 |
| <!-- SRC-LINE:0271 -->L0271 | <code>output          ld_ag_page_so;                      </code> | 声明输出 `ld_ag_page_so`，1 bit。MMU 页面属性的 AG 侧输出。 |
| <!-- SRC-LINE:0272 -->L0272 | <code>output          ld_ag_pf_inst;                      </code> | 声明输出 `ld_ag_pf_inst`，1 bit。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0273 -->L0273 | <code>output  [6 :0]  ld_ag_preg;                         </code> | 声明输出 `ld_ag_preg`，位段 [6:0]。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0274 -->L0274 | <code>output          ld_ag_raw_new;                      </code> | 声明输出 `ld_ag_raw_new`，1 bit。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0275 -->L0275 | <code>output          ld_ag_secd;                         </code> | 声明输出 `ld_ag_secd`，1 bit。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0276 -->L0276 | <code>output          ld_ag_sign_extend;                  </code> | 声明输出 `ld_ag_sign_extend`，1 bit。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0277 -->L0277 | <code>output          ld_ag_split;                        </code> | 声明输出 `ld_ag_split`，1 bit。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0278 -->L0278 | <code>output          ld_ag_stall_ori;                    </code> | 声明输出 `ld_ag_stall_ori`，1 bit。不含 atomic-no-commit restart 的原始 stall 指示。 |
| <!-- SRC-LINE:0279 -->L0279 | <code>output  [11:0]  ld_ag_stall_restart_entry;          </code> | 声明输出 `ld_ag_stall_restart_entry`，位段 [11:0]。stall/restart 时选中的 LSIQ entry bitmap。 |
| <!-- SRC-LINE:0280 -->L0280 | <code>output          ld_ag_utlb_miss;                    </code> | 声明输出 `ld_ag_utlb_miss`，1 bit。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0281 -->L0281 | <code>output  [27:0]  ld_ag_vpn;                          </code> | 声明输出 `ld_ag_vpn`，位段 [27:0]。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0282 -->L0282 | <code>output  [5 :0]  ld_ag_vreg;                         </code> | 声明输出 `ld_ag_vreg`，位段 [5:0]。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0283 -->L0283 | <code>output          lsu_hpcp_ld_cross_4k_stall;         </code> | 声明输出 `lsu_hpcp_ld_cross_4k_stall`，1 bit。模块接口信号；具体有效条件由相邻控制信号和功能规则限定。 |
| <!-- SRC-LINE:0284 -->L0284 | <code>output          lsu_hpcp_ld_other_stall;            </code> | 声明输出 `lsu_hpcp_ld_other_stall`，1 bit。模块接口信号；具体有效条件由相邻控制信号和功能规则限定。 |
| <!-- SRC-LINE:0285 -->L0285 | <code>output          lsu_idu_ag_pipe3_load_inst_vld;     </code> | 声明输出 `lsu_idu_ag_pipe3_load_inst_vld`，1 bit。从 LSU/AG 返回 IDU 的调度或目的寄存器信息。 |
| <!-- SRC-LINE:0286 -->L0286 | <code>output  [6 :0]  lsu_idu_ag_pipe3_preg_dup0;         </code> | 声明输出 `lsu_idu_ag_pipe3_preg_dup0`，位段 [6:0]。从 LSU/AG 返回 IDU 的调度或目的寄存器信息。 |
| <!-- SRC-LINE:0287 -->L0287 | <code>output  [6 :0]  lsu_idu_ag_pipe3_preg_dup1;         </code> | 声明输出 `lsu_idu_ag_pipe3_preg_dup1`，位段 [6:0]。从 LSU/AG 返回 IDU 的调度或目的寄存器信息。 |
| <!-- SRC-LINE:0288 -->L0288 | <code>output  [6 :0]  lsu_idu_ag_pipe3_preg_dup2;         </code> | 声明输出 `lsu_idu_ag_pipe3_preg_dup2`，位段 [6:0]。从 LSU/AG 返回 IDU 的调度或目的寄存器信息。 |
| <!-- SRC-LINE:0289 -->L0289 | <code>output  [6 :0]  lsu_idu_ag_pipe3_preg_dup3;         </code> | 声明输出 `lsu_idu_ag_pipe3_preg_dup3`，位段 [6:0]。从 LSU/AG 返回 IDU 的调度或目的寄存器信息。 |
| <!-- SRC-LINE:0290 -->L0290 | <code>output  [6 :0]  lsu_idu_ag_pipe3_preg_dup4;         </code> | 声明输出 `lsu_idu_ag_pipe3_preg_dup4`，位段 [6:0]。从 LSU/AG 返回 IDU 的调度或目的寄存器信息。 |
| <!-- SRC-LINE:0291 -->L0291 | <code>output          lsu_idu_ag_pipe3_vload_inst_vld;    </code> | 声明输出 `lsu_idu_ag_pipe3_vload_inst_vld`，1 bit。从 LSU/AG 返回 IDU 的调度或目的寄存器信息。 |
| <!-- SRC-LINE:0292 -->L0292 | <code>output  [6 :0]  lsu_idu_ag_pipe3_vreg_dup0;         </code> | 声明输出 `lsu_idu_ag_pipe3_vreg_dup0`，位段 [6:0]。从 LSU/AG 返回 IDU 的调度或目的寄存器信息。 |
| <!-- SRC-LINE:0293 -->L0293 | <code>output  [6 :0]  lsu_idu_ag_pipe3_vreg_dup1;         </code> | 声明输出 `lsu_idu_ag_pipe3_vreg_dup1`，位段 [6:0]。从 LSU/AG 返回 IDU 的调度或目的寄存器信息。 |
| <!-- SRC-LINE:0294 -->L0294 | <code>output  [6 :0]  lsu_idu_ag_pipe3_vreg_dup2;         </code> | 声明输出 `lsu_idu_ag_pipe3_vreg_dup2`，位段 [6:0]。从 LSU/AG 返回 IDU 的调度或目的寄存器信息。 |
| <!-- SRC-LINE:0295 -->L0295 | <code>output  [6 :0]  lsu_idu_ag_pipe3_vreg_dup3;         </code> | 声明输出 `lsu_idu_ag_pipe3_vreg_dup3`，位段 [6:0]。从 LSU/AG 返回 IDU 的调度或目的寄存器信息。 |
| <!-- SRC-LINE:0296 -->L0296 | <code>output  [11:0]  lsu_idu_ld_ag_wait_old;             </code> | 声明输出 `lsu_idu_ld_ag_wait_old`，位段 [11:0]。从 LSU/AG 返回 IDU 的调度或目的寄存器信息。 |
| <!-- SRC-LINE:0297 -->L0297 | <code>output          lsu_idu_ld_ag_wait_old_gateclk_en;  </code> | 声明输出 `lsu_idu_ld_ag_wait_old_gateclk_en`，1 bit。从 LSU/AG 返回 IDU 的调度或目的寄存器信息。 |
| <!-- SRC-LINE:0298 -->L0298 | <code>output          lsu_mmu_abort0;                     </code> | 声明输出 `lsu_mmu_abort0`，1 bit。中止当前 MMU port0 请求的组合条件。 |
| <!-- SRC-LINE:0299 -->L0299 | <code>output  [6 :0]  lsu_mmu_id0;                        </code> | 声明输出 `lsu_mmu_id0`，位段 [6:0]。发往 MMU port0 的请求、标识或中止信息。 |
| <!-- SRC-LINE:0300 -->L0300 | <code>output          lsu_mmu_st_inst0;                   </code> | 声明输出 `lsu_mmu_st_inst0`，1 bit。发往 MMU port0 的请求、标识或中止信息。 |
| <!-- SRC-LINE:0301 -->L0301 | <code>output  [63:0]  lsu_mmu_va0;                        </code> | 声明输出 `lsu_mmu_va0`，位段 [63:0]。发往 MMU 的 base VA；页内 offset 在 AG 本地加入。 |
| <!-- SRC-LINE:0302 -->L0302 | <code>output          lsu_mmu_va0_vld;                    </code> | 声明输出 `lsu_mmu_va0_vld`，1 bit。发往 MMU port0 的请求有效，等于 AG valid。 |
| <!-- SRC-LINE:0303 -->L0303 | &nbsp; | 空行，用于分隔“端口方向与位宽声明”中的逻辑块，提高源码可读性。 |

## 内部寄存器、连线与参数

| 行号 | 原始代码 | 中文注释 |
|---:|---|---|
| <!-- SRC-LINE:0304 -->L0304 | <code>// &amp;Regs; @30</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:0305 -->L0305 | <code>reg     [3 :0]  bank_en_low_ori;                    </code> | 声明过程赋值变量 `bank_en_low_ori`，位段 [3:0]。模块接口信号；具体有效条件由相邻控制信号和功能规则限定。 |
| <!-- SRC-LINE:0306 -->L0306 | <code>reg     [3 :0]  ld_ag_access_size_ori;              </code> | 声明过程赋值变量 `ld_ag_access_size_ori`，位段 [3:0]。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0307 -->L0307 | <code>reg             ld_ag_align;                        </code> | 声明过程赋值变量 `ld_ag_align`，1 bit。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0308 -->L0308 | <code>reg             ld_ag_already_cross_page_ldr_imme;  </code> | 声明过程赋值变量 `ld_ag_already_cross_page_ldr_imme`，1 bit。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0309 -->L0309 | <code>reg             ld_ag_already_da;                   </code> | 声明过程赋值变量 `ld_ag_already_da`，1 bit。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0310 -->L0310 | <code>reg             ld_ag_atomic;                       </code> | 声明过程赋值变量 `ld_ag_atomic`，1 bit。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0311 -->L0311 | <code>reg     [63:0]  ld_ag_base;                         </code> | 声明过程赋值变量 `ld_ag_base`，位段 [63:0]。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0312 -->L0312 | <code>reg             ld_ag_bypass_en;                    </code> | 声明过程赋值变量 `ld_ag_bypass_en`，1 bit。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0313 -->L0313 | <code>reg     [2 :0]  ld_ag_dc_access_size;               </code> | 声明过程赋值变量 `ld_ag_dc_access_size`，位段 [2:0]。从 AG 下传到 load DC stage 的数据或控制。 |
| <!-- SRC-LINE:0314 -->L0314 | <code>reg     [6 :0]  ld_ag_iid;                          </code> | 声明过程赋值变量 `ld_ag_iid`，位段 [6:0]。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0315 -->L0315 | <code>reg             ld_ag_inst_fls;                     </code> | 声明过程赋值变量 `ld_ag_inst_fls`，1 bit。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0316 -->L0316 | <code>reg             ld_ag_inst_ldr;                     </code> | 声明过程赋值变量 `ld_ag_inst_ldr`，1 bit。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0317 -->L0317 | <code>reg     [1 :0]  ld_ag_inst_size;                    </code> | 声明过程赋值变量 `ld_ag_inst_size`，位段 [1:0]。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0318 -->L0318 | <code>reg     [1 :0]  ld_ag_inst_type;                    </code> | 声明过程赋值变量 `ld_ag_inst_type`，位段 [1:0]。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0319 -->L0319 | <code>reg             ld_ag_inst_vld;                     </code> | 声明过程赋值变量 `ld_ag_inst_vld`，1 bit。AG 当前指令有效；stall 时保持，flush/reset 时清零。 |
| <!-- SRC-LINE:0320 -->L0320 | <code>reg     [14:0]  ld_ag_ldfifo_pc;                    </code> | 声明过程赋值变量 `ld_ag_ldfifo_pc`，位段 [14:0]。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0321 -->L0321 | <code>reg     [15:0]  ld_ag_le_bytes_vld_high_bits_full;  </code> | 声明过程赋值变量 `ld_ag_le_bytes_vld_high_bits_full`，位段 [15:0]。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0322 -->L0322 | <code>reg     [15:0]  ld_ag_le_bytes_vld_low_bits_full;   </code> | 声明过程赋值变量 `ld_ag_le_bytes_vld_low_bits_full`，位段 [15:0]。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0323 -->L0323 | <code>reg             ld_ag_lsfifo;                       </code> | 声明过程赋值变量 `ld_ag_lsfifo`，1 bit。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0324 -->L0324 | <code>reg     [11:0]  ld_ag_lsid;                         </code> | 声明过程赋值变量 `ld_ag_lsid`，位段 [11:0]。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0325 -->L0325 | <code>reg             ld_ag_lsiq_bkpta_data;              </code> | 声明过程赋值变量 `ld_ag_lsiq_bkpta_data`，1 bit。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0326 -->L0326 | <code>reg             ld_ag_lsiq_bkptb_data;              </code> | 声明过程赋值变量 `ld_ag_lsiq_bkptb_data`，1 bit。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0327 -->L0327 | <code>reg             ld_ag_lsiq_spec_fail;               </code> | 声明过程赋值变量 `ld_ag_lsiq_spec_fail`，1 bit。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0328 -->L0328 | <code>reg             ld_ag_no_spec;                      </code> | 声明过程赋值变量 `ld_ag_no_spec`，1 bit。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0329 -->L0329 | <code>reg             ld_ag_no_spec_exist;                </code> | 声明过程赋值变量 `ld_ag_no_spec_exist`，1 bit。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0330 -->L0330 | <code>reg     [63:0]  ld_ag_offset;                       </code> | 声明过程赋值变量 `ld_ag_offset`，位段 [63:0]。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0331 -->L0331 | <code>reg     [12:0]  ld_ag_offset_plus;                  </code> | 声明过程赋值变量 `ld_ag_offset_plus`，位段 [12:0]。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0332 -->L0332 | <code>reg     [3 :0]  ld_ag_offset_shift;                 </code> | 声明过程赋值变量 `ld_ag_offset_shift`，位段 [3:0]。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0333 -->L0333 | <code>reg             ld_ag_old;                          </code> | 声明过程赋值变量 `ld_ag_old`，1 bit。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0334 -->L0334 | <code>reg     [6 :0]  ld_ag_preg;                         </code> | 声明过程赋值变量 `ld_ag_preg`，位段 [6:0]。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0335 -->L0335 | <code>reg     [6 :0]  ld_ag_preg_dup1;                    </code> | 声明过程赋值变量 `ld_ag_preg_dup1`，位段 [6:0]。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0336 -->L0336 | <code>reg     [6 :0]  ld_ag_preg_dup2;                    </code> | 声明过程赋值变量 `ld_ag_preg_dup2`，位段 [6:0]。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0337 -->L0337 | <code>reg     [6 :0]  ld_ag_preg_dup3;                    </code> | 声明过程赋值变量 `ld_ag_preg_dup3`，位段 [6:0]。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0338 -->L0338 | <code>reg     [6 :0]  ld_ag_preg_dup4;                    </code> | 声明过程赋值变量 `ld_ag_preg_dup4`，位段 [6:0]。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0339 -->L0339 | <code>reg             ld_ag_secd;                         </code> | 声明过程赋值变量 `ld_ag_secd`，1 bit。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0340 -->L0340 | <code>reg             ld_ag_sign_extend;                  </code> | 声明过程赋值变量 `ld_ag_sign_extend`，1 bit。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0341 -->L0341 | <code>reg             ld_ag_split;                        </code> | 声明过程赋值变量 `ld_ag_split`，1 bit。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0342 -->L0342 | <code>reg     [5 :0]  ld_ag_vreg;                         </code> | 声明过程赋值变量 `ld_ag_vreg`，位段 [5:0]。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0343 -->L0343 | <code>reg     [5 :0]  ld_ag_vreg_dup1;                    </code> | 声明过程赋值变量 `ld_ag_vreg_dup1`，位段 [5:0]。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0344 -->L0344 | <code>reg     [5 :0]  ld_ag_vreg_dup2;                    </code> | 声明过程赋值变量 `ld_ag_vreg_dup2`，位段 [5:0]。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0345 -->L0345 | <code>reg     [5 :0]  ld_ag_vreg_dup3;                    </code> | 声明过程赋值变量 `ld_ag_vreg_dup3`，位段 [5:0]。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0346 -->L0346 | &nbsp; | 空行，用于分隔“内部寄存器、连线与参数”中的逻辑块，提高源码可读性。 |
| <!-- SRC-LINE:0347 -->L0347 | <code>// &amp;Wires; @31</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:0348 -->L0348 | <code>wire    [7 :0]  ag_dcache_arb_ld_data_gateclk_en;   </code> | 声明组合连线 `ag_dcache_arb_ld_data_gateclk_en`，位段 [7:0]。发往 DCACHE arbiter 的阵列请求、索引或门控。 |
| <!-- SRC-LINE:0349 -->L0349 | <code>wire    [10:0]  ag_dcache_arb_ld_data_high_idx;     </code> | 声明组合连线 `ag_dcache_arb_ld_data_high_idx`，位段 [10:0]。发往 DCACHE arbiter 的阵列请求、索引或门控。 |
| <!-- SRC-LINE:0350 -->L0350 | <code>wire    [10:0]  ag_dcache_arb_ld_data_low_idx;      </code> | 声明组合连线 `ag_dcache_arb_ld_data_low_idx`，位段 [10:0]。发往 DCACHE arbiter 的阵列请求、索引或门控。 |
| <!-- SRC-LINE:0351 -->L0351 | <code>wire    [7 :0]  ag_dcache_arb_ld_data_req;          </code> | 声明组合连线 `ag_dcache_arb_ld_data_req`，位段 [7:0]。发往 DCACHE arbiter 的阵列请求、索引或门控。 |
| <!-- SRC-LINE:0352 -->L0352 | <code>wire            ag_dcache_arb_ld_gateclk_en;        </code> | 声明组合连线 `ag_dcache_arb_ld_gateclk_en`，1 bit。发往 DCACHE arbiter 的阵列请求、索引或门控。 |
| <!-- SRC-LINE:0353 -->L0353 | <code>wire            ag_dcache_arb_ld_req;               </code> | 声明组合连线 `ag_dcache_arb_ld_req`，1 bit。发往 DCACHE arbiter 的阵列请求、索引或门控。 |
| <!-- SRC-LINE:0354 -->L0354 | <code>wire            ag_dcache_arb_ld_tag_gateclk_en;    </code> | 声明组合连线 `ag_dcache_arb_ld_tag_gateclk_en`，1 bit。发往 DCACHE arbiter 的阵列请求、索引或门控。 |
| <!-- SRC-LINE:0355 -->L0355 | <code>wire    [8 :0]  ag_dcache_arb_ld_tag_idx;           </code> | 声明组合连线 `ag_dcache_arb_ld_tag_idx`，位段 [8:0]。发往 DCACHE arbiter 的阵列请求、索引或门控。 |
| <!-- SRC-LINE:0356 -->L0356 | <code>wire            ag_dcache_arb_ld_tag_req;           </code> | 声明组合连线 `ag_dcache_arb_ld_tag_req`，1 bit。发往 DCACHE arbiter 的阵列请求、索引或门控。 |
| <!-- SRC-LINE:0357 -->L0357 | <code>wire    [3 :0]  bank_en_low;                        </code> | 声明组合连线 `bank_en_low`，位段 [3:0]。模块接口信号；具体有效条件由相邻控制信号和功能规则限定。 |
| <!-- SRC-LINE:0358 -->L0358 | <code>wire    [3 :0]  bank_en_low_gateclk;                </code> | 声明组合连线 `bank_en_low_gateclk`，位段 [3:0]。模块接口信号；具体有效条件由相邻控制信号和功能规则限定。 |
| <!-- SRC-LINE:0359 -->L0359 | <code>wire            cp0_lsu_cb_aclr_dis;                </code> | 声明组合连线 `cp0_lsu_cb_aclr_dis`，1 bit。禁止跨 16-byte 边界的 cache-buffer acceleration。 |
| <!-- SRC-LINE:0360 -->L0360 | <code>wire            cp0_lsu_da_fwd_dis;                 </code> | 声明组合连线 `cp0_lsu_da_fwd_dis`，1 bit。禁止 load ahead/DA forwarding 相关有效信号。 |
| <!-- SRC-LINE:0361 -->L0361 | <code>wire            cp0_lsu_dcache_en;                  </code> | 声明组合连线 `cp0_lsu_dcache_en`，1 bit。数据缓存使能；门控 tag/data array 请求。 |
| <!-- SRC-LINE:0362 -->L0362 | <code>wire            cp0_lsu_icg_en;                     </code> | 声明组合连线 `cp0_lsu_icg_en`，1 bit。LSU 模块时钟门控使能。 |
| <!-- SRC-LINE:0363 -->L0363 | <code>wire            cp0_lsu_mm;                         </code> | 声明组合连线 `cp0_lsu_mm`，1 bit。misaligned load 处理模式配置；为 0 时普通 load 不对齐在 AG 报错。 |
| <!-- SRC-LINE:0364 -->L0364 | <code>wire            cp0_yy_clk_en;                      </code> | 声明组合连线 `cp0_yy_clk_en`，1 bit。全局时钟使能。 |
| <!-- SRC-LINE:0365 -->L0365 | <code>wire            cpurst_b;                           </code> | 声明组合连线 `cpurst_b`，1 bit。低有效异步复位。 |
| <!-- SRC-LINE:0366 -->L0366 | <code>wire            ctrl_ld_clk;                        </code> | 声明组合连线 `ctrl_ld_clk`，1 bit。load 控制时钟，用于更新 AG valid。 |
| <!-- SRC-LINE:0367 -->L0367 | <code>wire            dcache_arb_ag_ld_sel;               </code> | 声明组合连线 `dcache_arb_ag_ld_sel`，1 bit。DCACHE arbiter 已选择 load AG 请求；取反形成 cache stall。 |
| <!-- SRC-LINE:0368 -->L0368 | <code>wire    [39:0]  dcache_arb_ld_ag_addr;              </code> | 声明组合连线 `dcache_arb_ld_ag_addr`，位段 [39:0]。DCACHE arbiter 借用的地址。 |
| <!-- SRC-LINE:0369 -->L0369 | <code>wire            dcache_arb_ld_ag_borrow_addr_vld;   </code> | 声明组合连线 `dcache_arb_ld_ag_borrow_addr_vld`，1 bit。DCACHE arbiter 借用地址有效，覆盖下传 DC 地址。 |
| <!-- SRC-LINE:0370 -->L0370 | <code>wire            forever_cpuclk;                     </code> | 声明组合连线 `forever_cpuclk`，1 bit。未门控的 CPU 基准时钟，作为 AG ICG 输入。 |
| <!-- SRC-LINE:0371 -->L0371 | <code>wire            idu_lsu_rf_pipe3_already_da;        </code> | 声明组合连线 `idu_lsu_rf_pipe3_already_da`，1 bit。来自 IDU/RF pipe3 的指令属性或操作数。 |
| <!-- SRC-LINE:0372 -->L0372 | <code>wire            idu_lsu_rf_pipe3_atomic;            </code> | 声明组合连线 `idu_lsu_rf_pipe3_atomic`，1 bit。原子类指令标志。 |
| <!-- SRC-LINE:0373 -->L0373 | <code>wire            idu_lsu_rf_pipe3_bkpta_data;        </code> | 声明组合连线 `idu_lsu_rf_pipe3_bkpta_data`，1 bit。来自 IDU/RF pipe3 的指令属性或操作数。 |
| <!-- SRC-LINE:0374 -->L0374 | <code>wire            idu_lsu_rf_pipe3_bkptb_data;        </code> | 声明组合连线 `idu_lsu_rf_pipe3_bkptb_data`，1 bit。来自 IDU/RF pipe3 的指令属性或操作数。 |
| <!-- SRC-LINE:0375 -->L0375 | <code>wire            idu_lsu_rf_pipe3_gateclk_sel;       </code> | 声明组合连线 `idu_lsu_rf_pipe3_gateclk_sel`，1 bit。RF pipe3 门控时钟选择；本模块同时把它视为 RF 数据有效。 |
| <!-- SRC-LINE:0376 -->L0376 | <code>wire    [6 :0]  idu_lsu_rf_pipe3_iid;               </code> | 声明组合连线 `idu_lsu_rf_pipe3_iid`，位段 [6:0]。指令 ID，用于提交和新旧比较。 |
| <!-- SRC-LINE:0377 -->L0377 | <code>wire            idu_lsu_rf_pipe3_inst_fls;          </code> | 声明组合连线 `idu_lsu_rf_pipe3_inst_fls`，1 bit。来自 IDU/RF pipe3 的指令属性或操作数。 |
| <!-- SRC-LINE:0378 -->L0378 | <code>wire            idu_lsu_rf_pipe3_inst_ldr;          </code> | 声明组合连线 `idu_lsu_rf_pipe3_inst_ldr`，1 bit。寄存器 offset 的 LDR 类地址生成标志。 |
| <!-- SRC-LINE:0379 -->L0379 | <code>wire    [1 :0]  idu_lsu_rf_pipe3_inst_size;         </code> | 声明组合连线 `idu_lsu_rf_pipe3_inst_size`，位段 [1:0]。访问大小编码：BYTE/HALF/WORD/DWORD。 |
| <!-- SRC-LINE:0380 -->L0380 | <code>wire    [1 :0]  idu_lsu_rf_pipe3_inst_type;         </code> | 声明组合连线 `idu_lsu_rf_pipe3_inst_type`，位段 [1:0]。load/atomic 子类型编码。 |
| <!-- SRC-LINE:0381 -->L0381 | <code>wire    [11:0]  idu_lsu_rf_pipe3_lch_entry;         </code> | 声明组合连线 `idu_lsu_rf_pipe3_lch_entry`，位段 [11:0]。对应 LSIQ entry 的 12-bit one-hot/bitmap。 |
| <!-- SRC-LINE:0382 -->L0382 | <code>wire            idu_lsu_rf_pipe3_lsfifo;            </code> | 声明组合连线 `idu_lsu_rf_pipe3_lsfifo`，1 bit。来自 IDU/RF pipe3 的指令属性或操作数。 |
| <!-- SRC-LINE:0383 -->L0383 | <code>wire            idu_lsu_rf_pipe3_no_spec;           </code> | 声明组合连线 `idu_lsu_rf_pipe3_no_spec`，1 bit。来自 IDU/RF pipe3 的指令属性或操作数。 |
| <!-- SRC-LINE:0384 -->L0384 | <code>wire            idu_lsu_rf_pipe3_no_spec_exist;     </code> | 声明组合连线 `idu_lsu_rf_pipe3_no_spec_exist`，1 bit。来自 IDU/RF pipe3 的指令属性或操作数。 |
| <!-- SRC-LINE:0385 -->L0385 | <code>wire            idu_lsu_rf_pipe3_off_0_extend;      </code> | 声明组合连线 `idu_lsu_rf_pipe3_off_0_extend`，1 bit。来自 IDU/RF pipe3 的指令属性或操作数。 |
| <!-- SRC-LINE:0386 -->L0386 | <code>wire    [11:0]  idu_lsu_rf_pipe3_offset;            </code> | 声明组合连线 `idu_lsu_rf_pipe3_offset`，位段 [11:0]。普通 load 的 12-bit 立即数 offset。 |
| <!-- SRC-LINE:0387 -->L0387 | <code>wire    [12:0]  idu_lsu_rf_pipe3_offset_plus;       </code> | 声明组合连线 `idu_lsu_rf_pipe3_offset_plus`，位段 [12:0]。split 首拍使用的 13-bit 备选 offset。 |
| <!-- SRC-LINE:0388 -->L0388 | <code>wire            idu_lsu_rf_pipe3_oldest;            </code> | 声明组合连线 `idu_lsu_rf_pipe3_oldest`，1 bit。来自 IDU/RF pipe3 的指令属性或操作数。 |
| <!-- SRC-LINE:0389 -->L0389 | <code>wire    [14:0]  idu_lsu_rf_pipe3_pc;                </code> | 声明组合连线 `idu_lsu_rf_pipe3_pc`，位段 [14:0]。来自 IDU/RF pipe3 的指令属性或操作数。 |
| <!-- SRC-LINE:0390 -->L0390 | <code>wire    [6 :0]  idu_lsu_rf_pipe3_preg;              </code> | 声明组合连线 `idu_lsu_rf_pipe3_preg`，位段 [6:0]。来自 IDU/RF pipe3 的指令属性或操作数。 |
| <!-- SRC-LINE:0391 -->L0391 | <code>wire            idu_lsu_rf_pipe3_sel;               </code> | 声明组合连线 `idu_lsu_rf_pipe3_sel`，1 bit。RF pipe3 向 AG 发射/选择有效指示。 |
| <!-- SRC-LINE:0392 -->L0392 | <code>wire    [3 :0]  idu_lsu_rf_pipe3_shift;             </code> | 声明组合连线 `idu_lsu_rf_pipe3_shift`，位段 [3:0]。offset 移位选择，RTL 按 one-hot 编码使用。 |
| <!-- SRC-LINE:0393 -->L0393 | <code>wire            idu_lsu_rf_pipe3_sign_extend;       </code> | 声明组合连线 `idu_lsu_rf_pipe3_sign_extend`，1 bit。来自 IDU/RF pipe3 的指令属性或操作数。 |
| <!-- SRC-LINE:0394 -->L0394 | <code>wire            idu_lsu_rf_pipe3_spec_fail;         </code> | 声明组合连线 `idu_lsu_rf_pipe3_spec_fail`，1 bit。来自 IDU/RF pipe3 的指令属性或操作数。 |
| <!-- SRC-LINE:0395 -->L0395 | <code>wire            idu_lsu_rf_pipe3_split;             </code> | 声明组合连线 `idu_lsu_rf_pipe3_split`，1 bit。来自 IDU/RF pipe3 的指令属性或操作数。 |
| <!-- SRC-LINE:0396 -->L0396 | <code>wire    [63:0]  idu_lsu_rf_pipe3_src0;              </code> | 声明组合连线 `idu_lsu_rf_pipe3_src0`，位段 [63:0]。地址基址源操作数。 |
| <!-- SRC-LINE:0397 -->L0397 | <code>wire    [63:0]  idu_lsu_rf_pipe3_src1;              </code> | 声明组合连线 `idu_lsu_rf_pipe3_src1`，位段 [63:0]。LDR 类指令的 offset 源操作数。 |
| <!-- SRC-LINE:0398 -->L0398 | <code>wire            idu_lsu_rf_pipe3_unalign_2nd;       </code> | 声明组合连线 `idu_lsu_rf_pipe3_unalign_2nd`，1 bit。split/边界访问第二拍标志，锁存为 ld_ag_secd。 |
| <!-- SRC-LINE:0399 -->L0399 | <code>wire    [6 :0]  idu_lsu_rf_pipe3_vreg;              </code> | 声明组合连线 `idu_lsu_rf_pipe3_vreg`，位段 [6:0]。来自 IDU/RF pipe3 的指令属性或操作数。 |
| <!-- SRC-LINE:0400 -->L0400 | <code>wire            ld_ag_4k_sum_12;                    </code> | 声明组合连线 `ld_ag_4k_sum_12`，1 bit。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0401 -->L0401 | <code>wire    [12:0]  ld_ag_4k_sum_ori;                   </code> | 声明组合连线 `ld_ag_4k_sum_ori`，位段 [12:0]。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0402 -->L0402 | <code>wire    [12:0]  ld_ag_4k_sum_plus;                  </code> | 声明组合连线 `ld_ag_4k_sum_plus`，位段 [12:0]。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0403 -->L0403 | <code>wire    [3 :0]  ld_ag_access_size;                  </code> | 声明组合连线 `ld_ag_access_size`，位段 [3:0]。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0404 -->L0404 | <code>wire            ld_ag_acclr_en;                     </code> | 声明组合连线 `ld_ag_acclr_en`，1 bit。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0405 -->L0405 | <code>wire    [39:0]  ld_ag_addr0;                        </code> | 声明组合连线 `ld_ag_addr0`，位段 [39:0]。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0406 -->L0406 | <code>wire    [35:0]  ld_ag_addr1_to4;                    </code> | 声明组合连线 `ld_ag_addr1_to4`，位段 [35:0]。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0407 -->L0407 | <code>wire            ld_ag_ahead_predict;                </code> | 声明组合连线 `ld_ag_ahead_predict`，1 bit。load ahead 预测，本版本恒为 1。 |
| <!-- SRC-LINE:0408 -->L0408 | <code>wire            ld_ag_atomic_no_cmit_restart_arb;   </code> | 声明组合连线 `ld_ag_atomic_no_cmit_restart_arb`，1 bit。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0409 -->L0409 | <code>wire            ld_ag_atomic_no_cmit_restart_req;   </code> | 声明组合连线 `ld_ag_atomic_no_cmit_restart_req`，1 bit。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0410 -->L0410 | <code>wire            ld_ag_boundary;                     </code> | 声明组合连线 `ld_ag_boundary`，1 bit。普通 load 跨 16-byte 边界或处于第二拍。 |
| <!-- SRC-LINE:0411 -->L0411 | <code>wire            ld_ag_boundary_stall;               </code> | 声明组合连线 `ld_ag_boundary_stall`，1 bit。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0412 -->L0412 | <code>wire            ld_ag_boundary_unmask;              </code> | 声明组合连线 `ld_ag_boundary_unmask`，1 bit。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0413 -->L0413 | <code>wire    [15:0]  ld_ag_bytes_vld;                    </code> | 声明组合连线 `ld_ag_bytes_vld`，位段 [15:0]。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0414 -->L0414 | <code>wire    [15:0]  ld_ag_bytes_vld1;                   </code> | 声明组合连线 `ld_ag_bytes_vld1`，位段 [15:0]。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0415 -->L0415 | <code>wire    [15:0]  ld_ag_bytes_vld_high_bits;          </code> | 声明组合连线 `ld_ag_bytes_vld_high_bits`，位段 [15:0]。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0416 -->L0416 | <code>wire    [15:0]  ld_ag_bytes_vld_low_cross_bits;     </code> | 声明组合连线 `ld_ag_bytes_vld_low_cross_bits`，位段 [15:0]。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0417 -->L0417 | <code>wire            ld_ag_clk;                          </code> | 声明组合连线 `ld_ag_clk`，1 bit。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0418 -->L0418 | <code>wire            ld_ag_clk_en;                       </code> | 声明组合连线 `ld_ag_clk_en`，1 bit。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0419 -->L0419 | <code>wire            ld_ag_cmit;                         </code> | 声明组合连线 `ld_ag_cmit`，1 bit。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0420 -->L0420 | <code>wire            ld_ag_cmit_hit0;                    </code> | 声明组合连线 `ld_ag_cmit_hit0`，1 bit。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0421 -->L0421 | <code>wire            ld_ag_cmit_hit1;                    </code> | 声明组合连线 `ld_ag_cmit_hit1`，1 bit。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0422 -->L0422 | <code>wire            ld_ag_cmit_hit2;                    </code> | 声明组合连线 `ld_ag_cmit_hit2`，1 bit。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0423 -->L0423 | <code>wire            ld_ag_cross_4k;                     </code> | 声明组合连线 `ld_ag_cross_4k`，1 bit。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0424 -->L0424 | <code>wire            ld_ag_cross_page_ldr_imme_stall_arb; </code> | 声明组合连线 `ld_ag_cross_page_ldr_imme_stall_arb`，1 bit。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0425 -->L0425 | <code>wire            ld_ag_cross_page_ldr_imme_stall_req; </code> | 声明组合连线 `ld_ag_cross_page_ldr_imme_stall_req`，1 bit。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0426 -->L0426 | <code>wire            ld_ag_dc_acclr_en;                  </code> | 声明组合连线 `ld_ag_dc_acclr_en`，1 bit。满足 PA valid、cacheable 等条件的边界加速使能。 |
| <!-- SRC-LINE:0427 -->L0427 | <code>wire    [39:0]  ld_ag_dc_addr0;                     </code> | 声明组合连线 `ld_ag_dc_addr0`，位段 [39:0]。从 AG 下传到 load DC stage 的数据或控制。 |
| <!-- SRC-LINE:0428 -->L0428 | <code>wire    [15:0]  ld_ag_dc_bytes_vld;                 </code> | 声明组合连线 `ld_ag_dc_bytes_vld`，位段 [15:0]。当前 16-byte 数据窗口的字节有效掩码。 |
| <!-- SRC-LINE:0429 -->L0429 | <code>wire    [15:0]  ld_ag_dc_bytes_vld1;                </code> | 声明组合连线 `ld_ag_dc_bytes_vld1`，位段 [15:0]。边界访问低地址侧/合并用途的辅助掩码。 |
| <!-- SRC-LINE:0430 -->L0430 | <code>wire            ld_ag_dc_fwd_bypass_en;             </code> | 声明组合连线 `ld_ag_dc_fwd_bypass_en`，1 bit。从 AG 下传到 load DC stage 的数据或控制。 |
| <!-- SRC-LINE:0431 -->L0431 | <code>wire            ld_ag_dc_inst_vld;                  </code> | 声明组合连线 `ld_ag_dc_inst_vld`，1 bit。发往 DC 的有效，排除所有 stall/restart。 |
| <!-- SRC-LINE:0432 -->L0432 | <code>wire            ld_ag_dc_load_ahead_inst_vld;       </code> | 声明组合连线 `ld_ag_dc_load_ahead_inst_vld`，1 bit。从 AG 下传到 load DC stage 的数据或控制。 |
| <!-- SRC-LINE:0433 -->L0433 | <code>wire            ld_ag_dc_load_inst_vld;             </code> | 声明组合连线 `ld_ag_dc_load_inst_vld`，1 bit。从 AG 下传到 load DC stage 的数据或控制。 |
| <!-- SRC-LINE:0434 -->L0434 | <code>wire            ld_ag_dc_mmu_req;                   </code> | 声明组合连线 `ld_ag_dc_mmu_req`，1 bit。从 AG 下传到 load DC stage 的数据或控制。 |
| <!-- SRC-LINE:0435 -->L0435 | <code>wire    [3 :0]  ld_ag_dc_rot_sel;                   </code> | 声明组合连线 `ld_ag_dc_rot_sel`，位段 [3:0]。基于 VA 低 4 位的数据旋转选择。 |
| <!-- SRC-LINE:0436 -->L0436 | <code>wire            ld_ag_dc_vload_ahead_inst_vld;      </code> | 声明组合连线 `ld_ag_dc_vload_ahead_inst_vld`，1 bit。从 AG 下传到 load DC stage 的数据或控制。 |
| <!-- SRC-LINE:0437 -->L0437 | <code>wire            ld_ag_dc_vload_inst_vld;            </code> | 声明组合连线 `ld_ag_dc_vload_inst_vld`，1 bit。从 AG 下传到 load DC stage 的数据或控制。 |
| <!-- SRC-LINE:0438 -->L0438 | <code>wire            ld_ag_dcache_stall_req;             </code> | 声明组合连线 `ld_ag_dcache_stall_req`，1 bit。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0439 -->L0439 | <code>wire            ld_ag_dcache_stall_unmask;          </code> | 声明组合连线 `ld_ag_dcache_stall_unmask`，1 bit。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0440 -->L0440 | <code>wire            ld_ag_expt_access_fault_with_page;  </code> | 声明组合连线 `ld_ag_expt_access_fault_with_page`，1 bit。AG 生成的异常条件。 |
| <!-- SRC-LINE:0441 -->L0441 | <code>wire            ld_ag_expt_ldamo_not_ca;            </code> | 声明组合连线 `ld_ag_expt_ldamo_not_ca`，1 bit。原子 load/AMO 访问 non-cacheable 页的专用异常。 |
| <!-- SRC-LINE:0442 -->L0442 | <code>wire            ld_ag_expt_misalign_no_page;        </code> | 声明组合连线 `ld_ag_expt_misalign_no_page`，1 bit。AG 生成的异常条件。 |
| <!-- SRC-LINE:0443 -->L0443 | <code>wire            ld_ag_expt_misalign_with_page;      </code> | 声明组合连线 `ld_ag_expt_misalign_with_page`，1 bit。AG 生成的异常条件。 |
| <!-- SRC-LINE:0444 -->L0444 | <code>wire            ld_ag_expt_page_fault;              </code> | 声明组合连线 `ld_ag_expt_page_fault`，1 bit。AG 生成的异常条件。 |
| <!-- SRC-LINE:0445 -->L0445 | <code>wire            ld_ag_expt_vld;                     </code> | 声明组合连线 `ld_ag_expt_vld`，1 bit。聚合异常：misalign、SO misalign、带页属性 access fault、page fault。 |
| <!-- SRC-LINE:0446 -->L0446 | <code>wire            ld_ag_inst_fof;                     </code> | 声明组合连线 `ld_ag_inst_fof`，1 bit。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0447 -->L0447 | <code>wire            ld_ag_inst_stall_gateclk_en;        </code> | 声明组合连线 `ld_ag_inst_stall_gateclk_en`，1 bit。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0448 -->L0448 | <code>wire            ld_ag_inst_vfls;                    </code> | 声明组合连线 `ld_ag_inst_vfls`，1 bit。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0449 -->L0449 | <code>wire            ld_ag_inst_vls;                     </code> | 声明组合连线 `ld_ag_inst_vls`，1 bit。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0450 -->L0450 | <code>wire            ld_ag_ld_inst;                      </code> | 声明组合连线 `ld_ag_ld_inst`，1 bit。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0451 -->L0451 | <code>wire            ld_ag_ldamo_inst;                   </code> | 声明组合连线 `ld_ag_ldamo_inst`，1 bit。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0452 -->L0452 | <code>wire    [15:0]  ld_ag_le_bytes_vld_cross;           </code> | 声明组合连线 `ld_ag_le_bytes_vld_cross`，位段 [15:0]。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0453 -->L0453 | <code>wire    [15:0]  ld_ag_le_bytes_vld_high_bits;       </code> | 声明组合连线 `ld_ag_le_bytes_vld_high_bits`，位段 [15:0]。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0454 -->L0454 | <code>wire    [15:0]  ld_ag_le_bytes_vld_low_cross_bits;  </code> | 声明组合连线 `ld_ag_le_bytes_vld_low_cross_bits`，位段 [15:0]。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0455 -->L0455 | <code>wire            ld_ag_lm_init_vld;                  </code> | 声明组合连线 `ld_ag_lm_init_vld`，1 bit。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0456 -->L0456 | <code>wire            ld_ag_lr_inst;                      </code> | 声明组合连线 `ld_ag_lr_inst`，1 bit。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0457 -->L0457 | <code>wire    [11:0]  ld_ag_mask_lsid;                    </code> | 声明组合连线 `ld_ag_mask_lsid`，位段 [11:0]。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0458 -->L0458 | <code>wire            ld_ag_mmu_stall_req;                </code> | 声明组合连线 `ld_ag_mmu_stall_req`，1 bit。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0459 -->L0459 | <code>wire            ld_ag_off_4k_high_bits_all_0_ori;   </code> | 声明组合连线 `ld_ag_off_4k_high_bits_all_0_ori`，1 bit。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0460 -->L0460 | <code>wire            ld_ag_off_4k_high_bits_all_1_ori;   </code> | 声明组合连线 `ld_ag_off_4k_high_bits_all_1_ori`，1 bit。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0461 -->L0461 | <code>wire            ld_ag_off_4k_high_bits_not_eq;      </code> | 声明组合连线 `ld_ag_off_4k_high_bits_not_eq`，1 bit。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0462 -->L0462 | <code>wire    [63:0]  ld_ag_offset_aftershift;            </code> | 声明组合连线 `ld_ag_offset_aftershift`，位段 [63:0]。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0463 -->L0463 | <code>wire    [39:0]  ld_ag_pa;                           </code> | 声明组合连线 `ld_ag_pa`，位段 [39:0]。MMU PPN 与最终 VA 低 12 位拼接的物理地址。 |
| <!-- SRC-LINE:0464 -->L0464 | <code>wire            ld_ag_page_buf;                     </code> | 声明组合连线 `ld_ag_page_buf`，1 bit。MMU 页面属性的 AG 侧输出。 |
| <!-- SRC-LINE:0465 -->L0465 | <code>wire            ld_ag_page_ca;                      </code> | 声明组合连线 `ld_ag_page_ca`，1 bit。MMU 页面属性的 AG 侧输出。 |
| <!-- SRC-LINE:0466 -->L0466 | <code>wire            ld_ag_page_fault;                   </code> | 声明组合连线 `ld_ag_page_fault`，1 bit。MMU 页面属性的 AG 侧输出。 |
| <!-- SRC-LINE:0467 -->L0467 | <code>wire            ld_ag_page_sec;                     </code> | 声明组合连线 `ld_ag_page_sec`，1 bit。MMU 页面属性的 AG 侧输出。 |
| <!-- SRC-LINE:0468 -->L0468 | <code>wire            ld_ag_page_share;                   </code> | 声明组合连线 `ld_ag_page_share`，1 bit。MMU 页面属性的 AG 侧输出。 |
| <!-- SRC-LINE:0469 -->L0469 | <code>wire            ld_ag_page_so;                      </code> | 声明组合连线 `ld_ag_page_so`，1 bit。MMU 页面属性的 AG 侧输出。 |
| <!-- SRC-LINE:0470 -->L0470 | <code>wire            ld_ag_pf_inst;                      </code> | 声明组合连线 `ld_ag_pf_inst`，1 bit。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0471 -->L0471 | <code>wire    [27:0]  ld_ag_pn;                           </code> | 声明组合连线 `ld_ag_pn`，位段 [27:0]。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0472 -->L0472 | <code>wire            ld_ag_raw_new;                      </code> | 声明组合连线 `ld_ag_raw_new`，1 bit。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0473 -->L0473 | <code>wire            ld_ag_secd_imme_stall;              </code> | 声明组合连线 `ld_ag_secd_imme_stall`，1 bit。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0474 -->L0474 | <code>wire            ld_ag_stall_mask;                   </code> | 声明组合连线 `ld_ag_stall_mask`，1 bit。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0475 -->L0475 | <code>wire            ld_ag_stall_ori;                    </code> | 声明组合连线 `ld_ag_stall_ori`，1 bit。不含 atomic-no-commit restart 的原始 stall 指示。 |
| <!-- SRC-LINE:0476 -->L0476 | <code>wire            ld_ag_stall_restart;                </code> | 声明组合连线 `ld_ag_stall_restart`，1 bit。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0477 -->L0477 | <code>wire    [11:0]  ld_ag_stall_restart_entry;          </code> | 声明组合连线 `ld_ag_stall_restart_entry`，位段 [11:0]。stall/restart 时选中的 LSIQ entry bitmap。 |
| <!-- SRC-LINE:0478 -->L0478 | <code>wire            ld_ag_stall_vld;                    </code> | 声明组合连线 `ld_ag_stall_vld`，1 bit。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0479 -->L0479 | <code>wire            ld_ag_unalign;                      </code> | 声明组合连线 `ld_ag_unalign`，1 bit。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0480 -->L0480 | <code>wire            ld_ag_unalign_so;                   </code> | 声明组合连线 `ld_ag_unalign_so`，1 bit。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0481 -->L0481 | <code>wire            ld_ag_utlb_miss;                    </code> | 声明组合连线 `ld_ag_utlb_miss`，1 bit。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0482 -->L0482 | <code>wire    [63:0]  ld_ag_va;                           </code> | 声明组合连线 `ld_ag_va`，位段 [63:0]。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0483 -->L0483 | <code>wire    [4 :0]  ld_ag_va_add_access_size;           </code> | 声明组合连线 `ld_ag_va_add_access_size`，位段 [4:0]。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0484 -->L0484 | <code>wire    [63:0]  ld_ag_va_ori;                       </code> | 声明组合连线 `ld_ag_va_ori`，位段 [63:0]。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0485 -->L0485 | <code>wire    [63:0]  ld_ag_va_plus;                      </code> | 声明组合连线 `ld_ag_va_plus`，位段 [63:0]。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0486 -->L0486 | <code>wire            ld_ag_va_plus_sel;                  </code> | 声明组合连线 `ld_ag_va_plus_sel`，1 bit。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0487 -->L0487 | <code>wire            ld_ag_vmb_merge_vld;                </code> | 声明组合连线 `ld_ag_vmb_merge_vld`，1 bit。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0488 -->L0488 | <code>wire    [27:0]  ld_ag_vpn;                          </code> | 声明组合连线 `ld_ag_vpn`，位段 [27:0]。load AG stage 的状态、地址、分类或控制输出。 |
| <!-- SRC-LINE:0489 -->L0489 | <code>wire            ld_rf_inst_ldr;                     </code> | 声明组合连线 `ld_rf_inst_ldr`，1 bit。模块接口信号；具体有效条件由相邻控制信号和功能规则限定。 |
| <!-- SRC-LINE:0490 -->L0490 | <code>wire            ld_rf_inst_vld;                     </code> | 声明组合连线 `ld_rf_inst_vld`，1 bit。模块接口信号；具体有效条件由相邻控制信号和功能规则限定。 |
| <!-- SRC-LINE:0491 -->L0491 | <code>wire            ld_rf_off_0_extend;                 </code> | 声明组合连线 `ld_rf_off_0_extend`，1 bit。模块接口信号；具体有效条件由相邻控制信号和功能规则限定。 |
| <!-- SRC-LINE:0492 -->L0492 | <code>wire            lsu_hpcp_ld_cross_4k_stall;         </code> | 声明组合连线 `lsu_hpcp_ld_cross_4k_stall`，1 bit。模块接口信号；具体有效条件由相邻控制信号和功能规则限定。 |
| <!-- SRC-LINE:0493 -->L0493 | <code>wire            lsu_hpcp_ld_other_stall;            </code> | 声明组合连线 `lsu_hpcp_ld_other_stall`，1 bit。模块接口信号；具体有效条件由相邻控制信号和功能规则限定。 |
| <!-- SRC-LINE:0494 -->L0494 | <code>wire            lsu_idu_ag_pipe3_load_inst_vld;     </code> | 声明组合连线 `lsu_idu_ag_pipe3_load_inst_vld`，1 bit。从 LSU/AG 返回 IDU 的调度或目的寄存器信息。 |
| <!-- SRC-LINE:0495 -->L0495 | <code>wire    [6 :0]  lsu_idu_ag_pipe3_preg_dup0;         </code> | 声明组合连线 `lsu_idu_ag_pipe3_preg_dup0`，位段 [6:0]。从 LSU/AG 返回 IDU 的调度或目的寄存器信息。 |
| <!-- SRC-LINE:0496 -->L0496 | <code>wire    [6 :0]  lsu_idu_ag_pipe3_preg_dup1;         </code> | 声明组合连线 `lsu_idu_ag_pipe3_preg_dup1`，位段 [6:0]。从 LSU/AG 返回 IDU 的调度或目的寄存器信息。 |
| <!-- SRC-LINE:0497 -->L0497 | <code>wire    [6 :0]  lsu_idu_ag_pipe3_preg_dup2;         </code> | 声明组合连线 `lsu_idu_ag_pipe3_preg_dup2`，位段 [6:0]。从 LSU/AG 返回 IDU 的调度或目的寄存器信息。 |
| <!-- SRC-LINE:0498 -->L0498 | <code>wire    [6 :0]  lsu_idu_ag_pipe3_preg_dup3;         </code> | 声明组合连线 `lsu_idu_ag_pipe3_preg_dup3`，位段 [6:0]。从 LSU/AG 返回 IDU 的调度或目的寄存器信息。 |
| <!-- SRC-LINE:0499 -->L0499 | <code>wire    [6 :0]  lsu_idu_ag_pipe3_preg_dup4;         </code> | 声明组合连线 `lsu_idu_ag_pipe3_preg_dup4`，位段 [6:0]。从 LSU/AG 返回 IDU 的调度或目的寄存器信息。 |
| <!-- SRC-LINE:0500 -->L0500 | <code>wire            lsu_idu_ag_pipe3_vload_inst_vld;    </code> | 声明组合连线 `lsu_idu_ag_pipe3_vload_inst_vld`，1 bit。从 LSU/AG 返回 IDU 的调度或目的寄存器信息。 |
| <!-- SRC-LINE:0501 -->L0501 | <code>wire    [6 :0]  lsu_idu_ag_pipe3_vreg_dup0;         </code> | 声明组合连线 `lsu_idu_ag_pipe3_vreg_dup0`，位段 [6:0]。从 LSU/AG 返回 IDU 的调度或目的寄存器信息。 |
| <!-- SRC-LINE:0502 -->L0502 | <code>wire    [6 :0]  lsu_idu_ag_pipe3_vreg_dup1;         </code> | 声明组合连线 `lsu_idu_ag_pipe3_vreg_dup1`，位段 [6:0]。从 LSU/AG 返回 IDU 的调度或目的寄存器信息。 |
| <!-- SRC-LINE:0503 -->L0503 | <code>wire    [6 :0]  lsu_idu_ag_pipe3_vreg_dup2;         </code> | 声明组合连线 `lsu_idu_ag_pipe3_vreg_dup2`，位段 [6:0]。从 LSU/AG 返回 IDU 的调度或目的寄存器信息。 |
| <!-- SRC-LINE:0504 -->L0504 | <code>wire    [6 :0]  lsu_idu_ag_pipe3_vreg_dup3;         </code> | 声明组合连线 `lsu_idu_ag_pipe3_vreg_dup3`，位段 [6:0]。从 LSU/AG 返回 IDU 的调度或目的寄存器信息。 |
| <!-- SRC-LINE:0505 -->L0505 | <code>wire    [11:0]  lsu_idu_ld_ag_wait_old;             </code> | 声明组合连线 `lsu_idu_ld_ag_wait_old`，位段 [11:0]。从 LSU/AG 返回 IDU 的调度或目的寄存器信息。 |
| <!-- SRC-LINE:0506 -->L0506 | <code>wire            lsu_idu_ld_ag_wait_old_gateclk_en;  </code> | 声明组合连线 `lsu_idu_ld_ag_wait_old_gateclk_en`，1 bit。从 LSU/AG 返回 IDU 的调度或目的寄存器信息。 |
| <!-- SRC-LINE:0507 -->L0507 | <code>wire            lsu_mmu_abort0;                     </code> | 声明组合连线 `lsu_mmu_abort0`，1 bit。中止当前 MMU port0 请求的组合条件。 |
| <!-- SRC-LINE:0508 -->L0508 | <code>wire    [6 :0]  lsu_mmu_id0;                        </code> | 声明组合连线 `lsu_mmu_id0`，位段 [6:0]。发往 MMU port0 的请求、标识或中止信息。 |
| <!-- SRC-LINE:0509 -->L0509 | <code>wire            lsu_mmu_st_inst0;                   </code> | 声明组合连线 `lsu_mmu_st_inst0`，1 bit。发往 MMU port0 的请求、标识或中止信息。 |
| <!-- SRC-LINE:0510 -->L0510 | <code>wire    [63:0]  lsu_mmu_va0;                        </code> | 声明组合连线 `lsu_mmu_va0`，位段 [63:0]。发往 MMU 的 base VA；页内 offset 在 AG 本地加入。 |
| <!-- SRC-LINE:0511 -->L0511 | <code>wire            lsu_mmu_va0_vld;                    </code> | 声明组合连线 `lsu_mmu_va0_vld`，1 bit。发往 MMU port0 的请求有效，等于 AG valid。 |
| <!-- SRC-LINE:0512 -->L0512 | <code>wire            mmu_lsu_buf0;                       </code> | 声明组合连线 `mmu_lsu_buf0`，1 bit。来自 MMU port0 的翻译结果、属性或流控。 |
| <!-- SRC-LINE:0513 -->L0513 | <code>wire            mmu_lsu_ca0;                        </code> | 声明组合连线 `mmu_lsu_ca0`，1 bit。页属性：cacheable。 |
| <!-- SRC-LINE:0514 -->L0514 | <code>wire    [27:0]  mmu_lsu_pa0;                        </code> | 声明组合连线 `mmu_lsu_pa0`，位段 [27:0]。MMU 返回的物理页号。 |
| <!-- SRC-LINE:0515 -->L0515 | <code>wire            mmu_lsu_pa0_vld;                    </code> | 声明组合连线 `mmu_lsu_pa0_vld`，1 bit。MMU port0 返回有效；同时限定 CA/SO 和多种异常。 |
| <!-- SRC-LINE:0516 -->L0516 | <code>wire            mmu_lsu_page_fault0;                </code> | 声明组合连线 `mmu_lsu_page_fault0`，1 bit。MMU port0 页故障。 |
| <!-- SRC-LINE:0517 -->L0517 | <code>wire            mmu_lsu_sec0;                       </code> | 声明组合连线 `mmu_lsu_sec0`，1 bit。来自 MMU port0 的翻译结果、属性或流控。 |
| <!-- SRC-LINE:0518 -->L0518 | <code>wire            mmu_lsu_sh0;                        </code> | 声明组合连线 `mmu_lsu_sh0`，1 bit。来自 MMU port0 的翻译结果、属性或流控。 |
| <!-- SRC-LINE:0519 -->L0519 | <code>wire            mmu_lsu_so0;                        </code> | 声明组合连线 `mmu_lsu_so0`，1 bit。页属性：strong order。 |
| <!-- SRC-LINE:0520 -->L0520 | <code>wire            mmu_lsu_stall0;                     </code> | 声明组合连线 `mmu_lsu_stall0`，1 bit。MMU stall；上游当前 DUTLB 实现中常为 0，但本模块未按 valid 门控。 |
| <!-- SRC-LINE:0521 -->L0521 | <code>wire            pad_yy_icg_scan_en;                 </code> | 声明组合连线 `pad_yy_icg_scan_en`，1 bit。扫描模式下的 ICG 覆盖使能。 |
| <!-- SRC-LINE:0522 -->L0522 | <code>wire            rf_iid_older_than_ld_ag;            </code> | 声明组合连线 `rf_iid_older_than_ld_ag`，1 bit。模块接口信号；具体有效条件由相邻控制信号和功能规则限定。 |
| <!-- SRC-LINE:0523 -->L0523 | <code>wire            rtu_yy_xx_commit0;                  </code> | 声明组合连线 `rtu_yy_xx_commit0`，1 bit。来自 RTU 的提交端口信息。 |
| <!-- SRC-LINE:0524 -->L0524 | <code>wire    [6 :0]  rtu_yy_xx_commit0_iid;              </code> | 声明组合连线 `rtu_yy_xx_commit0_iid`，位段 [6:0]。来自 RTU 的提交端口信息。 |
| <!-- SRC-LINE:0525 -->L0525 | <code>wire            rtu_yy_xx_commit1;                  </code> | 声明组合连线 `rtu_yy_xx_commit1`，1 bit。来自 RTU 的提交端口信息。 |
| <!-- SRC-LINE:0526 -->L0526 | <code>wire    [6 :0]  rtu_yy_xx_commit1_iid;              </code> | 声明组合连线 `rtu_yy_xx_commit1_iid`，位段 [6:0]。来自 RTU 的提交端口信息。 |
| <!-- SRC-LINE:0527 -->L0527 | <code>wire            rtu_yy_xx_commit2;                  </code> | 声明组合连线 `rtu_yy_xx_commit2`，1 bit。来自 RTU 的提交端口信息。 |
| <!-- SRC-LINE:0528 -->L0528 | <code>wire    [6 :0]  rtu_yy_xx_commit2_iid;              </code> | 声明组合连线 `rtu_yy_xx_commit2_iid`，位段 [6:0]。来自 RTU 的提交端口信息。 |
| <!-- SRC-LINE:0529 -->L0529 | <code>wire            rtu_yy_xx_flush;                    </code> | 声明组合连线 `rtu_yy_xx_flush`，1 bit。全局 flush，清除 AG valid 并中止 MMU。 |
| <!-- SRC-LINE:0530 -->L0530 | <code>wire    [6 :0]  st_ag_iid;                          </code> | 声明组合连线 `st_ag_iid`，位段 [6:0]。模块接口信号；具体有效条件由相邻控制信号和功能规则限定。 |
| <!-- SRC-LINE:0531 -->L0531 | &nbsp; | 空行，用于分隔“内部寄存器、连线与参数”中的逻辑块，提高源码可读性。 |
| <!-- SRC-LINE:0532 -->L0532 | &nbsp; | 空行，用于分隔“内部寄存器、连线与参数”中的逻辑块，提高源码可读性。 |
| <!-- SRC-LINE:0533 -->L0533 | <code>parameter BYTE        = 2&#x27;b00,</code> | 声明/延续本模块的本地参数编码，用于访问大小、队列深度或 PC 位宽。 |
| <!-- SRC-LINE:0534 -->L0534 | <code>          HALF        = 2&#x27;b01,</code> | 声明/延续本模块的本地参数编码，用于访问大小、队列深度或 PC 位宽。 |
| <!-- SRC-LINE:0535 -->L0535 | <code>          WORD        = 2&#x27;b10,</code> | 声明/延续本模块的本地参数编码，用于访问大小、队列深度或 PC 位宽。 |
| <!-- SRC-LINE:0536 -->L0536 | <code>          DWORD       = 2&#x27;b11;</code> | 声明/延续本模块的本地参数编码，用于访问大小、队列深度或 PC 位宽。 |
| <!-- SRC-LINE:0537 -->L0537 | &nbsp; | 空行，用于分隔“内部寄存器、连线与参数”中的逻辑块，提高源码可读性。 |
| <!-- SRC-LINE:0538 -->L0538 | <code>parameter LSIQ_ENTRY  = 12;</code> | 声明/延续本模块的本地参数编码，用于访问大小、队列深度或 PC 位宽。 |
| <!-- SRC-LINE:0539 -->L0539 | <code>parameter VMB_ENTRY   = 8;</code> | 声明/延续本模块的本地参数编码，用于访问大小、队列深度或 PC 位宽。 |
| <!-- SRC-LINE:0540 -->L0540 | <code>parameter PC_LEN      = 15;</code> | 声明/延续本模块的本地参数编码，用于访问大小、队列深度或 PC 位宽。 |
| <!-- SRC-LINE:0541 -->L0541 | &nbsp; | 空行，用于分隔“内部寄存器、连线与参数”中的逻辑块，提高源码可读性。 |

## RF 映射与门控时钟

| 行号 | 原始代码 | 中文注释 |
|---:|---|---|
| <!-- SRC-LINE:0542 -->L0542 | <code>//==========================================================</code> | “RF 映射与门控时钟”的视觉分隔注释，不参与逻辑。 |
| <!-- SRC-LINE:0543 -->L0543 | <code>//                        RF signal</code> | 原作者注释，说明“RF signal”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:0544 -->L0544 | <code>//==========================================================</code> | “RF 映射与门控时钟”的视觉分隔注释，不参与逻辑。 |
| <!-- SRC-LINE:0545 -->L0545 | <code>assign ld_rf_inst_vld         = idu_lsu_rf_pipe3_gateclk_sel;</code> | 连续组合赋值开始：驱动 `ld_rf_inst_vld`；完整右值可能延续到后续行，属于“RF 映射与门控时钟”。 |
| <!-- SRC-LINE:0546 -->L0546 | <code>assign ld_rf_inst_ldr         = idu_lsu_rf_pipe3_inst_ldr;</code> | 连续组合赋值开始：驱动 `ld_rf_inst_ldr`；完整右值可能延续到后续行，属于“RF 映射与门控时钟”。 |
| <!-- SRC-LINE:0547 -->L0547 | <code>assign ld_rf_off_0_extend     = idu_lsu_rf_pipe3_off_0_extend;</code> | 连续组合赋值开始：驱动 `ld_rf_off_0_extend`；完整右值可能延续到后续行，属于“RF 映射与门控时钟”。 |
| <!-- SRC-LINE:0548 -->L0548 | <code>//==========================================================</code> | “RF 映射与门控时钟”的视觉分隔注释，不参与逻辑。 |
| <!-- SRC-LINE:0549 -->L0549 | <code>//                 Instance of Gated Cell  </code> | 原作者注释，说明“Instance of Gated Cell”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:0550 -->L0550 | <code>//==========================================================</code> | “RF 映射与门控时钟”的视觉分隔注释，不参与逻辑。 |
| <!-- SRC-LINE:0551 -->L0551 | <code>assign ld_ag_clk_en = idu_lsu_rf_pipe3_gateclk_sel &#124;&#124; ld_ag_inst_stall_gateclk_en;</code> | 生成 AG 数据门控时钟的 local enable：新 RF 指令或 AG 已有有效指令时开钟。 |
| <!-- SRC-LINE:0552 -->L0552 | <code>// &amp;Instance(&quot;gated_clk_cell&quot;, &quot;x_lsu_ld_ag_gated_clk&quot;); @52</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:0553 -->L0553 | <code>gated_clk_cell  x_lsu_ld_ag_gated_clk (</code> | 实例化通用门控时钟单元，生成 load AG 数据路径时钟。 |
| <!-- SRC-LINE:0554 -->L0554 | <code>  .clk_in             (forever_cpuclk    ),</code> | 实例端口连接：子模块端口 `clk_in` 连接本层信号/常量 `forever_cpuclk`。 |
| <!-- SRC-LINE:0555 -->L0555 | <code>  .clk_out            (ld_ag_clk         ),</code> | 实例端口连接：子模块端口 `clk_out` 连接本层信号/常量 `ld_ag_clk`。 |
| <!-- SRC-LINE:0556 -->L0556 | <code>  .external_en        (1&#x27;b0              ),</code> | 实例端口连接：子模块端口 `external_en` 连接本层信号/常量 `1'b0`。 |
| <!-- SRC-LINE:0557 -->L0557 | <code>  .global_en          (cp0_yy_clk_en     ),</code> | 实例端口连接：子模块端口 `global_en` 连接本层信号/常量 `cp0_yy_clk_en`。 |
| <!-- SRC-LINE:0558 -->L0558 | <code>  .local_en           (ld_ag_clk_en      ),</code> | 实例端口连接：子模块端口 `local_en` 连接本层信号/常量 `ld_ag_clk_en`。 |
| <!-- SRC-LINE:0559 -->L0559 | <code>  .module_en          (cp0_lsu_icg_en    ),</code> | 实例端口连接：子模块端口 `module_en` 连接本层信号/常量 `cp0_lsu_icg_en`。 |
| <!-- SRC-LINE:0560 -->L0560 | <code>  .pad_yy_icg_scan_en (pad_yy_icg_scan_en)</code> | 实例端口连接：子模块端口 `pad_yy_icg_scan_en` 连接本层信号/常量 `pad_yy_icg_scan_en`。 |
| <!-- SRC-LINE:0561 -->L0561 | <code>);</code> | 结束当前子模块实例的端口连接。 |
| <!-- SRC-LINE:0562 -->L0562 | &nbsp; | 空行，用于分隔“RF 映射与门控时钟”中的逻辑块，提高源码可读性。 |
| <!-- SRC-LINE:0563 -->L0563 | <code>// &amp;Connect(.clk_in        (forever_cpuclk     ), @53</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:0564 -->L0564 | <code>//          .external_en   (1&#x27;b0               ), @54</code> | 原作者注释，说明“.external_en   (1'b0               ), @54”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:0565 -->L0565 | <code>//          .global_en     (cp0_yy_clk_en      ), @55</code> | 原作者注释，说明“.global_en     (cp0_yy_clk_en      ), @55”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:0566 -->L0566 | <code>//          .module_en     (cp0_lsu_icg_en     ), @56</code> | 原作者注释，说明“.module_en     (cp0_lsu_icg_en     ), @56”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:0567 -->L0567 | <code>//          .local_en      (ld_ag_clk_en       ), @57</code> | 原作者注释，说明“.local_en      (ld_ag_clk_en       ), @57”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:0568 -->L0568 | <code>//          .clk_out       (ld_ag_clk          )); @58</code> | 原作者注释，说明“.clk_out       (ld_ag_clk          )); @58”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:0569 -->L0569 | &nbsp; | 空行，用于分隔“RF 映射与门控时钟”中的逻辑块，提高源码可读性。 |

## AG 流水寄存器与重放数据保持

| 行号 | 原始代码 | 中文注释 |
|---:|---|---|
| <!-- SRC-LINE:0570 -->L0570 | <code>//==========================================================</code> | “AG 流水寄存器与重放数据保持”的视觉分隔注释，不参与逻辑。 |
| <!-- SRC-LINE:0571 -->L0571 | <code>//                 Pipeline Register</code> | 原作者注释，说明“Pipeline Register”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:0572 -->L0572 | <code>//==========================================================</code> | “AG 流水寄存器与重放数据保持”的视觉分隔注释，不参与逻辑。 |
| <!-- SRC-LINE:0573 -->L0573 | <code>//------------------control part----------------------------</code> | 原作者注释，说明“------------------control part----------------------------”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:0574 -->L0574 | <code>//+----------+</code> | “AG 流水寄存器与重放数据保持”的视觉分隔注释，不参与逻辑。 |
| <!-- SRC-LINE:0575 -->L0575 | <code>//&#124; inst_vld &#124;</code> | 原作者注释，说明“&#124; inst_vld &#124;”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:0576 -->L0576 | <code>//+----------+</code> | “AG 流水寄存器与重放数据保持”的视觉分隔注释，不参与逻辑。 |
| <!-- SRC-LINE:0577 -->L0577 | <code>//if there is a stall in the AG stage ,the inst keep valid,</code> | 原作者注释，说明“if there is a stall in the AG stage ,the inst keep valid,”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:0578 -->L0578 | <code>//elseif there is inst and no flush in RF stage,</code> | 原作者注释，说明“elseif there is inst and no flush in RF stage,”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:0579 -->L0579 | <code>//the inst goes to the AG stage next cycle</code> | 原作者注释，说明“the inst goes to the AG stage next cycle”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:0580 -->L0580 | &nbsp; | 空行，用于分隔“AG 流水寄存器与重放数据保持”中的逻辑块，提高源码可读性。 |
| <!-- SRC-LINE:0581 -->L0581 | <code>// &amp;Force(&quot;output&quot;,&quot;ld_ag_inst_vld&quot;); @71</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:0582 -->L0582 | <code>always @(posedge ctrl_ld_clk or negedge cpurst_b)</code> | AG valid 的时序逻辑，使用独立的 ctrl_ld_clk 和低有效异步复位。 |
| <!-- SRC-LINE:0583 -->L0583 | <code>begin</code> | 开始上一条 always/if/case 语句的复合语句块。 |
| <!-- SRC-LINE:0584 -->L0584 | <code>  if (!cpurst_b)</code> | 条件分支：仅当 `if (!cpurst_b)` 的条件成立时执行紧随的赋值/语句。 |
| <!-- SRC-LINE:0585 -->L0585 | <code>    ld_ag_inst_vld  &lt;=  1&#x27;b0;</code> | 时序非阻塞赋值：在时钟沿后更新 `ld_ag_inst_vld`；右值及条件由本行和相邻分支定义。 |
| <!-- SRC-LINE:0586 -->L0586 | <code>  else if(rtu_yy_xx_flush)</code> | 条件分支：仅当 `else if(rtu_yy_xx_flush)` 的条件成立时执行紧随的赋值/语句。 |
| <!-- SRC-LINE:0587 -->L0587 | <code>    ld_ag_inst_vld  &lt;=  1&#x27;b0;</code> | 时序非阻塞赋值：在时钟沿后更新 `ld_ag_inst_vld`；右值及条件由本行和相邻分支定义。 |
| <!-- SRC-LINE:0588 -->L0588 | <code>  else if(ld_ag_stall_vld &#124;&#124;  idu_lsu_rf_pipe3_sel)</code> | 若 AG stall 或 RF 有新指令，则下一周期 AG valid 保持/置 1；该条件依赖 stall 不在空闲期误拉高。 |
| <!-- SRC-LINE:0589 -->L0589 | <code>    ld_ag_inst_vld  &lt;=  1&#x27;b1;</code> | 时序非阻塞赋值：在时钟沿后更新 `ld_ag_inst_vld`；右值及条件由本行和相邻分支定义。 |
| <!-- SRC-LINE:0590 -->L0590 | <code>  else</code> | 前述条件均不成立时进入默认分支。 |
| <!-- SRC-LINE:0591 -->L0591 | <code>    ld_ag_inst_vld  &lt;=  1&#x27;b0;</code> | 时序非阻塞赋值：在时钟沿后更新 `ld_ag_inst_vld`；右值及条件由本行和相邻分支定义。 |
| <!-- SRC-LINE:0592 -->L0592 | <code>end</code> | 结束当前复合语句块。 |
| <!-- SRC-LINE:0593 -->L0593 | &nbsp; | 空行，用于分隔“AG 流水寄存器与重放数据保持”中的逻辑块，提高源码可读性。 |
| <!-- SRC-LINE:0594 -->L0594 | <code>//------------------data part-------------------------------</code> | 原作者注释，说明“------------------data part-------------------------------”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:0595 -->L0595 | <code>//+-----------+-----------+------+------------+----------------+</code> | “AG 流水寄存器与重放数据保持”的视觉分隔注释，不参与逻辑。 |
| <!-- SRC-LINE:0596 -->L0596 | <code>//&#124; inst_type &#124; inst_size &#124; secd &#124; already_da &#124; lsiq_spec_fail &#124;</code> | 原作者注释，说明“&#124; inst_type &#124; inst_size &#124; secd &#124; already_da &#124; lsiq_spec_fail &#124;”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:0597 -->L0597 | <code>//+-----------+-----------+------+------------+----------------+</code> | “AG 流水寄存器与重放数据保持”的视觉分隔注释，不参与逻辑。 |
| <!-- SRC-LINE:0598 -->L0598 | <code>//+-------------+----+-----+------+-----+------+</code> | “AG 流水寄存器与重放数据保持”的视觉分隔注释，不参与逻辑。 |
| <!-- SRC-LINE:0599 -->L0599 | <code>//&#124; sign_extend &#124; ex &#124; iid &#124; lsid &#124; old &#124; preg &#124;</code> | 原作者注释，说明“&#124; sign_extend &#124; ex &#124; iid &#124; lsid &#124; old &#124; preg &#124;”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:0600 -->L0600 | <code>//+-------------+----+-----+------+-----+------+</code> | “AG 流水寄存器与重放数据保持”的视觉分隔注释，不参与逻辑。 |
| <!-- SRC-LINE:0601 -->L0601 | <code>//+-----------+----------------+-------+</code> | “AG 流水寄存器与重放数据保持”的视觉分隔注释，不参与逻辑。 |
| <!-- SRC-LINE:0602 -->L0602 | <code>//&#124; ldfifo_pc &#124; unalign_permit &#124; split &#124;</code> | 原作者注释，说明“&#124; ldfifo_pc &#124; unalign_permit &#124; split &#124;”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:0603 -->L0603 | <code>//+-----------+----------------+-------+</code> | “AG 流水寄存器与重放数据保持”的视觉分隔注释，不参与逻辑。 |
| <!-- SRC-LINE:0604 -->L0604 | <code>//+-------+-------+</code> | “AG 流水寄存器与重放数据保持”的视觉分隔注释，不参与逻辑。 |
| <!-- SRC-LINE:0605 -->L0605 | <code>//&#124; bkpta &#124; bkptb &#124;</code> | 原作者注释，说明“&#124; bkpta &#124; bkptb &#124;”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:0606 -->L0606 | <code>//+-------+-------+</code> | “AG 流水寄存器与重放数据保持”的视觉分隔注释，不参与逻辑。 |
| <!-- SRC-LINE:0607 -->L0607 | <code>//if there is a stall in the AG stage ,the inst info keep unchanged,</code> | 原作者注释，说明“if there is a stall in the AG stage ,the inst info keep unchanged,”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:0608 -->L0608 | <code>//elseif there is inst in RF stage, the inst goes to the AG stage next cycle</code> | 原作者注释，说明“elseif there is inst in RF stage, the inst goes to the AG stage next cycle”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:0609 -->L0609 | &nbsp; | 空行，用于分隔“AG 流水寄存器与重放数据保持”中的逻辑块，提高源码可读性。 |
| <!-- SRC-LINE:0610 -->L0610 | <code>// &amp;Force(&quot;bus&quot;,&quot;idu_lsu_rf_pipe3_vreg&quot;,6,0); @100</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:0611 -->L0611 | <code>// &amp;Force(&quot;output&quot;,&quot;ld_ag_split&quot;); @101</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:0612 -->L0612 | <code>// &amp;Force(&quot;output&quot;,&quot;ld_ag_inst_type&quot;); @102</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:0613 -->L0613 | <code>// &amp;Force(&quot;output&quot;,&quot;ld_ag_secd&quot;); @103</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:0614 -->L0614 | <code>// &amp;Force(&quot;output&quot;,&quot;ld_ag_already_da&quot;); @104</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:0615 -->L0615 | <code>// &amp;Force(&quot;output&quot;,&quot;ld_ag_lsiq_spec_fail&quot;); @105</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:0616 -->L0616 | <code>// &amp;Force(&quot;output&quot;,&quot;ld_ag_lsiq_bkpta_data&quot;); @106</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:0617 -->L0617 | <code>// &amp;Force(&quot;output&quot;,&quot;ld_ag_lsiq_bkptb_data&quot;); @107</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:0618 -->L0618 | <code>// &amp;Force(&quot;output&quot;,&quot;ld_ag_sign_extend&quot;); @108</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:0619 -->L0619 | <code>// &amp;Force(&quot;output&quot;,&quot;ld_ag_atomic&quot;); @109</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:0620 -->L0620 | <code>// &amp;Force(&quot;output&quot;,&quot;ld_ag_iid&quot;); @110</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:0621 -->L0621 | <code>// &amp;Force(&quot;output&quot;,&quot;ld_ag_lsid&quot;); @111</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:0622 -->L0622 | <code>// &amp;Force(&quot;output&quot;,&quot;ld_ag_old&quot;); @112</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:0623 -->L0623 | <code>// &amp;Force(&quot;output&quot;,&quot;ld_ag_preg&quot;); @113</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:0624 -->L0624 | <code>// &amp;Force(&quot;output&quot;,&quot;ld_ag_vreg&quot;); @114</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:0625 -->L0625 | <code>// &amp;Force(&quot;output&quot;,&quot;ld_ag_ldfifo_pc&quot;); @115</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:0626 -->L0626 | <code>always @(posedge ld_ag_clk or negedge cpurst_b)</code> | AG 数据寄存器组的时序逻辑，使用门控后的 ld_ag_clk。 |
| <!-- SRC-LINE:0627 -->L0627 | <code>begin</code> | 开始上一条 always/if/case 语句的复合语句块。 |
| <!-- SRC-LINE:0628 -->L0628 | <code>  if (!cpurst_b)</code> | 条件分支：仅当 `if (!cpurst_b)` 的条件成立时执行紧随的赋值/语句。 |
| <!-- SRC-LINE:0629 -->L0629 | <code>  begin</code> | 开始上一条 always/if/case 语句的复合语句块。 |
| <!-- SRC-LINE:0630 -->L0630 | <code>    ld_ag_split                 &lt;=  1&#x27;b0;</code> | 时序非阻塞赋值：在时钟沿后更新 `ld_ag_split`；右值及条件由本行和相邻分支定义。 |
| <!-- SRC-LINE:0631 -->L0631 | <code>    ld_ag_inst_type[1:0]        &lt;=  2&#x27;b0;</code> | 时序非阻塞赋值：在时钟沿后更新 `ld_ag_inst_type[1:0]`；右值及条件由本行和相邻分支定义。 |
| <!-- SRC-LINE:0632 -->L0632 | <code>    ld_ag_inst_size[1:0]        &lt;=  2&#x27;b0;</code> | 时序非阻塞赋值：在时钟沿后更新 `ld_ag_inst_size[1:0]`；右值及条件由本行和相邻分支定义。 |
| <!-- SRC-LINE:0633 -->L0633 | <code>    //ld_ag_inst_code[31:0]       &lt;=  32&#x27;b0;</code> | 原作者注释，说明“ld_ag_inst_code[31:0]       <=  32'b0;”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:0634 -->L0634 | <code>    ld_ag_secd                  &lt;=  1&#x27;b0;</code> | 时序非阻塞赋值：在时钟沿后更新 `ld_ag_secd`；右值及条件由本行和相邻分支定义。 |
| <!-- SRC-LINE:0635 -->L0635 | <code>    ld_ag_already_da            &lt;=  1&#x27;b0;</code> | 时序非阻塞赋值：在时钟沿后更新 `ld_ag_already_da`；右值及条件由本行和相邻分支定义。 |
| <!-- SRC-LINE:0636 -->L0636 | <code>    ld_ag_lsiq_spec_fail        &lt;=  1&#x27;b0;</code> | 时序非阻塞赋值：在时钟沿后更新 `ld_ag_lsiq_spec_fail`；右值及条件由本行和相邻分支定义。 |
| <!-- SRC-LINE:0637 -->L0637 | <code>    ld_ag_lsiq_bkpta_data       &lt;=  1&#x27;b0;</code> | 时序非阻塞赋值：在时钟沿后更新 `ld_ag_lsiq_bkpta_data`；右值及条件由本行和相邻分支定义。 |
| <!-- SRC-LINE:0638 -->L0638 | <code>    ld_ag_lsiq_bkptb_data       &lt;=  1&#x27;b0;</code> | 时序非阻塞赋值：在时钟沿后更新 `ld_ag_lsiq_bkptb_data`；右值及条件由本行和相邻分支定义。 |
| <!-- SRC-LINE:0639 -->L0639 | <code>    ld_ag_sign_extend           &lt;=  1&#x27;b0;</code> | 时序非阻塞赋值：在时钟沿后更新 `ld_ag_sign_extend`；右值及条件由本行和相邻分支定义。 |
| <!-- SRC-LINE:0640 -->L0640 | <code>    ld_ag_atomic                &lt;=  1&#x27;b0;</code> | 时序非阻塞赋值：在时钟沿后更新 `ld_ag_atomic`；右值及条件由本行和相邻分支定义。 |
| <!-- SRC-LINE:0641 -->L0641 | <code>    ld_ag_iid[6:0]              &lt;=  7&#x27;b0;</code> | 时序非阻塞赋值：在时钟沿后更新 `ld_ag_iid[6:0]`；右值及条件由本行和相邻分支定义。 |
| <!-- SRC-LINE:0642 -->L0642 | <code>    ld_ag_lsid[LSIQ_ENTRY-1:0]  &lt;=  {LSIQ_ENTRY{1&#x27;b0}};</code> | 时序非阻塞赋值：在时钟沿后更新 `ld_ag_lsid[LSIQ_ENTRY-1:0]`；右值及条件由本行和相邻分支定义。 |
| <!-- SRC-LINE:0643 -->L0643 | <code>    ld_ag_old                   &lt;=  1&#x27;b0;</code> | 时序非阻塞赋值：在时钟沿后更新 `ld_ag_old`；右值及条件由本行和相邻分支定义。 |
| <!-- SRC-LINE:0644 -->L0644 | <code>    ld_ag_preg[6:0]             &lt;=  7&#x27;b0;</code> | 时序非阻塞赋值：在时钟沿后更新 `ld_ag_preg[6:0]`；右值及条件由本行和相邻分支定义。 |
| <!-- SRC-LINE:0645 -->L0645 | <code>    ld_ag_preg_dup1[6:0]        &lt;=  7&#x27;b0;</code> | 时序非阻塞赋值：在时钟沿后更新 `ld_ag_preg_dup1[6:0]`；右值及条件由本行和相邻分支定义。 |
| <!-- SRC-LINE:0646 -->L0646 | <code>    ld_ag_preg_dup2[6:0]        &lt;=  7&#x27;b0;</code> | 时序非阻塞赋值：在时钟沿后更新 `ld_ag_preg_dup2[6:0]`；右值及条件由本行和相邻分支定义。 |
| <!-- SRC-LINE:0647 -->L0647 | <code>    ld_ag_preg_dup3[6:0]        &lt;=  7&#x27;b0;</code> | 时序非阻塞赋值：在时钟沿后更新 `ld_ag_preg_dup3[6:0]`；右值及条件由本行和相邻分支定义。 |
| <!-- SRC-LINE:0648 -->L0648 | <code>    ld_ag_preg_dup4[6:0]        &lt;=  7&#x27;b0;</code> | 时序非阻塞赋值：在时钟沿后更新 `ld_ag_preg_dup4[6:0]`；右值及条件由本行和相邻分支定义。 |
| <!-- SRC-LINE:0649 -->L0649 | <code>    ld_ag_ldfifo_pc[PC_LEN-1:0] &lt;=  {PC_LEN{1&#x27;b0}};</code> | 时序非阻塞赋值：在时钟沿后更新 `ld_ag_ldfifo_pc[PC_LEN-1:0]`；右值及条件由本行和相邻分支定义。 |
| <!-- SRC-LINE:0650 -->L0650 | <code>    ld_ag_vreg[5:0]             &lt;=  6&#x27;b0;</code> | 时序非阻塞赋值：在时钟沿后更新 `ld_ag_vreg[5:0]`；右值及条件由本行和相邻分支定义。 |
| <!-- SRC-LINE:0651 -->L0651 | <code>    ld_ag_vreg_dup1[5:0]        &lt;=  6&#x27;b0;</code> | 时序非阻塞赋值：在时钟沿后更新 `ld_ag_vreg_dup1[5:0]`；右值及条件由本行和相邻分支定义。 |
| <!-- SRC-LINE:0652 -->L0652 | <code>    ld_ag_vreg_dup2[5:0]        &lt;=  6&#x27;b0;</code> | 时序非阻塞赋值：在时钟沿后更新 `ld_ag_vreg_dup2[5:0]`；右值及条件由本行和相邻分支定义。 |
| <!-- SRC-LINE:0653 -->L0653 | <code>    ld_ag_vreg_dup3[5:0]        &lt;=  6&#x27;b0;</code> | 时序非阻塞赋值：在时钟沿后更新 `ld_ag_vreg_dup3[5:0]`；右值及条件由本行和相邻分支定义。 |
| <!-- SRC-LINE:0654 -->L0654 | <code>    ld_ag_inst_ldr              &lt;=  1&#x27;b0;</code> | 时序非阻塞赋值：在时钟沿后更新 `ld_ag_inst_ldr`；右值及条件由本行和相邻分支定义。 |
| <!-- SRC-LINE:0655 -->L0655 | <code>    ld_ag_inst_fls              &lt;=  1&#x27;b0;</code> | 时序非阻塞赋值：在时钟沿后更新 `ld_ag_inst_fls`；右值及条件由本行和相邻分支定义。 |
| <!-- SRC-LINE:0656 -->L0656 | <code>    ld_ag_lsfifo                &lt;=  1&#x27;b0;</code> | 时序非阻塞赋值：在时钟沿后更新 `ld_ag_lsfifo`；右值及条件由本行和相邻分支定义。 |
| <!-- SRC-LINE:0657 -->L0657 | <code>    ld_ag_no_spec               &lt;=  1&#x27;b0;</code> | 时序非阻塞赋值：在时钟沿后更新 `ld_ag_no_spec`；右值及条件由本行和相邻分支定义。 |
| <!-- SRC-LINE:0658 -->L0658 | <code>    ld_ag_no_spec_exist         &lt;=  1&#x27;b0;</code> | 时序非阻塞赋值：在时钟沿后更新 `ld_ag_no_spec_exist`；右值及条件由本行和相邻分支定义。 |
| <!-- SRC-LINE:0659 -->L0659 | <code>  end</code> | 结束当前复合语句块。 |
| <!-- SRC-LINE:0660 -->L0660 | <code>  else if(!ld_ag_stall_vld  &amp;&amp;  ld_rf_inst_vld)</code> | 仅在 AG 不 stall 且 RF 数据有效时装载新指令数据；stall 时自然保持。 |
| <!-- SRC-LINE:0661 -->L0661 | <code>  begin</code> | 开始上一条 always/if/case 语句的复合语句块。 |
| <!-- SRC-LINE:0662 -->L0662 | <code>    ld_ag_split                 &lt;=  idu_lsu_rf_pipe3_split;</code> | 时序非阻塞赋值：在时钟沿后更新 `ld_ag_split`；右值及条件由本行和相邻分支定义。 |
| <!-- SRC-LINE:0663 -->L0663 | <code>    ld_ag_inst_type[1:0]        &lt;=  idu_lsu_rf_pipe3_inst_type[1:0];</code> | 时序非阻塞赋值：在时钟沿后更新 `ld_ag_inst_type[1:0]`；右值及条件由本行和相邻分支定义。 |
| <!-- SRC-LINE:0664 -->L0664 | <code>    ld_ag_inst_size[1:0]        &lt;=  idu_lsu_rf_pipe3_inst_size[1:0];</code> | 时序非阻塞赋值：在时钟沿后更新 `ld_ag_inst_size[1:0]`；右值及条件由本行和相邻分支定义。 |
| <!-- SRC-LINE:0665 -->L0665 | <code>    //ld_ag_inst_code[31:0]       &lt;=  idu_lsu_rf_pipe3_inst_code[31:0];</code> | 原作者注释，说明“ld_ag_inst_code[31:0]       <=  idu_lsu_rf_pipe3_inst_code[31:0];”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:0666 -->L0666 | <code>    ld_ag_secd                  &lt;=  idu_lsu_rf_pipe3_unalign_2nd;</code> | 时序非阻塞赋值：在时钟沿后更新 `ld_ag_secd`；右值及条件由本行和相邻分支定义。 |
| <!-- SRC-LINE:0667 -->L0667 | <code>    ld_ag_already_da            &lt;=  idu_lsu_rf_pipe3_already_da;</code> | 时序非阻塞赋值：在时钟沿后更新 `ld_ag_already_da`；右值及条件由本行和相邻分支定义。 |
| <!-- SRC-LINE:0668 -->L0668 | <code>    ld_ag_lsiq_spec_fail        &lt;=  idu_lsu_rf_pipe3_spec_fail;</code> | 时序非阻塞赋值：在时钟沿后更新 `ld_ag_lsiq_spec_fail`；右值及条件由本行和相邻分支定义。 |
| <!-- SRC-LINE:0669 -->L0669 | <code>    ld_ag_lsiq_bkpta_data       &lt;=  idu_lsu_rf_pipe3_bkpta_data;</code> | 时序非阻塞赋值：在时钟沿后更新 `ld_ag_lsiq_bkpta_data`；右值及条件由本行和相邻分支定义。 |
| <!-- SRC-LINE:0670 -->L0670 | <code>    ld_ag_lsiq_bkptb_data       &lt;=  idu_lsu_rf_pipe3_bkptb_data;</code> | 时序非阻塞赋值：在时钟沿后更新 `ld_ag_lsiq_bkptb_data`；右值及条件由本行和相邻分支定义。 |
| <!-- SRC-LINE:0671 -->L0671 | <code>    ld_ag_sign_extend           &lt;=  idu_lsu_rf_pipe3_sign_extend;</code> | 时序非阻塞赋值：在时钟沿后更新 `ld_ag_sign_extend`；右值及条件由本行和相邻分支定义。 |
| <!-- SRC-LINE:0672 -->L0672 | <code>    ld_ag_atomic                &lt;=  idu_lsu_rf_pipe3_atomic;</code> | 时序非阻塞赋值：在时钟沿后更新 `ld_ag_atomic`；右值及条件由本行和相邻分支定义。 |
| <!-- SRC-LINE:0673 -->L0673 | <code>    ld_ag_iid[6:0]              &lt;=  idu_lsu_rf_pipe3_iid[6:0];</code> | 时序非阻塞赋值：在时钟沿后更新 `ld_ag_iid[6:0]`；右值及条件由本行和相邻分支定义。 |
| <!-- SRC-LINE:0674 -->L0674 | <code>    ld_ag_lsid[LSIQ_ENTRY-1:0]  &lt;=  idu_lsu_rf_pipe3_lch_entry[LSIQ_ENTRY-1:0];</code> | 时序非阻塞赋值：在时钟沿后更新 `ld_ag_lsid[LSIQ_ENTRY-1:0]`；右值及条件由本行和相邻分支定义。 |
| <!-- SRC-LINE:0675 -->L0675 | <code>    ld_ag_old                   &lt;=  idu_lsu_rf_pipe3_oldest;</code> | 时序非阻塞赋值：在时钟沿后更新 `ld_ag_old`；右值及条件由本行和相邻分支定义。 |
| <!-- SRC-LINE:0676 -->L0676 | <code>    ld_ag_preg[6:0]             &lt;=  idu_lsu_rf_pipe3_preg[6:0];</code> | 时序非阻塞赋值：在时钟沿后更新 `ld_ag_preg[6:0]`；右值及条件由本行和相邻分支定义。 |
| <!-- SRC-LINE:0677 -->L0677 | <code>    ld_ag_preg_dup1[6:0]        &lt;=  idu_lsu_rf_pipe3_preg[6:0];</code> | 时序非阻塞赋值：在时钟沿后更新 `ld_ag_preg_dup1[6:0]`；右值及条件由本行和相邻分支定义。 |
| <!-- SRC-LINE:0678 -->L0678 | <code>    ld_ag_preg_dup2[6:0]        &lt;=  idu_lsu_rf_pipe3_preg[6:0];</code> | 时序非阻塞赋值：在时钟沿后更新 `ld_ag_preg_dup2[6:0]`；右值及条件由本行和相邻分支定义。 |
| <!-- SRC-LINE:0679 -->L0679 | <code>    ld_ag_preg_dup3[6:0]        &lt;=  idu_lsu_rf_pipe3_preg[6:0];</code> | 时序非阻塞赋值：在时钟沿后更新 `ld_ag_preg_dup3[6:0]`；右值及条件由本行和相邻分支定义。 |
| <!-- SRC-LINE:0680 -->L0680 | <code>    ld_ag_preg_dup4[6:0]        &lt;=  idu_lsu_rf_pipe3_preg[6:0];</code> | 时序非阻塞赋值：在时钟沿后更新 `ld_ag_preg_dup4[6:0]`；右值及条件由本行和相邻分支定义。 |
| <!-- SRC-LINE:0681 -->L0681 | <code>    ld_ag_ldfifo_pc[PC_LEN-1:0] &lt;=  idu_lsu_rf_pipe3_pc[PC_LEN-1:0];</code> | 时序非阻塞赋值：在时钟沿后更新 `ld_ag_ldfifo_pc[PC_LEN-1:0]`；右值及条件由本行和相邻分支定义。 |
| <!-- SRC-LINE:0682 -->L0682 | <code>    ld_ag_vreg[5:0]             &lt;=  idu_lsu_rf_pipe3_vreg[5:0];</code> | 时序非阻塞赋值：在时钟沿后更新 `ld_ag_vreg[5:0]`；右值及条件由本行和相邻分支定义。 |
| <!-- SRC-LINE:0683 -->L0683 | <code>    ld_ag_vreg_dup1[5:0]        &lt;=  idu_lsu_rf_pipe3_vreg[5:0];</code> | 时序非阻塞赋值：在时钟沿后更新 `ld_ag_vreg_dup1[5:0]`；右值及条件由本行和相邻分支定义。 |
| <!-- SRC-LINE:0684 -->L0684 | <code>    ld_ag_vreg_dup2[5:0]        &lt;=  idu_lsu_rf_pipe3_vreg[5:0];</code> | 时序非阻塞赋值：在时钟沿后更新 `ld_ag_vreg_dup2[5:0]`；右值及条件由本行和相邻分支定义。 |
| <!-- SRC-LINE:0685 -->L0685 | <code>    ld_ag_vreg_dup3[5:0]        &lt;=  idu_lsu_rf_pipe3_vreg[5:0];</code> | 时序非阻塞赋值：在时钟沿后更新 `ld_ag_vreg_dup3[5:0]`；右值及条件由本行和相邻分支定义。 |
| <!-- SRC-LINE:0686 -->L0686 | <code>    ld_ag_inst_ldr              &lt;=  idu_lsu_rf_pipe3_inst_ldr;</code> | 时序非阻塞赋值：在时钟沿后更新 `ld_ag_inst_ldr`；右值及条件由本行和相邻分支定义。 |
| <!-- SRC-LINE:0687 -->L0687 | <code>    ld_ag_inst_fls              &lt;=  idu_lsu_rf_pipe3_inst_fls;</code> | 时序非阻塞赋值：在时钟沿后更新 `ld_ag_inst_fls`；右值及条件由本行和相邻分支定义。 |
| <!-- SRC-LINE:0688 -->L0688 | <code>    ld_ag_lsfifo                &lt;=  idu_lsu_rf_pipe3_lsfifo;</code> | 时序非阻塞赋值：在时钟沿后更新 `ld_ag_lsfifo`；右值及条件由本行和相邻分支定义。 |
| <!-- SRC-LINE:0689 -->L0689 | <code>    ld_ag_no_spec               &lt;=  idu_lsu_rf_pipe3_no_spec;</code> | 时序非阻塞赋值：在时钟沿后更新 `ld_ag_no_spec`；右值及条件由本行和相邻分支定义。 |
| <!-- SRC-LINE:0690 -->L0690 | <code>    ld_ag_no_spec_exist         &lt;=  idu_lsu_rf_pipe3_no_spec_exist;</code> | 时序非阻塞赋值：在时钟沿后更新 `ld_ag_no_spec_exist`；右值及条件由本行和相邻分支定义。 |
| <!-- SRC-LINE:0691 -->L0691 | <code>  end</code> | 结束当前复合语句块。 |
| <!-- SRC-LINE:0692 -->L0692 | <code>end</code> | 结束当前复合语句块。 |
| <!-- SRC-LINE:0693 -->L0693 | &nbsp; | 空行，用于分隔“AG 流水寄存器与重放数据保持”中的逻辑块，提高源码可读性。 |
| <!-- SRC-LINE:0694 -->L0694 | <code>//+------------------+</code> | “AG 流水寄存器与重放数据保持”的视觉分隔注释，不参与逻辑。 |
| <!-- SRC-LINE:0695 -->L0695 | <code>//&#124; already_cross_4k &#124;</code> | 原作者注释，说明“&#124; already_cross_4k &#124;”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:0696 -->L0696 | <code>//+------------------+</code> | “AG 流水寄存器与重放数据保持”的视觉分隔注释，不参与逻辑。 |
| <!-- SRC-LINE:0697 -->L0697 | <code>//already cross 4k means addr1 is wrong, and mustn&#x27;t merge from cache buffer</code> | 原作者注释，说明“already cross 4k means addr1 is wrong, and mustn't merge from cache buffer”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:0698 -->L0698 | <code>always @(posedge ld_ag_clk or negedge cpurst_b)</code> | 记录一次跨页/边界 LDR 重放已经发生，避免重复执行同一重放动作。 |
| <!-- SRC-LINE:0699 -->L0699 | <code>begin</code> | 开始上一条 always/if/case 语句的复合语句块。 |
| <!-- SRC-LINE:0700 -->L0700 | <code>  if (!cpurst_b)</code> | 条件分支：仅当 `if (!cpurst_b)` 的条件成立时执行紧随的赋值/语句。 |
| <!-- SRC-LINE:0701 -->L0701 | <code>    ld_ag_already_cross_page_ldr_imme  &lt;=  1&#x27;b0;</code> | 时序非阻塞赋值：在时钟沿后更新 `ld_ag_already_cross_page_ldr_imme`；右值及条件由本行和相邻分支定义。 |
| <!-- SRC-LINE:0702 -->L0702 | <code>  else if (!ld_ag_stall_vld)</code> | 条件分支：仅当 `else if (!ld_ag_stall_vld)` 的条件成立时执行紧随的赋值/语句。 |
| <!-- SRC-LINE:0703 -->L0703 | <code>    ld_ag_already_cross_page_ldr_imme  &lt;=  1&#x27;b0;</code> | 时序非阻塞赋值：在时钟沿后更新 `ld_ag_already_cross_page_ldr_imme`；右值及条件由本行和相邻分支定义。 |
| <!-- SRC-LINE:0704 -->L0704 | <code>  else if(ld_ag_stall_vld &amp;&amp;  ld_ag_cross_page_ldr_imme_stall_req)</code> | 条件分支：仅当 `else if(ld_ag_stall_vld &&  ld_ag_cross_page_ldr_imme_stall_req)` 的条件成立时执行紧随的赋值/语句。 |
| <!-- SRC-LINE:0705 -->L0705 | <code>    ld_ag_already_cross_page_ldr_imme  &lt;=  1&#x27;b1;</code> | 时序非阻塞赋值：在时钟沿后更新 `ld_ag_already_cross_page_ldr_imme`；右值及条件由本行和相邻分支定义。 |
| <!-- SRC-LINE:0706 -->L0706 | <code>end</code> | 结束当前复合语句块。 |
| <!-- SRC-LINE:0707 -->L0707 | &nbsp; | 空行，用于分隔“AG 流水寄存器与重放数据保持”中的逻辑块，提高源码可读性。 |
| <!-- SRC-LINE:0708 -->L0708 | <code>//+--------------+</code> | “AG 流水寄存器与重放数据保持”的视觉分隔注释，不参与逻辑。 |
| <!-- SRC-LINE:0709 -->L0709 | <code>//&#124; offset_shift &#124;</code> | 原作者注释，说明“&#124; offset_shift &#124;”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:0710 -->L0710 | <code>//+--------------+</code> | “AG 流水寄存器与重放数据保持”的视觉分隔注释，不参与逻辑。 |
| <!-- SRC-LINE:0711 -->L0711 | <code>//if there is a stall in the AG stage ,offset_shift is reset to 0</code> | 原作者注释，说明“if there is a stall in the AG stage ,offset_shift is reset to 0”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:0712 -->L0712 | <code>//cache stall will not change shift</code> | 原作者注释，说明“cache stall will not change shift”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:0713 -->L0713 | <code>always @(posedge ld_ag_clk or negedge cpurst_b)</code> | 保存 offset 的 one-hot 移位选择；跨页 LDR 重放时重置为不移位。 |
| <!-- SRC-LINE:0714 -->L0714 | <code>begin</code> | 开始上一条 always/if/case 语句的复合语句块。 |
| <!-- SRC-LINE:0715 -->L0715 | <code>  if (!cpurst_b)</code> | 条件分支：仅当 `if (!cpurst_b)` 的条件成立时执行紧随的赋值/语句。 |
| <!-- SRC-LINE:0716 -->L0716 | <code>    ld_ag_offset_shift[3:0] &lt;=  4&#x27;b1;</code> | 时序非阻塞赋值：在时钟沿后更新 `ld_ag_offset_shift[3:0]`；右值及条件由本行和相邻分支定义。 |
| <!-- SRC-LINE:0717 -->L0717 | <code>  else if (!ld_ag_stall_vld &amp;&amp;  idu_lsu_rf_pipe3_sel)</code> | 条件分支：仅当 `else if (!ld_ag_stall_vld &&  idu_lsu_rf_pipe3_sel)` 的条件成立时执行紧随的赋值/语句。 |
| <!-- SRC-LINE:0718 -->L0718 | <code>    ld_ag_offset_shift[3:0] &lt;=  idu_lsu_rf_pipe3_shift[3:0];</code> | 时序非阻塞赋值：在时钟沿后更新 `ld_ag_offset_shift[3:0]`；右值及条件由本行和相邻分支定义。 |
| <!-- SRC-LINE:0719 -->L0719 | <code>  else if(ld_ag_stall_vld &amp;&amp; ld_ag_cross_page_ldr_imme_stall_req)</code> | 条件分支：仅当 `else if(ld_ag_stall_vld && ld_ag_cross_page_ldr_imme_stall_req)` 的条件成立时执行紧随的赋值/语句。 |
| <!-- SRC-LINE:0720 -->L0720 | <code>    ld_ag_offset_shift[3:0] &lt;=  4&#x27;b1;</code> | 时序非阻塞赋值：在时钟沿后更新 `ld_ag_offset_shift[3:0]`；右值及条件由本行和相邻分支定义。 |
| <!-- SRC-LINE:0721 -->L0721 | <code>end</code> | 结束当前复合语句块。 |
| <!-- SRC-LINE:0722 -->L0722 | &nbsp; | 空行，用于分隔“AG 流水寄存器与重放数据保持”中的逻辑块，提高源码可读性。 |
| <!-- SRC-LINE:0723 -->L0723 | <code>//+--------+</code> | “AG 流水寄存器与重放数据保持”的视觉分隔注释，不参与逻辑。 |
| <!-- SRC-LINE:0724 -->L0724 | <code>//&#124; offset &#124;</code> | 原作者注释，说明“&#124; offset &#124;”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:0725 -->L0725 | <code>//+--------+</code> | “AG 流水寄存器与重放数据保持”的视觉分隔注释，不参与逻辑。 |
| <!-- SRC-LINE:0726 -->L0726 | <code>//if the 1st time boundary 2nd instruction stall, the offset set 16 for bias, else</code> | 原作者注释，说明“if the 1st time boundary 2nd instruction stall, the offset set 16 for bias, else”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:0727 -->L0727 | <code>//if stall, it set to 0, cache stall will not change offset</code> | 原作者注释，说明“if stall, it set to 0, cache stall will not change offset”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:0728 -->L0728 | <code>always @(posedge ld_ag_clk)</code> | 更新 offset 高 32 位；无 reset，必须与有效位一起解释。 |
| <!-- SRC-LINE:0729 -->L0729 | <code>begin</code> | 开始上一条 always/if/case 语句的复合语句块。 |
| <!-- SRC-LINE:0730 -->L0730 | <code>  if(ld_ag_cross_page_ldr_imme_stall_arb)</code> | 条件分支：仅当 `if(ld_ag_cross_page_ldr_imme_stall_arb)` 的条件成立时执行紧随的赋值/语句。 |
| <!-- SRC-LINE:0731 -->L0731 | <code>    ld_ag_offset[63:32]  &lt;=  32&#x27;h0;</code> | 时序非阻塞赋值：在时钟沿后更新 `ld_ag_offset[63:32]`；右值及条件由本行和相邻分支定义。 |
| <!-- SRC-LINE:0732 -->L0732 | <code>  else if (!ld_ag_stall_vld &amp;&amp;  ld_rf_inst_vld  &amp;&amp;  !ld_rf_inst_ldr)</code> | 条件分支：仅当 `else if (!ld_ag_stall_vld &&  ld_rf_inst_vld  &&  !ld_rf_inst_ldr)` 的条件成立时执行紧随的赋值/语句。 |
| <!-- SRC-LINE:0733 -->L0733 | <code>    ld_ag_offset[63:32]  &lt;=  {32{idu_lsu_rf_pipe3_offset[11]}};</code> | 时序非阻塞赋值：在时钟沿后更新 `ld_ag_offset[63:32]`；右值及条件由本行和相邻分支定义。 |
| <!-- SRC-LINE:0734 -->L0734 | <code>  else if (!ld_ag_stall_vld &amp;&amp;  ld_rf_inst_vld  &amp;&amp;  ld_rf_inst_ldr  &amp;&amp;  ld_rf_off_0_extend)</code> | 条件分支：仅当 `else if (!ld_ag_stall_vld &&  ld_rf_inst_vld  &&  ld_rf_inst_ldr  &&  ld_rf_off_0_extend)` 的条件成立时执行紧随的赋值/语句。 |
| <!-- SRC-LINE:0735 -->L0735 | <code>    ld_ag_offset[63:32]  &lt;=  32&#x27;h0;</code> | 时序非阻塞赋值：在时钟沿后更新 `ld_ag_offset[63:32]`；右值及条件由本行和相邻分支定义。 |
| <!-- SRC-LINE:0736 -->L0736 | <code>  else if (!ld_ag_stall_vld &amp;&amp;  ld_rf_inst_vld)</code> | 条件分支：仅当 `else if (!ld_ag_stall_vld &&  ld_rf_inst_vld)` 的条件成立时执行紧随的赋值/语句。 |
| <!-- SRC-LINE:0737 -->L0737 | <code>    ld_ag_offset[63:32]  &lt;=  idu_lsu_rf_pipe3_src1[63:32];</code> | 时序非阻塞赋值：在时钟沿后更新 `ld_ag_offset[63:32]`；右值及条件由本行和相邻分支定义。 |
| <!-- SRC-LINE:0738 -->L0738 | <code>end</code> | 结束当前复合语句块。 |
| <!-- SRC-LINE:0739 -->L0739 | &nbsp; | 空行，用于分隔“AG 流水寄存器与重放数据保持”中的逻辑块，提高源码可读性。 |
| <!-- SRC-LINE:0740 -->L0740 | &nbsp; | 空行，用于分隔“AG 流水寄存器与重放数据保持”中的逻辑块，提高源码可读性。 |
| <!-- SRC-LINE:0741 -->L0741 | <code>always @(posedge ld_ag_clk)</code> | 更新 offset 低 32 位；边界第二拍首次重放时注入 0x10。 |
| <!-- SRC-LINE:0742 -->L0742 | <code>begin</code> | 开始上一条 always/if/case 语句的复合语句块。 |
| <!-- SRC-LINE:0743 -->L0743 | <code>  if(ld_ag_cross_page_ldr_imme_stall_arb  &amp;&amp;  ld_ag_secd_imme_stall)</code> | 条件分支：仅当 `if(ld_ag_cross_page_ldr_imme_stall_arb  &&  ld_ag_secd_imme_stall)` 的条件成立时执行紧随的赋值/语句。 |
| <!-- SRC-LINE:0744 -->L0744 | <code>    ld_ag_offset[31:0]  &lt;=  32&#x27;h10;</code> | 时序非阻塞赋值：在时钟沿后更新 `ld_ag_offset[31:0]`；右值及条件由本行和相邻分支定义。 |
| <!-- SRC-LINE:0745 -->L0745 | <code>  else if(ld_ag_cross_page_ldr_imme_stall_arb)</code> | 条件分支：仅当 `else if(ld_ag_cross_page_ldr_imme_stall_arb)` 的条件成立时执行紧随的赋值/语句。 |
| <!-- SRC-LINE:0746 -->L0746 | <code>    ld_ag_offset[31:0]  &lt;=  32&#x27;h0;</code> | 时序非阻塞赋值：在时钟沿后更新 `ld_ag_offset[31:0]`；右值及条件由本行和相邻分支定义。 |
| <!-- SRC-LINE:0747 -->L0747 | <code>  else if (!ld_ag_stall_vld &amp;&amp;  ld_rf_inst_vld  &amp;&amp;  !ld_rf_inst_ldr)</code> | 条件分支：仅当 `else if (!ld_ag_stall_vld &&  ld_rf_inst_vld  &&  !ld_rf_inst_ldr)` 的条件成立时执行紧随的赋值/语句。 |
| <!-- SRC-LINE:0748 -->L0748 | <code>    ld_ag_offset[31:0]  &lt;=  {{20{idu_lsu_rf_pipe3_offset[11]}},idu_lsu_rf_pipe3_offset[11:0]};</code> | 时序非阻塞赋值：在时钟沿后更新 `ld_ag_offset[31:0]`；右值及条件由本行和相邻分支定义。 |
| <!-- SRC-LINE:0749 -->L0749 | <code>  else if (!ld_ag_stall_vld &amp;&amp;  ld_rf_inst_vld)</code> | 条件分支：仅当 `else if (!ld_ag_stall_vld &&  ld_rf_inst_vld)` 的条件成立时执行紧随的赋值/语句。 |
| <!-- SRC-LINE:0750 -->L0750 | <code>    ld_ag_offset[31:0]  &lt;=  idu_lsu_rf_pipe3_src1[31:0];</code> | 时序非阻塞赋值：在时钟沿后更新 `ld_ag_offset[31:0]`；右值及条件由本行和相邻分支定义。 |
| <!-- SRC-LINE:0751 -->L0751 | <code>end</code> | 结束当前复合语句块。 |
| <!-- SRC-LINE:0752 -->L0752 | &nbsp; | 空行，用于分隔“AG 流水寄存器与重放数据保持”中的逻辑块，提高源码可读性。 |
| <!-- SRC-LINE:0753 -->L0753 | <code>//+-------------+</code> | “AG 流水寄存器与重放数据保持”的视觉分隔注释，不参与逻辑。 |
| <!-- SRC-LINE:0754 -->L0754 | <code>//&#124; offset_plus &#124;</code> | 原作者注释，说明“&#124; offset_plus &#124;”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:0755 -->L0755 | <code>//+-------------+</code> | “AG 流水寄存器与重放数据保持”的视觉分隔注释，不参与逻辑。 |
| <!-- SRC-LINE:0756 -->L0756 | <code>//use this imm as offset when the ld/st inst need split and !secd</code> | 原作者注释，说明“use this imm as offset when the ld/st inst need split and !secd”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:0757 -->L0757 | <code>always @(posedge ld_ag_clk or negedge cpurst_b)</code> | 保存 split 首拍的 offset_plus，跨页重放时清零。 |
| <!-- SRC-LINE:0758 -->L0758 | <code>begin</code> | 开始上一条 always/if/case 语句的复合语句块。 |
| <!-- SRC-LINE:0759 -->L0759 | <code>  if (!cpurst_b)</code> | 条件分支：仅当 `if (!cpurst_b)` 的条件成立时执行紧随的赋值/语句。 |
| <!-- SRC-LINE:0760 -->L0760 | <code>    ld_ag_offset_plus[12:0]  &lt;=  13&#x27;h0;</code> | 时序非阻塞赋值：在时钟沿后更新 `ld_ag_offset_plus[12:0]`；右值及条件由本行和相邻分支定义。 |
| <!-- SRC-LINE:0761 -->L0761 | <code>  else if(ld_ag_cross_page_ldr_imme_stall_arb)</code> | 条件分支：仅当 `else if(ld_ag_cross_page_ldr_imme_stall_arb)` 的条件成立时执行紧随的赋值/语句。 |
| <!-- SRC-LINE:0762 -->L0762 | <code>    ld_ag_offset_plus[12:0]  &lt;=  13&#x27;h0;</code> | 时序非阻塞赋值：在时钟沿后更新 `ld_ag_offset_plus[12:0]`；右值及条件由本行和相邻分支定义。 |
| <!-- SRC-LINE:0763 -->L0763 | <code>  else if (!ld_ag_stall_vld &amp;&amp;  ld_rf_inst_vld)</code> | 条件分支：仅当 `else if (!ld_ag_stall_vld &&  ld_rf_inst_vld)` 的条件成立时执行紧随的赋值/语句。 |
| <!-- SRC-LINE:0764 -->L0764 | <code>    ld_ag_offset_plus[12:0]  &lt;=  idu_lsu_rf_pipe3_offset_plus[12:0];</code> | 时序非阻塞赋值：在时钟沿后更新 `ld_ag_offset_plus[12:0]`；右值及条件由本行和相邻分支定义。 |
| <!-- SRC-LINE:0765 -->L0765 | <code>end</code> | 结束当前复合语句块。 |
| <!-- SRC-LINE:0766 -->L0766 | &nbsp; | 空行，用于分隔“AG 流水寄存器与重放数据保持”中的逻辑块，提高源码可读性。 |
| <!-- SRC-LINE:0767 -->L0767 | <code>//+------+</code> | “AG 流水寄存器与重放数据保持”的视觉分隔注释，不参与逻辑。 |
| <!-- SRC-LINE:0768 -->L0768 | <code>//&#124; base &#124;</code> | 原作者注释，说明“&#124; base &#124;”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:0769 -->L0769 | <code>//+------+</code> | “AG 流水寄存器与重放数据保持”的视觉分隔注释，不参与逻辑。 |
| <!-- SRC-LINE:0770 -->L0770 | <code>//the base addr, if stall, the base is set the result from the adder</code> | 原作者注释，说明“the base addr, if stall, the base is set the result from the adder”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:0771 -->L0771 | <code>always @(posedge ld_ag_clk)</code> | 保存 base；跨页重放时把已算出的 VA 回写为新 base。 |
| <!-- SRC-LINE:0772 -->L0772 | <code>begin</code> | 开始上一条 always/if/case 语句的复合语句块。 |
| <!-- SRC-LINE:0773 -->L0773 | <code>  if(ld_ag_cross_page_ldr_imme_stall_arb)</code> | 条件分支：仅当 `if(ld_ag_cross_page_ldr_imme_stall_arb)` 的条件成立时执行紧随的赋值/语句。 |
| <!-- SRC-LINE:0774 -->L0774 | <code>    ld_ag_base[63:0]  &lt;=  ld_ag_va[63:0];</code> | 时序非阻塞赋值：在时钟沿后更新 `ld_ag_base[63:0]`；右值及条件由本行和相邻分支定义。 |
| <!-- SRC-LINE:0775 -->L0775 | <code>  else if (!ld_ag_stall_vld &amp;&amp;  ld_rf_inst_vld)</code> | 条件分支：仅当 `else if (!ld_ag_stall_vld &&  ld_rf_inst_vld)` 的条件成立时执行紧随的赋值/语句。 |
| <!-- SRC-LINE:0776 -->L0776 | <code>    ld_ag_base[63:0]  &lt;=  idu_lsu_rf_pipe3_src0[63:0];</code> | 时序非阻塞赋值：在时钟沿后更新 `ld_ag_base[63:0]`；右值及条件由本行和相邻分支定义。 |
| <!-- SRC-LINE:0777 -->L0777 | <code>end</code> | 结束当前复合语句块。 |
| <!-- SRC-LINE:0778 -->L0778 | &nbsp; | 空行，用于分隔“AG 流水寄存器与重放数据保持”中的逻辑块，提高源码可读性。 |

## 虚拟地址生成

| 行号 | 原始代码 | 中文注释 |
|---:|---|---|
| <!-- SRC-LINE:0779 -->L0779 | <code>//==========================================================</code> | “虚拟地址生成”的视觉分隔注释，不参与逻辑。 |
| <!-- SRC-LINE:0780 -->L0780 | <code>//                      AG gateclk</code> | 原作者注释，说明“AG gateclk”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:0781 -->L0781 | <code>//==========================================================</code> | “虚拟地址生成”的视觉分隔注释，不参与逻辑。 |
| <!-- SRC-LINE:0782 -->L0782 | <code>assign ld_ag_inst_stall_gateclk_en  = ld_ag_inst_vld;</code> | 连续组合赋值开始：驱动 `ld_ag_inst_stall_gateclk_en`；完整右值可能延续到后续行，属于“虚拟地址生成”。 |
| <!-- SRC-LINE:0783 -->L0783 | &nbsp; | 空行，用于分隔“虚拟地址生成”中的逻辑块，提高源码可读性。 |
| <!-- SRC-LINE:0784 -->L0784 | <code>//==========================================================</code> | “虚拟地址生成”的视觉分隔注释，不参与逻辑。 |
| <!-- SRC-LINE:0785 -->L0785 | <code>//               Generate virtual address</code> | 原作者注释，说明“Generate virtual address”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:0786 -->L0786 | <code>//==========================================================</code> | “虚拟地址生成”的视觉分隔注释，不参与逻辑。 |
| <!-- SRC-LINE:0787 -->L0787 | <code>// for first boundary inst, use addr+offset+128 as va instead of addr+offset</code> | 原作者注释，说明“for first boundary inst, use addr+offset+128 as va instead of addr+offset”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:0788 -->L0788 | <code>//for secd boundary,use addr+offset as va</code> | 原作者注释，说明“for secd boundary,use addr+offset as va”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:0789 -->L0789 | <code>assign ld_ag_offset_aftershift[63:0]  = {64{ld_ag_offset_shift[0]}} &amp; ld_ag_offset[63:0]</code> | 按 one-hot shift[3:0] 对 offset 选择左移 0/1/2/3 位并 OR 合成。 |
| <!-- SRC-LINE:0790 -->L0790 | <code>                                        &#124; {64{ld_ag_offset_shift[1]}} &amp; {ld_ag_offset[62:0],1&#x27;b0}</code> | 注释中的 ASCII 框图行，用来列举流水寄存器字段，不参与逻辑。 |
| <!-- SRC-LINE:0791 -->L0791 | <code>                                        &#124; {64{ld_ag_offset_shift[2]}} &amp; {ld_ag_offset[61:0],2&#x27;b0}</code> | 注释中的 ASCII 框图行，用来列举流水寄存器字段，不参与逻辑。 |
| <!-- SRC-LINE:0792 -->L0792 | <code>                                        &#124; {64{ld_ag_offset_shift[3]}} &amp; {ld_ag_offset[60:0],3&#x27;b0};</code> | 注释中的 ASCII 框图行，用来列举流水寄存器字段，不参与逻辑。 |
| <!-- SRC-LINE:0793 -->L0793 | &nbsp; | 空行，用于分隔“虚拟地址生成”中的逻辑块，提高源码可读性。 |
| <!-- SRC-LINE:0794 -->L0794 | <code>assign ld_ag_va_ori[63:0]           = ld_ag_base[63:0]</code> | 计算常规虚拟地址 va_ori = base + shifted_offset。 |
| <!-- SRC-LINE:0795 -->L0795 | <code>                                      + ld_ag_offset_aftershift[63:0];</code> | 注释中的 ASCII 框图行，用来列举流水寄存器字段，不参与逻辑。 |
| <!-- SRC-LINE:0796 -->L0796 | &nbsp; | 空行，用于分隔“虚拟地址生成”中的逻辑块，提高源码可读性。 |
| <!-- SRC-LINE:0797 -->L0797 | <code>assign ld_ag_va_plus[63:0]          = ld_ag_base[63:0]</code> | 计算 split 首拍候选虚拟地址 va_plus = base + sign_extended(offset_plus)。 |
| <!-- SRC-LINE:0798 -->L0798 | <code>                                      + {{51{ld_ag_offset_plus[12]}},ld_ag_offset_plus[12:0]};</code> | 注释中的 ASCII 框图行，用来列举流水寄存器字段，不参与逻辑。 |
| <!-- SRC-LINE:0799 -->L0799 | &nbsp; | 空行，用于分隔“虚拟地址生成”中的逻辑块，提高源码可读性。 |
| <!-- SRC-LINE:0800 -->L0800 | <code>//if misalign without page, then select ori va</code> | 原作者注释，说明“if misalign without page, then select ori va”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:0801 -->L0801 | <code>assign ld_ag_va_plus_sel            = ld_ag_boundary_unmask</code> | 普通非 LDR load 首拍跨 16-byte 边界时选择 va_plus。 |
| <!-- SRC-LINE:0802 -->L0802 | <code>                                      &amp;&amp;  ld_ag_ld_inst </code> | 延续“虚拟地址生成”中的声明、实例连接或多行组合表达式；需与前后行合并阅读。 |
| <!-- SRC-LINE:0803 -->L0803 | <code>                                      &amp;&amp;  !ld_ag_secd</code> | 延续“虚拟地址生成”中的声明、实例连接或多行组合表达式；需与前后行合并阅读。 |
| <!-- SRC-LINE:0804 -->L0804 | <code>                                      &amp;&amp;  !ld_ag_inst_ldr;</code> | 延续“虚拟地址生成”中的声明、实例连接或多行组合表达式；需与前后行合并阅读。 |
| <!-- SRC-LINE:0805 -->L0805 | &nbsp; | 空行，用于分隔“虚拟地址生成”中的逻辑块，提高源码可读性。 |
| <!-- SRC-LINE:0806 -->L0806 | <code>assign ld_ag_va[63:0]               = ld_ag_va_plus_sel</code> | 在 va_plus 与 va_ori 之间选择本拍最终虚拟地址。 |
| <!-- SRC-LINE:0807 -->L0807 | <code>                                      ? ld_ag_va_plus[63:0]</code> | 延续“虚拟地址生成”中的声明、实例连接或多行组合表达式；需与前后行合并阅读。 |
| <!-- SRC-LINE:0808 -->L0808 | <code>                                      : ld_ag_va_ori[63:0]; </code> | 延续“虚拟地址生成”中的声明、实例连接或多行组合表达式；需与前后行合并阅读。 |
| <!-- SRC-LINE:0809 -->L0809 | &nbsp; | 空行，用于分隔“虚拟地址生成”中的逻辑块，提高源码可读性。 |
| <!-- SRC-LINE:0810 -->L0810 | <code>assign ld_ag_vpn[`PA_WIDTH-13:0]    = ld_ag_va[`PA_WIDTH-1:12];</code> | 连续组合赋值开始：驱动 `ld_ag_vpn[`PA_WIDTH-13:0]`；完整右值可能延续到后续行，属于“虚拟地址生成”。 |
| <!-- SRC-LINE:0811 -->L0811 | &nbsp; | 空行，用于分隔“虚拟地址生成”中的逻辑块，提高源码可读性。 |

## 指令类型与预取分类

| 行号 | 原始代码 | 中文注释 |
|---:|---|---|
| <!-- SRC-LINE:0812 -->L0812 | <code>//==========================================================</code> | “指令类型与预取分类”的视觉分隔注释，不参与逻辑。 |
| <!-- SRC-LINE:0813 -->L0813 | <code>//                Generate inst type</code> | 原作者注释，说明“Generate inst type”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:0814 -->L0814 | <code>//==========================================================</code> | “指令类型与预取分类”的视觉分隔注释，不参与逻辑。 |
| <!-- SRC-LINE:0815 -->L0815 | <code>//ld/ldr/lrw/pop/lrs is treated as ld inst</code> | 原作者注释，说明“ld/ldr/lrw/pop/lrs is treated as ld inst”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:0816 -->L0816 | <code>assign ld_ag_ld_inst      = !ld_ag_atomic</code> | 普通 load 分类：非 atomic 且 inst_type 为 00。 |
| <!-- SRC-LINE:0817 -->L0817 | <code>                            &amp;&amp;  (ld_ag_inst_type[1:0]  == 2&#x27;b00);</code> | 延续“指令类型与预取分类”中的声明、实例连接或多行组合表达式；需与前后行合并阅读。 |
| <!-- SRC-LINE:0818 -->L0818 | <code>// &amp;Force(&quot;output&quot;,&quot;ld_ag_lr_inst&quot;); @344</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:0819 -->L0819 | <code>assign ld_ag_lr_inst      = ld_ag_atomic</code> | LR 分类：atomic 且 inst_type 为 01。 |
| <!-- SRC-LINE:0820 -->L0820 | <code>                            &amp;&amp;  (ld_ag_inst_type[1:0]  == 2&#x27;b01);</code> | 延续“指令类型与预取分类”中的声明、实例连接或多行组合表达式；需与前后行合并阅读。 |
| <!-- SRC-LINE:0821 -->L0821 | <code>assign ld_ag_ldamo_inst   = ld_ag_atomic</code> | LDAMO 分类：atomic 且 inst_type 为 00。 |
| <!-- SRC-LINE:0822 -->L0822 | <code>                            &amp;&amp;  (ld_ag_inst_type[1:0]  == 2&#x27;b00);</code> | 延续“指令类型与预取分类”中的声明、实例连接或多行组合表达式；需与前后行合并阅读。 |
| <!-- SRC-LINE:0823 -->L0823 | &nbsp; | 空行，用于分隔“指令类型与预取分类”中的逻辑块，提高源码可读性。 |
| <!-- SRC-LINE:0824 -->L0824 | <code>//-------------need to prefetch inst------------------------</code> | 原作者注释，说明“-------------need to prefetch inst------------------------”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:0825 -->L0825 | <code>assign ld_ag_pf_inst  = ld_ag_ld_inst</code> | 连续组合赋值开始：驱动 `ld_ag_pf_inst`；完整右值可能延续到后续行，属于“指令类型与预取分类”。 |
| <!-- SRC-LINE:0826 -->L0826 | <code>                        &amp;&amp;  !ld_ag_split</code> | 延续“指令类型与预取分类”中的声明、实例连接或多行组合表达式；需与前后行合并阅读。 |
| <!-- SRC-LINE:0827 -->L0827 | <code>                        &amp;&amp;  ld_ag_lsfifo</code> | 延续“指令类型与预取分类”中的声明、实例连接或多行组合表达式；需与前后行合并阅读。 |
| <!-- SRC-LINE:0828 -->L0828 | <code>                        &amp;&amp;  !ld_ag_secd;          //only 1st inst</code> | 延续“指令类型与预取分类”中的声明、实例连接或多行组合表达式；需与前后行合并阅读。 |
| <!-- SRC-LINE:0829 -->L0829 | &nbsp; | 空行，用于分隔“指令类型与预取分类”中的逻辑块，提高源码可读性。 |
| <!-- SRC-LINE:0830 -->L0830 | <code>// &amp;Force(&quot;output&quot;, &quot;ld_ag_vmb_merge_vld&quot;); @357</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:0831 -->L0831 | <code>// &amp;Force(&quot;output&quot;, &quot;ld_ag_inst_fof&quot;); @358</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:0832 -->L0832 | <code>assign ld_ag_inst_vls   = 1&#x27;b0;</code> | 连续组合赋值开始：驱动 `ld_ag_inst_vls`；完整右值可能延续到后续行，属于“指令类型与预取分类”。 |
| <!-- SRC-LINE:0833 -->L0833 | <code>assign ld_ag_inst_fof   = 1&#x27;b0;</code> | 连续组合赋值开始：驱动 `ld_ag_inst_fof`；完整右值可能延续到后续行，属于“指令类型与预取分类”。 |
| <!-- SRC-LINE:0834 -->L0834 | <code>assign ld_ag_inst_vfls  = ld_ag_inst_fls;</code> | 连续组合赋值开始：驱动 `ld_ag_inst_vfls`；完整右值可能延续到后续行，属于“指令类型与预取分类”。 |
| <!-- SRC-LINE:0835 -->L0835 | <code>assign ld_ag_vmb_merge_vld = 1&#x27;b0;</code> | 连续组合赋值开始：驱动 `ld_ag_vmb_merge_vld`；完整右值可能延续到后续行，属于“指令类型与预取分类”。 |

## 访问大小、对齐与 16-byte 边界

| 行号 | 原始代码 | 中文注释 |
|---:|---|---|
| <!-- SRC-LINE:0836 -->L0836 | <code>//==========================================================</code> | “访问大小、对齐与 16-byte 边界”的视觉分隔注释，不参与逻辑。 |
| <!-- SRC-LINE:0837 -->L0837 | <code>//            Generate unalign, bytes_vld</code> | 原作者注释，说明“Generate unalign, bytes_vld”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:0838 -->L0838 | <code>//==========================================================</code> | “访问大小、对齐与 16-byte 边界”的视觉分隔注释，不参与逻辑。 |
| <!-- SRC-LINE:0839 -->L0839 | <code>//---------------inst access size---------------</code> | 原作者注释，说明“---------------inst access size---------------”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:0840 -->L0840 | <code>// access size is used to select bytes_vld and boundary judge</code> | 原作者注释，说明“access size is used to select bytes_vld and boundary judge”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:0841 -->L0841 | <code>// &amp;CombBeg; @371</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:0842 -->L0842 | <code>always @( ld_ag_inst_size[1:0])</code> | 把 2-bit 指令大小译码为 size-minus-one 掩码 0/1/3/7。 |
| <!-- SRC-LINE:0843 -->L0843 | <code>begin</code> | 开始上一条 always/if/case 语句的复合语句块。 |
| <!-- SRC-LINE:0844 -->L0844 | <code>case(ld_ag_inst_size[1:0])</code> | 开始 case 译码，根据括号内编码选择唯一分支。 |
| <!-- SRC-LINE:0845 -->L0845 | <code>  BYTE: ld_ag_access_size_ori[3:0] = 4&#x27;b0000;</code> | case 译码分支：为当前输入组合设置确定的组合输出。 |
| <!-- SRC-LINE:0846 -->L0846 | <code>  HALF: ld_ag_access_size_ori[3:0] = 4&#x27;b0001;</code> | case 译码分支：为当前输入组合设置确定的组合输出。 |
| <!-- SRC-LINE:0847 -->L0847 | <code>  WORD: ld_ag_access_size_ori[3:0] = 4&#x27;b0011;</code> | case 译码分支：为当前输入组合设置确定的组合输出。 |
| <!-- SRC-LINE:0848 -->L0848 | <code>  DWORD:ld_ag_access_size_ori[3:0] = 4&#x27;b0111;</code> | case 译码分支：为当前输入组合设置确定的组合输出。 |
| <!-- SRC-LINE:0849 -->L0849 | <code>  default:ld_ag_access_size_ori[3:0] = 4&#x27;b0;</code> | case 译码分支：为当前输入组合设置确定的组合输出。 |
| <!-- SRC-LINE:0850 -->L0850 | <code>endcase</code> | 结束当前 case/casez 译码。 |
| <!-- SRC-LINE:0851 -->L0851 | <code>// &amp;CombEnd; @379</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:0852 -->L0852 | <code>end</code> | 结束当前复合语句块。 |
| <!-- SRC-LINE:0853 -->L0853 | <code>assign ld_ag_access_size[3:0] = ld_ag_access_size_ori[3:0]; </code> | 连续组合赋值开始：驱动 `ld_ag_access_size[3:0]`；完整右值可能延续到后续行，属于“访问大小、对齐与 16-byte 边界”。 |
| <!-- SRC-LINE:0854 -->L0854 | &nbsp; | 空行，用于分隔“访问大小、对齐与 16-byte 边界”中的逻辑块，提高源码可读性。 |
| <!-- SRC-LINE:0855 -->L0855 | <code>// access_size pipedown to dc, used for biu req_size(strong order)</code> | 原作者注释，说明“access_size pipedown to dc, used for biu req_size(strong order)”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:0856 -->L0856 | <code>// &amp;CombBeg; @388</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:0857 -->L0857 | <code>always @( ld_ag_access_size[3:0])</code> | 开始组合 always 块；敏感表列出决定本块输出的输入信号。 |
| <!-- SRC-LINE:0858 -->L0858 | <code>begin</code> | 开始上一条 always/if/case 语句的复合语句块。 |
| <!-- SRC-LINE:0859 -->L0859 | <code>case(ld_ag_access_size[3:0])</code> | 开始 case 译码，根据括号内编码选择唯一分支。 |
| <!-- SRC-LINE:0860 -->L0860 | <code>  4&#x27;b0000: ld_ag_dc_access_size[2:0] = 3&#x27;b000;  //byte</code> | case 译码分支：为当前输入组合设置确定的组合输出。 |
| <!-- SRC-LINE:0861 -->L0861 | <code>  4&#x27;b0001: ld_ag_dc_access_size[2:0] = 3&#x27;b001;  //half</code> | case 译码分支：为当前输入组合设置确定的组合输出。 |
| <!-- SRC-LINE:0862 -->L0862 | <code>  4&#x27;b0011: ld_ag_dc_access_size[2:0] = 3&#x27;b010;  //word</code> | case 译码分支：为当前输入组合设置确定的组合输出。 |
| <!-- SRC-LINE:0863 -->L0863 | <code>  4&#x27;b0111: ld_ag_dc_access_size[2:0] = 3&#x27;b011;  //dword</code> | case 译码分支：为当前输入组合设置确定的组合输出。 |
| <!-- SRC-LINE:0864 -->L0864 | <code>  4&#x27;b1111: ld_ag_dc_access_size[2:0] = 3&#x27;b100;  //qword</code> | case 译码分支：为当前输入组合设置确定的组合输出。 |
| <!-- SRC-LINE:0865 -->L0865 | <code>  default: ld_ag_dc_access_size[2:0] = 3&#x27;b0;</code> | case 译码分支：为当前输入组合设置确定的组合输出。 |
| <!-- SRC-LINE:0866 -->L0866 | <code>endcase</code> | 结束当前 case/casez 译码。 |
| <!-- SRC-LINE:0867 -->L0867 | <code>// &amp;CombEnd; @397</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:0868 -->L0868 | <code>end</code> | 结束当前复合语句块。 |
| <!-- SRC-LINE:0869 -->L0869 | <code>//----------------generate unalign--------------------------</code> | 原作者注释，说明“----------------generate unalign--------------------------”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:0870 -->L0870 | <code>//-----------unalign--------------------</code> | 原作者注释，说明“-----------unalign--------------------”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:0871 -->L0871 | <code>// &amp;CombBeg; @400</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:0872 -->L0872 | <code>always @( ld_ag_inst_size[1:0]</code> | 根据 size 和 VA 低 3 位判断自然对齐。 |
| <!-- SRC-LINE:0873 -->L0873 | <code>       or ld_ag_va_ori[2:0])</code> | “访问大小、对齐与 16-byte 边界”中的 RTL 语句片段；与相邻行共同构成完整声明、条件或表达式。 |
| <!-- SRC-LINE:0874 -->L0874 | <code>begin</code> | 开始上一条 always/if/case 语句的复合语句块。 |
| <!-- SRC-LINE:0875 -->L0875 | <code>casez({ld_ag_inst_size[1:0],ld_ag_va_ori[2:0]})</code> | 开始带通配位的 casez 译码；`?` 位不参与匹配。 |
| <!-- SRC-LINE:0876 -->L0876 | <code>  {BYTE,3&#x27;b???}:ld_ag_align = 1&#x27;b1;</code> | case 译码分支：为当前输入组合设置确定的组合输出。 |
| <!-- SRC-LINE:0877 -->L0877 | <code>  {HALF,3&#x27;b??0}:ld_ag_align = 1&#x27;b1;</code> | case 译码分支：为当前输入组合设置确定的组合输出。 |
| <!-- SRC-LINE:0878 -->L0878 | <code>  {WORD,3&#x27;b?00}:ld_ag_align = 1&#x27;b1;</code> | case 译码分支：为当前输入组合设置确定的组合输出。 |
| <!-- SRC-LINE:0879 -->L0879 | <code>  {DWORD,3&#x27;b000}:ld_ag_align = 1&#x27;b1;//NOTE:in risc-v isa, double inst misalign is set</code> | case 译码分支：为当前输入组合设置确定的组合输出。 |
| <!-- SRC-LINE:0880 -->L0880 | <code>                                    //     when double not align,</code> | 原作者注释，说明“when double not align,”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:0881 -->L0881 | <code>                                    //     but in csky, double misalign is set</code> | 原作者注释，说明“but in csky, double misalign is set”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:0882 -->L0882 | <code>                                    //     when word not align</code> | 原作者注释，说明“when word not align”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:0883 -->L0883 | <code>  default:ld_ag_align  = 1&#x27;b0;</code> | case 译码分支：为当前输入组合设置确定的组合输出。 |
| <!-- SRC-LINE:0884 -->L0884 | <code>endcase</code> | 结束当前 case/casez 译码。 |
| <!-- SRC-LINE:0885 -->L0885 | <code>// &amp;CombEnd; @411</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:0886 -->L0886 | <code>end</code> | 结束当前复合语句块。 |
| <!-- SRC-LINE:0887 -->L0887 | <code>assign ld_ag_unalign = !ld_ag_align;</code> | 连续组合赋值开始：驱动 `ld_ag_unalign`；完整右值可能延续到后续行，属于“访问大小、对齐与 16-byte 边界”。 |
| <!-- SRC-LINE:0888 -->L0888 | &nbsp; | 空行，用于分隔“访问大小、对齐与 16-byte 边界”中的逻辑块，提高源码可读性。 |
| <!-- SRC-LINE:0889 -->L0889 | <code>// for strong order,only support access size aligned address</code> | 原作者注释，说明“for strong order,only support access size aligned address”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:0890 -->L0890 | <code>//&amp;CombBeg;</code> | 原作者注释，说明“&CombBeg;”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:0891 -->L0891 | <code>//casez({ld_ag_access_size[3:0],ld_ag_va_ori[3:0]})</code> | 原作者注释，说明“casez({ld_ag_access_size[3:0],ld_ag_va_ori[3:0]})”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:0892 -->L0892 | <code>//  {4&#x27;b0000,4&#x27;b????}:ld_ag_align_so = 1&#x27;b1;       //byte</code> | 原作者注释，说明“{4'b0000,4'b????}:ld_ag_align_so = 1'b1;       //byte”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:0893 -->L0893 | <code>//  {4&#x27;b0001,4&#x27;b???0}:ld_ag_align_so = 1&#x27;b1;       //half</code> | 原作者注释，说明“{4'b0001,4'b???0}:ld_ag_align_so = 1'b1;       //half”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:0894 -->L0894 | <code>//  {4&#x27;b0011,4&#x27;b??00}:ld_ag_align_so = 1&#x27;b1;       //word</code> | 原作者注释，说明“{4'b0011,4'b??00}:ld_ag_align_so = 1'b1;       //word”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:0895 -->L0895 | <code>//  {4&#x27;b0111,4&#x27;b?000}:ld_ag_align_so = 1&#x27;b1;       //dword</code> | 原作者注释，说明“{4'b0111,4'b?000}:ld_ag_align_so = 1'b1;       //dword”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:0896 -->L0896 | <code>//  {4&#x27;b1111,4&#x27;b0000}:ld_ag_align_so = 1&#x27;b1;       //qword</code> | 原作者注释，说明“{4'b1111,4'b0000}:ld_ag_align_so = 1'b1;       //qword”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:0897 -->L0897 | <code>//  default:ld_ag_align_so  = 1&#x27;b0;</code> | 原作者注释，说明“default:ld_ag_align_so  = 1'b0;”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:0898 -->L0898 | <code>//endcase</code> | 原作者注释，说明“endcase”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:0899 -->L0899 | <code>//&amp;CombEnd;</code> | 原作者注释，说明“&CombEnd;”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:0900 -->L0900 | <code>assign ld_ag_unalign_so = !ld_ag_align;</code> | 连续组合赋值开始：驱动 `ld_ag_unalign_so`；完整右值可能延续到后续行，属于“访问大小、对齐与 16-byte 边界”。 |
| <!-- SRC-LINE:0901 -->L0901 | &nbsp; | 空行，用于分隔“访问大小、对齐与 16-byte 边界”中的逻辑块，提高源码可读性。 |
| <!-- SRC-LINE:0902 -->L0902 | <code>//---------------boundary---------------</code> | 原作者注释，说明“---------------boundary---------------”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:0903 -->L0903 | <code>assign ld_ag_va_add_access_size[4:0]  = {1&#x27;b0,ld_ag_va_ori[3:0]} + {1&#x27;b0,ld_ag_access_size[3:0]};</code> | VA 低 4 位加 size-minus-one；第 4 位进位表示跨 16-byte 边界。 |
| <!-- SRC-LINE:0904 -->L0904 | <code>assign ld_ag_boundary_unmask  = ld_ag_va_add_access_size[4];</code> | 连续组合赋值开始：驱动 `ld_ag_boundary_unmask`；完整右值可能延续到后续行，属于“访问大小、对齐与 16-byte 边界”。 |
| <!-- SRC-LINE:0905 -->L0905 | &nbsp; | 空行，用于分隔“访问大小、对齐与 16-byte 边界”中的逻辑块，提高源码可读性。 |
| <!-- SRC-LINE:0906 -->L0906 | <code>// &amp;Force(&quot;output&quot;, &quot;ld_ag_boundary&quot;); @431</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:0907 -->L0907 | <code>assign ld_ag_boundary = (ld_ag_boundary_unmask</code> | 边界输出仅对普通 load 有效；第二拍强制继续标记 boundary。 |
| <!-- SRC-LINE:0908 -->L0908 | <code>                            &#124;&#124;  ld_ag_secd)</code> | 注释中的 ASCII 框图行，用来列举流水寄存器字段，不参与逻辑。 |
| <!-- SRC-LINE:0909 -->L0909 | <code>                        &amp;&amp;  ld_ag_ld_inst;</code> | 延续“访问大小、对齐与 16-byte 边界”中的声明、实例连接或多行组合表达式；需与前后行合并阅读。 |
| <!-- SRC-LINE:0910 -->L0910 | &nbsp; | 空行，用于分隔“访问大小、对齐与 16-byte 边界”中的逻辑块，提高源码可读性。 |

## 字节有效掩码与旋转

| 行号 | 原始代码 | 中文注释 |
|---:|---|---|
| <!-- SRC-LINE:0911 -->L0911 | <code>//----------------generate bytes_vld------------------------</code> | 原作者注释，说明“----------------generate bytes_vld------------------------”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:0912 -->L0912 | <code>//-----------in le/bev2-----------------</code> | 原作者注释，说明“-----------in le/bev2-----------------”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:0913 -->L0913 | <code>//the 2nd half boundary inst will +128, so va[3:0] of 2nd inst will not change</code> | 原作者注释，说明“the 2nd half boundary inst will +128, so va[3:0] of 2nd inst will not change”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:0914 -->L0914 | <code>// &amp;CombBeg; @439</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:0915 -->L0915 | <code>always @( ld_ag_va_ori[3:0])</code> | 生成从起始 byte 到 16-byte 窗口末端的高侧全掩码。 |
| <!-- SRC-LINE:0916 -->L0916 | <code>begin</code> | 开始上一条 always/if/case 语句的复合语句块。 |
| <!-- SRC-LINE:0917 -->L0917 | <code>case(ld_ag_va_ori[3:0])</code> | 开始 case 译码，根据括号内编码选择唯一分支。 |
| <!-- SRC-LINE:0918 -->L0918 | <code>  4&#x27;b0000:ld_ag_le_bytes_vld_high_bits_full[15:0] = 16&#x27;hffff;</code> | case 译码分支：为当前输入组合设置确定的组合输出。 |
| <!-- SRC-LINE:0919 -->L0919 | <code>  4&#x27;b0001:ld_ag_le_bytes_vld_high_bits_full[15:0] = 16&#x27;hfffe;</code> | case 译码分支：为当前输入组合设置确定的组合输出。 |
| <!-- SRC-LINE:0920 -->L0920 | <code>  4&#x27;b0010:ld_ag_le_bytes_vld_high_bits_full[15:0] = 16&#x27;hfffc;</code> | case 译码分支：为当前输入组合设置确定的组合输出。 |
| <!-- SRC-LINE:0921 -->L0921 | <code>  4&#x27;b0011:ld_ag_le_bytes_vld_high_bits_full[15:0] = 16&#x27;hfff8;</code> | case 译码分支：为当前输入组合设置确定的组合输出。 |
| <!-- SRC-LINE:0922 -->L0922 | <code>  4&#x27;b0100:ld_ag_le_bytes_vld_high_bits_full[15:0] = 16&#x27;hfff0;</code> | case 译码分支：为当前输入组合设置确定的组合输出。 |
| <!-- SRC-LINE:0923 -->L0923 | <code>  4&#x27;b0101:ld_ag_le_bytes_vld_high_bits_full[15:0] = 16&#x27;hffe0;</code> | case 译码分支：为当前输入组合设置确定的组合输出。 |
| <!-- SRC-LINE:0924 -->L0924 | <code>  4&#x27;b0110:ld_ag_le_bytes_vld_high_bits_full[15:0] = 16&#x27;hffc0;</code> | case 译码分支：为当前输入组合设置确定的组合输出。 |
| <!-- SRC-LINE:0925 -->L0925 | <code>  4&#x27;b0111:ld_ag_le_bytes_vld_high_bits_full[15:0] = 16&#x27;hff80;</code> | case 译码分支：为当前输入组合设置确定的组合输出。 |
| <!-- SRC-LINE:0926 -->L0926 | <code>  4&#x27;b1000:ld_ag_le_bytes_vld_high_bits_full[15:0] = 16&#x27;hff00;</code> | case 译码分支：为当前输入组合设置确定的组合输出。 |
| <!-- SRC-LINE:0927 -->L0927 | <code>  4&#x27;b1001:ld_ag_le_bytes_vld_high_bits_full[15:0] = 16&#x27;hfe00;</code> | case 译码分支：为当前输入组合设置确定的组合输出。 |
| <!-- SRC-LINE:0928 -->L0928 | <code>  4&#x27;b1010:ld_ag_le_bytes_vld_high_bits_full[15:0] = 16&#x27;hfc00;</code> | case 译码分支：为当前输入组合设置确定的组合输出。 |
| <!-- SRC-LINE:0929 -->L0929 | <code>  4&#x27;b1011:ld_ag_le_bytes_vld_high_bits_full[15:0] = 16&#x27;hf800;</code> | case 译码分支：为当前输入组合设置确定的组合输出。 |
| <!-- SRC-LINE:0930 -->L0930 | <code>  4&#x27;b1100:ld_ag_le_bytes_vld_high_bits_full[15:0] = 16&#x27;hf000;</code> | case 译码分支：为当前输入组合设置确定的组合输出。 |
| <!-- SRC-LINE:0931 -->L0931 | <code>  4&#x27;b1101:ld_ag_le_bytes_vld_high_bits_full[15:0] = 16&#x27;he000;</code> | case 译码分支：为当前输入组合设置确定的组合输出。 |
| <!-- SRC-LINE:0932 -->L0932 | <code>  4&#x27;b1110:ld_ag_le_bytes_vld_high_bits_full[15:0] = 16&#x27;hc000;</code> | case 译码分支：为当前输入组合设置确定的组合输出。 |
| <!-- SRC-LINE:0933 -->L0933 | <code>  4&#x27;b1111:ld_ag_le_bytes_vld_high_bits_full[15:0] = 16&#x27;h8000;</code> | case 译码分支：为当前输入组合设置确定的组合输出。 |
| <!-- SRC-LINE:0934 -->L0934 | <code>  default:ld_ag_le_bytes_vld_high_bits_full[15:0] = {16{1&#x27;bx}};</code> | case 译码分支：为当前输入组合设置确定的组合输出。 |
| <!-- SRC-LINE:0935 -->L0935 | <code>endcase</code> | 结束当前 case/casez 译码。 |
| <!-- SRC-LINE:0936 -->L0936 | <code>// &amp;CombEnd; @459</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:0937 -->L0937 | <code>end</code> | 结束当前复合语句块。 |
| <!-- SRC-LINE:0938 -->L0938 | &nbsp; | 空行，用于分隔“字节有效掩码与旋转”中的逻辑块，提高源码可读性。 |
| <!-- SRC-LINE:0939 -->L0939 | <code>// &amp;CombBeg; @461</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:0940 -->L0940 | <code>always @( ld_ag_va_add_access_size[3:0])</code> | 生成从窗口起点到访问结束 byte 的低侧全掩码。 |
| <!-- SRC-LINE:0941 -->L0941 | <code>begin</code> | 开始上一条 always/if/case 语句的复合语句块。 |
| <!-- SRC-LINE:0942 -->L0942 | <code>case(ld_ag_va_add_access_size[3:0])</code> | 开始 case 译码，根据括号内编码选择唯一分支。 |
| <!-- SRC-LINE:0943 -->L0943 | <code>  4&#x27;b0000:ld_ag_le_bytes_vld_low_bits_full[15:0] = 16&#x27;h0001;</code> | case 译码分支：为当前输入组合设置确定的组合输出。 |
| <!-- SRC-LINE:0944 -->L0944 | <code>  4&#x27;b0001:ld_ag_le_bytes_vld_low_bits_full[15:0] = 16&#x27;h0003;</code> | case 译码分支：为当前输入组合设置确定的组合输出。 |
| <!-- SRC-LINE:0945 -->L0945 | <code>  4&#x27;b0010:ld_ag_le_bytes_vld_low_bits_full[15:0] = 16&#x27;h0007;</code> | case 译码分支：为当前输入组合设置确定的组合输出。 |
| <!-- SRC-LINE:0946 -->L0946 | <code>  4&#x27;b0011:ld_ag_le_bytes_vld_low_bits_full[15:0] = 16&#x27;h000f;</code> | case 译码分支：为当前输入组合设置确定的组合输出。 |
| <!-- SRC-LINE:0947 -->L0947 | <code>  4&#x27;b0100:ld_ag_le_bytes_vld_low_bits_full[15:0] = 16&#x27;h001f;</code> | case 译码分支：为当前输入组合设置确定的组合输出。 |
| <!-- SRC-LINE:0948 -->L0948 | <code>  4&#x27;b0101:ld_ag_le_bytes_vld_low_bits_full[15:0] = 16&#x27;h003f;</code> | case 译码分支：为当前输入组合设置确定的组合输出。 |
| <!-- SRC-LINE:0949 -->L0949 | <code>  4&#x27;b0110:ld_ag_le_bytes_vld_low_bits_full[15:0] = 16&#x27;h007f;</code> | case 译码分支：为当前输入组合设置确定的组合输出。 |
| <!-- SRC-LINE:0950 -->L0950 | <code>  4&#x27;b0111:ld_ag_le_bytes_vld_low_bits_full[15:0] = 16&#x27;h00ff;</code> | case 译码分支：为当前输入组合设置确定的组合输出。 |
| <!-- SRC-LINE:0951 -->L0951 | <code>  4&#x27;b1000:ld_ag_le_bytes_vld_low_bits_full[15:0] = 16&#x27;h01ff;</code> | case 译码分支：为当前输入组合设置确定的组合输出。 |
| <!-- SRC-LINE:0952 -->L0952 | <code>  4&#x27;b1001:ld_ag_le_bytes_vld_low_bits_full[15:0] = 16&#x27;h03ff;</code> | case 译码分支：为当前输入组合设置确定的组合输出。 |
| <!-- SRC-LINE:0953 -->L0953 | <code>  4&#x27;b1010:ld_ag_le_bytes_vld_low_bits_full[15:0] = 16&#x27;h07ff;</code> | case 译码分支：为当前输入组合设置确定的组合输出。 |
| <!-- SRC-LINE:0954 -->L0954 | <code>  4&#x27;b1011:ld_ag_le_bytes_vld_low_bits_full[15:0] = 16&#x27;h0fff;</code> | case 译码分支：为当前输入组合设置确定的组合输出。 |
| <!-- SRC-LINE:0955 -->L0955 | <code>  4&#x27;b1100:ld_ag_le_bytes_vld_low_bits_full[15:0] = 16&#x27;h1fff;</code> | case 译码分支：为当前输入组合设置确定的组合输出。 |
| <!-- SRC-LINE:0956 -->L0956 | <code>  4&#x27;b1101:ld_ag_le_bytes_vld_low_bits_full[15:0] = 16&#x27;h3fff;</code> | case 译码分支：为当前输入组合设置确定的组合输出。 |
| <!-- SRC-LINE:0957 -->L0957 | <code>  4&#x27;b1110:ld_ag_le_bytes_vld_low_bits_full[15:0] = 16&#x27;h7fff;</code> | case 译码分支：为当前输入组合设置确定的组合输出。 |
| <!-- SRC-LINE:0958 -->L0958 | <code>  4&#x27;b1111:ld_ag_le_bytes_vld_low_bits_full[15:0] = 16&#x27;hffff;</code> | case 译码分支：为当前输入组合设置确定的组合输出。 |
| <!-- SRC-LINE:0959 -->L0959 | <code>  default:ld_ag_le_bytes_vld_low_bits_full[15:0] = {16{1&#x27;bx}};</code> | case 译码分支：为当前输入组合设置确定的组合输出。 |
| <!-- SRC-LINE:0960 -->L0960 | <code>endcase</code> | 结束当前 case/casez 译码。 |
| <!-- SRC-LINE:0961 -->L0961 | <code>// &amp;CombEnd; @481</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:0962 -->L0962 | <code>end</code> | 结束当前复合语句块。 |
| <!-- SRC-LINE:0963 -->L0963 | &nbsp; | 空行，用于分隔“字节有效掩码与旋转”中的逻辑块，提高源码可读性。 |
| <!-- SRC-LINE:0964 -->L0964 | <code>assign ld_ag_le_bytes_vld_cross[15:0]       = ld_ag_le_bytes_vld_high_bits_full[15:0]</code> | 非跨界访问的精确 byte mask 等于高侧掩码与低侧掩码的交集。 |
| <!-- SRC-LINE:0965 -->L0965 | <code>                                                &amp; ld_ag_le_bytes_vld_low_bits_full[15:0];</code> | 延续“字节有效掩码与旋转”中的声明、实例连接或多行组合表达式；需与前后行合并阅读。 |
| <!-- SRC-LINE:0966 -->L0966 | &nbsp; | 空行，用于分隔“字节有效掩码与旋转”中的逻辑块，提高源码可读性。 |
| <!-- SRC-LINE:0967 -->L0967 | <code>assign ld_ag_le_bytes_vld_low_cross_bits[15:0]  = ld_ag_boundary_unmask</code> | 连续组合赋值开始：驱动 `ld_ag_le_bytes_vld_low_cross_bits[15:0]`；完整右值可能延续到后续行，属于“字节有效掩码与旋转”。 |
| <!-- SRC-LINE:0968 -->L0968 | <code>                                                  ? ld_ag_le_bytes_vld_low_bits_full[15:0]</code> | 延续“字节有效掩码与旋转”中的声明、实例连接或多行组合表达式；需与前后行合并阅读。 |
| <!-- SRC-LINE:0969 -->L0969 | <code>                                                  : ld_ag_le_bytes_vld_cross[15:0]; </code> | 延续“字节有效掩码与旋转”中的声明、实例连接或多行组合表达式；需与前后行合并阅读。 |
| <!-- SRC-LINE:0970 -->L0970 | &nbsp; | 空行，用于分隔“字节有效掩码与旋转”中的逻辑块，提高源码可读性。 |
| <!-- SRC-LINE:0971 -->L0971 | <code>assign ld_ag_le_bytes_vld_high_bits[15:0]   = ld_ag_le_bytes_vld_high_bits_full[15:0];</code> | 连续组合赋值开始：驱动 `ld_ag_le_bytes_vld_high_bits[15:0]`；完整右值可能延续到后续行，属于“字节有效掩码与旋转”。 |
| <!-- SRC-LINE:0972 -->L0972 | <code>//-----------select bytes_vld-----------</code> | 原作者注释，说明“-----------select bytes_vld-----------”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:0973 -->L0973 | <code>assign ld_ag_bytes_vld_low_cross_bits[15:0] = ld_ag_le_bytes_vld_low_cross_bits[15:0];</code> | 连续组合赋值开始：驱动 `ld_ag_bytes_vld_low_cross_bits[15:0]`；完整右值可能延续到后续行，属于“字节有效掩码与旋转”。 |
| <!-- SRC-LINE:0974 -->L0974 | &nbsp; | 空行，用于分隔“字节有效掩码与旋转”中的逻辑块，提高源码可读性。 |
| <!-- SRC-LINE:0975 -->L0975 | <code>assign ld_ag_bytes_vld_high_bits[15:0]  = ld_ag_le_bytes_vld_high_bits[15:0];</code> | 连续组合赋值开始：驱动 `ld_ag_bytes_vld_high_bits[15:0]`；完整右值可能延续到后续行，属于“字节有效掩码与旋转”。 |
| <!-- SRC-LINE:0976 -->L0976 | &nbsp; | 空行，用于分隔“字节有效掩码与旋转”中的逻辑块，提高源码可读性。 |
| <!-- SRC-LINE:0977 -->L0977 | <code>//used for </code> | 原作者注释，说明“used for”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:0978 -->L0978 | <code>//1.lq create</code> | 原作者注释，说明“1.lq create”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:0979 -->L0979 | <code>//2.da data_merge when acclr_en</code> | 原作者注释，说明“2.da data_merge when acclr_en”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:0980 -->L0980 | <code>//bytes_vld1 is the bytes_vld of lower addr when there is a first(bigger) boundary ld inst</code> | 原作者注释，说明“bytes_vld1 is the bytes_vld of lower addr when there is a first(bigger) boundary ld inst”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:0981 -->L0981 | <code>assign ld_ag_bytes_vld1[15:0] =  ld_ag_bytes_vld_high_bits[15:0];</code> | 连续组合赋值开始：驱动 `ld_ag_bytes_vld1[15:0]`；完整右值可能延续到后续行，属于“字节有效掩码与旋转”。 |
| <!-- SRC-LINE:0982 -->L0982 | &nbsp; | 空行，用于分隔“字节有效掩码与旋转”中的逻辑块，提高源码可读性。 |
| <!-- SRC-LINE:0983 -->L0983 | <code>assign ld_ag_bytes_vld[15:0]  =  ld_ag_secd</code> | 第二拍选择高地址侧掩码，首拍/普通拍选择低侧或交集掩码。 |
| <!-- SRC-LINE:0984 -->L0984 | <code>                                 ? ld_ag_bytes_vld_high_bits[15:0]</code> | 延续“字节有效掩码与旋转”中的声明、实例连接或多行组合表达式；需与前后行合并阅读。 |
| <!-- SRC-LINE:0985 -->L0985 | <code>                                 : ld_ag_bytes_vld_low_cross_bits[15:0];</code> | 延续“字节有效掩码与旋转”中的声明、实例连接或多行组合表达式；需与前后行合并阅读。 |
| <!-- SRC-LINE:0986 -->L0986 | <code>//==========================================================</code> | “字节有效掩码与旋转”的视觉分隔注释，不参与逻辑。 |
| <!-- SRC-LINE:0987 -->L0987 | <code>//        vector mask</code> | 原作者注释，说明“vector mask”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:0988 -->L0988 | <code>//==========================================================</code> | “字节有效掩码与旋转”的视觉分隔注释，不参与逻辑。 |
| <!-- SRC-LINE:0989 -->L0989 | <code>// &amp;CombBeg; @513</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:0990 -->L0990 | <code>// &amp;CombEnd; @521</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:0991 -->L0991 | <code>// &amp;Force(&quot;output&quot;,&quot;ld_ag_element_cnt&quot;); @523</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:0992 -->L0992 | <code>// &amp;CombBeg; @530</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:0993 -->L0993 | <code>// &amp;CombEnd; @542</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:0994 -->L0994 | <code>// &amp;CombBeg; @547</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:0995 -->L0995 | <code>// &amp;CombEnd; @555</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:0996 -->L0996 | <code>// &amp;CombBeg; @640</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:0997 -->L0997 | <code>// &amp;CombEnd; @651</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:0998 -->L0998 | <code>// &amp;CombBeg; @655</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:0999 -->L0999 | <code>// &amp;CombEnd; @675</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:1000 -->L1000 | <code>// &amp;CombBeg; @684</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:1001 -->L1001 | <code>// &amp;CombEnd; @704</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:1002 -->L1002 | <code>// &amp;CombBeg; @721</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:1003 -->L1003 | <code>// &amp;CombEnd; @741</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:1004 -->L1004 | <code>// &amp;CombBeg; @743</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:1005 -->L1005 | <code>// &amp;CombEnd; @763</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:1006 -->L1006 | <code>// &amp;CombBeg; @765</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:1007 -->L1007 | <code>// &amp;CombEnd; @771</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:1008 -->L1008 | <code>// &amp;CombBeg; @773</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:1009 -->L1009 | <code>// &amp;CombEnd; @779</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:1010 -->L1010 | <code>// &amp;CombBeg; @786</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:1011 -->L1011 | <code>// &amp;CombEnd; @805</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:1012 -->L1012 | <code>// &amp;CombBeg; @808</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:1013 -->L1013 | <code>// &amp;CombEnd; @828</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:1014 -->L1014 | <code>// &amp;CombBeg; @844</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:1015 -->L1015 | <code>// &amp;CombEnd; @852</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:1016 -->L1016 | <code>// &amp;CombBeg; @854</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:1017 -->L1017 | <code>// &amp;CombEnd; @866</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:1018 -->L1018 | <code>// &amp;CombBeg; @874</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:1019 -->L1019 | <code>// &amp;CombEnd; @893</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:1020 -->L1020 | <code>// &amp;CombBeg; @898</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:1021 -->L1021 | <code>// &amp;CombEnd; @906</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:1022 -->L1022 | <code>// &amp;CombBeg; @913</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:1023 -->L1023 | <code>// &amp;CombEnd; @920</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:1024 -->L1024 | <code>// &amp;CombBeg; @927</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:1025 -->L1025 | <code>// &amp;CombEnd; @935</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:1026 -->L1026 | <code>// &amp;Force(&quot;output&quot;,&quot;ld_ag_vsew&quot;); @938</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:1027 -->L1027 | <code>// &amp;Force(&quot;output&quot;,&quot;ld_ag_inst_vls&quot;); @939</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:1028 -->L1028 | <code>assign ld_ag_dc_bytes_vld[15:0]  = ld_ag_bytes_vld[15:0];</code> | 连续组合赋值开始：驱动 `ld_ag_dc_bytes_vld[15:0]`；完整右值可能延续到后续行，属于“字节有效掩码与旋转”。 |
| <!-- SRC-LINE:1029 -->L1029 | <code>assign ld_ag_dc_bytes_vld1[15:0] = ld_ag_bytes_vld1[15:0];</code> | 连续组合赋值开始：驱动 `ld_ag_dc_bytes_vld1[15:0]`；完整右值可能延续到后续行，属于“字节有效掩码与旋转”。 |
| <!-- SRC-LINE:1030 -->L1030 | <code>assign ld_ag_dc_rot_sel[3:0]     = ld_ag_va_ori[3:0];</code> | 连续组合赋值开始：驱动 `ld_ag_dc_rot_sel[3:0]`；完整右值可能延续到后续行，属于“字节有效掩码与旋转”。 |

## MMU 接口

| 行号 | 原始代码 | 中文注释 |
|---:|---|---|
| <!-- SRC-LINE:1031 -->L1031 | <code>//==========================================================</code> | “MMU 接口”的视觉分隔注释，不参与逻辑。 |
| <!-- SRC-LINE:1032 -->L1032 | <code>//        MMU interface</code> | 原作者注释，说明“MMU interface”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:1033 -->L1033 | <code>//==========================================================</code> | “MMU 接口”的视觉分隔注释，不参与逻辑。 |
| <!-- SRC-LINE:1034 -->L1034 | <code>//-----------mmu input--------------------------------------</code> | 原作者注释，说明“-----------mmu input--------------------------------------”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:1035 -->L1035 | <code>assign lsu_mmu_va0_vld              = ld_ag_inst_vld;</code> | MMU 请求有效等于 AG valid。 |
| <!-- SRC-LINE:1036 -->L1036 | <code>assign lsu_mmu_va0[63:0]            = ld_ag_base[63:0];</code> | MMU 请求的是 base 地址而不是最终 VA；跨页由重放机制处理。 |
| <!-- SRC-LINE:1037 -->L1037 | <code>// &amp;Force(&quot;output&quot;,&quot;lsu_mmu_abort0&quot;); @960</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:1038 -->L1038 | <code>assign lsu_mmu_abort0               = ld_ag_cross_page_ldr_imme_stall_req</code> | 组合生成 MMU abort：跨页重放、atomic 等提交、DCACHE stall、misalign 或 flush。 |
| <!-- SRC-LINE:1039 -->L1039 | <code>                                      &#124;&#124;  ld_ag_atomic_no_cmit_restart_req</code> | 注释中的 ASCII 框图行，用来列举流水寄存器字段，不参与逻辑。 |
| <!-- SRC-LINE:1040 -->L1040 | <code>                                      &#124;&#124;  ld_ag_dcache_stall_req</code> | 注释中的 ASCII 框图行，用来列举流水寄存器字段，不参与逻辑。 |
| <!-- SRC-LINE:1041 -->L1041 | <code>                                      &#124;&#124;  ld_ag_expt_misalign_no_page</code> | 注释中的 ASCII 框图行，用来列举流水寄存器字段，不参与逻辑。 |
| <!-- SRC-LINE:1042 -->L1042 | <code>                                      &#124;&#124;  rtu_yy_xx_flush;</code> | 注释中的 ASCII 框图行，用来列举流水寄存器字段，不参与逻辑。 |
| <!-- SRC-LINE:1043 -->L1043 | <code>assign lsu_mmu_id0[6:0]             = ld_ag_iid[6:0];</code> | 连续组合赋值开始：驱动 `lsu_mmu_id0[6:0]`；完整右值可能延续到后续行，属于“MMU 接口”。 |
| <!-- SRC-LINE:1044 -->L1044 | <code>assign lsu_mmu_st_inst0             = ld_ag_ldamo_inst;</code> | 连续组合赋值开始：驱动 `lsu_mmu_st_inst0`；完整右值可能延续到后续行，属于“MMU 接口”。 |
| <!-- SRC-LINE:1045 -->L1045 | &nbsp; | 空行，用于分隔“MMU 接口”中的逻辑块，提高源码可读性。 |
| <!-- SRC-LINE:1046 -->L1046 | <code>//-----------mmu output-------------------------------------</code> | 原作者注释，说明“-----------mmu output-------------------------------------”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:1047 -->L1047 | <code>assign ld_ag_pn[`PA_WIDTH-13:0]     = mmu_lsu_pa0[`PA_WIDTH-13:0];</code> | 连续组合赋值开始：驱动 `ld_ag_pn[`PA_WIDTH-13:0]`；完整右值可能延续到后续行，属于“MMU 接口”。 |
| <!-- SRC-LINE:1048 -->L1048 | <code>// &amp;Force(&quot;output&quot;, &quot;ld_ag_page_so&quot;); @971</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:1049 -->L1049 | <code>assign ld_ag_page_so        = mmu_lsu_so0 &amp;&amp; mmu_lsu_pa0_vld;</code> | SO 属性只在 MMU PA valid 时对外有效。 |
| <!-- SRC-LINE:1050 -->L1050 | <code>// &amp;Force(&quot;output&quot;, &quot;ld_ag_page_ca&quot;); @973</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:1051 -->L1051 | <code>assign ld_ag_page_ca        = mmu_lsu_ca0 &amp;&amp; mmu_lsu_pa0_vld;</code> | cacheable 属性只在 MMU PA valid 时对外有效。 |
| <!-- SRC-LINE:1052 -->L1052 | <code>assign ld_ag_page_buf       = mmu_lsu_buf0;</code> | 连续组合赋值开始：驱动 `ld_ag_page_buf`；完整右值可能延续到后续行，属于“MMU 接口”。 |
| <!-- SRC-LINE:1053 -->L1053 | <code>assign ld_ag_page_sec       = mmu_lsu_sec0;</code> | 连续组合赋值开始：驱动 `ld_ag_page_sec`；完整右值可能延续到后续行，属于“MMU 接口”。 |
| <!-- SRC-LINE:1054 -->L1054 | <code>assign ld_ag_page_share     = mmu_lsu_sh0;</code> | 连续组合赋值开始：驱动 `ld_ag_page_share`；完整右值可能延续到后续行，属于“MMU 接口”。 |
| <!-- SRC-LINE:1055 -->L1055 | <code>// &amp;Force(&quot;output&quot;,&quot;ld_ag_utlb_miss&quot;); @978</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:1056 -->L1056 | <code>assign ld_ag_utlb_miss      = !mmu_lsu_pa0_vld;</code> | uTLB miss 直接定义为 PA 无效；空闲态也可能为 1，需与指令 valid 合用。 |
| <!-- SRC-LINE:1057 -->L1057 | &nbsp; | 空行，用于分隔“MMU 接口”中的逻辑块，提高源码可读性。 |
| <!-- SRC-LINE:1058 -->L1058 | <code>assign ld_ag_page_fault     = mmu_lsu_page_fault0;</code> | 连续组合赋值开始：驱动 `ld_ag_page_fault`；完整右值可能延续到后续行，属于“MMU 接口”。 |
| <!-- SRC-LINE:1059 -->L1059 | <code>//assign ld_ag_access_fault   = mmu_lsu_access_fault0;</code> | 原作者注释，说明“assign ld_ag_access_fault   = mmu_lsu_access_fault0;”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:1060 -->L1060 | &nbsp; | 空行，用于分隔“MMU 接口”中的逻辑块，提高源码可读性。 |

## 物理地址、边界加速与转发

| 行号 | 原始代码 | 中文注释 |
|---:|---|---|
| <!-- SRC-LINE:1061 -->L1061 | <code>//==========================================================</code> | “物理地址、边界加速与转发”的视觉分隔注释，不参与逻辑。 |
| <!-- SRC-LINE:1062 -->L1062 | <code>//        Generate physical address</code> | 原作者注释，说明“Generate physical address”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:1063 -->L1063 | <code>//==========================================================</code> | “物理地址、边界加速与转发”的视觉分隔注释，不参与逻辑。 |
| <!-- SRC-LINE:1064 -->L1064 | <code>// &amp;Force(&quot;output&quot;,&quot;ld_ag_pa&quot;); @987</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:1065 -->L1065 | <code>assign ld_ag_pa[`PA_WIDTH-1:0]     = {ld_ag_pn[`PA_WIDTH-13:0],ld_ag_va[11:0]};</code> | 物理地址由 MMU 返回 PPN 和最终 VA 的 12-bit 页内 offset 拼接。 |
| <!-- SRC-LINE:1066 -->L1066 | &nbsp; | 空行，用于分隔“物理地址、边界加速与转发”中的逻辑块，提高源码可读性。 |
| <!-- SRC-LINE:1067 -->L1067 | <code>//grs inst use va, rather than pa</code> | 原作者注释，说明“grs inst use va, rather than pa”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:1068 -->L1068 | <code>assign ld_ag_addr0[`PA_WIDTH-1:0]  = ld_ag_pa[`PA_WIDTH-1:0];</code> | 连续组合赋值开始：驱动 `ld_ag_addr0[`PA_WIDTH-1:0]`；完整右值可能延续到后续行，属于“物理地址、边界加速与转发”。 |
| <!-- SRC-LINE:1069 -->L1069 | &nbsp; | 空行，用于分隔“物理地址、边界加速与转发”中的逻辑块，提高源码可读性。 |
| <!-- SRC-LINE:1070 -->L1070 | <code>// used for boundary inst acceleration</code> | 原作者注释，说明“used for boundary inst acceleration”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:1071 -->L1071 | <code>assign ld_ag_addr1_to4[`PA_WIDTH-5:0] = ld_ag_va_ori[`PA_WIDTH-1:4];</code> | 连续组合赋值开始：驱动 `ld_ag_addr1_to4[`PA_WIDTH-5:0]`；完整右值可能延续到后续行，属于“物理地址、边界加速与转发”。 |
| <!-- SRC-LINE:1072 -->L1072 | <code>assign ld_ag_acclr_en         = ld_ag_boundary</code> | 形成边界加速预资格，不包含 MMU PA valid/cacheable；真实下传使能在后续补充。 |
| <!-- SRC-LINE:1073 -->L1073 | <code>                                &amp;&amp;  !ld_ag_4k_sum_ori[12]</code> | 延续“物理地址、边界加速与转发”中的声明、实例连接或多行组合表达式；需与前后行合并阅读。 |
| <!-- SRC-LINE:1074 -->L1074 | <code>                                &amp;&amp;  !cp0_lsu_cb_aclr_dis</code> | 延续“物理地址、边界加速与转发”中的声明、实例连接或多行组合表达式；需与前后行合并阅读。 |
| <!-- SRC-LINE:1075 -->L1075 | <code>                                &amp;&amp;  !ld_ag_secd</code> | 延续“物理地址、边界加速与转发”中的声明、实例连接或多行组合表达式；需与前后行合并阅读。 |
| <!-- SRC-LINE:1076 -->L1076 | <code>                                &amp;&amp;  !ld_ag_inst_fof</code> | 延续“物理地址、边界加速与转发”中的声明、实例连接或多行组合表达式；需与前后行合并阅读。 |
| <!-- SRC-LINE:1077 -->L1077 | <code>                                &amp;&amp;  cp0_lsu_dcache_en</code> | 延续“物理地址、边界加速与转发”中的声明、实例连接或多行组合表达式；需与前后行合并阅读。 |
| <!-- SRC-LINE:1078 -->L1078 | <code>                                &amp;&amp;  !ld_ag_already_cross_page_ldr_imme;</code> | 延续“物理地址、边界加速与转发”中的声明、实例连接或多行组合表达式；需与前后行合并阅读。 |
| <!-- SRC-LINE:1079 -->L1079 | &nbsp; | 空行，用于分隔“物理地址、边界加速与转发”中的逻辑块，提高源码可读性。 |
| <!-- SRC-LINE:1080 -->L1080 | <code>// &amp;Force(&quot;output&quot;,&quot;ld_ag_dc_acclr_en&quot;);  @1003</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:1081 -->L1081 | <code>assign ld_ag_dc_acclr_en     = ld_ag_acclr_en</code> | 真实 DC 边界加速使能还要求 PA valid 且页面 cacheable。 |
| <!-- SRC-LINE:1082 -->L1082 | <code>                               &amp;&amp; mmu_lsu_pa0_vld</code> | 延续“物理地址、边界加速与转发”中的声明、实例连接或多行组合表达式；需与前后行合并阅读。 |
| <!-- SRC-LINE:1083 -->L1083 | <code>                               &amp;&amp; ld_ag_page_ca;</code> | 延续“物理地址、边界加速与转发”中的声明、实例连接或多行组合表达式；需与前后行合并阅读。 |
| <!-- SRC-LINE:1084 -->L1084 | &nbsp; | 空行，用于分隔“物理地址、边界加速与转发”中的逻辑块，提高源码可读性。 |
| <!-- SRC-LINE:1085 -->L1085 | <code>//fwd bypass is bypass data from pipe5 EX1 stage when ld is at AG stage</code> | 原作者注释，说明“fwd bypass is bypass data from pipe5 EX1 stage when ld is at AG stage”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:1086 -->L1086 | <code>// used for ld fwd bypass what means</code> | 原作者注释，说明“used for ld fwd bypass what means”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:1087 -->L1087 | <code>//only support byte,half,word,double word</code> | 原作者注释，说明“only support byte,half,word,double word”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:1088 -->L1088 | <code>// &amp;CombBeg; @1011</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:1089 -->L1089 | <code>always @( ld_ag_access_size[3:0])</code> | 开始组合 always 块；敏感表列出决定本块输出的输入信号。 |
| <!-- SRC-LINE:1090 -->L1090 | <code>begin</code> | 开始上一条 always/if/case 语句的复合语句块。 |
| <!-- SRC-LINE:1091 -->L1091 | <code>case(ld_ag_access_size[3:0])</code> | 开始 case 译码，根据括号内编码选择唯一分支。 |
| <!-- SRC-LINE:1092 -->L1092 | <code>  4&#x27;b0000: ld_ag_bypass_en = 1&#x27;b1;  //byte</code> | case 译码分支：为当前输入组合设置确定的组合输出。 |
| <!-- SRC-LINE:1093 -->L1093 | <code>  4&#x27;b0001: ld_ag_bypass_en = 1&#x27;b1;  //half</code> | case 译码分支：为当前输入组合设置确定的组合输出。 |
| <!-- SRC-LINE:1094 -->L1094 | <code>  4&#x27;b0011: ld_ag_bypass_en = 1&#x27;b1;  //word</code> | case 译码分支：为当前输入组合设置确定的组合输出。 |
| <!-- SRC-LINE:1095 -->L1095 | <code>  4&#x27;b0111: ld_ag_bypass_en = 1&#x27;b1;  //dword</code> | case 译码分支：为当前输入组合设置确定的组合输出。 |
| <!-- SRC-LINE:1096 -->L1096 | <code>  4&#x27;b1111: ld_ag_bypass_en = 1&#x27;b1;  //qword</code> | case 译码分支：为当前输入组合设置确定的组合输出。 |
| <!-- SRC-LINE:1097 -->L1097 | <code>  default: ld_ag_bypass_en = 1&#x27;b0;</code> | case 译码分支：为当前输入组合设置确定的组合输出。 |
| <!-- SRC-LINE:1098 -->L1098 | <code>endcase</code> | 结束当前 case/casez 译码。 |
| <!-- SRC-LINE:1099 -->L1099 | <code>// &amp;CombEnd; @1020</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:1100 -->L1100 | <code>end</code> | 结束当前复合语句块。 |
| <!-- SRC-LINE:1101 -->L1101 | &nbsp; | 空行，用于分隔“物理地址、边界加速与转发”中的逻辑块，提高源码可读性。 |
| <!-- SRC-LINE:1102 -->L1102 | <code>assign ld_ag_dc_fwd_bypass_en = ld_ag_bypass_en</code> | forward bypass 只允许受支持大小、非 vector-memory、非 boundary 访问。 |
| <!-- SRC-LINE:1103 -->L1103 | <code>                                &amp;&amp; !ld_ag_inst_vls</code> | 延续“物理地址、边界加速与转发”中的声明、实例连接或多行组合表达式；需与前后行合并阅读。 |
| <!-- SRC-LINE:1104 -->L1104 | <code>                                &amp;&amp; !ld_ag_boundary;</code> | 延续“物理地址、边界加速与转发”中的声明、实例连接或多行组合表达式；需与前后行合并阅读。 |
| <!-- SRC-LINE:1105 -->L1105 | &nbsp; | 空行，用于分隔“物理地址、边界加速与转发”中的逻辑块，提高源码可读性。 |

## 提交匹配

| 行号 | 原始代码 | 中文注释 |
|---:|---|---|
| <!-- SRC-LINE:1106 -->L1106 | <code>//==========================================================</code> | “提交匹配”的视觉分隔注释，不参与逻辑。 |
| <!-- SRC-LINE:1107 -->L1107 | <code>//        Generage commit signal</code> | 原作者注释，说明“Generage commit signal”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:1108 -->L1108 | <code>//==========================================================</code> | “提交匹配”的视觉分隔注释，不参与逻辑。 |
| <!-- SRC-LINE:1109 -->L1109 | <code>assign ld_ag_cmit_hit0  = {rtu_yy_xx_commit0,rtu_yy_xx_commit0_iid[6:0]}</code> | 比较 RTU commit0 的 valid+iid 与当前 AG iid。 |
| <!-- SRC-LINE:1110 -->L1110 | <code>                          ==  {1&#x27;b1,ld_ag_iid[6:0]};</code> | 延续“提交匹配”中的声明、实例连接或多行组合表达式；需与前后行合并阅读。 |
| <!-- SRC-LINE:1111 -->L1111 | <code>assign ld_ag_cmit_hit1  = {rtu_yy_xx_commit1,rtu_yy_xx_commit1_iid[6:0]}</code> | 连续组合赋值开始：驱动 `ld_ag_cmit_hit1`；完整右值可能延续到后续行，属于“提交匹配”。 |
| <!-- SRC-LINE:1112 -->L1112 | <code>                          ==  {1&#x27;b1,ld_ag_iid[6:0]};</code> | 延续“提交匹配”中的声明、实例连接或多行组合表达式；需与前后行合并阅读。 |
| <!-- SRC-LINE:1113 -->L1113 | <code>assign ld_ag_cmit_hit2  = {rtu_yy_xx_commit2,rtu_yy_xx_commit2_iid[6:0]}</code> | 连续组合赋值开始：驱动 `ld_ag_cmit_hit2`；完整右值可能延续到后续行，属于“提交匹配”。 |
| <!-- SRC-LINE:1114 -->L1114 | <code>                          ==  {1&#x27;b1,ld_ag_iid[6:0]};</code> | 延续“提交匹配”中的声明、实例连接或多行组合表达式；需与前后行合并阅读。 |
| <!-- SRC-LINE:1115 -->L1115 | &nbsp; | 空行，用于分隔“提交匹配”中的逻辑块，提高源码可读性。 |
| <!-- SRC-LINE:1116 -->L1116 | <code>// //&amp;Force(&quot;output&quot;,&quot;ld_ag_cmit&quot;); @1036</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:1117 -->L1117 | <code>assign ld_ag_cmit       = ld_ag_cmit_hit0</code> | 连续组合赋值开始：驱动 `ld_ag_cmit`；完整右值可能延续到后续行，属于“提交匹配”。 |
| <!-- SRC-LINE:1118 -->L1118 | <code>                          &#124;&#124;  ld_ag_cmit_hit1</code> | 注释中的 ASCII 框图行，用来列举流水寄存器字段，不参与逻辑。 |
| <!-- SRC-LINE:1119 -->L1119 | <code>                          &#124;&#124;  ld_ag_cmit_hit2;</code> | 注释中的 ASCII 框图行，用来列举流水寄存器字段，不参与逻辑。 |
| <!-- SRC-LINE:1120 -->L1120 | &nbsp; | 空行，用于分隔“提交匹配”中的逻辑块，提高源码可读性。 |

## DCACHE tag/data 阵列请求

| 行号 | 原始代码 | 中文注释 |
|---:|---|---|
| <!-- SRC-LINE:1121 -->L1121 | <code>//==========================================================</code> | “DCACHE tag/data 阵列请求”的视觉分隔注释，不参与逻辑。 |
| <!-- SRC-LINE:1122 -->L1122 | <code>//        Generage dcache request information</code> | 原作者注释，说明“Generage dcache request information”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:1123 -->L1123 | <code>//==========================================================</code> | “DCACHE tag/data 阵列请求”的视觉分隔注释，不参与逻辑。 |
| <!-- SRC-LINE:1124 -->L1124 | <code>assign ag_dcache_arb_ld_gateclk_en  = ld_ag_inst_vld</code> | 连续组合赋值开始：驱动 `ag_dcache_arb_ld_gateclk_en`；完整右值可能延续到后续行，属于“DCACHE tag/data 阵列请求”。 |
| <!-- SRC-LINE:1125 -->L1125 | <code>                                      &amp;&amp;  cp0_lsu_dcache_en;</code> | 延续“DCACHE tag/data 阵列请求”中的声明、实例连接或多行组合表达式；需与前后行合并阅读。 |
| <!-- SRC-LINE:1126 -->L1126 | &nbsp; | 空行，用于分隔“DCACHE tag/data 阵列请求”中的逻辑块，提高源码可读性。 |
| <!-- SRC-LINE:1127 -->L1127 | <code>//for timing, delete mmu signal</code> | 原作者注释，说明“for timing, delete mmu signal”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:1128 -->L1128 | <code>assign ag_dcache_arb_ld_req = ld_ag_inst_vld</code> | DCACHE 阵列请求只由 AG valid 和 dcache enable 门控，属于投机读取。 |
| <!-- SRC-LINE:1129 -->L1129 | <code>                              &amp;&amp;  cp0_lsu_dcache_en;</code> | 延续“DCACHE tag/data 阵列请求”中的声明、实例连接或多行组合表达式；需与前后行合并阅读。 |
| <!-- SRC-LINE:1130 -->L1130 | <code>//                              &amp;&amp;  !ld_ag_expt_vld</code> | 原作者注释，说明“&&  !ld_ag_expt_vld”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:1131 -->L1131 | <code>//                              &amp;&amp;  !ld_ag_prior_stall_restart;</code> | 原作者注释，说明“&&  !ld_ag_prior_stall_restart;”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:1132 -->L1132 | <code>//                              &amp;&amp;  ld_ag_page_ca</code> | 原作者注释，说明“&&  ld_ag_page_ca”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:1133 -->L1133 | <code>//                              &amp;&amp;  mmu_lsu_pa0_vld;</code> | 原作者注释，说明“&&  mmu_lsu_pa0_vld;”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:1134 -->L1134 | &nbsp; | 空行，用于分隔“DCACHE tag/data 阵列请求”中的逻辑块，提高源码可读性。 |
| <!-- SRC-LINE:1135 -->L1135 | <code>//-----------tag array-------------------------------------</code> | 原作者注释，说明“-----------tag array-------------------------------------”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:1136 -->L1136 | <code>assign ag_dcache_arb_ld_tag_gateclk_en  = ag_dcache_arb_ld_gateclk_en;</code> | 连续组合赋值开始：驱动 `ag_dcache_arb_ld_tag_gateclk_en`；完整右值可能延续到后续行，属于“DCACHE tag/data 阵列请求”。 |
| <!-- SRC-LINE:1137 -->L1137 | <code>assign ag_dcache_arb_ld_tag_req         = ag_dcache_arb_ld_req;</code> | 连续组合赋值开始：驱动 `ag_dcache_arb_ld_tag_req`；完整右值可能延续到后续行，属于“DCACHE tag/data 阵列请求”。 |
| <!-- SRC-LINE:1138 -->L1138 | <code>assign ag_dcache_arb_ld_tag_idx[8:0]    = ld_ag_pa[14:6];</code> | tag index 使用 PA[14:6]。 |
| <!-- SRC-LINE:1139 -->L1139 | <code>//assign ag_dcache_arb_ld_tag_din[35:0] = 36&#x27;b0;</code> | 原作者注释，说明“assign ag_dcache_arb_ld_tag_din[35:0] = 36'b0;”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:1140 -->L1140 | <code>//assign ag_dcache_arb_ld_tag_wen[1:0]  = 2&#x27;b0;</code> | 原作者注释，说明“assign ag_dcache_arb_ld_tag_wen[1:0]  = 2'b0;”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:1141 -->L1141 | &nbsp; | 空行，用于分隔“DCACHE tag/data 阵列请求”中的逻辑块，提高源码可读性。 |
| <!-- SRC-LINE:1142 -->L1142 | <code>//-----------data array------------------------------------</code> | 原作者注释，说明“-----------data array------------------------------------”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:1143 -->L1143 | <code>//------------data req signal-----------</code> | 原作者注释，说明“------------data req signal-----------”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:1144 -->L1144 | <code>// &amp;CombBeg; @1064</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:1145 -->L1145 | <code>always @( ld_ag_va_add_access_size[3:2]</code> | 根据 boundary/secd 和 4-byte bank 起止位置生成低半区 bank enable。 |
| <!-- SRC-LINE:1146 -->L1146 | <code>       or ld_ag_va_ori[3:2]</code> | “DCACHE tag/data 阵列请求”中的 RTL 语句片段；与相邻行共同构成完整声明、条件或表达式。 |
| <!-- SRC-LINE:1147 -->L1147 | <code>       or ld_ag_boundary</code> | “DCACHE tag/data 阵列请求”中的 RTL 语句片段；与相邻行共同构成完整声明、条件或表达式。 |
| <!-- SRC-LINE:1148 -->L1148 | <code>       or ld_ag_secd)</code> | “DCACHE tag/data 阵列请求”中的 RTL 语句片段；与相邻行共同构成完整声明、条件或表达式。 |
| <!-- SRC-LINE:1149 -->L1149 | <code>begin</code> | 开始上一条 always/if/case 语句的复合语句块。 |
| <!-- SRC-LINE:1150 -->L1150 | <code>casez({ld_ag_boundary,ld_ag_secd,ld_ag_va_ori[3:2],ld_ag_va_add_access_size[3:2]})</code> | 开始带通配位的 casez 译码；`?` 位不参与匹配。 |
| <!-- SRC-LINE:1151 -->L1151 | <code>  {1&#x27;b0,1&#x27;b?,2&#x27;b00,2&#x27;b00}:bank_en_low_ori[3:0] = 4&#x27;b0001;</code> | case 译码分支：为当前输入组合设置确定的组合输出。 |
| <!-- SRC-LINE:1152 -->L1152 | <code>  {1&#x27;b0,1&#x27;b?,2&#x27;b00,2&#x27;b01}:bank_en_low_ori[3:0] = 4&#x27;b0011;</code> | case 译码分支：为当前输入组合设置确定的组合输出。 |
| <!-- SRC-LINE:1153 -->L1153 | <code>  {1&#x27;b0,1&#x27;b?,2&#x27;b00,2&#x27;b10}:bank_en_low_ori[3:0] = 4&#x27;b0111;</code> | case 译码分支：为当前输入组合设置确定的组合输出。 |
| <!-- SRC-LINE:1154 -->L1154 | <code>  {1&#x27;b0,1&#x27;b?,2&#x27;b00,2&#x27;b11}:bank_en_low_ori[3:0] = 4&#x27;b1111;</code> | case 译码分支：为当前输入组合设置确定的组合输出。 |
| <!-- SRC-LINE:1155 -->L1155 | <code>  {1&#x27;b0,1&#x27;b?,2&#x27;b01,2&#x27;b01}:bank_en_low_ori[3:0] = 4&#x27;b0010;</code> | case 译码分支：为当前输入组合设置确定的组合输出。 |
| <!-- SRC-LINE:1156 -->L1156 | <code>  {1&#x27;b0,1&#x27;b?,2&#x27;b01,2&#x27;b10}:bank_en_low_ori[3:0] = 4&#x27;b0110;</code> | case 译码分支：为当前输入组合设置确定的组合输出。 |
| <!-- SRC-LINE:1157 -->L1157 | <code>  {1&#x27;b0,1&#x27;b?,2&#x27;b01,2&#x27;b11}:bank_en_low_ori[3:0] = 4&#x27;b1110;</code> | case 译码分支：为当前输入组合设置确定的组合输出。 |
| <!-- SRC-LINE:1158 -->L1158 | <code>  {1&#x27;b0,1&#x27;b?,2&#x27;b10,2&#x27;b10}:bank_en_low_ori[3:0] = 4&#x27;b0100;</code> | case 译码分支：为当前输入组合设置确定的组合输出。 |
| <!-- SRC-LINE:1159 -->L1159 | <code>  {1&#x27;b0,1&#x27;b?,2&#x27;b10,2&#x27;b11}:bank_en_low_ori[3:0] = 4&#x27;b1100;</code> | case 译码分支：为当前输入组合设置确定的组合输出。 |
| <!-- SRC-LINE:1160 -->L1160 | <code>  {1&#x27;b0,1&#x27;b?,2&#x27;b11,2&#x27;b11}:bank_en_low_ori[3:0] = 4&#x27;b1000;</code> | case 译码分支：为当前输入组合设置确定的组合输出。 |
| <!-- SRC-LINE:1161 -->L1161 | <code>  {1&#x27;b1,1&#x27;b0,2&#x27;b??,2&#x27;b00}:bank_en_low_ori[3:0] = 4&#x27;b0001;</code> | case 译码分支：为当前输入组合设置确定的组合输出。 |
| <!-- SRC-LINE:1162 -->L1162 | <code>  {1&#x27;b1,1&#x27;b0,2&#x27;b??,2&#x27;b01}:bank_en_low_ori[3:0] = 4&#x27;b0011;</code> | case 译码分支：为当前输入组合设置确定的组合输出。 |
| <!-- SRC-LINE:1163 -->L1163 | <code>  {1&#x27;b1,1&#x27;b0,2&#x27;b??,2&#x27;b10}:bank_en_low_ori[3:0] = 4&#x27;b0111;</code> | case 译码分支：为当前输入组合设置确定的组合输出。 |
| <!-- SRC-LINE:1164 -->L1164 | <code>  {1&#x27;b1,1&#x27;b0,2&#x27;b??,2&#x27;b11}:bank_en_low_ori[3:0] = 4&#x27;b1111;</code> | case 译码分支：为当前输入组合设置确定的组合输出。 |
| <!-- SRC-LINE:1165 -->L1165 | <code>  {1&#x27;b1,1&#x27;b1,2&#x27;b00,2&#x27;b??}:bank_en_low_ori[3:0] = 4&#x27;b1111;</code> | case 译码分支：为当前输入组合设置确定的组合输出。 |
| <!-- SRC-LINE:1166 -->L1166 | <code>  {1&#x27;b1,1&#x27;b1,2&#x27;b01,2&#x27;b??}:bank_en_low_ori[3:0] = 4&#x27;b1110;</code> | case 译码分支：为当前输入组合设置确定的组合输出。 |
| <!-- SRC-LINE:1167 -->L1167 | <code>  {1&#x27;b1,1&#x27;b1,2&#x27;b10,2&#x27;b??}:bank_en_low_ori[3:0] = 4&#x27;b1100;</code> | case 译码分支：为当前输入组合设置确定的组合输出。 |
| <!-- SRC-LINE:1168 -->L1168 | <code>  {1&#x27;b1,1&#x27;b1,2&#x27;b11,2&#x27;b??}:bank_en_low_ori[3:0] = 4&#x27;b1000;</code> | case 译码分支：为当前输入组合设置确定的组合输出。 |
| <!-- SRC-LINE:1169 -->L1169 | <code>  default:bank_en_low_ori[3:0]  = 4&#x27;b0;</code> | case 译码分支：为当前输入组合设置确定的组合输出。 |
| <!-- SRC-LINE:1170 -->L1170 | <code>endcase</code> | 结束当前 case/casez 译码。 |
| <!-- SRC-LINE:1171 -->L1171 | <code>// &amp;CombEnd; @1086</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:1172 -->L1172 | <code>end</code> | 结束当前复合语句块。 |
| <!-- SRC-LINE:1173 -->L1173 | &nbsp; | 空行，用于分隔“DCACHE tag/data 阵列请求”中的逻辑块，提高源码可读性。 |
| <!-- SRC-LINE:1174 -->L1174 | <code>//if accelate, it must access all banks for 128 bits</code> | 原作者注释，说明“if accelate, it must access all banks for 128 bits”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:1175 -->L1175 | <code>assign bank_en_low[3:0] = ld_ag_acclr_en ? 4&#x27;b1111</code> | 边界加速时强制访问全部四个 32-bit bank。 |
| <!-- SRC-LINE:1176 -->L1176 | <code>                                         : bank_en_low_ori[3:0];</code> | 延续“DCACHE tag/data 阵列请求”中的声明、实例连接或多行组合表达式；需与前后行合并阅读。 |
| <!-- SRC-LINE:1177 -->L1177 | <code>//-------------for gateclk--------------</code> | 原作者注释，说明“-------------for gateclk--------------”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:1178 -->L1178 | &nbsp; | 空行，用于分隔“DCACHE tag/data 阵列请求”中的逻辑块，提高源码可读性。 |
| <!-- SRC-LINE:1179 -->L1179 | <code>assign bank_en_low_gateclk[3:0]   = bank_en_low[3:0];</code> | 连续组合赋值开始：驱动 `bank_en_low_gateclk[3:0]`；完整右值可能延续到后续行，属于“DCACHE tag/data 阵列请求”。 |
| <!-- SRC-LINE:1180 -->L1180 | &nbsp; | 空行，用于分隔“DCACHE tag/data 阵列请求”中的逻辑块，提高源码可读性。 |
| <!-- SRC-LINE:1181 -->L1181 | <code>assign ag_dcache_arb_ld_data_gateclk_en[7:0]  = {bank_en_low_gateclk[3:0],bank_en_low_gateclk[3:0]}</code> | 连续组合赋值开始：驱动 `ag_dcache_arb_ld_data_gateclk_en[7:0]`；完整右值可能延续到后续行，属于“DCACHE tag/data 阵列请求”。 |
| <!-- SRC-LINE:1182 -->L1182 | <code>                                                &amp; {8{ag_dcache_arb_ld_gateclk_en}};</code> | 延续“DCACHE tag/data 阵列请求”中的声明、实例连接或多行组合表达式；需与前后行合并阅读。 |
| <!-- SRC-LINE:1183 -->L1183 | &nbsp; | 空行，用于分隔“DCACHE tag/data 阵列请求”中的逻辑块，提高源码可读性。 |
| <!-- SRC-LINE:1184 -->L1184 | <code>//--------------for req-----------------</code> | 原作者注释，说明“--------------for req-----------------”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:1185 -->L1185 | <code>assign ag_dcache_arb_ld_data_req[7:0] = {bank_en_low[3:0],bank_en_low[3:0]}</code> | 连续组合赋值开始：驱动 `ag_dcache_arb_ld_data_req[7:0]`；完整右值可能延续到后续行，属于“DCACHE tag/data 阵列请求”。 |
| <!-- SRC-LINE:1186 -->L1186 | <code>                                        &amp; {8{ag_dcache_arb_ld_req}};</code> | 延续“DCACHE tag/data 阵列请求”中的声明、实例连接或多行组合表达式；需与前后行合并阅读。 |
| <!-- SRC-LINE:1187 -->L1187 | &nbsp; | 空行，用于分隔“DCACHE tag/data 阵列请求”中的逻辑块，提高源码可读性。 |
| <!-- SRC-LINE:1188 -->L1188 | <code>//-----------data idx-------------------</code> | 原作者注释，说明“-----------data idx-------------------”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:1189 -->L1189 | <code>assign ag_dcache_arb_ld_data_low_idx[10:0]  = ld_ag_pa[14:4];</code> | 低 128-bit 数据阵列索引使用 PA[14:4]。 |
| <!-- SRC-LINE:1190 -->L1190 | <code>assign ag_dcache_arb_ld_data_high_idx[10:0] = {ld_ag_pa[14:5],~ld_ag_pa[4]};</code> | 高 128-bit 数据阵列索引翻转 PA[4]，指向相邻 16-byte 块。 |
| <!-- SRC-LINE:1191 -->L1191 | &nbsp; | 空行，用于分隔“DCACHE tag/data 阵列请求”中的逻辑块，提高源码可读性。 |
| <!-- SRC-LINE:1192 -->L1192 | <code>//low/high din</code> | 原作者注释，说明“low/high din”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:1193 -->L1193 | <code>//assign ag_dcache_arb_ld_data_low_din[127:0]   = 128&#x27;b0;</code> | 原作者注释，说明“assign ag_dcache_arb_ld_data_low_din[127:0]   = 128'b0;”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:1194 -->L1194 | <code>//assign ag_dcache_arb_ld_data_high_din[127:0]  = 128&#x27;b0;</code> | 原作者注释，说明“assign ag_dcache_arb_ld_data_high_din[127:0]  = 128'b0;”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:1195 -->L1195 | &nbsp; | 空行，用于分隔“DCACHE tag/data 阵列请求”中的逻辑块，提高源码可读性。 |
| <!-- SRC-LINE:1196 -->L1196 | <code>//assign ag_dcache_arb_ld_data_wen[31:0] = 32&#x27;b0;</code> | 原作者注释，说明“assign ag_dcache_arb_ld_data_wen[31:0] = 32'b0;”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:1197 -->L1197 | &nbsp; | 空行，用于分隔“DCACHE tag/data 阵列请求”中的逻辑块，提高源码可读性。 |

## 异常生成

| 行号 | 原始代码 | 中文注释 |
|---:|---|---|
| <!-- SRC-LINE:1198 -->L1198 | <code>//==========================================================</code> | “异常生成”的视觉分隔注释，不参与逻辑。 |
| <!-- SRC-LINE:1199 -->L1199 | <code>//        Generage exception signal</code> | 原作者注释，说明“Generage exception signal”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:1200 -->L1200 | <code>//==========================================================</code> | “异常生成”的视觉分隔注释，不参与逻辑。 |
| <!-- SRC-LINE:1201 -->L1201 | <code>//if the 1st boundary instruction is weak order and 2nd is strong order, then treat</code> | 原作者注释，说明“if the 1st boundary instruction is weak order and 2nd is strong order, then treat”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:1202 -->L1202 | <code>//this instruction as weak order</code> | 原作者注释，说明“this instruction as weak order”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:1203 -->L1203 | <code>// &amp;Force(&quot;output&quot;, &quot;ld_ag_expt_misalign_no_page&quot;); @1117</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:1204 -->L1204 | <code>assign ld_ag_expt_misalign_no_page  = ld_ag_unalign</code> | 生成无需等待页属性的 misalign：atomic/vector 或普通 load 且 MM 模式关闭。 |
| <!-- SRC-LINE:1205 -->L1205 | <code>                                      &amp;&amp;  (ld_ag_atomic</code> | 延续“异常生成”中的声明、实例连接或多行组合表达式；需与前后行合并阅读。 |
| <!-- SRC-LINE:1206 -->L1206 | <code>                                          &#124;&#124;  ld_ag_inst_vls</code> | 注释中的 ASCII 框图行，用来列举流水寄存器字段，不参与逻辑。 |
| <!-- SRC-LINE:1207 -->L1207 | <code>                                          &#124;&#124;  ld_ag_ld_inst</code> | 注释中的 ASCII 框图行，用来列举流水寄存器字段，不参与逻辑。 |
| <!-- SRC-LINE:1208 -->L1208 | <code>                                              &amp;&amp;  !cp0_lsu_mm);</code> | 延续“异常生成”中的声明、实例连接或多行组合表达式；需与前后行合并阅读。 |
| <!-- SRC-LINE:1209 -->L1209 | &nbsp; | 空行，用于分隔“异常生成”中的逻辑块，提高源码可读性。 |
| <!-- SRC-LINE:1210 -->L1210 | <code>// &amp;Force(&quot;output&quot;,&quot;ld_ag_expt_misalign_with_page&quot;); @1124</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:1211 -->L1211 | <code>assign ld_ag_expt_misalign_with_page  = ld_ag_unalign_so</code> | SO 页面上的普通 load 不对齐异常，需要 PA valid。 |
| <!-- SRC-LINE:1212 -->L1212 | <code>                                        &amp;&amp;  ld_ag_page_so</code> | 延续“异常生成”中的声明、实例连接或多行组合表达式；需与前后行合并阅读。 |
| <!-- SRC-LINE:1213 -->L1213 | <code>                                        &amp;&amp;  mmu_lsu_pa0_vld</code> | 延续“异常生成”中的声明、实例连接或多行组合表达式；需与前后行合并阅读。 |
| <!-- SRC-LINE:1214 -->L1214 | <code>                                        &amp;&amp;  ld_ag_ld_inst;</code> | 延续“异常生成”中的声明、实例连接或多行组合表达式；需与前后行合并阅读。 |
| <!-- SRC-LINE:1215 -->L1215 | &nbsp; | 空行，用于分隔“异常生成”中的逻辑块，提高源码可读性。 |
| <!-- SRC-LINE:1216 -->L1216 | <code>// &amp;Force(&quot;output&quot;, &quot;ld_ag_expt_page_fault&quot;); @1130</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:1217 -->L1217 | <code>assign ld_ag_expt_page_fault       = mmu_lsu_pa0_vld</code> | 页故障输出要求 PA valid 与 MMU page_fault 同时成立。 |
| <!-- SRC-LINE:1218 -->L1218 | <code>                                    &amp;&amp;  ld_ag_page_fault;</code> | 延续“异常生成”中的声明、实例连接或多行组合表达式；需与前后行合并阅读。 |
| <!-- SRC-LINE:1219 -->L1219 | &nbsp; | 空行，用于分隔“异常生成”中的逻辑块，提高源码可读性。 |
| <!-- SRC-LINE:1220 -->L1220 | <code>// &amp;Force(&quot;output&quot;,&quot;ld_ag_expt_ldamo_not_ca&quot;); @1134</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:1221 -->L1221 | <code>assign ld_ag_expt_ldamo_not_ca    = mmu_lsu_pa0_vld</code> | 生成 LDAMO 访问 non-cacheable 页的专用异常。 |
| <!-- SRC-LINE:1222 -->L1222 | <code>                                    &amp;&amp;  ld_ag_ldamo_inst</code> | 延续“异常生成”中的声明、实例连接或多行组合表达式；需与前后行合并阅读。 |
| <!-- SRC-LINE:1223 -->L1223 | <code>                                    &amp;&amp;  !ld_ag_page_ca;</code> | 延续“异常生成”中的声明、实例连接或多行组合表达式；需与前后行合并阅读。 |
| <!-- SRC-LINE:1224 -->L1224 | &nbsp; | 空行，用于分隔“异常生成”中的逻辑块，提高源码可读性。 |
| <!-- SRC-LINE:1225 -->L1225 | <code>// //&amp;Force(&quot;output&quot;, &quot;ld_ag_expt_access_fault&quot;); @1139</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:1226 -->L1226 | <code>//assign ld_ag_expt_access_fault    = mmu_lsu_pa0_vld</code> | 原作者注释，说明“assign ld_ag_expt_access_fault    = mmu_lsu_pa0_vld”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:1227 -->L1227 | <code>//                                    &amp;&amp;  (ld_ag_access_fault</code> | 原作者注释，说明“&&  (ld_ag_access_fault”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:1228 -->L1228 | <code>//                                        &#124;&#124;  ld_ag_ldamo_inst</code> | 原作者注释，说明“&#124;&#124;  ld_ag_ldamo_inst”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:1229 -->L1229 | <code>//                                            &amp;&amp;  !ld_ag_page_ca);</code> | 原作者注释，说明“&&  !ld_ag_page_ca);”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:1230 -->L1230 | &nbsp; | 空行，用于分隔“异常生成”中的逻辑块，提高源码可读性。 |
| <!-- SRC-LINE:1231 -->L1231 | <code>//for vector strong order</code> | 原作者注释，说明“for vector strong order”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:1232 -->L1232 | <code>// &amp;Force(&quot;output&quot;, &quot;ld_ag_expt_access_fault_with_page&quot;); @1146</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:1233 -->L1233 | <code>assign ld_ag_expt_access_fault_with_page = mmu_lsu_pa0_vld</code> | 连续组合赋值开始：驱动 `ld_ag_expt_access_fault_with_page`；完整右值可能延续到后续行，属于“异常生成”。 |
| <!-- SRC-LINE:1234 -->L1234 | <code>                                           &amp;&amp;  ld_ag_page_so</code> | 延续“异常生成”中的声明、实例连接或多行组合表达式；需与前后行合并阅读。 |
| <!-- SRC-LINE:1235 -->L1235 | <code>                                           &amp;&amp;  ld_ag_ld_inst</code> | 延续“异常生成”中的声明、实例连接或多行组合表达式；需与前后行合并阅读。 |
| <!-- SRC-LINE:1236 -->L1236 | <code>                                           &amp;&amp;  ld_ag_inst_vls;</code> | 延续“异常生成”中的声明、实例连接或多行组合表达式；需与前后行合并阅读。 |
| <!-- SRC-LINE:1237 -->L1237 | &nbsp; | 空行，用于分隔“异常生成”中的逻辑块，提高源码可读性。 |
| <!-- SRC-LINE:1238 -->L1238 | <code>assign ld_ag_expt_vld         = ld_ag_expt_misalign_no_page</code> | 聚合异常不包含专用 LDAMO-not-cacheable 异常，消费者需另行处理。 |
| <!-- SRC-LINE:1239 -->L1239 | <code>                                &#124;&#124;  ld_ag_expt_misalign_with_page</code> | 注释中的 ASCII 框图行，用来列举流水寄存器字段，不参与逻辑。 |
| <!-- SRC-LINE:1240 -->L1240 | <code>                                &#124;&#124;  ld_ag_expt_access_fault_with_page</code> | 注释中的 ASCII 框图行，用来列举流水寄存器字段，不参与逻辑。 |
| <!-- SRC-LINE:1241 -->L1241 | <code>                                &#124;&#124;  ld_ag_expt_page_fault;</code> | 注释中的 ASCII 框图行，用来列举流水寄存器字段，不参与逻辑。 |
| <!-- SRC-LINE:1242 -->L1242 | &nbsp; | 空行，用于分隔“异常生成”中的逻辑块，提高源码可读性。 |

## stall、restart 与优先级

| 行号 | 原始代码 | 中文注释 |
|---:|---|---|
| <!-- SRC-LINE:1243 -->L1243 | <code>//==========================================================</code> | “stall、restart 与优先级”的视觉分隔注释，不参与逻辑。 |
| <!-- SRC-LINE:1244 -->L1244 | <code>//        Generage stall/restart signal</code> | 原作者注释，说明“Generage stall/restart signal”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:1245 -->L1245 | <code>//==========================================================</code> | “stall、restart 与优先级”的视觉分隔注释，不参与逻辑。 |
| <!-- SRC-LINE:1246 -->L1246 | <code>//-----------restart----------------------------------------</code> | 原作者注释，说明“-----------restart----------------------------------------”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:1247 -->L1247 | <code>assign ld_ag_atomic_no_cmit_restart_req = ld_ag_inst_vld</code> | atomic 指令在对应 iid 尚未 commit 时请求 restart。 |
| <!-- SRC-LINE:1248 -->L1248 | <code>                                          &amp;&amp;  ld_ag_atomic</code> | 延续“stall、restart 与优先级”中的声明、实例连接或多行组合表达式；需与前后行合并阅读。 |
| <!-- SRC-LINE:1249 -->L1249 | <code>                                          &amp;&amp;  !ld_ag_cmit;</code> | 延续“stall、restart 与优先级”中的声明、实例连接或多行组合表达式；需与前后行合并阅读。 |
| <!-- SRC-LINE:1250 -->L1250 | &nbsp; | 空行，用于分隔“stall、restart 与优先级”中的逻辑块，提高源码可读性。 |
| <!-- SRC-LINE:1251 -->L1251 | <code>//-----------stall------------------------------------------</code> | 原作者注释，说明“-----------stall------------------------------------------”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:1252 -->L1252 | <code>//get the stall signal if virtual address cross 4k address</code> | 原作者注释，说明“get the stall signal if virtual address cross 4k address”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:1253 -->L1253 | <code>//for timing, if there is a carry adding last 12 bits, or there is &#x27;1&#x27; in high</code> | 原作者注释，说明“for timing, if there is a carry adding last 12 bits, or there is '1' in high”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:1254 -->L1254 | <code>//bits, it will stall</code> | 原作者注释，说明“bits, it will stall”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:1255 -->L1255 | <code>//---------------------cross 4k-----------------------------</code> | 原作者注释，说明“---------------------cross 4k-----------------------------”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:1256 -->L1256 | <code>assign ld_ag_4k_sum_ori[12:0]   = {1&#x27;b0,ld_ag_base[11:0]} </code> | 用 base 页内低 12 位与有效 offset 低位计算 4 KiB 进位。 |
| <!-- SRC-LINE:1257 -->L1257 | <code>                                  + {ld_ag_offset[63],ld_ag_offset_aftershift[11:0]};</code> | 注释中的 ASCII 框图行，用来列举流水寄存器字段，不参与逻辑。 |
| <!-- SRC-LINE:1258 -->L1258 | &nbsp; | 空行，用于分隔“stall、restart 与优先级”中的逻辑块，提高源码可读性。 |
| <!-- SRC-LINE:1259 -->L1259 | <code>assign ld_ag_4k_sum_plus[12:0]   = {1&#x27;b0,ld_ag_base[11:0]} </code> | 连续组合赋值开始：驱动 `ld_ag_4k_sum_plus[12:0]`；完整右值可能延续到后续行，属于“stall、restart 与优先级”。 |
| <!-- SRC-LINE:1260 -->L1260 | <code>                                  + ld_ag_offset_plus[12:0];</code> | 注释中的 ASCII 框图行，用来列举流水寄存器字段，不参与逻辑。 |
| <!-- SRC-LINE:1261 -->L1261 | &nbsp; | 空行，用于分隔“stall、restart 与优先级”中的逻辑块，提高源码可读性。 |
| <!-- SRC-LINE:1262 -->L1262 | <code>assign ld_ag_off_4k_high_bits_all_0_ori = !(&#124;ld_ag_offset_aftershift[63:12]);</code> | 检测 shifted offset 高位是否全 0。 |
| <!-- SRC-LINE:1263 -->L1263 | <code>assign ld_ag_off_4k_high_bits_all_1_ori = &amp;ld_ag_offset_aftershift[63:12];</code> | 检测 shifted offset 高位是否全 1，用于合法负 offset 的符号扩展判定。 |
| <!-- SRC-LINE:1264 -->L1264 | <code>assign ld_ag_off_4k_high_bits_not_eq    = !ld_ag_off_4k_high_bits_all_0_ori</code> | 连续组合赋值开始：驱动 `ld_ag_off_4k_high_bits_not_eq`；完整右值可能延续到后续行，属于“stall、restart 与优先级”。 |
| <!-- SRC-LINE:1265 -->L1265 | <code>                                          &amp;&amp;  !ld_ag_off_4k_high_bits_all_1_ori;</code> | 延续“stall、restart 与优先级”中的声明、实例连接或多行组合表达式；需与前后行合并阅读。 |
| <!-- SRC-LINE:1266 -->L1266 | &nbsp; | 空行，用于分隔“stall、restart 与优先级”中的逻辑块，提高源码可读性。 |
| <!-- SRC-LINE:1267 -->L1267 | <code>assign ld_ag_4k_sum_12  = ld_ag_va_plus_sel ? ld_ag_4k_sum_plus[12]</code> | 连续组合赋值开始：驱动 `ld_ag_4k_sum_12`；完整右值可能延续到后续行，属于“stall、restart 与优先级”。 |
| <!-- SRC-LINE:1268 -->L1268 | <code>                                            : ld_ag_4k_sum_ori[12];</code> | 延续“stall、restart 与优先级”中的声明、实例连接或多行组合表达式；需与前后行合并阅读。 |
| <!-- SRC-LINE:1269 -->L1269 | &nbsp; | 空行，用于分隔“stall、restart 与优先级”中的逻辑块，提高源码可读性。 |
| <!-- SRC-LINE:1270 -->L1270 | <code>assign ld_ag_cross_4k   = ld_ag_4k_sum_12</code> | 跨 4 KiB 条件为低位加法进位或 offset 高位既非全 0 也非全 1。 |
| <!-- SRC-LINE:1271 -->L1271 | <code>                          &#124;&#124;  ld_ag_off_4k_high_bits_not_eq;</code> | 注释中的 ASCII 框图行，用来列举流水寄存器字段，不参与逻辑。 |
| <!-- SRC-LINE:1272 -->L1272 | &nbsp; | 空行，用于分隔“stall、restart 与优先级”中的逻辑块，提高源码可读性。 |
| <!-- SRC-LINE:1273 -->L1273 | <code>//only ldr will trigger secd stall, and will stall at the first split</code> | 原作者注释，说明“only ldr will trigger secd stall, and will stall at the first split”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:1274 -->L1274 | <code>assign ld_ag_boundary_stall = ld_ag_inst_ldr &amp;&amp; ld_ag_boundary &amp;&amp; !ld_ag_secd;</code> | 连续组合赋值开始：驱动 `ld_ag_boundary_stall`；完整右值可能延续到后续行，属于“stall、restart 与优先级”。 |
| <!-- SRC-LINE:1275 -->L1275 | <code>assign ld_ag_secd_imme_stall  = ld_ag_boundary_stall  &amp;&amp;  !ld_ag_already_cross_page_ldr_imme;</code> | 连续组合赋值开始：驱动 `ld_ag_secd_imme_stall`；完整右值可能延续到后续行，属于“stall、restart 与优先级”。 |
| <!-- SRC-LINE:1276 -->L1276 | &nbsp; | 空行，用于分隔“stall、restart 与优先级”中的逻辑块，提高源码可读性。 |
| <!-- SRC-LINE:1277 -->L1277 | <code>assign ld_ag_dcache_stall_unmask    = !dcache_arb_ag_ld_sel;</code> | 连续组合赋值开始：驱动 `ld_ag_dcache_stall_unmask`；完整右值可能延续到后续行，属于“stall、restart 与优先级”。 |
| <!-- SRC-LINE:1278 -->L1278 | <code>//because corss_4k to mmu, so there doesn&#x27;t exist prior stall</code> | 原作者注释，说明“because corss_4k to mmu, so there doesn't exist prior stall”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:1279 -->L1279 | <code>assign ld_ag_cross_page_ldr_imme_stall_req =  (ld_ag_cross_4k</code> | 跨页或 LDR 边界第二拍需要 stall/replay，并排除已在 AG 报出的 misalign。 |
| <!-- SRC-LINE:1280 -->L1280 | <code>                                                  &#124;&#124;  ld_ag_secd_imme_stall)</code> | 注释中的 ASCII 框图行，用来列举流水寄存器字段，不参与逻辑。 |
| <!-- SRC-LINE:1281 -->L1281 | <code>                                              &amp;&amp;  !ld_ag_expt_misalign_no_page</code> | 延续“stall、restart 与优先级”中的声明、实例连接或多行组合表达式；需与前后行合并阅读。 |
| <!-- SRC-LINE:1282 -->L1282 | <code>                                              &amp;&amp;  ld_ag_inst_vld;</code> | 延续“stall、restart 与优先级”中的声明、实例连接或多行组合表达式；需与前后行合并阅读。 |
| <!-- SRC-LINE:1283 -->L1283 | <code>assign ld_ag_dcache_stall_req   = ld_ag_dcache_stall_unmask</code> | DCACHE 未选择当前 AG 请求且指令有效时产生 cache stall。 |
| <!-- SRC-LINE:1284 -->L1284 | <code>                                  &amp;&amp;  ld_ag_inst_vld;</code> | 延续“stall、restart 与优先级”中的声明、实例连接或多行组合表达式；需与前后行合并阅读。 |
| <!-- SRC-LINE:1285 -->L1285 | <code>assign ld_ag_mmu_stall_req      = mmu_lsu_stall0;</code> | MMU stall 未在本模块按 AG valid 门控；当前上游 DUTLB 实现将其常置 0。 |
| <!-- SRC-LINE:1286 -->L1286 | &nbsp; | 空行，用于分隔“stall、restart 与优先级”中的逻辑块，提高源码可读性。 |
| <!-- SRC-LINE:1287 -->L1287 | <code>//-----------arbiter----------------------------------------</code> | 原作者注释，说明“-----------arbiter----------------------------------------”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:1288 -->L1288 | <code>//prioritize:</code> | 原作者注释，说明“prioritize:”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:1289 -->L1289 | <code>//  1. prior_restart  : ldex_no_cmit</code> | 原作者注释，说明“1. prior_restart  : ldex_no_cmit”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:1290 -->L1290 | <code>//  2. cross_page_ldr_imme_stall    : cross_4k, secd_imme</code> | 原作者注释，说明“2. cross_page_ldr_imme_stall    : cross_4k, secd_imme”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:1291 -->L1291 | <code>//  3. dcache_stall    : cache</code> | 原作者注释，说明“3. dcache_stall    : cache”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:1292 -->L1292 | <code>//  other restart flop to dc stage</code> | 原作者注释，说明“other restart flop to dc stage”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:1293 -->L1293 | <code>//  other_restart  : utlb_miss, tlb_busy</code> | 原作者注释，说明“other_restart  : utlb_miss, tlb_busy”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:1294 -->L1294 | &nbsp; | 空行，用于分隔“stall、restart 与优先级”中的逻辑块，提高源码可读性。 |
| <!-- SRC-LINE:1295 -->L1295 | <code>//assign ld_ag_prior_stall_restart  = ld_ag_atomic_no_cmit_restart_req</code> | 原作者注释，说明“assign ld_ag_prior_stall_restart  = ld_ag_atomic_no_cmit_restart_req”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:1296 -->L1296 | <code>//                                    &#124;&#124;  ld_ag_cross_page_ldr_imme_stall_req;</code> | 原作者注释，说明“&#124;&#124;  ld_ag_cross_page_ldr_imme_stall_req;”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:1297 -->L1297 | &nbsp; | 空行，用于分隔“stall、restart 与优先级”中的逻辑块，提高源码可读性。 |
| <!-- SRC-LINE:1298 -->L1298 | <code>assign ld_ag_stall_restart        = ld_ag_atomic_no_cmit_restart_req</code> | 总 restart/stall 合并 atomic、跨页、DCACHE 和 MMU 四类原因。 |
| <!-- SRC-LINE:1299 -->L1299 | <code>                                    &#124;&#124;  ld_ag_cross_page_ldr_imme_stall_req</code> | 注释中的 ASCII 框图行，用来列举流水寄存器字段，不参与逻辑。 |
| <!-- SRC-LINE:1300 -->L1300 | <code>                                    &#124;&#124;  ld_ag_dcache_stall_req</code> | 注释中的 ASCII 框图行，用来列举流水寄存器字段，不参与逻辑。 |
| <!-- SRC-LINE:1301 -->L1301 | <code>                                    &#124;&#124;  ld_ag_mmu_stall_req;</code> | 注释中的 ASCII 框图行，用来列举流水寄存器字段，不参与逻辑。 |
| <!-- SRC-LINE:1302 -->L1302 | &nbsp; | 空行，用于分隔“stall、restart 与优先级”中的逻辑块，提高源码可读性。 |
| <!-- SRC-LINE:1303 -->L1303 | <code>assign ld_ag_atomic_no_cmit_restart_arb = ld_ag_atomic_no_cmit_restart_req;</code> | 连续组合赋值开始：驱动 `ld_ag_atomic_no_cmit_restart_arb`；完整右值可能延续到后续行，属于“stall、restart 与优先级”。 |
| <!-- SRC-LINE:1304 -->L1304 | <code>assign ld_ag_cross_page_ldr_imme_stall_arb  = !ld_ag_atomic_no_cmit_restart_req</code> | 跨页/LDR replay 仅在非 atomic 优先级且未被更老 RF 指令 mask 时执行。 |
| <!-- SRC-LINE:1305 -->L1305 | <code>                                              &amp;&amp;  ld_ag_cross_page_ldr_imme_stall_req</code> | 延续“stall、restart 与优先级”中的声明、实例连接或多行组合表达式；需与前后行合并阅读。 |
| <!-- SRC-LINE:1306 -->L1306 | <code>                                              &amp;&amp;  !ld_ag_stall_mask;</code> | 延续“stall、restart 与优先级”中的声明、实例连接或多行组合表达式；需与前后行合并阅读。 |
| <!-- SRC-LINE:1307 -->L1307 | &nbsp; | 空行，用于分隔“stall、restart 与优先级”中的逻辑块，提高源码可读性。 |
| <!-- SRC-LINE:1308 -->L1308 | <code>//-----------generate total siangl--------------------------</code> | 原作者注释，说明“-----------generate total siangl--------------------------”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:1309 -->L1309 | <code>// &amp;Force(&quot;output&quot;,&quot;ld_ag_stall_ori&quot;); @1223</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:1310 -->L1310 | <code>assign ld_ag_stall_ori            = (ld_ag_cross_page_ldr_imme_stall_req</code> | 对外原始 stall 排除 atomic-no-commit restart。 |
| <!-- SRC-LINE:1311 -->L1311 | <code>                                        &#124;&#124;  ld_ag_dcache_stall_req</code> | 注释中的 ASCII 框图行，用来列举流水寄存器字段，不参与逻辑。 |
| <!-- SRC-LINE:1312 -->L1312 | <code>                                        &#124;&#124;  ld_ag_mmu_stall_req)</code> | 注释中的 ASCII 框图行，用来列举流水寄存器字段，不参与逻辑。 |
| <!-- SRC-LINE:1313 -->L1313 | <code>                                    &amp;&amp;  !ld_ag_atomic_no_cmit_restart_req;</code> | 延续“stall、restart 与优先级”中的声明、实例连接或多行组合表达式；需与前后行合并阅读。 |
| <!-- SRC-LINE:1314 -->L1314 | &nbsp; | 空行，用于分隔“stall、restart 与优先级”中的逻辑块，提高源码可读性。 |
| <!-- SRC-LINE:1315 -->L1315 | <code>assign ld_ag_stall_vld            = ld_ag_stall_ori</code> | 连续组合赋值开始：驱动 `ld_ag_stall_vld`；完整右值可能延续到后续行，属于“stall、restart 与优先级”。 |
| <!-- SRC-LINE:1316 -->L1316 | <code>                                    &amp;&amp; !ld_ag_stall_mask;</code> | 延续“stall、restart 与优先级”中的声明、实例连接或多行组合表达式；需与前后行合并阅读。 |
| <!-- SRC-LINE:1317 -->L1317 | &nbsp; | 空行，用于分隔“stall、restart 与优先级”中的逻辑块，提高源码可读性。 |
| <!-- SRC-LINE:1318 -->L1318 | <code>//for performance,when ag stall,let oldest inst go</code> | 原作者注释，说明“for performance,when ag stall,let oldest inst go”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:1319 -->L1319 | &nbsp; | 空行，用于分隔“stall、restart 与优先级”中的逻辑块，提高源码可读性。 |
| <!-- SRC-LINE:1320 -->L1320 | <code>// &amp;Instance(&quot;ct_rtu_compare_iid&quot;,&quot;x_lsu_rf_compare_ld_ag_iid&quot;); @1234</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:1321 -->L1321 | <code>ct_rtu_compare_iid  x_lsu_rf_compare_ld_ag_iid (</code> | 实例化 iid 比较器，判断 RF 指令是否比当前 AG 指令更老。 |
| <!-- SRC-LINE:1322 -->L1322 | <code>  .x_iid0                    (idu_lsu_rf_pipe3_iid[6:0]),</code> | 实例端口连接：子模块端口 `x_iid0` 连接本层信号/常量 `idu_lsu_rf_pipe3_iid[6:0]`。 |
| <!-- SRC-LINE:1323 -->L1323 | <code>  .x_iid0_older              (rf_iid_older_than_ld_ag  ),</code> | 实例端口连接：子模块端口 `x_iid0_older` 连接本层信号/常量 `rf_iid_older_than_ld_ag`。 |
| <!-- SRC-LINE:1324 -->L1324 | <code>  .x_iid1                    (ld_ag_iid[6:0]           )</code> | 实例端口连接：子模块端口 `x_iid1` 连接本层信号/常量 `ld_ag_iid[6:0]`。 |
| <!-- SRC-LINE:1325 -->L1325 | <code>);</code> | 结束当前子模块实例的端口连接。 |
| <!-- SRC-LINE:1326 -->L1326 | &nbsp; | 空行，用于分隔“stall、restart 与优先级”中的逻辑块，提高源码可读性。 |
| <!-- SRC-LINE:1327 -->L1327 | <code>// &amp;Connect( .x_iid0         (idu_lsu_rf_pipe3_iid[6:0]), @1235</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:1328 -->L1328 | <code>//           .x_iid1         (ld_ag_iid[6:0]           ), @1236</code> | 原作者注释，说明“.x_iid1         (ld_ag_iid[6:0]           ), @1236”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:1329 -->L1329 | <code>//           .x_iid0_older   (rf_iid_older_than_ld_ag )); @1237</code> | 原作者注释，说明“.x_iid0_older   (rf_iid_older_than_ld_ag )); @1237”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:1330 -->L1330 | &nbsp; | 空行，用于分隔“stall、restart 与优先级”中的逻辑块，提高源码可读性。 |
| <!-- SRC-LINE:1331 -->L1331 | <code>assign ld_ag_stall_mask = idu_lsu_rf_pipe3_sel</code> | 更老 RF 指令可 mask 当前 AG stall，以改善调度性能。 |
| <!-- SRC-LINE:1332 -->L1332 | <code>                          &amp;&amp; rf_iid_older_than_ld_ag;</code> | 延续“stall、restart 与优先级”中的声明、实例连接或多行组合表达式；需与前后行合并阅读。 |
| <!-- SRC-LINE:1333 -->L1333 | &nbsp; | 空行，用于分隔“stall、restart 与优先级”中的逻辑块，提高源码可读性。 |
| <!-- SRC-LINE:1334 -->L1334 | <code>assign ld_ag_stall_restart_entry[LSIQ_ENTRY-1:0] = ld_ag_stall_mask</code> | 连续组合赋值开始：驱动 `ld_ag_stall_restart_entry[LSIQ_ENTRY-1:0]`；完整右值可能延续到后续行，属于“stall、restart 与优先级”。 |
| <!-- SRC-LINE:1335 -->L1335 | <code>                                                   ? ld_ag_lsid[LSIQ_ENTRY-1:0]</code> | 延续“stall、restart 与优先级”中的声明、实例连接或多行组合表达式；需与前后行合并阅读。 |
| <!-- SRC-LINE:1336 -->L1336 | <code>                                                   : idu_lsu_rf_pipe3_lch_entry[LSIQ_ENTRY-1:0];</code> | 延续“stall、restart 与优先级”中的声明、实例连接或多行组合表达式；需与前后行合并阅读。 |
| <!-- SRC-LINE:1337 -->L1337 | &nbsp; | 空行，用于分隔“stall、restart 与优先级”中的逻辑块，提高源码可读性。 |

## 下传 DC 与提前唤醒

| 行号 | 原始代码 | 中文注释 |
|---:|---|---|
| <!-- SRC-LINE:1338 -->L1338 | <code>//==========================================================</code> | “下传 DC 与提前唤醒”的视觉分隔注释，不参与逻辑。 |
| <!-- SRC-LINE:1339 -->L1339 | <code>//        Generage to DC stage signal</code> | 原作者注释，说明“Generage to DC stage signal”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:1340 -->L1340 | <code>//==========================================================</code> | “下传 DC 与提前唤醒”的视觉分隔注释，不参与逻辑。 |
| <!-- SRC-LINE:1341 -->L1341 | <code>// &amp;Force(&quot;output&quot;, &quot;ld_ag_dc_inst_vld&quot;); @1249</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:1342 -->L1342 | <code>assign ld_ag_dc_inst_vld          = ld_ag_inst_vld</code> | 下传 DC valid = AG valid 且不存在任何 stall/restart。 |
| <!-- SRC-LINE:1343 -->L1343 | <code>                                    &amp;&amp;  !ld_ag_stall_restart;</code> | 延续“下传 DC 与提前唤醒”中的声明、实例连接或多行组合表达式；需与前后行合并阅读。 |
| <!-- SRC-LINE:1344 -->L1344 | &nbsp; | 空行，用于分隔“下传 DC 与提前唤醒”中的逻辑块，提高源码可读性。 |
| <!-- SRC-LINE:1345 -->L1345 | <code>assign ld_ag_dc_mmu_req           = !lsu_mmu_abort0;</code> | DC 伴随 mmu_req 为 abort 的反相；空闲时可能为 1，DC 仅在 AG valid 时锁存。 |
| <!-- SRC-LINE:1346 -->L1346 | &nbsp; | 空行，用于分隔“下传 DC 与提前唤醒”中的逻辑块，提高源码可读性。 |
| <!-- SRC-LINE:1347 -->L1347 | <code>//this logic may be redundant</code> | 原作者注释，说明“this logic may be redundant”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:1348 -->L1348 | <code>assign ld_ag_dc_addr0[`PA_WIDTH-1:0] = dcache_arb_ld_ag_borrow_addr_vld</code> | DCACHE borrow 地址有效时覆盖正常的 AG 物理地址。 |
| <!-- SRC-LINE:1349 -->L1349 | <code>                                      ? dcache_arb_ld_ag_addr[`PA_WIDTH-1:0]</code> | 延续“下传 DC 与提前唤醒”中的声明、实例连接或多行组合表达式；需与前后行合并阅读。 |
| <!-- SRC-LINE:1350 -->L1350 | <code>                                      : ld_ag_addr0[`PA_WIDTH-1:0];</code> | 延续“下传 DC 与提前唤醒”中的声明、实例连接或多行组合表达式；需与前后行合并阅读。 |
| <!-- SRC-LINE:1351 -->L1351 | &nbsp; | 空行，用于分隔“下传 DC 与提前唤醒”中的逻辑块，提高源码可读性。 |
| <!-- SRC-LINE:1352 -->L1352 | <code>//for idu timing</code> | 原作者注释，说明“for idu timing”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:1353 -->L1353 | <code>// &amp;Force(&quot;output&quot;,&quot;ld_ag_inst_vfls&quot;);  @1261</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:1354 -->L1354 | <code>// &amp;Force(&quot;output&quot;,&quot;ld_ag_dc_load_inst_vld&quot;); @1262</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:1355 -->L1355 | <code>//TODO ld_ag_ahead_predict is the predict result for 3 write back</code> | 原作者注释，说明“TODO ld_ag_ahead_predict is the predict result for 3 write back”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:1356 -->L1356 | <code>// &amp;Force(&quot;output&quot;,&quot;ld_ag_ahead_predict&quot;); @1264</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:1357 -->L1357 | <code>assign ld_ag_ahead_predict        = 1&#x27;b1;</code> | ahead prediction 在本版本恒为 1，且源码留有 TODO。 |
| <!-- SRC-LINE:1358 -->L1358 | <code>assign ld_ag_dc_load_inst_vld       = ld_ag_inst_vld</code> | 连续组合赋值开始：驱动 `ld_ag_dc_load_inst_vld`；完整右值可能延续到后续行，属于“下传 DC 与提前唤醒”。 |
| <!-- SRC-LINE:1359 -->L1359 | <code>                                      &amp;&amp;  !ld_ag_inst_vfls</code> | 延续“下传 DC 与提前唤醒”中的声明、实例连接或多行组合表达式；需与前后行合并阅读。 |
| <!-- SRC-LINE:1360 -->L1360 | <code>                                      &amp;&amp;  !(ld_ag_boundary</code> | 延续“下传 DC 与提前唤醒”中的声明、实例连接或多行组合表达式；需与前后行合并阅读。 |
| <!-- SRC-LINE:1361 -->L1361 | <code>                                          &amp;&amp; !ld_ag_acclr_en);</code> | 延续“下传 DC 与提前唤醒”中的声明、实例连接或多行组合表达式；需与前后行合并阅读。 |
| <!-- SRC-LINE:1362 -->L1362 | <code>//if boundary and acclr en, then set load_inst_vld and clr</code> | 原作者注释，说明“if boundary and acclr en, then set load_inst_vld and clr”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:1363 -->L1363 | <code>//load_ahead_inst_vld, because boundary don&#x27;t write back in 3 cycles</code> | 原作者注释，说明“load_ahead_inst_vld, because boundary don't write back in 3 cycles”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:1364 -->L1364 | <code>assign ld_ag_dc_load_ahead_inst_vld = ld_ag_inst_vld</code> | 普通 load ahead-valid 排除 boundary、vector 和 DA-forward-disable。 |
| <!-- SRC-LINE:1365 -->L1365 | <code>                                      &amp;&amp;  !ld_ag_inst_vfls</code> | 延续“下传 DC 与提前唤醒”中的声明、实例连接或多行组合表达式；需与前后行合并阅读。 |
| <!-- SRC-LINE:1366 -->L1366 | <code>                                      &amp;&amp;  !ld_ag_boundary</code> | 延续“下传 DC 与提前唤醒”中的声明、实例连接或多行组合表达式；需与前后行合并阅读。 |
| <!-- SRC-LINE:1367 -->L1367 | <code>                                      &amp;&amp;  !cp0_lsu_da_fwd_dis</code> | 延续“下传 DC 与提前唤醒”中的声明、实例连接或多行组合表达式；需与前后行合并阅读。 |
| <!-- SRC-LINE:1368 -->L1368 | <code>                                      &amp;&amp;  ld_ag_ahead_predict;</code> | 延续“下传 DC 与提前唤醒”中的声明、实例连接或多行组合表达式；需与前后行合并阅读。 |
| <!-- SRC-LINE:1369 -->L1369 | &nbsp; | 空行，用于分隔“下传 DC 与提前唤醒”中的逻辑块，提高源码可读性。 |
| <!-- SRC-LINE:1370 -->L1370 | <code>// &amp;Force(&quot;output&quot;,&quot;ld_ag_dc_vload_inst_vld&quot;); @1278</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:1371 -->L1371 | <code>assign ld_ag_dc_vload_inst_vld        = ld_ag_inst_vld</code> | vector load valid 使用 inst_vfls 分类，且排除 VMB merge 与不能加速的 boundary。 |
| <!-- SRC-LINE:1372 -->L1372 | <code>                                        &amp;&amp;  ld_ag_inst_vfls</code> | 延续“下传 DC 与提前唤醒”中的声明、实例连接或多行组合表达式；需与前后行合并阅读。 |
| <!-- SRC-LINE:1373 -->L1373 | <code>                                        &amp;&amp;  !ld_ag_vmb_merge_vld</code> | 延续“下传 DC 与提前唤醒”中的声明、实例连接或多行组合表达式；需与前后行合并阅读。 |
| <!-- SRC-LINE:1374 -->L1374 | <code>                                        &amp;&amp;  !(ld_ag_boundary</code> | 延续“下传 DC 与提前唤醒”中的声明、实例连接或多行组合表达式；需与前后行合并阅读。 |
| <!-- SRC-LINE:1375 -->L1375 | <code>                                              &amp;&amp; !ld_ag_acclr_en);</code> | 延续“下传 DC 与提前唤醒”中的声明、实例连接或多行组合表达式；需与前后行合并阅读。 |
| <!-- SRC-LINE:1376 -->L1376 | <code>//assign ld_ag_dc_vload_ahead_inst_vld  = ld_ag_inst_vld</code> | 原作者注释，说明“assign ld_ag_dc_vload_ahead_inst_vld  = ld_ag_inst_vld”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:1377 -->L1377 | <code>//                                        &amp;&amp;  ld_ag_inst_vfls</code> | 原作者注释，说明“&&  ld_ag_inst_vfls”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:1378 -->L1378 | <code>//                                        &amp;&amp;  !ld_ag_inst_vls</code> | 原作者注释，说明“&&  !ld_ag_inst_vls”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:1379 -->L1379 | <code>//                                        &amp;&amp;  !ld_ag_boundary</code> | 原作者注释，说明“&&  !ld_ag_boundary”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:1380 -->L1380 | <code>//                                        &amp;&amp;  !cp0_lsu_da_fwd_dis</code> | 原作者注释，说明“&&  !cp0_lsu_da_fwd_dis”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:1381 -->L1381 | <code>//                                        &amp;&amp;  ld_ag_ahead_predict;</code> | 原作者注释，说明“&&  ld_ag_ahead_predict;”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:1382 -->L1382 | <code>assign ld_ag_dc_vload_ahead_inst_vld = 1&#x27;b0; </code> | vector load ahead-valid 在本版本恒为 0。 |
| <!-- SRC-LINE:1383 -->L1383 | &nbsp; | 空行，用于分隔“下传 DC 与提前唤醒”中的逻辑块，提高源码可读性。 |
| <!-- SRC-LINE:1384 -->L1384 | <code>//-----------for timing--------------------------</code> | 原作者注释，说明“-----------for timing--------------------------”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:1385 -->L1385 | <code>//compare iid ahead for dc restart timing</code> | 原作者注释，说明“compare iid ahead for dc restart timing”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:1386 -->L1386 | <code>//compare the instruction in the entry is newer or older</code> | 原作者注释，说明“compare the instruction in the entry is newer or older”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:1387 -->L1387 | <code>// &amp;Instance(&quot;ct_rtu_compare_iid&quot;,&quot;x_lsu_ld_ag_compare_st_ag_iid&quot;); @1295</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:1388 -->L1388 | <code>ct_rtu_compare_iid  x_lsu_ld_ag_compare_st_ag_iid (</code> | 比较 store AG iid 与 load AG iid，生成 RAW 新旧关系信号。 |
| <!-- SRC-LINE:1389 -->L1389 | <code>  .x_iid0         (st_ag_iid[6:0]),</code> | 实例端口连接：子模块端口 `x_iid0` 连接本层信号/常量 `st_ag_iid[6:0]`。 |
| <!-- SRC-LINE:1390 -->L1390 | <code>  .x_iid0_older   (ld_ag_raw_new ),</code> | 实例端口连接：子模块端口 `x_iid0_older` 连接本层信号/常量 `ld_ag_raw_new`。 |
| <!-- SRC-LINE:1391 -->L1391 | <code>  .x_iid1         (ld_ag_iid[6:0])</code> | 实例端口连接：子模块端口 `x_iid1` 连接本层信号/常量 `ld_ag_iid[6:0]`。 |
| <!-- SRC-LINE:1392 -->L1392 | <code>);</code> | 结束当前子模块实例的端口连接。 |
| <!-- SRC-LINE:1393 -->L1393 | &nbsp; | 空行，用于分隔“下传 DC 与提前唤醒”中的逻辑块，提高源码可读性。 |
| <!-- SRC-LINE:1394 -->L1394 | <code>// &amp;Connect( .x_iid0         (st_ag_iid[6:0]         ), @1296</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:1395 -->L1395 | <code>//           .x_iid1         (ld_ag_iid[6:0]         ), @1297</code> | 原作者注释，说明“.x_iid1         (ld_ag_iid[6:0]         ), @1297”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:1396 -->L1396 | <code>//           .x_iid0_older   (ld_ag_raw_new          )); @1298</code> | 原作者注释，说明“.x_iid0_older   (ld_ag_raw_new          )); @1298”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:1397 -->L1397 | &nbsp; | 空行，用于分隔“下传 DC 与提前唤醒”中的逻辑块，提高源码可读性。 |

## 本地监控、LSIQ 与 IDU 接口

| 行号 | 原始代码 | 中文注释 |
|---:|---|---|
| <!-- SRC-LINE:1398 -->L1398 | <code>//==========================================================</code> | “本地监控、LSIQ 与 IDU 接口”的视觉分隔注释，不参与逻辑。 |
| <!-- SRC-LINE:1399 -->L1399 | <code>//              Interface to other module</code> | 原作者注释，说明“Interface to other module”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:1400 -->L1400 | <code>//==========================================================</code> | “本地监控、LSIQ 与 IDU 接口”的视觉分隔注释，不参与逻辑。 |
| <!-- SRC-LINE:1401 -->L1401 | <code>//-----------interface to cmit monitor----------------------</code> | 原作者注释，说明“-----------interface to cmit monitor----------------------”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:1402 -->L1402 | <code>//assign ld_ag_inst_wait_cmit_vld = ld_ag_inst_vld</code> | 原作者注释，说明“assign ld_ag_inst_wait_cmit_vld = ld_ag_inst_vld”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:1403 -->L1403 | <code>//                                  &amp;&amp;  ld_ag_atomic;</code> | 原作者注释，说明“&&  ld_ag_atomic;”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:1404 -->L1404 | <code>//-----------interface to local monitor---------------------</code> | 原作者注释，说明“-----------interface to local monitor---------------------”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:1405 -->L1405 | <code>assign ld_ag_lm_init_vld  = ld_ag_inst_vld</code> | atomic 指令已经 commit 时初始化 local monitor。 |
| <!-- SRC-LINE:1406 -->L1406 | <code>                            &amp;&amp;  ld_ag_atomic</code> | 延续“本地监控、LSIQ 与 IDU 接口”中的声明、实例连接或多行组合表达式；需与前后行合并阅读。 |
| <!-- SRC-LINE:1407 -->L1407 | <code>                            &amp;&amp;  ld_ag_cmit;</code> | 延续“本地监控、LSIQ 与 IDU 接口”中的声明、实例连接或多行组合表达式；需与前后行合并阅读。 |
| <!-- SRC-LINE:1408 -->L1408 | &nbsp; | 空行，用于分隔“本地监控、LSIQ 与 IDU 接口”中的逻辑块，提高源码可读性。 |
| <!-- SRC-LINE:1409 -->L1409 | <code>//==========================================================</code> | “本地监控、LSIQ 与 IDU 接口”的视觉分隔注释，不参与逻辑。 |
| <!-- SRC-LINE:1410 -->L1410 | <code>//        Generate restart/lsiq signal</code> | 原作者注释，说明“Generate restart/lsiq signal”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:1411 -->L1411 | <code>//==========================================================</code> | “本地监控、LSIQ 与 IDU 接口”的视觉分隔注释，不参与逻辑。 |
| <!-- SRC-LINE:1412 -->L1412 | <code>//-----------lsiq signal----------------</code> | 原作者注释，说明“-----------lsiq signal----------------”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:1413 -->L1413 | <code>assign ld_ag_mask_lsid[LSIQ_ENTRY-1:0]    = {LSIQ_ENTRY{ld_ag_inst_vld}}</code> | 连续组合赋值开始：驱动 `ld_ag_mask_lsid[LSIQ_ENTRY-1:0]`；完整右值可能延续到后续行，属于“本地监控、LSIQ 与 IDU 接口”。 |
| <!-- SRC-LINE:1414 -->L1414 | <code>                                            &amp;  ld_ag_lsid[LSIQ_ENTRY-1:0];</code> | 延续“本地监控、LSIQ 与 IDU 接口”中的声明、实例连接或多行组合表达式；需与前后行合并阅读。 |
| <!-- SRC-LINE:1415 -->L1415 | &nbsp; | 空行，用于分隔“本地监控、LSIQ 与 IDU 接口”中的逻辑块，提高源码可读性。 |
| <!-- SRC-LINE:1416 -->L1416 | <code>assign lsu_idu_ld_ag_wait_old_gateclk_en = ld_ag_atomic_no_cmit_restart_arb;</code> | atomic 未 commit restart 时向 IDU/LSIQ 提供 wait-old 门控。 |
| <!-- SRC-LINE:1417 -->L1417 | <code>assign lsu_idu_ld_ag_wait_old[LSIQ_ENTRY-1:0]  = ld_ag_mask_lsid[LSIQ_ENTRY-1:0]</code> | 连续组合赋值开始：驱动 `lsu_idu_ld_ag_wait_old[LSIQ_ENTRY-1:0]`；完整右值可能延续到后续行，属于“本地监控、LSIQ 与 IDU 接口”。 |
| <!-- SRC-LINE:1418 -->L1418 | <code>                                                 &amp; {LSIQ_ENTRY{ld_ag_atomic_no_cmit_restart_arb}};</code> | 延续“本地监控、LSIQ 与 IDU 接口”中的声明、实例连接或多行组合表达式；需与前后行合并阅读。 |
| <!-- SRC-LINE:1419 -->L1419 | &nbsp; | 空行，用于分隔“本地监控、LSIQ 与 IDU 接口”中的逻辑块，提高源码可读性。 |
| <!-- SRC-LINE:1420 -->L1420 | <code>//==========================================================</code> | “本地监控、LSIQ 与 IDU 接口”的视觉分隔注释，不参与逻辑。 |
| <!-- SRC-LINE:1421 -->L1421 | <code>//        for idu timing</code> | 原作者注释，说明“for idu timing”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:1422 -->L1422 | <code>//==========================================================</code> | “本地监控、LSIQ 与 IDU 接口”的视觉分隔注释，不参与逻辑。 |
| <!-- SRC-LINE:1423 -->L1423 | <code>assign lsu_idu_ag_pipe3_load_inst_vld  = ld_ag_inst_vld</code> | 为 IDU timing 生成普通 load 的提前有效。 |
| <!-- SRC-LINE:1424 -->L1424 | <code>                                         &amp;&amp; !ld_ag_inst_vfls</code> | 延续“本地监控、LSIQ 与 IDU 接口”中的声明、实例连接或多行组合表达式；需与前后行合并阅读。 |
| <!-- SRC-LINE:1425 -->L1425 | <code>                                         &amp;&amp; !cp0_lsu_da_fwd_dis</code> | 延续“本地监控、LSIQ 与 IDU 接口”中的声明、实例连接或多行组合表达式；需与前后行合并阅读。 |
| <!-- SRC-LINE:1426 -->L1426 | <code>                                         &amp;&amp; ld_ag_ahead_predict;</code> | 延续“本地监控、LSIQ 与 IDU 接口”中的声明、实例连接或多行组合表达式；需与前后行合并阅读。 |
| <!-- SRC-LINE:1427 -->L1427 | &nbsp; | 空行，用于分隔“本地监控、LSIQ 与 IDU 接口”中的逻辑块，提高源码可读性。 |
| <!-- SRC-LINE:1428 -->L1428 | <code>assign lsu_idu_ag_pipe3_preg_dup0[6:0] = ld_ag_preg[6:0];</code> | 连续组合赋值开始：驱动 `lsu_idu_ag_pipe3_preg_dup0[6:0]`；完整右值可能延续到后续行，属于“本地监控、LSIQ 与 IDU 接口”。 |
| <!-- SRC-LINE:1429 -->L1429 | <code>assign lsu_idu_ag_pipe3_preg_dup1[6:0] = ld_ag_preg_dup1[6:0];</code> | 连续组合赋值开始：驱动 `lsu_idu_ag_pipe3_preg_dup1[6:0]`；完整右值可能延续到后续行，属于“本地监控、LSIQ 与 IDU 接口”。 |
| <!-- SRC-LINE:1430 -->L1430 | <code>assign lsu_idu_ag_pipe3_preg_dup2[6:0] = ld_ag_preg_dup2[6:0];</code> | 连续组合赋值开始：驱动 `lsu_idu_ag_pipe3_preg_dup2[6:0]`；完整右值可能延续到后续行，属于“本地监控、LSIQ 与 IDU 接口”。 |
| <!-- SRC-LINE:1431 -->L1431 | <code>assign lsu_idu_ag_pipe3_preg_dup3[6:0] = ld_ag_preg_dup3[6:0];</code> | 连续组合赋值开始：驱动 `lsu_idu_ag_pipe3_preg_dup3[6:0]`；完整右值可能延续到后续行，属于“本地监控、LSIQ 与 IDU 接口”。 |
| <!-- SRC-LINE:1432 -->L1432 | <code>assign lsu_idu_ag_pipe3_preg_dup4[6:0] = ld_ag_preg_dup4[6:0];</code> | 连续组合赋值开始：驱动 `lsu_idu_ag_pipe3_preg_dup4[6:0]`；完整右值可能延续到后续行，属于“本地监控、LSIQ 与 IDU 接口”。 |
| <!-- SRC-LINE:1433 -->L1433 | &nbsp; | 空行，用于分隔“本地监控、LSIQ 与 IDU 接口”中的逻辑块，提高源码可读性。 |
| <!-- SRC-LINE:1434 -->L1434 | <code>assign lsu_idu_ag_pipe3_vload_inst_vld = ld_ag_inst_vld</code> | 为 IDU timing 生成 vector load 的提前有效。 |
| <!-- SRC-LINE:1435 -->L1435 | <code>                                         &amp;&amp; ld_ag_inst_vfls</code> | 延续“本地监控、LSIQ 与 IDU 接口”中的声明、实例连接或多行组合表达式；需与前后行合并阅读。 |
| <!-- SRC-LINE:1436 -->L1436 | <code>                                         &amp;&amp; !ld_ag_inst_vls</code> | 延续“本地监控、LSIQ 与 IDU 接口”中的声明、实例连接或多行组合表达式；需与前后行合并阅读。 |
| <!-- SRC-LINE:1437 -->L1437 | <code>                                         &amp;&amp; !cp0_lsu_da_fwd_dis</code> | 延续“本地监控、LSIQ 与 IDU 接口”中的声明、实例连接或多行组合表达式；需与前后行合并阅读。 |
| <!-- SRC-LINE:1438 -->L1438 | <code>                                         &amp;&amp; ld_ag_ahead_predict;</code> | 延续“本地监控、LSIQ 与 IDU 接口”中的声明、实例连接或多行组合表达式；需与前后行合并阅读。 |
| <!-- SRC-LINE:1439 -->L1439 | &nbsp; | 空行，用于分隔“本地监控、LSIQ 与 IDU 接口”中的逻辑块，提高源码可读性。 |
| <!-- SRC-LINE:1440 -->L1440 | <code>assign lsu_idu_ag_pipe3_vreg_dup0[6:0]      = {1&#x27;b0,ld_ag_vreg[5:0]};</code> | 连续组合赋值开始：驱动 `lsu_idu_ag_pipe3_vreg_dup0[6:0]`；完整右值可能延续到后续行，属于“本地监控、LSIQ 与 IDU 接口”。 |
| <!-- SRC-LINE:1441 -->L1441 | <code>assign lsu_idu_ag_pipe3_vreg_dup1[6:0]      = {1&#x27;b0,ld_ag_vreg_dup1[5:0]};</code> | 连续组合赋值开始：驱动 `lsu_idu_ag_pipe3_vreg_dup1[6:0]`；完整右值可能延续到后续行，属于“本地监控、LSIQ 与 IDU 接口”。 |
| <!-- SRC-LINE:1442 -->L1442 | <code>assign lsu_idu_ag_pipe3_vreg_dup2[6:0]      = {1&#x27;b0,ld_ag_vreg_dup2[5:0]};</code> | 连续组合赋值开始：驱动 `lsu_idu_ag_pipe3_vreg_dup2[6:0]`；完整右值可能延续到后续行，属于“本地监控、LSIQ 与 IDU 接口”。 |
| <!-- SRC-LINE:1443 -->L1443 | <code>assign lsu_idu_ag_pipe3_vreg_dup3[6:0]      = {1&#x27;b0,ld_ag_vreg_dup3[5:0]};</code> | 连续组合赋值开始：驱动 `lsu_idu_ag_pipe3_vreg_dup3[6:0]`；完整右值可能延续到后续行，属于“本地监控、LSIQ 与 IDU 接口”。 |

## 性能计数与模块结束

| 行号 | 原始代码 | 中文注释 |
|---:|---|---|
| <!-- SRC-LINE:1444 -->L1444 | <code>//==========================================================</code> | “性能计数与模块结束”的视觉分隔注释，不参与逻辑。 |
| <!-- SRC-LINE:1445 -->L1445 | <code>//        interface to hpcp</code> | 原作者注释，说明“interface to hpcp”；仅用于解释相邻 RTL，不参与综合。 |
| <!-- SRC-LINE:1446 -->L1446 | <code>//==========================================================</code> | “性能计数与模块结束”的视觉分隔注释，不参与逻辑。 |
| <!-- SRC-LINE:1447 -->L1447 | <code>assign lsu_hpcp_ld_cross_4k_stall  = ld_ag_inst_vld</code> | 生成跨 4 KiB stall 的性能事件脉冲。 |
| <!-- SRC-LINE:1448 -->L1448 | <code>                                     &amp;&amp;  ld_ag_already_cross_page_ldr_imme</code> | 延续“性能计数与模块结束”中的声明、实例连接或多行组合表达式；需与前后行合并阅读。 |
| <!-- SRC-LINE:1449 -->L1449 | <code>                                     &amp;&amp;  !ld_ag_stall_vld</code> | 延续“性能计数与模块结束”中的声明、实例连接或多行组合表达式；需与前后行合并阅读。 |
| <!-- SRC-LINE:1450 -->L1450 | <code>                                     &amp;&amp;  !ld_ag_utlb_miss</code> | 延续“性能计数与模块结束”中的声明、实例连接或多行组合表达式；需与前后行合并阅读。 |
| <!-- SRC-LINE:1451 -->L1451 | <code>                                     &amp;&amp;  !ld_ag_already_da;</code> | 延续“性能计数与模块结束”中的声明、实例连接或多行组合表达式；需与前后行合并阅读。 |
| <!-- SRC-LINE:1452 -->L1452 | <code>assign lsu_hpcp_ld_other_stall     = ld_ag_inst_vld</code> | 生成其他 stall 的性能事件，排除跨 4 KiB 与 uTLB miss。 |
| <!-- SRC-LINE:1453 -->L1453 | <code>                                     &amp;&amp;  !ld_ag_cross_4k</code> | 延续“性能计数与模块结束”中的声明、实例连接或多行组合表达式；需与前后行合并阅读。 |
| <!-- SRC-LINE:1454 -->L1454 | <code>                                     &amp;&amp;  ld_ag_stall_vld</code> | 延续“性能计数与模块结束”中的声明、实例连接或多行组合表达式；需与前后行合并阅读。 |
| <!-- SRC-LINE:1455 -->L1455 | <code>                                     &amp;&amp;  !ld_ag_utlb_miss</code> | 延续“性能计数与模块结束”中的声明、实例连接或多行组合表达式；需与前后行合并阅读。 |
| <!-- SRC-LINE:1456 -->L1456 | <code>                                     &amp;&amp;  !ld_ag_already_da;</code> | 延续“性能计数与模块结束”中的声明、实例连接或多行组合表达式；需与前后行合并阅读。 |
| <!-- SRC-LINE:1457 -->L1457 | &nbsp; | 空行，用于分隔“性能计数与模块结束”中的逻辑块，提高源码可读性。 |
| <!-- SRC-LINE:1458 -->L1458 | &nbsp; | 空行，用于分隔“性能计数与模块结束”中的逻辑块，提高源码可读性。 |
| <!-- SRC-LINE:1459 -->L1459 | <code>// &amp;ModuleEnd; @1363</code> | 源代码生成工具保留的指令/行号标记；不参与综合逻辑。 |
| <!-- SRC-LINE:1460 -->L1460 | <code>endmodule</code> | 结束 ct_lsu_ld_ag 模块定义。 |
| <!-- SRC-LINE:1461 -->L1461 | &nbsp; | 空行，用于分隔“性能计数与模块结束”中的逻辑块，提高源码可读性。 |
| <!-- SRC-LINE:1462 -->L1462 | &nbsp; | 空行，用于分隔“性能计数与模块结束”中的逻辑块，提高源码可读性。 |

## 阅读注意事项

1. `ld_ag_inst_vld` 是大多数数据/属性的总有效资格；若某个输出自身未门控，消费者仍应按对应 valid 采样。
2. MMU 接收 base VA，AG 在本地加入页内 offset；跨 4 KiB 必须依赖 replay 重新翻译。
3. DCACHE tag/data 阵列请求是投机的，不能等价为 load 已经可以提交。
4. `ld_ag_ahead_predict` 在当前版本恒为 1，后级必须具备完整取消/回放协议。
