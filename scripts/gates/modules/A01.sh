#!/usr/bin/env bash
# Gate: A01 — extracted from validate-gate.sh (verbatim body).
# Sourced by the dispatcher; do NOT execute directly.
# Shared helpers (check_required/check_optional/check_intake_gate/...) come
# from ../lib/checks.sh, which the dispatcher sources before this file.

# --- gate_A01 ------------------------------------------------------
gate_A01() {
    echo "=== A01: WBS Phasing & Domain Decomposition Checklist ==="
    check_required "docs/pm/WBS_PHASING_PLAN.md" "" 1000
}
