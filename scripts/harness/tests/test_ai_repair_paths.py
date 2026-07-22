import unittest

from scripts.ai_repair import validate_patch


class AIRepairPathTests(unittest.TestCase):
    def test_allowed_asset_path_passes(self):
        validate_patch(
            "--- a/data_assets/ddl/example.sql\n"
            "+++ b/data_assets/ddl/example.sql\n"
            "@@\n+-- change\n"
        )

    def test_root_file_is_rejected(self):
        with self.assertRaises(ValueError):
            validate_patch(
                "--- a/README.md\n+++ b/README.md\n@@\n+change\n"
            )

    def test_workflow_file_is_rejected(self):
        with self.assertRaises(ValueError):
            validate_patch(
                "--- a/.github/workflows/validate.yml\n"
                "+++ b/.github/workflows/validate.yml\n@@\n+change\n"
            )


if __name__ == "__main__":
    unittest.main()
