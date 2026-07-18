#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import sys
import argparse

from utils import fix_windows_encoding, get_changed_files

fix_windows_encoding()

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DDL_DIR = os.path.join(BASE_DIR, 'data_assets', 'ddl')
DATA_DICT_DIR = os.path.join(BASE_DIR, 'data_assets', 'data_dictionary')
MAPPING_DIR = os.path.join(BASE_DIR, 'data_assets', 'mapping')

def validate_ddl_files(changed_files=None, quick_mode=False):
    print("=" * 80)
    print("验证DDL文件")
    print("=" * 80)
    
    has_errors = False
    total_checked = 0
    
    for layer in ['dwd', 'dws', 'ads']:
        layer_dir = os.path.join(DDL_DIR, layer)
        if not os.path.isdir(layer_dir):
            continue
        
        has_layer_change = changed_files and any(f.startswith(f'data_assets/ddl/{layer}/') for f in changed_files)
        
        if quick_mode and changed_files and not has_layer_change:
            continue
        
        print(f"\n--- {layer.upper()}层 ---")
        files = [f for f in os.listdir(layer_dir) if f.endswith('.sql')]
        
        for filename in files:
            filepath = os.path.join(layer_dir, filename)
            rel_path = f'data_assets/ddl/{layer}/{filename}'
            
            if changed_files and rel_path not in changed_files:
                if quick_mode:
                    continue
            
            total_checked += 1
            
            with open(filepath, 'r', encoding='utf-8') as f:
                content = f.read()
            
            table_name = filename.replace('.sql', '').upper()
            
            has_create = 'CREATE TABLE' in content
            has_table_comment = ('COMMENT ON TABLE' in content) or ('comment on table' in content.lower())
            has_column_comments = 'COMMENT' in content
            has_semicolon = content.strip().endswith(';')
            
            status = "✓" if all([has_create, has_table_comment, has_column_comments, has_semicolon]) else "✗"
            print(f"  {status} {filename}")
            
            if not has_create:
                print(f"    - 缺少 CREATE TABLE 语句")
                has_errors = True
            if not has_table_comment:
                print(f"    - 缺少表注释")
                has_errors = True
            if not has_column_comments:
                print(f"    - 缺少字段注释")
                has_errors = True
            if not has_semicolon:
                print(f"    - 缺少结束分号")
                has_errors = True
    
    if total_checked == 0 and changed_files:
        print("  ✓ 无变更DDL文件，跳过校验")
    
    return not has_errors

def validate_data_dictionary(changed_files=None, quick_mode=False):
    print("\n" + "=" * 80)
    print("验证数据字典")
    print("=" * 80)
    
    has_errors = False
    total_checked = 0
    
    has_dict_change = changed_files and any(f.startswith('data_assets/data_dictionary/') for f in changed_files)
    
    if quick_mode and changed_files and not has_dict_change:
        print("  ✓ 无变更数据字典文件，跳过校验")
        return True
    
    for layer in ['dwd', 'dws', 'ads']:
        layer_dir = os.path.join(DATA_DICT_DIR, layer)
        if not os.path.isdir(layer_dir):
            continue
        
        has_layer_change = changed_files and any(f.startswith(f'data_assets/data_dictionary/{layer}/') for f in changed_files)
        
        if quick_mode and changed_files and not has_layer_change:
            continue
        
        print(f"\n--- {layer.upper()}层 ---")
        files = [f for f in os.listdir(layer_dir) if f.endswith('.md')]
        
        for filename in files:
            filepath = os.path.join(layer_dir, filename)
            rel_path = f'data_assets/data_dictionary/{layer}/{filename}'
            
            if changed_files and rel_path not in changed_files:
                if quick_mode:
                    continue
            
            total_checked += 1
            
            with open(filepath, 'r', encoding='utf-8') as f:
                content = f.read()
            
            has_table_info = '## 表信息' in content
            has_field_list = '## 字段列表' in content
            has_table_name = '| 表名 |' in content
            has_comment = '| 中文名称 |' in content
            
            status = "✓" if all([has_table_info, has_field_list, has_table_name, has_comment]) else "✗"
            print(f"  {status} {filename}")
            
            if not all([has_table_info, has_field_list, has_table_name, has_comment]):
                has_errors = True
    
    if total_checked == 0 and changed_files:
        print("  ✓ 无变更数据字典文件，跳过校验")
    
    return not has_errors

