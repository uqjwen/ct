# Interaction 2.0 Detailed Test Plan Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Deliver an implementation-ready, signal-accurate `xx_lsu_ld_ag` test plan with at least 48 “当 …，则 …” scenarios and a machine-enforced completeness gate.

**Architecture:** Keep `coverage_matrix.csv` as the twelve-feature anchor and add `detailed_test_plan.csv` as the scenario-level source of truth. Expand the Markdown feature plan for engineers, then make `check_completeness.py` cross-check scenario schema, parent mappings, signal vocabulary, and documentation coverage against the delivered RTL and verification sources.

**Tech Stack:** Python 3 standard library, CSV, unittest, Markdown, GNU Make, SystemVerilog source inspection, git.

## Global Constraints

- Scope is `xx_lsu_ld_ag`, continuing interaction 1.9.
- Keep feature IDs `AG-FP-01` through `AG-FP-12` and existing testcase/checker/coverage anchors stable.
- Provide at least four detailed scenarios per feature and at least 48 scenarios total.
- Every trigger begins with “当”; every expectation begins with “则”.
- Every scenario names exact drive and expected signal identifiers and an explicit C0/C1-or-later sequence.
- Result states remain only `BLOCKED_NO_VCS` or `PENDING_FULL_CHIP`.
- Do not modify any file under `srcs/`.
- Do not claim VCS simulation or URG coverage without an actual licensed run.
- Preserve one final delivery commit by amending the already committed design/plan commit during implementation.

---

### Task 1: Add the failing interaction 2.0 contract test

**Files:**
- Create: `tests/test_interaction_2_0_detailed_plan.py`

**Interfaces:**
- Consumes: repository files rooted at `Path(__file__).resolve().parents[1]`
- Produces: unittest contract for detailed scenario count, schema, validator behavior, report boundary, and no RTL changes

- [ ] **Step 1: Write the failing artifact and validator tests**

Create a unittest module that imports `verif/xx_lsu_ld_ag/tools/check_completeness.py` with `importlib.util`, reads the detailed CSV with `csv.DictReader`, and includes these observable checks:

```python
EXPECTED_COLUMNS = (
    "scenario_id", "feature_id", "scenario", "testcase", "priority",
    "setup", "drive_signals", "cycle_sequence", "trigger_condition",
    "expected_signals", "expected_result", "checker", "coverage",
    "closure", "result",
)

def test_every_feature_has_four_directly_implementable_scenarios(self):
    rows = self.read_rows()
    self.assertGreaterEqual(len(rows), 48)
    self.assertEqual(EXPECTED_COLUMNS, tuple(rows[0]))
    counts = collections.Counter(row["feature_id"] for row in rows)
    self.assertEqual(set(FEATURE_IDS), set(counts))
    self.assertTrue(all(counts[feature_id] >= 4 for feature_id in FEATURE_IDS))

def test_completeness_rejects_unknown_signal(self):
    rows, parents, signals, plan = self.validation_inputs()
    mutated = [dict(row) for row in rows]
    mutated[0]["drive_signals"] = "signal_that_is_not_delivered"
    with self.assertRaisesRegex(RuntimeError, "unknown drive signal"):
        self.module.validate_detailed_rows(mutated, parents, signals, plan)
```

Also mutate a parent mapping and the “当/则” grammar, then assert the real validator rejects each mutation. Run the completeness script as a subprocess and require `DETAILED_PLAN_PASS` on the completed tree.

- [ ] **Step 2: Run the focused test and verify RED**

Run:

```bash
python3 -m unittest discover -s tests -p 'test_interaction_2_0_detailed_plan.py' -v
```

Expected: FAIL because `detailed_test_plan.csv`, the validator interface, and the interaction 2.0 report do not exist.

- [ ] **Step 3: Preserve the RED evidence without committing broken production artifacts**

Record the focused failure in the task commentary. Do not weaken assertions or add placeholder files to make the test pass.

---

