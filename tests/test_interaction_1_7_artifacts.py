import re
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]

REQUIRED_HEADER = (
    "| 二级功能点 | 三级功能点 | 功能点描述 | "
    "测试方法和配置说明 | 优先级 |"
)

REQUIRED_PLANS = {
    "doc-ag/xx_lsu_ld_ag_feature_test_plan.md": ("xx_lsu_ld_ag",),
    "doc-dc/xx_lsu_ld_dc_feature_test_plan.md": ("xx_lsu_ld_dc",),
    "doc-da/xx_lsu_ld_da_feature_test_plan.md": ("xx_lsu_ld_da",),
    "doc-wb/xx_lsu_ld_wb_feature_test_plan.md": ("xx_lsu_ld_wb",),
    "doc-lrq/xx_lsu_lrq_feature_test_plan.md": (
        "xx_lsu_lrq",
        "xx_lsu_lrq_entry",
    ),
    "doc-rb/xx_lsu_rb_feature_test_plan.md": (
        "xx_lsu_rb",
        "xx_lsu_rb_entry",
    ),
    "doc-lq/xx_lsu_lq_feature_test_plan.md": (
        "xx_lsu_lq",
        "xx_lsu_lq_entry",
    ),
    "doc-lfb/xx_lsu_lfb_feature_test_plan.md": (
        "xx_lsu_lfb",
        "xx_lsu_lfb_addr_entry",
    ),
}

REQUIRED_REVIEWS = (
    "doc-rtu/xx_rtu_retire_risk_review.md",
    "doc-rtu/xx_rtu_retire_verification_focus.md",
    "docs/interaction-1.7-followup-review.md",
)

SOURCE_ANCHOR = re.compile(r"`?srcs/[A-Za-z0-9_./-]+\.(?:sv|v):\d+")
PLACEHOLDER = re.compile(r"\b(?:TBD|TODO)\b|待补充", re.IGNORECASE)


class Interaction17ArtifactTests(unittest.TestCase):
    def required_text(self, relative_path: str) -> str:
        path = ROOT / relative_path
        self.assertTrue(path.is_file(), msg=f"missing required artifact: {relative_path}")
        return path.read_text(encoding="utf-8")

    def test_all_feature_test_plans_have_required_schema_and_coverage(self) -> None:
        for relative_path, modules in REQUIRED_PLANS.items():
            with self.subTest(path=relative_path):
                text = self.required_text(relative_path)
                self.assertIn(REQUIRED_HEADER, text)
                self.assertIsNone(
                    PLACEHOLDER.search(text),
                    msg=f"placeholder text remains in {relative_path}",
                )
                for module in modules:
                    self.assertIn(module, text)

                rows = [
                    line
                    for line in text.splitlines()
                    if line.startswith("| ")
                    and line != REQUIRED_HEADER
                    and not re.fullmatch(r"\|[\s:|-]+\|", line)
                ]
                self.assertGreaterEqual(
                    len(rows),
                    8,
                    msg=f"{relative_path} has fewer than 8 feature rows",
                )
                self.assertRegex(text, SOURCE_ANCHOR)
                for row in rows:
                    columns = [cell.strip() for cell in row.strip("|").split("|")]
                    self.assertEqual(
                        len(columns),
                        5,
                        msg=f"row does not have five columns: {row}",
                    )
                    self.assertTrue(
                        columns[3],
                        msg=f"test method/configuration is empty: {row}",
                    )
                    self.assertRegex(columns[4], r"^P[0-3]$")

    def test_rtu_review_has_traceable_findings_and_verification(self) -> None:
        risk = self.required_text(REQUIRED_REVIEWS[0])
        verification = self.required_text(REQUIRED_REVIEWS[1])

        self.assertRegex(risk, r"RTU-RR-\d{2}")
        self.assertRegex(risk, r"\bP[0-3]\b")
        self.assertRegex(risk, r"已确认|高风险|合同依赖|验证义务|未发现")
        self.assertRegex(risk, SOURCE_ANCHOR)
        self.assertRegex(risk, r"\b[0-9a-f]{40}\b")
        self.assertIsNone(PLACEHOLDER.search(risk))

        self.assertIn("RTU-RR-", verification)
        self.assertRegex(verification, r"断言|assert")
        self.assertIn("覆盖", verification)
        self.assertIn("关闭条件", verification)
        self.assertIsNone(PLACEHOLDER.search(verification))

    def test_overall_report_closes_both_readme_items(self) -> None:
        report = self.required_text(REQUIRED_REVIEWS[2])
        self.assertIn("README 第 1 项", report)
        self.assertIn("README 第 2 项", report)
        self.assertIn("xx_rtu_retire", report)
        for modules in REQUIRED_PLANS.values():
            for module in modules:
                self.assertIn(module, report)
        self.assertIn("静态", report)
        self.assertIn("动态", report)
        self.assertIsNone(PLACEHOLDER.search(report))


if __name__ == "__main__":
    unittest.main()
