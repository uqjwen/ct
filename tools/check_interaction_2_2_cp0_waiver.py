#!/usr/bin/env python3
"""Independently validate the interaction-2.2 CP0 waiver workbook OOXML."""

from __future__ import annotations

import csv
import posixpath
import re
import sys
from collections import Counter
from pathlib import Path
from xml.etree import ElementTree as ET
from zipfile import ZipFile


ROOT = Path(__file__).resolve().parents[1]
WORKBOOK = ROOT / "waive/08-cp0_代码与功能覆盖率排除列表.xlsx"
MANIFEST = ROOT / "waive/interaction_2_2_cp0_code_waiver_manifest.csv"
EXPECTED_HEADERS = (
    "对象名称", "对象位置", "所属模块/子系统", "规范/需求编号",
    "排除条件描述", "排除原因", "影响评估", "替代验证手段",
    "属性", "计划期限", "提出人", "", "审核", "", "审批", "", "备注",
)
EXPECTED_SUBHEADERS = (
    "", "", "", "", "", "", "", "", "", "",
    "角色", "姓名", "负责人", "日期", "负责人", "日期", "",
)
EXPECTED_MERGES = {"A1:A2", "B1:B2", "C1:C2", "D1:D2", "E1:E2",
                   "F1:F2", "G1:G2", "H1:H2", "I1:I2", "J1:J2",
                   "K1:L1", "M1:N1", "O1:P1", "Q1:Q2"}

SHEET_NS = "http://schemas.openxmlformats.org/spreadsheetml/2006/main"
REL_NS = "http://schemas.openxmlformats.org/officeDocument/2006/relationships"
PKG_REL_NS = "http://schemas.openxmlformats.org/package/2006/relationships"
FORBIDDEN_EXAMPLES = (
    "default分支_未使用调试模式",
    "rtl/core/ctrl_fsm.sv:module ctrl_fsm:line 210",
    "CPU核控制模块",
    "RV-CORE-SPEC-DBG-OPT",
    "wk-core/periph/wk_cp0_iui.v",
    "张三",
    "李四",
    "王五",
    "xxx",
)


def manifest_row(row: dict[str, str]) -> list[str]:
    return [
        row["coverage_type"], row["source_object"], row["module"],
        row["source_section"], row["condition"], row["reason"],
        row["impact"], row["alternative"], row["property"], row["term"],
        "", "", "", "", "", "", row["remarks"],
    ]


def _shared_strings(archive: ZipFile) -> list[str]:
    if "xl/sharedStrings.xml" not in archive.namelist():
        return []
    root = ET.fromstring(archive.read("xl/sharedStrings.xml"))
    return [
        "".join(node.text or "" for node in item.iter(f"{{{SHEET_NS}}}t"))
        for item in root.findall(f"{{{SHEET_NS}}}si")
    ]


def _column_index(reference: str) -> int:
    match = re.match(r"[A-Z]+", reference)
    if match is None:
        raise ValueError(f"invalid cell reference: {reference}")
    value = 0
    for character in match.group(0):
        value = value * 26 + ord(character) - ord("A") + 1
    return value - 1


def _cell_value(cell: ET.Element, shared: list[str]) -> str:
    value = cell.find(f"{{{SHEET_NS}}}v")
    cell_type = cell.attrib.get("t")
    if cell_type == "s" and value is not None:
        index = int(value.text or "0")
        if not 0 <= index < len(shared):
            raise ValueError(f"shared-string index out of range: {index}")
        return shared[index]
    if cell_type == "inlineStr":
        inline = cell.find(f"{{{SHEET_NS}}}is")
        if inline is None:
            return ""
        return "".join(node.text or "" for node in inline.iter(f"{{{SHEET_NS}}}t"))
    return "" if value is None else (value.text or "")


def _sheet_paths(archive: ZipFile) -> dict[str, str]:
    workbook = ET.fromstring(archive.read("xl/workbook.xml"))
    relations = ET.fromstring(archive.read("xl/_rels/workbook.xml.rels"))
    targets = {
        relation.attrib["Id"]: relation.attrib["Target"]
        for relation in relations.findall(f"{{{PKG_REL_NS}}}Relationship")
    }
    sheets = workbook.find(f"{{{SHEET_NS}}}sheets")
    if sheets is None:
        raise ValueError("workbook has no sheets container")
    result: dict[str, str] = {}
    for sheet in sheets:
        relationship_id = sheet.attrib[f"{{{REL_NS}}}id"]
        target = targets.get(relationship_id)
        if target is None:
            raise ValueError(f"unresolved worksheet relationship: {relationship_id}")
        if target.startswith("/"):
            resolved = target.lstrip("/")
        else:
            resolved = posixpath.normpath(posixpath.join("xl", target))
        result[sheet.attrib["name"]] = resolved
    return result


