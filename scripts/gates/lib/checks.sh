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

# Small-scale detection: the declared Scale field, or the PROJECT_LITE fallback.
# NOTE: the fallback only decides which WAIVER MESSAGE a project sees — it can
# never produce a passing run, because PROJECT_STATE.md is mandatory for every
# scale (it holds the Intake answers, and check_intake_gate fails without it).
# PROJECT_LITE.md alone is not a substitute for PROJECT_STATE.md.
is_small_scale() {
    [ "$(get_field Scale docs/pm/PROJECT_STATE.md | tr '[:upper:]' '[:lower:]')" = "small" ] \
        && return 0
    [ ! -f "docs/pm/PROJECT_STATE.md" ] && [ -f "PROJECT_LITE.md" ]
}

# Universal precondition: the Intake answers must exist before ANY module work.
# Small projects have M00/M01/M02 waived, so the intake gate is their ONLY
# requirement — it must never be nested inside a scale-waiver branch.
# Besides the 6 core questions, the 4 escalation fields READ BY
# classify-scale.sh (Integrations / Branch-Hierarchy / Compliance / Legacy-Core) are required:
# an absent field is not "none", and while it is absent a payment webhook or a
# multi-tenant hierarchy stays invisible and the project keeps its self-declared
# "small" tier. "None" is a valid answer; blank/UNKNOWN/UNSET is not.
# Returns 0 (pass) or 1 (fail, sets GATE_FAILED).
check_intake_gate() {
    local state="docs/pm/PROJECT_STATE.md"
    if [ ! -f "$state" ]; then
        # Mandatory at EVERY scale. This used to return 0 for non-Small projects
        # ("the module checks it itself"), but no module did: with the file absent,
        # is_small_scale() could not read a Scale field, so a project with no
        # PROJECT_STATE.md and no PROJECT_LITE.md skipped both the waiver and the
        # intake check and every gate passed vacuously.
        echo "  ❌ Intake Gate: $state missing — record the Intake answers (see templates/essentials/INTAKE_GATE.md) before any module work."
        echo "     PROJECT_LITE.md is not a substitute: PROJECT_STATE.md is mandatory at every scale."
        GATE_FAILED=1
        return 1
    fi
    local bad=0
    local field label
    for field in "Delivery:" "Intake-Success-Metric:" "Intake-P0-Features:" "Intake-Time-Capacity:" \
                 "Intake-Sensitive-Data:" "Intake-Integrations:" "Intake-Branch-Hierarchy:" \
                 "Intake-Compliance:" "Intake-Legacy-Core:"; do
        label="${field%:}"
        # An ABSENT line must fail too. The first pattern alone only matched a
        # present-but-empty line, so dropping the escalation fields from the state
        # file was a way to make them "not applicable" and keep the small tier.
        if ! grep -qiE "^[[:space:]]*-?[[:space:]]*$field[[:space:]]*[^[:space:]]" "$state"; then
            echo "  ❌ Intake field missing or UNSET: $label"
            bad=1
        elif grep -qiE "^[[:space:]]*-?[[:space:]]*$field[[:space:]]*(UNKNOWN|\[)" "$state"; then
            echo "  ❌ Intake field incomplete or UNKNOWN: $label"
            bad=1
        fi
    done
    if grep -qiE "^[[:space:]]*-?[[:space:]]*Intake-Status:[[:space:]]*ANSWERED" "$state"; then
        [ "$bad" -eq 0 ] && echo "  ✅ Intake Gate: all 9 mandatory fields answered"
    else
        echo "  ❌ Intake Gate: Intake-Status not set to ANSWERED — ask the Intake questions and END TURN."
        bad=1
    fi
    [ "$bad" -ne 0 ] && GATE_FAILED=1
    [ "$bad" -eq 0 ]
}

