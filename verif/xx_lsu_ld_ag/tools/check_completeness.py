#!/usr/bin/env python3
"""Simulator-independent Interaction 1.9 completeness gate."""

from __future__ import annotations

import csv
import re
import subprocess
import sys
from pathlib import Path


ENV_ROOT = Path(__file__).resolve().parents[1]
REPO_ROOT = ENV_ROOT.parents[1]
EXPECTED_IDS = [f"AG-FP-{index:02d}" for index in range(1, 13)]
REQUIRED_RESULTS = {"BLOCKED_NO_VCS", "PENDING_FULL_CHIP"}


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
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except (RuntimeError, subprocess.CalledProcessError) as error:
        print(f"COMPLETENESS_FAIL: {error}", file=sys.stderr)
        raise SystemExit(1)
