#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import re
import sys

from utils import fix_windows_encoding, safe_print

fix_windows_encoding()

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DDL_DIR = os.path.join(BASE_DIR, 'data_assets', 'ddl')
DATA_DICT_DIR = os.path.join(BASE_DIR, 'data_assets', 'data_dictionary')
MAPPING_DIR = os.path.join(BASE_DIR, 'data_assets', 'mapping')

CREATE_TABLE_RE = re.compile(r'CREATE\s+TABLE\s+(?:IF\s+NOT\s+EXISTS\s+)?([\w.]+)\s*\((.*)\);', re.I | re.S)
FIELD_RE = re.compile(r'^\s*([\w]+)\s+[\w]+', re.I)

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
    
    for layer in ['dwd', 'dws', 'ads']:
        ddl_layer_dir = os.path.join(DDL_DIR, layer)
        dict_layer_dir = os.path.join(DATA_DICT_DIR, layer)
        
        if not os.path.isdir(ddl_layer_dir):
            continue
        
        for filename in os.listdir(ddl_layer_dir):
            if not filename.endswith('.sql'):
                continue
            
            table_name = filename.replace('.sql', '')
            dict_file = os.path.join(dict_layer_dir, f'{table_name}.md')
            
            if not os.path.exists(dict_file):
                errors.append(f"[{layer}] {table_name}: DDL存在但数据字典缺失")
                continue
            
            with open(os.path.join(ddl_layer_dir, filename), 'r', encoding='utf-8', errors='replace') as f:
                ddl_fields = parse_ddl_fields(f.read())
            
            with open(dict_file, 'r', encoding='utf-8', errors='replace') as f:
                dict_fields = parse_dict_fields(f.read())
            
            ddl_set = set(ddl_fields)
            dict_set = set(dict_fields)
            
            ddl_only = ddl_set - dict_set
            dict_only = dict_set - ddl_set
            
            if ddl_only:
                errors.append(f"[{layer}] {table_name}: DDL有但数据字典缺少字段: {', '.join(ddl_only)}")
            if dict_only:
                errors.append(f"[{layer}] {table_name}: 数据字典有但DDL缺少字段: {', '.join(dict_only)}")
            
            if not ddl_only and not dict_only:
                safe_print(f"  ✓ [{layer}] {table_name}: DDL与数据字典字段一致")

def validate_dict_mapping_consistency():
    safe_print("\n=== 数据字典 vs Mapping 一致性校验 ===")
    
    mapping_files = []
    for root, dirs, files in os.walk(MAPPING_DIR):
        for f in files:
            if f.endswith('.md'):
                mapping_files.append(os.path.join(root, f))
    
    for mapping_file in mapping_files:
        with open(mapping_file, 'r', encoding='utf-8', errors='replace') as f:
            content = f.read()
        
        mapping_fields = parse_mapping_target_fields(content)
        
        for layer in ['dwd', 'dws', 'ads']:
            dict_layer_dir = os.path.join(DATA_DICT_DIR, layer)
            if not os.path.isdir(dict_layer_dir):
                continue
            
            for dict_file in os.listdir(dict_layer_dir):
                if not dict_file.endswith('.md'):
                    continue
                
                table_name = dict_file.replace('.md', '')
                with open(os.path.join(dict_layer_dir, dict_file), 'r', encoding='utf-8', errors='replace') as f:
                    dict_fields = parse_dict_fields(f.read())
                
                for field in mapping_fields:
                    if field and field.lower() in table_name.lower():
                        if field.lower() not in [f.lower() for f in dict_fields]:
                            warnings.append(f"[{layer}] {table_name}: Mapping字段 {field} 未在数据字典中定义")
    
    if not warnings:
        safe_print("  ✓ 数据字典与Mapping字段一致")

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
            
            table_name = filename.replace('.sql', '')
            
            if layer == 'temp':
                if not table_name.startswith('tmp_'):
                    warnings.append(f"[temp] {table_name}: 临时表应使用tmp_前缀")
            elif layer in naming_rules:
                expected_prefix = naming_rules[layer]
                if not table_name.startswith(expected_prefix):
                    errors.append(f"[{layer}] {table_name}: 表名应使用{expected_prefix}前缀")
    
    safe_print("  ✓ 表命名规范校验完成")

def main():
    safe_print("=" * 80)
    safe_print("跨层一致性校验")
    safe_print("=" * 80)
    
    validate_ddl_dict_consistency()
    validate_dict_mapping_consistency()
    validate_naming_conventions()
    
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
        sys.exit(0)
    elif errors:
        sys.exit(1)
    else:
        sys.exit(0)

if __name__ == '__main__':
    main()
