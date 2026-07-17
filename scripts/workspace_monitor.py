#!/usr/bin/env python3

import subprocess
import sys
import os

def run_command(cmd):
    result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
    return result.stdout.strip(), result.stderr.strip(), result.returncode

def check_workspace():
    print("=" * 70)
    print("  工作区监控 - 定时检查")
    print("=" * 70)
    
    print("\n1. 检查工作区状态...")
    stdout, stderr, rc = run_command("git status --porcelain")
    if rc != 0:
        print("   ✗ Git命令执行失败")
        return False
    
    if not stdout:
        print("   ✓ 工作区干净")
        return True
    
    print("   ✗ 发现未提交的变更:")
    changes = []
    for line in stdout.split('\n'):
        if line.strip():
            status = line[:2]
            file_path = line[3:]
            if status.startswith('M'):
                changes.append(f"修改: {file_path}")
            elif status.startswith('A'):
                changes.append(f"新增: {file_path}")
            elif status.startswith('D'):
                changes.append(f"删除: {file_path}")
            elif status.startswith('R'):
                changes.append(f"重命名: {file_path}")
            else:
                changes.append(f"其他: {file_path}")
    
    for change in changes:
        print(f"     {change}")
    
    print("\n" + "=" * 70)
    print("  警告: 工作区存在未提交的变更!")
    print("  请及时提交代码，避免绕过审查流程")
    print("=" * 70)
    
    return False

def main():
    if not check_workspace():
        sys.exit(1)
    sys.exit(0)

if __name__ == "__main__":
    main()
