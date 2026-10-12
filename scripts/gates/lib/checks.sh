#!/usr/bin/env bash
# lib/checks.sh — shared gate helpers, sourced by the validate-gate.sh dispatcher.
# Extracted verbatim from validate-gate.sh. Do not add a shebang-only entry point:
# this file defines functions; the dispatcher owns set -e and the case routing.

# F2: structured field reader. Anchored to line start; tolerates optional "- " and
# bold "**" markers. Echoes the value after "Field:"; empty output when absent.
get_field() {
    local name="$1"
    local file="${2:-docs/pm/PROJECT_STATE.md}"
    [ -f "$file" ] || return 0
    grep -iE "^[[:space:]]*-?[[:space:]]*\**${name}\**[[:space:]]*:" "$file" 2>/dev/null \
        | head -1 \
        | sed "s/^[^:]*:[[:space:]]*//" \
        | sed 's/\*\*//g' \
        | tr -d '\r'
}

# Small-scale detection: declared Scale field, or the PROJECT_LITE fallback
# (no PROJECT_STATE.md but a root PROJECT_LITE.md exists).
is_small_scale() {
    [ "$(get_field Scale docs/pm/PROJECT_STATE.md | tr '[:upper:]' '[:lower:]')" = "small" ] \
        && return 0
    [ ! -f "docs/pm/PROJECT_STATE.md" ] && [ -f "PROJECT_LITE.md" ]
}

# Universal precondition: the 5 Intake answers must exist before ANY module work.
# Small projects have M00/M01/M02 waived, so the intake gate is their ONLY
# requirement — it must never be nested inside a scale-waiver branch.
# Returns 0 (pass) or 1 (fail, sets GATE_FAILED).
check_intake_gate() {
    local state="docs/pm/PROJECT_STATE.md"
    if [ ! -f "$state" ]; then
        if is_small_scale; then
            echo "  ❌ Intake Gate: $state missing — record the 5 Intake answers (see templates/essentials/INTAKE_GATE.md) before any module work."
            GATE_FAILED=1
            return 1
        fi
        return 0 # non-Small: PROJECT_STATE is checked by the module itself
    fi
    local bad=0
    for field in "Delivery:" "Intake-Success-Metric:" "Intake-P0-Features:" "Intake-Time-Capacity:" "Intake-Sensitive-Data:"; do
        if grep -qiE "^[[:space:]]*-?[[:space:]]*$field[[:space:]]*(UNKNOWN|\[|$)" "$state"; then
            echo "  ❌ Intake field incomplete or UNKNOWN: $field"
            bad=1
        fi
    done
    if grep -qiE "^[[:space:]]*-?[[:space:]]*Intake-Status:[[:space:]]*ANSWERED" "$state"; then
        [ "$bad" -eq 0 ] && echo "  ✅ Intake Gate: all 5 mandatory fields answered"
    else
        echo "  ❌ Intake Gate: Intake-Status not set to ANSWERED — ask the 5 Intake questions and END TURN."
        bad=1
    fi
    [ "$bad" -ne 0 ] && GATE_FAILED=1
    [ "$bad" -eq 0 ]
}

