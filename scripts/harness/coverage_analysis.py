"""Measure rule implementation and test coverage without a database."""

from __future__ import annotations

import importlib
import json
from pathlib import Path
from typing import Any

import yaml


class CoverageAnalysisError(ValueError):
    """Raised when coverage inputs are incomplete or inconsistent."""


def _read_yaml(path: Path) -> dict[str, Any]:
    value = yaml.safe_load(path.read_text(encoding="utf-8")) or {}
    if not isinstance(value, dict):
        raise CoverageAnalysisError(f"Coverage YAML root must be an object: {path}")
    return value


def _read_json(path: Path) -> dict[str, Any]:
    value = json.loads(path.read_text(encoding="utf-8"))
    if not isinstance(value, dict):
        raise CoverageAnalysisError(f"Coverage JSON root must be an object: {path}")
    return value


def _relative(root: Path, path: Path) -> str:
    return path.resolve().relative_to(root.resolve()).as_posix()


def _load_reference(spec: str) -> bool:
    try:
        module_name, function_name = spec.split(":", 1)
        function = getattr(importlib.import_module(module_name), function_name)
    except (ValueError, ImportError, AttributeError):
        return False
    return callable(function)


def analyze_coverage(
    root: Path,
    catalog_path: Path | None = None,
    impact_report_path: Path | None = None,
) -> dict[str, Any]:
    root = root.resolve()
    catalog_path = catalog_path or root / "validation" / "rules" / "deadline_reminder.yaml"
    impact_report_path = impact_report_path or (
        root / ".harness" / "tasks" / "offline-first-development-architecture-v1" / "reports" / "impact-analysis.json"
    )
    catalog = _read_yaml(catalog_path)
    impact_report = _read_json(impact_report_path)
    rules = catalog.get("rules")
    findings_by_rule = {item.get("rule_id"): item for item in impact_report.get("findings", [])}
    if not isinstance(rules, list) or not rules:
        raise CoverageAnalysisError("Rule catalog must contain a non-empty rules list")
    if impact_report.get("result") != "passed":
        raise CoverageAnalysisError("Impact report must pass before coverage analysis")

    findings: list[dict[str, Any]] = []
    for rule in rules:
        if not isinstance(rule, dict):
            raise CoverageAnalysisError("Every rule must be an object")
        rule_id = str(rule.get("rule_id", "")).strip()
        if not rule_id:
            raise CoverageAnalysisError("Rule is missing rule_id")
        impact = findings_by_rule.get(rule_id)
        if not impact:
            raise CoverageAnalysisError(f"Rule is missing from impact report: {rule_id}")
        reference = str(rule.get("reference", "")).strip()
        reference_available = _load_reference(reference)
        required_tags = {str(tag) for tag in rule.get("required_case_tags", [])}
        fixture_path = root / "validation" / "fixtures" / f"{catalog_path.stem}.json"
        expected_path = root / "validation" / "expected" / f"{catalog_path.stem}.json"
        fixtures = _read_json(fixture_path).get("cases")
        expected = _read_json(expected_path).get("cases")
        if not isinstance(fixtures, list) or not isinstance(expected, list):
            raise CoverageAnalysisError(f"Fixture and Expected cases are required: {rule_id}")
        cases = [case for case in fixtures if case.get("rule_id") == rule_id]
        case_ids = {str(case.get("case_id", "")) for case in cases}
        expected_ids = {
            str(case.get("case_id", ""))
            for case in expected
            if str(case.get("case_id", "")) in case_ids
        }
        tags = {str(tag) for case in cases for tag in case.get("tags", [])}
        missing_tags = sorted(required_tags - tags)
        cases_complete = bool(cases) and case_ids == expected_ids
        scope = str(impact.get("database_impact", {}).get("status", "production"))
        implementation_covered = reference_available
        production_required = scope not in {"offline_only"}
        production_covered = not production_required or any(
            artifact.get("kind") in {"sql", "procedure", "production_test"}
            for artifact in impact.get("artifacts", [])
        )
        passed = implementation_covered and cases_complete and not missing_tags and production_covered
        findings.append({
            "rule_id": rule_id,
            "scope": scope,
            "reference": reference,
            "reference_available": reference_available,
            "case_count": len(cases),
            "required_case_tags": sorted(required_tags),
            "covered_case_tags": sorted(tags),
            "missing_case_tags": missing_tags,
            "cases_complete": cases_complete,
            "production_required": production_required,
            "production_covered": production_covered,
            "passed": passed,
        })

    covered_count = sum(1 for finding in findings if finding["passed"])
    return {
        "schema_version": "0.1",
        "result": "passed" if covered_count == len(findings) else "blocked",
        "catalog": _relative(root, catalog_path),
        "impact_report": _relative(root, impact_report_path),
        "rule_count": len(findings),
        "covered_rule_count": covered_count,
        "coverage_percent": round(covered_count * 100 / len(findings), 2),
        "findings": findings,
    }


def main() -> int:
    import argparse

    parser = argparse.ArgumentParser(description="Analyze rule implementation coverage")
    parser.add_argument("--root", default=".")
    parser.add_argument("--catalog", default="")
    parser.add_argument("--impact-report", default="")
    parser.add_argument("--report", default="")
    args = parser.parse_args()
    try:
        root = Path(args.root).resolve()
        catalog = root / args.catalog if args.catalog else None
        impact = root / args.impact_report if args.impact_report else None
        report = analyze_coverage(root, catalog, impact)
        if args.report:
            report_path = root / args.report
            report_path.parent.mkdir(parents=True, exist_ok=True)
            report_path.write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
        print(json.dumps(report, ensure_ascii=False, indent=2))
        return 0 if report["result"] == "passed" else 1
    except (CoverageAnalysisError, FileNotFoundError, json.JSONDecodeError, yaml.YAMLError) as error:
        print(f"Coverage analysis failed: {error}")
        return 2


if __name__ == "__main__":
    raise SystemExit(main())
