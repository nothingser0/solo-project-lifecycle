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
    # Client UAT must include scenario-to-requirement traceability and evidence.
    if [ $is_m09_solo -eq 1 ]; then
        check_optional "docs/pm/UAT_WORKBOOK.md" "docs/qa/UAT_WORKBOOK.md"
    else
        check_required "docs/pm/UAT_WORKBOOK.md" "docs/qa/UAT_WORKBOOK.md" 300
    fi
    target_workbook="docs/pm/UAT_WORKBOOK.md"
    [ -f "$target_workbook" ] || target_workbook="docs/qa/UAT_WORKBOOK.md"
    if [ $is_m09_solo -eq 0 ] && [ -f "$target_workbook" ]; then
        check_sections "$target_workbook" "Requirement / AC ID" "Evidence" "UAT"
        if grep -qiE "UAT Approved[^:]*:[[:space:]]*(yes|true)|Pass Rate.*90%" "$target_workbook"; then
            echo "  ❌ $target_workbook contains a fixed approval/pass-rate assumption; base UAT decision on applicable P0 criteria and authorized risk disposition."
            GATE_FAILED=1
        fi
    fi
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
        if grep -qiE "REJECTED|DISAPPROVED|NOT APPROVED|NO-GO|PENDING|FAILED[[:space:]]*BY[[:space:]]*CLIENT|Status[[:space:]]*:[[:space:]]*REJECT" "$target_uat"; then
            echo "  ❌ $target_uat reports REJECTED / NOT APPROVED status! Client UAT must pass before Production Go-Live."
            GATE_FAILED=1
        elif grep -qiE "(^|[^A-Z])GO([^A-Z]|$)|APPROVED|PASSED|ACCEPTED|UAT PASS|Production Release Authorization" "$target_uat"; then
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
            check_sections "$target_uat" "Sign-Off Metadata" "Testing Summary" "Acceptance & Release Decision"
        fi
        # 2b. The client signatory must be a person. M04 and M06 already refuse a model as
        # approver; this is the signature that closes the project, so it is the last place the
        # agent could sign its own work off. A ticked box is not a sign-off.
        if grep -qiE "Client Single PIC|Approved by Client|Signature" "$target_uat"; then
            sig_lines=$(grep -iE "Client Single PIC|Approved by Client|Signature" "$target_uat")
            if printf '%s\n' "$sig_lines" | grep -qiE "claude|chatgpt|gpt-|copilot|assistant|ai agent|chatbot|llm|anthropic|openai"; then
                echo "  ❌ $target_uat names a model as the client signatory — the agent may prepare the pack, never sign it."
                GATE_FAILED=1
            fi
            # A signature carries a name, a date and a channel. Any one missing is not a signature.
            # The channel may sit on its own line, so search the whole file, not the name line.
            sig_missing=""
            grep -qiE "Signed via|Sign-off via|Disetujui via|Approved via" "$target_uat" || sig_missing="$sig_missing channel"
            grep -qiE "[0-9]{4}-[0-9]{2}-[0-9]{2}" "$target_uat" || sig_missing="$sig_missing date"
            if [ -n "$sig_missing" ]; then
                echo "  ❌ $target_uat sign-off is incomplete: missing$sig_missing (need a named human, YYYY-MM-DD, and 'Signed via: meeting|email|WhatsApp')."
                GATE_FAILED=1
            fi
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
