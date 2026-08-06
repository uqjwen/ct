#!/usr/bin/env python3
"""Generate checked-in interfaces and named DUT connections from RTL ports."""

from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path
from typing import Iterable


REPO_ROOT = Path(__file__).resolve().parents[3]
if str(REPO_ROOT) not in sys.path:
    sys.path.insert(0, str(REPO_ROOT))

from verif.common.tools.rtl_ports import Port, parse_module_ports
from verif.common.tools.scenario_contract import ModuleManifest, load_manifest


TEMPLATE_ROOT = REPO_ROOT / "verif/common/templates"


def _template(name: str) -> str:
    return (TEMPLATE_ROOT / name).read_text(encoding="utf-8")


def _replace(template: str, replacements: dict[str, str]) -> str:
    rendered = template
    for token, value in replacements.items():
        rendered = rendered.replace(f"@@{token}@@", value)
    leftovers = sorted(set(re.findall(r"@@[A-Z_]+@@", rendered)))
    if leftovers:
        raise ValueError(f"unresolved template tokens: {', '.join(leftovers)}")
    return rendered.rstrip() + "\n"


def _parameter_block(parameters: dict[str, object]) -> str:
    if not parameters:
        return ""
    rows = []
    items = list(parameters.items())
    for index, (name, value) in enumerate(items):
        comma = "," if index + 1 < len(items) else ""
        rows.append(f"  parameter int {name} = {value}{comma}")
    return " #(\n" + "\n".join(rows) + "\n)"


def render_interface(manifest: ModuleManifest, ports: Iterable[Port]) -> str:
    """Render a deterministic interface with input-only idle driving."""

    ports = tuple(ports)
    interface_name = f"{manifest.dut_module}_if"
    guard = re.sub(r"[^A-Za-z0-9]", "_", interface_name).upper() + "_SV"
    signals = []
    idle = []
    for port in ports:
        width = f" {port.width}" if port.width else ""
        unpacked = f" {port.unpacked}" if port.unpacked else ""
        signals.append(f"  logic{width} {port.name}{unpacked};")
        if port.direction != "input" or port.name == manifest.clock:
            continue
        if port.name in manifest.idle_overrides:
            value = manifest.idle_overrides[port.name]
            if value is None:
                continue
        else:
            value = "'{default:'0}" if port.unpacked else "'0"
        idle.append(f"    {port.name} = {value};")
    if not idle:
        idle.append("    // No input ports require an idle assignment.")
    return _replace(
        _template("interface.sv.in"),
        {
            "GUARD": guard,
            "INTERFACE": interface_name,
            "PARAMETERS": _parameter_block(dict(manifest.parameters)),
            "SIGNALS": "\n".join(signals),
            "IDLE_ASSIGNMENTS": "\n".join(idle),
        },
    )


def render_connections(ports: Iterable[Port]) -> str:
    """Render ordered named connections through the conventional bus object."""

    ports = tuple(ports)
    rows = []
    for index, port in enumerate(ports):
        comma = "," if index + 1 < len(ports) else ""
        rows.append(f"  .{port.name:<44} (bus.{port.name}){comma}")
    return _replace(
        _template("connect.svh.in"),
        {"CONNECTIONS": "\n".join(rows)},
    )


def _display_path(path: Path) -> str:
    try:
        return str(path.relative_to(REPO_ROOT))
    except ValueError:
        return str(path)


def _check_or_write(path: Path, content: str, check: bool) -> bool:
    if check:
        if not path.is_file() or path.read_text(encoding="utf-8") != content:
            print(f"generated file is stale: {_display_path(path)}", file=sys.stderr)
            return False
        return True
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(content, encoding="utf-8")
    return True


def _resolve_source(manifest_path: Path, manifest: ModuleManifest) -> Path:
    repository_source = REPO_ROOT / manifest.dut_source
    if repository_source.is_file():
        return repository_source
    fixture_source = manifest_path.parent / manifest.dut_source
    if fixture_source.is_file():
        return fixture_source
    raise FileNotFoundError(f"DUT source not found: {manifest.dut_source}")


def generate(manifest_path: Path, check: bool = False) -> bool:
    """Generate or byte-compare one environment's checked-in port artifacts."""

    manifest_path = manifest_path.resolve()
    manifest = load_manifest(manifest_path)
    env_dir = manifest_path.parent
    source_path = _resolve_source(manifest_path, manifest)
    ports = parse_module_ports(
        source_path.read_text(encoding="utf-8"), manifest.dut_module
    )
    interface_path = env_dir / "tb" / f"{manifest.dut_module}_if.sv"
    connect_path = env_dir / "tb" / f"{manifest.dut_module}_connect.svh"
    ok = _check_or_write(interface_path, render_interface(manifest, ports), check)
    ok &= _check_or_write(connect_path, render_connections(ports), check)
    if ok:
        action = "verified" if check else "generated"
        print(f"{action} {len(ports)} {manifest.dut_module} ports")
    return ok


def _arguments() -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    selector = parser.add_mutually_exclusive_group(required=True)
    selector.add_argument("--env", help="environment directory name under verif/")
    selector.add_argument("--manifest", type=Path, help="explicit module.json path")
    parser.add_argument("--check", action="store_true", help="fail on generated drift")
    return parser.parse_args()


def main() -> int:
    args = _arguments()
    manifest_path = (
        args.manifest
        if args.manifest is not None
        else REPO_ROOT / "verif" / args.env / "module.json"
    )
    try:
        return 0 if generate(manifest_path, args.check) else 1
    except (FileNotFoundError, ValueError, OSError) as error:
        print(f"GEN_ENV_FAIL: {error}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
