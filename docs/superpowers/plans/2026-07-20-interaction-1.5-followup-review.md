# Interaction 1.5 LSU Follow-up Review Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Reassess all eleven Interaction 1.5 clarifications against commit `443384a`, the complete local producer/consumer paths, and a pinned official openC910 reference, then publish one auditable documentation commit.

**Architecture:** Treat the README as the task contract, not as proof. Separate local RTL facts, inherited openC910 patterns, and still-unproven integration assumptions; an epoch tag is not required if lifetime exclusion is source-proven, but inheritance alone cannot prove a modified wrapper or new LRQ path. Keep the repository change documentation-only.

**Tech Stack:** SystemVerilog static data-flow review, exhaustive Boolean checks, Git history/diff, official T-Head openC910 RTL at commit `b91c90914c19f114d35c8f6b73408eb241ed847c`, Markdown.

## Global Constraints

- Base local conclusions on remote `uqjwen/ct` commit `443384a` (`interaction-1.5`).
- Use only the official `T-head-Semi/openc910` repository as the external C910 reference and pin every comparison to commit `b91c90914c19f114d35c8f6b73408eb241ed847c`.
- Do not modify `README.md` or `srcs/`; this task asks for continued risk confirmation, not an RTL patch.
- Do not claim that lack of an explicit epoch is itself a bug; prove or disprove the equivalent lifetime-exclusion invariant at every producer/consumer boundary.
- Distinguish safety (no collision/misrouting) from liveness (bounded grant/fairness) in `xx_lsu_wb_arbiter`.
- Finish with one documentation commit and push it directly to remote `main` after a fast-forward check.

---

### Task 1: Verify the new DA and WB fixes

**Files:**
- Inspect: `srcs/xx_lsu_ld_da.sv`
- Inspect: `srcs/xx_lsu_ld_wb.sv`
- Modify: `doc-da/xx_lsu_ld_da_detailed_risk_review.md`
- Modify: `doc-da/xx_lsu_ld_da_verification_focus.md`
- Modify: `doc-wb/xx_lsu_ld_wb_risk_review.md`
- Modify: `doc-wb/xx_lsu_ld_wb_verification_focus.md`

**Interfaces:**
- Consumes: Interaction 1.5 points 2 and 10 plus DA-RR-01, WB-RR-01, and WB-RR-02.
- Produces: Evidence-backed closure or residual-bug status and corrected severity.

- [x] **Step 1: Confirm scalar block-3 replay identity**

Run: `git diff 013c366..HEAD -- srcs/xx_lsu_ld_da.sv && rg -n "lda_rb_ex3_data_ori3" srcs/xx_lsu_ld_da.sv`

Expected: scalar replay now selects `lda_lwb_ex3_data3`; DA-RR-01 can be source-closed after retaining the four-distinct-block regression.

- [x] **Step 2: Trace the complete halt-info update pulse**

Run: `rg -n "ld_wb_(cmplt|data)_clk_en|ld_dtu2_vld|rb_data_halt_info_update_vld|ld_wb_halt_info_effect" srcs/xx_lsu_ld_wb.sv`

Expected: `ld_dtu2_vld` now opens the source clock to set the update register, but the registered update itself must also be checked for a clocked clear; priority against `ld_wb_halt_info_effect` must be analyzed cycle by cycle.

- [x] **Step 3: Reclassify severity from demonstrated impact**

Record DA-RR-01 as P1 because a reachable ECC replay corrupts architectural load data, independent of whether the root cause is a one-line typo. Assign WB residual severity from pulse persistence/completion duplication impact, not from patch size.

### Task 2: Prove the no-epoch lifetime invariant

**Files:**
- Inspect: `srcs/xx_lsu_ctrl.sv`
- Inspect: `srcs/xx_lsu_lrq.sv`
- Inspect: `srcs/xx_lsu_lrq_entry.sv`
- Inspect: `srcs/xx_lsu_ld_da.sv`
- Inspect: `srcs/xx_lsu_ls_ld_da.sv`
- Inspect: `srcs/mmu/xx_mmu_dutlb_tmq.sv`
- Inspect: `srcs/mmu/xx_mmu_dutlb_tmq_entry.sv`
- Inspect: `srcs/xx_lsu_lfb.sv`
- Inspect: `srcs/xx_lsu_sq.sv`
- Inspect: `srcs/xx_lsu_wmb.sv`
- Modify: `doc-ctrl/xx_lsu_ctrl_integration_risk_review.md`
- Modify: `doc-ctrl/xx_lsu_ctrl_integration_verification_focus.md`
- Modify: `doc-lrq/xx_lsu_lrq_risk_review.md`
- Modify: `doc-lrq/xx_lsu_lrq_verification_focus.md`
- Modify: `doc-da/xx_lsu_ld_da_detailed_risk_review.md`
- Modify: `doc-da/xx_lsu_ld_da_verification_focus.md`

**Interfaces:**
- Consumes: Interaction 1.5 points 1, 3, and 6.
- Produces: A producer-by-producer lifetime proof, exact remaining assumptions, and epoch-free assertions.

