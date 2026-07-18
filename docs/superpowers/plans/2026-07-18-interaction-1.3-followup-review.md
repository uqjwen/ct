# Interaction 1.3 Follow-up LSU Review Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Review all 17 Interaction 1.3 README clarifications against the available LSU RTL, update each module's risk and verification documents, and publish the evidence-backed result to the repository default branch.

**Architecture:** Treat the README clarifications as proposed environment contracts, then validate every locally provable claim against the producer, allocator, per-entry payload mux, valid-bit lifecycle, and consumer logic. Reclassify findings as source-closed, contract-closed, narrowed, or still open; keep missing-module assumptions explicit.

**Tech Stack:** SystemVerilog static source audit, Markdown, Git.

## Global Constraints

- Review only the RTL and documentation present in this repository; do not infer missing BIU, WMB, dcache arbiter, bus arbiter, IDU/SQ, MMU, or RTU behavior as source-proven.
- Do not modify RTL or README unless a new source defect requires an explicitly justified fix; this task is primarily a follow-up review.
- For every create-path audit, distinguish raw request, dp-valid, gateclock enable, actual create-valid, allocator pointer, entry-valid update, and payload selection.
- Record exact source-line evidence and convert missing environmental guarantees into named assertions or directed tests.
- Validate all edited Markdown files for forbidden placeholders and stale Interaction 1.2 wording before commit.

---

### Task 1: Re-audit RB clarifications 1-4 and the payload-source hazard

**Files:**
- Inspect: `srcs/xx_lsu_rb.sv`
- Inspect: `srcs/xx_lsu_rb_entry.sv`
- Modify: `doc-rb/xx_lsu_rb_risk_review.md`
- Modify: `doc-rb/xx_lsu_rb_verification_focus.md`

- [x] Trace lane0/lane2/lane3 raw create, dp-valid, gateclock, full, pointer, per-entry create vector, entry-valid set, and payload mux equations.
- [x] Construct the adversarial case in which multiple per-entry dp-valid sources are asserted, the higher-priority source does not actually create, and a lower-priority source does; prove whether payload can be stolen.
- [x] Reclassify RB-RR-01 with exact source evidence and add a directed payload-identity test or assertion.
- [x] Record README response-ownership, two-beat US response, B-response ID, and error-mapping assumptions as source-closed or contract-closed without overstating missing-module proof.
- [x] Update RB verification coverage for ID reuse, US two-beat completion, replay/truncation exclusion, and unrelated shared-ID B responses.

### Task 2: Re-audit WB clarifications 5-6

**Files:**
- Inspect: `srcs/xx_lsu_ld_wb.sv`
- Inspect: `srcs/xx_lsu_ld_da.sv`
- Modify: `doc-wb/xx_lsu_ld_wb_risk_review.md`
- Modify: `doc-wb/xx_lsu_ld_wb_verification_focus.md`

- [x] Prove the direction of the DA data request/dp/gate implications and enumerate all dp-only states.
- [x] Determine whether dp-only arbitration creates only a bounded bubble or can starve/block another WB producer under the available RTL.
- [x] Reclassify WB-RR-03 and WB-RR-04, keeping issue-queue/backpressure/bus-arb assumptions explicit where their producers are absent.
- [x] Add assertions for request-to-dp implication, payload stability until grant, and bounded progress under the stated arbiter contract.

### Task 3: Re-audit DC clarifications 7-8 and CTRL clarifications 14-16

**Files:**
- Inspect: `srcs/xx_lsu_ld_dc.sv`
- Inspect: `srcs/xx_lsu_ctrl.sv`
- Inspect: `srcs/xx_lsu_lrq.sv`
- Inspect: `srcs/xx_lsu_lrq_entry.sv`
- Modify: `doc-dc/xx_lsu_ld_dc_risk_review.md`
- Modify: `doc-dc/xx_lsu_ld_dc_verification_focus.md`
- Modify: `doc-ctrl/xx_lsu_ctrl_integration_risk_review.md`
- Modify: `doc-ctrl/xx_lsu_ctrl_integration_verification_focus.md`

