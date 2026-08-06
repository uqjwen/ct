# Interaction 2.2 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Clarify that AG-FP-05-S07 is a DUT functional scenario verified through real input stimulus, and populate the CP0 waiver workbook with 45 source-traceable code-coverage exclusions and no fabricated approval data.

**Architecture:** Keep production RTL unchanged. Close the AG question through direction-aware documentation, testbench-comment clarification, and static regression tests; close the CP0 question through a reviewed CSV manifest, an artifact-tool workbook builder, a narrowly authorized standard-library pane finalizer, an independent OOXML checker, visual QA, and an evidence report.

**Tech Stack:** SystemVerilog source/testbench, Markdown, Python 3 `unittest` plus standard-library OOXML parsing, CSV, Node.js, `@oai/artifact-tool`, Git.

## Global Constraints

- Work only in `review/interaction-2.2-v1` until final integration.
- Do not modify any file under `srcs/`.
- Do not directly drive or force `lsu_mmu_abort`, `lsu_lrq_create_frz`, or `lag_ex1_stall_restart_entry` in the AG testbench.
- Keep AG dynamic results as `BLOCKED_NO_VCS` until real VCS logs and VDB evidence exist.
- Use `@oai/artifact-tool` from the bundled workspace runtime for all XLSX content and style authoring; do not use `openpyxl`, `xlsxwriter`, pandas, LibreOffice, or a general Excel writer. Per the user's option-A authorization, a standard-library OOXML finalizer may change only the two worksheet XML payloads to add the missing frozen-pane elements and must prove every other ZIP entry payload is byte-identical.
- Preserve the CP0 workbook's two-row, 17-column header, merged cells, fonts, fills, borders, and sheet names.
- Populate exactly 45 code-waiver rows: Line 4, Branch 5, Condition 11, Toggle 25, FSM 0.
- Populate exactly zero function-waiver rows because the DOCX says “未覆盖功能点情况：无”。
- Leave workbook columns K–P empty for every data row; do not invent proposer, reviewer, approver, or dates.
- Remove template examples `张三`, `李四`, `王五`, and `xxx` from workbook data rows.
- Keep the Office temporary lock file unchanged.
- Use TDD for executable checkers and workbook behavior: observe RED before implementation, then GREEN. Human-facing prose is reviewed directly and must not be protected by exact-phrase tests.

## File Responsibility Map

|File|Responsibility|
|---|---|
|`tests/test_interaction_2_2_ag_clarification.py`|Runs the AG boundary checker and verifies its observable result.|
|`tools/check_interaction_2_2_ag_boundary.py`|Mechanically proves signal directions, real input stimulus, output observation, and absence of direct DUT-output driving in the target task.|
|`doc-ag/xx_lsu_ld_ag_feature_test_plan.md`|Explains AG-FP-05-S07 as a DUT scenario and classifies stimulus, internal state, and observed outputs.|
|`doc-ag/xx_lsu_ld_ag_vcs_verification.md`|Explains the VCS driver/assertion/cover method and why “no force” is verification discipline.|
|`verif/xx_lsu_ld_ag/tb/xx_lsu_ld_ag_tb.sv`|Retains the existing stimulus and checks; changes only the ambiguous explanatory comment.|
|`waive/interaction_2_2_cp0_code_waiver_manifest.csv`|Auditable source-of-truth for the 45 CP0 code-waiver rows.|
|`tests/test_interaction_2_2_cp0_waiver.py`|Enforces manifest counts, workbook equality, blank management fields, and example removal.|
|`tools/build_interaction_2_2_cp0_waiver.mjs`|Imports the template, writes manifest data, preserves style, renders QA images, and exports XLSX.|
|`tools/finalize_interaction_2_2_cp0_waiver.py`|Narrowly adds a two-row frozen pane to each worksheet after Artifact Tool export and proves all unrelated ZIP payloads are unchanged.|
|`tools/check_interaction_2_2_cp0_waiver.py`|Independently reads XLSX OOXML and validates workbook structure/content without artifact-tool.|
|`waive/08-cp0_代码与功能覆盖率排除列表.xlsx`|Final CP0 workbook deliverable.|
|`docs/interaction-2.2-followup-review.md`|Closes both README questions and records evidence and remaining VCS/URG boundary.|

