# Interaction 1.1.3 and 1.2 Full LSU Review Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Resolve the interaction 1.1.3 RR-02 clarification and perform source-grounded design-risk and verification reviews for every supplied LSU module not already covered by the load-AG review.

**Architecture:** Keep the supplied RTL and README unchanged. Treat each functional block as its own audit unit, but use `xx_lsu_top.sv` and producer/consumer modules as the cross-module truth set; write one risk report and one verification-focus document per unit. Accept behavior outside the repository only as an explicit contract, and distinguish confirmed defects, high-confidence risks, contract-dependent risks, configuration constraints, and cleanup items.

**Tech Stack:** SystemVerilog RTL, Git history, structural parsing, Boolean/priority analysis, Markdown review artifacts.

## Global Constraints

- Baseline commit is `9928a13dffcaf5c87478baae6ac516a6a192e210` (`interaction-1.1.3/1.2`).
- Do not modify `srcs/` or `README.md`; this task produces review and verification artifacts only.
- Cover all supplied non-baseline modules: LRQ/LRQ entry, LQ/LQ entry, RB/RB entry, load DC, load DA, load WB, controller, and top-level integration.
- Every retained finding must include exact source lines, trigger, failure mechanism, impact, confidence, and a correction or verification recommendation.
- Every closed clarification must identify the RTL equation or external contract that closes it; unavailable helper/SFP behavior remains an explicit source-availability boundary.
- Use the README directory spelling exactly for `doc-lrq`, `doc-rb`, `doc-dc`, and `doc_da`; create matching `doc-lq`, `doc-wb`, and `doc-ctrl` directories for the remaining supplied modules.
- Validate source citations, Markdown structure, module/instance named-port sets, staged scope, and final remote SHA before completion.

---

### Task 1: Resolve interaction 1.1.3 and establish the full audit map

**Files:**
- Read: `README.md`
- Modify: `doc-1.1/xx_lsu_ld_ag_risk_review.md`
- Modify: `doc-1.1/xx_lsu_ld_ag_verification_focus.md`
- Read: `srcs/xx_lsu_lrq.sv`
- Read: `srcs/xx_lsu_ld_ag.sv`
- Read: `srcs/xx_lsu_ld_dc.sv`
- Read: `srcs/xx_lsu_ld_da.sv`
- Read: `srcs/xx_lsu_ld_wb.sv`

**Interfaces:**
- Consumes: README item 1.1.3, replay `no_spec`, saved split/vmew/vsew metadata, and the missing SFP/vector-helper contracts.
- Produces: a corrected RR-02 disposition plus an inventory mapping every supplied module to one review directory.

- [x] **Step 1:** Trace replay `no_spec` from LRQ through AG/DC/DA/WB and identify every output still driven by it.
- [x] **Step 2:** Trace `element_cnt` and `rot_sel` from saved LRQ metadata through the unavailable helper boundaries and record exactly what current source can and cannot prove.
- [x] **Step 3:** Add an interaction 1.1.3 disposition section to both AG documents, closing only subpaths justified by RTL or an explicit external SFP/helper contract.
- [x] **Step 4:** Record the review inventory for LRQ, LQ, RB, DC, DA, WB, CTRL, and top-level integration.

### Task 2: Audit LRQ and LRQ entries

**Files:**
- Create: `doc-lrq/xx_lsu_lrq_risk_review.md`
- Create: `doc-lrq/xx_lsu_lrq_verification_focus.md`
- Read: `srcs/xx_lsu_lrq.sv`
- Read: `srcs/xx_lsu_lrq_entry.sv`
- Read: `srcs/xx_lsu_top.sv`
- Read: `srcs/xx_lsu_ld_ag.sv`
- Read: `srcs/xx_lsu_ctrl.sv`

**Interfaces:**
- Consumes: three-lane create/pop/replay interfaces, entry free/freeze/ready state, flush and wakeup bitmaps, IID ordering, no-space arbitration, and saved payload fields.
- Produces: LRQ findings with `LRQ-RR-*` IDs and directed checks with `LRQ-V*` IDs.

- [x] **Step 1:** Derive each entry's create, freeze-clear, flush, ready, issue, complete, and reuse priority order.
- [x] **Step 2:** Audit three-lane allocation, free-pointer uniqueness, simultaneous create/pop, no-space reservation, and cross-lane arbitration.
- [x] **Step 3:** Audit every saved/replayed field for width, initialization, valid qualification, and transaction identity.
- [x] **Step 4:** Write the LRQ risk report and verification plan with lifecycle scoreboards, assertions, and coverage crosses.

