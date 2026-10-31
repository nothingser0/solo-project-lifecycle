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
    # Probe a public production URL only as a supplemental check; explicit human decision and PVT evidence are still required.
    live_report="docs/pm/GO_LIVE_REPORT.md"
    [ -f "$live_report" ] || live_report="docs/GO_LIVE_REPORT.md"
    if [ -f "$live_report" ]; then
        report_content=$(cat "$live_report" 2>/dev/null || true)
        # 1. Reject unresolved template placeholders and default status values.
        if echo "$report_content" | grep -qE "\[Project Name\]|\[git rev-parse|\[Vercel /|\[app\.client\.com|\[YYYY-MM-DD\]|\[immutable commit|\[GO / NO-GO / PENDING\]|\[LIVE / NOT LIVE|\[PVT-ID\]|Human decision:[[:space:]]*\[|Release status:[[:space:]]*\[|Decision maker and date:[[:space:]]*\[|Verification performed by:[[:space:]]*\["; then
            echo "  ❌ $live_report still contains unresolved template placeholders ([...])! Record actual production verification."
            GATE_FAILED=1
        fi
        # 2. Require an explicit human GO and live release status; reject failed or pending outcomes.
        if echo "$report_content" | grep -qiE "Human decision:[[:space:]]*(NO-GO|PENDING)|Release status:[[:space:]]*(NOT LIVE|DEGRADED|ROLLED BACK|PENDING)|ROLLBACK[[:space:]]*EXECUTED|DEPLOYMENT[[:space:]]*FAILED|Status[[:space:]]*:[[:space:]]*FAILED|PVT[[:space:]]*FAILED"; then
            echo "  ❌ $live_report reports deployment failure or rollback! Production cutover must be successful."
            GATE_FAILED=1
        elif echo "$report_content" | grep -qE "^Human decision:[[:space:]]*GO[[:space:]]*$" && echo "$report_content" | grep -qE "^Release status:[[:space:]]*LIVE[[:space:]]*$"; then
            echo "  ✅ Production Go-Live & PVT pass attestation verified in $live_report"
        else
            echo "  ❌ $live_report must record 'Human decision: GO' and 'Release status: LIVE'."
            GATE_FAILED=1
        fi
        # 3. Reject failed PVT test scenarios in the verification matrix
        if echo "$report_content" | grep -qiE "\|[[:space:]]*\**(FAIL|BLOCKED)\**[[:space:]]*\|"; then
            echo "  ❌ $live_report contains failed or blocked PVT scenarios; disposition them before recording GO."
            GATE_FAILED=1
        fi
        if ! echo "$report_content" | grep -qiE "^\|[[:space:]]*PVT-[[:alnum:]_-]+[[:space:]]*\|"; then
            echo "  ❌ $live_report must include at least one completed PVT evidence row (PVT-ID)."
            GATE_FAILED=1
        fi
        # 4. Reject blank lead engineer signature line
        if echo "$report_content" | grep -qE "Lead Engineer:[[:space:]]*_{3,}"; then
            echo "  ❌ $live_report contains blank Lead Engineer signature line (_____)! Must record real engineer sign-off."
            GATE_FAILED=1
        fi
        # 5. Core section headings verification
        check_sections "$live_report" "Release and Environment" "Post-Deployment Verification" "Monitoring and Recovery"
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