---

### Task 1: Clarify AG-FP-05 as a DUT Functional Scenario

**Files:**
- Create: `tests/test_interaction_2_2_ag_clarification.py`
- Create: `tools/check_interaction_2_2_ag_boundary.py`
- Modify: `doc-ag/xx_lsu_ld_ag_feature_test_plan.md:91-102`
- Modify: `doc-ag/xx_lsu_ld_ag_vcs_verification.md:70-90`
- Modify: `verif/xx_lsu_ld_ag/tb/xx_lsu_ld_ag_tb.sv:362-366`

**Interfaces:**
- Consumes: RTL port directions from `srcs/xx_lsu_ld_ag.sv`
- Consumes: existing `tc_stall_restart_owner`, `CHK_FP05_MASK_ABORT_REPLAY`, and `COV_FP05_MASK_ABORT_TABLE`
- Produces: checker marker `AG_FP05_DUT_BOUNDARY_PASS inputs=4 outputs=3`
- Produces: documentation phrase `AG-FP-05-S07 是 DUT 功能点`
- Produces: explicit stimulus/internal/output signal classification

- [ ] **Step 1: Write the failing AG clarification test**

```python
import subprocess
import sys
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]


class Interaction22AgClarificationTests(unittest.TestCase):
    def test_checker_accepts_real_input_to_observed_output_path(self) -> None:
        completed = subprocess.run(
            [sys.executable, "tools/check_interaction_2_2_ag_boundary.py"],
            cwd=ROOT,
            text=True,
            capture_output=True,
        )
        self.assertEqual(0, completed.returncode, completed.stderr)
        self.assertIn("AG_FP05_DUT_BOUNDARY_PASS inputs=4 outputs=3", completed.stdout)


if __name__ == "__main__":
    unittest.main()
```

- [ ] **Step 2: Run the focused test and confirm RED**

Run:

```bash
python3 -m unittest tests.test_interaction_2_2_ag_clarification -v
```

Expected: FAIL because `tools/check_interaction_2_2_ag_boundary.py` does not exist, so the subprocess returns nonzero.

- [ ] **Step 3: Implement the AG boundary checker**

Implement a standard-library Python checker that reads the real RTL and testbench, extracts `tc_stall_restart_owner`, and raises `ValueError` unless all four environment signals are RTL inputs, all three target signals are RTL outputs, the task drives the required access-fault stimulus, the task observes all three target outputs, and the task never assigns any target output. Print the deterministic PASS marker only after every check succeeds.

- [ ] **Step 4: Add the exact AG clarification text**

Insert the following section immediately before the AG-FP-05 scenario table in the feature plan, and mirror its verification-method paragraph in the VCS runbook:

```markdown
#### AG-FP-05-S07 的 DUT 边界

AG-FP-05-S07 是 DUT 功能点。“由真实 MMU 输入驱动、未直接强制 DUT 输出”描述的是验证方法：testbench 驱动 `dcache_arb_lag_ex1_sel`、`idu_lsu_rf_older_vld`、`mmu_lsu_pa_vld`、`mmu_lsu_access_fault` 和 `lrq_lsu_ex1_lrqid` 等 DUT 输入；DUT 内部派生 `ld_ag_stall_mask`、`lag_mmu_acfault` 和已保存的 LRQ owner；testbench 只观察 `lsu_mmu_abort`、`lsu_lrq_create_frz` 和 `lag_ex1_stall_restart_entry` 等 DUT 输出。验证环境不直接驱动或 force DUT 输出，因此 PASS 必须来自 RTL 因果链，而不是测试平台伪造结果。

该场景区分纯 TLB miss 与 aborted miss：纯 miss 保持 frozen；当独立 access-fault 使 `lsu_mmu_abort=1` 时，已创建 LRQ owner 必须得到 `lsu_lrq_create_frz=0` 和非零 restart bitmap。当前仅有静态 driver/assertion/cover 证据，动态状态仍为 `BLOCKED_NO_VCS`。
```

