from __future__ import annotations

import tempfile
import unittest
from datetime import datetime, timedelta, timezone
from pathlib import Path

from scripts.harness.evidence_integrity import EvidenceIntegrityError, validate_evidence, validate_evidence_set
from scripts.harness.evidence_store import git_revision, sha256_file


class EvidenceIntegrityTests(unittest.TestCase):
    def _evidence(self, root: Path, task_dir: Path, source: Path) -> dict[str, str]:
        return {
            "evidence_id": "E-0001",
            "task_id": task_dir.name,
            "kind": "file_read",
            "path": str(source.relative_to(root)),
            "sha256": sha256_file(source),
            "purpose": "workspace_status",
            "result": "passed",
            "repository_revision": (git_revision(root) if git_revision(root) != "UNKNOWN" else "a" * 40),
            "created_at": datetime.now(timezone.utc).isoformat(timespec="seconds"),
        }

    def test_valid_file_evidence_passes(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            task_dir = root / ".harness" / "tasks" / "demo-task"
            evidence_path = task_dir / "evidence" / "E-0001.yaml"
            source = root / "input.txt"
            source.write_text("source", encoding="utf-8")
            evidence_path.parent.mkdir(parents=True)
            evidence = self._evidence(root, task_dir, source)
            validate_evidence(evidence, task_id=task_dir.name, evidence_path=evidence_path,
                              task_dir=task_dir, repo_root=root)

    def test_wrong_task_is_rejected(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            task_dir = root / ".harness" / "tasks" / "demo-task"
            source = root / "input.txt"
            source.write_text("source", encoding="utf-8")
            evidence = self._evidence(root, task_dir, source)
            evidence["task_id"] = "other-task"
            with self.assertRaises(EvidenceIntegrityError):
                validate_evidence(evidence, task_id=task_dir.name,
                                  evidence_path=task_dir / "evidence" / "E-0001.yaml",
                                  task_dir=task_dir, repo_root=root)

    def test_changed_file_hash_is_rejected(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            task_dir = root / ".harness" / "tasks" / "demo-task"
            source = root / "input.txt"
            source.write_text("source", encoding="utf-8")
            evidence = self._evidence(root, task_dir, source)
            source.write_text("changed", encoding="utf-8")
            with self.assertRaises(EvidenceIntegrityError):
                validate_evidence(evidence, task_id=task_dir.name,
                                  evidence_path=task_dir / "evidence" / "E-0001.yaml",
                                  task_dir=task_dir, repo_root=root)

    def test_expired_evidence_is_rejected(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            task_dir = root / ".harness" / "tasks" / "demo-task"
            source = root / "input.txt"
            source.write_text("source", encoding="utf-8")
            evidence = self._evidence(root, task_dir, source)
            evidence["created_at"] = (datetime.now(timezone.utc) - timedelta(days=31)).isoformat()
            with self.assertRaises(EvidenceIntegrityError):
                validate_evidence(evidence, task_id=task_dir.name,
                                  evidence_path=task_dir / "evidence" / "E-0001.yaml",
                                  task_dir=task_dir, repo_root=root)

    def test_evidence_filename_and_task_manifest_must_match(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            task_dir = root / ".harness" / "tasks" / "demo-task"
            source = root / "input.txt"
            source.write_text("source", encoding="utf-8")
            evidence_dir = task_dir / "evidence"
            evidence_dir.mkdir(parents=True)
            evidence = self._evidence(root, task_dir, source)
            evidence_path = evidence_dir / "E-0002.yaml"
            import yaml

            evidence_path.write_text(yaml.safe_dump(evidence), encoding="utf-8")
            with self.assertRaises(EvidenceIntegrityError):
                validate_evidence_set(evidence_dir, task_id=task_dir.name, task_dir=task_dir,
                                      repo_root=root, expected_ids=["E-0002"])

            evidence_path.unlink()
            evidence_path = evidence_dir / "E-0001.yaml"
            evidence_path.write_text(yaml.safe_dump(evidence), encoding="utf-8")
            with self.assertRaises(EvidenceIntegrityError):
                validate_evidence_set(evidence_dir, task_id=task_dir.name, task_dir=task_dir,
                                      repo_root=root, expected_ids=["E-0002"])
