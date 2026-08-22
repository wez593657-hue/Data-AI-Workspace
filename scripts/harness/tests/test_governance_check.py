from __future__ import annotations

import tempfile
import unittest
from pathlib import Path

import yaml

from scripts.harness.governance_check import run_governance_check


class GovernanceCheckTests(unittest.TestCase):
    def _policy(self, root: Path) -> Path:
        policy = {
            "version": "1.0",
            "text_extensions": [".md", ".sql"],
            "binary_extensions": [".xlsx"],
            "allowed_gbk_paths": ["legacy/"],
            "required_metadata": ["docs/core/governance.md"],
            "required_metadata_fields": ["层级：", "版本：", "状态："],
            "source_of_truth_paths": {"core": "docs/core/", "mapping": "data_assets/mapping/"},
        }
        path = root / "validation/governance/policy.yaml"
        path.parent.mkdir(parents=True)
        path.write_text(yaml.safe_dump(policy, allow_unicode=True), encoding="utf-8")
        governance = root / "docs/core/governance.md"
        governance.parent.mkdir(parents=True, exist_ok=True)
        governance.write_text("> 层级：L0\n> 版本：v1\n> 状态：ACTIVE\n", encoding="utf-8")
        return path

    def _write(self, root: Path, relative: str, content: str | bytes) -> None:
        path = root / relative
        path.parent.mkdir(parents=True, exist_ok=True)
        if isinstance(content, bytes):
            path.write_bytes(content)
        else:
            path.write_text(content, encoding="utf-8")

    def test_reports_duplicate_without_modifying_files(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            policy = self._policy(root)
            self._write(root, "requirements/copy.xlsx", b"same")
            self._write(root, "data_assets/mapping/copy.xlsx", b"same")
            before = (root / "requirements/copy.xlsx").read_bytes()

            report = run_governance_check(root, policy)

            self.assertEqual(report["result"], "passed")
            self.assertEqual(len(report["checks"]["duplicate_assets"]["warnings"]), 1)
            self.assertEqual((root / "requirements/copy.xlsx").read_bytes(), before)

    def test_treats_zip_content_as_binary_even_with_backup_suffix(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            policy = self._policy(root)
            self._write(root, "requirements/book.xlsx.bak_20260819", b"PK\\x03\\x04not-text")

            report = run_governance_check(root, policy)

            self.assertEqual(report["checks"]["encoding"]["failures"], [])

    def test_flags_invalid_utf8_outside_allowed_gbk_path(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            policy = self._policy(root)
            self._write(root, "docs/core/governance.md", "> 层级：L0\n> 版本：v1\n> 状态：ACTIVE\n")
            self._write(root, "docs/bad.md", b"\xff")

            report = run_governance_check(root, policy)

            self.assertEqual(report["result"], "failed")
            self.assertIn("docs/bad.md", report["checks"]["encoding"]["failures"])

    def test_allows_gbk_sql_under_declared_path(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            policy = self._policy(root)
            self._write(root, "docs/core/governance.md", "> 层级：L0\n> 版本：v1\n> 状态：ACTIVE\n")
            self._write(root, "legacy/old.sql", "中文".encode("gbk"))

            report = run_governance_check(root, policy)

            self.assertEqual(report["checks"]["encoding"]["failures"], [])
            self.assertIn("legacy/old.sql", report["checks"]["encoding"]["warnings"])

    def test_ignores_legacy_file_uri(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            policy = self._policy(root)
            self._write(root, "docs/core/governance.md", "> 层级：L0\n> 版本：v1\n> 状态：ACTIVE\n[legacy](file:///d:/old/template.sql)\n")

            report = run_governance_check(root, policy)

            self.assertEqual(report["checks"]["markdown_links"]["failures"], [])

    def test_flags_broken_local_markdown_link(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            policy = self._policy(root)
            self._write(root, "docs/core/governance.md", "> 层级：L0\n> 版本：v1\n> 状态：ACTIVE\n[bad](missing.md)\n")

            report = run_governance_check(root, policy)

            self.assertEqual(report["result"], "failed")
            self.assertTrue(report["checks"]["markdown_links"]["failures"])

    def test_flags_missing_lifecycle_metadata(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            policy = self._policy(root)
            self._write(root, "docs/core/governance.md", "# governance\n")

            report = run_governance_check(root, policy)

            self.assertEqual(report["result"], "failed")
            self.assertTrue(report["checks"]["lifecycle"]["failures"])


if __name__ == "__main__":
    unittest.main()
