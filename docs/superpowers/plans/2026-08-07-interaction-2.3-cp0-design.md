# Interaction 2.3 CP0 Detailed Design Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Deliver a source-accurate, verification-oriented detailed design for the CP0 system interrupt/exception implementation added by README interaction 2.3, plus an executable contract extractor that detects stale topology, source, priority, delegation, and ack assumptions.

**Architecture:** Keep all four CP0 RTL files unchanged. Use one detailed Markdown document as the human verification reference. Back its mechanical facts with a Python standard-library checker that parses the real RTL and exposes a stable JSON/text contract; review all multi-signal and timing semantics manually against the source. Record static evidence and explicitly separate it from unavailable full CP0 compile/simulation/coverage evidence.

**Tech Stack:** Verilog RTL, Markdown, Python 3 standard library and `unittest`, Git.

## Global Constraints

- Work only in branch `review/interaction-2.3-v1` and its existing isolated worktree until final integration.
- The source baseline is `473b3c23794a7841f3c31fc667a4964fda9a28d4`.
- Do not modify `README.md`, any file under `cp0/`, any file under `srcs/`, or prior interaction artifacts.
- The only authoritative RTL inputs are `cp0/wk_cp0_top.v`, `cp0/wk_cp0_iui.v`, `cp0/wk_cp0_regs.v`, and `cp0/wk_cp0_lpmd.v`.
- Describe the RTL as implemented. Label external timing, source-clear, downstream vector-offset, and dual-valid relationships as interface contracts or items requiring system integration confirmation.
- Do not claim full CP0 compile, VCS simulation, regression, code coverage, functional coverage, or URG success. The repository lacks a complete CP0 filelist, external dependencies, `WK_MAJOR_*` macro definitions, and dynamic evidence.
- Use TDD for the executable checker: observe RED before implementation, then GREEN. Human-facing prose earns manual source review, not exact-phrase tests.
- Tests must run the real checker. Mutation tests must name and catch a concrete stale-document failure; do not grep Chinese prose.
- The final document must identify the active-low interrupt request polarity, the 15-slot/13-live fixed priority, the 12 effective delegated exception causes, the unused `rtu_cp0_int_ack`, the delegated-MCIP request/trap target mismatch, and the distinction between interrupt wakeup and trap eligibility.
- All final claims must be verified again on integrated `main` before non-force push.

## File Responsibility Map

|File|Responsibility|
|---|---|
|`tests/test_interaction_2_3_cp0_contract.py`|Runs the real checker and proves it rejects priority, topology, MCIP delegation, ACK-consumer, WFI-path, and CLI-contract drift.|
|`tools/check_interaction_2_3_cp0_contract.py`|Parses the CP0 RTL into the stable module/source/priority/delegation/ACK/key-path contract.|
|`doc-cp0/wk_cp0_system_interrupt_exception_detailed_design.md`|Primary system interrupt/exception design and verification reference.|
|`docs/interaction-2.3-followup-review.md`|README closure, evidence summary, scope audit, and dynamic-signoff boundary.|
|`docs/superpowers/specs/2026-08-07-interaction-2.3-cp0-design.md`|Approved design and source-fact model.|
|`docs/superpowers/plans/2026-08-07-interaction-2.3-cp0-design.md`|This implementation plan.|

---

### Task 1: Build the Executable CP0 RTL Contract

**Files:**
- Create: `tests/test_interaction_2_3_cp0_contract.py`
- Create: `tools/check_interaction_2_3_cp0_contract.py`

**Interfaces:**
- CLI: `python3 tools/check_interaction_2_3_cp0_contract.py [--root PATH] [--json]`
- Default root: repository root derived from the checker file location
- Success marker: `CP0_CONTRACT_PASS modules=4 submodules=3 interrupt_sources=8 priority_slots=15 live_slots=13 delegable_exceptions=12 ack_consumers=0`
- JSON keys: `modules`, `top_submodules`, `interrupt_sources`, `interrupt_priority`, `delegable_exceptions`, `mcip_delegation`, `ack_consumers`, `key_paths`
- Failure: nonzero exit and one concise `CP0_CONTRACT_FAIL:` message on stderr

- [ ] **Step 1: Write the failing real-RTL and mutation tests**

