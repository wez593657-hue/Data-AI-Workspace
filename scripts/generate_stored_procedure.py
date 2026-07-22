#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import sys
import re
import argparse

from utils import fix_windows_encoding, safe_print, run_command

fix_windows_encoding()

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

DDL_DIR = os.path.join(BASE_DIR, 'data_assets', 'ddl')
DICT_DIR = os.path.join(BASE_DIR, 'data_assets', 'data_dictionary')
MAPPING_DIR = os.path.join(BASE_DIR, 'data_assets', 'mapping')
PROC_DIR = os.path.join(BASE_DIR, 'data_assets', 'stored_procedure')

LAYER_MAP = {
    'ods': 'ODS',
    'dwd': 'DWD',
    'dws': 'DWS',
    'ads': 'ADS'
}

def parse_ddl(ddl_content):
    fields = []
    lines = ddl_content.split('\n')
    
    in_table = False
    
    for line in lines:
        line = line.strip()
        if not line or line.startswith('--') or line.startswith('/*') or line.startswith('COMMENT'):
            continue
        
        if 'CREATE TABLE' in line.upper():
            in_table = True
            continue
        
        if in_table and line.startswith(')'):
            in_table = False
            continue
        
        if not in_table:
            continue
        
        line = line.rstrip(',')
        
        if not line or line.startswith('(') or line.startswith(')'):
            continue
        
        field_name = ''
        field_type = ''
        nullable = 'NULL'
        constraint = ''
        
        if 'NOT NULL' in line:
            nullable = 'NOT NULL'
        elif 'NULL' in line:
            nullable = 'NULL'
        
        if 'PRIMARY KEY' in line.upper():
            constraint = 'PRIMARY KEY'
        
        parts = line.split()
        if len(parts) >= 2:
            field_name = parts[0].lower()
            field_type = parts[1].upper()
        
        if not field_name:
            continue
        
        if field_name in ['primary', 'unique', 'constraint', 'foreign', 'key', 'references']:
            continue
        
        fields.append({
            'name': field_name,
            'type': field_type,
            'nullable': nullable,
            'constraint': constraint
        })
    
    return fields

def parse_data_dictionary(dict_content):
    fields = []
    lines = dict_content.split('\n')
    
    in_table = False
    header_found = False
    
    for line in lines:
        if '| 字段名 |' in line:
            header_found = True
            continue
        
        if header_found and line.startswith('|') and line.endswith('|'):
            parts = [p.strip() for p in line.split('|')[1:-1]]
            if len(parts) >= 4:
                fields.append({
                    'name': parts[0],
                    'description': parts[1] if len(parts) > 1 else '',
                    'type': parts[2] if len(parts) > 2 else '',
                    'constraint': parts[3] if len(parts) > 3 else ''
                })
    
    return fields

def parse_mapping(mapping_content, target_table):
    mappings = []
    lines = mapping_content.split('\n')
    
    for line in lines:
        line = line.strip()
        if not line or line.startswith('#') or line.startswith('|'):
            continue
        
        if target_table in line.lower():
            parts = line.split('->')
            if len(parts) >= 2:
                source = parts[0].strip()
                target = parts[1].strip()
                
                source_table = ''
                source_field = source
                if '.' in source:
                    source_table, source_field = source.split('.', 1)
                
                mappings.append({
                    'source_table': source_table,
                    'source_field': source_field,
                    'target_field': target
                })
    
    return mappings

