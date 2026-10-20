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
    # Windows Git emits CRLF, so "$f" can carry a trailing CR. The linter then reads a
    # path that does not exist and reports PASSED on empty input — which is why
    # UU_PDP_COMPLIANCE.md failed standalone but passed inside this sweep.
    f="${f%$'\r'}"
    total=$((total + 1))
    # Use the linter's EXIT CODE, not a message substring. A missing file prints
    # "File not found" (no "FAILED"), so a message grep counted it as a pass.
    if ! bash scripts/verify/lint-template.sh "$f" >/dev/null 2>&1; then
        failed_list="$failed_list $f"
        fails=$((fails + 1))
    fi
# 'patterns/*.md' matched ZERO files (patterns live in subdirectories), so every file
# under patterns/ was silently unswept while the summary still reported a pass. Use
# recursive globs and assert a floor so an empty selector can never look like success.
done < <(git ls-files 'templates/*.md' 'patterns/**/*.md' 2>/dev/null)

if [ "$total" -lt 250 ]; then
    echo "❌ sweep selected only $total files — the selector matched almost nothing."
    echo "   Refusing to report a pass from an empty file list."
    exit 1
fi

# Two files legitimately contain bracketed text that is NOT an unfilled placeholder:
#   - UU PDP: a model breach-notification with [Nama PT] etc. as illustrative format
#   - payment gateways: ASCII sequence diagrams whose nodes read [Your Backend]
# An allowlist is honest; loosening the linter would hide real placeholders elsewhere.
ALLOW='patterns/compliance/UU_PDP_COMPLIANCE.md patterns/payments/INDONESIA_PAYMENT_GATEWAYS.md'

real_fails=0
real_list=""
for f in $failed_list; do
    allowed=0
    for a in $ALLOW; do [ "$f" = "$a" ] && allowed=1; done
    if [ "$allowed" -eq 0 ]; then
        real_list="$real_list $f"; real_fails=$((real_fails + 1))
    fi
done

if [ "$real_fails" -eq 0 ]; then
    echo "✅ $total files linted; $fails known-benign (allowlist: $(echo $ALLOW | wc -w) file(s)), 0 real failures."
    exit 0
fi
fails=$real_fails
failed_list="$real_list"

if [ "$fails" -eq 0 ]; then
    echo "✅ $total templates/patterns pass the placeholder and structure linter."
    exit 0
fi

echo "❌ $fails of $total files failed lint:"
for f in $failed_list; do echo "  $f"; done
echo ""
echo "Run: bash scripts/verify/lint-template.sh <file> to see the reason."
exit 1