Create the focused real-RTL and mutation suite (13 tests at final review):

1. `test_real_rtl_contract_passes_and_reports_hand_derived_facts` runs the checker with `--json`, asserts exit 0, and compares literal hand-derived values:
   - modules: `wk_cp0_top`, `wk_cp0_iui`, `wk_cp0_regs`, `wk_cp0_lpmd`;
   - submodules: `wk_cp0_iui`, `wk_cp0_regs`, `wk_cp0_lpmd`;
   - eight source expressions for `meip`, `mtip`, `msip`, `seip`, `stip`, `ssip`, `mcip`, `moip`;
   - cause order: `[23,18,11,3,7,9,1,5,13,23,18,9,1,5,13]` with slot-live flags derived from the two `1'b0` entries;
   - delegated exceptions: `[1,2,3,4,5,6,7,8,9,12,13,15]`;
   - MCIP delegation fact: cause 23, request-side S selection true, trap-side S classification false;
   - ack consumers: `0`;
   - exact five-key `key_paths` mapping, all values true.
2. `test_rejects_interrupt_priority_cause_drift` copies `cp0/` into a temporary root, changes the highest `valid_int_vec` cause from 23 to 22, runs the real checker against the copy, and expects failure mentioning priority.
3. `test_rejects_missing_top_submodule` removes/renames the `wk_cp0_lpmd x_wk_cp0_lpmd` instance in the temporary copy and expects topology failure.
4. `test_rejects_new_interrupt_ack_consumer` adds a continuous assignment consuming `rtu_cp0_int_ack` before `wk_cp0_regs` endmodule and expects ack-consumer failure.

Also cover priority-selector and duplicate-assignment drift, `wire` declaration-assignment ACK consumption, comment/string non-consumers, both sides of the MCIP delegation fact, BIU no-op/debug-wake removal, and invalid argparse input's single-line failure contract.

The mutations represent a stale verification reference being incorrectly accepted; they are not tests of comments or formatting.

- [ ] **Step 2: Run the focused tests and confirm RED**

Run:

```bash
python3 -m unittest tests.test_interaction_2_3_cp0_contract -v
```

Expected: FAIL because the checker does not yet exist.

- [ ] **Step 3: Implement the standard-library parser/checker**

Implementation requirements:

- strip `//` and `/* ... */` comments before semantic parsing;
- parse module declarations from the four authoritative files;
- parse only the three CP0 child instances from `wk_cp0_top` and reject missing/extra CP0 children;
- extract continuous assignments with balanced whitespace normalization;
- parse `int_sel[14:0]` concatenation into these 15 high-to-low slots:

```text
mcip_nodeleg_vld, 0, meip_vld, msip_vld, mtip_vld,
seip_nodeleg_vld, ssip_nodeleg_vld, stip_nodeleg_vld,
moip_nodeleg_vld, mcip_deleg_vld, 0, seip_deleg_vld,
ssip_deleg_vld, stip_deleg_vld, moip_deleg_vld
```

- parse the IUI `casez(regs_iui_int_sel[14:0])` rows and preserve all 15 cause values;
- derive the effective delegated exception set by intersecting the one-hot bit selected by `vec_num` with the writable source-bit set represented by `edeleg_upd_val`;
- count `rtu_cp0_int_ack` semantic consumers in `wk_cp0_regs` after comments, strings, the port-list entry, and bare declarations are excluded; declaration initializers such as `wire used = rtu_cp0_int_ack;` remain consumers and fail;
- expose and validate the structured MCIP fact: request-side delegated selection uses `mideleg_value[23]`, while trap-side `mideleg_vld` cannot classify returned cause 23 as S because `vec_num` ends at cause 18;
- validate exactly five key paths structurally: IUI illegal cause/mtval, M trap CSR update, S trap CSR update, MRET/SRET return PC, and WFI no-op/wakeup FSM; WFI requires all four ack and all four wake terms;
- emit deterministic JSON with `--json`; otherwise emit the exact success marker;
- catch expected parse/contract/argparse failures in `main()` and emit one failure line without a traceback.

- [ ] **Step 4: Run focused GREEN and mutation check**

Run:

```bash
python3 -m unittest tests.test_interaction_2_3_cp0_contract -v
python3 tools/check_interaction_2_3_cp0_contract.py
python3 tools/check_interaction_2_3_cp0_contract.py --json
```

