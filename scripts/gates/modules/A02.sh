#!/usr/bin/env bash
# Gate: A02 — extracted from validate-gate.sh (verbatim body).
# Sourced by the dispatcher; do NOT execute directly.
# Shared helpers (check_required/check_optional/check_intake_gate/...) come
# from ../lib/checks.sh, which the dispatcher sources before this file.

# --- gate_A02 ------------------------------------------------------
gate_A02() {
    echo "=== A02: C4 Enterprise Architecture & STRIDE Threat Modeling Checklist ==="
    check_required "docs/architecture/ENTERPRISE_ARCHITECTURE_BLUEPRINT.md" "docs/specs/ARCHITECTURE_BLUEPRINT.md" 1000
    check_required "docs/security/THREAT_MODEL_STRIDE.md" "docs/specs/THREAT_MODEL.md" 1000

    local arch_target="docs/architecture/ENTERPRISE_ARCHITECTURE_BLUEPRINT.md"
    [ -f "$arch_target" ] || arch_target="docs/specs/ARCHITECTURE_BLUEPRINT.md"
    if [ -f "$arch_target" ]; then
        if grep -qE "\[Client Company|\[Your Name\]|\[Project Name\]|\[YYYY-MM-DD\]" "$arch_target"; then
            echo "  ❌ $arch_target still contains unresolved template placeholders ([...])!"
            GATE_FAILED=1
        fi
        check_sections "$arch_target" "C4" "Data Residency" "Scenario"

        a02_section() { # $1 keyword, $2 file  -> body without headings, same-or-higher heading ends it
            awk -v pat="$1" '                /^#+[[:space:]]/ {
                    lvl = match($0, /[^#]/)
                    if (keep == 0 && tolower($0) ~ tolower(pat)) { keep = 1; base = lvl; next }
                    if (keep == 1 && lvl <= base) { keep = 0 }
                }
                keep { print }' "$2" 2>/dev/null
        }

        for sec in "C4" "Data Residency" "Scenario"; do
            body=$(a02_section "$sec" "$arch_target")
            n=$(printf '%s\n' "$body" | sed 's/^[[:space:]]*//' | grep -vE '^$|^-{3,}$' | wc -l)
            if [ "$n" -lt 1 ]; then
                echo "  ❌ $arch_target '$sec' section is empty - a heading is not architecture."
                GATE_FAILED=1
            fi
        done

        # "The system should feel fast" is not a quality attribute scenario without a figure.
        scen=$(a02_section "Scenario" "$arch_target")
        if [ -n "$scen" ] && ! printf '%s\n' "$scen" | grep -qE "[0-9]"; then
            echo "  ❌ $arch_target quality scenario states no measurable target (no number anywhere in the section)."
            GATE_FAILED=1
        fi

        # A residency section that names no region or country says nothing about residency.
        resid=$(a02_section "Data Residency" "$arch_target")
        if [ -n "$resid" ] && ! printf '%s\n' "$resid" | grep -qiE "jakarta|indonesia|singapore|asia/|region|country|zone|dc-|eu-|us-"; then
            echo "  ❌ $arch_target Data Residency names no region, zone or country."
            GATE_FAILED=1
        fi
    fi

    local sec_target="docs/security/THREAT_MODEL_STRIDE.md"
    [ -f "$sec_target" ] || sec_target="docs/specs/THREAT_MODEL.md"
    if [ -f "$sec_target" ]; then
        if grep -qE "\[Client Company|\[Your Name\]|\[Project Name\]|\[YYYY-MM-DD\]" "$sec_target"; then
            echo "  ❌ $sec_target still contains unresolved template placeholders ([...])!"
            GATE_FAILED=1
        fi
        check_sections "$sec_target" "STRIDE" "Mitigation"

        # A threat model whose STRIDE section says "none found" is a document with no threats,
        # which is the one thing a threat model cannot be. Require >=3 STRIDE categories named
        # and at least one mitigation row.
        if [ -f "$sec_target" ]; then
            # The categories must be ROWS of the threat table. Grepping the whole file let a
            # sentence ("Spoofing and Tampering were considered") count as coverage, and the
            # trust-boundary table satisfied the old "any table row" test.
            stride_rows=$(awk -v pat="STRIDE" '
                /^#+[[:space:]]/ {
                    lvl = match($0, /[^#]/)
                    if (keep == 0 && tolower($0) ~ tolower(pat)) { keep = 1; base = lvl; next }
                    if (keep == 1 && lvl <= base) { keep = 0 }
                }
                keep && /^[[:space:]]*\|/ { print }' "$sec_target" 2>/dev/null)
            # The shipped template writes the letter code in its own column ("| `P01` | S |"), and the
            # long names appear in the header row only, so matching names alone rejected the template.
            stride_hits=0
            for pair in "Spoofing:S" "Tampering:T" "Repudiation:R" "Information Disclosure:I" "Denial of Service:D" "Elevation of Privilege:E"; do
                name="${pair%:*}"; code="${pair##*:}"
                if printf '%s\n' "$stride_rows" | grep -qiE "\|[[:space:]]*\**[\`]?${code}[\`]?\**[[:space:]]*\|" \
                   || printf '%s\n' "$stride_rows" | grep -qi "$name"; then
                    stride_hits=$((stride_hits + 1))
                fi
            done
            if [ "$stride_hits" -lt 3 ]; then
                echo "  ❌ $sec_target has $stride_hits of the 6 STRIDE categories as threat-table rows - a threat model covering fewer than 3 has not been done."
                GATE_FAILED=1
            else
                echo "  ✅ Threat model covers $stride_hits/6 STRIDE categories as rows"
            fi
            # Threat IDs are "T-S-P01-001" in the shipped template, not "T01".
            if ! printf '%s\n' "$stride_rows" | grep -qE "\|[[:space:]]*\**[\`]?T[-0-9][^|]*\|"; then
                echo "  ❌ $sec_target has no threat row inside the STRIDE section - a trust-boundary table is not a threat model."
                GATE_FAILED=1
            fi
            # A mitigation section with no rows leaves every threat unanswered.
            mit_rows=$(awk -v pat="Mitigation" '
                /^#+[[:space:]]/ {
                    lvl = match($0, /[^#]/)
                    if (keep == 0 && tolower($0) ~ tolower(pat)) { keep = 1; base = lvl; next }
                    if (keep == 1 && lvl <= base) { keep = 0 }
                }
                keep { print }' "$sec_target" 2>/dev/null | sed 's/^[[:space:]]*//' | grep -vE '^$|^-{3,}$|^#' | wc -l)
            if [ "$mit_rows" -lt 1 ]; then
                echo "  ❌ $sec_target Mitigation section is empty - every named threat needs an answer."
                GATE_FAILED=1
            fi
        fi
    fi
}
