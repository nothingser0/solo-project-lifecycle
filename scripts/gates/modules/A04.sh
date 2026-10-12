#!/usr/bin/env bash
# Gate: A04 — extracted from validate-gate.sh (verbatim body).
# Sourced by the dispatcher; do NOT execute directly.
# Shared helpers (check_required/check_optional/check_intake_gate/...) come
# from ../lib/checks.sh, which the dispatcher sources before this file.

# --- gate_A04 ------------------------------------------------------
gate_A04() {
    echo "=== A04: Governance Handover & Architecture Conformance Retainer Checklist ==="
    check_required "docs/governance/GOVERNANCE_HANDOVER_PACK.md" "docs/pm/GOVERNANCE_HANDOVER_PACK.md" 1000
}
