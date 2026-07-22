"""Task lifecycle management for the local harness."""

from __future__ import annotations

import re
import subprocess
from pathlib import Path
from typing import Any

from .evidence_store import (
    read_yaml,
    record_event,
    record_file_read,
    utc_now,
    write_yaml,
)
from .state_machine import (
    BLOCKED,
    STATES,
    WORKFLOW_STATES,
    validate_required_evidence,
    validate_transition,
)
from .state_integrity import StateIntegrityError, state_seal, validate_task_integrity


TASK_ID_PATTERN = re.compile(r"^[a-z0-9][a-z0-9._-]{2,63}$")


class TaskError(ValueError):
    """Raised for invalid task operations."""


def repo_root() -> Path:
    result = subprocess.run(
        ["git", "rev-parse", "--show-toplevel"],
        capture_output=True,
        text=True,
        encoding="utf-8",
        errors="replace",
        check=False,
    )
    if result.returncode != 0:
        raise TaskError("当前目录不在 Git 仓库中")
    return Path(result.stdout.strip()).resolve()


def branch_name(root: Path) -> str:
    result = subprocess.run(
        ["git", "branch", "--show-current"],
        cwd=root,
        capture_output=True,
        text=True,
        encoding="utf-8",
        errors="replace",
        check=False,
    )
    return result.stdout.strip() or "DETACHED"


def task_dir(root: Path, task_id: str) -> Path:
    if not TASK_ID_PATTERN.fullmatch(task_id):
        raise TaskError("任务编号必须使用 3-64 位小写字母、数字、点、下划线或连字符")
    return root / ".harness" / "tasks" / task_id


def task_file(root: Path, task_id: str) -> Path:
    return task_dir(root, task_id) / "task.yaml"


def load_task(root: Path, task_id: str) -> tuple[Path, dict[str, Any]]:
    directory = task_dir(root, task_id)
    payload = read_yaml(directory / "task.yaml")
    try:
        validate_task_integrity(payload)
    except StateIntegrityError as error:
        raise TaskError(f"任务状态完整性校验失败: {error}") from error
    return directory, payload


def save_task(directory: Path, payload: dict[str, Any]) -> None:
    payload["updated_at"] = utc_now()
    payload["state_seal"] = state_seal(payload)
    write_yaml(directory / "task.yaml", payload)


def require_change_manifest(root: Path, directory: Path) -> None:
    policy_path = root / ".harness" / "policies" / "allowed_paths.yaml"
    policy = read_yaml(policy_path) if policy_path.exists() else {}
    default_policy = policy.get("default", {}) if isinstance(policy, dict) else {}
    if not default_policy.get("require_change_manifest", False):
        return
    manifest_path = directory / "change_manifest.yaml"
    if not manifest_path.exists():
        raise TaskError("任务缺少 change_manifest.yaml，未确认目标文件和只读上游范围")
    manifest = read_yaml(manifest_path)
    if manifest.get("user_confirmation") != "confirmed":
        raise TaskError("change_manifest.yaml 未记录用户确认")
    if not manifest.get("allowed_changes"):
        raise TaskError("change_manifest.yaml 缺少 allowed_changes")
    if not manifest.get("read_only_inputs"):
        raise TaskError("change_manifest.yaml 缺少 read_only_inputs")


def create_task(
    root: Path, task_id: str, purpose: str, workflow_profile: str = "data_warehouse"
) -> dict[str, Any]:
    if workflow_profile not in WORKFLOW_STATES:
        raise TaskError(f"未知工作流类型: {workflow_profile}")
    directory = task_dir(root, task_id)
    if directory.exists():
        raise TaskError(f"任务已存在: {task_id}")
    directory.mkdir(parents=True)
    payload: dict[str, Any] = {
        "schema_version": "0.1",
        "task_id": task_id,
        "purpose": purpose,
        "workflow_profile": workflow_profile,
        "state": "CREATED",
        "branch": branch_name(root),
        "created_at": utc_now(),
        "updated_at": utc_now(),
        "evidence_ids": [],
        "allowed_paths": [],
        "forbidden_paths": [],
        "history": [{"from": None, "to": "CREATED", "at": utc_now()}],
    }
    save_task(directory, payload)
    record_event(directory, {"event": "task_created", "task_id": task_id})
    return payload


def set_workflow_profile(root: Path, task_id: str, workflow_profile: str) -> dict[str, Any]:
    directory, payload = load_task(root, task_id)
    if payload.get("state") not in {"CREATED", BLOCKED}:
        raise TaskError("只有 CREATED 或因工作流缺失而阻塞的任务才能设置工作流类型")
    if workflow_profile not in WORKFLOW_STATES:
        raise TaskError(f"未知工作流类型: {workflow_profile}")
    payload["workflow_profile"] = workflow_profile
    save_task(directory, payload)
    record_event(directory, {"event": "workflow_profile_set", "workflow_profile": workflow_profile})
    return payload


