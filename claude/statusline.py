#!/usr/bin/env python3
"""Claude Code status line script.
Displays: cwd | git branch | model | context usage
"""
import sys
import json
import subprocess
import os

def get_git_branch():
    try:
        result = subprocess.run(
            ['git', 'rev-parse', '--abbrev-ref', 'HEAD'],
            capture_output=True, text=True, timeout=2
        )
        if result.returncode == 0:
            return result.stdout.strip()
    except:
        pass
    return None

def main():
    try:
        data = json.load(sys.stdin)
        parts = []

        cwd = data.get('cwd')
        if isinstance(cwd, dict):
            cwd = cwd.get('path', '')
        if cwd:
            home = os.path.expanduser('~')
            if cwd.startswith(home):
                cwd = '~' + cwd[len(home):]
            parts.append(cwd)

        branch = get_git_branch()
        if branch:
            parts.append(f"git:{branch}")

        model = data.get('model')
        if isinstance(model, dict):
            model = model.get('name', '') or model.get('id', '')
        if isinstance(model, str) and model:
            short_model = model.replace('claude-', '').replace('-20251101', '')
            parts.append(short_model)

        context = data.get('context', {})
        if isinstance(context, dict):
            used = context.get('used', 0) or context.get('tokens_used', 0)
            total = context.get('total', 0) or context.get('tokens_total', 0)
            if total > 0:
                pct = int((used / total) * 100)
                parts.append(f"ctx:{pct}%")

        print(' | '.join(parts))
    except Exception as e:
        print(f"err: {e}")

if __name__ == '__main__':
    main()
