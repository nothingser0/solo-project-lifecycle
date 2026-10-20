#!/usr/bin/env bash
# validate-gate.sh - Gate checkpoint validation for solo-project-lifecycle
# Usage: ./scripts/gates/validate-gate.sh <MODULE_ID>
#
# Thin dispatcher. The gate bodies live in scripts/gates/modules/<GATE>.sh and the
# shared helpers in scripts/gates/lib/checks.sh. Each gate used to sit in one
# 92KB / 1670-line case statement, which made single-gate logic hard to read and
# easy to misplace (two real bugs came from exactly that: the intake check nested
# inside a scale-waiver branch, and the M05 stack lock nested inside the FSD branch).
#
# Behaviour is guarded by scripts/verify/test-gate-output.sh, which diffs every
# gate's output byte-for-byte against captured golden files.

set -e

# F1: resolve the script's own directory so self-references (e.g. classify-scale.sh)
# work from ANY cwd, including a scaffolded project dir that has no scripts/ subtree.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="$SCRIPT_DIR/lib"
MODULES_DIR="$SCRIPT_DIR/modules"

# --- argument handling (before sourcing, so --help stays cheap) -----------------
GATE_MODULE="${1:-}"
GATE_FAILED=0
# Modules may downgrade a failure to a non-terminal verdict (M00 RETEST band:
# evidence is real but insufficient to close the gate; M01 PROVISIONAL_PENDING_M00:
# scoring is real but M00 primary research is missing, so no final GO may be
# declared). check_scale_feasibility sets CAPACITY_OVERRIDE when a capacity-only
# Large scope was accepted in writing: the artefacts may pass, but the verdict
# must never read as a clean green. The dispatcher owns the exit code so callers
# only read one convention: 0 passed - 1 failed - 3 RETEST - 4 PROVISIONAL -
# 5 CAPACITY_OVERRIDE (gate continues, override is always surfaced).
GATE_VERDICT=""

if [ -z "$GATE_MODULE" ]; then
    echo "Usage: $0 <MODULE_ID>"
    echo "Example: $0 M03"
    echo ""
    echo "Available gates: M00..M13 (SDLC Modules) | A00..A04 (Enterprise Advisory Series)"
    exit 1
fi

echo "🔍 Validating Gate: $GATE_MODULE"
echo "============================================================"

# --- shared helpers ------------------------------------------------------------
if [ ! -f "$LIB_DIR/checks.sh" ]; then
    echo "❌ Gate helpers not found: $LIB_DIR/checks.sh"
    echo "   The gate scripts appear to be incompletely installed or copied."
    exit 1
fi
# shellcheck source=lib/checks.sh
. "$LIB_DIR/checks.sh"

# --- route to the gate module --------------------------------------------------
MODULE_FILE="$MODULES_DIR/$GATE_MODULE.sh"
if [ ! -f "$MODULE_FILE" ]; then
    echo "❌ Unknown gate: $GATE_MODULE"
    echo "Available gates: M00..M13 (SDLC Modules) | A00..A04 (Enterprise Advisory Series)"
    exit 1
fi

# shellcheck source=modules/
. "$MODULE_FILE"

if ! command -v "gate_$GATE_MODULE" >/dev/null 2>&1; then
    echo "❌ Gate module $MODULE_FILE defines no gate_$GATE_MODULE function."
    exit 1
fi

# A module returning non-zero must not trip `set -e` before the verdict prints:
# GATE_FAILED/GATE_VERDICT are the contract, not the function's return status.
"gate_$GATE_MODULE" || true

# --- verdict -------------------------------------------------------------------
echo ""
echo "============================================================"
# RETEST / PROVISIONAL are non-terminal outcomes: the gate is NOT passed and the
# lifecycle must not chain onward, but the project is not killed either. Distinct
# exit codes let callers branch without parsing prose (3 = retest with better
# evidence, 4 = collect the missing human research first). CAPACITY_OVERRIDE is
# also non-terminal: the artefacts passed, but a capacity-only Large scope runs
# solo under a written risk acceptance, so exit 5 keeps the override visible.
# A real failure (GATE_FAILED=1) still wins — an override never hides a missing artefact.
if [ "$GATE_VERDICT" = "RETEST" ] && [ $GATE_FAILED -eq 0 ]; then
    echo "⚠️  Gate validation NOT PASSED - RERUN after one optimisation sprint (exit 3)"
    exit 3
elif [ "$GATE_VERDICT" = "PROVISIONAL_PENDING_M00" ] && [ $GATE_FAILED -eq 0 ]; then
    echo "⚠️  Gate validation NOT PASSED - PROVISIONAL: complete M00 primary research and re-run (exit 4)"
    exit 4
elif [ "$GATE_VERDICT" = "CAPACITY_OVERRIDE" ] && [ $GATE_FAILED -eq 0 ]; then
    echo "⚠️  Gate validation PASSED UNDER CAPACITY OVERRIDE - Large scope runs solo under a signed risk acceptance (exit 5)"
    exit 5
elif [ $GATE_FAILED -eq 1 ]; then
    echo "❌ Gate validation FAILED - missing mandatory artifacts"
    exit 1
else
    echo "✅ Gate validation PASSED"
    exit 0
fi
