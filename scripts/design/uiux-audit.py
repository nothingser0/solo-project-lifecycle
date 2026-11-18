#!/usr/bin/env python3
"""uiux-audit.py - Kebab-case compatibility wrapper for uiux_audit.py."""
import sys
from pathlib import Path

target = Path(__file__).resolve().parent / "uiux_audit.py"
if not target.exists():
    sys.exit(f"Target script not found: {target}")

# Execute uiux_audit.py with the same arguments
with open(target, "r", encoding="utf-8") as f:
    code = compile(f.read(), str(target), "exec")
    sys.argv[0] = str(target)
    exec(code, {"__name__": "__main__"})
