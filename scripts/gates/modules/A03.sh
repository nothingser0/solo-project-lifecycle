#!/usr/bin/env bash
# Gate: A03 — extracted from validate-gate.sh (verbatim body).
# Sourced by the dispatcher; do NOT execute directly.
# Shared helpers (check_required/check_optional/check_intake_gate/...) come
# from ../lib/checks.sh, which the dispatcher sources before this file.

# --- gate_A03 ------------------------------------------------------
gate_A03() {
    echo "=== A03: Vendor Procurement & Build-vs-Buy Evaluation Checklist ==="
    check_required "docs/procurement/VENDOR_PROCUREMENT_SCHEDULE.md" "docs/specs/VENDOR_PROCUREMENT_SCHEDULE.md" 800
    check_required "docs/governance/VENDOR_COMPARISON_MATRIX.md" "docs/pm/VENDOR_COMPARISON_MATRIX.md" 500
}
