"""Policy-backed checks before a task state transition."""

from __future__ import annotations

from pathlib import Path
from typing import Any

import yaml

from .evidence_store import read_yaml
from .state_machine import validate_transition
from .task_manager import load_task


class GateError(ValueError):
    """Raised when a phase gate is not satisfied."""


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
    evidence = _evidence_payloads(directory)
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
