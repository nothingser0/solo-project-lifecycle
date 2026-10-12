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
}
