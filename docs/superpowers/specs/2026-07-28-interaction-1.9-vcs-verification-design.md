# Interaction 1.9 VCS Verification Design

## Goal

Provide a reproducible Synopsys VCS verification environment for
`srcs/xx_lsu_ld_ag.sv`, map every row of
`doc-ag/xx_lsu_ld_ag_feature_test_plan.md` to executable stimulus, checking,
and functional coverage, and explain the independent RTU-RR-02 canonical
extension defect with concrete virtual addresses.

## Environment boundary

The repository does not contain VCS, URG, Verdi, a license configuration, the
project macro header, or the three vector helper modules instantiated by
`xx_lsu_ld_ag`. The checked-in environment therefore has two explicit layers:

1. **AG DUT layer** — compile the unmodified `srcs/xx_lsu_ld_ag.sv` and drive
   its public ports. Assertions and the scoreboard check the AG address,
   ownership, stall/restart, MMU fault, D-cache request, LRQ, unit-stride,
   debug, and flush behavior.
2. **Standalone compatibility layer** — define only the missing widths and
   provide verification-only behavioral models for `gated_clk_cell`,
   `xx_lsu_compare_iid`, `xx_lsu_vmask_gen`, `xx_lsu_vreg_mask`,
   `xx_lsu_us_bytes_gen`, and `xx_lsu_ld_vreg_rot`. These models make the
   supplied AG source elaboratable; their internal correctness is outside the
   AG sign-off boundary and must be replaced by production definitions in a
   full-chip regression.

No VCS pass result or coverage percentage is claimed on a host that did not
execute VCS. Local checks prove artifact traceability, deterministic reference
models, generated wrapper consistency, and regression compatibility.

## Components

- `verif/xx_lsu_ld_ag/Makefile`: `preflight`, `compile`, `run`, `regress`,
  `coverage`, and `clean` targets.
- `verif/xx_lsu_ld_ag/filelist.f`: deterministic VCS compilation order.
- `verif/xx_lsu_ld_ag/tools/gen_dut_if.py`: parses the DUT's non-ANSI port
  declarations and generates a 258-port interface plus named connections.
- `verif/xx_lsu_ld_ag/tb/xx_lsu_ld_ag_tb.sv`: clock/reset, reusable drivers,
  twelve named testcases, scoreboard, and pass/fail accounting.
- `verif/xx_lsu_ld_ag/tb/xx_lsu_ld_ag_assertions.sv`: bind assertions for
  interface contracts, owner stability, fault persistence, and output safety.
- `verif/xx_lsu_ld_ag/tb/xx_lsu_ld_ag_deps.sv`: verification-only missing
  dependency models.
- `verif/xx_lsu_ld_ag/tests.list`: one test name per feature-plan row.
- `verif/xx_lsu_ld_ag/coverage_matrix.csv`: feature-to-test/check/cover
  traceability and closure criteria.
- `verif/xx_lsu_ld_ag/tools/check_completeness.py`: local, simulator-independent
  validation of the feature matrix and generated wrapper.
- `verif/xx_lsu_ld_ag/tools/reference_model.py`: executable directed and
  exhaustive models for address/mask, MMU owner, fault timing, unit-stride
  line boundary, and RTU canonical examples.
- `doc-ag/xx_lsu_ld_ag_vcs_verification.md`: environment, commands, testcase
  catalog, findings, and actual-versus-pending results.
- `doc-rtu/xx_rtu_retire_canonical_example.md`: concrete low/high canonical
  PC examples and the exact wrong `mtval`.

## Test and coverage model

The twelve feature rows receive stable IDs `AG-FP-01` through `AG-FP-12`.
Completeness requires, for every ID:

- at least one testcase in `tests.list`;
- one self-checking task in the VCS testbench;
- one named assertion or scoreboard check;
- one named coverpoint/cross or cover property;
- a documented pass criterion and result state.

Directed tests close P0 corner cases first. The address/mask testcase adds a
seeded pseudo-random sweep after exhaustive size/low-address tests; the other
testcases explicitly cross transaction source, stall reason, translation
result, flush point, and unit-stride way. Coverage is collected per test with
`-cm line+cond+fsm+tgl+branch+assert` and merged by URG.

## Error handling and result semantics

- Any scoreboard mismatch calls `$fatal`.
- Assertions are fatal except explicitly documented interface assumptions,
  which use assumption-style diagnostics and are counted separately.
- Unknown values on a valid payload fail the testcase.
- `make preflight` fails before compilation if a feature row lacks a test,
  checker, coverage item, or result entry.
- `make regress` exits nonzero on the first failing test and preserves logs.
- The report uses only `PASS`, `FAIL`, `BLOCKED_NO_VCS`, and
  `PENDING_FULL_CHIP` result states.

## Expected design-error tests

Two tests intentionally target already source-confirmed open issues:

1. `tc_replay_halt_info_owner` expects replay debug metadata to equal the
   replayed transaction. The current AG/LRQ boundary has no saved
   `halt_info`, so a full integration run is expected to expose the owner
   mismatch until the RTL is fixed.
2. `tc_unit_stride_cross_line` issues a 512-bit unit-stride access whose active
   range crosses a 64-byte line. The current AG indexes one line only. This
   testcase is expected to fail unless the producer contract rejects/splits
   the request before AG.

These expected failures are evidence targets, not fabricated execution
results. The checked-in report records them as pending VCS/full-integration
confirmation on the current host.
