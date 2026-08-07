#!/usr/bin/env python3
"""Check the executable CP0 interrupt, exception, return, and WFI RTL contract."""

from __future__ import annotations

import argparse
import json
import re
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
MODULE_FILES = {
    "wk_cp0_top": "wk_cp0_top.v",
    "wk_cp0_iui": "wk_cp0_iui.v",
    "wk_cp0_regs": "wk_cp0_regs.v",
    "wk_cp0_lpmd": "wk_cp0_lpmd.v",
}
EXPECTED_CHILDREN = {
    "wk_cp0_iui": "x_wk_cp0_iui",
    "wk_cp0_regs": "x_wk_cp0_regs",
    "wk_cp0_lpmd": "x_wk_cp0_lpmd",
}
EXPECTED_SOURCES = {
    "meip": "biu_cp0_me_int",
    "mtip": "biu_cp0_mt_int",
    "msip": "biu_cp0_ms_int",
    "seip": "seip_s | biu_cp0_se_int",
    "stip": "stip_s | biu_cp0_st_int",
    "ssip": "mvssip",
    "mcip": "ecc_int_vld",
    "moip": "hpcp_cp0_int_vld",
}
EXPECTED_SLOTS = [
    "mcip_nodeleg_vld", "1'b0", "meip_vld", "msip_vld", "mtip_vld",
    "seip_nodeleg_vld", "ssip_nodeleg_vld", "stip_nodeleg_vld",
    "moip_nodeleg_vld", "mcip_deleg_vld", "1'b0", "seip_deleg_vld",
    "ssip_deleg_vld", "stip_deleg_vld", "moip_deleg_vld",
]
EXPECTED_CAUSES = [23, 18, 11, 3, 7, 9, 1, 5, 13, 23, 18, 9, 1, 5, 13]
EXPECTED_SELECTORS = [
    "1??????????????", "01?????????????", "001????????????",
    "0001???????????", "00001??????????", "000001?????????",
    "0000001????????", "00000001???????", "000000001??????",
    "0000000001?????", "00000000001????", "000000000001???",
    "0000000000001??", "00000000000001?", "000000000000001",
]
CHECKED_ASSIGNMENTS = frozenset({*EXPECTED_SOURCES, "int_sel", "edeleg_upd_val"})


class ContractError(ValueError):
    """An RTL contract value could not be parsed or differs from the contract."""


def _strip_comments(source: str) -> str:
    return re.sub(r"//[^\n]*|/\*.*?\*/", "", source, flags=re.DOTALL)


def _normalize(value: str) -> str:
    return " ".join(value.strip().split())


def _read_modules(root: Path) -> dict[str, str]:
    sources: dict[str, str] = {}
    for module, filename in MODULE_FILES.items():
        path = root / "cp0" / filename
        if not path.is_file():
            raise ContractError(f"missing authoritative RTL: cp0/{filename}")
        source = _strip_comments(path.read_text(encoding="utf-8"))
        declarations = re.findall(r"\bmodule\s+([A-Za-z_]\w*)\b", source)
        if declarations != [module]:
            raise ContractError(
                f"module declaration differs in cp0/{filename}: {declarations}"
            )
        sources[module] = source
    return sources


def _assignments(source: str) -> dict[str, str]:
    assignments: dict[str, str] = {}
    for match in re.finditer(
        r"\bassign\s+([A-Za-z_]\w*)(?:\s*\[[^\]]+\])?\s*=\s*(.*?);",
        source,
        flags=re.DOTALL,
    ):
        name = match.group(1)
        if name in assignments and name in CHECKED_ASSIGNMENTS:
            raise ContractError(f"duplicate assignment for checked signal: {name}")
        assignments.setdefault(name, _normalize(match.group(2)))
    return assignments


