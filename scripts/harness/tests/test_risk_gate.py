import tempfile
import unittest
from pathlib import Path

import yaml

from scripts.harness.risk_gate import RiskGateError, run_risk_gate


class RiskGateTests(unittest.TestCase):
    def test_fast_profile_passes(self):
        root = Path(__file__).resolve().parents[3]
        with tempfile.TemporaryDirectory() as directory:
            config = Path(directory) / "risk.yaml"
            config.write_text(
                yaml.safe_dump(
                    {"profiles": {"fast": {"commands": ["python -c \"print('ok')\""]}}},
                    sort_keys=False,
                ),
                encoding="utf-8",
            )
            report = run_risk_gate(root, "fast", config)
        self.assertEqual(report["result"], "passed")
        self.assertEqual(report["completed_count"], report["command_count"])

    def test_unknown_profile_is_rejected(self):
        root = Path(__file__).resolve().parents[3]
        with self.assertRaises(RiskGateError):
            run_risk_gate(root, "unknown")


if __name__ == "__main__":
    unittest.main()
