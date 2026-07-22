"""Stage 6 logic gate for requirement coverage and reverse procedure checks."""

from __future__ import annotations

from pathlib import Path
from typing import Any

from .evidence_store import utc_now, write_yaml
from .rule_coverage_checker import check_rule_coverage
from .reverse_logic_checker import check_reverse_logic
from .task_manager import load_task


def run_logic_gate(root: Path, task_id: str, requirement: Path, procedure: Path, target_ddl: Path | None = None) -> dict[str, Any]:
    task_dir, _ = load_task(root, task_id)
    coverage = check_rule_coverage(requirement, procedure)
    reverse = check_reverse_logic(procedure, target_ddl)
    report: dict[str, Any] = {
        "schema_version": "0.1",
        "task_id": task_id,
        "created_at": utc_now(),
        "status": "blocked" if coverage["status"] == "blocked" or reverse["status"] == "blocked" else "passed",
        "rule_coverage": coverage,
        "reverse_logic": reverse,
        "blocking_reasons": [],
    }
    for item in coverage["rules"]:
        if item["status"] in {"blocked", "unresolved"}:
            report["blocking_reasons"].append({"kind": "rule_coverage", "rule_id": item["rule_id"], "message": item["description"]})
    report["blocking_reasons"].extend(reverse["checks"]["issues"])
    write_yaml(task_dir / "reports" / "logic-gate.yaml", report)
    return report
