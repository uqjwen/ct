#!/usr/bin/env python3
"""Build/check the interaction-2.1 source-grounded waiver manifest and XLSX."""

from __future__ import annotations

import argparse
import csv
import posixpath
import re
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import Iterable
from xml.etree import ElementTree as ET
from zipfile import ZipFile


ROOT = Path(__file__).resolve().parents[1]
DOCX = ROOT / "waive/07_xxx_代码与功能覆盖率排除说明文档.docx"
XLSX = ROOT / "waive/08-xxx_代码与功能覆盖率排除列表.xlsx"
MANIFEST = ROOT / "waive/interaction_2_1_code_waiver_manifest.csv"

MANIFEST_COLUMNS = (
    "coverage_type",
    "source_object",
    "repo_mapping",
    "module",
    "condition",
    "reason",
    "impact",
    "alternative",
    "property",
    "term",
    "source_section",
    "remarks",
)

WORKBOOK_HEADERS = (
    (
        "对象名称", "对象位置", "所属模块/子系统", "规范/需求编号", "排除条件描述",
        "排除原因", "影响评估", "替代验证手段", "属性", "计划期限", "提出人", "",
        "审核", "", "审批", "", "备注",
    ),
    (
        "", "", "", "", "", "", "", "", "", "", "角色", "姓名", "负责人",
        "日期", "负责人", "日期", "",
    ),
)

REQUIRED_MERGES = {
    "A1:A2", "B1:B2", "C1:C2", "D1:D2", "E1:E2", "F1:F2", "G1:G2",
    "H1:H2", "I1:I2", "J1:J2", "K1:L1", "M1:N1", "O1:P1", "Q1:Q2",
}

WORD_NS = "http://schemas.openxmlformats.org/wordprocessingml/2006/main"
SHEET_NS = "http://schemas.openxmlformats.org/spreadsheetml/2006/main"
REL_NS = "http://schemas.openxmlformats.org/officeDocument/2006/relationships"
PKG_REL_NS = "http://schemas.openxmlformats.org/package/2006/relationships"

MODULE_RE = re.compile(
    r"^(1\.(?:[1-9]|1\d|2[01]))\s+(wk_[A-Za-z0-9_]+)模块代码覆盖率排除说明"
)
SECTION_RE = re.compile(
    r"^(1\.\d+\.\d+)\s+(Line|Branch|Condition|condition|Toggle|toggle|FSM)覆盖率排除情况"
)
ITEM_RE = re.compile(r"^\d+）")


@dataclass
class SourceItem:
    coverage_type: str
    module: str
    source_section: str
    condition_parts: list[str]
    reason_parts: list[str]


def _paragraphs_from_docx(path: Path) -> list[str]:
    with ZipFile(path) as archive:
        root = ET.fromstring(archive.read("word/document.xml"))
    paragraphs: list[str] = []
    for paragraph in root.iter(f"{{{WORD_NS}}}p"):
        text = "".join(node.text or "" for node in paragraph.iter(f"{{{WORD_NS}}}t"))
        text = " ".join(text.split())
        paragraphs.append(text)
    return paragraphs


def _repo_mapping(module: str) -> str:
    candidates = []
    if module.startswith("wk_lsu_"):
        candidates.append("xx_lsu_" + module[len("wk_lsu_"):])
    elif module.startswith("wk_ls_"):
        candidates.append("xx_lsu_" + module[len("wk_ls_"):])
    for candidate in candidates:
        source = ROOT / "srcs" / f"{candidate}.sv"
        if source.is_file():
            return str(source.relative_to(ROOT))
    candidate_text = candidates[0] if candidates else module
    return f"未在本仓库srcs中定位到{candidate_text}生产源"


def _is_reason(text: str) -> bool:
    return text.startswith((
        "排除原因", "排除愿意", "第二个条件", "创建", "assign ", "同理，", "同理排除",
    )) or text == "排除"


def _coverage_type(label: str) -> str:
    return {
        "line": "line",
        "branch": "branch",
        "condition": "condition",
        "toggle": "toggle",
        "fsm": "fsm",
    }[label.lower()]


