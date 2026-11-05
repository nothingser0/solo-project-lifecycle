#!/usr/bin/env bash
# Gate: A01 — extracted from validate-gate.sh (verbatim body).
# Sourced by the dispatcher; do NOT execute directly.
# Shared helpers (check_required/check_optional/check_intake_gate/...) come
# from ../lib/checks.sh, which the dispatcher sources before this file.

# --- gate_A01 ------------------------------------------------------
gate_A01() {
    echo "=== A01: WBS Phasing & Domain Decomposition Checklist ==="
    check_required "docs/pm/WBS_PHASING_PLAN.md" "" 1000
    local target="docs/pm/WBS_PHASING_PLAN.md"
    if [ -f "$target" ]; then
        if grep -qE "\[Client Company|\[Your Name\]|\[Project Name\]|\[YYYY-MM-DD\]" "$target"; then
            echo "  ❌ $target still contains unresolved template placeholders ([...])!"
            GATE_FAILED=1
        fi
        check_sections "$target" "Phasing Strategy" "Phased Package Breakdown" "Scope Razor" "Sign-Off"

        # Sign-off is a commitment to a phasing plan; a model cannot commit on the client's behalf.
        if grep -iE "(sign-off|signed by|signed)[[:space:]]*:" "$target" | grep -qiE "(claude|chatgpt|gpt[0-9._-]*|openai|anthropic|copilot|gemini|llama|assistant|agent|bot|llm|ai assistant)"; then
            echo "  ❌ $target names a model in the Sign-Off - the agent may draft the phasing plan, never sign it."
            GATE_FAILED=1
        fi
        # The date may sit on a "Date:" line under a "## Sign-Off" heading rather than on the
        # signature line itself, so look at the sign-off block, not just the labelled line.
        a01_signoff=$(sed -n '/[#]*.*Sign-Off/,/^#[#]\{0,2\}[[:space:]]/p' "$target" 2>/dev/null || true)
        [ -n "$a01_signoff" ] || a01_signoff=$(sed -n '/[#]*.*Sign-Off/,$p' "$target" 2>/dev/null || true)
        if ! echo "$a01_signoff" | grep -qiE "[0-9]{4}-[0-9]{2}-[0-9]{2}"; then
            echo "  ❌ $target Sign-Off carries no ISO date - an undated sign-off cannot be sequenced against delivery."
            GATE_FAILED=1
        fi

        # "Scope Razor: Nothing cut" is a phasing plan with no razor. A phasing plan exists to cut
        # something out of phase 1, so at least two cuts must be named with a reason.
        razor_block=$(sed -n '/[#]*.*Scope Razor/,/^#[#]\{0,2\}[[:space:]]/p' "$target" 2>/dev/null || true)
        [ -n "$razor_block" ] || razor_block=$(sed -n '/[#]*.*Scope Razor/,$p' "$target" 2>/dev/null || true)
        razor_cuts=$(echo "$razor_block" | grep -cE "^\s*([0-9]+\.|-|\*)\s+.+" || true)
        if echo "$razor_block" | grep -qiE "(nothing (cut|removed)|no (cuts|exclusions)|everything (is )?in)"; then
            echo "  ❌ $target Scope Razor says nothing is cut - a phasing plan that cuts nothing is not phased."
            GATE_FAILED=1
        elif [ "${razor_cuts:-0}" -lt 2 ]; then
            echo "  ❌ $target Scope Razor names ${razor_cuts:-0} cut item(s) - at least two must be named for phase 1."
            GATE_FAILED=1
        else
            echo "  ✅ Scope Razor names $razor_cuts cut item(s)"
        fi

        # Two phases for Large/Enterprise. A solo project may legitimately ship in one phase, but
        # then the plan must say so rather than leaving a single unnamed row.
        a01_scale="$(get_field Scale docs/pm/PROJECT_STATE.md 2>/dev/null | tr '[:upper:]' '[:lower:]')"
        a01_phases=$(grep -cE "^\|[^-|][^|]*\|" "$target" 2>/dev/null | head -1 | tr -dc '0-9')
        a01_phases=${a01_phases:-0}
        if { [ "$a01_scale" = "large" ] || [ "$a01_scale" = "enterprise" ]; } && [ "$a01_phases" -lt 2 ]; then
            echo "  ❌ $target has $a01_phases package row(s) at ${a01_scale} scale - phased delivery needs at least two."
            GATE_FAILED=1
        fi
    fi
}