- [x] **Step 1: Trace release, flush, and reuse ordering**

Run: `rg -n "rtu_.*flush|create_vld|pop_vld|wakeup|already_da|spec_fail|secd" srcs/xx_lsu_lrq*.sv srcs/xx_lsu_ctrl.sv`

Expected: identify whether flush/release has priority over create, whether a freed bit can be reallocated in the same cycle, and which signals may still target it.

- [x] **Step 2: Trace every delayed producer through flush**

Run: `rg -n "rtu_ck_flush|rtu_yy_xx_flush|wakeup_queue|wakeup.*lsid|lsid" srcs/mmu/xx_mmu_dutlb_tmq*.sv srcs/xx_lsu_lfb.sv srcs/xx_lsu_sq.sv srcs/xx_lsu_wmb.sv srcs/xx_lsu_ld_da.sv srcs/xx_lsu_ls_ld_da.sv`

Expected: each producer either drops old state before reuse or emits it only on the flush cycle when LRQ cannot accept a new epoch. Any path not satisfying that invariant remains open even if inherited from C910.

- [x] **Step 3: Replace epoch terminology with implementable invariants**

Document assertions such as `wakeup[bit] -> lrq_entry_vld[bit] && saved_iid_matches_producer_iid`, `flush_kill -> no producer bit after reuse`, and `create_accept(bit) -> no pending old-owner producer state`; use a verification scoreboard epoch only as an observer, not as a required RTL field.

### Task 3: Reclassify DC and LRQ retained payloads

**Files:**
- Inspect: `srcs/xx_lsu_dcache_arb.sv`
- Inspect: `srcs/xx_lsu_ld_dc.sv`
- Inspect: `srcs/xx_lsu_lrq_entry.sv`
- Modify: `doc-dc/xx_lsu_ld_dc_risk_review.md`
- Modify: `doc-dc/xx_lsu_ld_dc_verification_focus.md`
- Modify: `doc-lrq/xx_lsu_lrq_risk_review.md`
- Modify: `doc-lrq/xx_lsu_lrq_verification_focus.md`

**Interfaces:**
- Consumes: Interaction 1.5 points 4, 5, and 7.
- Produces: Correct implication direction for borrow valid/gate and dead-field qualification status for retained masks.

- [x] **Step 1: Formalize borrow implication direction**

Treat SNQ as `req == gate` and VB as `req -> gate`, not equality. Verify that gate-only opens payload clocks without asserting borrow valid, then retain payload identity and `valid -> gate` assertions while removing an unjustified reverse-equality requirement.

- [x] **Step 2: Trace all consumers of retained US-only fields**

Run: `rg -n "bytes_vld[123]|reg_bytes_vld[123]|inst_us|unit_stride" srcs/xx_lsu_ld_dc.sv srcs/xx_lsu_lrq_entry.sv srcs/xx_lsu_ld_da.sv`

Expected: stale upper mask fields are dead for scalar/non-US flows only if every consumer qualifies them by saved US/unit-stride state; otherwise retain the correctness risk.

- [x] **Step 3: Preserve power intent without weakening safety checks**

Reclassify dead retained fields as a documented power optimization and require `!US -> upper fields never consumed` assertions, rather than requiring zero values that would defeat the stated clock-gating intent.

### Task 4: Compare RB ownership with official openC910

**Files:**
- Inspect local: `srcs/xx_lsu_rb.sv`
- Inspect local: `srcs/xx_lsu_rb_entry.sv`
- Inspect local: `srcs/xx_lsu_lfb.sv`
- Inspect local: `srcs/xx_lsu_wmb_entry.sv`
- Inspect reference: `/private/tmp/openc910-interaction15/C910_RTL_FACTORY/gen_rtl/lsu/rtl/ct_lsu_rb.v`
- Inspect reference: `/private/tmp/openc910-interaction15/C910_RTL_FACTORY/gen_rtl/lsu/rtl/ct_lsu_rb_entry.v`
- Inspect reference: `/private/tmp/openc910-interaction15/C910_RTL_FACTORY/gen_rtl/lsu/rtl/ct_lsu_lfb.v`
- Inspect reference: `/private/tmp/openc910-interaction15/C910_RTL_FACTORY/gen_rtl/lsu/rtl/ct_lsu_wmb_entry.v`
- Inspect reference: `/private/tmp/openc910-interaction15/C910_RTL_FACTORY/gen_rtl/rtu/rtl/ct_rtu_top.v`
- Inspect reference: `/private/tmp/openc910-interaction15/C910_RTL_FACTORY/gen_rtl/biu/rtl/ct_biu_read_channel.v`
- Inspect reference: `/private/tmp/openc910-interaction15/C910_RTL_FACTORY/gen_rtl/biu/rtl/ct_biu_write_channel.v`
- Modify: `doc-rb/xx_lsu_rb_risk_review.md`
- Modify: `doc-rb/xx_lsu_rb_verification_focus.md`

**Interfaces:**
- Consumes: Interaction 1.5 points 8 and 9.
- Produces: A pinned inheritance comparison and an explicit list of modified-system assumptions that inheritance cannot prove.

