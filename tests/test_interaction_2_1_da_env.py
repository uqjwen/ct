import unittest

from tests.interaction_2_1_support import validate_named_environment


class Interaction21DaEnvironmentTests(unittest.TestCase):
    def test_da_environment_covers_four_block_data_and_terminal_states(self) -> None:
        summary = validate_named_environment("xx_lsu_ld_da")

        self.assertEqual(
            (12, 72, 6),
            (
                summary.feature_count,
                summary.scenario_count,
                summary.minimum_scenarios,
            ),
        )
        for token in ("四块互异数据", "completion", "RB create", "LQ pop", "唯一终态"):
            self.assertIn(token, summary.markdown)


if __name__ == "__main__":
    unittest.main()
