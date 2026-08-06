import csv
import io
import subprocess
import sys
import tempfile
import unittest
from collections import Counter
from contextlib import redirect_stdout
from pathlib import Path
from xml.etree import ElementTree as ET
from zipfile import ZIP_DEFLATED, ZipFile, ZipInfo

from tools.check_interaction_2_2_cp0_waiver import check_workbook
from tools.finalize_interaction_2_2_cp0_waiver import (
    finalize_workbook,
    main as finalize_main,
)


ROOT = Path(__file__).resolve().parents[1]
MANIFEST = ROOT / "waive/interaction_2_2_cp0_code_waiver_manifest.csv"
FIELDS = (
    "coverage_type", "source_object", "module", "source_section",
    "condition", "reason", "impact", "alternative", "property",
    "term", "remarks",
)
PASS_MARKER = (
    "CP0_WAIVER_WORKBOOK_PASS code_rows=45 function_rows=0 "
    "line=4 branch=5 condition=11 toggle=25 fsm=0"
)
PANE_MARKER = "CP0_WAIVER_PANES_PASS sheets=2 rows=2"
SHEET_NS = "http://schemas.openxmlformats.org/spreadsheetml/2006/main"
REL_NS = "http://schemas.openxmlformats.org/officeDocument/2006/relationships"
PKG_REL_NS = "http://schemas.openxmlformats.org/package/2006/relationships"
EXPECTED_PANE = {
    "ySplit": "2",
    "topLeftCell": "A3",
    "activePane": "bottomLeft",
    "state": "frozen",
}
ZIP_METADATA_FIELDS = (
    "filename", "orig_filename", "date_time", "compress_type", "comment", "extra",
    "create_system", "create_version", "extract_version", "reserved",
    "flag_bits", "volume", "internal_attr", "external_attr",
)


def read_manifest() -> list[dict[str, str]]:
    with MANIFEST.open(encoding="utf-8", newline="") as stream:
        return list(csv.DictReader(stream))


def zip_metadata(info: ZipInfo) -> tuple[object, ...]:
    return tuple(getattr(info, field) for field in ZIP_METADATA_FIELDS)


def write_finalizer_fixture(path: Path, existing_view: bool = False) -> None:
    workbook_xml = f"""<?xml version="1.0" encoding="UTF-8"?>
<workbook xmlns="{SHEET_NS}" xmlns:r="{REL_NS}"><sheets>
<sheet name="代码waiver" sheetId="1" r:id="rId1"/>
<sheet name="功能waiver" sheetId="2" r:id="rId2"/>
</sheets></workbook>""".encode()
    relationships_xml = f"""<?xml version="1.0" encoding="UTF-8"?>
<Relationships xmlns="{PKG_REL_NS}">
<Relationship Id="rId1" Type="worksheet" Target="worksheets/sheet1.xml"/>
<Relationship Id="rId2" Type="worksheet" Target="worksheets/sheet2.xml"/>
</Relationships>""".encode()
    view = (
        '<sheetViews><sheetView workbookViewId="0"/></sheetViews>'
        if existing_view else ""
    )
    sheet_one = (
        f'<?xml version="1.0" encoding="UTF-8"?>'
        f'<worksheet xmlns="{SHEET_NS}">{view}'
        '<sheetFormatPr defaultRowHeight="15"/><sheetData/></worksheet>'
    ).encode()
    sheet_two = (
        f'<?xml version="1.0" encoding="UTF-8"?>'
        f'<x:worksheet xmlns:x="{SHEET_NS}">'
        '<x:sheetFormatPr defaultRowHeight="15"/><x:sheetData/></x:worksheet>'
    ).encode()
    payloads = {
        "xl/workbook.xml": workbook_xml,
        "xl/_rels/workbook.xml.rels": relationships_xml,
        "xl/worksheets/sheet1.xml": sheet_one,
        "xl/worksheets/sheet2.xml": sheet_two,
        "docProps/core.xml": b"unchanged sentinel payload",
    }
    with ZipFile(path, "w") as archive:
        archive.comment = b"archive-comment"
        for index, (name, payload) in enumerate(payloads.items(), start=1):
            info = ZipInfo(name, date_time=(2020, 1, index, 4, 5, 6))
            info.compress_type = ZIP_DEFLATED
            info.comment = f"entry-{index}".encode()
            info.extra = b"\x01\x00\x00\x00"
            info.create_system = 3
            info.external_attr = 0o100600 << 16
            archive.writestr(info, payload)


