#!/usr/bin/env python3
"""Validate TMP_ table manifests referenced by stored procedure SQL."""

import argparse
import json
import re
import sys
from pathlib import Path

# 修复 Windows GBK 控制台 Unicode 编码问题
import sys as _sys
if hasattr(_sys.stdout, 'reconfigure'):
    _sys.stdout.reconfigure(encoding='utf-8', errors='replace')
if hasattr(_sys.stderr, 'reconfigure'):
    _sys.stderr.reconfigure(encoding='utf-8', errors='replace')

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
            required = ['table_name', 'procedure', 'purpose', 'columns', 'indexes', 'lifecycle']
            missing = [key for key in required if not manifest.get(key)]
            if manifest.get('table_name', '').upper() != name or missing:
                errors.append(f"{manifest_path.relative_to(ROOT)}: 审核清单缺失 {', '.join(missing) or '正确表名'}")
            for column in manifest.get('columns', []):
                if not all(column.get(key) is not None for key in ('name', 'type', 'nullable')):
                    errors.append(f"{manifest_path.relative_to(ROOT)}: 字段定义不完整")
                    break
            lifecycle = manifest.get('lifecycle', {})
            if not lifecycle.get('cleanup') or not lifecycle.get('concurrency'):
                errors.append(f'{manifest_path.relative_to(ROOT)}: 生命周期或并发隔离策略缺失')
            if args.require_approved and manifest.get('approval_status') != 'approved':
                errors.append(f'{manifest_path.relative_to(ROOT)}: 未获人工审核')
    if errors:
        print('\n'.join(f'✗ {error}' for error in errors))
        sys.exit(1)
    print('✓ TMP_ 审核清单校验通过')


if __name__ == '__main__':
    main()
