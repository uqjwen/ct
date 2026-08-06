import collections
import csv
import importlib.util
import re
import subprocess
import sys
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
ENV = ROOT / "verif/xx_lsu_ld_ag"
DETAIL = ENV / "detailed_test_plan.csv"
FEATURE_PLAN = ROOT / "doc-ag/xx_lsu_ld_ag_feature_test_plan.md"
RUNBOOK = ROOT / "doc-ag/xx_lsu_ld_ag_vcs_verification.md"
REPORT = ROOT / "docs/interaction-2.0-followup-review.md"
FEATURE_IDS = [f"AG-FP-{index:02d}" for index in range(1, 13)]
EXPECTED_COLUMNS = (
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


def load_completeness_module():
    path = ENV / "tools/check_completeness.py"
    spec = importlib.util.spec_from_file_location("interaction20_completeness", path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot import completeness checker: {path}")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


class Interaction20DetailedPlanTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.checker = load_completeness_module()

    def text(self, path: Path) -> str:
        self.assertTrue(path.is_file(), msg=f"missing required artifact: {path}")
        return path.read_text(encoding="utf-8")

    def read_csv(self, path: Path) -> list[dict[str, str]]:
        self.assertTrue(path.is_file(), msg=f"missing required artifact: {path}")
        with path.open(encoding="utf-8", newline="") as stream:
            reader = csv.DictReader(stream)
            self.assertEqual(EXPECTED_COLUMNS, tuple(reader.fieldnames or ()))
            return list(reader)

    def parent_rows(self) -> dict[str, dict[str, str]]:
        with (ENV / "coverage_matrix.csv").open(
            encoding="utf-8", newline=""
        ) as stream:
            rows = list(csv.DictReader(stream))
        return {row["feature_id"]: row for row in rows}

    def known_signals(self) -> set[str]:
        sources = [(ROOT / "srcs/xx_lsu_ld_ag.sv").read_text(encoding="utf-8")]
        sources.extend(
            path.read_text(encoding="utf-8")
            for path in sorted((ENV / "tb").glob("*.sv*"))
        )
        return self.checker.signal_vocabulary(*sources)

    def validation_inputs(self):
        return (
            self.read_csv(DETAIL),
            self.parent_rows(),
            self.known_signals(),
            self.text(FEATURE_PLAN),
        )

    def test_every_feature_has_four_directly_implementable_scenarios(self) -> None:
        rows = self.read_csv(DETAIL)
        self.assertGreaterEqual(len(rows), 48)
        counts = collections.Counter(row["feature_id"] for row in rows)
        self.assertEqual(set(FEATURE_IDS), set(counts))
        self.assertTrue(
            all(counts[feature_id] >= 4 for feature_id in FEATURE_IDS),
            msg=f"per-feature scenario counts: {dict(counts)}",
        )
        self.assertEqual(len(rows), len({row["scenario_id"] for row in rows}))

    def test_real_scenario_contract_passes_validator(self) -> None:
        rows, parents, signals, plan = self.validation_inputs()
        counts = self.checker.validate_detailed_rows(
            rows, parents, signals, plan
        )
        self.assertGreaterEqual(min(counts.values()), 4)

    def test_validator_rejects_unknown_signal(self) -> None:
        rows, parents, signals, plan = self.validation_inputs()
        mutated = [dict(row) for row in rows]
        mutated[0]["drive_signals"] = "signal_that_is_not_delivered"
        with self.assertRaisesRegex(RuntimeError, "unknown drive signal"):
            self.checker.validate_detailed_rows(mutated, parents, signals, plan)

    def test_validator_rejects_grammar_and_parent_drift(self) -> None:
        rows, parents, signals, plan = self.validation_inputs()

        bad_trigger = [dict(row) for row in rows]
        bad_trigger[0]["trigger_condition"] = "missing trigger prefix"
        with self.assertRaisesRegex(RuntimeError, "trigger must begin with 当"):
            self.checker.validate_detailed_rows(
                bad_trigger, parents, signals, plan
            )

        bad_expectation = [dict(row) for row in rows]
        bad_expectation[0]["expected_result"] = "missing result prefix"
        with self.assertRaisesRegex(RuntimeError, "expected result must begin with 则"):
            self.checker.validate_detailed_rows(
                bad_expectation, parents, signals, plan
            )

        signal_free_trigger = [dict(row) for row in rows]
        signal_free_trigger[0]["trigger_condition"] = "当一般条件成立时"
        with self.assertRaisesRegex(RuntimeError, "trigger names no delivered signal"):
            self.checker.validate_detailed_rows(
                signal_free_trigger, parents, signals, plan
            )

        signal_free_result = [dict(row) for row in rows]
        signal_free_result[0]["expected_result"] = "则得到一般结果"
        with self.assertRaisesRegex(
            RuntimeError, "expected result names no delivered signal"
        ):
            self.checker.validate_detailed_rows(
                signal_free_result, parents, signals, plan
            )

        bad_parent = [dict(row) for row in rows]
        bad_parent[0]["testcase"] = "tc_wrong_parent"
        with self.assertRaisesRegex(RuntimeError, "parent testcase mismatch"):
            self.checker.validate_detailed_rows(
                bad_parent, parents, signals, plan
            )

        missing_document_row = plan.replace(rows[0]["scenario_id"], "")
        with self.assertRaisesRegex(RuntimeError, "scenario ID missing"):
            self.checker.validate_detailed_rows(
                rows, parents, signals, missing_document_row
            )

    def test_cli_and_reports_expose_detailed_plan_boundary(self) -> None:
        completed = subprocess.run(
            [sys.executable, str(ENV / "tools/check_completeness.py")],
            cwd=ROOT,
            check=False,
            capture_output=True,
            text=True,
        )
        self.assertEqual(0, completed.returncode, msg=completed.stderr)
        match = re.search(
            r"DETAILED_PLAN_PASS scenarios=(\d+) per_feature_min=(\d+)",
            completed.stdout,
        )
        self.assertIsNotNone(match, completed.stdout)
        assert match is not None
        self.assertGreaterEqual(int(match.group(1)), 48)
        self.assertGreaterEqual(int(match.group(2)), 4)

        runbook = self.text(RUNBOOK)
        report = self.text(REPORT)
        self.assertIn("detailed_test_plan.csv", runbook)
        self.assertIn("interaction 2.0", report.lower())
        for boundary in ("BLOCKED_NO_VCS", "PENDING_FULL_CHIP"):
            self.assertIn(boundary, runbook)
            self.assertIn(boundary, report)


if __name__ == "__main__":
    unittest.main()