class Interaction22Cp0WaiverTests(unittest.TestCase):
    def test_manifest_has_exact_source_contract(self) -> None:
        rows = read_manifest()
        self.assertEqual(45, len(rows))
        self.assertEqual(FIELDS, tuple(rows[0]))
        self.assertEqual(
            Counter({"toggle": 25, "condition": 11, "branch": 5, "line": 4}),
            Counter(row["coverage_type"] for row in rows),
        )
        self.assertEqual(
            Counter({"wk_cp0_regs": 29, "wk_cp0_iui": 13, "wk_cp0_lpmd": 3}),
            Counter(row["module"] for row in rows),
        )
        self.assertTrue(all(all(row[field].strip() for field in FIELDS) for row in rows))
        self.assertTrue(all(row["property"] == "DOCX代码覆盖率排除项" for row in rows))
        self.assertTrue(all(row["term"] == "待项目评审确认" for row in rows))

    def test_workbook_matches_manifest(self) -> None:
        completed = subprocess.run(
            [sys.executable, "tools/check_interaction_2_2_cp0_waiver.py"],
            cwd=ROOT,
            text=True,
            capture_output=True,
        )
        self.assertEqual(0, completed.returncode, completed.stderr)
        self.assertEqual(PASS_MARKER, completed.stdout.strip())

    def test_workbook_serializes_two_row_frozen_panes(self) -> None:
        code_rows, function_rows, _ = check_workbook()
        self.assertEqual((45, 0), (code_rows, function_rows))


class Interaction22Cp0WaiverFinalizerTests(unittest.TestCase):
    def test_finalizer_changes_only_two_sheets_and_inserts_exact_panes(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            workbook = Path(directory) / "fixture.xlsx"
            write_finalizer_fixture(workbook)
            with ZipFile(workbook) as archive:
                before = {info.filename: archive.read(info) for info in archive.infolist()}

            finalize_workbook(workbook)

            with ZipFile(workbook) as archive:
                after = {info.filename: archive.read(info) for info in archive.infolist()}
            changed = {name for name in before if before[name] != after[name]}
            self.assertEqual(
                {"xl/worksheets/sheet1.xml", "xl/worksheets/sheet2.xml"},
                changed,
            )
            for name in changed:
                root = ET.fromstring(after[name])
                views = root.findall(f"{{{SHEET_NS}}}sheetViews")
                self.assertEqual(1, len(views))
                sheet_views = views[0].findall(f"{{{SHEET_NS}}}sheetView")
                self.assertEqual(1, len(sheet_views))
                self.assertEqual({"workbookViewId": "0"}, sheet_views[0].attrib)
                panes = sheet_views[0].findall(f"{{{SHEET_NS}}}pane")
                self.assertEqual(1, len(panes))
                self.assertEqual(EXPECTED_PANE, panes[0].attrib)

    def test_finalizer_preserves_zip_metadata_and_archive_comment(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            workbook = Path(directory) / "fixture.xlsx"
            write_finalizer_fixture(workbook)
            with ZipFile(workbook) as archive:
                before_comment = archive.comment
                before = {
                    info.filename: zip_metadata(info) for info in archive.infolist()
                }

            finalize_workbook(workbook)

            with ZipFile(workbook) as archive:
                after_comment = archive.comment
                after = {
                    info.filename: zip_metadata(info) for info in archive.infolist()
                }
            self.assertEqual(before_comment, after_comment)
            self.assertEqual(before, after)

    def test_finalizer_refuses_existing_views_without_replacing_workbook(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            workbook = Path(directory) / "fixture.xlsx"
            write_finalizer_fixture(workbook, existing_view=True)
            before = workbook.read_bytes()

            with self.assertRaisesRegex(ValueError, "unexpected existing worksheet view"):
                finalize_workbook(workbook)

            self.assertEqual(before, workbook.read_bytes())

    def test_finalizer_main_emits_marker_after_verified_replacement(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            workbook = Path(directory) / "fixture.xlsx"
            write_finalizer_fixture(workbook)
            output = io.StringIO()
            with redirect_stdout(output):
                result = finalize_main(workbook)
            self.assertEqual(0, result)
            self.assertEqual(PANE_MARKER, output.getvalue().strip())
