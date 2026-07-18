#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import sys
import subprocess

from utils import fix_windows_encoding, safe_print, run_command, get_changed_files

fix_windows_encoding()

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SCRIPTS_DIR = os.path.join(BASE_DIR, 'scripts')

def run_validation_script(script_name):
    script_path = os.path.join(SCRIPTS_DIR, script_name)
    if not os.path.exists(script_path):
        return None, f"脚本不存在: {script_name}"
    
    result = subprocess.run(
        [sys.executable, script_path],
        capture_output=True,
        cwd=BASE_DIR,
        encoding='utf-8',
        errors='replace'
    )
    return result.returncode, result.stdout + result.stderr

def validate_document_changes():
    safe_print("\n" + "=" * 60)
    safe_print("1. 文档变更审核")
    safe_print("=" * 60)
    
    rc, output = run_validation_script('validate_document_changes.py')
    
    if output:
        safe_print(output)
    
    if rc == 0:
        safe_print("\n✓ 文档变更审核通过")
        return True
    else:
        safe_print("\n✗ 文档变更审核失败")
        return False

def validate_cross_layer_consistency():
    safe_print("\n" + "=" * 60)
    safe_print("2. 跨层一致性校验")
    safe_print("=" * 60)
    
    rc, output = run_validation_script('validate_cross_layer_consistency.py')
    
    if output:
        safe_print(output)
    
    if rc == 0:
        safe_print("\n✓ 跨层一致性校验通过")
        return True
    else:
        safe_print("\n✗ 跨层一致性校验失败")
        return False

def validate_syntax():
    safe_print("\n" + "=" * 60)
    safe_print("3. SQL语法检查")
    safe_print("=" * 60)
    
    errors = []
    
    ddl_dir = os.path.join(BASE_DIR, 'data_assets', 'ddl')
    if os.path.isdir(ddl_dir):
        for root, dirs, files in os.walk(ddl_dir):
            for f in files:
                if f.endswith('.sql'):
                    filepath = os.path.join(root, f)
                    with open(filepath, 'r', encoding='utf-8', errors='replace') as file:
                        content = file.read()
                        if content.strip():
                            if not content.strip().endswith(';'):
                                errors.append(f"  - {filepath}: SQL文件未以分号结尾")
                            if '--' in content and content.count('--') > content.count('\n') * 2:
                                errors.append(f"  - {filepath}: 可能存在未关闭的注释")
    
    if errors:
        for error in errors:
            safe_print(error)
        safe_print("\n✗ SQL语法检查失败")
        return False
    else:
        safe_print("  ✓ SQL语法检查通过")
        return True

def validate_json():
    safe_print("\n" + "=" * 60)
    safe_print("4. JSON格式检查")
    safe_print("=" * 60)
    
    errors = []
    
    for root, dirs, files in os.walk(BASE_DIR):
        if '.git' in root:
            continue
        for f in files:
            if f.endswith('.json'):
                filepath = os.path.join(root, f)
                try:
                    import json
                    with open(filepath, 'r', encoding='utf-8') as file:
                        json.load(file)
                except json.JSONDecodeError as e:
                    errors.append(f"  - {filepath}: JSON解析错误: {str(e)}")
                except Exception as e:
                    errors.append(f"  - {filepath}: 读取错误: {str(e)}")
    
    if errors:
        for error in errors:
            safe_print(error)
        safe_print("\n✗ JSON格式检查失败")
        return False
    else:
        safe_print("  ✓ JSON格式检查通过")
        return True

def validate_yaml():
    safe_print("\n" + "=" * 60)
    safe_print("5. YAML格式检查")
    safe_print("=" * 60)
    
    errors = []
    
    for root, dirs, files in os.walk(BASE_DIR):
        if '.git' in root:
            continue
        for f in files:
            if f.endswith('.yml') or f.endswith('.yaml'):
                filepath = os.path.join(root, f)
                try:
                    import yaml
                    with open(filepath, 'r', encoding='utf-8') as file:
                        yaml.safe_load(file)
                except ImportError:
                    safe_print("  - 未安装PyYAML，跳过YAML检查")
                    return True
                except yaml.YAMLError as e:
                    errors.append(f"  - {filepath}: YAML解析错误: {str(e)}")
                except Exception as e:
                    errors.append(f"  - {filepath}: 读取错误: {str(e)}")
    
    if errors:
        for error in errors:
            safe_print(error)
        safe_print("\n✗ YAML格式检查失败")
        return False
    else:
        safe_print("  ✓ YAML格式检查通过")
        return True

def validate_git_consistency():
    safe_print("\n" + "=" * 60)
    safe_print("6. Git一致性检查")
    safe_print("=" * 60)
    
    stdout, stderr, rc = run_command("git status --porcelain")
    if rc != 0:
        safe_print(f"  ✗ Git状态检查失败: {stderr}")
        return False
    
    untracked = [line for line in stdout.split('\n') if line.startswith('??')]
    modified = [line for line in stdout.split('\n') if line.startswith(' M') or line.startswith('M ')]
    staged = [line for line in stdout.split('\n') if line.startswith('A ') or line.startswith(' M') or line.startswith('M ') or line.startswith('D ')]
    
    if untracked:
        safe_print(f"  ⚠ 存在未跟踪文件: {len(untracked)} 个")
    
    if modified:
        safe_print(f"  ⚠ 存在未暂存的修改: {len(modified)} 个")
    
    safe_print("  ✓ Git一致性检查完成")
    return True

def run_full_validation():
    safe_print("=" * 80)
    safe_print("工作区完整校验")
    safe_print("=" * 80)
    
    results = []
    
    results.append(('文档变更审核', validate_document_changes()))
    results.append(('跨层一致性校验', validate_cross_layer_consistency()))
    results.append(('SQL语法检查', validate_syntax()))
    results.append(('JSON格式检查', validate_json()))
    results.append(('YAML格式检查', validate_yaml()))
    results.append(('Git一致性检查', validate_git_consistency()))
    
    safe_print("\n" + "=" * 80)
    safe_print("校验结果汇总")
    safe_print("=" * 80)
    
    all_passed = True
    for name, passed in results:
        status = "✓ 通过" if passed else "✗ 失败"
        safe_print(f"  {name}: {status}")
        if not passed:
            all_passed = False
    
    safe_print("\n" + "=" * 80)
    
    if all_passed:
        safe_print("✓ 所有校验通过")
        return True
    else:
        safe_print("✗ 部分校验未通过")
        return False

def run_quick_validation():
    safe_print("=" * 80)
    safe_print("工作区快速校验")
    safe_print("=" * 80)
    
    results = []
    
    results.append(('文档变更审核', validate_document_changes()))
    results.append(('SQL语法检查', validate_syntax()))
    results.append(('JSON格式检查', validate_json()))
    results.append(('YAML格式检查', validate_yaml()))
    
    safe_print("\n" + "=" * 80)
    safe_print("校验结果汇总")
    safe_print("=" * 80)
    
    all_passed = True
    for name, passed in results:
        status = "✓ 通过" if passed else "✗ 失败"
        safe_print(f"  {name}: {status}")
        if not passed:
            all_passed = False
    
    safe_print("\n" + "=" * 80)
    
    if all_passed:
        safe_print("✓ 所有校验通过")
        return True
    else:
        safe_print("✗ 部分校验未通过")
        return False

def main():
    mode = 'full'
    if len(sys.argv) > 1:
        mode = sys.argv[1]
    
    if mode == 'quick':
        success = run_quick_validation()
    else:
        success = run_full_validation()
    
    sys.exit(0 if success else 1)

if __name__ == '__main__':
    main()
