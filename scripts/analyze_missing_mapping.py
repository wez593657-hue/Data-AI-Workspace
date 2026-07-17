#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import pandas as pd
import re

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DWD_FILE = os.path.join(BASE_DIR, 'data_assets', 'mapping', 'ods_to_dwd', 'DWD明细层数据模型_CRM_ V1.0.xlsx')
ADS_FILE = os.path.join(BASE_DIR, 'data_assets', 'mapping', 'dws_to_ads', 'ADS应用层数据模型_CRM_ V1.0.xlsx')
ODS_DIR = os.path.join(BASE_DIR, 'data_assets', 'ddl', 'ods')
DWD_DIR = os.path.join(BASE_DIR, 'data_assets', 'ddl', 'dwd')

def parse_ods_tables():
    ods_tables = {}
    
    for root, dirs, files in os.walk(ODS_DIR):
        for filename in files:
            if not filename.endswith('.sql'):
                continue
            
            filepath = os.path.join(root, filename)
            table_name = filename.replace('.sql', '').upper()
            
            with open(filepath, 'r', encoding='utf-8') as f:
                content = f.read()
            
            columns = []
            lines = content.split('\n')
            for line in lines:
                line = line.strip()
                if line.startswith('--') or line.startswith('/*') or line.startswith('*/') or not line:
                    continue
                if 'CREATE TABLE' in line:
                    continue
                if 'COMMENT ON' in line:
                    continue
                
                match = re.match(r'^\s*(\w+)\s+([A-Za-z]+(?:\(\d+(?:,\d+)?\))?)\s*(NULL|NOT NULL)?', line)
                if match:
                    col_name = match.group(1).strip().upper()
                    col_type = match.group(2).strip()
                    columns.append({'name': col_name, 'type': col_type})
            
            ods_tables[table_name] = columns
    
    return ods_tables

def analyze_dwd_mapping():
    if not os.path.exists(DWD_FILE):
        print(f"警告: DWD Excel文件不存在: {DWD_FILE}")
        return
    
    xls = pd.ExcelFile(DWD_FILE)
    
    for sheet_name in xls.sheet_names:
        if sheet_name in ['修订记录', '实体清单', '逻辑模型维度描述', 'Sheet1']:
            continue
        
        df = pd.read_excel(DWD_FILE, sheet_name=sheet_name, header=None)
        
        if len(df) < 3:
            continue
        
        table_name = str(df.iloc[0, 5]).strip() if len(df.columns) > 5 and pd.notna(df.iloc[0, 5]) else sheet_name
        
        missing_mapping = []
        
        for idx in range(5, len(df)):
            row = df.iloc[idx]
            
            attr_name = str(row.iloc[1]).strip() if pd.notna(row.iloc[1]) else ''
            if not attr_name or attr_name == '属性名称':
                continue
            
            if not attr_name.isalnum():
                continue
            
            src_table = str(row.iloc[11]).strip() if len(df.columns) > 11 and pd.notna(row.iloc[11]) else ''
            src_field = str(row.iloc[13]).strip() if len(df.columns) > 13 and pd.notna(row.iloc[13]) else ''
            
            if not src_table:
                std_name = str(row.iloc[4]).strip() if len(df.columns) > 4 and pd.notna(row.iloc[4]) else ''
                missing_mapping.append({
                    'attr_name': attr_name,
                    'std_name': std_name
                })
        
        if missing_mapping:
            print(f"\n{'='*80}")
            print(f"DWD表: {table_name} ({sheet_name})")
            print(f"{'='*80}")
            print(f"缺少映射的字段 ({len(missing_mapping)} 个):")
            for item in missing_mapping:
                print(f"  - {item['attr_name']}: {item['std_name']}")

def analyze_ads_mapping():
    if not os.path.exists(ADS_FILE):
        print(f"警告: ADS Excel文件不存在: {ADS_FILE}")
        return
    
    xls = pd.ExcelFile(ADS_FILE)
    
    for sheet_name in xls.sheet_names:
        if sheet_name in ['修订记录', '实体清单', '逻辑模型维度描述', 'Sheet1']:
            continue
        
        df = pd.read_excel(ADS_FILE, sheet_name=sheet_name, header=None)
        
        if len(df) < 3:
            continue
        
        table_name = str(df.iloc[0, 5]).strip() if len(df.columns) > 5 and pd.notna(df.iloc[0, 5]) else sheet_name
        
        missing_mapping = []
        
        for idx in range(5, len(df)):
            row = df.iloc[idx]
            
            attr_name = str(row.iloc[1]).strip() if pd.notna(row.iloc[1]) else ''
            if not attr_name or attr_name == '属性名称':
                continue
            
            if not attr_name.isalnum():
                continue
            
            src_table = str(row.iloc[11]).strip() if len(df.columns) > 11 and pd.notna(row.iloc[11]) else ''
            src_field = str(row.iloc[13]).strip() if len(df.columns) > 13 and pd.notna(row.iloc[13]) else ''
            
            if not src_table:
                std_name = str(row.iloc[4]).strip() if len(df.columns) > 4 and pd.notna(row.iloc[4]) else ''
                missing_mapping.append({
                    'attr_name': attr_name,
                    'std_name': std_name
                })
        
        if missing_mapping:
            print(f"\n{'='*80}")
            print(f"ADS表: {table_name} ({sheet_name})")
            print(f"{'='*80}")
            print(f"缺少映射的字段 ({len(missing_mapping)} 个):")
            for item in missing_mapping:
                print(f"  - {item['attr_name']}: {item['std_name']}")

if __name__ == '__main__':
    print("分析DWD层缺少映射的字段:")
    analyze_dwd_mapping()
    
    print("\n\n分析ADS层缺少映射的字段:")
    analyze_ads_mapping()