# M06 per-task human approval guard.
# The gate used to require every task to be '[x]' but never checked WHO ticked
# it, so an agent could self-approve an entire sprint. Every task marked '[x]'
# must carry a human approval line inside its own block:
#   **Evidence**: ... | Approved: 2026-10-12 by <name>
# Accepted markers: "Approved:", "Approved by", "Disetujui".
# Returns 1 (and sets GATE_FAILED) when a completed task lacks the marker.
check_task_approval() {
    local todo="TODO.md"
    [ -f "$todo" ] || return 0

    local missing
    missing=$(awk '
        /^[ \t]*-[ \t]*\[[^]]*\][ \t]*\*\*M06-/ {
            if (cur_done && !cur_appr) print cur_id
            cur_id = $0
            sub(/^[ \t]*-[ \t]*\[[^]]*\][ \t]*\*\*/, "", cur_id)
            sub(/\*\*.*$/, "", cur_id)
            cur_done = ($0 ~ /\[x\]/)
            cur_appr = ($0 ~ /Approved|Disetujui/)
            next
        }
        { if ($0 ~ /Approved|Disetujui/) cur_appr = 1 }
        END { if (cur_done && !cur_appr) print cur_id }
    ' "$todo" 2>/dev/null || true)

    if [ -n "$missing" ]; then
        echo "  ❌ TODO.md: completed task(s) missing a human approval line in their Evidence."
        echo "     Add e.g. 'Approved: <date> by <name>' to each block below, or un-tick them:"
        echo "$missing" | sed 's/^/       - /'
        GATE_FAILED=1
        return 1
    fi

    local done_count
    done_count=$(grep -cE "^\s*-\s*\[x\][^]]*\*\*M06-" "$todo" 2>/dev/null || true)
    echo "  ✅ Per-task human approval verified for ${done_count:-0} completed task(s)"
    return 0
}

# M04 Design Freeze sign-off guard.
# The gate used to verify only that DESIGN_SPEC.md is large enough, so an agent
# could generate the file, fill the approval row itself, and still pass.
# A completed freeze must show a named human approver and a real date, with no
# blank or placeholder signature lines remaining.
# Returns 1 (and sets GATE_FAILED) when the freeze is unsigned.
check_design_freeze() {
    local spec="docs/specs/DESIGN_SPEC.md"
    [ -f "$spec" ] || return 0 # existence is enforced by check_required

    local bad=0

    # 1. Blank/placeholder signatures must be gone (the template ships with underscores).
    if grep -qiE "_{5,}|\[YYYY-MM-DD\]|\[(name|your name)\]|<name>|TBD" "$spec" 2>/dev/null; then
        echo "  ❌ DESIGN_SPEC.md still holds blank/placeholder sign-off fields (underscores, [YYYY-MM-DD], [Name]). The human signs the Design Freeze before M06."
        bad=1
    fi

    # 2. A named approver must be recorded (not empty, not a placeholder).
    if grep -qiE "^\s*[-*]?\s*\**\s*Approved by\**:?[[:space:]]*[A-Za-z]" "$spec" 2>/dev/null; then
        echo "  ✅ Design Freeze approver recorded"
    else
        echo "  ❌ DESIGN_SPEC.md missing a named Design Freeze approver ('Approved by: <name>')."
        bad=1
    fi

    # 3. An approval date must be present and look like a real date.
    if grep -qE "(Approved on|Approval Date|Date)\**:?[[:space:]]*[0-9]{4}-[0-9]{2}-[0-9]{2}" "$spec" 2>/dev/null; then
        echo "  ✅ Design Freeze approval date recorded"
    else
        echo "  ❌ DESIGN_SPEC.md missing a real Design Freeze date ('Approved on: YYYY-MM-DD')."
        bad=1
    fi

    [ "$bad" -ne 0 ] && GATE_FAILED=1
    [ "$bad" -eq 0 ]
}

