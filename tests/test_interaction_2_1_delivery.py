import re
import subprocess
import sys
import unittest

from tests.interaction_2_1_support import ROOT


class Interaction21DeliveryTests(unittest.TestCase):
    def test_interaction_2_1_aggregate_delivery(self) -> None:
        completed = subprocess.run(
            [sys.executable, "verif/common/tools/preflight.py", "--all"],
            cwd=ROOT,
            text=True,
            capture_output=True,
        )

        self.assertEqual(0, completed.returncode, completed.stderr)
        self.assertRegex(
            completed.stdout,
            re.compile(
                r"INTERACTION_2_1_PREFLIGHT_PASS "
                r"environments=7 features=85 "
                r"scenarios=(53[4-9]|5[4-9][0-9]|[6-9][0-9]{2,})"
            ),
        )


if __name__ == "__main__":
    unittest.main()
