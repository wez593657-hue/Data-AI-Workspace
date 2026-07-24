"""Build an explicit rule-to-artifact impact report without database access."""

from __future__ import annotations

import json
from pathlib import Path
from typing import Any

import yaml


class ImpactAnalysisError(ValueError):
    """Raised when an impact manifest is incomplete or inconsistent."""


def _read_yaml(path: Path) -> dict[str, Any]:
    value = yaml.safe_load(path.read_text(encoding="utf-8")) or {}
    if not isinstance(value, dict):
        raise ImpactAnalysisError(f"Impact YAML root must be an object: {path}")
    return value


def _read_json(path: Path) -> dict[str, Any]:
    value = json.loads(path.read_text(encoding="utf-8"))
    if not isinstance(value, dict):
        raise ImpactAnalysisError(f"JSON root must be an object: {path}")
    return value


def _relative(root: Path, path: Path) -> str:
    return path.resolve().relative_to(root.resolve()).as_posix()


def _require_text(value: Any, label: str) -> str:
    text = str(value or "").strip()
    if not text:
        raise ImpactAnalysisError(f"Missing {label}")
    return text


def analyze_impact(root: Path, manifest_path: Path | None = None) -> dict[str, Any]:
    root = root.resolve()
    manifest_path = manifest_path or root / "validation" / "impact" / "deadline_reminder.yaml"
    manifest = _read_yaml(manifest_path)
    rules = manifest.get("rules")
    if not isinstance(rules, list) or not rules:
        raise ImpactAnalysisError("Impact manifest must contain a non-empty rules list")

    findings: list[dict[str, Any]] = []
    rule_ids: set[str] = set()
    for rule in rules:
        if not isinstance(rule, dict):
            raise ImpactAnalysisError("Every impact rule must be an object")
        rule_id = _require_text(rule.get("rule_id"), "rule_id")
        if rule_id in rule_ids:
            raise ImpactAnalysisError(f"Duplicate impact rule_id: {rule_id}")
        rule_ids.add(rule_id)
        source = rule.get("source")
        inputs = rule.get("inputs")
        outputs = rule.get("outputs")
        artifacts = rule.get("artifacts")
        if not isinstance(source, dict) or not source.get("document") or not source.get("section"):
            raise ImpactAnalysisError(f"Rule {rule_id} must declare source document and section")
        if not isinstance(inputs, list) or not inputs:
            raise ImpactAnalysisError(f"Rule {rule_id} must declare inputs")
        if not isinstance(outputs, list) or not outputs:
            raise ImpactAnalysisError(f"Rule {rule_id} must declare outputs")
        if not isinstance(artifacts, list) or not artifacts:
            raise ImpactAnalysisError(f"Rule {rule_id} must declare artifacts")

        missing_paths: list[str] = []
        artifact_results: list[dict[str, Any]] = []
        for artifact in artifacts:
            if not isinstance(artifact, dict):
                raise ImpactAnalysisError(f"Rule {rule_id} contains an invalid artifact")
            kind = _require_text(artifact.get("kind"), f"{rule_id}.artifact.kind")
            relative_path = _require_text(artifact.get("path"), f"{rule_id}.artifact.path")
            path = (root / relative_path).resolve()
            try:
                path.relative_to(root)
            except ValueError as error:
                raise ImpactAnalysisError(f"Artifact path escapes repository: {relative_path}") from error
            exists = path.is_file()
            if not exists:
                missing_paths.append(relative_path)
            artifact_results.append({
                "kind": kind,
                "path": relative_path,
                "exists": exists,
            })

        unresolved: list[dict[str, Any]] = []
        database_impact = rule.get("database_impact") or {}
        if not isinstance(database_impact, dict):
            raise ImpactAnalysisError(f"Rule {rule_id}.database_impact must be an object")
        impact_status = _require_text(database_impact.get("status"), f"{rule_id}.database_impact.status")
        if impact_status == "unresolved":
            unresolved.append({
                "rule_id": rule_id,
                "area": "database_impact",
                "target_table": database_impact.get("target_table", ""),
                "target_fields": database_impact.get("target_fields", []),
                "reason": _require_text(database_impact.get("reason"), f"{rule_id}.database_impact.reason"),
            })
        elif impact_status not in {"confirmed", "offline_only"}:
            raise ImpactAnalysisError(
                f"Rule {rule_id}.database_impact.status must be confirmed, offline_only, or unresolved"
            )

        findings.append({
            "rule_id": rule_id,
            "source": source,
            "inputs": inputs,
            "outputs": outputs,
            "artifacts": artifact_results,
            "missing_artifacts": missing_paths,
            "database_impact": database_impact,
            "unresolved": unresolved,
        })

    missing_artifacts = sorted({path for finding in findings for path in finding["missing_artifacts"]})
    unresolved = [item for finding in findings for item in finding["unresolved"]]
    status = "blocked" if missing_artifacts or unresolved else "passed"
    return {
        "schema_version": "0.1",
        "result": status,
        "manifest": _relative(root, manifest_path),
        "rule_count": len(findings),
        "impact_count": len(findings),
        "missing_artifacts": missing_artifacts,
        "unresolved": unresolved,
        "findings": findings,
    }


def main() -> int:
    import argparse

    parser = argparse.ArgumentParser(description="Analyze rule impact without a database")
    parser.add_argument("--root", default=".")
    parser.add_argument("--manifest", default="")
    parser.add_argument("--report", default="")
    args = parser.parse_args()
    try:
        root = Path(args.root).resolve()
        manifest = root / args.manifest if args.manifest else None
        report = analyze_impact(root, manifest)
        if args.report:
            report_path = root / args.report
            report_path.parent.mkdir(parents=True, exist_ok=True)
            report_path.write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
        print(json.dumps(report, ensure_ascii=False, indent=2))
        return 0 if report["result"] == "passed" else 1
    except (ImpactAnalysisError, FileNotFoundError, json.JSONDecodeError, yaml.YAMLError) as error:
        print(f"Impact analysis failed: {error}")
        return 2


if __name__ == "__main__":
    raise SystemExit(main())
