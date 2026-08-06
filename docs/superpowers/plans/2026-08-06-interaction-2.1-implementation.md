# Interaction 2.1 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Deliver at least 534 signal-accurate interaction-2.1 scenarios, independent VCS environments for seven LSU modules, and a source-grounded LSU coverage-waiver workbook, then publish the verified result to `main`.

**Architecture:** A standard-library Python framework under `verif/common` parses the non-ANSI RTL ports, generates stable interface/connection artifacts, validates feature/scenario contracts, checks standalone dependency boundaries, and aggregates per-module preflight. Each DUT owns its detailed plans, testbench, assertions, coverage, runbook, and manifest. A manifest-driven JavaScript builder edits and visually verifies the supplied XLSX with the bundled artifact runtime.

**Tech Stack:** Python 3 standard library, SystemVerilog/VCS/URG entry points, JSON/CSV/Markdown, Node.js with bundled `@oai/artifact-tool`, OOXML read-only validation, Git.

## Global Constraints

- Work only in `/Users/mjw/Documents/Codex/2026-07-11/uqjwen-ct-https-github-com-uqjwen/work/ct/.worktrees/interaction-2.1-v1` until the finishing step.
- Do not modify production files under `srcs/`.
- Preserve the legacy five-column feature-plan table required by interaction-1.7.
- Use `BLOCKED_NO_VCS` only for locally complete scenarios awaiting licensed VCS/URG execution.
- Use `PENDING_FULL_CHIP` only when production integration or a missing production dependency is required.
- Do not claim dynamic simulation or coverage closure on this host.
- Do not invent waiver specification IDs, names, approvals, dates, or function exclusions.
- Edit the XLSX only with the bundled `@oai/artifact-tool`; preserve the supplied visual template.
- Every production Python/SV behavior is preceded by a failing test. Generated interface/connection outputs are checked by drift tests.
- Commit each completed task independently; never force-push.

---

### Task 1: Shared RTL Port and Scenario Contract Library

**Files:**
- Create: `verif/common/__init__.py`
- Create: `verif/common/tools/__init__.py`
- Create: `verif/common/tools/rtl_ports.py`
- Create: `verif/common/tools/scenario_contract.py`
- Create: `tests/interaction_2_1_support.py`
- Test: `tests/test_interaction_2_1_common.py`

**Interfaces:**
- Produces: `parse_module_ports(source: str, module_name: str) -> list[Port]`
- Produces: `signal_vocabulary(*sources: str) -> set[str]`
- Produces: `load_environment(root: Path, env_name: str) -> EnvironmentContract`
- Produces: `validate_environment(contract: EnvironmentContract) -> ValidationSummary`
- Produces dataclasses: `Port`, `ModuleManifest`, `EnvironmentContract`, and `ValidationSummary(env_name, feature_count, scenario_count, minimum_scenarios, signal_count, declared_stubs, stub_results, markdown, runbook)`
- Produces test helpers: `make_contract(**overrides)`, `copy_fixture_env(destination)`, `run_gen(env, check)`, `read_detail(env_name)`, `scenario_signals(row)`, `validate_named_environment(env_name)`, and `read_manifest(path=ROOT / "waive/interaction_2_1_code_waiver_manifest.csv")`

- [ ] **Step 1: Write the failing port-parser tests**

```python
class RtlPortTests(unittest.TestCase):
    def test_parses_real_non_ansi_dc_ports_in_header_order(self):
        source = (ROOT / "srcs/xx_lsu_ld_dc.sv").read_text()
        ports = parse_module_ports(source, "xx_lsu_ld_dc")
        self.assertGreater(len(ports), 100)
        self.assertEqual("cb_ld_dc_addr_hit", ports[0].name)
        self.assertIn("cpurst_b", {port.name for port in ports})
        self.assertEqual(len(ports), len({port.name for port in ports}))
        self.assertTrue(any(p.name == "ldc_lda_ex2_inst_vld" and p.direction == "output" for p in ports))

    def test_rejects_missing_or_duplicate_declarations(self):
        bad = "module demo(a,a); input a; endmodule"
        with self.assertRaisesRegex(ValueError, "duplicate header port"):
            parse_module_ports(bad, "demo")
```

- [ ] **Step 2: Run the focused test and confirm RED**

Run: `python3 -m unittest tests.test_interaction_2_1_common.RtlPortTests -v`

Expected: import failure because `verif.common.tools.rtl_ports` does not exist.

- [ ] **Step 3: Implement the ordered non-ANSI parser**

Implement a balanced-parenthesis module-header scanner, comment stripper, declaration collector supporting optional `wire/reg/logic` and parameterized widths, duplicate/missing declaration diagnostics, and immutable `Port(name, direction, width)` objects. Do not hardcode a port count.

Implement the named test helpers in `tests/interaction_2_1_support.py` as thin fixture/read adapters. Expected values remain literal in each test; helpers may load or tokenize artifacts but may not calculate the outcome being asserted.

- [ ] **Step 4: Run the focused test and confirm GREEN**

Run: `python3 -m unittest tests.test_interaction_2_1_common.RtlPortTests -v`

Expected: both tests pass.

- [ ] **Step 5: Write failing scenario-contract tests**

```python
class ScenarioContractTests(unittest.TestCase):
    def test_rejects_unknown_signal_and_non_leaf_language(self):
        fixture = make_contract(
            trigger_condition="当 `signal_not_in_rtl=1` 时",
            expected_result="则正常处理",
        )
        with self.assertRaisesRegex(ContractError, "unknown drive or observed signal"):
            validate_environment(fixture)

    def test_requires_declared_stubs_and_exact_markdown_rows(self):
        fixture = make_contract(stub_modules=["xx_missing_dep"], declared_stubs=[])
        with self.assertRaisesRegex(ContractError, "undeclared dependency stub"):
            validate_environment(fixture)
```

