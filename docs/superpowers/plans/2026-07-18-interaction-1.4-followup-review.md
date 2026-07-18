# Interaction 1.4 LSU Follow-up Review Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Reassess every Interaction 1.4 clarification against commit `6260f4a`, regenerate the detailed scalar LD-DA report under the requested `doc-da` path, and publish one auditable documentation commit.

**Architecture:** Treat README statements as contracts until the newly supplied RTL proves them. Trace each changed or newly supplied producer through its consumer, classify every prior risk as source-closed, contract-only, narrowed, or still open, and keep all deliverables documentation-only.

**Tech Stack:** SystemVerilog/Verilog static data-flow review, `rg`, Git diff/status checks, Markdown.

## Global Constraints

- Base all conclusions on remote commit `6260f4a` (`interaction-1.4`).
- Do not modify README or RTL source files.
- Put the regenerated scalar `xx_lsu_ld_da` report and verification plan in `doc-da/` exactly as requested.
- Preserve uncertainty whenever a producer, arbiter, protocol definition, testbench, or helper module is absent.
- Finish with one commit and push it directly to the remote default branch `main`.

---

### Task 1: Verify Interaction 1.4 RTL changes

**Files:**
- Inspect: `README.md`
- Inspect: `srcs/xx_lsu_ld_da.sv`
- Inspect: `srcs/xx_lsu_ls_ld_da.sv`
- Inspect: `srcs/xx_lsu_ld_wb.sv`

**Interfaces:**
- Consumes: README items 1-5 and the previous DA/WB risk IDs.
- Produces: Evidence-backed closure status for DA-RR-01, WB-RR-01, and WB-RR-02.

- [ ] **Step 1: Compare the new commit with the prior review base**

Run: `git diff 6d03c0d..HEAD -- README.md srcs/xx_lsu_ld_da.sv srcs/xx_lsu_ls_ld_da.sv srcs/xx_lsu_ld_wb.sv`

Expected: README and WB change are visible; no scalar LD-DA change is present.

- [ ] **Step 2: Trace DA block-3 replay identity**

Run: `rg -n "data_ori3|data2|data3" srcs/xx_lsu_ld_da.sv srcs/xx_lsu_ls_ld_da.sv`

Expected: scalar LD-DA still selects `data2`; LSDA selects `data3`.

- [ ] **Step 3: Trace both source and consumer clocks for halt-info update/clear**

Run: `rg -n "ld_wb_(cmplt|data)_clk_en|rb_data_halt_info_update_vld|ld_wb_halt_info_effect" srcs/xx_lsu_ld_wb.sv`

Expected: completion clock includes the registered update pulse, while the data clock does not guarantee creation/clearing of that pulse and the completion clock does not include the bit1 clear event.

### Task 2: Reclassify newly supplied integration contracts

**Files:**
- Inspect: `srcs/xx_lsu_dcache_arb.sv`
- Inspect: `srcs/xx_lsu_bus_arb.sv`
- Inspect: `srcs/xx_lsu_top.sv`
- Inspect: `srcs/xx_lsu_wmb.sv`
- Inspect: `srcs/mmu/xx_mmu_dutlb.v`
- Inspect: `srcs/mmu/xx_mmu_dutlb_tmq.sv`
- Inspect: `srcs/mmu/xx_mmu_dutlb_tmq_entry.sv`

**Interfaces:**
- Consumes: DC-RR-02, WB-RR-04, LRQ-RR-03, and the missing-module list in the Interaction 1.3 summary.
- Produces: Source-closure matrix plus an exact remaining-information list.

- [ ] **Step 1: Compare D-cache borrow valid and gate expressions**

Run: `nl -ba srcs/xx_lsu_dcache_arb.sv | sed -n '512,545p'`

Expected: VB/SNQ terms use distinct `borrow_req` and `borrow_req_gate` inputs, so equality still depends on missing producers.

- [ ] **Step 2: Identify the actual three-lane writeback arbiter**

Run: `rg -n "xx_lsu_wb_arbiter|xx_lsu_bus_arb|arb_lwb0_wmb_data_req" srcs`

Expected: top instantiates `xx_lsu_wb_arbiter`, but its implementation is absent; supplied `xx_lsu_bus_arb` arbitrates BIU channels instead.

- [ ] **Step 3: Trace MMU wakeup state through flush**

