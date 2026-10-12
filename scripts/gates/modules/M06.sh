#!/usr/bin/env bash
# Gate: M06 — extracted from validate-gate.sh (verbatim body).
# Sourced by the dispatcher; do NOT execute directly.
# Shared helpers (check_required/check_optional/check_intake_gate/...) come
# from ../lib/checks.sh, which the dispatcher sources before this file.

# --- gate_M06 ------------------------------------------------------
gate_M06() {
    echo "=== M06: Development Execution Gate Checklist ==="
    check_intake_gate || true
    check_required "AGENTS.md" "" 500
    check_required "TODO.md" "" 500
    # B1: Small scale requires ONLY AGENTS.md + TODO.md at the root harness level.
    # CONTEXT.md / RUNBOOK_LOCAL.md / VERIFY_LOCAL.md are Medium+ requirements.
    is_m06_small=0
    if is_small_scale; then
        is_m06_small=1
        echo "  [INFO] Small scale detected: minimal root harness (AGENTS.md + TODO.md only)."
    else
        check_required "CONTEXT.md" "" 500
    fi

    # Content verification for TODO.md (BLOCKER: tasks must actually be completed)
    if [ -f "TODO.md" ]; then
        done_tasks=$(grep -cE "^\s*-\s*\[x\]" "TODO.md" 2>/dev/null || true)
        done_tasks=$(echo "$done_tasks" | tr -d ' ')
        if [ "${done_tasks:-0}" -ge 3 ]; then
            echo "  ✅ Completed tasks verified in TODO.md ($done_tasks tasks marked '[x]')"
        else
            echo "  ❌ TODO.md has insufficient completed tasks: found only ${done_tasks:-0} marked '[x]' (minimum 3 completed tasks required)!"
            GATE_FAILED=1
        fi
        # Zero unfinished tasks allowed when declaring M06 complete (no [ ], [~], or [!] permitted)
        pending_tasks=$(grep -cE "^\s*-\s*\[[ ~!]\]" "TODO.md" 2>/dev/null || true)
        pending_tasks=$(echo "$pending_tasks" | tr -d ' ')
        if [ "${pending_tasks:-0}" -gt 0 ]; then
            echo "  ❌ TODO.md has ${pending_tasks} unfinished/blocked task(s) marked '[ ]', '[~]', or '[!]'! All sprint tasks must be completed ([x]) before closing Module 06."
            GATE_FAILED=1
        else
            echo "  ✅ 100% Sprint completion verified: zero pending/blocked tasks in TODO.md"
        fi
        # Per-task human approval: a tick is only valid with a human approval line.
        # '|| true' keeps the checklist running so ALL failures print in one pass
        # (without it, 'set -e' aborts here and hides every later check).
        check_task_approval || true
        # B1: DB/BE/FE task categories required ONLY when the project declares a
        # database/backend (Intake field); pure frontend/CLI/utility projects skip.
        intake_nonfeat="$(get_field Intake-Non-Features docs/pm/PROJECT_STATE.md | tr '[:upper:]' '[:lower:]')"
        intake_p0="$(get_field Intake-P0-Features docs/pm/PROJECT_STATE.md | tr '[:upper:]' '[:lower:]')"
        m06_needs_backend=0
        if echo "$intake_nonfeat" | grep -qiE "database|backend|api|auth|login"; then
            m06_needs_backend=0 # explicitly excluded as a Non-Feature
        elif echo "$intake_p0" | grep -qiE "database|backend|api|auth|login|dashboard|crud" \
            || echo "$intake_nonfeat" | grep -qiE "^$"; then
            m06_needs_backend=1
        fi
        if [ "$is_m06_small" -eq 1 ] && [ "$m06_needs_backend" -eq 0 ]; then
            echo "  [INFO] No declared database/backend (Intake): DB/BE/FE task categories skipped."
        else
            has_core_categories=1
            for cat in "DB" "BE" "FE"; do
                if ! grep -qiE "M06-${cat}-[0-9]+" "TODO.md"; then
                    echo "  ❌ TODO.md missing core category tasks for 'M06-${cat}-xx'!"
                    has_core_categories=0
                    GATE_FAILED=1
                fi
            done
            if [ $has_core_categories -eq 1 ]; then
                echo "  ✅ Full-stack atomic task categories verified in TODO.md (DB, BE, FE)"
            fi
        fi
        # Mandatory specs pre-read task must exist and be completed
        if grep -qiE "M06-SETUP-03|Specs Pre-Read|Pre-Read Sign-Off" "TODO.md"; then
            if grep -iE "M06-SETUP-03|Pre-Read Sign-Off" "TODO.md" | grep -qE "^\s*-\s*\[x\]"; then
                echo "  ✅ Specs pre-read task verified (M06-SETUP-03 completed)"
            else
                echo "  ❌ Specs pre-read task (M06-SETUP-03) present but NOT completed! Read AGENTS/CONTEXT/PROJECT_LITE/FSD/PRD before coding."
                GATE_FAILED=1
            fi
        else
            echo "  ❌ TODO.md missing mandatory specs pre-read task (M06-SETUP-03)!"
            GATE_FAILED=1
        fi
    fi

    # Content verification for AGENTS.md (BLOCKER: quality / anti-slop guidelines)
    if [ -f "AGENTS.md" ]; then
        if grep -qiE "typescript|strict|anti-slop|guidelines|verification|test|standards" "AGENTS.md"; then
            echo "  ✅ AGENTS.md technical quality and engineering guidelines verified"
        else
            echo "  ❌ AGENTS.md missing technical guidelines / anti-slop engineering standards!"
            GATE_FAILED=1
        fi
    fi

    # Small scale absorbs M07 security (Opsi A): security checklist is part of M06 exit.
    if [ "$is_m06_small" -eq 1 ]; then
        echo "  [INFO] Small scale: SECURITY_CHECKLIST_SMALL.md absorbed into M06 (M07 folded)."
        check_required "docs/qa/SECURITY_CHECKLIST_SMALL.md" "SECURITY_CHECKLIST_SMALL.md" 300
        # Small has no M07: anti-vibe-code polish audit is enforced here instead.
        if [ -f "docs/qa/POLISH_AUDIT.md" ]; then
        polish_small=$(cat "docs/qa/POLISH_AUDIT.md" 2>/dev/null || true)
        if echo "$polish_small" | grep -qiE "NOT READY"; then
            echo "  ❌ POLISH_AUDIT.md reports NOT READY (blocking tells still open)!"
            GATE_FAILED=1
        elif echo "$polish_small" | grep -qiE "READY \(0 blocking tells\)|0 blocking"; then
            echo "  ✅ POLISH_AUDIT.md attests 0 blocking tells (ready)"
        else
            echo "  ❌ POLISH_AUDIT.md missing explicit READY attestation (0 blocking tells)!"
            GATE_FAILED=1
        fi
        else
        echo "  ❌ docs/qa/POLISH_AUDIT.md (MISSING: Small path has no M07 — run the 22-tell audit here)"
        GATE_FAILED=1
        fi
    fi
    # B1: RUNBOOK_LOCAL.md / VERIFY_LOCAL.md required only for Medium+ (not Small).
    if [ "$is_m06_small" -eq 0 ]; then
        runbook_path="RUNBOOK_LOCAL.md"
        for candidate in "RUNBOOK_LOCAL.md" "docs/RUNBOOK_LOCAL.md" "docs/specs/RUNBOOK_LOCAL.md"; do
            if [ -f "$candidate" ]; then runbook_path="$candidate"; break; fi
        done
        check_required "$runbook_path" "" 500
        verify_path="VERIFY_LOCAL.md"
        for candidate in "VERIFY_LOCAL.md" "docs/VERIFY_LOCAL.md" "docs/specs/VERIFY_LOCAL.md"; do
            if [ -f "$candidate" ]; then verify_path="$candidate"; break; fi
        done
        check_required "$verify_path" "" 500
    fi

    # Content verification for VERIFY_LOCAL.md (BLOCKER: local test pass proof)
    if [ -f "$verify_path" ]; then
        if grep -qiE "LOCAL PASS|\[x\]\s*\*?PASS\*?|Exit code 0|Smoke Test PASS|All assertions passed" "$verify_path"; then
            echo "  ✅ VERIFY_LOCAL.md test execution proof verified (LOCAL PASS / assertions passed)"
        else
            echo "  ❌ VERIFY_LOCAL.md missing proof of test execution (requires 'LOCAL PASS', 'Exit code 0', or passing test assertions)!"
            GATE_FAILED=1
        fi
    fi

    # Mechanical anti-slop source scan (BLOCKER): scan real source dirs only
    scan_dirs=""
    for d in "src" "app" "lib" "components" "pages" "server" "api"; do
        [ -d "$d" ] && scan_dirs="$scan_dirs $d"
    done
    if [ -n "$scan_dirs" ]; then
        # 1. Type-suppression escape hatches
        ts_ignore=$(grep -rInE "//\s*@ts-(ignore|nocheck|expect-error)" $scan_dirs 2>/dev/null | wc -l | tr -d ' ')
        if [ "${ts_ignore:-0}" -gt 0 ]; then
            echo "  ❌ Anti-slop: found ${ts_ignore} type-suppression escape hatch(es) (@ts-ignore / @ts-nocheck / @ts-expect-error) in source!"
            GATE_FAILED=1
        else
            echo "  ✅ Anti-slop: zero type-suppression escape hatches in source"
        fi
        # 2. Placeholder TODO stubs left in production code
        todo_stub=$(grep -rInE "//\s*TODO:?\s*(Implement|Add (your )?logic|Fill|Complete|Fix later)" $scan_dirs 2>/dev/null | wc -l | tr -d ' ')
        if [ "${todo_stub:-0}" -gt 0 ]; then
            echo "  ❌ Anti-slop: found ${todo_stub} unresolved placeholder TODO stub(s) in source!"
            GATE_FAILED=1
        else
            echo "  ✅ Anti-slop: zero placeholder TODO stubs in source"
        fi
        # 3. Hardcoded secret heuristics (assignment of a long literal to a secret-ish name)
        hc_secret=$(grep -rinE "(api_?key|secret|password|passwd|token|private_?key)[[:space:]]*[:=][[:space:]]*[\"'][^\"']{16,}" $scan_dirs 2>/dev/null | grep -viE "process\.env|import\.meta\.env|example|placeholder|your[_-]|xxx|\*\*\*|<REPLACE" | wc -l | tr -d ' ')
        if [ "${hc_secret:-0}" -gt 0 ]; then
            echo "  ❌ Anti-slop: found ${hc_secret} possible hardcoded secret(s) in source! Use process.env."
            GATE_FAILED=1
        else
            echo "  ✅ Anti-slop: zero obvious hardcoded secrets in source"
        fi
        # 4. Narrating / stub comments (ADVISORY — row 21 of POLISH_AUDIT; subjective, so non-blocking)
        slop_cmt=$(grep -rInE "(//|#)[[:space:]]*(Increment|Import|Get the|Set the|Initialize|Create a|This (function|method|class) (is|will)|Add your logic|Loop through|Return the result)" $scan_dirs 2>/dev/null | wc -l | tr -d ' ')
        if [ "${slop_cmt:-0}" -gt 0 ]; then
            echo "  ⚠️  Anti-slop advisory: ${slop_cmt} comment(s) that may merely restate the code (row 21 of POLISH_AUDIT). Review and delete if redundant."
        else
            echo "  ✅ Anti-slop: no narrating/stub comments detected in source"
        fi
        # 5. Unlocked read-modify-write on shared state (ADVISORY — row 22 of POLISH_AUDIT; must be attested there)
        rmw_files=$(find $scan_dirs -type f \( -name "*.sql" -o -name "*.ts" -o -name "*.js" -o -name "*.py" -o -name "*.php" -o -name "*.rb" -o -name "*.go" \) 2>/dev/null | head -400)
        if [ -n "$rmw_files" ]; then
            unlocked=$(awk '/UPDATE .*(stock|balance|qty|quantity|count|version)/ { if (!lock) print FILENAME":"FNR } { if (/FOR UPDATE|version =|BEGIN/) lock=1; if (/COMMIT|ROLLBACK/) lock=0 }' $rmw_files 2>/dev/null | wc -l | tr -d ' ')
            if [ "${unlocked:-0}" -gt 0 ]; then
                echo "  ⚠️  Anti-slop advisory: ${unlocked} UPDATE on shared state outside a locked transaction (row 22 of POLISH_AUDIT). Verify each has a row lock, unique constraint, or compare-and-swap."
            else
                echo "  ✅ Anti-slop: no unlocked read-modify-write detected on shared state"
            fi
        fi
    fi
    check_optional "ARCHITECTURE.md"
    check_optional "CONVENTIONS.md"
}