# Solo-capacity / High-Water-Mark classifier — runs for EVERY scale, including
# projects that declare themselves Small. M01 used to call it from inside its
# non-Small branch, so a self-declared "small" tier skipped the check the scale
# router calls mandatory: 20 P0 features + sensitive data passed as "small".
# Exit 0 = solo-viable. Exit 2 = blocked (non-delegable obligation, or a capacity
# risk without a written acceptance). Exit 5 = the human accepted the CAPACITY risk
# in writing (docs/pm/SOLO-CAPACITY-RISK-ACCEPTANCE.md) — the gate CONTINUES but the
# override is surfaced, never silently green. ANY other non-zero exit is a
# CLASSIFIER ERROR and also fails closed — previously only exit 2 counted as
# failure, so a crashing classifier printed "✅ Solo capacity verified" and its
# own error output was swallowed.
# Returns 0 (verified) or 1 (sets GATE_FAILED).
check_scale_feasibility() {
    if [ ! -f "docs/pm/PROJECT_STATE.md" ]; then
        return 0 # nothing to classify; check_intake_gate already reports the file
    fi
    local gate_dir="${SCRIPT_DIR:-scripts/gates}"
    if [ ! -f "$gate_dir/classify-scale.sh" ]; then
        echo "  ⚠️  classify-scale.sh not found next to the gate dispatcher ($gate_dir) — scale / High-Water-Mark check SKIPPED"
        GATE_FAILED=1
        return 1
    fi
    echo "  [INFO] Running mechanical scale & solo capacity classifier..."
    local classify_output rc=0
    classify_output="$(bash "$gate_dir/classify-scale.sh" 2>&1)" || rc=$?
    if [ "$rc" -eq 0 ]; then
        echo "  ✅ Solo capacity verified: Scope is executable within solo capacity"
        # The classifier derives the tier from the structured Intake fields only; it
        # never reads the human-declared `Scale:` line. So a project that declares
        # "small" while its own answers say otherwise (payment webhook, sensitive
        # data, 8+ P0) used to print the green line and keep the Small path, which
        # waives M01/M02 and the whole document set. Compare the two explicitly.
        local evaluated declared_s declared_n
        evaluated=$(echo "$classify_output" | sed -n 's/^Evaluated Scale[[:space:]]*:[[:space:]]*//p' | head -1 | tr -d ' \r')
        declared_s=$(get_field Scale docs/pm/PROJECT_STATE.md | tr '[:upper:]' '[:lower:]' | tr -d ' \r')
        declared_n=$(echo "$declared_s" | grep -oiE "small|medium|large|enterprise" | head -1)
        if [ -n "$evaluated" ] && [ -n "$declared_n" ] && [ "$evaluated" != "$declared_n" ]; then
            echo "  ❌ Scale mismatch: declared 'Scale: $declared_s' but the Intake fields evaluate to '$evaluated'."
            echo "     The HIGH-WATER MARK rule says the highest tier wins. Re-classify the project (and re-run the matching lifecycle path) or correct the Intake answers."
            GATE_FAILED=1
            return 1
        fi
        return 0
    fi
    if [ "$rc" -eq 5 ]; then
        # Capacity-only override, accepted in writing by a named human. The scale
        # still must match the evaluated tier (a Large project cannot keep the Small
        # path), so run the same declared-vs-evaluated comparison as the rc=0 branch.
        echo "  ⚠️  SOLO CAPACITY OVERRIDE ACCEPTED (capacity-only): proceeding under a recorded risk acceptance."
        echo "     Non-delegable obligations (statutory compliance / legacy-core) are still hard-blocked — none were declared."
        local evaluated declared_s declared_n
        evaluated=$(echo "$classify_output" | sed -n 's/^Evaluated Scale[[:space:]]*:[[:space:]]*//p' | head -1 | tr -d ' \r')
        declared_s=$(get_field Scale docs/pm/PROJECT_STATE.md | tr '[:upper:]' '[:lower:]' | tr -d ' \r')
        declared_n=$(echo "$declared_s" | grep -oiE "small|medium|large|enterprise" | head -1)
        if [ -n "$evaluated" ] && [ -n "$declared_n" ] && [ "$evaluated" != "$declared_n" ]; then
            echo "  ❌ Scale mismatch: declared 'Scale: $declared_s' but the Intake fields evaluate to '$evaluated'."
            echo "     The override may accept the CAPACITY risk, never a wrong lifecycle path. Re-classify the project."
            GATE_FAILED=1
            return 1
        fi
        echo "$classify_output" | sed 's/^/    /'
        return 0
    fi
    if [ "$rc" -eq 2 ]; then
        echo "  ❌ SOLO CAPACITY GATE TRIGGERED: Project exceeds solo developer capacity!"
        echo "     The declared Scale does not override the classifier — the HIGH-WATER MARK wins."
    else
        echo "  ❌ Scale classifier ERROR (exit $rc): solo capacity could NOT be verified. Failing closed."
    fi
    echo "$classify_output" | sed 's/^/    /'
    GATE_FAILED=1
    return 1
}

