#!/usr/bin/env python3

import sys
import os
import argparse

from utils import fix_windows_encoding, safe_print, run_command, get_staged_files

fix_windows_encoding()

def check_python():
    safe_print("\n1. 检查Python环境...")
    if sys.executable:
        safe_print("   ✓ Python已安装")
        return True
    else:
        safe_print("   ✗ Python未安装")
        return False

def check_staged_files():
    safe_print("\n2. 检查暂存区文件...")
    staged_files = get_staged_files()
    if not staged_files:
        safe_print("   ✗ 暂存区没有文件")
        safe_print("   ✗ 请先使用 git add 添加文件")
        return False
    safe_print("   ✓ 暂存区文件检查通过")
    return True

def run_workspace_validation(quick_mode=False):
    safe_print("\n3. 执行工作区完整校验...")
    
    cmd = f"python scripts/workspace_validation.py {'quick' if quick_mode else 'full'}"
    stdout, stderr, rc = run_command(cmd)
    
    if stdout:
        safe_print(stdout)
    
    if rc != 0:
        safe_print("   ✗ 工作区校验失败")
        safe_print("   ✗ 请修复校验错误后重新提交")
        safe_print("   ✗ 或运行: python scripts/ai_repair_loop.py 自动修复")
        return False
    safe_print("   ✓ 工作区校验通过")
    return True

def main():
    parser = argparse.ArgumentParser(description='Git Pre-Commit Hook')
    parser.add_argument('--mode', choices=['quick', 'full'], default='full',
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

    if args.mode == 'full':
        if not run_workspace_validation(False):
            sys.exit(1)
    else:
        if not run_workspace_validation(True):
            sys.exit(1)
    
    safe_print("\n" + "=" * 70)
    safe_print("  所有校验通过，可以提交!")
    safe_print("=" * 70)
    
    sys.exit(0)

if __name__ == "__main__":
    main()
