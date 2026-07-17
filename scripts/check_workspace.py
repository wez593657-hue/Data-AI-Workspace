#!/usr/bin/env python3

import subprocess
import sys

# 修复 Windows GBK 控制台 Unicode 编码问题
import sys as _sys
if hasattr(_sys.stdout, 'reconfigure'):
    _sys.stdout.reconfigure(encoding='utf-8', errors='replace')
if hasattr(_sys.stderr, 'reconfigure'):
    _sys.stderr.reconfigure(encoding='utf-8', errors='replace')

def run_command(cmd):
    result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
    return result.stdout.strip(), result.stderr.strip(), result.returncode

def main():
    print("=" * 70)
    print("  工作区检查脚本")
    print("=" * 70)
    
    print("\n1. 检查工作区状态...")
    stdout, stderr, rc = run_command("git status --porcelain")
    if rc != 0:
        print("   ✗ Git命令执行失败")
        print(f"   错误: {stderr}")
        sys.exit(1)
    
    if not stdout:
        print("   ✓ 工作区干净，无未提交的变更")
        sys.exit(0)
    
    print("   ✗ 发现未提交的变更:")
    print("   " + "-" * 60)
    for line in stdout.split('\n'):
        status = line[:2]
        file_path = line[3:]
        if status.startswith('M'):
            print(f"   修改: {file_path}")
        elif status.startswith('A'):
            print(f"   新增: {file_path}")
        elif status.startswith('D'):
            print(f"   删除: {file_path}")
        elif status.startswith('R'):
            print(f"   重命名: {file_path}")
        else:
            print(f"   其他: {file_path}")
    print("   " + "-" * 60)
    
    print("\n2. 检查暂存区状态...")
    stdout, stderr, rc = run_command("git diff --cached --name-only")
    if rc != 0:
        print("   ✗ Git命令执行失败")
        sys.exit(1)
    
    if stdout:
        print("   ✗ 暂存区有未提交的文件:")
        for line in stdout.split('\n'):
            print(f"     - {line}")
    else:
        print("   ✓ 暂存区为空")
    
    print("\n3. 检查未跟踪文件...")
    stdout, stderr, rc = run_command("git ls-files --others --exclude-standard")
    if rc != 0:
        print("   ✗ Git命令执行失败")
        sys.exit(1)
    
    if stdout:
        print("   ✗ 发现未跟踪文件:")
        for line in stdout.split('\n'):
            if line.strip():
                print(f"     - {line.strip()}")
    else:
        print("   ✓ 无未跟踪文件")
    
    print("\n" + "=" * 70)
    print("  警告: 工作区存在未提交的变更!")
    print("  请执行以下操作:")
    print("    1. git add <file>    - 添加文件到暂存区")
    print("    2. git commit -m \"xxx\" - 提交变更")
    print("    3. git push origin <branch> - 推送到远程")
    print("=" * 70)
    
    sys.exit(1)

if __name__ == "__main__":
    main()
