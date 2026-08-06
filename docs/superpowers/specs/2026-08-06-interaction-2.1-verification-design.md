# Interaction 2.1 Detailed LSU Verification Design

## 1. Goal

Complete all three `README.md` interaction-2.1 requirements:

1. Refine the `xx_lsu_ld_ag` feature and test plan to leaf-level, signal-accurate scenarios, including the explicitly reported older-RF-overrides-AG case.
2. Produce equally detailed plans and independent VCS verification environments for `xx_lsu_ld_dc`, `xx_lsu_ld_da`, `xx_lsu_ld_wb`, `xx_lsu_rb`, `xx_lsu_lrq`, and `xx_lsu_lfb` (including the entry modules already named by the feature plans).
3. Populate the supplied code/function coverage waiver workbook from the supplied DOCX without inventing unsupported waiver facts or approval metadata.

The local machine has no Synopsys VCS or URG installation. Local completion therefore means that all generated artifacts, static gates, test suites, and VCS/URG entry points pass or reach the documented tool-availability boundary. Dynamic simulation and coverage closure remain a separate licensed-host signoff.

## 2. Chosen Architecture

Use a shared verification framework plus one independent environment per DUT.

- `verif/common/` owns reusable port extraction, interface/connection generation, scenario validation, SystemVerilog structural validation, dependency-stub generation, and aggregate preflight.
- Each DUT directory owns its module manifest, Makefile, feature matrix, detailed scenario CSV, test list, generated interface/connection files, module-specific testbench, assertions, runbook, and any explicitly documented standalone dependency boundary.
- Every DUT remains runnable through the same commands: `make preflight`, `make compile`, `make run TEST=...`, `make regress`, and `make coverage`.
- Shared tooling removes duplicated parser/checker logic, while module-local data and assertions keep failures attributable to one DUT.

A single full-LSU integration environment is not the primary delivery because this repository lacks part of the production dependency graph, including `xx_lsu_lfb_data_entry`. Integration-only coverage would also obscure whether an individual module plan is directly actionable.

## 3. Artifact Layout

### 3.1 Shared framework

Create the following focused files:

- `verif/common/tools/rtl_ports.py`: parse the repository's non-ANSI SystemVerilog module declarations and return ordered ports, directions, and widths.
- `verif/common/tools/gen_env.py`: render checked-in DUT interfaces, named connections, and dependency stubs from a module manifest; `--check` fails on drift.
- `verif/common/tools/scenario_contract.py`: validate scenario IDs, schemas, parent-feature mappings, signal vocabulary, `当`/`则` grammar, cycle descriptions, checker/coverage references, closure text, and result states.
- `verif/common/tools/preflight.py`: run one module or every module through port, scenario, generated-file, testbench-structure, and runbook gates.
- `verif/common/Makefile`: expose aggregate `preflight`, `compile`, `regress`, and `coverage` targets.

The tools use only the Python standard library so a verification checkout does not need a package installation step.

### 3.2 Module environments

Create or upgrade:

- `verif/xx_lsu_ld_ag`
- `verif/xx_lsu_ld_dc`
- `verif/xx_lsu_ld_da`
- `verif/xx_lsu_ld_wb`
- `verif/xx_lsu_rb`
- `verif/xx_lsu_lrq`
- `verif/xx_lsu_lfb`

Each directory contains:

- `module.json`: DUT source, module name, parameters, clock/reset signals, associated documentation, feature-ID prefix, expected feature count, minimum leaf-scenario count, production dependencies, and standalone boundaries.
- `coverage_matrix.csv`: one parent row per feature with testcase, priority, checker, coverage point, closure criterion, and result boundary.
- `detailed_test_plan.csv`: leaf scenarios with exact setup, driven signals, cycle sequence, trigger condition, observed signals, expected result, checker, coverage, closure, and result.
- `tests.list`: the module-level testcase names selectable with `+TEST=`.
- `Makefile` and a Markdown runbook documenting identical invocation semantics.
- `tb/<dut>_if.sv` and `tb/<dut>_connect.svh`: generated from the real DUT declaration.
- `tb/<dut>_deps.sv`: only the standalone compatibility modules required to elaborate the DUT. Stubs must be listed in `module.json` and documented as `PENDING_FULL_CHIP`; a production dependency may not be silently replaced.
- `tb/<dut>_assertions.sv`: named assertions and cover properties referenced by the feature matrix.
- `tb/<dut>_tb.sv`: clock/reset, idle driving, testcase selection, feature-level stimulus tasks, check helpers, and explicit result reporting.

