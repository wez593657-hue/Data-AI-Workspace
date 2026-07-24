import unittest
from pathlib import Path


class CiIntegrationTests(unittest.TestCase):
    def test_offline_workflow_runs_standard_gate(self):
        root = Path(__file__).resolve().parents[3]
        workflow = (root / ".github" / "workflows" / "offline-harness.yml").read_text(encoding="utf-8")
        self.assertIn("risk-check standard", workflow)
        self.assertIn("pull_request", workflow)

    def test_pre_push_runs_standard_gate(self):
        root = Path(__file__).resolve().parents[3]
        hook = (root / "hooks" / "pre-push").read_text(encoding="utf-8")
        self.assertIn("risk-check", hook)
        self.assertIn("standard", hook)


if __name__ == "__main__":
    unittest.main()