def validate_mapping_files(changed_files=None, quick_mode=False):
    print("\n" + "=" * 80)
    print("验证Mapping文件")
    print("=" * 80)
    
    has_errors = False
    total_checked = 0
    
    has_mapping_change = changed_files and any(f.startswith('data_assets/mapping/') for f in changed_files)
    
    if quick_mode and changed_files and not has_mapping_change:
        print("  ✓ 无变更Mapping文件，跳过校验")
        return True
    
    for mapping_type in os.listdir(MAPPING_DIR):
        mapping_path = os.path.join(MAPPING_DIR, mapping_type)
        if not os.path.isdir(mapping_path):
            continue
        
        has_type_change = changed_files and any(f.startswith(f'data_assets/mapping/{mapping_type}/') for f in changed_files)
        
        if quick_mode and changed_files and not has_type_change:
            continue
        
        md_files = [f for f in os.listdir(mapping_path) if f.endswith('.md')]
        for filename in md_files:
            filepath = os.path.join(mapping_path, filename)
            rel_path = f'data_assets/mapping/{mapping_type}/{filename}'
            
            if changed_files and rel_path not in changed_files:
                if quick_mode:
                    continue
            
            total_checked += 1
            
            with open(filepath, 'r', encoding='utf-8') as f:
                content = f.read()
            
            has_overview = '## 映射概览' in content
            has_details = '## 字段映射详情' in content
            
            status = "✓" if all([has_overview, has_details]) else "✗"
            print(f"  {status} {mapping_type}/{filename}")
            
            if not all([has_overview, has_details]):
                has_errors = True
    
    if total_checked == 0 and changed_files:
        print("  ✓ 无变更Mapping文件，跳过校验")
    
    return not has_errors

def validate_excel_mapping(changed_files=None, quick_mode=False):
    print("\n" + "=" * 80)
    print("验证Excel映射完整性")
    print("=" * 80)
    
    has_errors = False
    total_checked = 0
    
    has_excel_change = changed_files and any(f.endswith('.xlsx') for f in changed_files)
    
    if quick_mode and changed_files and not has_excel_change:
        print("  ✓ 无变更Excel文件，跳过校验")
        return True
    
    try:
        import pandas as pd
    except ImportError:
        print("  ⚠ pandas未安装，跳过Excel校验")
        return True
    
    dwd_file = os.path.join(MAPPING_DIR, 'ods_to_dwd', 'DWD明细层数据模型_CRM_ V1.0.xlsx')
    ads_file = os.path.join(MAPPING_DIR, 'dws_to_ads', 'ADS应用层数据模型_CRM_ V1.0.xlsx')
    
    for file_path, file_type in [(dwd_file, 'DWD'), (ads_file, 'ADS')]:
        rel_path = file_path.replace(BASE_DIR + os.sep, '').replace('\\', '/')
        
        if changed_files and rel_path not in changed_files:
            continue
        
        total_checked += 1
        
        if not os.path.exists(file_path):
            print(f"  ✗ {file_type} 文件不存在")
            has_errors = True
            continue
        
        xls = pd.ExcelFile(file_path)
        print(f"\n--- {file_type}层 ---")
        
        for sheet_name in xls.sheet_names:
            if sheet_name in ['修订记录', '实体清单', '逻辑模型维度描述', 'Sheet1']:
                continue
            
            df = pd.read_excel(file_path, sheet_name=sheet_name, header=None)
            
            if len(df) < 3:
                print(f"  ⚠ {sheet_name}: 数据行数较少")
                continue
            
            if len(df) < 5:
                print(f"  ⚠ {sheet_name}: 数据行数较少，建议检查内容完整性")
            
            table_name = str(df.iloc[0, 5]).strip() if len(df.columns) > 5 and pd.notna(df.iloc[0, 5]) else sheet_name
            
            missing_count = 0
            total_count = 0
            
            for idx in range(5, len(df)):
                row = df.iloc[idx]
                attr_name = str(row.iloc[1]).strip() if pd.notna(row.iloc[1]) else ''
                
                if not attr_name or attr_name == '属性名称':
                    continue
                
                if not attr_name.isalnum():
                    continue
                
                total_count += 1
                src_table = str(row.iloc[11]).strip() if len(df.columns) > 11 and pd.notna(row.iloc[11]) else ''
                
                if not src_table:
                    missing_count += 1
            
            if missing_count > 0:
                print(f"  ⚠ {table_name} ({sheet_name}): {missing_count}/{total_count} 个字段缺少映射")
            else:
                print(f"  ✓ {table_name} ({sheet_name}): {total_count} 个字段全部有映射")
    
    if total_checked == 0 and changed_files:
        print("  ✓ 无变更Excel文件，跳过校验")
    
    return not has_errors

