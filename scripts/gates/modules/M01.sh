#!/usr/bin/env bash
# Gate: M01 — extracted from validate-gate.sh (verbatim body).
# Sourced by the dispatcher; do NOT execute directly.
# Shared helpers (check_required/check_optional/check_intake_gate/...) come
# from ../lib/checks.sh, which the dispatcher sources before this file.

# --- gate_M01 ------------------------------------------------------
gate_M01() {
    echo "=== M01: Idea Feasibility Gate Checklist ==="

    # 1. Automatic waiver for Small Scale (handled via Intake Gate + PROJECT_LITE.md).
    #    The waiver skips the BRIEF only. It must never skip the solo-capacity
    #    classifier below: a self-declared "small" tier is exactly how a 20-P0
    #    project with sensitive data used to pass this gate (High-Water Mark rule).
    is_m01_waived=0
    if is_small_scale; then
        echo "  [INFO] Small Scale detected: M01 Idea Feasibility is WAIVED (Handled by Intake Gate & PROJECT_LITE)."
        is_m01_waived=1
    fi

    # 2. Solo Capacity Classifier / High-Water Mark — EVERY scale, waived or not.
    check_scale_feasibility || true

    if [ $is_m01_waived -eq 1 ]; then
        # Small path: neither brief is required, but confirm the lite spec exists (root or docs/specs/).
        local lite_target="PROJECT_LITE.md"
        [ -f "$lite_target" ] || lite_target="docs/specs/PROJECT_LITE.md"
        check_optional "docs/pm/IDEA_BRIEF.md" "$lite_target"
    else
        # PROJECT_STATE.md carries the scale decision and every Intake answer, so a
        # non-Small run must fail without it. check_intake_gate only fails on a
        # MISSING state file for Small projects (where it is their sole record), so
        # without this line an undeclared-scale project with a brief passed the gate.
        check_required "docs/pm/PROJECT_STATE.md" "" 200

        # 3. Brief resolution: IDEA_BRIEF.md, or the FEASIBILITY_REPORT.md alias.
        #    When both exist the more complete one wins (a stub must not shadow a
        #    filled report); check_feasibility_brief sets BRIEF_FILE.
        check_feasibility_brief || true

        if [ -n "$BRIEF_FILE" ] && [ -f "$BRIEF_FILE" ]; then
            # 3a. Reject template placeholders [...]
            if grep -q "\[\.\.\.\]\|\[Example:\|\[Your Name\]\|\[Direct Comp\|\[Adjacent Comp\|\[Segment 1:\|Rp \[X\]" "$BRIEF_FILE"; then
                echo "  ❌ Unresolved template placeholders [...] detected in $BRIEF_FILE!"
                GATE_FAILED=1
            fi

            # 3b. Feasibility-Decision. Two accepted forms, stored in one value:
            #       Feasibility-Decision: GO          (machine field)
            #       - [x] **CONDITIONAL_GO**          (checkbox in the scorecard)
            #     Normalised to GO | CONDITIONAL_GO | PIVOT | KILL | PROVISIONAL_*.
            #     Recognising PROVISIONAL matters: docs/modules/01_IDEA_FEASIBILITY.md
            #     instructs the agent to HOLD at PROVISIONAL_PENDING_M00 when M00 is
            #     PENDING_PRIMARY_RESEARCH. It used to fall through to the generic
            #     "not declared" error, hiding a legitimate halt state.
            decision_raw=""
            if grep -qiE "^[[:space:]]*-?[[:space:]]*\**Feasibility-Decision\**:" "$BRIEF_FILE"; then
                decision_raw=$(grep -iE "^[[:space:]]*-?[[:space:]]*\**Feasibility-Decision\**:" "$BRIEF_FILE" \
                    | head -1 | sed 's/.*:[[:space:]]*//' | tr -d '*\r')
            else
                # Form 2: a ticked checkbox — only "[x]" counts, "[ ]" is untouched.
                decision_raw=$(grep -iE "^[[:space:]]*-[[:space:]]*\[[xX]\][[:space:]]*\**" "$BRIEF_FILE" 2>/dev/null \
                    | grep -oiE "(CONDITIONAL[ _]GO|GO|PIVOT|KILL|PROVISIONAL[A-Z_]*)" | head -1)
                # Form 3: a bare bold declaration, e.g. "**GO**".
                [ -n "$decision_raw" ] || decision_raw=$(grep -oE "\*\*(CONDITIONAL[ _]GO|GO|PIVOT|KILL|PROVISIONAL[A-Z_]*)\*\*" "$BRIEF_FILE" 2>/dev/null | head -1 | tr -d '*')
            fi
            decision_normalised=$(echo "$decision_raw" | tr '[:lower:]' '[:upper:]' | tr ' ' '_' | tr -d '\r')
            case "$decision_normalised" in
                GO|CONDITIONAL_GO|PIVOT|KILL) ;;
                PROVISIONAL*) decision_normalised="PROVISIONAL" ;;
                *) decision_normalised="" ;;
            esac

            if [ -z "$decision_normalised" ]; then
                echo "  ❌ Explicit Feasibility-Decision (GO | CONDITIONAL_GO | PIVOT | KILL) not declared!"
                GATE_FAILED=1
            else
                case "$decision_normalised" in
                    KILL)
                        echo "  ❌ Gate status: KILL (Fatal single-point blocker; project terminated)"
                        GATE_FAILED=1
                        ;;
                    PIVOT)
                        echo "  ❌ Gate status: PIVOT (Idea feasibility rejected; return to M00 or restructure scope)"
                        GATE_FAILED=1
                        ;;
                    PROVISIONAL)
                        echo "  ⚠️  Gate status: PROVISIONAL_PENDING_M00 — M00 primary research is not complete."
                        echo "     The gate is NOT passed: score provisionally, run the M00 research (interviews / waitlist), then re-run."
                        GATE_VERDICT="PROVISIONAL_PENDING_M00"
                        ;;
                    *)
                        echo "  ✅ Feasibility decision verified: $decision_normalised"
                        ;;
                esac
            fi

            # 3c. Dimension Floor & Score Integrity. All 4 dimensions REQUIRED,
            #     numeric, 1.0-5.0, each >= 3.0. Field form is bold-tolerant and
            #     rejects a leading minus (a score must never be parsed as negative).
            dim_ok=1
            dim_sum=0
            for dim in Technical Operational Regulatory Financial; do
                # Reject unedited placeholder form [3.0 - 5.0]
                if grep -qiE "^[[:space:]]*-?[[:space:]]*\**Feasibility-Score-${dim}\**:[[:space:]]*\[" "$BRIEF_FILE"; then
                    echo "  ❌ Feasibility-Score-${dim} still holds an unedited placeholder!"
                    dim_ok=0
                    GATE_FAILED=1
                    continue
                fi
                dim_val=$(grep -iE "^[[:space:]]*-?[[:space:]]*\**Feasibility-Score-${dim}\**:[[:space:]]*[0-9]" "$BRIEF_FILE" 2>/dev/null \
                    | grep -oE "[0-9]+(\.[0-9]+)?" | head -1 || echo "")
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
                # 3d. Decision/average consistency, fail-closed in BOTH directions:
                #     average < 3.5 must be CONDITIONAL_GO; average >= 3.5 declared as
                #     CONDITIONAL_GO must carry its mitigation plan (M01 sends
                #     CONDITIONAL_GO onward to M02, so the plan has to exist here).
                if [ "$(awk -v a="$dim_avg" 'BEGIN { print (a < 3.5) ? 1 : 0 }')" -eq 1 ]; then
                    if [ "$decision_normalised" = "GO" ]; then
                        echo "  ❌ Decision mismatch: average $dim_avg < 3.5 requires 'CONDITIONAL_GO', not 'GO'"
                        GATE_FAILED=1
                    fi
                elif [ "$decision_normalised" = "CONDITIONAL_GO" ]; then
                    if grep -qiE "Mitigation[[:space:]]*:|Mitigasi[[:space:]]*:" "$BRIEF_FILE"; then
                        echo "  ✅ CONDITIONAL_GO mitigation plan recorded"
                    else
                        echo "  ❌ CONDITIONAL_GO at average $dim_avg requires an explicit mitigation plan ('Mitigation: ...' in $BRIEF_FILE)."
                        GATE_FAILED=1
                    fi
                fi
            fi
        fi
    fi

    # 4. Intake Gate (ALL scales — the ONLY gate Small projects have, since
    #    M00/M01/M02 are waived). Runs OUTSIDE the is_m01_waived branch.
    check_intake_gate || true
}
