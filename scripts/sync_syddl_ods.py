"""Synchronize approved ODS DDL assets from SYDDL.ddl.sql."""

from __future__ import annotations

import json
import re
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "data_assets" / "ddl" / "SYDDL.ddl.sql"
ODS = ROOT / "data_assets" / "ddl" / "ods"
REPORT = ROOT / "temp" / "outputs" / "syddl_ods_sync_report.json"
HEADER = re.compile(r"(?m)^--\s+([\w.]+)\s+定义\s*$")
CREATE = re.compile(r"(?im)^\s*create\s+table\s+(?:if\s+not\s+exists\s+)?([\w.]+)\s*\(")
EXCLUDED = re.compile(r"^(ads|dwd|dws|tmp\d*|prc)_", re.I)
NEW_PATHS = {
    "cms_customer_belong": "cms",
    "cms_user_info": "cms",
    "mbk_cust_detail_info": "mbk",
    "crm_sys_post": "crm",
}


def source_tables() -> dict[str, str]:
    text = SOURCE.read_text(encoding="utf-8", errors="replace")
    headers = list(HEADER.finditer(text))
    result: dict[str, str] = {}
    for index, match in enumerate(headers):
        block = text[match.start(): headers[index + 1].start() if index + 1 < len(headers) else len(text)].strip()
        create = CREATE.search(block)
        if create:
            result[create.group(1).split(".")[-1].lower()] = block + "\n"
    return result


def main() -> None:
    tables = source_tables()
    updated, added, excluded, unmatched = [], [], [], []
    for path in ODS.rglob("*.sql"):
        name = path.stem.lower()
        if name not in tables:
            unmatched.append(str(path.relative_to(ROOT)))
            continue
        path.write_text(tables[name], encoding="utf-8")
        updated.append(str(path.relative_to(ROOT)))
    for name, block in tables.items():
        if EXCLUDED.match(name):
            excluded.append(name)
            continue
        if name not in NEW_PATHS:
            continue
        path = ODS / NEW_PATHS[name] / f"{name}.sql"
        if not path.exists():
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_text(block, encoding="utf-8")
            added.append(str(path.relative_to(ROOT)))
    REPORT.parent.mkdir(parents=True, exist_ok=True)
    REPORT.write_text(json.dumps({"updated": updated, "added": added, "excluded": sorted(excluded), "unmatched": unmatched}, ensure_ascii=False, indent=2), encoding="utf-8")
    print(f"updated={len(updated)} added={len(added)} excluded={len(excluded)} unmatched={len(unmatched)}")


if __name__ == "__main__":
    main()