# M01 brief resolution. Two filenames are accepted: IDEA_BRIEF.md (preferred) and
# FEASIBILITY_REPORT.md (documented alias). When BOTH exist the gate must score the
# more complete one — a leftover stub used to shadow a filled report, and the run
# failed on the stub's contents with no hint that the real report was sitting next
# to it. Sets BRIEF_FILE (empty when neither exists). Returns 0 when a usable
# file was found and is not a stub.
BRIEF_FILE=""
check_feasibility_brief() {
    local primary="docs/pm/IDEA_BRIEF.md"
    local alias="docs/pm/FEASIBILITY_REPORT.md"
    BRIEF_FILE=""
    local primary_scores=0 alias_scores=0
    if [ -f "$primary" ]; then
        primary_scores=$(grep -ciE "^[[:space:]]*-?[[:space:]]*\**Feasibility-Score-" "$primary" 2>/dev/null) || primary_scores=0
    fi
    if [ -f "$alias" ]; then
        alias_scores=$(grep -ciE "^[[:space:]]*-?[[:space:]]*\**Feasibility-Score-" "$alias" 2>/dev/null) || alias_scores=0
    fi
    if [ "$alias_scores" -gt "$primary_scores" ]; then
        BRIEF_FILE="$alias"
        if [ -f "$primary" ]; then
            echo "  [INFO] Both briefs present — scoring $alias ($alias_scores score lines); the less complete $primary ($primary_scores) is ignored."
        fi
    elif [ -f "$primary" ]; then
        BRIEF_FILE="$primary"
    elif [ -f "$alias" ]; then
        BRIEF_FILE="$alias"
    fi

    if [ -z "$BRIEF_FILE" ]; then
        echo "  ❌ $primary (MISSING — copy templates/01-discovery-commercial/IDEA_BRIEF_TEMPLATE.md; FEASIBILITY_REPORT.md is an accepted alias)"
        GATE_FAILED=1
        return 1
    fi
    local size
    size=$(wc -c < "$BRIEF_FILE" 2>/dev/null | tr -d ' ')
    size="${size:-0}"
    if [ "$size" -lt 40 ]; then
        echo "  ❌ $BRIEF_FILE (STUB: ${size}B — file exists but empty/near-empty; fill real content)"
        GATE_FAILED=1
        return 1
    fi
    echo "  ✅ $BRIEF_FILE (${size}B)"
    return 0
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
    [ -f "$todo" ] || todo="docs/harness-root/TODO.md"
    [ -f "$todo" ] || return 0

    # The task-id pattern must NOT require bold markers. It used to be
    # /\[[^]]*\][ \t]*\*\*M06-/, so a task written without '**' ("- [x] M06-DB-01:
    # Schema") was invisible to this guard: an agent could self-approve a whole
    # sprint by simply omitting the bold, while the tick/pending counts in M06.sh
    # (which are bold-agnostic) still saw the task as complete.
    local missing
    missing=$(awk '
        /^[ \t]*-[ \t]*\[[^]]*\][ \t]*\*{0,2}M06-/ {
            if (cur_done && !cur_appr) print cur_id
            cur_id = $0
            sub(/^[ \t]*-[ \t]*\[[^]]*\][ \t]*/, "", cur_id)
            sub(/\*+[ \t]*$/, "", cur_id)
            sub(/^\*{0,2}/, "", cur_id)
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
    # Bold-agnostic: identical task-id shape to the awk block above.
    done_count=$(grep -cE "^\s*-\s*\[x\][^]]*\*{0,2}M06-" "$todo" 2>/dev/null || true)
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
    if grep -qiE "^\s*[-*]?\s*\**\s*(Approved by|Signed by|Design-Freeze: Signed by)\**:?[[:space:]]*[A-Za-z]" "$spec" 2>/dev/null; then
        echo "  ✅ Design Freeze approver recorded"
    else
        echo "  ❌ DESIGN_SPEC.md missing a named Design Freeze approver ('Approved by: <name>' or 'Signed by: <name>')."
        bad=1
    fi

    # 3. An approval date must be present and look like a real date.
    if grep -qE "(Approved on|Approval Date|Date|on)\**:?[[:space:]]*[0-9]{4}-[0-9]{2}-[0-9]{2}" "$spec" 2>/dev/null; then
        echo "  ✅ Design Freeze approval date recorded"
    else
        echo "  ❌ DESIGN_SPEC.md missing a real Design Freeze date ('Approved on: YYYY-MM-DD' or 'on YYYY-MM-DD')."
        bad=1
    fi

    [ "$bad" -ne 0 ] && GATE_FAILED=1
    [ "$bad" -eq 0 ]
}

