#!/usr/bin/env bash
# Gate: M00 — Product Discovery & Strategy.
# Sourced by the dispatcher; do NOT execute directly.
# Shared helpers (check_required/check_optional/check_sections/...) come from
# ../lib/checks.sh, which the dispatcher sources before this file.
#
# Canonical thresholds (single source of truth; mirrored in
# docs/modules/00_PRODUCT_DISCOVERY_STRATEGY.md "Gate bar" and
# templates/01-discovery-commercial/M00_LITE_TEMPLATE.md §5):
#   PASS   waitlist >= 5.0% of >= 100 targeted visits | intent-to-buy >= 30%
#          | >= 5 refundable deposits | >= 2 signed LOIs
#   RETEST waitlist 2.0-4.9% with no other evidence -> one 7-day optimisation
#          sprint, then re-test (verdict exit 3: M00 is NOT closed, do not chain)
#   KILL   waitlist < 2.0% with no other evidence
#
# Formatting rule: machine-read lines must survive markdown styling, because the
# shipped template writes them as "- **Field**: value". Requiring the bare form
# made a template-faithful document FAIL while a de-formatted one PASSED.

# Field reader tolerant of bullets, bold, a trailing "%" and stray spacing.
# Echoes the first number on the line, or nothing when the value is still an
# unresolved placeholder ("[e.g. 6.4]", "X visitors").
m00_num_field() {
    local field="$1" file="$2" value
    value=$(sed 's/\*//g' "$file" 2>/dev/null \
        | grep -iE "^[[:space:]]*-?[[:space:]]*${field}[[:space:]]*:" \
        | head -1 \
        | sed -e 's/^[^:]*:[[:space:]]*//' -e 's/%//' || true)
    [ -n "$value" ] || return 0
    case "$value" in
        *'['*) return 0 ;;     # unresolved [placeholder]
        [XxYyZz]*) return 0 ;; # unresolved X / Y / Z
    esac
    printf '%s' "$value" | grep -oE '[0-9]+(\.[0-9]+)?' | head -1
}

# True when the document declares exactly the given Gate-Decision (bold/bullet
# tolerant). Case must be an explicit PASS | RETEST | PENDING | FAIL.
m00_decision_is() {
    sed 's/\*//g' "$2" 2>/dev/null \
        | grep -qiE "^[[:space:]]*-?[[:space:]]*Gate-Decision[[:space:]]*:[[:space:]]*$1([[:space:].]|$)"
}

# Unresolved template placeholders: any [...] token except the explicit allowlist
# of marks that legitimately survive in a finished document. Links are stripped
# first so [label](url) is not flagged. Only checkbox marks are allowlisted, in the
# two positions they legitimately occupy (list bullet and table cell) — a bare
# "[X]/mo" price placeholder is followed by other text and must still be caught.
m00_placeholders() {
    sed -e 's/\[[^]]*\]([^)]*)//g' "$1" 2>/dev/null \
        | sed -E -e 's/^([[:space:]]*-[[:space:]]*)\[[xX ]\]/\1/g' \
                   -e 's/\|[[:space:]]*\[[xX ]\][[:space:]]*\|/|/g' \
        | sed -e 's/\[✅\/❌\/⏳\]//g' -e 's/\[Open \/ Tested \/ Disproven\]//g' \
        | grep -oE '\[[^]]+\]' | sort -u || true
}

