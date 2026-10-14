#!/usr/bin/env bash
# Gate: M13 — extracted from validate-gate.sh (verbatim body).
# Sourced by the dispatcher; do NOT execute directly.
# Shared helpers (check_required/check_optional/check_intake_gate/...) come
# from ../lib/checks.sh, which the dispatcher sources before this file.

# --- gate_M13 ------------------------------------------------------
gate_M13() {
    echo "=== M13: Product Operations & Iteration Gate Checklist ==="
    # M13 is a Continuous Product Loop for SELF-INITIATED products only.
    # Small Scale terminates at M12; Client delivery terminates at M11/M12.
    is_m13_waived=0
    m13_delivery="$(get_field Delivery docs/pm/PROJECT_STATE.md | tr '[:upper:]' '[:lower:]')"
    if [ "$m13_delivery" = "client" ] || [ "$m13_delivery" = "portfolio" ] || [ "$m13_delivery" = "internal" ]; then
        echo "  [INFO] Client/Internal/Portfolio delivery detected: M13 Product Iteration is WAIVED (lifecycle ends at M11/M12)."
        is_m13_waived=1
    elif is_small_scale; then
        echo "  [INFO] Small Scale detected: M13 Product Iteration is WAIVED (Fast-Track ends at M12)."
        is_m13_waived=1
    fi

    if [ $is_m13_waived -eq 1 ]; then
        check_optional "docs/analytics/METRICS_BASELINE_REPORT.md" "docs/pm/METRICS_BASELINE_REPORT.md"
    else
        check_required "docs/analytics/METRICS_BASELINE_REPORT.md" "docs/pm/METRICS_BASELINE_REPORT.md" 1000
        # Content verification for METRICS_BASELINE_REPORT.md (BLOCKER)
        metrics_target="docs/analytics/METRICS_BASELINE_REPORT.md"
        [ -f "$metrics_target" ] || metrics_target="docs/pm/METRICS_BASELINE_REPORT.md"
        if [ -f "$metrics_target" ]; then
            metrics_content=$(cat "$metrics_target" 2>/dev/null || true)
            # 1. Reject unresolved template placeholders [...]
            if echo "$metrics_content" | grep -qE "\[Product Name\]|\[Solo Developer Name\]|\[Start Date\]|\[number\]|\[X\]%|Rp \[amount\]"; then
                echo "  ❌ $metrics_target still contains unresolved template placeholders ([...])! Record actual baseline measurements."
                GATE_FAILED=1
            fi
            # 2. Require core metrics baseline dimensions (Acquisition, Activation, Retention)
            check_sections "$metrics_target" "Acquisition" "Activation" "Retention" || true
        fi
        # For Large scale, RICE-scored growth experiment backlog is MANDATORY
        m13_scale="$(get_field Scale docs/pm/PROJECT_STATE.md | tr '[:upper:]' '[:lower:]')"
        if [ "$m13_scale" = "large" ] || [ "$m13_scale" = "enterprise" ]; then
            echo "  [INFO] Large / Enterprise scale detected: Growth Experiments Backlog is MANDATORY."
            check_required "docs/pm/GROWTH_EXPERIMENTS_BACKLOG.md" "" 500
            # Reject unresolved template placeholders in growth experiments backlog
            if [ -f "docs/pm/GROWTH_EXPERIMENTS_BACKLOG.md" ]; then
                if grep -qE "\[Product Name\]|\[YYYY-MM-DD\]|\[Feature Name\]|\[Brief description\]" "docs/pm/GROWTH_EXPERIMENTS_BACKLOG.md"; then
                    echo "  ❌ docs/pm/GROWTH_EXPERIMENTS_BACKLOG.md still contains unresolved template placeholders ([...])!"
                    GATE_FAILED=1
                fi
                if grep -qiE "RICE[[:space:]]*Score|Reach[[:space:]]*×[[:space:]]*Impact|RICE[[:space:]]*Framework" "docs/pm/GROWTH_EXPERIMENTS_BACKLOG.md"; then
                    echo "  ✅ RICE scoring framework verified in Growth Experiments Backlog"
                else
                    echo "  ❌ docs/pm/GROWTH_EXPERIMENTS_BACKLOG.md missing RICE scoring framework!"
                    GATE_FAILED=1
                fi
            fi
        else
            check_optional "docs/pm/GROWTH_EXPERIMENTS_BACKLOG.md"
        fi
    fi
}
