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
            # Any bracket field left unfilled is an unresolved placeholder. The old version
            # matched eight hardcoded strings, so "[Direct Comp 1]", "[Segment 1: ...]" and
            # "[Your Name]" survived - and a faithfully filled brief still failed on the ones it
            # did list. Markdown links are stripped first so [label](url) is not flagged, and
            # checkbox cells are allowed because they are filled marks, not fields.
            m01_leftovers=$(sed -e 's/\[[^]]*\]([^)]*)//g' "$BRIEF_FILE" 2>/dev/null \
                | sed -E -e 's/^([[:space:]]*-[[:space:]]*)\[[xX ]\]/\1/g' \
                           -e 's/\|[[:space:]]*\[[xX ]\][[:space:]]*\|/|/g' \
                | grep -oE '\[[^]]+\]' | sort -u || true)
            if [ -n "$m01_leftovers" ]; then
                echo "  ❌ Unresolved template placeholders detected in $BRIEF_FILE:"
                printf '%s\n' "$m01_leftovers" | head -8 | sed 's/^/       /'
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

            # 3c-bis. Evidence binding (BLOCKER). A 4.0+ dimension is a claim of near-certainty,
            #     and the scorecard is where invented numbers do the most damage: a brief with no
            #     research at all can otherwise score 4.0 across the board and be declared GO.
            #     Confidence markers ([x]/[!]/[?]) are not checked - they are trivial to fake;
            #     a cited data point (N=, x/y, a measured loss) is not. A high score without one
            #     is forced down to 3.0, which makes GO (average >= 3.5) unreachable on vibes.
            if [ $dim_ok -eq 1 ]; then
                for dim in Technical Operational Regulatory Financial; do
                    dim_val=$(grep -iE "^[[:space:]]*-?[[:space:]]*\**Feasibility-Score-${dim}\**:[[:space:]]*[0-9]" "$BRIEF_FILE" 2>/dev/null \
                        | grep -oE "[0-9]+(\.[0-9]+)?" | head -1 || echo "")
                    [ -z "$dim_val" ] && continue
                    if [ "$(awk -v v="$dim_val" 'BEGIN { print (v >= 4.0) ? 1 : 0 }')" -ne 1 ]; then
                        continue
                    fi
                    ev_line=$(grep -iE "^[[:space:]]*-?[[:space:]]*\**Feasibility-Evidence-${dim}\**:[[:space:]]*.+" "$BRIEF_FILE" 2>/dev/null | head -1 || echo "")
                    ev_text=$(printf '%s' "$ev_line" | sed -E 's/^[^:]*:[[:space:]]*//')
                    if ! printf '%s' "$ev_text" | grep -qE 'N[[:space:]]*=[[:space:]]*[0-9]|[0-9]+[[:space:]]*/[[:space:]]*[0-9]+|[0-9]'; then
                        echo "  ❌ Feasibility-Score-${dim}: ${dim_val} claims near-certainty with no cited evidence"
                        echo "     Add 'Feasibility-Evidence-${dim}: <sample size, x/y observed, measured loss>' or lower the score to 3.0."
                        echo "     Score forced to 3.0 (GO requires average >= 3.5, so GO is now unreachable)."
                        dim_sum=$(awk -v a="$dim_sum" -v b="$dim_val" 'BEGIN { print a - b + 3.0 }')
                        EVIDENCE_FORCED=1
                    fi
                done
            fi

            if [ $dim_ok -eq 1 ]; then
                dim_avg=$(awk -v s="$dim_sum" 'BEGIN { printf "%.2f", s / 4 }')
                echo "  ✅ Dimension Floor verified: all 4 dimensions >= 3.0 (average $dim_avg)"
                # 3d. Decision/average consistency, fail-closed in BOTH directions:
                #     average < 3.5 must be CONDITIONAL_GO; average >= 3.5 declared as
                #     CONDITIONAL_GO must carry its mitigation plan (M01 sends
                #     CONDITIONAL_GO onward to M02, so the plan has to exist here).
                if [ "$(awk -v a="$dim_avg" 'BEGIN { print (a < 3.5) ? 1 : 0 }')" -eq 1 ] \
                   && [ "$decision_normalised" = "GO" ]; then
                    echo "  ❌ Decision mismatch: average $dim_avg < 3.5 requires 'CONDITIONAL_GO', not 'GO'"
                    GATE_FAILED=1
                fi
                # Independent of the average: CONDITIONAL_GO carries a plan or it does not
                # proceed. The label alone is not a plan - the template ships
                # "Mitigation: [required when the decision is CONDITIONAL_GO]", which the old
                # check called "recorded" and sent into M02 as an approved condition.
                if [ "$decision_normalised" = "CONDITIONAL_GO" ]; then
                    # The template carries two lines that start with the word: the blank field
                    # and the instruction that explains it. A founder appends the real plan at
                    # the end, so read the LAST occurrence, not the first.
                    m01_mitigation=$(grep -iE "^[[:space:]]*-?[[:space:]]*\**Mitigation\**[[:space:]]*:|^[[:space:]]*-?[[:space:]]*\**Mitigasi\**[[:space:]]*:" "$BRIEF_FILE" 2>/dev/null \
                        | grep -vE '[\[<]' | tail -1 | sed 's/.*:[[:space:]]*//' | tr -d '*\r')
                    m01_mitigation_ok=1
                    if [ -z "$m01_mitigation" ]; then
                        m01_mitigation_ok=0
                    elif printf '%s' "$m01_mitigation" | grep -qE '[\[<]'; then
                        m01_mitigation_ok=0     # still a template field
                    elif printf '%s' "$m01_mitigation" | grep -qiE '^(required when|tbd|todo|n/?a|none|—|-)$'; then
                        m01_mitigation_ok=0
                    elif [ "$(printf '%s' "$m01_mitigation" | tr -d ' ' | wc -c)" -lt 21 ]; then
                        m01_mitigation_ok=0     # under 20 characters is a label, not a plan
                    fi
                    if [ "$m01_mitigation_ok" -eq 1 ]; then
                        echo "  ✅ CONDITIONAL_GO mitigation plan recorded"
                    else
                        echo "  ❌ CONDITIONAL_GO at average $dim_avg requires a real mitigation plan, not the field itself."
                        echo "     Write what you will do about the weakest dimension (>=20 characters). Found: $(printf '%s' "$m01_mitigation" | cut -c1-60)"
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
