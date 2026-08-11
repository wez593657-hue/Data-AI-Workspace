import json
import tempfile
import unittest
from pathlib import Path

from scripts.harness.process_compliance import (
    compliance_report,
    format_report,
    measure_compliance,
)


class ProcessComplianceTests(unittest.TestCase):
    _root: Path
    _tasks_dir: Path

    def setUp(self):
        self._root = Path(tempfile.mkdtemp())
        (self._root / ".git").mkdir(parents=True, exist_ok=True)
        (self._root / ".git" / "HEAD").write_text("ref: refs/heads/main", encoding="utf-8")
        self._tasks_dir = self._root / ".harness" / "tasks"
        self._tasks_dir.mkdir(parents=True)

    def _make_task(self, task_id: str, state: str, workflow: str,
                   history: list[dict] | None = None,
                   state_seal: str | None = None,
                   lifecycle: str = "active",
                   evidence_files: list[str] | None = None):
        task_dir = self._tasks_dir / task_id
        task_dir.mkdir(parents=True)
        task = {
            "schema_version": "0.1",
            "task_id": task_id,
            "purpose": "test task",
            "workflow_profile": workflow,
            "state": state,
            "lifecycle": lifecycle,
            "history": history or [{"from": None, "to": state, "at": "2026-08-01T00:00:00Z"}],
        }
        if state_seal:
            task["state_seal"] = state_seal
        (task_dir / "task.yaml").write_text(
            json.dumps(task, ensure_ascii=False, indent=2), encoding="utf-8"
        )
        if evidence_files:
            evidence_dir = task_dir / "evidence"
            evidence_dir.mkdir(parents=True)
            for name in evidence_files:
                (evidence_dir / name).write_text(
                    json.dumps({"evidence_id": name, "purpose": "test"}), encoding="utf-8"
                )

    def test_compliance_report_empty(self):
        report = compliance_report(self._root)
        self.assertEqual(report["summary"]["total"], 0)

    def test_compliance_report_skips_archived(self):
        self._make_task("archived-task", "COMPLETED", "standard", lifecycle="archived")
        report = compliance_report(self._root)
        self.assertEqual(report["summary"]["total"], 0)

    def test_compliance_report_includes_active(self):
        self._make_task("active-task", "CREATED", "standard")
        report = compliance_report(self._root)
        self.assertEqual(report["summary"]["total"], 1)

    def test_full_compliance_scores_max(self):
        full_history = [
            {"from": None, "to": "CREATED", "at": "2026-08-01T00:00:00Z"},
            {"from": "CREATED", "to": "REQUIREMENT_ANALYZED", "at": "2026-08-01T00:01:00Z"},
            {"from": "REQUIREMENT_ANALYZED", "to": "SCOPE_CONFIRMED", "at": "2026-08-01T00:02:00Z"},
            {"from": "SCOPE_CONFIRMED", "to": "PROCEDURE_IMPLEMENTED", "at": "2026-08-01T00:03:00Z"},
            {"from": "PROCEDURE_IMPLEMENTED", "to": "PROCEDURE_REVIEW_PASSED", "at": "2026-08-01T00:04:00Z"},
            {"from": "PROCEDURE_REVIEW_PASSED", "to": "FULL_VALIDATION_PASSED", "at": "2026-08-01T00:05:00Z"},
            {"from": "FULL_VALIDATION_PASSED", "to": "USER_APPROVED", "at": "2026-08-01T00:06:00Z"},
        ]
        self._make_task(
            "full-task", "USER_APPROVED", "standard",
            history=full_history,
            state_seal="abc123",
            evidence_files=["E-0001.yaml", "E-0002.yaml", "E-0003.yaml", "E-0004.yaml",
                           "E-0005.yaml", "E-0006.yaml", "E-0007.yaml"],
        )
        report = compliance_report(self._root)
        task = report["tasks"][0]
        self.assertGreaterEqual(task["score"], 70)
        self.assertEqual(task["level"], "partial")

    def test_single_state_scores_low(self):
        self._make_task("bare-task", "CREATED", "standard")
        report = compliance_report(self._root)
        task = report["tasks"][0]
        self.assertLess(task["score"], 30)
        self.assertEqual(task["level"], "critical")

    def test_skip_penalty_reduces_score(self):
        skipped_history = [
            {"from": None, "to": "CREATED", "at": "2026-08-01T00:00:00Z"},
            {"from": "CREATED", "to": "PROCEDURE_IMPLEMENTED", "at": "2026-08-01T00:01:00Z"},
        ]
        self._make_task("skip-task", "PROCEDURE_IMPLEMENTED", "standard", history=skipped_history)
        report = compliance_report(self._root)
        task = report["tasks"][0]
        penalty = task["breakdown"]["skip_penalty"]["penalty"]
        self.assertLess(penalty, 0)

    def test_format_report_output(self):
        self._make_task("fmt-task", "CREATED", "standard")
        report = compliance_report(self._root)
        text = format_report(report)
        self.assertIn("流程合规度报告", text)
        self.assertIn("fmt-task", text)

    def test_lightweight_task_scoring(self):
        self._make_task("l1-task", "USER_APPROVED", "lightweight",
                        history=[
                            {"from": None, "to": "CREATED", "at": "2026-08-01T00:00:00Z"},
                            {"from": "CREATED", "to": "SCOPE_CONFIRMED", "at": "2026-08-01T00:01:00Z"},
                            {"from": "SCOPE_CONFIRMED", "to": "QUICK_VALIDATION_PASSED", "at": "2026-08-01T00:02:00Z"},
                            {"from": "QUICK_VALIDATION_PASSED", "to": "USER_APPROVED", "at": "2026-08-01T00:03:00Z"},
                        ],
                        state_seal="abc",
                        evidence_files=["E-0001.yaml", "E-0002.yaml", "E-0003.yaml", "E-0004.yaml"])
        report = compliance_report(self._root)
        task = report["tasks"][0]
        self.assertGreater(task["score"], 60)

    def test_state_seal_missing_scores_lower(self):
        self._make_task("no-seal-task", "USER_APPROVED", "standard",
                        history=[
                            {"from": None, "to": "CREATED", "at": "2026-08-01T00:00:00Z"},
                            {"from": "CREATED", "to": "REQUIREMENT_ANALYZED", "at": "2026-08-01T00:01:00Z"},
                            {"from": "REQUIREMENT_ANALYZED", "to": "SCOPE_CONFIRMED", "at": "2026-08-01T00:02:00Z"},
                            {"from": "SCOPE_CONFIRMED", "to": "PROCEDURE_IMPLEMENTED", "at": "2026-08-01T00:03:00Z"},
                            {"from": "PROCEDURE_IMPLEMENTED", "to": "PROCEDURE_REVIEW_PASSED", "at": "2026-08-01T00:04:00Z"},
                            {"from": "PROCEDURE_REVIEW_PASSED", "to": "FULL_VALIDATION_PASSED", "at": "2026-08-01T00:05:00Z"},
                            {"from": "FULL_VALIDATION_PASSED", "to": "USER_APPROVED", "at": "2026-08-01T00:06:00Z"},
                        ],
                        evidence_files=["E-0001.yaml", "E-0002.yaml", "E-0003.yaml",
                                       "E-0004.yaml", "E-0005.yaml", "E-0006.yaml", "E-0007.yaml"])
        self._make_task("sealed-task", "USER_APPROVED", "standard",
                        history=[
                            {"from": None, "to": "CREATED", "at": "2026-08-01T00:00:00Z"},
                            {"from": "CREATED", "to": "REQUIREMENT_ANALYZED", "at": "2026-08-01T00:01:00Z"},
                            {"from": "REQUIREMENT_ANALYZED", "to": "SCOPE_CONFIRMED", "at": "2026-08-01T00:02:00Z"},
                            {"from": "SCOPE_CONFIRMED", "to": "PROCEDURE_IMPLEMENTED", "at": "2026-08-01T00:03:00Z"},
                            {"from": "PROCEDURE_IMPLEMENTED", "to": "PROCEDURE_REVIEW_PASSED", "at": "2026-08-01T00:04:00Z"},
                            {"from": "PROCEDURE_REVIEW_PASSED", "to": "FULL_VALIDATION_PASSED", "at": "2026-08-01T00:05:00Z"},
                            {"from": "FULL_VALIDATION_PASSED", "to": "USER_APPROVED", "at": "2026-08-01T00:06:00Z"},
                        ],
                        state_seal="abc",
                        evidence_files=["E-0001.yaml", "E-0002.yaml", "E-0003.yaml",
                                       "E-0004.yaml", "E-0005.yaml", "E-0006.yaml", "E-0007.yaml"])
        report = compliance_report(self._root)
        no_seal = [t for t in report["tasks"] if t["task_id"] == "no-seal-task"][0]
        sealed = [t for t in report["tasks"] if t["task_id"] == "sealed-task"][0]
        self.assertLess(no_seal["score"], sealed["score"])


if __name__ == "__main__":
    unittest.main()