def generate_procedure(table_name, layer):
    ddl_file = os.path.join(DDL_DIR, layer, f'{table_name}.sql')
    dict_file = os.path.join(DICT_DIR, layer, f'{table_name}.md')
    
    if not os.path.exists(ddl_file):
        safe_print(f"  ⚠ DDL文件不存在: {ddl_file}")
        return None
    
    with open(ddl_file, 'r', encoding='utf-8', errors='replace') as f:
        ddl_content = f.read()
    
    ddl_fields = parse_ddl(ddl_content)
    
    dict_fields = []
    if os.path.exists(dict_file):
        with open(dict_file, 'r', encoding='utf-8', errors='replace') as f:
            dict_content = f.read()
        dict_fields = parse_data_dictionary(dict_content)
    
    mapping_file = ''
    mapping_content = ''
    if layer == 'dwd':
        mapping_file = os.path.join(MAPPING_DIR, 'ods_to_dwd', 'ods到dwd映射.md')
    elif layer == 'dws':
        mapping_file = os.path.join(MAPPING_DIR, 'dwd_to_dws', 'dwd到dws映射.md')
    elif layer == 'ads':
        mapping_file = os.path.join(MAPPING_DIR, 'dws_to_ads', 'dws到ads映射.md')
    
    mappings = []
    if os.path.exists(mapping_file):
        with open(mapping_file, 'r', encoding='utf-8', errors='replace') as f:
            mapping_content = f.read()
        mappings = parse_mapping(mapping_content, table_name)
    
    proc_name = f'pro_{table_name}'
    layer_name = LAYER_MAP.get(layer, layer.upper())
    
    source_layer = 'ODS' if layer == 'dwd' else ('DWD' if layer == 'dws' else 'DWS')
    
    input_params = []
    output_params = []
    
    for field in ddl_fields:
        if field['name'] in ['create_time', 'update_time', 'create_by', 'update_by']:
            continue
        
        if field['constraint'] == 'PRIMARY KEY' or field['nullable'] == 'NOT NULL':
            input_params.append(f"    p_{field['name']} IN {field['type']}")
    
    output_params.append("    p_result_code OUT INT")
    output_params.append("    p_result_msg OUT VARCHAR(500)")
    
    input_params_str = ',\n'.join(input_params)
    output_params_str = ',\n'.join(output_params)
    
    if input_params_str and output_params_str:
        params_str = input_params_str + ',\n' + output_params_str
    elif input_params_str:
        params_str = input_params_str
    else:
        params_str = output_params_str
    
    param_checks = []
    for field in ddl_fields:
        if field['name'] in ['create_time', 'update_time', 'create_by', 'update_by']:
            continue
        
        if field['constraint'] == 'PRIMARY KEY' or field['nullable'] == 'NOT NULL':
            param_checks.append(f"""    IF p_{field['name']} IS NULL OR p_{field['name']} = '' THEN
        p_result_code := -1;
        p_result_msg := '{field['name']}不能为空';
        RAISE NOTICE '参数检查失败: {field['name']}为空';
        RETURN;
    END IF;""")
    
    param_checks_str = '\n\n'.join(param_checks)
    
    insert_fields = []
    insert_values = []
    for field in ddl_fields:
        if field['name'] in ['create_time', 'update_time', 'create_by', 'update_by']:
            continue
        insert_fields.append(field['name'])
        insert_values.append(f"p_{field['name']}")
    
    insert_fields_str = ',\n            '.join(insert_fields)
    insert_values_str = ',\n            '.join(insert_values)
    
    select_fields = []
    for field in ddl_fields:
        select_fields.append(f"            {field['name']}")
    select_fields_str = ',\n'.join(select_fields)
    
    mapping_comment = ''
    if mappings:
        mapping_comment = '\n    -- ====================\n    -- 字段映射关系\n    -- ====================\n'
        for mapping in mappings[:5]:
            mapping_comment += f"    -- {mapping['source_field']} -> {mapping['target_field']}\n"
        if len(mappings) > 5:
            mapping_comment += f"    -- ...还有{len(mappings) - 5}个字段映射\n"
    
    content = f"""CREATE OR REPLACE PROCEDURE {proc_name}(
{params_str}
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_start_time TIMESTAMP := NOW();
    v_end_time TIMESTAMP;
    v_duration INTERVAL;
BEGIN
    -- ====================
    -- 步骤 1: 参数检查
    -- ====================
{param_checks_str}

    -- ====================
    -- 步骤 2: 日志开始
    -- ====================
    RAISE NOTICE '存储过程 {proc_name} 开始执行';
    RAISE NOTICE '目标表: {table_name} ({layer_name}层)';

{mapping_comment}
    -- ====================
    -- 步骤 3: 业务处理
    -- ====================
    BEGIN
        -- 插入数据
        INSERT INTO {table_name} (
            {insert_fields_str},
            create_time,
            update_time,
            create_by,
            update_by
        ) VALUES (
            {insert_values_str},
            NOW(),
            NOW(),
            CURRENT_USER,
            CURRENT_USER
        );

        IF NOT FOUND THEN
            p_result_code := -3;
            p_result_msg := '数据插入失败';
            RAISE NOTICE '数据插入失败';
            RETURN;
        END IF;

        -- 提交事务
        COMMIT;

        p_result_code := 0;
        p_result_msg := '执行成功';

    EXCEPTION
        -- ====================
        -- 步骤 4: 异常处理
        -- ====================
        WHEN UNIQUE_VIOLATION THEN
            ROLLBACK;
            p_result_code := -4;
            p_result_msg := '数据已存在';
            RAISE NOTICE '异常发生: 数据已存在';
            RETURN;
        
        WHEN OTHERS THEN
            ROLLBACK;
            p_result_code := SQLSTATE;
            p_result_msg := SQLERRM;
            RAISE NOTICE '异常发生: SQLSTATE=%, SQLERRM=%', SQLSTATE, SQLERRM;
            RETURN;
    END;

    -- ====================
    -- 步骤 5: 日志结束
    -- ====================
    v_end_time := NOW();
    v_duration := v_end_time - v_start_time;
    RAISE NOTICE '存储过程 {proc_name} 执行完成';
    RAISE NOTICE '执行时间: %', v_duration;
    RAISE NOTICE '输出结果: result_code=%, result_msg=%', p_result_code, p_result_msg;

END $$;
"""
    
    return content

