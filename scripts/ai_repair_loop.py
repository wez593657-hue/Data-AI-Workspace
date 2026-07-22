#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import sys
import subprocess

from utils import fix_windows_encoding, safe_print, run_command

fix_windows_encoding()

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SCRIPTS_DIR = os.path.join(BASE_DIR, 'scripts')

MAX_RETRIES = 3

def run_validation():
    script_path = os.path.join(SCRIPTS_DIR, 'workspace_validation.py')
    result = subprocess.run(
        [sys.executable, script_path],
        capture_output=True,
        cwd=BASE_DIR,
        encoding='utf-8',
        errors='replace'
    )
    return result.returncode == 0, result.stdout + result.stderr

def detect_issues(validation_output):
    issues = []
    
    if 'DDL存在但数据字典缺失' in validation_output:
        issues.append('data_dictionary_missing')
    
    if 'DDL有但数据字典缺少字段' in validation_output:
        issues.append('field_mismatch_ddl_dict')
    
    if '数据字典有但DDL缺少字段' in validation_output:
        issues.append('field_mismatch_dict_ddl')
    
    if '表名应使用' in validation_output:
        issues.append('naming_convention')
    
    if '临时表应使用' in validation_output:
        issues.append('temp_table_naming')
    
    if 'SQL文件未以分号结尾' in validation_output:
        issues.append('sql_syntax')
    
    if 'JSON解析错误' in validation_output:
        issues.append('json_format')
    
    if 'YAML解析错误' in validation_output:
        issues.append('yaml_format')
    
    if '核心章节缺失' in validation_output:
        issues.append('doc_section_missing')
    
    if '可能删除核心章节' in validation_output:
        issues.append('doc_section_deleted')
    
    return issues

def fix_data_dictionary_missing(validation_output):
    safe_print("\n  尝试修复: 数据字典缺失")
    
    import re
    
    matches = re.findall(r'\[(dwd|dws|ads)\]\s+(\w+): DDL存在但数据字典缺失', validation_output)
    if not matches:
        safe_print("    未找到缺失的数据字典")
        return False
    
    for layer, table_name in matches:
        dict_dir = os.path.join(BASE_DIR, 'data_assets', 'data_dictionary', layer)
        os.makedirs(dict_dir, exist_ok=True)
        
        dict_file = os.path.join(dict_dir, f'{table_name}.md')
        if os.path.exists(dict_file):
            continue
        
        ddl_file = os.path.join(BASE_DIR, 'data_assets', 'ddl', layer, f'{table_name}.sql')
        if not os.path.exists(ddl_file):
            continue
        
        with open(ddl_file, 'r', encoding='utf-8', errors='replace') as f:
            ddl_content = f.read()
        
        fields = []
        for line in ddl_content.split('\n'):
            line = line.strip()
            if line and not line.startswith('--') and not line.startswith('PRIMARY') and not line.startswith('UNIQUE') and not line.startswith('CONSTRAINT'):
                parts = line.split()
                if len(parts) >= 2:
                    field_name = parts[0].lower()
                    if field_name not in ['create', 'table', 'if', 'not', 'exists']:
                        fields.append(field_name)
        
        if not fields:
            continue
        
        content = f"""# {table_name}

## 表信息

| 属性 | 值 |
|------|-----|
| 表名 | {table_name} |
| 所属层级 | {layer.upper()} |
| 描述 | 待补充 |

## 字段列表

| 字段名 | 类型 | 描述 | 约束 |
|--------|------|------|------|
"""
        
        for field in fields:
            field_type = 'VARCHAR(100)'
            description = '待补充'
            constraint = ''
            
            if field.endswith('_id'):
                field_type = 'VARCHAR(50)'
                constraint = '主键'
            elif field.endswith('_name'):
                field_type = 'VARCHAR(200)'
            elif field.endswith('_code'):
                field_type = 'VARCHAR(50)'
            elif field.endswith('_time'):
                field_type = 'TIMESTAMP'
            elif field.endswith('_amount'):
                field_type = 'DECIMAL(18,2)'
            elif field.endswith('_flag'):
                field_type = 'VARCHAR(10)'
            elif field.endswith('_status'):
                field_type = 'VARCHAR(20)'
            
            content += f"| {field} | {field_type} | {description} | {constraint} |\n"
        
        content += """

## 审计字段

| 字段名 | 类型 | 描述 |
|--------|------|------|
| create_time | TIMESTAMP | 创建时间 |
| update_time | TIMESTAMP | 更新时间 |
| create_by | VARCHAR(50) | 创建人 |
| update_by | VARCHAR(50) | 更新人 |
"""
        
        with open(dict_file, 'w', encoding='utf-8') as f:
            f.write(content)
        
        safe_print(f"    ✓ 创建数据字典: {dict_file}")
    
    return True

