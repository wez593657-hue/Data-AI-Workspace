import unittest
from pathlib import Path


class DocumentationMigrationTests(unittest.TestCase):
    def test_operating_guide_describes_single_task_flow(self):
        root = Path(__file__).resolve().parents[3]
        guide = (root / "docs" / "offline-first-development.md").read_text(encoding="utf-8")
        self.assertIn("offline-first-development-architecture-v1", guide)
        self.assertIn("risk-check standard", guide)
        self.assertIn("数据库恢复后", guide)


if __name__ == "__main__":
    unittest.main()
