import unittest
from collections import Counter
from pathlib import Path

from tests.interaction_2_1_support import read_detail, scenario_signals


ROOT = Path(__file__).resolve().parents[1]


class Interaction21AgDetailTests(unittest.TestCase):
    def test_ag_has_eight_leaf_scenarios_per_feature(self) -> None:
        rows = read_detail("xx_lsu_ld_ag")
        counts = Counter(row["feature_id"] for row in rows)

        self.assertGreaterEqual(len(rows), 96)
        self.assertEqual(12, len(counts))
        self.assertTrue(all(count >= 8 for count in counts.values()))

    def test_ag_contains_older_rf_abort_tlbmiss_immediate_replay(self) -> None:
        rows = read_detail("xx_lsu_ld_ag")
        required = {
            "lag_ex1_stall_ori",
            "idu_lsu_rf_older_vld",
            "mmu_lsu_pa_vld",
            "lsu_mmu_abort",
            "lag_ex1_stall_restart_entry",
            "lsu_lrq_create_frz",
        }
        matches = [row for row in rows if required <= scenario_signals(row)]

        self.assertEqual(1, len(matches))
        self.assertIn("`lsu_mmu_abort=1`", matches[0]["trigger_condition"])
        self.assertIn("`lsu_lrq_create_frz=0`", matches[0]["expected_result"])

    def test_exact_path_has_driver_assertion_and_coverage(self) -> None:
        tb = (ROOT / "verif/xx_lsu_ld_ag/tb/xx_lsu_ld_ag_tb.sv").read_text(
            encoding="utf-8"
        )
        assertions = (
            ROOT / "verif/xx_lsu_ld_ag/tb/xx_lsu_ld_ag_assertions.sv"
        ).read_text(encoding="utf-8")

        self.assertIn("AG-FP-05-S07", tb)
        self.assertIn("dut.ld_ag_stall_mask", tb)
        self.assertIn("CHK_FP05_MASK_ABORT_REPLAY", assertions)
        self.assertIn("COV_FP05_MASK_ABORT_TABLE", assertions)


if __name__ == "__main__":
    unittest.main()
