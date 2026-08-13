#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import json
import os
import re
import sys

from utils import fix_windows_encoding, safe_print

fix_windows_encoding()

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DDL_DIR = os.path.join(BASE_DIR, 'data_assets', 'ddl')
DATA_DICT_DIR = os.path.join(BASE_DIR, 'data_assets', 'data_dictionary')
MAPPING_DIR = os.path.join(BASE_DIR, 'data_assets', 'mapping')
PROCEDURE_DIR = os.path.join(BASE_DIR, 'data_assets', 'stored_procedure')
MANIFEST_DIR = os.path.join(BASE_DIR, 'governance', 'tmp_tables')

CREATE_TABLE_RE = re.compile(r'CREATE\s+TABLE\s+(?:IF\s+NOT\s+EXISTS\s+)?([\w.]+)\s*\((.*)\);', re.I | re.S)
FIELD_RE = re.compile(r'^\s*([\w]+)\s+[\w]+', re.I)
TMP_RE = re.compile(r'\b(?:CREATE\s+TABLE(?:\s+IF\s+NOT\s+EXISTS)?|FROM|JOIN|INTO|UPDATE|TRUNCATE\s+TABLE|DROP\s+TABLE(?:\s+IF\s+EXISTS)?)\s+([\w.]*TMP_[A-Z0-9_]+)', re.I)

errors = []
warnings = []

def parse_ddl_fields(ddl_content):
    fields = []
    match = CREATE_TABLE_RE.search(ddl_content)
    if match:
        table_body = match.group(2)
        for line in table_body.split('\n'):
            line = line.strip()
            if not line or line.startswith('--') or line.startswith('PRIMARY') or line.startswith('UNIQUE') or line.startswith('CONSTRAINT') or line.startswith('FOREIGN') or line.startswith('CHECK'):
                continue
            field_match = FIELD_RE.match(line)
            if field_match:
                field_name = field_match.group(1).lower()
                if field_name and field_name != 'create' and field_name != 'index' and field_name != 'constraint':
                    fields.append(field_name)
    return fields

def parse_dict_fields(dict_content):
    fields = []
    lines = dict_content.split('\n')
    in_table = False
    for line in lines:
        if '## 字段列表' in line:
            in_table = True
            continue
        if in_table:
            if not line.strip():
                continue
            if '字段名' in line:
                continue
            if all(c == '-' or c == '|' or c.isspace() for c in line.strip()):
                continue
            if line.strip() == '---':
                break
            if '|' not in line:
                continue
            parts = line.split('|')
            if len(parts) >= 2:
                field_name = parts[1].strip().lower()
                if field_name and field_name != 'primary' and field_name != 'create' and ':' not in field_name and '*' not in field_name and len(field_name) < 50 and field_name != 'constraint':
                    fields.append(field_name)
    return fields

def parse_mapping_target_fields(mapping_content):
    fields = []
    lines = mapping_content.split('\n')
    for line in lines:
        if '|' in line and '目标字段' in line:
            for l in lines[lines.index(line)+2:]:
                if '|' in l and '---' not in l[:5]:
                    parts = l.split('|')
                    if len(parts) >= 2:
                        fields.append(parts[1].strip().lower())
                else:
                    break
    return fields

def validate_ddl_dict_consistency():
    safe_print("\n=== DDL vs 数据字典 一致性校验 ===")
    safe_print("  ⊘ 数据字典已废弃，跳过DDL与数据字典一致性校验")

def validate_ods_dictionary():
    safe_print("\n=== ODS DDL 与数据字典一致性校验 ===")
    safe_print("  ⊘ 数据字典已废弃，跳过ODS数据字典校验")

def validate_dict_mapping_consistency():
    safe_print("\n=== 数据字典 vs Mapping 一致性校验 ===")
    safe_print("  ⊘ 数据字典已废弃，跳过数据字典与Mapping一致性校验")

