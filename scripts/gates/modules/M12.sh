#!/usr/bin/env bash
# Gate: M12 — extracted from validate-gate.sh (verbatim body).
# Sourced by the dispatcher; do NOT execute directly.
# Shared helpers (check_required/check_optional/check_intake_gate/...) come
# from ../lib/checks.sh, which the dispatcher sources before this file.

# --- gate_M12 ------------------------------------------------------
gate_M12() {
    echo "=== M12: Warranty SLA Retainer Gate Checklist ==="
    is_m12_solo=0
    m12_delivery="$(get_field Delivery docs/pm/PROJECT_STATE.md | tr '[:upper:]' '[:lower:]')"
    # The M00_LITE/PROJECT_LITE infer-solo fallback is REMOVED, matching M03/M09/M11:
    # a missing PROJECT_STATE.md must FAIL for an undeclared delivery, not silently
    # route a client project to the solo waiver.
    if [ "$m12_delivery" = "solo" ] || [ "$m12_delivery" = "portfolio" ] || [ "$m12_delivery" = "internal" ]; then
        is_m12_solo=1
    fi

    if [ $is_m12_solo -eq 1 ]; then
        echo "  [INFO] Solo/Internal project detected: RUNBOOK_OPS.md accepted in place of WARRANTY_POLICY.md"
        check_required "docs/pm/RUNBOOK_OPS.md" "docs/pm/WARRANTY_POLICY.md" 500
        m12_runbook="docs/pm/RUNBOOK_OPS.md"
        [ -f "$m12_runbook" ] || m12_runbook="docs/pm/WARRANTY_POLICY.md"
        if [ -f "$m12_runbook" ]; then
            # Byte count is not a runbook: "Operations are handled as needed" repeated filled it.
            for need in "health|uptime|monitor" "backup|restore|snapshot" "log|metric|trace|sentry" "alert|notif|on-call|on call"; do
                if ! grep -qiE "$need" "$m12_runbook"; then
                    echo "  ❌ $m12_runbook is missing $(echo "$need" | cut -d'|' -f1)-level detail - a runbook must say how the service is watched and restored."
                    GATE_FAILED=1
                fi
            done
            if grep -qiE "(handled as needed|deal with it when|as needed|we will handle)" "$m12_runbook"; then
                echo "  ❌ $m12_runbook defers operations instead of defining them."
                GATE_FAILED=1
            fi
        fi
    else
        check_required "docs/pm/WARRANTY_POLICY.md" "docs/pm/WARRANTY_POLICY_SMALL.md" 500
        target_wp="docs/pm/WARRANTY_POLICY.md"
        [ -f "$target_wp" ] || target_wp="docs/pm/WARRANTY_POLICY_SMALL.md"

        # Content verification for WARRANTY_POLICY.md (BLOCKER)
        if [ -f "$target_wp" ]; then
            wp_content=$(cat "$target_wp" 2>/dev/null || true)
            # 1. Reject unresolved template placeholders [...]
            if echo "$wp_content" | grep -qE "\[Application Name\]|\[Client Company|\[Your Name\]|\[PROJECT_ID\]|\[YYYY-MM-DD\]|\[email-support"; then
                echo "  ❌ $target_wp still contains unresolved template placeholders ([...])! Fill in actual warranty terms."
                GATE_FAILED=1
            fi
            # 2. Require core section headings: Coverage, Exclusions, and SLA
            check_sections "$target_wp" "Coverage" "Exclusion" "Service Level Agreement"
            check_section_content "$target_wp" "Coverage" "Exclusion" "Service Level Agreement"

            # 3. A heading is not a policy. Each core section must carry real content, and the SLA
            #    must state figures: "To be discussed" under Coverage, or an SLA with the matrix
            #    deleted and "agreed per issue" in its place, both passed this gate.
            # A section ends at the next heading of the SAME or HIGHER level. Treating every heading
            # as a boundary threw away all content once the shipped template used ### subsections,
            # and the official WARRANTY_POLICY_SMALL.md was then reported as empty.
            m12_section() { # $1 = heading keyword, $2 = file
                awk -v pat="$1" '                    /^#+[[:space:]]/ {
                        lvl = match($0, /[^#]/)          # index of first non-# = level+1
                        if (keep == 0 && tolower($0) ~ tolower(pat)) { keep = 1; base = lvl; print; next }
                        if (keep == 1 && lvl <= base) { keep = 0 }
                    }
                    keep { print }' "$2" 2>/dev/null | grep -vE "^#"
            }
            for sec in "Coverage" "Exclusion" "Service Level Agreement"; do
                body=$(m12_section "$sec" "$target_wp")
                substance=$(printf '%s\n' "$body" | sed 's/^[[:space:]]*//' | grep -vE '^$|^-{3,}$|^:$' | wc -l)
                if [ "$substance" -lt 2 ]; then
                    echo "  ❌ $target_wp '$sec' section is empty - a heading with no terms is not a policy."
                    GATE_FAILED=1
                elif printf '%s\n' "$body" | grep -qiE "(to be (discussed|determined|decided)|TBD|akan dibahas|belum ditentukan|as needed|will be agreed)"; then
                    echo "  ❌ $target_wp '$sec' section defers its own terms instead of stating them."
                    GATE_FAILED=1
                fi
            done
            # 4. A warranty window that already closed protects nothing. Measured with an end date
            #    a year in the past: the policy passed every other check.
            # The shipped templates label these "**End Date**" / "**Warranty End Date**", and the
            # small one states a duration ("30 days after handover") rather than a date, so both
            # forms are read: a date is compared with today, a duration is accepted as a window.
            m12_end_line=$(grep -iE "(Warranty )?End Date" "$target_wp" | head -1)
            m12_end=$(printf '%s' "$m12_end_line" | grep -oE "[0-9]{4}-[0-9]{2}-[0-9]{2}" | head -1)
            m12_start=$(grep -iE "(Warranty )?Start Date" "$target_wp" | head -1 \
                | grep -oE "[0-9]{4}-[0-9]{2}-[0-9]{2}" | head -1)
            m12_duration=0
            [ -z "$m12_end" ] && printf '%s' "$m12_end_line" | grep -qiE "[0-9]+[[:space:]]*(day|days|month|months|week|weeks)[[:space:]]+(after|from)" && m12_duration=1
            today=$(date -u +%Y-%m-%d)
            if [ -z "$m12_end" ] && [ "$m12_duration" -eq 0 ]; then
                echo "  ❌ $target_wp states no warranty end - neither a date nor a duration ('30 days after handover')."
                GATE_FAILED=1
            elif [ -n "$m12_end" ] && [ "$m12_end" \< "$today" ]; then
                echo "  ❌ $target_wp warranty ended on $m12_end, before today ($today) - an expired policy covers nothing."
                GATE_FAILED=1
            elif [ -n "$m12_start" ] && [ "$m12_end" \< "$m12_start" ]; then
                echo "  ❌ $target_wp warranty ends ($m12_end) before it starts ($m12_start)."
                GATE_FAILED=1
            fi
            sla_body=$(m12_section "Service Level Agreement" "$target_wp")
            if [ -n "$sla_body" ] && ! printf '%s\n' "$sla_body" | grep -qiE "([0-9]+[[:space:]]*(hour|hr|hours|minute|min|minute?s|day|days|week|weeks)|<[[:space:]]*[0-9]+)"; then
                echo "  ❌ $target_wp SLA states no response or resolution time - 'agreed per issue' is not a service level."
                GATE_FAILED=1
            fi
        fi
    fi
    check_optional "docs/pm/SLA_RETAINER_CONTRACT.md" "contracts/SLA_RETAINER.md"
    # For Large scale, emergency incident response plan is MANDATORY
    m12_scale="$(get_field Scale docs/pm/PROJECT_STATE.md | tr '[:upper:]' '[:lower:]')"
    if [ "$m12_scale" = "large" ] || [ "$m12_scale" = "enterprise" ]; then
        echo "  [INFO] Large / Enterprise scale detected: Incident Response Plan is MANDATORY."
        check_required "docs/pm/INCIDENT_RESPONSE.md" "docs/INCIDENT_RESPONSE.md" 500
        ir_file="docs/pm/INCIDENT_RESPONSE.md"
        [ -f "$ir_file" ] || ir_file="docs/INCIDENT_RESPONSE.md"
        if [ -f "$ir_file" ]; then
            # An incident plan needs a severity scale somebody defined, an escalation path with
            # names, response time targets, and a communication channel. "We will handle it" has
            # none of those and passed at Large scale.
            for req in "severity|SEV[0-9]|P[0-9][[:space:]]|priority" "escalat|on-call|on call|contact" "response time|SLA|within[[:space:]]+[0-9]+[[:space:]]*(hour|hr|minute|min)" "communicat|status page|notify"; do
                if ! grep -qiE "$req" "$ir_file"; then
                    echo "  ❌ $ir_file is missing $(echo "$req" | cut -d'|' -f1)-level detail - an incident plan without it is an intention."
                    GATE_FAILED=1
                fi
            done
            if grep -qiE "(we will handle|handle it when|deal with it later|as needed)" "$ir_file"; then
                echo "  ❌ $ir_file defers incident handling instead of defining it."
                GATE_FAILED=1
            fi
            if grep -qiE "(signed by|approved by|owner)[[:space:]]*:" "$ir_file" | grep -qiE "(claude|chatgpt|gpt[0-9._-]*|openai|anthropic|copilot|gemini|llama|assistant|agent|bot|llm|ai assistant)"; then
                echo "  ❌ $ir_file names a model as its owner - the agent may draft it, never own incident response."
                GATE_FAILED=1
            fi
        fi
    else
    check_optional "docs/pm/INCIDENT_RESPONSE.md" "docs/INCIDENT_RESPONSE.md"
    fi
}
