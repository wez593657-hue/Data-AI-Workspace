"""Full-repository DDL, data dictionary and Mapping consistency checks."""

from __future__ import annotations

import re
from pathlib import Path
from typing import Any

from .artifact_graph import build_artifact_graph
from .evidence_store import sha256_file, utc_now, write_yaml
from .task_manager import load_task


class SchemaConsistencyError(ValueError):
    """Raised when the consistency checker cannot produce a valid report."""


LAYERS = ("ods", "dwd", "dws", "ads")
OPTIONAL_MAPPING_FLOWS = {"ods_to_dwd", "dwd_to_dws", "dws_to_ads"}
_IDENTIFIER = re.compile(r"^[A-Za-z_][A-Za-z0-9_$]*$")
_CREATE = re.compile(
    r"CREATE\s+TABLE\s+(?:IF\s+NOT\s+EXISTS\s+)?([\w$\".]+)\s*\(",
    re.IGNORECASE,
)
_STOP_TYPE = re.compile(
    r"\s+(?:NOT\s+NULL|NULL|DEFAULT|PRIMARY\s+KEY|UNIQUE|REFERENCES|CHECK)\b",
    re.IGNORECASE,
)


def _normalise(value: str) -> str:
    return value.strip().strip('"`[]').split(".")[-1].lower()


def _normalise_type(value: str) -> str:
    value = re.sub(r"\s+", "", value).upper()
    value = value.replace("VARCHAR2", "VARCHAR")
    value = value.replace('SYS."DATE"', "DATE").replace("SYS.DATE", "DATE").replace("SYS", "DATE") if value in {"SYS", "SYS.DATE", 'SYS."DATE"'} else value
    return value


def _split_top_level(body: str) -> list[str]:
    parts: list[str] = []
    start = 0
    depth = 0
    quote: str | None = None
    for index, char in enumerate(body):
        if quote:
            if char == quote and (index == 0 or body[index - 1] != "\\"):
                quote = None
            continue
        if char in "'\"":
            quote = char
        elif char == "(":
            depth += 1
        elif char == ")":
            depth -= 1
        elif char == "," and depth == 0:
            parts.append(body[start:index])
            start = index + 1
    parts.append(body[start:])
    return parts


def _create_body(content: str, opening: int) -> str:
    depth = 1
    quote: str | None = None
    for index in range(opening, len(content)):
        char = content[index]
        if quote:
            if char == quote and content[index - 1] != "\\":
                quote = None
            continue
        if char in "'\"":
            quote = char
        elif char == "(":
            depth += 1
        elif char == ")":
            depth -= 1
            if depth == 0:
                return content[opening:index]
    raise SchemaConsistencyError("CREATE TABLE 缺少闭合括号")


def parse_ddl(path: Path) -> dict[str, Any]:
    content = path.read_text(encoding="utf-8", errors="replace")
    match = _CREATE.search(content)
    if not match:
        raise SchemaConsistencyError(f"无法解析 CREATE TABLE: {path}")
    table = _normalise(match.group(1))
    body = _create_body(content, match.end())
    fields: dict[str, dict[str, Any]] = {}
    for definition in _split_top_level(body):
        line = re.sub(r"\s+", " ", definition.strip())
        if not line or line.startswith("--"):
            continue
        first = re.match(r"^([A-Za-z_][A-Za-z0-9_$]*)\s+(.+)$", line)
        if not first or first.group(1).upper() in {
            "PRIMARY", "UNIQUE", "CONSTRAINT", "FOREIGN", "CHECK",
        }:
            continue
        field = _normalise(first.group(1))
        type_text = _STOP_TYPE.split(first.group(2), maxsplit=1)[0].strip()
        nullable = not bool(re.search(r"\bNOT\s+NULL\b", first.group(2), re.I))
        fields[field] = {
            "name": first.group(1),
            "type": _normalise_type(type_text),
            "nullable": nullable,
            "source_path": str(path),
        }
    if not fields:
        raise SchemaConsistencyError(f"CREATE TABLE 没有可解析字段: {path}")
    return {"table": table, "fields": fields, "path": str(path)}


def _markdown_rows(content: str) -> list[list[str]]:
    rows: list[list[str]] = []
    for line in content.splitlines():
        if not line.strip().startswith("|"):
            continue
        cells = [cell.strip() for cell in line.strip().strip("|").split("|")]
        if cells and not all(set(cell) <= {"-", ":", " "} for cell in cells):
            rows.append(cells)
    return rows