Replace the ambiguous testbench comment with:

```systemverilog
    // AG-FP-05-S07 is a DUT functional scenario.  The testbench drives only
    // upstream MMU/IDU/D-cache inputs; lsu_mmu_abort, create_frz, and the
    // restart bitmap must be produced by the DUT and are observation-only.
```

- [ ] **Step 5: Run the focused test and existing AG tests**

Run:

```bash
python3 -m unittest tests.test_interaction_2_2_ag_clarification tests.test_interaction_2_1_ag_detail -v
make -C verif/xx_lsu_ld_ag preflight
```

Expected: both Python test modules pass and AG preflight reports 12 features, 96 scenarios, and 211 reference-model cases with 3 source findings.

- [ ] **Step 6: Commit the AG clarification**

```bash
git add tests/test_interaction_2_2_ag_clarification.py \
  tools/check_interaction_2_2_ag_boundary.py \
  doc-ag/xx_lsu_ld_ag_feature_test_plan.md \
  doc-ag/xx_lsu_ld_ag_vcs_verification.md \
  verif/xx_lsu_ld_ag/tb/xx_lsu_ld_ag_tb.sv
git commit -m "docs: clarify AG-FP-05 DUT boundary"
```

---

### Task 2: Create the 45-Row CP0 Waiver Manifest

**Files:**
- Create: `waive/interaction_2_2_cp0_code_waiver_manifest.csv`
- Create: `tests/test_interaction_2_2_cp0_waiver.py`

**Interfaces:**
- Produces CSV columns: `coverage_type,source_object,module,source_section,condition,reason,impact,alternative,property,term,remarks`
- Produces exact type counts: `line=4`, `branch=5`, `condition=11`, `toggle=25`, `fsm=0`
- Produces exact module counts: `wk_cp0_regs=29`, `wk_cp0_iui=13`, `wk_cp0_lpmd=3`
- Later consumed by `build_interaction_2_2_cp0_waiver.mjs` and `check_interaction_2_2_cp0_waiver.py`

- [ ] **Step 1: Write the failing manifest contract test**

```python
import csv
import subprocess
import sys
import unittest
from collections import Counter
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
MANIFEST = ROOT / "waive/interaction_2_2_cp0_code_waiver_manifest.csv"
FIELDS = (
    "coverage_type", "source_object", "module", "source_section",
    "condition", "reason", "impact", "alternative", "property",
    "term", "remarks",
)


def read_manifest() -> list[dict[str, str]]:
    with MANIFEST.open(encoding="utf-8", newline="") as stream:
        return list(csv.DictReader(stream))


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
        self.assertIn("CP0_WAIVER_WORKBOOK_PASS", completed.stdout)
```

- [ ] **Step 2: Run the manifest test and confirm RED**

Run:

```bash
python3 -m unittest tests.test_interaction_2_2_cp0_waiver.Interaction22Cp0WaiverTests.test_manifest_has_exact_source_contract -v
```

Expected: FAIL with `FileNotFoundError` for the manifest.

- [ ] **Step 3: Transcribe the exact source-row identity contract**

Create one CSV row for each line below. The parenthesized labels distinguish two identical `cp0_dtu_satp` occurrences that the DOCX lists separately; the remarks column must say `原文重复列示，按来源出现次数保留` on the second occurrence.

