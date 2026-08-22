"""Read-only governance health checks.

The checker reports findings only. It never modifies, moves, deletes, renames,
or re-encodes repository files.
"""

from __future__ import annotations

import hashlib
import json
import re
from pathlib import Path
from typing import Any

import yaml


_MARKDOWN_LINK = re.compile(r"!?\[[^\]]*\]\(([^)]+)\)")
_BINARY_DEFAULTS = {".xlsx", ".xls", ".docx", ".doc", ".pyc", ".png", ".jpg", ".jpeg", ".gif", ".zip"}


def _relative(root: Path, path: Path) -> str:
    return path.resolve().relative_to(root.resolve()).as_posix()


def _is_ignored_path(relative: str) -> bool:
    parts = set(Path(relative).parts)
    return ".git" in parts or "__pycache__" in parts


def _iter_files(root: Path):
    for path in root.rglob("*"):
        if path.is_file():
            relative = _relative(root, path)
            if not _is_ignored_path(relative):
                yield path, relative


def _path_allowed(relative: str, prefixes: list[str]) -> bool:
    normalized = relative.replace("\\", "/")
    return any(normalized == prefix.rstrip("/") or normalized.startswith(prefix.rstrip("/") + "/") for prefix in prefixes)


def _is_binary_content(path: Path) -> bool:
    header = path.read_bytes()[:8]
    return header.startswith(b"PK\x03\x04") or header.startswith(b"\xd0\xcf\x11\xe0")


def _sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def _encoding_check(root: Path, policy: dict[str, Any]) -> dict[str, Any]:
    binary = {str(item).lower() for item in policy.get("binary_extensions", _BINARY_DEFAULTS)}
    allowed_gbk = [str(item).replace("\\", "/") for item in policy.get("allowed_gbk_paths", [])]
    failures: list[str] = []
    warnings: list[str] = []
    for path, relative in _iter_files(root):
        if path.suffix.lower() in binary or _is_binary_content(path):
            continue
        try:
            path.read_bytes().decode("utf-8")
        except UnicodeDecodeError:
            if _path_allowed(relative, allowed_gbk):
                warnings.append(relative)
            else:
                failures.append(relative)
    return {"status": "passed" if not failures else "failed", "failures": failures, "warnings": warnings}


def _duplicate_check(root: Path) -> dict[str, Any]:
    by_hash: dict[str, list[str]] = {}
    for path, relative in _iter_files(root):
        by_hash.setdefault(_sha256(path), []).append(relative)
    warnings = [paths for paths in by_hash.values() if len(paths) > 1]
    return {"status": "passed", "warnings": warnings, "failures": []}


def _markdown_link_check(root: Path) -> dict[str, Any]:
    failures: list[dict[str, str]] = []
    for path, relative in _iter_files(root):
        if path.suffix.lower() != ".md":
            continue
        try:
            text = path.read_text(encoding="utf-8")
        except UnicodeDecodeError:
            continue
        for target in _MARKDOWN_LINK.findall(text):
            target = target.strip().split(" ", 1)[0]
            if not target or target.startswith(("http://", "https://", "mailto:", "file:", "#")):
                continue
            target_path = (path.parent / target.split("#", 1)[0]).resolve()
            try:
                target_path.relative_to(root.resolve())
            except ValueError:
                failures.append({"source": relative, "target": target, "reason": "越出仓库"})
                continue
            if not target_path.exists():
                failures.append({"source": relative, "target": target, "reason": "目标不存在"})
    return {"status": "passed" if not failures else "failed", "failures": failures, "warnings": []}


def _source_truth_check(root: Path, policy: dict[str, Any]) -> dict[str, Any]:
    failures: list[str] = []
    warnings: list[str] = []
    for name, configured in (policy.get("source_of_truth_paths") or {}).items():
        path = root / str(configured)
        if not path.exists():
            failures.append(f"{name}: {configured}")
    requirements = root / "requirements"
    mapping = root / "data_assets" / "mapping"
    if requirements.exists() and mapping.exists():
        for path in requirements.glob("*.xlsx"):
            if (mapping / path.name).exists() and _sha256(path) == _sha256(mapping / path.name):
                warnings.append(f"mapping_duplicate_candidate:{_relative(root, path)}")
    return {"status": "passed" if not failures else "failed", "failures": failures, "warnings": warnings}


def _lifecycle_check(root: Path, policy: dict[str, Any]) -> dict[str, Any]:
    failures: list[dict[str, Any]] = []
    required = policy.get("required_metadata", [])
    fields = [str(item) for item in policy.get("required_metadata_fields", [])]
    for item in required:
        path = root / str(item)
        if not path.is_file():
            failures.append({"path": str(item), "missing": "file"})
            continue
        try:
            text = path.read_text(encoding="utf-8")
        except UnicodeDecodeError:
            failures.append({"path": str(item), "missing": "utf8 metadata"})
            continue
        missing = [field for field in fields if field not in text]
        if missing:
            failures.append({"path": str(item), "missing": missing})
    return {"status": "passed" if not failures else "failed", "failures": failures, "warnings": []}


def run_governance_check(root: Path, policy_path: Path | None = None) -> dict[str, Any]:
    policy_path = policy_path or root / "validation" / "governance" / "policy.yaml"
    policy = yaml.safe_load(policy_path.read_text(encoding="utf-8")) or {}
    checks = {
        "encoding": _encoding_check(root, policy),
        "duplicate_assets": _duplicate_check(root),
        "markdown_links": _markdown_link_check(root),
        "source_of_truth": _source_truth_check(root, policy),
        "lifecycle": _lifecycle_check(root, policy),
    }
    failed = [name for name, result in checks.items() if result["status"] == "failed"]
    return {
        "schema_version": "1.0",
        "result": "failed" if failed else "passed",
        "failed_checks": failed,
        "checks": checks,
        "read_only": True,
    }


def write_report(result: dict[str, Any], path: Path) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(result, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