# --- gate_M00 ------------------------------------------------------
gate_M00() {
    echo "=== M00: Product Discovery & Strategy Gate Checklist ==="
    # 0. Check if an exploratory spike sandbox exists
    if [ -d "spike" ] || [ -d "poc" ]; then
        echo "  [INFO] Pre-intake technical spike sandbox detected (spike/ or poc/)."
    fi
    # 1. Check if M00 is WAIVED by Scale (small) or Delivery (client/internal/portfolio)
    is_m00_waived=0
    if is_small_scale; then
        echo "  [INFO] Small Scale detected: M00 Product Discovery is WAIVED (Handled by Intake Gate)."
        is_m00_waived=1
    elif [ -n "$(get_field Delivery docs/pm/PROJECT_STATE.md)" ] \
        && [ "$(get_field Delivery docs/pm/PROJECT_STATE.md | tr '[:upper:]' '[:lower:]')" != "solo" ]; then
        echo "  [INFO] Client / Internal / Portfolio delivery: M00 Product Discovery is WAIVED (Scope pre-defined)."
        is_m00_waived=1
    fi

    local validation_file=""
    if [ -f "docs/pm/MARKET_VALIDATION.md" ]; then
        validation_file="docs/pm/MARKET_VALIDATION.md"
    elif [ -f "docs/pm/M00_LITE.md" ]; then
        validation_file="docs/pm/M00_LITE.md"
    fi

    if [ $is_m00_waived -eq 1 ]; then
        check_optional "docs/pm/M00_LITE.md" "docs/pm/MARKET_RESEARCH.md"
        return 0
    fi

    if [ -n "$validation_file" ]; then
        echo "  [INFO] Detected M00-lite rapid validation path (Solo SaaS)"
        check_required "$validation_file" ""
        check_sections "$validation_file" \
            "Riskiest Assumption Register" "User Discovery" "Behavioral Intent" "Unit Economics" "Kill Criteria"

        # 1. Unresolved template placeholders (generic bracket scan + allowlist).
        local leftovers
        leftovers=$(m00_placeholders "$validation_file")
        if [ -n "$leftovers" ]; then
            echo "  ❌ Unresolved template placeholders detected in $validation_file:"
            printf '%s\n' "$leftovers" | sed 's/^/       /'
            GATE_FAILED=1
        fi

        # 2. The gate decision must be explicit and terminal states are blocking.
        local declared=""
        if m00_decision_is "PASS" "$validation_file"; then declared="PASS"
        elif m00_decision_is "RETEST" "$validation_file"; then declared="RETEST"
        elif m00_decision_is "PENDING" "$validation_file"; then declared="PENDING"
        elif m00_decision_is "FAIL" "$validation_file"; then declared="FAIL"
        fi
        if [ -z "$declared" ]; then
            echo "  ❌ Explicit Gate-Decision (PASS | RETEST | PENDING | FAIL) not declared!"
            GATE_FAILED=1
        elif [ "$declared" = "PENDING" ]; then
            echo "  ❌ Gate status: PENDING_PRIMARY_RESEARCH (Real human research pending; M00 cannot be closed)"
            GATE_FAILED=1
        elif [ "$declared" = "FAIL" ]; then
            echo "  ❌ Gate status: FAIL (market validation kill criteria triggered)"
            GATE_FAILED=1
        else
            echo "  ✅ Gate decision declared: $declared"
        fi

        # 3. Real interview count: the template records 5 attempts; at least 3 must
        # be confirmed from real conversations ("✅ Real"). Bold markers tolerated.
        local real_interviews
        real_interviews=$(sed 's/\*//g' "$validation_file" 2>/dev/null \
            | grep -E "^[[:space:]]*\|[[:space:]]*INT-0[0-9][[:space:]]*\|" \
            | grep -cE '✅.*Real' || true)
        real_interviews=$(printf '%s' "$real_interviews" | tr -d ' ')
        if [ "${real_interviews:-0}" -ge 3 ]; then
            echo "  ✅ Real user interviews verified in INT-0x rows: $real_interviews (>= 3 of 5 attempts confirmed)"
        else
            echo "  ❌ Insufficient real interviews: ${real_interviews:-0} confirmed in INT-0x rows (< 3 required; record every attempt, verify at least 3 with '✅ Real')"
            GATE_FAILED=1
        fi

        # 4. Behavioural evidence: sample floor, arithmetic, then the band + floor
        # reconciliation against the declared decision.
        local visitors signups pct intent alt deposits loi strong band
        visitors=$(m00_num_field "Total Unique Visitors" "$validation_file")
        signups=$(m00_num_field "Total Waitlist / Email Signups" "$validation_file")
        pct=$(m00_num_field "Waitlist-Conversion-Pct" "$validation_file")
        intent=$(m00_num_field "Intent-to-Buy-Pct" "$validation_file")
        alt=$(sed 's/\*//g' "$validation_file" 2>/dev/null \
            | grep -iE "^[[:space:]]*-?[[:space:]]*Alternative-Proof[[:space:]]*:" | head -1 || true)
        deposits=$(printf '%s' "$alt" | grep -oE 'deposits:[0-9]+' | grep -oE '[0-9]+' || true)
        loi=$(printf '%s' "$alt" | grep -oE 'loi:[0-9]+' | grep -oE '[0-9]+' || true)

        if [ -z "$visitors" ]; then
            echo "  ❌ Total Unique Visitors missing or still an unresolved placeholder in $validation_file!"
            GATE_FAILED=1
        elif [ "$(awk -v v="$visitors" 'BEGIN { print (v + 0 >= 100) ? 1 : 0 }')" != "1" ]; then
            echo "  ❌ Targeted-visit floor not met: $visitors visitors (< 100 minimum — a rate from a smaller sample is not evidence)"
            GATE_FAILED=1
        else
            echo "  ✅ Targeted-visit floor met: $visitors visitors (>= 100)"
        fi

        # Both halves of the rate are required: a document that omits the signup
        # count cannot be cross-checked, which is exactly how a rate gets invented.
        if [ -z "$signups" ]; then
            echo "  ❌ Total Waitlist / Email Signups missing or still an unresolved placeholder in $validation_file!"
            GATE_FAILED=1
        fi

        if [ -n "$visitors" ] && [ -n "$signups" ]; then
            if [ "$(awk -v s="$signups" -v v="$visitors" 'BEGIN { print (s + 0 > v + 0) ? 1 : 0 }')" = "1" ]; then
                echo "  ❌ Implausible evidence: signups ($signups) exceed visitors ($visitors)."
                GATE_FAILED=1
            fi
        fi
        if [ -n "$visitors" ] && [ -n "$signups" ] && [ -n "$pct" ] \
            && [ "$(awk -v v="$visitors" 'BEGIN { print (v + 0 > 0) ? 1 : 0 }')" = "1" ]; then
            if [ "$(awk -v p="$pct" -v s="$signups" -v v="$visitors" \
                'BEGIN { d = p - (s / v * 100); if (d < 0) d = -d; print (d > 1.0) ? 1 : 0 }')" = "1" ]; then
                echo "  ❌ Waitlist-Conversion-Pct ($pct%) disagrees with signups/visitors ($signups/$visitors). Fix the numbers."
                GATE_FAILED=1
            fi
        fi

        band=""
        if [ -n "$pct" ]; then
            band=$(awk -v p="$pct" 'BEGIN { if (p + 0 >= 5.0) print "PASS"; else if (p + 0 >= 2.0) print "RETEST"; else print "KILL" }')
            case "$band" in
                PASS)   echo "  ✅ Waitlist conversion $pct% is in the PASS band (>= 5.0%)" ;;
                RETEST) echo "  ⚠️  Waitlist conversion $pct% is in the RETEST band (2.0-4.9%)" ;;
                KILL)   echo "  ❌ Waitlist conversion $pct% is in the KILL band (< 2.0%)" ;;
            esac
        else
            echo "  ❌ Waitlist-Conversion-Pct missing or still an unresolved placeholder in $validation_file!"
            GATE_FAILED=1
        fi

        # Aggregate all four signals the way the runbook defines them
        # (docs/modules/00_PRODUCT_DISCOVERY_STRATEGY.md §1):
        #   PASS if ANY signal is in its PASS band
        #   KILL only if ALL signals are in KILL
        #   otherwise RETEST (best signal is RETEST)
        # Previously only waitlist conversion decided the band, so an intent-only
        # 20% report scored KILL, and any "strong" signal rescued a genuine KILL.
        sig=""
        band_of() { # $1 value, $2 pass threshold, $3 retest threshold
            awk -v v="$1" -v p="$2" -v r="$3" 'BEGIN { if (v+0 >= p) print "PASS"; else if (v+0 >= r) print "RETEST"; else print "KILL" }'
        }
        [ -n "$band" ] && sig="$sig $band"
        if [ -n "$intent" ]; then
            b=$(band_of "$intent" 30 15); sig="$sig $b"
            echo "  [signal] intent-to-buy $intent% -> $b"
        fi
        if [ -n "$deposits" ]; then
            b=$(band_of "$deposits" 5 1); sig="$sig $b"
            echo "  [signal] refundable deposits $deposits -> $b"
        fi
        if [ -n "$loi" ]; then
            b=$(band_of "$loi" 2 1); sig="$sig $b"
            echo "  [signal] signed LOIs $loi -> $b"
        fi

        local computed=""
        if printf '%s' "$sig" | grep -q "PASS"; then
            computed="PASS"
        elif printf '%s' "$sig" | grep -q "RETEST"; then
            computed="RETEST"
        elif [ -n "$sig" ]; then
            computed="KILL"
        fi
        [ -n "$computed" ] && echo "  [INFO] Aggregated verdict from signals:${sig} -> $computed"

        # 5. Human attribution. The agent may fill the report but cannot run the
        # interviews, so a PASS must carry a named human validator + real date.
        if [ "$declared" = "PASS" ]; then
            local m00_validator
            m00_validator=$(sed 's/\*//g' "$validation_file" 2>/dev/null \
                | grep -iE "^[[:space:]]*-?[[:space:]]*Validated-by[[:space:]]*:" | head -1 \
                | sed 's/^[^:]*:[[:space:]]*//' | sed 's/[[:space:]]*on[[:space:]]*[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}.*$//' | tr -d '\r')
            if sed 's/\*//g' "$validation_file" 2>/dev/null \
                | grep -qiE "^[[:space:]]*-?[[:space:]]*Validated-by[[:space:]]*:[[:space:]]*[A-Za-z0-9_].*[0-9]{4}-[0-9]{2}-[0-9]{2}" \
                && ! is_role_placeholder "$m00_validator"; then
                echo "  ✅ Human validation recorded (Validated-by: <name> on <date>)"
            else
                echo "  ❌ $validation_file is missing 'Validated-by: <human name> on <YYYY-MM-DD>' — the agent cannot validate its own research."
                GATE_FAILED=1
            fi
        fi

        # 6. Declared decision must match the computed evidence.
        if [ -n "$declared" ] && [ -n "$computed" ]; then
            if [ "$declared" = "$computed" ]; then
                echo "  ✅ Gate decision matches the evidence: $computed"
                if [ "$computed" = "RETEST" ]; then
                    echo "     RETEST: run one 7-day optimisation sprint, then re-test with more targeted visits."
                    GATE_VERDICT="RETEST"
                fi
            else
                echo "  ❌ Declared Gate-Decision '$declared' contradicts the evidence band '$computed'."
                GATE_FAILED=1
            fi
        fi
    else
        check_required "docs/pm/MARKET_RESEARCH.md" "" 1500
        check_required "docs/pm/COMPETITIVE_LANDSCAPE.md" "docs/pm/COMPETITOR_ANALYSIS.md" 1500
        check_required "docs/pm/USER_RESEARCH_REPORT.md" "" 1500
        check_required "docs/pm/PRODUCT_STRATEGY.md" "" 1500

        # 1. Reject unresolved template placeholders in all Full M00 docs
        for doc in "docs/pm/MARKET_RESEARCH.md" "docs/pm/COMPETITIVE_LANDSCAPE.md" "docs/pm/USER_RESEARCH_REPORT.md" "docs/pm/PRODUCT_STRATEGY.md"; do
            if [ -f "$doc" ] && grep -qE "\[\.\.\.\]|\[X\]|\[Y\]|\[Z\]|\[WTP\]|\[Friction\]|\[Current tool\]|\[Business Type\]|\[Your Name[^]]*\]|\[Team Name[^]]*\]|\[Researcher[^]]*\]|\[name\]|\[YYYY-MM-DD\]|\[Competitor [A-Z]\]|\[e\.g\." "$doc"; then
                echo "  ❌ Unresolved template placeholders detected in $doc!"
                GATE_FAILED=1
            fi
        done

        # 2. Verify MARKET_RESEARCH.md cites live sources and verification dates
        if [ -f "docs/pm/MARKET_RESEARCH.md" ]; then
            if grep -qiE "https?://" "docs/pm/MARKET_RESEARCH.md" && grep -qiE "Verified:|Tahun 20|202[0-9]-[0-9]{2}-[0-9]{2}" "docs/pm/MARKET_RESEARCH.md"; then
                echo "  ✅ Market research sources and verification dates verified"
            else
                echo "  ❌ MARKET_RESEARCH.md must cite live source URLs (https://) and verification dates!"
                GATE_FAILED=1
            fi
        fi

        # 3. Verify USER_RESEARCH_REPORT.md structured decision & numeric intent
        if [ -f "docs/pm/USER_RESEARCH_REPORT.md" ]; then
            if grep -qiE "^Gate-Decision:[[:space:]]*PENDING|PENDING_PRIMARY_RESEARCH" "docs/pm/USER_RESEARCH_REPORT.md"; then
                echo "  ❌ Gate status: PENDING_PRIMARY_RESEARCH (Real user data pending; synthetic data prohibited)"
                GATE_FAILED=1
            elif grep -qiE "^Gate-Decision:[[:space:]]*FAIL" "docs/pm/USER_RESEARCH_REPORT.md"; then
                echo "  ❌ Gate status: FAIL (market research thresholds not met)"
                GATE_FAILED=1
            elif grep -qiE "^Gate-Decision:[[:space:]]*PASS" "docs/pm/USER_RESEARCH_REPORT.md"; then
                echo "  ✅ Gate decision verified: PASS"
                # Human attribution, same rule as the lite path.
                local m00_validator2
                m00_validator2=$(sed 's/\*//g' "docs/pm/USER_RESEARCH_REPORT.md" 2>/dev/null \
                    | grep -iE "^[[:space:]]*-?[[:space:]]*Validated-by[[:space:]]*:" | head -1 \
                    | sed 's/^[^:]*:[[:space:]]*//' | sed 's/[[:space:]]*on[[:space:]]*[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}.*$//' | tr -d '\r')
                if sed 's/\*//g' "docs/pm/USER_RESEARCH_REPORT.md" 2>/dev/null \
                    | grep -qiE "^[[:space:]]*-?[[:space:]]*Validated-by[[:space:]]*:[[:space:]]*[A-Za-z0-9_].*[0-9]{4}-[0-9]{2}-[0-9]{2}" \
                    && ! is_role_placeholder "$m00_validator2"; then
                    echo "  ✅ Human validation recorded (Validated-by: <name> on <date>)"
                else
                    echo "  ❌ USER_RESEARCH_REPORT.md is missing 'Validated-by: <human name> on <YYYY-MM-DD>' — the agent cannot validate its own research."
                    GATE_FAILED=1
                fi
            else
                echo "  ❌ Explicit Gate-Decision (PASS|RETEST|PENDING|FAIL) not declared in USER_RESEARCH_REPORT.md!"
                GATE_FAILED=1
            fi
        fi

        # 4. Hands-on competitor testing is a MANDATORY BLOCKER
        if [ -f "docs/pm/COMPETITIVE_LANDSCAPE.md" ]; then
            if grep -qiE "Test Date|Tanggal Uji|Onboarding Time|Waktu Onboarding" "docs/pm/COMPETITIVE_LANDSCAPE.md"; then
                echo "  ✅ Hands-on competitor testing evidence verified"
            else
                echo "  ❌ Hands-on competitor testing evidence (Test Date / Onboarding Time) missing in COMPETITIVE_LANDSCAPE.md!"
                GATE_FAILED=1
            fi
        fi
    fi
}