# Universal human design-reference guard (M04; retrofit guard in M06).
# The framework requires a HUMAN-SUPPLIED visual reference before any design
# artifact is produced (logo, components, DESIGN.md, screen prompts) at EVERY
# scale. The gate used to accept notes.md alone — an agent-written analysis
# document — so the "reference" requirement was satisfiable without a single
# real reference existing (the shipped parity fixture proves exactly that: it
# passed with notes.md as the only file in inspiration/).
# Rules:
#   1. docs/design/inspiration/ must contain >=1 file the agent could not have
#      authored itself: any file EXCEPT notes.md, README.md, NOTES_TEMPLATE.md
#      and dotfiles (.gitkeep) counts as the human's reference — a screenshot,
#      a brand board, or links.md holding the reference URLs.
#   2. notes.md must cite a filename that actually exists in that folder, so a
#      benchmark written from imagination (no corresponding file) cannot pass.
# Returns 1 (and sets GATE_FAILED) when the human reference is missing.
check_design_inspiration() {
    local dir="docs/design/inspiration"
    local refs="" ref_count=0

    refs="$(find "$dir" -maxdepth 1 -type f 2>/dev/null \
        ! -name 'notes.md' ! -name 'README.md' ! -name 'NOTES_TEMPLATE.md' ! -name '.*' \
        | sort || true)"
    if [ -n "$refs" ]; then
        ref_count=$(printf '%s\n' "$refs" | wc -l | tr -d ' ')
    fi

    if [ "${ref_count:-0}" -lt 1 ]; then
        echo "  ❌ Design references: no HUMAN-supplied reference in $dir/"
        echo "     Required BEFORE logo/components/DESIGN.md at every scale: the human places >=1"
        echo "     reference file there (screenshot, brand board, or a links.md of URLs)."
        echo "     notes.md is agent output — it is never the reference itself. STOP AND ASK."
        GATE_FAILED=1
        return 1
    fi
    echo "  ✅ Design references: ${ref_count} human-supplied reference file(s) present"

    local notes="$dir/notes.md"
    if [ ! -f "$notes" ]; then
        echo "  ❌ $notes (MISSING: copy templates/02-design/references/inspiration-template/NOTES_TEMPLATE.md)"
        GATE_FAILED=1
        return 1
    fi

    # notes.md must cite at least one reference file that is ACTUALLY present.
    local cited=0 f base
    while IFS= read -r f; do
        [ -n "$f" ] || continue
        base="$(basename "$f")"
        if grep -qiF -- "$base" "$notes" 2>/dev/null; then cited=1; break; fi
        base="${base%.*}"
        if [ -n "$base" ] && grep -qiF -- "$base" "$notes" 2>/dev/null; then cited=1; break; fi
    done < <(find "$dir" -maxdepth 1 -type f 2>/dev/null \
        ! -name 'notes.md' ! -name 'README.md' ! -name 'NOTES_TEMPLATE.md' ! -name '.*')
    if [ "$cited" -eq 1 ]; then
        echo "  ✅ notes.md cites a reference filename that exists in $dir/"
    else
        echo "  ❌ notes.md cites no filename present in $dir/ — a benchmark without a real"
        echo "     reference file is fabricated. Cite the human's file (e.g. 'reference-1-dashboard.png')."
        GATE_FAILED=1
        return 1
    fi
    return 0
}

