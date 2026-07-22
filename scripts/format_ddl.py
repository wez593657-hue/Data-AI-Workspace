import os
import re

def format_ddl_file(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    
    start_idx = content.find('CREATE TABLE')
    if start_idx == -1:
        return False
    
    left_paren = content.find('(', start_idx)
    if left_paren == -1:
        return False
    
    right_paren = content.find(');', left_paren)
    if right_paren == -1:
        return False
    
    prefix = content[start_idx:left_paren].strip()
    body = content[left_paren+1:right_paren].strip()
    
    fields = []
    for part in body.split(','):
        part = part.strip()
        if part:
            fields.append(part)
    
    formatted = prefix + ' (\n    ' + ',\n    '.join(fields) + '\n);'
    new_content = content[:start_idx] + formatted + content[right_paren+2:]
    
    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(new_content)
    
    return True

def main():
    ddl_dir = os.path.join(os.path.dirname(os.path.dirname(__file__)), 'data_assets', 'ddl')
    
    count = 0
    for root, dirs, files in os.walk(ddl_dir):
        for file in files:
            if file.endswith('.sql'):
                filepath = os.path.join(root, file)
                if format_ddl_file(filepath):
                    count += 1
    
    print(f'格式化完成，共处理 {count} 个文件')

if __name__ == '__main__':
    main()
