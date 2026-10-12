#!/usr/bin/env bash
# Gate: A00 — extracted from validate-gate.sh (verbatim body).
# Sourced by the dispatcher; do NOT execute directly.
# Shared helpers (check_required/check_optional/check_intake_gate/...) come
# from ../lib/checks.sh, which the dispatcher sources before this file.

# --- gate_A00 ------------------------------------------------------
gate_A00() {
    echo "=== A00: Bid/No-Bid & Commercial Clearance Checklist ==="
    check_required "contracts/CONSULTING_AGREEMENT.md" "docs/pm/CONSULTING_AGREEMENT.md" 1000
    check_optional "docs/pm/RFP_RESPONSE.md"
}
