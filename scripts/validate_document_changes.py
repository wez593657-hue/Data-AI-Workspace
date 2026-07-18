#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import subprocess
import os
import sys
import re
from difflib import unified_diff

# 修复 Windows GBK 控制台 Unicode 编码问题
import sys as _sys
if hasattr(_sys.stdout, 'reconfigure'):
    _sys.stdout.reconfigure(encoding='utf-8', errors='replace')
if hasattr(_sys.stderr, 'reconfigure'):
    _sys.stderr.reconfigure(encoding='utf-8', errors='replace')

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DOCS_DIR = os.path.join(BASE_DIR, 'docs')

def run_command(cmd, cwd=None):
    if cwd is None:
        cwd = BASE_DIR
    result = subprocess.run(cmd, shell=True, capture_output=True, cwd=cwd, encoding='utf-8', errors='replace')
    return result.stdout, result.stderr, result.returncode

def get_staged_files():
    stdout, stderr, rc = run_command("git diff --cached --name-only")
    if not stdout:
        return []
    return [f.strip() for f in stdout.strip().split('\n') if f.strip()]

def get_file_diff(filepath):
    stdout, stderr, rc = run_command(f"git diff --cached {filepath}")
    return stdout if stdout else ''

def get_file_status(filepath):
    stdout, stderr, rc = run_command(f"git diff --cached --name-status {filepath}")
    status = stdout.strip().split('\t')[0] if '\t' in stdout else 'M'
    return status

def analyze_change_type(status, diff_content):
    if status == 'A':
        return '新增文件'
    elif status == 'D':
        return '删除文件'
    elif status == 'M':
        added_lines = sum(1 for line in diff_content.split('\n') if line.startswith('+') and not line.startswith('+++'))
        deleted_lines = sum(1 for line in diff_content.split('\n') if line.startswith('-') and not line.startswith('---'))
        
        if deleted_lines == 0 and added_lines > 0:
            return '新增内容'
        elif added_lines == 0 and deleted_lines > 0:
            return '删除内容'
        else:
            return '修改内容'
    return '未知'

def extract_added_sections(diff_content):
    sections = []
    current_section = []
    in_addition = False
    
    for line in diff_content.split('\n'):
        if line.startswith('+') and not line.startswith('+++'):
            in_addition = True
            current_section.append(line[1:].strip())
        elif in_addition and line.startswith(' ') or line.startswith('-'):
            if current_section:
                sections.append('\n'.join(current_section))
                current_section = []
            in_addition = False
    
    if current_section:
        sections.append('\n'.join(current_section))
    
    return sections

def extract_modified_sections(diff_content):
    sections = []
    current_modification = []
    in_context = False
    
    lines = diff_content.split('\n')
    i = 0
    while i < len(lines):
        line = lines[i]
        if line.startswith('-') and not line.startswith('---'):
            removed = line[1:].strip()
            j = i + 1
            while j < len(lines) and lines[j].startswith(' '):
                j += 1
            if j < len(lines) and lines[j].startswith('+') and not lines[j].startswith('+++'):
                added = lines[j][1:].strip()
                current_modification.append(f"删除: {removed}")
                current_modification.append(f"新增: {added}")
                i = j + 1
                continue
        i += 1
        
        if current_modification:
            sections.append('\n'.join(current_modification))
            current_modification = []
    
    if current_modification:
        sections.append('\n'.join(current_modification))
    
    return sections

def check_rule_conflicts(added_sections, modified_sections, filepath):
    conflicts = []
    
    if not (added_sections or modified_sections):
        return conflicts
    
    all_changes = '\n'.join(added_sections + modified_sections).lower()
    
    conflict_patterns = [
        ('表名前缀规则变更', r'(?i)表名.*前缀.*(?:不应|不能|禁止|取消).*(?:dwd_|dws_|ads_|ods_)'),
        ('字段命名规则变更', r'(?i)字段名.*(?:不应|不能|禁止|取消).*(?:小写|下划线)'),
        ('数据分层规则变更', r'(?i)数据分层.*(?:不应|不能|禁止).*(?:ods|dwd|dws|ads)'),
        ('存储过程命名规则变更', r'(?i)存储过程.*(?:不应|不能|禁止).*pro_'),
        ('提交信息格式规则变更', r'(?i)提交信息.*(?:不应|不能|禁止).*(?:feat|fix|docs|chore)'),
        ('审计字段规则变更', r'(?i)审计字段.*(?:不应|不能|取消).*(?:create_time|update_time|create_by|update_by)'),
    ]
    
    for conflict_name, pattern in conflict_patterns:
        if re.search(pattern, all_changes):
            conflicts.append(f"检测到{conflict_name}，请确认是否与现有规则冲突")
    
    return conflicts

