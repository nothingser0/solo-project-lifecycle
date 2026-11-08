#!/usr/bin/env python3
"""Put an unbounded promise into the real liability clause of a SOW fixture.

mode: liability | support | bugfree
"""
import io
import re
import sys

path, mode = sys.argv[1], sys.argv[2]

PROMISES = {
    "liability": (
        "The Developer accepts unlimited liability for any and all damages of any kind, "
        "with no limit whatsoever, in perpetuity."
    ),
    "support": (
        "The Developer provides unlimited lifetime support and free maintenance for as long as "
        "the Client uses the system."
    ),
    "bugfree": (
        "The software is guaranteed to be completely bug-free and will work perfectly forever."
    ),
}

s = io.open(path, encoding="utf-8").read()

if mode == "bugfree":
    s, n = re.subn(
        r"(?m)^1\. The Developer provides a bug fixing warranty.*$",
        "1. " + PROMISES["bugfree"],
        s,
        count=1,
    )
    if n == 0:
        raise SystemExit("warranty clause line not found")
else:
    lines = s.split("\n")
    target = None
    for i, ln in enumerate(lines):
        if "maximum total legal liability" in ln.lower() or "aggregate liability" in ln.lower():
            target = i
            break
    if target is None:
        raise SystemExit("liability clause line not found")
    lines[target] = PROMISES[mode]
    s = "\n".join(lines)

io.open(path, "w", encoding="utf-8").write(s)
print(f"injected {mode} promise")
