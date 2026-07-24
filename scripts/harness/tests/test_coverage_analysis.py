import tempfile
import unittest
from pathlib import Path

from scripts.harness.coverage_analysis import CoverageAnalysisError, analyze_coverage


class CoverageAnalysisTests(unittest.TestCase):
    def test_repository_offline_rule_is_fully_covered(self):
        root = Path(__file__).resolve().parents[3]
        report = analyze_coverage(root)
        self.assertEqual(report["result"], "passed")
        self.assertEqual(report["coverage_percent"], 100.0)
        self.assertEqual(report["findings"][0]["scope"], "offline_only")

    def test_impact_report_must_pass(self):
        with tempfile.TemporaryDirectory() as temp_dir:
            root = Path(temp_dir)
            catalog = root / "catalog.yaml"
            impact = root / "impact.json"
            catalog.write_text("rules:\n  - rule_id: R-001\n", encoding="utf-8")
            impact.write_text('{"result": "blocked", "findings": []}\n', encoding="utf-8")
            with self.assertRaises(CoverageAnalysisError):
                analyze_coverage(root, catalog, impact)

    def test_missing_rule_in_impact_report_is_rejected(self):
        root = Path(__file__).resolve().parents[3]
        with tempfile.TemporaryDirectory() as temp_dir:
            impact = Path(temp_dir) / "impact.json"
            impact.write_text('{"result": "passed", "findings": []}\n', encoding="utf-8")
            with self.assertRaises(CoverageAnalysisError):
                analyze_coverage(root, root / "validation/rules/deadline_reminder.yaml", impact)
