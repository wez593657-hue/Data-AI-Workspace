import os
import subprocess
import sys
from datetime import datetime

PROJECT_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

BRANCHES = ["feature/ai-repair-loop", "feature/churn-recovery", "feature/maturity-takeover", "feature/hooks-fix", "master"]

EXCLUDE_PATTERNS = [
    ".git/",
    ".harness/",
    "scripts/harness/",
    "__pycache__/",
    ".pytest_cache/",
    ".trae-cn/",
    ".vscode/",
]

def is_excluded(file_path):
    for pattern in EXCLUDE_PATTERNS:
        if file_path.startswith(pattern):
            return True
    return False

def get_git_file_modify_time(branch, file_path):
    try:
        result = subprocess.run(
            ["git", "-C", PROJECT_ROOT, "log", "-1", "--format=%ad", "--", file_path],
            capture_output=True,
            text=True,
            check=True
        )
        date_str = result.stdout.strip()
        if date_str:
            return datetime.strptime(date_str, "%a %b %d %H:%M:%S %Y %z")
    except Exception:
        pass
    return None

def get_file_content_from_branch(branch, file_path):
    try:
        result = subprocess.run(
            ["git", "-C", PROJECT_ROOT, "show", f"{branch}:{file_path}"],
            capture_output=True,
            text=False,
            check=True
        )
        return result.stdout
    except Exception:
        return None

def get_all_files_from_branch(branch):
    files = set()
    try:
        result = subprocess.run(
            ["git", "-C", PROJECT_ROOT, "ls-tree", "-r", branch, "--name-only"],
            capture_output=True,
            text=True,
            check=True
        )
        for line in result.stdout.split("\n"):
            line = line.strip()
            if line and not is_excluded(line):
                files.add(line)
    except Exception as e:
        print(f"Error getting files from branch {branch}: {e}")
    return files

def main():
    auto_confirm = "--auto" in sys.argv or "--yes" in sys.argv
    preview_only = "--preview-only" in sys.argv
    
    print("=" * 80)
    print("合并所有分支的项目内容")
    print("=" * 80)

    all_files = set()
    for branch in BRANCHES:
        print(f"\n获取分支 {branch} 的文件列表...")
        files = get_all_files_from_branch(branch)
        all_files.update(files)
        print(f"  发现 {len(files)} 个文件")

    print(f"\n总计发现 {len(all_files)} 个唯一文件")

    file_info_list = []
    
    for file_path in sorted(all_files):
        branch_info = []
        latest_time = None
        latest_branch = None
        latest_content = None

        for branch in BRANCHES:
            content = get_file_content_from_branch(branch, file_path)
            if content is not None:
                modify_time = get_git_file_modify_time(branch, file_path)
                if modify_time is None:
                    modify_time = datetime.min
                
                branch_info.append({
                    "branch": branch,
                    "modify_time": modify_time,
                    "has_content": True
                })

                if latest_time is None or modify_time > latest_time:
                    latest_time = modify_time
                    latest_branch = branch
                    latest_content = content

        if latest_content is None:
            continue

        local_path = os.path.join(PROJECT_ROOT, file_path)
        exists_locally = os.path.exists(local_path)
        
        file_info = {
            "file_path": file_path,
            "branch_info": branch_info,
            "latest_branch": latest_branch,
            "latest_time": latest_time,
            "exists_locally": exists_locally,
            "latest_content": latest_content
        }
        file_info_list.append(file_info)

    print("\n" + "=" * 80)
    print("文件差异预览 (相同文件在不同分支的信息)")
    print("=" * 80)

    conflict_files = []
    for info in file_info_list:
        if len(info["branch_info"]) > 1:
            conflict_files.append(info)

    if conflict_files:
        print(f"\n发现 {len(conflict_files)} 个文件在多个分支中存在差异:")
        print("\n" + "-" * 80)
        
        for i, info in enumerate(conflict_files, 1):
            print(f"\n[{i}] 文件: {info['file_path']}")
            print(f"  本地存在: {'是' if info['exists_locally'] else '否'}")
            print(f"  最新版本: {info['latest_branch']} ({info['latest_time'].strftime('%Y-%m-%d %H:%M:%S')})")
            print(f"  各分支版本:")
            for branch_info in info["branch_info"]:
                time_str = branch_info["modify_time"].strftime('%Y-%m-%d %H:%M:%S') if branch_info["modify_time"] else "未知"
                is_latest = " [最新]" if branch_info["branch"] == info["latest_branch"] else ""
                print(f"    - {branch_info['branch']}: {time_str}{is_latest}")
        
        print("\n" + "-" * 80)
    else:
        print("\n所有文件仅在单个分支中存在，无需冲突处理")

    single_branch_files = [info for info in file_info_list if len(info["branch_info"]) == 1]
    if single_branch_files:
        print(f"\n仅在单个分支中存在的文件: {len(single_branch_files)} 个")

    if preview_only:
        print("\n预览模式，不执行合并")
        sys.exit(0)

    print("\n" + "=" * 80)
    if auto_confirm:
        print("自动确认合并")
        confirm = 'y'
    else:
        confirm = input("确认合并以上文件? (y/n): ")
    print("=" * 80)

    if confirm.lower() != 'y':
        print("用户取消合并")
        sys.exit(0)

    print("\n开始合并...")

    merged_count = 0
    skipped_count = 0
    updated_count = 0
    created_count = 0

    for info in file_info_list:
        file_path = info["file_path"]
        latest_branch = info["latest_branch"]
        latest_content = info["latest_content"]
        
        if latest_content is None:
            skipped_count += 1
            continue

        local_path = os.path.join(PROJECT_ROOT, file_path)
        local_dir = os.path.dirname(local_path)

        if not os.path.exists(local_dir):
            os.makedirs(local_dir, exist_ok=True)

        needs_update = False
        if os.path.exists(local_path):
            with open(local_path, "rb") as f:
                existing_content = f.read()
            if existing_content != latest_content:
                needs_update = True
                updated_count += 1
            else:
                skipped_count += 1
        else:
            needs_update = True
            created_count += 1

        if needs_update:
            try:
                with open(local_path, "wb") as f:
                    f.write(latest_content)
                print(f"  更新: {file_path} (来自 {latest_branch})")
                merged_count += 1
            except Exception as e:
                print(f"  错误写入 {file_path}: {e}")

    print("\n" + "=" * 80)
    print(f"合并完成!")
    print(f"  合并文件: {merged_count}")
    print(f"  创建新文件: {created_count}")
    print(f"  更新现有文件: {updated_count}")
    print(f"  跳过(无变化): {skipped_count}")
    print("=" * 80)

if __name__ == "__main__":
    main()