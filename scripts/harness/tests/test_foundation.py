from __future__ import annotations

import tempfile
import unittest
from pathlib import Path

import yaml

from scripts.harness.memory_card_guard import MemoryCardError, verify_memory_card
from scripts.harness.read_manifest import ManifestError, validate_manifest
from scripts.harness.requirement_parser import RequirementError, parse_requirement
from scripts.harness.state_machine import StateTransitionError, validate_transition
from scripts.harness.permission_guard import PermissionError, validate_paths
from scripts.harness.task_manager import (
    TaskError,
    block_task,
    create_task,
    load_task,
    repo_root,
    resume_task,
    transition_task,
)


class StateMachineTests(unittest.TestCase):
    def test_only_next_state_is_allowed(self):
        self.assertEqual(validate_transition("CREATED", "WORKSPACE_CHECKED").target, "WORKSPACE_CHECKED")
        with self.assertRaises(StateTransitionError):
            validate_transition("CREATED", "DDL_READY")

    def test_harness_workflow_has_independent_transitions(self):
        self.assertEqual(
            validate_transition("CREATED", "WORKSPACE_CHECKED", "harness").target,
            "WORKSPACE_CHECKED",
        )
        self.assertEqual(
            validate_transition("WORKSPACE_CHECKED", "IMPLEMENTATION_READY", "harness").target,
            "IMPLEMENTATION_READY",
        )
        self.assertEqual(
            validate_transition("USER_APPROVED", "NEXT_PHASE_ALLOWED", "harness").target,
            "NEXT_PHASE_ALLOWED",
        )
        self.assertEqual(
            validate_transition("USER_APPROVED", "RELEASE_APPROVED", "harness").target,
            "RELEASE_APPROVED",
        )
        self.assertEqual(
            validate_transition("NEXT_PHASE_ALLOWED", "IMPLEMENTATION_READY", "harness").target,
            "IMPLEMENTATION_READY",
        )
        with self.assertRaises(StateTransitionError):
            validate_transition("WORKSPACE_CHECKED", "REQUIREMENT_PARSED", "harness")

    def test_path_capability_rejects_forbidden_and_unlisted_paths(self):
        violations = validate_paths(
            ["scripts/harness/cli.py", ".github/workflows/validate.yml", "data_assets/a.sql"],
            ["scripts/harness/", ".harness/"],
            [".github/"],
        )
        self.assertEqual(len(violations), 2)
        with self.assertRaises(PermissionError):
            from scripts.harness.permission_guard import assert_paths_allowed

            assert_paths_allowed([".github/workflows/validate.yml"], ["scripts/harness/"], [".github/"])


class TaskLifecycleTests(unittest.TestCase):
    def test_create_and_transition_requires_evidence(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            task_id = "demo-task"
            # Use the manager's persistence functions against an isolated fake repository.
            from scripts.harness import task_manager

            original_repo_root = task_manager.repo_root
            task_manager.repo_root = lambda: root
            try:
                create_task(root, task_id, "foundation test")
                with self.assertRaises(StateTransitionError):
                    transition_task(root, task_id, "WORKSPACE_CHECKED", "missing evidence")
            finally:
                task_manager.repo_root = original_repo_root

    def test_block_requires_complete_reason_and_resume_decision(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            task_id = "blocked-task"
            create_task(root, task_id, "blocking test")
            block_task(
                root,
                task_id,
                "需求存在歧义",
                "requirement_unclear",
                "requirements/example.md:3",
                "影响 Mapping 和存储过程",
                "请确认优先级",
                "暂停该字段",
                "等待用户确认",
                "用户确认优先级",
            )
            with self.assertRaises(TaskError):
                resume_task(root, task_id, "", "evidence")
            resume_task(root, task_id, "采用最新版本规则", "用户确认记录")
            _, payload = load_task(root, task_id)
            self.assertEqual(payload["state"], "CREATED")


class RequirementGuardTests(unittest.TestCase):
    def test_requirement_version_and_rules_are_extracted(self):
        with tempfile.TemporaryDirectory() as directory:
            requirement = Path(directory) / "customer.md"
            requirement.write_text("# Customer\n\n版本：v2.1.0\n\nREQ-CUST-001 客户必须有效\n", encoding="utf-8")
            parsed = parse_requirement(requirement)
            self.assertEqual(parsed["version"], "v2.1.0")
            self.assertEqual(parsed["rule_count"], 1)

    def test_real_requirement_index_ignores_template_versions_and_rules(self):
        root = Path(__file__).parents[3]
        parsed = parse_requirement(root / "requirements" / "需求文档索引.md")
        self.assertEqual(parsed["version"], "v2.1")
        self.assertEqual([rule["rule_id"] for rule in parsed["rules"]], ["REQ-001"])

    def test_missing_version_and_memory_version_mismatch_block(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            requirement = root / "customer.md"
            requirement.write_text("# Customer\nREQ-CUST-001 规则\n", encoding="utf-8")
            with self.assertRaises(RequirementError):
                parse_requirement(requirement)
            requirement.write_text("版本：v2.1.0\nREQ-CUST-001 规则\n", encoding="utf-8")
            card = root / "customer规则记忆卡片.md"
            card.write_text("版本：v2.0.0\n", encoding="utf-8")
            with self.assertRaises(MemoryCardError):
                verify_memory_card(requirement)

    def test_manifest_rejects_reverse_order_and_missing_required_file(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            manifest = root / "read_manifest.yaml"
            payload = {"read_order": [
                {"path": "mapping.md", "purpose": "ods_to_dwd_mapping", "required": True},
                {"path": "rules.md", "purpose": "requirement", "required": True},
            ]}
            (root / "mapping.md").write_text("mapping", encoding="utf-8")
            (root / "rules.md").write_text("rules", encoding="utf-8")
            manifest.write_text(yaml.safe_dump(payload), encoding="utf-8")
            with self.assertRaises(ManifestError):
                validate_manifest(manifest, root)


if __name__ == "__main__":
    unittest.main()
