#!/usr/bin/env python3
"""check-evidence.py - Kebab-case compatibility wrapper for check_evidence.py."""
import sys
from pathlib import Path

target = Path(__file__).resolve().parent / "check_evidence.py"
if not target.exists():
    sys.exit(f"Target script not found: {target}")

with open(target, "r", encoding="utf-8") as f:
    code = compile(f.read(), str(target), "exec")
    sys.argv[0] = str(target)
    exec(code, {"__name__": "__main__"})
