"""Route user commands to the controlled CRM development workflow."""

from __future__ import annotations

from typing import Any


class WorkflowRoutingError(ValueError):
    """Raised when a command cannot be routed safely."""


REQUIREMENT_TERMS = (
    "需求开发", "需求文档", "业务需求", "业务规则", "目标表", "生成存储过程", "修改存储过程",
    "requirement", "stored procedure", "procedure",
)
SCHEMA_TERMS = (
    "表结构变更", "表结构修改", "mapping excel", "mapping", "同步excel", "同步 excel",
    "md/dd", "数据字典", "字段结构", "schema change", "data dictionary",
)
READ_ONLY_TERMS = ("分析", "扫描", "查看", "校验", "对比", "analyse", "analyze", "scan", "compare")
WRITE_ACTION_TERMS = ("开发", "生成", "修改", "创建", "更新", "同步", "实现", "develop", "generate", "modify", "create", "update", "sync")
PROCEDURE_ASSET_TERMS = ("存储过程", "procedure", "prc_")


def _matches(command: str, terms: tuple[str, ...]) -> list[str]:
    normalized = command.casefold()
    return [term for term in terms if term.casefold() in normalized]


def _schema_required_skills(command: str) -> list[str]:
    """Return the concrete skills required by a schema synchronization task."""
    skills = ["crm-schema-change", "kingbase-ddl-generator"]
    if _matches(command, PROCEDURE_ASSET_TERMS):
        skills.extend(["prc-sql", "validate-procedure-date-parameters"])
    return skills


def route_command(command: str) -> dict[str, Any]:
    text = str(command or "").strip()
    if not text:
        raise WorkflowRoutingError("用户命令为空，无法选择开发流程")
    requirement_matches = _matches(text, REQUIREMENT_TERMS)
    schema_matches = _matches(text, SCHEMA_TERMS)
    readonly_matches = _matches(text, READ_ONLY_TERMS)
    write_action = bool(_matches(text, WRITE_ACTION_TERMS))
    if readonly_matches and not write_action:
        return {
            "profile": "read_only",
            "skill": None,
            "reason": {"read_only": readonly_matches},
            "follow_up": None,
            "read_only": True,
            "required_skills": [],
        }
    if requirement_matches and schema_matches:
        return {
            "profile": "requirement_development",
            "skill": "crm-requirement-development",
            "reason": {"requirement": requirement_matches, "schema": schema_matches},
            "follow_up": "schema_change",
            "read_only": False,
            "required_skills": ["crm-requirement-development"],
            "follow_up_skills": _schema_required_skills(text),
        }
    if requirement_matches:
        return {
            "profile": "requirement_development",
            "skill": "crm-requirement-development",
            "reason": {"requirement": requirement_matches},
            "follow_up": None,
            "read_only": False,
            "required_skills": ["crm-requirement-development"],
        }
    if schema_matches:
        return {
            "profile": "schema_change",
            "skill": "crm-schema-change",
            "reason": {"schema": schema_matches},
            "follow_up": None,
            "read_only": False,
            "required_skills": _schema_required_skills(text),
        }
    if readonly_matches:
        return {
            "profile": "read_only",
            "skill": None,
            "reason": {"read_only": readonly_matches},
            "follow_up": None,
            "read_only": True,
            "required_skills": [],
        }
    raise WorkflowRoutingError("命令语义不足以确定需求开发、表结构变更或只读分析流程")
