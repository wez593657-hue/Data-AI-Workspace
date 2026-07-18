#!/usr/bin/env python3
import subprocess
import sys
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

def check(message, expected):
    with tempfile.NamedTemporaryFile(mode='w', encoding='utf-8', delete=False) as file:
        file.write(message)
        path = file.name
    try:
        result = subprocess.run([sys.executable, str(ROOT / '.git' / 'hooks' / 'commit-msg'), path], cwd=ROOT)
        return result.returncode == expected
    finally:
        Path(path).unlink(missing_ok=True)

if not check('fix(hooks): validate commit message', 0) or not check('invalid message', 1):
    sys.exit(1)
print('hooks test passed')