def add_evidence(root: Path, task_id: str, evidence: dict[str, Any]) -> dict[str, Any]:
    directory, payload = load_task(root, task_id)
    evidence_id = str(evidence.get("evidence_id", "")).strip()
    if not evidence_id:
        raise TaskError("证据必须包含 evidence_id")
    if evidence_id in payload.get("evidence_ids", []):
        raise TaskError(f"证据编号已存在: {evidence_id}")
    write_yaml(directory / "evidence" / f"{evidence_id}.yaml", evidence)
    record_event(directory, {"event": "evidence_recorded", "evidence_id": evidence_id})
    payload.setdefault("evidence_ids", []).append(evidence_id)
    save_task(directory, payload)
    return evidence


def add_file_read_evidence(
    root: Path,
    task_id: str,
    evidence_id: str,
    phase: str,
    path: str,
    purpose: str,
) -> dict[str, Any]:
    directory, payload = load_task(root, task_id)
    if evidence_id in payload.get("evidence_ids", []):
        raise TaskError(f"证据编号已存在: {evidence_id}")
    evidence = record_file_read(
        directory, evidence_id, phase, root / path, root, purpose
    )
    payload.setdefault("evidence_ids", []).append(evidence_id)
    save_task(directory, payload)
    return evidence


def transition_task(root: Path, task_id: str, target: str, reason: str) -> dict[str, Any]:
    directory, payload = load_task(root, task_id)
    try:
        validate_task_integrity(payload, require_seal=True)
    except StateIntegrityError as error:
        raise TaskError(f"任务状态不可迁移: {error}") from error
    source = payload["state"]
    workflow = payload.get("workflow_profile", "data_warehouse")
    if (root / ".harness" / "policies" / "phase_gates.yaml").exists():
        from .gate_checker import check_gate

        check_gate(root, task_id, target)
    transition = validate_transition(source, target, workflow)
    evidence_ids = payload.get("evidence_ids", [])
    validate_required_evidence(target, evidence_ids, workflow)
    require_change_manifest(root, directory)
    payload["state"] = transition.target
    payload.setdefault("history", []).append(
        {"from": source, "to": target, "reason": reason, "at": utc_now()}
    )
    save_task(directory, payload)
    record_event(directory, {"event": "state_transition", "from": source, "to": target})
    return payload


def block_task(
    root: Path,
    task_id: str,
    reason: str,
    category: str,
    evidence: str,
    impact: str,
    recommendation: str,
    alternatives: str,
    user_decision: str,
    recovery_condition: str,
) -> dict[str, Any]:
    directory, payload = load_task(root, task_id)
    if payload["state"] == BLOCKED:
        raise TaskError("任务已经处于阻塞状态")
    previous_state = payload["state"]
    blocking = {
        "status": BLOCKED,
        "blocked_from": previous_state,
        "reason": reason,
        "category": category,
        "evidence": evidence,
        "impact": impact,
        "recommendation": recommendation,
        "alternatives": alternatives,
        "user_decision": user_decision,
        "recovery_condition": recovery_condition,
        "created_at": utc_now(),
    }
    write_yaml(directory / "blocking.yaml", blocking)
    payload["state"] = BLOCKED
    payload["blocked_from"] = previous_state
    payload.setdefault("history", []).append(
        {"from": previous_state, "to": BLOCKED, "reason": reason, "at": utc_now()}
    )
    save_task(directory, payload)
    record_event(directory, {"event": "task_blocked", "from": previous_state, "category": category})
    return blocking


def resume_task(root: Path, task_id: str, user_decision: str, recovery_evidence: str) -> dict[str, Any]:
    directory, payload = load_task(root, task_id)
    if payload.get("state") != BLOCKED:
        raise TaskError("只有 BLOCKED 任务才能恢复")
    blocking = read_yaml(directory / "blocking.yaml")
    if not user_decision.strip():
        raise TaskError("恢复任务必须记录用户决策")
    if not recovery_evidence.strip():
        raise TaskError("恢复任务必须记录恢复证据")
    previous_state = payload.get("blocked_from")
    if previous_state not in STATES:
        raise TaskError("阻塞前状态无效，不能恢复")
    blocking.update(
        {
            "status": "RESUMED",
            "user_decision": user_decision,
            "recovery_evidence": recovery_evidence,
            "resumed_at": utc_now(),
        }
    )
    write_yaml(directory / "blocking.yaml", blocking)
    payload["state"] = previous_state
    payload.pop("blocked_from", None)
    payload.setdefault("history", []).append(
        {"from": BLOCKED, "to": previous_state, "reason": "恢复条件已验证", "at": utc_now()}
    )
    save_task(directory, payload)
    record_event(directory, {"event": "task_resumed", "to": previous_state})
    return payload
