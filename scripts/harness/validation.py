"""Scoped validation for the harness workflow profile."""

from __future__ import annotations

import json
import subprocess
import sys
from pathlib import Path
from typing import Any

import yaml

from .task_manager import load_task


class ValidationError(RuntimeError):
    """Raised when scoped harness validation fails."""


def _python_files(root: Path) -> list[Path]:
    return sorted((root / "scripts" / "harness").rglob("*.py"))


def _check_python_compile(root: Path) -> dict[str, Any]:
    files = _python_files(root)
    result = subprocess.run(
        [sys.executable, "-m", "py_compile", *[str(path) for path in files]],
        cwd=root,
        capture_output=True,
        text=True,
        encoding="utf-8",
        errors="replace",
        check=False,
    )
    return {
        "name": "python_compile",
        "passed": result.returncode == 0,
        "details": result.stdout + result.stderr,
    }


def _check_unit_tests(root: Path) -> dict[str, Any]:
    result = subprocess.run(
        [sys.executable, "-m", "unittest", "discover", "-s", "scripts/harness/tests", "-v"],
        cwd=root,
        capture_output=True,
        text=True,
        encoding="utf-8",
        errors="replace",
        check=False,
    )
    return {
        "name": "unit_tests",
        "passed": result.returncode == 0,
        "details": result.stdout + result.stderr,
    }


def _check_config_files(root: Path) -> dict[str, Any]:
    errors: list[str] = []
    for path in sorted((root / "scripts" / "harness" / "schemas").glob("*.json")):
        try:
            json.loads(path.read_text(encoding="utf-8"))
        except (OSError, json.JSONDecodeError) as error:
            errors.append(f"{path}: {error}")
    for path in [
        root / ".harness" / "config.yaml",
        root / ".harness" / "policies" / "allowed_paths.yaml",
        root / ".harness" / "policies" / "phase_gates.yaml",
        root / ".harness" / "policies" / "required_evidence.yaml",
    ]:
        try:
            yaml.safe_load(path.read_text(encoding="utf-8"))
        except (OSError, yaml.YAMLError) as error:
            errors.append(f"{path}: {error}")
    return {"name": "config_parse", "passed": not errors, "details": errors}


def _check_whitespace(root: Path) -> dict[str, Any]:
    paths = [root / ".harness", root / "scripts" / "harness"]
    files = [path for base in paths for path in base.rglob("*") if path.is_file()]
    errors: list[str] = []
    for path in files:
        try:
            lines = path.read_text(encoding="utf-8").splitlines()
        except UnicodeDecodeError:
            continue
        for index, line in enumerate(lines, 1):
            if line.endswith((" ", "\t")):
                errors.append(f"{path}:{index}")
    return {"name": "whitespace", "passed": not errors, "details": errors}


def validate_task(root: Path, task_id: str) -> dict[str, Any]:
    _, task = load_task(root, task_id)
    profile = task.get("workflow_profile")
    if profile not in {"harness", "requirement_development", "schema_change"}:
        raise ValidationError(f"当前 workflow_profile 不支持 Harness 完整校验: {profile}")
    checks = [
        _check_python_compile(root),
        _check_unit_tests(root),
        _check_config_files(root),
        _check_whitespace(root),
    ]
    passed = all(check["passed"] for check in checks)
    result = {"task_id": task_id, "workflow_profile": profile, "passed": passed, "checks": checks}
    if not passed:
        raise ValidationError(json.dumps(result, ensure_ascii=False))
    return result
