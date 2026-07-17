#!/usr/bin/env python3
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
DDL_DIR = ROOT / 'data_assets' / 'ddl' / 'ods'
DICT_DIR = ROOT / 'data_assets' / 'data_dictionary' / 'ods'
CREATE = re.compile(r'CREATE\s+TABLE\s+(?:IF\s+NOT\s+EXISTS\s+)?([\w.]+)\s*\((.*)\);', re.I | re.S)
FIELD = re.compile(r'^\s*([\w]+)\s+[\w]+', re.I)

errors = []
for path in DDL_DIR.rglob('*.sql'):
    if 'temp' in path.relative_to(DDL_DIR).parts:
        continue
    match = CREATE.search(path.read_text(encoding='utf-8', errors='replace'))
    if not match:
        errors.append(f'{path.relative_to(ROOT)}: 无法解析 CREATE TABLE')
        continue
    table, body = match.groups()
    dictionary = DICT_DIR / f'{table.split(".")[-1].lower()}_dd.md'
    if not dictionary.exists():
        errors.append(f'{path.relative_to(ROOT)}: 缺少数据字典')
        continue
    text = dictionary.read_text(encoding='utf-8')
    for definition in body.split(','):
        field = FIELD.match(definition.strip())
        if field and field.group(1).upper() not in {'PRIMARY', 'UNIQUE', 'CONSTRAINT', 'FOREIGN', 'CHECK'}:
            if f'| {field.group(1)} |' not in text and f'| {field.group(1).upper()} |' not in text:
                errors.append(f'{dictionary.relative_to(ROOT)}: 缺少字段 {field.group(1)}')
if errors:
    print('\n'.join(f'✗ {item}' for item in errors))
    sys.exit(1)
print('✓ ODS DDL 与数据字典字段一致')