### Task 3: Audit LQ and LQ entries

**Files:**
- Create: `doc-lq/xx_lsu_lq_risk_review.md`
- Create: `doc-lq/xx_lsu_lq_verification_focus.md`
- Read: `srcs/xx_lsu_lq.sv`
- Read: `srcs/xx_lsu_lq_entry.sv`
- Read: `srcs/xx_lsu_top.sv`
- Read: `srcs/xx_lsu_ld_da.sv`

**Interfaces:**
- Consumes: LQ create/merge/pop/flush, address and byte-mask matching, dependency checks, store-forward feedback, and entry fullness.
- Produces: LQ findings with `LQ-RR-*` IDs and directed checks with `LQ-V*` IDs.

- [x] **Step 1:** Derive entry allocation, merge, clear, and full/no-space priority for simultaneous lane activity.
- [x] **Step 2:** Audit address/mask compare semantics, dependency outputs, and transaction identity across IID wrap and partial flush.
- [x] **Step 3:** Audit parameter widths, one-hot assumptions, X/default behavior, and top-level named-port wiring.
- [x] **Step 4:** Write the LQ risk report and verification plan with entry scoreboards, assertions, and coverage crosses.

### Task 4: Audit RB and RB entries

**Files:**
- Create: `doc-rb/xx_lsu_rb_risk_review.md`
- Create: `doc-rb/xx_lsu_rb_verification_focus.md`
- Read: `srcs/xx_lsu_rb.sv`
- Read: `srcs/xx_lsu_rb_entry.sv`
- Read: `srcs/xx_lsu_top.sv`
- Read: `srcs/xx_lsu_ld_da.sv`
- Read: `srcs/xx_lsu_ld_wb.sv`
- Read: `srcs/xx_lsu_ctrl.sv`

**Interfaces:**
- Consumes: miss/refill create, merge, dependency, bus request/response, ECC/error, completion/data-return, flush, and entry pop interfaces.
- Produces: RB findings with `RB-RR-*` IDs and directed checks with `RB-V*` IDs.

- [x] **Step 1:** Derive RB entry lifecycle and priority among create, merge, bus grant/response, data return, flush, and pop.
- [x] **Step 2:** Audit request/response identity, burst/beat accounting, error/ECC propagation, and refill completion ordering.
- [x] **Step 3:** Audit arbitration, one-hot selection, simultaneous entry events, parameter widths, and top-level wiring.
- [x] **Step 4:** Write the RB risk report and verification plan with protocol scoreboards, assertions, and coverage crosses.

### Task 5: Audit load DC

**Files:**
- Create: `doc-dc/xx_lsu_ld_dc_risk_review.md`
- Create: `doc-dc/xx_lsu_ld_dc_verification_focus.md`
- Read: `srcs/xx_lsu_ld_dc.sv`
- Read: `srcs/xx_lsu_ld_ag.sv`
- Read: `srcs/xx_lsu_ld_da.sv`
- Read: `srcs/xx_lsu_top.sv`
- Read: `srcs/xx_lsu_ctrl.sv`

**Interfaces:**
- Consumes: AG valid/payload, D-cache tag/data/ECC, borrow paths, immediate-wakeup dead path, and DC-to-DA metadata.
- Produces: DC findings with `DC-RR-*` IDs and directed checks with `DC-V*` IDs.

- [x] **Step 1:** Derive DC valid, payload-clock, borrow, stall, and flush priority across all sequential groups.
- [x] **Step 2:** Audit tag/data way selection, hit/miss/ECC classification, cacheability and fault masking, and payload alignment.
- [x] **Step 3:** Audit AG-to-DC and DC-to-DA valid qualification, dead immediate-wakeup logic, X propagation, and top wiring.
- [x] **Step 4:** Write the DC risk report and verification plan with stage scoreboards, assertions, and coverage crosses.

### Task 6: Audit load DA

**Files:**
- Create: `doc_da/xx_lsu_ld_da_risk_review.md`
- Create: `doc_da/xx_lsu_ld_da_verification_focus.md`
- Read: `srcs/xx_lsu_ld_da.sv`
- Read: `srcs/xx_lsu_ld_dc.sv`
- Read: `srcs/xx_lsu_ld_wb.sv`
- Read: `srcs/xx_lsu_lq.sv`
- Read: `srcs/xx_lsu_rb.sv`
- Read: `srcs/xx_lsu_top.sv`

