"""Policy-backed checks before a task state transition."""

from __future__ import annotations

from pathlib import Path
from typing import Any

import yaml

from .evidence_store import read_yaml
from .evidence_integrity import EvidenceIntegrityError, validate_evidence
from .state_machine import validate_transition
from .task_manager import load_task


class GateError(ValueError):
    """Raised when a phase gate is not satisfied."""


_REVIEW_STAGES = {
    "REQUIREMENT_REVIEW_PASSED": "requirement_review",
    "PROCEDURE_REVIEW_PASSED": "procedure_review",
    "ASSETS_REVIEW_PASSED": "schema_consistency_review",
}


def _validate_review_gate(
    source: str, target: str, evidence: list[dict[str, Any]], required: list[str]
) -> None:
    purpose = _REVIEW_STAGES.get(source)
    if not purpose:
        return
    reviews = [item for item in evidence if item.get("kind") == "review" and item.get("purpose") == purpose]
    if not reviews:
        raise GateError(f"审核阶段 {source} 缺少结构化审核证据: {purpose}")
    review = reviews[-1]
    result = str(review.get("result", "")).strip()
    if target in {"MATERIALS_SUPPLEMENTED", "PROCEDURE_IMPLEMENTED", "CHANGE_SCOPE_IDENTIFIED"}:
        if result != "failed":
            raise GateError(f"审核退回 {source} -> {target} 必须记录 result=failed")
        if not review.get("issues") or review.get("return_to") != target:
            raise GateError("审核失败证据必须包含 issues，并将 return_to 指向退回阶段")
    elif result != "passed":
        raise GateError(f"审核通过 {source} -> {target} 必须记录 result=passed")
    if not review.get("checked_files") or not review.get("rules_checked"):
        raise GateError("审核证据必须包含 checked_files 和 rules_checked")


def _validate_skill_execution_gate(
    required: list[str], evidence: list[dict[str, Any]]
) -> None:
    """Ensure schema assets are produced through the declared skill chain."""
    if "skill_execution" not in required:
        return
    records = [item for item in evidence if item.get("purpose") == "skill_execution"]
    if not records:
        raise GateError("资产修改前缺少 skill_execution 证据")
    record = records[-1]
    skills = {str(item).strip() for item in record.get("skills", []) if str(item).strip()}
    outputs = [str(item).strip() for item in record.get("output_files", []) if str(item).strip()]
    steps = {str(item).strip() for item in record.get("steps", []) if str(item).strip()}
    if not record.get("input_workbook"):
        raise GateError("skill_execution 证据缺少 input_workbook")
    if not outputs:
        raise GateError("skill_execution 证据缺少 output_files")
    if "kingbase-ddl-generator" not in skills:
        raise GateError("Excel驱动的DDL/数据字典变更必须使用 kingbase-ddl-generator")
    if not {"excel_to_mapping", "excel_to_ddl", "excel_to_dictionary"}.issubset(steps):
        raise GateError("skill_execution 证据缺少 Excel 到 Mapping、DDL、数据字典的完整步骤")
    procedure_output = any(
        "stored_procedure" in path or path.lower().endswith(".prc.sql")
        for path in outputs
    )
    if procedure_output:
        if "prc-sql" not in skills:
            raise GateError("涉及存储过程输出时必须使用 prc-sql")
        if "validate-procedure-date-parameters" not in skills:
            raise GateError("涉及存储过程输出时必须执行日期参数校验")


def check_schema_consistency_gate(root: Path, task_id: str) -> dict[str, Any]:
    """Accept only a current, complete and clean schema consistency report."""
    directory, _ = load_task(root, task_id)
    report = read_yaml(directory / "reports" / "schema-consistency.yaml")
    if report.get("status") != "passed":
        raise GateError(
            "DDL、数据字典和Mapping一致性报告未通过: "
            f"差异 {len(report.get('differences', []))} 项，"
            f"未解析 {len(report.get('unresolved', []))} 项"
        )
    if report.get("differences") or report.get("unresolved"):
        raise GateError("一致性报告包含未处理差异或未解析项")
    if not report.get("inputs") or not report.get("summary"):
        raise GateError("一致性报告缺少输入文件哈希或汇总结果")
    return {"task_id": task_id, "gate": "schema_consistency", "result": "passed", "summary": report["summary"]}


def _policy(root: Path) -> dict[str, Any]:
    path = root / ".harness" / "policies" / "phase_gates.yaml"
    with path.open("r", encoding="utf-8") as handle:
        return yaml.safe_load(handle) or {}


def _evidence_items(directory: Path) -> list[tuple[Path, dict[str, Any]]]:
    evidence_dir = directory / "evidence"
    payloads: list[tuple[Path, dict[str, Any]]] = []
    if not evidence_dir.exists():
        return payloads
    for path in sorted(evidence_dir.glob("*.yaml")):
        payloads.append((path, read_yaml(path)))
    return payloads


def _latest_gate_evidence(
    evidence_items: list[tuple[Path, dict[str, Any]]], required: list[str]
) -> list[tuple[Path, dict[str, Any]]]:
    selected: list[tuple[Path, dict[str, Any]]] = []
    for purpose in required:
        matches = [
            item for item in evidence_items
            if str(item[1].get("purpose", "")).strip() == purpose
        ]
        if matches:
            selected.append(max(matches, key=lambda item: str(item[1].get("created_at", ""))))
    return selected


def check_gate(root: Path, task_id: str, target: str) -> dict[str, Any]:
    directory, task = load_task(root, task_id)
    source = str(task.get("state", ""))
    workflow = task.get("workflow_profile", "data_warehouse")
    validate_transition(source, target, workflow)
    policy = _policy(root).get("workflows", {}).get(workflow, {}).get(source, {})
    allowed_targets = set(policy.get("allowed_next", []))
    if allowed_targets and target not in allowed_targets:
        raise GateError(f"门禁策略不允许状态迁移: {source} -> {target}")
    required_by_target = policy.get("required_evidence_by_target", {})
    required = list(required_by_target.get(target, policy.get("required_evidence", [])))
    evidence_policy = _policy(root).get("evidence_policy", {})
    try:
        evidence_items = _evidence_items(directory)
        evidence = [payload for _, payload in evidence_items]
    except EvidenceIntegrityError as error:
        raise GateError(f"证据完整性校验失败: {error}") from error
    purposes = {str(item.get("purpose", "")) for item in evidence}
    missing = [item for item in required if item not in purposes]
    if missing:
        raise GateError(
            f"阶段 {source} -> {target} 缺少证据类型: {', '.join(missing)}"
        )
    selected = _latest_gate_evidence(evidence_items, required)
    _validate_skill_execution_gate(required, evidence)
    try:
        for path, payload in selected:
            validate_evidence(
                payload,
                task_id=task_id,
                evidence_path=path,
                task_dir=directory,
                repo_root=root,
                expected_purposes=required,
                max_age_days=int(evidence_policy.get("max_age_days", 30)),
            )
    except EvidenceIntegrityError as error:
        raise GateError(f"证据完整性校验失败: {error}") from error
    _validate_review_gate(source, target, evidence, required)
    return {
        "task_id": task_id,
        "source": source,
        "target": target,
        "required_evidence": required,
        "result": "passed",
    }