- [ ] **Step 6: Run the contract test and confirm RED**

Run: `python3 -m unittest tests.test_interaction_2_1_common.ScenarioContractTests -v`

Expected: import or symbol failure because the contract validator is absent.

- [ ] **Step 7: Implement the environment validator**

Use the exact 15-column schema from the approved design. Validate contiguous IDs, parent fields, minimum counts, non-empty setup/closure, `C0:` and `C1:`, `当` and `则`, backticked real signals, checker/coverage identifiers, Markdown presence, testcase presence, allowed priorities, and allowed result states. Return counts and signal totals in `ValidationSummary`.

- [ ] **Step 8: Run focused and legacy tests**

Run: `python3 -m unittest tests.test_interaction_2_1_common tests.test_interaction_2_0_detailed_plan -v`

Expected: all focused and legacy tests pass.

- [ ] **Step 9: Commit the shared contracts**

```bash
git add verif/common tests/test_interaction_2_1_common.py
git commit -m "verif: add shared LSU scenario contracts"
```

---

### Task 2: Environment Generation and Aggregate Preflight

**Files:**
- Create: `verif/common/tools/gen_env.py`
- Create: `verif/common/tools/preflight.py`
- Create: `verif/common/templates/Makefile.in`
- Create: `verif/common/templates/interface.sv.in`
- Create: `verif/common/templates/connect.svh.in`
- Create: `verif/common/Makefile`
- Modify: `tests/test_interaction_2_1_common.py`

**Interfaces:**
- Consumes: `parse_module_ports`, `load_environment`, `validate_environment`
- Produces: `render_interface(manifest, ports) -> str`
- Produces: `render_connections(ports) -> str`
- Produces CLI: `python3 verif/common/tools/gen_env.py --env <name> [--check]`
- Produces CLI: `python3 verif/common/tools/preflight.py [--env <name>|--all]`

- [ ] **Step 1: Write failing generator drift and aggregate tests**

```python
def test_generator_check_detects_stale_interface(self):
    with tempfile.TemporaryDirectory() as td:
        env = copy_fixture_env(Path(td))
        (env / "tb/demo_if.sv").write_text("stale")
        completed = run_gen(env, check=True)
        self.assertNotEqual(0, completed.returncode)
        self.assertIn("generated file is stale", completed.stderr)

def test_aggregate_preflight_names_each_environment(self):
    completed = subprocess.run(
        [sys.executable, "verif/common/tools/preflight.py", "--all"],
        cwd=ROOT, text=True, capture_output=True,
    )
    self.assertIn("AG_PREFLIGHT_PASS", completed.stdout)
```

- [ ] **Step 2: Run and confirm RED**

Run: `python3 -m unittest tests.test_interaction_2_1_common.EnvironmentGenerationTests -v`

Expected: missing `gen_env.py`/`preflight.py` failure.

- [ ] **Step 3: Implement deterministic generation**

Generate include guards, manifest parameters, all DUT ports as `logic`, an input-only `drive_idle()` task, named port connections, and a common Makefile with `preflight/generate/compile/run/regress/coverage/clean`. `--check` compares byte-for-byte without writing.

- [ ] **Step 4: Implement structural and aggregate preflight**

Check balanced delimiters and `module/endmodule`, `interface/endinterface`, `task/endtask`, `function/endfunction`, `case/endcase`, and `begin/end`. Inspect instantiated `gated_clk_cell`/`xx_lsu_*` modules and require each to be either a production source or manifest-declared standalone stub.

- [ ] **Step 5: Generate/check AG through the shared path without changing behavior**

Add `verif/xx_lsu_ld_ag/module.json`, adapt its Makefile to call shared tools, generate its interface/connections, then run:

`python3 verif/common/tools/preflight.py --env xx_lsu_ld_ag`

Expected: existing 48-scenario AG environment passes with `AG_PREFLIGHT_PASS`.

- [ ] **Step 6: Run legacy and shared tests**

Run: `python3 -m unittest tests.test_interaction_1_9_vcs_env tests.test_interaction_2_0_detailed_plan tests.test_interaction_2_1_common -v`

Expected: all pass.

- [ ] **Step 7: Commit the generator and preflight**

```bash
git add verif/common verif/xx_lsu_ld_ag tests/test_interaction_2_1_common.py
git commit -m "verif: centralize LSU environment preflight"
```

---

### Task 3: Expand AG to the Interaction-2.1 Truth Table

**Files:**
- Modify: `verif/xx_lsu_ld_ag/coverage_matrix.csv`
- Modify: `verif/xx_lsu_ld_ag/detailed_test_plan.csv`
- Modify: `verif/xx_lsu_ld_ag/tb/xx_lsu_ld_ag_tb.sv`
- Modify: `verif/xx_lsu_ld_ag/tb/xx_lsu_ld_ag_assertions.sv`
- Modify: `doc-ag/xx_lsu_ld_ag_feature_test_plan.md`
- Modify: `doc-ag/xx_lsu_ld_ag_vcs_verification.md`
- Create: `docs/interaction-2.1-followup-review.md`
- Create: `tests/test_interaction_2_1_ag_detail.py`
- Modify: `tests/test_interaction_2_0_detailed_plan.py`

