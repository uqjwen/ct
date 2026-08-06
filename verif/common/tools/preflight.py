#!/usr/bin/env python3
"""Simulator-independent structural preflight for LSU module environments."""

from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path


REPO_ROOT = Path(__file__).resolve().parents[3]
if str(REPO_ROOT) not in sys.path:
    sys.path.insert(0, str(REPO_ROOT))

from verif.common.tools.gen_env import generate
from verif.common.tools.rtl_ports import strip_comments
from verif.common.tools.scenario_contract import (
    ContractError,
    ValidationSummary,
    load_environment,
    validate_environment,
)


APPROVED_ENVIRONMENTS = {
    "xx_lsu_ld_ag": (12, 96, 8),
    "xx_lsu_ld_dc": (12, 72, 6),
    "xx_lsu_ld_da": (12, 72, 6),
    "xx_lsu_ld_wb": (12, 72, 6),
    "xx_lsu_rb": (12, 72, 6),
    "xx_lsu_lrq": (12, 72, 6),
    "xx_lsu_lfb": (13, 78, 6),
}


def _strip_strings(text: str) -> str:
    return re.sub(r'"(?:\\.|[^"\\])*"', '""', strip_comments(text))


def validate_sv_structure(path: Path) -> None:
    """Apply lightweight delimiter and paired-keyword checks to one SV file."""

    text = _strip_strings(path.read_text(encoding="utf-8"))
    for opening, closing in (("(", ")"), ("[", "]"), ("{", "}")):
        depth = 0
        for character in text:
            if character == opening:
                depth += 1
            elif character == closing:
                depth -= 1
                if depth < 0:
                    raise ContractError(f"{path}: unmatched {closing}")
        if depth:
            raise ContractError(f"{path}: unmatched {opening}, depth={depth}")

    tokens = re.findall(r"\b[A-Za-z_][A-Za-z0-9_$]*\b", text)
    for opening, closing in (
        ("module", "endmodule"),
        ("interface", "endinterface"),
        ("task", "endtask"),
        ("function", "endfunction"),
        ("case", "endcase"),
        ("begin", "end"),
    ):
        if tokens.count(opening) != tokens.count(closing):
            raise ContractError(
                f"{path}: {opening}/{closing} mismatch "
                f"{tokens.count(opening)}/{tokens.count(closing)}"
            )


def preflight_environment(env_name: str) -> ValidationSummary:
    manifest_path = REPO_ROOT / "verif" / env_name / "module.json"
    if not generate(manifest_path, check=True):
        raise ContractError(f"generated artifacts drifted for {env_name}")
    contract = load_environment(REPO_ROOT, env_name)
    summary = validate_environment(contract)
    for path in sorted((contract.env_dir / "tb").glob("*.sv*")):
        validate_sv_structure(path)
    print(
        f"{contract.manifest.feature_prefix}_PREFLIGHT_PASS "
        f"features={summary.feature_count} scenarios={summary.scenario_count} "
        f"per_feature_min={summary.minimum_scenarios} signals={summary.signal_count}"
    )
    return summary


def _environment_names() -> list[str]:
    return sorted(
        path.parent.name
        for path in (REPO_ROOT / "verif").glob("xx_lsu_*/module.json")
    )


def _arguments() -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    selector = parser.add_mutually_exclusive_group(required=True)
    selector.add_argument("--env")
    selector.add_argument("--all", action="store_true")
    return parser.parse_args()


def main() -> int:
    args = _arguments()
    names = _environment_names() if args.all else [args.env]
    if not names:
        print("PREFLIGHT_FAIL: no module manifests found", file=sys.stderr)
        return 1
    try:
        summaries = [preflight_environment(name) for name in names]
    except (ContractError, FileNotFoundError, OSError, ValueError) as error:
        print(f"PREFLIGHT_FAIL: {error}", file=sys.stderr)
        return 1
    environment_count = len(summaries)
    feature_count = sum(item.feature_count for item in summaries)
    scenario_count = sum(item.scenario_count for item in summaries)
    print(
        "LSU_PREFLIGHT_PASS "
        f"environments={environment_count} "
        f"features={feature_count} "
        f"scenarios={scenario_count}"
    )
    if args.all:
        if set(names) != set(APPROVED_ENVIRONMENTS):
            print(
                "PREFLIGHT_FAIL: environment set differs from interaction-2.1 approval",
                file=sys.stderr,
            )
            return 1
        for name, summary in zip(names, summaries):
            expected_features, expected_scenarios, expected_minimum = APPROVED_ENVIRONMENTS[name]
            actual = (summary.feature_count, summary.scenario_count, summary.minimum_scenarios)
            expected = (expected_features, expected_scenarios, expected_minimum)
            if any(actual[index] < expected[index] for index in range(3)):
                print(
                    f"PREFLIGHT_FAIL: {name} below approved minimum: {actual} < {expected}",
                    file=sys.stderr,
                )
                return 1
        print(
            "INTERACTION_2_1_PREFLIGHT_PASS "
            f"environments={environment_count} features={feature_count} scenarios={scenario_count}"
        )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
