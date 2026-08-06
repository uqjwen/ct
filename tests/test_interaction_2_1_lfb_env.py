import unittest

from tests.interaction_2_1_support import validate_named_environment


class Interaction21LfbEnvironmentTests(unittest.TestCase):
    def test_lfb_environment_is_complete_and_names_missing_data_entry(self) -> None:
        summary = validate_named_environment("xx_lsu_lfb")

        self.assertEqual((13, 78, 6), (
            summary.feature_count,
            summary.scenario_count,
            summary.minimum_scenarios,
        ))
        self.assertEqual(
            "PENDING_FULL_CHIP",
            summary.stub_results["xx_lsu_lfb_data_entry"],
        )
        self.assertIn("srcs/xx_lsu_lfb_data_entry.sv", summary.runbook)


if __name__ == "__main__":
    unittest.main()
