#!/usr/bin/env python3

import subprocess
import sys
import os
import argparse

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

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
    stdout, stderr, rc = run_command("git diff --cached --name-only")
    staged = [f.strip() for f in stdout.strip().split('\n') if f.strip()]
    stdout, stderr, rc = run_command("git diff --name-only")
    unstaged = [f.strip() for f in stdout.strip().split('\n') if f.strip()]
    return list(set(staged + unstaged))

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
    print("\n1. 检查Python环境...")
    if sys.executable:
        print("   ✓ Python已安装")
        return True
    else:
        print("   ✗ Python未安装")
        return False

def check_unstaged_changes():
    print("\n2. 检查工作区未暂存变更...")
    stdout, stderr, rc = run_command("git diff --name-only")
    unstaged_files = [f.strip() for f in stdout.strip().split('\n') if f.strip()]
    
    non_whitelist_unstaged = [f for f in unstaged_files if not is_in_whitelist(f)]
    
    if non_whitelist_unstaged:
        print("   ✗ 工作区存在未暂存的变更:")
        for file in non_whitelist_unstaged[:5]:
            print(f"     - {file}")
        if len(non_whitelist_unstaged) > 5:
            print(f"     ...还有{len(non_whitelist_unstaged) - 5}个文件")
        print("   ✗ 请先使用 git add 添加所有变更文件")
        return False
    print("   ✓ 工作区未暂存变更检查通过")
    return True

def check_untracked_files():
    print("\n3. 检查未跟踪文件...")
    stdout, stderr, rc = run_command("git ls-files --others --exclude-standard")
    untracked_files = [f.strip() for f in stdout.strip().split('\n') if f.strip()]
    
    non_whitelist_untracked = [f for f in untracked_files if not is_in_whitelist(f)]
    
    if non_whitelist_untracked:
        print("   ✗ 发现未跟踪文件:")
        for file in non_whitelist_untracked[:5]:
            print(f"     - {file}")
        if len(non_whitelist_untracked) > 5:
            print(f"     ...还有{len(non_whitelist_untracked) - 5}个文件")
        print("   ✗ 请使用 git add 添加或 .gitignore 忽略")
        return False
    print("   ✓ 未跟踪文件检查通过")
    return True

def check_staged_files():
    print("\n4. 检查暂存区文件...")
    staged_files = get_staged_files()
    if not staged_files:
        print("   ✗ 暂存区没有文件")
        print("   ✗ 请先使用 git add 添加文件")
        return False
    print("   ✓ 暂存区文件检查通过")
    return True

def run_doc_review(changed_files=None):
    print("\n5. 执行文档变更审核...")
    
    if not changed_files or not has_doc_changes(changed_files):
        print("   ✓ 无文档变更，跳过审核")
        return True
    
    cmd = "python scripts/validate_document_changes.py"
    
    stdout, stderr, rc = run_command(cmd)
    print(stdout)
    
    if rc != 0:
        print("   ⚠ 文档审核发现警告，建议人工审核")
        print("   ⚠ 是否继续提交？(y/N)")
        try:
            import getpass
            response = getpass.getpass("")
            if response.lower() != 'y':
                print("   ✗ 用户取消提交")
                return False
            print("   ✓ 用户确认继续提交")
        except:
            print("   ✗ 无法获取用户输入，取消提交")
            return False
    
    print("   ✓ 文档变更审核通过")
    return True

def run_consistency_check(quick_mode=False, changed_files=None):
    print("\n6. 执行数据资产一致性校验...")
    
    if quick_mode and changed_files and not has_data_asset_changes(changed_files):
        print("   ✓ 无数据资产变更，跳过校验")
        return True
    
    cmd = "python scripts/validate_consistency.py"
    if quick_mode:
        cmd += " --quick"
    if changed_files:
        changed_str = ' '.join(f'"{f}"' for f in changed_files)
        cmd += f" --changed {changed_str}"
    
    stdout, stderr, rc = run_command(cmd)
    if rc != 0:
        print("   ✗ 数据资产一致性校验失败")
        print("   ✗ 请修复校验错误后重新提交")
        return False
    print("   ✓ 数据资产一致性校验通过")
    return True

def run_generated_files_check(quick_mode=False, changed_files=None):
    print("\n7. 执行文件生成校验...")
    
    if quick_mode and changed_files and not has_data_asset_changes(changed_files):
        print("   ✓ 无数据资产变更，跳过校验")
        return True
    
    cmd = "python scripts/validate_generated_files.py"
    if quick_mode:
        cmd += " --quick"
    if changed_files:
        changed_str = ' '.join(f'"{f}"' for f in changed_files)
        cmd += f" --changed {changed_str}"
    
    stdout, stderr, rc = run_command(cmd)
    if rc != 0:
        print("   ✗ 文件生成校验失败")
        print("   ✗ 请修复校验错误后重新提交")
        return False
    print("   ✓ 文件生成校验通过")
    return True

def main():
    parser = argparse.ArgumentParser(description='Git Pre-Commit Hook')
    parser.add_argument('--mode', choices=['quick', 'full'], default='quick',
                       help='校验模式: quick(快速)或full(完整)')
    args = parser.parse_args()
    
    print("=" * 70)
    print("  Git Pre-Commit Hook - 自动校验")
    print("=" * 70)
    
    print(f"  模式: {'快速校验' if args.mode == 'quick' else '完整校验'}")
    
    if not check_python():
        sys.exit(1)
    
    if not check_staged_files():
        sys.exit(1)
    
    if not check_unstaged_changes():
        sys.exit(1)
    
    if not check_untracked_files():
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
    
    print("\n" + "=" * 70)
    print("  所有校验通过，可以提交!")
    print("=" * 70)
    
    sys.exit(0)

if __name__ == "__main__":
    main()