#!/usr/bin/env python3
"""Run the repository validation suite and persist an auditable report."""

from __future__ import annotations

import argparse
import subprocess
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
CHECKS = [
    [sys.executable, "scripts/validate_generated_files.py"],
    [sys.executable, "scripts/analyze_missing_mapping.py"],
    [sys.executable, "scripts/validate_tmp_tables.py", "--require-approved"],
    [sys.executable, "scripts/validate_ods_dictionary.py"],
]


def main() -> int:
    if hasattr(sys.stdout, "reconfigure"):
        sys.stdout.reconfigure(encoding="utf-8", errors="replace")
    if hasattr(sys.stderr, "reconfigure"):
        sys.stderr.reconfigure(encoding="utf-8", errors="replace")

    parser = argparse.ArgumentParser()
    parser.add_argument("--report", default="validation-report.txt")
    args = parser.parse_args()

    report_path = Path(args.report)
    if not report_path.is_absolute():
        report_path = ROOT / report_path
    report_path.parent.mkdir(parents=True, exist_ok=True)

    sections: list[str] = []
    failed = False
    for command in CHECKS:
        result = subprocess.run(
            command,
            cwd=ROOT,
            text=True,
            encoding="utf-8",
            errors="replace",
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            check=False,
        )
        output = result.stdout or ""
        sections.append(
            "$ " + " ".join(command) + "\n"
            + output
            + f"\n[exit_code={result.returncode}]\n"
        )
        failed = failed or result.returncode != 0

    report_path.write_text("\n".join(sections), encoding="utf-8")
    print("\n".join(sections))
    print(f"Validation report: {report_path}")
    return 1 if failed else 0


if __name__ == "__main__":
    raise SystemExit(main())
