#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import sys
import re

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DDL_DIR = os.path.join(BASE_DIR, 'data_assets', 'ddl')
DATA_DICT_DIR = os.path.join(BASE_DIR, 'data_assets', 'data_dictionary')
MAPPING_DIR = os.path.join(BASE_DIR, 'data_assets', 'mapping')

def validate_ddl_structure():
    print("=" * 80)
    print("校验DDL文件结构")
    print("=" * 80)
    
    errors = []
    
    for layer in ['dwd', 'dws', 'ads']:
        layer_dir = os.path.join(DDL_DIR, layer)
        if not os.path.isdir(layer_dir):
            continue
        
        for filename in os.listdir(layer_dir):
            if not filename.endswith('.sql'):
                continue
            
            filepath = os.path.join(layer_dir, filename)
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
        print("  ✓ DDL结构校验通过")
        return True

def validate_dict_consistency():
    print("\n" + "=" * 80)
    print("校验数据字典一致性")
    print("=" * 80)
    
    errors = []
    
    for layer in ['dwd', 'dws', 'ads']:
        ddl_layer_dir = os.path.join(DDL_DIR, layer)
        dict_layer_dir = os.path.join(DATA_DICT_DIR, layer)
        
        if not os.path.isdir(ddl_layer_dir) or not os.path.isdir(dict_layer_dir):
            continue
        
        ddl_files = set(f.replace('.sql', '') for f in os.listdir(ddl_layer_dir) if f.endswith('.sql'))
        dict_files = set(f.replace('.md', '') for f in os.listdir(dict_layer_dir) if f.endswith('.md'))
        
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
        print("  ✓ 数据字典一致性校验通过")
        return True

def validate_mapping_files():
    print("\n" + "=" * 80)
    print("校验Mapping文件")
    print("=" * 80)
    
    errors = []
    
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
        print("  ✓ Mapping文件校验通过")
        return True

def validate_excel_files():
    print("\n" + "=" * 80)
    print("校验Excel文件")
    print("=" * 80)
    
    errors = []
    
    excel_files = [
        os.path.join(MAPPING_DIR, 'ods_to_dwd', 'DWD明细层数据模型_CRM_ V1.0.xlsx'),
        os.path.join(MAPPING_DIR, 'dwd_to_dws', 'DWS汇总层数据模型_CRM_ V1.0.xlsx'),
        os.path.join(MAPPING_DIR, 'dws_to_ads', 'ADS应用层数据模型_CRM_ V1.0.xlsx')
    ]
    
    try:
        import pandas as pd
        
        for excel_file in excel_files:
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
        print("  ✓ Excel文件校验通过")
        return True

def main():
    print("数据资产一致性校验")
    print("=" * 80)
    
    results = []
    results.append(validate_ddl_structure())
    results.append(validate_dict_consistency())
    results.append(validate_mapping_files())
    results.append(validate_excel_files())
    
    print("\n" + "=" * 80)
    
    if all(results):
        print("所有校验通过!")
        sys.exit(0)
    else:
        print("校验失败!")
        sys.exit(1)

if __name__ == '__main__':
    main()
