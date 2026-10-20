#!/usr/bin/env bash
# classify-scale.sh - Deterministic Engineering Scale Classifier + Solo Capacity Gate
# v2: Structured-field parsing ONLY (no raw keyword grep over free text).
# Reads: Intake-* fields, Scale/Delivery lines (anchored, bold-tolerant), SCOPE_STATEMENT/PROJECT_LITE.
# Tiers: small 1-5 P0 | medium 6-15 | large 16-25 | enterprise >25.
# Enforces the HIGH-WATER MARK RULE and the SOLO CAPACITY GATE, which has TWO
# different predicates (the cause matters, not the tier number):
#   NON-DELEGABLE  -> statutory compliance or legacy-core replacement. A licensed
#                     third party is legally required, so no amount of solo
#                     capacity substitutes. Hard block AT ANY TIER -> exit 2 (A00-A04).
#   CAPACITY-ONLY  -> 16-25 P0 / multi-service with no non-delegable obligation.
#                     That is a schedule/quality risk the human may accept in
#                     writing (docs/pm/SOLO-CAPACITY-RISK-ACCEPTANCE.md) -> exit 5.
# Exit codes: 0 solo-viable | 2 blocked | 5 capacity override accepted.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_STATE="${1:-docs/pm/PROJECT_STATE.md}"
SOLO_HOURS_PER_WEEK="${SOLO_HOURS_PER_WEEK:-28}"

if [ ! -f "$PROJECT_STATE" ]; then
    echo "Usage: $0 [path/to/PROJECT_STATE.md]"
    echo "Error: $PROJECT_STATE not found."
    exit 1
fi

# Anchored field reader: strips "- ", bold **, whitespace. Reads ONLY the first matching line.
get_field() {
    local name="$1" file="$2"
    grep -m1 -E "^[[:space:]]*-?[[:space:]]*(\*\*)?${name}[[:space:]]*:(\*\*)?" "$file" 2>/dev/null \
        | sed -E "s/^[[:space:]]*-?[[:space:]]*(\*\*)?${name}[[:space:]]*:(\*\*)?[[:space:]]*//; s/[[:space:]]*$//; s/^\*\*//; s/\*\*$//" \
        | head -1
}

echo "=== Engineering Scale Classifier (High-Water Mark + Solo Capacity) ==="
echo "Target: $PROJECT_STATE"
echo "Assumed solo productive hours/week: $SOLO_HOURS_PER_WEEK"

TIER=1
REASON="1-5 P0 features, isolated DB, best-effort SLA"

# --- Structured fields only (free text is NEVER scanned) ---
DELIVERY=$(get_field "Delivery" "$PROJECT_STATE")
P0_FIELD=$(get_field "Intake-P0-Features" "$PROJECT_STATE")
NON_FEATURES=$(get_field "Intake-Non-Features" "$PROJECT_STATE")
SENSITIVE=$(get_field "Intake-Sensitive-Data" "$PROJECT_STATE")
INTEGRATIONS=$(get_field "Intake-Integrations" "$PROJECT_STATE")
BRANCH_HIER=$(get_field "Intake-Branch-Hierarchy" "$PROJECT_STATE")
COMPLIANCE=$(get_field "Intake-Compliance" "$PROJECT_STATE")
LEGACY_CORE=$(get_field "Intake-Legacy-Core" "$PROJECT_STATE")

# P0 count: structured field first, else scope artifacts.
P0_COUNT=0
if [ -n "$P0_FIELD" ]; then
    P0_COUNT=$(echo "$P0_FIELD" | grep -oE "[0-9]+" | head -1)
fi
if [ -z "$P0_COUNT" ] || [ "$P0_COUNT" -eq 0 ] 2>/dev/null; then
    if [ -f "docs/pm/SCOPE_STATEMENT.md" ]; then
        P0_COUNT=$(grep -icE "\|\s*\*\*F-[0-9]+\*\*\s*\|.*(must|p0)" "docs/pm/SCOPE_STATEMENT.md" 2>/dev/null | tr -d ' ')
    elif [ -f "PROJECT_LITE.md" ]; then
        # Matches PROJECT_LITE format: "1. **[Feature 1]**: ..."
        P0_COUNT=$(grep -cE "^[[:space:]]*[0-9]+\.[[:space:]]*\*\*\[?Feature" "PROJECT_LITE.md" 2>/dev/null | tr -d ' ')
    fi
fi
[ -z "$P0_COUNT" ] && P0_COUNT=0

