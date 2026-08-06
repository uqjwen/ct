#!/usr/bin/env python3
"""Load and validate signal-level LSU verification environment contracts."""

from __future__ import annotations

import csv
import json
import re
from dataclasses import dataclass
from pathlib import Path
from typing import Any, Iterable, Mapping, Sequence

from verif.common.tools.rtl_ports import Port, parse_module_ports, strip_comments


DETAIL_COLUMNS = (
    "scenario_id",
    "feature_id",
    "scenario",
    "testcase",
    "priority",
    "setup",
    "drive_signals",
    "cycle_sequence",
    "trigger_condition",
    "expected_signals",
    "expected_result",
    "checker",
    "coverage",
    "closure",
    "result",
)

_ALLOWED_PRIORITIES = frozenset({"P0", "P1", "P2"})
_ALLOWED_RESULTS = frozenset({"BLOCKED_NO_VCS", "PENDING_FULL_CHIP"})
_IDENTIFIER = re.compile(r"^[A-Za-z_][A-Za-z0-9_$]*$")
_IDENTIFIER_TOKEN = re.compile(r"\b[A-Za-z_][A-Za-z0-9_$]*\b")
_BACKTICK = re.compile(r"`([^`]+)`")
_MODULE_DEFINITION = re.compile(
    r"\b(?:module|interface)\s+([A-Za-z_][A-Za-z0-9_$]*)\b"
)
_MODULE_INSTANCE = re.compile(
    r"(?ms)^\s*((?:gated_clk_cell|xx_lsu_[A-Za-z0-9_$]+))\s*"
    r"(?:#\s*\(.*?\)\s*)?[A-Za-z_][A-Za-z0-9_$]*\s*\("
)


class ContractError(RuntimeError):
    """Raised when an environment violates the interaction-2.1 contract."""


@dataclass(frozen=True)
class ModuleManifest:
    """Declarative description of one standalone verification environment."""

    env_name: str
    dut_module: str
    dut_source: str
    feature_doc: str
    runbook: str
    feature_prefix: str
    expected_features: int
    min_scenarios_per_feature: int
    clock: str
    reset: str
    parameters: Mapping[str, Any]
    idle_overrides: Mapping[str, Any]
    production_sources: tuple[str, ...]
    declared_stubs: tuple[str, ...]
    stub_results: Mapping[str, str]


@dataclass(frozen=True)
class EnvironmentContract:
    """All source material used to validate one module environment."""

    root: Path
    env_dir: Path
    manifest: ModuleManifest
    ports: tuple[Port, ...]
    feature_rows: tuple[Mapping[str, str], ...]
    detail_rows: tuple[Mapping[str, str], ...]
    test_names: frozenset[str]
    markdown: str
    runbook: str
    tb_text: str
    assertion_text: str
    known_signals: frozenset[str]
    instantiated_modules: frozenset[str]
    defined_modules: frozenset[str]


@dataclass(frozen=True)
class ValidationSummary:
    """Static signoff counts for one validated environment."""

    env_name: str
    feature_count: int
    scenario_count: int
    minimum_scenarios: int
    signal_count: int
    declared_stubs: tuple[str, ...]
    stub_results: Mapping[str, str]
    markdown: str
    runbook: str


def signal_vocabulary(*sources: str) -> set[str]:
    """Return SystemVerilog-like identifiers found in source text."""

    return {
        token
        for source in sources
        for token in _IDENTIFIER_TOKEN.findall(strip_comments(source))
    }


def _read_csv(path: Path) -> tuple[tuple[str, ...], tuple[dict[str, str], ...]]:
    with path.open(encoding="utf-8", newline="") as stream:
        reader = csv.DictReader(stream)
        columns = tuple(reader.fieldnames or ())
        rows = tuple(dict(row) for row in reader)
    return columns, rows