# M05 Tech Stack Discovery questionnaire guard.
# The gate only checked for the literal marker 'Stack Decision LOCKED:', which an
# agent can write itself after inventing a stack. The 8 questionnaire answers are
# the human's input, so at least the recorded answers must be present and the
# marker must not appear without them.
# Second regression (found by copying the raw PROJECT_LITE_TEMPLATE.md and
# changing ONLY the lock line): the template ships 8 literal `- Q1 ... [answer]`
# lines, so the count matched 8 and a completely unfilled document passed with
# "8 recorded questionnaire answers". A placeholder is not an answer.
# Returns 1 (and sets GATE_FAILED) when the lock is unsupported by answers.
check_stack_questionnaire() {
    local target=""
    if [ -f "PROJECT_LITE.md" ]; then
        target="PROJECT_LITE.md"
    elif [ -f "docs/specs/PROJECT_LITE.md" ]; then
        target="docs/specs/PROJECT_LITE.md"
    elif [ -f "docs/specs/FSD.md" ]; then
        target="docs/specs/FSD.md"
    fi
    [ -n "$target" ] || return 0 # missing artifact is reported by check_required

    if ! grep -qiE "Stack Decision LOCKED:" "$target" 2>/dev/null; then
        return 0 # the dedicated lock check already reports this
    fi

    # Q1..Q8 are counted individually so a partially filled block names the gap.
    local q answered=0 missing="" placeholder="" value
    for q in 1 2 3 4 5 6 7 8; do
        value=$(grep -iE "^\s*[-*]?\s*\**\s*(Q${q}\b|Question ${q}\b|Tech-Stack-Q${q}\b)" "$target" 2>/dev/null \
            | head -1 | sed 's/^[^:]*:[[:space:]]*//' | tr -d '\r')
        if [ -z "$value" ]; then
            missing="${missing} Q${q}"
            continue
        fi
        # A template placeholder is not an answer: [answer], <value>, TBD, ___ , UNKNOWN.
        if echo "$value" | grep -qiE "^\[.*\]$|^<.*>$|^(tbd|tba|unknown|unset|n/?a|xxx+|-+)$|_\{3,\}|\[answer\]|\[your .*\]|\[\.\.\.\]"; then
            placeholder="${placeholder} Q${q}"
            continue
        fi
        answered=$((answered + 1))
    done

    if [ "$answered" -lt 8 ]; then
        echo "  ❌ $target declares 'Stack Decision LOCKED:' but records only ${answered}/8 real questionnaire answers."
        [ -n "$missing" ] && echo "     Missing:${missing}"
        [ -n "$placeholder" ] && echo "     Still a template placeholder (not a human answer):${placeholder}"
        echo "     The 8 answers are the human's input (M05 STEP 1). Ask the questions, END TURN, and record all 8 before locking."
        GATE_FAILED=1
        return 1
    fi

    # The lock must name the human who chose the stack — not a blank, not a placeholder.
    local locker
    locker=$(grep -iE "Stack[- ]Lock(ed)?[- ]?by" "$target" 2>/dev/null | head -1 \
        | sed 's/^[^:]*:[[:space:]]*//' | sed 's/\*\*//g' | tr -d '\r')
    if echo "$locker" | grep -qE "^[[:space:]]*[A-Za-z][A-Za-z.'-]*" && \
       ! echo "$locker" | grep -qiE "^\[.*\]|your name|the human|<.*>|^tbd|^name$" && \
       ! is_role_placeholder "$locker"; then
        echo "  ✅ Stack lock supported by 8 recorded answers + named approver"
    else
        echo "  ❌ $target names no human in 'Stack-Locked-by:' (found: '${locker:-<empty>}')."
        echo "     The AI agent may present options but may never choose the stack — record the human's name."
        GATE_FAILED=1
        return 1
    fi
    return 0
}

