"""Resolve and validate the active Harness task for CI."""

from __future__ import annotations

import argparse
import os
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


def resolve_task_id(branch: str, pr_body: str = "", explicit: str = "") -> str:
    explicit = explicit.strip()
    if explicit and TASK_ID_PATTERN.fullmatch(explicit):
        return explicit
    raise TaskResolutionError("必须通过 --task-id 或 HARNESS_TASK_ID 明确指定任务编号")


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
    if task.get("state") == "COMPLETED":
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
    parser.add_argument("--task-id", default=os.environ.get("HARNESS_TASK_ID", ""))
    args = parser.parse_args()
    try:
        task_id = resolve_task_id(args.branch, explicit=args.task_id)
        validate_active_task(Path(args.root).resolve(), task_id)
    except (TaskResolutionError, FileNotFoundError, ValueError) as error:
        print(f"Harness 任务解析失败: {error}", file=sys.stderr)
        return 2
    print(f"task_id={task_id}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
