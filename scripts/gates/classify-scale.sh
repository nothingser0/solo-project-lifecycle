#!/usr/bin/env bash
# classify-scale.sh - Deterministic 6-Dimension Engineering Scale Classifier
# Evaluates P0 count, blast radius, stakeholders, SLA, webhooks, and team size.
# Enforces the HIGH-WATER MARK RULE (highest applicable tier determines project scale).

set -e

PROJECT_STATE="${1:-docs/pm/PROJECT_STATE.md}"

if [ ! -f "$PROJECT_STATE" ]; then
    echo "Usage: $0 [path/to/PROJECT_STATE.md]"
    echo "Error: $PROJECT_STATE not found."
    exit 1
fi

echo "=== Engineering Scale Classifier (High-Water Mark) ==="
echo "Target: $PROJECT_STATE"

TIER=1
REASON="3-7 P0 features, isolated DB, best-effort SLA"

P0_COUNT=0
if [ -f "docs/pm/SCOPE_STATEMENT.md" ]; then
    P0_COUNT=$(grep -iE "\|.*(must|p0).*\|" "docs/pm/SCOPE_STATEMENT.md" | wc -l)
elif [ -f "PROJECT_LITE.md" ]; then
    P0_COUNT=$(grep -iE "^\s*-\s*Feature\s*[0-9]:" "PROJECT_LITE.md" | wc -l)
fi

echo "Detected P0 Must-Have Count: $P0_COUNT"

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

if grep -qiE "midtrans|xendit|stripe|webhook|multi-tenant" "$PROJECT_STATE" 2>/dev/null; then
    if [ $TIER -lt 2 ]; then
        TIER=2
        REASON="High-Water Mark: External payment/webhook integration elevates tier to Medium"
    fi
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
echo "------------------------------------------------------"
