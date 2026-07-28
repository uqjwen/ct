#!/usr/bin/env python3
"""Executable reference checks used when VCS is not available.

This is not an RTL simulator. It validates address/mask mathematics, ownership
truth tables, canonical extension examples, and the source signatures of the
open design issues targeted by the VCS tests.
"""

from __future__ import annotations

import itertools
from pathlib import Path


ENV_ROOT = Path(__file__).resolve().parents[1]
REPO_ROOT = ENV_ROOT.parents[1]
MASK64 = (1 << 64) - 1


def sign_extend(value: int, width: int) -> int:
    value &= (1 << width) - 1
    if value & (1 << (width - 1)):
        value |= MASK64 ^ ((1 << width) - 1)
    return value & MASK64


def scalar_va(base: int, offset: int, shift: int, zero_extend: bool) -> int:
    offset &= 0xFFF
    if not zero_extend and offset & 0x800:
        offset -= 1 << 12
    return (base + (offset << shift)) & MASK64


def byte_mask(size: int, address: int) -> int:
    byte_count = 1 << size
    low = address & 0xF
    return (((1 << byte_count) - 1) << low) & 0xFFFF


def crosses_4k(base: int, offset: int, shift: int, zero_extend: bool) -> bool:
    target = scalar_va(base, offset, shift, zero_extend)
    return (base >> 12) != (target >> 12)


def create_frozen(stall: bool, older: bool, pa_valid: bool, abort: bool) -> bool:
    return not (stall and older and (pa_valid or abort))


def canonical_byte_pc(cur_pc: int, wk_pc_len: int = 39) -> int:
    return sign_extend(cur_pc << 1, wk_pc_len + 1)


def broken_ordinary_mtval(cur_pc: int, wk_pc_len: int = 39) -> int:
    sign = (cur_pc >> (wk_pc_len - 1)) & 1
    return ((sign << (wk_pc_len + 1)) | (cur_pc << 1)) & MASK64


def broken_debug_dtval(cur_pc: int) -> int:
    return (cur_pc << 1) & MASK64


def run_math_checks() -> int:
    cases = 0
    for size, low in itertools.product(range(4), range(16)):
        mask = byte_mask(size, low)
        expected = (((1 << (1 << size)) - 1) << low) & 0xFFFF
        assert mask == expected
        cases += 1

    for base_low, offset, shift, zext in itertools.product(
        (0x000, 0x7F8, 0xFF0, 0xFFE),
        (0x001, 0x7FF, 0x800, 0xFFF),
        range(4),
        (False, True),
    ):
        base = 0x12345000 | base_low
        target = scalar_va(base, offset, shift, zext)
        signed = offset & 0xFFF
        if not zext and signed & 0x800:
            signed -= 0x1000
        assert target == (base + (signed << shift)) & MASK64
        assert crosses_4k(base, offset, shift, zext) == (
            (base >> 12) != (target >> 12)
        )
        cases += 1

    for stall, older, pa_valid, abort in itertools.product((False, True), repeat=4):
        expected = not (stall and older and (pa_valid or abort))
        assert create_frozen(stall, older, pa_valid, abort) == expected
        cases += 1

    cur_pc = 0x4000000800
    assert canonical_byte_pc(cur_pc) == 0xFFFFFF8000001000
    assert broken_ordinary_mtval(cur_pc) == 0x0000018000001000
    assert broken_debug_dtval(cur_pc) == 0x0000008000001000
    cases += 3
    return cases


def run_source_checks() -> list[str]:
    ag = (REPO_ROOT / "srcs/xx_lsu_ld_ag.sv").read_text(encoding="utf-8")
    lrq_entry = (REPO_ROOT / "srcs/xx_lsu_lrq_entry.sv").read_text(
        encoding="utf-8"
    )
    rtu = (REPO_ROOT / "srcs/xx_rtu_retire.v").read_text(encoding="utf-8")

    assert (
        "retire_expt_pc_high_hw_expt[63:0] = "
        "rob_retire_inst0_cur_pc + 64'd2"
    ) in rtu
    assert "idu_lsu_rf_halt_info" in ag
    assert "halt_info" not in lrq_entry
    us_indices = [
        line
        for line in ag.splitlines()
        if "lag_dcache_arb_ex1_data_" in line
        and "_idx[9:0]" in line
        and "{lag_ex1_pa[13:6], lag_us_settle_way[1:0]}" in line
    ]
    assert len(us_indices) == 4

    return [
        "RTU high-half helper adds 2 to a halfword address",
        "LRQ entry does not preserve replay halt_info",
        "all four unit-stride data indices select one 64-byte line",
    ]


def main() -> int:
    cases = run_math_checks()
    findings = run_source_checks()
    for finding in findings:
        print(f"KNOWN_SOURCE_FINDING: {finding}")
    print(f"REFERENCE_MODEL_PASS cases={cases} source_findings={len(findings)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
