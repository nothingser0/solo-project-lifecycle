#!/usr/bin/env python3
"""Replace a clause body with a one-liner, anchoring on the roman-numbered heading.

The fixture's regex required an optional run of # and stars directly before the clause name, but the
heading is "### II.7. Limitation of Liability", so it never matched and the "thin clause" scenario
was really testing the full contract.
"""
import io
import re
import sys

path = sys.argv[1]
s = io.open(path, encoding="utf-8").read()

pattern = re.compile(
    r"(?ms)^(###[^\n]*Limitation of Liability[^\n]*\n)(.*?)(?=^#{2,4} )"
)
new, n = pattern.subn(r"\1\nCapped at fees paid.\n\n", s, count=1)
if n == 0:
    raise SystemExit("Limitation of Liability heading not found - cannot build the thin clause case")
io.open(path, "w", encoding="utf-8").write(new)
print("Limitation of Liability body replaced with a one-liner")
