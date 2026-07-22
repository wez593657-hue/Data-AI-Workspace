"""Integrity checks for task state and transition history."""

from __future__ import annotations

import hashlib
import json
from typing import Any

from .state_machine import BLOCKED, WORKFLOW_STATES, validate_transition


class StateIntegrityError(ValueError):
    """Raised when a task state cannot be trusted."""


def _canonical_state(payload: dict[str, Any]) -> str:
    value = {
        "task_id": payload.get("task_id"),
        "workflow_profile": payload.get("workflow_profile"),
        "state": payload.get("state"),
        "history": payload.get("history", []),
    }
    return json.dumps(value, ensure_ascii=False, sort_keys=True, separators=(",", ":"))


def state_seal(payload: dict[str, Any]) -> str:
    return hashlib.sha256(_canonical_state(payload).encode("utf-8")).hexdigest()


def verify_state_seal(payload: dict[str, Any], require_seal: bool = False) -> None:
    seal = str(payload.get("state_seal", "")).strip()
    if not seal:
        if require_seal:
            raise StateIntegrityError("任务状态未封印，必须先完成旧任务迁移校验")
        return
    if seal != state_seal(payload):
        raise StateIntegrityError("任务状态封印不匹配，疑似直接修改了task.yaml")


def validate_history(payload: dict[str, Any]) -> None:
    task_id = str(payload.get("task_id", "")).strip()
    workflow = str(payload.get("workflow_profile", "")).strip()
    current = str(payload.get("state", "")).strip()
    history = payload.get("history")
    if not task_id or workflow not in WORKFLOW_STATES or not isinstance(history, list) or not history:
        raise StateIntegrityError("任务缺少有效的task_id、workflow_profile或history")
    previous = history[0].get("from")
    if previous is not None or history[0].get("to") != "CREATED":
        raise StateIntegrityError("任务历史必须从 CREATED 开始")
    for item in history[1:]:
        source = str(item.get("from", "")).strip()
        target = str(item.get("to", "")).strip()
        if not source or not target:
            raise StateIntegrityError("任务历史存在缺少from或to的记录")
        if source == BLOCKED:
            if target not in WORKFLOW_STATES[workflow]:
                raise StateIntegrityError(f"阻塞恢复目标状态无效: {target}")
            continue
        if target == BLOCKED:
            if source not in WORKFLOW_STATES[workflow]:
                raise StateIntegrityError(f"阻塞前状态无效: {source}")
            continue
        try:
            validate_transition(source, target, workflow)
        except ValueError as error:
            raise StateIntegrityError(f"任务历史存在非法跳转: {source} -> {target}") from error
    if history[-1].get("to") != current:
        raise StateIntegrityError("task.yaml当前state与history最后状态不一致")


def validate_task_integrity(payload: dict[str, Any], require_seal: bool = False) -> None:
    validate_history(payload)
    verify_state_seal(payload, require_seal=require_seal)
