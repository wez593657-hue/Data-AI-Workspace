import unittest
from pathlib import Path

from scripts.harness.property_validation import validate_properties


class PropertyValidationTests(unittest.TestCase):
    def test_repository_properties_pass(self):
        root = Path(__file__).resolve().parents[3]
        report = validate_properties(root)
        self.assertEqual(report["result"], "passed")
        self.assertEqual(report["passed_rule_count"], 1)
        self.assertTrue(report["properties"][0]["null_safe"])
        self.assertTrue(report["properties"][0]["exception_stable"])


if __name__ == "__main__":
    unittest.main()