## 4. Scenario Contract and Volume

Every leaf scenario is directly traceable through this chain:

`README requirement -> feature-plan Markdown -> feature matrix -> detailed CSV -> testcase -> checker -> coverage point -> closure criterion -> result state`.

The scenario schema is:

`scenario_id, feature_id, scenario, testcase, priority, setup, drive_signals, cycle_sequence, trigger_condition, expected_signals, expected_result, checker, coverage, closure, result`.

Each scenario must:

- have a contiguous ID such as `DC-FP-03-S04`;
- name only signals delivered by the DUT, interface, testbench, or explicitly declared checker observation set;
- include both `C0` and `C1`, adding later cycles when the contract is sequential;
- start its trigger with `当` and its outcome with `则`;
- state signal values and ownership/ID conditions rather than using labels such as “normal case”;
- define a checker, coverage point, and measurable closure condition;
- use `BLOCKED_NO_VCS` when locally executable but not dynamically run, or `PENDING_FULL_CHIP` when a production dependency or system contract is required.

Minimum delivered volume:

| Environment | Parent features | Minimum scenarios per feature | Minimum total |
|---|---:|---:|---:|
| AG | 12 | 8 | 96 |
| DC | 12 | 6 | 72 |
| DA | 12 | 6 | 72 |
| WB | 12 | 6 | 72 |
| RB | 12 | 6 | 72 |
| LRQ | 12 | 6 | 72 |
| LFB | 13 | 6 | 78 |
| **Total** | **85** | - | **534** |

The six recurring leaf classes are nominal transfer, backpressure/hold, simultaneous-priority conflict, flush/reset boundary, delayed or malformed response, and owner/entry reuse. AG adds two more leaf classes per feature, selected from timing, attribute, cross-page, unit-stride, fault, and negative-isolation behavior.

## 5. Required AG Correction

The exact interaction-2.1 case is a mandatory AG-FP-05 leaf scenario and executable feature-task branch:

- Live AG owner is structurally stalled so `lag_ex1_stall_ori=1`.
- A genuinely older RF request makes `idu_lsu_rf_older_vld=1`, therefore internal `ld_ag_stall_mask=1` and `ld_ag_stall_vld=0`.
- The MMU has no translation, `mmu_lsu_pa_vld=0`, while another abort cause makes `lsu_mmu_abort=1`.
- Because `lag_stall_ori_tlbmiss_not_abort` requires `!lsu_mmu_abort`, this combination must not take the ordinary un-aborted TLB-miss suppression path.
- The old AG owner must be made immediately replayable: its LRQ create is not frozen, and after the created entry ID is available, `lag_ex1_stall_restart_entry` selects that owner. The older RF request may replace EX1 without losing or duplicating the displaced transaction.

AG-FP-05 also covers the adjacent truth-table combinations for `stall_ori`, `stall_mask`, `pa_vld`, `abort`, replay/fresh ownership, and create-already state. The checker verifies restart bitmap ownership, LRQ freeze state, zero duplicate create, and zero lost owner.

## 6. Module-Specific Verification Focus

- DC: EX1-to-EX2 ownership, borrow gate/payload consistency, one-hot cache-way selection, unit-stride way retention, byte masks, LQ acceptance, restart priority, exception transfer, forward metadata, DA transfer, debug pulse, and clock/reset capture.
- DA: cache-data selection, forward merge, ECC/replay, delayed MMU access fault, LQ pop, RB create/merge, completion/data requests, exception/restart terminal state, LFB/LRQ wakeup, debug side effects, and flush/clock boundaries.
- WB: completion and data arbitration, req/DP/gate implications, scalar/vector formatting, RTU completion, bus-error suppression, VMB completion, halt-info state, EX4 forwarding, flush, and clock/reset behavior.
- RB: capacity/pointers, create winner ownership, entry state transitions, merge/boundary data, BIU request attributes/ID, LFB binding, R/B response ownership, SO FIFO, WB hold-until-grant, sync/async flush, and clock/reset.
- LRQ: allocation, create/pop acceptance, replay payload, freeze reasons, producer-owner wakeup, oldest-ready issue, replay isolation, barrier/no-spec dependencies, DA feedback, flush, entry clocks, and parameter-width contract.
- LFB: RB/PFU allocation, address-entry lifecycle, line hit/merge, address/data binding, BIU response protocol, VB selection, refill, completion accounting, dependency wakeup, SNQ bypass, flush/outstanding behavior, capacity, and clock/reset. The absent production data-entry module is an explicit standalone/full-chip boundary.

