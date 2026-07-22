"""Policy-backed checks before a task state transition."""

from __future__ import annotations

from pathlib import Path
from typing import Any

import yaml

from .evidence_store import read_yaml
from .evidence_integrity import EvidenceIntegrityError, validate_evidence_set
from .state_machine import validate_transition
from .task_manager import load_task


class GateError(ValueError):
    """Raised when a phase gate is not satisfied."""


def check_schema_consistency_gate(root: Path, task_id: str) -> dict[str, Any]:
    """Accept only a current, complete and clean schema consistency report."""
    directory, _ = load_task(root, task_id)
    report = read_yaml(directory / "reports" / "schema-consistency.yaml")
    if report.get("status") != "passed":
        raise GateError(
            "DDL、数据字典和Mapping一致性报告未通过: "
            f"差异 {len(report.get('differences', []))} 项，"
            f"未解析 {len(report.get('unresolved', []))} 项"
        )
    if report.get("differences") or report.get("unresolved"):
        raise GateError("一致性报告包含未处理差异或未解析项")
    if not report.get("inputs") or not report.get("summary"):
        raise GateError("一致性报告缺少输入文件哈希或汇总结果")
    return {"task_id": task_id, "gate": "schema_consistency", "result": "passed", "summary": report["summary"]}


def _policy(root: Path) -> dict[str, Any]:
    path = root / ".harness" / "policies" / "phase_gates.yaml"
    with path.open("r", encoding="utf-8") as handle:
        return yaml.safe_load(handle) or {}


def _evidence_payloads(directory: Path) -> list[dict[str, Any]]:
    evidence_dir = directory / "evidence"
    payloads: list[dict[str, Any]] = []
    if not evidence_dir.exists():
        return payloads
    for path in sorted(evidence_dir.glob("*.yaml")):
        payloads.append(read_yaml(path))
    return payloads


def check_gate(root: Path, task_id: str, target: str) -> dict[str, Any]:
    directory, task = load_task(root, task_id)
    source = str(task.get("state", ""))
    workflow = task.get("workflow_profile", "data_warehouse")
    validate_transition(source, target, workflow)
    policy = _policy(root).get("workflows", {}).get(workflow, {}).get(source, {})
    allowed_targets = set(policy.get("allowed_next", []))
    if allowed_targets and target not in allowed_targets:
        raise GateError(f"门禁策略不允许状态迁移: {source} -> {target}")
    required_by_target = policy.get("required_evidence_by_target", {})
    required = list(required_by_target.get(target, policy.get("required_evidence", [])))
    evidence_policy = _policy(root).get("evidence_policy", {})
    try:
        evidence = validate_evidence_set(
            directory / "evidence",
            task_id=task_id,
            task_dir=directory,
            repo_root=root,
            expected_ids=task.get("evidence_ids", []),
            max_age_days=int(evidence_policy.get("max_age_days", 30)),
        )
    except EvidenceIntegrityError as error:
        raise GateError(f"证据完整性校验失败: {error}") from error
    purposes = {str(item.get("purpose", "")) for item in evidence}
    missing = [item for item in required if item not in purposes]
    if missing:
        raise GateError(
            f"阶段 {source} -> {target} 缺少证据类型: {', '.join(missing)}"
        )
    return {
        "task_id": task_id,
        "source": source,
        "target": target,
        "required_evidence": required,
        "result": "passed",
    }