# M05 Module 04 handoff guard.
# M06 STEP 0 parses `Module 04 Handoff Strategy` + a Level 1-4 to decide how the
# frozen M04 prototype converts into the chosen framework, and M06's own gate
# refuses to start without it. Nothing in M05 required that section and the FSD
# template never shipped one, so every project reached M06 with the handoff
# missing — an artifact M05's exit criteria claimed to verify. It is produced
# here, where the stack is locked. Section name matches M06 verbatim.
# Returns 1 (and sets GATE_FAILED) when the section or its Level is absent.
check_handoff_strategy() {
    # Honour the caller's path. The previous version re-derived FSD/PROJECT_LITE itself,
    # so M05 and M06 could silently check DIFFERENT documents on a Small project
    # (M05 passed "$fsd", got the LITE file checked, and a missing handoff on the FSD
    # went unreported). Pass the document you mean; default to the FSD path.
    local target="${1:-docs/specs/FSD.md}"
    local label="${2:-$target}"
    [ -f "$target" ] || return 1   # a missing artifact is reported by check_required

    local bad=0
    if grep -qiE "Module 04 Handoff Strategy|Prototype Conversion Strategy" "$target" 2>/dev/null; then
        echo "  ✅ Module 04 handoff strategy documented in $target"
    else
        echo "  ❌ $target missing the 'Module 04 Handoff Strategy' section — M06 STEP 0 cannot be completed without it."
        echo "     Document the prototype → framework conversion plan (see FSD_TECHNICAL_TEMPLATE.md §2.1)."
        bad=1
    fi

    # The level must be a CHOSEN value, not the template's menu. Extracting and
    # anchoring is what distinguishes "Level 3" / "3" (a choice) from
    # "[Level 1 | Level 2 | Level 3 | Level 4]" (the menu, which a naive
    # `Level[1-4]` grep matched — so an unfilled template passed).
    local val
    val=$(grep -iE "Compatibility[- ]Level[^:]*:" "$target" 2>/dev/null | head -1 \
        | sed 's/^[^:]*:[[:space:]]*//' | sed 's/\*\*//g' | tr -d '\r' \
        | sed 's/^[[:space:]]*//; s/[[:space:]]*$//')
    if [ -n "$val" ] && printf '%s' "$val" | grep -qiE '^(Level[[:space:]]*)?[1-4]$'; then
        echo "  ✅ Module 04 handoff compatibility level recorded (Level $val)"
    else
        echo "  ❌ $target has no chosen 'Compatibility Level' (found: '${val:-<none>}')."
        echo "     Record the level the human chose (1-4), not the template's menu."
        bad=1
    fi

    [ "$bad" -ne 0 ] && GATE_FAILED=1
    [ "$bad" -eq 0 ]
}

# M05 security blueprint guard.
# M05 STEP 5 makes the security blueprint a deliverable (AES-256-GCM envelope
# encryption, Argon2id hashing, OWASP Top 10, rate limiting, UU PDP) and M06
# inherits it as the baseline its anti-slop audit is measured against. Nothing
# checked it, so a project could be told its architecture was signed off without
# a single control recorded. Counted by distinct control; Medium+ also needs the
# compliance tie-in.
# Returns 1 (and sets GATE_FAILED) when the blueprint is absent/incomplete.
check_security_blueprint() {
    local fsd="docs/specs/FSD.md"
    local lite="PROJECT_LITE.md"
    [ ! -f "$lite" ] && [ -f "docs/specs/PROJECT_LITE.md" ] && lite="docs/specs/PROJECT_LITE.md"
    local target=""
    if is_small_scale && [ -f "$lite" ]; then
        target="$lite"
    elif [ -f "$fsd" ]; then
        target="$fsd"
    fi
    [ -n "$target" ] || return 0 # missing artifact is reported by check_required

    local need=4 hit=0 have="" kw
    for kw in "AES-256|AES.?256|aes-256-gcm" "Argon2id|Argon2|bcrypt|scrypt" "OWASP" "rate.?limit"; do
        if grep -qiE "$kw" "$target" 2>/dev/null; then
            hit=$((hit + 1)); have="${have} $(echo "$kw" | cut -d'|' -f1)"
        fi
    done
    if ! is_small_scale; then
        need=5
        if grep -qiE "UU PDP|UU_PDP|GDPR|consent" "$target" 2>/dev/null; then
            hit=$((hit + 1)); have="${have} UU-PDP"
        fi
    fi

    if [ "$hit" -ge "$need" ]; then
        echo "  ✅ Security blueprint recorded in $target (${hit} controls:$have)"
    else
        echo "  ❌ $target security blueprint incomplete (${hit}/${need} controls found:$have)."
        echo "     M05 STEP 5 requires: AES-256-GCM envelope encryption, Argon2id hashing, OWASP Top 10, rate limiting$([ "$need" -eq 5 ] && echo ", UU PDP consent/deletion/audit")."
        GATE_FAILED=1
        return 1
    fi
    return 0
}

