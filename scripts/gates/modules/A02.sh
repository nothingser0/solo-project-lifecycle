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
            stride_hits=0
            for cat in Spoofing Tampering Repudiation "Information Disclosure" "Denial of Service" "Elevation of Privilege"; do
                grep -qi "$cat" "$sec_target" && stride_hits=$((stride_hits + 1))
            done
            if [ "$stride_hits" -lt 3 ]; then
                echo "  ❌ $sec_target names $stride_hits of the 6 STRIDE categories - a threat model covering fewer than 3 has not been done."
                GATE_FAILED=1
            else
                echo "  ✅ Threat model covers $stride_hits/6 STRIDE categories"
            fi
            if ! grep -qE "^\|[^-|].*\|" "$sec_target"; then
                echo "  ❌ $sec_target contains no threat table rows - 'none found' is not a threat model."
                GATE_FAILED=1
            fi
        fi
    fi
}