def _source_items() -> list[SourceItem]:
    paragraphs = _paragraphs_from_docx(DOCX)
    items: list[SourceItem] = []
    module = ""
    source_section = ""
    coverage_type = ""
    current: SourceItem | None = None
    active = False

    def flush() -> None:
        nonlocal current
        if current is not None and any(part.strip() for part in current.condition_parts):
            items.append(current)
        current = None

    for text in paragraphs:
        if not text:
            continue
        if not active:
            if text == "代码覆盖率排除说明":
                active = True
            continue
        if text.startswith("二、未覆盖功能点情况") or text.startswith("1.17 模板模块"):
            flush()
            break

        module_match = MODULE_RE.match(text)
        if module_match:
            flush()
            module = module_match.group(2)
            source_section = ""
            coverage_type = ""
            continue

        section_match = SECTION_RE.match(text)
        if section_match:
            flush()
            source_section = section_match.group(1)
            coverage_type = _coverage_type(section_match.group(2))
            continue

        if not module or not coverage_type or text == "无":
            continue

        numbered = ITEM_RE.match(text) is not None
        if coverage_type == "toggle":
            if numbered:
                flush()
                current = SourceItem(coverage_type, module, source_section, [text], [])
            elif current is None:
                current = SourceItem(coverage_type, module, source_section, [text], [])
            else:
                current.condition_parts.append(text)
            continue

        if numbered:
            flush()
            current = SourceItem(coverage_type, module, source_section, [text], [])
            continue

        if current is None:
            current = SourceItem(coverage_type, module, source_section, [text], [])
        elif _is_reason(text):
            current.reason_parts.append(text)
        else:
            current.reason_parts.append(text)

    flush()
    return items


def expected_manifest_rows() -> list[dict[str, str]]:
    rows: list[dict[str, str]] = []
    seen: set[tuple[str, str, str]] = set()
    for item in _source_items():
        condition = "；".join(item.condition_parts)
        reason = "；".join(item.reason_parts)
        if not reason:
            reason = condition if any(token in condition for token in ("tie", "未使用", "不支持", "排除原因")) else "DOCX仅列示该排除项，未另述原因"
        key = (item.coverage_type, item.module, condition)
        if key in seen:
            continue
        seen.add(key)
        mapping = _repo_mapping(item.module)
        rows.append(
            {
                "coverage_type": item.coverage_type,
                "source_object": f"{item.module} | {condition}",
                "repo_mapping": mapping,
                "module": item.module,
                "condition": condition,
                "reason": reason,
                "impact": "仅影响所列代码覆盖率统计；不替代功能正确性与全芯片动态签核",
                "alternative": "静态代码审查；在具备VCS/URG的全芯片环境复核适用边界",
                "property": "DOCX代码覆盖率排除项",
                "term": "待项目评审确认",
                "source_section": item.source_section,
                "remarks": "来源：07_xxx_代码与功能覆盖率排除说明文档.docx；分组及同理排除引用按原文保留",
            }
        )
    return rows


def write_manifest(rows: Iterable[dict[str, str]]) -> None:
    MANIFEST.parent.mkdir(parents=True, exist_ok=True)
    with MANIFEST.open("w", encoding="utf-8", newline="") as stream:
        writer = csv.DictWriter(stream, fieldnames=MANIFEST_COLUMNS, quoting=csv.QUOTE_ALL, lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)


def read_manifest() -> list[dict[str, str]]:
    with MANIFEST.open(encoding="utf-8", newline="") as stream:
        reader = csv.DictReader(stream)
        if tuple(reader.fieldnames or ()) != MANIFEST_COLUMNS:
            raise ValueError("manifest columns are not exact")
        return [dict(row) for row in reader]


def workbook_row(row: dict[str, str]) -> tuple[str, ...]:
    return (
        row["coverage_type"],
        row["source_object"] + "\n仓库映射：" + row["repo_mapping"],
        row["module"],
        row["source_section"],
        row["condition"],
        row["reason"],
        row["impact"],
        row["alternative"],
        row["property"],
        row["term"],
        "", "", "", "", "", "",
        row["remarks"],
    )


def _shared_strings(archive: ZipFile) -> list[str]:
    if "xl/sharedStrings.xml" not in archive.namelist():
        return []
    root = ET.fromstring(archive.read("xl/sharedStrings.xml"))
    return [
        "".join(node.text or "" for node in item.iter(f"{{{SHEET_NS}}}t"))
        for item in root.findall(f"{{{SHEET_NS}}}si")
    ]


def _column_index(reference: str) -> int:
    letters = re.match(r"[A-Z]+", reference).group(0)
    value = 0
    for character in letters:
        value = value * 26 + ord(character) - ord("A") + 1
    return value - 1


def _cell_value(cell: ET.Element, shared: list[str]) -> str:
    cell_type = cell.attrib.get("t")
    value = cell.find(f"{{{SHEET_NS}}}v")
    if cell_type == "s" and value is not None:
        return shared[int(value.text or "0")]
    if cell_type == "inlineStr":
        inline = cell.find(f"{{{SHEET_NS}}}is")
        return "" if inline is None else "".join(
            node.text or "" for node in inline.iter(f"{{{SHEET_NS}}}t")
        )
    return "" if value is None else (value.text or "")


