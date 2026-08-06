#!/usr/bin/env python3
"""Statically verify that AG-FP-05-S07 exercises a DUT output boundary."""

from __future__ import annotations

import re
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
RTL = ROOT / "srcs/xx_lsu_ld_ag.sv"
TB = ROOT / "verif/xx_lsu_ld_ag/tb/xx_lsu_ld_ag_tb.sv"
ASSERTIONS = ROOT / "verif/xx_lsu_ld_ag/tb/xx_lsu_ld_ag_assertions.sv"

ENVIRONMENT_INPUTS = {
    "dcache_arb_lag_ex1_sel": "1'b0",
    "idu_lsu_rf_older_vld": "1'b1",
    "mmu_lsu_pa_vld": "1'b0",
    "mmu_lsu_access_fault": "1'b1",
}
TARGET_OUTPUTS = (
    "lsu_mmu_abort",
    "lsu_lrq_create_frz",
    "lag_ex1_stall_restart_entry",
)
REQUIRED_ASSERTION_MARKERS = (
    "CHK_FP05_MASK_ABORT_REPLAY",
    "COV_FP05_MASK_ABORT_TABLE",
)


def _task_body(text: str, task_name: str) -> str:
    match = re.search(
        rf"\btask\s+automatic\s+{re.escape(task_name)}\s*\([^;]*;(?P<body>.*?)\bendtask",
        text,
        flags=re.DOTALL,
    )
    if match is None:
        raise ValueError(f"missing task {task_name}")
    return match.group("body")


def _scenario_body(task_body: str) -> str:
    marker = "AG-FP-05-S07"
    start = task_body.find(marker)
    if start < 0:
        raise ValueError(f"missing {marker} scenario marker")
    return task_body[start:]


def _port_direction(rtl_text: str, signal: str) -> str:
    match = re.search(
        rf"^\s*(input|output)\b[^;\n]*\b{re.escape(signal)}\b\s*;",
        rtl_text,
        flags=re.MULTILINE,
    )
    if match is None:
        raise ValueError(f"missing RTL port declaration for {signal}")
    return match.group(1)


def _is_driven_with(scenario: str, signal: str, value: str) -> bool:
    return re.search(
        rf"\bbus\.{re.escape(signal)}\s*(?:=|<=)\s*{re.escape(value)}\s*;",
        scenario,
    ) is not None


def _is_observed(scenario: str, signal: str) -> bool:
    return re.search(
        rf"\bexpect_true\s*\((?:(?!;).)*?\bbus\.{re.escape(signal)}\b",
        scenario,
        flags=re.DOTALL,
    ) is not None


def _is_assigned(task_body: str, signal: str) -> bool:
    return re.search(
        rf"^\s*(?:assign\s+|force\s+)?(?:bus\.|dut\.)?{re.escape(signal)}\s*"
        r"(?:=|<=|\+=|-=|\*=|/=|&=|\|=|\^=)",
        task_body,
        flags=re.MULTILINE,
    ) is not None


def check() -> None:
    rtl_text = RTL.read_text(encoding="utf-8")
    tb_text = TB.read_text(encoding="utf-8")
    assertions_text = ASSERTIONS.read_text(encoding="utf-8")
    task_body = _task_body(tb_text, "tc_stall_restart_owner")
    scenario = _scenario_body(task_body)

    for signal in ENVIRONMENT_INPUTS:
        if _port_direction(rtl_text, signal) != "input":
            raise ValueError(f"{signal} must be an RTL input")
    for signal in TARGET_OUTPUTS:
        if _port_direction(rtl_text, signal) != "output":
            raise ValueError(f"{signal} must be an RTL output")
    for signal, value in ENVIRONMENT_INPUTS.items():
        if not _is_driven_with(scenario, signal, value):
            raise ValueError(f"AG-FP-05-S07 does not drive {signal}={value}")
    for signal in TARGET_OUTPUTS:
        if not _is_observed(scenario, signal):
            raise ValueError(f"AG-FP-05-S07 does not observe {signal}")
        if _is_assigned(task_body, signal):
            raise ValueError(f"tc_stall_restart_owner assigns DUT output {signal}")
    for marker in REQUIRED_ASSERTION_MARKERS:
        if marker not in assertions_text:
            raise ValueError(f"missing AG-FP-05 assertion/cover marker {marker}")


def main() -> None:
    check()
    print("AG_FP05_DUT_BOUNDARY_PASS inputs=4 outputs=3")


if __name__ == "__main__":
    main()
