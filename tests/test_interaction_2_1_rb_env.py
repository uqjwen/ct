import unittest

from tests.interaction_2_1_support import validate_named_environment


class Interaction21RbEnvironmentTests(unittest.TestCase):
    def test_rb_environment_tracks_generation_rid_and_entry_lifecycle(self) -> None:
        summary = validate_named_environment("xx_lsu_rb")

        self.assertEqual((12, 72), (summary.feature_count, summary.scenario_count))
        for token in (
            "{entry, IID, generation, BIU ID, owner}",
            "恰好两拍",
            "B response",
            "async flush",
        ):
            self.assertIn(token, summary.markdown)


if __name__ == "__main__":
    unittest.main()
