#!/usr/bin/env node

import fs from "node:fs/promises";
import path from "node:path";
import { SpreadsheetFile, Workbook } from "@oai/artifact-tool";

const repoRoot = path.resolve(path.dirname(new URL(import.meta.url).pathname), "..");
const outputPath = process.argv[2] ? path.resolve(process.argv[2]) : path.join(repoRoot, "ld_ag_feature_list.xlsx");
const previewPath = process.argv[3] ? path.resolve(process.argv[3]) : path.join(repoRoot, "work", "feature_list_preview.png");

const headers = [
  "类功能点名称",
  "详细功能点名称",
  "功能点描述",
  "配置说明",
  "测试方法",
  "优先级",
  "源码位置",
  "预期结果/检查点",
];

const F = (category, name, description, config, method, priority, source, expected) =>
  [category, name, description, config, method, priority, source, expected];

const features = [
  F("复位与时钟", "AG valid 异步复位", "cpurst_b 拉低时清除 ld_ag_inst_vld。", "cpurst_b=0", "在 idle、issue、stall 三种状态随机拉低复位。", "P0", "L582-L591", "复位期间及释放前 valid=0；无虚假 DC 事务。"),
  F("复位与时钟", "flush 优先级", "flush 的清 valid 优先于 stall 和 RF 新发射。", "rtu_yy_xx_flush=1", "flush 分别与 stall/new issue 同周期组合。", "P0", "L584-L591", "下一周期 valid=0，旧指令不下传。"),
  F("复位与时钟", "数据门控时钟使能", "RF gateclk select 或 AG valid 使 ld_ag_clk 开启。", "cp0_yy_clk_en、cp0_lsu_icg_en", "检查 local/global/module enable 与 scan override。", "P1", "L551-L560", "接收或保持指令时数据寄存器获得时钟。"),
  F("复位与时钟", "控制/数据时钟一致性", "valid 使用 ctrl_ld_clk，数据使用 ld_ag_clk。", "时钟相位/门控契约", "门级/时序仿真覆盖使能边界与 reset release。", "P0", "L551-L560; L582; L626", "不存在 valid 更新而数据未捕获。"),
  F("复位与时钟", "未复位数据 X 传播", "base/offset 无 reset，空闲输出可能为 X。", "X-prop 开启", "复位释放后保持 idle，再发首条 load。", "P1", "L728-L751; L771-L777", "X 不导致有效请求、状态更新或 architectural event。"),

  F("流水控制", "RF 指令接收", "无 stall 且 RF valid 时捕获全部指令字段。", "idu_lsu_rf_pipe3_gateclk_sel=1", "随机所有输入字段并逐项比较 AG 寄存器。", "P0", "L626-L692", "下一 AG 周期字段一致。"),
  F("流水控制", "stall 保持", "stall 时 AG valid 和非 replay 数据保持。", "任一 stall 原因", "每类 stall 连续 1/2/5 周期，随机改变 RF 输入。", "P0", "L588-L591; L660-L692", "当前 iid/属性不被新 RF 数据覆盖。"),
  F("流水控制", "更老 RF 指令 mask stall", "更老 RF 指令可 mask 当前 AG 非原子 stall。", "iid 年龄比较", "覆盖普通 iid 与环回边界。", "P0", "L1321-L1336", "mask 时 stall_vld 清除，restart entry 选择正确。"),
  F("流水控制", "DC stage advance", "AG valid 且无任何 stall/restart 时产生 DC valid。", "所有流控输入", "逐一及组合注入 atomic/page/cache/MMU stall。", "P0", "L1298-L1301; L1342-L1343", "仅无阻塞时 ld_ag_dc_inst_vld=1。"),
  F("流水控制", "借用地址覆盖", "borrow_addr_vld 时 DC 地址选择 arbiter 地址。", "dcache_arb_ld_ag_borrow_addr_vld", "正常 PA 与借用地址设置不同模式。", "P1", "L1348-L1350", "mux 输出与 valid 指示匹配。"),

  F("地址生成", "普通立即数地址", "普通 load 用 sign-extended 12-bit offset。", "inst_ldr=0", "offset 取 0、1、0x7ff、0x800、0xfff。", "P0", "L732-L733; L747-L748", "VA 等于 base + 符号扩展 offset。"),
  F("地址生成", "LDR 寄存器 offset", "LDR 使用 src1 作为 64-bit offset。", "inst_ldr=1", "随机 src1，覆盖负数与大值。", "P0", "L734-L750", "VA 等于 base + 选定 src1 offset。"),
  F("地址生成", "LDR offset 高位零扩展", "off_0_extend 时 LDR offset 高 32 位清零。", "inst_ldr=1; off_0_extend=1", "src1 高位全 1，低位随机。", "P1", "L734-L737", "有效 offset 为 zero-extended 32-bit。"),
  F("地址生成", "one-hot shift", "offset 根据 shift one-hot 左移 0/1/2/3 位。", "shift=1/2/4/8", "四个合法编码 × 正负 offset。", "P0", "L713-L720; L789-L792", "VA 与参考模型完全一致。"),
  F("地址生成", "非法 shift", "全零/多热 shift 会得到 0 或多个移位结果 OR。", "非法输入负向测试", "遍历其余 12 个编码并检查断言。", "P1", "L789-L792", "协议断言失败或按已确认安全策略处理。"),
  F("地址生成", "split offset_plus", "首拍边界普通 load 可选择 sign-extended offset_plus。", "boundary_unmask=1; !secd; !LDR", "随机 base/offset/offset_plus 造成选择条件真假。", "P0", "L757-L765; L797-L808", "最终 VA 选择正确。"),
  F("地址生成", "64-bit 加法回绕", "VA 加法为 64-bit 模运算。", "无", "base 接近 0/2^64-1，offset 正负。", "P1", "L794-L808", "结果与 64-bit reference model 一致。"),
  F("地址生成", "VPN 输出", "VPN 取最终 VA 的 PA_WIDTH 范围内页号。", "PA_WIDTH=40", "随机 VA 页号与页内 offset。", "P1", "L810", "ld_ag_vpn=VA[39:12]。"),

  F("访问大小与对齐", "访问大小译码", "BYTE/HALF/WORD/DWORD 映射 size-minus-one 0/1/3/7。", "inst_size=00/01/10/11", "穷举四种 size。", "P0", "L842-L853", "ld_ag_access_size 正确。"),
  F("访问大小与对齐", "DC 访问大小编码", "size-minus-one 映射 DC code 0/1/2/3。", "四种标量 size", "穷举并检查输出。", "P1", "L857-L868", "ld_ag_dc_access_size 正确。"),
  F("访问大小与对齐", "自然对齐", "按 size 检查 VA 低 1/2/3 位。", "cp0_lsu_mm 任意", "size × VA[2:0] 穷举。", "P0", "L872-L887", "align/unalign 与 ISA 对齐规则一致。"),
  F("访问大小与对齐", "16-byte 边界检测", "起始 nibble + size-minus-one 产生进位即跨界。", "普通 load", "size × VA[3:0] 穷举。", "P0", "L903-L909", "boundary_unmask 与参考模型一致。"),
  F("访问大小与对齐", "第二拍 boundary 保持", "secd 对普通 load 强制 boundary 输出。", "secd=1", "构造低位本身不跨界的第二拍。", "P1", "L907-L909", "ld_ag_boundary 保持为 1。"),

  F("字节掩码与旋转", "高侧全掩码", "从起始 byte 到 16-byte 窗口末端置 1。", "VA[3:0]", "穷举 16 个起点。", "P0", "L915-L937", "掩码等于 16'hffff << start。"),
  F("字节掩码与旋转", "低侧全掩码", "从 byte0 到访问结束 byte 置 1。", "end=VA+size-1", "穷举 end nibble。", "P0", "L940-L962", "掩码等于 (1<<(end+1))-1。"),
  F("字节掩码与旋转", "非边界精确掩码", "高侧与低侧全掩码相与。", "boundary=0", "size × start 穷举。", "P0", "L964-L975", "仅访问范围内 byte 为 1。"),
  F("字节掩码与旋转", "边界首/第二拍掩码", "首拍选低侧跨界掩码，第二拍选高侧掩码。", "boundary=1; secd=0/1", "跨界 size/start 全覆盖。", "P0", "L967-L985", "两拍掩码合并覆盖完整访问且无重叠错误。"),
  F("字节掩码与旋转", "旋转选择", "rot_sel 等于原始 VA 低 4 位。", "无", "遍历 VA[3:0]。", "P1", "L1030", "ld_ag_dc_rot_sel=VA[3:0]。"),

  F("MMU 与物理地址", "MMU request valid", "lsu_mmu_va0_vld 等于 AG valid。", "无", "issue/idle/stall/flush 周期检查。", "P0", "L1035", "严格相等。"),
  F("MMU 与物理地址", "MMU base VA", "MMU 翻译 base，而页内 offset 在 AG 本地加入。", "跨页重放契约", "同页 offset 和跨 4 KiB offset 分别测试。", "P0", "L1036; L1065", "同页直接拼接；跨页先 replay 再翻译。"),
  F("MMU 与物理地址", "MMU abort 原因", "跨页、atomic 未 commit、cache stall、misalign、flush 均 abort。", "各原因", "每原因单独及组合激励。", "P0", "L1038-L1042", "lsu_mmu_abort0 OR 逻辑正确。"),
  F("MMU 与物理地址", "PA 拼接", "PA={MMU PPN, final VA[11:0]}。", "PA_WIDTH=40", "随机 PPN 和 offset。", "P0", "L1047; L1065", "40-bit PA 与参考值一致。"),
  F("MMU 与物理地址", "页属性有效性", "CA/SO 由 pa_vld 门控，BUF/SEC/SH 直接传递。", "pa_vld=0/1", "随机属性并切换 pa_vld。", "P1", "L1049-L1054", "消费者只在 valid 时采样；门控差异符合规格。"),
  F("MMU 与物理地址", "uTLB miss 伴随语义", "pa_vld=0 时 utlb_miss=1，包括 idle。", "与 inst_vld 合用", "idle、真实 miss、page fault 三种场景。", "P1", "L1056", "只有 valid 指令的 miss 被计为事件。"),
  F("MMU 与物理地址", "page fault/pa_vld 时序", "页故障输出还要求 pa_vld。", "MMU 接口契约", "page_fault × pa_vld 四组合。", "P0", "L1217-L1218", "符合已确认 MMU fault-valid 协议。"),

  F("DCACHE 接口", "投机 tag 请求", "AG valid 且 dcache enable 时发 tag req，不等待 MMU/异常。", "cp0_lsu_dcache_en", "pa_vld=0、page fault、non-CA 时观察。", "P0", "L1124-L1138", "允许读阵列但不得产生可见副作用。"),
  F("DCACHE 接口", "tag index", "tag index=PA[14:6]。", "无", "随机 PA。", "P1", "L1138", "索引位完全匹配。"),
  F("DCACHE 接口", "bank enable 普通访问", "按访问覆盖的 32-bit bank 生成 4-bit enable。", "boundary=0", "起止 bank 组合穷举。", "P0", "L1145-L1172", "启用连续且恰当的 bank。"),
  F("DCACHE 接口", "bank enable 边界访问", "首/第二拍按 end/start bank 生成 enable。", "boundary=1; secd=0/1", "所有跨界 start/size。", "P0", "L1161-L1168", "两拍 bank enable 正确。"),
  F("DCACHE 接口", "边界加速全 bank", "acclr_en 时强制 4'b1111。", "cp0_lsu_cb_aclr_dis=0", "可/不可加速条件交叉。", "P1", "L1175-L1176", "加速时两半阵列全部 bank 请求。"),
  F("DCACHE 接口", "data index 低/高半", "low_idx=PA[14:4]，high_idx 翻转 PA[4]。", "无", "PA[4] 取 0/1，其他位随机。", "P0", "L1189-L1190", "两个索引指向相邻 16-byte 块。"),
  F("DCACHE 接口", "cache backpressure", "arbiter 未选中时生成 dcache stall。", "dcache_arb_ag_ld_sel", "连续拒绝后接受。", "P0", "L1277-L1284", "AG 保持且只下传一次。"),

  F("边界加速", "预资格", "boundary、同页、功能开启、首拍、dcache enable 等形成 acclr_en。", "cp0_lsu_cb_aclr_dis", "逐位翻转每个 qualifier。", "P0", "L1072-L1078", "预资格布尔表达式正确。"),
  F("边界加速", "真实 DC 使能", "预资格外还要求 pa_vld 和 cacheable。", "MMU 结果", "pa_vld × page_ca。", "P0", "L1081-L1083", "ld_ag_dc_acclr_en 仅合法时为 1。"),
  F("边界加速", "load valid 分类一致性", "load_inst_vld 使用预资格而非真实 DC 使能。", "pa_vld/page_ca", "boundary × acclr_en × dc_acclr_en 交叉。", "P0", "L1358-L1361", "后级 split/replay 无漏处理。"),

  F("异常", "普通 load misalign", "MM 模式关闭时普通 load 不对齐立即报错。", "cp0_lsu_mm=0", "size × 低地址位。", "P0", "L1204-L1208", "misalign_no_page 与参考规则一致。"),
  F("异常", "atomic misalign", "atomic 不对齐始终进入 no-page misalign。", "atomic=1", "LR/LDAMO × size × 地址。", "P0", "L1204-L1208", "无需 MMU 属性即可报错。"),
  F("异常", "SO misalign", "普通 load 在 SO 页面且不对齐时产生 with-page misalign。", "cp0_lsu_mm=1; page_so=1", "pa_vld × SO × align。", "P0", "L1211-L1214", "仅合法 MMU 返回周期置位。"),
  F("异常", "LDAMO non-cacheable", "原子 load/AMO 访问 non-cacheable 页产生专用异常。", "atomic; inst_type=00", "page_ca=0/1，pa_vld=0/1。", "P0", "L1221-L1223", "专用异常精确，且无内存副作用。"),
  F("异常", "聚合异常完整性", "expt_vld 不包含 LDAMO non-CA 专用异常。", "下级异常协议", "追踪 AG-DC-DA-WB 所有异常消费者。", "P0", "L1238-L1241", "专用异常不会因聚合信号缺失而丢失。"),
  F("异常", "page fault", "pa_vld 与 page_fault 同时成立时输出页故障。", "MMU fault-valid 协议", "真实 refill fault/VA illegal。", "P0", "L1217-L1218", "精确异常 iid 和地址正确。"),

  F("stall/restart", "atomic 等待 commit", "atomic valid 且三个 commit port 均未命中时 restart。", "RTU commit0/1/2", "错误 iid、各端口正确 iid、同时命中。", "P0", "L1109-L1119; L1247-L1249", "命中前保持，命中后释放。"),
  F("stall/restart", "跨 4 KiB 检测", "页内加法进位或 offset 高位非法符号扩展表示跨页。", "offset/shift/offset_plus", "围绕 0x000/0xfff 的定向与随机。", "P0", "L1256-L1271", "与 64-bit 地址页号比较等价。"),
  F("stall/restart", "LDR 边界第二拍 stall", "LDR 第一拍 boundary 且未记录已重放时触发 secd stall。", "inst_ldr=1", "跨 16-byte 同页/跨页两类。", "P0", "L1273-L1282", "只触发一次，offset 注入 0x10。"),
  F("stall/restart", "stall 优先级", "atomic > cross-page/LDR > dcache > MMU。", "多原因同时", "所有两两组合与四原因同发。", "P0", "L1287-L1316", "仲裁和 base/offset replay 动作符合优先级。"),
  F("stall/restart", "空闲 MMU stall 注入", "未门控 stall0 可能制造幽灵 valid。", "负向接口测试", "AG idle、无 RF issue 时强制 stall0=1。", "P0", "L582-L591; L1285", "接口断言阻止该条件，或设计修复后不产生 valid。"),
  F("stall/restart", "LSIQ wait-old", "atomic 未 commit 时用当前 lsid 生成 wait-old bitmap。", "atomic restart", "随机 lsid bitmap。", "P1", "L1413-L1418", "输出仅在 atomic restart 时包含正确 entry。"),

  F("提前执行与转发", "ahead predict 常 1", "当前版本对所有候选 load 给出正预测。", "无", "cache/TLB/异常/flush 误预测取消测试。", "P0", "L1355-L1357", "依赖者不会消费无效数据。"),
  F("提前执行与转发", "标量 load ahead", "非 vector、非 boundary、未禁用 forwarding 时置位。", "cp0_lsu_da_fwd_dis", "所有 qualifier 逐项翻转。", "P0", "L1364-L1368; L1423-L1426", "ahead valid 布尔条件正确。"),
  F("提前执行与转发", "forward bypass", "支持大小、非 vector-memory、非 boundary 时允许 bypass。", "访问大小", "四种 size × boundary × vector。", "P1", "L1089-L1104", "ld_ag_dc_fwd_bypass_en 正确。"),
  F("提前执行与转发", "vector ahead 裁剪", "DC vector ahead 输出恒为 0。", "本版本功能裁剪", "静态检查。", "P2", "L1382", "恒 0，覆盖目标标记为不可达。"),

  F("寄存器与标识", "iid 提交匹配", "三个 RTU commit 端口的 valid+iid 与当前 iid 比较。", "commit ports", "逐端口、错误 iid、同时命中。", "P0", "L1109-L1119", "任一正确端口使 ld_ag_cmit=1。"),
  F("寄存器与标识", "preg duplicate", "五路 preg 输出保持相同目的寄存器。", "无", "随机 preg。", "P2", "L644-L648; L676-L680; L1428-L1432", "所有 duplicate 一致。"),
  F("寄存器与标识", "vreg bit6 截断", "输入 7 位 vreg 只保存低 6 位，输出 bit6 补 0。", "bit6 契约", "输入 bit6=0/1、低位相同。", "P0", "L650-L653; L682-L685; L1440-L1443", "确认 bit6 保留为 0；否则暴露别名。"),
  F("寄存器与标识", "RAW iid 比较", "比较 store AG 与 load AG iid，生成 ld_ag_raw_new。", "iid age wrap", "随机与环回边界。", "P1", "L1388-L1392", "极性与下游契约一致。"),

  F("性能与可达性", "cross-4K stall 事件", "已跨页重放完成且非 miss/already-DA 时计数。", "HPCP", "单次跨页及连续 backpressure。", "P2", "L1447-L1451", "每事务按定义产生一次事件。"),
  F("性能与可达性", "other stall 事件", "非 cross-4K 的 stall 且非 uTLB miss/already-DA。", "HPCP", "cache/MMU/atomic 等 stall 分类。", "P2", "L1452-L1456", "计数分类无重复/遗漏。"),
  F("性能与可达性", "裁剪功能静态检查", "vector mask、FOF、VMB merge 和 vector ahead 在本版本不可达。", "无", "lint/形式常量传播。", "P2", "L832-L835; L986-L1027; L1382", "恒定输出与 spec 一致，覆盖不报假洞。"),
];

