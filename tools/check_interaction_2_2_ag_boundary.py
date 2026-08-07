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
    for predicate_start, predicate_end in _expect_true_predicate_ranges(executable):
        predicate = executable[predicate_start:predicate_end]
        if _is_safe_observation_predicate(predicate, signal):
            return True
    return False


_EXPECT_TRUE_TOKEN = re.compile(
    r"(?<![A-Za-z0-9_])expect_true(?![A-Za-z0-9_$])"
)
_IMPORT_TOKEN = re.compile(r"(?<![A-Za-z0-9_$])import(?![A-Za-z0-9_$])")
_CANONICAL_EXPECT_TRUE_HELPER = re.compile(
    r"task\s+automatic\s+expect_true\s*\(\s*"
    r"input\s+logic\s+condition\s*,\s*"
    r"input\s+string\s+message\s*\)\s*",
    flags=re.DOTALL,
)


def _skip_whitespace(text: str, index: int) -> int:
    while index < len(text) and text[index].isspace():
        index += 1
    return index


def _previous_non_whitespace(text: str, index: int) -> int:
    index -= 1
    while index >= 0 and text[index].isspace():
        index -= 1
    return index


def _top_level_offsets(text: str) -> set[int] | None:
    """Return offsets outside balanced (), [], and {} delimiters."""
    closing = {"(": ")", "[": "]", "{": "}"}
    stack: list[str] = []
    top_level: set[int] = set()
    for index, char in enumerate(text):
        if not stack:
            top_level.add(index)
        if char in closing:
            stack.append(closing[char])
        elif char in closing.values():
            if not stack or char != stack.pop():
                return None
    if stack:
        return None
    return top_level


def _standalone_expect_true_predicate_range(
    text: str, match: re.Match[str]
) -> tuple[int, int] | None:
    """Parse one exact `expect_true(predicate, string);` statement."""
    previous = _previous_non_whitespace(text, match.start())
    if previous >= 0 and text[previous] != ";":
        return None

    opening = _skip_whitespace(text, match.end())
    if opening >= len(text) or text[opening] != "(":
        return None
    predicate_start = opening + 1
    closing = {"(": ")", "[": "]", "{": "}"}
    stack: list[str] = []
    predicate_end: int | None = None
    for index in range(predicate_start, len(text)):
        char = text[index]
        if char in closing:
            stack.append(closing[char])
        elif char in closing.values():
            if stack:
                if char != stack.pop():
                    return None
            else:
                return None
        elif char == "," and not stack:
            predicate_end = index
            break
    if predicate_end is None:
        return None

    message_start = _skip_whitespace(text, predicate_end + 1)
    if message_start >= len(text) or text[message_start] != '"':
        return None
    message_end = text.find('"', message_start + 1)
    if message_end < 0:
        return None
    call_closing = _skip_whitespace(text, message_end + 1)
    if call_closing >= len(text) or text[call_closing] != ")":
        return None
    terminator = _skip_whitespace(text, call_closing + 1)
    if terminator >= len(text) or text[terminator] != ";":
        return None
    return predicate_start, predicate_end


def _expect_true_predicate_ranges(text: str) -> list[tuple[int, int]]:
    """Authorize only complete, standalone, unqualified expect_true statements."""
    if _IMPORT_TOKEN.search(text) is not None:
        return []
    top_level = _top_level_offsets(text)
    if top_level is None:
        return []
    ranges: list[tuple[int, int]] = []
    for match in _EXPECT_TRUE_TOKEN.finditer(text):
        if match.start() not in top_level:
            return []
        predicate_range = _standalone_expect_true_predicate_range(text, match)
        if predicate_range is None:
            return []
        ranges.append(predicate_range)
    return ranges


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
            masked = ["\n" if char == "\n" else " " for char in string]
            masked[0] = '"'
            if len(masked) > 1 and string.endswith('"'):
                masked[-1] = '"'
            result.append("".join(masked))
            index = end
        else:
            result.append(text[index])
            index += 1
    return "".join(result)


_UNARY_OPERATORS = ("~&", "~|", "~^", "^~", "!", "~", "&", "|", "^")
_BASED_NUMBER = re.compile(
    r"(?:[0-9][0-9_]*)?'[sS]?[bBoOdDhH][0-9a-fA-FxXzZ?_]+"
)
_UNSIZED_NUMBER = re.compile(r"'[01xXzZ]")
_DECIMAL_NUMBER = re.compile(r"[0-9][0-9_]*")
_SELECTOR_PUNCTUATION = frozenset("()+-*/%&|^~!<>?:")


