# XX LSU Load AG Review Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:dispatching-parallel-agents for the independent functional, wiring, and verification investigations.

**Goal:** Review `srcs/xx_lsu_ld_ag.sv` for functional risks and integration mistakes, then provide a source-grounded verification focus document under `doc-1.1/`.

**Architecture:** Keep the RTL unchanged. Compare the modified AG stage with `srcs/ct_lsu_ld_ag.v`, trace all new MMU/LRQ interfaces through `srcs/xx_lsu_top.sv` and neighboring modules, and classify findings by evidence and dependency on undocumented interface contracts.

**Tech Stack:** SystemVerilog RTL, local Git history, structural text analysis, Markdown deliverables.

## Global Constraints

- Satisfy all four deliverable requirements in `README.md` interaction 1.1.
- Put review deliverables in `doc-1.1/`.
- Every reported risk must include exact source locations, a trigger scenario, impact, and a verification or correction recommendation.
- Distinguish confirmed/high-confidence defects from contract-dependent risks and open timing questions.
- Do not modify the supplied RTL.

---

### Task 1: Establish the review baseline

**Files:**
- Read: `README.md`
- Read: `srcs/ct_lsu_ld_ag.v`
- Read: `srcs/xx_lsu_ld_ag.sv`

- [x] Record the new MMU miss-queue and LRQ/replay interfaces.
- [x] Diff the modified AG implementation against the C910 baseline.
- [x] Identify the valid, stall, abort, flush, PA-return, LRQ-create, and LRQ-replay state transitions.

### Task 2: Audit functional behavior

**Files:**
- Create: `doc-1.1/xx_lsu_ld_ag_risk_review.md`
- Read: `srcs/xx_lsu_ld_ag.sv`
- Read: `srcs/xx_lsu_lrq.sv`
- Read: `srcs/xx_lsu_lrq_entry.sv`

- [x] Check MMU request/response retention, abort, fault, and backpressure sequences.
- [x] Check LRQ allocation, freeze, wakeup, replay, PA reuse, and pop sequences.
- [x] Check exception, boundary, vector/split, cache request, and flush interactions.
- [x] Write only evidence-backed findings and explicitly list unresolved contract questions.

### Task 3: Audit instantiation and wiring

**Files:**
- Read: `srcs/xx_lsu_top.sv`
- Read: `srcs/xx_lsu_ld_ag.sv`
- Read: `srcs/xx_lsu_ld_dc.sv`
- Read: `srcs/xx_lsu_ld_da.sv`
- Read: `srcs/xx_lsu_lrq.sv`
- Read: `srcs/xx_lsu_lq.sv`
- Update: `doc-1.1/xx_lsu_ld_ag_risk_review.md`

- [x] Compare the AG declaration with its named-port instance one port at a time.
- [x] Compare shared signal widths, directions, names, and polarity across producer and consumer modules.
- [x] Record suspected typos separately from function-level risks.

### Task 4: Define verification priorities

**Files:**
- Create: `doc-1.1/xx_lsu_ld_ag_verification_focus.md`

- [x] Define directed scenarios for translation hit/miss/fault, MMU backpressure, LRQ replay, flush, boundary, exception, vector, AMO, cacheability, and clock gating.
- [x] For each scenario, specify stimulus, observables, pass criteria, assertions, and coverage intent.
- [x] Add a design-clarification checklist for undocumented interface timing.

### Task 5: Verify and prepare the authorized publication

**Files:**
- Verify: `doc-1.1/xx_lsu_ld_ag_risk_review.md`
- Verify: `doc-1.1/xx_lsu_ld_ag_verification_focus.md`

- [x] Check that every cited line and signal exists in the supplied source.
- [x] Check that all README requirements are covered and that no RTL file changed.
- [x] Review Markdown structure and cross-document consistency.
- [x] Validate the default branch, GitHub write access, and explicit staging scope for the authorized publish workflow.
