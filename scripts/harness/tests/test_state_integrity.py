from __future__ import annotations

import unittest

from scripts.harness.state_integrity import state_seal, validate_task_integrity


class StateIntegrityTests(unittest.TestCase):
    def test_seal_is_stable_for_same_state(self):
        payload = {
            "task_id": "stable-task",
            "workflow_profile": "harness",
            "state": "CREATED",
            "history": [{"from": None, "to": "CREATED"}],
        }
        self.assertEqual(state_seal(payload), state_seal(payload))

    def test_unsealed_legacy_task_is_not_migratable(self):
        payload = {
            "task_id": "legacy-task",
            "workflow_profile": "harness",
            "state": "CREATED",
            "history": [{"from": None, "to": "CREATED"}],
        }
        with self.assertRaises(ValueError):
            validate_task_integrity(payload, require_seal=True)