# M05 Tech Stack Discovery questionnaire guard.
# The gate only checked for the literal marker 'Stack Decision LOCKED:', which an
# agent can write itself after inventing a stack. The 8 questionnaire answers are
# the human's input, so at least the recorded answers must be present and the
# marker must not appear without them.
# Returns 1 (and sets GATE_FAILED) when the lock is unsupported by answers.
check_stack_questionnaire() {
    local target=""
    if [ -f "PROJECT_LITE.md" ]; then
        target="PROJECT_LITE.md"
    elif [ -f "docs/specs/FSD.md" ]; then
        target="docs/specs/FSD.md"
    fi
    [ -n "$target" ] || return 0 # missing artifact is reported by check_required

    if ! grep -qiE "Stack Decision LOCKED:" "$target" 2>/dev/null; then
        return 0 # the dedicated lock check already reports this
    fi

    # Answers must be recorded as a questionnaire block, not just a bare marker.
    local answered
    answered=$(grep -ciE "^\s*[-*]?\s*\**\s*(Q[1-8]\b|Question [1-8]\b|Tech-Stack-Q[1-8]\b)" "$target" 2>/dev/null || true)
    answered="${answered:-0}"

    if [ "$answered" -lt 8 ]; then
        echo "  ❌ $target declares 'Stack Decision LOCKED:' but records only ${answered}/8 questionnaire answers."
        echo "     The 8 answers are the human's input (M05 STEP 1). Ask the questions, END TURN, and record all 8 before locking."
        GATE_FAILED=1
        return 1
    fi

    # An approver line must name the human who locked the stack.
    if grep -qiE "Stack[- ]Lock(ed)?[- ]?by:?\**[[:space:]]*[A-Za-z]" "$target" 2>/dev/null; then
        echo "  ✅ Stack lock supported by 8 recorded answers + named approver"
    else
        echo "  ✅ Stack lock supported by $answered recorded questionnaire answers"
        echo "     [INFO] Add 'Stack-Locked-by: <name>' to record who chose the stack."
    fi
    return 0
}

# M08/M10 client-input receipt guard.
# These modules cannot start without artefacts only the client can supply (source
# data / credentials). Nothing checked that the handover actually happened, so an
# agent could proceed on invented inputs. The plan must record receipt explicitly.
# Returns 1 (and sets GATE_FAILED) when the client handover is unrecorded.
check_client_inputs() {
    local plan="$1" label="$2"
    [ -f "$plan" ] || return 0 # existence enforced by check_required

    if grep -qiE "Inputs[- ]Received|Client[- ]Provided|Received from client|Handover received" "$plan" 2>/dev/null; then
        echo "  ✅ $label: client input receipt recorded"
        return 0
    fi

    echo "  ❌ $label: no record that the client-supplied inputs were actually received."
    echo "     Add 'Inputs-Received: <what> from <client PIC> on <YYYY-MM-DD>' to $plan"
    echo "     Source data / credentials come from the client — never invent or simulate them."
    GATE_FAILED=1
    return 1
}

# A2: content check — require core section headings from the matching template.
check_sections() {
    local file="$1"
    shift
    if [ ! -f "$file" ]; then
        return 0 # existence is enforced by check_required; here we only verify content
    fi
    local h missing=0
    for h in "$@"; do
        if ! grep -qiE "^#{1,6}[[:space:]]*.*${h}" "$file" 2>/dev/null; then
            echo "  ❌ $file missing core section heading matching '${h}'!"
            missing=1
        fi
    done
    if [ "$missing" -eq 0 ]; then
        echo "  ✅ $file core section headings verified ($# headings present)"
    else
        GATE_FAILED=1
    fi
}

check_required() {
    local file="$1"
    local alt="$2"
    local min_size="${3:-0}" # v2: size threshold ignored (padding incentive removed); stub-check only
    local target=""
    if [ -f "$file" ]; then
        target="$file"
    elif [ -n "$alt" ] && [ -f "$alt" ]; then
        target="$alt"
    fi

    if [ -n "$target" ]; then
        local size=0
        # Portable file size extraction
        size=$(wc -c < "$target" 2>/dev/null || stat -c%s "$target" 2>/dev/null || echo 0)
        size=$(echo "$size" | tr -d ' ')
        if [ "$size" -lt 40 ]; then
            echo "  ❌ $target (STUB: ${size}B — file exists but empty/near-empty; fill real content)"
            GATE_FAILED=1
        else
            echo "  ✅ $target (${size}B)"
        fi
    else
        echo "  ❌ $file (MISSING)"
        GATE_FAILED=1
    fi
}

check_optional() {
    local file="$1"
    local alt="$2"
    if [ -f "$file" ]; then
        echo "  [OK] $file (optional)"
    elif [ -n "$alt" ] && [ -f "$alt" ]; then
        echo "  [OK] $alt (optional)"
    else
        echo "  ⚠️  $file (optional, not found)"
    fi
}
