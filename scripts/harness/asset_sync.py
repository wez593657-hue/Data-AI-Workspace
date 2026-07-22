"""Synchronize dictionary type/length metadata from authoritative DDL."""

from __future__ import annotations

import re
from pathlib import Path
from typing import Any

from .schema_consistency import parse_ddl, _normalise


def _display_type(type_value: str) -> tuple[str, str]:
    value = type_value.upper().replace('SYS."DATE"', "DATE").replace("SYS.DATE", "DATE")
    if value in {"DATE", "SYS"}:
        return "DATE", "-"
    match = re.match(r"^([A-Z][A-Z0-9_]*)(?:\(([^)]*)\))?$", value)
    if not match:
        return value, "-"
    return match.group(1), match.group(2) or "-"


def _rewrite_dictionary(path: Path, ddl: dict[str, Any]) -> bool:
    lines = path.read_text(encoding="utf-8", errors="replace").splitlines()
    header_index = next((i for i, line in enumerate(lines) if "字段名" in line and "数据类型" in line and "|" in line), None)
    if header_index is None:
        return False
    header = [cell.strip() for cell in lines[header_index].strip().strip("|").split("|")]
    field_index = header.index("字段名")
    type_index = header.index("数据类型")
    length_index = header.index("长度") if "长度" in header else None
    changed = False
    for i in range(header_index + 2, len(lines)):
        if not lines[i].strip().startswith("|") or lines[i].strip().startswith("|---"):
            continue
        cells = [cell.strip() for cell in lines[i].strip().strip("|").split("|")]
        if len(cells) <= max(field_index, type_index) or not re.fullmatch(r"[A-Za-z_][A-Za-z0-9_$]*", cells[field_index]):
            continue
        field = _normalise(cells[field_index])
        if field not in ddl["fields"]:
            continue
        display_type, length = _display_type(ddl["fields"][field]["type"])
        if cells[type_index] != display_type:
            cells[type_index] = display_type
            changed = True
        if length_index is not None and cells[length_index] != length:
            cells[length_index] = length
            changed = True
        lines[i] = "| " + " | ".join(cells) + " |"
    if changed:
        path.write_text("\n".join(lines) + "\n", encoding="utf-8", newline="\n")
    return changed


def sync_dictionary_types(root: Path) -> list[dict[str, str]]:
    ddl_index: dict[str, dict[str, Any]] = {}
    changed_ddl: list[str] = []
    for path in sorted((root / "data_assets" / "ddl").rglob("*.sql")):
        content = path.read_text(encoding="utf-8", errors="replace")
        normalized = re.sub(r"SYS\.\"DATE\"|SYS\.DATE", "DATE", content, flags=re.IGNORECASE)
        if normalized != content:
            path.write_text(normalized, encoding="utf-8", newline="\n")
            changed_ddl.append(str(path.relative_to(root)))
        relative_parts = path.relative_to(root / "data_assets" / "ddl").parts
        if "tmp" in {part.lower() for part in relative_parts} or "temp" in {part.lower() for part in relative_parts}:
            continue
        parsed = parse_ddl(path)
        ddl_index[parsed["table"]] = parsed
    changed_dict: list[str] = []
    for path in sorted((root / "data_assets" / "data_dictionary").rglob("*.md")):
        if "temp" in {part.lower() for part in path.relative_to(root / "data_assets" / "data_dictionary").parts}:
            continue
        table_line = next((line for line in path.read_text(encoding="utf-8", errors="replace").splitlines() if line.strip().startswith("| 表名 |")), "")
        if not table_line:
            continue
        table = _normalise(table_line.split("|")[2].strip())
        ddl = ddl_index.get(table)
        if ddl and _rewrite_dictionary(path, ddl):
            changed_dict.append(str(path.relative_to(root)))
    return [{"kind": "ddl", "path": path} for path in changed_ddl] + [{"kind": "dictionary", "path": path} for path in changed_dict]
