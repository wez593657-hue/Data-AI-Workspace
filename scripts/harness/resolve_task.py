"""Resolve and validate the active Harness task for CI."""

from __future__ import annotations

import argparse
import os
import re
import sys
from pathlib import Path
from typing import Any

try:
    from .evidence_store import read_yaml
    from .task_manager import TASK_ID_PATTERN
except ImportError:  # Direct execution from GitHub Actions.
    import sys

    sys.path.insert(0, str(Path(__file__).resolve().parents[2]))
    from scripts.harness.evidence_store import read_yaml
    from scripts.harness.task_manager import TASK_ID_PATTERN


class TaskResolutionError(ValueError):
    """Raised when CI cannot identify a valid active task."""


TASK_MARKER = re.compile(
    r"<!--\s*harness-task-id\s*:\s*([a-z0-9][a-z0-9._-]{2,63})\s*-->"
)
BRANCH_PREFIXES = ("feature/", "bugfix/")


def extract_task_id(pr_body: str) -> str | None:
    match = TASK_MARKER.search(pr_body or "")
    return match.group(1) if match else None


def task_id_from_branch(branch: str) -> str | None:
    for prefix in BRANCH_PREFIXES:
        if branch.startswith(prefix):
            candidate = branch[len(prefix) :]
            return candidate if TASK_ID_PATTERN.fullmatch(candidate) else None
    return None


def resolve_task_id(branch: str, pr_body: str = "", explicit: str = "") -> str:
    explicit = explicit.strip()
    marker = extract_task_id(pr_body)
    branch_task = task_id_from_branch(branch.strip())
    if explicit and marker and explicit != marker:
        raise TaskResolutionError(f"任务编号来源不一致: {explicit}, {marker}")
    if explicit:
        return explicit
    if marker:
        return marker
    if not branch_task:
        raise TaskResolutionError(
            "无法确定 Harness task_id；PR 必须包含 "
            "<!-- harness-task-id: <task_id> -->，Push 分支必须使用 feature/<task_id> 或 bugfix/<task_id>"
        )
    return branch_task


def validate_active_task(root: Path, task_id: str) -> dict[str, Any]:
    task_dir = root / ".harness" / "tasks" / task_id
    task_path = task_dir / "task.yaml"
    manifest_path = task_dir / "change_manifest.yaml"
    if not task_path.is_file():
        raise TaskResolutionError(f"任务不存在: {task_id}")
    if not manifest_path.is_file():
        raise TaskResolutionError(f"任务缺少 change_manifest.yaml: {task_id}")

    task = read_yaml(task_path)
    if task.get("task_id") != task_id:
        raise TaskResolutionError(f"task.yaml 的 task_id 不匹配: {task_id}")
    if str(task.get("lifecycle", "")).lower() == "archived":
        raise TaskResolutionError(f"任务已归档，不能用于 CI: {task_id}")
    if task.get("state") in {"COMPLETED", "PR_APPROVED"}:
        raise TaskResolutionError(f"任务已完成，不能作为活动任务: {task_id}")

    manifest = read_yaml(manifest_path)
    if manifest.get("user_confirmation") != "confirmed":
        raise TaskResolutionError(f"任务 Manifest 未记录用户确认: {task_id}")
    if not manifest.get("allowed_changes"):
        raise TaskResolutionError(f"任务 Manifest 缺少 allowed_changes: {task_id}")
    if not manifest.get("read_only_inputs"):
        raise TaskResolutionError(f"任务 Manifest 缺少 read_only_inputs: {task_id}")
    return {"task_id": task_id, "task": task, "manifest": manifest}


def main() -> int:
    parser = argparse.ArgumentParser(description="Resolve the active Harness task")
    parser.add_argument("--root", default=".")
    parser.add_argument("--branch", default=os.environ.get("GITHUB_HEAD_REF") or os.environ.get("GITHUB_REF_NAME", ""))
    parser.add_argument("--pr-body", default=os.environ.get("HARNESS_PR_BODY", ""))
    parser.add_argument("--task-id", default=os.environ.get("HARNESS_TASK_ID", ""))
    args = parser.parse_args()
    try:
        task_id = resolve_task_id(args.branch, args.pr_body, args.task_id)
        validate_active_task(Path(args.root).resolve(), task_id)
    except (TaskResolutionError, FileNotFoundError, ValueError) as error:
        print(f"Harness 任务解析失败: {error}", file=sys.stderr)
        return 2
    print(f"task_id={task_id}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