# Integrations: count only from the structured Intake-Integrations field,
# minus anything explicitly excluded in Intake-Non-Features (negation-safe).
INTEGRATION_COUNT=0
if [ -n "$INTEGRATIONS" ] && ! echo "$INTEGRATIONS" | grep -qiE "^\s*(none|no|tidak ada|-)\s*$"; then
    INTEGRATION_COUNT=$(echo "$INTEGRATIONS" | tr ',' '\n' | sed '/^[[:space:]]*$/d' | wc -l | tr -d ' ')
    if [ -n "$NON_FEATURES" ]; then
        NON_COUNT=$(echo "$NON_FEATURES" | grep -ioE "midtrans|xendit|stripe|fonnte|wablas|twilio|sendgrid|resend|whatsapp|payment gateway|webhook" 2>/dev/null | sort -u | wc -l | tr -d ' ')
        INTEGRATION_COUNT=$(( INTEGRATION_COUNT > NON_COUNT ? INTEGRATION_COUNT - NON_COUNT : 0 ))
    fi
fi

echo "Delivery (structured)        : ${DELIVERY:-[not declared]}"
echo "Detected P0 Must-Have Count  : $P0_COUNT"
echo "Detected Distinct Integrations: $INTEGRATION_COUNT"

if [ "$P0_COUNT" -gt 25 ]; then
    TIER=4; REASON=">25 P0 features (Enterprise scope)"
elif [ "$P0_COUNT" -ge 16 ] && [ $TIER -lt 3 ]; then
    TIER=3; REASON="16-25 P0 features (Large Scale platform)"
elif [ "$P0_COUNT" -ge 6 ] && [ $TIER -lt 2 ]; then
    # 6-15 is the documented Medium band (SKILL.md:22-23, M01, M02, SCOPE_STATEMENT).
    # A `-ge 8` threshold made the documented 6-7 band unreachable.
    TIER=2; REASON="6-15 P0 features (Medium Scale)"
fi

# Sensitive data: structured yes/no only (no free-text matching).
if echo "$SENSITIVE" | grep -qiE "^\s*(yes|ya|true)" 2>/dev/null; then
    if [ $TIER -lt 2 ]; then
        TIER=2; REASON="High-Water Mark: Sensitive data (UU PDP applies) elevates tier to Medium"
    fi
fi

if [ "$INTEGRATION_COUNT" -ge 1 ] && [ $TIER -lt 2 ]; then
    TIER=2; REASON="High-Water Mark: External integration/webhook elevates tier to Medium"
fi
if [ "$INTEGRATION_COUNT" -ge 4 ] && [ $TIER -lt 3 ]; then
    TIER=3; REASON="High-Water Mark: 4+ distinct integrations (multi-vendor) elevate tier to Large"
fi

if echo "$BRANCH_HIER" | grep -qiE "^\s*(yes|ya|true|multi)" 2>/dev/null; then
    if [ $TIER -lt 3 ]; then
        TIER=3; REASON="High-Water Mark: Multi-branch/multi-tenant hierarchy elevates tier to Large"
    fi
fi

if [ -n "$COMPLIANCE" ] && ! echo "$COMPLIANCE" | grep -qiE "^\s*(none|no|tidak ada|-)\s*$" 2>/dev/null; then
    TIER=4; REASON="High-Water Mark: Statutory compliance ($COMPLIANCE) elevates tier to Enterprise"
fi

FINAL_SCALE="small"
case $TIER in
    1) FINAL_SCALE="small" ;;
    2) FINAL_SCALE="medium" ;;
    3) FINAL_SCALE="large" ;;
    4) FINAL_SCALE="enterprise" ;;
esac

echo "------------------------------------------------------"
echo "Evaluated Scale   : $FINAL_SCALE"
echo "Primary Rationale : $REASON"

# --- SOLO CAPACITY GATE ---------------------------------------------------------
# Predicate 1 — NON-DELEGABLE, checked at EVERY tier (INTAKE_GATE Q6, SKILL.md and
# templates/essentials/SOLO_CAPACITY_RISK_ACCEPTANCE.md all say "at any size").
# Statutory compliance (OJK/BI/UU PDP/ISO/medical) and a legacy-core replacement both
# require a licensed third party: an audit certificate or vendor engagement nobody can
# self-issue. Declaring "I am ready to code solo" cannot substitute for a missing
# auditor, so this is a hard block regardless of tier and NO override file can open it.
# Regression: this predicate used to live inside the TIER>=3 branch, so a 12-P0 Medium
# ledger migration (legacy-core yes, no compliance) printed "Within solo capacity" and
# exited 0 — exactly the case the docs call "never solo coding, at any size".
NON_DELEGABLE=""
if [ -n "$COMPLIANCE" ] && ! echo "$COMPLIANCE" | grep -qiE "^\s*(none|no|tidak ada|-)\s*$" 2>/dev/null; then
    NON_DELEGABLE="statutory compliance ($COMPLIANCE) — requires licensed audit/counsel"
