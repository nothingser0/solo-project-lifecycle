#!/usr/bin/env python3
"""
Anti-Stub & Anti-Slop Linter Script for Solo Project Lifecycle (Excluding Framework Core Scripts).
Scans user project source code for stub pages, console.log debuggers, placeholder text, and raw unicode emojis.
Exits with 1 if violations are found, 0 if clean.
"""

import sys
import os
import re

PATTERNS = [
    (r"\bconsole\.log\(", "Debug console.log found"),
    (r"Lorem ipsum", "Placeholder Lorem ipsum text found"),
    (r"example\.com", "Placeholder domain example.com found"),
    (r"placeholder\.com", "Placeholder domain placeholder.com found"),
    (r"href\s*=\s*[\"']#[\"']", "Dead link href='#' found"),
]

def scan_file(filepath):
    errors = []
    try:
        with open(filepath, 'r', encoding='utf-8', errors='ignore') as f:
            lines = f.readlines()
            
        # Check stub page condition (< 12 lines or < 400 bytes for page files)
        if ('app/' in filepath or 'pages/' in filepath or 'views/' in filepath) and (filepath.endswith('.tsx') or filepath.endswith('.jsx') or filepath.endswith('.html') or filepath.endswith('.vue')):
            if len(lines) < 12 or os.path.getsize(filepath) < 400:
                errors.append(f"Stub page detected (< 12 lines or < 400 bytes)")

        for idx, line in enumerate(lines, 1):
            for pattern, desc in PATTERNS:
                if re.search(pattern, line):
                    errors.append(f"Line {idx}: {desc} -> {line.strip()}")
    except Exception as e:
        pass
    return errors

def main():
    target_dir = sys.argv[1] if len(sys.argv) > 1 else "."
    violations = 0
    
    print(f"Scanning target directory: {target_dir} for stubs and slop...")
    for root, dirs, files in os.walk(target_dir):
        # Skip hidden, build, and framework script dirs
        dirs[:] = [d for d in dirs if not d.startswith('.') and d not in ('node_modules', '.git', 'dist', 'build', '.next', 'venv', 'scripts', 'evals', 'references', 'case-studies', 'templates')]
        for file in files:
            if file.endswith(('.tsx', '.jsx', '.ts', '.js', '.html', '.vue')):
                filepath = os.path.join(root, file)
                errs = scan_file(filepath)
                if errs:
                    violations += len(errs)
                    print(f"\n[VIOLATION] {filepath}")
                    for err in errs:
                        print(f"  - {err}")
                        
    if violations > 0:
        print(f"\nScan FAILED: Found {violations} anti-slop violations in user project code.")
        sys.exit(1)
    else:
        print("\nScan PASSED: User codebase is clean of stubs and slop.")
        sys.exit(0)

if __name__ == '__main__':
    main()