def validate_consistency(changed_files=None, quick_mode=False):
    print("\n" + "=" * 80)
    print("验证DDL与数据字典一致性")
    print("=" * 80)
    
    has_errors = False
    total_checked = 0
    
    has_dict_change = changed_files and any(f.startswith('data_assets/data_dictionary/') for f in changed_files)
    has_ddl_change = changed_files and any(f.startswith('data_assets/ddl/') for f in changed_files)
    
    if quick_mode and changed_files and not (has_dict_change or has_ddl_change):
        print("  ✓ 无变更数据字典或DDL文件，跳过校验")
        return True
    
    for layer in ['dwd', 'dws', 'ads']:
        ddl_dir = os.path.join(DDL_DIR, layer)
        dict_dir = os.path.join(DATA_DICT_DIR, layer)
        
        if not os.path.isdir(ddl_dir) or not os.path.isdir(dict_dir):
            continue
        
        print(f"\n--- {layer.upper()}层 ---")
        
        ddl_files = [f.replace('.sql', '') for f in os.listdir(ddl_dir) if f.endswith('.sql')]
        dict_files = [f.replace('.md', '') for f in os.listdir(dict_dir) if f.endswith('.md')]
        
        total_checked += len(ddl_files) + len(dict_files)
        
        ddl_set = set(ddl_files)
        dict_set = set(dict_files)
        
        only_ddl = ddl_set - dict_set
        only_dict = dict_set - ddl_set
        
        if only_ddl:
            print(f"  ⚠ DDL存在但数据字典缺失: {', '.join(only_ddl)}")
            has_errors = True
        
        if only_dict:
            print(f"  ⚠ 数据字典存在但DDL缺失: {', '.join(only_dict)}")
            has_errors = True
        
        if not only_ddl and not only_dict:
            print(f"  ✓ DDL和数据字典完全一致 ({len(ddl_set)} 个表)")
    
    return not has_errors

def main():
    parser = argparse.ArgumentParser(description='文件生成校验')
    parser.add_argument('--quick', action='store_true', help='快速模式，只检查变更相关文件')
    parser.add_argument('--changed', nargs='*', help='指定变更文件列表')
    args = parser.parse_args()
    
    if args.quick:
        print("  模式: 快速校验")
    else:
        print("  模式: 完整校验")
    
    changed_files = args.changed if args.changed else get_changed_files()
    
    if changed_files:
        print(f"  变更文件数: {len(changed_files)}")
    
    results = []
    results.append(validate_ddl_files(changed_files, args.quick))
    results.append(validate_data_dictionary(changed_files, args.quick))
    results.append(validate_mapping_files(changed_files, args.quick))
    results.append(validate_excel_mapping(changed_files, args.quick))
    results.append(validate_consistency(changed_files, args.quick))
    
    print("\n" + "=" * 80)
    print("验证完成!")
    print("=" * 80)
    
    if all(results):
        sys.exit(0)
    else:
        sys.exit(1)

if __name__ == '__main__':
    main()