def generate_all_procedures():
    safe_print("=" * 80)
    safe_print("存储过程批量生成")
    safe_print("=" * 80)
    
    os.makedirs(os.path.join(PROC_DIR, 'ods_to_dwd'), exist_ok=True)
    os.makedirs(os.path.join(PROC_DIR, 'dwd_to_dws'), exist_ok=True)
    os.makedirs(os.path.join(PROC_DIR, 'dws_to_ads'), exist_ok=True)
    
    generated_count = 0
    skipped_count = 0
    
    for layer in ['dwd', 'dws', 'ads']:
        layer_dir = os.path.join(DDL_DIR, layer)
        if not os.path.isdir(layer_dir):
            continue
        
        safe_print(f"\n--- {LAYER_MAP.get(layer)}层 ---")
        
        for filename in os.listdir(layer_dir):
            if not filename.endswith('.sql'):
                continue
            
            table_name = filename[:-4]
            
            if layer == 'dwd':
                target_dir = os.path.join(PROC_DIR, 'ods_to_dwd')
            elif layer == 'dws':
                target_dir = os.path.join(PROC_DIR, 'dwd_to_dws')
            else:
                target_dir = os.path.join(PROC_DIR, 'dws_to_ads')
            
            output_file = os.path.join(target_dir, f'pro_{table_name}.sql')
            
            if os.path.exists(output_file):
                safe_print(f"  ⚠ 已存在，跳过: {output_file}")
                skipped_count += 1
                continue
            
            safe_print(f"  生成: {table_name}")
            
            content = generate_procedure(table_name, layer)
            if content:
                with open(output_file, 'w', encoding='utf-8') as f:
                    f.write(content)
                safe_print(f"    ✓ 成功: {output_file}")
                generated_count += 1
            else:
                safe_print(f"    ✗ 失败: {table_name}")
                skipped_count += 1
    
    safe_print("\n" + "=" * 80)
    safe_print(f"生成完成! 成功: {generated_count} 个, 跳过: {skipped_count} 个")
    safe_print("=" * 80)
    
    return generated_count > 0

def generate_single_procedure(table_name, layer):
    safe_print(f"生成存储过程: {table_name} ({layer})")
    
    content = generate_procedure(table_name, layer)
    if not content:
        safe_print(f"✗ 生成失败")
        return False
    
    if layer == 'dwd':
        target_dir = os.path.join(PROC_DIR, 'ods_to_dwd')
    elif layer == 'dws':
        target_dir = os.path.join(PROC_DIR, 'dwd_to_dws')
    else:
        target_dir = os.path.join(PROC_DIR, 'dws_to_ads')
    
    os.makedirs(target_dir, exist_ok=True)
    
    output_file = os.path.join(target_dir, f'pro_{table_name}.sql')
    
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write(content)
    
    safe_print(f"✓ 成功: {output_file}")
    return True

def main():
    parser = argparse.ArgumentParser(description='存储过程生成工具')
    parser.add_argument('--table', help='目标表名')
    parser.add_argument('--layer', choices=['dwd', 'dws', 'ads'], help='目标层级')
    parser.add_argument('--all', action='store_true', help='批量生成所有存储过程')
    
    args = parser.parse_args()
    
    if args.all:
        generate_all_procedures()
    elif args.table and args.layer:
        generate_single_procedure(args.table, args.layer)
    else:
        parser.print_help()
        sys.exit(1)

if __name__ == '__main__':
    main()