Expected: 13 tests pass, the marker has the exact counts above, and JSON is stable and parseable.

- [ ] **Step 5: Self-review and commit**

Confirm tests exercise the real checker, literal expectations do not reuse checker helpers, malformed RTL fails closed, only the two authorized files changed, and `git diff --check` passes.

Commit:

```bash
git add tests/test_interaction_2_3_cp0_contract.py tools/check_interaction_2_3_cp0_contract.py
git commit -m "test: add CP0 interrupt contract checker"
```

---

### Task 2: Write the Verification-Oriented CP0 Detailed Design

**Files:**
- Create: `doc-cp0/wk_cp0_system_interrupt_exception_detailed_design.md`

**Inputs from Task 1:**
- Checker JSON and success marker
- Exact source/priority/delegation facts

**Required source anchors:**
- topology: `wk_cp0_top.v:1042`, `:1162`, `:1475`;
- IUI instruction decode/FSM/privilege: `wk_cp0_iui.v:928-1027`, `:1406-1505`, `:1680-1805`;
- IUI local exception and interrupt request: `wk_cp0_iui.v:1967-2054`;
- status stack/delegation/enable/pending: `wk_cp0_regs.v:2144-2247`, `:2280-2371`, `:2382-2481`, `:2531-2714`;
- S trap state: `wk_cp0_regs.v:2731-2792`, `:2846-2944`;
- privilege and return/vector outputs: `wk_cp0_regs.v:3207-3268`, `:5006-5014`, `:5145-5186`, `:5574-5579`;
- ECC and AIA: `wk_cp0_regs.v:3966-4036`, `:5597-6104`;
- WFI: `wk_cp0_lpmd.v:161-265`.

- [ ] **Step 1: Establish scope, evidence labels, and architecture**

Create the document with:

- title, source commit, update rule, intended verification audience;
- evidence labels: `RTL实现`, `接口合同`, `验证要求`, `待集成确认`;
- a system flow diagram from source through RTU trap/xRET;
- a module responsibility and clock/reset table;
- explicit note that external macros/modules and a complete CP0 filelist are absent.

- [ ] **Step 2: Document all relevant interfaces and instruction control**

Include a direction/width/polarity/clock/meaning table for BIU interrupt and wake sources, HPCP, RTU trap metadata and debug, CP0 interrupt requests/vector, IU local exception/xRET, IFU vector base, BIU low-power outputs, and current privilege.

Describe IUI IDLE/EX1/EX2/EX3, commit/flush behavior, CSR privilege/readonly/address/status gates, and local illegal-instruction cause 2 with opcode mtval. State that `cp0_expt_vld` holds until flush or a later EX2 update.

- [ ] **Step 3: Document the complete interrupt pipeline**

Include:

- source-to-pending table for causes 1, 3, 5, 7, 9, 11, 13, 23;
- `MIE/MIP/SIE/SIP`, local enable, global enable, current privilege, and delegation equations;
- a mode/delegation eligibility truth table for M/S/U;
- exact 15-slot priority table, marking slots 13 and 4 as hardwired zero/unreachable while retaining their code-18 decode rows;
- registered active-low request timing and vector hold behavior;
- explicit `rtu_cp0_int_ack` non-use and source-clear responsibility;
- WFI wake eligibility separated from trap eligibility.

- [ ] **Step 4: Document exception/trap entry, vectoring, and return**

Include:

- CP0-local illegal exception versus RTU-supplied system trap paths;
- effective exception-delegation table with causes 1-9, 12, 13, 15 delegated when enabled, plus non-effective causes 0, 10, 11, 14, and >=16 behavior;
- M/S trap CSR write table (`xEPC`, `xCAUSE`, `xTVAL`, xPP/xPIE/xIE, current privilege);
- exact trap-entry and MRET/SRET state-transition tables;
- `mtvec/stvec` storage/read behavior and the downstream vector-offset contract;
- `mepc/sepc` bit-0 clearing and halfword-address `cp0_iu_ex3_efpc` output.

- [ ] **Step 5: Document WFI, ECC, Debug, AIA, reset, and timing**

Cover:

