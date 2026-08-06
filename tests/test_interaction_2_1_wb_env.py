import unittest

from tests.interaction_2_1_support import validate_named_environment


class Interaction21WbEnvironmentTests(unittest.TestCase):
    def test_wb_environment_covers_arbitration_implications_and_no_starvation_contract(self) -> None:
        summary = validate_named_environment("xx_lsu_ld_wb")

        self.assertEqual(72, summary.scenario_count)
        for token in (
            "req=1",
            "DP=1",
            "gate=1",
            "DP-only",
            "任意空闲lane",
            "不会丢失",
        ):
            self.assertIn(token, summary.markdown)


if __name__ == "__main__":
    unittest.main()
