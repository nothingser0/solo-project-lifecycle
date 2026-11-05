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
        check_sections "$sched_target" "Procurement Scope" "Timeline" "Requirements"
    fi

    local matrix_target="docs/governance/VENDOR_COMPARISON_MATRIX.md"
    [ -f "$matrix_target" ] || matrix_target="docs/pm/VENDOR_COMPARISON_MATRIX.md"
    if [ -f "$matrix_target" ]; then
        if grep -qE "\[Client Company|\[Your Name\]|\[Project Name\]|\[YYYY-MM-DD\]" "$matrix_target"; then
            echo "  ❌ $matrix_target still contains unresolved template placeholders ([...])!"
            GATE_FAILED=1
        fi
        check_sections "$matrix_target" "Comparison Framework" "Decision Matrix" "Recommendation"

        if [ -f "$matrix_target" ]; then
            # A decision matrix with no scored rows decides nothing.
            # grep -c already prints 0 and exits 1 on no match, so "|| echo 0" appended a second
            # line and made the comparison below mismatch - the gate printed "has 0 scored rows"
            # as a pass and never failed.
            m03_rows=$(grep -cE "^\|[^-|][^|]*\|.*[0-9]" "$matrix_target" 2>/dev/null | head -1 | tr -dc '0-9')
            m03_rows=${m03_rows:-0}
            if [ "${m03_rows:-0}" -lt 2 ]; then
                echo "  ❌ $matrix_target has ${m03_rows} scored row(s) - a comparison needs at least two scored vendors."
                GATE_FAILED=1
            else
                echo "  ✅ Decision matrix has ${m03_rows} scored row(s)"
            fi
            # The recommendation must name a vendor that appears in the matrix, otherwise the
            # document recommends something it never compared.
            rec_line=$(grep -iA2 "## Recommendation" "$matrix_target" | grep -vE "Recommendation|--" | head -1)
            if [ -n "$rec_line" ]; then
                rec_named=0
                for vendor in $(grep -E "^\|[^-|][^|]*\|" "$matrix_target" | sed -E 's/^\|[[:space:]]*([^|]*).*/\1/' | tr -d '*' | sort -u); do
                    [ -z "$vendor" ] && continue
                    echo "$rec_line" | grep -qiF "$vendor" && rec_named=1
                done
                if [ "$rec_named" -eq 0 ]; then
                    echo "  ❌ $matrix_target recommends a vendor that appears in no matrix row - the recommendation is not backed by the comparison."
                    GATE_FAILED=1
                fi
            fi
        fi
    fi
}
