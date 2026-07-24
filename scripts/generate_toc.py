"""为大需求文档自动生成目录索引，减少AI全量读取的token浪费。"""
import re
import sys
import os

def extract_sections(filepath):
    """从需求文档提取疑似章节标题的短行"""
    sections = []
    with open(filepath, 'r', encoding='utf-8') as f:
        lines = f.readlines()
    
    for i, line in enumerate(lines):
        stripped = line.strip()
        # 跳过空行、已含#的markdown标题行、过长的行
        if not stripped or stripped.startswith('#') or len(stripped) > 30:
            continue
        # 跳过编号列表行、含标点的描述性行
        if re.match(r'^\d+[\.\、）)]', stripped):
            continue
        # 只保留疑似章节标题（不含句号、逗号等）
        if re.match(r'^[\u4e00-\u9fa5\w\-\s]+$', stripped):
            sections.append((i + 1, stripped))
    
    return sections

def generate_toc(sections):
    """生成目录markdown"""
    lines = ['## 目录索引\n']
    lines.append('| 章节 | 行号 |')
    lines.append('|------|------|')
    for lineno, title in sections:
        lines.append(f'| [{title}](#L{lineno}) | L{lineno} |')
    lines.append('')
    return '\n'.join(lines)

def insert_toc(filepath):
    """在文档顶部插入TOC"""
    sections = extract_sections(filepath)
    if len(sections) < 5:
        print(f"  跳过 {filepath}: 章节太少({len(sections)})")
        return False
    
    toc = generate_toc(sections)
    
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # 检查是否已有TOC
    if '## 目录索引' in content:
        print(f"  跳过 {filepath}: 已有TOC")
        return False
    
    # 在第一行标题后插入
    lines = content.split('\n')
    # 找到第一个 # 标题行
    insert_pos = 0
    for i, line in enumerate(lines):
        if line.startswith('# ') and not line.startswith('## '):
            insert_pos = i + 1
            break
    
    new_lines = lines[:insert_pos] + ['', toc] + lines[insert_pos:]
    new_content = '\n'.join(new_lines)
    
    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(new_content)
    
    print(f"  已添加TOC: {filepath} ({len(sections)}个章节)")
    return True

def main():
    target_dir = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), 'requirements')
    
    # 目标：大于30KB的需求文档
    targets = []
    for fname in os.listdir(target_dir):
        if fname.endswith('.md'):
            fpath = os.path.join(target_dir, fname)
            size_kb = os.path.getsize(fpath) / 1024
            if size_kb > 30:
                targets.append((fpath, size_kb, fname))
    
    targets.sort(key=lambda x: x[1], reverse=True)
    
    print(f"为 {len(targets)} 个大需求文档添加目录索引:\n")
    for fpath, size_kb, fname in targets:
        print(f"  {fname} ({size_kb:.1f}KB)")
    
    print()
    count = 0
    for fpath, size_kb, fname in targets:
        if insert_toc(fpath):
            count += 1
    
    print(f"\n完成: 为 {count} 个文档添加了目录索引")

if __name__ == '__main__':
    main()