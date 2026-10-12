#!/usr/bin/env bash
# Gate: M00 — extracted from validate-gate.sh (verbatim body).
# Sourced by the dispatcher; do NOT execute directly.
# Shared helpers (check_required/check_optional/check_intake_gate/...) come
# from ../lib/checks.sh, which the dispatcher sources before this file.

# --- gate_M00 ------------------------------------------------------
gate_M00() {
    echo "=== M00: Product Discovery & Strategy Gate Checklist ==="
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

    if [ $is_m00_waived -eq 1 ]; then
        check_optional "docs/pm/M00_LITE.md" "docs/pm/MARKET_RESEARCH.md"
    elif [ -f "docs/pm/M00_LITE.md" ]; then
        echo "  [INFO] Detected M00-lite rapid validation path (Solo SaaS)"
        check_required "docs/pm/M00_LITE.md" "" 1000
        # 1. Blocking decision check: must explicitly be Gate-Decision: PASS
        if grep -qiE "^Gate-Decision:\s*PENDING|\[x\]\s*⏳\s*PENDING" "docs/pm/M00_LITE.md"; then
            echo "  ❌ Gate status: PENDING_PRIMARY_RESEARCH (Real human research pending; M00 cannot be closed)"
            GATE_FAILED=1
        elif grep -qiE "^Gate-Decision:\s*FAIL|^Gate-Decision:\s*PIVOT|\[x\]\s*❌\s*(PIVOT|STOP)" "docs/pm/M00_LITE.md"; then
            echo "  ❌ Gate status: FAIL / PIVOT (Market validation kill criteria triggered)"
            GATE_FAILED=1
        elif grep -qiE "^Gate-Decision:\s*PASS|\[x\]\s*✅\s*PASS" "docs/pm/M00_LITE.md"; then
            echo "  ✅ Gate decision verified: PASS"
        else
            echo "  ❌ Explicit Gate-Decision (PASS|PENDING|FAIL) not declared!"
            GATE_FAILED=1
        fi
        # 2. Check for unresolved template placeholders [...]
        if grep -q "\[\.\.\.\]\|\[X\]/mo\|\[Your Name\]\|\[Business Type\]\|\[Current tool\]\|\[Competitor A\]" "docs/pm/M00_LITE.md"; then
            echo "  ❌ Unresolved template placeholders [...] detected in M00_LITE.md!"
            GATE_FAILED=1
        fi
        # 3. Check real interview count (must be in table rows INT-0x, minimum 3 confirmed)
        real_interviews=$(grep -iE "\|\s*\*\*INT-0[1-5]\*\*\s*\|.*✅\s*Real" "docs/pm/M00_LITE.md" 2>/dev/null | wc -l || echo 0)
        real_interviews=$(echo "$real_interviews" | tr -d ' ')
        if [ "$real_interviews" -ge 3 ]; then
            echo "  ✅ Real user interviews verified in INT-0x rows: $real_interviews (>= 3 minimum confirmed)"
        else
            echo "  ❌ Insufficient real interviews: $real_interviews confirmed in INT-0x rows (< 3 confirmed with '✅ Real')"
            GATE_FAILED=1
        fi
        # 4. Check Waitlist Conversion rate is numeric and >= 5.0%
        wl_pct=$(grep -iE "Waitlist-Conversion-Pct:\s*[0-9.]+" "docs/pm/M00_LITE.md" 2>/dev/null | grep -oE "[0-9.]+" | head -1 || echo "")
        if [ -n "$wl_pct" ]; then
            is_low=$(awk -v val="$wl_pct" 'BEGIN { if (val < 5.0) print 1; else print 0 }' 2>/dev/null || echo 0)
            if [ "$is_low" -eq 1 ]; then
                echo "  ❌ Waitlist-Conversion-Pct ($wl_pct%) is below minimum gate pass threshold (5.0%)!"
                GATE_FAILED=1
            else
                echo "  ✅ Waitlist conversion rate verified: $wl_pct% (>= 5.0% threshold)"
            fi
        else
            echo "  ❌ Waitlist-Conversion-Pct numeric percentage missing in M00_LITE.md!"
            GATE_FAILED=1
        fi
    else
        check_required "docs/pm/MARKET_RESEARCH.md" "" 1500
        check_required "docs/pm/COMPETITIVE_LANDSCAPE.md" "docs/pm/COMPETITOR_ANALYSIS.md" 1500
        check_required "docs/pm/USER_RESEARCH_REPORT.md" "" 1500
        check_required "docs/pm/PRODUCT_STRATEGY.md" "" 1500

        # 1. Reject template placeholders in all Full M00 docs
        for doc in "docs/pm/MARKET_RESEARCH.md" "docs/pm/COMPETITIVE_LANDSCAPE.md" "docs/pm/USER_RESEARCH_REPORT.md" "docs/pm/PRODUCT_STRATEGY.md"; do
            if [ -f "$doc" ] && grep -q "\[\.\.\.\]" "$doc"; then
                echo "  ❌ Unresolved template placeholders [...] detected in $doc!"
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
            if grep -qiE "^Gate-Decision:\s*PENDING|PENDING_PRIMARY_RESEARCH" "docs/pm/USER_RESEARCH_REPORT.md"; then
                echo "  ❌ Gate status: PENDING_PRIMARY_RESEARCH (Real user data pending; synthetic data prohibited)"
                GATE_FAILED=1
            elif grep -qiE "^Gate-Decision:\s*FAIL" "docs/pm/USER_RESEARCH_REPORT.md"; then
                echo "  ❌ Gate status: FAIL (Market research thresholds not met)"
                GATE_FAILED=1
            elif grep -qiE "^Gate-Decision:\s*PASS" "docs/pm/USER_RESEARCH_REPORT.md"; then
                echo "  ✅ Gate decision verified: PASS"
            else
                echo "  ❌ Explicit Gate-Decision (PASS|PENDING|FAIL) not declared in USER_RESEARCH_REPORT.md!"
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