```text
line|wk_cp0_regs|1.1.1|wk_cp0_regs.v:5373 | mteecfg_local_en
branch|wk_cp0_regs|1.1.2|wk_cp0_regs.v:5373 | mteecfg_local_en
branch|wk_cp0_regs|1.1.2|wk_cp0_regs.v:5955 | mvstien
condition|wk_cp0_regs|1.1.3|wk_cp0_regs.v:5955,6012 | mvstien=1
condition|wk_cp0_regs|1.1.3|wk_cp0_regs.v:4002,4036,3932,4026 | cp0_ecc_vld && cp0_ecc_fatal && !dcache_ecc_vld
condition|wk_cp0_regs|1.1.3|wk_cp0_regs.v:4805,4750 | mteecfg_local_en
condition|wk_cp0_regs|1.1.3|wk_cp0_regs.v:2023 | xs
condition|wk_cp0_regs|1.1.3|wk_cp0_regs.v:5133,4291,5265 | TCM paths
condition|wk_cp0_regs|1.1.3|wk_cp0_regs.v:1543 | tee_ff
condition|wk_cp0_regs|1.1.3|wk_cp0_regs.v:4750 | iui_regs_addr[11:8]=f && dtu_regs_sel
toggle|wk_cp0_regs|1.1.5|wk_cp0_regs.sv | cp0_idu_light_fence_en
toggle|wk_cp0_regs|1.1.5|wk_cp0_regs.sv | cp0_mmu_pa_equal_va
toggle|wk_cp0_regs|1.1.5|wk_cp0_regs.sv | cp0_yy_hyper
toggle|wk_cp0_regs|1.1.5|wk_cp0_regs.sv | cp0_yy_virtual_mode
toggle|wk_cp0_regs|1.1.5|wk_cp0_regs.sv | regs_iui_v
toggle|wk_cp0_regs|1.1.5|wk_cp0_regs.sv | regs_iui_chk_vld,reg_iui_tee_ff,reg_iui_tee_vld
toggle|wk_cp0_regs|1.1.5|wk_cp0_regs.sv | sip_raw unsupported bits
toggle|wk_cp0_regs|1.1.5|wk_cp0_regs.sv | mip_raw unsupported bits
toggle|wk_cp0_regs|1.1.5|wk_cp0_regs.sv | cp0_vfpu_fcsr[8],cp0_vfpu_fcsr[63:11]
toggle|wk_cp0_regs|1.1.5|wk_cp0_regs.sv | cp0_dtu_satp[62:61],cp0_dtu_satp[43:36] (first occurrence)
toggle|wk_cp0_regs|1.1.5|wk_cp0_regs.sv | cp0_ifu_rvbr[0]
toggle|wk_cp0_regs|1.1.5|wk_cp0_regs.sv | cp0_pad_mstatus reserved/tie-off fields
toggle|wk_cp0_regs|1.1.5|wk_cp0_regs.sv | cp0_vfpu_fxcr[22:6],cp0_vfpu_fxcr[31:27]
toggle|wk_cp0_regs|1.1.5|wk_cp0_regs.sv | regs_iui_wdata[63:32],regs_iui_wdata[27:25]
toggle|wk_cp0_regs|1.1.5|wk_cp0_regs.sv | reg_iui_reg_idx[3]
toggle|wk_cp0_regs|1.1.5|wk_cp0_regs.sv | cp0_hpcp_mcntwen[1]
toggle|wk_cp0_regs|1.1.5|wk_cp0_regs.sv | cp0_ifu_vbr[1]
toggle|wk_cp0_regs|1.1.5|wk_cp0_regs.sv | cp0_dtu_satp[62:61],cp0_dtu_satp[43:36] (second occurrence)
toggle|wk_cp0_regs|1.1.5|wk_cp0_regs.sv | regs_iui_int_sel[4],regs_iui_int_sel[13]
line|wk_cp0_iui|1.2.1|wk_cp0_iui.v:1179,1189,1195 | undefined register address ranges
line|wk_cp0_iui|1.2.1|wk_cp0_iui.v:2027-2037 | undefined interrupt types
branch|wk_cp0_iui|1.2.2|wk_cp0_iui.v:1179,1189,1195 | same as line coverage
branch|wk_cp0_iui|1.2.2|wk_cp0_iui.v:2027-2037 | same as line coverage
condition|wk_cp0_iui|1.2.3|wk_cp0_iui.v:1666 | TCM path
condition|wk_cp0_iui|1.2.3|wk_cp0_iui.v:1729 | tied signal
condition|wk_cp0_iui|1.2.3|wk_cp0_iui.v:1742-1751 | ini_v_mode and iui_tee_inv
toggle|wk_cp0_iui|1.2.5|wk_cp0_iui.sv | cp0_iu_ex3_abnormal
toggle|wk_cp0_iui|1.2.5|wk_cp0_iui.sv | cp0_iu_ex3_expt_vec
toggle|wk_cp0_iui|1.2.5|wk_cp0_iui.sv | sip_raw reserved bits
toggle|wk_cp0_iui|1.2.5|wk_cp0_iui.sv | mip_raw reserved bits
toggle|wk_cp0_iui|1.2.5|wk_cp0_iui.sv | cp0_biu_op[14:7]
toggle|wk_cp0_iui|1.2.5|wk_cp0_iui.sv | regs_iui_reg_idx[3]
line|wk_cp0_lpmd|1.3.1|wk_cp0_lpmd.v:238-253 | inst_lpmd_ex1_ex2 invariant
branch|wk_cp0_lpmd|1.3.2|wk_cp0_lpmd.v:238-253 | same as line coverage
condition|wk_cp0_lpmd|1.3.3|wk_cp0_lpmd.v:244-249 | lpmd_ack && !cpu_in_lpmd
```

