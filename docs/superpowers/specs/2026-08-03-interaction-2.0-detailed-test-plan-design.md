# Interaction 2.0 Detailed Test Plan Design

## Goal

Refine the existing `xx_lsu_ld_ag` feature and test plan so that an engineer can
translate every planned scenario directly into a cycle-accurate VCS testcase.
Each scenario must state the driven signals and timing, the exact trigger
condition, the expected observable result, and the checker and coverage item
that close it.

## Scope

The scope is `xx_lsu_ld_ag`, because interaction 2.0 immediately follows the
interaction 1.9 request to build the standalone VCS environment for that DUT.
The work refines verification artifacts; it does not modify
`srcs/xx_lsu_ld_ag.sv` or claim that VCS/URG ran on this Mac.

The existing twelve feature IDs `AG-FP-01` through `AG-FP-12` remain stable.
The existing twelve test tasks, assertions, cover properties, priorities, and
result states remain the feature-level anchors.

## Chosen Approach

Use a human-readable detailed Markdown plan backed by a machine-readable CSV
scenario matrix and an automatic completeness gate. This is preferred over
only enlarging the current Markdown table because structural omissions and
signal-name drift would otherwise be invisible. It is also preferred over
expanding every SystemVerilog test immediately because interaction 2.0 asks for
an implementation-ready plan, while real dynamic signoff still requires a
licensed VCS host and production helper modules.

## Artifacts

### Detailed scenario matrix

Create `verif/xx_lsu_ld_ag/detailed_test_plan.csv` as the source of structured
traceability. It contains at least four scenarios for each of the twelve
feature IDs, for a minimum of 48 scenarios. Scenario IDs use
`AG-FP-NN-SMM`, for example `AG-FP-03-S02`.

Each row has these fields:

| Field | Meaning |
|---|---|
| `scenario_id` | Stable `AG-FP-NN-SMM` scenario identifier |
| `feature_id` | Parent feature in `coverage_matrix.csv` |
| `scenario` | Short behavior name |
| `testcase` | Existing SystemVerilog task that the engineer extends with the scenario |
| `priority` | Parent `P0` or `P1` priority |
| `setup` | Reset state, model configuration, address class, and owner identity |
| `drive_signals` | Pipe-separated input or forced signal identifiers |
| `cycle_sequence` | Explicit C0/C1/C2 drive and sample sequence |
| `trigger_condition` | Chinese sentence beginning with “当”, containing exact signal conditions |
| `expected_signals` | Pipe-separated outputs or internal observables |
| `expected_result` | Chinese sentence beginning with “则”, containing exact expected values/timing |
| `checker` | Existing checker/SVA label |
| `coverage` | Existing cover-property label |
| `closure` | Per-scenario pass criterion, including prohibited side effects |
| `result` | `BLOCKED_NO_VCS` or `PENDING_FULL_CHIP`, matching the parent feature |

The signal lists contain RTL/testbench identifiers, not prose aliases. A row
therefore supplies enough information to write the driver assignments,
sampling point, assertion, and coverage bin without reverse-engineering the
summary description.

The twelve existing test tasks remain feature-level execution buckets. The
detailed plan does not claim that every new subscenario is already encoded or
simulated; it identifies the exact task to extend and the closure condition to
use. Dynamic implementation and execution status must be reported separately.

### Human-readable feature plan

Expand `doc-ag/xx_lsu_ld_ag_feature_test_plan.md` with:

1. a short implementation contract explaining clock-cycle notation;
2. one section for every `AG-FP-NN` feature;
3. a table of that feature’s scenario IDs, setup and cycle sequence;
4. an explicit “当 …，则 …” statement for every scenario;
5. the checker, cover property, and closure requirement;
6. the standalone versus full-chip execution boundary.

The document must distinguish expected architectural behavior from known RTL
findings. A known source finding is recorded as an expected detection outcome,
not rewritten as a passing DUT result.

### Automatic completeness gate

Extend `verif/xx_lsu_ld_ag/tools/check_completeness.py` to reject the plan when:

- the CSV schema differs from the specified fields;
- scenario IDs are missing, duplicated, malformed, or mapped to the wrong parent;
- any feature has fewer than four detailed scenarios;
- testcase, priority, checker, coverage, or result differs from the parent row;
- a trigger does not start with “当” or an expectation does not start with “则”;
- setup, cycle sequence, closure, driven signals, or expected signals are empty;
- a listed signal identifier is absent from the delivered DUT or verification sources;
- the Markdown plan does not contain every scenario ID and execution boundary.

Successful preflight reports both the existing 12/12 feature mapping and the
new detailed-scenario count.

### Regression test and reports

Add `tests/test_interaction_2_0_detailed_plan.py` before implementing the new
artifacts. The test first fails because the detailed matrix/report are absent,
then passes only after schema, mapping, wording, signal traceability, and
documentation coverage are implemented.

Update `doc-ag/xx_lsu_ld_ag_vcs_verification.md` so engineers know how the
detailed rows map into the existing `+TEST=` tasks. Add
`docs/interaction-2.0-followup-review.md` to state the requirement coverage,
commands used, and the VCS/URG execution boundary.

## Data Flow

`coverage_matrix.csv` defines the twelve feature-level anchors.
`detailed_test_plan.csv` expands each anchor into cycle-accurate scenarios.
The Markdown plan presents those scenarios to engineers. The completeness
script cross-checks both layers against `tests.list`, the testbench, assertions,
and delivered signal identifiers. `make preflight` remains the single local
entry point.

## Verification Strategy

1. Run the new unit test before implementation and retain the expected failure.
2. Add the detailed matrix and documentation until the focused test passes.
3. Extend the completeness gate and confirm mutation-style negative cases are
   rejected by unit tests.
4. Run `make -C verif/xx_lsu_ld_ag preflight`.
5. Run the full Python regression.
6. Run `make -C verif/xx_lsu_ld_ag compile`; if VCS is unavailable, preserve
   the exact blocker and do not report simulation or coverage as passed.
7. Check the final diff, verify no DUT RTL changed, commit once for the final
   delivery, push to `main`, fetch, and verify local/remote commit identity.

## Completion Criteria

- All twelve features have at least four implementation-ready scenarios.
- Every scenario has exact signal conditions, cycle timing, expectations,
  checker, coverage, and closure.
- Machine checks prove scenario-to-feature and signal traceability.
- Existing interaction 1.9 tests and preflight remain green.
- Dynamic VCS/URG results are reported only if actually obtained.
- No file under `srcs/` is modified.
