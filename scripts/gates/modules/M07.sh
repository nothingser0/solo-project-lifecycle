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
        "Core Web Vitals" \
        "Native Mobile QA" \
        "Sign-Off"
    # Anti-vibe-code polish audit (medium+): 33 tells must be checked on the deployed URL.
    if [ -f "docs/qa/POLISH_AUDIT.md" ]; then
        polish_content=$(cat "docs/qa/POLISH_AUDIT.md" 2>/dev/null || true)
        if echo "$polish_content" | grep -qiE "NOT READY"; then
            echo "  ❌ POLISH_AUDIT.md reports NOT READY (blocking tells still open)!"
            GATE_FAILED=1
        elif echo "$polish_content" | grep -qiE "READY \(0 blocking tells\)|READY FOR (CLIENT )?UAT|0 blocking"; then
            # A claim of zero blocking tells is only meaningful next to what was inspected: the
            # deployed URL and the tell inventory. Prose that says "0 blocking" in passing proves
            # nothing, because it names neither the target nor the checklist.
            polish_url_ok=0
            polish_tells_ok=0
            echo "$polish_content" | grep -qiE "https?://[a-zA-Z0-9.-]+\.[a-z]{2,}" && polish_url_ok=1
            tell_rows=$(echo "$polish_content" | grep -cE '^[[:space:]]*\|[^|]+\|[^|]+\|' || true)
            [ "${tell_rows:-0}" -ge 5 ] && polish_tells_ok=1
            if [ "$polish_url_ok" -ne 1 ]; then
                echo "  ❌ POLISH_AUDIT.md claims READY but names no deployed URL - the audit must record the URL it inspected."
                GATE_FAILED=1
            elif [ "$polish_tells_ok" -ne 1 ]; then
                echo "  ❌ POLISH_AUDIT.md claims READY but has no tell-by-tell table (${tell_rows} row(s)) - state each tell's verdict."
                GATE_FAILED=1
            else
                echo "  ✅ POLISH_AUDIT.md attests 0 blocking tells (ready) against a named URL"
            fi
        else
            echo "  ❌ POLISH_AUDIT.md missing explicit READY attestation (0 blocking tells)!"
            GATE_FAILED=1
        fi
    else
        echo "  ❌ docs/qa/POLISH_AUDIT.md (MISSING: run the 33-tell anti-vibe-code audit on the deployed URL)"
        GATE_FAILED=1
    fi
    # Content verification (BLOCKER): workbook must attest a real PASS, not FAILED / NOT EXECUTED.
    if [ -f "docs/qa/SIT_WORKBOOK.md" ]; then
        sit_content=$(cat "docs/qa/SIT_WORKBOOK.md" 2>/dev/null || true)
        if echo "$sit_content" | grep -qE "\[Your Name\]|\[Application Name\]|\[client-domain\]|\[e\.g\.|\[git-hash\]|\[YYYY-MM-DD\]|\[Total\]|\[ID\]"; then
            echo "  ❌ SIT_WORKBOOK.md still contains unresolved template placeholders ([...])! Fill in real execution results."
            GATE_FAILED=1
        elif echo "$sit_content" | grep -qiE "NOT EXECUTED|NOT PASSED|NOT TESTED|Final Testing Status[^:]*:[[:space:]]*.*NOT READY|Status[[:space:]]*:[[:space:]]*FAIL|Testing Status[[:space:]]*:[[:space:]]*FAIL"; then
            echo "  ❌ SIT_WORKBOOK.md reports a FAILED / NOT EXECUTED status! SIT must PASS before Client UAT."
            GATE_FAILED=1
        elif echo "$sit_content" | grep -qiE "Final Testing Status[^:]*:[[:space:]]*SIT PASS"; then
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
        # The sign-off sheet is what a human is held to. A heading proves nothing: the shipped
        # template already has the heading and ships `______` blanks under it, so a workbook that
        # nobody signed passed. Both names AND both signature cells must carry real text.
        sit_signoff=$(echo "$sit_content" | sed -n '/SIT Sign-Off/,$p')
        if [ -z "$sit_signoff" ]; then
            echo "  ❌ SIT_WORKBOOK.md has no 'SIT Sign-Off' section - the workbook cannot be accepted without one."
            GATE_FAILED=1
        else
            blank_cell='(_|=|\[ *\]|\.\.\.|todo|tbd|n/a|N/A)'
            names_ok=0
            for who in "Solo Lead Engineer" "Client Single PIC"; do
                echo "$sit_signoff" | grep -qE "\*\*Name\*\*:[[:space:]]*[^|]*[A-Za-z]{3,}.*\*\*Name\*\*:|\*\*Name\*\*:.*\|.*\*\*Name\*\*:[[:space:]]*[A-Za-z]{3,}" || true
            done
            # a signature cell is real when it holds a name-like token, not blanks or a placeholder
            sig_line=$(echo "$sit_signoff" | grep -iE '^[[:space:]]*\|[^|]*\*\*Signature\*\*' | head -1)
            if [ -n "$sig_line" ] && echo "$sig_line" | grep -qE "\*\*Signature\*\*:[[:space:]]*[A-Za-z][^|]{2,}.*\*\*Signature\*\*:[[:space:]]*[A-Za-z][^|]{2,}"; then
                names_ok=1
            fi
            # a blank anywhere in the sign-off table (____ / [ ] / empty) is an unsigned sheet
            if echo "$sit_signoff" | grep -qE '\|[[:space:]]*\*\*Signature\*\*:[[:space:]]*(_{3,}|\[ *\]|)[[:space:]]*\|'; then
                echo "  ❌ SIT_WORKBOOK.md sign-off sheet is UNSIGNED: a signature cell is blank."
                echo "     Both the Solo Lead Engineer and the Client Single PIC must sign and date it."
                GATE_FAILED=1
            elif echo "$sit_signoff" | grep -qE '\*\*Name\*\*:[[:space:]]*(_{3,}|\[ *\]|)[[:space:]]*\|'; then
                echo "  ❌ SIT_WORKBOOK.md sign-off sheet names nobody: a Name cell is blank."
                echo "     Both the Solo Lead Engineer and the Client Single PIC must be named."
                GATE_FAILED=1
            elif [ "$names_ok" -ne 1 ]; then
                echo "  ❌ SIT_WORKBOOK.md sign-off sheet is not filled by two identifiable people."
                GATE_FAILED=1
            else
                echo "  ✅ SIT_WORKBOOK.md sign-off sheet is signed and dated by both parties"
            fi
        fi
        # Reject any failed scenario: an explicit FAIL cell or a non-zero Failed-column count.
        if echo "$sit_content" | grep -qE "\|[[:space:]]*\**(FAIL|BLOCKED)\**[[:space:]]*\|" || echo "$sit_content" | grep -qE "\|[[:space:]]*[0-9]+[[:space:]]*\|[[:space:]]*[0-9]+[[:space:]]*\|[[:space:]]*[1-9][0-9]*[[:space:]]*\|"; then
            echo "  ❌ SIT_WORKBOOK.md contains FAILED test scenario(s)! 100% of SIT scenarios must PASS before Client UAT."
            GATE_FAILED=1
        else
            echo "  ✅ SIT_WORKBOOK.md shows zero failed SIT scenarios"
        fi
        # Coverage: a SIT workbook with one row can attest "SIT PASS" for an application with
        # dozens of requirements. Every REQ-xx and every SCR-xx from the specs must appear as a
        # tested item, so the attestation covers the system rather than one happy path.
        sit_reqs=""
        [ -f "docs/specs/PRD.md" ] && sit_reqs=$(grep -oE "REQ-[0-9]+" docs/specs/PRD.md | sort -u || true)
        [ -z "$sit_reqs" ] && [ -f "docs/specs/FSD.md" ] && sit_reqs=$(grep -oE "REQ-[0-9]+" docs/specs/FSD.md | sort -u || true)
        sit_screens=""
        [ -f "docs/specs/SITEMAP.md" ] && sit_screens=$(grep -oE "SCR-[A-Z]*-?[0-9]+" docs/specs/SITEMAP.md | sort -u || true)

        untested=""
        for rq in $sit_reqs; do
            grep -qE "(^|[^A-Za-z0-9-])${rq}([^0-9]|$)" docs/qa/SIT_WORKBOOK.md || untested="$untested $rq"
        done
        for sc in $sit_screens; do
            grep -qE "(^|[^A-Za-z0-9-])${sc}([^0-9]|$)" docs/qa/SIT_WORKBOOK.md || untested="$untested $sc"
        done
        if [ -n "$untested" ]; then
            echo "  ❌ SIT_WORKBOOK.md attests SIT PASS but never tests:$untested"
            echo "     Each REQ-xx and SCR-xx needs a row: a passing suite that skips items cannot sign the system off."
            GATE_FAILED=1
        elif [ -n "$sit_reqs$sit_screens" ]; then
            echo "  ✅ SIT covers every REQ-xx and SCR-xx in the specs"
        else
            # No spec meant the loop above had nothing to iterate, so this branch never ran and a
            # one-row workbook could attest SIT PASS for anything. The specs are not always present
            # at this point (a client may keep them elsewhere), so the workbook itself must carry
            # the requirement IDs it claims to have tested - that is the traceability, not the path.
            wb_ids=$(echo "$sit_content" | grep -oE "REQ-[0-9]+|SCR-[A-Z]*-?[0-9]+" | sort -u | wc -l)
            if [ "${wb_ids:-0}" -lt 1 ]; then
                echo "  ❌ SIT coverage cannot be verified: the specs declare no REQ-xx/SCR-xx and the workbook names none either."
                echo "     A SIT PASS must trace to requirements; list the requirement or screen IDs each row covers."
                GATE_FAILED=1
            else
                echo "  ✅ SIT rows are traceable to ${wb_ids} requirement/screen ID(s) declared in the workbook"
            fi
        fi

        # A suite of passing rows with no failure path proves the happy path only. Wireflow and
        # acceptance criteria define sad and edge paths, so at least one row must exercise one.
        if ! grep -qiE "invalid|wrong|rejected|denied|forbidden|unauthori[sz]ed|error|empty|null|negative|sad path|edge|timeout|expired|missing" docs/qa/SIT_WORKBOOK.md; then
            echo "  ❌ SIT_WORKBOOK.md has no negative/edge scenario - only happy paths. Add rows for invalid input, unauthorised access, empty state or error handling."
            GATE_FAILED=1
        fi

        # Large / Enterprise must report measured coverage; M02/project policy owns any threshold.
        m07_scale="$(get_field Scale docs/pm/PROJECT_STATE.md | tr '[:upper:]' '[:lower:]')"
        if [ "$m07_scale" = "large" ] || [ "$m07_scale" = "enterprise" ]; then
            cov_line=$(echo "$sit_content" | grep -iE "line[[:space:]]*coverage" | grep -oE "[0-9]+([.][0-9]+)?%" | head -1 | tr -d '%')
            if [ -n "$cov_line" ]; then
                echo "  ✅ SIT_WORKBOOK.md measured line coverage recorded (${cov_line}%)"
            else
                echo "  ❌ SIT_WORKBOOK.md missing measured line coverage required for this scale; report actual coverage or document why unavailable."
                GATE_FAILED=1
            fi
        fi
    fi
    echo "  [INFO] Full M07 scale detected: Security Audit is MANDATORY."
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
        elif echo "$sec_content" | grep -qiE "\[x\][^A-Za-z]*REJECTED" || echo "$sec_content" | grep -qiE "\|[[:space:]]*[*_]*[[:space:]]*Critical[[:space:]]*[*_]*[[:space:]]*\|[[:space:]]*[*_]*[[:space:]]*[1-9][0-9]*[[:space:]]*[*_]*[[:space:]]*\|"; then
            echo "  ❌ $sec_target reports unresolved Critical vulnerabilities! Zero Critical required before go-live."
            GATE_FAILED=1
        elif echo "$sec_content" | grep -qiE "\[x\][^A-Za-z]*(SECURITY PASS|MEETS SECURITY STANDARDS)|Free of Critical|Zero Critical|0 Critical"; then
            echo "  ✅ $sec_target attests SECURITY PASS (zero Critical vulnerabilities)"
        else
            echo "  ❌ $sec_target missing zero-Critical attestation ('SECURITY PASS' / 'Free of Critical')!"
            GATE_FAILED=1
        fi
    fi
    fi
}
