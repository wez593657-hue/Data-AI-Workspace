"""Enforce task-scoped change manifests before commit and push."""

from __future__ import annotations

import argparse
import subprocess
from pathlib import Path
from typing import Any, Iterable

try:
    from .evidence_store import read_yaml
    from .permission_guard import validate_paths
except ImportError:  # Direct execution from hooks and CI.
    import sys

    sys.path.insert(0, str(Path(__file__).resolve().parents[2]))
    from scripts.harness.evidence_store import read_yaml
    from scripts.harness.permission_guard import validate_paths


class ChangeGuardError(ValueError):
    """Raised when a change is outside the active task capability."""


def _normalize(path: str) -> str:
    return path.replace("\\", "/").lstrip("./")


def collect_changed_files(root: Path, scope: str = "worktree", base_ref: str = "") -> list[str]:
    if scope == "staged":
        commands = (["git", "diff", "--cached", "--name-only"],)
    elif scope == "commit":
        commands = (["git", "diff", "--name-only", "HEAD^", "HEAD"],)
    elif scope == "push":
        branch = subprocess.run(
            ["git", "branch", "--show-current"], cwd=root, capture_output=True,
            text=True, encoding="utf-8", check=False
        ).stdout.strip()
        commands = (["git", "diff", "--name-only", f"origin/{branch}...HEAD"],)
    elif scope == "pr":
        if not base_ref.strip():
            raise ChangeGuardError("PR 变更检查必须提供 base_ref")
        commands = (["git", "diff", "--name-only", f"origin/{base_ref}...HEAD"],)
    else:
        commands = (
            ["git", "diff", "--name-only", "HEAD"],
            ["git", "diff", "--cached", "--name-only"],
            ["git", "ls-files", "--others", "--exclude-standard"],
        )
    changed: set[str] = set()
    for command in commands:
        result = subprocess.run(
            command,
            cwd=root,
            capture_output=True,
            text=True,
            encoding="utf-8",
            errors="replace",
            check=False,
        )
        if result.returncode != 0:
            raise ChangeGuardError(f"无法读取 Git 变更: {' '.join(command)}")
        changed.update(_normalize(line.strip()) for line in result.stdout.splitlines() if line.strip())
    return sorted(changed)


def _manifest_paths(manifest: dict[str, Any], key: str) -> list[str]:
    values = manifest.get(key, []) or []
    paths = []
    for item in values:
        if isinstance(item, str):
            paths.append(_normalize(item))
        elif isinstance(item, dict) and item.get("path"):
            paths.append(_normalize(str(item["path"])))
    return paths


def validate_manifest_changes(
    manifest: dict[str, Any], changed_files: Iterable[str]
) -> dict[str, Any]:
    if manifest.get("user_confirmation") != "confirmed":
        raise ChangeGuardError("change_manifest.yaml 未记录用户确认")
    allowed = _manifest_paths(manifest, "allowed_changes")
    read_only = _manifest_paths(manifest, "read_only_inputs")
    forbidden = _manifest_paths(manifest, "forbidden_changes")
    if not allowed:
        raise ChangeGuardError("change_manifest.yaml 缺少 allowed_changes")

    changed = [_normalize(path) for path in changed_files]
    violations = validate_paths(changed, allowed, forbidden)
    read_only_set = set(read_only)
    violations.extend(f"只读输入被修改: {path}" for path in changed if path in read_only_set)
    if violations:
        raise ChangeGuardError("; ".join(sorted(set(violations))))
    return {
        "result": "passed",
        "changed_files": changed,
        "allowed_paths": allowed,
        "read_only_inputs": read_only,
    }


def check_task_changes(
    root: Path, task_id: str, scope: str = "worktree", base_ref: str = ""
) -> dict[str, Any]:
    if not task_id.strip():
        raise ChangeGuardError("必须提供 HARNESS_TASK_ID 或 --task-id")
    task_dir = root / ".harness" / "tasks" / task_id
    manifest_path = task_dir / "change_manifest.yaml"
    if not manifest_path.is_file():
        raise ChangeGuardError(f"任务缺少 change_manifest.yaml: {task_id}")
    report = validate_manifest_changes(
        read_yaml(manifest_path), collect_changed_files(root, scope, base_ref)
    )
    report["scope"] = scope
    if base_ref:
        report["base_ref"] = base_ref
    report["task_id"] = task_id
    return report


def main() -> int:
    parser = argparse.ArgumentParser(description="Harness task-scoped change guard")
    parser.add_argument("--task-id", required=True)
    parser.add_argument(
        "--scope",
        choices=["staged", "commit", "push", "pr", "worktree"],
        default="worktree",
    )
    parser.add_argument("--base-ref", default="")
    args = parser.parse_args()
    root_result = subprocess.run(
        ["git", "rev-parse", "--show-toplevel"], capture_output=True, text=True, check=True
    )
    root = Path(root_result.stdout.strip()).resolve()
    try:
        result = check_task_changes(root, args.task_id, args.scope, args.base_ref)
    except (ChangeGuardError, FileNotFoundError, ValueError) as error:
        print(f"Harness 变更门禁失败: {error}")
        return 2
    print(f"Harness 变更门禁通过: {result['task_id']} ({len(result['changed_files'])} 个文件)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
