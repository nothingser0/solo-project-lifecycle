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

        a03_section() { # $1 keyword, $2 file
            awk -v pat="$1" '                /^#+[[:space:]]/ {
                    lvl = match($0, /[^#]/)
                    if (keep == 0 && tolower($0) ~ tolower(pat)) { keep = 1; base = lvl; next }
                    if (keep == 1 && lvl <= base) { keep = 0 }
                }
                keep { print }' "$2" 2>/dev/null
        }
        for sec in "Procurement Scope" "Timeline" "Requirements"; do
            n=$(a03_section "$sec" "$sched_target" | sed 's/^[[:space:]]*//' | grep -vE '^$|^-{3,}$|^#' | wc -l)
            if [ "$n" -lt 1 ]; then
                echo "  ❌ $sched_target '$sec' section is empty - a heading is not a procurement plan."
                GATE_FAILED=1
            fi
        done
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
            # Vendor names live in the COLUMN HEADERS ("| Requirement | Midtrans | Xendit | Adyen |"),
            # not the first column, and the old rec_line filter dropped the line it wanted because
            # that line contains the word "Recommendation". Both halves are fixed here.
            rec_body=$(a03_section "Recommendation" "$matrix_target" | sed 's/^[[:space:]]*//' | grep -vE '^$|^-{3,}$|^#')
            if [ -z "$rec_body" ]; then
                echo "  ❌ $matrix_target has no recommendation - a comparison that decides nothing is not a decision aid."
                GATE_FAILED=1
            else
                # Vendors appear in the header row of EVERY comparison table, and the shipped
                # template keeps a schematic example ("Vendor A | Vendor B") next to the real one
                # (Stripe | PayPal | Adyen). Read every header row, not only the first.
                vendors=$(awk '/^[[:space:]]*\|/ && !/^[[:space:]]*\|[[:space:]]*:/ { print }' "$matrix_target" \
                          | tr '|' '\n' | sed 's/^[[:space:]]*//; s/[[:space:]]*$//' | tr -d '*' \
                          | grep -viE "^(|requirement|requirements|criteria|item|weight|score|stage|element|id|aspect|feature|#|total|result|winner)$" \
                          | grep -viE "^(vendor|option)[[:space:]]+[A-Z]$" \
                          | grep -viE "^(yes|no|true|false|pass|fail|n/a|nil|-)$" \
                          | grep -E "^[A-Za-z][A-Za-z0-9&.' -]{2,}$" \
                          | grep -vE "^[0-9]" | sort -u)
                rec_named=0
                while IFS= read -r vendor; do
                    [ -z "$vendor" ] && continue
                    printf '%s\n' "$rec_body" | grep -qiF -- "$vendor" && rec_named=1
                done <<< "$vendors"
                if [ "$rec_named" -eq 0 ]; then
                    echo "  ❌ $matrix_target recommends a vendor that appears in no comparison column - the recommendation is not backed by the comparison."
                    GATE_FAILED=1
                else
                    echo "  ✅ Recommendation names a vendor from the comparison"
                fi
            fi
        fi
    fi
}
