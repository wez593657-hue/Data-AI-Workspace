#!/usr/bin/env python3

import tempfile
import os
import subprocess

content = 'fix: 修复钩子路径计算问题'
with tempfile.NamedTemporaryFile(mode='w', encoding='utf-8', delete=False) as f:
    f.write(content)
    temp_file = f.name

try:
    result = subprocess.run(
        ['python', '.git/hooks/commit-msg', temp_file],
        capture_output=True,
        encoding='utf-8',
        errors='replace',
        cwd=os.path.dirname(os.path.dirname(__file__))
    )
    print('STDOUT:', result.stdout)
    print('STDERR:', result.stderr)
    print('Exit code:', result.returncode)
finally:
    os.unlink(temp_file)