**Interfaces:**
- Consumes: DC hit/miss/data/ECC metadata, forwarding/dependency results, exception inputs, vector rotation/FOF state, no-spec outputs, and DA-to-WB/RB/LQ side effects.
- Produces: DA findings with `DA-RR-*` IDs and directed checks with `DA-V*` IDs.

- [x] **Step 1:** Derive DA completion, restart, exception, refill-buffer, forwarding, and writeback priority.
- [x] **Step 2:** Audit data select/merge/rotation, byte masks, ECC handling, scalar/vector exception priority, FOF/vstart, and no-spec side effects.
- [x] **Step 3:** Audit valid qualification for every architectural side effect and transaction identity across borrow, replay, and flush.
- [x] **Step 4:** Write the DA risk report and verification plan with data/exception scoreboards, assertions, and coverage crosses.

### Task 7: Audit load WB

**Files:**
- Create: `doc-wb/xx_lsu_ld_wb_risk_review.md`
- Create: `doc-wb/xx_lsu_ld_wb_verification_focus.md`
- Read: `srcs/xx_lsu_ld_wb.sv`
- Read: `srcs/xx_lsu_ld_da.sv`
- Read: `srcs/xx_lsu_rb.sv`
- Read: `srcs/xx_lsu_top.sv`

**Interfaces:**
- Consumes: DA/RB/WMB/VMB completion and data requests, arbitration grants, exceptions, vector state, debug halt data, and RTU/IDU writeback outputs.
- Produces: WB findings with `WB-RR-*` IDs and directed checks with `WB-V*` IDs.

- [x] **Step 1:** Derive completion/data arbitration and payload selection priority for simultaneous requesters.
- [x] **Step 2:** Audit exception, scalar/vector result, vstart/VL, no-spec, debug, and completion identity propagation.
- [x] **Step 3:** Audit valid/gate-clock relationships, fixed-width assumptions, X/default behavior, and top wiring.
- [x] **Step 4:** Write the WB risk report and verification plan with arbitration scoreboards, assertions, and coverage crosses.

### Task 8: Audit controller and cross-module integration

**Files:**
- Create: `doc-ctrl/xx_lsu_ctrl_integration_risk_review.md`
- Create: `doc-ctrl/xx_lsu_ctrl_integration_verification_focus.md`
- Read: `srcs/xx_lsu_ctrl.sv`
- Read: `srcs/xx_lsu_top.sv`
- Read: all reviewed module interfaces under `srcs/`

**Interfaces:**
- Consumes: clock-enable expressions, restart/async wakeup bitmaps, flush, shared lane signals, and every top-level named-port instance.
- Produces: controller/integration findings with `CTRL-RR-*` IDs and directed checks with `CTRL-V*` IDs.

- [x] **Step 1:** Audit functional and special clock enables against every sequential consumer and the permanent tie-off contracts.
- [x] **Step 2:** Audit restart/wakeup ownership, lane mapping, shared-signal naming, reset/flush priority, and parameter compatibility.
- [x] **Step 3:** Re-run named-port set checks for every top instance and every generated entry instance; distinguish structural success from missing elaboration.
- [x] **Step 4:** Write the controller/integration risk report and verification plan with clock/wakeup assertions and cross-module coverage.

### Task 9: Cross-review, verify, and publish

**Files:**
- Verify: `doc-1.1/*.md`
- Verify: `doc-lrq/*.md`
- Verify: `doc-lq/*.md`
- Verify: `doc-rb/*.md`
- Verify: `doc-dc/*.md`
- Verify: `doc_da/*.md`
- Verify: `doc-wb/*.md`
- Verify: `doc-ctrl/*.md`
- Verify: `docs/superpowers/plans/2026-07-16-interaction-1.1.3-1.2-full-lsu-review.md`

**Interfaces:**
- Consumes: all audit artifacts from Tasks 1-8.
- Produces: a documentation-only commit on the verified remote default branch with matching local, tracking, and GitHub API SHA.

- [x] **Step 1:** Cross-check risk IDs, severity, contracts, duplicated findings, and producer/consumer conclusions across all reports.
- [x] **Step 2:** Validate every source citation, Markdown fence/table structure, trailing whitespace, and required directory/file presence.
- [x] **Step 3:** Run module/instance named-port audits and targeted source-token/priority checks for every retained high-priority finding.
- [x] **Step 4:** Verify `git diff -- srcs README.md` is empty and inspect the complete staged diff.
- [x] **Step 5:** Commit on the isolated branch, fast-forward local `main`, push to the verified default branch, and confirm all three SHAs match.
