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

        # A heading with no content under it closed this gate.
        for sec in "Phasing Strategy" "Phased Package Breakdown"; do
            body=$(awk -v pat="$sec" 'BEGIN{IGNORECASE=1}
                    /^#+[[:space:]]/ {
                        lvl = match($0, /[^#]/)
                        if (keep == 0 && $0 ~ pat) { keep = 1; base = lvl; next }
                        if (keep == 1 && lvl <= base) { keep = 0 }
                    }
                    keep { print }' "$target" 2>/dev/null | grep -vE "^#{1,6}[[:space:]]")
            n=$(printf '%s\n' "$body" | sed 's/^[[:space:]]*//' | grep -vE '^$|^-{3,}$' | wc -l)
            if [ "$n" -lt 1 ]; then
                echo "  ❌ $target '$sec' section is empty - a heading is not a plan."
                GATE_FAILED=1
            fi
        done

        # Sign-off is a commitment to a phasing plan; a model cannot commit on the client's behalf.
        if grep -iE "(sign-off|signed by|signed)[[:space:]]*:" "$target" | grep -qiE "(claude|chatgpt|gpt[0-9._-]*|openai|anthropic|copilot|gemini|llama|assistant|agent|bot|llm|ai assistant)"; then
            echo "  ❌ $target names a model in the Sign-Off - the agent may draft the phasing plan, never sign it."
            GATE_FAILED=1
        fi
        # "Lead Enterprise Architect: filled" was accepted as a signature: a placeholder word is
        # not a person, and the same rule already applies to UAT and BAST.
        a01_signer=$(grep -iE "^[^A-Za-z]*[A-Za-z ]*(architect|lead|owner|manager|consultant|signed by)[[:space:]]*:" "$target" 2>/dev/null | head -1)
        if [ -n "$a01_signer" ]; then
            a01_signer_name=$(printf '%s' "$a01_signer" | sed 's/.*://' | sed 's/\*\*//g' | tr -d '\r' | sed 's/^[[:space:]]*//; s/[[:space:]]*$//')
            if [ -z "$a01_signer_name" ] || printf '%s' "$a01_signer_name" | grep -qiE "^(filled|tbd|todo|name|your name|xxx+|placeholder|n/a|none|-)$"; then
                echo "  ❌ $target Sign-Off names no person ('${a01_signer_name:-empty}') - a filler word is not a signature."
                GATE_FAILED=1
            fi
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
        # Table rows are not phases: a one-phase Enterprise plan with a rich breakdown table counted
        # as many packages and closed the gate. Phases are "### Phase" headings.
        a01_phases=$(grep -ciE "^#{2,4}[[:space:]]*(phase|fase)[[:space:]]*[0-9]" "$target" 2>/dev/null | tr -dc '0-9')
        a01_phases=${a01_phases:-0}
        if { [ "$a01_scale" = "large" ] || [ "$a01_scale" = "enterprise" ]; } && [ "$a01_phases" -lt 2 ]; then
            echo "  ❌ $target defines $a01_phases phase heading(s) at ${a01_scale} scale - phased delivery needs at least two (### Phase 1, ### Phase 2)."
            GATE_FAILED=1
        fi
    fi
}
