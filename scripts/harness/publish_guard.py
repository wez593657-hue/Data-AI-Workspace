"""Validate Harness authorization before publishing commits."""

from __future__ import annotations

import argparse
import re
import subprocess
from pathlib import Path
from typing import Iterable

try:
    from .change_guard import ChangeGuardError, validate_manifest_changes
    from .evidence_store import read_yaml
except ImportError:  # Direct execution from hooks and CI.
    import sys

    sys.path.insert(0, str(Path(__file__).resolve().parents[2]))
    from scripts.harness.change_guard import ChangeGuardError, validate_manifest_changes
    from scripts.harness.evidence_store import read_yaml


TASK_ID_RE = re.compile(r"(?im)^Task-ID:\s*([a-z0-9][a-z0-9._-]{2,63})\s*$")
ZERO_SHA = "0" * 40


class PublishGuardError(ValueError):
    """Raised when a push is not authorized by Harness."""


def extract_task_id(message: str) -> str:
    matches = TASK_ID_RE.findall(message or "")
    if not matches:
        raise PublishGuardError("提交信息缺少 Task-ID trailer")
    unique = set(matches)
    if len(unique) != 1:
        raise PublishGuardError("单个提交包含多个不同的 Task-ID trailer")
    return matches[0]


def ensure_single_task_id(messages: Iterable[str]) -> str:
    task_ids = [extract_task_id(message) for message in messages]
    if not task_ids:
        raise PublishGuardError("待推送提交为空")
    unique = set(task_ids)
    if len(unique) != 1:
        raise PublishGuardError(
            "待推送提交必须使用同一个 Task-ID: " + ", ".join(sorted(unique))
        )
    return task_ids[0]


def validate_task_for_publish(root: Path, task_id: str, changed_files: Iterable[str]) -> dict:
    task_dir = root / ".harness" / "tasks" / task_id
    task_path = task_dir / "task.yaml"
    manifest_path = task_dir / "change_manifest.yaml"
    if not task_path.is_file():
        raise PublishGuardError(f"任务不存在或缺少 task.yaml: {task_id}")
    if not manifest_path.is_file():
        raise PublishGuardError(f"任务缺少 change_manifest.yaml: {task_id}")

    task = read_yaml(task_path)
    if task.get("task_id") != task_id:
        raise PublishGuardError(f"task.yaml 的 task_id 不匹配: {task_id}")
    if str(task.get("lifecycle", "")).lower() == "archived":
        raise PublishGuardError(f"任务已归档，不能推送: {task_id}")
    if task.get("state") != "PUSH_ALLOWED":
        raise PublishGuardError(
            f"任务状态必须为 PUSH_ALLOWED，当前为 {task.get('state', '<missing>')}: {task_id}"
        )

    manifest = read_yaml(manifest_path)
    try:
        report = validate_manifest_changes(manifest, changed_files)
    except (ChangeGuardError, FileNotFoundError, ValueError) as error:
        raise PublishGuardError(str(error)) from error
    return {"task_id": task_id, "state": task["state"], **report}


def git_output(root: Path, args: list[str]) -> str:
    result = subprocess.run(
        ["git", *args],
        cwd=root,
        capture_output=True,
        text=True,
        encoding="utf-8",
        errors="replace",
        check=False,
    )
    if result.returncode != 0:
        raise PublishGuardError(result.stderr.strip() or f"Git 命令失败: git {' '.join(args)}")
    return result.stdout


def revision_list(root: Path, old_sha: str, new_sha: str) -> list[str]:
    if new_sha == ZERO_SHA:
        return []
    if old_sha == ZERO_SHA:
        return [new_sha]
    output = git_output(root, ["rev-list", "--reverse", f"{old_sha}..{new_sha}"])
    return [line.strip() for line in output.splitlines() if line.strip()]


def changed_files(root: Path, old_sha: str, new_sha: str) -> list[str]:
    if new_sha == ZERO_SHA:
        return []
    if old_sha == ZERO_SHA:
        output = git_output(root, ["ls-tree", "-r", "--name-only", new_sha])
    else:
        output = git_output(root, ["diff", "--name-only", f"{old_sha}..{new_sha}"])
    return [line.strip() for line in output.splitlines() if line.strip()]


def validate_push(root: Path, old_sha: str, new_sha: str) -> dict:
    revisions = revision_list(root, old_sha, new_sha)
    if not revisions:
        return {"result": "skipped", "reason": "删除引用或没有新增提交"}
    messages = [git_output(root, ["show", "-s", "--format=%B", revision]) for revision in revisions]
    task_id = ensure_single_task_id(messages)
    report = validate_task_for_publish(root, task_id, changed_files(root, old_sha, new_sha))
    return {"result": "passed", "revision_count": len(revisions), **report}


def main() -> int:
    parser = argparse.ArgumentParser(description="Harness publish guard")
    parser.add_argument("--root", default=".")
    parser.add_argument("--old", required=True)
    parser.add_argument("--new", required=True)
    args = parser.parse_args()
    try:
        report = validate_push(Path(args.root).resolve(), args.old, args.new)
    except (PublishGuardError, FileNotFoundError, ValueError) as error:
        print(f"Harness 发布门禁失败: {error}")
        return 2
    print(f"Harness 发布门禁通过: {report}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