def parse_dictionary(path: Path) -> dict[str, Any]:
    rows = _markdown_rows(path.read_text(encoding="utf-8", errors="replace"))
    header_index = next(
        (index for index, row in enumerate(rows) if any("字段名" in cell for cell in row)),
        None,
    )
    if header_index is None:
        raise SchemaConsistencyError(f"数据字典缺少字段列表表头: {path}")
    header = rows[header_index]
    indexes = {name: header.index(name) for name in ("字段名", "数据类型", "长度") if name in header}
    if "字段名" not in indexes or "数据类型" not in indexes:
        raise SchemaConsistencyError(f"数据字典字段列不完整: {path}")
    table = _normalise(next((row[1] for row in rows if row and row[0] == "表名"), path.stem.replace("_dd", "")))
    fields: dict[str, dict[str, Any]] = {}
    for row in rows[header_index + 1:]:
        if len(row) <= max(indexes.values()):
            continue
        name = row[indexes["字段名"]].strip()
        if not _IDENTIFIER.fullmatch(name):
            continue
        field = _normalise(name)
        type_value = row[indexes["数据类型"]]
        if "长度" in indexes:
            length = row[indexes["长度"]].strip()
            if length and length not in {"-", "--", "【待确认】"} and "(" not in type_value:
                type_value = f"{type_value}({length})"
        fields[field] = {
            "name": name,
            "type": _normalise_type(type_value),
            "source_path": str(path),
        }
    if not fields:
        raise SchemaConsistencyError(f"数据字典没有可解析字段: {path}")
    return {"table": table, "fields": fields, "path": str(path)}


def parse_mapping(path: Path) -> list[dict[str, Any]]:
    lines = path.read_text(encoding="utf-8", errors="replace").splitlines()
    records: list[dict[str, Any]] = []
    current_table = ""
    index = 0
    while index < len(lines):
        heading = re.match(r"^###\s+([^（(]+)", lines[index].strip())
        if heading:
            current_table = _normalise(heading.group(1).strip())
            index += 1
            continue
        if "目标字段" not in lines[index] or "|" not in lines[index]:
            index += 1
            continue
        header = [cell.strip() for cell in lines[index].strip().strip("|").split("|")]
        positions = {name: header.index(name) for name in ("目标字段", "源表", "源字段", "映射规则") if name in header}
        if "目标字段" not in positions:
            index += 1
            continue
        index += 2
        while index < len(lines) and lines[index].strip().startswith("|"):
            cells = [cell.strip() for cell in lines[index].strip().strip("|").split("|")]
            if len(cells) <= max(positions.values()):
                index += 1
                continue
            target = cells[positions["目标字段"]]
            if _IDENTIFIER.fullmatch(target):
                records.append({
                    "target_table": current_table,
                    "target_field": _normalise(target),
                    "source_table": cells[positions["源表"]] if "源表" in positions else "",
                    "source_field": cells[positions["源字段"]] if "源字段" in positions else "",
                    "rule": cells[positions["映射规则"]] if "映射规则" in positions else "",
                    "source_path": str(path),
                    "flow": path.parent.name,
                })
            index += 1
    return records


def _files(root: Path, directory: str, suffix: str) -> list[Path]:
    return sorted((root / directory).rglob(f"*{suffix}"))


def _dictionary_index(root: Path) -> tuple[dict[str, dict[str, Any]], list[dict[str, Any]]]:
    tables: dict[str, dict[str, Any]] = {}
    errors: list[dict[str, Any]] = []
    for path in _files(root, "data_assets/data_dictionary", ".md"):
        try:
            parsed = parse_dictionary(path)
            tables[parsed["table"]] = parsed
        except SchemaConsistencyError as error:
            errors.append({"kind": "unresolved", "path": str(path), "message": str(error)})
    return tables, errors


