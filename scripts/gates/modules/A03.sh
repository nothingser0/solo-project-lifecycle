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

    local sched_target="docs/procurement/VENDOR_PROCUREMENT_SCHEDULE.md"
    [ -f "$sched_target" ] || sched_target="docs/specs/VENDOR_PROCUREMENT_SCHEDULE.md"
    if [ -f "$sched_target" ]; then
        if grep -qE "\[Client Company|\[Your Name\]|\[Project Name\]|\[YYYY-MM-DD\]" "$sched_target"; then
            echo "  ❌ $sched_target still contains unresolved template placeholders ([...])!"
            GATE_FAILED=1
        fi
        check_sections "$sched_target" "Procurement Scope" "Timeline" "Requirements" || true
    fi

    local matrix_target="docs/governance/VENDOR_COMPARISON_MATRIX.md"
    [ -f "$matrix_target" ] || matrix_target="docs/pm/VENDOR_COMPARISON_MATRIX.md"
    if [ -f "$matrix_target" ]; then
        if grep -qE "\[Client Company|\[Your Name\]|\[Project Name\]|\[YYYY-MM-DD\]" "$matrix_target"; then
            echo "  ❌ $matrix_target still contains unresolved template placeholders ([...])!"
            GATE_FAILED=1
        fi
        check_sections "$matrix_target" "Comparison Framework" "Decision Matrix" "Recommendation" || true
    fi
}
