#!/usr/bin/env python3
"""Validate date-parameter rules for staged stored procedure changes."""

from __future__ import annotations

import argparse
import re
import subprocess
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
PROCEDURE_ROOT = Path("data_assets/stored_procedure")
DIRECT_DERIVATION_PATTERNS = (
    re.compile(r"\bADD_MONTHS\s*\([^;\n]*\bV_SYSDAT\b", re.IGNORECASE),
    re.compile(r"\bLAST_DAY\s*\([^;\n]*\bV_SYSDAT\b", re.IGNORECASE),
    re.compile(r"\bTRUNC\s*\(\s*TO_DATE\s*\(\s*V_SYSDAT\b", re.IGNORECASE),
    re.compile(r"\bTO_DATE\s*\(\s*V_SYSDAT\b[^;\n]*[+-]\s*\d", re.IGNORECASE),
    # V_DATA_DATE 是 V_SYSDAT 的别名，同样禁止直接推导业务日期边界
    re.compile(r"\bADD_MONTHS\s*\([^;\n]*\bV_DATA_DATE\b", re.IGNORECASE),
    re.compile(r"\bLAST_DAY\s*\([^;\n]*\bV_DATA_DATE\b", re.IGNORECASE),
    re.compile(r"\bTRUNC\s*\(\s*TO_DATE\s*\(\s*V_DATA_DATE\b", re.IGNORECASE),
    re.compile(r"\bTO_DATE\s*\(\s*V_DATA_DATE\b[^;\n]*[+-]\s*\d", re.IGNORECASE),
)
DATE_FUNCTION_PATTERN = re.compile(
    r"\bsys_fun_deal_date\s*\(\s*V_SYSDAT\s*,\s*(\d+)\s*\)", re.IGNORECASE
)
FUNCTION_IMPLEMENTED_PATTERN = re.compile(r"\bWHEN\s+(\d+)\s+THEN", re.IGNORECASE)


def function_implemented_codes(root: Path = ROOT) -> set[int]:
    """返回 sys_fun_deal_date.sql 中已实现的日期参数编号集合。"""
    function_path = root / "data_assets/function/sys_fun_deal_date.sql"
    if not function_path.is_file():
        return set()
    text = function_path.read_text(encoding="utf-8", errors="replace")
    return {int(code) for code in FUNCTION_IMPLEMENTED_PATTERN.findall(text)}


def executable_sql(content: str) -> str:
    """Remove comments while preserving newlines for accurate diagnostics."""
    without_blocks = re.sub(r"/\*.*?\*/", lambda item: "\n" * item.group(0).count("\n"), content, flags=re.DOTALL)
    return re.sub(r"--[^\n]*", "", without_blocks)


def validate_procedure_text(path: Path, content: str) -> list[str]:
    """Return static rule violations for one stored procedure."""
    content = executable_sql(content)
    errors: list[str] = []
    implemented_codes = function_implemented_codes()
    for pattern in DIRECT_DERIVATION_PATTERNS:
        for match in pattern.finditer(content):
            line = content.count("\n", 0, match.start()) + 1
            errors.append(
                f"{path}:{line}: 不得直接基于 V_SYSDAT 推导业务日期；请使用具名 sys_fun_deal_date 参数"
            )

    for match in DATE_FUNCTION_PATTERN.finditer(content):
        code = int(match.group(1))
        statement_start = content.rfind(";", 0, match.start()) + 1
        statement_end = content.find(";", match.end())
        statement_end = len(content) if statement_end == -1 else statement_end
        statement = content[statement_start:statement_end]
        line_number = content.count("\n", 0, match.start()) + 1
        if code < 1:
            errors.append(f"{path}:{line_number}: sys_fun_deal_date 参数编号必须大于 0")
        if not re.search(
            r"\b[VP]_[A-Z0-9_]+\b(?:(?:\s+[A-Z0-9_]+)|(?:\s*\([^;]*?\)))*\s*:=",
            statement,
            re.IGNORECASE,
        ):
            errors.append(
                f"{path}:{line_number}: sys_fun_deal_date 必须赋值给具名日期参数，不能在业务 SQL 中内联调用"
            )
        if code not in implemented_codes:
            errors.append(
                f"{path}:{line_number}: sys_fun_deal_date 参数 {code} 未在 "
                "data_assets/function/sys_fun_deal_date.sql 中实现；请先同步函数实现再使用"
            )
    return errors


def staged_procedure_files(root: Path) -> list[Path]:
    result = subprocess.run(
        ["git", "diff", "--cached", "--name-only", "--", str(PROCEDURE_ROOT)],
        cwd=root,
        capture_output=True,
        text=True,
        encoding="utf-8",
        errors="replace",
        check=False,
    )
    if result.returncode != 0:
        return []
    return [root / line for line in result.stdout.splitlines() if line.endswith(".sql")]


def validate_files(paths: list[Path]) -> list[str]:
    errors: list[str] = []
    for path in paths:
        if path.is_file():
            errors.extend(validate_procedure_text(path, path.read_text(encoding="utf-8", errors="replace")))
    return errors


def validate_staged_procedure_date_parameters(root: Path = ROOT) -> bool:
    errors = validate_files(staged_procedure_files(root))
    if errors:
        print("存储过程日期参数规则校验失败:")
        print("\n".join(f"  - {error}" for error in errors))
        return False
    print("存储过程日期参数规则校验通过")
    return True


def main() -> int:
    parser = argparse.ArgumentParser(description="校验存储过程日期参数规则")
    parser.add_argument("paths", nargs="*", type=Path, help="待校验过程；省略时校验暂存过程")
    args = parser.parse_args()
    errors = validate_files(args.paths) if args.paths else validate_files(staged_procedure_files(ROOT))
    if errors:
        print("\n".join(errors))
        return 1
    print("存储过程日期参数规则校验通过")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
