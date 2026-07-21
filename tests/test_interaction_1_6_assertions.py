import re
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]


def read_source(path: str) -> str:
    return (ROOT / path).read_text(encoding="utf-8")


def strip_comments(source: str) -> str:
    """Remove SV comments so disabled text cannot satisfy a regression check."""
    return re.sub(r"//[^\n]*|/\*.*?\*/", "", source, flags=re.DOTALL)


def compact_source(source: str) -> str:
    """Remove formatting so checks describe assertion semantics, not style."""
    return re.sub(r"\s+", "", source)


def synthesis_excluded_source(path: str) -> str:
    source = strip_comments(read_source(path))
    blocks = re.findall(r"`ifndef\s+SYNTHESIS(.*?)`endif", source, flags=re.DOTALL)
    if not blocks:
        raise AssertionError(f"no `ifndef SYNTHESIS block found in {path}")
    return compact_source("\n".join(blocks))


class Interaction16AssertionTests(unittest.TestCase):
    def assert_source_contains(self, source: str, expected: str) -> None:
        self.assertTrue(expected in source, msg=f"missing source contract: {expected}")

    def test_lrq_wakeup_only_targets_live_entry(self) -> None:
        source = synthesis_excluded_source("srcs/xx_lsu_lrq.sv")
        comments = compact_source(read_source("srcs/xx_lsu_lrq.sv"))
        self.assert_source_contains(comments, "producer_owner_iid==entry_iid")
        for lane in (0, 2, 3):
            with self.subTest(lane=lane):
                self.assert_source_contains(
                    source,
                    f"a_lrq{lane}_wakeup_targets_live_entry:assertproperty",
                )
                self.assert_source_contains(
                    source,
                    f"(lsu{lane}_lrq_exx_tlb_wakeup[assert_entry]||"
                    f"lsu{lane}_lrq_frz_clr[assert_entry])"
                    f"|->lrq{lane}_entry_vld[assert_entry]",
                )

    def test_lrq_create_has_no_visible_old_owner_event(self) -> None:
        source = synthesis_excluded_source("srcs/xx_lsu_lrq.sv")
        for lane in (0, 2, 3):
            with self.subTest(lane=lane):
                self.assert_source_contains(
                    source,
                    f"a_lrq{lane}_create_has_no_visible_old_wakeup:assertproperty",
                )
                self.assert_source_contains(
                    source,
                    f"lrq{lane}_create_vld[assert_entry]|->!"
                    f"(lsu{lane}_lrq_exx_tlb_wakeup[assert_entry]||"
                    f"lsu{lane}_lrq_frz_clr[assert_entry])",
                )

    def test_dcache_hit_way_is_onehot0_for_live_cacheable_access(self) -> None:
        source = synthesis_excluded_source("srcs/xx_lsu_ld_dc.sv")
        self.assert_source_contains(source, "a_ldc_hit_way_onehot0:assertproperty")
        self.assert_source_contains(
            source,
            "(ldc_ex2_inst_vld&&ldc_lda_ex2_page_ca&&cp0_lsu_dcache_en)"
            "|->$onehot0(ldc_hit_way)",
        )


if __name__ == "__main__":
    unittest.main()
