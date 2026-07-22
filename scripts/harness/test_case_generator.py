"""Generate an auditable, task-scoped static test matrix."""

from __future__ import annotations

from typing import Any

SCENARIOS = (
    ("positive", "正例"),
    ("negative", "反例"),
    ("boundary_date", "边界日期"),
    ("boundary_amount", "边界金额"),
    ("null_value", "空值"),
    ("duplicate_data", "重复数据"),
    ("no_match", "无匹配关联"),
    ("multi_match", "多匹配关联"),
    ("historical_data", "历史数据"),
    ("rerun", "重复执行"),
    ("rollback", "异常回滚"),
)


def _validate_rules(rules: list[dict[str, Any]]) -> list[str]:
    unresolved = []
    for index, rule in enumerate(rules, start=1):
        rule_id = str(rule.get("rule_id", "")).strip() or f"RULE-{index:03d}"
        source = rule.get("source")
        if rule.get("status") != "confirmed" or not isinstance(source, dict):
            unresolved.append(rule_id)
            continue
        if not str(source.get("file", "")).strip() or not str(source.get("section", "")).strip():
            unresolved.append(rule_id)
    return unresolved


def generate_matrix(
    task_id: str,
    targets: list[str],
    rules: list[dict[str, Any]],
    source_evidence: list[str] | None = None,
) -> dict[str, Any]:
    """Generate scenarios from current-task inputs without inferring business rules."""
    if not task_id.strip():
        raise ValueError("task_id不能为空")
    if not targets or any(not str(target).strip() for target in targets):
        raise ValueError("targets必须包含至少一个非空目标表")

    unresolved_rules = _validate_rules(rules)
    rule_ids = [str(rule.get("rule_id", "")).strip() for rule in rules if rule.get("rule_id")]
    status = "blocked_unresolved" if unresolved_rules or not rules else "static_matrix_ready"
    expectation = (
        "UNRESOLVED: 必须由当前任务的已确认业务规则定义验收结果"
        if status == "blocked_unresolved"
        else "由当前任务已确认业务规则定义验收结果"
    )
    cases = []
    for index, (kind, name) in enumerate(SCENARIOS, start=1):
        cases.append(
            {
                "case_id": f"{task_id.upper()}-{index:03d}",
                "kind": kind,
                "name": name,
                "targets": list(targets),
                "expectation": expectation,
                "rule_ids": rule_ids,
                "execution_status": "out_of_scope",
            }
        )
    return {
        "schema_version": "0.1",
        "task_id": task_id,
        "status": status,
        "targets": list(targets),
        "rule_ids": rule_ids,
        "unresolved_rules": unresolved_rules or (["NO_CONFIRMED_RULE"] if not rules else []),
        "source_evidence": source_evidence or [],
        "cases": cases,
    }


if __name__ == "__main__":
    import yaml

    print(yaml.safe_dump(generate_matrix("example-task", ["TARGET_TABLE"], [], []), allow_unicode=True, sort_keys=False))