const workbook = Workbook.create();
const sheet = workbook.worksheets.add("功能点清单");
sheet.showGridLines = false;
sheet.mergeCells("A1:H1");
sheet.getRange("A1").values = [["CT LSU Load Address Generation - Verification Feature List"]];
sheet.getRange("A1:H1").format = {
  fill: "#17365D",
  font: { bold: true, color: "#FFFFFF", size: 18 },
  horizontalAlignment: "center",
  verticalAlignment: "center",
};
sheet.getRange("A1:H1").format.rowHeight = 34;

sheet.mergeCells("A2:H2");
sheet.getRange("A2").values = [[
  `RTL 基线：ct_lsu_ld_ag.v | 功能点 ${features.length} 项 | 生成日期：2026-07-11 | P0=关键功能/风险，P1=重要，P2=补充`,
]];
sheet.getRange("A2:H2").format = {
  fill: "#D9EAF7",
  font: { color: "#17365D", size: 10 },
  horizontalAlignment: "center",
  verticalAlignment: "center",
  wrapText: true,
};
sheet.getRange("A2:H2").format.rowHeight = 30;

sheet.getRange("A4:H4").values = [headers];
sheet.getRange(`A5:H${features.length + 4}`).values = features;
const table = sheet.tables.add(`A4:H${features.length + 4}`, true, "LdAgFeatureTable");
table.style = "TableStyleMedium2";
table.showFilterButton = true;
table.showBandedRows = true;