def _sheet_paths(archive: ZipFile) -> dict[str, str]:
    workbook = ET.fromstring(archive.read("xl/workbook.xml"))
    relations = ET.fromstring(archive.read("xl/_rels/workbook.xml.rels"))
    targets = {
        relation.attrib["Id"]: relation.attrib["Target"]
        for relation in relations.findall(f"{{{PKG_REL_NS}}}Relationship")
    }
    result = {}
    for sheet in workbook.find(f"{{{SHEET_NS}}}sheets"):
        target = targets[sheet.attrib[f"{{{REL_NS}}}id"]]
        if target.startswith("/"):
            resolved = target.lstrip("/")
        else:
            resolved = posixpath.normpath(posixpath.join("xl", target))
        result[sheet.attrib["name"]] = resolved
    return result


def _read_sheet(archive: ZipFile, path: str, shared: list[str]) -> tuple[list[tuple[str, ...]], set[str]]:
    root = ET.fromstring(archive.read(path))
    rows: list[tuple[str, ...]] = []
    for row in root.findall(f".//{{{SHEET_NS}}}row"):
        values = [""] * 17
        for cell in row.findall(f"{{{SHEET_NS}}}c"):
            index = _column_index(cell.attrib["r"])
            if index < len(values):
                values[index] = _cell_value(cell, shared)
        rows.append(tuple(values))
    merge_container = root.find(f"{{{SHEET_NS}}}mergeCells")
    merges = set() if merge_container is None else {
        merge.attrib["ref"] for merge in merge_container
    }
    return rows, merges


def _validate_manifest(actual: list[dict[str, str]], expected: list[dict[str, str]]) -> None:
    if len(actual) <= 50:
        raise ValueError(f"manifest has only {len(actual)} rows")
    if actual != expected:
        for index, (actual_row, expected_row) in enumerate(zip(actual, expected), 1):
            if actual_row != expected_row:
                raise ValueError(f"manifest differs from DOCX extraction at row {index}")
        raise ValueError(f"manifest row count differs: {len(actual)} != {len(expected)}")
    allowed = {"line", "branch", "condition", "toggle", "fsm"}
    if {row["coverage_type"] for row in actual} != allowed:
        raise ValueError("manifest coverage types are incomplete")
    for index, row in enumerate(actual, 1):
        blank = [column for column in MANIFEST_COLUMNS if not row[column].strip()]
        if blank:
            raise ValueError(f"manifest row {index} has blank fields: {', '.join(blank)}")
        if not row["source_section"].startswith("1."):
            raise ValueError(f"invalid source section at manifest row {index}")


def validate_workbook(rows: list[dict[str, str]]) -> None:
    with ZipFile(XLSX) as archive:
        shared = _shared_strings(archive)
        paths = _sheet_paths(archive)
        if set(paths) != {"代码waiver", "功能waiver"}:
            raise ValueError(f"unexpected worksheets: {sorted(paths)}")
        code_rows, code_merges = _read_sheet(archive, paths["代码waiver"], shared)
        function_rows, function_merges = _read_sheet(archive, paths["功能waiver"], shared)

    if not REQUIRED_MERGES.issubset(code_merges) or not REQUIRED_MERGES.issubset(function_merges):
        raise ValueError("required two-row header merges were not preserved")
    if tuple(code_rows[:2]) != WORKBOOK_HEADERS or tuple(function_rows[:2]) != WORKBOOK_HEADERS:
        raise ValueError("17-column two-row headers were not preserved")

    populated_code = [row for row in code_rows[2:] if any(value.strip() for value in row)]
    populated_function = [row for row in function_rows[2:] if any(value.strip() for value in row)]
    expected_code = [workbook_row(row) for row in rows]
    if populated_code != expected_code:
        raise ValueError(f"code waiver worksheet differs from manifest: {len(populated_code)} rows")
    if populated_function:
        raise ValueError("function waiver worksheet contains unsupported data rows")

    all_text = "\n".join(value for row in (*code_rows, *function_rows) for value in row)
    for forbidden in ("CP0", "张三", "default分支_未使用调试模式"):
        if forbidden in all_text:
            raise ValueError(f"example content remains in workbook: {forbidden}")


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--write-manifest", action="store_true")
    args = parser.parse_args()
    try:
        expected = expected_manifest_rows()
        if args.write_manifest:
            write_manifest(expected)
            print(f"WAIVER_MANIFEST_WRITTEN rows={len(expected)}")
            return 0
        actual = read_manifest()
        _validate_manifest(actual, expected)
        validate_workbook(actual)
        counts = {kind: sum(row["coverage_type"] == kind for row in actual) for kind in ("line", "branch", "condition", "toggle", "fsm")}
        print(
            "WAIVER_WORKBOOK_PASS "
            f"code_rows={len(actual)} function_rows=0 "
            + " ".join(f"{key}={value}" for key, value in counts.items())
        )
        return 0
    except (OSError, ValueError, KeyError, ET.ParseError) as error:
        print(f"WAIVER_WORKBOOK_FAIL: {error}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
