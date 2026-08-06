import csv
import subprocess
import sys
import unittest
from collections import Counter
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
MANIFEST = ROOT / "waive/interaction_2_2_cp0_code_waiver_manifest.csv"
FIELDS = (
    "coverage_type", "source_object", "module", "source_section",
    "condition", "reason", "impact", "alternative", "property",
    "term", "remarks",
)
PASS_MARKER = (
    "CP0_WAIVER_WORKBOOK_PASS code_rows=45 function_rows=0 "
    "line=4 branch=5 condition=11 toggle=25 fsm=0"
)


def read_manifest() -> list[dict[str, str]]:
    with MANIFEST.open(encoding="utf-8", newline="") as stream:
        return list(csv.DictReader(stream))


class Interaction22Cp0WaiverTests(unittest.TestCase):
    def test_manifest_has_exact_source_contract(self) -> None:
        rows = read_manifest()
        self.assertEqual(45, len(rows))
        self.assertEqual(FIELDS, tuple(rows[0]))
        self.assertEqual(
            Counter({"toggle": 25, "condition": 11, "branch": 5, "line": 4}),
            Counter(row["coverage_type"] for row in rows),
        )
        self.assertEqual(
            Counter({"wk_cp0_regs": 29, "wk_cp0_iui": 13, "wk_cp0_lpmd": 3}),
            Counter(row["module"] for row in rows),
        )
        self.assertTrue(all(all(row[field].strip() for field in FIELDS) for row in rows))
        self.assertTrue(all(row["property"] == "DOCX代码覆盖率排除项" for row in rows))
        self.assertTrue(all(row["term"] == "待项目评审确认" for row in rows))

    def test_workbook_matches_manifest(self) -> None:
        completed = subprocess.run(
            [sys.executable, "tools/check_interaction_2_2_cp0_waiver.py"],
            cwd=ROOT,
            text=True,
            capture_output=True,
        )
        self.assertEqual(0, completed.returncode, completed.stderr)
        self.assertEqual(PASS_MARKER, completed.stdout.strip())
