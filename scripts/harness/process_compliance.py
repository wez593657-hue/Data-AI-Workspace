"""Automated process-compliance monitoring for the harness task system.

Measures compliance across three dimensions:
  state_completion  – how many expected states were actually traversed
  evidence_coverage – how many state transitions have evidence files
  state_seal        – whether the task's integrity seal is present
"""

from __future__ import annotations

import math
from pathlib import Path
from typing import Any

from .evidence_store import read_yaml
from .state_machine import WORKFLOW_STATES


def _state_completion_score(
    actual_states: list[str], expected_states: tuple[str, ...]
) -> tuple[float, list[str]]:
    """Score based on % of expected states actually traversed.  Max 50 points."""
    expected_set = set(expected_states)
    actual_set = set(actual_states)
    if not expected_set:
        return 0.0, []
    completed = expected_set & actual_set
    missing = sorted(expected_set - actual_set)
    ratio = len(completed) / len(expected_set)
    return round(ratio * 50.0, 1), missing


def _evidence_coverage_score(
    task_dir: Path, actual_states: list[str]
) -> tuple[float, int]:
    """Score evidence coverage per state.  Max 30 points."""
    evidence_dir = task_dir / "evidence"
    if not evidence_dir.exists():
        return 0.0, 0
    evidence_files = list(evidence_dir.glob("*.yaml"))
    evidence_count = len(evidence_files)
    if not actual_states:
        return 0.0, evidence_count
    # Each state transition should have at least 1 evidence file
    ratio = min(evidence_count / len(actual_states), 1.0)
    return round(ratio * 30.0, 1), evidence_count


def _state_seal_score(task: dict[str, Any]) -> float:
    """10 points if state_seal is present, 0 otherwise."""
    return 10.0 if task.get("state_seal") else 0.0


def _checklist_score(task_dir: Path) -> float:
    """10 points if task_execution_checklist.md exists."""
    return 10.0 if (task_dir / "task_execution_checklist.md").exists() else 0.0


def _skip_detection_score(
    history: list[dict[str, Any]], expected_states: tuple[str, ...]
) -> tuple[float, list[str]]:
    """Penalty for skipping states. Max penalty: -20 points."""
    state_order = {s: i for i, s in enumerate(expected_states)}
    seen_indices = []
    for entry in history:
        state = entry.get("to", "")
        if state in state_order:
            seen_indices.append(state_order[state])
    if not seen_indices:
        return 0.0, []
    skips = []
    prev = seen_indices[0]
    for curr in seen_indices[1:]:
        gap = curr - prev
        if gap > 1:
            for i in range(prev + 1, curr):
                skips.append(expected_states[i])
        prev = curr
    penalty = min(len(skips) * 2.0, 20.0)
    return -penalty, skips


def measure_compliance(task_dir: Path, task: dict[str, Any]) -> dict[str, Any]:
    """Return a 0-100 compliance score and detailed breakdown."""
    workflow = task.get("workflow_profile", "data_warehouse")
    expected_states = WORKFLOW_STATES.get(workflow, ())
    history = task.get("history", [])
    actual_states = [h.get("to", "") for h in history if h.get("to")]

    state_score, missing_states = _state_completion_score(actual_states, expected_states)
    evidence_score, evidence_count = _evidence_coverage_score(task_dir, actual_states)
    seal_score = _state_seal_score(task)
    checklist_core = _checklist_score(task_dir)
    skip_penalty, skipped_states = _skip_detection_score(history, expected_states)

    total = max(
        round(state_score + evidence_score + seal_score + checklist_core + skip_penalty, 1),
        0.0,
    )

    level = "compliant"
    if total < 30:
        level = "critical"
    elif total < 60:
        level = "non_compliant"
    elif total < 80:
        level = "partial"

    return {
        "task_id": task.get("task_id", ""),
        "workflow": workflow,
        "state": task.get("state", ""),
        "score": total,
        "level": level,
        "breakdown": {
            "state_completion": {"score": state_score, "max": 50, "missing_states": missing_states},
            "evidence_coverage": {"score": evidence_score, "max": 30, "evidence_files": evidence_count},
            "state_seal": {"score": seal_score, "max": 10},
            "checklist": {"score": checklist_core, "max": 10},
            "skip_penalty": {"penalty": skip_penalty, "max_penalty": -20, "skipped_states": skipped_states},
        },
        "actual_states": actual_states,
        "expected_states": list(expected_states),
    }


def compliance_report(root: Path) -> dict[str, Any]:
    """Scan all active tasks and produce a compliance report."""
    tasks_dir = root / ".harness" / "tasks"
    if not tasks_dir.exists():
        return {"tasks": [], "summary": {"total": 0, "median_score": 0, "level": "empty"}}

    results = []
    for task_dir in sorted(tasks_dir.iterdir()):
        if not task_dir.is_dir():
            continue
        task_yaml = task_dir / "task.yaml"
        if not task_yaml.exists():
            continue
        task = read_yaml(task_yaml)
        lifecycle = task.get("lifecycle", "")
        if lifecycle == "archived":
            continue
        result = measure_compliance(task_dir, task)
        results.append(result)

    if not results:
        return {"tasks": [], "summary": {"total": 0, "median_score": 0, "level": "empty"}}

    scores = [r["score"] for r in results]
    scores.sort()
    n = len(scores)
    if n % 2 == 1:
        median = scores[n // 2]
    else:
        median = (scores[n // 2 - 1] + scores[n // 2]) / 2.0

    counts = {"critical": 0, "non_compliant": 0, "partial": 0, "compliant": 0}
    for r in results:
        counts[r["level"]] = counts.get(r["level"], 0) + 1

    overall = "compliant"
    if median < 30:
        overall = "critical"
    elif median < 60:
        overall = "non_compliant"
    elif median < 80:
        overall = "partial"

    return {
        "tasks": results,
        "summary": {
            "total": len(results),
            "median_score": round(median, 1),
            "level": overall,
            "counts": counts,
        },
    }


def format_report(report: dict[str, Any]) -> str:
    """Format the compliance report as human-readable text."""
    summary = report["summary"]
    lines = [
        f"=== 流程合规度报告 ===",
        f"任务总数: {summary['total']}",
        f"合规度中位数: {summary['median_score']}/100",
        f"整体评级: {summary['level']}",
        f"",
        f"分布: 严重违规={summary['counts'].get('critical', 0)} "
        f"不合规={summary['counts'].get('non_compliant', 0)} "
        f"部分合规={summary['counts'].get('partial', 0)} "
        f"合规={summary['counts'].get('compliant', 0)}",
        f"",
        f"--- 逐任务明细 ---",
    ]
    for task in report["tasks"]:
        bd = task["breakdown"]
        lines.append(
            f"  {task['task_id']} ({task['workflow']}): "
            f"{task['score']}/100 [{task['level']}] "
            f"状态={bd['state_completion']['score']}/50 "
            f"证据={bd['evidence_coverage']['score']}/30 "
            f"密封={bd['state_seal']['score']}/10 "
            f"清单={bd['checklist']['score']}/10 "
            f"跳过惩罚={bd['skip_penalty']['penalty']}"
        )
        if bd["state_completion"]["missing_states"]:
            lines.append(f"    缺失状态: {', '.join(bd['state_completion']['missing_states'][:5])}")
        if bd["skip_penalty"]["skipped_states"]:
            lines.append(f"    跳过状态: {', '.join(bd['skip_penalty']['skipped_states'][:5])}")
    return "\n".join(lines)