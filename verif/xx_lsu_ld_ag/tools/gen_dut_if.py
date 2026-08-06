#!/usr/bin/env python3
"""Compatibility wrapper for the shared interaction-2.1 generator."""

from __future__ import annotations

import sys
from pathlib import Path


REPO_ROOT = Path(__file__).resolve().parents[3]
if str(REPO_ROOT) not in sys.path:
    sys.path.insert(0, str(REPO_ROOT))

from verif.common.tools.gen_env import generate


def main() -> int:
    check = "--check" in sys.argv[1:]
    unexpected = [argument for argument in sys.argv[1:] if argument != "--check"]
    if unexpected:
        print(f"unexpected arguments: {' '.join(unexpected)}", file=sys.stderr)
        return 2
    manifest = REPO_ROOT / "verif/xx_lsu_ld_ag/module.json"
    return 0 if generate(manifest, check=check) else 1


if __name__ == "__main__":
    raise SystemExit(main())
