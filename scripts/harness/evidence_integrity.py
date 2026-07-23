"""Strict validation for task evidence before state transitions."""

from __future__ import annotations

import re
from datetime import datetime, timedelta, timezone
from pathlib import Path
from typing import Any, Iterable

from .evidence_store import git_revision, sha256_file


class EvidenceIntegrityError(ValueError):
    """Raised when evidence cannot be trusted for a gate."""


_REVISION_PATTERN = re.compile(r"^[0-9a-f]{7,64}$")


def _parse_time(value: Any, evidence_id: str) -> datetime:
    try:
        parsed = datetime.fromisoformat(str(value).replace("Z", "+00:00"))
    except (TypeError, ValueError) as error:
        raise EvidenceIntegrityError(f"证据 {evidence_id} 的 created_at 无效") from error
    if parsed.tzinfo is None:
        raise EvidenceIntegrityError(f"证据 {evidence_id} 的 created_at 必须包含时区")
    return parsed.astimezone(timezone.utc)


def validate_evidence(
    evidence: dict[str, Any],
    *,
    task_id: str,
    evidence_path: Path,
    task_dir: Path,
    repo_root: Path,
    expected_purposes: Iterable[str] = (),
    max_age_days: int = 30,
    now: datetime | None = None,
) -> None:
    evidence_id = str(evidence.get("evidence_id", "")).strip()
    if not evidence_id:
        raise EvidenceIntegrityError("证据缺少 evidence_id")
    if str(evidence.get("task_id", "")).strip() != task_id:
        raise EvidenceIntegrityError(f"证据 {evidence_id} 不属于当前任务 {task_id}")
    purpose = str(evidence.get("purpose", "")).strip()
    if not purpose:
        raise EvidenceIntegrityError(f"证据 {evidence_id} 缺少 purpose")
    expected = {str(item).strip() for item in expected_purposes if str(item).strip()}
    if expected and purpose not in expected:
        raise EvidenceIntegrityError(f"证据 {evidence_id} 的 purpose 不符合当前阶段: {purpose}")
    result = str(evidence.get("result", "")).strip()
    if result not in {"passed", "failed", "blocked"}:
        raise EvidenceIntegrityError(f"证据 {evidence_id} 的 result 无效: {result}")
    if result != "passed" and evidence.get("kind") != "review":
        raise EvidenceIntegrityError(f"非审核证据 {evidence_id} 的 result 必须为 passed")
    revision = str(evidence.get("repository_revision", "")).strip()
    if not _REVISION_PATTERN.fullmatch(revision):
        raise EvidenceIntegrityError(f"证据 {evidence_id} 缺少有效 repository_revision")
    current_revision = git_revision(repo_root)
    if current_revision not in {"", "UNKNOWN"} and revision != current_revision:
        raise EvidenceIntegrityError(f"证据 {evidence_id} 的 repository_revision 已过期")
    created_at = _parse_time(evidence.get("created_at"), evidence_id)
    current_time = (now or datetime.now(timezone.utc)).astimezone(timezone.utc)
    if created_at > current_time:
        raise EvidenceIntegrityError(f"证据 {evidence_id} 的 created_at 不能晚于当前时间")
    if max_age_days < 0 or current_time - created_at > timedelta(days=max_age_days):
        raise EvidenceIntegrityError(f"证据 {evidence_id} 已超过 {max_age_days} 天有效期")
    try:
        evidence_path.resolve().relative_to(task_dir.resolve())
    except ValueError as error:
        raise EvidenceIntegrityError(f"证据 {evidence_id} 不在当前任务 evidence 目录内") from error
    if evidence.get("kind") == "file_read":
        relative_path = str(evidence.get("path", "")).strip()
        if not relative_path:
            raise EvidenceIntegrityError(f"文件证据 {evidence_id} 缺少 path")
        source = (repo_root / Path(relative_path)).resolve()
        try:
            source.relative_to(repo_root.resolve())
        except ValueError as error:
            raise EvidenceIntegrityError(f"文件证据 {evidence_id} 的 path 越出仓库") from error
        if not source.is_file():
            raise EvidenceIntegrityError(f"文件证据 {evidence_id} 的源文件不存在")
        if str(evidence.get("sha256", "")).strip() != sha256_file(source):
            raise EvidenceIntegrityError(f"文件证据 {evidence_id} 的 sha256 不匹配")


def validate_evidence_set(
    evidence_dir: Path,
    *,
    task_id: str,
    task_dir: Path,
    repo_root: Path,
    expected_purposes: Iterable[str] = (),
    expected_ids: Iterable[str] = (),
    max_age_days: int = 30,
) -> list[dict[str, Any]]:
    if not evidence_dir.exists():
        raise EvidenceIntegrityError("当前任务缺少 evidence 目录")
    payloads: list[dict[str, Any]] = []
    seen: set[str] = set()
    for path in sorted(evidence_dir.glob("*.yaml")):
        from .evidence_store import read_yaml

        evidence = read_yaml(path)
        evidence_id = str(evidence.get("evidence_id", "")).strip()
        if path.stem != evidence_id:
            raise EvidenceIntegrityError(
                f"证据文件名与 evidence_id 不一致: {path.name} != {evidence_id}"
            )
        if evidence_id in seen:
            raise EvidenceIntegrityError(f"证据编号重复: {evidence_id}")
        seen.add(evidence_id)
        validate_evidence(
            evidence,
            task_id=task_id,
            evidence_path=path,
            task_dir=task_dir,
            repo_root=repo_root,
            expected_purposes=expected_purposes,
            max_age_days=max_age_days,
        )
        payloads.append(evidence)
    declared_ids = {str(item).strip() for item in expected_ids if str(item).strip()}
    actual_ids = {str(item.get("evidence_id", "")).strip() for item in payloads}
    if declared_ids != actual_ids:
        raise EvidenceIntegrityError(
            f"任务 evidence_ids 与证据文件不一致: declared={sorted(declared_ids)}, actual={sorted(actual_ids)}"
        )
    return payloads
