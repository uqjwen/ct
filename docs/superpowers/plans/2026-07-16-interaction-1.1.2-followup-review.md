# Interaction 1.1.2 Follow-up Review Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Verify the interaction 1.1.2 RTL changes and eight clarifications, reclassify the existing risks, and continue searching for replay-metadata, MMU-ownership, wakeup, and X-propagation bugs.

**Architecture:** Keep the supplied RTL and README unchanged. Trace each clarification through producer, top-level wiring, consumer, sequential priority, and valid gating; accept external MMU behavior only as an explicit integration contract. Update the existing risk and verification documents with corrected dispositions, technical pushback where a clarification is incomplete, and mechanically checkable assertions.

**Tech Stack:** SystemVerilog RTL, Git history, four-state truth-table analysis, read-only static analysis, Markdown.

## Global Constraints

- Do not modify `srcs/` or `README.md`.
- Evaluate all eight interaction 1.1.2 README items; do not carry forward an obsolete interaction 1.1.1 conclusion.
- Treat `mmu_lsu_imme_wakeup==0`, async-only wakeup, and full/partial-flush cancellation of MMU pending entries as integration contracts because the MMU implementation is not supplied.
- Every retained risk must identify the exact surviving observable path; every closed risk must identify the equation or contract that closes it.
- Verify source citations, Markdown structure, named-port sets, staged scope, and final remote SHA before completion.

---

### Task 1: Establish the interaction 1.1.2 baseline and disposition map

**Files:**
- Read: `README.md`
- Read: `srcs/xx_lsu_ld_ag.sv`
- Read: `doc-1.1/xx_lsu_ld_ag_risk_review.md`
- Read: `doc-1.1/xx_lsu_ld_ag_verification_focus.md`

**Interfaces:**
- Consumes: commit `218df2d`, the eight new clarifications, and previous RR-02/RR-03/RR-12/RR-13/RR-14/RR-16 findings.
- Produces: an eight-row clarification table with each item marked fixed, contract-closed, narrowed, retained, or incomplete.

- [x] **Step 1:** Confirm the new commit changes only `README.md` and `srcs/xx_lsu_ld_ag.sv` relative to the previous review baseline.
- [x] **Step 2:** Map README items 1-8 to RR-13, RR-14, RR-16, RR-02/RR-03, and RR-12.
- [x] **Step 3:** Record the new external contracts: immediate wake is tied low, only async wake is legal, and full/partial flush directly removes matching MMU pending requests.

### Task 2: Prove the RR-13 and RR-12 RTL changes

**Files:**
- Read: `srcs/xx_lsu_ld_ag.sv`
- Read: `srcs/xx_lsu_lrq_entry.sv`
- Read: `srcs/xx_lsu_ctrl.sv`
- Read: `srcs/xx_lsu_top.sv`

**Interfaces:**
- Consumes: `lsu_lrq_create_frz`, `lag_ex1_stall_ori`, `ld_ag_stall_mask`, `mmu_lsu_pa_vld`, `lsu_mmu_abort`, and the `bytes_vld1` selector.
- Produces: a two-state ownership truth table and an exact 27-state `casez` behavior classification.

- [x] **Step 1:** Prove `!(stall && older && (pa_vld || abort))` equals `!(stall && older) || (!pa_vld && !abort)` for all 16 binary combinations.
- [x] **Step 2:** Confirm the accepted-miss row now creates a frozen LRQ entry, while hit/abort rows can become ready when an older RF request replaces AG.
- [x] **Step 3:** Enumerate selector values over `{0,1,X}` and classify 8 binary, 16 default-X, and 3 wildcard-X states; distinguish functional ambiguity from a literal any-X policy.

### Task 3: Re-audit replay metadata and wakeup ownership

**Files:**
- Read: `srcs/xx_lsu_lrq.sv`
- Read: `srcs/xx_lsu_lrq_entry.sv`
- Read: `srcs/xx_lsu_ld_ag.sv`
- Read: `srcs/xx_lsu_ld_dc.sv`
- Read: `srcs/xx_lsu_ld_da.sv`
- Read: `srcs/xx_lsu_ld_wb.sv`

**Interfaces:**
- Consumes: LRQ saved VA/byte masks, replay X-valued fields, AG vector helper inputs, DC/DA/WB consumers, async wakeup bitmap, and flush contracts.
- Produces: a narrowed RR-02/RR-03 proof and contract-based RR-14/RR-16 dispositions.

- [x] **Step 1:** Close replay `inst_ldr` and source-address subcases only after proving replay selects saved VA and the boundary second-pass stall is disabled by `!lag_lrq_replay_vld`.
- [x] **Step 2:** Retain the observable 2-bit `no_spec` path and identify vector `element_cnt`/`rot_sel` as values not present in the LRQ payload.
- [x] **Step 3:** Keep RR-03 open because `halt_info` is still sampled from the current IDU bus; record the design owner's agreement that it must be preserved.
- [x] **Step 4:** Close RR-16 under the immediate-wakeup tie-off and close RR-14 under the flush-cancels-pending-before-reuse contract, while retaining integration assertions for both.
- [x] **Step 5:** Record that lane2/lane3 AG/DC wrapper source is absent, so parity with the lane0 fix needs full-project confirmation.

### Task 4: Refresh the review and verification documents

**Files:**
- Modify: `doc-1.1/xx_lsu_ld_ag_risk_review.md`
- Modify: `doc-1.1/xx_lsu_ld_ag_verification_focus.md`

**Interfaces:**
- Consumes: Tasks 1-3 evidence.
- Produces: an interaction 1.1.2 disposition table, corrected detailed findings, directed tests, assertions, coverage, and open questions.

- [x] **Step 1:** Update the review baseline, executive conclusion, risk table, and add the eight-row interaction 1.1.2 disposition table.
- [x] **Step 2:** Rewrite RR-12 as primary defect fixed/policy scope pending, RR-13 as fixed, RR-14/RR-16 as contract-closed, RR-02 as narrowed but open, and RR-03 as acknowledged but open.
- [x] **Step 3:** Replace obsolete immediate-wakeup tests with a tie-off assertion and async-only wakeup/flush-cancellation tests.
- [x] **Step 4:** Add replay assertions for `no_spec`, `element_cnt`, `rot_sel`, saved VA/byte masks, and `halt_info` transaction identity.

### Task 5: Verify and publish

**Files:**
- Verify: `doc-1.1/xx_lsu_ld_ag_risk_review.md`
- Verify: `doc-1.1/xx_lsu_ld_ag_verification_focus.md`
- Verify: `docs/superpowers/plans/2026-07-16-interaction-1.1.2-followup-review.md`

**Interfaces:**
- Consumes: completed documentation changes.
- Produces: a clean documentation-only commit on the repository default branch with matching local and remote SHA.

- [x] **Step 1:** Validate every `srcs/...:line` citation, Markdown fence/table structure, and trailing whitespace.
- [x] **Step 2:** Re-run the seven-module named-port audit plus RR-12/RR-13 targeted truth-table and source-token checks.
- [x] **Step 3:** Verify `git diff -- srcs README.md` is empty and inspect the complete staged diff.
- [ ] **Step 4:** Commit on the isolated branch, fast-forward local `main`, and push to the verified remote default branch.
- [ ] **Step 5:** Confirm local `main`, `origin/main`, and the GitHub branch API report the same commit SHA.
