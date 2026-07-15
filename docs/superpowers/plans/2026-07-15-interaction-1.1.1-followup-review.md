# Interaction 1.1.1 Follow-up Review Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Verify all 16 interaction 1.1.1 clarifications against the supplied RTL, correct the prior risk dispositions, and continue searching for request-loss, duplicate-ownership, stale-wakeup, and X-propagation bugs.

**Architecture:** Keep RTL and README unchanged. Trace every disputed statement through the exact producer, top-level wiring, consumer, and sequential priority; treat README statements as interface contracts only when they do not contradict the supplied signal equations. Update the existing risk and verification documents with closed risks, retained findings, technical pushback, and directed checks.

**Tech Stack:** SystemVerilog RTL, Git history, read-only static analysis, Markdown.

## Global Constraints

- Do not modify `srcs/` or `README.md`.
- Evaluate all 16 README items; do not silently accept a clarification that conflicts with the RTL.
- Every retained or new risk must include exact source locations, trigger, failure mechanism, impact, and verification recommendation.
- Separate current functional risks from configuration constraints, power-only issues, and contract-dependent risks.
- Verify cited source lines, Markdown structure, staged scope, and remote SHA before completion.

---

### Task 1: Establish the interaction 1.1.1 baseline

**Files:**
- Read: `README.md`
- Read: `doc-1.1/xx_lsu_ld_ag_risk_review.md`
- Read: `doc-1.1/xx_lsu_ld_ag_verification_focus.md`

**Interfaces:**
- Consumes: the 16 new clarifications and the previous RR-01 through RR-15 dispositions.
- Produces: a clarification-to-risk mapping with each item marked closed, narrowed, retained, or contradicted by RTL.

- [x] **Step 1:** Map README items 1-16 to RR-01/RR-02/RR-08/RR-10/RR-11/RR-12/RR-13/RR-14/RR-15 and section 4.2/5.x questions.
- [x] **Step 2:** Record the exact contract statements for MMU accept, non-retroactive abort, D-cache side effects, flush priority, supported parameter values, and intentionally relaxed clock gating.
- [x] **Step 3:** Identify ambiguous or technically mismatched answers that require direct RTL tracing.

### Task 2: Resolve the RR-13 MMU-lsid ownership dispute

**Files:**
- Read: `srcs/xx_lsu_ld_ag.sv`
- Read: `srcs/xx_lsu_top.sv`
- Read: `srcs/xx_lsu_ctrl.sv`
- Read: `srcs/xx_lsu_lrq.sv`
- Read: `srcs/xx_lsu_lrq_entry.sv`

**Interfaces:**
- Consumes: `lsu_mmu_va_vld`, `lsu_mmu_abort`, `lag_ldc_ex1_lsid`, `lag_ex1_stall_restart_entry`, `lsu_lrq_create_frz`, and LRQ issue arbitration.
- Produces: a cycle-accurate ownership proof showing whether MMU records the fresh LRQ ID and whether the entry can replay before wakeup.

- [x] **Step 1:** Trace the fresh free pointer through `lag_ldc_ex1_lsid` and top-level `lsu_mmu_lsid0` independently of controller restart bitmap.
- [x] **Step 2:** Apply the clarified MMU accept equation `lsu_mmu_va_vld && !lsu_mmu_abort` to the RR-13 trigger cycle.
- [x] **Step 3:** Derive create/freeze/restart/ready/issue values for T0-T2 and mechanically check the Boolean counterexample.
- [x] **Step 4:** Search lane2/lane3 and all supplied replay/restart paths for the same ownership split; document source-availability limits.

### Task 3: Resolve X propagation and wakeup/flush contracts

**Files:**
- Read: `srcs/xx_lsu_ld_ag.sv`
- Read: `srcs/xx_lsu_lrq.sv`
- Read: `srcs/xx_lsu_lrq_entry.sv`
- Read: `srcs/xx_lsu_ctrl.sv`
- Read: `srcs/xx_lsu_top.sv`

**Interfaces:**
- Consumes: `casez` behavior, replay X-valued fields, MMU async wakeup bitmap, LRQ create/clear priority, and flush/reuse behavior.
- Produces: corrected RR-02/RR-12/RR-14 dispositions and any newly evidenced design risk.

- [x] **Step 1:** Verify whether a no-default `casez` propagates X or retains a previous value when no item matches.
- [x] **Step 2:** Reconfirm which replay X fields remain observable downstream despite the D-cache no-side-effect contract.
- [x] **Step 3:** Close the same-cycle wakeup subcase using the one-cycle contract, then separately trace stale wakeup after flush and LRQ-bit reuse.
- [x] **Step 4:** Inspect controller, LRQ, and top-level wakeup/flush wiring for generation, pending-valid, or cancellation protection.

### Task 4: Update review and verification documents

**Files:**
- Modify: `doc-1.1/xx_lsu_ld_ag_risk_review.md`
- Modify: `doc-1.1/xx_lsu_ld_ag_verification_focus.md`

**Interfaces:**
- Consumes: Tasks 1-3 evidence.
- Produces: internally consistent risk dispositions, directed tests, assertions, coverage, and open questions.

- [x] **Step 1:** Add an interaction 1.1.1 disposition table covering all 16 README answers.
- [x] **Step 2:** Close RR-08/RR-11 and configuration-only concerns where the clarified contracts are sufficient.
- [x] **Step 3:** Retain or revise RR-02/RR-12/RR-13/RR-14 only to the extent supported by current equations.
- [x] **Step 4:** Reclassify RR-15 as current power/clock-gating quality rather than a functional bug when `pfu_part_empty` is permanently tie 0.
- [x] **Step 5:** Update directed tests and assertions to distinguish legal contracts from deliberately invalid negative checks.

### Task 5: Verify and publish

**Files:**
- Verify: `doc-1.1/xx_lsu_ld_ag_risk_review.md`
- Verify: `doc-1.1/xx_lsu_ld_ag_verification_focus.md`
- Verify: `docs/superpowers/plans/2026-07-15-interaction-1.1.1-followup-review.md`

**Interfaces:**
- Consumes: completed documentation changes.
- Produces: a clean commit on the repository default branch with matching local and remote SHA.

- [x] **Step 1:** Validate every `srcs/...:line` reference, Markdown fence/table structure, and trailing whitespace.
- [x] **Step 2:** Re-run the seven-module named-port audit and targeted Boolean/source-token checks.
- [x] **Step 3:** Verify `git diff -- srcs README.md` is empty and inspect the full staged diff.
- [ ] **Step 4:** Commit on the isolated branch, fast-forward local `main`, and push to the verified remote default branch.
- [ ] **Step 5:** Confirm local `main`, `origin/main`, and the GitHub branch API report the same commit SHA.
