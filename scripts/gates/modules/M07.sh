#!/usr/bin/env bash
# Gate: M07 — extracted from validate-gate.sh (verbatim body).
# Sourced by the dispatcher; do NOT execute directly.
# Shared helpers (check_required/check_optional/check_intake_gate/...) come
# from ../lib/checks.sh, which the dispatcher sources before this file.

# --- gate_M07 ------------------------------------------------------
gate_M07() {
    echo "=== M07: Quality Assurance & SIT Gate Checklist (medium+ only) ==="
    # NOTE: Small scale does NOT run M07; security is folded into M06.
    is_m07_waived=0
    if is_small_scale; then
        echo "  [INFO] Small Scale detected: M07 QA & SIT is WAIVED (Security absorbed in M06, UAT in M09-LITE)."
        is_m07_waived=1
    fi

    if [ $is_m07_waived -eq 1 ]; then
        check_optional "docs/qa/SIT_WORKBOOK.md"
    else
    check_required "docs/qa/SIT_WORKBOOK.md"
    check_sections "docs/qa/SIT_WORKBOOK.md" \
        "PART I: SIT TEST PLAN" \
        "PART II: SIT REPORT" \
        "Third-Party Integration" \
        "Load & Concurrency Test" \
        "Sign-Off"
    # Anti-vibe-code polish audit (medium+): 32 tells must be checked on the deployed URL.
    if [ -f "docs/qa/POLISH_AUDIT.md" ]; then
        polish_content=$(cat "docs/qa/POLISH_AUDIT.md" 2>/dev/null || true)
        if echo "$polish_content" | grep -qiE "NOT READY"; then
            echo "  ❌ POLISH_AUDIT.md reports NOT READY (blocking tells still open)!"
            GATE_FAILED=1
        elif echo "$polish_content" | grep -qiE "READY \(0 blocking tells\)|READY FOR (CLIENT )?UAT|0 blocking"; then
            echo "  ✅ POLISH_AUDIT.md attests 0 blocking tells (ready)"
        else
            echo "  ❌ POLISH_AUDIT.md missing explicit READY attestation (0 blocking tells)!"
            GATE_FAILED=1
        fi
    else
        echo "  ❌ docs/qa/POLISH_AUDIT.md (MISSING: run the 32-tell anti-vibe-code audit on the deployed URL)"
        GATE_FAILED=1
    fi
    # Content verification (BLOCKER): workbook must attest a real PASS, not FAILED / NOT EXECUTED.
    if [ -f "docs/qa/SIT_WORKBOOK.md" ]; then
        sit_content=$(cat "docs/qa/SIT_WORKBOOK.md" 2>/dev/null || true)
        if echo "$sit_content" | grep -qE "\[Your Name\]|\[Application Name\]|\[client-domain\]|\[e\.g\.|\[git-hash\]|\[YYYY-MM-DD\]|\[Total\]|\[ID\]"; then
            echo "  ❌ SIT_WORKBOOK.md still contains unresolved template placeholders ([...])! Fill in real execution results."
            GATE_FAILED=1
        elif echo "$sit_content" | grep -qiE "NOT EXECUTED|NOT PASSED|NOT TESTED|Status[[:space:]]*:[[:space:]]*FAIL|Testing Status[[:space:]]*:[[:space:]]*FAIL"; then
            echo "  ❌ SIT_WORKBOOK.md reports a FAILED / NOT EXECUTED status! SIT must PASS before Client UAT."
            GATE_FAILED=1
        elif echo "$sit_content" | grep -qiE "SIT PASS|READY FOR (CLIENT )?UAT|Testing Status[^:]*:[[:space:]]*PASS|PASSED \(SIT PASS\)"; then
            echo "  ✅ SIT_WORKBOOK.md attests SIT PASS (ready for UAT)"
        else
            echo "  ❌ SIT_WORKBOOK.md missing explicit PASS attestation ('SIT PASS' / 'READY FOR UAT')!"
            GATE_FAILED=1
        fi
        if echo "$sit_content" | grep -qiE "(staging[_-]url|environment[_-]url|target[_-]url|base[_-]url)[[:space:]]*:[[:space:]]*https?://|https?://[a-zA-Z0-9.-]*(staging|preview|vercel\.app|railway\.app|fly\.dev|pages\.dev|render\.com)"; then
            echo "  ✅ SIT_WORKBOOK.md references a staging/environment URL"
        else
            echo "  ❌ SIT_WORKBOOK.md missing explicit staging environment URL (e.g. Staging-URL: https://...)!"
            GATE_FAILED=1
        fi
        # Reject any failed scenario: an explicit FAIL cell or a non-zero Failed-column count.
        if echo "$sit_content" | grep -qE "\|[[:space:]]*\**FAIL\**[[:space:]]*\|" || echo "$sit_content" | grep -qE "\|[[:space:]]*[0-9]+[[:space:]]*\|[[:space:]]*[0-9]+[[:space:]]*\|[[:space:]]*[1-9][0-9]*[[:space:]]*\|"; then
            echo "  ❌ SIT_WORKBOOK.md contains FAILED test scenario(s)! 100% of SIT scenarios must PASS before Client UAT."
            GATE_FAILED=1
        else
            echo "  ✅ SIT_WORKBOOK.md shows zero failed SIT scenarios"
        fi
        # Coverage threshold for Large / Enterprise (module 07 §6).
        m07_scale="$(get_field Scale docs/pm/PROJECT_STATE.md | tr '[:upper:]' '[:lower:]')"
        if [ "$m07_scale" = "large" ] || [ "$m07_scale" = "enterprise" ]; then
            if [ "$m07_scale" = "enterprise" ]; then
                cov_min=80
            else
                cov_min=70
            fi
            cov_line=$(echo "$sit_content" | grep -iE "line[[:space:]]*coverage" | grep -oE "[0-9]+([.][0-9]+)?%" | head -1 | tr -d '%')
            if [ -n "$cov_line" ]; then
                cov_int=${cov_line%%.*}
                if [ "${cov_int:-0}" -ge "$cov_min" ]; then
                    echo "  ✅ SIT_WORKBOOK.md line coverage ${cov_int}% >= ${cov_min}% (required)"
                else
                    echo "  ❌ SIT_WORKBOOK.md line coverage ${cov_int}% < ${cov_min}% required for this scale!"
                    GATE_FAILED=1
                fi
            else
                echo "  ❌ SIT_WORKBOOK.md missing 'Line Coverage: N%' report (>= ${cov_min}% required for this scale)!"
                GATE_FAILED=1
            fi
        fi
    fi
    if [ "${m07_scale:-}" = "large" ] || [ "${m07_scale:-}" = "enterprise" ]; then
        echo "  [INFO] Large / Enterprise scale detected: Security Audit is MANDATORY."
        check_required "docs/qa/SECURITY_AUDIT.md" "docs/qa/SECURITY_AUDIT_REPORT.md"
        # Content verification (BLOCKER): zero-critical attestation required.
        sec_target=""
        [ -f "docs/qa/SECURITY_AUDIT.md" ] && sec_target="docs/qa/SECURITY_AUDIT.md"
        [ -z "$sec_target" ] && [ -f "docs/qa/SECURITY_AUDIT_REPORT.md" ] && sec_target="docs/qa/SECURITY_AUDIT_REPORT.md"
        if [ -n "$sec_target" ]; then
            sec_content=$(cat "$sec_target" 2>/dev/null || true)
            if echo "$sec_content" | grep -qE "\[Your Name\]|\[Application Name\]|\[client-domain\]|\[YYYY-MM-DD\]|\[Patched / Monitored\]"; then
                echo "  ❌ $sec_target still contains unresolved template placeholders ([...])! Fill in real audit results."
                GATE_FAILED=1
            elif echo "$sec_content" | grep -qiE "\[x\][^A-Za-z]*REJECTED" || echo "$sec_content" | grep -qiE "\|[[:space:]]*Critical[[:space:]]*\|[[:space:]]*[1-9][0-9]*[[:space:]]*\|"; then
                echo "  ❌ $sec_target reports unresolved Critical vulnerabilities! Zero Critical required before go-live."
                GATE_FAILED=1
            elif echo "$sec_content" | grep -qiE "\[x\][^A-Za-z]*(SECURITY PASS|MEETS SECURITY STANDARDS)|Free of Critical|Zero Critical|0 Critical"; then
                echo "  ✅ $sec_target attests SECURITY PASS (zero Critical vulnerabilities)"
            else
                echo "  ❌ $sec_target missing zero-Critical attestation ('SECURITY PASS' / 'Free of Critical')!"
                GATE_FAILED=1
            fi
        fi
    else
        check_optional "docs/qa/SECURITY_AUDIT.md" "docs/qa/SECURITY_AUDIT_REPORT.md"
    fi
    fi
}
