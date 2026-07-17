#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import pandas as pd
import re

BASE_DIR = r'd:\AI\AI-Workspace\Kingbase-CRM-AI-Development-Guide'
DDL_DIR = os.path.join(BASE_DIR, 'data_assets', 'ddl')
DATA_DICT_DIR = os.path.join(BASE_DIR, 'data_assets', 'data_dictionary')
MAPPING_DIR = os.path.join(BASE_DIR, 'data_assets', 'mapping')

def validate_ddl_files():
    print("=" * 80)
    print("验证DDL文件")
    print("=" * 80)
    
    for layer in ['dwd', 'dws', 'ads']:
        layer_dir = os.path.join(DDL_DIR, layer)
        if not os.path.isdir(layer_dir):
            continue
        
        print(f"\n--- {layer.upper()}层 ---")
        files = [f for f in os.listdir(layer_dir) if f.endswith('.sql')]
        
        for filename in files:
            filepath = os.path.join(layer_dir, filename)
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
            if not has_table_comment:
                print(f"    - 缺少表注释")
            if not has_column_comments:
                print(f"    - 缺少字段注释")
            if not has_semicolon:
                print(f"    - 缺少结束分号")

def validate_data_dictionary():
    print("\n" + "=" * 80)
    print("验证数据字典")
    print("=" * 80)
    
    for layer in ['dwd', 'dws', 'ads']:
        layer_dir = os.path.join(DATA_DICT_DIR, layer)
        if not os.path.isdir(layer_dir):
            continue
        
        print(f"\n--- {layer.upper()}层 ---")
        files = [f for f in os.listdir(layer_dir) if f.endswith('.md')]
        
        for filename in files:
            filepath = os.path.join(layer_dir, filename)
            with open(filepath, 'r', encoding='utf-8') as f:
                content = f.read()
            
            has_table_info = '## 表信息' in content
            has_field_list = '## 字段列表' in content
            has_table_name = '| 表名 |' in content
            has_comment = '| 中文名称 |' in content
            
            status = "✓" if all([has_table_info, has_field_list, has_table_name, has_comment]) else "✗"
            print(f"  {status} {filename}")

def validate_mapping_files():
    print("\n" + "=" * 80)
    print("验证Mapping文件")
    print("=" * 80)
    
    for mapping_type in os.listdir(MAPPING_DIR):
        mapping_path = os.path.join(MAPPING_DIR, mapping_type)
        if not os.path.isdir(mapping_path):
            continue
        
        md_files = [f for f in os.listdir(mapping_path) if f.endswith('.md')]
        for filename in md_files:
            filepath = os.path.join(mapping_path, filename)
            with open(filepath, 'r', encoding='utf-8') as f:
                content = f.read()
            
            has_overview = '## 映射概览' in content
            has_details = '## 字段映射详情' in content
            
            status = "✓" if all([has_overview, has_details]) else "✗"
            print(f"  {status} {mapping_type}/{filename}")

def validate_excel_mapping():
    print("\n" + "=" * 80)
    print("验证Excel映射完整性")
    print("=" * 80)
    
    dwd_file = os.path.join(MAPPING_DIR, 'ods_to_dwd', 'DWD明细层数据模型_CRM_ V1.0.xlsx')
    ads_file = os.path.join(MAPPING_DIR, 'dws_to_ads', 'ADS应用层数据模型_CRM_ V1.0.xlsx')
    
    for file_path, file_type in [(dwd_file, 'DWD'), (ads_file, 'ADS')]:
        if not os.path.exists(file_path):
            print(f"  ✗ {file_type} 文件不存在")
            continue
        
        xls = pd.ExcelFile(file_path)
        print(f"\n--- {file_type}层 ---")
        
        for sheet_name in xls.sheet_names:
            if sheet_name in ['修订记录', '实体清单', '逻辑模型维度描述', 'Sheet1']:
                continue
            
            df = pd.read_excel(file_path, sheet_name=sheet_name, header=None)
            
            if len(df) < 5:
                print(f"  ✗ {sheet_name}: 数据行数不足")
                continue
            
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

def validate_consistency():
    print("\n" + "=" * 80)
    print("验证DDL与数据字典一致性")
    print("=" * 80)
    
    for layer in ['dwd', 'dws', 'ads']:
        ddl_dir = os.path.join(DDL_DIR, layer)
        dict_dir = os.path.join(DATA_DICT_DIR, layer)
        
        if not os.path.isdir(ddl_dir) or not os.path.isdir(dict_dir):
            continue
        
        print(f"\n--- {layer.upper()}层 ---")
        
        ddl_files = [f.replace('.sql', '') for f in os.listdir(ddl_dir) if f.endswith('.sql')]
        dict_files = [f.replace('.md', '') for f in os.listdir(dict_dir) if f.endswith('.md')]
        
        ddl_set = set(ddl_files)
        dict_set = set(dict_files)
        
        only_ddl = ddl_set - dict_set
        only_dict = dict_set - ddl_set
        
        if only_ddl:
            print(f"  ⚠ DDL存在但数据字典缺失: {', '.join(only_ddl)}")
        
        if only_dict:
            print(f"  ⚠ 数据字典存在但DDL缺失: {', '.join(only_dict)}")
        
        if not only_ddl and not only_dict:
            print(f"  ✓ DDL和数据字典完全一致 ({len(ddl_set)} 个表)")

if __name__ == '__main__':
    validate_ddl_files()
    validate_data_dictionary()
    validate_mapping_files()
    validate_excel_mapping()
    validate_consistency()
    
    print("\n" + "=" * 80)
    print("验证完成!")
    print("=" * 80)
