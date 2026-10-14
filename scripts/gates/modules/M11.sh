#!/usr/bin/env bash
# Gate: M11 — extracted from validate-gate.sh (verbatim body).
# Sourced by the dispatcher; do NOT execute directly.
# Shared helpers (check_required/check_optional/check_intake_gate/...) come
# from ../lib/checks.sh, which the dispatcher sources before this file.

# --- gate_M11 ------------------------------------------------------
gate_M11() {
    echo "=== M11: Handover & BAST Gate Checklist ==="
    is_m11_solo=0
    m11_delivery="$(get_field Delivery docs/pm/PROJECT_STATE.md | tr '[:upper:]' '[:lower:]')"
    if [ "$m11_delivery" = "solo" ] || [ "$m11_delivery" = "portfolio" ] || [ "$m11_delivery" = "internal" ]; then
        is_m11_solo=1
    elif [ "$m11_delivery" = "client" ]; then
        is_m11_solo=0 # Client delivery NEVER waives BAST handover regardless of scale
    else
        is_m11_solo=0 # F4: undeclared delivery fail-closed (M00_LITE fallback removed)
    fi

    if [ $is_m11_solo -eq 1 ]; then
        echo "  [INFO] Solo SaaS / Internal project detected: M11 Client BAST Handover is WAIVED."
        check_optional "docs/pm/BAST.md" "contracts/BAST.md"
    else
        # Accept standard BAST.md or lightweight BAST_EMAIL_SMALL.md
        target_bast="docs/pm/BAST.md"
        [ -f "$target_bast" ] || target_bast="contracts/BAST.md"
        [ -f "$target_bast" ] || target_bast="docs/pm/BAST_EMAIL_SMALL.md"
        [ -f "$target_bast" ] || target_bast="contracts/BAST_EMAIL_SMALL.md"

        if [ -f "$target_bast" ]; then
            check_required "$target_bast" "" 200
        else
            check_required "docs/pm/BAST.md" "contracts/BAST.md" 500
        fi
        # Content verification for BAST (BLOCKER)
        if [ -f "$target_bast" ]; then
            bast_content=$(cat "$target_bast" 2>/dev/null || true)
            # 1. Reject unresolved template placeholders [...]
            if echo "$bast_content" | grep -qE "\[PROJECT_CODE\]|\[Client PIC|\[Your Full Name\]|\[Your Name\]|\[CONTRACT_NUMBER\]|\[30 / 60 / 90\]"; then
                echo "  ❌ $target_bast still contains unresolved template placeholders ([...])! Fill in actual BAST legal terms."
                GATE_FAILED=1
            fi
            # 2. Reject unpaid / arrears status (BLOCKER: Article 2 requires 100% settlement before handover)
            # Note: avoid matching legitimate negative phrase 'no outstanding arrears' / 'zero arrears'
            if echo "$bast_content" | grep -qiE "UNPAID|BELUM LUNAS|OUTSTANDING PAYMENT|OWES[[:space:]]+[0-9]+|(has|have|with)[[:space:]]+arrears" || (echo "$bast_content" | grep -qiE "ARREARS" && ! echo "$bast_content" | grep -qiE "(no|zero|without)[[:space:]]+outstanding[[:space:]]+arrears|(no|zero)[[:space:]]+arrears"); then
                echo "  ❌ $target_bast indicates outstanding payment arrears! 100% financial settlement required before closing M11."
                GATE_FAILED=1
            elif echo "$bast_content" | grep -qiE "settled all payment|100%|lunas|no outstanding arrears|Settlement of Financial"; then
                echo "  ✅ 100% payment settlement verified in $target_bast"
            else
                echo "  ❌ $target_bast missing 100% payment settlement confirmation (Article 2)!"
                GATE_FAILED=1
            fi
            # 3. Reject unfulfilled blank signature lines (______ or unassigned PIC)
            if echo "$bast_content" | grep -qiE "FIRST PARTY|Client PIC|Client Company"; then
                if echo "$bast_content" | grep -qiE "_{5,}"; then
                    echo "  ❌ $target_bast has unfulfilled blank signature lines (______ / unassigned PIC)!"
                    GATE_FAILED=1
                else
                    echo "  ✅ BAST signed by both parties"
                fi
            fi
            # 4. Core section headings verification for formal BAST
            if [ "$target_bast" = "docs/pm/BAST.md" ] || [ "$target_bast" = "contracts/BAST.md" ]; then
                check_sections "$target_bast" "Article 1" "Article 2" "Article 3" || true
            fi
        fi

        # User manual is mandatory for Medium+ client projects
        m11_scale="$(get_field Scale docs/pm/PROJECT_STATE.md | tr '[:upper:]' '[:lower:]')"
        if [ "$m11_scale" = "medium" ] || [ "$m11_scale" = "large" ] || [ "$m11_scale" = "enterprise" ]; then
            check_required "docs/USER_MANUAL.md" "docs/pm/USER_MANUAL.md" 500
        else
            check_optional "docs/USER_MANUAL.md" "docs/pm/USER_MANUAL.md"
        fi

        # For Large scale, technical handover protocol is MANDATORY
        if [ "$(get_field Scale docs/pm/PROJECT_STATE.md | tr '[:upper:]' '[:lower:]')" = "large" ] \
            || [ "$(get_field Scale docs/pm/PROJECT_STATE.md | tr '[:upper:]' '[:lower:]')" = "enterprise" ]; then
            echo "  [INFO] Large / Enterprise scale detected: Technical Handover Protocol is MANDATORY."
            check_required "docs/pm/HANDOVER_PROTOCOL.md" "docs/HANDOVER_PROTOCOL.md" 500
        else
            check_optional "docs/pm/HANDOVER_PROTOCOL.md" "docs/HANDOVER_PROTOCOL.md"
        fi
    fi
    check_optional "docs/pm/GO_LIVE_REPORT.md"
    echo ""
    echo "⚠️  DO NOT transfer repo/credentials until 100% payment confirmed"
}