def _is_constant_selector(selector: str) -> bool:
    """Accept only numeric literals, operator punctuation, and grouping."""
    if "++" in selector or "--" in selector or "=" in selector:
        return False
    index = 0
    grouping_depth = 0
    saw_number = False
    while index < len(selector):
        if selector[index].isspace():
            index += 1
            continue
        number = (
            _BASED_NUMBER.match(selector, index)
            or _UNSIZED_NUMBER.match(selector, index)
            or _DECIMAL_NUMBER.match(selector, index)
        )
        if number is not None:
            saw_number = True
            index = number.end()
            continue
        char = selector[index]
        if char not in _SELECTOR_PUNCTUATION:
            return False
        if char == "(":
            grouping_depth += 1
        elif char == ")":
            if grouping_depth == 0:
                return False
            grouping_depth -= 1
        index += 1
    return saw_number and grouping_depth == 0


class _ReadOnlyPredicateParser:
    """Parse the deliberately small approved protected-output grammar."""

    def __init__(self, text: str, signal: str) -> None:
        self.text = text
        self.targets = (f"bus.{signal}", f"dut.{signal}")
        self.index = 0

    def parse(self) -> bool:
        if not self._parse_unary_expression():
            return False
        self._skip_whitespace()
        return self.index == len(self.text)

    def _parse_unary_expression(self) -> bool:
        self._skip_whitespace()
        while self._take_unary_operator():
            self._skip_whitespace()
        if self.index < len(self.text) and self.text[self.index] == "(":
            self.index += 1
            if not self._parse_unary_expression():
                return False
            self._skip_whitespace()
            if self.index >= len(self.text) or self.text[self.index] != ")":
                return False
            self.index += 1
            return True
        return self._parse_target_reference()

    def _take_unary_operator(self) -> bool:
        if self.text.startswith(("&&", "||"), self.index):
            return False
        for operator in _UNARY_OPERATORS:
            if self.text.startswith(operator, self.index):
                self.index += len(operator)
                return True
        return False

    def _parse_target_reference(self) -> bool:
        target = next(
            (
                candidate
                for candidate in self.targets
                if self.text.startswith(candidate, self.index)
            ),
            None,
        )
        if target is None:
            return False
        self.index += len(target)
        while True:
            self._skip_whitespace()
            if self.index >= len(self.text) or self.text[self.index] != "[":
                return True
            closing = self.text.find("]", self.index + 1)
            if closing < 0:
                return False
            selector = self.text[self.index + 1:closing]
            if not _is_constant_selector(selector):
                return False
            self.index = closing + 1

    def _skip_whitespace(self) -> None:
        while self.index < len(self.text) and self.text[self.index].isspace():
            self.index += 1


def _is_safe_observation_predicate(predicate: str, signal: str) -> bool:
    """Require complete consumption by the approved read-only grammar."""
    return _ReadOnlyPredicateParser(predicate, signal).parse()


def _is_assigned(task_body: str, signal: str) -> bool:
    executable = _executable_text(task_body)
    predicates = _expect_true_predicate_ranges(executable)
    pattern = re.compile(rf"\b{re.escape(signal)}\b")
    for match in pattern.finditer(executable):
        predicate_range = next(
            (
                (start, end)
                for start, end in predicates
                if start <= match.start() and match.end() <= end
            ),
            None,
        )
        if predicate_range is None:
            return True
        predicate_start, predicate_end = predicate_range
        predicate = executable[predicate_start:predicate_end]
        if not _is_safe_observation_predicate(predicate, signal):
            return True
    return False


def _validate_expect_true_helper(tb_text: str) -> None:
    """Require one canonical, input-only expect_true task in the TB module."""
    executable = _executable_text(tb_text)
    modules = list(
        re.finditer(
            r"\bmodule\s+xx_lsu_ld_ag_tb\b[^;]*;(?P<body>.*?)\bendmodule\b",
            executable,
            flags=re.DOTALL,
        )
    )
    if len(modules) != 1:
        raise ValueError("expect_true helper requires one xx_lsu_ld_ag_tb module")
    module_body = modules[0].group("body")
    declarations: list[str] = []
    for declaration in re.finditer(r"\b(?:task|function)\b", module_body):
        header_end = module_body.find(";", declaration.start())
        if header_end < 0:
            raise ValueError("expect_true helper declaration is unterminated")
        header = module_body[declaration.start():header_end]
        if _EXPECT_TRUE_TOKEN.search(header) is not None:
            declarations.append(header)
    if len(declarations) != 1:
        raise ValueError(
            "expect_true helper must have exactly one task/function declaration"
        )
    if _CANONICAL_EXPECT_TRUE_HELPER.fullmatch(declarations[0]) is None:
        raise ValueError(
            "expect_true helper must be task automatic with two input by-value ports"
        )


def check() -> None:
    rtl_text = RTL.read_text(encoding="utf-8")
    tb_text = TB.read_text(encoding="utf-8")
    assertions_text = ASSERTIONS.read_text(encoding="utf-8")
    _validate_expect_true_helper(tb_text)
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