Run: `rg -n "rtu_ck_flush|tmq_entry_lsid|cmplt_wakeup|spec_wakeup" srcs/mmu/xx_mmu_dutlb*.v srcs/mmu/xx_mmu_dutlb*.sv`

Expected: TMQ stores IID/LSID, flush clears pending LSID state and emits wakeup vectors, materially narrowing LRQ-RR-03 to assertions and any still-missing producer paths.

### Task 3: Regenerate the detailed DA deliverables

**Files:**
- Create: `doc-da/xx_lsu_ld_da_detailed_risk_review.md`
- Create: `doc-da/xx_lsu_ld_da_verification_focus.md`

**Interfaces:**
- Consumes: scalar LD-DA control/data-flow evidence and Interaction 1.4 item 6.
- Produces: Explicit DA-RR-01 through DA-RR-05 analysis, trigger sequences, impact, status, assertions, and tests under the exact requested directory.

- [ ] **Step 1: Write the detailed risk report**

Include exact source anchors, separate scalar LD-DA from LSDA, and explain why a correct LSDA analogue does not fix scalar DA-RR-01.

- [ ] **Step 2: Write the verification plan**

Include four-distinct-block ECC replay, SQ-forward/ECC, RB accept/restart, debug side effects, flush/epoch, and scalar-vs-LSDA parity checks with concrete SystemVerilog assertions.

- [ ] **Step 3: Check every DA risk ID is present in both files**

Run: `for id in DA-RR-01 DA-RR-02 DA-RR-03 DA-RR-04 DA-RR-05; do rg -q "$id" doc-da/*.md || exit 1; done`

Expected: exit 0.

### Task 4: Publish the Interaction 1.4 follow-up matrix

**Files:**
- Create: `docs/interaction-1.4-followup-review.md`
- Modify: `doc-wb/xx_lsu_ld_wb_risk_review.md`
- Modify: `doc-wb/xx_lsu_ld_wb_verification_focus.md`
- Modify: `doc-dc/xx_lsu_ld_dc_risk_review.md`
- Modify: `doc-dc/xx_lsu_ld_dc_verification_focus.md`
- Modify: `doc-lrq/xx_lsu_lrq_risk_review.md`
- Modify: `doc-lrq/xx_lsu_lrq_verification_focus.md`

**Interfaces:**
- Consumes: Tasks 1-3 evidence.
- Produces: One authoritative 1.4 response, synchronized module-level status, and exact requests for missing source/specification.

- [ ] **Step 1: Write the seven-item response matrix**

For each README item, state disposition, evidence, consequence, and remaining action without claiming RTL closure from README text alone.

- [ ] **Step 2: Synchronize affected module reports and verification plans**

Mark incomplete fixes as open, source-proven MMU behavior as narrowed, and preserve contract-only status for absent producers/arbiter.

- [ ] **Step 3: Verify links and stale status text**

Run: `rg -n "Interaction 1.4|doc-da|WB-RR-01|WB-RR-02|DC-RR-02|LRQ-RR-03" docs doc-da doc-wb doc-dc doc-lrq`

Expected: all new conclusions and paths are discoverable; no new summary points to `doc_da`.

### Task 5: Validate and publish one commit

**Files:**
- Verify: all changed Markdown files.

**Interfaces:**
- Consumes: completed documentation artifacts.
- Produces: one clean commit whose SHA is identical on local HEAD and remote `main`.

- [ ] **Step 1: Run documentation and repository checks**

Run: `git diff --check && ! rg -n "T[B]D|TO[D]O|implement lat[e]r|fill in detail[s]" docs/interaction-1.4-followup-review.md doc-da doc-wb doc-dc doc-lq doc-lrq doc-rb doc-ctrl && git status --short`

Expected: `git diff --check` passes; placeholder scan only matches explanatory text if present; status lists documentation files only.

- [ ] **Step 2: Review the final diff**

Run: `git diff --stat && git diff -- README.md srcs`

Expected: documentation changes only; no README or RTL diff.

- [ ] **Step 3: Commit once**

Run: `git add docs doc-da doc-wb doc-dc doc-lq doc-lrq doc-rb doc-ctrl && git commit -m "docs: review interaction 1.4 LSU risks"`

Expected: one new documentation commit.

- [ ] **Step 4: Push and verify remote identity**

Run: `git push origin HEAD:main && git fetch origin main && test "$(git rev-parse HEAD)" = "$(git rev-parse origin/main)"`

Expected: push succeeds and local/remote SHAs are identical.
