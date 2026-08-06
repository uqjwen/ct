#!/usr/bin/env python3
"""Parse ordered ports from the repository's non-ANSI RTL declarations."""

from __future__ import annotations

import re
from dataclasses import dataclass


@dataclass(frozen=True)
class Port:
    """One ordered module port."""

    name: str
    direction: str
    width: str = ""
    unpacked: str = ""


_IDENTIFIER = re.compile(r"^[A-Za-z_][A-Za-z0-9_$]*$")
_DECLARATION = re.compile(
    r"(?m)^\s*(input|output|inout)\s+"
    r"(?:(?:wire|reg|logic|signed|unsigned)\s+)*"
    r"(?:(\[[^;\n]+\])\s+)?"
    r"([^;]+);"
)
_ANSI_DECLARATION = re.compile(
    r"^\s*(input|output|inout)\s+"
    r"(?:(?:wire|reg|logic|signed|unsigned|var)\s+)*"
    r"(?:(\[[^\]]+\])\s+)?"
    r"([A-Za-z_][A-Za-z0-9_$]*)"
    r"((?:\s*\[[^\]]+\])*)"
    r"(?:\s*=\s*.+)?\s*$",
    flags=re.DOTALL,
)


def strip_comments(text: str) -> str:
    """Remove SystemVerilog comments while preserving line structure."""

    text = re.sub(
        r"/\*.*?\*/",
        lambda match: "\n" * match.group(0).count("\n"),
        text,
        flags=re.DOTALL,
    )
    return re.sub(r"//[^\n]*", "", text)


def _matching(text: str, opening_index: int, opening: str, closing: str) -> int:
    depth = 0
    for index in range(opening_index, len(text)):
        character = text[index]
        if character == opening:
            depth += 1
        elif character == closing:
            depth -= 1
            if depth == 0:
                return index
    raise ValueError(f"unmatched {opening} in module declaration")


def _split_top_level(text: str) -> list[str]:
    tokens: list[str] = []
    start = 0
    depths = {"(": 0, "[": 0, "{": 0}
    pairs = {")": "(", "]": "[", "}": "{"}
    for index, character in enumerate(text):
        if character in depths:
            depths[character] += 1
        elif character in pairs:
            depths[pairs[character]] -= 1
        elif character == "," and not any(depths.values()):
            tokens.append(text[start:index].strip())
            start = index + 1
    tokens.append(text[start:].strip())
    return [token for token in tokens if token]


def _module_region(source: str, module_name: str) -> tuple[str, str]:
    clean = strip_comments(source)
    match = re.search(rf"\bmodule\s+{re.escape(module_name)}\b", clean)
    if match is None:
        raise ValueError(f"module not found: {module_name}")

    cursor = match.end()
    while cursor < len(clean) and clean[cursor].isspace():
        cursor += 1
    if cursor < len(clean) and clean[cursor] == "#":
        parameter_open = clean.find("(", cursor + 1)
        if parameter_open < 0:
            raise ValueError(f"parameter list missing opening parenthesis: {module_name}")
        cursor = _matching(clean, parameter_open, "(", ")") + 1
        while cursor < len(clean) and clean[cursor].isspace():
            cursor += 1

    if cursor >= len(clean) or clean[cursor] != "(":
        raise ValueError(f"port list missing opening parenthesis: {module_name}")
    port_close = _matching(clean, cursor, "(", ")")
    semicolon = clean.find(";", port_close)
    if semicolon < 0:
        raise ValueError(f"module header missing semicolon: {module_name}")
    endmodule = re.search(r"\bendmodule\b", clean[semicolon + 1 :])
    if endmodule is None:
        raise ValueError(f"module missing endmodule: {module_name}")
    body_end = semicolon + 1 + endmodule.start()
    return clean[cursor + 1 : port_close], clean[semicolon + 1 : body_end]


def _declared_ports(body: str) -> dict[str, tuple[str, str, str]]:
    declarations: dict[str, tuple[str, str, str]] = {}
    for match in _DECLARATION.finditer(body):
        direction, width, names_blob = match.groups()
        for item in _split_top_level(names_blob):
            name_match = re.match(
                r"\s*([A-Za-z_][A-Za-z0-9_$]*)((?:\s*\[[^\]]+\])*)",
                item,
            )
            if name_match is None:
                continue
            name, unpacked = name_match.groups()
            declarations.setdefault(
                name,
                (direction, (width or "").strip(), unpacked.strip()),
            )
    return declarations


def parse_module_ports(source: str, module_name: str) -> list[Port]:
    """Return ANSI or non-ANSI ports in module-header order."""

    header, body = _module_region(source, module_name)
    header_items = _split_top_level(header)
    ansi = any(
        re.match(r"^\s*(?:input|output|inout)\b", item) is not None
        for item in header_items
    )
    if ansi:
        ports: list[Port] = []
        malformed: list[str] = []
        for item in header_items:
            match = _ANSI_DECLARATION.fullmatch(item)
            if match is None:
                malformed.append(item)
                continue
            direction, width, name, unpacked = match.groups()
            ports.append(
                Port(
                    name=name,
                    direction=direction,
                    width=(width or "").strip(),
                    unpacked=unpacked.strip(),
                )
            )
        if malformed:
            raise ValueError(f"malformed ANSI header ports: {', '.join(malformed)}")
        names = [port.name for port in ports]
        seen: set[str] = set()
        duplicates: list[str] = []
        for name in names:
            if name in seen and name not in duplicates:
                duplicates.append(name)
            seen.add(name)
        if duplicates:
            raise ValueError(f"duplicate header port: {', '.join(duplicates)}")
        return ports

    names = header_items
    malformed = [name for name in names if _IDENTIFIER.fullmatch(name) is None]
    if malformed:
        raise ValueError(f"malformed header ports: {', '.join(malformed)}")

    seen: set[str] = set()
    duplicates: list[str] = []
    for name in names:
        if name in seen and name not in duplicates:
            duplicates.append(name)
        seen.add(name)
    if duplicates:
        raise ValueError(f"duplicate header port: {', '.join(duplicates)}")

    declarations = _declared_ports(body)
    missing = [name for name in names if name not in declarations]
    if missing:
        raise ValueError(f"missing declarations for ports: {', '.join(missing)}")

    return [
        Port(
            name=name,
            direction=declarations[name][0],
            width=declarations[name][1],
            unpacked=declarations[name][2],
        )
        for name in names
    ]
