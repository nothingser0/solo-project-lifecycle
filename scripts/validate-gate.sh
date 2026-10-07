#!/usr/bin/env bash
# validate-gate.sh - Gate checkpoint validation for solo-project-lifecycle
# Usage: ./scripts/validate-gate.sh <MODULE_ID>

set -e

GATE_MODULE="${1:-}"
GATE_FAILED=0

if [ -z "$GATE_MODULE" ]; then
    echo "Usage: $0 <MODULE_ID>"
    echo "Example: $0 M03"
    echo ""
    echo "Available gates: M00, M01, M02, M03, M04, M05, M06, M07, M08, M09, M10, M11, M12, M13"
    exit 1
fi

echo "🔍 Validating Gate: $GATE_MODULE"
echo "============================================================"

check_required() {
    local file="$1"
    local alt="$2"
    if [ -f "$file" ] || ([ -n "$alt" ] && [ -f "$alt" ]); then
        [ -f "$file" ] && echo "  ✅ $file" || echo "  ✅ $alt"
    else
        echo "  ❌ $file (MISSING)"
        GATE_FAILED=1
    fi
}

check_optional() {
    local file="$1"
    local alt="$2"
    if [ -f "$file" ]; then
        echo "  [OK] $file (optional)"
    elif [ -n "$alt" ] && [ -f "$alt" ]; then
        echo "  [OK] $alt (optional)"
    else
        echo "  ⚠️  $file (optional, not found)"
    fi
}