def _manifest_from_json(path: Path) -> ModuleManifest:
    raw = json.loads(path.read_text(encoding="utf-8"))
    required = {
        "env_name",
        "dut_module",
        "dut_source",
        "feature_doc",
        "runbook",
        "feature_prefix",
        "expected_features",
        "min_scenarios_per_feature",
        "clock",
        "reset",
    }
    missing = sorted(required - raw.keys())
    if missing:
        raise ContractError(f"manifest missing fields: {', '.join(missing)}")
    return ModuleManifest(
        env_name=str(raw["env_name"]),
        dut_module=str(raw["dut_module"]),
        dut_source=str(raw["dut_source"]),
        feature_doc=str(raw["feature_doc"]),
        runbook=str(raw["runbook"]),
        feature_prefix=str(raw["feature_prefix"]),
        expected_features=int(raw["expected_features"]),
        min_scenarios_per_feature=int(raw["min_scenarios_per_feature"]),
        clock=str(raw["clock"]),
        reset=str(raw["reset"]),
        parameters=dict(raw.get("parameters", {})),
        idle_overrides=dict(raw.get("idle_overrides", {})),
        production_sources=tuple(str(item) for item in raw.get("production_sources", ())),
        declared_stubs=tuple(str(item) for item in raw.get("declared_stubs", ())),
        stub_results={str(key): str(value) for key, value in raw.get("stub_results", {}).items()},
    )


def load_manifest(path: Path) -> ModuleManifest:
    """Load one environment manifest from JSON."""

    return _manifest_from_json(path)


def _read_optional(path: Path) -> str:
    return path.read_text(encoding="utf-8") if path.exists() else ""


def _defined_modules(*sources: str) -> set[str]:
    return {
        name
        for source in sources
        for name in _MODULE_DEFINITION.findall(strip_comments(source))
    }


def _instantiated_modules(*sources: str) -> set[str]:
    return {
        name
        for source in sources
        for name in _MODULE_INSTANCE.findall(strip_comments(source))
    }


def load_environment(root: Path, env_name: str) -> EnvironmentContract:
    """Load an environment and its real RTL vocabulary from the repository."""

    root = root.resolve()
    env_dir = root / "verif" / env_name
    manifest = _manifest_from_json(env_dir / "module.json")
    if manifest.env_name != env_name:
        raise ContractError(
            f"manifest env_name mismatch: expected {env_name}, got {manifest.env_name}"
        )

    dut_path = root / manifest.dut_source
    dut_text = dut_path.read_text(encoding="utf-8")
    ports = tuple(parse_module_ports(dut_text, manifest.dut_module))

    feature_columns, feature_rows = _read_csv(env_dir / "coverage_matrix.csv")
    if "feature_id" not in feature_columns:
        raise ContractError("coverage_matrix.csv missing feature_id")
    detail_columns, detail_rows = _read_csv(env_dir / "detailed_test_plan.csv")
    if detail_columns != DETAIL_COLUMNS:
        raise ContractError(
            "unexpected detail schema: " + ",".join(detail_columns)
        )

    test_names = frozenset(
        line.strip()
        for line in (env_dir / "tests.list").read_text(encoding="utf-8").splitlines()
        if line.strip() and not line.lstrip().startswith("#")
    )
    markdown = (root / manifest.feature_doc).read_text(encoding="utf-8")
    runbook = (root / manifest.runbook).read_text(encoding="utf-8")

    tb_path = env_dir / "tb" / f"{manifest.dut_module}_tb.sv"
    assertion_path = env_dir / "tb" / f"{manifest.dut_module}_assertions.sv"
    deps_path = env_dir / "tb" / f"{manifest.dut_module}_deps.sv"
    interface_path = env_dir / "tb" / f"{manifest.dut_module}_if.sv"
    connect_path = env_dir / "tb" / f"{manifest.dut_module}_connect.svh"
    tb_text = _read_optional(tb_path)
    assertion_text = _read_optional(assertion_path)
    deps_text = _read_optional(deps_path)
    interface_text = _read_optional(interface_path)
    connect_text = _read_optional(connect_path)

    production_texts = tuple(
        (root / source).read_text(encoding="utf-8")
        for source in manifest.production_sources
        if (root / source).exists()
    )
    all_sources = (
        dut_text,
        tb_text,
        assertion_text,
        deps_text,
        interface_text,
        connect_text,
        *production_texts,
    )
    known_signals = signal_vocabulary(*all_sources)
    known_signals.update(port.name for port in ports)
    known_signals.update((manifest.clock, manifest.reset))

    defined = _defined_modules(
        dut_text, tb_text, assertion_text, deps_text, interface_text, *production_texts
    )
    instantiated = _instantiated_modules(
        dut_text, tb_text, assertion_text, deps_text, *production_texts
    )
    return EnvironmentContract(
        root=root,
        env_dir=env_dir,
        manifest=manifest,
        ports=ports,
        feature_rows=feature_rows,
        detail_rows=detail_rows,
        test_names=test_names,
        markdown=markdown,
        runbook=runbook,
        tb_text=tb_text,
        assertion_text=assertion_text,
        known_signals=frozenset(known_signals),
        instantiated_modules=frozenset(instantiated),
        defined_modules=frozenset(defined),
    )


