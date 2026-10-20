#!/usr/bin/env bash
# Gate: M09 — extracted from validate-gate.sh (verbatim body).
# Sourced by the dispatcher; do NOT execute directly.
# Shared helpers (check_required/check_optional/check_intake_gate/...) come
# from ../lib/checks.sh, which the dispatcher sources before this file.

# --- gate_M09 ------------------------------------------------------
gate_M09() {
    echo "=== M09: Validation Gate (UAT Sign-Off) Checklist ==="
    is_m09_solo=0
    m09_delivery="$(get_field Delivery docs/pm/PROJECT_STATE.md | tr '[:upper:]' '[:lower:]')"
    if [ "$m09_delivery" = "solo" ] || [ "$m09_delivery" = "portfolio" ] || [ "$m09_delivery" = "internal" ]; then
        is_m09_solo=1
    elif [ "$m09_delivery" = "client" ]; then
        is_m09_solo=0 # Client delivery NEVER waives UAT regardless of scale
    else
        is_m09_solo=0 # F4: undeclared delivery fail-closed (M00_LITE fallback removed)
    fi

    if [ $is_m09_solo -eq 1 ]; then
        echo "  [INFO] Solo SaaS / Internal project detected: M09 Client UAT is WAIVED (Self-testing)."
        check_optional "docs/pm/UAT_SIGNOFF_REPORT.md" "docs/qa/UAT_SIGNOFF.md"
    else
        # Accept standard UAT_SIGNOFF_REPORT or lightweight UAT_SIGNOFF_SMALL
        target_uat="docs/pm/UAT_SIGNOFF_REPORT.md"
        [ -f "$target_uat" ] || target_uat="docs/qa/UAT_SIGNOFF.md"
        [ -f "$target_uat" ] || target_uat="docs/qa/UAT_SIGNOFF_SMALL.md"
        [ -f "$target_uat" ] || target_uat="docs/pm/UAT_SIGNOFF_SMALL.md"

        if [ -f "$target_uat" ]; then
            check_required "$target_uat" "" 300
        else
            check_required "docs/pm/UAT_SIGNOFF_REPORT.md" "docs/qa/UAT_SIGNOFF.md" 500
        fi
    fi
    check_optional "docs/qa/UAT_WORKBOOK.md"
    if [ -f "docs/pm/UAT_SIGNOFF_REPORT.md" ] || [ -f "docs/qa/UAT_SIGNOFF.md" ] || [ -f "docs/qa/UAT_SIGNOFF_SMALL.md" ] || [ -f "docs/pm/UAT_SIGNOFF_SMALL.md" ]; then
        target_uat="docs/pm/UAT_SIGNOFF_REPORT.md"
        [ -f "$target_uat" ] || target_uat="docs/qa/UAT_SIGNOFF.md"
        [ -f "$target_uat" ] || target_uat="docs/qa/UAT_SIGNOFF_SMALL.md"
        [ -f "$target_uat" ] || target_uat="docs/pm/UAT_SIGNOFF_SMALL.md"
        # 1. Reject unresolved template placeholders [...]
        if grep -qE "\[Application Name\]|\[Client Company|\[Client PIC|\[Your Name\]|\[YYYY-MM-DD\]|\[git-hash\]" "$target_uat"; then
            echo "  ❌ $target_uat still contains unresolved template placeholders ([...])! Fill in actual UAT outcomes."
            GATE_FAILED=1
        fi
        # 2. Reject explicit failure / rejection status (BLOCKER)
        if grep -qiE "REJECTED|DISAPPROVED|NOT APPROVED|FAILED[[:space:]]*BY[[:space:]]*CLIENT|Status[[:space:]]*:[[:space:]]*REJECT" "$target_uat"; then
            echo "  ❌ $target_uat reports REJECTED / NOT APPROVED status! Client UAT must pass before Production Go-Live."
            GATE_FAILED=1
        elif grep -qiE "APPROVED|PASSED|ACCEPTED|UAT PASS|Production Release Authorization" "$target_uat"; then
            echo "  ✅ UAT approved status verified in $target_uat"
        else
            echo "  ❌ $target_uat missing explicit approval attestation ('APPROVED' / 'PASSED' / 'UAT PASS')!"
            GATE_FAILED=1
        fi
        # 2b. Reject unresolved Severity 1 & 2 defects in report
        # Catches lines where Sev 1 or 2 is explicitly open/unresolved (avoid matching '0 Open')
        if grep -qiE "Sev(erity)?[[:space:]]*[12].*:[[:space:]]*[1-9][0-9]*[[:space:]]*(Open|Unresolved|Pending)|Sev(erity)?[[:space:]]*[12].*(Status:[[:space:]]*(Open|Unresolved))" "$target_uat"; then
            echo "  ❌ $target_uat reports unresolved Severity 1 or 2 defects! All blockers must be RESOLVED before production."
            GATE_FAILED=1
        fi
        # 2c. Verify core section headings for standard UAT report
        if [ "$target_uat" = "docs/pm/UAT_SIGNOFF_REPORT.md" ] || [ "$target_uat" = "docs/qa/UAT_SIGNOFF.md" ]; then
            check_sections "$target_uat" "Sign-Off Metadata" "Testing Summary" "Release Authorization" || true
        fi
        # 3. Verify Client Single PIC Sign-off: reject blank signature lines (______ or empty signature cell)
        if grep -qiE "Client Single PIC|Approved by Client" "$target_uat"; then
            if grep -qiE "Name[[:space:]]*:[[:space:]]*_{3,}|Signature[[:space:]]*:[[:space:]]*_{3,}|Signature[[:space:]]*:[[:space:]]*\|[[:space:]]*$" "$target_uat"; then
                echo "  ❌ $target_uat has unfulfilled blank signature lines (______ / unassigned Client Single PIC)!"
                GATE_FAILED=1
            else
                echo "  ✅ Client Single PIC UAT signature recorded"
            fi
        fi
    fi
    echo ""
    echo "⚠️  DO NOT deploy to production until UAT signed"
}
