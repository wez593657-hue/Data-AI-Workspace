from __future__ import annotations

import unittest

from scripts.harness.test_case_generator import generate_matrix


class Phase7Tests(unittest.TestCase):
    def test_matrix_contains_all_required_scenarios(self):
        matrix = generate_matrix(
            "deadline-task",
            ["ADS_CUST_DEADLINE_RMND_DTL", "ADS_CUST_DEADLINE_RMND_STATIS"],
            [
                {
                    "rule_id": "REQ-CUST-007",
                    "status": "confirmed",
                    "source": {"file": "requirements/deadline.md", "section": "4.1"},
                }
            ],
        )
        self.assertEqual(len(matrix["cases"]), 11)
        self.assertEqual(matrix["status"], "static_matrix_ready")
        self.assertIn("ADS_CUST_DEADLINE_RMND_DTL", matrix["targets"])
        self.assertIn("rollback", {case["kind"] for case in matrix["cases"]})

    def test_missing_or_unconfirmed_rules_are_unresolved(self):
        matrix = generate_matrix(
            "generic-task",
            ["TARGET_TABLE"],
            [{"rule_id": "REQ-001", "status": "pending", "source": {"file": "r.md", "section": "1"}}],
        )
        self.assertEqual(matrix["status"], "blocked_unresolved")
        self.assertEqual(matrix["unresolved_rules"], ["REQ-001"])
        self.assertTrue(matrix["cases"][0]["expectation"].startswith("UNRESOLVED"))

if __name__ == "__main__":
    unittest.main()