def _split_signals(value: str) -> tuple[str, ...]:
    return tuple(signal.strip() for signal in value.split("|") if signal.strip())


def _backticked_signals(text: str, vocabulary: Iterable[str]) -> set[str]:
    known = set(vocabulary)
    return {
        token
        for expression in _BACKTICK.findall(text)
        for token in _IDENTIFIER_TOKEN.findall(expression)
        if token in known
    }


def _require(condition: bool, message: str) -> None:
    if not condition:
        raise ContractError(message)


def _validate_dependencies(contract: EnvironmentContract) -> None:
    supplied = {contract.manifest.dut_module}
    supplied.update(
        module
        for module in contract.defined_modules
        if module not in contract.manifest.declared_stubs
    )
    missing = set(contract.instantiated_modules) - supplied
    undeclared = sorted(missing - set(contract.manifest.declared_stubs))
    _require(
        not undeclared,
        "undeclared dependency stub: " + ", ".join(undeclared),
    )

    undefined = sorted(
        set(contract.manifest.declared_stubs) - set(contract.defined_modules)
    )
    _require(not undefined, "declared stub has no module definition: " + ", ".join(undefined))
    for stub in contract.manifest.declared_stubs:
        _require(
            contract.manifest.stub_results.get(stub) == "PENDING_FULL_CHIP",
            f"stub result must be PENDING_FULL_CHIP: {stub}",
        )


def _validate_feature_rows(contract: EnvironmentContract) -> dict[str, Mapping[str, str]]:
    prefix = contract.manifest.feature_prefix
    expected = [
        f"{prefix}-FP-{index:02d}"
        for index in range(1, contract.manifest.expected_features + 1)
    ]
    actual = [str(row.get("feature_id", "")) for row in contract.feature_rows]
    _require(actual == expected, f"feature IDs are not exact and contiguous: {actual}")

    parents: dict[str, Mapping[str, str]] = {}
    for row in contract.feature_rows:
        feature_id = row["feature_id"]
        for field in (
            "testcase",
            "priority",
            "checker",
            "coverage",
            "closure",
            "result",
        ):
            _require(bool(str(row.get(field, "")).strip()), f"{feature_id} empty {field}")
        _require(row["testcase"] in contract.test_names, f"unknown testcase: {row['testcase']}")
        _require(row["priority"] in _ALLOWED_PRIORITIES, f"invalid priority: {feature_id}")
        _require(row["result"] in _ALLOWED_RESULTS, f"invalid result: {feature_id}")
        _require(_IDENTIFIER.fullmatch(row["checker"]) is not None, f"invalid checker: {feature_id}")
        _require(_IDENTIFIER.fullmatch(row["coverage"]) is not None, f"invalid coverage: {feature_id}")
        combined_checker_text = contract.tb_text + "\n" + contract.assertion_text
        _require(row["checker"] in combined_checker_text, f"checker not implemented: {row['checker']}")
        _require(row["coverage"] in combined_checker_text, f"coverage not implemented: {row['coverage']}")
        parents[feature_id] = row
    return parents


