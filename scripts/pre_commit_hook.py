#!/usr/bin/env python3

import subprocess
import sys
import os
import argparse

# 修复 Windows GBK 控制台 Unicode 编码问题
import sys as _sys
if hasattr(_sys.stdout, 'reconfigure'):
    _sys.stdout.reconfigure(encoding='utf-8', errors='replace')
if hasattr(_sys.stderr, 'reconfigure'):
    _sys.stderr.reconfigure(encoding='utf-8', errors='replace')

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

def safe_print(*args, **kwargs):
    try:
        print(*args, **kwargs)
    except UnicodeEncodeError:
        text = ' '.join(str(arg) for arg in args)
        text = text.replace('✓', '[OK]').replace('✗', '[FAIL]').replace('⚠', '[WARN]')
        print(text)

WHITELIST_PATTERNS = [
    'docs/',
    'README.md',
    '.git/',
    '.github/',
    'scripts/',
    '.vscode/',
    '.gitignore',
    'CONTRIBUTING.md'
]

DOC_REVIEW_PATTERNS = [
    'docs/',
    'README.md',
    'CONTRIBUTING.md'
]

def run_command(cmd, cwd=None):
    if cwd is None:
        cwd = BASE_DIR
    result = subprocess.run(cmd, shell=True, capture_output=True, text=True, cwd=cwd)
    return result.stdout, result.stderr, result.returncode

def is_in_whitelist(filepath):
    for pattern in WHITELIST_PATTERNS:
        if filepath.startswith(pattern) or filepath == pattern.rstrip('/'):
            return True
    return False

def is_doc_file(filepath):
    for pattern in DOC_REVIEW_PATTERNS:
        if filepath.startswith(pattern) or filepath == pattern.rstrip('/'):
            return True
    return False

def get_changed_files():
    return get_staged_files()

def get_staged_files():
    stdout, stderr, rc = run_command("git diff --cached --name-only")
    return [f.strip() for f in stdout.strip().split('\n') if f.strip()]

def has_data_asset_changes(files):
    data_asset_paths = [
        'data_assets/',
    ]
    return any(f.startswith(p) for f in files for p in data_asset_paths)

def has_doc_changes(files):
    return any(is_doc_file(f) for f in files)

def check_python():
    safe_print("\n1. 检查Python环境...")
    if sys.executable:
        safe_print("   ✓ Python已安装")
        return True
    else:
        safe_print("   ✗ Python未安装")
        return False

def check_unstaged_changes():
    safe_print("\n2. 检查工作区未暂存变更...")
    stdout, stderr, rc = run_command("git diff --name-only")
    unstaged_files = [f.strip() for f in stdout.strip().split('\n') if f.strip()]
    
    non_whitelist_unstaged = [f for f in unstaged_files if not is_in_whitelist(f)]
    
    if non_whitelist_unstaged:
        safe_print("   ✗ 工作区存在未暂存的变更:")
        for file in non_whitelist_unstaged[:5]:
            safe_print(f"     - {file}")
        if len(non_whitelist_unstaged) > 5:
            safe_print(f"     ...还有{len(non_whitelist_unstaged) - 5}个文件")
        safe_print("   ✗ 请先使用 git add 添加所有变更文件")
        return False
    safe_print("   ✓ 工作区未暂存变更检查通过")
    return True

def check_untracked_files():
    safe_print("\n3. 检查未跟踪文件...")
    stdout, stderr, rc = run_command("git ls-files --others --exclude-standard")
    untracked_files = [f.strip() for f in stdout.strip().split('\n') if f.strip()]
    
    non_whitelist_untracked = [f for f in untracked_files if not is_in_whitelist(f)]
    
    if non_whitelist_untracked:
        safe_print("   ✗ 发现未跟踪文件:")
        for file in non_whitelist_untracked[:5]:
            safe_print(f"     - {file}")
        if len(non_whitelist_untracked) > 5:
            safe_print(f"     ...还有{len(non_whitelist_untracked) - 5}个文件")
        safe_print("   ✗ 请使用 git add 添加或 .gitignore 忽略")
        return False
    safe_print("   ✓ 未跟踪文件检查通过")
    return True