**Interfaces:**
- Keeps feature IDs `AG-FP-01` through `AG-FP-12`
- Produces scenario IDs `AG-FP-01-S01` through `AG-FP-12-S08` or later contiguous IDs
- Produces assertions `CHK_FP05_MASK_ABORT_REPLAY` and coverage `COV_FP05_MASK_ABORT_TABLE`

- [ ] **Step 1: Write the failing scenario-count and exact-path test**

```python
def test_ag_has_eight_leaf_scenarios_per_feature(self):
    rows = read_detail("xx_lsu_ld_ag")
    self.assertGreaterEqual(len(rows), 96)
    self.assertTrue(all(v >= 8 for v in Counter(r["feature_id"] for r in rows).values()))

def test_ag_contains_older_rf_abort_tlbmiss_immediate_replay(self):
    rows = read_detail("xx_lsu_ld_ag")
    matches = [r for r in rows if {
        "lag_ex1_stall_ori", "idu_lsu_rf_older_vld",
        "mmu_lsu_pa_vld", "lsu_mmu_abort",
        "lag_ex1_stall_restart_entry", "lsu_lrq_create_frz",
    } <= scenario_signals(r)]
    self.assertEqual(1, len(matches))
    self.assertIn("`lsu_mmu_abort=1`", matches[0]["trigger_condition"])
    self.assertIn("`lsu_lrq_create_frz=0`", matches[0]["expected_result"])
```

- [ ] **Step 2: Run and confirm RED**

Run: `python3 -m unittest tests.test_interaction_2_1_ag_detail -v`

Expected: 48 is less than 96 and the exact six-signal contract is absent.

- [ ] **Step 3: Add 48 curated AG leaf scenarios**

Add S05-S08 for every AG feature. For AG-FP-05, enumerate the adjacent `lag_ex1_stall_ori × idu_lsu_rf_older_vld × mmu_lsu_pa_vld × lsu_mmu_abort × lag_lrq_replay_vld × lag_lrq_create_already` outcomes. Each row names exact C0/C1/C2 drives and observed owner/freeze/restart signals.

- [ ] **Step 4: Implement the AG feature-task branch and assertion**

Add a testbench branch that drives an AG structural stall, asserts `idu_lsu_rf_older_vld`, forces a separate abort cause while `mmu_lsu_pa_vld=0`, records the created LRQ ID, and checks immediate replay ownership. Add an SVA property equivalent to:

```systemverilog
CHK_FP05_MASK_ABORT_REPLAY:
  assert property (lag_ex1_stall_ori && idu_lsu_rf_older_vld
                   && !mmu_lsu_pa_vld && lsu_mmu_abort
                   |-> !lsu_lrq_create_frz
                       && (!lag_lrq_create_already
                           || |lag_ex1_stall_restart_entry));
```

Create the abort through the prior-cycle captured TLB-miss path rather than directly driving an output. Use only signals actually connected to the assertion module; add explicit observation ports for internal `ld_ag_stall_mask` and `lag_lrq_create_already` where the truth-table checker requires them.

- [ ] **Step 5: Regenerate the Markdown scenario section from the reviewed CSV**

Keep the interaction-1.7 five-column summary unchanged. Add all 96 exact scenario IDs and complete `当`/`则` text; update the runbook and interaction report with the 96-scenario count and dynamic boundary.

Update the interaction-2.0 regression assertions from exact equality at four scenarios/48 total to lower-bound checks (`>=4` per feature and `>=48` total). This preserves the 2.0 contract while allowing the stricter 2.1 expansion; keep its mutation tests intact.

- [ ] **Step 6: Run AG tests and preflight**

Run:

```bash
python3 -m unittest tests.test_interaction_2_0_detailed_plan tests.test_interaction_2_1_ag_detail -v
python3 verif/common/tools/preflight.py --env xx_lsu_ld_ag
make -C verif/xx_lsu_ld_ag preflight
```

Expected: all pass and output includes `DETAILED_PLAN_PASS scenarios=96 per_feature_min=8`.

- [ ] **Step 7: Commit AG expansion**

```bash
git add doc-ag docs/interaction-2.1-followup-review.md verif/xx_lsu_ld_ag tests/test_interaction_2_1_ag_detail.py
git commit -m "verif: expand AG interaction 2.1 scenarios"
```

---

### Task 4: DC Detailed Plan and Standalone Environment

**Files:**
- Modify: `doc-dc/xx_lsu_ld_dc_feature_test_plan.md`
- Create: `doc-dc/xx_lsu_ld_dc_vcs_verification.md`
- Create: `verif/xx_lsu_ld_dc/module.json`
- Create: `verif/xx_lsu_ld_dc/Makefile`
- Create: `verif/xx_lsu_ld_dc/coverage_matrix.csv`
- Create: `verif/xx_lsu_ld_dc/detailed_test_plan.csv`
- Create: `verif/xx_lsu_ld_dc/tests.list`
- Create: `verif/xx_lsu_ld_dc/filelist.f`
- Create: `verif/xx_lsu_ld_dc/tb/xx_lsu_ld_dc_deps.sv`
- Create: `verif/xx_lsu_ld_dc/tb/xx_lsu_ld_dc_if.sv`
- Create: `verif/xx_lsu_ld_dc/tb/xx_lsu_ld_dc_connect.svh`
- Create: `verif/xx_lsu_ld_dc/tb/xx_lsu_ld_dc_assertions.sv`
- Create: `verif/xx_lsu_ld_dc/tb/xx_lsu_ld_dc_tb.sv`
- Create: `tests/test_interaction_2_1_dc_env.py`

**Interfaces:**
- Produces IDs `DC-FP-01-S01` through `DC-FP-12-S06`
- Declares standalone dependencies `gated_clk_cell` and `xx_lsu_compare_iid`
- Produces 12 testcases and 12 checker/coverage pairs

