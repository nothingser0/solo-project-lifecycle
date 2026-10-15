#!/usr/bin/env bash
# Gate: M02 — extracted from validate-gate.sh (verbatim body).
# Sourced by the dispatcher; do NOT execute directly.
# Shared helpers (check_required/check_optional/check_intake_gate/...) come
# from ../lib/checks.sh, which the dispatcher sources before this file.

# --- gate_M02 ------------------------------------------------------
gate_M02() {
    echo "=== M02: Discovery & Scope Gate Checklist ==="
    # 1. Automatic waiver for Small Scale (handled via Intake Gate + PROJECT_LITE.md)
    check_intake_gate || true
    is_m02_waived=0
    if is_small_scale; then
        echo "  [INFO] Small Scale detected: M02 Discovery & Scope is WAIVED (Handled by Intake Gate & PROJECT_LITE)."
        is_m02_waived=1
    fi

    # Solo-capacity / High-Water-Mark classifier. M02 is where P0 count is checked
    # against the declared scale, so it must apply the same ground truth as M01:
    # a project that declares "small" and prunes nothing would otherwise skip this
    # check entirely (Small waives the scope checklist by design).
    check_scale_feasibility || true

    if [ $is_m02_waived -eq 1 ]; then
        local lite_target="PROJECT_LITE.md"
        [ -f "$lite_target" ] || lite_target="docs/specs/PROJECT_LITE.md"
        check_optional "docs/pm/SCOPE_STATEMENT.md" "$lite_target"
    else
        check_required "docs/pm/SCOPE_STATEMENT.md" "" 2000
    check_sections "docs/pm/SCOPE_STATEMENT.md" "User Stories" "Acceptance Criteria"
    if [ "$(get_field Scale docs/pm/PROJECT_STATE.md | tr '[:upper:]' '[:lower:]')" = "enterprise" ]; then
        echo "  [INFO] Enterprise scale detected: RACI Matrix is MANDATORY."
        check_required "docs/governance/RACI_MATRIX.md" "docs/pm/RACI_MATRIX.md"
    fi
    if [ -f "docs/pm/SCOPE_STATEMENT.md" ]; then
        scope="docs/pm/SCOPE_STATEMENT.md"

        # 1. Reject unresolved template placeholders [...]
        if grep -q "\[\.\.\.\]\|\[Feature [0-9]\|\[Application / System Name\]" "$scope"; then
            echo "  ❌ Unresolved template placeholders [...] detected in SCOPE_STATEMENT.md!"
            GATE_FAILED=1
        fi

        # 2. Ambiguity detection on Must-Have rows
        if grep -iE "\|.*(must|p0).*\|" "$scope" | grep -qiE "TBD|maybe|if time permits|tentative|TBA"; then
            echo "  ❌ Ambiguous terms (TBD/maybe/if time permits) detected in Must-Have scope rows!"
            GATE_FAILED=1
        else
            echo "  ✅ Zero ambiguous terms in Must-Have scope rows"
        fi

        # 3. Scope-Lock-Decision verification (BLOCKER)
        if grep -qiE "^Scope-Lock-Decision:\s*PENDING" "$scope"; then
            echo "  ❌ Scope lock status: PENDING (Scope not frozen; M02 cannot be closed)"
            GATE_FAILED=1
        elif grep -qiE "^Scope-Lock-Decision:\s*LOCKED" "$scope"; then
            echo "  ✅ Scope lock decision verified: LOCKED"
        else
            echo "  ❌ Explicit Scope-Lock-Decision (LOCKED | PENDING) not declared in SCOPE_STATEMENT.md!"
            GATE_FAILED=1
        fi

        # 4. P0 feature count within scale limits (strictly count | **F-xx** | rows)
        p0_count=$(grep -iE "\|\s*\*\*F-[0-9]+\*\*\s*\|.*(must|p0)" "$scope" 2>/dev/null | wc -l || true)
        p0_count=$(echo "$p0_count" | tr -d ' ')
        # Lowercased like every other gate (M05/M07/M08/M10/M12/M13): `grep -o`
        # preserves input case, so without the tr a "Scale: Medium" project fell
        # through to the `*` fallback and the 8-15 / 16-25 bands were never enforced.
        # Spaces are folded to hyphens so "Solo SaaS" matches the solo-saas band.
        declared_scale=$(get_field Scale docs/pm/PROJECT_STATE.md \
            | grep -oiE "small|medium|large|enterprise|solo[ -]?saas" | head -1 \
            | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
        case "$declared_scale" in
            small)      lo=1;  hi=5 ;;
            medium|solo-saas) lo=6; hi=15 ;;
            large)      lo=16; hi=25 ;;
            # Enterprise (>25 P0) is out of solo capacity and routed to the A-Series
            # advisory (classify-scale.sh exit 2); M02 keeps the wide band rather
            # than inventing an upper limit it cannot validate.
            enterprise) lo=3;  hi=25 ;;
            *)          lo=3;  hi=25 ;;
        esac
        echo "  [INFO] Declared scale: ${declared_scale:-unknown}; P0 feature rows (F-xx) counted: $p0_count (expected $lo-$hi)"
        if [ "$p0_count" -lt "$lo" ] || [ "$p0_count" -gt "$hi" ]; then
            echo "  ❌ P0 Must-Have count ($p0_count) outside scale '$declared_scale' limits ($lo-$hi). Prune scope or re-classify scale."
            GATE_FAILED=1
        else
            echo "  ✅ P0 Must-Have count within scale limits"
        fi

        # 4b. Machine-field reconciliation: the declared `Scope-P0-Count` must be a
        # real number (the template ships the `[number]` placeholder, which the
        # [Feature N] regex above never caught) and must agree with the counted rows.
        declared_p0=$(grep -iE "^Scope-P0-Count:" "$scope" 2>/dev/null | head -1 \
            | sed 's/^[^:]*:[[:space:]]*//' | tr -d ' \r')
        if [ -z "$declared_p0" ]; then
            echo "  ❌ Missing 'Scope-P0-Count:' machine field in SCOPE_STATEMENT.md!"
            GATE_FAILED=1
        elif ! echo "$declared_p0" | grep -qE "^[0-9]+$"; then
            echo "  ❌ Scope-P0-Count is not a number ('$declared_p0') — replace the [number] placeholder."
            GATE_FAILED=1
        elif [ "$declared_p0" -ne "$p0_count" ]; then
            echo "  ❌ Scope-P0-Count ($declared_p0) disagrees with counted Must-Have rows ($p0_count)."
            GATE_FAILED=1
        else
            echo "  ✅ Scope-P0-Count ($declared_p0) reconciles with counted Must-Have rows"
        fi

        # 5. Confidence Legend check (BLOCKER)
        if grep -q "✅" "$scope" || grep -qi "VERIFIED" "$scope"; then
            echo "  ✅ Data Confidence Legend / status markers present"
        else
            echo "  ❌ Data Confidence Legend [✅ / 🔶 / ❓] not declared!"
            GATE_FAILED=1
        fi

        # 6. Out-of-Scope exclusions check
        if grep -qi "out-of-scope" "$scope"; then
            oos_section=$(sed -n '/[#]*.*[Oo]ut-[Oo]f-[Ss]cope/,/^[#]\{1,3\}[[:space:]]/p' "$scope" 2>/dev/null || true)
            [ -n "$oos_section" ] || oos_section=$(sed -n '/[#]*.*[Oo]ut-[Oo]f-[Ss]cope/,$p' "$scope" 2>/dev/null || true)
            oos_count=$(echo "$oos_section" | grep -cE "^\s*([0-9]+\.|-|\*)\s+" || true)
            if [ "${oos_count:-0}" -ge 3 ]; then
                echo "  ✅ Explicit Out-of-Scope boundaries defined ($oos_count exclusions)"
            else
                echo "  ❌ Out-of-Scope requires >= 3 explicit exclusions (found: ${oos_count:-0})"
                GATE_FAILED=1
            fi
        else
            echo "  ❌ Out-of-Scope boundary section missing!"
            GATE_FAILED=1
        fi

        # 7. RBAC Zero Self-Approval guardrail (Hard blocker on non-small projects)
        if grep -qiE "zero self-approval|no self-approval" "$scope"; then
            echo "  ✅ RBAC Zero Self-Approval guardrail present"
        else
            echo "  ❌ RBAC Zero Self-Approval guardrail (no self-approval for mutations/approvals) missing in SCOPE_STATEMENT.md!"
            GATE_FAILED=1
        fi

        # 8. Legal-text review marker (STEP 5). The agent may DRAFT the Privacy Policy,
        # ToS and tax disclaimers, but they are operational drafts, never legal advice:
        # publishing them unreviewed is a FROZEN-spec violation. Guarded to documents
        # that actually contain legal/tax text, so a scope statement without a legal
        # section is unaffected. The PENDING -> REVIEWED flip is the human's action.
        if grep -qiE "UU PDP|Privacy Policy|In-App Disclaimer|tidak menggantikan|Terms of Service" "$scope"; then
            if grep -qiE "LEGAL-REVIEW:" "$scope"; then
                echo "  ✅ Legal-text review marker present (LEGAL-REVIEW: ...)"
            else
                echo "  ❌ SCOPE_STATEMENT.md includes legal/tax text without a LEGAL-REVIEW marker!"
                echo "     Add 'LEGAL-REVIEW: PENDING — DRAFT TEKNIS, WAJIB DITINJAU ...' and keep it until counsel/pajak review."
                GATE_FAILED=1
            fi
        fi
    fi
    # 7. Company/team projects require STAKEHOLDER_MAP, COMMUNICATION_PLAN, RACI
    m02_delivery="$(get_field Delivery docs/pm/PROJECT_STATE.md | tr '[:upper:]' '[:lower:]')"
    if [ "$m02_delivery" = "client" ] || [ "$m02_delivery" = "internal" ]; then
        echo "  [INFO] Company/client delivery: Stakeholder & Communication docs MANDATORY."
        check_required "docs/pm/STAKEHOLDER_MAP.md" "" 500
        check_required "docs/pm/COMMUNICATION_PLAN.md" "" 500
    fi
    fi # end of is_m02_waived else
}
