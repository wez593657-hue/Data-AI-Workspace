"""Static Oracle/Kingbase dialect checks for declared SQL inputs."""

from __future__ import annotations

import json
import re
from pathlib import Path
from typing import Any

import yaml


class DialectCheckError(ValueError):
    """Raised when dialect check inputs are invalid."""


def _read_yaml(path: Path) -> dict[str, Any]:
    value = yaml.safe_load(path.read_text(encoding="utf-8")) or {}
    if not isinstance(value, dict):
        raise DialectCheckError(f"Dialect manifest root must be an object: {path}")
    return value


def check_dialect(root: Path, manifest_path: Path | None = None) -> dict[str, Any]:
    root = root.resolve()
    manifest_path = manifest_path or (
        root / ".harness" / "tasks" / "offline-first-development-architecture-v1" / "dialect_manifest.yaml"
    )
    manifest = _read_yaml(manifest_path)
    inputs = manifest.get("inputs")
    patterns = manifest.get("forbidden_patterns")
    if not isinstance(inputs, list) or not inputs:
        raise DialectCheckError("Dialect manifest must declare inputs")
    if not isinstance(patterns, list) or not patterns:
        raise DialectCheckError("Dialect manifest must declare forbidden_patterns")

    compiled: list[tuple[str, re.Pattern[str], str]] = []
    for item in patterns:
        if not isinstance(item, dict):
            raise DialectCheckError("Every dialect pattern must be an object")
        name = str(item.get("name", "")).strip()
        pattern = str(item.get("pattern", "")).strip()
        reason = str(item.get("reason", "")).strip()
        if not name or not pattern or not reason:
            raise DialectCheckError("Dialect patterns require name, pattern, and reason")
        try:
            compiled.append((name, re.compile(pattern, re.IGNORECASE), reason))
        except re.error as error:
            raise DialectCheckError(f"Invalid dialect regex {name}: {error}") from error

    findings: list[dict[str, Any]] = []
    missing_inputs: list[str] = []
    for relative_path in inputs:
        relative_path = str(relative_path).replace("\\", "/")
        path = (root / relative_path).resolve()
        try:
            path.relative_to(root)
        except ValueError as error:
            raise DialectCheckError(f"Dialect input escapes repository: {relative_path}") from error
        if not path.is_file():
            missing_inputs.append(relative_path)
            continue
        text = path.read_text(encoding="utf-8", errors="replace")
        for name, pattern, reason in compiled:
            for match in pattern.finditer(text):
                line = text.count("\n", 0, match.start()) + 1
                findings.append({
                    "path": relative_path,
                    "line": line,
                    "rule": name,
                    "reason": reason,
                })

    passed = not missing_inputs and not findings
    return {
        "schema_version": "0.1",
        "result": "passed" if passed else "failed",
        "manifest": str(manifest_path.relative_to(root)).replace("\\", "/"),
        "input_count": len(inputs),
        "missing_inputs": missing_inputs,
        "violation_count": len(findings),
        "violations": findings,
    }


def main() -> int:
    import argparse

    parser = argparse.ArgumentParser(description="Check Oracle/Kingbase SQL dialect")
    parser.add_argument("--root", default=".")
    parser.add_argument("--manifest", default="")
    parser.add_argument("--report", default="")
    args = parser.parse_args()
    try:
        root = Path(args.root).resolve()
        manifest = root / args.manifest if args.manifest else None
        report = check_dialect(root, manifest)
        if args.report:
            report_path = root / args.report
            report_path.parent.mkdir(parents=True, exist_ok=True)
            report_path.write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
        print(json.dumps(report, ensure_ascii=False, indent=2))
        return 0 if report["result"] == "passed" else 1
    except (DialectCheckError, FileNotFoundError, yaml.YAMLError) as error:
        print(f"Dialect check failed: {error}")
        return 2


if __name__ == "__main__":
    raise SystemExit(main())