- [ ] **Step 1: Write the failing DC contract test**

```python
def test_dc_environment_is_leaf_complete(self):
    summary = validate_named_environment("xx_lsu_ld_dc")
    self.assertEqual(12, summary.feature_count)
    self.assertEqual(72, summary.scenario_count)
    self.assertEqual(6, summary.minimum_scenarios)
    self.assertEqual({"gated_clk_cell", "xx_lsu_compare_iid"}, summary.declared_stubs)
```

- [ ] **Step 2: Run and confirm RED**

Run: `python3 -m unittest tests.test_interaction_2_1_dc_env -v`

Expected: missing `verif/xx_lsu_ld_dc/module.json`.

- [ ] **Step 3: Add the DC manifest, feature matrix, and 72 exact scenarios**

Cover the 12 existing feature rows. Each feature receives nominal, backpressure, conflict, flush, delayed/malformed, and owner-reuse scenarios using DC RTL signals such as `lag_ldc_ex1_inst_vld`, `dcache_arb_ldc_*`, `ldc_hit_way`, `ldc_lq_ex2_create_*`, `ldc_lda_ex2_*`, and the applicable borrow/exception/forward signals verified by the shared vocabulary gate.

- [ ] **Step 4: Generate the DC interface/connections and implement testbench/assertions**

Run `python3 verif/common/tools/gen_env.py --env xx_lsu_ld_dc`, then implement 12 feature tasks and named SVA/coverage points for owner hold, borrow qualification, `$onehot0(ldc_hit_way)`, LQ accept, restart isolation, exception ownership, forward-source selection, and DC-to-DA payload stability.

- [ ] **Step 5: Complete Markdown and runbook**

Append all 72 rows to the existing feature document and document each Make target, standalone stub boundary, and expected result state.

- [ ] **Step 6: Run focused verification**

Run:

```bash
python3 -m unittest tests.test_interaction_2_1_dc_env -v
python3 verif/common/tools/preflight.py --env xx_lsu_ld_dc
make -C verif/xx_lsu_ld_dc preflight
```

Expected: `DC_PREFLIGHT_PASS features=12 scenarios=72 per_feature_min=6`.

- [ ] **Step 7: Commit DC**

```bash
git add doc-dc verif/xx_lsu_ld_dc tests/test_interaction_2_1_dc_env.py
git commit -m "verif: add detailed DC environment"
```

---

### Task 5: DA Detailed Plan and Standalone Environment

**Files:**
- Modify: `doc-da/xx_lsu_ld_da_feature_test_plan.md`
- Create: `doc-da/xx_lsu_ld_da_vcs_verification.md`
- Create: `verif/xx_lsu_ld_da/module.json`
- Create: `verif/xx_lsu_ld_da/Makefile`
- Create: `verif/xx_lsu_ld_da/coverage_matrix.csv`
- Create: `verif/xx_lsu_ld_da/detailed_test_plan.csv`
- Create: `verif/xx_lsu_ld_da/tests.list`
- Create: `verif/xx_lsu_ld_da/filelist.f`
- Create: `verif/xx_lsu_ld_da/tb/xx_lsu_ld_da_deps.sv`
- Create: `verif/xx_lsu_ld_da/tb/xx_lsu_ld_da_if.sv`
- Create: `verif/xx_lsu_ld_da/tb/xx_lsu_ld_da_connect.svh`
- Create: `verif/xx_lsu_ld_da/tb/xx_lsu_ld_da_assertions.sv`
- Create: `verif/xx_lsu_ld_da/tb/xx_lsu_ld_da_tb.sv`
- Create: `tests/test_interaction_2_1_da_env.py`

**Interfaces:**
- Produces IDs `DA-FP-01-S01` through `DA-FP-12-S06`
- Declares gated-clock, IID compare, rotate, and ECC decoder standalone boundaries
- Produces 12 testcases and 12 checker/coverage pairs

- [ ] **Step 1: Write the failing DA contract test**

```python
def test_da_environment_covers_four_block_data_and_terminal_states(self):
    summary = validate_named_environment("xx_lsu_ld_da")
    self.assertEqual((12, 72, 6), (
        summary.feature_count, summary.scenario_count, summary.minimum_scenarios,
    ))
    text = summary.markdown
    for token in ("四块互异数据", "completion", "RB create", "LQ pop", "唯一终态"):
        self.assertIn(token, text)
```

- [ ] **Step 2: Run and confirm RED**

Run: `python3 -m unittest tests.test_interaction_2_1_da_env -v`

Expected: missing DA environment.

- [ ] **Step 3: Add 12 parent rows and 72 signal-level DA scenarios**

Use exact inputs/outputs for cache-bank selection, SQ/WMB forwarding, ECC, delayed access fault, LQ pop, RB create/merge, completion/data requests, exception/restart terminal state, dependency wakeup, debug, and flush/clock. Every data scenario uses four different 128-bit patterns and checks the applicable block/mask owner.

- [ ] **Step 4: Generate and implement the DA harness**

Generate the interface/connections; declare each compatibility decoder/rotator in the manifest; implement feature tasks and SVA for req/DP/gate implications, delayed-fault IID ownership, one terminal side effect, hold-until-grant, and zero side effects after flush.

- [ ] **Step 5: Complete the DA Markdown/runbook and verify**

Run:

```bash
python3 -m unittest tests.test_interaction_2_1_da_env -v
python3 verif/common/tools/preflight.py --env xx_lsu_ld_da
make -C verif/xx_lsu_ld_da preflight
```

