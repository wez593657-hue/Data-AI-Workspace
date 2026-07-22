"""Check that a stored procedure has explicit coverage for requirement rules."""

from __future__ import annotations

import re
from pathlib import Path
from typing import Any


DEADLINE_RULES = {
    "REQ-CUST-001": ("到期承接明细表", r"INSERT\s+INTO\s+ADS_CUST_DEADLINE_RMND_DTL"),
    "REQ-CUST-003": ("30天承接窗口", r"30|TAKE_END_DT_30D"),
    "REQ-CUST-004": ("下一笔到期日减1窗口规则", r"EXPR_DT\s*>\s*g\.LAST_EXPR_DT|MIN\(n\.EXPR_DT\)\s*-\s*1"),
    "REQ-CUST-005": ("理财转存款转化率/金额", r"FIN_MATURE_TRAN_FIXED_AMT|BUY_DEPO_AMT_30D.*STATIS_TYP\s*=\s*'2'"),
    "REQ-CUST-006": ("存款转理财转化率/金额", r"FIXED_MATURE_TRAN_FIN_AMT|BUY_FIN_AMT_30D.*STATIS_TYP\s*=\s*'1'"),
    "REQ-CUST-007": (
        "客户承接率剔除保险",
        r"TAKE_AMT_30D|PRDKT_TYP\s+IN\s*\(\s*['\"]DEPO['\"]\s*,\s*['\"]FIN['\"]\s*\)",
    ),
    "REQ-CUST-008": (
        "定期存款承接率排除通知存款",
        r"PRDKT_CATE_BIG\s*(?:<>|!=|NOT\s+IN)\s*(?:\(\s*)?['\"]04['\"]",
    ),
}


def parse_requirement_version(path: Path) -> str:
    content = path.read_text(encoding="utf-8", errors="replace")
    versions = re.findall(r"\|\s*(v\d+\.\d+\.\d+)\s*\|", content, re.IGNORECASE)
    if not versions:
        versions = re.findall(r"版本\s*[:：]\s*(v\d+\.\d+\.\d+)", content, re.IGNORECASE)
    return versions[-1] if versions else ""


def check_rule_coverage(requirement: Path, procedure: Path, rule_map: dict[str, tuple[str, str]] | None = None) -> dict[str, Any]:
    source = requirement.read_text(encoding="utf-8", errors="replace")
    implementation = procedure.read_text(encoding="utf-8", errors="replace")
    rules = rule_map or DEADLINE_RULES
    results: list[dict[str, Any]] = []
    for rule_id, (description, pattern) in rules.items():
        source_declared = rule_id in source or description in source
        if rule_id == "REQ-CUST-003":
            source_declared = source_declared or bool(re.search(r"30天", source))
        elif rule_id == "REQ-CUST-004":
            source_declared = source_declared or bool(re.search(r"下一笔到期日减1|最后一笔到期日后30天", source))
        elif rule_id == "REQ-CUST-005":
            source_declared = source_declared or bool(re.search(r"理财转存款", source))
        elif rule_id == "REQ-CUST-006":
            source_declared = source_declared or bool(re.search(r"存款转理财", source))
        elif rule_id == "REQ-CUST-007":
            source_declared = source_declared or bool(re.search(r"承接率.*保险|保险.*剔除", source))
        elif rule_id == "REQ-CUST-008":
            source_declared = source_declared or bool(re.search(r"通知存款.*过滤|过滤.*通知存款", source))
        implemented = bool(re.search(pattern, implementation, re.IGNORECASE | re.DOTALL))
        pending = any(marker in implementation for marker in ("待实现", "待确认")) and rule_id in {
            "REQ-CUST-007",
            "REQ-CUST-008",
        }
        status = "blocked" if pending else ("passed" if source_declared and implemented else "unresolved")
        results.append({
            "rule_id": rule_id,
            "description": description,
            "source_declared": source_declared,
            "implementation_match": implemented,
            "pending_marker": pending,
            "status": status,
        })
    return {
        "requirement": str(requirement),
        "procedure": str(procedure),
        "requirement_version": parse_requirement_version(requirement),
        "rules": results,
        "status": "blocked" if any(item["status"] in {"blocked", "unresolved"} for item in results) else "passed",
    }
