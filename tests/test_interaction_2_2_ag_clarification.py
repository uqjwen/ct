import subprocess
import sys
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]


class Interaction22AgClarificationTests(unittest.TestCase):
    def test_checker_accepts_real_input_to_observed_output_path(self) -> None:
        completed = subprocess.run(
            [sys.executable, "tools/check_interaction_2_2_ag_boundary.py"],
            cwd=ROOT,
            text=True,
            capture_output=True,
        )
        self.assertEqual(0, completed.returncode, completed.stderr)
        self.assertIn("AG_FP05_DUT_BOUNDARY_PASS inputs=4 outputs=3", completed.stdout)


if __name__ == "__main__":
    unittest.main()
