#!/usr/bin/env python3
"""Simulator-independent Interaction 1.9/2.0 completeness gate."""

from __future__ import annotations

import csv
import re
import subprocess
import sys
from collections import Counter
from pathlib import Path


ENV_ROOT = Path(__file__).resolve().parents[1]
REPO_ROOT = ENV_ROOT.parents[1]
EXPECTED_IDS = [f"AG-FP-{index:02d}" for index in range(1, 13)]
REQUIRED_RESULTS = {"BLOCKED_NO_VCS", "PENDING_FULL_CHIP"}
DETAIL_COLUMNS = (
    "scenario_id",
    "feature_id",
    "scenario",
    "testcase",
    "priority",
    "setup",
    "drive_signals",
    "cycle_sequence",
    "trigger_condition",
    "expected_signals",
    "expected_result",
    "checker",
    "coverage",
    "closure",
    "result",
)
SCENARIO_PATTERN = re.compile(r"^(AG-FP-\d{2})-S(\d{2})$")
PARENT_FIELDS = ("testcase", "priority", "checker", "coverage", "result")


def fail(message: str) -> None:
    raise RuntimeError(message)


def read(relative: str) -> str:
    path = REPO_ROOT / relative
    if not path.is_file():
        fail(f"missing required artifact: {relative}")
    return path.read_text(encoding="utf-8")


def strip_sv_comments_and_strings(text: str) -> str:
    text = re.sub(r"/\*.*?\*/", "", text, flags=re.DOTALL)
    text = re.sub(r"//.*", "", text)
    text = re.sub(r'"(?:\\.|[^"\\])*"', '""', text)
    return text


def signal_vocabulary(*sources: str) -> set[str]:
    """Return every SystemVerilog-style identifier delivered in sources."""
    return set(
        re.findall(
            r"\b[A-Za-z_][A-Za-z0-9_]*\b",
            "\n".join(sources),
        )
    )


def validate_detailed_rows(
    rows: list[dict[str, str]],
    parents: dict[str, dict[str, str]],
    known_signals: set[str],
    plan_text: str,
) -> Counter[str]:
    """Validate Interaction 2.0 scenario-level traceability."""
    if not rows:
        fail("detailed plan contains no scenarios")
    if tuple(rows[0]) != DETAIL_COLUMNS:
        fail(
            "detailed plan schema mismatch: "
            f"expected {DETAIL_COLUMNS}, got {tuple(rows[0])}"
        )

    counts: Counter[str] = Counter()
    seen: set[str] = set()
    sequence_numbers: dict[str, set[int]] = {
        feature_id: set() for feature_id in parents
    }

    for row in rows:
        scenario_id = row["scenario_id"].strip()
        feature_id = row["feature_id"].strip()
        if any(not row[column].strip() for column in DETAIL_COLUMNS):
            fail(f"{scenario_id or '<empty ID>'}: detailed field is empty")
        if scenario_id in seen:
            fail(f"duplicate scenario ID: {scenario_id}")

        match = SCENARIO_PATTERN.fullmatch(scenario_id)
        if match is None:
            fail(f"malformed scenario ID: {scenario_id}")
        if match.group(1) != feature_id:
            fail(
                f"{scenario_id}: encoded parent {match.group(1)} "
                f"differs from feature_id {feature_id}"
            )
        if feature_id not in parents:
            fail(f"{scenario_id}: unknown parent feature {feature_id}")

        parent = parents[feature_id]
        for field in PARENT_FIELDS:
            if row[field] != parent[field]:
                fail(
                    f"{scenario_id}: parent {field} mismatch: "
                    f"expected {parent[field]}, got {row[field]}"
                )

        if not row["trigger_condition"].startswith("当"):
            fail(f"{scenario_id}: trigger must begin with 当")
        if not row["expected_result"].startswith("则"):
            fail(f"{scenario_id}: expected result must begin with 则")
        for field, label in (
            ("trigger_condition", "trigger"),
            ("expected_result", "expected result"),
        ):
            quoted = re.findall(r"`([^`]+)`", row[field])
            referenced = signal_vocabulary(*quoted) & known_signals
            if not referenced:
                fail(f"{scenario_id}: {label} names no delivered signal")
        if "C0:" not in row["cycle_sequence"] or "C1:" not in row["cycle_sequence"]:
            fail(f"{scenario_id}: cycle sequence must name C0 and C1")

        for field, label in (
            ("drive_signals", "drive signal"),
            ("expected_signals", "expected signal"),
        ):
            signals = row[field].split("|")
            malformed = any(
                not re.fullmatch(r"[A-Za-z_][A-Za-z0-9_]*", signal)
                for signal in signals
            )
            if malformed:
                fail(f"{scenario_id}: malformed {label} list {row[field]}")
            for signal in signals:
                if signal not in known_signals:
                    fail(f"{scenario_id}: unknown {label} {signal}")

        for required_text, label in (
            (scenario_id, "scenario ID"),
            (row["trigger_condition"], "trigger condition"),
            (row["expected_result"], "expected result"),
        ):
            if required_text not in plan_text:
                fail(f"{scenario_id}: {label} missing from Markdown plan")

        seen.add(scenario_id)
        counts[feature_id] += 1
        sequence_numbers[feature_id].add(int(match.group(2)))

    for feature_id in EXPECTED_IDS:
        if feature_id not in parents:
            fail(f"parent feature matrix missing {feature_id}")
        if counts[feature_id] < 4:
            fail(f"{feature_id}: fewer than four detailed scenarios")
        expected_prefix = set(range(1, counts[feature_id] + 1))
        if sequence_numbers[feature_id] != expected_prefix:
            fail(
                f"{feature_id}: scenario sequence is not contiguous from S01: "
                f"{sorted(sequence_numbers[feature_id])}"
            )

    for boundary in REQUIRED_RESULTS:
        if boundary not in plan_text:
            fail(f"Markdown plan missing execution boundary {boundary}")
    return counts


