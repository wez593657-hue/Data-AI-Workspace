"""Conservative requirement and business-rule extraction."""

from __future__ import annotations

import re
from dataclasses import asdict, dataclass
from pathlib import Path
from typing import Any


VERSION_RE = re.compile(r"(?i)\bv\d+(?:\.\d+){1,3}\b")
RULE_ID_RE = re.compile(r"\b(?:REQ|RULE|BR)[-_][A-Z0-9][A-Z0-9._-]+\b")


class RequirementError(ValueError):
    """Raised when a requirement lacks machine-verifiable information."""


@dataclass(frozen=True)
class BusinessRule:
    rule_id: str
    description: str
    source_file: str
    source_line: int
    status: str


def extract_version(path: Path) -> str:
    lines = path.read_text(encoding="utf-8").splitlines()
    history_section = next(
        (index for index, line in enumerate(lines) if "更新记录" in line), None
    )
    if history_section is not None:
        history_lines: list[str] = []
        for line in lines[history_section + 1 :]:
            if line.startswith("## "):
                break
            if "示例" not in line and "模板" not in line:
                history_lines.append(line)
        history_versions = VERSION_RE.findall("\n".join(history_lines))
        if history_versions:
            return history_versions[-1]
    version_section = next(
        (index for index, line in enumerate(lines) if "版本信息" in line), None
    )
    if version_section is not None:
        candidate_text = "\n".join(lines[version_section : version_section + 35])
    else:
        candidate_text = "\n".join(lines[:80])
    versions = [version for version in VERSION_RE.findall(candidate_text) if "X" not in version]
    if not versions:
        raise RequirementError(f"需求文件缺少版本号: {path}")
    return versions[0]


def extract_rules(path: Path) -> list[BusinessRule]:
    lines = path.read_text(encoding="utf-8").splitlines()
    rules: list[BusinessRule] = []
    seen: set[str] = set()
    for number, line in enumerate(lines, 1):
        for rule_id in RULE_ID_RE.findall(line):
            if "XXX" in rule_id or "示例" in line or "模板" in line:
                continue
            if rule_id in seen:
                raise RequirementError(f"需求文件存在重复规则编号: {rule_id}")
            seen.add(rule_id)
            description = re.sub(r"^[#*\-\s|]+", "", line).strip()
            rules.append(BusinessRule(rule_id, description, str(path), number, "confirmed"))
    return rules


def parse_requirement(path: Path) -> dict[str, Any]:
    if not path.is_file():
        raise FileNotFoundError(f"需求文件不存在: {path}")
    version = extract_version(path)
    rules = extract_rules(path)
    return {
        "requirement_id": path.stem,
        "version": version,
        "source_file": str(path),
        "rules": [asdict(rule) for rule in rules],
        "rule_count": len(rules),
    }
