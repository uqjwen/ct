import unittest

from tests.interaction_2_1_support import validate_named_environment


class Interaction21DcEnvironmentTests(unittest.TestCase):
    def test_dc_environment_is_leaf_complete(self) -> None:
        summary = validate_named_environment("xx_lsu_ld_dc")

        self.assertEqual(12, summary.feature_count)
        self.assertEqual(72, summary.scenario_count)
        self.assertEqual(6, summary.minimum_scenarios)
        self.assertEqual(
            {"gated_clk_cell", "xx_lsu_compare_iid"},
            set(summary.declared_stubs),
        )


if __name__ == "__main__":
    unittest.main()
