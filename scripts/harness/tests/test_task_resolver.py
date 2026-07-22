import unittest

from scripts.harness.resolve_task import (
    TaskResolutionError,
    extract_task_id,
    resolve_task_id,
    task_id_from_branch,
)


class TaskResolverTests(unittest.TestCase):
    def test_extracts_explicit_pr_marker(self):
        body = "说明\n<!-- harness-task-id: maturity-takeover-v2 -->\n"
        self.assertEqual(extract_task_id(body), "maturity-takeover-v2")

    def test_branch_fallback_requires_supported_prefix(self):
        self.assertEqual(task_id_from_branch("feature/maturity-takeover-v2"), "maturity-takeover-v2")
        self.assertIsNone(task_id_from_branch("master"))

    def test_missing_task_source_blocks(self):
        with self.assertRaises(TaskResolutionError):
            resolve_task_id("master")

    def test_pr_marker_can_differ_from_branch_name(self):
        self.assertEqual(
            resolve_task_id(
                "feature/maturity-takeover",
                "<!-- harness-task-id: phase6-deadline-detail-v1 -->",
            ),
            "phase6-deadline-detail-v1",
        )

    def test_conflicting_explicit_sources_block(self):
        with self.assertRaises(TaskResolutionError):
            resolve_task_id(
                "feature/maturity-takeover-v2",
                "<!-- harness-task-id: other-task-v1 -->",
                "another-task-v1",
            )


if __name__ == "__main__":
    unittest.main()
