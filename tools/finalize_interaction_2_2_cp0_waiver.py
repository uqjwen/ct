#!/usr/bin/env python3
"""Insert the two authorized CP0 workbook pane views without other authoring."""

from __future__ import annotations

import copy
import os
import posixpath
import re
import stat
import sys
import tempfile
from pathlib import Path
from xml.etree import ElementTree as ET
from zipfile import BadZipFile, ZipFile, ZipInfo


ROOT = Path(__file__).resolve().parents[1]
WORKBOOK = ROOT / "waive/08-cp0_代码与功能覆盖率排除列表.xlsx"
EXPECTED_SHEETS = ("代码waiver", "功能waiver")
SHEET_NS = "http://schemas.openxmlformats.org/spreadsheetml/2006/main"
REL_NS = "http://schemas.openxmlformats.org/officeDocument/2006/relationships"
PKG_REL_NS = "http://schemas.openxmlformats.org/package/2006/relationships"
PANE_ATTRIBUTES = {
    "ySplit": "2",
    "topLeftCell": "A3",
    "activePane": "bottomLeft",
    "state": "frozen",
}
ZIP_METADATA_FIELDS = (
    "filename", "orig_filename", "date_time", "compress_type", "comment",
    "extra",
    "create_system", "create_version", "extract_version", "reserved",
    "flag_bits", "volume", "internal_attr", "external_attr",
)


def _zip_metadata(info: ZipInfo) -> tuple[object, ...]:
    return tuple(getattr(info, field) for field in ZIP_METADATA_FIELDS)


def _local_name(tag: str) -> str:
    return tag.rsplit("}", 1)[-1]


def _resolve_worksheet_paths(payloads: dict[str, bytes]) -> dict[str, str]:
    try:
        workbook = ET.fromstring(payloads["xl/workbook.xml"])
        relationships = ET.fromstring(payloads["xl/_rels/workbook.xml.rels"])
    except KeyError as error:
        raise ValueError(f"missing required workbook payload: {error.args[0]}") from error

    targets: dict[str, str] = {}
    for relationship in relationships.findall(f"{{{PKG_REL_NS}}}Relationship"):
        relationship_id = relationship.attrib.get("Id")
        target = relationship.attrib.get("Target")
        if not relationship_id or not target or relationship_id in targets:
            raise ValueError("invalid or duplicate workbook relationship")
        targets[relationship_id] = target

    sheets = workbook.find(f"{{{SHEET_NS}}}sheets")
    if sheets is None:
        raise ValueError("workbook has no sheets container")
    result: dict[str, str] = {}
    for sheet in sheets:
        name = sheet.attrib.get("name")
        relationship_id = sheet.attrib.get(f"{{{REL_NS}}}id")
        if not name or not relationship_id or name in result:
            raise ValueError("invalid or duplicate worksheet declaration")
        target = targets.get(relationship_id)
        if target is None:
            raise ValueError(f"unresolved worksheet relationship: {relationship_id}")
        if target.startswith("/"):
            resolved = target.lstrip("/")
        else:
            resolved = posixpath.normpath(posixpath.join("xl", target))
        if resolved.startswith("../") or resolved not in payloads:
            raise ValueError(f"invalid worksheet target for {name}: {target}")
        result[name] = resolved

    if set(result) != set(EXPECTED_SHEETS):
        raise ValueError(f"unexpected worksheets: {sorted(result)}")
    if len(set(result.values())) != len(EXPECTED_SHEETS):
        raise ValueError("expected worksheets resolve to the same payload")
    return result


def _insert_pane_view(payload: bytes, sheet_name: str) -> bytes:
    root = ET.fromstring(payload)
    if root.tag != f"{{{SHEET_NS}}}worksheet":
        raise ValueError(f"{sheet_name} is not a SpreadsheetML worksheet")
    unexpected = [
        _local_name(element.tag)
        for element in root.iter()
        if _local_name(element.tag) in {"sheetViews", "sheetView", "pane"}
    ]
    if unexpected:
        raise ValueError(
            f"{sheet_name} has unexpected existing worksheet view: {unexpected[0]}"
        )

    root_match = re.search(
        rb"<(?:(?P<prefix>[A-Za-z_][\w.-]*):)?worksheet(?=[\s>/])",
        payload,
    )
    if root_match is None:
        raise ValueError(f"{sheet_name} worksheet root prefix cannot be resolved")
    prefix = root_match.group("prefix")
    qualified = (prefix + b":") if prefix else b""

    anchors = []
    for local_name in (b"sheetFormatPr", b"cols", b"sheetData"):
        match = re.search(
            rb"<" + re.escape(qualified + local_name) + rb"(?=[\s>/])",
            payload,
        )
        if match is not None:
            anchors.append(match.start())
    if not anchors:
        raise ValueError(f"{sheet_name} has no safe worksheet-view insertion point")

    fragment = (
        b"<" + qualified + b"sheetViews>"
        b"<" + qualified + b'sheetView workbookViewId="0">'
        b"<" + qualified
        + b'pane ySplit="2" topLeftCell="A3" activePane="bottomLeft" state="frozen"/>'
        b"</" + qualified + b"sheetView>"
        b"</" + qualified + b"sheetViews>"
    )
    insert_at = min(anchors)
    return payload[:insert_at] + fragment + payload[insert_at:]