Expected: `DA_PREFLIGHT_PASS features=12 scenarios=72 per_feature_min=6`.

- [ ] **Step 6: Commit DA**

```bash
git add doc-da verif/xx_lsu_ld_da tests/test_interaction_2_1_da_env.py
git commit -m "verif: add detailed DA environment"
```

---

### Task 6: WB Detailed Plan and Standalone Environment

**Files:**
- Modify: `doc-wb/xx_lsu_ld_wb_feature_test_plan.md`
- Create: `doc-wb/xx_lsu_ld_wb_vcs_verification.md`
- Create: `verif/xx_lsu_ld_wb/module.json`
- Create: `verif/xx_lsu_ld_wb/Makefile`
- Create: `verif/xx_lsu_ld_wb/coverage_matrix.csv`
- Create: `verif/xx_lsu_ld_wb/detailed_test_plan.csv`
- Create: `verif/xx_lsu_ld_wb/tests.list`
- Create: `verif/xx_lsu_ld_wb/filelist.f`
- Create: `verif/xx_lsu_ld_wb/tb/xx_lsu_ld_wb_deps.sv`
- Create: `verif/xx_lsu_ld_wb/tb/xx_lsu_ld_wb_if.sv`
- Create: `verif/xx_lsu_ld_wb/tb/xx_lsu_ld_wb_connect.svh`
- Create: `verif/xx_lsu_ld_wb/tb/xx_lsu_ld_wb_assertions.sv`
- Create: `verif/xx_lsu_ld_wb/tb/xx_lsu_ld_wb_tb.sv`
- Create: `tests/test_interaction_2_1_wb_env.py`

**Interfaces:**
- Produces IDs `WB-FP-01-S01` through `WB-FP-12-S06`
- Declares gated-clock and IID comparison boundaries
- Produces 12 testcases and 12 checker/coverage pairs

- [ ] **Step 1: Write the failing WB contract test**

```python
def test_wb_environment_covers_arbitration_implications_and_no_starvation_contract(self):
    summary = validate_named_environment("xx_lsu_ld_wb")
    self.assertEqual(72, summary.scenario_count)
    for text in ("req=1", "DP=1", "gate=1", "DP-only", "任意空闲lane", "不会丢失"):
        self.assertIn(text, summary.markdown)
```

- [ ] **Step 2: Run and confirm RED**

Run: `python3 -m unittest tests.test_interaction_2_1_wb_env -v`

Expected: missing WB environment.

- [ ] **Step 3: Add WB scenarios and environment**

Write six exact leaves for all 12 WB features. Include DA/RB completion arbitration, DA/WMB/VMB/RB data arbitration, `req -> DP -> gate`, DP-only, scalar/vector formatting, RTU completion, error data suppression, VMB metadata, halt-info self-clocked clear, forward winner, flush age, and ICG/scan reset.

- [ ] **Step 4: Generate harness, add assertions, and document the arbiter boundary**

Connect `xx_lsu_wb_arbiter` where required by the production path or declare the exact standalone arbitration model boundary. Assertions check one-hot grants, loser payload stability, req/DP/gate implications, actual-winner forwarding, and zero data-valid on error.

- [ ] **Step 5: Verify WB**

Run:

```bash
python3 -m unittest tests.test_interaction_2_1_wb_env -v
python3 verif/common/tools/preflight.py --env xx_lsu_ld_wb
make -C verif/xx_lsu_ld_wb preflight
```

Expected: `WB_PREFLIGHT_PASS features=12 scenarios=72 per_feature_min=6`.

- [ ] **Step 6: Commit WB**

```bash
git add doc-wb verif/xx_lsu_ld_wb tests/test_interaction_2_1_wb_env.py
git commit -m "verif: add detailed WB environment"
```

---

### Task 7: RB Detailed Plan and Entry-Aware Environment

**Files:**
- Modify: `doc-rb/xx_lsu_rb_feature_test_plan.md`
- Create: `doc-rb/xx_lsu_rb_vcs_verification.md`
- Create: `verif/xx_lsu_rb/module.json`
- Create: `verif/xx_lsu_rb/Makefile`
- Create: `verif/xx_lsu_rb/coverage_matrix.csv`
- Create: `verif/xx_lsu_rb/detailed_test_plan.csv`
- Create: `verif/xx_lsu_rb/tests.list`
- Create: `verif/xx_lsu_rb/filelist.f`
- Create: `verif/xx_lsu_rb/tb/xx_lsu_rb_deps.sv`
- Create: `verif/xx_lsu_rb/tb/xx_lsu_rb_if.sv`
- Create: `verif/xx_lsu_rb/tb/xx_lsu_rb_connect.svh`
- Create: `verif/xx_lsu_rb/tb/xx_lsu_rb_assertions.sv`
- Create: `verif/xx_lsu_rb/tb/xx_lsu_rb_tb.sv`
- Create: `tests/test_interaction_2_1_rb_env.py`

**Interfaces:**
- Produces IDs `RB-FP-01-S01` through `RB-FP-12-S06`
- Includes production `srcs/xx_lsu_rb_entry.sv` in the filelist
- Declares FIFO, encoder, rotate, pending-address, gated-clock, and entry dependencies explicitly

- [ ] **Step 1: Write the failing RB lifecycle and response-owner test**

```python
def test_rb_environment_tracks_generation_rid_and_entry_lifecycle(self):
    summary = validate_named_environment("xx_lsu_rb")
    self.assertEqual((12, 72), (summary.feature_count, summary.scenario_count))
    for token in ("{entry, IID, generation, BIU ID, owner}", "恰好两拍", "B response", "async flush"):
        self.assertIn(token, summary.markdown)
```