# M05 human technical sign-off guard.
# Same failure mode the M04 Design Freeze guard was written for: the PRD/FSD
# templates ship `| **Name**: ________ |` / `[YYYY-MM-DD]` rows and M05 STEP 7 is
# a HUMAN-ONLY step (docs/AUTHORITY.md). The gate accepted the untouched
# template, so an agent could declare "Tech Spec Sign-off" on its own blank sheet
# without the human ever reviewing it. Delivery-routed: solo/portfolio/internal
# need the developer's validation; client work needs the Client Single PIC too.
# Returns 1 (and sets GATE_FAILED) when the sign-off is blank/placeholder/unnamed.
check_tech_signoff() {
    local doc="" label=""
    if is_small_scale; then
        doc="PROJECT_LITE.md"; label="PROJECT_LITE.md"
        [ ! -f "$doc" ] && [ -f "docs/specs/PROJECT_LITE.md" ] && { doc="docs/specs/PROJECT_LITE.md"; label="docs/specs/PROJECT_LITE.md"; }
    else
        doc="docs/specs/FSD.md"; label="FSD.md"
        [ -f "$doc" ] || { doc="docs/specs/PRD.md"; label="PRD.md"; }
    fi
    [ -f "$doc" ] || return 0 # existence is enforced by check_required

    local bad=0

    # 1. Residual blank SIGN-OFF fields only. Scoped to signature lines so unrelated
    #    metadata placeholders (e.g. 'Target Release: [YYYY-MM-DD]', 'Lead Software
    #    Architect: [Your Name]') do not trip it.
    if grep -iE "approved|validated|approver|signature|client pic|sign-off" "$doc" 2>/dev/null \
        | grep -qE "_{3,}|\[YYYY-MM-DD\]|\[Your Name\]|\[Client PIC Name\]|\[name\]|\[Name\]|<name>"; then
        echo "  ❌ $label still holds blank/placeholder sign-off fields (underscores, [YYYY-MM-DD], [Your Name]). M05 STEP 7 is a HUMAN-ONLY step."
        bad=1
    fi

    # 2. The approver must be a named human, not a role placeholder.
    local approver
    approver=$(grep -iE "^\s*[-*|]?\s*\**\s*(Approved by|Validated by|Approver)[^*:]{0,40}\**:?[[:space:]]*[A-Za-z]" "$doc" 2>/dev/null \
        | head -1 | sed 's/^[^:]*:[[:space:]]*//' | sed 's/\*\*//g' | sed 's/[[:space:]]*(.*$//' | tr -d '\r')
    if [ -n "$approver" ] && ! is_role_placeholder "$approver"; then
        echo "  ✅ $label technical sign-off records a named approver"
    else
        echo "  ❌ $label missing a named technical approver (e.g. 'Approved by: <name>')."
        bad=1
    fi

    # 3. A real approval date.
    if grep -qE "(Approved on|Approval Date|Date)\**:?[[:space:]]*[0-9]{4}-[0-9]{2}-[0-9]{2}" "$doc" 2>/dev/null; then
        echo "  ✅ $label technical sign-off records a real date"
    else
        echo "  ❌ $label missing a real sign-off date ('Approved on: YYYY-MM-DD')."
        bad=1
    fi

    # 4. Delivery-routed second signature.
    local delivery
    delivery=$(get_field Delivery docs/pm/PROJECT_STATE.md | tr '[:upper:]' '[:lower:]')
    case "$delivery" in
        solo|portfolio|internal)
            if grep -qiE "Validated by (the )?(Solo Developer|Developer|Human)|Developer Sign-Off" "$doc" 2>/dev/null; then
                echo "  ✅ $label developer self-validation recorded ($delivery delivery)"
            else
                echo "  ❌ $label missing the developer's validation line ('Validated by Solo Developer: <name>')."
                bad=1
            fi
            ;;
        client)
            if grep -qiE "Client Single PIC|Approved by Client|Client PIC" "$doc" 2>/dev/null; then
                echo "  ✅ $label Client Single PIC sign-off verified"
            else
                echo "  ❌ $label missing the Client Single PIC sign-off row (client delivery)."
                bad=1
            fi
            ;;
    esac

    [ "$bad" -ne 0 ] && GATE_FAILED=1
    [ "$bad" -eq 0 ]
}