def _verify_pane(payload: bytes, sheet_name: str) -> None:
    root = ET.fromstring(payload)
    views = root.findall(f"{{{SHEET_NS}}}sheetViews")
    if len(views) != 1 or views[0].attrib:
        raise ValueError(f"{sheet_name} pane finalization produced invalid sheetViews")
    sheet_views = views[0].findall(f"{{{SHEET_NS}}}sheetView")
    if len(sheet_views) != 1 or sheet_views[0].attrib != {"workbookViewId": "0"}:
        raise ValueError(f"{sheet_name} pane finalization produced invalid sheetView")
    panes = sheet_views[0].findall(f"{{{SHEET_NS}}}pane")
    if len(panes) != 1 or panes[0].attrib != PANE_ATTRIBUTES:
        raise ValueError(f"{sheet_name} pane finalization produced invalid pane")
    if list(panes[0]) or list(sheet_views[0]) != panes or list(views[0]) != sheet_views:
        raise ValueError(f"{sheet_name} pane finalization produced extra view nodes")


def _snapshot(
    workbook_path: Path,
) -> tuple[list[ZipInfo], dict[str, bytes], dict[str, tuple[object, ...]], bytes]:
    with ZipFile(workbook_path) as archive:
        infos = archive.infolist()
        names = [info.filename for info in infos]
        if len(names) != len(set(names)):
            raise ValueError("workbook archive contains duplicate entry names")
        payloads = {info.filename: archive.read(info) for info in infos}
        metadata = {info.filename: _zip_metadata(info) for info in infos}
        return infos, payloads, metadata, archive.comment


def _write_archive(
    destination: Path,
    infos: list[ZipInfo],
    payloads: dict[str, bytes],
    archive_comment: bytes,
) -> None:
    with ZipFile(destination, "w") as archive:
        archive.comment = archive_comment
        for info in infos:
            archive.writestr(copy.copy(info), payloads[info.filename])


def _verify_archive(
    workbook_path: Path,
    before_payloads: dict[str, bytes],
    expected_payloads: dict[str, bytes],
    before_metadata: dict[str, tuple[object, ...]],
    before_comment: bytes,
    worksheet_paths: dict[str, str],
) -> None:
    with ZipFile(workbook_path) as archive:
        bad_entry = archive.testzip()
        if bad_entry is not None:
            raise ValueError(f"rewritten archive has a corrupt entry: {bad_entry}")
        infos = archive.infolist()
        names = [info.filename for info in infos]
        if names != list(before_payloads):
            raise ValueError("rewritten archive entry order or names changed")
        if archive.comment != before_comment:
            raise ValueError("rewritten archive comment changed")
        after_payloads = {info.filename: archive.read(info) for info in infos}
        after_metadata = {info.filename: _zip_metadata(info) for info in infos}

    if after_metadata != before_metadata:
        raise ValueError("rewritten archive did not preserve ZipInfo metadata")
    changed = {
        name for name in before_payloads
        if before_payloads[name] != after_payloads[name]
    }
    expected_changed = set(worksheet_paths.values())
    if changed != expected_changed:
        raise ValueError(
            f"unexpected rewritten payloads: {sorted(changed ^ expected_changed)}"
        )
    for sheet_name, path in worksheet_paths.items():
        if after_payloads[path] != expected_payloads[path]:
            raise ValueError(f"{sheet_name} payload differs from pane-only rewrite")
        _verify_pane(after_payloads[path], sheet_name)


def finalize_workbook(workbook_path: Path = WORKBOOK) -> None:
    """Atomically add frozen panes while proving every other payload unchanged."""
    workbook_path = Path(workbook_path)
    infos, before_payloads, before_metadata, before_comment = _snapshot(workbook_path)
    worksheet_paths = _resolve_worksheet_paths(before_payloads)
    expected_payloads = dict(before_payloads)
    for sheet_name in EXPECTED_SHEETS:
        path = worksheet_paths[sheet_name]
        expected_payloads[path] = _insert_pane_view(before_payloads[path], sheet_name)
        _verify_pane(expected_payloads[path], sheet_name)

    source_mode = stat.S_IMODE(workbook_path.stat().st_mode)
    temporary_path: Path | None = None
    try:
        with tempfile.NamedTemporaryFile(
            dir=workbook_path.parent,
            prefix=f".{workbook_path.name}.",
            suffix=".tmp",
            delete=False,
        ) as temporary:
            temporary_path = Path(temporary.name)
        _write_archive(temporary_path, infos, expected_payloads, before_comment)
        os.chmod(temporary_path, source_mode)
        _verify_archive(
            temporary_path,
            before_payloads,
            expected_payloads,
            before_metadata,
            before_comment,
            worksheet_paths,
        )
        os.replace(temporary_path, workbook_path)
        temporary_path = None
        _verify_archive(
            workbook_path,
            before_payloads,
            expected_payloads,
            before_metadata,
            before_comment,
            worksheet_paths,
        )
    finally:
        if temporary_path is not None:
            temporary_path.unlink(missing_ok=True)


def main(workbook_path: Path = WORKBOOK) -> int:
    try:
        finalize_workbook(workbook_path)
        print("CP0_WAIVER_PANES_PASS sheets=2 rows=2")
        return 0
    except (BadZipFile, ET.ParseError, KeyError, OSError, ValueError) as error:
        print(f"CP0_WAIVER_PANES_FAIL: {error}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
