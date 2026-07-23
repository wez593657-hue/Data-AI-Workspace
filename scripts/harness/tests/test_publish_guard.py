from __future__ import annotations

import tempfile
import unittest
from pathlib import Path

from scripts.harness.publish_guard import (
    PublishGuardError,
    ensure_single_task_id,
    extract_task_id,
    validate_task_for_publish,
)


class PublishGuardTests(unittest.TestCase):
    def test_extract_task_id_from_trailer(self):
        self.assertEqual(
            extract_task_id("sync: update assets\n\nTask-ID: schema-change-v1\n"),
            "schema-change-v1",
        )

    def test_missing_task_id_is_rejected(self):
        with self.assertRaises(PublishGuardError):
            extract_task_id("sync: update assets")

    def test_multiple_commits_must_share_task_id(self):
        with self.assertRaises(PublishGuardError):
            ensure_single_task_id(
                [
                    "fix: one\n\nTask-ID: task-one",
                    "fix: two\n\nTask-ID: task-two",
                ]
            )

    def test_publish_requires_push_allowed(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            task_dir = root / ".harness" / "tasks" / "task-one"
            task_dir.mkdir(parents=True)
            (task_dir / "task.yaml").write_text(
                "task_id: task-one\nstate: USER_APPROVED\n", encoding="utf-8"
            )
            (task_dir / "change_manifest.yaml").write_text(
                "user_confirmation: confirmed\n"
                "allowed_changes:\n  - path: data_assets/\n"
                "read_only_inputs:\n  - docs/source.md\n",
                encoding="utf-8",
            )
            with self.assertRaisesRegex(PublishGuardError, "PUSH_ALLOWED"):
                validate_task_for_publish(root, "task-one", ["data_assets/table.sql"])

    def test_publish_rejects_out_of_scope_file(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            task_dir = root / ".harness" / "tasks" / "task-one"
            task_dir.mkdir(parents=True)
            (task_dir / "task.yaml").write_text(
                "task_id: task-one\nstate: PUSH_ALLOWED\n", encoding="utf-8"
            )
            (task_dir / "change_manifest.yaml").write_text(
                "user_confirmation: confirmed\n"
                "allowed_changes:\n  - path: data_assets/\n"
                "read_only_inputs:\n  - docs/source.md\n",
                encoding="utf-8",
            )
            with self.assertRaisesRegex(PublishGuardError, "未授权路径"):
                validate_task_for_publish(root, "task-one", ["scripts/unsafe.py"])


if __name__ == "__main__":
    unittest.main()
