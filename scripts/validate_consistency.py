#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import sys
import re
import argparse

# 修复 Windows GBK 控制台 Unicode 编码问题
import sys as _sys
if hasattr(_sys.stdout, 'reconfigure'):
    _sys.stdout.reconfigure(encoding='utf-8', errors='replace')
if hasattr(_sys.stderr, 'reconfigure'):
    _sys.stderr.reconfigure(encoding='utf-8', errors='replace')

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DDL_DIR = os.path.join(BASE_DIR, 'data_assets', 'ddl')
DATA_DICT_DIR = os.path.join(BASE_DIR, 'data_assets', 'data_dictionary')
MAPPING_DIR = os.path.join(BASE_DIR, 'data_assets', 'mapping')

WHITELIST_DIRS = ['docs/', 'README.md', '.git/', '.github/', 'scripts/', '.vscode/']

def get_changed_files():
    try:
        import subprocess
        result = subprocess.run(['git', 'diff', '--cached', '--name-only'], 
                              capture_output=True, text=True, cwd=BASE_DIR)
        changed = [f.strip() for f in result.stdout.strip().split('\n') if f.strip()]
        result2 = subprocess.run(['git', 'diff', '--name-only'], 
                               capture_output=True, text=True, cwd=BASE_DIR)
        changed += [f.strip() for f in result2.stdout.strip().split('\n') if f.strip()]
        return list(set(changed))
    except:
        return []

def is_in_whitelist(filepath):
    for pattern in WHITELIST_DIRS:
        if filepath.startswith(pattern) or filepath == pattern.rstrip('/'):
            return True
    return False

def validate_ddl_structure(changed_files=None, quick_mode=False):
    print("=" * 80)
    print("校验DDL文件结构")
    print("=" * 80)
    
    errors = []
    total_checked = 0
    
    for layer in ['dwd', 'dws', 'ads']:
        layer_dir = os.path.join(DDL_DIR, layer)
        if not os.path.isdir(layer_dir):
            continue
        
        for filename in os.listdir(layer_dir):
            if not filename.endswith('.sql'):
                continue
            
            filepath = os.path.join(layer_dir, filename)
            rel_path = f'data_assets/ddl/{layer}/{filename}'
            
            if changed_files and rel_path not in changed_files:
                if quick_mode:
                    continue
                if not any(f.startswith('data_assets/ddl/') for f in changed_files):
                    continue
            
            total_checked += 1
            
            with open(filepath, 'r', encoding='utf-8') as f:
                content = f.read()
            
            table_name = filename.replace('.sql', '')
            
            if not table_name.startswith(layer):
                errors.append(f"DDL命名错误: {layer}/{filename} 表名应以{layer}_开头")
            
            if 'CREATE TABLE' not in content:
                errors.append(f"缺少CREATE TABLE: {layer}/{filename}")
            
            if 'COMMENT ON TABLE' not in content:
                errors.append(f"缺少表注释: {layer}/{filename}")
    
    if errors:
        for error in errors:
            print(f"  ✗ {error}")
        return False
    else:
        if total_checked == 0 and changed_files:
            print("  ✓ 无变更DDL文件，跳过校验")
        else:
            print(f"  ✓ DDL结构校验通过 (检查{total_checked}个文件)")
        return True

def validate_dict_consistency(changed_files=None, quick_mode=False):
    print("\n" + "=" * 80)
    print("校验数据字典一致性")
    print("=" * 80)
    
    errors = []
    total_checked = 0
    
    has_dict_change = changed_files and any(f.startswith('data_assets/data_dictionary/') for f in changed_files)
    has_ddl_change = changed_files and any(f.startswith('data_assets/ddl/') for f in changed_files)
    
    if quick_mode and changed_files and not (has_dict_change or has_ddl_change):
        print("  ✓ 无变更数据字典或DDL文件，跳过校验")
        return True
    
    for layer in ['dwd', 'dws', 'ads']:
        ddl_layer_dir = os.path.join(DDL_DIR, layer)
        dict_layer_dir = os.path.join(DATA_DICT_DIR, layer)
        
        if not os.path.isdir(ddl_layer_dir) or not os.path.isdir(dict_layer_dir):
            continue
        
        ddl_files = set(f.replace('.sql', '') for f in os.listdir(ddl_layer_dir) if f.endswith('.sql'))
        dict_files = set(f.replace('.md', '') for f in os.listdir(dict_layer_dir) if f.endswith('.md'))
        
        total_checked += len(ddl_files) + len(dict_files)
        
        missing_in_dict = ddl_files - dict_files
        missing_in_ddl = dict_files - ddl_files
        
        for table in missing_in_dict:
            errors.append(f"DDL存在但数据字典缺失: {layer}/{table}.sql")
        
        for table in missing_in_ddl:
            errors.append(f"数据字典存在但DDL缺失: {layer}/{table}.md")
    
    if errors:
        for error in errors:
            print(f"  ✗ {error}")
        return False
    else:
        print(f"  ✓ 数据字典一致性校验通过 (检查{total_checked}个文件)")
        return True

