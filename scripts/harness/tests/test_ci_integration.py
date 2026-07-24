import unittest
from pathlib import Path

import yaml


class CiIntegrationTests(unittest.TestCase):
    def test_offline_workflow_runs_standard_gate(self):
        root = Path(__file__).resolve().parents[3]
        workflow = yaml.load(
            (root / ".github" / "workflows" / "offline-harness.yml").read_text(encoding="utf-8"),
            Loader=yaml.BaseLoader,
        )
        triggers = workflow["on"]
        self.assertIn("push", triggers)
        self.assertIn("pull_request", triggers)
        self.assertEqual(triggers["push"]["branches"], ["master"])
        self.assertEqual(triggers["pull_request"]["branches"], ["master"])

        steps = workflow["jobs"]["offline-harness"]["steps"]
        commands = [step.get("run") for step in steps if isinstance(step, dict) and "run" in step]
        self.assertIn("python -m scripts.harness risk-check standard", commands)
        self.assertIn("python -m scripts.harness validate offline-first-development-architecture-v1", commands)

    def test_pre_push_runs_standard_gate(self):
        root = Path(__file__).resolve().parents[3]
        hook = (root / "hooks" / "pre-push").read_text(encoding="utf-8")
        self.assertIn("scripts.harness', 'risk-check', 'standard'", hook)
        self.assertIn("refs/heads/master", hook)
        self.assertIn("scripts/workspace_validation.py', 'full'", hook)


if __name__ == "__main__":
    unittest.main()
