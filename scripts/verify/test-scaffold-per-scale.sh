#!/usr/bin/env bash
# Per-scale scaffold placement.
#
# Why a bash test and not the Node parity guard: Node and MSYS bash disagree about
# what "/tmp" means, and bash cannot read a "C:\..." path at all, so a Node-driven
# per-scale test fails for environmental reasons on Windows. Here the shell owns
# every path, which is the only spelling that works everywhere.
#
# Why it exists: the parity guard compares the SET of template references across the
# whole file, so it cannot see a branch that is missing a file another branch has.
# That is exactly how the nine-file harness gap and the A03/A04 gap survived.
set -uo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
SCAFFOLD="$REPO/scripts/scaffold/init-project.sh"
PASS=0
FAIL=0

# Small deliberately skips the nine-file harness (SKILL.md). Every other scale = 9.
declare -A EXPECTED=( [small]=2 [medium]=9 [large]=9 [enterprise]=9 )

note() { printf '  %s %s\n' "$1" "$2"; }

for scale in small medium large enterprise; do
    dir="$(mktemp -d)" || { note "❌" "$scale: mktemp failed"; FAIL=$((FAIL + 1)); continue; }
    want="${EXPECTED[$scale]}"

    if ! ( cd "$REPO" && bash "$SCAFFOLD" "$dir" "$scale" >/dev/null 2>&1 ); then
        note "❌" "$scale: scaffold exited non-zero"
        FAIL=$((FAIL + 1))
        rm -rf "$dir"
        continue
    fi

    harness="$dir/docs/harness-root"
    if [ -d "$harness" ]; then
        got=$(ls -A "$harness" | wc -l | tr -d ' ')
    else
        got=0
    fi

    if [ "$got" -eq "$want" ]; then
        note "✓" "$scale: $got/$want harness files"
        PASS=$((PASS + 1))
    else
        note "❌" "$scale: $got/$want harness files"
        [ -d "$harness" ] && ls -A "$harness" | sed 's/^/       /'
        FAIL=$((FAIL + 1))
    fi
    rm -rf "$dir"
done

# A03/A04 artifacts: the gates require them and no template produced them until late.
dir="$(mktemp -d)"
if ( cd "$REPO" && bash "$SCAFFOLD" "$dir" enterprise >/dev/null 2>&1 ); then
    missing=""
    for f in docs/procurement/VENDOR_PROCUREMENT_SCHEDULE.md \
             docs/governance/GOVERNANCE_HANDOVER_PACK.md \
             docs/security/THREAT_MODEL_STRIDE.md \
             docs/architecture/ENTERPRISE_ARCHITECTURE_BLUEPRINT.md \
             docs/pm/INCIDENT_RESPONSE.md; do
        [ -f "$dir/$f" ] || missing="$missing $f"
    done
    if [ -z "$missing" ]; then
        note "✓" "enterprise: A02-A04 artifacts staged"
        PASS=$((PASS + 1))
    else
        note "❌" "enterprise: missing artifacts:$missing"
        FAIL=$((FAIL + 1))
    fi
else
    note "❌" "enterprise: scaffold exited non-zero"
    FAIL=$((FAIL + 1))
fi
rm -rf "$dir"

echo ""
if [ "$FAIL" -eq 0 ]; then
    echo "All $PASS per-scale scaffold checks passed."
    exit 0
fi
echo "$FAIL of $((PASS + FAIL)) per-scale scaffold checks FAILED."
exit 1