def validate_mapping_files(changed_files=None, quick_mode=False):
    print("\n" + "=" * 80)
    print("校验Mapping文件")
    print("=" * 80)
    
    errors = []
    total_checked = 0
    
    has_mapping_change = changed_files and any(f.startswith('data_assets/mapping/') for f in changed_files)
    
    if quick_mode and changed_files and not has_mapping_change:
        print("  ✓ 无变更Mapping文件，跳过校验")
        return True
    
    mapping_types = ['ods_to_dwd', 'dwd_to_dws', 'dws_to_ads']
    
    for mapping_type in mapping_types:
        mapping_path = os.path.join(MAPPING_DIR, mapping_type)
        if not os.path.isdir(mapping_path):
            errors.append(f"Mapping目录不存在: {mapping_type}")
            continue
        
        md_files = [f for f in os.listdir(mapping_path) if f.endswith('.md')]
        if not md_files:
            errors.append(f"Mapping目录为空: {mapping_type}")
            continue
        
        for filename in md_files:
            filepath = os.path.join(mapping_path, filename)
            rel_path = f'data_assets/mapping/{mapping_type}/{filename}'
            
            if changed_files and rel_path not in changed_files:
                continue
            
            total_checked += 1
            
            with open(filepath, 'r', encoding='utf-8') as f:
                content = f.read()
            
            if '## 映射概览' not in content:
                errors.append(f"缺少映射概览: {mapping_type}/{filename}")
            
            if '## 字段映射详情' not in content:
                errors.append(f"缺少字段映射详情: {mapping_type}/{filename}")
    
    if errors:
        for error in errors:
            print(f"  ✗ {error}")
        return False
    else:
        if total_checked == 0 and changed_files:
            print("  ✓ 无变更Mapping文件，跳过校验")
        else:
            print(f"  ✓ Mapping文件校验通过 (检查{total_checked}个文件)")
        return True

def validate_excel_files(changed_files=None, quick_mode=False):
    print("\n" + "=" * 80)
    print("校验Excel文件")
    print("=" * 80)
    
    errors = []
    total_checked = 0
    
    has_excel_change = changed_files and any(f.endswith('.xlsx') for f in changed_files)
    
    if quick_mode and changed_files and not has_excel_change:
        print("  ✓ 无变更Excel文件，跳过校验")
        return True
    
    excel_files = [
        os.path.join(MAPPING_DIR, 'ods_to_dwd', 'DWD明细层数据模型_CRM_ V1.0.xlsx'),
        os.path.join(MAPPING_DIR, 'dwd_to_dws', 'DWS汇总层数据模型_CRM_ V1.0.xlsx'),
        os.path.join(MAPPING_DIR, 'dws_to_ads', 'ADS应用层数据模型_CRM_ V1.0.xlsx')
    ]
    
    try:
        import pandas as pd
        
        for excel_file in excel_files:
            rel_path = excel_file.replace(BASE_DIR + os.sep, '').replace('\\', '/')
            
            if changed_files and rel_path not in changed_files:
                continue
            
            total_checked += 1
            
            if not os.path.exists(excel_file):
                errors.append(f"Excel文件不存在: {excel_file}")
                continue
            
            try:
                xls = pd.ExcelFile(excel_file)
                if not xls.sheet_names:
                    errors.append(f"Excel文件为空: {excel_file}")
            except Exception as e:
                errors.append(f"Excel文件读取失败: {excel_file} - {str(e)}")

    except ImportError:
        print("  ⚠ pandas未安装，跳过Excel校验")
    
    if errors:
        for error in errors:
            print(f"  ✗ {error}")
        return False
    else:
        if total_checked == 0 and changed_files:
            print("  ✓ 无变更Excel文件，跳过校验")
        else:
            print(f"  ✓ Excel文件校验通过 (检查{total_checked}个文件)")
        return True

def main():
    parser = argparse.ArgumentParser(description='数据资产一致性校验')
    parser.add_argument('--quick', action='store_true', help='快速模式，只检查变更相关文件')
    parser.add_argument('--changed', nargs='*', help='指定变更文件列表')
    args = parser.parse_args()
    
    print("数据资产一致性校验")
    print("=" * 80)
    
    if args.quick:
        print("  模式: 快速校验")
    else:
        print("  模式: 完整校验")
    
    changed_files = args.changed if args.changed else get_changed_files()
    
    if changed_files:
        print(f"  变更文件数: {len(changed_files)}")
    
    results = []
    results.append(validate_ddl_structure(changed_files, args.quick))
    results.append(validate_dict_consistency(changed_files, args.quick))
    results.append(validate_mapping_files(changed_files, args.quick))
    results.append(validate_excel_files(changed_files, args.quick))
    
    print("\n" + "=" * 80)
    
    if all(results):
        print("所有校验通过!")
        sys.exit(0)
    else:
        print("校验失败!")
        sys.exit(1)

if __name__ == '__main__':
    main()