def check_sv_structure(relative: str) -> None:
    text = strip_sv_comments_and_strings(read(relative))
    for opening, closing in (("(", ")"), ("[", "]"), ("{", "}")):
        depth = 0
        for character in text:
            if character == opening:
                depth += 1
            elif character == closing:
                depth -= 1
                if depth < 0:
                    fail(f"{relative}: unmatched {closing}")
        if depth:
            fail(f"{relative}: unmatched {opening}, depth={depth}")

    token_pairs = (
        ("module", "endmodule"),
        ("interface", "endinterface"),
        ("task", "endtask"),
        ("function", "endfunction"),
        ("begin", "end"),
        ("case", "endcase"),
    )
    tokens = re.findall(r"\b[A-Za-z_][A-Za-z0-9_]*\b", text)
    for opening, closing in token_pairs:
        open_count = tokens.count(opening)
        close_count = tokens.count(closing)
        if open_count != close_count:
            fail(
                f"{relative}: {opening}/{closing} mismatch "
                f"{open_count}/{close_count}"
            )


def main() -> int:
    subprocess.run(
        [sys.executable, str(ENV_ROOT / "tools/gen_dut_if.py"), "--check"],
        cwd=REPO_ROOT,
        check=True,
    )

    with (ENV_ROOT / "coverage_matrix.csv").open(
        encoding="utf-8", newline=""
    ) as stream:
        rows = list(csv.DictReader(stream))

    ids = [row["feature_id"] for row in rows]
    if ids != EXPECTED_IDS:
        fail(f"feature IDs differ: expected {EXPECTED_IDS}, got {ids}")

    tests = {
        line.strip()
        for line in read("verif/xx_lsu_ld_ag/tests.list").splitlines()
        if line.strip() and not line.lstrip().startswith("#")
    }
    if len(tests) != 12:
        fail(f"expected 12 test names, got {len(tests)}")

    with (ENV_ROOT / "detailed_test_plan.csv").open(
        encoding="utf-8", newline=""
    ) as stream:
        detail_reader = csv.DictReader(stream)
        if tuple(detail_reader.fieldnames or ()) != DETAIL_COLUMNS:
            fail(
                "detailed plan schema mismatch: "
                f"expected {DETAIL_COLUMNS}, got {tuple(detail_reader.fieldnames or ())}"
            )
        detail_rows = list(detail_reader)

    tb = read("verif/xx_lsu_ld_ag/tb/xx_lsu_ld_ag_tb.sv")
    assertions = read("verif/xx_lsu_ld_ag/tb/xx_lsu_ld_ag_assertions.sv")
    combined = f"{tb}\n{assertions}"

    dut = read("srcs/xx_lsu_ld_ag.sv")
    deps = read("verif/xx_lsu_ld_ag/tb/xx_lsu_ld_ag_deps.sv")
    instantiated = set(
        re.findall(
            r"^\s*(gated_clk_cell|xx_lsu_[A-Za-z0-9_]+)\b",
            dut,
            re.MULTILINE,
        )
    )
    defined = set(
        re.findall(
            r"^\s*module\s+(gated_clk_cell|xx_lsu_[A-Za-z0-9_]+)\b",
            deps,
            re.MULTILINE,
        )
    )
    if instantiated != defined:
        fail(
            "standalone dependency mismatch: "
            f"instantiated={sorted(instantiated)}, defined={sorted(defined)}"
        )

    for relative in (
        "verif/xx_lsu_ld_ag/tb/xx_lsu_ld_ag_deps.sv",
        "verif/xx_lsu_ld_ag/tb/xx_lsu_ld_ag_if.sv",
        "verif/xx_lsu_ld_ag/tb/xx_lsu_ld_ag_assertions.sv",
        "verif/xx_lsu_ld_ag/tb/xx_lsu_ld_ag_tb.sv",
    ):
        check_sv_structure(relative)

    for row in rows:
        feature_id = row["feature_id"]
        testcase = row["testcase"]
        if testcase not in tests:
            fail(f"{feature_id}: testcase {testcase} missing from tests.list")
        if not re.search(rf"\btask\s+automatic\s+{re.escape(testcase)}\b", tb):
            fail(f"{feature_id}: task {testcase} missing from testbench")
        if row["checker"] not in combined:
            fail(f"{feature_id}: checker {row['checker']} missing")
        if row["coverage"] not in combined:
            fail(f"{feature_id}: coverage {row['coverage']} missing")
        if row["priority"] not in {"P0", "P1"}:
            fail(f"{feature_id}: invalid priority {row['priority']}")
        if not row["closure"].strip():
            fail(f"{feature_id}: empty closure criterion")
        if row["result"] not in REQUIRED_RESULTS:
            fail(f"{feature_id}: unsupported result state {row['result']}")

    signal_sources = [dut]
    signal_sources.extend(
        path.read_text(encoding="utf-8")
        for path in sorted((ENV_ROOT / "tb").glob("*.sv*"))
    )
    detail_counts = validate_detailed_rows(
        detail_rows,
        {row["feature_id"]: row for row in rows},
        signal_vocabulary(*signal_sources),
        read("doc-ag/xx_lsu_ld_ag_feature_test_plan.md"),
    )

    runbook = read("doc-ag/xx_lsu_ld_ag_vcs_verification.md")
    for command in (
        "make preflight",
        "make compile",
        "make run TEST=",
        "make regress",
        "make coverage",
    ):
        if command not in runbook:
            fail(f"runbook missing command: {command}")

    print(
        "COMPLETENESS_PASS "
        f"features={len(rows)} tests={len(tests)} "
        "checkers=12 coverage_items=12"
    )
    print(
        "DETAILED_PLAN_PASS "
        f"scenarios={len(detail_rows)} "
        f"per_feature_min={min(detail_counts.values())}"
    )
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except (RuntimeError, subprocess.CalledProcessError) as error:
        print(f"COMPLETENESS_FAIL: {error}", file=sys.stderr)
        raise SystemExit(1)
