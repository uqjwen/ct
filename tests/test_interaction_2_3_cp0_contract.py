import json
import shutil
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
CHECKER = ROOT / "tools/check_interaction_2_3_cp0_contract.py"


class Interaction23Cp0ContractTests(unittest.TestCase):
    """Protect real CP0 interrupt and trap paths from stale reference drift."""

    def run_checker(self, *args: str, cwd: Path = ROOT) -> subprocess.CompletedProcess[str]:
        return subprocess.run(
            [sys.executable, str(CHECKER), *args],
            cwd=cwd,
            text=True,
            capture_output=True,
        )

    def temporary_cp0_root(self) -> tuple[tempfile.TemporaryDirectory[str], Path]:
        temporary = tempfile.TemporaryDirectory()
        root = Path(temporary.name)
        shutil.copytree(ROOT / "cp0", root / "cp0")
        return temporary, root

    def test_real_rtl_contract_passes_and_reports_hand_derived_facts(self) -> None:
        completed = self.run_checker("--json")

        self.assertEqual(0, completed.returncode, completed.stderr)
        payload = json.loads(completed.stdout)
        self.assertEqual(
            ["wk_cp0_top", "wk_cp0_iui", "wk_cp0_regs", "wk_cp0_lpmd"],
            payload["modules"],
        )
        self.assertEqual(
            ["wk_cp0_iui", "wk_cp0_regs", "wk_cp0_lpmd"],
            payload["top_submodules"],
        )
        self.assertEqual(
            {
                "meip": "biu_cp0_me_int",
                "mtip": "biu_cp0_mt_int",
                "msip": "biu_cp0_ms_int",
                "seip": "seip_s | biu_cp0_se_int",
                "stip": "stip_s | biu_cp0_st_int",
                "ssip": "mvssip",
                "mcip": "ecc_int_vld",
                "moip": "hpcp_cp0_int_vld",
            },
            payload["interrupt_sources"],
        )
        self.assertEqual(
            [23, 18, 11, 3, 7, 9, 1, 5, 13, 23, 18, 9, 1, 5, 13],
            payload["interrupt_priority"]["causes"],
        )
        self.assertEqual(
            [
                True, False, True, True, True, True, True, True, True,
                True, False, True, True, True, True,
            ],
            payload["interrupt_priority"]["live"],
        )
        self.assertEqual(
            [1, 2, 3, 4, 5, 6, 7, 8, 9, 12, 13, 15],
            payload["delegable_exceptions"],
        )
        self.assertEqual(0, payload["ack_consumers"])
        self.assertTrue(all(payload["key_paths"].values()))

    def test_rejects_interrupt_priority_cause_drift(self) -> None:
        temporary, root = self.temporary_cp0_root()
        with temporary:
            iui = root / "cp0/wk_cp0_iui.v"
            contents = iui.read_text(encoding="utf-8")
            self.assertIn("15'b1?????????????? : valid_int_vec[4:0] = 5'd23;", contents)
            iui.write_text(
                contents.replace(
                    "15'b1?????????????? : valid_int_vec[4:0] = 5'd23;",
                    "15'b1?????????????? : valid_int_vec[4:0] = 5'd22;",
                    1,
                ),
                encoding="utf-8",
            )

            completed = self.run_checker("--root", str(root))

        self.assertNotEqual(0, completed.returncode)
        self.assertIn("priority", completed.stderr.lower())

    def test_rejects_missing_top_submodule(self) -> None:
        temporary, root = self.temporary_cp0_root()
        with temporary:
            top = root / "cp0/wk_cp0_top.v"
            contents = top.read_text(encoding="utf-8")
            self.assertIn("wk_cp0_lpmd  x_wk_cp0_lpmd", contents)
            top.write_text(
                contents.replace(
                    "wk_cp0_lpmd  x_wk_cp0_lpmd",
                    "wk_cp0_lpmd  x_wk_cp0_lpmd_removed",
                    1,
                ),
                encoding="utf-8",
            )

            completed = self.run_checker("--root", str(root))

        self.assertNotEqual(0, completed.returncode)
        self.assertIn("topology", completed.stderr.lower())

    def test_rejects_new_interrupt_ack_consumer(self) -> None:
        temporary, root = self.temporary_cp0_root()
        with temporary:
            regs = root / "cp0/wk_cp0_regs.v"
            contents = regs.read_text(encoding="utf-8")
            self.assertIn("endmodule", contents)
            regs.write_text(
                contents.rsplit("endmodule", 1)[0]
                + "assign contract_drift_ack_consumer = rtu_cp0_int_ack;\nendmodule"
                + contents.rsplit("endmodule", 1)[1],
                encoding="utf-8",
            )

            completed = self.run_checker("--root", str(root))

        self.assertNotEqual(0, completed.returncode)
        self.assertIn("ack-consumer", completed.stderr.lower())


if __name__ == "__main__":
    unittest.main()