case "$GATE_MODULE" in
    M00)
        echo "=== M00: Product Discovery & Strategy Gate Checklist ==="
        if [ -f "docs/pm/M00_LITE.md" ]; then
            echo "  [INFO] Detected M00-lite rapid validation path"
            check_required "docs/pm/M00_LITE.md"
            if grep -q "PENDING_PRIMARY_RESEARCH" "docs/pm/M00_LITE.md"; then
                echo "  ⏳ Gate status: PENDING_PRIMARY_RESEARCH (Real user interviews & waitlist test pending)"
            elif grep -q "PASS" "docs/pm/M00_LITE.md"; then
                echo "  ✅ Gate status: PASS (Empirical validation verified)"
            fi
        else
            check_required "docs/pm/MARKET_RESEARCH.md"
            check_required "docs/pm/COMPETITIVE_LANDSCAPE.md" "docs/pm/COMPETITOR_ANALYSIS.md"
            check_required "docs/pm/USER_RESEARCH_REPORT.md"
            check_required "docs/pm/PRODUCT_STRATEGY.md"
            if [ -f "docs/pm/USER_RESEARCH_REPORT.md" ]; then
                if grep -q "PENDING_PRIMARY_RESEARCH" "docs/pm/USER_RESEARCH_REPORT.md"; then
                    echo "  ⏳ Gate status: PENDING_PRIMARY_RESEARCH (Real user data pending; synthetic data prohibited)"
                elif grep -qi "intent.*[3-9][0-9]%\|intent.*100%\|PASS" "docs/pm/USER_RESEARCH_REPORT.md"; then
                    echo "  ✅ Market validation gate criteria: Intent-to-buy threshold verified"
                else
                    echo "  ⚠️  Market validation: Intent-to-buy ≥30% not explicitly validated"
                fi
            fi
        fi
        ;;
    M01)
        echo "=== M01: Idea Feasibility Gate Checklist ==="
        check_required "docs/pm/IDEA_BRIEF.md" "docs/pm/FEASIBILITY_REPORT.md"
        ;;
    M02)
        echo "=== M02: Discovery & Scope Gate Checklist ==="
        check_required "docs/pm/SCOPE_STATEMENT.md"
        if [ -f "docs/pm/SCOPE_STATEMENT.md" ]; then
            # 1. Ambiguity detection on Must-Have rows
            if grep -iE "\|.*(must|p0).*\|" "docs/pm/SCOPE_STATEMENT.md" | grep -qiE "TBD|maybe|if time permits|tentative|TBA"; then
                echo "  ❌ Ambiguous terms (TBD/maybe/if time permits) detected in Must-Have scope rows!"
                GATE_FAILED=1
            else
                echo "  ✅ Zero ambiguous terms in Must-Have scope rows"
            fi

            # 2. Confidence Legend check
            if grep -q "✅" "docs/pm/SCOPE_STATEMENT.md" || grep -q "VERIFIED" "docs/pm/SCOPE_STATEMENT.md"; then
                echo "  ✅ Data Confidence Legend / status markers present"
            else
                echo "  ⚠️  Data Confidence Legend [✅ / 🔶 / ❓] not explicitly declared"
            fi

            # 3. Out-of-Scope exclusions check
            if grep -qi "out-of-scope" "docs/pm/SCOPE_STATEMENT.md"; then
                echo "  ✅ Explicit Out-of-Scope boundaries defined"
            else
                echo "  ⚠️  Out-of-Scope boundary section missing"
            fi
        fi
        ;;
    M03)
        echo "=== M03: Legal SOW & Charter Checklist ==="
            target_sow="contracts/SOW_CONTRACT.md"
            [ -f "$target_sow" ] || target_sow="docs/pm/SOW_CONTRACT.md"
        
        if grep -qiE "bypass|waived|solo saas|self-initiated" "$target_sow" 2>/dev/null || ([ ! -f "$target_sow" ] && [ -f "docs/pm/M00_LITE.md" ]); then
            echo "  [INFO] Solo SaaS / Self-Initiated product: Commercial SOW gate is WAIVED."
            check_optional "contracts/SOW_CONTRACT.md" "docs/pm/SOW_CONTRACT.md"
            else
        check_required "contracts/SOW_CONTRACT.md" "docs/pm/SOW_CONTRACT.md"
            check_optional "contracts/NDA.md" "docs/pm/NDA.md"
            if [ -f "$target_sow" ]; then
                if grep -qiE "Termin|Milestone.*Payment|Down Payment|DP" "$target_sow"; then
                echo "  ✅ Payment terms defined"
            else
                    echo "  ❌ Payment terms not clearly defined!"
                    GATE_FAILED=1
            fi
                if grep -qi "Single PIC" "$target_sow"; then
                echo "  ✅ Single PIC clause present"
                else
                    echo "  ❌ Single PIC clause missing!"
                    GATE_FAILED=1
            fi
                if grep -qiE "Limitation of Liability|Liability Cap" "$target_sow"; then
                    echo "  ✅ Limitation of liability clause present"
                else
                    echo "  ⚠️  Limitation of liability clause not explicitly detected"
        fi
            fi
        echo ""
            echo "⚠️  DO NOT proceed to M04 until DP confirmed in bank account (or bypassed for Solo SaaS)"
        fi
        ;;
    M04)
        echo "=== M04: UI/UX Prototyping Gate Checklist ==="
        check_required "DESIGN.md" "docs/harness-root/DESIGN.md"
        check_required "docs/specs/DESIGN_SPEC.md"
        ;;
    M05)
        echo "=== M05: Architecture & Specs Gate Checklist ==="
        check_required "docs/specs/PRD.md"
        check_required "docs/specs/FSD.md"
        check_optional "PROJECT_LITE.md"
        ;;
    M06)
        echo "=== M06: Development Execution Gate Checklist ==="
        check_required "AGENTS.md"
        check_required "CONTEXT.md"
        check_required "TODO.md"
        check_required "docs/RUNBOOK_LOCAL.md"
        check_optional "ARCHITECTURE.md"
        check_optional "CONVENTIONS.md"
        ;;
    M07)
        echo "=== M07: Quality Assurance & SIT Gate Checklist ==="
        check_required "docs/qa/SIT_WORKBOOK.md"
        check_optional "docs/qa/SECURITY_AUDIT.md" "docs/qa/SECURITY_AUDIT_REPORT.md"
        ;;
    M08)
        echo "=== M08: Data Migration & Seeding Gate Checklist ==="
        check_required "docs/pm/DATA_MIGRATION_PLAN.md"
        check_optional "docs/pm/MIGRATION_RECONCILIATION_REPORT.md"
        ;;
    M09)
        echo "=== M09: Validation Gate (UAT Sign-Off) Checklist ==="
        check_required "docs/pm/UAT_SIGNOFF_REPORT.md" "docs/qa/UAT_SIGNOFF.md"
        check_optional "docs/qa/UAT_WORKBOOK.md"
        if [ -f "docs/pm/UAT_SIGNOFF_REPORT.md" ] || [ -f "docs/qa/UAT_SIGNOFF.md" ]; then
            target_uat="docs/pm/UAT_SIGNOFF_REPORT.md"
            [ -f "$target_uat" ] || target_uat="docs/qa/UAT_SIGNOFF.md"
            if grep -q "APPROVED\|PASSED\|Accepted" "$target_uat"; then
                echo "  ✅ UAT approved status detected"
            else
                echo "  ⚠️  UAT approved status not clearly found"
            fi
        fi
        echo ""
        echo "⚠️  DO NOT deploy to production until UAT signed"
        ;;
    M10)
        echo "=== M10: Deployment Production Gate Checklist ==="
        check_required "docs/DEPLOYMENT_PROTOCOL.md" "docs/pm/DEPLOYMENT_PROTOCOL.md"
        check_optional "docs/ROLLBACK_PLAN.md" "docs/pm/ROLLBACK_PLAN.md"
        ;;
    M11)
        echo "=== M11: Handover & BAST Gate Checklist ==="
        check_required "docs/pm/BAST.md" "contracts/BAST.md"
        check_optional "docs/pm/GO_LIVE_REPORT.md"
        check_optional "docs/pm/HANDOVER_PROTOCOL.md" "docs/HANDOVER_PROTOCOL.md"
        check_optional "docs/USER_MANUAL.md"
        echo ""
        echo "⚠️  DO NOT transfer repo/credentials until 100% payment confirmed"
        ;;
    M12)
        echo "=== M12: Warranty SLA Retainer Gate Checklist ==="
        check_required "docs/pm/WARRANTY_POLICY.md"
        check_optional "docs/pm/SLA_RETAINER_CONTRACT.md" "contracts/SLA_RETAINER.md"
        check_optional "docs/pm/INCIDENT_RESPONSE.md" "docs/INCIDENT_RESPONSE.md"
        ;;
    M13)
        echo "=== M13: Product Operations & Iteration Gate Checklist ==="
        check_required "docs/pm/METRICS_BASELINE_REPORT.md" "docs/analytics/METRICS_BASELINE_REPORT.md"
        check_optional "docs/pm/GROWTH_EXPERIMENTS_BACKLOG.md"
        ;;
    *)
        echo "❌ Unknown gate: $GATE_MODULE"
        echo "Available gates: M00, M01, M02, M03, M04, M05, M06, M07, M08, M09, M10, M11, M12, M13"
        exit 1
        ;;
esac

echo ""
echo "============================================================"
if [ $GATE_FAILED -eq 1 ]; then
    echo "❌ Gate validation FAILED - missing mandatory artifacts"
    exit 1
else
    echo "✅ Gate validation PASSED"
    exit 0
fi