- [ ] **Step 2: Run and confirm RED**

Run: `python3 -m unittest tests.test_interaction_2_1_rb_env -v`

Expected: missing RB environment.

- [ ] **Step 3: Add the 72 RB/entry scenarios**

Cover pointer capacity, create winner, entry transitions, merge/boundary, BIU request attributes/ID, LFB RID binding, exactly-two-beat unit-stride R responses, paired B responses, SO FIFO, WB backpressure, sync/check/debug-async flush, and clock/reset. Add negative wrong-ID/early-B/late-old-response leaves without assuming the environment will silently accept them.

- [ ] **Step 4: Generate and implement entry-aware harness/assertions**

Use `{entry,IID,generation,RID,owner}` scoreboard state. Assertions cover unique accepted pointer, valid state transition, request hold, response owner, exactly two unit-stride beats, paired B acceptance, and old-generation response rejection.

- [ ] **Step 5: Verify RB**

Run:

```bash
python3 -m unittest tests.test_interaction_2_1_rb_env -v
python3 verif/common/tools/preflight.py --env xx_lsu_rb
make -C verif/xx_lsu_rb preflight
```

Expected: `RB_PREFLIGHT_PASS features=12 scenarios=72 per_feature_min=6`.

- [ ] **Step 6: Commit RB**

```bash
git add doc-rb verif/xx_lsu_rb tests/test_interaction_2_1_rb_env.py
git commit -m "verif: add detailed RB environment"
```

---

### Task 8: LRQ Detailed Plan and Entry-Aware Environment

**Files:**
- Modify: `doc-lrq/xx_lsu_lrq_feature_test_plan.md`
- Create: `doc-lrq/xx_lsu_lrq_vcs_verification.md`
- Create: `verif/xx_lsu_lrq/module.json`
- Create: `verif/xx_lsu_lrq/Makefile`
- Create: `verif/xx_lsu_lrq/coverage_matrix.csv`
- Create: `verif/xx_lsu_lrq/detailed_test_plan.csv`
- Create: `verif/xx_lsu_lrq/tests.list`
- Create: `verif/xx_lsu_lrq/filelist.f`
- Create: `verif/xx_lsu_lrq/tb/xx_lsu_lrq_deps.sv`
- Create: `verif/xx_lsu_lrq/tb/xx_lsu_lrq_if.sv`
- Create: `verif/xx_lsu_lrq/tb/xx_lsu_lrq_connect.svh`
- Create: `verif/xx_lsu_lrq/tb/xx_lsu_lrq_assertions.sv`
- Create: `verif/xx_lsu_lrq/tb/xx_lsu_lrq_tb.sv`
- Create: `tests/test_interaction_2_1_lrq_env.py`

**Interfaces:**
- Produces IDs `LRQ-FP-01-S01` through `LRQ-FP-12-S06`
- Includes production `srcs/xx_lsu_lrq_entry.sv`
- Uses `{bank,entry,IID,generation}` owner tracking

- [ ] **Step 1: Write the failing LRQ owner-generation test**

```python
def test_lrq_environment_covers_flush_create_and_late_wakeup_reuse(self):
    summary = validate_named_environment("xx_lsu_lrq")
    self.assertEqual(72, summary.scenario_count)
    for token in ("create_vld=1", "flush", "create_success=0", "旧 owner", "entry复用", "wakeup"):
        self.assertIn(token, summary.markdown)
```

- [ ] **Step 2: Run and confirm RED**

Run: `python3 -m unittest tests.test_interaction_2_1_lrq_env -v`

Expected: missing LRQ environment.

- [ ] **Step 3: Add 72 LRQ/entry leaves**

Explicitly cover no-space precheck, create-vld with flush-caused no-success, payload retention, all freeze reasons, live/killed/reused wakeup bits, oldest issue, replay-no-recreate, barrier/no-spec release, DA feedback, flush age/wrap, entry clocking, and `LRQENTRY=LSIQENTRY` elaboration contract.

- [ ] **Step 4: Generate and implement the bank/entry harness**

Add per-bank entry generations and assert `wakeup[bit] -> entry_vld[bit] && owner_generation_match`, accepted create one-hot, replay payload stability, zero create on replay, and no killed-entry issue.

- [ ] **Step 5: Verify LRQ**

Run:

```bash
python3 -m unittest tests.test_interaction_2_1_lrq_env -v
python3 verif/common/tools/preflight.py --env xx_lsu_lrq
make -C verif/xx_lsu_lrq preflight
```

Expected: `LRQ_PREFLIGHT_PASS features=12 scenarios=72 per_feature_min=6`.

- [ ] **Step 6: Commit LRQ**

```bash
git add doc-lrq verif/xx_lsu_lrq tests/test_interaction_2_1_lrq_env.py
git commit -m "verif: add detailed LRQ environment"
```

---

### Task 9: LFB Detailed Plan and Missing-Data-Entry Boundary

**Files:**
- Modify: `doc-lfb/xx_lsu_lfb_feature_test_plan.md`
- Create: `doc-lfb/xx_lsu_lfb_vcs_verification.md`
- Create: `verif/xx_lsu_lfb/module.json`
- Create: `verif/xx_lsu_lfb/Makefile`
- Create: `verif/xx_lsu_lfb/coverage_matrix.csv`
- Create: `verif/xx_lsu_lfb/detailed_test_plan.csv`
- Create: `verif/xx_lsu_lfb/tests.list`
- Create: `verif/xx_lsu_lfb/filelist.f`
- Create: `verif/xx_lsu_lfb/tb/xx_lsu_lfb_deps.sv`
- Create: `verif/xx_lsu_lfb/tb/xx_lsu_lfb_if.sv`
- Create: `verif/xx_lsu_lfb/tb/xx_lsu_lfb_connect.svh`
- Create: `verif/xx_lsu_lfb/tb/xx_lsu_lfb_assertions.sv`
- Create: `verif/xx_lsu_lfb/tb/xx_lsu_lfb_tb.sv`
- Create: `tests/test_interaction_2_1_lfb_env.py`