def _split_concatenation(expression: str) -> list[str]:
    expression = expression.strip()
    if not expression.startswith("{") or not expression.endswith("}"):
        raise ContractError("int_sel is not a concatenation")
    items: list[str] = []
    depth = 0
    start = 1
    for index, character in enumerate(expression[1:-1], start=1):
        if character in "{(":
            depth += 1
        elif character in "})":
            depth -= 1
        elif character == "," and depth == 0:
            items.append(_normalize(expression[start:index]))
            start = index + 1
    items.append(_normalize(expression[start:-1]))
    if depth != 0 or any(not item for item in items):
        raise ContractError("int_sel concatenation is malformed")
    return items


def _topology(top: str) -> list[str]:
    instances = re.findall(
        r"\b(wk_cp0_[A-Za-z_]\w*)\s*(?:#\s*\(.*?\)\s*)?"
        r"([A-Za-z_]\w*)\s*\(",
        _module_body(top, "wk_cp0_top"),
        flags=re.DOTALL,
    )
    actual = dict(instances)
    if len(instances) != 3 or actual != EXPECTED_CHILDREN:
        raise ContractError(f"topology differs: {instances}")
    return list(actual)


def _interrupt_priority(iui: str) -> tuple[list[str], list[int], list[bool]]:
    match = re.search(
        r"\bcasez\s*\(\s*regs_iui_int_sel\s*\[\s*14\s*:\s*0\s*\]\s*\)"
        r"(?P<body>.*?)\bendcase\b",
        iui,
        flags=re.DOTALL,
    )
    if match is None:
        raise ContractError("interrupt priority casez is missing")
    rows = re.findall(
        r"15\s*'\s*b\s*([01?]{15})\s*:\s*valid_int_vec\s*\[\s*4\s*:\s*0\s*\]"
        r"\s*=\s*5\s*'\s*d\s*(\d+)\s*;",
        match.group("body"),
        flags=re.IGNORECASE,
    )
    selectors = [selector for selector, _ in rows]
    causes = [int(cause) for _, cause in rows]
    if selectors != EXPECTED_SELECTORS or causes != EXPECTED_CAUSES:
        raise ContractError(
            f"interrupt priority differs: selectors={selectors} causes={causes}"
        )
    return selectors, causes, [slot != "1'b0" for slot in EXPECTED_SLOTS]


def _term_width(term: str) -> tuple[set[int], int]:
    zero = re.fullmatch(r"(\d+)\s*'\s*b\s*0+", term, flags=re.IGNORECASE)
    if zero is not None:
        return set(), int(zero.group(1))
    selected = re.fullmatch(
        r"iui_regs_src0\s*\[\s*(\d+)\s*(?::\s*(\d+)\s*)?\]", term
    )
    if selected is None:
        raise ContractError(f"unsupported edeleg update term: {term}")
    high = int(selected.group(1))
    low = int(selected.group(2) or selected.group(1))
    if high < low:
        raise ContractError(f"ascending edeleg source range: {term}")
    return set(range(low, high + 1)), high - low + 1


def _delegable_exceptions(regs: str, assignments: dict[str, str]) -> list[int]:
    update = assignments.get("edeleg_upd_val")
    if update is None:
        raise ContractError("edeleg update assignment is missing")
    position = 15
    writable_bits: set[int] = set()
    for term in _split_concatenation(update):
        source_bits, width = _term_width(term)
        destination = set(range(position - width + 1, position + 1))
        if position - width + 1 < 0:
            raise ContractError("edeleg update width exceeds 16 bits")
        if source_bits:
            if source_bits != destination:
                raise ContractError("edeleg update is not bit-preserving")
            writable_bits.update(destination)
        position -= width
    if position != -1:
        raise ContractError("edeleg update width is not 16 bits")

    case = re.search(
        r"\bcase\s*\(\s*rtu_yy_xx_expt_vec\s*\[\s*4\s*:\s*0\s*\]\s*\)"
        r"(?P<body>.*?)\bendcase\b",
        regs,
        flags=re.DOTALL,
    )
    if case is None:
        raise ContractError("vec_num exception case is missing")
    mappings = re.findall(
        r"5\s*'\s*d\s*(\d+)\s*:\s*vec_num\s*\[\s*18\s*:\s*0\s*\]"
        r"\s*=\s*19\s*'\s*h\s*([0-9a-f]+)\s*;",
        case.group("body"),
        flags=re.IGNORECASE,
    )
    result: list[int] = []
    for exception, encoded in mappings:
        one_hot = int(encoded, 16)
        if one_hot == 0 or one_hot & (one_hot - 1):
            raise ContractError(f"vec_num mapping is not one-hot for exception {exception}")
        bit = one_hot.bit_length() - 1
        if bit in writable_bits:
            result.append(int(exception))
    expected = [1, 2, 3, 4, 5, 6, 7, 8, 9, 12, 13, 15]
    if result != expected:
        raise ContractError(f"delegable exceptions differ: {result}")
    return result


