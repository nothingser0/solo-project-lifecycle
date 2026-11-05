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