def validate_naming_conventions():
    safe_print("\n=== 表命名规范校验 ===")
    
    naming_rules = {
        'dwd': 'dwd_',
        'dws': 'dws_',
        'ads': 'ads_',
        'ods': 'ods_',
        'tmp': 'tmp_',
        'TMP': 'TMP_',
    }
    
    for layer in os.listdir(DDL_DIR):
        layer_dir = os.path.join(DDL_DIR, layer)
        if not os.path.isdir(layer_dir):
            continue
        
        for filename in os.listdir(layer_dir):
            if not filename.endswith('.sql'):
                continue

            ddl_path = os.path.join(layer_dir, filename)
            ddl_content = open(ddl_path, 'r', encoding='utf-8', errors='replace').read()
            if not CREATE_TABLE_RE.search(ddl_content):
                continue
            
            table_name = filename.replace('.sql', '')
            
            if layer == 'temp':
                if not table_name.startswith('tmp_'):
                    warnings.append(f"[temp] {table_name}: 临时表应使用tmp_前缀")
            elif layer in naming_rules:
                expected_prefix = naming_rules[layer]
                if not table_name.startswith(expected_prefix):
                    errors.append(f"[{layer}] {table_name}: 表名应使用{expected_prefix}前缀")
    
    safe_print("  ✓ 表命名规范校验完成")

def validate_tmp_tables():
    safe_print("\n=== TMP_ 表审核清单校验 ===")
    
    if not os.path.isdir(PROCEDURE_DIR):
        safe_print("  ⚠ 存储过程目录不存在")
        return
    
    for sql_path in os.listdir(PROCEDURE_DIR):
        if not sql_path.endswith('.sql'):
            continue
        
        sql_file = os.path.join(PROCEDURE_DIR, sql_path)
        content = open(sql_file, 'r', encoding='utf-8', errors='replace').read()
        
        names = {name.split('.')[-1].upper() for name in TMP_RE.findall(content)}
        
        for name in names:
            manifest_path = os.path.join(MANIFEST_DIR, f'{name.lower()}.json')
            if not os.path.exists(manifest_path):
                errors.append(f'{sql_path}: 缺少 {name} 审核清单')
                continue
            
            try:
                manifest = json.loads(open(manifest_path, 'r', encoding='utf-8').read())
            except json.JSONDecodeError as error:
                errors.append(f'{manifest_path}: JSON 无效: {error.msg}')
                continue
            
            required = ['table_name', 'procedure', 'purpose', 'columns', 'indexes', 'lifecycle']
            missing = [key for key in required if not manifest.get(key)]
            
            if manifest.get('table_name', '').upper() != name or missing:
                errors.append(f"{manifest_path}: 审核清单缺失 {', '.join(missing) or '正确表名'}")
            
            for column in manifest.get('columns', []):
                if not all(column.get(key) is not None for key in ('name', 'type', 'nullable')):
                    errors.append(f"{manifest_path}: 字段定义不完整")
                    break
            
            lifecycle = manifest.get('lifecycle', {})
            if not lifecycle.get('cleanup') or not lifecycle.get('concurrency'):
                errors.append(f'{manifest_path}: 生命周期或并发隔离策略缺失')
    
    safe_print("  ✓ TMP_ 审核清单校验完成")

def validate_cross_layer_consistency():
    global errors, warnings
    errors = []
    warnings = []

    safe_print("=" * 80)
    safe_print("跨层一致性校验")
    safe_print("=" * 80)
    
    validate_ddl_dict_consistency()
    validate_ods_dictionary()
    validate_dict_mapping_consistency()
    validate_naming_conventions()
    validate_tmp_tables()
    
    safe_print("\n" + "=" * 80)
    
    if errors:
        safe_print("\n✗ 错误:")
        for error in errors:
            safe_print(f"  - {error}")
    
    if warnings:
        safe_print("\n⚠ 警告:")
        for warning in warnings:
            safe_print(f"  - {warning}")
    
    if not errors and not warnings:
        safe_print("\n✓ 所有校验通过")
        return True
    elif errors:
        return False
    else:
        return True

def main():
    sys.exit(0 if validate_cross_layer_consistency() else 1)

if __name__ == '__main__':
    main()
