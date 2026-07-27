import re
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
BASELINE = "4a8223a2d80a5da6a7198c6fc89d97790b9729c3"
SOURCE_ANCHOR = re.compile(r"`?srcs/[A-Za-z0-9_./-]+\.(?:sv|v):\d+")
PLACEHOLDER = re.compile(r"\b(?:TBD|TODO)\b|待补充", re.IGNORECASE)

REQUIRED_REAUDITS = {
    "doc-ag/xx_lsu_ld_ag_interaction_1_8_reaudit.md": ("xx_lsu_ld_ag",),
    "doc-dc/xx_lsu_ld_dc_interaction_1_8_reaudit.md": ("xx_lsu_ld_dc",),
    "doc-da/xx_lsu_ld_da_interaction_1_8_reaudit.md": ("xx_lsu_ld_da",),
    "doc-wb/xx_lsu_ld_wb_interaction_1_8_reaudit.md": ("xx_lsu_ld_wb",),
    "doc-lrq/xx_lsu_lrq_interaction_1_8_reaudit.md": (
        "xx_lsu_lrq",
        "xx_lsu_lrq_entry",
    ),
    "doc-rb/xx_lsu_rb_interaction_1_8_reaudit.md": (
        "xx_lsu_rb",
        "xx_lsu_rb_entry",
    ),
    "doc-lq/xx_lsu_lq_interaction_1_8_reaudit.md": (
        "xx_lsu_lq",
        "xx_lsu_lq_entry",
    ),
    "doc-lfb/xx_lsu_lfb_interaction_1_8_reaudit.md": (
        "xx_lsu_lfb",
        "xx_lsu_lfb_addr_entry",
    ),
}


class Interaction18ReviewTests(unittest.TestCase):
    def required_text(self, relative_path: str) -> str:
        path = ROOT / relative_path
        self.assertTrue(path.is_file(), msg=f"missing required artifact: {relative_path}")
        return path.read_text(encoding="utf-8")

    def test_rtu_rr_02_explains_halfword_unit_bug_and_independent_extension(self) -> None:
        risk = self.required_text("doc-rtu/xx_rtu_retire_risk_review.md")
        verification = self.required_text("doc-rtu/xx_rtu_retire_verification_focus.md")

        for token in (
            "半字地址",
            "字节地址",
            "0xFFE",
            "0x7FF",
            "0x801",
            "0x1000",
            "左移",
            "符号扩展",
        ):
            self.assertIn(token, risk)
        self.assertRegex(risk, r"cur_pc.*1'b0")
        self.assertRegex(risk, r"RTU-RR-02")
        self.assertIn("独立", risk)
        self.assertIn("RTU-RR-02", verification)
        self.assertIn("0x1000", verification)
        self.assertRegex(verification, r"assert|断言")

    def test_all_lsu_reaudits_are_traceable_and_have_closure(self) -> None:
        for relative_path, modules in REQUIRED_REAUDITS.items():
            with self.subTest(path=relative_path):
                text = self.required_text(relative_path)
                self.assertIn(BASELINE, text)
                for module in modules:
                    self.assertIn(module, text)
                self.assertRegex(text, SOURCE_ANCHOR)
                self.assertRegex(text, r"\bP[0-3]\b")
                self.assertRegex(
                    text,
                    r"已确认|高置信|合同依赖|验证义务|未发现新增",
                )
                self.assertRegex(text, r"动态关闭|关闭条件")
                self.assertIsNone(
                    PLACEHOLDER.search(text),
                    msg=f"placeholder text remains in {relative_path}",
                )

    def test_overall_report_closes_both_readme_items_and_all_modules(self) -> None:
        report = self.required_text("docs/interaction-1.8-followup-review.md")
        self.assertIn("README 第 1 项", report)
        self.assertIn("README 第 2 项", report)
        self.assertIn("RTU-RR-02", report)
        self.assertIn("0xFFE", report)
        self.assertIn("0x1000", report)
        for modules in REQUIRED_REAUDITS.values():
            for module in modules:
                self.assertIn(module, report)
        self.assertIn("静态", report)
        self.assertIn("动态", report)
        self.assertIsNone(PLACEHOLDER.search(report))


if __name__ == "__main__":
    unittest.main()
