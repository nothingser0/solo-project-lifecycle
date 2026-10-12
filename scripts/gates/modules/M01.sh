#!/usr/bin/env bash
# Gate: M01 — extracted from validate-gate.sh (verbatim body).
# Sourced by the dispatcher; do NOT execute directly.
# Shared helpers (check_required/check_optional/check_intake_gate/...) come
# from ../lib/checks.sh, which the dispatcher sources before this file.

# --- gate_M01 ------------------------------------------------------
gate_M01() {
    echo "=== M01: Idea Feasibility Gate Checklist ==="
    # 1. Automatic waiver for Small Scale (handled via Intake Gate + PROJECT_LITE.md)
    is_m01_waived=0
    if is_small_scale; then
        echo "  [INFO] Small Scale detected: M01 Idea Feasibility is WAIVED (Handled by Intake Gate & PROJECT_LITE)."
        is_m01_waived=1
    fi

    if [ $is_m01_waived -eq 1 ]; then
        check_optional "docs/pm/IDEA_BRIEF.md" "PROJECT_LITE.md"
    else
        check_required "docs/pm/IDEA_BRIEF.md" "docs/pm/FEASIBILITY_REPORT.md" 1000
        check_required "docs/pm/PROJECT_STATE.md" "" 200

        # 2. Execute Solo Capacity Classifier (High-Water Mark enforcement)
        # F1b: resolve via SCRIPT_DIR — the gate runs from the PROJECT dir, where scripts/ does not exist.
        if [ -f "$SCRIPT_DIR/classify-scale.sh" ]; then
            echo "  [INFO] Running mechanical scale & solo capacity classifier..."
            classify_output=$(bash "$SCRIPT_DIR/classify-scale.sh" 2>&1) || classify_exit=$?
            classify_exit=${classify_exit:-0}
            if [ "$classify_exit" -eq 2 ]; then
                echo "  ❌ SOLO CAPACITY GATE TRIGGERED: Project exceeds solo developer capacity!"
                echo "$classify_output" | sed "s/^/    /"
                GATE_FAILED=1
            else
                echo "  ✅ Solo capacity verified: Scope is executable within solo capacity"
            fi
        fi

    # Target file resolution
    brief_file="docs/pm/IDEA_BRIEF.md"
    [ -f "$brief_file" ] || brief_file="docs/pm/FEASIBILITY_REPORT.md"

    if [ -f "$brief_file" ]; then
        # 1. Reject template placeholders [...]
        if grep -q "\[\.\.\.\]\|\[Example:\|\[Your Name\]\|\[Direct Comp\|\[Adjacent Comp\|\[Segment 1:\|Rp \[X\]" "$brief_file"; then
            echo "  ❌ Unresolved template placeholders [...] detected in $brief_file!"
            GATE_FAILED=1
        fi

        # 2. Blocking Feasibility Decision check
        if grep -qiE "^Feasibility-Decision:\s*KILL|\[x\]\s*\*\*KILL\*\*" "$brief_file"; then
            echo "  ❌ Gate status: KILL (Fatal single-point blocker; project terminated)"
            GATE_FAILED=1
        elif grep -qiE "^Feasibility-Decision:\s*PIVOT|\[x\]\s*\*\*PIVOT\*\*" "$brief_file"; then
            echo "  ❌ Gate status: PIVOT (Idea feasibility rejected; return to M00 or restructure scope)"
            GATE_FAILED=1
        elif grep -qiE "^Feasibility-Decision:\s*(GO|CONDITIONAL_GO)|\[x\]\s*\*\*(GO|CONDITIONAL GO)\*\*" "$brief_file"; then
            echo "  ✅ Feasibility decision verified: GO / CONDITIONAL_GO"
        else
            echo "  ❌ Explicit Feasibility-Decision (GO | CONDITIONAL_GO | PIVOT | KILL) not declared!"
            GATE_FAILED=1
        fi

        # 3. Dimension Floor & Score Integrity (all 4 dimensions REQUIRED, numeric, range 1.0-5.0, each >= 3.0)
        dim_ok=1
        dim_sum=0
        for dim in Technical Operational Regulatory Financial; do
            # Reject unedited placeholder form [3.0 - 5.0]
            if grep -qiE "^Feasibility-Score-${dim}:\s*\[" "$brief_file"; then
                echo "  ❌ Feasibility-Score-${dim} still holds an unedited placeholder!"
                dim_ok=0
                GATE_FAILED=1
                continue
            fi
            dim_val=$(grep -iE "^Feasibility-Score-${dim}:\s*[0-9]" "$brief_file" | grep -oE "[0-9]+(\.[0-9]+)?" | head -1 || echo "")
            if [ -z "$dim_val" ]; then
                echo "  ❌ Missing numeric Feasibility-Score-${dim} (all 4 dimensions required, 1.0-5.0)"
                dim_ok=0
                GATE_FAILED=1
                continue
            fi
            if [ "$(awk -v v="$dim_val" 'BEGIN { print (v >= 1.0 && v <= 5.0) ? 1 : 0 }')" -ne 1 ]; then
                echo "  ❌ Feasibility-Score-${dim} out of range: $dim_val (must be 1.0-5.0)"
                dim_ok=0
                GATE_FAILED=1
                continue
            fi
            if [ "$(awk -v v="$dim_val" 'BEGIN { print (v < 3.0) ? 1 : 0 }')" -eq 1 ]; then
                echo "  ❌ Dimension Floor Failure: ${dim} = $dim_val (< 3.0)"
                dim_ok=0
                GATE_FAILED=1
                continue
            fi
            dim_sum=$(awk -v a="$dim_sum" -v b="$dim_val" 'BEGIN { print a + b }')
        done
        if [ $dim_ok -eq 1 ]; then
            dim_avg=$(awk -v s="$dim_sum" 'BEGIN { printf "%.2f", s / 4 }')
            echo "  ✅ Dimension Floor verified: all 4 dimensions >= 3.0 (average $dim_avg)"
            # 4. Decision/average consistency: average < 3.5 MUST be CONDITIONAL_GO, not GO
            decision=$(grep -iE "^Feasibility-Decision:\s*(GO|CONDITIONAL_GO)" "$brief_file" | grep -oiE "CONDITIONAL_GO|GO" | head -1 | tr '[:lower:]' '[:upper:]')
            if [ -n "$decision" ] && [ "$decision" = "GO" ]; then
                if [ "$(awk -v a="$dim_avg" 'BEGIN { print (a < 3.5) ? 1 : 0 }')" -eq 1 ]; then
                    echo "  ❌ Decision mismatch: average $dim_avg < 3.5 requires 'CONDITIONAL_GO', not 'GO'"
                    GATE_FAILED=1
                fi
            fi
        fi
    fi

    fi # end of is_m01_waived else branch

    # 4. Intake Gate (ALL scales — the ONLY gate Small projects have, since
    #    M00/M01/M02 are waived). Runs OUTSIDE the is_m01_waived branch.
    check_intake_gate || true
}