### Task 2: Add the 48-scenario source of truth and human plan

**Files:**
- Create: `verif/xx_lsu_ld_ag/detailed_test_plan.csv`
- Modify: `doc-ag/xx_lsu_ld_ag_feature_test_plan.md`

**Interfaces:**
- Consumes: parent rows from `verif/xx_lsu_ld_ag/coverage_matrix.csv`, exact identifiers from the DUT/interface/testbench, existing twelve testcase names
- Produces: 48 unique scenario rows `AG-FP-01-S01` through `AG-FP-12-S04` and matching engineer-facing Markdown sections

- [ ] **Step 1: Populate four signal-accurate scenarios per feature**

Use this exact CSV header:

```csv
scenario_id,feature_id,scenario,testcase,priority,setup,drive_signals,cycle_sequence,trigger_condition,expected_signals,expected_result,checker,coverage,closure,result
```

For each feature, cover these four behavior classes:

```text
AG-FP-01 fresh capture; stalled owner hold; replay payload ownership; flush/capture arbitration
AG-FP-02 size/mask sweep; signed negative offset; forward 4 KiB crossing; reverse 4 KiB crossing
AG-FP-03 same-cycle MMU hit; accepted miss; page-fault abort; next-cycle access-fault response
AG-FP-04 stalled page-fault persistence; delayed access-fault persistence; fault priority; drain/reset clearing
AG-FP-05 fresh D-cache rejection; replay rejection; TLB-miss restart during stall; fault abort during stall
AG-FP-06 cacheable bank request; D-cache disabled suppression; NC/SO attributes with speculative request; borrow/backpressure hold
AG-FP-07 one-hot way capture; fixed tag/data phases; scalar-after-unit-stride isolation; cross-line index finding
AG-FP-08 atomic misalign; page-fault priority; access-fault encoding; LDAMO non-cacheable encoding
AG-FP-09 fresh miss creates frozen owner; ready fresh create; replay no-duplicate; flush cancels late create
AG-FP-10 standalone TCM boundary; atomic before commit; matching commit; non-matching commit
AG-FP-11 vmew values 0, 1, 2, and 3 with split/unit-stride masks
AG-FP-12 full flush; selective check flush; scan-enabled capture; late MMU result after flush
```

Every `drive_signals` and `expected_signals` value is pipe-separated and appears as an identifier in delivered SystemVerilog. Every `cycle_sequence` includes concrete `C0:` and `C1:` operations. The four parent fields `testcase`, `checker`, `coverage`, and `result` exactly match the feature row.

- [ ] **Step 2: Expand the Markdown plan**

Replace the summary-only document with an implementation contract followed by twelve sections. Each section contains its four scenario IDs and exact wording in this form:

```markdown
| `AG-FP-03-S02` | C0 drive `mmu_lsu_pa_vld=0`; C1 sample | 当 `lsu_mmu_va_vld=1` 且 `mmu_lsu_pa_vld=0` 时 | 则 `lag_ldc_ex1_utlb_miss=1`，并由 `lsu_lrq_create_frz=1` 保留 owner | `CHK_FP03_MMU_OWNER` / `COV_FP03_MMU_RESULT` |
```

State that each row is ready to be added to the named existing testcase task, but the detailed-plan count is not a claim that every row has run under VCS.

- [ ] **Step 3: Run the focused test to observe the next intended failure**

Run the focused unittest again. Expected: artifact/schema/count checks progress, while validator/report checks remain RED because Task 3 and Task 4 are not implemented.

- [ ] **Step 4: Amend the design commit**

```bash
git add verif/xx_lsu_ld_ag/detailed_test_plan.csv doc-ag/xx_lsu_ld_ag_feature_test_plan.md tests/test_interaction_2_0_detailed_plan.py docs/superpowers/plans/2026-08-03-interaction-2.0-detailed-test-plan.md
git commit --amend --no-edit
```

---

### Task 3: Enforce scenario completeness and signal traceability

