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
        check_optional "docs/pm/SCOPE_STATEMENT.md" "PROJECT_LITE.md"
    else
        check_required "docs/pm/SCOPE_STATEMENT.md" "" 2000
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
        declared_scale=$(get_field Scale docs/pm/PROJECT_STATE.md | grep -oiE "small|medium|large|enterprise|solo-saas" | head -1)
        case "$declared_scale" in
            small)      lo=3; hi=7 ;;
            medium|solo-saas) lo=8; hi=15 ;;
            large)      lo=16; hi=25 ;;
            *)          lo=3; hi=25 ;;
        esac
        echo "  [INFO] Declared scale: ${declared_scale:-unknown}; P0 feature rows (F-xx) counted: $p0_count (expected $lo-$hi)"
        if [ "$p0_count" -lt "$lo" ] || [ "$p0_count" -gt "$hi" ]; then
            echo "  ❌ P0 Must-Have count ($p0_count) outside scale '$declared_scale' limits ($lo-$hi). Prune scope or re-classify scale."
            GATE_FAILED=1
        else
            echo "  ✅ P0 Must-Have count within scale limits"
        fi

        # 5. Confidence Legend check (BLOCKER)
        if grep -q "✅" "$scope" || grep -qi "VERIFIED" "$scope"; then
            echo "  ✅ Data Confidence Legend / status markers present"
        else
            echo "  ❌ Data Confidence Legend [✅ / 🔶 / ❓] not declared!"
            GATE_FAILED=1
        fi

        # 6. Out-of-Scope exclusions check (strictly scoped within Section 5.2)
        if grep -qi "out-of-scope" "$scope"; then
            oos_section=$(sed -n '/### 5\.2 Out-of-Scope/,/### 5\.3/p' "$scope" 2>/dev/null || true)
            oos_count=$(echo "$oos_section" | grep -cE "^\s*[0-9]+\.\s" || true)
            if [ "${oos_count:-0}" -ge 3 ]; then
                echo "  ✅ Explicit Out-of-Scope boundaries defined in Section 5.2 ($oos_count numbered exclusions)"
            else
                echo "  ❌ Section 5.2 Out-of-Scope requires >= 3 explicit numbered exclusions (found: ${oos_count:-0})"
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
