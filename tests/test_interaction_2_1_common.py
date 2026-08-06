import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

from verif.common.tools.rtl_ports import parse_module_ports
from verif.common.tools.scenario_contract import (
    ContractError,
    validate_environment,
)

from tests.interaction_2_1_support import copy_fixture_env, make_contract, run_gen


ROOT = Path(__file__).resolve().parents[1]


class RtlPortTests(unittest.TestCase):
    def test_parses_real_non_ansi_dc_ports_in_header_order(self) -> None:
        source = (ROOT / "srcs/xx_lsu_ld_dc.sv").read_text(encoding="utf-8")
        ports = parse_module_ports(source, "xx_lsu_ld_dc")

        self.assertGreater(len(ports), 100)
        self.assertEqual("cb_ld_dc_addr_hit", ports[0].name)
        self.assertIn("cpurst_b", {port.name for port in ports})
        self.assertEqual(len(ports), len({port.name for port in ports}))
        self.assertTrue(
            any(
                port.name == "ldc_lda_ex2_inst_vld"
                and port.direction == "output"
                for port in ports
            )
        )

    def test_rejects_missing_or_duplicate_declarations(self) -> None:
        duplicate = "module demo(a,a); input a; endmodule"
        with self.assertRaisesRegex(ValueError, "duplicate header port"):
            parse_module_ports(duplicate, "demo")

        missing = "module demo(a,b); input a; endmodule"
        with self.assertRaisesRegex(ValueError, "missing declarations"):
            parse_module_ports(missing, "demo")

    def test_parses_real_ansi_rb_ports_in_header_order(self) -> None:
        source = (ROOT / "srcs/xx_lsu_rb.sv").read_text(encoding="utf-8")

        ports = parse_module_ports(source, "xx_lsu_rb")

        self.assertGreater(len(ports), 300)
        self.assertEqual("biu_lsu_b_id", ports[0].name)
        self.assertTrue(
            any(
                port.name == "rb_biu_ar_req" and port.direction == "output"
                for port in ports
            )
        )


class ScenarioContractTests(unittest.TestCase):
    def test_rejects_unknown_signal_and_non_leaf_language(self) -> None:
        fixture = make_contract(
            drive_signals="signal_not_in_rtl",
            trigger_condition="当 `signal_not_in_rtl=1` 时",
            expected_result="则正常处理",
        )
        with self.assertRaisesRegex(
            ContractError, "unknown drive or observed signal"
        ):
            validate_environment(fixture)

        vague = make_contract(expected_result="则正常处理")
        with self.assertRaisesRegex(
            ContractError, "expected result names no delivered signal"
        ):
            validate_environment(vague)

    def test_requires_declared_stubs_and_exact_markdown_rows(self) -> None:
        fixture = make_contract(
            stub_modules=["xx_missing_dep"],
            declared_stubs=[],
        )
        with self.assertRaisesRegex(ContractError, "undeclared dependency stub"):
            validate_environment(fixture)


class EnvironmentGenerationTests(unittest.TestCase):
    def test_generator_check_detects_stale_interface(self) -> None:
        with tempfile.TemporaryDirectory() as temporary_directory:
            env = copy_fixture_env(Path(temporary_directory))
            (env / "tb/demo_if.sv").write_text("stale", encoding="utf-8")

            completed = run_gen(env, check=True)

        self.assertNotEqual(0, completed.returncode)
        self.assertIn("generated file is stale", completed.stderr)

    def test_aggregate_preflight_names_each_environment(self) -> None:
        completed = subprocess.run(
            [sys.executable, "verif/common/tools/preflight.py", "--all"],
            cwd=ROOT,
            text=True,
            capture_output=True,
        )

        self.assertEqual(0, completed.returncode, completed.stderr)
        self.assertIn("AG_PREFLIGHT_PASS", completed.stdout)


if __name__ == "__main__":
    unittest.main()
