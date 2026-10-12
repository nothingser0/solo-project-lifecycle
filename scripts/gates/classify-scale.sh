#!/usr/bin/env bash
# classify-scale.sh - Deterministic Engineering Scale Classifier + Solo Capacity Gate
# v2: Structured-field parsing ONLY (no raw keyword grep over free text).
# Reads: Intake-* fields, Scale/Delivery lines (anchored, bold-tolerant), SCOPE_STATEMENT/PROJECT_LITE.
# Tiers: small 3-7 P0 | medium 8-15 | large 16-25 | enterprise >25.
# Enforces the HIGH-WATER MARK RULE and the SOLO CAPACITY GATE (Large/Enterprise -> A00-A04 advisory).

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
REASON="3-7 P0 features, isolated DB, best-effort SLA"

# --- Structured fields only (free text is NEVER scanned) ---
DELIVERY=$(get_field "Delivery" "$PROJECT_STATE")
P0_FIELD=$(get_field "Intake-P0-Features" "$PROJECT_STATE")
NON_FEATURES=$(get_field "Intake-Non-Features" "$PROJECT_STATE")
SENSITIVE=$(get_field "Intake-Sensitive-Data" "$PROJECT_STATE")
INTEGRATIONS=$(get_field "Intake-Integrations" "$PROJECT_STATE")
BRANCH_HIER=$(get_field "Intake-Branch-Hierarchy" "$PROJECT_STATE")
COMPLIANCE=$(get_field "Intake-Compliance" "$PROJECT_STATE")

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
elif [ "$P0_COUNT" -ge 8 ] && [ $TIER -lt 2 ]; then
    TIER=2; REASON="8-15 P0 features (Medium Scale)"
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

# --- SOLO CAPACITY GATE ---
if [ "$TIER" -ge 3 ]; then
    echo "------------------------------------------------------"
    echo "⛔ SOLO CAPACITY GATE: $FINAL_SCALE EXCEEDS SOLO DEVELOPER CAPACITY."
    echo "   MANDATORY REDIRECTION: Route to A-Series Advisory Lifecycle (A00-A04)"
    echo "   The skill STRICTLY PROHIBITS solo coding for Large/Enterprise scope."
    echo "   Allowed output: ENTERPRISE ARCHITECTURE & READINESS PACKAGE ONLY."
    echo "   Exit code: 2 (Non-solo capacity — route to A00-A04 Advisory)."
    exit 2
fi

echo "------------------------------------------------------"
echo "✅ Within solo capacity. Proceed with $FINAL_SCALE path."
exit 0
