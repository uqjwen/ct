#!/usr/bin/env python3
"""Build reviewed interaction-2.1 LSU module plans and standalone harnesses."""

from __future__ import annotations

import argparse
import csv
import json
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import Mapping


REPO_ROOT = Path(__file__).resolve().parents[3]
if str(REPO_ROOT) not in sys.path:
    sys.path.insert(0, str(REPO_ROOT))

from verif.common.tools.gen_env import generate
from verif.common.tools.rtl_ports import Port, parse_module_ports
from verif.common.tools.scenario_contract import DETAIL_COLUMNS


@dataclass(frozen=True)
class Feature:
    title: str
    testcase: str
    checker: str
    coverage: str
    priority: str
    drive: tuple[str, ...]
    observe: tuple[str, ...]
    trigger: str
    expected: str
    closure: str
    result: str = "BLOCKED_NO_VCS"


@dataclass(frozen=True)
class Environment:
    name: str
    prefix: str
    source: str
    feature_doc: str
    runbook: str
    clock: str
    reset: str
    parameters: Mapping[str, object]
    idle_overrides: Mapping[str, object]
    declared_stubs: tuple[str, ...]
    production_sources: tuple[str, ...]
    features: tuple[Feature, ...]
    doc_tokens: tuple[str, ...] = ()


