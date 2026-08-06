"""Small fixture and artifact readers for interaction-2.1 tests."""

from __future__ import annotations

import csv
import shutil
import subprocess
import sys
from pathlib import Path

from verif.common.tools.rtl_ports import Port
from verif.common.tools.scenario_contract import (
    DETAIL_COLUMNS,
    EnvironmentContract,
    ModuleManifest,
    ValidationSummary,
    load_environment,
    validate_environment,
)


ROOT = Path(__file__).resolve().parents[1]


def make_contract(**overrides) -> EnvironmentContract:
    feature_id = "DEMO-FP-01"
    testcase = "tc_demo"
    checker = "CHK_DEMO"
    coverage = "COV_DEMO"
    result = "BLOCKED_NO_VCS"
    parent = {
        "feature_id": feature_id,
        "testcase": testcase,
        "priority": "P0",
        "checker": checker,
        "coverage": coverage,
        "closure": "观察输出与owner一致",
        "result": result,
    }
    row = {
        "scenario_id": "DEMO-FP-01-S01",
        "feature_id": feature_id,
        "scenario": "演示场景",
        "testcase": testcase,
        "priority": "P0",
        "setup": "复位释放且输入稳定",
        "drive_signals": "demo_in",
        "cycle_sequence": "C0: 驱动demo_in=1；C1: 采样demo_out",
        "trigger_condition": "当 `demo_in=1` 时",
        "expected_signals": "demo_out",
        "expected_result": "则 `demo_out=1`",
        "checker": checker,
        "coverage": coverage,
        "closure": "demo_out在C1为1",
        "result": result,
    }
    row.update({key: value for key, value in overrides.items() if key in row})

    declared_stubs = tuple(overrides.get("declared_stubs", ()))
    stub_modules = set(overrides.get("stub_modules", ()))
    manifest = ModuleManifest(
        env_name="demo",
        dut_module="demo",
        dut_source="srcs/demo.sv",
        feature_doc="doc-demo/demo.md",
        runbook="doc-demo/runbook.md",
        feature_prefix="DEMO",
        expected_features=1,
        min_scenarios_per_feature=1,
        clock="clk",
        reset="reset_n",
        parameters={},
        idle_overrides={},
        production_sources=(),
        declared_stubs=declared_stubs,
        stub_results={name: "PENDING_FULL_CHIP" for name in declared_stubs},
    )
    markdown = "\n".join(
        (row["scenario_id"], row["trigger_condition"], row["expected_result"])
    )
    return EnvironmentContract(
        root=ROOT,
        env_dir=ROOT / "verif/demo",
        manifest=manifest,
        ports=(Port("demo_in", "input"), Port("demo_out", "output")),
        feature_rows=(parent,),
        detail_rows=(row,),
        test_names=frozenset({testcase}),
        markdown=markdown,
        runbook="make preflight\nmake compile\nmake run TEST=\nmake regress\nmake coverage",
        tb_text=f"task automatic {testcase}; endtask {checker} {coverage}",
        assertion_text=f"{checker} {coverage}",
        known_signals=frozenset({"demo_in", "demo_out", "clk", "reset_n"}),
        instantiated_modules=frozenset(stub_modules),
        defined_modules=frozenset(declared_stubs),
    )


def copy_fixture_env(destination: Path) -> Path:
    fixture = ROOT / "tests/fixtures/interaction_2_1/demo_env"
    target = destination / "demo"
    shutil.copytree(fixture, target)
    return target


def run_gen(env: Path, check: bool) -> subprocess.CompletedProcess[str]:
    command = [
        sys.executable,
        str(ROOT / "verif/common/tools/gen_env.py"),
        "--manifest",
        str(env / "module.json"),
    ]
    if check:
        command.append("--check")
    return subprocess.run(command, cwd=ROOT, text=True, capture_output=True)


def read_detail(env_name: str) -> list[dict[str, str]]:
    path = ROOT / "verif" / env_name / "detailed_test_plan.csv"
    with path.open(encoding="utf-8", newline="") as stream:
        reader = csv.DictReader(stream)
        if tuple(reader.fieldnames or ()) != DETAIL_COLUMNS:
            raise AssertionError(f"unexpected detail schema: {reader.fieldnames}")
        return list(reader)


def scenario_signals(row: dict[str, str]) -> set[str]:
    return {
        signal
        for field in ("drive_signals", "expected_signals")
        for signal in row[field].split("|")
        if signal
    }


def validate_named_environment(env_name: str) -> ValidationSummary:
    return validate_environment(load_environment(ROOT, env_name))


def read_manifest(
    path: Path = ROOT / "waive/interaction_2_1_code_waiver_manifest.csv",
) -> list[dict[str, str]]:
    with path.open(encoding="utf-8", newline="") as stream:
        return list(csv.DictReader(stream))
