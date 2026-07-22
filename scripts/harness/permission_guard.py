"""Path capability checks for task-scoped changes."""

from __future__ import annotations

from pathlib import PurePosixPath
from typing import Iterable


class PermissionError(ValueError):
    """Raised when a requested path is outside the task capability."""


def normalize(path: str) -> str:
    value = path.replace("\\", "/").lstrip("./")
    if not value or value.startswith("../") or "/../" in value:
        raise PermissionError(f"非法相对路径: {path}")
    return value


def matches(path: str, pattern: str) -> bool:
    path = normalize(path)
    pattern = normalize(pattern)
    if pattern.endswith("/"):
        return path.startswith(pattern)
    return path == pattern


def validate_paths(
    paths: Iterable[str], allowed: Iterable[str], forbidden: Iterable[str]
) -> list[str]:
    allowed = list(allowed)
    forbidden = list(forbidden)
    violations: list[str] = []
    for raw_path in paths:
        path = normalize(raw_path)
        if any(matches(path, pattern) for pattern in forbidden):
            violations.append(f"禁止路径: {path}")
            continue
        if allowed and not any(matches(path, pattern) for pattern in allowed):
            violations.append(f"未授权路径: {path}")
    return violations


def assert_paths_allowed(
    paths: Iterable[str], allowed: Iterable[str], forbidden: Iterable[str]
) -> None:
    violations = validate_paths(paths, allowed, forbidden)
    if violations:
        raise PermissionError("; ".join(violations))
