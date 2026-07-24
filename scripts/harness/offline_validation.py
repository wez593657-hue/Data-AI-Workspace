"""Run deterministic rule tests without a database connection."""

from __future__ import annotations

import importlib
import json
from pathlib import Path
from typing import Any

import yaml


class OfflineValidationError(ValueError):
    """Raised when offline validation inputs are incomplete or invalid."""


def _read_yaml(path: Path) -> dict[str, Any]:
    value = yaml.safe_load(path.read_text(encoding="utf-8")) or {}
    if not isinstance(value, dict):
        raise OfflineValidationError(f"YAML 根节点必须是对象: {path}")
    return value


def _read_json(path: Path) -> dict[str, Any]:
    value = json.loads(path.read_text(encoding="utf-8"))
    if not isinstance(value, dict):
        raise OfflineValidationError(f"JSON 根节点必须是对象: {path}")
    return value


def _reference_function(spec: str):
    try:
        module_name, function_name = spec.split(":", 1)
        function = getattr(importlib.import_module(module_name), function_name)
    except (ValueError, ImportError, AttributeError) as error:
        raise OfflineValidationError(f"无法加载参考实现: {spec}") from error
    if not callable(function):
        raise OfflineValidationError(f"参考实现不可调用: {spec}")
    return function


def _unique(items: list[str], label: str) -> None:
    duplicates = sorted({item for item in items if items.count(item) > 1})
    if duplicates:
        raise OfflineValidationError(f"{label}存在重复编号: {', '.join(duplicates)}")


def validate_offline(root: Path, catalog_path: Path | None = None) -> dict[str, Any]:
    root = root.resolve()
    catalog_path = catalog_path or root / "validation" / "rules" / "deadline_reminder.yaml"
    catalog = _read_yaml(catalog_path)
    rules = catalog.get("rules")
    if not isinstance(rules, list) or not rules:
        raise OfflineValidationError("规则目录必须包含非空 rules 列表")

    rule_index: dict[str, dict[str, Any]] = {}
    for rule in rules:
        if not isinstance(rule, dict):
            raise OfflineValidationError("规则目录中的每条规则必须是对象")
        rule_id = str(rule.get("rule_id", "")).strip()
        if not rule_id or not rule.get("source") or not rule.get("reference"):
            raise OfflineValidationError(f"规则缺少 rule_id、source 或 reference: {rule}")
        if rule_id in rule_index:
            raise OfflineValidationError(f"规则编号重复: {rule_id}")
        if rule.get("status") == "unresolved":
            raise OfflineValidationError(f"未解决规则禁止进入离线验证: {rule_id}")
        rule_index[rule_id] = rule

    fixture_path = root / "validation" / "fixtures" / f"{catalog_path.stem}.json"
    expected_path = root / "validation" / "expected" / f"{catalog_path.stem}.json"
    fixtures = _read_json(fixture_path).get("cases")
    expected = _read_json(expected_path).get("cases")
    if not isinstance(fixtures, list) or not isinstance(expected, list):
        raise OfflineValidationError("Fixture 和 Expected 必须包含 cases 列表")

    fixture_ids = [str(case.get("case_id", "")) for case in fixtures]
    expected_ids = [str(case.get("case_id", "")) for case in expected]
    _unique(fixture_ids, "Fixture case_id")
    _unique(expected_ids, "Expected case_id")
    if set(fixture_ids) != set(expected_ids):
        raise OfflineValidationError("Fixture 与 Expected 的 case_id 不一致")

    expected_index = {case["case_id"]: case.get("output") for case in expected}
    tested_rules: set[str] = set()
    tag_index: dict[str, set[str]] = {rule_id: set() for rule_id in rule_index}
    results: list[dict[str, Any]] = []
    for case in fixtures:
        if not isinstance(case, dict):
            raise OfflineValidationError("Fixture 中的每条 case 必须是对象")
        case_id = str(case.get("case_id", "")).strip()
        rule_id = str(case.get("rule_id", "")).strip()
        if rule_id not in rule_index:
            raise OfflineValidationError(f"Fixture 引用了不存在的规则: {rule_id}")
        if not isinstance(case.get("input"), dict):
            raise OfflineValidationError(f"Fixture 缺少 input 对象: {case_id}")
        tags = case.get("tags", [])
        if not isinstance(tags, list):
            raise OfflineValidationError(f"Fixture tags 必须是列表: {case_id}")

        actual = _reference_function(rule_index[rule_id]["reference"])(case["input"])
        expected_output = expected_index[case_id]
        passed = actual == expected_output
        tested_rules.add(rule_id)
        tag_index[rule_id].update(str(tag) for tag in tags)
        results.append({
            "case_id": case_id,
            "rule_id": rule_id,
            "tags": tags,
            "passed": passed,
            "actual": actual,
            "expected": expected_output,
        })

    missing_rules = sorted(set(rule_index) - tested_rules)
    missing_tags = {
        rule_id: sorted(set(rule.get("required_case_tags", [])) - tag_index[rule_id])
        for rule_id, rule in rule_index.items()
    }
    missing_tags = {rule_id: tags for rule_id, tags in missing_tags.items() if tags}
    failed_cases = [result["case_id"] for result in results if not result["passed"]]
    passed = not missing_rules and not missing_tags and not failed_cases
    return {
        "schema_version": "0.1",
        "result": "passed" if passed else "failed",
        "catalog": str(catalog_path.relative_to(root)),
        "rule_count": len(rule_index),
        "tested_rule_count": len(tested_rules),
        "case_count": len(results),
        "passed_case_count": len(results) - len(failed_cases),
        "failed_cases": failed_cases,
        "missing_rules": missing_rules,
        "missing_case_tags": missing_tags,
        "cases": results,
    }


def main() -> int:
    import argparse

    parser = argparse.ArgumentParser(description="离线规则验证")
    parser.add_argument("--root", default=".")
    parser.add_argument("--catalog", default="")
    parser.add_argument("--report", default="")
    args = parser.parse_args()
    try:
        root = Path(args.root).resolve()
        report = validate_offline(root, Path(args.catalog) if args.catalog else None)
        if args.report:
            report_path = root / args.report
            report_path.parent.mkdir(parents=True, exist_ok=True)
            report_path.write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
        print(json.dumps(report, ensure_ascii=False, indent=2))
        return 0 if report["result"] == "passed" else 1
    except (OfflineValidationError, FileNotFoundError, json.JSONDecodeError, yaml.YAMLError) as error:
        print(f"离线验证失败: {error}")
        return 2


if __name__ == "__main__":
    raise SystemExit(main())
