#!/usr/bin/env bash
# classify-scale.sh - Deterministic Engineering Scale Classifier + Solo Capacity Gate
# Evaluates P0 count, blast radius, integrations, branches, and estimated hours.
# Enforces the HIGH-WATER MARK RULE (highest applicable tier determines project scale).
# Enforces the SOLO CAPACITY GATE (Large/Enterprise exceed a single solo developer's realistic capacity).

set -e

PROJECT_STATE="${1:-docs/pm/PROJECT_STATE.md}"
# Realistic solo productive hours per week (NOT 40; meetings/context-switching/overhead excluded)
SOLO_HOURS_PER_WEEK="${SOLO_HOURS_PER_WEEK:-28}"

if [ ! -f "$PROJECT_STATE" ]; then
    echo "Usage: $0 [path/to/PROJECT_STATE.md]"
    echo "Error: $PROJECT_STATE not found."
    exit 1
fi

echo "=== Engineering Scale Classifier (High-Water Mark + Solo Capacity) ==="
echo "Target: $PROJECT_STATE"
echo "Assumed solo productive hours/week: $SOLO_HOURS_PER_WEEK"

TIER=1
REASON="3-7 P0 features, isolated DB, best-effort SLA"

P0_COUNT=0
if [ -f "docs/pm/SCOPE_STATEMENT.md" ]; then
    P0_COUNT=$(grep -iE "\|.*(must|p0).*\|" "docs/pm/SCOPE_STATEMENT.md" | wc -l | tr -d ' ')
elif [ -f "PROJECT_LITE.md" ]; then
    P0_COUNT=$(grep -iE "^\s*-\s*Feature\s*[0-9]:" "PROJECT_LITE.md" | wc -l | tr -d ' ')
fi

INTEGRATION_COUNT=$(grep -ioE "midtrans|xendit|stripe|fonnte|wablas|twilio|sendgrid|resend|whatsapp|payment gateway|webhook" "$PROJECT_STATE" 2>/dev/null | sort -u | wc -l | tr -d ' ')
BRANCH_COUNT=$(grep -ioE "cabang|branch|multi-tenant|multi-cabang" "$PROJECT_STATE" 2>/dev/null | wc -l | tr -d ' ')

echo "Detected P0 Must-Have Count : $P0_COUNT"
echo "Detected Distinct Integrations: $INTEGRATION_COUNT"
echo "Detected Branch/Tenant Hints : $BRANCH_COUNT"

if [ "$P0_COUNT" -gt 25 ]; then
    TIER=4
    REASON=">25 P0 features (Enterprise scope)"
elif [ "$P0_COUNT" -ge 16 ] && [ $TIER -lt 3 ]; then
    TIER=3
    REASON="16-25 P0 features (Large Scale platform)"
elif [ "$P0_COUNT" -ge 8 ] && [ $TIER -lt 2 ]; then
    TIER=2
    REASON="8-15 P0 features (Medium Scale)"
fi

if grep -qiE "financial|rekening|saldo|pembayaran|payment|rekam medis|health|pasien|banking" "$PROJECT_STATE" 2>/dev/null; then
    if [ $TIER -lt 2 ]; then
        TIER=2
        REASON="High-Water Mark: Financial/sensitive data mutation elevates tier to Medium"
    fi
fi

if [ "$INTEGRATION_COUNT" -ge 1 ] && [ $TIER -lt 2 ]; then
    TIER=2
    REASON="High-Water Mark: External integration/webhook elevates tier to Medium"
fi

if [ "$INTEGRATION_COUNT" -ge 4 ] && [ $TIER -lt 3 ]; then
    TIER=3
    REASON="High-Water Mark: 4+ distinct integrations (multi-vendor) elevate tier to Large"
fi

if [ "$BRANCH_COUNT" -ge 2 ] && [ $TIER -lt 3 ]; then
    TIER=3
    REASON="High-Water Mark: Multi-branch/multi-tenant hierarchy elevates tier to Large"
fi

if grep -qiE "ojk|bank indonesia|hipaa|soc2|pci-dss" "$PROJECT_STATE" 2>/dev/null; then
    TIER=4
    REASON="High-Water Mark: Statutory compliance (OJK/BI/HIPAA) elevates tier to Enterprise"
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

# --- SOLO CAPACITY GATE (Opsi A) ---
if [ "$TIER" -ge 3 ]; then
    echo "------------------------------------------------------"
    echo "⛔ SOLO CAPACITY GATE: $FINAL_SCALE EXCEEDS SOLO DEVELOPER CAPACITY."
    echo "   A single developer cannot realistically deliver 16+ P0 features + pentest +"
    echo "   data migration + 100+ UAT cases within a safe timeline at $SOLO_HOURS_PER_WEEK hrs/week."
    echo ""
    echo "   MANDATORY REDIRECTION: Route to A-Series Advisory Lifecycle (A00-A04)"
    echo "     - A00: Pre-Sales, Administrative Eligibility, Bid/No-Bid & Consulting Agreement"
    echo "     - A01: WBS Decomposition into autonomous Medium sub-projects & Legacy Isolation"
    echo "     - A02: C4 Blueprint, STRIDE Threat Modeling, ATAM Quality Scenarios, Data Residency"
    echo "     - A03: Vendor Procurement Specifications & Build-vs-Buy Evaluation"
    echo "     - A04: Governance Handover Pack (RACI, CAB, DR Plan) & Conformance Retainer"
    echo ""
    echo "   The skill STRICTLY PROHIBITS solo coding for Large/Enterprise scope."
    echo "   Allowed output: ENTERPRISE ARCHITECTURE & READINESS PACKAGE ONLY."
    echo "   Exit code: 2 (Non-solo capacity — route to A00-A04 Advisory)."
    exit 2
fi

echo "------------------------------------------------------"
echo "✅ Within solo capacity. Proceed with $FINAL_SCALE path."
exit 0