- [x] Verify every locally visible borrow-valid/gate consumer and identify which equality claim depends on the missing dcache arbiter.
- [x] Verify tag-hit handling and record the coherence one-hot guarantee as a contract with a local one-hot assertion.
- [x] Confirm the Interaction 1.3 VMB create1 gateclock source fix and check whether ICC/LSDA or other special-path enables remain omitted or functionally masked.
- [x] Verify all visible LSIQENTRY/LRQENTRY indexing assumptions and audit LRQ completion/wakeup IID mapping for implementation violations.
- [x] Update DC and CTRL findings with source-closed versus contract-closed status and directed checks.

### Task 4: Re-audit LQ clarifications 9-11

**Files:**
- Inspect: `srcs/xx_lsu_lq.sv`
- Inspect: `srcs/xx_lsu_lq_entry.sv`
- Inspect: `srcs/xx_lsu_ld_da.sv`
- Modify: `doc-lq/xx_lsu_lq_risk_review.md`
- Modify: `doc-lq/xx_lsu_lq_verification_focus.md`

- [x] Confirm that lowest-physical-index PC selection is a performance tradeoff rather than a correctness failure under the stated semantics.
- [x] Trace all lane create pointers, full indications, per-entry dp-valids, entry-valid updates, and payload muxes for the same payload-source hazard tested in RB.
- [x] Trace restart-pop generation through DC, DA, flush, and LQ entry release; determine whether an old transaction can pop a reallocated entry.
- [x] Reclassify LQ-RR-01 through LQ-RR-03 and add lane-identity, flush/restart, and epoch-style stress tests.

### Task 5: Re-audit LRQ clarifications 12-13 and the CTRL completion contract

**Files:**
- Inspect: `srcs/xx_lsu_lrq.sv`
- Inspect: `srcs/xx_lsu_lrq_entry.sv`
- Inspect: `srcs/xx_lsu_ctrl.sv`
- Modify: `doc-lrq/xx_lsu_lrq_risk_review.md`
- Modify: `doc-lrq/xx_lsu_lrq_verification_focus.md`

- [x] Trace no-space reservation, create-valid, create-success, flush, pop/release, and MMU wakeup priority for every LRQ entry.
- [x] Test the same-cycle combinations of flush, create, old MMU wakeup, completion, and entry reuse for stale-wakeup corruption.
- [x] Check whether an LRQ entry can release before completion or whether a completion wake bit can map to a different IID in the available implementation.
- [x] Reclassify LRQ-RR-02/LRQ-RR-03 and add assertions for valid-qualified wakeups, IID stability, and no pre-completion reuse.

### Task 6: Make the existing LD-DA analysis explicit and refresh it for Interaction 1.3

**Files:**
- Inspect: `srcs/xx_lsu_ld_da.sv`
- Inspect: `doc_da/xx_lsu_ld_da_risk_review.md`
- Inspect: `doc_da/xx_lsu_ld_da_verification_focus.md`
- Modify: `doc_da/xx_lsu_ld_da_risk_review.md`
- Modify: `doc_da/xx_lsu_ld_da_verification_focus.md`

- [x] Explain that LD-DA already has a dedicated analysis and enumerate its current findings.
- [x] Recheck DA's create/accept, ECC replay, SQ forwarding ECC, debug-halt side effects, WB dp-only behavior, and LQ pop generation against Interaction 1.3.
- [x] Add a clearly labeled Interaction 1.3 response section and cross-links to affected RB/WB/LQ findings.
- [x] Update DA verification cases for all newly clarified cross-module contracts.

### Task 7: Cross-check, validate, commit, and publish

**Files:**
- Create: `docs/interaction-1.3-followup-review.md`
- Modify: `docs/superpowers/plans/2026-07-18-interaction-1.3-followup-review.md`
- Validate: all modified `doc-*/**/*.md` and `doc_da/*.md`

- [x] Create a compact 17-point disposition matrix, list remaining confirmed defects, and identify the exact missing modules/information needed for source-level closure.
- [x] Cross-check that all 17 README points have an explicit disposition and that no contract-only conclusion is labeled source-proven.
- [x] Run repository-wide Markdown placeholder and stale-status checks, inspect the final diff, and confirm no unintended RTL/README changes.
- [x] Mark completed plan checkboxes and commit the review on `review/interaction-1.3-v1`.
- [x] Push the commit directly to the remote default branch `main`, then verify the remote branch SHA equals the local commit.