def check_staged_files():
    safe_print("\n4. 检查暂存区文件...")
    staged_files = get_staged_files()
    if not staged_files:
        safe_print("   ✗ 暂存区没有文件")
        safe_print("   ✗ 请先使用 git add 添加文件")
        return False
    safe_print("   ✓ 暂存区文件检查通过")
    return True

def run_doc_review(changed_files=None):
    safe_print("\n5. 执行文档变更审核...")
    
    if not changed_files or not has_doc_changes(changed_files):
        safe_print("   ✓ 无文档变更，跳过审核")
        return True
    
    cmd = "python scripts/validate_document_changes.py"
    
    stdout, stderr, rc = run_command(cmd)
    print(stdout)
    
    if rc != 0:
        safe_print("   ✗ 文档审核发现规则冲突，请修复后再提交")
        return False
    
    safe_print("   ✓ 文档变更审核通过")
    return True

def run_consistency_check(quick_mode=False, changed_files=None):
    safe_print("\n6. 执行数据资产一致性校验...")
    
    if quick_mode and changed_files and not has_data_asset_changes(changed_files):
        safe_print("   ✓ 无数据资产变更，跳过校验")
        return True
    
    cmd = "python scripts/validate_consistency.py"
    if quick_mode:
        cmd += " --quick"
    if changed_files:
        changed_str = ' '.join(f'"{f}"' for f in changed_files)
        cmd += f" --changed {changed_str}"
    
    stdout, stderr, rc = run_command(cmd)
    if rc != 0:
        safe_print("   ✗ 数据资产一致性校验失败")
        safe_print("   ✗ 请修复校验错误后重新提交")
        return False
    safe_print("   ✓ 数据资产一致性校验通过")
    return True

def run_generated_files_check(quick_mode=False, changed_files=None):
    safe_print("\n7. 执行文件生成校验...")
    
    if quick_mode and changed_files and not has_data_asset_changes(changed_files):
        safe_print("   ✓ 无数据资产变更，跳过校验")
        return True
    
    cmd = "python scripts/validate_generated_files.py"
    if quick_mode:
        cmd += " --quick"
    if changed_files:
        changed_str = ' '.join(f'"{f}"' for f in changed_files)
        cmd += f" --changed {changed_str}"
    
    stdout, stderr, rc = run_command(cmd)
    if rc != 0:
        safe_print("   ✗ 文件生成校验失败")
        safe_print("   ✗ 请修复校验错误后重新提交")
        return False
    safe_print("   ✓ 文件生成校验通过")
    return True

def main():
    parser = argparse.ArgumentParser(description='Git Pre-Commit Hook')
    parser.add_argument('--mode', choices=['quick', 'full'], default='quick',
                       help='校验模式: quick(快速)或full(完整)')
    args = parser.parse_args()
    
    safe_print("=" * 70)
    safe_print("  Git Pre-Commit Hook - 自动校验")
    safe_print("=" * 70)
    
    safe_print(f"  模式: {'快速校验' if args.mode == 'quick' else '完整校验'}")
    
    if not check_python():
        sys.exit(1)
    
    if not check_staged_files():
        sys.exit(1)
    
    changed_files = get_changed_files()
    
    if not run_doc_review(changed_files):
        sys.exit(1)
    
    if args.mode == 'full':
        if not run_consistency_check(False, changed_files):
            sys.exit(1)
        if not run_generated_files_check(False, changed_files):
            sys.exit(1)
    else:
        if not run_consistency_check(True, changed_files):
            sys.exit(1)
        if not run_generated_files_check(True, changed_files):
            sys.exit(1)
    
    safe_print("\n" + "=" * 70)
    safe_print("  所有校验通过，可以提交!")
    safe_print("=" * 70)
    
    sys.exit(0)

if __name__ == "__main__":
    main()
