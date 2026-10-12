#!/usr/bin/env bash
# Gate: M03 — extracted from validate-gate.sh (verbatim body).
# Sourced by the dispatcher; do NOT execute directly.
# Shared helpers (check_required/check_optional/check_intake_gate/...) come
# from ../lib/checks.sh, which the dispatcher sources before this file.

# --- gate_M03 ------------------------------------------------------
gate_M03() {
    echo "=== M03: Legal SOW & Charter Checklist ==="
    target_sow="contracts/SOW_CONTRACT.md"
    [ -f "$target_sow" ] || target_sow="docs/pm/SOW_CONTRACT.md"
    [ -f "$target_sow" ] || target_sow="contracts/SOW_SMB.md"
    [ -f "$target_sow" ] || target_sow="docs/pm/SOW_SMB.md"
    
    IS_SOLO=0
    # F4: STRICT DELIVERY ROUTING — read Delivery from ITS OWN field line only.
    # A stray "Delivery: solo" in prose must NEVER waive a client project, and the
    # M00_LITE.md-presence infer-solo fallback is REMOVED (missing SOW must FAIL
    # for an undeclared delivery, not silently pass).
    m03_delivery="$(get_field Delivery docs/pm/PROJECT_STATE.md | tr '[:upper:]' '[:lower:]')"
    if [ "$m03_delivery" = "solo" ] || [ "$m03_delivery" = "portfolio" ] || [ "$m03_delivery" = "internal" ]; then
        IS_SOLO=1
    elif [ "$m03_delivery" = "client" ]; then
        IS_SOLO=0 # Client delivery NEVER bypasses SOW regardless of scale
    else
        IS_SOLO=0 # Undeclared delivery: gate is enforced (fail-closed)
    fi

    if [ $IS_SOLO -eq 1 ]; then
        echo "  [INFO] Solo SaaS / Internal project detected: Commercial SOW gate is WAIVED."
        check_optional "contracts/SOW_CONTRACT.md" "docs/pm/SOW_CONTRACT.md"
    else
        # Accept standard SOW_CONTRACT or simplified SOW_SMB
        if [ -f "contracts/SOW_SMB.md" ] || [ -f "docs/pm/SOW_SMB.md" ]; then
            check_required "contracts/SOW_SMB.md" "docs/pm/SOW_SMB.md" 1000
        else
            check_required "contracts/SOW_CONTRACT.md" "docs/pm/SOW_CONTRACT.md" 1000
        fi

        # NDA is mandatory for Medium+ client delivery; optional for Small client
        is_small_client=0
        if is_small_scale; then
            is_small_client=1
        fi
        if [ $is_small_client -eq 1 ]; then
            check_optional "contracts/NDA.md" "docs/pm/NDA.md"
        else
            echo "  [INFO] Medium+ client delivery: NDA is MANDATORY before client data access."
            check_required "contracts/NDA.md" "docs/pm/NDA.md" 500
        fi
        if [ -f "$target_sow" ]; then
            # A2: core section headings must be present (SOW_SMB vs consolidated SOW layout)
            if grep -qiE "^#{1,6}[[:space:]]*.*Statement of Work" "$target_sow" 2>/dev/null; then
                check_sections "$target_sow" "Project Overview" "Scope of Work" "Payment Terms" "Change Request"
            else
                check_sections "$target_sow" "Identification of Parties" "Scope of Work" "Compensation" "Change Request"
            fi
            # 1. Check unresolved placeholders [...]
            if grep -q "\[\.\.\.\]\|\[Numeric Amount\]\|\[Account Number\]" "$target_sow"; then
                echo "  ❌ Unresolved template placeholders [...] detected in SOW contract!"
                GATE_FAILED=1
            fi

            # 2. Payment terms & milestones
            if grep -qiE "Termin|Milestone.*Payment|Down Payment|DP|30/40/30|50/50" "$target_sow"; then
                echo "  ✅ Payment terms & milestone schedule defined"
            else
                echo "  ❌ Payment terms not clearly defined!"
                GATE_FAILED=1
            fi

            # 3. Down payment confirmation is a HARD BLOCKER for client projects
            # Must be an explicit [x] DP line AND state a clearing/received/transfer status
            if grep -qiE "\[x\][^\n]*(DP|Down Payment|30%|40%|50%)" "$target_sow" && \
               grep -qiE "\[x\][^\n]*(Cleared|Received|Masuk|Lunas|Transferred|Settled|Bank Confirmed|Transfer Confirmed)" "$target_sow"; then
                echo "  ✅ Down payment (DP) confirmation verified ([x] cleared & received in bank account)"
            else
                echo "  ❌ Down payment (DP) not confirmed! Requires '[x] DP ... Cleared/Received/Transferred' (discussion-only or unchecked lines do NOT count)."
                GATE_FAILED=1
            fi

            # 4. Single PIC is a HARD BLOCKER
            if grep -qi "Single PIC" "$target_sow"; then
                echo "  ✅ Single PIC clause present"
            else
                echo "  ❌ Single PIC clause missing!"
                GATE_FAILED=1
            fi

            # 5. Deemed Acceptance is a HARD BLOCKER
            if grep -qiE "Deemed Acceptance|Klien Diam" "$target_sow"; then
                echo "  ✅ Deemed acceptance clause verified (Anti-ghosting protection)"
            else
                echo "  ❌ Deemed acceptance clause (7-day feedback limit) missing in SOW contract!"
                GATE_FAILED=1
            fi

            # 6. Limitation of Liability is a HARD BLOCKER
            if grep -qiE "Limitation of Liability|Liability Cap" "$target_sow"; then
                echo "  ✅ Limitation of liability clause present"
            else
                echo "  ❌ Limitation of liability clause missing in SOW contract!"
                GATE_FAILED=1
            fi

            # 7. Revision Limits clause is a HARD BLOCKER (solo dev anti infinite-revision trap)
            if grep -qiE "Revision Limit|Maximum\s+[0-9]+\s+round|Maximum\s+[0-9]+\s+test cycle|[0-9]+\s+rounds\b|[0-9]+\s+cycles\b" "$target_sow"; then
                echo "  ✅ Revision limits clause present (design/UAT rounds capped)"
            else
                echo "  ❌ Revision limits clause missing! Cap design revisions & UAT cycles to prevent infinite revision traps."
                GATE_FAILED=1
            fi

            # 8. Third-Party Account Ownership is a HARD BLOCKER (client-owned infrastructure)
            if grep -qiE "Third-Party (Subscriptions|Accounts)|Client corporate name|registered under the Client|Client credit card|billed directly to the Client" "$target_sow"; then
                echo "  ✅ Third-party account ownership clause present (client-owned infrastructure)"
            else
                echo "  ❌ Third-party account ownership clause missing! Cloud/hosting/gateway accounts MUST be registered under the Client."
                GATE_FAILED=1
            fi

            # 9. Enterprise scale requires approved Risk Assessment Matrix & RACI Matrix
            if [ "$(get_field Scale docs/pm/PROJECT_STATE.md | tr '[:upper:]' '[:lower:]')" = "enterprise" ]; then
                echo "  [INFO] Enterprise scale detected: Risk Assessment Matrix & RACI Matrix MANDATORY in M03."
                check_required "docs/governance/RISK_ASSESSMENT_MATRIX.md" "docs/pm/RISK_REGISTER.md" 500
                check_required "docs/governance/RACI_MATRIX.md" "docs/pm/RACI_MATRIX.md" 500
            fi
        fi
        echo ""
        echo "⚠️  DO NOT proceed to M04 until DP confirmed in bank account (or bypassed for Solo SaaS)"
    fi
}