def fix_field_mismatch(validation_output):
    safe_print("\n  尝试修复: 字段不一致")
    
    import re
    
    ddl_only_matches = re.findall(r'\[(dwd|dws|ads)\]\s+(\w+): DDL有但数据字典缺少字段: (.+)', validation_output)
    dict_only_matches = re.findall(r'\[(dwd|dws|ads)\]\s+(\w+): 数据字典有但DDL缺少字段: (.+)', validation_output)
    
    for layer, table_name, fields_str in ddl_only_matches:
        dict_file = os.path.join(BASE_DIR, 'data_assets', 'data_dictionary', layer, f'{table_name}.md')
        if not os.path.exists(dict_file):
            continue
        
        fields = [f.strip() for f in fields_str.split(',')]
        
        with open(dict_file, 'r', encoding='utf-8') as f:
            content = f.read()
        
        lines = content.split('\n')
        field_list_idx = -1
        for i, line in enumerate(lines):
            if '## 字段列表' in line:
                field_list_idx = i
                break
        
        if field_list_idx == -1:
            continue
        
        separator_idx = -1
        for i in range(field_list_idx + 1, len(lines)):
            if lines[i].startswith('|----'):
                separator_idx = i
                break
        
        if separator_idx == -1:
            continue
        
        new_lines = []
        for field in fields:
            field_type = 'VARCHAR(100)'
            if field.endswith('_id'):
                field_type = 'VARCHAR(50)'
            elif field.endswith('_name'):
                field_type = 'VARCHAR(200)'
            elif field.endswith('_time'):
                field_type = 'TIMESTAMP'
            elif field.endswith('_amount'):
                field_type = 'DECIMAL(18,2)'
            
            new_lines.append(f"| {field} | {field_type} | 待补充 | |")
        
        lines.insert(separator_idx + 1, '\n'.join(new_lines))
        
        with open(dict_file, 'w', encoding='utf-8') as f:
            f.write('\n'.join(lines))
        
        safe_print(f"    ✓ 补充字段到数据字典: {table_name}")
    
    return True

def fix_naming_convention(validation_output):
    safe_print("\n  尝试修复: 命名规范")
    
    import re
    
    matches = re.findall(r'\[(dwd|dws|ads)\]\s+(\w+): 表名应使用(\w+_)前缀', validation_output)
    if not matches:
        safe_print("    未找到命名规范问题")
        return False
    
    for layer, table_name, expected_prefix in matches:
        ddl_file = os.path.join(BASE_DIR, 'data_assets', 'ddl', layer, f'{table_name}.sql')
        if not os.path.exists(ddl_file):
            continue
        
        new_name = expected_prefix + table_name
        new_ddl_file = os.path.join(BASE_DIR, 'data_assets', 'ddl', layer, f'{new_name}.sql')
        
        with open(ddl_file, 'r', encoding='utf-8', errors='replace') as f:
            content = f.read()
        
        content = content.replace(table_name, new_name)
        
        with open(new_ddl_file, 'w', encoding='utf-8') as f:
            f.write(content)
        
        os.remove(ddl_file)
        
        dict_file = os.path.join(BASE_DIR, 'data_assets', 'data_dictionary', layer, f'{table_name}.md')
        if os.path.exists(dict_file):
            new_dict_file = os.path.join(BASE_DIR, 'data_assets', 'data_dictionary', layer, f'{new_name}.md')
            with open(dict_file, 'r', encoding='utf-8') as f:
                dict_content = f.read()
            dict_content = dict_content.replace(table_name, new_name)
            with open(new_dict_file, 'w', encoding='utf-8') as f:
                f.write(dict_content)
            os.remove(dict_file)
        
        safe_print(f"    ✓ 重命名表: {table_name} -> {new_name}")
    
    return True

def apply_fixes(issues, validation_output):
    safe_print("\n=== 应用修复 ===")
    
    if 'data_dictionary_missing' in issues:
        fix_data_dictionary_missing(validation_output)
    
    if 'field_mismatch_ddl_dict' in issues:
        fix_field_mismatch(validation_output)
    
    if 'naming_convention' in issues:
        fix_naming_convention(validation_output)
    
    safe_print("\n  ✓ 修复应用完成")

def main():
    safe_print("=" * 80)
    safe_print("AI 修复循环")
    safe_print("=" * 80)
    
    for attempt in range(1, MAX_RETRIES + 1):
        safe_print(f"\n--- 第 {attempt}/{MAX_RETRIES} 次尝试 ---")
        
        safe_print("\n1. 执行工作区校验...")
        success, output = run_validation()
        
        if success:
            safe_print("\n✓ 校验通过，无需修复")
            sys.exit(0)
        
        safe_print("\n✗ 校验失败，检测问题...")
        
        issues = detect_issues(output)
        if not issues:
            safe_print("  无法检测到具体问题类型，需人工审查")
            sys.exit(1)
        
        safe_print(f"\n  检测到问题: {', '.join(issues)}")
        
        safe_print("\n2. 应用修复...")
        apply_fixes(issues, output)
        
        safe_print("\n3. 再次执行校验验证修复...")
        success, output = run_validation()
        
        if success:
            safe_print("\n✓ 修复成功，所有校验通过")
            sys.exit(0)
        
        safe_print("\n✗ 修复后校验仍未通过")
    
    safe_print(f"\n✗ 经过 {MAX_RETRIES} 次修复尝试后仍未通过")
    safe_print("  请进行人工审查")
    sys.exit(1)

if __name__ == '__main__':
    main()
