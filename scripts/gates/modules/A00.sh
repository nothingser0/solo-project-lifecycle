#!/usr/bin/env bash
# Gate: A00 — extracted from validate-gate.sh (verbatim body).
# Sourced by the dispatcher; do NOT execute directly.
# Shared helpers (check_required/check_optional/check_intake_gate/...) come
# from ../lib/checks.sh, which the dispatcher sources before this file.

# --- gate_A00 ------------------------------------------------------
gate_A00() {
    echo "=== A00: Bid/No-Bid & Commercial Clearance Checklist ==="
    check_required "contracts/CONSULTING_AGREEMENT.md" "docs/pm/CONSULTING_AGREEMENT.md" 1000
    local target="contracts/CONSULTING_AGREEMENT.md"
    [ -f "$target" ] || target="docs/pm/CONSULTING_AGREEMENT.md"
    if [ -f "$target" ]; then
        if grep -qE "\[Client Company|\[Your Name\]|\[PT / CV|\[YYYY-MM-DD\]" "$target"; then
            echo "  ❌ $target still contains unresolved template placeholders ([...])!"
            GATE_FAILED=1
        fi
        check_sections "$target" "Parties" "Advisory Deliverables" "Professional Fees" "Liability" || true
    fi
    check_optional "docs/pm/RFP_RESPONSE.md"
}
