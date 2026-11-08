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
        if [ -z "$m11_delivery" ]; then
            echo "  ❌ Delivery is not recorded in docs/pm/PROJECT_STATE.md - M11 cannot tell a client handover from an internal one."
            echo "     Record '- **Delivery**: client | solo | portfolio | internal' before closing M11."
            GATE_FAILED=1
        fi
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
                    # Both parties sign a BAST, and neither may be a model. A document signed
            # "SECOND PARTY: Claude Agent" is a legal handover with no human on either side.
            # Match "Signed by FIRST PARTY:" too - the signature block is where the model's
            # name actually lands, and the first version only looked at the identity lines.
            # The names live on "CLIENT PIC NAME:" / "DEVELOPER NAME:", not on the sentence that
            # defines FIRST/SECOND PARTY, so scanning only the PARTY line let "DEVELOPER NAME:
            # Claude Agent" through. Every identity/signature line is inspected instead.
            for party in "CLIENT PIC NAME" "DEVELOPER NAME" "FIRST PARTY" "SECOND PARTY"; do
                # The label can sit anywhere on the line: "Signed by FIRST PARTY: Claude Agent" is the
                # shipped form, so anchoring at the start of the line silently stopped catching it.
                party_line=$(echo "$bast_content" | grep -iE "$party[^:]*:" | grep -iE "(claude|chatgpt|gpt[0-9._-]*|openai|anthropic|copilot|gemini|llama|assistant|agent|bot|llm|ai assistant)" | head -1)
                if [ -n "$party_line" ]; then
                    echo "  ❌ $target_bast names a model as $party - the agent may draft the BAST, never sign it."
                    GATE_FAILED=1
                fi
            done
            # The two parties must differ: a handover between one person is no handover.
            first_name=$(echo "$bast_content" | grep -iE "^[^A-Za-z]*(\*\*)?CLIENT PIC NAME" | head -1 | sed -E 's/.*:[[:space:]]*//' | sed 's/\*\*//g' | cut -c1-40 | tr '[:upper:]' '[:lower:]' | sed 's/[[:space:]]*$//')
            [ -z "$first_name" ] && first_name=$(echo "$bast_content" | grep -iE "^[^A-Za-z]*FIRST PARTY[^:]*:" | grep -viE "signed by" | head -1 | sed -E 's/.*:[[:space:]]*//' | cut -c1-40 | tr '[:upper:]' '[:lower:]')
            second_name=$(echo "$bast_content" | grep -iE "^[^A-Za-z]*(\*\*)?DEVELOPER NAME" | head -1 | sed -E 's/.*:[[:space:]]*//' | sed 's/\*\*//g' | cut -c1-40 | tr '[:upper:]' '[:lower:]' | sed 's/[[:space:]]*$//')
            [ -z "$second_name" ] && second_name=$(echo "$bast_content" | grep -iE "^[^A-Za-z]*SECOND PARTY[^:]*:" | grep -viE "signed by" | head -1 | sed -E 's/.*:[[:space:]]*//' | cut -c1-40 | tr '[:upper:]' '[:lower:]')
            if [ -n "$first_name" ] && [ "$first_name" = "$second_name" ]; then
                echo "  ❌ $target_bast has the same party on both sides ('$first_name') - that is not a handover."
                GATE_FAILED=1
            fi

            # 1. Reject unresolved template placeholders [...]
            if echo "$bast_content" | grep -qE "\[PROJECT_CODE\]|\[Client PIC|\[Your Full Name\]|\[Your Name\]|\[CONTRACT_NUMBER\]|\[30 / 60 / 90\]"; then
                echo "  ❌ $target_bast still contains unresolved template placeholders ([...])! Fill in actual BAST legal terms."
                GATE_FAILED=1
            fi
            # 2. Reject unpaid / arrears status (BLOCKER: Article 2 requires 100% settlement before handover)
            # Note: avoid matching legitimate negative phrase 'no outstanding arrears' / 'zero arrears'
            # "outstanding arrears of Rp 0" states that nothing is owed; the old pattern read the
            # word ARREARS and rejected a settled account.
            arrears_zero=0
            echo "$bast_content" | grep -qiE "arrears[[:space:]]+(of[[:space:]]+)?(Rp\.?|IDR|USD|\$)?[[:space:]]*0([.,]0+)?([[:space:]]|$|\.|,)" && arrears_zero=1
            if echo "$bast_content" | grep -qiE "UNPAID|BELUM LUNAS|OUTSTANDING PAYMENT|OWES[[:space:]]+[1-9][0-9]*|(has|have|with)[[:space:]]+arrears" || { [ "$arrears_zero" -eq 0 ] && echo "$bast_content" | grep -qiE "ARREARS" && ! echo "$bast_content" | grep -qiE "(no|zero|without)[[:space:]]+outstanding[[:space:]]+arrears|(no|zero)[[:space:]]+arrears"; }; then
                echo "  ❌ $target_bast indicates outstanding payment arrears! 100% financial settlement required before closing M11."
                GATE_FAILED=1
            elif echo "$bast_content" | grep -qiE "settled all payment|100%|lunas|no outstanding arrears|Settlement of Financial" \
                && echo "$bast_content" | grep -qiE "(100[[:space:]]*%|Rp\.?[[:space:]]*[0-9]|IDR[[:space:]]*[0-9]|USD[[:space:]]*[0-9]|settled in full|fully paid|paid in full)"; then
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
                elif echo "$bast_content" | grep -iE "(FIRST|SECOND) PARTY[^:]*:" | grep -qiE "(claude|chatgpt|gpt[0-9._-]*|openai|anthropic|copilot|gemini|llama|assistant|agent|bot|llm|ai assistant)"; then
                    # Do not print a pass next to the model-signature failure above: a gate that
                    # says "signed by both parties" and "a model signed" in the same report is
                    # the same contradiction the harness sections were fixed for.
                    echo "  ❌ $target_bast is not signed by both parties - a model is in a signature line."
                    GATE_FAILED=1
                else
                    echo "  ✅ BAST signed by both parties"
                fi
            fi
            # 4. Core section headings verification for formal BAST
            if [ "$target_bast" = "docs/pm/BAST.md" ] || [ "$target_bast" = "contracts/BAST.md" ]; then
                check_sections "$target_bast" "Article 1" "Article 2" "Article 3"
                check_section_content "$target_bast" "Article 1" "Article 2" "Article 3"
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
