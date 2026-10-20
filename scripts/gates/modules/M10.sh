#!/usr/bin/env bash
# Gate: M10 — extracted from validate-gate.sh (verbatim body).
# Sourced by the dispatcher; do NOT execute directly.
# Shared helpers (check_required/check_optional/check_intake_gate/...) come
# from ../lib/checks.sh, which the dispatcher sources before this file.

# --- gate_M10 ------------------------------------------------------
gate_M10() {
    echo "=== M10: Deployment Production Gate Checklist ==="
    check_required "docs/DEPLOYMENT_PROTOCOL.md" "docs/pm/DEPLOYMENT_PROTOCOL.md" 1000
    check_required "docs/pm/GO_LIVE_REPORT.md" "docs/GO_LIVE_REPORT.md" 500

    # Client handover: production credentials / DNS access are the client's inputs.
    # '|| true' keeps the checklist running under 'set -e' so ALL failures print.
    m10_protocol="docs/DEPLOYMENT_PROTOCOL.md"
    [ -f "$m10_protocol" ] || m10_protocol="docs/pm/DEPLOYMENT_PROTOCOL.md"
    check_client_inputs "$m10_protocol" "M10 Deployment" || true
    # Check HTTP status 200 if URL present in GO_LIVE_REPORT.md
    live_report="docs/pm/GO_LIVE_REPORT.md"
    [ -f "$live_report" ] || live_report="docs/GO_LIVE_REPORT.md"
    if [ -f "$live_report" ]; then
        report_content=$(cat "$live_report" 2>/dev/null || true)
        # 1. Reject unresolved template placeholders [...]
        if echo "$report_content" | grep -qE "\[Project Name\]|\[git rev-parse|\[Vercel /|\[app\.client\.com|\[YYYY-MM-DD\]"; then
            echo "  ❌ $live_report still contains unresolved template placeholders ([...])! Record actual production verification."
            GATE_FAILED=1
        fi
        # 2. Reject deployment failure, rollback, or incomplete PVT status (BLOCKER)
        if echo "$report_content" | grep -qiE "ROLLBACK[[:space:]]*EXECUTED|DEPLOYMENT[[:space:]]*FAILED|Status[[:space:]]*:[[:space:]]*FAILED|PVT[[:space:]]*FAILED"; then
            echo "  ❌ $live_report reports deployment failure or rollback! Production cutover must be successful."
            GATE_FAILED=1
        elif echo "$report_content" | grep -qiE "PASSED|VERIFIED LIVE|SYSTEM LIVE|OPERATIONAL|200 OK"; then
            echo "  ✅ Production Go-Live & PVT pass attestation verified in $live_report"
        else
            echo "  ❌ $live_report missing explicit LIVE / PASSED attestation ('VERIFIED LIVE' / 'SYSTEM LIVE')!"
            GATE_FAILED=1
        fi
        # 3. Reject failed PVT test scenarios in the verification matrix
        if echo "$report_content" | grep -qE "\|[[:space:]]*\**FAIL\**[[:space:]]*\|"; then
            echo "  ❌ $live_report contains failed PVT test scenario(s)! 100% of production verification tests must PASS."
            GATE_FAILED=1
        fi
        # 4. Reject blank lead engineer signature line
        if echo "$report_content" | grep -qE "Lead Engineer:[[:space:]]*_{3,}"; then
            echo "  ❌ $live_report contains blank Lead Engineer signature line (_____)! Must record real engineer sign-off."
            GATE_FAILED=1
        fi
        # 5. Core section headings verification
        check_sections "$live_report" "Release" "Post-Deployment Verification" "Observability" || true
        prod_url=$(grep -iE "Production URL|Live URL|URL Live" "$live_report" | grep -oE "https?://[^ ]+" | head -1 || echo "")
        if [ -n "$prod_url" ] && command -v curl >/dev/null 2>&1; then
            echo "  [INFO] Probing Production URL: $prod_url"
            http_code=$(curl -s -o /dev/null -w "%{http_code}" --connect-timeout 5 --max-time 10 "$prod_url" 2>/dev/null || echo "000")
            if [ "$http_code" = "200" ] || [ "$http_code" = "301" ] || [ "$http_code" = "302" ]; then
                echo "  ✅ Production URL responded with HTTP $http_code (Verified LIVE)"
            else
                echo "  ⚠️  Production URL probe returned HTTP $http_code (Check deployment connectivity)"
            fi
        fi
    fi
    if [ "$(get_field Scale docs/pm/PROJECT_STATE.md | tr '[:upper:]' '[:lower:]')" = "enterprise" ]; then
        echo "  [INFO] Enterprise scale detected: CAB Approval is MANDATORY."
        check_required "docs/governance/CAB_APPROVAL.md" "docs/pm/CAB_APPROVAL.md"
    fi
    # For Large scale, emergency rollback plan is MANDATORY
    m10_scale="$(get_field Scale docs/pm/PROJECT_STATE.md | tr '[:upper:]' '[:lower:]')"
    if [ "$m10_scale" = "large" ] || [ "$m10_scale" = "enterprise" ]; then
        echo "  [INFO] Large / Enterprise scale detected: Emergency Rollback Plan is MANDATORY."
        check_required "docs/pm/ROLLBACK_PLAN.md" "docs/ROLLBACK_PLAN.md" 500
    else
        check_optional "docs/ROLLBACK_PLAN.md" "docs/pm/ROLLBACK_PLAN.md"
    fi
}
