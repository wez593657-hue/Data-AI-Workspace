#!/usr/bin/env python3
"""Validate TMP_ table manifests referenced by stored procedure SQL."""

import argparse
import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
PROCEDURE_DIR = ROOT / 'data_assets' / 'stored_procedure'
MANIFEST_DIR = ROOT / 'governance' / 'tmp_tables'
TMP_RE = re.compile(r'\b(?:CREATE\s+TABLE(?:\s+IF\s+NOT\s+EXISTS)?|FROM|JOIN|INTO|UPDATE|TRUNCATE\s+TABLE|DROP\s+TABLE(?:\s+IF\s+EXISTS)?)\s+([\w.]*TMP_[A-Z0-9_]+)', re.I)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--require-approved', action='store_true')
    args = parser.parse_args()
    errors = []
    for sql_path in PROCEDURE_DIR.rglob('*.sql'):
        names = {name.split('.')[-1].upper() for name in TMP_RE.findall(sql_path.read_text(encoding='utf-8', errors='replace'))}
        for name in names:
            manifest_path = MANIFEST_DIR / f'{name.lower()}.json'
            if not manifest_path.exists():
                errors.append(f'{sql_path.relative_to(ROOT)}: 缺少 {name} 审核清单')
                continue
            try:
                manifest = json.loads(manifest_path.read_text(encoding='utf-8'))
            except json.JSONDecodeError as error:
                errors.append(f'{manifest_path.relative_to(ROOT)}: JSON 无效: {error.msg}')
                continue
            if manifest.get('table_name', '').upper() != name or not manifest.get('columns'):
                errors.append(f'{manifest_path.relative_to(ROOT)}: 表名或字段清单缺失')
            if args.require_approved and manifest.get('approval_status') != 'approved':
                errors.append(f'{manifest_path.relative_to(ROOT)}: 未获人工审核')
    if errors:
        print('\n'.join(f'✗ {error}' for error in errors))
        sys.exit(1)
    print('✓ TMP_ 审核清单校验通过')


if __name__ == '__main__':
    main()
