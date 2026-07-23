from __future__ import annotations

import unittest
from scripts.harness.change_guard import ChangeGuardError, validate_manifest_changes


class ChangeGuardTests(unittest.TestCase):
    def setUp(self):
        self.manifest = {
            "user_confirmation": "confirmed",
            "allowed_changes": [
                {"path": "scripts/harness/"},
                {"path": ".harness/tasks/phase8-change-gate-v1/"},
            ],
            "read_only_inputs": ["data_assets/source.sql"],
        }

    def test_allowed_changes_pass(self):
        result = validate_manifest_changes(self.manifest, ["scripts/harness/change_guard.py"])
        self.assertEqual(result["result"], "passed")

    def test_business_asset_change_is_rejected(self):
        with self.assertRaises(ChangeGuardError):
            validate_manifest_changes(self.manifest, ["data_assets/ddl/ads/table.sql"])

    def test_read_only_input_change_is_rejected(self):
        with self.assertRaises(ChangeGuardError):
            validate_manifest_changes(self.manifest, ["data_assets/source.sql"])

    def test_unconfirmed_manifest_is_rejected(self):
        manifest = dict(self.manifest, user_confirmation="pending")
        with self.assertRaises(ChangeGuardError):
            validate_manifest_changes(manifest, ["scripts/harness/change_guard.py"])

    def test_empty_change_scope_is_allowed(self):
        result = validate_manifest_changes(self.manifest, [])
        self.assertEqual(result["changed_files"], [])