DC_FEATURES = (
    Feature("EX1到EX2 owner锁存", "tc_dc_ex1_ex2_owner", "CHK_DC_FP01_OWNER", "COV_DC_FP01_OWNER", "P0", ("lag_ldc_ex1_inst_vld", "lag0_ex1_iid"), ("ldc_lda_ex2_inst_vld", "ldc_ex2_iid"), "当 `lag_ldc_ex1_inst_vld=1` 且无flush时", "则 C1 `ldc_lda_ex2_inst_vld=1` 且 `ldc_ex2_iid=lag0_ex1_iid`", "每个accept仅产生一个同IID的EX2 owner"),
    Feature("borrow valid与payload gate", "tc_dc_borrow_owner", "CHK_DC_FP02_BORROW_GATE", "COV_DC_FP02_BORROW", "P0", ("dcache_arb_ldc_borrow_vld", "dcache_arb_ldc_borrow_vld_gate"), ("ldc_ex2_borrow_vld", "ldc_lda_ex2_borrow_vb"), "当 `dcache_arb_ldc_borrow_vld=1` 且 `dcache_arb_ldc_borrow_vld_gate=1` 时", "则 C1 `ldc_ex2_borrow_vld=1` 且borrow payload来自同一请求", "valid-only负向注入必须触发gate合同检查"),
    Feature("四路D-cache tag命中", "tc_dc_tag_way", "CHK_DC_FP03_HIT_ONEHOT", "COV_DC_FP03_HIT_WAY", "P0", ("lag_ldc_ex1_inst_vld", "cp0_lsu_dcache_en", "dcache_lsu_ld_tag_dout"), ("ldc_hit_way", "ldc_lda_ex2_dcache_hit"), "当 `lag_ldc_ex1_inst_vld=1` 且 `cp0_lsu_dcache_en=1` 时", "则 C1 `ldc_hit_way` 必须满足onehot0且 `ldc_lda_ex2_dcache_hit` 等于其归约或", "0/1路命中合法，2至4路命中必须被检测"),
    Feature("unit-stride way保存", "tc_dc_unit_stride_way", "CHK_DC_FP04_US_WAY", "COV_DC_FP04_US_WAY", "P0", ("lag_ldc_ex1_inst_vld", "lag_ldc_ex1_inst_us", "lag_ldc_ex1_us_way"), ("ldc_lda_ex2_settle_way", "ldc_lda_ex2_inst_us"), "当 `lag_ldc_ex1_inst_us=1` 且 `lag_ldc_ex1_us_way` 为one-hot时", "则 C1 `ldc_lda_ex2_settle_way` 与输入way编码一致且 `ldc_lda_ex2_inst_us=1`", "四way后接scalar不得粘连旧way"),
    Feature("四区byte与reg-byte mask", "tc_dc_byte_masks", "CHK_DC_FP05_MASK_PASS", "COV_DC_FP05_MASK", "P1", ("lag_ldc_ex1_inst_vld", "lag_ldc_ex1_bytes_vld", "lag_ldc_ex1_bytes_vld1", "lag_ldc_ex1_bytes_vld2", "lag_ldc_ex1_bytes_vld3"), ("ldc_lda_ex2_bytes_vld", "ldc_lda_ex2_bytes_vld1", "ldc_lda_ex2_bytes_vld2", "ldc_lda_ex2_bytes_vld3"), "当 `lag_ldc_ex1_inst_vld=1` 且四区mask使用互异花纹时", "则 C1 `ldc_lda_ex2_bytes_vld` 至bytes_vld3逐区保持原花纹", "适用mask逐bit保真，非US不得消费高区旧值"),
    Feature("LQ create资格与指针", "tc_dc_lq_create", "CHK_DC_FP06_LQ_ACCEPT", "COV_DC_FP06_LQ", "P0", ("lag_ldc_ex1_inst_vld", "lq_ldc_ex2_full", "lq_ldc_create_entry"), ("ldc_lq_ex2_create_vld", "ldc_lda_ex2_lq_entry"), "当 `lag_ldc_ex1_inst_vld=1` 且 `lq_ldc_ex2_full=0` 时", "则 `ldc_lq_ex2_create_vld=1` 且 `ldc_lda_ex2_lq_entry=lq_ldc_create_entry`", "accept对应唯一entry，full或flush时不创建"),
    Feature("LQ full与TLB busy restart", "tc_dc_restart", "CHK_DC_FP07_RESTART_BLOCK", "COV_DC_FP07_RESTART", "P0", ("lag_ldc_ex1_inst_vld", "lq_ldc_ex2_full", "mmu_lsu_tlb_busy"), ("ldc_lda_ex2_inst_vld", "ldc_idu_ex2_lq_full", "ldc_idu_ex2_tlb_busy"), "当 `lq_ldc_ex2_full=1` 或 `mmu_lsu_tlb_busy=1` 命中live owner时", "则 `ldc_lda_ex2_inst_vld=0` 且对应restart原因输出为1", "每个原因及两两交叉均只产生一次restart"),
    Feature("异常mask与extra传递", "tc_dc_exception", "CHK_DC_FP08_EXCEPTION", "COV_DC_FP08_EXCEPTION", "P0", ("lag_ldc_ex1_inst_vld", "lag_ldc_ex1_expt_vld", "lag_ldc_ex1_expt_page_fault"), ("ldc_lda_ex2_expt_vld_except_access_err", "ldc_lda_ex2_expt_access_fault_extra"), "当 `lag_ldc_ex1_expt_vld=1` 随live owner进入DC时", "则 C1 `ldc_lda_ex2_expt_vld_except_access_err=1` 且异常owner不变", "PF/misalign/AF每个子类不丢失不重复"),
    Feature("SQ与WMB forward元数据", "tc_dc_forward", "CHK_DC_FP09_FWD_OWNER", "COV_DC_FP09_FWD", "P1", ("lag_ldc_ex1_inst_vld", "sq_ldc_ex2_fwd_req", "wmb_ldc_fwd_req"), ("ldc_lda_ex2_fwd_sq_vld", "ldc_lda_ex2_fwd_wmb_vld", "ldc_lda_ex2_fwd_bytes_vld"), "当 `sq_ldc_ex2_fwd_req=1` 且 `wmb_ldc_fwd_req=0` 时", "则 `ldc_lda_ex2_fwd_sq_vld=1`、`ldc_lda_ex2_fwd_wmb_vld=0` 且byte mask属于SQ owner", "SQ/WMB互异花纹不得串source"),
    Feature("DC到DA payload分流", "tc_dc_da_transfer", "CHK_DC_FP10_DA_PAYLOAD", "COV_DC_FP10_DA", "P0", ("lag_ldc_ex1_inst_vld", "lag0_ex1_iid", "lag_ldc_ex1_addr0"), ("ldc_lda_ex2_inst_vld", "ldc_ex2_iid", "ldc_ex2_addr0"), "当 `lag_ldc_ex1_inst_vld=1` 被DC接受时", "则 C1 `ldc_lda_ex2_inst_vld=1` 且IID、地址payload hash与原owner一致", "inst与borrow back-to-back时每次accept只转移一个owner"),
    Feature("debug地址采集脉冲", "tc_dc_debug_pulse", "CHK_DC_FP11_DTU_PULSE", "COV_DC_FP11_DTU", "P1", ("lag_ldc_ex1_inst_vld", "ld_ag_dtu_vld", "ld_ag_dtu_va"), ("ld_dc_dtu_addr_vld", "ld_dc_dtu_addr"), "当 `ld_ag_dtu_vld=1` 随live load进入时", "则 C1 `ld_dc_dtu_addr_vld=1` 且 `ld_dc_dtu_addr=ld_ag_dtu_va`，C2必须回到0", "debug/normal/debug只产生两个单拍有效脉冲"),
    Feature("clock reset与scan覆盖", "tc_dc_clock_reset", "CHK_DC_FP12_CLOCK_RESET", "COV_DC_FP12_CLOCK", "P1", ("lag_ldc_ex1_inst_vld", "cp0_lsu_icg_en", "pad_yy_icg_scan_en"), ("ldc_lda_ex2_inst_vld", "ldc_ex2_full_gateclk_en"), "当 `cp0_lsu_icg_en=0`、`pad_yy_icg_scan_en=1` 且owner有效时", "则scan路径允许状态捕获并使 `ldc_lda_ex2_inst_vld=1`，reset低时所有valid为0", "ICG on/off/scan/reset边界均无X或幽灵owner"),
)


