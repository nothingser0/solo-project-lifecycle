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
        check_sections "$arch_target" "C4" "Data Residency" "Scenario" || true
    fi

    local sec_target="docs/security/THREAT_MODEL_STRIDE.md"
    [ -f "$sec_target" ] || sec_target="docs/specs/THREAT_MODEL.md"
    if [ -f "$sec_target" ]; then
        if grep -qE "\[Client Company|\[Your Name\]|\[Project Name\]|\[YYYY-MM-DD\]" "$sec_target"; then
            echo "  ❌ $sec_target still contains unresolved template placeholders ([...])!"
            GATE_FAILED=1
        fi
        check_sections "$sec_target" "STRIDE" "Mitigation" || true
    fi
}
