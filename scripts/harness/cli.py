"""Command line entry point for the local harness foundation."""

from __future__ import annotations

import argparse
import json
import sys
from datetime import datetime, timezone

from .gate_checker import GateError, check_gate, check_schema_consistency_gate
from .asset_sync import sync_dictionary_types
from .memory_card_guard import MemoryCardError, verify_memory_card
from .mapping_excel_sync import sync_mapping_markdown
from .read_manifest import ManifestError, validate_manifest
from .requirement_parser import RequirementError, parse_requirement
from .schema_consistency import SchemaConsistencyError, run_schema_consistency
from .validation import ValidationError, validate_task
from .task_manager import (
    TaskError,
    add_file_read_evidence,
    block_task,
    branch_name,
    create_task,
    load_task,
    repo_root,
    resume_task,
    transition_task,
)


def parser() -> argparse.ArgumentParser:
    command = argparse.ArgumentParser(description="AI 数据仓库开发 Harness")
    subparsers = command.add_subparsers(dest="command", required=True)

    create = subparsers.add_parser("create", help="创建任务")
    create.add_argument("task_id")
    create.add_argument("--purpose", required=True)
    create.add_argument("--workflow-profile", choices=["data_warehouse", "harness"], default="data_warehouse")

    profile = subparsers.add_parser("set-profile", help="设置任务工作流类型")
    profile.add_argument("task_id")
    profile.add_argument("workflow_profile", choices=["data_warehouse", "harness"])

    status = subparsers.add_parser("status", help="查看任务")
    status.add_argument("task_id")

    transition = subparsers.add_parser("transition", help="迁移任务状态")
    transition.add_argument("task_id")
    transition.add_argument("target")
    transition.add_argument("--reason", required=True)

    gate = subparsers.add_parser("check-gate", help="检查阶段门禁")
    gate.add_argument("task_id")
    gate.add_argument("target")

    validate = subparsers.add_parser("validate", help="执行 Harness 任务范围完整校验")
    validate.add_argument("task_id")

    requirement = subparsers.add_parser("parse-requirement", help="解析需求版本和业务规则")
    requirement.add_argument("path")

    memory = subparsers.add_parser("check-memory-card", help="核对需求与记忆卡片版本")
    memory.add_argument("requirement")

    manifest = subparsers.add_parser("check-manifest", help="检查读取清单顺序和文件")
    manifest.add_argument("path")

    consistency = subparsers.add_parser("check-schema-consistency", help="执行全量DDL、数据字典和Mapping一致性校验")
    consistency.add_argument("task_id")

    consistency_gate = subparsers.add_parser("check-schema-gate", help="检查一致性报告是否允许通过门禁")
    consistency_gate.add_argument("task_id")

    sync_mapping = subparsers.add_parser("sync-mapping-md", help="按三个Mapping Excel重新生成Markdown")

    sync_assets = subparsers.add_parser("sync-dictionary-types", help="按DDL同步数据字典类型、长度并统一DATE")

    read = subparsers.add_parser("record-read", help="记录文件读取证据")
    read.add_argument("task_id")
    read.add_argument("evidence_id")
    read.add_argument("path")
    read.add_argument("--phase", required=True)
    read.add_argument("--purpose", required=True)

    evidence = subparsers.add_parser("record", help="记录通用证据")
    evidence.add_argument("task_id")
    evidence.add_argument("evidence_id")
    evidence.add_argument("--phase", required=True)
    evidence.add_argument("--kind", required=True)
    evidence.add_argument("--purpose", required=True)
    evidence.add_argument("--result", choices=["passed", "failed", "blocked"], default="passed")
    evidence.add_argument("--details", default="")

    block = subparsers.add_parser("block", help="阻塞任务")
    block.add_argument("task_id")
    for name in (
        "reason",
        "category",
        "evidence",
        "impact",
        "recommendation",
        "alternatives",
        "user_decision",
        "recovery_condition",
    ):
        block.add_argument(f"--{name.replace('_', '-')}", required=True)

    resume = subparsers.add_parser("resume", help="恢复任务")
    resume.add_argument("task_id")
    resume.add_argument("--user-decision", required=True)
    resume.add_argument("--recovery-evidence", required=True)
    return command


def main(argv: list[str] | None = None) -> int:
    args = parser().parse_args(argv)
    try:
        root = repo_root()
        if args.command == "create":
            result = create_task(root, args.task_id, args.purpose, args.workflow_profile)
        elif args.command == "set-profile":
            from .task_manager import set_workflow_profile

            result = set_workflow_profile(root, args.task_id, args.workflow_profile)
        elif args.command == "status":
            _, result = load_task(root, args.task_id)
        elif args.command == "transition":
            result = transition_task(root, args.task_id, args.target, args.reason)
        elif args.command == "check-gate":
            result = check_gate(root, args.task_id, args.target)
        elif args.command == "validate":
            result = validate_task(root, args.task_id)
        elif args.command == "parse-requirement":
            result = parse_requirement(root / args.path)
        elif args.command == "check-memory-card":
            result = verify_memory_card(root / args.requirement)
        elif args.command == "check-manifest":
            result = validate_manifest(root / args.path, root)
        elif args.command == "check-schema-consistency":
            result = run_schema_consistency(root, args.task_id)
        elif args.command == "check-schema-gate":
            result = check_schema_consistency_gate(root, args.task_id)
        elif args.command == "sync-mapping-md":
            result = sync_mapping_markdown(root)
        elif args.command == "sync-dictionary-types":
            result = sync_dictionary_types(root)
        elif args.command == "record-read":
            result = add_file_read_evidence(
                root, args.task_id, args.evidence_id, args.phase, args.path, args.purpose
            )
        elif args.command == "record":
            details = {
                "evidence_id": args.evidence_id,
                "phase": args.phase,
                "kind": args.kind,
                "purpose": args.purpose,
                "result": args.result,
                "details": args.details,
                "created_at": datetime.now(timezone.utc).isoformat(timespec="seconds"),
            }
            from .task_manager import add_evidence

            result = add_evidence(root, args.task_id, details)
        elif args.command == "block":
            result = block_task(
                root,
                args.task_id,
                args.reason,
                args.category,
                args.evidence,
                args.impact,
                args.recommendation,
                args.alternatives,
                args.user_decision,
                args.recovery_condition,
            )
        else:
            result = resume_task(
                root, args.task_id, args.user_decision, args.recovery_evidence
            )
        print(json.dumps(result, ensure_ascii=False, indent=2, default=str))
        return 0
    except (
        TaskError,
        GateError,
        ValidationError,
        RequirementError,
        MemoryCardError,
        ManifestError,
        SchemaConsistencyError,
        FileNotFoundError,
        ValueError,
    ) as error:
        print(f"Harness 操作失败: {error}", file=sys.stderr)
        return 2


if __name__ == "__main__":
    raise SystemExit(main())