# M08/M10 client-input receipt guard.
# These modules cannot start without artefacts only the client can supply (source
# data / credentials). Nothing checked that the handover actually happened, so an
# agent could proceed on invented inputs. The plan must record receipt explicitly.
# Returns 1 (and sets GATE_FAILED) when the client handover is unrecorded.
check_client_inputs() {
    local plan="$1" label="$2"
    [ -f "$plan" ] || return 0 # existence enforced by check_required

    # The marker alone is a false green: the unfilled template line matches too, so a plan
    # where the client sent nothing would pass. Require a recorded value after the colon.
    if grep -qiE "Inputs[- ]Received|Client[- ]Provided|Received from client|Handover received" "$plan" 2>/dev/null; then
        local receipt
        receipt=$(grep -iE "Inputs[- ]Received|Client[- ]Provided|Received from client|Handover received" "$plan" 2>/dev/null \
            | head -1 | sed 's/^[^:]*:[[:space:]]*//' | sed 's/\*\*//g' | tr -d '\r')
        # Reject: empty, bracketed placeholders, or a line still carrying template tokens.
        if [ -n "$receipt" ] \
            && ! printf '%s' "$receipt" | grep -qE "^\[.*\]$|\[what was received\]|\[client PIC\]|\[YYYY-MM-DD\]|\[what\]|<what>|<client PIC>|<YYYY-MM-DD>"; then
            echo "  ✅ $label: client input receipt recorded ($receipt)"
            return 0
        fi
        echo "  ❌ $label: the client-input line is present but still a placeholder."
        echo "     Record what actually arrived: 'Inputs-Received: <what> from <client PIC> on <YYYY-MM-DD>'."
        echo "     A filled key with no value is the same as no receipt."
        GATE_FAILED=1
        return 1
    fi

    echo "  ❌ $label: no record that the client-supplied inputs were actually received."
    echo "     Add 'Inputs-Received: <what> from <client PIC> on <YYYY-MM-DD>' to $plan"
    echo "     Source data / credentials come from the client — never invent or simulate them."
    GATE_FAILED=1
    return 1
}

# A2: content check — require core section headings from the matching template.
# A role placeholder ("Validation Lead", "Founder", "Admin") is not a named human.
# Sourced by the approver checks below; kept in one place so they cannot drift apart.
is_role_placeholder() {
    printf '%s' "$1" \
        | tr 'A-Z' 'a-z' \
        | grep -qE '^[[:space:]]*((validation|test|qa|project|tech|technical|engineering|delivery|product)[[:space:]-]+(lead|manager|owner|admin|approver|head)|founder|admin|team|owner|sme|dev|developer|tbd|n/?a|client|user)[[:space:]]*$'
}

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
    local alt="${2:-}"
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
    local alt="${2:-}"
    if [ -f "$file" ]; then
        echo "  [OK] $file (optional)"
    elif [ -n "$alt" ] && [ -f "$alt" ]; then
        echo "  [OK] $alt (optional)"
    else
        echo "  ⚠️  $file (optional, not found)"
    fi
}
