#!/usr/bin/env bash
# Gate: A04 — extracted from validate-gate.sh (verbatim body).
# Sourced by the dispatcher; do NOT execute directly.
# Shared helpers (check_required/check_optional/check_intake_gate/...) come
# from ../lib/checks.sh, which the dispatcher sources before this file.

# --- gate_A04 ------------------------------------------------------
gate_A04() {
    echo "=== A04: Governance Handover & Architecture Conformance Retainer Checklist ==="
    check_required "docs/governance/GOVERNANCE_HANDOVER_PACK.md" "docs/pm/GOVERNANCE_HANDOVER_PACK.md" 1000

    local target="docs/governance/GOVERNANCE_HANDOVER_PACK.md"
    [ -f "$target" ] || target="docs/pm/GOVERNANCE_HANDOVER_PACK.md"
    if [ -f "$target" ]; then
        if grep -qE "\[Client Company|\[Your Name\]|\[Project Name\]|\[YYYY-MM-DD\]" "$target"; then
            echo "  ❌ $target still contains unresolved template placeholders ([...])!"
            GATE_FAILED=1
        fi
        check_sections "$target" "RACI" "CAB" "Disaster Recovery"

        # A RACI whose only row is "Everything | TBD" assigns nothing. Require at least three
        # rows, at least one accountable owner, and no placeholder owner.
        raci_block=$(sed -n '/[#]*.*RACI/,/^#[#]\{0,2\}[[:space:]]/p' "$target" 2>/dev/null || true)
        [ -n "$raci_block" ] || raci_block=$(sed -n '/[#]*.*RACI/,$p' "$target" 2>/dev/null || true)
        raci_rows=$(echo "$raci_block" | grep -cE "^\|[^-|][^|]*\|" || true)
        raci_rows=${raci_rows:-0}
        if [ "$raci_rows" -lt 3 ]; then
            echo "  ❌ $target RACI has $raci_rows row(s) - fewer than three assigns nothing."
            GATE_FAILED=1
        fi
        if echo "$raci_block" | grep -qiE "\|[[:space:]]*(TBD|TODO|XXX|\?+|n/a|_____)[[:space:]]*\|"; then
            echo "  ❌ $target RACI assigns a role to TBD/placeholder - the accountability is unassigned."
            GATE_FAILED=1
        fi
        if ! echo "$raci_block" | grep -qiE "\|[[:space:]]*A[[:space:]]*\||accountable"; then
            echo "  ❌ $target RACI has no Accountable owner - a governance pack with nobody accountable is not governance."
            GATE_FAILED=1
        fi

        # Disaster recovery without a stated recovery time and recovery point is an intention.
        dr_block=$(sed -n '/[#]*.*Disaster Recovery/,/^#[#]\{0,2\}[[:space:]]/p' "$target" 2>/dev/null || true)
        [ -n "$dr_block" ] || dr_block=$(sed -n '/[#]*.*Disaster Recovery/,$p' "$target" 2>/dev/null || true)
        if [ -n "$dr_block" ]; then
            if ! echo "$dr_block" | grep -qiE "RTO|recovery time"; then
                echo "  ❌ $target Disaster Recovery states no RTO (recovery time objective) - 'we have backups' is not a recovery plan."
                GATE_FAILED=1
            fi
            if ! echo "$dr_block" | grep -qiE "RPO|recovery point"; then
                echo "  ❌ $target Disaster Recovery states no RPO (recovery point objective) - how much data loss is acceptable is unstated."
                GATE_FAILED=1
            fi
        fi

        # Same signing rule as M09/M10/M11/A00.
        if grep -iE "(signed by|signed|approved by)[[:space:]]*:" "$target" | grep -qiE "(claude|chatgpt|gpt[0-9._-]*|openai|anthropic|copilot|gemini|llama|assistant|agent|bot|llm|ai assistant)"; then
            echo "  ❌ $target names a model as the signing party - the agent may draft the handover pack, never sign it."
            GATE_FAILED=1
        fi
    fi
}
