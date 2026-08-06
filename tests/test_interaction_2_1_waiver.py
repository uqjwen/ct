import subprocess
import sys
import unittest

from tests.interaction_2_1_support import ROOT, read_manifest


class Interaction21WaiverTests(unittest.TestCase):
    def test_workbook_matches_source_manifest_and_has_no_examples(self) -> None:
        completed = subprocess.run(
            [sys.executable, "tools/check_interaction_2_1_waiver.py"],
            cwd=ROOT,
            text=True,
            capture_output=True,
        )

        self.assertEqual(0, completed.returncode, completed.stderr)
        self.assertIn("WAIVER_WORKBOOK_PASS", completed.stdout)
        self.assertNotIn("CP0", completed.stdout)

    def test_manifest_has_only_documented_lsu_coverage_types(self) -> None:
        rows = read_manifest()

        self.assertGreater(len(rows), 50)
        self.assertEqual(
            {"line", "branch", "condition", "toggle", "fsm"},
            {row["coverage_type"] for row in rows},
        )
        self.assertTrue(
            all(row["source_section"].startswith("1.") for row in rows)
        )


if __name__ == "__main__":
    unittest.main()
