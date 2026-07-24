from __future__ import annotations

import tempfile
import unittest
from pathlib import Path

from scripts.harness.offline_validation import validate_offline


class OfflineValidationTests(unittest.TestCase):
    def test_repository_example_passes(self):
        report = validate_offline(Path.cwd())
        self.assertEqual(report["result"], "passed")
        self.assertEqual(report["failed_cases"], [])

    def test_missing_required_case_tag_fails(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            for folder in ("rules", "fixtures", "expected"):
                (root / "validation" / folder).mkdir(parents=True)
            (root / "validation" / "rules" / "sample.yaml").write_text(
                "schema_version: '0.1'\n"
                "rules:\n"
                "  - rule_id: R-001\n"
                "    status: confirmed\n"
                "    source: {document: test.md, section: '1'}\n"
                "    reference: validation.reference.deadline_reminder:evaluate\n"
                "    required_case_tags: [normal, boundary]\n",
                encoding="utf-8",
            )
            (root / "validation" / "fixtures" / "sample.json").write_text(
                '{"cases":[{"case_id":"TC-001","rule_id":"R-001","tags":["normal"],"input":{"due_date":null,"current_date":"2026-07-21","handle_status":"0"}}]}',
                encoding="utf-8",
            )
            (root / "validation" / "expected" / "sample.json").write_text(
                '{"cases":[{"case_id":"TC-001","output":{"remind_flag":"0","overdue_days":0}}]}',
                encoding="utf-8",
            )
            report = validate_offline(root, root / "validation" / "rules" / "sample.yaml")
            self.assertEqual(report["result"], "failed")
            self.assertEqual(report["missing_case_tags"], {"R-001": ["boundary"]})


if __name__ == "__main__":
    unittest.main()
