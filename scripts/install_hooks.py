#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import shutil
import sys

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
HOOKS_DIR = os.path.join(BASE_DIR, 'hooks')
GIT_HOOKS_DIR = os.path.join(BASE_DIR, '.git', 'hooks')

HOOK_FILES = ['pre-commit', 'pre-push', 'prepare-commit-msg']

def main():
    print("=" * 60)
    print("  Git Hooks 安装脚本")
    print("=" * 60)
    
    if not os.path.exists(HOOKS_DIR):
        print(f"  ✗ 钩子源目录不存在: {HOOKS_DIR}")
        sys.exit(1)
    
    if not os.path.exists(GIT_HOOKS_DIR):
        print(f"  ✗ Git钩子目录不存在: {GIT_HOOKS_DIR}")
        print("  ✗ 请先初始化Git仓库")
        sys.exit(1)
    
    installed_count = 0
    for hook_name in HOOK_FILES:
        src_path = os.path.join(HOOKS_DIR, hook_name)
        dst_path = os.path.join(GIT_HOOKS_DIR, hook_name)
        
        if not os.path.exists(src_path):
            print(f"  ⚠ 钩子文件不存在: {hook_name}")
            continue
        
        try:
            shutil.copy2(src_path, dst_path)
            
            os.chmod(dst_path, 0o755)
            
            print(f"  ✓ 安装成功: {hook_name}")
            installed_count += 1
        except Exception as e:
            print(f"  ✗ 安装失败: {hook_name} - {str(e)}")
    
    print("\n" + "=" * 60)
    print(f"  安装完成! 共安装 {installed_count} 个钩子")
    print("=" * 60)
    
    sys.exit(0)

if __name__ == "__main__":
    main()