**Files:**
- Modify: `verif/xx_lsu_ld_ag/tools/check_completeness.py`
- Modify: `tests/test_interaction_2_0_detailed_plan.py`

**Interfaces:**
- Consumes: `list[dict[str, str]]` detailed rows, `dict[str, dict[str, str]]` parent rows, `set[str]` known signal tokens, Markdown plan text
- Produces: `validate_detailed_rows(rows, parents, known_signals, plan_text) -> collections.Counter[str]` and CLI output `DETAILED_PLAN_PASS scenarios=48 per_feature_min=4`

- [ ] **Step 1: Implement the minimal validator API**

Add constants and functions with these signatures:

```python
DETAIL_COLUMNS = (
    "scenario_id", "feature_id", "scenario", "testcase", "priority",
    "setup", "drive_signals", "cycle_sequence", "trigger_condition",
    "expected_signals", "expected_result", "checker", "coverage",
    "closure", "result",
)

def signal_vocabulary(*sources: str) -> set[str]:
    return set(re.findall(r"\b[A-Za-z_][A-Za-z0-9_]*\b", "\n".join(sources)))

def validate_detailed_rows(
    rows: list[dict[str, str]],
    parents: dict[str, dict[str, str]],
    known_signals: set[str],
    plan_text: str,
) -> Counter[str]:
    if not rows or tuple(rows[0]) != DETAIL_COLUMNS:
        fail("detailed plan schema mismatch")
    counts: Counter[str] = Counter()
    seen: set[str] = set()
    for row in rows:
        scenario_id = row["scenario_id"]
        feature_id = row["feature_id"]
        if scenario_id in seen:
            fail(f"duplicate scenario ID: {scenario_id}")
        if feature_id not in parents:
            fail(f"unknown parent feature: {feature_id}")
        if not row["trigger_condition"].startswith("当"):
            fail(f"{scenario_id}: trigger must begin with 当")
        if not row["expected_result"].startswith("则"):
            fail(f"{scenario_id}: expected result must begin with 则")
        if "C0:" not in row["cycle_sequence"] or "C1:" not in row["cycle_sequence"]:
            fail(f"{scenario_id}: cycle sequence must name C0 and C1")
        for field in ("drive_signals", "expected_signals"):
            label = "drive signal" if field == "drive_signals" else "expected signal"
            for signal in row[field].split("|"):
                if signal not in known_signals:
                    fail(f"{scenario_id}: unknown {label} {signal}")
        if scenario_id not in plan_text:
            fail(f"{scenario_id}: missing from Markdown plan")
        seen.add(scenario_id)
        counts[feature_id] += 1
    for feature_id in parents:
        if counts[feature_id] < 4:
            fail(f"{feature_id}: fewer than four detailed scenarios")
    return counts
```

The function raises `RuntimeError` through `fail()` for wrong schema, duplicate or malformed IDs, parent mismatches, fewer than four rows, missing C0/C1 timing, wrong “当/则” grammar, empty closure, unknown signal, or missing Markdown scenario ID. It returns counts only after all rows pass.

- [ ] **Step 2: Wire validation into `main()`**

Load `detailed_test_plan.csv`, build a parent dictionary from the existing feature rows, build the signal vocabulary from the DUT plus `tb/*.sv` and `tb/*.svh`, validate the human plan, then print:

```python
print(
    "DETAILED_PLAN_PASS "
    f"scenarios={len(detail_rows)} per_feature_min={min(counts.values())}"
)
```

Keep the existing `COMPLETENESS_PASS features=12 tests=12 checkers=12 coverage_items=12` output.

- [ ] **Step 3: Run focused tests and verify GREEN for validator behavior**

Run:

```bash
python3 -m unittest discover -s tests -p 'test_interaction_2_0_detailed_plan.py' -v
```

Expected: validator mutation tests pass; only the missing interaction 2.0 report may remain RED until Task 4.

- [ ] **Step 4: Run preflight**

Run:

