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
                "1??????????????", "01?????????????", "001????????????",
                "0001???????????", "00001??????????", "000001?????????",
                "0000001????????", "00000001???????", "000000001??????",
                "0000000001?????", "00000000001????", "000000000001???",
                "0000000000001??", "00000000000001?", "000000000000001",
            ],
            payload["interrupt_priority"]["selectors"],
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
        self.assertEqual(
            {
                "cause": 23,
                "request_selects_supervisor": True,
                "trap_classifies_supervisor": False,
            },
            payload.get("mcip_delegation"),
        )
        self.assertEqual(0, payload["ack_consumers"])
        self.assertEqual(
            {
                "iui_illegal_cause_mtval": True,
                "machine_trap_csr_update": True,
                "supervisor_trap_csr_update": True,
                "mret_sret_return_pc": True,
                "wfi_noop_wakeup_fsm": True,
            },
            payload["key_paths"],
        )

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

    def test_rejects_interrupt_priority_selector_drift(self) -> None:
        temporary, root = self.temporary_cp0_root()
        with temporary:
            iui = root / "cp0/wk_cp0_iui.v"
            contents = iui.read_text(encoding="utf-8")
            self.assertIn("15'b1?????????????? : valid_int_vec[4:0] = 5'd23;", contents)
            iui.write_text(
                contents.replace(
                    "15'b1?????????????? : valid_int_vec[4:0] = 5'd23;",
                    "15'b01????????????? : valid_int_vec[4:0] = 5'd23;",
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

    def test_rejects_interrupt_ack_consumer_in_declaration_assignment(self) -> None:
        for declaration in ("wire", "reg"):
            with self.subTest(declaration=declaration):
                temporary, root = self.temporary_cp0_root()
                with temporary:
                    regs = root / "cp0/wk_cp0_regs.v"
                    contents = regs.read_text(encoding="utf-8")
                    self.assertIn("endmodule", contents)
                    regs.write_text(
                        contents.rsplit("endmodule", 1)[0]
                        + f"{declaration} contract_drift_ack_consumer = "
                        "rtu_cp0_int_ack;\nendmodule"
                        + contents.rsplit("endmodule", 1)[1],
                        encoding="utf-8",
                    )

                    completed = self.run_checker("--root", str(root))

                self.assertNotEqual(0, completed.returncode)
                self.assertIn("ack-consumer", completed.stderr.lower())

    def test_ignores_interrupt_ack_in_comments_and_string_text(self) -> None:
        temporary, root = self.temporary_cp0_root()
        with temporary:
            regs = root / "cp0/wk_cp0_regs.v"
            contents = regs.read_text(encoding="utf-8")
            self.assertIn("endmodule", contents)
            regs.write_text(
                contents.rsplit("endmodule", 1)[0]
                + "// rtu_cp0_int_ack is documentation, not a consumer\n"
                + 'initial $display("rtu_cp0_int_ack");\nendmodule'
                + contents.rsplit("endmodule", 1)[1],
                encoding="utf-8",
            )

            completed = self.run_checker("--root", str(root))

        self.assertEqual(0, completed.returncode, completed.stderr)

    def test_rejects_mcip_request_side_delegation_bit_drift(self) -> None:
        temporary, root = self.temporary_cp0_root()
        with temporary:
            regs = root / "cp0/wk_cp0_regs.v"
            contents = regs.read_text(encoding="utf-8")
            original = "&& mcip_en && mideleg_value[23];"
            self.assertIn(original, contents)
            regs.write_text(
                contents.replace(original, "&& mcip_en && mideleg_value[22];", 1),
                encoding="utf-8",
            )

            completed = self.run_checker("--root", str(root))

        self.assertNotEqual(0, completed.returncode)
        self.assertIn("mcip delegation", completed.stderr.lower())

    def test_rejects_mcip_trap_side_becoming_delegated(self) -> None:
        temporary, root = self.temporary_cp0_root()
        with temporary:
            regs = root / "cp0/wk_cp0_regs.v"
            contents = regs.read_text(encoding="utf-8")
            original = "&& |(vec_num[18:0] & mideleg_value[18:0]);"
            self.assertIn(original, contents)
            regs.write_text(
                contents.replace(
                    original,
                    "&& (rtu_yy_xx_expt_vec[4:0] == 5'd23 "
                    "|| |(vec_num[18:0] & mideleg_value[18:0]));",
                    1,
                ),
                encoding="utf-8",
            )

            completed = self.run_checker("--root", str(root))

        self.assertNotEqual(0, completed.returncode)
        self.assertIn("mcip delegation", completed.stderr.lower())

    def test_rejects_wfi_ack_missing_biu_term(self) -> None:
        temporary, root = self.temporary_cp0_root()
        with temporary:
            lpmd = root / "cp0/wk_cp0_lpmd.v"
            contents = lpmd.read_text(encoding="utf-8")
            original = "                  && biu_yy_xx_no_op\n"
            self.assertIn(original, contents)
            lpmd.write_text(contents.replace(original, "", 1), encoding="utf-8")

            completed = self.run_checker("--root", str(root))

        self.assertNotEqual(0, completed.returncode)
        self.assertIn("wfi no-op/wakeup fsm", completed.stderr.lower())

    def test_rejects_wfi_wakeup_missing_debug_term(self) -> None:
        temporary, root = self.temporary_cp0_root()
        with temporary:
            lpmd = root / "cp0/wk_cp0_lpmd.v"
            contents = lpmd.read_text(encoding="utf-8")
            original = "biu_cp0_int_wakeup || rtu_yy_xx_dbgon || biu_cp0_event_wakeup"
            self.assertIn(original, contents)
            lpmd.write_text(
                contents.replace(
                    original,
                    "biu_cp0_int_wakeup || biu_cp0_event_wakeup",
                    1,
                ),
                encoding="utf-8",
            )

            completed = self.run_checker("--root", str(root))

        self.assertNotEqual(0, completed.returncode)
        self.assertIn("wfi no-op/wakeup fsm", completed.stderr.lower())

    def test_invalid_cli_is_one_contract_failure_line(self) -> None:
        completed = self.run_checker("--not-a-real-option")

        self.assertNotEqual(0, completed.returncode)
        self.assertEqual("", completed.stdout)
        self.assertEqual(1, len(completed.stderr.splitlines()))
        self.assertTrue(completed.stderr.startswith("CP0_CONTRACT_FAIL: "))

    def test_rejects_duplicate_checked_interrupt_source_assignment(self) -> None:
        temporary, root = self.temporary_cp0_root()
        with temporary:
            regs = root / "cp0/wk_cp0_regs.v"
            contents = regs.read_text(encoding="utf-8")
            self.assertIn("endmodule", contents)
            regs.write_text(
                contents.rsplit("endmodule", 1)[0]
                + "assign meip = 1'b0;\nendmodule"
                + contents.rsplit("endmodule", 1)[1],
                encoding="utf-8",
            )

            completed = self.run_checker("--root", str(root))

        self.assertNotEqual(0, completed.returncode)
        self.assertIn("duplicate assignment", completed.stderr.lower())


if __name__ == "__main__":
    unittest.main()