def _module_body(source: str, module: str) -> str:
    declaration = re.search(rf"\bmodule\s+{module}\b", source)
    if declaration is None:
        raise ContractError(f"{module} declaration is missing")
    port_end = source.find(";", declaration.end())
    module_end = source.find("endmodule", declaration.end())
    if port_end < 0 or module_end < 0 or port_end >= module_end:
        raise ContractError(f"{module} body cannot be located")
    return source[port_end + 1:module_end]


def _ack_consumers(regs: str) -> int:
    body = _module_body(regs, "wk_cp0_regs")
    body_without_declarations = re.sub(
        r"\b(?:input|output|wire|reg)\b[^;]*;", "", body, flags=re.DOTALL
    )
    consumers = len(re.findall(r"\brtu_cp0_int_ack\b", body_without_declarations))
    if consumers:
        raise ContractError(f"ack-consumer count differs: {consumers}")
    return consumers


def _require(source: str, label: str, *patterns: str) -> bool:
    for pattern in patterns:
        if re.search(pattern, source, flags=re.DOTALL) is None:
            raise ContractError(f"key path missing: {label}")
    return True


def _key_paths(iui: str, regs: str, lpmd: str) -> dict[str, bool]:
    return {
        "iui_illegal_cause_mtval": _require(
            iui,
            "iui illegal cause/mtval",
            r"assign\s+cp0_ex2_expt_vld\s*=\s*!iui_privilege\s*&&\s*cp0_ex2_select\s*;",
            r"assign\s+cp0_iu_ex3_mtval\s*\[\s*31\s*:\s*0\s*\]\s*=\s*iui_opcode\s*\[\s*31\s*:\s*0\s*\]\s*;",
            r"assign\s+cp0_iu_ex3_expt_vec\s*\[\s*4\s*:\s*0\s*\]\s*=\s*5\s*'\s*h\s*2\s*;",
        ),
        "machine_trap_csr_update": _require(
            regs,
            "machine trap CSR update",
            r"rtu_cp0_expt_vld\s*&&\s*!mdeleg_vld\s*\)\s*mepc_reg\s*\[\s*62\s*:\s*0\s*\]\s*<=\s*rtu_cp0_epc\s*\[\s*63\s*:\s*1\s*\]",
            r"rtu_cp0_expt_vld\s*&&\s*!mdeleg_vld\s*\)\s*m_vector\s*\[\s*4\s*:\s*0\s*\]\s*<=\s*rtu_yy_xx_expt_vec\s*\[\s*4\s*:\s*0\s*\]",
            r"rtu_cp0_expt_vld\s*&&\s*!mdeleg_vld\s*\)\s*mtval_data\s*\[\s*63\s*:\s*0\s*\]\s*<=\s*mtval_upd_data\s*\[\s*63\s*:\s*0\s*\]",
        ),
        "supervisor_trap_csr_update": _require(
            regs,
            "supervisor trap CSR update",
            r"rtu_cp0_expt_vld\s*&&\s*mdeleg_vld\s*\)\s*sepc_reg\s*\[\s*62\s*:\s*0\s*\]\s*<=\s*rtu_cp0_epc\s*\[\s*63\s*:\s*1\s*\]",
            r"rtu_cp0_expt_vld\s*&&\s*mdeleg_vld\s*\)\s*s_vector\s*\[\s*4\s*:\s*0\s*\]\s*<=\s*rtu_yy_xx_expt_vec\s*\[\s*4\s*:\s*0\s*\]",
            r"rtu_cp0_expt_vld\s*&&\s*mdeleg_vld\s*\)\s*stval_data\s*\[\s*63\s*:\s*0\s*\]\s*<=\s*stval_upd_data\s*\[\s*63\s*:\s*0\s*\]",
        ),
        "mret_sret_return_pc": _require(
            regs,
            "MRET/SRET return PC",
            r"assign\s+cp0_iu_ex3_efpc\s*\[.*?\]\s*=\s*cp0_mret\s*\?\s*mepc_value\s*\[.*?\]\s*:\s*sepc_value\s*\[.*?\]\s*;",
            r"assign\s+cp0_iu_ex3_efpc_vld\s*=\s*cp0_mret\s*\|\|\s*cp0_sret\s*;",
        ),
        "wfi_noop_wakeup_fsm": _require(
            lpmd,
            "WFI no-op/wakeup FSM",
            r"parameter\s+IDLE\s*=\s*2\s*'\s*b\s*00\s*;",
            r"parameter\s+SWAIT\s*=\s*2\s*'\s*b\s*01\s*;",
            r"parameter\s+LPMD\s*=\s*2\s*'\s*b\s*10\s*;",
            r"assign\s+cp0_ifu_no_op_req\s*=\s*lpmd_in_wait_state\s*;",
            r"assign\s+cp0_lsu_no_op_req\s*=\s*lpmd_in_wait_state\s*;",
            r"assign\s+cp0_mmu_no_op_req\s*=\s*lpmd_in_wait_state\s*;",
            r"biu_cp0_int_wakeup\s*\|\|.*?biu_cp0_event_wakeup\s*\|\|\s*dtu_cp0_wake_up\s*\)\s*lpmd_b",
        ),
    }


