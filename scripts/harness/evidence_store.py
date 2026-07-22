"""Machine-verifiable evidence and blocking records."""

from __future__ import annotations

import hashlib
import json
import subprocess
from datetime import datetime, timezone
from pathlib import Path
from typing import Any

import yaml


def utc_now() -> str:
    return datetime.now(timezone.utc).isoformat(timespec="seconds")


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def write_yaml(path: Path, payload: dict[str, Any]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    temporary = path.with_suffix(path.suffix + ".tmp")
    with temporary.open("w", encoding="utf-8", newline="\n") as handle:
        yaml.safe_dump(payload, handle, allow_unicode=True, sort_keys=False)
    temporary.replace(path)


def read_yaml(path: Path) -> dict[str, Any]:
    if not path.exists():
        raise FileNotFoundError(f"文件不存在: {path}")
    with path.open("r", encoding="utf-8") as handle:
        value = yaml.safe_load(handle) or {}
    if not isinstance(value, dict):
        raise ValueError(f"YAML 根节点必须是对象: {path}")
    return value


def append_jsonl(path: Path, payload: dict[str, Any]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("a", encoding="utf-8", newline="\n") as handle:
        handle.write(json.dumps(payload, ensure_ascii=False, sort_keys=True) + "\n")


def git_revision(repo_root: Path) -> str:
    result = subprocess.run(
        ["git", "rev-parse", "HEAD"],
        cwd=repo_root,
        capture_output=True,
        text=True,
        encoding="utf-8",
        errors="replace",
        check=False,
    )
    return result.stdout.strip() if result.returncode == 0 else "UNKNOWN"


def record_file_read(
    task_dir: Path,
    evidence_id: str,
    phase: str,
    path: Path,
    repo_root: Path,
    purpose: str,
    result: str = "passed",
) -> dict[str, Any]:
    resolved = path.resolve()
    if not resolved.is_file():
        raise FileNotFoundError(f"读取证据目标不是文件: {path}")
    evidence = {
        "evidence_id": evidence_id,
        "task_id": task_dir.name,
        "phase": phase,
        "kind": "file_read",
        "path": str(resolved.relative_to(repo_root.resolve())),
        "sha256": sha256_file(resolved),
        "purpose": purpose,
        "repository_revision": git_revision(repo_root),
        "result": result,
        "created_at": utc_now(),
    }
    write_yaml(task_dir / "evidence" / f"{evidence_id}.yaml", evidence)
    append_jsonl(task_dir / "evidence.jsonl", evidence)
    return evidence


def record_event(task_dir: Path, event: dict[str, Any]) -> None:
    event = {"created_at": utc_now(), **event}
    append_jsonl(task_dir / "events.jsonl", event)
