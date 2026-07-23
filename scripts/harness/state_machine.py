"""Task state transitions and gate validation for the harness."""

from __future__ import annotations

from dataclasses import dataclass
from typing import Iterable


DATA_WAREHOUSE_STATES = (
    "CREATED",
    "WORKSPACE_CHECKED",
    "REQUIREMENT_PARSED",
    "MEMORY_CARD_VERIFIED",
    "BUSINESS_RULES_CONFIRMED",
    "DATA_LINEAGE_CONFIRMED",
    "DDL_READY",
    "DICTIONARY_READY",
    "MAPPING_READY",
    "SQL_READY",
    "PROCEDURE_READY",
    "ETL_READY",
    "REVERSE_LOGIC_PASSED",
    "TEST_PASSED",
    "USER_APPROVED",
    "FULL_VALIDATION_PASSED",
    "COMMIT_ALLOWED",
    "PUSH_ALLOWED",
    "COMPLETED",
)

HARNESS_STATES = (
    "CREATED",
    "WORKSPACE_CHECKED",
    "IMPLEMENTATION_READY",
    "QUICK_VALIDATION_PASSED",
    "FULL_VALIDATION_PASSED",
    "USER_APPROVED",
    "COMMIT_ALLOWED",
    "PUSH_ALLOWED",
    "COMPLETED",
)

REQUIREMENT_DEVELOPMENT_STATES = (
    "CREATED",
    "REQUIREMENT_ANALYZED",
    "SCOPE_CONFIRMED",
    "PROJECT_SCANNED",
    "TABLE_LINEAGE_IDENTIFIED",
    "SOURCE_CAPABILITY_ANALYZED",
    "FIELD_GAP_CONFIRMED",
    "MATERIALS_SUPPLEMENTED",
    "REQUIREMENT_REVIEW_PASSED",
    "MEMORY_CARD_UPDATED",
    "PROCEDURE_IMPLEMENTED",
    "PROCEDURE_REVIEW_PASSED",
    "TMP_TABLES_GENERATED",
    "FULL_VALIDATION_PASSED",
    "USER_APPROVED",
    "COMMIT_ALLOWED",
    "PUSH_ALLOWED",
    "COMPLETED",
)

SCHEMA_CHANGE_STATES = (
    "CREATED",
    "MAPPING_EXCEL_ANALYZED",
    "RELATED_FILES_SCANNED",
    "CHANGE_SCOPE_IDENTIFIED",
    "USER_SCOPE_CONFIRMED",
    "ASSETS_UPDATED",
    "ASSETS_REVIEW_PASSED",
    "FULL_VALIDATION_PASSED",
    "USER_APPROVED",
    "COMMIT_ALLOWED",
    "PUSH_ALLOWED",
    "COMPLETED",
)

WORKFLOW_STATES = {
    "data_warehouse": DATA_WAREHOUSE_STATES,
    "harness": HARNESS_STATES,
    "requirement_development": REQUIREMENT_DEVELOPMENT_STATES,
    "schema_change": SCHEMA_CHANGE_STATES,
}
STATES = DATA_WAREHOUSE_STATES

_EXPLICIT_NEXT = {
    "requirement_development": {
        "FIELD_GAP_CONFIRMED": {"REQUIREMENT_REVIEW_PASSED", "MATERIALS_SUPPLEMENTED"},
        "REQUIREMENT_REVIEW_PASSED": {"MEMORY_CARD_UPDATED", "MATERIALS_SUPPLEMENTED"},
        "PROCEDURE_REVIEW_PASSED": {"TMP_TABLES_GENERATED", "PROCEDURE_IMPLEMENTED"},
        "MATERIALS_SUPPLEMENTED": {"SOURCE_CAPABILITY_ANALYZED"},
    },
    "schema_change": {
        "ASSETS_REVIEW_PASSED": {"FULL_VALIDATION_PASSED", "CHANGE_SCOPE_IDENTIFIED"},
    },
}

BLOCKED = "BLOCKED"
_NEXT = {state: STATES[index + 1] for index, state in enumerate(STATES[:-1])}
class StateTransitionError(ValueError):
    """Raised when a task attempts an invalid state transition."""


@dataclass(frozen=True)
class Transition:
    source: str
    target: str


def validate_state(state: str, workflow: str = "data_warehouse") -> None:
    if workflow not in WORKFLOW_STATES:
        raise StateTransitionError(f"未知工作流类型: {workflow}")
    if state not in WORKFLOW_STATES[workflow] and state != BLOCKED:
        raise StateTransitionError(f"未知任务状态: {state}")


def expected_next(state: str, workflow: str = "data_warehouse") -> str | None:
    if workflow not in WORKFLOW_STATES:
        raise StateTransitionError(f"未知工作流类型: {workflow}")
    validate_state(state, workflow)
    if state == BLOCKED:
        return None
    states = WORKFLOW_STATES[workflow]
    index = states.index(state)
    return states[index + 1] if index + 1 < len(states) else None


def allowed_next(state: str, workflow: str = "data_warehouse") -> set[str]:
    explicit = _EXPLICIT_NEXT.get(workflow, {}).get(state)
    if explicit is not None:
        return set(explicit)
    next_state = expected_next(state, workflow)
    return {next_state} if next_state else set()


def validate_transition(
    source: str, target: str, workflow: str = "data_warehouse"
) -> Transition:
    validate_state(source, workflow)
    validate_state(target, workflow)
    if source == BLOCKED:
        raise StateTransitionError("阻塞状态必须通过 resume 恢复，不能直接迁移")
    valid_targets = allowed_next(source, workflow)
    if target not in valid_targets:
        expected = ", ".join(sorted(valid_targets)) or "无"
        raise StateTransitionError(
            f"禁止跳过状态: {source} -> {target}，当前允许的下一状态为 {expected}"
        )
    return Transition(source=source, target=target)


def validate_required_evidence(
    state: str, evidence_ids: Iterable[str], workflow: str = "data_warehouse"
) -> None:
    """Require at least one evidence item for every post-create state."""

    validate_state(state, workflow)
    if state != "CREATED" and not list(evidence_ids):
        raise StateTransitionError(f"进入 {state} 前必须提供至少一条证据")