**Interfaces:**
- Produces IDs `LFB-FP-01-S01` through `LFB-FP-13-S06`
- Includes production `srcs/xx_lsu_lfb_addr_entry.sv`
- Declares `xx_lsu_lfb_data_entry` as `PENDING_FULL_CHIP` and provides a named standalone behavioral compatibility module

- [ ] **Step 1: Write the failing LFB count and dependency-boundary test**

```python
def test_lfb_environment_is_complete_and_names_missing_data_entry(self):
    summary = validate_named_environment("xx_lsu_lfb")
    self.assertEqual((13, 78, 6), (
        summary.feature_count, summary.scenario_count, summary.minimum_scenarios,
    ))
    self.assertEqual("PENDING_FULL_CHIP", summary.stub_results["xx_lsu_lfb_data_entry"])
    self.assertIn("srcs/xx_lsu_lfb_data_entry.sv", summary.runbook)
```

- [ ] **Step 2: Run and confirm RED**

Run: `python3 -m unittest tests.test_interaction_2_1_lfb_env -v`

Expected: missing LFB environment.

- [ ] **Step 3: Add 78 LFB/address-entry/data-boundary scenarios**

Cover RB/PFU allocation, address lifecycle and immediate reuse, line match, address/data ID binding, BIU beat/last/error, VB result, refill way/data/ECC, all-response accounting, dependency wakeup, SNQ bypass, flush with outstanding response, capacity counters, and clock/reset.

- [ ] **Step 4: Generate and implement the LFB harness**

Use different patterns for both data entries and all refill blocks. Assertions check address/data owner match, valid ID response, last/beat contract, refill-way one-hot, dependency generation, and no wakeup for flushed owners. The compatibility data-entry module must be clearly named in `module.json` and the runbook and may not be reported as production signoff.

- [ ] **Step 5: Verify LFB**

Run:

```bash
python3 -m unittest tests.test_interaction_2_1_lfb_env -v
python3 verif/common/tools/preflight.py --env xx_lsu_lfb
make -C verif/xx_lsu_lfb preflight
```

Expected: `LFB_PREFLIGHT_PASS features=13 scenarios=78 per_feature_min=6`.

- [ ] **Step 6: Commit LFB**

```bash
git add doc-lfb verif/xx_lsu_lfb tests/test_interaction_2_1_lfb_env.py
git commit -m "verif: add detailed LFB environment"
```

---

### Task 10: Waiver Manifest and Source-Grounded XLSX

**Files:**
- Create: `waive/interaction_2_1_code_waiver_manifest.csv`
- Modify: `waive/08-xxx_代码与功能覆盖率排除列表.xlsx`
- Create: `tools/build_interaction_2_1_waiver.mjs`
- Create: `tools/check_interaction_2_1_waiver.py`
- Create: `tests/test_interaction_2_1_waiver.py`

**Interfaces:**
- Manifest columns: `coverage_type,source_object,repo_mapping,module,condition,reason,impact,alternative,property,term,source_section,remarks`
- Produces checker CLI: `python3 tools/check_interaction_2_1_waiver.py`
- Builder imports the supplied workbook and exports back to the same repository path after verification

- [ ] **Step 1: Build the reviewed source manifest from the DOCX**

Transcribe every distinct `line`, `branch`, `condition`, `toggle`, and `fsm` item from sections 1.1 through 1.21. Preserve explicit grouped “同理排除” references in one manifest row. Record the DOCX section and historical `wk_lsu_*` object, plus the repository `xx_lsu_*` mapping when present. Do not add a function-waiver record for chapter-two placeholders.

- [ ] **Step 2: Write the failing workbook checker test**

```python
def test_workbook_matches_source_manifest_and_has_no_examples(self):
    completed = subprocess.run(
        [sys.executable, "tools/check_interaction_2_1_waiver.py"],
        cwd=ROOT, text=True, capture_output=True,
    )
    self.assertEqual(0, completed.returncode, completed.stderr)
    self.assertIn("WAIVER_WORKBOOK_PASS", completed.stdout)
    self.assertNotIn("CP0", completed.stdout)

def test_manifest_has_only_documented_lsu_coverage_types(self):
    rows = read_manifest()
    self.assertGreater(len(rows), 50)
    self.assertEqual({"line", "branch", "condition", "toggle", "fsm"}, {r["coverage_type"] for r in rows})
    self.assertTrue(all(r["source_section"].startswith("1.") for r in rows))
```

- [ ] **Step 3: Run and confirm RED**

Run: `python3 -m unittest tests.test_interaction_2_1_waiver -v`

Expected: checker missing or existing workbook still contains CP0 examples and does not match the manifest.

- [ ] **Step 4: Implement the OOXML checker**

Using only `zipfile` and `xml.etree.ElementTree`, resolve shared/inline strings, merged cells, both worksheets, and used rows. Assert exact code-waiver row count and key values against the manifest, absence of CP0/example names, no populated function-waiver data rows, no blank required manifest fields, and preserved 17-column headers.

- [ ] **Step 5: Implement the artifact-tool workbook builder**

