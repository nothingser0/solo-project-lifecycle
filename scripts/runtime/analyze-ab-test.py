#!/usr/bin/env python3
"""analyze-ab-test.py - Kebab-case compatibility wrapper for analyze_ab_test.py."""
import sys
from pathlib import Path

target = Path(__file__).resolve().parent / "analyze_ab_test.py"
if not target.exists():
    sys.exit(f"Target script not found: {target}")

with open(target, "r", encoding="utf-8") as f:
    code = compile(f.read(), str(target), "exec")
    sys.argv[0] = str(target)
    exec(code, {"__name__": "__main__"})
