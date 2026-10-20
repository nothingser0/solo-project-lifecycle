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
        check_sections "$target" "RACI" "CAB" "Disaster Recovery" || true
    fi
}