```bash
make -C verif/xx_lsu_ld_ag preflight
```

Expected output includes `COMPLETENESS_PASS`, `DETAILED_PLAN_PASS scenarios=48 per_feature_min=4`, and `REFERENCE_MODEL_PASS cases=211 source_findings=3`.

- [ ] **Step 5: Amend the delivery commit**

```bash
git add verif/xx_lsu_ld_ag/tools/check_completeness.py tests/test_interaction_2_0_detailed_plan.py
git commit --amend --no-edit
```

---

### Task 4: Update runbook and interaction 2.0 closure report

**Files:**
- Modify: `doc-ag/xx_lsu_ld_ag_vcs_verification.md`
- Create: `docs/interaction-2.0-followup-review.md`

**Interfaces:**
- Consumes: detailed-plan count, validator output, existing make targets, actual local tool availability
- Produces: engineer workflow and evidence-bounded completion report

- [ ] **Step 1: Add runbook instructions**

Document that `detailed_test_plan.csv` is the scenario source of truth, explain each field, map a scenario into its parent `+TEST=` task, and retain these commands:

```bash
make -C verif/xx_lsu_ld_ag preflight
make -C verif/xx_lsu_ld_ag run TEST=tc_mmu_hit_miss_abort SEED=19
make -C verif/xx_lsu_ld_ag regress SEED=19
make -C verif/xx_lsu_ld_ag coverage SEED=19
```

Explicitly separate “48 detailed scenarios specified” from “48 scenarios dynamically encoded/executed.”

- [ ] **Step 2: Write the closure report**

The report states how interaction 2.0 is closed, lists all changed artifacts, records the focused/full/preflight commands and observed counts, and preserves `BLOCKED_NO_VCS`/`PENDING_FULL_CHIP` boundaries. It must contain no unfinished placeholder markers.

- [ ] **Step 3: Run focused and full tests**

```bash
python3 -m unittest discover -s tests -p 'test_interaction_2_0_detailed_plan.py' -v
python3 -m unittest discover -s tests -v
```

Expected: all focused tests pass and the repository suite reports zero failures.

- [ ] **Step 4: Amend the delivery commit with a final subject**

```bash
git add doc-ag/xx_lsu_ld_ag_vcs_verification.md docs/interaction-2.0-followup-review.md
git commit --amend -m "verif: detail interaction 2.0 AG test scenarios"
```

---

### Task 5: Verify, review, publish, and confirm remote state

**Files:**
- Verify only: all files in the final commit

**Interfaces:**
- Consumes: final worktree, complete unittest suite, preflight, VCS availability, git remote state
- Produces: one verified commit on `main` and matching local/remote commit IDs

- [ ] **Step 1: Run fresh final verification**

Run:

```bash
make -C verif/xx_lsu_ld_ag preflight
python3 -m unittest discover -s tests -v
make -C verif/xx_lsu_ld_ag compile
git diff --check HEAD^ HEAD
git diff --name-only HEAD^ HEAD -- srcs
```

The first two commands must pass. `compile` either succeeds on a licensed host or emits the exact `ERROR: Synopsys VCS not found` blocker. The `srcs` diff must be empty.

- [ ] **Step 2: Review scope and commit structure**

Run `git status -sb`, `git show --stat --oneline HEAD`, and inspect `git diff HEAD^ HEAD`. Confirm there is one interaction 2.0 delivery commit above `origin/main`, with no unrelated files.

- [ ] **Step 3: Push directly to `main` under the established README workflow**

```bash
git push origin HEAD:main
git fetch origin main
```

Do not force-push. If remote `main` moved, stop and rebase or merge only after inspecting the new commits.

- [ ] **Step 4: Verify publication and synchronize the clean main checkout**

Confirm `git rev-parse HEAD` equals `git rev-parse origin/main`. Fast-forward the clean main checkout to `origin/main`, then rerun the focused test and preflight there. Report the commit hash, files, test counts, and any VCS/URG blocker.
