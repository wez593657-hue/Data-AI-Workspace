"""Extract and validate statically observable SQL/procedure logic."""

from __future__ import annotations

import re
from pathlib import Path
from typing import Any

from .schema_consistency import parse_ddl


def _issues(content: str) -> list[dict[str, str]]:
    issues: list[dict[str, str]] = []
    if re.search(r"\bSELECT\s+\*", content, re.IGNORECASE):
        issues.append({"kind": "select_star", "message": "禁止使用 SELECT *"})
    joins = len(re.findall(r"\b(?:INNER|LEFT|RIGHT|FULL|CROSS)?\s+JOIN\b", content, re.IGNORECASE))
    ons = len(re.findall(r"\bON\b", content, re.IGNORECASE))
    if joins > ons:
        issues.append({"kind": "join_condition_missing", "message": f"JOIN数量{joins}大于ON数量{ons}"})
    if not re.search(r"\bCOMMIT\b", content, re.IGNORECASE):
        issues.append({"kind": "transaction_missing", "message": "未发现COMMIT"})
    if not re.search(r"\bEXCEPTION\b", content, re.IGNORECASE) or not re.search(r"\bROLLBACK\b", content, re.IGNORECASE):
        issues.append({"kind": "exception_handling_missing", "message": "异常处理或ROLLBACK不完整"})
    return issues


def check_reverse_logic(procedure: Path, target_ddl: Path | None = None) -> dict[str, Any]:
    content = procedure.read_text(encoding="utf-8", errors="replace")
    targets = sorted(set(re.findall(r"\b(?:INSERT\s+INTO|UPDATE|DELETE\s+FROM)\s+([A-Z][A-Z0-9_$]+)", content, re.IGNORECASE)))
    sources = sorted(set(re.findall(r"\b(?:FROM|JOIN)\s+([A-Z][A-Z0-9_$]+)", content, re.IGNORECASE)))
    issues = _issues(content)
    target_field_check: dict[str, Any] = {"status": "not_checked"}
    if target_ddl and target_ddl.exists():
        ddl = parse_ddl(target_ddl)
        target_name = re.escape(ddl["table"])
        insert = re.search(rf"INSERT\s+INTO\s+{target_name}\s*\((.*?)\)\s*SELECT", content, re.IGNORECASE | re.DOTALL)
        if insert:
            field_block = re.sub(r"--[^\r\n]*", "", insert.group(1))
            fields = set(re.findall(r"\b[A-Z][A-Z0-9_$]*\b", field_block, re.IGNORECASE))
            fields = {field.lower() for field in fields}
            missing = sorted(fields - set(ddl["fields"]))
            target_field_check = {"status": "passed" if not missing else "blocked", "missing_in_ddl": missing, "insert_field_count": len(fields)}
            if missing:
                issues.append({"kind": "target_field_missing", "message": f"INSERT目标字段不在DDL: {', '.join(missing)}"})
    return {
        "procedure": str(procedure),
        "targets": targets,
        "sources": sources,
        "checks": {"issues": issues, "target_field_check": target_field_check},
        "status": "blocked" if issues else "passed",
    }
