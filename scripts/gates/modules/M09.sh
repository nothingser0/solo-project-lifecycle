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
        check_section_content "$target_workbook" "Requirement / AC ID" "Evidence" "UAT"
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
        # 2. The verdict is read from the status lines, never from prose. A finished report may
        # legitimately write "no PENDING items remained", and a word-only rule rejected that; the
        # same rule accepted "The cargo crate was shipped" as an approval because GO matched inside
        # a word. Only lines that state a decision count, and the outcome words must stand alone.
        verdict_lines=$(grep -iE "^[[:space:]]*([-*|].*)?(\*\*)?(UAT[ -]?)?(Status|Decision|Conclusion|Result|Release Decision|Acceptance)(\*\*)?[[:space:]]*[:|]" "$target_uat" || true)
        [ -z "$verdict_lines" ] && verdict_lines="$target_uat"  # fall back to the file for old packs
        if printf '%s\n' "$verdict_lines" | grep -qiE "REJECTED|DISAPPROVED|NOT[[:space:]]+APPROVED|NO-GO|\bFAILED\b|\bPENDING\b"; then
            echo "  ❌ $target_uat reports REJECTED / NOT APPROVED / PENDING status! Client UAT must pass before Production Go-Live."
            printf '%s\n' "$verdict_lines" | grep -iE "REJECTED|DISAPPROVED|NOT[[:space:]]+APPROVED|NO-GO|\bFAILED\b|\bPENDING\b" | head -1 | sed 's/^/       /' | cut -c1-100
            GATE_FAILED=1
        elif printf '%s\n' "$verdict_lines" | grep -qE "\bAPPROVED\b|\bPASSED\b|\bACCEPTED\b|\bGO\b|UAT PASS|Production Release Authorization"; then
            echo "  ✅ UAT approved status verified in $target_uat"
        else
            echo "  ❌ $target_uat missing explicit approval attestation ('Status: APPROVED' / 'PASSED' / 'UAT PASS')!"
            echo "     A decision line must exist; approval words inside prose do not count."
            GATE_FAILED=1
        fi
        # 2b. Reject unresolved Severity 1 & 2 defects in report
        # Catches lines where Sev 1 or 2 is explicitly open/unresolved (avoid matching '0 Open')
        # Two shapes carry the same fact: a labelled line ("Sev 1: 3 Open") and a table row
        # ("| Sev 1 | 3 | still reproducing |"). Only the labelled form was matched, so an open
        # blocker written as a row passed. Counts must be positive and not explicitly zero/resolved.
        sev_row=$(grep -iE "^[[:space:]]*\|[[:space:]]*\*{0,2}Sev(erity)?[[:space:]]*[12]" "$target_uat" \
                  | grep -vE "\|[[:space:]]*0[[:space:]]*\||[[:space:]]0[[:space:]]*(open|remaining)?" \
                  | grep -E "\|[[:space:]]*[1-9][0-9]*[[:space:]]*\|" || true)
        if [ -n "$sev_row" ]; then
            echo "  ❌ $target_uat reports unresolved Severity 1 or 2 defects!"
            printf '%s\n' "$sev_row" | head -1 | sed 's/^/       /' | cut -c1-100
            echo "     All Sev 1/2 blockers must be RESOLVED before production."
            GATE_FAILED=1
        elif grep -qiE "Sev(erity)?[[:space:]]*[12].*:[[:space:]]*[1-9][0-9]*[[:space:]]*(Open|Unresolved|Pending)|Sev(erity)?[[:space:]]*[12].*(Status:[[:space:]]*(Open|Unresolved))" "$target_uat"; then
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
        # The block is found structurally: keying it on the phrase "Client Single PIC" let a renamed
        # row skip the whole check, which is how an unsigned UAT could close.
        has_sign_block=0
        grep -qiE "Client Single PIC|Approved by Client|Signature|Signatures of the Parties|Sign-?Off" "$target_uat" && has_sign_block=1
        if [ "$has_sign_block" -ne 1 ]; then
            echo "  ❌ $target_uat has no client sign-off section - an unsigned UAT cannot close the project."
            GATE_FAILED=1
        fi
        if [ "$has_sign_block" -eq 1 ]; then
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
            # A section can exist and still name nobody: `| Reviewer | | | 2026-11-06 |` satisfied
            # every check above. The client side must carry a person, and a filler word is not one -
            # filling the shipped template with a single placeholder produced "recorded" as the name.
            sign_area=$(awk '/^##+[[:space:]]/ { sec = ($0 ~ /[Ss]ignatures|[Ss]ignature[[:space:]]*[|:]|Signatures of the Parties|Approved by Client|Disetujui oleh/) ? 1 : 0 }
                             sec { print }' "$target_uat")
            # A section titled "Sign-Off Metadata" holds the request details, not the signature, so
            # it is deliberately not a match: the signatory must appear where a signature is asked for.
            [ -z "$sign_area" ] && sign_area=$(grep -iE "Client Single PIC|Approved by Client|Signature" "$target_uat")
            client_named=0
            client_row_seen=0
            while IFS='|' read -r _ c1 c2 c3 c4 _rest; do
                # Only client-side rows can carry the client's acceptance. A row naming the solo
                # engineer (or any other internal party) must not satisfy this check.
                row_party=$(printf '%s' "$c1" | tr -d '*_`' | tr '[:upper:]' '[:lower:]')
                case "$row_party" in
                    *client*|*pic*|*customer*|*klien*|*pelanggan*|*reviewer*) client_row_seen=1 ;;
                    *) continue ;;
                esac
                for cell in "$c1" "$c2" "$c3" "$c4"; do
                    cell=$(printf '%s' "$cell" | sed 's/^[[:space:]]*//; s/[[:space:]]*$//' | tr -d '*_`')
                    [ -z "$cell" ] && continue
                    low=$(printf '%s' "$cell" | tr '[:upper:]' '[:lower:]')
                    case "$low" in
                        party|name|signature|sign|date|role|title|pic|client|reviewer|recorded|done|filled|n/a|na|x|xxx|tbd|todo) continue ;;
                    esac
                    # a person's name is at least two words, each starting with a letter
                    if printf '%s' "$cell" | grep -qE "^[A-Za-z][A-Za-z.'-]*([[:space:]]+[A-Za-z][A-Za-z.'-]*)+$"; then
                        client_named=1
                    fi
                done
            done < <(printf '%s\n' "$sign_area" | grep -E '^[[:space:]]*\|' || true)
            if [ "$client_row_seen" -ne 1 ]; then
                echo "  ❌ $target_uat sign-off sheet has no client row - only internal parties signed."
                echo "     UAT is the client's acceptance; name the client PIC and have them sign."
                GATE_FAILED=1
            elif [ "$client_named" -ne 1 ]; then
                echo "  ❌ $target_uat client sign-off row names nobody."
                echo "     Fill the client PIC's name and signature."
                GATE_FAILED=1
            else
                echo "  ✅ UAT sign-off records a named client signatory"
            fi
            if printf '%s\n' "$sign_area" | grep -qiE "[|:][[:space:]]*(recorded|done|filled|TBD|TODO|X{1,3})[[:space:]]*[|]"; then
                echo "  ❌ $target_uat uses a placeholder word ('recorded' / 'done') where a name belongs."
                GATE_FAILED=1
            fi
        fi

        # 3. A signature must be present in whichever form the sheet uses: a labelled line
        # ("Signature: ____") or a table cell ("| Name | ____ |"). Only the labelled form was
        # checked, so a blank cell read as a signature.
        if [ "$has_sign_block" -eq 1 ]; then
            if grep -qiE "Name[[:space:]]*:[[:space:]]*_{3,}|Signature[[:space:]]*:[[:space:]]*_{3,}|Signature[[:space:]]*:[[:space:]]*\|[[:space:]]*$|[|][[:space:]]*(_{3,}|\[ *\]|\.\.\.)[[:space:]]*[|]" "$target_uat"; then
                echo "  ❌ $target_uat has unfulfilled blank signature lines (______ / empty cell)!"
                GATE_FAILED=1
            else
                echo "  ✅ Client UAT signature recorded"
            fi
        fi
    fi
    echo ""
    echo "⚠️  DO NOT deploy to production until UAT signed"
}
