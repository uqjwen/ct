# LSU Load Address Generation Documentation Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Produce reviewer-ready line annotations, a verification specification, a categorized verification feature workbook, and a design-risk report for `ct_lsu_ld_ag.v`, then verify and commit the artifacts.

**Architecture:** Treat the Verilog file as the single source of truth. First extract its interfaces, state, combinational equations, clocking, stalls, exceptions, MMU/DCACHE handshakes, and output mappings; then reuse one reviewed analysis model across Markdown, Word, and Excel outputs so names and behavior remain consistent.

**Tech Stack:** Verilog source inspection, Markdown, Python with `python-docx`, LibreOffice/Poppler rendering, JavaScript with `@oai/artifact-tool`, Git.

## Global Constraints

- Preserve `ct_lsu_ld_ag.v`; documentation work must not alter RTL behavior.
- Create `ct_lsu_ld_ag.md` with source-line anchors and a Chinese explanation for every non-blank source line.
- Create `ld_ag_spec.doc` for the verification team, with an editable `ld_ag_spec.docx` source retained for maintainability.
- Create an Excel workbook with columns for category, detailed feature, description, configuration, and test method.
- Record potential risks or bugs separately, distinguishing confirmed code facts from integration assumptions and open questions.
- Verify generated files structurally and visually before committing.

---

### Task 1: Establish isolated branch and extract RTL behavior

**Files:**
- Read: `ct_lsu_ld_ag.v`
- Create: `work/analysis/rtl_model.json`

**Interfaces:**
- Consumes: the full 1462-line RTL source.
- Produces: normalized sections, signal groups, functional equations, sequencing notes, and review findings used by all deliverables.

- [ ] **Step 1:** Create branch `docs/interaction-1-0` from the clean default branch.
- [ ] **Step 2:** Parse declarations, assignments, always blocks, and module instances with line anchors.
- [ ] **Step 3:** Manually review behavior by functional block and record confirmed facts, inferred protocol semantics, and unresolved questions separately.
- [ ] **Step 4:** Run structural checks for duplicate/missing ports, width mismatches visible from declarations, undriven outputs, and suspicious truncations/extensions.

### Task 2: Build line-by-line Markdown annotation

**Files:**
- Create: `ct_lsu_ld_ag.md`

**Interfaces:**
- Consumes: `ct_lsu_ld_ag.v` and the reviewed RTL analysis model.
- Produces: a navigable Markdown document whose line anchors map directly to the source.

- [ ] **Step 1:** Add module overview, reading guide, terminology, and functional-block index.
- [ ] **Step 2:** Emit source excerpts with original line numbers and an adjacent Chinese explanation for each non-blank source line.
- [ ] **Step 3:** Add cross-references for address generation, byte masks, 4 KiB/page crossing, stall/restart, exception, MMU, DCACHE, and clock-gating logic.
- [ ] **Step 4:** Verify every non-blank source line appears exactly once in the annotation index.

### Task 3: Build verification specification in Word formats

**Files:**
- Create: `ld_ag_spec.docx`
- Create: `ld_ag_spec.doc`

**Interfaces:**
- Consumes: interface inventory and reviewed block behavior.
- Produces: a verification-oriented specification with timing assumptions, stimulus/response rules, corner cases, assertions, and open questions.

- [ ] **Step 1:** Generate a styled DOCX with revision record, scope, interface tables, functional behavior, timing, reset/clocking, verification strategy, coverage targets, and unresolved items.
- [ ] **Step 2:** Convert DOCX to genuine Word 97-2003 DOC format.
- [ ] **Step 3:** Render the DOCX and DOC to PDF/PNG and inspect every page for clipping, broken tables, and unreadable text.
- [ ] **Step 4:** Extract text from the generated document and verify mandatory headings and signal names.

### Task 4: Build categorized verification feature workbook

**Files:**
- Create: `ld_ag_feature_list.xlsx`

**Interfaces:**
- Consumes: reviewed functional blocks, configuration inputs, corner cases, and risk findings.
- Produces: filterable verification features with exactly the requested five core columns plus traceability and priority fields.

- [ ] **Step 1:** Populate feature rows for instruction capture, address calculation, size/mask/rotation, split/cross-page, MMU, memory attributes, DCACHE, exceptions, stalls/restart, ordering/atomic, outputs, reset, and clock gating.
- [ ] **Step 2:** Apply table styling, filters, freeze panes, wrapped text, category coloring, and practical column widths.
- [ ] **Step 3:** Inspect key ranges and scan for formula errors.
- [ ] **Step 4:** Render the complete sheet and inspect it visually before export.

### Task 5: Document design risks and open questions

**Files:**
- Create: `ct_lsu_ld_ag_risk_review.md`

**Interfaces:**
- Consumes: structural checks and manual review findings.
- Produces: severity-ranked findings with evidence, impact, recommended verification, and clarification questions.

- [ ] **Step 1:** Separate likely RTL defects, integration risks, maintainability concerns, and specification questions.
- [ ] **Step 2:** Anchor every finding to exact source lines and avoid claiming a bug without evidence.
- [ ] **Step 3:** Provide a minimal reproducer or directed-test idea for each high/medium item.
- [ ] **Step 4:** Cross-check that open questions also appear in the verification specification.

### Task 6: Verify and commit

**Files:**
- Verify: all requested artifacts and supporting source files.
- Modify: Git history only after verification succeeds.

**Interfaces:**
- Consumes: completed artifacts.
- Produces: a clean, reviewable Git commit.

- [ ] **Step 1:** Run Markdown coverage, DOC/DOCX structure, workbook structure, RTL compile/lint if tools are available, and visual-render checks.
- [ ] **Step 2:** Re-read README and map every numbered requirement to an artifact.
- [ ] **Step 3:** Confirm `ct_lsu_ld_ag.v` is byte-identical to `origin/main`.
- [ ] **Step 4:** Commit verified artifacts with a descriptive message; inspect remote branches before deciding whether `master` means an existing branch or the repository's current `main` branch.
