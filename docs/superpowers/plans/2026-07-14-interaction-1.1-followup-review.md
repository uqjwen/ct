# Interaction 1.1 Follow-up Review Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Verify the six new interface clarifications, inspect the newly supplied LSU controller, and identify any remaining request-loss, duplicate-replay, or permanent-freeze bugs in the load AG/LRQ/MMU replay path.

**Architecture:** Keep RTL unchanged. Trace each load transaction across AG stall classification, MMU accept/abort, controller restart, LRQ create/freeze/clear, replay arbitration, and flush, using exact Boolean equations and cycle-by-cycle scenarios. Update the existing risk and verification documents so confirmed defects, closed risks, contract assumptions, and still-open questions are clearly separated.

**Tech Stack:** SystemVerilog RTL, Git history, read-only static analysis, Markdown.

## Global Constraints

- Treat the README clarifications as design contracts only after verifying that the supplied RTL implements them consistently.
- Do not modify files under `srcs/` or `README.md`.
- Every new or retained risk must cite exact source lines and include trigger, failure mechanism, impact, and verification recommendation.
- Do not call a contract-dependent case a confirmed defect.
- Verify all source references and Markdown structure before committing.

---

### Task 1: Verify the new clarification baseline

**Files:**
- Read: `README.md`
- Read: `srcs/xx_lsu_ld_ag.sv`
- Read: `srcs/xx_lsu_lrq.sv`
- Read: `srcs/xx_lsu_ctrl.sv`
- Read: `srcs/xx_lsu_top.sv`

- [x] **Step 1: Verify each RR05/RR06/RR07/RR08/RR09/RR12 clarification against actual signal equations and top-level wiring.**

- [x] **Step 2: Record which prior risks are closed, narrowed, or still require an explicit interface assertion.**

- [x] **Step 3: Confirm the newly added controller is the producer of the LRQ freeze-clear/restart path described by README.**

### Task 2: Trace request ownership and recovery end to end

**Files:**
- Read: `srcs/xx_lsu_ld_ag.sv`
- Read: `srcs/xx_lsu_ctrl.sv`
- Read: `srcs/xx_lsu_lrq.sv`
- Read: `srcs/xx_lsu_lrq_entry.sv`
- Read: `srcs/xx_lsu_ld_dc.sv`

- [x] **Step 1: Derive the exact conditions for `lag_stall_ori_tlbmiss_not_abort`, `lag_ex1_stall_restart_entry`, controller restart acceptance, and LRQ freeze clear.**

- [x] **Step 2: Enumerate cycle-level cases for MMU hit, accepted miss, aborted miss, D-cache backpressure, older RF replacement, LRQ replay, and full/partial flush.**

- [x] **Step 3: For every case, check the ownership invariant: exactly one of MMU pending, controller pending, AG local hold, or ready LRQ entry owns an unflushed request.**

- [x] **Step 4: Search all alternative replay/restart equations for the same anti-pattern: recovery derived from a result signal that can be suppressed by abort, flush, or unrelated qualification.**

### Task 3: Update the design-risk review

**Files:**
- Modify: `doc-1.1/xx_lsu_ld_ag_risk_review.md`

- [x] **Step 1: Add a follow-up disposition table for the six README clarifications.**

- [x] **Step 2: Correct or retire earlier risks when the new RTL and contract evidence close them.**

- [x] **Step 3: Add only newly confirmed or evidence-backed risks from the controller-assisted recovery trace.**

- [x] **Step 4: Update the summary, priority order, and design-question list so they match the revised evidence.**

### Task 4: Update focused verification guidance

**Files:**
- Modify: `doc-1.1/xx_lsu_ld_ag_verification_focus.md`

- [x] **Step 1: Replace invalid MMU timing scenarios with the confirmed one-cycle response contract and `mmu_lsu_stall==0` assumption.**

- [x] **Step 2: Add directed controller-restart cases covering abort, older RF replacement, LRQ freeze-clear, replay, and flush.**

- [x] **Step 3: Add an ownership scoreboard and assertions that detect request loss, duplicate ownership, duplicate replay, and permanent freeze.**

- [x] **Step 4: Keep open questions only where the supplied RTL still does not determine behavior.**

### Task 5: Verify and publish

**Files:**
- Verify: `doc-1.1/xx_lsu_ld_ag_risk_review.md`
- Verify: `doc-1.1/xx_lsu_ld_ag_verification_focus.md`
- Verify: `docs/superpowers/plans/2026-07-14-interaction-1.1-followup-review.md`

- [x] **Step 1: Validate every `srcs/...:line` reference against the current files and check Markdown fences, tables, and trailing whitespace.**

- [x] **Step 2: Verify `git diff -- srcs README.md` is empty and inspect the complete staged diff.**

- [ ] **Step 3: Commit the reviewed documentation on the isolated branch, fast-forward it into the authorized default branch, and push.**

- [ ] **Step 4: Confirm local `main`, `origin/main`, and the GitHub branch API report the same commit SHA.**