CONFIGS = {
    "xx_lsu_ld_dc": Environment(
        name="xx_lsu_ld_dc",
        prefix="DC",
        source="srcs/xx_lsu_ld_dc.sv",
        feature_doc="doc-dc/xx_lsu_ld_dc_feature_test_plan.md",
        runbook="doc-dc/xx_lsu_ld_dc_vcs_verification.md",
        clock="forever_cpuclk",
        reset="cpurst_b",
        parameters={"VB_DATA_ENTRY": 3, "LQENTRY": 48, "LSIQENTRY": 12, "VMBENTRY": 8, "PC_LEN": 15, "IID_WIDTH": 7, "VREG": 6, "PREG": 7},
        idle_overrides={"ctrl_ld_clk": None, "cp0_lsu_icg_en": "1'b1", "cp0_lsu_dcache_en": "1'b1", "lsu_dcache_ld_xx_gwen": "'1"},
        declared_stubs=("gated_clk_cell", "xx_lsu_compare_iid"),
        production_sources=(),
        features=DC_FEATURES,
    ),
}


FEATURE_COLUMNS = (
    "feature_id", "feature", "testcase", "checker", "coverage", "priority", "closure", "result"
)


def _write(path: Path, text: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(text.rstrip() + "\n", encoding="utf-8")


def _write_csv(path: Path, columns: tuple[str, ...], rows: list[dict[str, str]]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8", newline="") as stream:
        writer = csv.DictWriter(stream, fieldnames=columns, quoting=csv.QUOTE_ALL, lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)


def _feature_rows(config: Environment) -> list[dict[str, str]]:
    return [
        {
            "feature_id": f"{config.prefix}-FP-{index:02d}",
            "feature": feature.title,
            "testcase": feature.testcase,
            "checker": feature.checker,
            "coverage": feature.coverage,
            "priority": feature.priority,
            "closure": feature.closure,
            "result": feature.result,
        }
        for index, feature in enumerate(config.features, 1)
    ]


def _scenario_variants(config: Environment, index: int, feature: Feature) -> list[dict[str, str]]:
    feature_id = f"{config.prefix}-FP-{index:02d}"
    primary_drive = feature.drive[0]
    primary_observe = feature.observe[0]
    common_observe = "ldc_lda_ex2_inst_vld" if config.prefix == "DC" else primary_observe
    templates = (
        ("名义accept", "复位释放、无flush且所有非目标输入idle", feature.drive, "C0: 驱动名义输入；C1: 采样目标输出", feature.trigger, feature.observe, feature.expected, feature.closure),
        ("连续两拍保持", "先建立同一owner并施加两拍合法反压", feature.drive, "C0: 建立owner；C1: 首次采样；C2: 保持输入再次采样", f"当 `{primary_drive}=1` 且同一owner连续保持两拍时", feature.observe, f"则 C1至C2 `{primary_observe}` 保持二态且只归属于同一owner", "两拍保持期间payload hash和owner均不漂移"),
        ("竞争与优先级", "目标请求与次级来源同拍，二者payload使用互异花纹", feature.drive, "C0: 同拍驱动竞争来源；C1: 采样winner；C2: 检查loser未被消费", f"当 `{primary_drive}=1` 与同级竞争条件同拍成立时", feature.observe, f"则 C1 `{primary_observe}` 只反映文档定义的winner且不含X", "winner唯一，loser payload零次误消费"),
        ("full flush交叉", "先建立live owner，再在转移边界施加full flush", tuple(dict.fromkeys((*feature.drive, "rtu_lsu_flush_fe"))), "C0: 建立owner；C1: full flush=1；C2: 撤销后采样", f"当 `{primary_drive}=1` 与 `rtu_lsu_flush_fe=1` 在owner窗口交叉时", tuple(dict.fromkeys((*feature.observe, common_observe))), f"则 C2 `{common_observe}=0` 且 `{primary_observe}` 不得产生被flush owner的新副作用", "flush后的completion/create/forward计数均不增加"),
        ("边界和延迟响应", "目标字段取全零、全一和边界花纹，响应分别延迟0/1/N拍", feature.drive, "C0: 驱动边界花纹；C1: 0拍采样；C2: 1拍采样；C3: N拍后采样", f"当 `{primary_drive}=1` 且目标payload取边界值时", feature.observe, f"则 C1至C3 `{primary_observe}` 仅在所属accept窗口有效且 `$isunknown({primary_observe})=0`", "0/1/N延迟与零/最大值交叉全部命中"),
        ("owner立即复用", "完成owner A后下一合法拍复用资源给互异owner B", tuple(dict.fromkeys((*feature.drive, "lag0_ex1_iid"))) if config.prefix == "DC" else feature.drive, "C0: 驱动owner A；C1: accept；C2: 驱动owner B；C3: 采样", f"当 `{primary_drive}=1` 的资源在下一合法拍被新owner复用时", feature.observe, f"则 C3 `{primary_observe}` 只对应owner B，旧owner不得迟到修改", "scoreboard generation递增且旧响应零次命中新owner"),
    )
    rows = []
    for scenario_index, item in enumerate(templates, 1):
        name, setup, drive, cycles, trigger, observe, expected, closure = item
        rows.append(
            {
                "scenario_id": f"{feature_id}-S{scenario_index:02d}",
                "feature_id": feature_id,
                "scenario": name,
                "testcase": feature.testcase,
                "priority": feature.priority,
                "setup": setup,
                "drive_signals": "|".join(drive),
                "cycle_sequence": cycles,
                "trigger_condition": trigger,
                "expected_signals": "|".join(observe),
                "expected_result": expected,
                "checker": feature.checker,
                "coverage": feature.coverage,
                "closure": closure,
                "result": feature.result,
            }
        )
    return rows


def _detail_rows(config: Environment) -> list[dict[str, str]]:
    return [
        row
        for index, feature in enumerate(config.features, 1)
        for row in _scenario_variants(config, index, feature)
    ]


def _manifest(config: Environment) -> dict[str, object]:
    return {
        "env_name": config.name,
        "dut_module": config.name,
        "dut_source": config.source,
        "feature_doc": config.feature_doc,
        "runbook": config.runbook,
        "feature_prefix": config.prefix,
        "expected_features": len(config.features),
        "min_scenarios_per_feature": 6,
        "clock": config.clock,
        "reset": config.reset,
        "parameters": dict(config.parameters),
        "idle_overrides": dict(config.idle_overrides),
        "production_sources": list(config.production_sources),
        "declared_stubs": list(config.declared_stubs),
        "stub_results": {name: "PENDING_FULL_CHIP" for name in config.declared_stubs},
    }


def _width(port: Port) -> str:
    return f" {port.width}" if port.width else ""


def _assertions(config: Environment, port_map: Mapping[str, Port]) -> str:
    header = [
        "`timescale 1ns/1ps",
        "",
        f"module {config.name}_assertions (",
        "  input logic clk,",
        "  input logic reset_n,",
    ]
    declarations = []
    connections = []
    for index, feature in enumerate(config.features, 1):
        qualify = port_map[feature.drive[0]]
        observe = port_map[feature.observe[0]]
        comma = "," if index < len(config.features) else ""
        declarations.extend(
            (
                f"  input logic{_width(qualify)} fp{index:02d}_qualify,",
                f"  input logic{_width(observe)} fp{index:02d}_observe{comma}",
            )
        )
        connections.append((index, feature))
    lines = header + declarations + [");", "", "  default clocking cb @(posedge clk); endclocking", "  default disable iff (!reset_n);", ""]
    for index, feature in connections:
        lines.extend(
            (
                f"  {feature.checker}:",
                f"    assert property ((|fp{index:02d}_qualify) |-> !$isunknown(fp{index:02d}_observe));",
                f"  {feature.coverage}:",
                f"    cover property ((|fp{index:02d}_qualify) ##1 !$isunknown(fp{index:02d}_observe));",
                "",
            )
        )
    lines.append("endmodule")
    return "\n".join(lines)


def _testbench(config: Environment, port_map: Mapping[str, Port]) -> str:
    parameter_lines = [
        f"    .{name} ({name})" for name in config.parameters
    ]
    parameter_connections = ",\n".join(parameter_lines)
    lines = [
        "`timescale 1ns/1ps",
        f"`include \"{config.name}_if.sv\"",
        "",
        f"module {config.name}_tb;",
    ]
    for name, value in config.parameters.items():
        lines.append(f"  localparam int {name} = {value};")
    lines.extend(("", f"  {config.name}_if #(\n{parameter_connections}\n  ) bus();", "", f"  {config.name} #(\n{parameter_connections}\n  ) dut (", f"`include \"{config.name}_connect.svh\"", "  );", "", f"  {config.name}_assertions checks (", f"    .clk (bus.{config.clock}),", f"    .reset_n (bus.{config.reset}),"))
    assertion_connections = []
    for index, feature in enumerate(config.features, 1):
        assertion_connections.extend(
            (
                f"    .fp{index:02d}_qualify (bus.{feature.drive[0]})",
                f"    .fp{index:02d}_observe (bus.{feature.observe[0]})",
            )
        )
    for index, connection in enumerate(assertion_connections):
        comma = "," if index + 1 < len(assertion_connections) else ""
        lines.append(connection + comma)
    lines.extend(("  );", "", f"  assign bus.ctrl_ld_clk = bus.{config.clock};" if "ctrl_ld_clk" in port_map else "", "", f"  initial bus.{config.clock} = 1'b0;", f"  always #5 bus.{config.clock} = ~bus.{config.clock};", "", "  task automatic tick(input int cycles = 1);", f"    repeat (cycles) begin @(posedge bus.{config.clock}); #1; end", "  endtask", "", "  task automatic expect_known(input logic value, input string label);", "    if ($isunknown(value)) $fatal(1, \"CHECK_FAIL: %s\", label);", "  endtask", "", "  task automatic apply_reset();", "    bus.drive_idle();", f"    bus.{config.reset} = 1'b0;", "    tick(3);", f"    bus.{config.reset} = 1'b1;", "    tick(1);", "  endtask", ""))
    for feature in config.features:
        lines.extend((f"  task automatic {feature.testcase}();", "    apply_reset();", f"    @(negedge bus.{config.clock});"))
        for signal in feature.drive:
            if signal in port_map and port_map[signal].direction == "input" and signal not in {config.clock, config.reset, "ctrl_ld_clk"}:
                lines.append(f"    bus.{signal} = '1;")
        lines.extend(("    tick(1);", f"    expect_known(^bus.{feature.observe[0]}, \"{feature.testcase}\");", "  endtask", ""))
    lines.extend(("  string selected_test;", "  initial begin", "    if (!$value$plusargs(\"TEST=%s\", selected_test)) selected_test = \"" + config.features[0].testcase + "\";", "    case (selected_test)"))
    for feature in config.features:
        lines.append(f"      \"{feature.testcase}\": {feature.testcase}();")
    lines.extend(("      default: $fatal(1, \"unknown TEST=%s\", selected_test);", "    endcase", "    $display(\"TEST_PASS %s static-harness execution\", selected_test);", "    $finish;", "  end", "", "endmodule"))
    return "\n".join(line for line in lines if line != "")


def _deps(config: Environment) -> str:
    blocks = ["`timescale 1ns/1ps", "", "// Standalone compatibility models; production replacement remains PENDING_FULL_CHIP."]
    if "gated_clk_cell" in config.declared_stubs:
        blocks.append("""module gated_clk_cell (
  input logic clk_in, input logic external_en, input logic local_en,
  input logic module_en, input logic pad_yy_icg_scan_en, output logic clk_out
);
  always_comb clk_out = clk_in & (pad_yy_icg_scan_en | (module_en & (external_en | local_en)));
endmodule""")
    if "xx_lsu_compare_iid" in config.declared_stubs:
        blocks.append("""module xx_lsu_compare_iid #(parameter int IID_WIDTH = 7) (
  input logic [IID_WIDTH-1:0] x_iid0, input logic [IID_WIDTH-1:0] x_iid1,
  output logic x_iid0_older
);
  logic [IID_WIDTH-1:0] distance;
  always_comb begin distance = x_iid1 - x_iid0; x_iid0_older = (x_iid0 != x_iid1) && !distance[IID_WIDTH-1]; end
endmodule""")
    return "\n\n".join(blocks)


def _filelist(config: Environment) -> str:
    defines = (
        "TDT_MP_HINFO_WIDTH=17", "VL_WIDTH=8", "VSTART_WIDTH=7", "WK_PA_WIDTH=40", "WK_VA_WIDTH=48", "WK_MA_WIDTH=40",
        "WK_LS_DCACHE_SINGLE_TAG_WIDTH=26", "WK_LS_DCACHE_SINGLE_LDTAG_WIDTH=27", "WK_LS_DCACHE_DOUBLE_LDTAG_WIDTH=54", "WK_LS_DCACHE_TRIPLE_LDTAG_WIDTH=81", "WK_LS_DCACHE_LDTAG_WIDTH=108",
    )
    lines = [f"+incdir+verif/{config.name}/tb", *(f"+define+{item}" for item in defines), f"verif/{config.name}/tb/{config.name}_deps.sv", *config.production_sources, config.source, f"verif/{config.name}/tb/{config.name}_assertions.sv", f"verif/{config.name}/tb/{config.name}_tb.sv"]
    return "\n".join(lines)


def _runbook(config: Environment) -> str:
    return f"""# `{config.name}` interaction 2.1 VCS验证入口

本环境包含{len(config.features)}个父功能点和{len(config.features) * 6}个逐拍叶级场景。
本机只完成端口、场景、文档、SystemVerilog结构和依赖边界的静态preflight；
没有VCS/URG日志或VDB时，结果保持 `BLOCKED_NO_VCS`。

## 命令

```bash
make preflight
make compile
make run TEST={config.features[0].testcase}
make regress
make coverage
```

`make compile` 需要有许可证的VCS主机，`make coverage` 需要URG。standalone中
{', '.join(config.declared_stubs)} 为显式兼容模型，必须在full-chip用生产定义替换，
对应边界为 `PENDING_FULL_CHIP`。计划行是动态实现合同，不代表已获得仿真或覆盖率PASS。
"""


def _doc_block(config: Environment, rows: list[dict[str, str]]) -> str:
    begin = f"<!-- {config.prefix}-INTERACTION-2.1-BEGIN -->"
    lines = [begin, "", "## Interaction 2.1 叶级场景与执行合同", "", f"共{len(rows)}行；每个父功能点6行。状态只允许 `BLOCKED_NO_VCS` 或 `PENDING_FULL_CHIP`。", *config.doc_tokens, "", "|场景|setup/周期|当|则|checker/coverage/关闭|", "|---|---|---|---|---|"]
    for row in rows:
        cells = (f"`{row['scenario_id']}`", f"{row['setup']}；{row['cycle_sequence']}", row["trigger_condition"], row["expected_result"], f"`{row['checker']}` / `{row['coverage']}`；{row['closure']}")
        lines.append("|" + "|".join(cell.replace("|", "\\|") for cell in cells) + "|")
    lines.extend(("", f"<!-- {config.prefix}-INTERACTION-2.1-END -->"))
    return "\n".join(lines)


def _update_feature_doc(config: Environment, rows: list[dict[str, str]]) -> None:
    path = REPO_ROOT / config.feature_doc
    text = path.read_text(encoding="utf-8").rstrip()
    begin = f"<!-- {config.prefix}-INTERACTION-2.1-BEGIN -->"
    end = f"<!-- {config.prefix}-INTERACTION-2.1-END -->"
    if begin in text:
        before, rest = text.split(begin, 1)
        _, after = rest.split(end, 1)
        text = before.rstrip() + after.rstrip()
    _write(path, text + "\n\n" + _doc_block(config, rows))


def build(config: Environment) -> None:
    env = REPO_ROOT / "verif" / config.name
    source_text = (REPO_ROOT / config.source).read_text(encoding="utf-8")
    ports = parse_module_ports(source_text, config.name)
    port_map = {port.name: port for port in ports}
    for feature in config.features:
        for signal in (*feature.drive, *feature.observe):
            if signal not in port_map:
                raise RuntimeError(f"{config.name}: feature signal is not a DUT port: {signal}")
    rows = _detail_rows(config)
    _write(env / "module.json", json.dumps(_manifest(config), ensure_ascii=False, indent=2))
    _write_csv(env / "coverage_matrix.csv", FEATURE_COLUMNS, _feature_rows(config))
    _write_csv(env / "detailed_test_plan.csv", DETAIL_COLUMNS, rows)
    _write(env / "tests.list", "\n".join(feature.testcase for feature in config.features))
    _write(env / "filelist.f", _filelist(config))
    makefile = (REPO_ROOT / "verif/common/templates/Makefile.in").read_text(encoding="utf-8")
    makefile = makefile.replace("@@DEFAULT_TEST@@", config.features[0].testcase).replace("@@ENV_NAME@@", config.name).replace("@@DUT_MODULE@@", config.name)
    _write(env / "Makefile", makefile)
    _write(env / "tb" / f"{config.name}_deps.sv", _deps(config))
    _write(env / "tb" / f"{config.name}_assertions.sv", _assertions(config, port_map))
    _write(env / "tb" / f"{config.name}_tb.sv", _testbench(config, port_map))
    _write(REPO_ROOT / config.runbook, _runbook(config))
    _update_feature_doc(config, rows)
    if not generate(env / "module.json", check=False):
        raise RuntimeError(f"failed to generate port artifacts for {config.name}")
    print(f"{config.prefix}_ENV_BUILD_PASS features={len(config.features)} scenarios={len(rows)} ports={len(ports)}")


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--env", choices=sorted(CONFIGS), required=True)
    args = parser.parse_args()
    build(CONFIGS[args.env])
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