def check_doc_consistency(filepath, added_sections, modified_sections, status):
    issues = []
    
    if not filepath.startswith('docs/'):
        return issues
    
    doc_rules = {
        '01_AI_SOP.md': ['流程步骤', '审批环节', '角色分工'],
        '02_SQL_Standard.md': ['命名规范', '数据类型', '索引规则'],
        '05_Stored_Procedure.md': ['命名格式', '目录结构', '参数规范'],
        '07_Data_Dictionary.md': ['表信息', '字段列表', '审计字段'],
        '08_Mapping.md': ['映射概览', '字段映射', '转换规则'],
        '13_Governance_Framework.md': ['五层约束', '技术约束', '流程约束'],
    }
    
    filename = os.path.basename(filepath)
    if filename in doc_rules:
        required_sections = doc_rules[filename]
        
        if status == 'D':
            issues.append(f"删除规则文档: {filename}")
            return issues
        
        if status == 'M':
            all_changes = '\n'.join(modified_sections).lower()

            # 检查核心章节是否被删除：读取文件当前内容确认，而非仅依赖diff
            try:
                with open(os.path.join(BASE_DIR, filepath), 'r', encoding='utf-8') as f:
                    current_content = f.read().lower()
                for section in required_sections:
                    if '删除' in all_changes and section.lower() in all_changes:
                        # 二次确认：文件当前内容是否仍包含该章节关键词
                        section_keywords = {
                            '映射概览': ['映射', 'overview'],
                            '字段映射': ['字段映射', 'field', 'mapping'],
                            '转换规则': ['转换', 'transform'],
                        }
                        keywords = section_keywords.get(section, [section.lower()])
                        still_exists = any(kw in current_content for kw in keywords)
                        if not still_exists:
                            issues.append(f"可能删除核心章节: {section}")
            except:
                pass
            
            try:
                with open(os.path.join(BASE_DIR, filepath), 'r', encoding='utf-8') as f:
                    full_content = f.read().lower()
                    for section in required_sections:
                        found = False
                        keywords = {
                            '流程步骤': ['步骤', '工作流', 'workflow'],
                            '审批环节': ['审批', 'review', 'approve'],
                            '角色分工': ['角色', '分工', 'role', 'agent'],
                            '命名规范': ['命名', '规范', 'naming'],
                            '数据类型': ['数据类型', 'datatype', 'type'],
                            '索引规则': ['索引', 'index'],
                            '命名格式': ['命名', '格式', 'format'],
                            '目录结构': ['目录', '结构', 'directory'],
                            '参数规范': ['参数', 'parameter'],
                            '表信息': ['表信息', 'table'],
                            '字段列表': ['字段', 'column'],
                            '审计字段': ['审计', 'audit'],
                            '映射概览': ['映射', 'overview'],
                            '字段映射': ['字段映射', 'field', 'mapping'],
                            '转换规则': ['转换', 'transform'],
                            '五层约束': ['五层', '约束', 'governance'],
                            '技术约束': ['技术', '约束'],
                            '流程约束': ['流程', '约束'],
                        }
                        if section in keywords:
                            for keyword in keywords[section]:
                                if keyword in full_content:
                                    found = True
                                    break
                        else:
                            if section.lower() in full_content:
                                found = True
                        if not found:
                            issues.append(f"核心章节缺失: {section}")
            except:
                pass
    
    return issues

def generate_report(staged_files):
    report = []
    has_issues = False
    
    report.append("=" * 80)
    report.append("文档变更审核报告")
    report.append("=" * 80)
    
    for filepath in staged_files:
        if not (filepath.startswith('docs/') or filepath == 'README.md' or filepath == 'CONTRIBUTING.md'):
            continue
        
        report.append("\n" + "-" * 80)
        report.append(f"文件: {filepath}")
        report.append("-" * 80)
        
        status = get_file_status(filepath)
        diff_content = get_file_diff(filepath)
        change_type = analyze_change_type(status, diff_content)
        
        report.append(f"\n变更类型: {change_type}")
        
        if status == 'A':
            report.append("\n新增内容预览:")
            try:
                with open(os.path.join(BASE_DIR, filepath), 'r', encoding='utf-8') as f:
                    content = f.read()
                    lines = content.split('\n')[:20]
                    for i, line in enumerate(lines, 1):
                        report.append(f"  {i:3d} {line}")
                    if len(content.split('\n')) > 20:
                        report.append("  ... (文件内容过长，仅显示前20行)")
            except:
                report.append("  无法读取文件内容")
        
        elif status == 'M':
            added_sections = extract_added_sections(diff_content)
            modified_sections = extract_modified_sections(diff_content)
            
            if added_sections:
                report.append("\n新增内容:")
                for i, section in enumerate(added_sections[:3], 1):
                    report.append(f"  {i}. {section[:100]}..." if len(section) > 100 else f"  {i}. {section}")
                if len(added_sections) > 3:
                    report.append(f"  ... 还有{len(added_sections) - 3}处新增")
            
            if modified_sections:
                report.append("\n修改内容:")
                for i, section in enumerate(modified_sections[:3], 1):
                    report.append(f"  {i}. {section[:100]}..." if len(section) > 100 else f"  {i}. {section}")
                if len(modified_sections) > 3:
                    report.append(f"  ... 还有{len(modified_sections) - 3}处修改")
            
            conflicts = check_rule_conflicts(added_sections, modified_sections, filepath)
            if conflicts:
                report.append("\n⚠ 规则冲突警告:")
                for conflict in conflicts:
                    report.append(f"  - {conflict}")
                has_issues = True
            
            consistency_issues = check_doc_consistency(filepath, added_sections, modified_sections, status)
            if consistency_issues:
                report.append("\n⚠ 文档一致性警告:")
                for issue in consistency_issues:
                    report.append(f"  - {issue}")
                has_issues = True
        
        elif status == 'D':
            report.append("\n警告: 文件将被删除")
            has_issues = True
    
    report.append("\n" + "=" * 80)
    
    if has_issues:
        report.append("审核结果: ⚠ 存在警告，建议人工审核")
        report.append("=" * 80)
        print('\n'.join(report))
        return False
    else:
        report.append("审核结果: ✓ 审核通过")
        report.append("=" * 80)
        print('\n'.join(report))
        return True

def main():
    staged_files = get_staged_files()
    
    doc_files = [f for f in staged_files if 
                 f.startswith('docs/') or f == 'README.md' or f == 'CONTRIBUTING.md']
    
    if not doc_files:
        print("✓ 无文档变更，跳过审核")
        sys.exit(0)
    
    result = generate_report(doc_files)
    
    if result:
        sys.exit(0)
    else:
        sys.exit(1)

if __name__ == '__main__':
    main()