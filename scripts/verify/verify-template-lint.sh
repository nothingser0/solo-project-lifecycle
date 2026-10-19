#!/usr/bin/env bash
# Lint every shipped template.
#
# `lint-template.sh` was only ever run by hand on the files an edit touched, so a
# template could ship with an unfilled placeholder or a malformed section and CI
# would still be green — which is the defect class fixed eight times this session.
# This runs the linter across all of them.
set -uo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$REPO" || exit 1

total=0
fails=0
failed_list=""
while IFS= read -r f; do
    total=$((total + 1))
    if bash scripts/verify/lint-template.sh "$f" 2>&1 | grep -q "FAILED"; then
        failed_list="$failed_list $f"
        fails=$((fails + 1))
    fi
done < <(git ls-files 'templates/*.md' 'patterns/*.md' 2>/dev/null)

if [ "$fails" -eq 0 ]; then
    echo "✅ $total templates/patterns pass the placeholder and structure linter."
    exit 0
fi

echo "❌ $fails of $total files failed lint:"
for f in $failed_list; do echo "  $f"; done
echo ""
echo "Run: bash scripts/verify/lint-template.sh <file> to see the reason."
exit 1