- [x] **Step 1: Compare local and upstream RB state/response equations**

Run: `git diff --no-index -- /private/tmp/openc910-interaction15/C910_RTL_FACTORY/gen_rtl/lsu/rtl/ct_lsu_rb_entry.v srcs/xx_lsu_rb_entry.sv`

Expected: record semantic matches around async flush, request-issued state, fixed R/B IDs, and response qualification; ignore only mechanical module/prefix/width renames after checking them.

- [x] **Step 2: Trace upstream system guarantees**

Use official RTU/BIU/LFB/WMB sources to find the actual async-flush and fixed-ID ownership conditions. Pin report links to the official commit and do not cite a fork or unversioned branch.

- [x] **Step 3: Separate inherited evidence from local proof**

Close only equations that are semantically preserved locally. Keep any guarantee depending on modified ID width, new LSU wrappers, different outstanding depth, or unavailable top-level protocol as a boundary assertion.

### Task 5: Exhaustively audit `xx_lsu_wb_arbiter`

**Files:**
- Inspect: `srcs/xx_lsu_wb_arbiter.sv`
- Inspect: `srcs/xx_lsu_top.sv`
- Inspect: `srcs/xx_lsu_ld_wb.sv`
- Inspect: `srcs/xx_lsu_ls_wb.sv`
- Modify: `doc-wb/xx_lsu_ld_wb_risk_review.md`
- Modify: `doc-wb/xx_lsu_ld_wb_verification_focus.md`

**Interfaces:**
- Consumes: Interaction 1.5 point 11 and WB-RR-04.
- Produces: Exhaustive safety matrix and bounded-progress status.

- [x] **Step 1: Check all Boolean combinations against a reference allocator**

Enumerate all dedicated-lane and WMB/VMB/RB request combinations. Verify: no shared source selects two lanes, no lane receives two shared sources, no shared request uses a lane occupied by its dedicated DA request, and every selected source receives exactly one grant.

- [x] **Step 2: Check top-level request/grant identity**

Run: `rg -n "xx_lsu_wb_arbiter|arb_.*(req|grnt)" srcs/xx_lsu_top.sv srcs/xx_lsu_wb_arbiter.sv`

Expected: all arbiter outputs reach the intended WB lane and producer; completion and data paths do not cross source identities.

- [x] **Step 3: Distinguish combinational packing from fairness**

Construct sustained-contention traces. A stateless fixed-priority allocator can prove work conservation and collision freedom but cannot by itself prove a bounded grant for VMB/RB under continuous higher-priority traffic; retain or close WB-RR-04 accordingly.

### Task 6: Publish the Interaction 1.5 response

**Files:**
- Create: `docs/interaction-1.5-followup-review.md`
- Modify: all risk and verification files listed in Tasks 1-5.

**Interfaces:**
- Consumes: Tasks 1-5 evidence.
- Produces: One authoritative eleven-point matrix, synchronized module reports, severity rationale, C910 provenance, and precise remaining information requests.

- [x] **Step 1: Write the eleven-point disposition matrix**

For every README point state `closed`, `narrowed`, `contract-dependent`, or `still open`, with local source anchors and C910 links where relevant.

- [x] **Step 2: Synchronize module reports and verification plans**

Remove stale Interaction 1.4 claims, preserve historical summaries as history, and ensure every changed risk has a matching assertion or directed test.

- [x] **Step 3: State the verification boundary**

Record that the repository has no executable RTL testbench/filelist and the environment lacks Verilator/Icarus/Slang/svlint; Boolean exhaustiveness and static source checks are evidence, not dynamic sign-off.

### Task 7: Validate and publish one commit

**Files:**
- Verify: all changed Markdown files.

**Interfaces:**
- Consumes: completed documentation artifacts.
- Produces: one clean commit whose SHA matches remote `main`.

- [x] **Step 1: Run documentation checks**

Run: `git diff --check && ! rg -n "T[B]D|TO[D]O|implement lat[e]r|fill in detail[s]" docs/interaction-1.5-followup-review.md doc-ctrl doc-da doc-dc doc-lrq doc-rb doc-wb`

Expected: zero whitespace errors and no placeholders in current deliverables.

- [x] **Step 2: Verify scope and links**

Run: `git diff --name-only -- README.md srcs && git status --short`

Expected: the first command is empty and status lists Markdown documentation only; all relative and pinned C910 links resolve.

- [x] **Step 3: Commit once**

Run: `git add docs doc-ctrl doc-da doc-dc doc-lrq doc-rb doc-wb && git commit -m "docs: review interaction 1.5 LSU risks"`

Expected: one documentation commit.

- [x] **Step 4: Push and verify remote identity**

Run: `git fetch origin main && test "$(git rev-parse HEAD^)" = "$(git rev-parse origin/main)" && git push origin HEAD:main && git fetch origin main && test "$(git rev-parse HEAD)" = "$(git rev-parse origin/main)"`

Expected: fast-forward push succeeds and local/remote SHAs are identical.
