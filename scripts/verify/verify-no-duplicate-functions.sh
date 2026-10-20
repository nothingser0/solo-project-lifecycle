#!/usr/bin/env bash
# Duplicate top-level function definitions.
#
# Regression: `checks.sh` carried TWO `check_handoff_strategy` definitions. Bash uses
# the LAST one, so every fix applied to the first was dead code while the suite kept
# reporting the old behaviour. Nothing caught it: `bash -n` accepts redefinition,
# `set -u` does not complain, and the tests exercised the shadowing copy.
#
# This greps every sourced gate file for `name() {` at column 0 and fails on repeats.
set -uo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
FAIL=0

# Output is "file:NAME()" -> keep only NAME, then count repeats.
hits=$(grep -hoE '^[a-zA-Z_][a-zA-Z0-9_]*\(\)' \
        "$REPO"/scripts/gates/lib/checks.sh \
        "$REPO"/scripts/gates/modules/*.sh 2>/dev/null \
    | sort | uniq -c | awk '$1 > 1')

if [ -z "$hits" ]; then
    echo "✅ No duplicate top-level function definitions in gate files."
    exit 0
fi

echo "❌ Duplicate function definitions (bash silently keeps the LAST one):"
while read -r count name; do
    echo "  $name  (defined $count times)"
    grep -HnF "$name" "$REPO"/scripts/gates/lib/checks.sh "$REPO"/scripts/gates/modules/*.sh 2>/dev/null \
        | grep -E ":[0-9]+:${name}" | sed "s|$REPO/||; s/^/       /"
done <<< "$hits"
FAIL=1

if [ "$FAIL" -ne 0 ]; then
    echo ""
    echo "A redefined function makes every edit to the earlier copy dead code."
    exit 1
fi
