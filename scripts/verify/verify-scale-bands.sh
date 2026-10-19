#!/usr/bin/env bash
# One scale band, stated once.
#
# Regression: the P0 band was written out in 14 places and drifted into four
# different definitions (Small 1-5 vs 3-7; Medium 6-15 vs 8-15). A project with
# 6 P0 features read as Small in docs/README.md and Medium to the classifier,
# and nothing caught it because each file was internally consistent.
#
# This greps every markdown file for "<Scope> ... N-M P0|Must" and fails when a
# scope has more than one band. The canonical bands live in SKILL.md and
# scripts/gates/classify-scale.sh.
set -uo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$REPO" || exit 1

# `[^|]` excluded table rows, which is where the band is most often written, so the
# guard was blind to exactly the place it needed to look. Allow any character.
hits=$(grep -rHoE '(Small|Medium|Solo SaaS|Large|Enterprise)[^0-9]{0,40}[0-9]+[[:space:]]*[–-][[:space:]]*[0-9]+[^0-9]{0,20}?(P0|Must)' \
        --include='*.md' . 2>/dev/null \
    | grep -v '^\./archive/' \
    | sed -E 's/.*:(Small|Medium|Solo SaaS|Large|Enterprise)[^0-9]*([0-9]+)[[:space:]]*[–-][[:space:]]*([0-9]+).*/\1|\2-\3/' \
    | tr '[:upper:]' '[:lower:]' \
    | sort -u)

dupes=$(printf '%s\n' "$hits" | awk -F'|' '{c[$1]++; b[$1]=b[$1]" "$2} END {for (s in c) if (c[s]>1) print s": "b[s]}')

if [ -z "$dupes" ]; then
    echo "✅ Every scope states one P0 band."
    exit 0
fi

echo "❌ A scope is defined with more than one P0 band:"
printf '%s\n' "$dupes" | sed 's/^/  /'
echo ""
echo "Canonical: Small 1-5, Medium/Solo SaaS 6-15, Large 16-25, Enterprise >25."
echo "Fix the outliers; do not change the canonical bands without changing"
echo "scripts/gates/classify-scale.sh and SKILL.md in the same commit."
exit 1
