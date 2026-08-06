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
    executable = _executable_text(scenario)
    call_start = 0
    while (match := re.search(r"\bexpect_true\s*\(", executable[call_start:])) is not None:
        predicate_start = call_start + match.end()
        depth = 0
        for index in range(predicate_start, len(executable)):
            char = executable[index]
            if char == "(":
                depth += 1
            elif char == ")":
                if depth == 0:
                    predicate = executable[predicate_start:index]
                    break
                depth -= 1
            elif char == "," and depth == 0:
                predicate = executable[predicate_start:index]
                break
        else:
            return False
        if re.search(rf"\b(?:bus|dut)\.{re.escape(signal)}\b", predicate):
            return True
        call_start = index + 1
    return False


def _executable_text(text: str) -> str:
    result: list[str] = []
    index = 0
    while index < len(text):
        if text.startswith("//", index):
            newline = text.find("\n", index)
            if newline < 0:
                break
            result.append("\n")
            index = newline + 1
        elif text.startswith("/*", index):
            end = text.find("*/", index + 2)
            comment = text[index:] if end < 0 else text[index:end + 2]
            result.append("".join("\n" if char == "\n" else " " for char in comment))
            index = len(text) if end < 0 else end + 2
        elif text[index] == '"':
            end = index + 1
            while end < len(text):
                if text[end] == "\\":
                    end += 2
                elif text[end] == '"':
                    end += 1
                    break
                else:
                    end += 1
            string = text[index:end]
            result.append("".join("\n" if char == "\n" else " " for char in string))
            index = end
        else:
            result.append(text[index])
            index += 1
    return "".join(result)


def _parenthesis_depth(text: str, position: int) -> int:
    depth = 0
    for char in text[:position]:
        if char == "(":
            depth += 1
        elif char == ")":
            depth -= 1
    return depth


def _after_selectors(text: str, position: int) -> int:
    while True:
        while position < len(text) and text[position].isspace():
            position += 1
        if position == len(text) or text[position] != "[":
            return position
        depth = 0
        while position < len(text):
            if text[position] == "[":
                depth += 1
            elif text[position] == "]":
                depth -= 1
                if depth == 0:
                    position += 1
                    break
            position += 1
        if depth != 0:
            return len(text)


def _is_assigned(task_body: str, signal: str) -> bool:
    executable = _executable_text(task_body)
    pattern = re.compile(rf"\b(?:(force)\s+)?(?:bus\.|dut\.){re.escape(signal)}\b")
    for match in pattern.finditer(executable):
        if _parenthesis_depth(executable, match.start()) != 0:
            continue
        if match.group(1) is not None:
            return True
        suffix = executable[_after_selectors(executable, match.end()):]
        if re.match(
            r"(?:=(?!=)|<=|\+=|-=|\*=|/=|&=|\|=|\^=)",
            suffix,
        ):
            return True
    return False


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
