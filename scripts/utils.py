#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import subprocess
import sys
import os

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

def fix_windows_encoding():
    if hasattr(sys.stdout, 'reconfigure'):
        sys.stdout.reconfigure(encoding='utf-8', errors='replace')
    if hasattr(sys.stderr, 'reconfigure'):
        sys.stderr.reconfigure(encoding='utf-8', errors='replace')

def safe_print(*args, **kwargs):
    try:
        print(*args, **kwargs)
    except UnicodeEncodeError:
        text = ' '.join(str(arg) for arg in args)
        text = text.replace('✓', '[OK]').replace('✗', '[FAIL]').replace('⚠', '[WARN]')
        print(text, **kwargs)

def run_command(cmd, cwd=None):
    if cwd is None:
        cwd = BASE_DIR
    if isinstance(cmd, list):
        result = subprocess.run(cmd, capture_output=True, cwd=cwd, encoding='utf-8', errors='replace')
    else:
        result = subprocess.run(cmd, shell=True, capture_output=True, cwd=cwd, encoding='utf-8', errors='replace')
    return result.stdout, result.stderr, result.returncode

def get_staged_files():
    stdout, stderr, rc = run_command("git diff --cached --name-only")
    if not stdout:
        return []
    return [f.strip() for f in stdout.strip().split('\n') if f.strip()]

def get_changed_files():
    stdout1, stderr1, rc1 = run_command("git diff --cached --name-only")
    stdout2, stderr2, rc2 = run_command("git diff --name-only")
    changed1 = [f.strip() for f in stdout1.strip().split('\n') if f.strip()] if stdout1 else []
    changed2 = [f.strip() for f in stdout2.strip().split('\n') if f.strip()] if stdout2 else []
    return list(set(changed1 + changed2))

def is_in_whitelist(filepath, patterns=None):
    if patterns is None:
        patterns = [
            'docs/',
            'README.md',
            '.git/',
            '.github/',
            'scripts/',
            '.vscode/',
            '.gitignore',
            'CONTRIBUTING.md'
        ]
    for pattern in patterns:
        if filepath.startswith(pattern) or filepath == pattern.rstrip('/'):
            return True
    return False