fi
if echo "$LEGACY_CORE" | grep -qiE "^\s*(yes|ya|true)" 2>/dev/null; then
    NON_DELEGABLE="${NON_DELEGABLE:+$NON_DELEGABLE; }legacy-core replacement — requires vendor/legacy specialist"
fi

if [ -n "$NON_DELEGABLE" ]; then
    echo "------------------------------------------------------"
    echo "⛔ NON-DELEGABLE GATE: $FINAL_SCALE — the obligation cannot be discharged solo."
    echo "   Reason: $NON_DELEGABLE"
    echo "   MANDATORY REDIRECTION: Route to A-Series Advisory Lifecycle (A00-A04)."
    echo "   Allowed output: ENTERPRISE ARCHITECTURE & READINESS PACKAGE ONLY."
    echo "   This block is NOT overridable by a risk-acceptance file: a signature"
    echo "   cannot produce an audit certificate or a licensed vendor."
    echo "   Exit code: 2 (non-delegable — route to A00-A04 Advisory)."
    exit 2
fi

# Predicate 2 — CAPACITY-ONLY, Large tier and above. 16-25 P0 / multi-service with no
# non-delegable obligation. This is a schedule and quality risk that runs in YOUR name,
# so the human may accept it in writing. The override must name a real person and date:
# a placeholder is not an acceptance.
ACCEPTANCE_FILE="docs/pm/SOLO-CAPACITY-RISK-ACCEPTANCE.md"
[ -f "$ACCEPTANCE_FILE" ] || ACCEPTANCE_FILE="docs/pm/SOLO_CAPACITY_RISK_ACCEPTANCE.md"
if [ "$TIER" -ge 3 ]; then
    if [ ! -f "$ACCEPTANCE_FILE" ]; then
        echo "------------------------------------------------------"
        echo "⛔ SOLO CAPACITY GATE: $FINAL_SCALE EXCEEDS SOLO DEVELOPER CAPACITY."
        echo "   No non-delegable obligation was declared, so this is a CAPACITY risk —"
        echo "   which the human may accept in writing. Required: $ACCEPTANCE_FILE"
        echo "   Copy templates/essentials/SOLO_CAPACITY_RISK_ACCEPTANCE.md to $ACCEPTANCE_FILE and complete"
        echo "   Accepted-By (a real human) + Accepted-On (YYYY-MM-DD)."
        echo "   Exit code: 2 (blocked pending a written risk acceptance)."
        exit 2
    fi
    acc_by=$(grep -m1 -iE "^[[:space:]]*-?[[:space:]]*\**Accepted-By\**:" "$ACCEPTANCE_FILE" 2>/dev/null | sed 's/.*:[[:space:]]*//' | tr -d '*\r')
    acc_on=$(grep -m1 -iE "^[[:space:]]*-?[[:space:]]*\**Accepted-On\**:" "$ACCEPTANCE_FILE" 2>/dev/null | sed 's/.*:[[:space:]]*//' | tr -d '*\r')
    if [ -z "$acc_by" ] || echo "$acc_by" | grep -qiE "^\[.*\]|\[.*\]|your name|<.*>|^tbd|^name$|_\{3,\}|^$" \
        || ! echo "$acc_on" | grep -qE "[0-9]{4}-[0-9]{2}-[0-9]{2}"; then
        echo "------------------------------------------------------"
        echo "⛔ SOLO CAPACITY GATE: risk-acceptance is incomplete or holds placeholders."
        echo "   In $ACCEPTANCE_FILE: Accepted-By found: '${acc_by:-<empty>}', Accepted-On found: '${acc_on:-<empty>}'."
        echo "   A real human name and a real date (YYYY-MM-DD) are required. The AI agent"
        echo "   may draft this file but may never accept the risk on the human's behalf."
        echo "   Exit code: 2 (blocked pending a valid risk acceptance)."
        exit 2
    fi
    echo "------------------------------------------------------"
    echo "⚠️  SOLO CAPACITY OVERRIDE: $FINAL_SCALE — capacity risk accepted in writing."
    echo "   Accepted-By: $acc_by · Accepted-On: $acc_on"
    echo "   Advisory (A00-A04) is still required for the governance layers; the coding"
    echo "   itself proceeds solo under the recognised risk."
    echo "   Exit code: 5 (override accepted — gate continues, override is recorded)."
    exit 5
fi

echo "------------------------------------------------------"
echo "✅ Within solo capacity. Proceed with $FINAL_SCALE path."
exit 0