Use the bundled runtime paths returned by `codex_app__load_workspace_dependencies`. Import the existing XLSX; render both sheets before editing; clear example rows; write the manifest into “代码waiver”; leave “功能waiver” with two header rows; preserve merged K1:L1, M1:N1, O1:P1 and the template's styles; set wrapped text and bounded widths/heights; freeze the two header rows; export to the repository file.

- [ ] **Step 6: Inspect and render the final workbook**

Run artifact-tool `inspect` on all populated ranges, scan `#REF!|#DIV/0!|#VALUE!|#NAME?|#N/A`, render both sheets at readable scale, and inspect both PNGs. Correct clipping or excessive row/column sizing before final export.

- [ ] **Step 7: Run workbook tests/checker**

Run:

```bash
python3 -m unittest tests.test_interaction_2_1_waiver -v
python3 tools/check_interaction_2_1_waiver.py
```

Expected: `WAIVER_WORKBOOK_PASS` with manifest/workbook row counts and zero function-waiver claims.

- [ ] **Step 8: Commit waiver artifacts**

```bash
git add waive tools/build_interaction_2_1_waiver.mjs tools/check_interaction_2_1_waiver.py tests/test_interaction_2_1_waiver.py
git commit -m "docs: populate LSU coverage waiver workbook"
```

---

### Task 11: Aggregate Completeness, Report, and Licensed-Tool Boundary

**Files:**
- Modify: `docs/interaction-2.1-followup-review.md`
- Modify: `verif/common/Makefile`
- Create: `tests/test_interaction_2_1_delivery.py`

**Interfaces:**
- Produces aggregate marker: `INTERACTION_2_1_PREFLIGHT_PASS environments=7 features=85 scenarios>=534`
- Produces report sections: local static evidence, `BLOCKED_NO_VCS`, `PENDING_FULL_CHIP`, waiver inventory, and licensed-host commands

- [ ] **Step 1: Write the failing aggregate delivery test**

```python
def test_interaction_2_1_aggregate_delivery(self):
    completed = subprocess.run(
        [sys.executable, "verif/common/tools/preflight.py", "--all"],
        cwd=ROOT, text=True, capture_output=True,
    )
    self.assertEqual(0, completed.returncode, completed.stderr)
    self.assertRegex(completed.stdout, r"INTERACTION_2_1_PREFLIGHT_PASS environments=7 features=85 scenarios=(53[4-9]|5[4-9][0-9]|[6-9][0-9]{2,})")
```

- [ ] **Step 2: Run and confirm RED**

Run: `python3 -m unittest tests.test_interaction_2_1_delivery -v`

Expected: aggregate marker/report not yet complete.

- [ ] **Step 3: Implement aggregate reporting**

Sum module summaries, fail if any module is missing or below its approved minimum, and print one deterministic marker. Complete the follow-up report with per-module counts, paths, testcases, dependency boundaries, waiver counts, and exact licensed-host commands.

- [ ] **Step 4: Run all tests and all preflights**

Run:

```bash
python3 -m unittest discover -s tests -v
python3 verif/common/tools/preflight.py --all
make -C verif/common preflight
python3 tools/check_interaction_2_1_waiver.py
git diff --check
```

Expected: all commands exit 0 and aggregate totals are at least seven environments, 85 features, and 534 scenarios.

- [ ] **Step 5: Probe the licensed-tool boundary**

Run: `make -C verif/common compile`

Expected on this host: preflight succeeds first, then the command exits nonzero with `Synopsys VCS not found`; the report records this as `BLOCKED_NO_VCS` and does not claim compilation or simulation.

- [ ] **Step 6: Check production RTL and repository cleanliness**

Run:

```bash
git diff origin/main...HEAD -- srcs
git status -sb
```

Expected: no `srcs/` diff; only intended interaction-2.1 artifacts are present and committed after the next step.

- [ ] **Step 7: Commit final integration evidence**

```bash
git add docs/interaction-2.1-followup-review.md verif/common/Makefile tests/test_interaction_2_1_delivery.py
git commit -m "verif: close interaction 2.1 static completeness"
```

---

### Task 12: Final Review, Fast-Forward Main, and Push

**Files:**
- No new deliverable files; this task validates and publishes the reviewed commits.

**Interfaces:**
- Consumes: clean `review/interaction-2.1-v1`
- Produces: non-force updated `origin/main`

- [ ] **Step 1: Invoke the completion and branch-finishing skills**

Read and follow `verification-before-completion` and `finishing-a-development-branch` before making any completion or publication claim.

- [ ] **Step 2: Fetch and reconcile remote main**

Run:

```bash
git fetch origin main --prune
git log --oneline --left-right main...origin/main
```

If remote moved, inspect every new commit and rebase or merge without force. Re-run the complete verification commands after reconciliation.

- [ ] **Step 3: Run fresh final verification**

Run the complete Task 11 Step 4 command set again in the final commit state. Render and inspect the final workbook sheets again if reconciliation changed the XLSX or its manifest.

- [ ] **Step 4: Fast-forward local main**

From the primary checkout:

```bash
git merge --ff-only review/interaction-2.1-v1
```

Expected: `main` advances without a merge commit.

- [ ] **Step 5: Push without force and verify remote equality**

Run:

```bash
git push origin main
git fetch origin main
git rev-list --left-right --count main...origin/main
git status -sb
```

Expected: ahead/behind is `0 0` and the primary checkout is clean.

- [ ] **Step 6: Report exact evidence and remaining dynamic work**

Provide commit hash/link, scenario totals, test/preflight results, workbook citation, and the explicit VCS/URG/full-chip boundaries. Do not describe blocked dynamic execution as a pass.
