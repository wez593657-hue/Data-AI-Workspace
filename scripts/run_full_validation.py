#!/usr/bin/env python3
"""Run the repository validation suite and optionally persist its report."""

from __future__ import annotations

import argparse
import contextlib
import io
import sys
from pathlib import Path

import workspace_validation


def main() -> int:
    parser = argparse.ArgumentParser(description="Run full workspace validation")
    parser.add_argument("--report", type=Path, help="Write the validation output to this file")
    args = parser.parse_args()

    output = io.StringIO()
    with contextlib.redirect_stdout(output), contextlib.redirect_stderr(output):
        try:
            success = workspace_validation.run_full_validation()
        except Exception as error:  # Keep CI artifacts useful when a validator crashes.
            print(f"校验器异常: {error}")
            success = False

    report = output.getvalue()
    sys.stdout.write(report)
    if args.report:
        args.report.parent.mkdir(parents=True, exist_ok=True)
        args.report.write_text(report, encoding="utf-8")
    return 0 if success else 1


if __name__ == "__main__":
    raise SystemExit(main())
