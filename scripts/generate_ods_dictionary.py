#!/usr/bin/env python3
"""Generate conservative ODS data dictionaries from CREATE TABLE DDL."""

import argparse
import json
import re
from datetime import date
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DDL_DIR = ROOT / 'data_assets' / 'ddl' / 'ods'
OUTPUT_DIR = ROOT / 'data_assets' / 'data_dictionary' / 'ods'
REPORT = ROOT / 'temp' / 'outputs' / 'ods_dictionary_generation_report.json'
CREATE_RE = re.compile(r'CREATE\s+TABLE\s+(?:IF\s+NOT\s+EXISTS\s+)?([\w.]+)\s*\((.*)\);', re.I | re.S)
TYPE_RE = re.compile(r'^([\w]+)\s+([\w]+(?:\s*\([^)]*\))?)(.*)$', re.I | re.S)


def split_definitions(body):
    items, current, depth = [], [], 0
    for char in body:
        if char == '(':
            depth += 1
        elif char == ')':
            depth -= 1
        if char == ',' and depth == 0:
            items.append(''.join(current).strip())
            current = []
        else:
            current.append(char)
    if current:
        items.append(''.join(current).strip())
    return items


def parse_ddl(path):
    content = path.read_text(encoding='utf-8', errors='replace')
    match = CREATE_RE.search(content)
    if not match:
        raise ValueError('未识别到完整 CREATE TABLE 语句')
    table_name, body = match.groups()
    primary, unique, columns = set(), set(), []
    definitions = split_definitions(body)
    for item in definitions:
        normalized = re.sub(r'\s+', ' ', item.strip())
        primary_match = re.match(r'PRIMARY\s+KEY\s*\(([^)]+)\)', normalized, re.I)
        unique_match = re.match(r'UNIQUE\s*\(([^)]+)\)', normalized, re.I)
        if primary_match:
            primary.update(name.strip().strip('"').upper() for name in primary_match.group(1).split(','))
            continue
        if unique_match:
            unique.update(name.strip().strip('"').upper() for name in unique_match.group(1).split(','))
            continue
        column_match = TYPE_RE.match(normalized)
        if not column_match or normalized.upper().startswith(('CONSTRAINT ', 'FOREIGN KEY ', 'CHECK ')):
            continue
        name, data_type, rest = column_match.groups()
        name = name.strip('"')
        if re.search(r'\bPRIMARY\s+KEY\b', rest, re.I):
            primary.add(name.upper())
        if re.search(r'\bUNIQUE\b', rest, re.I):
            unique.add(name.upper())
        length = '-'
        length_match = re.search(r'\(([^)]+)\)', data_type)
        if length_match:
            length = length_match.group(1)
            data_type = data_type[:data_type.index('(')].strip()
        default_match = re.search(r'\bDEFAULT\s+(.+?)(?=\s+(?:NOT\s+NULL|NULL|PRIMARY\s+KEY|UNIQUE)|$)', rest, re.I)
        columns.append({
            'name': name,
            'type': data_type.upper(),
            'length': length,
            'nullable': 'NOT NULL' if re.search(r'\bNOT\s+NULL\b', rest, re.I) else 'NULL',
            'default': default_match.group(1).strip() if default_match else '-',
        })
    if not columns:
        raise ValueError('未识别到字段定义')
    return table_name, columns, primary, unique


def render(table_name, columns, primary, unique):
    today = date.today().isoformat()
    lines = [f'# ODS 层数据字典 - {table_name}', '', '## 表信息', '', '| 属性 | 值 |', '|------|----|',
             f'| 表名 | {table_name} |', '| 中文名称 | 【待确认】 |', '| 描述 | 根据 ODS DDL 自动生成，业务含义待确认 |',
             f'| 数据来源 | DDL: {table_name} |', '| 负责人 | 【待确认】 |', f'| 更新时间 | {today} |', '', '## 字段列表', '',
             '| 字段名 | 字段中文说明 | 数据类型 | 长度 | 是否为空 | 默认值 | 主键 | 外键 | 枚举说明 | 数据来源 | 负责人 | 更新时间 |',
             '|--------|--------------|----------|------|----------|--------|------|------|----------|----------|--------|----------|']
    for column in columns:
        key = 'PRIMARY KEY' if column['name'].upper() in primary else 'UNIQUE' if column['name'].upper() in unique else '-'
        lines.append(f"| {column['name']} | 【待确认】 | {column['type']} | {column['length']} | {column['nullable']} | {column['default']} | {key} | - | 【待确认】 | {table_name}.{column['name']} | 【待确认】 | {today} |")
    return '\n'.join(lines) + '\n'


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--write', action='store_true', help='写入数据字典；默认仅生成报告')
    args = parser.parse_args()
    results = {'generated': [], 'failed': []}
    for ddl_path in sorted(DDL_DIR.rglob('*.sql')):
        try:
            table, columns, primary, unique = parse_ddl(ddl_path)
            output = OUTPUT_DIR / f'{table.split(".")[-1].lower()}_dd.md'
            if args.write:
                output.parent.mkdir(parents=True, exist_ok=True)
                output.write_text(render(table, columns, primary, unique), encoding='utf-8')
            results['generated'].append({'source': str(ddl_path.relative_to(ROOT)), 'output': str(output.relative_to(ROOT)), 'columns': len(columns)})
        except ValueError as error:
            results['failed'].append({'source': str(ddl_path.relative_to(ROOT)), 'reason': str(error)})
    REPORT.parent.mkdir(parents=True, exist_ok=True)
    REPORT.write_text(json.dumps(results, ensure_ascii=False, indent=2), encoding='utf-8')
    print(f"生成: {len(results['generated'])}; 失败: {len(results['failed'])}; 报告: {REPORT.relative_to(ROOT)}")
    raise SystemExit(1 if results['failed'] else 0)


if __name__ == '__main__':
    main()