- [ ] **Step 4: Fill source-backed condition and reason fields**

For numbered line/branch/condition entries, copy the DOCX paragraph text without changing technical meaning. For toggle entries, use the listed signal/field as `condition` and the exact DOCX tie-off, unsupported-feature, reserved-field, alignment, or encoding explanation as `reason`. Use these exact common fields for every row:

```csv
impact,"仅影响所列代码覆盖率统计；不替代功能正确性或动态回归签核"
alternative,"静态代码审查；按tie-off、保留域、未实现特性或协议不变量执行定向验证；在具备VCS/URG的环境复核适用边界"
property,"DOCX代码覆盖率排除项"
term,"待项目评审确认"
remarks,"来源：08-cp0_代码与功能覆盖率排除列表.docx；分组及同理排除引用按原文保留"
```

- [ ] **Step 5: Run the focused manifest test and confirm GREEN**

Run:

```bash
python3 -m unittest tests.test_interaction_2_2_cp0_waiver.Interaction22Cp0WaiverTests.test_manifest_has_exact_source_contract -v
```

Expected: PASS with 45 rows and exact type/module counts.

- [ ] **Step 6: Inspect the first, duplicate, and last rows manually**

Run:

```bash
python3 -c 'import csv; p="waive/interaction_2_2_cp0_code_waiver_manifest.csv"; r=list(csv.DictReader(open(p,encoding="utf-8"))); print(r[0]); print(r[19]); print(r[27]); print(r[-1])'
```

Expected: first row is regs line, rows for both SATP source occurrences are distinguishable, and final row is the LPMD condition waiver.

- [ ] **Step 7: Commit the manifest contract**

```bash
git add waive/interaction_2_2_cp0_code_waiver_manifest.csv tests/test_interaction_2_2_cp0_waiver.py
git commit -m "docs: inventory CP0 coverage waivers"
```

---

### Task 3: Build and Independently Check the CP0 Workbook

**Files:**
- Create: `tools/build_interaction_2_2_cp0_waiver.mjs`
- Create: `tools/finalize_interaction_2_2_cp0_waiver.py`
- Create: `tools/check_interaction_2_2_cp0_waiver.py`
- Modify: `waive/08-cp0_代码与功能覆盖率排除列表.xlsx`
- Modify: `tests/test_interaction_2_2_cp0_waiver.py`