def _compare_table(ddl: dict[str, Any], dictionary: dict[str, Any]) -> list[dict[str, Any]]:
    differences: list[dict[str, Any]] = []
    ddl_fields = set(ddl["fields"])
    dict_fields = set(dictionary["fields"])
    for field in sorted(ddl_fields - dict_fields):
        differences.append({"kind": "missing", "side": "dictionary", "table": ddl["table"], "field": field, "path": dictionary["path"]})
    for field in sorted(dict_fields - ddl_fields):
        differences.append({"kind": "extra", "side": "dictionary", "table": ddl["table"], "field": field, "path": dictionary["path"]})
    for field in sorted(ddl_fields & dict_fields):
        left = ddl["fields"][field]
        right = dictionary["fields"][field]
        if left["type"] != right["type"]:
            differences.append({"kind": "mismatch", "attribute": "type", "table": ddl["table"], "field": field, "ddl": left["type"], "dictionary": right["type"], "path": dictionary["path"]})
    return differences


def run_schema_consistency(root: Path, task_id: str) -> dict[str, Any]:
    task_dir, _ = load_task(root, task_id)
    report: dict[str, Any] = {
        "schema_version": "0.1", "task_id": task_id, "created_at": utc_now(),
        "scope": {"ddl": "data_assets/ddl", "dictionary": "data_assets/data_dictionary", "mapping": "data_assets/mapping"},
        "status": "passed", "differences": [], "unresolved": [], "inputs": [], "summary": {},
    }
    dictionaries, unresolved = _dictionary_index(root)
    report["unresolved"].extend(unresolved)
    ddl_tables: dict[str, dict[str, Any]] = {}
    for path in _files(root, "data_assets/ddl", ".sql"):
        report["inputs"].append({"path": str(path.relative_to(root)), "sha256": sha256_file(path), "kind": "ddl"})
        try:
            parsed = parse_ddl(path)
            relative_parts = path.relative_to(root / "data_assets" / "ddl").parts
            if "tmp" not in {part.lower() for part in relative_parts} and "temp" not in {part.lower() for part in relative_parts} and not parsed["table"].startswith("tmp_"):
                ddl_tables[parsed["table"]] = parsed
        except SchemaConsistencyError as error:
            report["unresolved"].append({"kind": "unresolved", "path": str(path), "message": str(error)})
    for path in _files(root, "data_assets/data_dictionary", ".md"):
        report["inputs"].append({"path": str(path.relative_to(root)), "sha256": sha256_file(path), "kind": "dictionary"})
    for table, ddl in sorted(ddl_tables.items()):
        dictionary = dictionaries.get(table)
        if not dictionary:
            report["differences"].append({"kind": "missing", "side": "dictionary", "table": table, "path": ddl["path"]})
        else:
            report["differences"].extend(_compare_table(ddl, dictionary))
    mappings: list[dict[str, Any]] = []
    for path in _files(root, "data_assets/mapping", ".md"):
        report["inputs"].append({"path": str(path.relative_to(root)), "sha256": sha256_file(path), "kind": "mapping"})
        try:
            mappings.extend(parse_mapping(path))
        except (OSError, UnicodeError) as error:
            report["unresolved"].append({"kind": "unresolved", "path": str(path), "message": str(error)})
    for mapping in mappings:
        target = dictionaries.get(mapping["target_table"])
        if target and mapping["target_field"] not in target["fields"]:
            report["differences"].append({"kind": "missing", "side": "dictionary", "table": mapping["target_table"], "field": mapping["target_field"], "path": mapping["source_path"]})
        if mapping["flow"] in OPTIONAL_MAPPING_FLOWS and (not mapping["source_table"] or not mapping["source_field"] or not mapping["rule"] or mapping["source_table"] == "-" or mapping["source_field"] == "-" or mapping["rule"] == "-"):
            report.setdefault("optional_unresolved", []).append({"kind": "optional_unresolved", **mapping, "message": "Mapping 来源字段或转换规则暂未补齐，按当前规则允许为空"})
    graph = build_artifact_graph(mappings, report["unresolved"])
    report["summary"] = {"ddl_tables": len(ddl_tables), "dictionary_tables": len(dictionaries), "mapping_records": len(mappings), "difference_count": len(report["differences"]), "unresolved_count": len(report["unresolved"]), "optional_unresolved_count": len(report.get("optional_unresolved", []))}
    if report["differences"] or report["unresolved"]:
        report["status"] = "blocked"
    write_yaml(task_dir / "reports" / "schema-consistency.yaml", report)
    write_yaml(task_dir / "reports" / "artifact-graph.yaml", graph)
    return report
