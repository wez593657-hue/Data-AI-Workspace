"""Execute risk-based validation profiles with one aggregated report."""

from __future__ import annotations

import json
import os
import shlex
import subprocess
import sys
from pathlib import Path
from typing import Any

import yaml


class RiskGateError(ValueError):
    """Raised when risk gate configuration is invalid."""


def _read_yaml(path: Path) -> dict[str, Any]:
    value = yaml.safe_load(path.read_text(encoding="utf-8")) or {}
    if not isinstance(value, dict):
        raise RiskGateError(f"Risk profile root must be an object: {path}")
    return value


def run_risk_gate(root: Path, profile: str, config_path: Path | None = None) -> dict[str, Any]:
    root = root.resolve()
    config_path = config_path or (
        root / ".harness" / "tasks" / "offline-first-development-architecture-v1" / "risk_profiles.yaml"
    )
    config = _read_yaml(config_path)
    profiles = config.get("profiles")
    if not isinstance(profiles, dict) or profile not in profiles:
        raise RiskGateError(f"Unknown risk profile: {profile}")
    commands = profiles[profile].get("commands")
    if not isinstance(commands, list) or not commands:
        raise RiskGateError(f"Risk profile has no commands: {profile}")

    checks: list[dict[str, Any]] = []
    for command_text in commands:
        command = shlex.split(str(command_text), posix=True)
        if command[:3] == ["python", "-m", "scripts.harness"]:
            command[0] = sys.executable
        elif command and command[0] == "python":
            command[0] = sys.executable
        result = subprocess.run(
            command,
            cwd=root,
            capture_output=True,
            text=True,
            encoding="utf-8",
            errors="replace",
            env={**os.environ, "PYTHONIOENCODING": "utf-8"},
            check=False,
        )
        checks.append({
            "command": str(command_text),
            "passed": result.returncode == 0,
            "returncode": result.returncode,
            "output": (result.stdout + result.stderr)[-2000:],
        })
        if result.returncode != 0:
            break
    passed = all(check["passed"] for check in checks) and len(checks) == len(commands)
    return {
        "schema_version": "0.1",
        "result": "passed" if passed else "failed",
        "profile": profile,
        "command_count": len(commands),
        "completed_count": len(checks),
        "checks": checks,
    }


def main() -> int:
    import argparse

    if hasattr(sys.stdout, "reconfigure"):
        sys.stdout.reconfigure(encoding="utf-8", errors="replace")
    if hasattr(sys.stderr, "reconfigure"):
        sys.stderr.reconfigure(encoding="utf-8", errors="replace")

    parser = argparse.ArgumentParser(description="Run a risk-based Harness profile")
    parser.add_argument("profile", choices=["fast", "standard", "strict"])
    parser.add_argument("--root", default=".")
    parser.add_argument("--config", default="")
    parser.add_argument("--report", default="")
    args = parser.parse_args()
    try:
        root = Path(args.root).resolve()
        config = root / args.config if args.config else None
        report = run_risk_gate(root, args.profile, config)
        if args.report:
            report_path = root / args.report
            report_path.parent.mkdir(parents=True, exist_ok=True)
            report_path.write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
        print(json.dumps(report, ensure_ascii=False, indent=2))
        return 0 if report["result"] == "passed" else 1
    except (RiskGateError, FileNotFoundError, yaml.YAMLError) as error:
        print(f"Risk gate failed: {error}")
        return 2


if __name__ == "__main__":
    raise SystemExit(main())
