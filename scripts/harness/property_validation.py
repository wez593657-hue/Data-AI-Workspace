"""Check deterministic, null-safe, repeatable rule behavior offline."""

from __future__ import annotations

import importlib
import json
from pathlib import Path
from typing import Any

import yaml

from .offline_validation import validate_offline


class PropertyValidationError(ValueError):
    """Raised when property validation inputs are invalid."""


def _read_yaml(path: Path) -> dict[str, Any]:
    value = yaml.safe_load(path.read_text(encoding="utf-8")) or {}
    if not isinstance(value, dict):
        raise PropertyValidationError(f"Property YAML root must be an object: {path}")
    return value


def _read_json(path: Path) -> dict[str, Any]:
    value = json.loads(path.read_text(encoding="utf-8"))
    if not isinstance(value, dict):
        raise PropertyValidationError(f"Property JSON root must be an object: {path}")
    return value


def _load_reference(spec: str):
    try:
        module_name, function_name = spec.split(":", 1)
        function = getattr(importlib.import_module(module_name), function_name)
    except (ValueError, ImportError, AttributeError) as error:
        raise PropertyValidationError(f"Unable to load reference: {spec}") from error
    if not callable(function):
        raise PropertyValidationError(f"Reference is not callable: {spec}")
    return function


def validate_properties(root: Path, catalog_path: Path | None = None) -> dict[str, Any]:
    root = root.resolve()
    catalog_path = catalog_path or root / "validation" / "rules" / "deadline_reminder.yaml"
    catalog = _read_yaml(catalog_path)
    rules = catalog.get("rules")
    if not isinstance(rules, list) or not rules:
        raise PropertyValidationError("Rule catalog must contain rules")
    baseline = validate_offline(root, catalog_path)
    if baseline["result"] != "passed":
        raise PropertyValidationError("Offline validation must pass before property validation")

    properties: list[dict[str, Any]] = []
    for rule in rules:
        rule_id = str(rule.get("rule_id", "")).strip()
        reference = _load_reference(str(rule.get("reference", "")))
        fixture_path = root / "validation" / "fixtures" / f"{catalog_path.stem}.json"
        cases = _read_json(fixture_path).get("cases", [])
        rule_cases = [case for case in cases if case.get("rule_id") == rule_id]
        repeat_failures: list[str] = []
        null_safe = True
        exception_stability = True
        for case in rule_cases:
            payload = case.get("input", {})
            first = reference(payload)
            second = reference(payload)
            if first != second:
                repeat_failures.append(str(case.get("case_id", "")))
        try:
            null_result = reference({})
            null_safe = isinstance(null_result, dict)
        except Exception:
            null_safe = False
        invalid_payload = {"due_date": "invalid-date", "current_date": "2026-07-21", "handle_status": "0"}
        first_exception = second_exception = None
        for index in range(2):
            try:
                reference(invalid_payload)
            except Exception as error:  # The property is exception-type stability, not business inference.
                if index == 0:
                    first_exception = type(error).__name__
                else:
                    second_exception = type(error).__name__
        exception_stability = first_exception == second_exception and first_exception is not None
        passed = not repeat_failures and null_safe and exception_stability
        properties.append({
            "rule_id": rule_id,
            "case_count": len(rule_cases),
            "repeat_failures": repeat_failures,
            "null_safe": null_safe,
            "invalid_input_exception": first_exception,
            "exception_stable": exception_stability,
            "passed": passed,
        })

    passed_count = sum(1 for item in properties if item["passed"])
    return {
        "schema_version": "0.1",
        "result": "passed" if passed_count == len(properties) else "failed",
        "catalog": str(catalog_path.relative_to(root)).replace("\\", "/"),
        "rule_count": len(properties),
        "passed_rule_count": passed_count,
        "properties": properties,
    }


def main() -> int:
    import argparse

    parser = argparse.ArgumentParser(description="Validate deterministic rule properties")
    parser.add_argument("--root", default=".")
    parser.add_argument("--catalog", default="")
    parser.add_argument("--report", default="")
    args = parser.parse_args()
    try:
        root = Path(args.root).resolve()
        catalog = root / args.catalog if args.catalog else None
        report = validate_properties(root, catalog)
        if args.report:
            report_path = root / args.report
            report_path.parent.mkdir(parents=True, exist_ok=True)
            report_path.write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
        print(json.dumps(report, ensure_ascii=False, indent=2))
        return 0 if report["result"] == "passed" else 1
    except (PropertyValidationError, FileNotFoundError, json.JSONDecodeError, yaml.YAMLError) as error:
        print(f"Property validation failed: {error}")
        return 2


if __name__ == "__main__":
    raise SystemExit(main())