def check_contract(root: Path = ROOT) -> dict[str, object]:
    """Return hand-checkable CP0 facts or raise ContractError if RTL drifts."""
    sources = _read_modules(root.resolve())
    top_submodules = _topology(sources["wk_cp0_top"])
    assignments = _assignments(sources["wk_cp0_regs"])
    interrupt_sources = {name: assignments.get(name) for name in EXPECTED_SOURCES}
    if interrupt_sources != EXPECTED_SOURCES:
        raise ContractError(f"interrupt sources differ: {interrupt_sources}")
    slots = _split_concatenation(assignments.get("int_sel", ""))
    if slots != EXPECTED_SLOTS:
        raise ContractError(f"interrupt select slots differ: {slots}")
    selectors, causes, live = _interrupt_priority(sources["wk_cp0_iui"])
    return {
        "modules": list(MODULE_FILES),
        "top_submodules": top_submodules,
        "interrupt_sources": interrupt_sources,
        "interrupt_priority": {"selectors": selectors, "causes": causes, "live": live},
        "delegable_exceptions": _delegable_exceptions(sources["wk_cp0_regs"], assignments),
        "ack_consumers": _ack_consumers(sources["wk_cp0_regs"]),
        "key_paths": _key_paths(
            sources["wk_cp0_iui"], sources["wk_cp0_regs"], sources["wk_cp0_lpmd"]
        ),
    }


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--root", type=Path, default=ROOT)
    parser.add_argument("--json", action="store_true")
    arguments = parser.parse_args(argv)
    try:
        result = check_contract(arguments.root)
    except (ContractError, OSError, UnicodeError) as error:
        print(f"CP0_CONTRACT_FAIL: {error}", file=sys.stderr)
        return 1
    if arguments.json:
        print(json.dumps(result, sort_keys=True))
    else:
        print(
            "CP0_CONTRACT_PASS modules=4 submodules=3 interrupt_sources=8 "
            "priority_slots=15 live_slots=13 delegable_exceptions=12 ack_consumers=0"
        )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
