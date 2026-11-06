#!/usr/bin/env bash
# Gate: M03 — extracted from validate-gate.sh (verbatim body).
# Sourced by the dispatcher; do NOT execute directly.
# Shared helpers (check_required/check_optional/check_intake_gate/...) come
# from ../lib/checks.sh, which the dispatcher sources before this file.

# --- gate_M03 ------------------------------------------------------
gate_M03() {
    echo "=== M03: Legal SOW & Charter Checklist ==="
    target_sow="contracts/SOW_CONTRACT.md"
    [ -f "$target_sow" ] || target_sow="docs/pm/SOW_CONTRACT.md"
    [ -f "$target_sow" ] || target_sow="contracts/SOW_SMB.md"
    [ -f "$target_sow" ] || target_sow="docs/pm/SOW_SMB.md"
    
    IS_SOLO=0
    # F4: STRICT DELIVERY ROUTING — read Delivery from ITS OWN field line only.
    # A stray "Delivery: solo" in prose must NEVER waive a client project, and the
    # M00_LITE.md-presence infer-solo fallback is REMOVED (missing SOW must FAIL
    # for an undeclared delivery, not silently pass).
    m03_delivery="$(get_field Delivery docs/pm/PROJECT_STATE.md | tr '[:upper:]' '[:lower:]')"
    if [ "$m03_delivery" = "solo" ] || [ "$m03_delivery" = "portfolio" ] || [ "$m03_delivery" = "internal" ]; then
        IS_SOLO=1
    elif [ "$m03_delivery" = "client" ]; then
        IS_SOLO=0 # Client delivery NEVER bypasses SOW regardless of scale
    else
        IS_SOLO=0 # Undeclared delivery: gate is enforced (fail-closed)
        echo "  [INFO] Delivery not declared in docs/pm/PROJECT_STATE.md — the SOW gate is enforced fail-closed."
        echo "         Client work MUST pass this gate; Solo SaaS / product / internal work records 'Delivery: solo | internal | portfolio' to WAIVE it."
    fi

    if [ $IS_SOLO -eq 1 ]; then
        echo "  [INFO] Solo SaaS / Internal / Portfolio project detected: Commercial SOW gate is WAIVED."
        check_optional "contracts/SOW_CONTRACT.md" "docs/pm/SOW_CONTRACT.md"
        local charter="docs/pm/SOLO_SAAS_CHARTER.md"
        [ -f "$charter" ] || charter="contracts/SOLO_SAAS_CHARTER.md"
        if [ -f "$charter" ]; then
            echo "  ✅ Solo SaaS Project Charter present ($charter)"
            if grep -q "\[\.\.\.\]\|\[Your Name\]\|\[Product Codename\]" "$charter"; then
                echo "  ❌ Unresolved template placeholders [...] detected in $charter!"
                GATE_FAILED=1
            fi
        else
            echo "  ℹ️  Optional: $charter recommended for founder runway budget & kill thresholds"
        fi
    else
        # Accept standard SOW_CONTRACT or simplified SOW_SMB
        local sow_req_size=1000
        if is_small_scale; then
            sow_req_size=500  # Leaner threshold for SMB / Small client agreement
        fi
        if [ -f "contracts/SOW_SMB.md" ] || [ -f "docs/pm/SOW_SMB.md" ]; then
            check_required "contracts/SOW_SMB.md" "docs/pm/SOW_SMB.md" $sow_req_size
        else
            check_required "contracts/SOW_CONTRACT.md" "docs/pm/SOW_CONTRACT.md" $sow_req_size
        fi

        # NDA is mandatory for Medium+ client delivery; optional for Small client
        is_small_client=0
        if is_small_scale; then
            is_small_client=1
        fi
        if [ $is_small_client -eq 1 ]; then
            check_optional "contracts/NDA.md" "docs/pm/NDA.md"
        else
            echo "  [INFO] Medium+ client delivery: NDA is MANDATORY before client data access."
            check_required "contracts/NDA.md" "docs/pm/NDA.md" 500

    # An NDA is signed by both parties; a model may draft it, never be a party. Same rule as
    # M09/M10/M11/A00/A01/A04.
    nda_file="contracts/NDA.md"
    [ -f "$nda_file" ] || nda_file="docs/pm/NDA.md"
    if [ -f "$nda_file" ]; then
        if grep -iE "(signed by|signed|party|disclosing|receiving)[[:space:]]*:" "$nda_file" | grep -qiE "(claude|chatgpt|gpt[0-9._-]*|openai|anthropic|copilot|gemini|llama|assistant|agent|bot|llm|ai assistant)"; then
            echo "  ❌ $nda_file names a model as a signing party - the agent may draft the NDA, never sign it."
            GATE_FAILED=1
        fi
        if ! grep -qiE "(signed by|signature|party)[[:space:]]*:" "$nda_file"; then
            echo "  ❌ $nda_file has no signing party line - an unsigned NDA protects nothing."
            GATE_FAILED=1
        fi
    fi
            local target_nda="contracts/NDA.md"
            [ -f "$target_nda" ] || target_nda="docs/pm/NDA.md"
            if [ -f "$target_nda" ]; then
                if grep -q "\[\.\.\.\]\|\[Client Name\]\|\[Client Company Name\]" "$target_nda"; then
                    echo "  ❌ Unresolved template placeholders [...] detected in NDA contract!"
                    GATE_FAILED=1
                fi
            fi
        fi
        if [ -f "$target_sow" ]; then
            # A2: core section headings must be present (SOW_SMB vs consolidated SOW layout).
            # Heading-only routing kept the two layouts from cross-triggering. Every
            # entry is an ALTERNATION so either layout's own wording satisfies it: the
            # consolidated SOW titles its sections "Project Charter", "Compensation
            # Value & Payment Milestone Schedule" and "Change Request (CR) Procedure",
            # so a single-string matcher reported false MISSING headings.
            check_sections "$target_sow" \
                "Project Overview|Project Charter" \
                "Scope of Work" \
                "Payment Terms|Compensation" \
                "Change Request"
            # 1. Check unresolved placeholders [...]
            if grep -q "\[\.\.\.\]\|\[Numeric Amount\]\|\[Account Number\]" "$target_sow"; then
                echo "  ❌ Unresolved template placeholders [...] detected in SOW contract!"
                GATE_FAILED=1
            fi

            # 2. Payment terms & milestones
            if grep -qiE "Termin|Milestone.*Payment|Down Payment|DP|30/40/30|50/50" "$target_sow"; then
                echo "  ✅ Payment terms & milestone schedule defined"
            else
                echo "  ❌ Payment terms not clearly defined!"
                GATE_FAILED=1
            fi

            # 3. Down payment confirmation is a HARD BLOCKER for client projects
            # Must be an explicit [x] DP line AND state a clearing/received/transfer status
            # M1 (the DP line) must be ticked AND the receipt status must appear on the
            # same line: grep already matches line-by-line, so '.*' is the correct
            # same-line wildcard. Do NOT use '[^\n]*' — in POSIX ERE that is a negated
            # class of the LETTER n, so 'DP received in bank account' failed purely
            # because 'bank' contains an n. (Latent since the gate was written; the
            # status word had to precede every n-containing word to pass.)
            # The template's own confirmation line reads
            #   "- [ ] DP (Milestone 1) received in bank account - Date/Time: ... - Confirmed By: NAME"
            # so the tick and the status sit on ONE line. The old check wanted "[x]" in a line about
            # DP and "[x]" in a line about "Received" - two different lines - which no faithfully
            # ticked contract can satisfy. Also require a real date, not YYYY-MM-DD.
            m03_dp_line=$(grep -iE "^[[:space:]]*-?[[:space:]]*\[x\][^\n]*(DP|Down Payment|Milestone 1)" "$target_sow" 2>/dev/null | head -1 || true)
            if [ -n "$m03_dp_line" ] && \
               printf '%s' "$m03_dp_line" | grep -qiE "(Cleared|Received|Masuk|Lunas|Transferred|Settled|Bank Confirmed|Transfer Confirmed)" && \
               printf '%s' "$m03_dp_line" | grep -qE "[0-9]{4}-[0-9]{2}-[0-9]{2}" && \
               ! printf '%s' "$m03_dp_line" | grep -qE "YYYY-MM-DD|NAME|Rp X"; then
                echo "  ✅ Down payment (DP) confirmation verified ([x] cleared & received in bank account)"
            else
                echo "  ❌ Down payment (DP) not confirmed! Requires '[x] DP ... Cleared/Received/Transferred' (discussion-only or unchecked lines do NOT count)."
                GATE_FAILED=1
            fi

            # 4. Single PIC is a HARD BLOCKER
            if grep -qi "Single PIC" "$target_sow"; then
                echo "  ✅ Single PIC clause present"
            else
                echo "  ❌ Single PIC clause missing!"
                GATE_FAILED=1
            fi

            # 5. Deemed Acceptance is a HARD BLOCKER
            if grep -qiE "Deemed Acceptance|Klien Diam" "$target_sow"; then
                echo "  ✅ Deemed acceptance clause verified (Anti-ghosting protection)"
            else
                echo "  ❌ Deemed acceptance clause (7-day feedback limit) missing in SOW contract!"
                GATE_FAILED=1
            fi

            # 6. Limitation of Liability is a HARD BLOCKER
            if grep -qiE "Limitation of Liability|Liability Cap" "$target_sow"; then
                echo "  ✅ Limitation of liability clause present"
            else
                echo "  ❌ Limitation of liability clause missing in SOW contract!"
                GATE_FAILED=1
            fi

            # 7. Revision Limits clause is a HARD BLOCKER (solo dev anti infinite-revision trap)
            if grep -qiE "Revision Limit|Maximum\s+[0-9]+\s+round|Maximum\s+[0-9]+\s+test cycle|[0-9]+\s+rounds\b|[0-9]+\s+cycles\b" "$target_sow"; then
                echo "  ✅ Revision limits clause present (design/UAT rounds capped)"
            else
                echo "  ❌ Revision limits clause missing! Cap design revisions & UAT cycles to prevent infinite revision traps."
                GATE_FAILED=1
            fi

            # 8. Third-Party Account Ownership is a HARD BLOCKER (client-owned infrastructure)
            if grep -qiE "Third-Party (Subscriptions|Accounts)|Client corporate name|registered under the Client|Client credit card|billed directly to the Client" "$target_sow"; then
                echo "  ✅ Third-party account ownership clause present (client-owned infrastructure)"
            else
                echo "  ❌ Third-party account ownership clause missing! Cloud/hosting/gateway accounts MUST be registered under the Client."
                GATE_FAILED=1
            fi

            # 9. IP Ownership clause (source code retention until 100% paid)
            if grep -qiE "Intellectual Property|IP Ownership|Hak Cipta|property of the Developer until|ownership.*transfers.*upon.*full" "$target_sow"; then
                echo "  ✅ Intellectual Property (IP) ownership retention clause present"
            else
                echo "  ❌ Intellectual Property (IP) clause missing! Developer retains IP until 100% milestone paid."
                GATE_FAILED=1
            fi

            # 9b. Signature completeness (BLOCKER). The gate checked every clause but never
            #     whether anyone signed: a SOW whose signature block was a page of blank
            #     "Name: ____" / "Signature: ____" lines passed. It cannot verify a signature is
            #     authentic, but it can refuse an unsigned document.
            sig_lines=$(grep -cE "^[[:space:]]*(Signature|Signed)[[:space:]]*:" "$target_sow" 2>/dev/null || true)
            sig_blank=$(grep -cE "^[[:space:]]*(Signature|Signed|Name|Title|Date)[[:space:]]*:[[:space:]]*(_+|-+|\.+|\[[[:space:]]*\][[:space:]]*)?$" "$target_sow" 2>/dev/null || true)
            # A model may draft the contract, never be a party to it. Same rule as the NDA check
            # above and as M09/M10/M11/A00/A01/A04.
            m03_model='(claude|chatgpt|gpt[-_.0-9]|openai|anthropic|copilot|gemini|deepseek|llama|bard|ai agent|llm)'
            m03_model_signer=$(grep -iE "^[[:space:]]*(Signature|Signed|Signed by|Name|Party)[[:space:]]*:" "$target_sow" 2>/dev/null \
                | grep -iE "$m03_model" | head -2 || true)
            if [ -n "$m03_model_signer" ]; then
                echo "  ❌ The SOW names a model as a signing party - the agent may draft the contract, never sign it."
                printf '%s\n' "$m03_model_signer" | sed 's/^/       /' | cut -c1-110
                GATE_FAILED=1
            fi
            # Both parties must sign, each with a human name and a real date. A contract signed on
            # one side only is not a contract; a date left as YYYY-MM-DD is not a date.
            m03_human_sigs=0
            m03_no_date=""
            for party in DEVELOPER CLIENT "Solo Dev" "Klien" "Client" "Developer"; do
                block=$(awk -v who="$party" '
                    BEGIN { IGNORECASE = 1 }
                    $0 ~ ("^[#*[:space:]]*" who "[[:space:]]*$") { inside = 1; next }
                    inside && (/^#{1,4} / || $0 ~ "^[#*[:space:]]*(DEVELOPER|CLIENT|Solo Dev|Client|Developer|Klien)[[:space:]]*$") { inside = 0 }
                    inside { print }
                ' "$target_sow" 2>/dev/null)
                [ -n "$block" ] || continue
                # One-line signature blocks carry several fields, so take everything after "Name:"
                # up to the next field label.
                name=$(printf '%s' "$block" | grep -iE "^[[:space:]]*Name[[:space:]]*:" | head -1 \
                    | sed -E 's/.*[Nn]ame[[:space:]]*:[[:space:]]*//' \
                    | sed -E 's/[[:space:]]{2,}.*$//' | tr -d '*')
                date=$(printf '%s' "$block" | grep -oE "[0-9]{4}-[0-9]{2}-[0-9]{2}" | head -1 || true)
                [ -z "$name" ] && continue
                printf '%s' "$name" | grep -qiE "$m03_model" && continue
                if printf '%s' "$date" | grep -qE "[0-9]{4}-[0-9]{2}-[0-9]{2}" || printf '%s' "$date" | grep -qiE "[0-9]{1,2}[[:space:]]*(jan|feb|mar|apr|may|jun|jul|aug|sep|oct|nov|dec)"; then
                    m03_human_sigs=$((m03_human_sigs + 1))
                else
                    m03_no_date="$m03_no_date [$party:$date]"
                fi
            done
            if [ -n "$m03_no_date" ]; then
                echo "  ❌ A party signed the SOW without a date$m03_no_date"
                echo "     Replace the date field with the day it was signed; an undated signature is contestable."
                GATE_FAILED=1
            fi
            if [ "${m03_human_sigs:-0}" -lt 2 ]; then
                echo "  ❌ The SOW is signed by ${m03_human_sigs:-0} human part(y/ies); both DEVELOPER and CLIENT must sign with a name and a date."
                GATE_FAILED=1
            else
                echo "  ✅ Signed by both parties, each with a human name and a date"
            fi
            if [ "${sig_lines:-0}" -eq 0 ]; then
                echo "  ❌ No signature block in the SOW — an unsigned contract is not a contract."
                echo "     Add 'Signature: <name>' and 'Date: <YYYY-MM-DD>' for both parties."
                GATE_FAILED=1
            elif [ "${sig_blank:-0}" -gt 0 ]; then
                echo "  ❌ Signature block has ${sig_blank} blank line(s) (Name/Title/Date/Signature left empty)."
                echo "     Record who signed and when; '${sig_blank}' empty fields means nobody did."
                GATE_FAILED=1
            else
                echo "  ✅ Signature block completed (no blank Name/Title/Date/Signature fields)"
            fi

            # 9c. Clause substance floor (BLOCKER). Named clauses were matched by keyword only, so
            #     'Limitation of Liability: Capped at fees paid.' satisfied a clause that is meant
            #     to limit exposure. A word floor cannot judge quality, but it rejects a stub.
            # An unbounded promise is the one thing a solo developer cannot sign. The clause
            # length test above proves nobody wrote a stub; this proves nobody wrote a blank
            # cheque. A negation on the same line ("does not have unlimited rights") is allowed.
            # Negation only counts when it directly precedes the promise, e.g. "does not grant unlimited
            # rights". A bare "limit" or "maximum" elsewhere on the line was swallowing real promises.
            m03_neg='(not|never|no)[[:space:]]+[a-z]*[[:space:]]*(exceed|grant|provide|cover|include|accept|offer|apply|be liable)'
            m03_unbounded=""
            while IFS= read -r ln; do
                [ -z "$ln" ] && continue
                printf '%s' "$ln" | grep -qiE "$m03_neg" && continue
                printf '%s' "$ln" | grep -qiE '(bug[- ]free|perfectly (secure|reliable|error[- ]free)|will never (fail|crash|break)|guaranteed (to be )?(bug|error))' \
                    && m03_unbounded="$m03_unbounded [absolute software guarantee]"
                printf '%s' "$ln" | grep -qiE '(unlimited|forever|lifetime|perpetual|indefinite)[^.]*(support|maintenance|warranty|revision|fix)' \
                    && m03_unbounded="$m03_unbounded [unbounded support/warranty]"
                printf '%s' "$ln" | grep -qiE '(unlimited liability|any and all damages|no limit on liability|unlimited indemnity|hold harmless against all)' \
                    && m03_unbounded="$m03_unbounded [unlimited liability]"
            done <<< "$(sed 's/\\*//g' "$target_sow" 2>/dev/null)"
            if [ -n "$m03_unbounded" ]; then
                echo "  ❌ The SOW promises something without a bound:$m03_unbounded"
                echo "     Cap it: a number of days for warranty, 'limited to fees paid' for liability, 'excludes indirect loss'."
                GATE_FAILED=1
            fi
            # A warranty with no duration is unbounded in time even if it never says "forever".
            if grep -qiE "warrant" "$target_sow" 2>/dev/null; then
                if ! grep -qiE "[0-9]+[[:space:]]*(calendar[[:space:]]+)?days?" "$target_sow" 2>/dev/null; then
                    echo "  ❌ The SOW offers a warranty but names no duration in days."
                    echo "     State the window explicitly, e.g. '30 calendar days from BAST'."
                    GATE_FAILED=1
                fi
            fi

            thin=""
            # The clause may be a numbered heading ("### II.7. Limitation of Liability"), a bullet
            # ("- **Revision Limits**:" with sub-bullets) or a plain line. The old pattern required
            # the clause at the start of the line after optional #/*, so none of the shipped SOW's
            # clauses matched and every one scored 0 words - failing a complete contract.
            for clause in "Limitation of Liability" "Intellectual Property" "Revision Limits" "Deemed Acceptance" "Third.Party (Account|Subscription)"; do
                cl_words=$(awk -v pat="$clause" '
                    BEGIN { IGNORECASE = 1 }
                    $0 ~ pat && !started { started = 1; inside = 1 }
                    inside { n += split($0, a, " "); body++ }
                    inside && /^#/ && body > 1 { inside = 0 }
                    END { print n + 0 }
                ' "$target_sow" 2>/dev/null)
                [ "${cl_words:-0}" -lt 25 ] && thin="$thin [${clause}:${cl_words}w]"
            done
            if [ -n "$thin" ]; then
                echo "  ❌ Clause(s) present by name but too thin to protect anyone (need >= 25 words):$thin"
                echo "     A one-line 'capped at fees paid' is not a limitation-of-liability clause."
                GATE_FAILED=1
            else
                echo "  ✅ Required clauses have substance (>= 25 words each)"
            fi

            # 10. Enterprise scale requires approved Risk Assessment Matrix & RACI Matrix
            if [ "$(get_field Scale docs/pm/PROJECT_STATE.md | tr '[:upper:]' '[:lower:]')" = "enterprise" ]; then
                echo "  [INFO] Enterprise scale detected: Risk Assessment Matrix & RACI Matrix MANDATORY in M03."
                check_required "docs/governance/RISK_ASSESSMENT_MATRIX.md" "docs/pm/RISK_REGISTER.md" 500
                check_required "docs/governance/RACI_MATRIX.md" "docs/pm/RACI_MATRIX.md" 500
            fi
        fi
        echo ""
        echo "⚠️  DO NOT proceed to M04 until DP confirmed in bank account (or bypassed for Solo SaaS)"
    fi
}
