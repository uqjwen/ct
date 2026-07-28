import csv
import re
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
ENV = ROOT / "verif/xx_lsu_ld_ag"
FEATURE_IDS = [f"AG-FP-{index:02d}" for index in range(1, 13)]


class Interaction19VcsEnvironmentTests(unittest.TestCase):
    def text(self, relative_path: str) -> str:
        path = ROOT / relative_path
        self.assertTrue(path.is_file(), msg=f"missing required artifact: {relative_path}")
        return path.read_text(encoding="utf-8")

    def test_vcs_environment_has_reproducible_entrypoints(self) -> None:
        required = (
            "verif/xx_lsu_ld_ag/Makefile",
            "verif/xx_lsu_ld_ag/filelist.f",
            "verif/xx_lsu_ld_ag/tests.list",
            "verif/xx_lsu_ld_ag/coverage_matrix.csv",
            "verif/xx_lsu_ld_ag/tb/xx_lsu_ld_ag_defs.svh",
            "verif/xx_lsu_ld_ag/tb/xx_lsu_ld_ag_deps.sv",
            "verif/xx_lsu_ld_ag/tb/xx_lsu_ld_ag_if.sv",
            "verif/xx_lsu_ld_ag/tb/xx_lsu_ld_ag_connect.svh",
            "verif/xx_lsu_ld_ag/tb/xx_lsu_ld_ag_assertions.sv",
            "verif/xx_lsu_ld_ag/tb/xx_lsu_ld_ag_tb.sv",
            "verif/xx_lsu_ld_ag/tools/gen_dut_if.py",
            "verif/xx_lsu_ld_ag/tools/check_completeness.py",
            "verif/xx_lsu_ld_ag/tools/reference_model.py",
        )
        for relative_path in required:
            self.text(relative_path)

        makefile = self.text("verif/xx_lsu_ld_ag/Makefile")
        for target in ("preflight:", "compile:", "run:", "regress:", "coverage:"):
            self.assertIn(target, makefile)
        for tool in ("vcs", "urg"):
            self.assertRegex(makefile, rf"\b{tool}\b")
        self.assertIn("+TEST=$(TEST)", makefile)

        filelist = self.text("verif/xx_lsu_ld_ag/filelist.f")
        self.assertIn("srcs/xx_lsu_ld_ag.sv", filelist)
        self.assertIn("xx_lsu_ld_ag_deps.sv", filelist)
        self.assertIn("xx_lsu_ld_ag_tb.sv", filelist)

    def test_every_feature_has_test_check_coverage_and_result(self) -> None:
        matrix_path = ENV / "coverage_matrix.csv"
        self.assertTrue(matrix_path.is_file(), msg="missing coverage_matrix.csv")
        with matrix_path.open(encoding="utf-8", newline="") as stream:
            rows = list(csv.DictReader(stream))

        self.assertEqual(FEATURE_IDS, [row["feature_id"] for row in rows])
        required_columns = {
            "feature_id",
            "feature",
            "testcase",
            "checker",
            "coverage",
            "priority",
            "closure",
            "result",
        }
        self.assertEqual(required_columns, set(rows[0]))

        test_names = {
            line.strip()
            for line in self.text("verif/xx_lsu_ld_ag/tests.list").splitlines()
            if line.strip() and not line.lstrip().startswith("#")
        }
        tb = self.text("verif/xx_lsu_ld_ag/tb/xx_lsu_ld_ag_tb.sv")
        assertions = self.text(
            "verif/xx_lsu_ld_ag/tb/xx_lsu_ld_ag_assertions.sv"
        )
        combined = tb + "\n" + assertions

        for row in rows:
            with self.subTest(feature_id=row["feature_id"]):
                self.assertIn(row["testcase"], test_names)
                self.assertRegex(tb, rf"\btask\s+automatic\s+{row['testcase']}\b")
                self.assertIn(row["checker"], combined)
                self.assertIn(row["coverage"], combined)
                self.assertRegex(row["priority"], r"^P[01]$")
                self.assertTrue(row["closure"].strip())
                self.assertIn(
                    row["result"],
                    {"BLOCKED_NO_VCS", "PENDING_FULL_CHIP"},
                )

    def test_generated_interface_covers_every_dut_port(self) -> None:
        source = self.text("srcs/xx_lsu_ld_ag.sv")
        header = source[source.index("module xx_lsu_ld_ag") :]
        header = header[: header.index(");")]
        header = re.sub(r"//.*", "", header)
        parameter_end = header.index(")(") + 2
        ports = [
            token.strip()
            for token in header[parameter_end:].split(",")
            if token.strip()
        ]
        self.assertEqual(258, len(ports))

        connections = self.text(
            "verif/xx_lsu_ld_ag/tb/xx_lsu_ld_ag_connect.svh"
        )
        connected = re.findall(r"\.(\w+)\s*\(\s*bus\.\1\s*\)", connections)
        self.assertEqual(ports, connected)

        interface = self.text("verif/xx_lsu_ld_ag/tb/xx_lsu_ld_ag_if.sv")
        for port in ports:
            self.assertRegex(interface, rf"\b{re.escape(port)}\s*;")

    def test_standalone_layer_defines_every_instantiated_dependency(self) -> None:
        source = self.text("srcs/xx_lsu_ld_ag.sv")
        dependencies = self.text(
            "verif/xx_lsu_ld_ag/tb/xx_lsu_ld_ag_deps.sv"
        )
        instantiated = set(
            re.findall(
                r"^\s*(gated_clk_cell|xx_lsu_[A-Za-z0-9_]+)\b",
                source,
                re.MULTILINE,
            )
        )
        defined = set(
            re.findall(
                r"^\s*module\s+(gated_clk_cell|xx_lsu_[A-Za-z0-9_]+)\b",
                dependencies,
                re.MULTILINE,
            )
        )
        self.assertEqual(
            instantiated,
            defined,
            msg=f"dependency mismatch: instantiated={instantiated}, defined={defined}",
        )

    def test_reports_explain_execution_boundary_and_canonical_example(self) -> None:
        report = self.text("doc-ag/xx_lsu_ld_ag_vcs_verification.md")
        overall = self.text("docs/interaction-1.9-followup-review.md")
        canonical = self.text("doc-rtu/xx_rtu_retire_canonical_example.md")

        for command in (
            "make preflight",
            "make compile",
            "make run TEST=",
            "make regress",
            "make coverage",
        ):
            self.assertIn(command, report)
        self.assertIn("BLOCKED_NO_VCS", report)
        self.assertIn("12/12", report)
        self.assertIn("interaction 1.9", overall.lower())
        self.assertIn("VCS", overall)

        for value in (
            "0xffffff8000001000",
            "0x0000018000001000",
            "0x0000008000001000",
            "WK_PC_LEN=39",
        ):
            self.assertIn(value, canonical)
        self.assertRegex(canonical, r"符号扩展|canonical")
        self.assertIn("普通 instruction", canonical)

    def test_no_placeholder_language_in_delivery(self) -> None:
        paths = (
            "doc-ag/xx_lsu_ld_ag_vcs_verification.md",
            "doc-rtu/xx_rtu_retire_canonical_example.md",
            "docs/interaction-1.9-followup-review.md",
            "verif/xx_lsu_ld_ag/coverage_matrix.csv",
        )
        placeholder = re.compile(r"\b(?:TODO|TBD)\b|待补充", re.IGNORECASE)
        for path in paths:
            self.assertIsNone(placeholder.search(self.text(path)), msg=path)


if __name__ == "__main__":
    unittest.main()
