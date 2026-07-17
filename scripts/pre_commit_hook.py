#!/usr/bin/env python3

import subprocess
import sys
import os

def run_command(cmd):
    result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
    return result.stdout, result.stderr, result.returncode

def main():
    print("=" * 70)
    print("  Git Pre-Commit Hook - 自动校验")
    print("=" * 70)
    
    print("\n1. 检查Python环境...")
    if sys.executable:
        print("   ✓ Python已安装")
    else:
        print("   ✗ Python未安装")
        sys.exit(1)
    
    print("\n2. 执行数据资产一致性校验...")
    stdout, stderr, rc = run_command("python scripts/validate_consistency.py")
    if rc != 0:
        print("   ✗ 数据资产一致性校验失败")
        print("   ✗ 请修复校验错误后重新提交")
        sys.exit(1)
    print("   ✓ 数据资产一致性校验通过")
    
    print("\n3. 执行文件生成校验...")
    stdout, stderr, rc = run_command("python scripts/validate_generated_files.py")
    if rc != 0:
        print("   ✗ 文件生成校验失败")
        print("   ✗ 请修复校验错误后重新提交")
        sys.exit(1)
    print("   ✓ 文件生成校验通过")
    
    print("\n4. 检查工作区未暂存变更...")
    stdout, stderr, rc = run_command("git diff --name-only")
    unstaged_files = [f.strip() for f in stdout.strip().split('\n') if f.strip()]
    if unstaged_files:
        print("   ✗ 工作区存在未暂存的变更:")
        for file in unstaged_files:
            print(f"     - {file}")
        print("   ✗ 请先使用 git add 添加所有变更文件")
        sys.exit(1)
    print("   ✓ 工作区未暂存变更检查通过")
    
    print("\n5. 检查未跟踪文件...")
    stdout, stderr, rc = run_command("git ls-files --others --exclude-standard")
    untracked_files = [f.strip() for f in stdout.strip().split('\n') if f.strip()]
    if untracked_files:
        print("   ✗ 发现未跟踪文件:")
        for file in untracked_files:
            print(f"     - {file}")
        print("   ✗ 请使用 git add 添加或 .gitignore 忽略")
        sys.exit(1)
    print("   ✓ 未跟踪文件检查通过")
    
    print("\n6. 检查暂存区文件...")
    stdout, stderr, rc = run_command("git diff --cached --name-only")
    staged_files = [f.strip() for f in stdout.strip().split('\n') if f.strip()]
    if not staged_files:
        print("   ✗ 暂存区没有文件")
        print("   ✗ 请先使用 git add 添加文件")
        sys.exit(1)
    print("   ✓ 暂存区文件检查通过")
    
    print("\n" + "=" * 70)
    print("  所有校验通过，可以提交!")
    print("=" * 70)
    
    sys.exit(0)

if __name__ == "__main__":
    main()
