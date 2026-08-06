import unittest

from tests.interaction_2_1_support import validate_named_environment


class Interaction21LrqEnvironmentTests(unittest.TestCase):
    def test_lrq_environment_covers_flush_create_and_late_wakeup_reuse(self) -> None:
        summary = validate_named_environment("xx_lsu_lrq")

        self.assertEqual((12, 72, 6), (
            summary.feature_count,
            summary.scenario_count,
            summary.minimum_scenarios,
        ))
        for token in (
            "create_vld=1",
            "flush",
            "create_success=0",
            "旧 owner",
            "entry复用",
            "wakeup",
        ):
            self.assertIn(token, summary.markdown)


if __name__ == "__main__":
    unittest.main()