sheet.getRange(`A4:H${features.length + 4}`).format = {
  font: { name: "Microsoft YaHei", size: 9 },
  verticalAlignment: "top",
};
sheet.getRange("A4:H4").format = {
  fill: "#2F5597",
  font: { bold: true, color: "#FFFFFF", name: "Microsoft YaHei", size: 10 },
  horizontalAlignment: "center",
  verticalAlignment: "center",
  wrapText: true,
  borders: { preset: "outside", style: "medium", color: "#17365D" },
};
sheet.getRange("A4:H4").format.rowHeight = 30;
sheet.getRange(`A5:H${features.length + 4}`).format.wrapText = true;
sheet.getRange(`A5:H${features.length + 4}`).format.rowHeight = 62;
sheet.getRange(`F5:F${features.length + 4}`).format.horizontalAlignment = "center";
sheet.getRange(`G5:G${features.length + 4}`).format.horizontalAlignment = "center";

const widths = [18, 24, 39, 27, 47, 10, 22, 40];
for (let col = 0; col < widths.length; col += 1) {
  sheet.getRangeByIndexes(0, col, features.length + 4, 1).format.columnWidth = widths[col];
}

const categoryColors = {
  "复位与时钟": "#D9EAD3",
  "流水控制": "#CFE2F3",
  "地址生成": "#FFF2CC",
  "访问大小与对齐": "#FCE5CD",
  "字节掩码与旋转": "#EAD1DC",
  "MMU 与物理地址": "#D0E0E3",
  "DCACHE 接口": "#C9DAF8",
  "边界加速": "#F9CB9C",
  "异常": "#F4CCCC",
  "stall/restart": "#D9D2E9",
  "提前执行与转发": "#B6D7A8",
  "寄存器与标识": "#D9EAD3",
  "性能与可达性": "#E6E6E6",
};
for (let i = 0; i < features.length; i += 1) {
  const row = i + 5;
  sheet.getRange(`A${row}`).format = {
    fill: categoryColors[features[i][0]] ?? "#E6E6E6",
    font: { bold: true, color: "#17365D", name: "Microsoft YaHei", size: 9 },
    verticalAlignment: "top",
    wrapText: true,
  };
  const priority = features[i][5];
  const priorityFill = priority === "P0" ? "#F4CCCC" : priority === "P1" ? "#FCE5CD" : "#D9EAD3";
  sheet.getRange(`F${row}`).format = {
    fill: priorityFill,
    font: { bold: true, color: priority === "P0" ? "#990000" : "#333333" },
    horizontalAlignment: "center",
    verticalAlignment: "center",
  };
}

sheet.freezePanes.freezeRows(4);
sheet.freezePanes.freezeColumns(2);

await fs.mkdir(path.dirname(outputPath), { recursive: true });
await fs.mkdir(path.dirname(previewPath), { recursive: true });

const keyInspect = await workbook.inspect({
  kind: "table",
  range: `功能点清单!A1:H12`,
  include: "values,formulas",
  tableMaxRows: 12,
  tableMaxCols: 8,
  maxChars: 8000,
});
console.log(keyInspect.ndjson);
const errors = await workbook.inspect({
  kind: "match",
  searchTerm: "#REF!|#DIV/0!|#VALUE!|#NAME\\?|#N/A",
  options: { useRegex: true, maxResults: 100 },
  summary: "final formula error scan",
});
console.log(errors.ndjson);

const preview = await workbook.render({
  sheetName: "功能点清单",
  range: `A1:H${features.length + 4}`,
  scale: 1.2,
  format: "png",
});
await fs.writeFile(previewPath, new Uint8Array(await preview.arrayBuffer()));

const xlsx = await SpreadsheetFile.exportXlsx(workbook);
await xlsx.save(outputPath);
console.log(JSON.stringify({ outputPath, previewPath, featureCount: features.length }));