def _validate_detail_rows(
    contract: EnvironmentContract,
    parents: Mapping[str, Mapping[str, str]],
) -> None:
    prefix = contract.manifest.feature_prefix
    grouped: dict[str, list[Mapping[str, str]]] = {key: [] for key in parents}

    for row in contract.detail_rows:
        _require(tuple(row.keys()) == DETAIL_COLUMNS, "unexpected detail schema")
        scenario_id = str(row.get("scenario_id", ""))
        for field in DETAIL_COLUMNS:
            _require(bool(str(row.get(field, "")).strip()), f"{scenario_id} empty {field}")

        feature_id = row["feature_id"]
        _require(feature_id in parents, f"unknown parent feature: {scenario_id}")
        _require(
            re.fullmatch(rf"{re.escape(prefix)}-FP-\d{{2}}-S\d{{2,}}", scenario_id)
            is not None,
            f"invalid scenario ID: {scenario_id}",
        )
        parent = parents[feature_id]
        for field in ("testcase", "priority", "checker", "coverage", "result"):
            _require(
                row[field] == parent[field],
                f"{scenario_id} parent mismatch: {field}",
            )
        _require(row["testcase"] in contract.test_names, f"unknown testcase: {scenario_id}")
        _require(row["priority"] in _ALLOWED_PRIORITIES, f"invalid priority: {scenario_id}")
        _require(row["result"] in _ALLOWED_RESULTS, f"invalid result: {scenario_id}")
        _require("C0:" in row["cycle_sequence"], f"{scenario_id} missing C0")
        _require("C1:" in row["cycle_sequence"], f"{scenario_id} missing C1")
        _require(row["trigger_condition"].startswith("当"), f"{scenario_id} trigger must begin 当")
        _require(row["expected_result"].startswith("则"), f"{scenario_id} result must begin 则")

        drive_signals = _split_signals(row["drive_signals"])
        expected_signals = _split_signals(row["expected_signals"])
        _require(bool(drive_signals), f"{scenario_id} has no drive signals")
        _require(bool(expected_signals), f"{scenario_id} has no observed signals")
        unknown = sorted(
            (set(drive_signals) | set(expected_signals)) - set(contract.known_signals)
        )
        _require(
            not unknown,
            f"unknown drive or observed signal in {scenario_id}: {', '.join(unknown)}",
        )

        trigger_signals = _backticked_signals(
            row["trigger_condition"], contract.known_signals
        )
        _require(
            bool(trigger_signals),
            f"trigger names no real signal: {scenario_id}",
        )
        result_signals = _backticked_signals(
            row["expected_result"], contract.known_signals
        )
        _require(
            bool(result_signals & set(expected_signals)),
            f"expected result names no delivered signal: {scenario_id}",
        )

        for literal in (
            scenario_id,
            row["trigger_condition"],
            row["expected_result"],
        ):
            _require(literal in contract.markdown, f"Markdown row is not exact: {scenario_id}")
        grouped[feature_id].append(row)

    for feature_id, rows in grouped.items():
        _require(
            len(rows) >= contract.manifest.min_scenarios_per_feature,
            f"{feature_id} has only {len(rows)} scenarios",
        )
        expected_ids = [
            f"{feature_id}-S{index:02d}" for index in range(1, len(rows) + 1)
        ]
        actual_ids = [row["scenario_id"] for row in rows]
        _require(
            actual_ids == expected_ids,
            f"scenario IDs are not exact and contiguous for {feature_id}: {actual_ids}",
        )


def _validate_runbook(contract: EnvironmentContract) -> None:
    required = (
        "make preflight",
        "make compile",
        "make run TEST=",
        "make regress",
        "make coverage",
    )
    missing = [command for command in required if command not in contract.runbook]
    _require(not missing, "runbook missing commands: " + ", ".join(missing))


def validate_environment(contract: EnvironmentContract) -> ValidationSummary:
    """Validate a loaded environment and return static completion evidence."""

    _validate_dependencies(contract)
    parents = _validate_feature_rows(contract)
    _validate_detail_rows(contract, parents)
    _validate_runbook(contract)
    return ValidationSummary(
        env_name=contract.manifest.env_name,
        feature_count=len(contract.feature_rows),
        scenario_count=len(contract.detail_rows),
        minimum_scenarios=contract.manifest.min_scenarios_per_feature,
        signal_count=len(contract.known_signals),
        declared_stubs=contract.manifest.declared_stubs,
        stub_results=dict(contract.manifest.stub_results),
        markdown=contract.markdown,
        runbook=contract.runbook,
    )
