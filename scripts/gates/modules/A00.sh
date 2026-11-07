#!/usr/bin/env bash
# Gate: A00 — extracted from validate-gate.sh (verbatim body).
# Sourced by the dispatcher; do NOT execute directly.
# Shared helpers (check_required/check_optional/check_intake_gate/...) come
# from ../lib/checks.sh, which the dispatcher sources before this file.

# --- gate_A00 ------------------------------------------------------
gate_A00() {
    echo "=== A00: Bid/No-Bid & Commercial Clearance Checklist ==="
    check_required "contracts/CONSULTING_AGREEMENT.md" "docs/pm/CONSULTING_AGREEMENT.md" 1000
    local target="contracts/CONSULTING_AGREEMENT.md"
    [ -f "$target" ] || target="docs/pm/CONSULTING_AGREEMENT.md"
    if [ -f "$target" ]; then
        if grep -qE "\[Client Company|\[Your Name\]|\[PT / CV|\[YYYY-MM-DD\]" "$target"; then
            echo "  ❌ $target still contains unresolved template placeholders ([...])!"
            GATE_FAILED=1
        fi
        check_sections "$target" "Parties" "Advisory Deliverables" "Professional Fees" "Liability"

        # A heading with no terms under it closed this gate. Each named section must carry content.
        for sec in "Advisory Deliverables" "Professional Fees" "Liability"; do
            body=$(awk -v pat="$sec" 'BEGIN{IGNORECASE=1}
                    /^#+[[:space:]]/ {
                        lvl = match($0, /[^#]/)
                        if (keep == 0 && $0 ~ pat) { keep = 1; base = lvl; next }
                        if (keep == 1 && lvl <= base) { keep = 0 }
                    }
                    keep { print }' "$target" 2>/dev/null | grep -vE "^#{1,6}[[:space:]]")
            n=$(printf '%s\n' "$body" | sed 's/^[[:space:]]*//' | grep -vE '^$|^-{3,}$' | wc -l)
            if [ "$n" -lt 1 ]; then
                echo "  ❌ $target '$sec' section is empty - a heading is not a term."
                GATE_FAILED=1
            fi
        done

        # The consultant signs. A model may draft the agreement, never be a party to it - the
        # same rule M09/M10/M11 already enforce for UAT, go-live and BAST.
        # The signature lives in a table ("| For and on behalf of CONSULTANT |"), so a pattern that
        # required "consultant:" on the same line as the name could never match. Any signature-area
        # line naming a model is rejected.
        a00_sig_area=$(awk '/^#+[[:space:]]/ { sec = ($0 ~ /Execution|Signature|Duty Stamp|Signatories/) ? 1 : 0 } sec { print }' "$target")
        [ -z "$a00_sig_area" ] && a00_sig_area=$(grep -iE "for and on behalf|signed by|signature" "$target")
        if printf '%s\n' "$a00_sig_area" | grep -qiE "(claude|chatgpt|gpt[0-9._-]*|openai|anthropic|copilot|gemini|llama|assistant|agent|bot|llm|ai assistant)"; then
            echo "  ❌ $target names a model in the signature block - the agent may draft the agreement, never sign it."
            GATE_FAILED=1
        fi

        # A fee of zero is a pro-bono engagement, which must say so; and a consulting agreement
        # whose liability is "None at all" protects nobody, including the consultant.
        # The shipped template writes "**Total Advisory Fee**: Rp [Amount]", so a pattern expecting
        # "fee: 0" never saw "Rp 0". Zero, absent and "TBD" all mean the engagement is not priced.
        a00_fee_line=$(grep -iE "(total )?(advisory )?fee|professional fees" "$target" | grep -viE "^[[:space:]]*#" | head -1)
        if [ -n "$a00_fee_line" ]; then
            # "Fee: 0" carries no currency symbol, and a currency-anchored pattern skipped it.
            # Only the value AFTER the label matters: "1. **Total Advisory Fee**: Rp 0" carries a
            # list number, and reading any [1-9] on the line read that list number as the price.
            a00_fee_value=$(printf '%s' "$a00_fee_line" | sed 's/.*\*\*:\?//; s/^[^:]*:[[:space:]]*//' | sed 's/^[[:space:]]*//')
            if printf '%s' "$a00_fee_value" | grep -qiE "^(Rp|IDR|USD)?[[:space:]]*0([.,]0+)?([^0-9]|$)" \
               && ! printf '%s' "$a00_fee_value" | grep -qE "[1-9]"; then
                if ! grep -qiE "pro[- ]?bono" "$target"; then
                    echo "  ❌ $target prices the advisory at zero without 'pro bono' - that is an unpaid contract, not a priced one."
                    GATE_FAILED=1
                fi
            elif printf '%s' "$a00_fee_line" | grep -qiE ":[[:space:]]*(free|none|tbd|to be (discussed|determined)|n/a)[[:space:]]*$"; then
                if ! grep -qiE "pro[- ]?bono" "$target"; then
                    echo "  ❌ $target states no advisory fee ('$(printf '%s' "$a00_fee_line" | cut -c1-40)') and is not declared pro bono."
                    GATE_FAILED=1
                fi
            elif ! printf '%s' "$a00_fee_line" | grep -qE "[0-9]"; then
                echo "  ❌ $target fee line carries no amount: $(printf '%s' "$a00_fee_line" | cut -c1-60)"
                GATE_FAILED=1
            fi
        else
            echo "  ❌ $target does not state a professional fee."
            GATE_FAILED=1
        fi
        # "**Maximum Liability Cap**: None" never matched a pattern anchored on "liability: none",
        # and it is the exact phrasing the shipped template invites.
        a00_liab_line=$(grep -iE "liabilit(y|ies)" "$target" | grep -viE "^[[:space:]]*#" | grep -iE "cap|limit|maximum|maximum total" | head -1)
        if [ -n "$a00_liab_line" ] && printf '%s' "$a00_liab_line" | grep -qiE ":[[:space:]]*(none|n/a|nil|no liability|not applicable)[[:space:]]*\.?[[:space:]]*$"; then
            echo "  ❌ $target caps the consultant's liability at nothing ('$(printf '%s' "$a00_liab_line" | cut -c1-50)')."
            gate_liab_sentence=$(grep -iE "maximum liability cap" "$target" | grep -qiE "capped at|limited to|not exceed" && echo ok || echo none)
            if [ "$gate_liab_sentence" = "none" ]; then
                GATE_FAILED=1
            else
                echo "     (a numeric cap is also stated, so this line reads as a heading value — review it)"
            fi
            GATE_FAILED=1
        fi
        if ! grep -qiE "liabilit" "$target"; then
            echo "  ❌ $target does not address liability at all."
            GATE_FAILED=1
        fi
    fi
    check_optional "docs/pm/RFP_RESPONSE.md"
}