- WFI IDLE/SWAIT/LPMD transitions, four no-op acknowledgements, `lpmd_b`, clock enable, and four wakeup classes;
- ECC selection/sticky/fatal-to-cause-23 path and software clear behavior;
- debug enter/exit precedence in privilege-mode updates and `cp0_dtu_mexpt_vld`;
- `ADD_AIA` conditional IMSIC bridge, unconditional major-interrupt logic, `MVIEN/MVIP/MTOPI/STOPI`, and missing macro/config evidence;
- reset values for current privilege, global enables, xPP/xPIE, trap CSRs, vector CSRs, local enables, pending software state, and low-power state;
- cycle-level tables for interrupt detection/request, RTU trap write, xRET, and WFI.

- [ ] **Step 6: Add directly implementable verification guidance**

Provide:

- reference-model pseudocode that independently computes pending, local-enable, target eligibility, priority, trap target, CSR updates, and xRET restoration;
- at least 18 concrete directed scenario rows with setup, event, expected result, and observation points;
- at least 12 assertion/property descriptions covering polarity, priority, delegation, status stacks, stable cause/vector, ack independence, source clearing, invalid xRET, WFI wake, and dual-valid consistency;
- functional coverage crosses for source × mode × delegation × global enable, simultaneous-source priority, trap target × cause, xRET restore, WFI wake source, ECC state, and AIA configuration;
- scoreboard sampling guidance and clear static-versus-dynamic signoff gates.

- [ ] **Step 7: Add source-observed integration questions and anchors**

List, without silently repairing or overclaiming, all nine items from section 8 of the design spec (rendered as section 7 in the detailed design): unused ack, unqualified return-type output, sticky CP0 exception valid, cause-0 delegation mismatch, vector-mode WARL behavior, dual RTU valid signals, the expanded AIA/major-interrupt item including MCIP request/trap delegation mismatch, downstream vector offset, and sticky `biu_cp0_ss_int` path.

End with a source-anchor index and the Task 1 checker command/marker. Do not claim these items are confirmed bugs.

- [ ] **Step 8: Manual source review and commit**

Run the checker, inspect every numeric table against the anchored RTL, verify relative links, run `git diff --check`, and confirm `git diff -- cp0 srcs` is empty.

Commit:

```bash
git add doc-cp0/wk_cp0_system_interrupt_exception_detailed_design.md
git commit -m "docs: add CP0 interrupt exception design"
```

---

### Task 3: Close README Interaction 2.3 and Verify the Branch

**Files:**
- Create: `docs/interaction-2.3-followup-review.md`

- [ ] **Step 1: Write the closure report**

The report must state:

- README interaction 2.3 is closed by the detailed design document;
- exact source baseline and files reviewed;
- checker marker and what it proves;
- unit-test, existing preflight, whitespace, scope, and link evidence;
- production RTL is unchanged;
- static source review is not CP0 compile/simulation/coverage signoff;
- the nine integration questions remain open until system owners/dynamic tests resolve them.

Include exact commands readers can rerun and a compact artifact index.

- [ ] **Step 2: Run fresh focused and full verification**

Run from the repository root:

```bash
python3 tools/check_interaction_2_3_cp0_contract.py
python3 -m unittest tests.test_interaction_2_3_cp0_contract -v
python3 -m unittest discover -s tests -v
make -C verif/common preflight
git diff --check
git diff 473b3c2...HEAD -- cp0 srcs README.md
git status --short --branch
```

Record fresh counts and outputs. The CP0/source/README scope diff must be empty.

- [ ] **Step 3: Audit document links and source anchors**

Use a standard-library or shell read-only check to confirm every repository-relative Markdown link in the new detailed design and closure report resolves. Sample at least one source anchor from every major section against current line numbers.

- [ ] **Step 4: Commit the closure report**

```bash
git add docs/interaction-2.3-followup-review.md
git commit -m "docs: close interaction-2.3 CP0 design"
```

- [ ] **Step 5: Whole-branch review and integration**

Request a broad whole-branch review against this plan and the design spec. Address all Critical/Important findings, rerun affected tests, and then use the finishing-development-branch workflow. Under the user's standing instruction, select local merge into `main`, perform a non-force push, and verify local `main`, `origin/main`, and the pushed commit are identical.
