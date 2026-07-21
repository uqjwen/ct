# Interaction 1.6 Follow-up Review Implementation Plan

> **For Codex:** Execute this plan task by task with the `executing-plans` workflow. Keep RTL changes limited to the assertions explicitly requested by Interaction 1.6; record newly found AG functional risks rather than silently changing datapath behavior.

**Goal:** Implement the requested LRQ/DC assertions, reclassify the clarified RB/WB risks, and complete a source-backed review of the revised `xx_lsu_ld_ag` stall/MMU/unit-stride behavior.

**Architecture:** Add synthesis-excluded SystemVerilog assertions at the narrowest observable module boundaries. LRQ can prove entry-valid and same-cycle old-event exclusion, but its producer interfaces do not expose an owner IID, so the report must preserve that exact proof gap. DC can assert `$onehot0(ldc_hit_way)` directly. All other work is static review and documentation; no functional AG edit is authorized by the README review request.

**Tech Stack:** SystemVerilog RTL/SVA, Python 3 standard-library regression checks, Markdown review artifacts, Git.

---

### Task 1: Add a failing source-contract regression for the requested assertions

**Files:**
- Create: `tests/test_interaction_1_6_assertions.py`
- Inspect: `srcs/xx_lsu_lrq.sv`
- Inspect: `srcs/xx_lsu_ld_dc.sv`

1. Add tests that require synthesis-excluded LRQ wakeup/live-entry assertions for lanes 0/2/3, LRQ create/no-visible-old-event assertions for lanes 0/2/3, and a qualified DC `$onehot0(ldc_hit_way)` assertion.
2. Run `python3 -m unittest tests/test_interaction_1_6_assertions.py` and confirm it fails because the assertions are absent.

### Task 2: Implement the minimum LRQ and DC assertions

**Files:**
- Modify: `srcs/xx_lsu_lrq.sv`
- Modify: `srcs/xx_lsu_ld_dc.sv`

1. Add LRQ assertions under `` `ifndef SYNTHESIS``. Comment that the producer ports carry only entry bitmaps; therefore these assertions enforce the locally observable part of CTRL-RR-03, while exact owner-IID equality requires verification-only producer owner metadata.
2. Add the DC cacheable-live-access `$onehot0(ldc_hit_way)` assertion under `` `ifndef SYNTHESIS`` and explain that zero hits are legal while multiple hits indicate duplicate tags/coherence corruption.
3. Re-run the source-contract test and require it to pass.

### Task 3: Audit Interaction 1.6 clarifications and the new AG design

**Files:**
- Inspect: `srcs/xx_lsu_ld_ag.sv`
- Inspect: `srcs/mmu/xx_mmu_dutlb_read.v`
- Inspect: `srcs/xx_lsu_ld_wb.sv`
- Inspect: `srcs/xx_lsu_wb_arbiter.sv`
- Inspect: `srcs/xx_lsu_rb.sv`
- Inspect: `srcs/xx_lsu_rb_entry.sv`
- Compare: official openC910 snapshot at commit `b91c90914c19f114d35c8f6b73408eb241ed847c`

1. Trace TLB miss, page fault, one-cycle delayed access fault, MMU abort, EX1 invalidation, and exception propagation cycle by cycle.
2. Trace unit-stride tag request, way capture, data request, and fault interaction.
3. Re-evaluate RB-RR-02 under the newly explicit debug-recovery contract.
4. Determine whether RB-RR-04 and WB-RR-04 are actually inherited unchanged from C910 and whether inheritance is sufficient for waiver.
5. Verify the new WB data-clock enable closes the sticky halt-info update identified in Interaction 1.5.

### Task 4: Update module reports and create the Interaction 1.6 disposition

**Files:**
- Create: `docs/interaction-1.6-followup-review.md`
- Modify: `doc-ctrl/xx_lsu_ctrl_integration_risk_review.md`
- Modify: `doc-ctrl/xx_lsu_ctrl_integration_verification_focus.md`
- Modify: `doc-lrq/xx_lsu_lrq_risk_review.md`
- Modify: `doc-lrq/xx_lsu_lrq_verification_focus.md`
- Modify: `doc-dc/xx_lsu_ld_dc_risk_review.md`
- Modify: `doc-dc/xx_lsu_ld_dc_verification_focus.md`
- Modify: `doc-rb/xx_lsu_rb_risk_review.md`
- Modify: `doc-rb/xx_lsu_rb_verification_focus.md`
- Modify: `doc-wb/xx_lsu_ld_wb_risk_review.md`
- Modify: `doc-wb/xx_lsu_ld_wb_verification_focus.md`
- Modify: `doc-1.1/xx_lsu_ld_ag_risk_review.md`
- Modify: `doc-1.1/xx_lsu_ld_ag_verification_focus.md`

1. Record each README item as closed, waived under an explicit contract, narrowed, or open.
2. Include exact source anchors and the static-review limitation.
3. Add targeted verification scenarios for LRQ owner lifetime, DC duplicate hits, AG fault/stall overlap, US two-stage tag handling, WB halt-info quiescent clearing, and RB debug recovery.

### Task 5: Verify, review, commit, and publish

**Files:** all changed files.

1. Run `python3 -m unittest tests/test_interaction_1_6_assertions.py`.
2. Run whitespace checks, assertion/source anchor checks, and `git diff --check`.
3. Review the complete diff and confirm no unintended functional RTL edits.
4. Commit all Interaction 1.6 work as one commit.
5. Rebase/update against current `origin/main` if needed, fast-forward/push the commit to `main`, and verify the remote branch contains it.
