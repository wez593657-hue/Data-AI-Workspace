import tempfile
import unittest
from pathlib import Path

from scripts.harness.impact_analysis import ImpactAnalysisError, analyze_impact


class ImpactAnalysisTests(unittest.TestCase):
    def test_repository_example_excludes_offline_only_database_mapping(self):
        root = Path(__file__).resolve().parents[3]
        report = analyze_impact(root)
        self.assertEqual(report["result"], "passed")
        self.assertEqual(report["rule_count"], 1)
        self.assertEqual(report["unresolved"], [])

    def test_missing_artifact_blocks_report(self):
        with tempfile.TemporaryDirectory() as temp_dir:
            root = Path(temp_dir)
            (root / "validation" / "impact").mkdir(parents=True)
            manifest = {
                "rules": [{
                    "rule_id": "R-TEST",
                    "source": {"document": "req.md", "section": "s1"},
                    "inputs": [{"name": "input", "source": "fixture.json"}],
                    "outputs": [{"name": "output", "target": "expected.json"}],
                    "artifacts": [{"kind": "fixture", "path": "missing.json"}],
                    "database_impact": {"status": "confirmed"},
                }]
            }
            manifest_path = root / "validation" / "impact" / "test.yaml"
            manifest_path.write_text(yaml_dump(manifest), encoding="utf-8")
            report = analyze_impact(root, manifest_path)
            self.assertEqual(report["result"], "blocked")
            self.assertEqual(report["missing_artifacts"], ["missing.json"])

    def test_invalid_manifest_is_rejected(self):
        with tempfile.TemporaryDirectory() as temp_dir:
            root = Path(temp_dir)
            manifest_path = root / "invalid.yaml"
            manifest_path.write_text("rules: [{}]\n", encoding="utf-8")
            with self.assertRaises(ImpactAnalysisError):
                analyze_impact(root, manifest_path)


def yaml_dump(value):
    import yaml

    return yaml.safe_dump(value, allow_unicode=True, sort_keys=False)