## 7. Waiver Workbook Transformation

The source DOCX is read-only evidence. The supplied XLSX remains the deliverable and retains its two-sheet, 17-column template and visual language.

### 7.1 Code waiver sheet

- Remove the CP0 example rows.
- Add one row for each distinct LSU line, branch, condition, toggle, or FSM exclusion described in the DOCX.
- Group entries only when the DOCX explicitly says “同理排除” or provides one shared reason for a listed signal set.
- Preserve the DOCX's `wk_lsu_*` object reference. When a corresponding repository module exists, add the `srcs/xx_lsu_*` mapping in the object location or remarks without claiming that the historical line number is current.
- Populate object name/location, module/subsystem, exclusion condition, exclusion reason, impact assessment, alternative verification, property, and term.
- Leave specification IDs, personal names, reviewer/approver identities, and dates blank unless supplied by the source.
- Use “永久” only for structurally unreachable, tied-off, explicitly unsupported, or parameter-fixed behavior. Use “阶段性” for missing integration/dependency coverage that can be closed in another configuration.

### 7.2 Function waiver sheet

Remove the example data row. The DOCX's second chapter contains template placeholders rather than an actual LSU function-waiver claim, so retain only the formatted headers. Record this evidence gap in the interaction-2.1 delivery report rather than inventing a waiver.

### 7.3 Workbook QA

Use the bundled `@oai/artifact-tool` runtime to import, edit, inspect, render, and export the workbook. Preserve template header fills, merged header cells, borders, fonts, wrapping, and freeze behavior. Expand row heights and column widths only as needed for legibility. Completion requires:

- workbook inspection of all populated ranges;
- no formula-error tokens;
- render review of both sheets;
- no clipped headers, reasons, or approval columns;
- a repository test that extracts the final workbook and reconciles its waiver row count/type/module inventory with a checked-in manifest.

## 8. Error Handling and Evidence Rules

- Unknown or misspelled signal in any detailed scenario is a preflight failure.
- Missing feature, testcase, checker, coverage point, closure text, runbook command, or Markdown scenario ID is a preflight failure.
- Generated interface or connection drift from RTL is a preflight failure.
- An undeclared dependency stub or a production module silently replaced by a stub is a preflight failure.
- A VCS/URG tool lookup failure is reported as `BLOCKED_NO_VCS`, not as a simulation failure or PASS.
- A missing production module required for integration is reported as `PENDING_FULL_CHIP` with the exact filename/module name.
- Waiver content without DOCX evidence is omitted and reported as an evidence gap.

## 9. Test Strategy

Implementation follows red-green-refactor:

1. Add interaction-2.1 tests that initially fail because AG has fewer than 96 scenarios, six environments are absent, the required AG truth-table row is absent, and the workbook still contains CP0 examples.
2. Implement shared tooling and demonstrate validator mutation failures for unknown signals, broken parent mappings, missing Markdown rows, generated-port drift, undeclared stubs, and invalid result states.
3. Upgrade AG and rerun its focused tests/preflight.
4. Add each remaining module environment and run its focused tests/preflight before proceeding.
5. Populate the workbook, inspect values, scan errors, render both sheets, and reconcile it against the waiver manifest.
6. Run the full repository test suite and aggregate seven-module preflight.
7. Invoke aggregate `compile` once to prove it reaches only the explicit VCS availability boundary on this host.

## 10. Acceptance Criteria

Interaction 2.1 is complete locally only when:

- all 85 parent features and at least 534 detailed leaf scenarios pass the shared contract validator;
- the required AG older-RF/aborted-TLB-miss immediate-replay scenario and adjacent truth-table cases are present in CSV, Markdown, testcase, checker, and coverage artifacts;
- all seven module environments pass generated-port, scenario, SV-structure, dependency-boundary, test-list, and runbook preflight;
- the full Python test suite passes with no regressions;
- the waiver workbook contains only DOCX-supported LSU entries, no CP0/template example data, and both sheets pass visual QA;
- `main` receives the reviewed commits through a non-force update and matches `origin/main` afterward;
- the final report separately names local static evidence, licensed-host dynamic work, and full-chip dependency work.

## 11. Non-Goals

- Do not modify production RTL solely to increase coverage or make the standalone harness easier.
- Do not claim VCS simulation, URG coverage closure, or full-chip dependency signoff on this machine.
- Do not invent waiver owners, approvals, specification identifiers, or unsupported function exclusions.
- Do not replace the supplied DOCX or reformat it as a new deliverable.
