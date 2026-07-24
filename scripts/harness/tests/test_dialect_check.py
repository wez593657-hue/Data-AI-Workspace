import tempfile
import unittest
from pathlib import Path

from scripts.harness.dialect_check import check_dialect


class DialectCheckTests(unittest.TestCase):
    def test_repository_sql_passes_declared_dialect_check(self):
        root = Path(__file__).resolve().parents[3]
        report = check_dialect(root)
        self.assertEqual(report["result"], "passed")
        self.assertEqual(report["violation_count"], 0)

    def test_forbidden_mysql_syntax_fails(self):
        with tempfile.TemporaryDirectory() as temp_dir:
            root = Path(temp_dir)
            sql = root / "sample.sql"
            sql.write_text("SELECT * FROM `customers` LIMIT 1;\n", encoding="utf-8")
            manifest = root / "manifest.yaml"
            manifest.write_text(
                "inputs: [sample.sql]\n"
                "forbidden_patterns:\n"
                "  - {name: select_star, pattern: '\\\\bSELECT\\\\s+\\\\*', reason: unstable}\n"
                "  - {name: backtick, pattern: '`[^`]+`', reason: nonportable}\n",
                encoding="utf-8",
            )
            report = check_dialect(root, manifest)
            self.assertEqual(report["result"], "failed")
            self.assertGreaterEqual(report["violation_count"], 1)


if __name__ == "__main__":
    unittest.main()