def _read_sheet(
    archive: ZipFile, path: str, shared: list[str]
) -> tuple[dict[int, list[str]], set[str]]:
    root = ET.fromstring(archive.read(path))
    rows: dict[int, list[str]] = {}
    for row in root.findall(f".//{{{SHEET_NS}}}sheetData/{{{SHEET_NS}}}row"):
        row_number = int(row.attrib["r"])
        values = [""] * 17
        for cell in row.findall(f"{{{SHEET_NS}}}c"):
            reference = cell.attrib.get("r", "")
            index = _column_index(reference)
            cell_value = _cell_value(cell, shared)
            if index >= len(values):
                if cell_value.strip():
                    raise ValueError(f"data outside A:Q at {reference}")
                continue
            values[index] = cell_value
        rows[row_number] = values
    merge_container = root.find(f"{{{SHEET_NS}}}mergeCells")
    merges = set() if merge_container is None else {
        merge.attrib["ref"] for merge in merge_container
    }
    return rows, merges


def check_workbook() -> tuple[int, int, Counter[str]]:
    """Return code rows, function rows, and coverage counts; raise ValueError on drift."""
    with MANIFEST.open(encoding="utf-8", newline="") as stream:
        manifest = list(csv.DictReader(stream))
    expected_rows = [manifest_row(row) for row in manifest]
    if len(expected_rows) != 45:
        raise ValueError(f"manifest row count differs: {len(expected_rows)} != 45")

    with ZipFile(WORKBOOK) as archive:
        shared = _shared_strings(archive)
        paths = _sheet_paths(archive)
        if set(paths) != {"代码waiver", "功能waiver"}:
            raise ValueError(f"unexpected worksheets: {sorted(paths)}")
        code_rows, code_merges = _read_sheet(
            archive, paths["代码waiver"], shared
        )
        function_rows, function_merges = _read_sheet(
            archive, paths["功能waiver"], shared
        )

    for sheet_name, rows, merges in (
        ("代码waiver", code_rows, code_merges),
        ("功能waiver", function_rows, function_merges),
    ):
        if merges != EXPECTED_MERGES:
            raise ValueError(f"{sheet_name} merge ranges differ: {sorted(merges)}")
        if tuple(rows.get(1, [])) != EXPECTED_HEADERS:
            raise ValueError(f"{sheet_name} first header row differs")
        if tuple(rows.get(2, [])) != EXPECTED_SUBHEADERS:
            raise ValueError(f"{sheet_name} second header row differs")

    actual_code = [code_rows.get(row_number, [""] * 17) for row_number in range(3, 48)]
    if actual_code != expected_rows:
        for row_number, (actual, expected) in enumerate(
            zip(actual_code, expected_rows), start=3
        ):
            if actual != expected:
                raise ValueError(f"代码waiver row {row_number} differs from manifest")
        raise ValueError("代码waiver rows 3-47 differ from manifest")

    for row_number, row in code_rows.items():
        if row_number >= 48 and any(value.strip() for value in row):
            raise ValueError(f"unexpected code-waiver data at row {row_number}")
    if any(any(row[index].strip() for index in range(10, 16)) for row in actual_code):
        raise ValueError("management fields K-P must be blank")

    populated_function = [
        (row_number, row)
        for row_number, row in function_rows.items()
        if row_number >= 3 and any(value.strip() for value in row)
    ]
    if populated_function:
        raise ValueError(
            f"功能waiver contains data at row {populated_function[0][0]}"
        )

    all_text = "\n".join(
        value
        for rows in (code_rows, function_rows)
        for row in rows.values()
        for value in row
    )
    for forbidden in FORBIDDEN_EXAMPLES:
        if forbidden in all_text:
            raise ValueError(f"template example remains in workbook: {forbidden}")

    counts = Counter(row["coverage_type"] for row in manifest)
    expected_counts = {
        "line": 4, "branch": 5, "condition": 11, "toggle": 25, "fsm": 0
    }
    if (
        any(counts[kind] != expected for kind, expected in expected_counts.items())
        or set(counts) - set(expected_counts)
    ):
        raise ValueError(f"coverage counts differ: {counts}")
    return len(actual_code), len(populated_function), counts


def main() -> int:
    try:
        code_count, function_count, counts = check_workbook()
        print(
            "CP0_WAIVER_WORKBOOK_PASS "
            f"code_rows={code_count} function_rows={function_count} "
            f"line={counts['line']} branch={counts['branch']} "
            f"condition={counts['condition']} toggle={counts['toggle']} "
            f"fsm={counts['fsm']}"
        )
        return 0
    except (OSError, ValueError, KeyError, ET.ParseError) as error:
        print(f"CP0_WAIVER_WORKBOOK_FAIL: {error}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