**Interfaces:**
- Builder entry point: bundled Node.js running `tools/build_interaction_2_2_cp0_waiver.mjs`
- Pane finalizer entry point: `python3 tools/finalize_interaction_2_2_cp0_waiver.py`
- Checker entry point: `python3 tools/check_interaction_2_2_cp0_waiver.py`
- Pane finalizer marker: `CP0_WAIVER_PANES_PASS sheets=2 rows=2`
- Checker marker: `CP0_WAIVER_WORKBOOK_PASS code_rows=45 function_rows=0 line=4 branch=5 condition=11 toggle=25 fsm=0`
- Workbook data mapping: manifest fields to A–J and Q; K–P are six empty strings

- [ ] **Step 1: Run the workbook test and confirm RED**

Run:

```bash
python3 -m unittest tests.test_interaction_2_2_cp0_waiver.Interaction22Cp0WaiverTests.test_workbook_matches_manifest -v
```

Expected: FAIL because `tools/check_interaction_2_2_cp0_waiver.py` does not exist.

- [ ] **Step 2: Implement the standard-library OOXML checker**

Implement these exact responsibilities and function boundaries:

```python
WORKBOOK = ROOT / "waive/08-cp0_代码与功能覆盖率排除列表.xlsx"
MANIFEST = ROOT / "waive/interaction_2_2_cp0_code_waiver_manifest.csv"
EXPECTED_HEADERS = (
    "对象名称", "对象位置", "所属模块/子系统", "规范/需求编号",
    "排除条件描述", "排除原因", "影响评估", "替代验证手段",
    "属性", "计划期限", "提出人", "", "审核", "", "审批", "", "备注",
)
EXPECTED_MERGES = {"A1:A2", "B1:B2", "C1:C2", "D1:D2", "E1:E2",
                   "F1:F2", "G1:G2", "H1:H2", "I1:I2", "J1:J2",
                   "K1:L1", "M1:N1", "O1:P1", "Q1:Q2"}


def manifest_row(row: dict[str, str]) -> list[str]:
    return [
        row["coverage_type"], row["source_object"], row["module"],
        row["source_section"], row["condition"], row["reason"],
        row["impact"], row["alternative"], row["property"], row["term"],
        "", "", "", "", "", "", row["remarks"],
    ]


def check_workbook() -> tuple[int, int, Counter[str]]:
    """Return code rows, function rows, and coverage counts; raise ValueError on drift."""
```

Use `zipfile.ZipFile` and `xml.etree.ElementTree` to resolve shared strings, worksheet relationships, cell references, merge ranges, rows, and worksheet panes. Assert that code rows 3–47 exactly equal `manifest_row(...)`, function rows 3 onward are empty, K–P are blank, forbidden example names are absent, and both sheets serialize a frozen pane with `ySplit="2"`, `topLeftCell="A3"`, no horizontal split, and `state="frozen"` or `state="frozenSplit"`. Print the deterministic PASS marker only after every assertion succeeds.

- [ ] **Step 3: Implement the artifact-tool builder**

Use the bundled runtime returned by `codex_app__load_workspace_dependencies` and this exact mapping:

```javascript
function workbookRow(row) {
  return [
    row.coverage_type,
    row.source_object,
    row.module,
    row.source_section,
    row.condition,
    row.reason,
    row.impact,
    row.alternative,
    row.property,
    row.term,
    "", "", "", "", "", "",
    row.remarks,
  ];
}
```

Import the supplied CP0 workbook; inspect both sheets; render `A1:Q12` before editing; clear `A3:Q200` on both sheets; copy row-3 formatting to rows 3–47; write all manifest rows in one block; set wrap and vertical top alignment; center A, C, D, I, J, and K–P; apply bounded widths; calculate row heights from longest cell content; call the Artifact Tool freeze API for two rows; inspect `代码waiver!A1:Q47` and `功能waiver!A1:Q5`; scan formula errors; render code rows 1–14, code rows 36–47, and function rows 1–5; export to the original workbook path.

Use these width bounds to preserve the template while keeping narrative fields legible:

```javascript
const widths = {
  A: 12, B: 42, C: 20, D: 18, E: 42, F: 48, G: 30, H: 38, I: 22,
  J: 20, K: 10, L: 12, M: 12, N: 12, O: 12, P: 12, Q: 36,
};
```

- [ ] **Step 4: Implement the narrowly authorized pane finalizer**

Write a standard-library Python tool that resolves the two worksheet paths through `xl/workbook.xml` and its relationships, inserts exactly one `sheetViews/sheetView/pane` structure into each worksheet with `workbookViewId="0"`, `ySplit="2"`, `topLeftCell="A3"`, `activePane="bottomLeft"`, and `state="frozen"`, and refuses unexpected existing pane/view structures. It must preserve every unmodified ZIP entry payload byte-for-byte, preserve `ZipInfo` metadata when rewriting the archive, verify that exactly the two expected worksheet payloads changed, atomically replace the original workbook, and emit `CP0_WAIVER_PANES_PASS sheets=2 rows=2` only after post-write verification succeeds. It must not read or write cell values, styles, merges, shared strings, or workbook metadata.

- [ ] **Step 5: Set up the bundled artifact-tool runtime, run the builder, and finalize panes**

Run using the exact paths returned by the workspace dependency loader:

```bash
ln -sfn /Users/mjw/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules node_modules
/Users/mjw/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/bin/node tools/build_interaction_2_2_cp0_waiver.mjs
python3 tools/finalize_interaction_2_2_cp0_waiver.py
unlink node_modules
```

Expected: builder emits `CP0_WAIVER_BUILDER_PASS rows=45`; the finalizer emits `CP0_WAIVER_PANES_PASS sheets=2 rows=2`; the temporary `node_modules` symlink is not committed.

- [ ] **Step 6: Inspect values, formulas, and rendered sheets**

Confirm artifact-tool inspection shows rows 3–47 populated in `代码waiver`, no data in `功能waiver`, no formula-error matches, and blank K–P fields. Open every produced PNG with the local image viewer. Fix clipping, excessive row heights, or unreadable wrapping and rerun the builder until all three final renders are legible.

- [ ] **Step 7: Run the checker and workbook tests**

Run:

```bash
python3 tools/check_interaction_2_2_cp0_waiver.py
python3 -m unittest tests.test_interaction_2_2_cp0_waiver -v
```

Expected:

```text
CP0_WAIVER_WORKBOOK_PASS code_rows=45 function_rows=0 line=4 branch=5 condition=11 toggle=25 fsm=0
```

- [ ] **Step 8: Inspect the XLSX archive structurally**

Run:

```bash
unzip -t "waive/08-cp0_代码与功能覆盖率排除列表.xlsx"
git diff --check
git status --short
```

Expected: the XLSX archive is valid; only the intended workbook, builder, pane finalizer, checker, and test changes are present.

- [ ] **Step 9: Commit the workbook delivery**

```bash
git add "waive/08-cp0_代码与功能覆盖率排除列表.xlsx" \
  tools/build_interaction_2_2_cp0_waiver.mjs \
  tools/finalize_interaction_2_2_cp0_waiver.py \
  tools/check_interaction_2_2_cp0_waiver.py \
  tests/test_interaction_2_2_cp0_waiver.py
git commit -m "docs: populate CP0 coverage waiver workbook"
```

---

### Task 4: Close Interaction 2.2 with Evidence and Full Regression

**Files:**
- Create: `docs/interaction-2.2-followup-review.md`

**Interfaces:**
- Produces report sections: AG conclusion, input/internal/output mapping, CP0 counts, management-field boundary, pane-finalization boundary, static evidence, dynamic boundary, and licensed-host commands
- Consumes pane-finalizer and checker markers from Task 3
- Preserves existing interaction 1.6–2.1 test contracts

- [ ] **Step 1: Write the evidence report**

The report must state:

```text
AG-FP-05-S07 是 DUT 功能点；testbench 通过上游输入形成因果链，三个目标输出均由 DUT 产生。
CP0_WAIVER_WORKBOOK_PASS code_rows=45 function_rows=0 line=4 branch=5 condition=11 toggle=25 fsm=0。
CP0_WAIVER_PANES_PASS sheets=2 rows=2；工作簿内容与样式由 Artifact Tool 生成，标准库终结器仅补写两处冻结窗格并证明其他 ZIP payload 字节不变。
K–P 管理字段按用户确认保持空白；模板示例已清除。
本机静态测试和工作簿检查不等于 VCS/URG 动态签核，AG 状态仍为 BLOCKED_NO_VCS。
```

Include source paths, focused commands, complete commands, and licensed-host commands. Do not claim VCS compile, simulation, functional coverage, or code coverage passed.
Review this human-facing prose directly against the README and design; do not add exact-phrase tests for it.

- [ ] **Step 2: Run the complete static verification set**

Run:

```bash
python3 -m unittest discover -s tests -v
make -C verif/common preflight
python3 tools/check_interaction_2_1_waiver.py
python3 tools/check_interaction_2_2_cp0_waiver.py
unzip -t "waive/08-cp0_代码与功能覆盖率排除列表.xlsx"
git diff --check
```

Expected: all commands exit 0; the suite has at least 43 tests after adding interaction-2.2 tests; aggregate preflight remains 7 environments, 85 features, and 534 scenarios.

- [ ] **Step 3: Probe and record the licensed-tool boundary**

Run:

```bash
make -C verif/common compile
```

Expected on this host: static preflight passes first, then make exits nonzero with `Synopsys VCS not found`. Record this as an expected environment boundary, not a passed build.

- [ ] **Step 4: Verify scope and repository cleanliness**

Run:

```bash
git diff origin/main...HEAD -- srcs
git status -sb
git diff --check
```

Expected: no production RTL diff and no untracked QA images, PDFs, `node_modules`, or artifact directories.

- [ ] **Step 5: Commit the final report**

```bash
git add docs/interaction-2.2-followup-review.md
git commit -m "docs: close interaction 2.2 review"
```

---

### Task 5: Final Verification, Fast-Forward Main, and Push

**Files:**
- No new deliverable files; this task verifies and publishes reviewed commits.

**Interfaces:**
- Consumes: clean `review/interaction-2.2-v1`
- Produces: non-force updated `origin/main`

- [ ] **Step 1: Invoke completion and branch-finishing skills**

Read and follow `verification-before-completion` and `finishing-a-development-branch` before making a completion claim or publishing.

- [ ] **Step 2: Fetch and reconcile remote main**

Run:

```bash
git fetch origin main --prune
git log --oneline --left-right main...origin/main
```

If remote moved, inspect every new commit, reconcile without force, and rerun the complete verification set after reconciliation.

- [ ] **Step 3: Run fresh verification on the final review commit**

Repeat Task 4 Step 2 and inspect the final three workbook renders again. Verify `git diff --check` and a clean worktree.

- [ ] **Step 4: Fast-forward local main**

From the primary checkout:

```bash
git merge --ff-only review/interaction-2.2-v1
```

Expected: `main` advances without a merge commit.

- [ ] **Step 5: Run the complete verification set on merged main**

Run Task 4 Step 2 from the primary checkout. Stop before pushing if any command fails.

- [ ] **Step 6: Push without force and verify exact remote equality**

Run:

```bash
git push origin main
git fetch origin main
git rev-list --left-right --count main...origin/main
git status -sb
```

Expected: ahead/behind is `0 0`, local/remote commit hashes match, and `main` is clean.

- [ ] **Step 7: Clean the owned worktree and report evidence**

After the merged main verification and remote-equality check pass, remove `.worktrees/interaction-2.2-v1`, prune worktrees, and delete the merged review branch with non-force deletion. Report the final commit hash, test count, preflight totals, workbook counts, workbook path, and explicit VCS/URG boundary.
