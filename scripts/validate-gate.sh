#!/bin/bash
# validate-gate.sh - Gate checkpoint validation for solo-project-lifecycle
# Usage: ./scripts/validate-gate.sh M03

set -e

GATE_MODULE="${1:-}"
GATE_FAILED=0

if [ -z "$GATE_MODULE" ]; then
    echo "Usage: $0 <MODULE_ID>"
    echo "Example: $0 M03"
    echo ""
    echo "Available gates:"
    echo "  M03 - Commercial Gate (DP received, SOW signed)"
    echo "  M09 - Validation Gate (UAT sign-off)"
    echo "  M11 - Handover Gate (100% payment, BAST signed)"
    exit 1
fi

echo "🔍 Validating Gate: $GATE_MODULE"
echo ""

case "$GATE_MODULE" in
    M03)
        echo "=== M03: Commercial Gate Checklist ==="
        echo ""
        
        # Check SCOPE_STATEMENT exists
        if [ -f "docs/pm/SCOPE_STATEMENT.md" ]; then
            echo "✅ SCOPE_STATEMENT.md exists"
        else
            echo "❌ SCOPE_STATEMENT.md NOT FOUND"
            echo "   Expected: docs/pm/SCOPE_STATEMENT.md"
            GATE_FAILED=1
        fi
        
        # Check SOW_CONTRACT exists
        if [ -f "docs/pm/SOW_CONTRACT.md" ]; then
            echo "✅ SOW_CONTRACT.md exists"
            
            # Check for required sections
            if grep -q "Termin 1.*DP" "docs/pm/SOW_CONTRACT.md"; then
                echo "✅ Payment terms defined"
            else
                echo "⚠️  Payment terms not clearly defined"
            fi
            
            if grep -q "Single PIC" "docs/pm/SOW_CONTRACT.md"; then
                echo "✅ Single PIC clause present"
            else
                echo "⚠️  Single PIC not defined"
            fi
        else
            echo "❌ SOW_CONTRACT.md NOT FOUND"
            echo "   Expected: docs/pm/SOW_CONTRACT.md"
            GATE_FAILED=1
        fi
        
        echo ""
        echo "📋 Manual verification required:"
        echo "   [ ] DP payment received (30-50% of contract value)"
        echo "   [ ] Client signed SOW_CONTRACT.md (wet signature or e-signature)"
        echo "   [ ] Single PIC contact details recorded"
        echo "   [ ] Payment account confirmed (bank transfer details)"
        echo ""
        echo "⚠️  DO NOT proceed to M04 until DP confirmed in bank account"
        ;;
        
    M09)
        echo "=== M09: Validation Gate Checklist ==="
        echo ""
        
        # Check UAT_SIGNOFF_REPORT exists
        if [ -f "docs/pm/UAT_SIGNOFF_REPORT.md" ]; then
            echo "✅ UAT_SIGNOFF_REPORT.md exists"
            
            # Check for sign-off
            if grep -q "Single PIC.*Signature" "docs/pm/UAT_SIGNOFF_REPORT.md"; then
                echo "✅ Sign-off section present"
            else
                echo "⚠️  Sign-off section incomplete"
            fi
        else
            echo "❌ UAT_SIGNOFF_REPORT.md NOT FOUND"
            echo "   Expected: docs/pm/UAT_SIGNOFF_REPORT.md"
            GATE_FAILED=1
        fi
        
        # Check SIT passed (M07 output)
        if [ -f "docs/qa/SIT_WORKBOOK.md" ]; then
            echo "✅ SIT_WORKBOOK.md exists"
        else
            echo "⚠️  SIT_WORKBOOK.md not found (skip for MVP only)"
        fi
        
        echo ""
        echo "📋 Manual verification required:"
        echo "   [ ] All Severity 1 & 2 defects resolved"
        echo "   [ ] Client signed UAT_SIGNOFF_REPORT.md"
        echo "   [ ] Staging environment stable (no critical bugs)"
        echo "   [ ] Deemed acceptance deadline documented (if applicable)"
        echo ""
        echo "⚠️  DO NOT deploy to production until UAT signed"
        ;;
        
    M11)
        echo "=== M11: Handover Gate Checklist ==="
        echo ""
        
        # Check BAST exists
        if [ -f "contracts/BAST.md" ] || [ -f "docs/pm/BAST.md" ]; then
            echo "✅ BAST.md exists"
        else
            echo "❌ BAST.md NOT FOUND"
            echo "   Expected: contracts/BAST.md or docs/pm/BAST.md"
            GATE_FAILED=1
        fi
        
        # Check production deployment
        if [ -f "docs/pm/GO_LIVE_REPORT.md" ]; then
            echo "✅ docs/pm/GO_LIVE_REPORT.md exists"
        else
            echo "⚠️  docs/pm/GO_LIVE_REPORT.md not found"
        fi

        echo ""
        echo "📋 Manual verification required:"
        echo "   [ ] 100% payment received (all termin paid)"
        echo "   [ ] BAST signed by client Single PIC"
        echo "   [ ] Production deployed successfully"
        echo "   [ ] Source code repository access granted to client"
        echo "   [ ] Credentials handed over (encrypted via Bitwarden Send)"
        echo "   [ ] User training completed (if in scope)"
        echo ""
        echo "⚠️  DO NOT transfer repo/credentials until 100% payment confirmed"
        ;;
        
    *)
        echo "❌ Unknown gate: $GATE_MODULE"
        echo ""
        echo "Available gates: M03, M09, M11"
        exit 1
        ;;
esac

echo ""

if [ $GATE_FAILED -eq 1 ]; then
    echo "❌ Gate validation FAILED - missing mandatory artifacts"
    exit 1
else
    echo "✅ Gate validation PASSED"
    exit 0
fi
