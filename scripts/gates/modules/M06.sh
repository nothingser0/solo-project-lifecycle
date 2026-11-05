#!/usr/bin/env bash
# Gate: M06 — extracted from validate-gate.sh (verbatim body).
# Sourced by the dispatcher; do NOT execute directly.
# Shared helpers (check_required/check_optional/check_intake_gate/...) come
# from ../lib/checks.sh, which the dispatcher sources before this file.

# --- gate_M06 ------------------------------------------------------
gate_M06() {
    echo "=== M06: Development Execution Gate Checklist ==="
    check_intake_gate || true
    # High-Water Mark / solo-capacity classifier, same as M01/M02/M05: M06 is the
    # gate coding starts under, so an unvalidated scale claim must not survive it.
    check_scale_feasibility || true
    # HARNESS POLICY (one rule, applied everywhere below): `docs/harness-root/` is a
    # STAGING directory. Files must end up at the project ROOT for this gate to pass —
    # that copy is the human step M06 exists to verify. The staging path is accepted only
    # where the gate needs to READ content before the copy happens (STEP 2 below enforces
    # root placement for all seven files, and B1 does the same for RUNBOOK/VERIFY).
    check_required "AGENTS.md" "docs/harness-root/AGENTS.md" 500
    check_required "TODO.md" "docs/harness-root/TODO.md" 500
    # B1: Small scale requires AGENTS.md + TODO.md + DESIGN.md at the root harness level.
    # CONTEXT.md / RUNBOOK_LOCAL.md / VERIFY_LOCAL.md are Medium+ requirements.
    is_m06_small=0
    if is_small_scale; then
        is_m06_small=1
        echo "  [INFO] Small scale detected: minimal root harness (AGENTS.md + TODO.md + DESIGN.md)."
        check_required "DESIGN.md" "docs/harness-root/DESIGN.md" 500
    else
        check_required "CONTEXT.md" "" 500
    fi

    # M06 STEP 0 (MANDATORY FIRST per the runbook): the FSD must carry the locked
    # stack decision and the Module 04 handoff strategy BEFORE any coding. Only the
    # deep-dive pseudo-code asserted this, so an agent could reach M06 with no locked
    # stack and no conversion plan for the frozen prototype.
    m06_spec=""
    [ -f "docs/specs/FSD.md" ] && m06_spec="docs/specs/FSD.md"
    [ -z "$m06_spec" ] && [ -f "PROJECT_LITE.md" ] && m06_spec="PROJECT_LITE.md"
    if [ -n "$m06_spec" ]; then
        if grep -qiE "Stack Decision LOCKED:" "$m06_spec"; then
            echo "  ✅ STEP 0: locked stack decision present in $m06_spec"
        else
            echo "  ❌ STEP 0: $m06_spec has no 'Stack Decision LOCKED:' — M06 must not start without the M05 stack lock!"
            GATE_FAILED=1
        fi
        # Small (PROJECT_LITE) has no handoff section; Medium+ FSD must define how the
        # frozen M04 prototype converts to the chosen stack (compatibility level 1-4).
        if [ "$m06_spec" = "docs/specs/FSD.md" ]; then
            if check_handoff_strategy "$m06_spec" "FSD.md"; then
                echo "  ✅ STEP 0: Module 04 Handoff Strategy present in FSD.md"
            else
                echo "  ❌ STEP 0: FSD.md missing the 'Module 04 Handoff Strategy' section (prototype conversion plan, Level 1-4)!"
                GATE_FAILED=1
            fi
        fi
    fi

    # M06 STEP 2 (STRICT ORDER): all 9 harness files must be in ROOT, not just the
    # three the checklist used to spot-check (AGENTS/CONTEXT/TODO). The runbook
    # promises "all 9 verified in root"; ARCHITECTURE/DESIGN/CONVENTIONS/.env.example/
    # RUNBOOK_LOCAL/VERIFY_LOCAL were only ever printed as optional warnings.
    if [ "$is_m06_small" -eq 0 ]; then
        # Harness files that only exist to satisfy a size floor are decoration. Each one earns its
        # place by containing the section its reader opens it for.
        if [ "$is_m06_small" -eq 0 ]; then
            m06_section_gaps=""
            grep -qiE "Troubleshooting|Reset to a clean state" RUNBOOK_LOCAL.md 2>/dev/null \
                || m06_section_gaps="$m06_section_gaps RUNBOOK_LOCAL.md:no-troubleshooting"
            grep -qiE "Decision Log|Known issues" CONTEXT.md 2>/dev/null \
                || m06_section_gaps="$m06_section_gaps CONTEXT.md:no-decision-log"
            grep -qiE "Rejected" ARCHITECTURE.md 2>/dev/null \
                || m06_section_gaps="$m06_section_gaps ARCHITECTURE.md:no-rejected-alternative"
            if [ -n "$m06_section_gaps" ]; then
                echo "  ❌ Harness file(s) present but missing the section they exist for:$m06_section_gaps"
                echo "     RUNBOOK_LOCAL needs the failures that stop a new machine; CONTEXT needs the decision log"
                echo "     and known debt; ARCHITECTURE needs at least one decision naming what was rejected."
                GATE_FAILED=1
            fi
        fi

        # The agent must know where the frozen prototypes live before writing a screen.
        if [ -f "AGENTS.md" ] && ! grep -qiE "docs/design/screens" AGENTS.md; then
            echo "  ❌ AGENTS.md never names the frozen prototype path (docs/design/screens/)."
            echo "     Without it the agent has no documented layout source and invents screens from memory."
            GATE_FAILED=1
        fi
        m06_harness_missing=""
        for hf in AGENTS.md CONTEXT.md ARCHITECTURE.md DESIGN.md CONVENTIONS.md TODO.md .env.example; do
            [ -f "$hf" ] || m06_harness_missing="$m06_harness_missing $hf"
        done
        if [ -n "$m06_harness_missing" ]; then
            echo "  ❌ STEP 2: harness file(s) missing from project root:$m06_harness_missing"
            echo "     Staging is transit, not a destination: copy the missing files above from docs/harness-root/"
            echo "     (or templates/04-dev-execution/<stack>/) to the project root, verify, THEN delete staging."
            GATE_FAILED=1
        else
            echo "  ✅ STEP 2: 9-file root harness complete (AGENTS/CONTEXT/ARCHITECTURE/DESIGN/CONVENTIONS/TODO/.env.example + RUNBOOK_LOCAL/VERIFY_LOCAL below)"
        fi
    fi

    # Evidence report (BLOCKER): STEP 6 tells the agent to write artifacts/final-evidence.md
    # and run check_evidence.py, but nothing enforced that, so "Evidence:" could be a path
    # that never existed. The check is existence/non-stub only; it cannot prove the run.
    if [ -f "artifacts/final-evidence.md" ]; then
        fw_root="$(cd "${SCRIPT_DIR:-scripts/gates}/../.." && pwd)"
        ev_out=$(python3 "$fw_root/scripts/verify/check_evidence.py" "$(pwd)" --report artifacts/final-evidence.md 2>&1)
        if printf '%s' "$ev_out" | grep -q "✅ Evidence check passed"; then
            echo "  ✅ Evidence report resolves (every cited path exists and is not a stub)"
        else
            echo "  ❌ Evidence report does not resolve:"
            printf '%s\n' "$ev_out" | grep -E "❌" | head -5 | sed 's/^/     /'
            GATE_FAILED=1
        fi
    else
        echo "  ❌ artifacts/final-evidence.md missing — STEP 6 requires an evidence report before completion."
        GATE_FAILED=1
    fi

    # DB defense (BLOCKER): an M06-DB-* task asserts the schema is real. A green unit test
    # against a stubbed repo is not that proof, so require the probe itself in the evidence
    # report. Scoped to M06-DB only: a UI task is covered by the route probe instead.
    db_todo="TODO.md"
    [ -f "$db_todo" ] || db_todo="docs/harness-root/TODO.md"
    if [ -f "$db_todo" ] && grep -qE '^\s*-\s*\[[xX]\]\s*\**M06-DB-' "$db_todo"; then
        ev_file="artifacts/final-evidence.md"
        missing=""
        for probe in 'migrate[^a-z]*down|down' 'COUNT\(' 'EXPLAIN'; do
            if ! grep -qiE "$probe" "$ev_file" 2>/dev/null; then
                case "$probe" in
                    'migrate[^a-z]*down|down') missing="$missing migrate-down" ;;
                    'COUNT\(')                 missing="$missing seeder-count" ;;
                    'EXPLAIN')                 missing="$missing explain" ;;
                esac
            fi
        done
        if [ -n "$missing" ]; then
            echo "  ❌ M06-DB tasks were marked '[x]' but the evidence shows no real-DB proof: missing$missing"
            echo "     Paste the raw probes into $ev_file: migrate up->down->up, seeder COUNT(*) before/after, EXPLAIN."
            echo "     A stubbed unit test is not setup evidence (docs/modules/06_DEVELOPMENT_EXECUTION.md 'DB defense')."
            GATE_FAILED=1
        else
            echo "  ✅ M06-DB evidence shows real-DB probes (reversible, idempotent, indexed)"

            # The probe must run against the database the app runs against. Migrating a local
            # Postgres while the app points at a hosted one (Neon, Supabase, RDS) tests a schema
            # nobody ships - the failure is invisible because both are "Postgres".
            configured_dsn=""
            for envf in .env .env.local .env.example; do
                [ -f "$envf" ] || continue
                configured_dsn=$(grep -hoiE "^(DATABASE_URL|DB_HOST|POSTGRES_HOST|DB_URL)=[^[:space:]]*" "$envf" 2>/dev/null | head -1 | sed -E 's/^[^=]*=//' | tr -d '"'"'"'' | tr '[:upper:]' '[:lower:]')
                [ -n "$configured_dsn" ] && break
            done
            if [ -n "$configured_dsn" ]; then
                ev_lc=$(tr '[:upper:]' '[:lower:]' < "$ev_file" 2>/dev/null || true)
                db_target=""
                for hint in neon supabase rds planetscale turso cockroach atlas railway render; do
                    case "$configured_dsn" in
                        *"$hint"*) db_target="$hint" ;;
                    esac
                done
                case "$configured_dsn" in
                    *localhost*|*127.0.0.1*) db_target="localhost" ;;
                esac
                if [ -n "$db_target" ]; then
                    if printf '%s' "$ev_lc" | grep -q "$db_target"; then
                        echo "  ✅ DB probes ran against the configured target (${db_target})"
                    else
                        echo "  ❌ DB probes never name the configured database target (${db_target}, from DATABASE_URL/DB_HOST)."
                        echo "     Probing a different server (e.g. local Postgres while the app uses ${db_target}) proves a schema you do not ship."
                        echo "     Paste the probe output including the host/dsn it ran against."
                        GATE_FAILED=1
                    fi
                fi
            fi
        fi
    fi

    # Content verification for TODO.md (BLOCKER: tasks must actually be completed)
    target_todo="TODO.md"
    [ -f "$target_todo" ] || target_todo="docs/harness-root/TODO.md"
    if [ -f "$target_todo" ]; then
        done_tasks=$(grep -cE "^\s*-\s*\[x\]" "$target_todo" 2>/dev/null || true)
        done_tasks=$(echo "$done_tasks" | tr -d ' ')
        if [ "${done_tasks:-0}" -ge 3 ]; then
            echo "  ✅ Completed tasks verified in TODO.md ($done_tasks tasks marked '[x]')"
        else
            echo "  ❌ TODO.md has insufficient completed tasks: found only ${done_tasks:-0} marked '[x]' (minimum 3 completed tasks required)!"
            GATE_FAILED=1
        fi
        # Zero unfinished tasks allowed when declaring M06 complete (no [ ], [~], or [!] permitted)
        pending_tasks=$(grep -cE "^\s*-\s*\[[ ~!]\]" "$target_todo" 2>/dev/null || true)
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
        # Universal: Core atomic task categories (SETUP, DB, BE, FE) required across ALL scales.
        # Note: If project is client-only / pure-frontend / no-DB, tasks marked 'N/A' satisfy this requirement.
        has_core_categories=1
        for cat in "SETUP" "DB" "BE" "FE"; do
            if ! grep -qiE "M06-${cat}-[0-9]+" "$target_todo"; then
                echo "  ❌ TODO.md missing core category tasks for 'M06-${cat}-xx'!"
                has_core_categories=0
                GATE_FAILED=1
            fi
        done
        if [ $has_core_categories -eq 1 ]; then
            echo "  ✅ Atomic task categories verified across all scales in TODO.md (SETUP, DB, BE, FE)"
        fi

        # Anti-Bundling & SITEMAP Screen Coverage Check
        sitemap_spec=""
        [ -f "docs/specs/SITEMAP.md" ] && sitemap_spec="docs/specs/SITEMAP.md"
        [ -z "$sitemap_spec" ] && [ -f "SITEMAP.md" ] && sitemap_spec="SITEMAP.md"
        if [ -n "$sitemap_spec" ]; then
            sitemap_scr_count=$(grep -oE "SCR-[0-9]+" "$sitemap_spec" | sort -u | wc -l || true)
            sitemap_scr_count=$(echo "$sitemap_scr_count" | tr -d ' ')
            todo_fe_count=$(grep -cE "M06-FE-[0-9]+" "$target_todo" || true)
            todo_fe_count=$(echo "$todo_fe_count" | tr -d ' ')
            # If SITEMAP defines 5 or more unique screens, TODO cannot drop more than 20% into lazy stubs
            min_fe_tasks=$(( sitemap_scr_count * 75 / 100 ))
            [ "${min_fe_tasks:-0}" -lt 4 ] && min_fe_tasks=4
            if [ "${sitemap_scr_count:-0}" -ge 5 ] && [ "${todo_fe_count:-0}" -lt "${min_fe_tasks}" ]; then
                echo "  ❌ TODO.md has lazy bundling! SITEMAP.md defines ${sitemap_scr_count} unique screens, but TODO.md has only ${todo_fe_count} FE tasks (minimum ${min_fe_tasks} required)."
                echo "     Every core SCR-xx screen in SITEMAP.md must have its own dedicated M06-FE-xx task."
                GATE_FAILED=1
            else
                echo "  ✅ FE task count matches SITEMAP screen count: ${todo_fe_count} task(s) for ${sitemap_scr_count} screen(s)"
            fi

            # A task per screen is a count, not a port. M04 froze a prototype for every SCR-xx;
            # if the shipped source never references that screen, the FE work was invented rather
            # than ported, and "Screen fidelity verified" was claiming something unmeasured.
            if [ -d "docs/design/screens" ] && { [ -d "src" ] || [ -d "app" ]; }; then
                fe_src_dirs="src app"
                unported=""
                ported=0
                for scr in $(grep -oE "SCR-[A-Z]*-?[0-9]+" "$sitemap_spec" | sort -u); do
                    if grep -rqiE "(^|[^A-Za-z0-9-])${scr}([^0-9]|$)" $fe_src_dirs 2>/dev/null; then
                        ported=$((ported + 1))
                    else
                        unported="$unported $scr"
                    fi
                done
                if [ -n "$unported" ]; then
                    echo "  ❌ Shipped source never references these frozen prototype screen(s):$unported"
                    echo "     Each screen in docs/design/screens/ must be ported; name its SCR-xx in the component/page so the port is traceable."
                    GATE_FAILED=1
                elif [ "$ported" -gt 0 ]; then
                    echo "  ✅ All ${ported} frozen prototype screen(s) are referenced by the shipped source"
                fi
            fi
        fi

        # Integration coverage. TODO_TEMPLATE.md ships a Sprint 6 of M06-INT-xx tasks (payment
        # gateway, webhooks, hardware), but nothing required them: a project whose FSD declares an
        # external integration could finish M06 with the wire-up simply absent.
        if [ -f "docs/specs/FSD.md" ]; then
            declared_integrations=""
            for kw in webhook payment-gateway:payment "payment gateway:payment" midtrans xendit stripe hardware:hardware; do
                label="${kw%%:*}"
                pattern="${kw#*:}"
                if grep -qiE "$pattern" docs/specs/FSD.md 2>/dev/null; then
                    declared_integrations="$declared_integrations $label"
                fi
            done
            if [ -n "$declared_integrations" ]; then
                if grep -qiE "M06-INT-[0-9]+" "$target_todo"; then
                    echo "  ✅ Integration wire-up tasks present for declared external integration(s):$declared_integrations"
                elif grep -qiE "M06-INT.*N/A|N/A.*integration" "$target_todo"; then
                    echo "  ✅ Declared integration(s) marked N/A with a stated rationale:$declared_integrations"
                else
                    echo "  ❌ FSD declares external integration(s):$declared_integrations but TODO.md has no M06-INT-xx task."
                    echo "     Add the wire-up task (webhook handler, gateway adapter) or record 'M06-INT: N/A — <why>'."
                    GATE_FAILED=1
                fi
            fi
        fi

        # Auth & RBAC Coverage Check
        needs_auth=0
        if [ -n "$sitemap_spec" ] && grep -qiE "/login|/auth|authentication|SCR-02" "$sitemap_spec"; then
            needs_auth=1
        elif [ -n "$m06_spec" ] && grep -qiE "supabase\.auth|nextauth|session|jwt|cookie|login" "$m06_spec"; then
            needs_auth=1
        fi
        if [ $needs_auth -eq 1 ]; then
            auth_line=$(grep -iE "M06-AUTH-[0-9]+|M06-SETUP-[0-9]+.*(auth|login)|M06-BE-[0-9]+.*(auth|login)|login|authentication" "$target_todo" | head -1)
            if [ -n "$auth_line" ]; then
                echo "  ✅ Authentication & RBAC tasks verified in TODO.md"

            else
                echo "  ❌ TODO.md missing required Authentication/RBAC task(s)! (SITEMAP/FSD specifies auth/login flow)"
                GATE_FAILED=1
            fi
        fi
        # Mandatory specs pre-read task must exist and be completed
        if grep -qiE "M06-SETUP-[0-9]+.*(Specs Pre-Read|Pre-Read|Read Specs)|Specs Pre-Read|Pre-Read Sign-Off" "$target_todo"; then
            if grep -iE "M06-SETUP-[0-9]+.*(Specs Pre-Read|Pre-Read|Read Specs)|Specs Pre-Read|Pre-Read Sign-Off" "$target_todo" | grep -qE "^\s*-\s*\[x\]"; then
                echo "  ✅ Specs pre-read task verified (Specs Pre-Read completed)"
            else
                echo "  ❌ Specs pre-read task present but NOT completed! Read AGENTS/CONTEXT/PROJECT_LITE/FSD/PRD before coding."
                GATE_FAILED=1
            fi
        else
            echo "  ❌ TODO.md missing mandatory specs pre-read task (M06-SETUP-xx Specs Pre-Read)!"
            GATE_FAILED=1
        fi
    fi

    # Content verification for AGENTS.md (BLOCKER: quality / anti-slop guidelines)
    target_agents="AGENTS.md"
    [ -f "$target_agents" ] || target_agents="docs/harness-root/AGENTS.md"
    if [ -f "$target_agents" ]; then
        if grep -qiE "typescript|strict|anti-slop|guidelines|verification|test|standards" "$target_agents"; then
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
        local polish_small=""
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
        echo "  ❌ docs/qa/POLISH_AUDIT.md (MISSING: Small path has no M07 — run the 33-tell audit here)"
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

    # Content verification for VERIFY_LOCAL.md (BLOCKER: local test pass proof for Medium+)
    if [ "$is_m06_small" -eq 0 ] && [ -n "${verify_path:-}" ] && [ -f "$verify_path" ]; then
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
        # 0. Retrofit design-reference guard (BLOCKER for any project with UI):
        # M04 requires HUMAN-supplied design references before design artifacts.
        # A project that started coding before this rule existed would otherwise
        # never be asked for them (M04 is already closed), so the requirement is
        # re-checked here whenever UI source directories are present.
        if [ -d "src" ] || [ -d "app" ] || [ -d "components" ] || [ -d "pages" ]; then
            check_design_inspiration || true
        fi
        # 1. Type-suppression escape hatches
        ts_ignore=$(grep -rInE "//\s*@ts-(ignore|nocheck|expect-error)" $scan_dirs 2>/dev/null | wc -l | tr -d ' ')
        if [ "${ts_ignore:-0}" -gt 0 ]; then
            echo "  ❌ Anti-slop: found ${ts_ignore} type-suppression escape hatch(es) (@ts-ignore / @ts-nocheck / @ts-expect-error) in source!"
            GATE_FAILED=1
        else
            echo "  ✅ Anti-slop: zero type-suppression escape hatches in source"
        fi
        # 2. Placeholder TODO stubs left in production code
        # Any TODO/FIXME/HACK/XXX in shipped source is unresolved work in a file that claims to
        # be done. The old pattern needed "TODO: Implement|Fill|Complete|Fix later" specifically,
        # so "// TODO: add validation later" shipped clean.
        todo_stub=$(grep -rInE "(//|/\*|#|--)[[:space:]]*(TODO|FIXME|HACK|XXX)([[:space:]]|:|\()" $scan_dirs 2>/dev/null \
            | grep -vE "(\.test\.|\.spec\.|__tests__|node_modules|\.d\.ts|\.json|\.md)" | wc -l | tr -d ' ')
        if [ "${todo_stub:-0}" -gt 0 ]; then
            echo "  ❌ Anti-slop: found ${todo_stub} unresolved placeholder TODO stub(s) in source!"
            GATE_FAILED=1
        else
            echo "  ✅ Anti-slop: zero placeholder TODO stubs in source"
        fi
        # 2b. Empty catch blocks / silent error swallowing (BLOCKER)
        # Prevents AI code from writing 'catch (e) {}' or 'catch {}' without handling/logging
        empty_catch=$(grep -rInE "catch[[:space:]]*(\([a-zA-Z0-9_]*\))?[[:space:]]*\{[[:space:]]*\}" $scan_dirs 2>/dev/null | grep -vE "(\.test\.|\.spec\.|__tests__|node_modules)" | wc -l | tr -d ' ')
        if [ "${empty_catch:-0}" -gt 0 ]; then
            echo "  ❌ Anti-slop: found ${empty_catch} empty catch block(s) swallowing errors silently in source! Log or handle errors."
            GATE_FAILED=1
        else
            echo "  ✅ Anti-slop: zero silent empty catch blocks in source"
        fi

        # 3. Hardcoded secret heuristics (assignment of a long literal to a secret-ish name)
        hc_secret=$(grep -rinE "(api_?key|secret|password|passwd|token|private_?key)[[:space:]]*[:=][[:space:]]*[\"'][^\"']{16,}" $scan_dirs 2>/dev/null | grep -viE "process\.env|import\.meta\.env|example|placeholder|your[_-]|xxx|\*\*\*|<REPLACE" | wc -l | tr -d ' ')
        if [ "${hc_secret:-0}" -gt 0 ]; then
            echo "  ❌ Anti-slop: found ${hc_secret} possible hardcoded secret(s) in source! Use process.env."
            GATE_FAILED=1
        else
            echo "  ✅ Anti-slop: zero obvious hardcoded secrets in source"
        fi
        # 3b. Gitignore & Secret Leak Guard (BLOCKER across all scales)
        # Prevents committing .env, .env.local, or secrets to public repositories
        if [ -f ".gitignore" ]; then
            if grep -qE "^\s*\.env" ".gitignore"; then
                echo "  ✅ Git hygiene: .gitignore exists and protects .env files"
            else
                echo "  ❌ Git hygiene: .gitignore found but does NOT ignore .env files (missing '.env*')!"
                GATE_FAILED=1
            fi
        else
            echo "  ❌ Git hygiene: .gitignore is missing from project root! Create .gitignore to prevent leaking secrets/build artifacts."
            GATE_FAILED=1
        fi
        # 4. Narrating / stub comments (BLOCKER — row 21 of POLISH_AUDIT)
        # What is forbidden is a comment that repeats the code or decorates it, not the comment
        # that explains a why. The old pattern matched thirteen capitalised phrases, so
        # "// increment the counter" and a banner of "====" both passed.
        slop_cmt=$(python3 - $scan_dirs <<'PYEOF' 2>/dev/null || echo 0
import os, re, sys
SKIP = (".test.", ".spec.", "__tests__", "node_modules", ".d.ts", ".json", ".lock")
LINE = re.compile(r"^\s*(?://+|#|/\*|\*)\s*(.*)$")
# a comment that narrates the next line
NARRATE = re.compile(
    r"^(increment|decrement|import|export|get the|set the|initialize|initialise|create a|"
    r"this (function|method|class|component) (is|will)|add your logic|loop through|"
    r"return the result|handle error|handle the error|update the|call the|fetch the|"
    r"define the|declare the|render the|check if|if the|now we|here we|first,|then,)\b",
    re.I)
# a decorative banner: ====, ----, ****, ####
BANNER = re.compile(r"^[=\-*#_~]{4,}$")
# every word shouting
SHOUT = re.compile(r"^[A-Z0-9 _\-!?.,:'\"/()]{12,}$")
hits = 0
for root in sys.argv[1:]:
    for dirpath, dirnames, filenames in os.walk(root):
        dirnames[:] = [d for d in dirnames if d not in ("node_modules", ".next", "dist", "build", ".git")]
        for fn in filenames:
            if any(s in fn for s in SKIP) or fn.endswith((".md", ".css")):
                continue
            try:
                lines = open(os.path.join(dirpath, fn), encoding="utf-8", errors="ignore").read().split("\n")
            except OSError:
                continue
            for ln in lines:
                m = LINE.match(ln)
                if not m:
                    continue
                body = m.group(1).strip()
                if not body or body.startswith("!"):
                    continue
                if BANNER.match(body) or NARRATE.match(body) or SHOUT.match(body):
                    hits += 1
print(hits)
PYEOF
)
        slop_cmt=$(printf '%s' "$slop_cmt" | tr -dc '0-9')
        if [ "${slop_cmt:-0}" -gt 0 ]; then
            echo "  ❌ Anti-slop: found ${slop_cmt} narrating / redundant comment(s) in source (e.g. '// Initialize', '// Handle error', '// Hero Section')!"
            echo "     AI agents must never use comments to narrate obvious code or scratchpad thoughts. Code must be self-documenting."
            GATE_FAILED=1
        else
            echo "  ✅ Anti-slop: zero narrating/stub comments detected in source"
        fi
        # 4b. Internal spec ID & slot leaks in UI/view layer (BLOCKER)
        # Catches SCR-xx, REQ-xx, M06-xx, [WASM Canvas slot], [slot], etc. leaking into user-facing markup/templates
        spec_leaks=$(grep -rInE "(SCR-[0-9]+|REQ-[0-9]+|M06-[A-Z]+-[0-9]+|\[.*(slot|placeholder|canvas).*\])" $scan_dirs 2>/dev/null \
            | grep -vE "(\.test\.|\.spec\.|__tests__|node_modules|\.d\.ts|\.json|\.md)" | wc -l | tr -d ' ')
        if [ "${spec_leaks:-0}" -gt 0 ]; then
            echo "  ❌ Anti-slop: found ${spec_leaks} internal spec identifier(s) / slot placeholder(s) leaking in source (e.g. SCR-xx, REQ-xx, [slot])!"
            echo "     Internal spec codes must never be visible to end users in UI headers, badges, or copy."
            GATE_FAILED=1
        else
            echo "  ✅ Anti-slop: zero internal spec identifiers / slot placeholders leaked in source"
        fi
        # 4d. Tech stack vendor leaks in customer UI (BLOCKER)
        # Catches Supabase Auth, Next.js, Prisma ORM, etc. leaking into customer-facing text
        tech_leaks=$(grep -rInE "(Supabase Auth|Powered by Next\.js|Dikembangkan dengan Next|Prisma ORM|Tailwind CSS)" $scan_dirs 2>/dev/null \
            | grep -vE "(\.test\.|\.spec\.|__tests__|node_modules|\.d\.ts|\.json|\.md|config|package)" | wc -l | tr -d ' ')
        if [ "${tech_leaks:-0}" -gt 0 ]; then
            echo "  ❌ Anti-slop: found ${tech_leaks} tech stack vendor leak(s) in customer UI (e.g. 'Supabase Auth', 'Next.js', 'Prisma')!"
            echo "     End users care about their domain problem, not your stack. Speak strictly in business domain language."
            GATE_FAILED=1
        else
            echo "  ✅ Anti-slop: zero tech stack / vendor leaks in customer UI"
        fi
        # 4e. Anti-Stub Page Blocker
        # Catches lazy hollow page files (< 400 bytes or < 12 lines) that merely render an <h1> placeholder
        stub_pages=""
        for pdir in "src/app" "app" "src/pages" "pages"; do
            if [ -d "$pdir" ]; then
                for pf in $(find "$pdir" -type f \( -name "page.tsx" -o -name "page.jsx" -o -name "page.js" \) 2>/dev/null); do
                    case "$pf" in
                        *loading*|*error*|*not-found*|*layout*) continue ;;
                    esac
                    plines=$(wc -l < "$pf" 2>/dev/null | tr -d ' ')
                    psize=$(wc -c < "$pf" 2>/dev/null | tr -d ' ')
                    if [ "${plines:-0}" -lt 12 ] || [ "${psize:-0}" -lt 400 ]; then
                        stub_pages="$stub_pages $pf"
                    fi
                done
            fi
        done
        if [ -n "$stub_pages" ]; then
            echo "  ❌ Anti-slop: found hollow stub page(s) with no real UI implementation (<12 lines / <400B):$stub_pages"
            echo "     Every route declared in the app must be fully implemented with real components, tables, or forms — never an empty placeholder."
            GATE_FAILED=1
        else
            echo "  ✅ Anti-slop: zero hollow stub pages detected in app routes"
        fi

        # 4f. Anti-Fake-Auth Navigation Blocker
        # Catches login forms where the submit button is a client <Link href="/dashboard"> without real authentication
        fake_auth=$(grep -rInE "<Link[^>]+href=[\"']/(dashboard|staff|admin|app)" $scan_dirs 2>/dev/null \
            | grep -iE "(login|auth)" | grep -vE "(\.test\.|\.spec\.|__tests__|node_modules|\.d\.ts)" | wc -l | tr -d ' ')
        if [ "${fake_auth:-0}" -gt 0 ]; then
            echo "  ❌ Anti-slop: found fake login form navigation! Submit button directly links to dashboard without authenticating credentials."
            echo "     Login forms must execute real authentication (calling Auth handler/API, handling errors, and setting secure session cookies)."
            GATE_FAILED=1
        else
            echo "  ✅ Anti-slop: zero fake login navigation links"
        fi

        # 4g. Anti-Dummy-URL, Lorem Ipsum & Mock Data in Production Source & Seeds
        # Catches example.com, placeholder.com, lorem ipsum, john doe in production components or prisma seeds
        dummy_urls=$(grep -rInE "(https?://example\.com|https?://placeholder\.com)" $scan_dirs prisma 2>/dev/null \
            | grep -vE "(\.test\.|\.spec\.|__tests__|node_modules|\.d\.ts|\.json|\.md|config)" | wc -l | tr -d ' ')
        if [ "${dummy_urls:-0}" -gt 0 ]; then
            echo "  ❌ Anti-slop: found ${dummy_urls} dummy mock URL(s) (example.com / placeholder.com) in UI/source/seeds! Use real fallback handlers or local assets."
            GATE_FAILED=1
        else
            echo "  ✅ Anti-slop: zero dummy mock URLs in production UI"
        fi

        # 4g2. Anti-Lorem Ipsum & Generic Persona Slop (BLOCKER)
        lorem_hits=$(grep -rInEi "(lorem[[:space:]]+ipsum|dolor[[:space:]]+sit[[:space:]]+amet|john[[:space:]]+doe|jane[[:space:]]+doe)" $scan_dirs prisma 2>/dev/null \
            | grep -vE "(\.test\.|\.spec\.|__tests__|node_modules|\.d\.ts|\.json|\.md)" | wc -l | tr -d ' ')
        if [ "${lorem_hits:-0}" -gt 0 ]; then
            echo "  ❌ Anti-slop: found ${lorem_hits} instance(s) of Lorem Ipsum / generic fake personas ('John Doe' / 'Lorem ipsum') in source or seeds!"
            echo "     Use realistic, contextual domain data (e.g. real customer names, Indonesian locale context, actual business descriptions)."
            GATE_FAILED=1
        else
            echo "  ✅ Anti-slop: zero Lorem Ipsum or generic persona slop in source/seeds"
        fi

        # 4g3. Anti-Dead Links (href="#" or href="") in UI Components (BLOCKER)
        dead_links=$(grep -rInE "(href=[\"']#[\"']|href=[\"'][\"'])" $scan_dirs 2>/dev/null \
            | grep -vE "(\.test\.|\.spec\.|__tests__|node_modules|\.d\.ts|\.json|\.md)" | wc -l | tr -d ' ')
        if [ "${dead_links:-0}" -gt 0 ]; then
            echo "  ❌ Anti-slop: found ${dead_links} dead link(s) (href='#' or href='') in UI components!"
            echo "     All links must point to valid declared routes or be replaced with functional buttons/dialog modals."
            GATE_FAILED=1
        else
            echo "  ✅ Anti-slop: zero dead links (href='#') detected in UI source"
        fi

        # 4f-i. Visual slop that the text checks cannot see. All five are static: no browser.
        # Each fires only on source that exists, so a project with no UI is unaffected.
        visual_report=$(GATE_TAILWIND_PALETTE="$(dirname "${BASH_SOURCE[0]}")/../lib/tailwind_palette.json" python3 - $scan_dirs <<'PYEOF' 2>/dev/null || echo "SKIP|||"
import os, re, sys, json

# Tailwind v3 hex values, so a class pair can be scored the same way a literal hex pair is.
# Without this, "text-slate-400 on bg-white" (2.6:1) passed as accessible.
PALETTE_PATH = os.path.join(os.path.dirname(os.path.abspath(__file__)) if "__file__" in dir() else ".", "")
try:
    _palette_file = os.environ.get("GATE_TAILWIND_PALETTE", "")
    PALETTE = json.load(open(_palette_file, encoding="utf-8")) if _palette_file and os.path.exists(_palette_file) else {}
except Exception:
    PALETTE = {}
TW_TEXT = re.compile(r"\btext-(?!xs\b|sm\b|base\b|lg\b|xl\b|2xl\b|3xl\b|4xl\b|5xl\b|6xl\b|7xl\b|8xl\b|9xl\b|left\b|center\b|right\b|justify\b|start\b|end\b|wrap\b|nowrap\b|balance\b|pretty\b|ellipsis\b|clip\b|transparent\b|current\b|inherit\b)([a-z]+)-(\d{2,3})\b")
TW_BG = re.compile(r"\bbg-(?!transparent\b|current\b|inherit\b|cover\b|contain\b|center\b|no-repeat\b|repeat\b|fixed\b|local\b|scroll\b)([a-z]+)-(\d{2,3})\b")

def tw_color(catalog, first, shade):
    key = f"{first}-{shade}" if shade else first
    val = catalog.get(key)
    return rgb(val) if val else None

# bare bg-white / bg-black / text-white carry no shade
TW_BARE = re.compile(r"\b(bg|text)-(white|black)\b")

SKIP_FILES = (".test.", ".spec.", "__tests__", "node_modules", ".d.ts", ".json", ".lock", ".md")
SKIP_DIRS = ("node_modules", ".next", "dist", "build", ".git", "coverage")
SRC_EXT = (".tsx", ".jsx", ".ts", ".js", ".vue", ".svelte", ".astro", ".html", ".css")

def files(roots):
    for root in roots:
        for dp, dn, fns in os.walk(root):
            dn[:] = [d for d in dn if d not in SKIP_DIRS]
            for fn in fns:
                if any(x in fn for x in SKIP_FILES) or fn.endswith(".d.ts"):
                    continue
                if fn.endswith(SRC_EXT):
                    p = os.path.join(dp, fn)
                    try:
                        yield p, open(p, encoding="utf-8", errors="ignore").read()
                    except OSError:
                        continue

def rgb(h):
    h = h.strip().lstrip("#")
    if len(h) == 3:
        h = "".join(c * 2 for c in h)
    if len(h) != 6 or any(c not in "0123456789abcdefABCDEF" for c in h):
        return None
    return tuple(int(h[i:i+2], 16) for i in (0, 2, 4))

def lum(c):
    def f(v):
        v /= 255.0
        return v / 12.92 if v <= 0.03928 else ((v + 0.055) / 1.055) ** 2.4
    r, g, b = (f(x) for x in c)
    return 0.2126 * r + 0.7152 * g + 0.0722 * b

def ratio(a, b):
    la, lb = lum(a), lum(b)
    hi, lo = max(la, lb), min(la, lb)
    return (hi + 0.05) / (lo + 0.05)

# Tailwind slate/gray/neutral pairs that are known-good are not worth re-deriving; only literal
# hex values are compared, because a class pair cannot be resolved without the compiled theme.
COLOR = re.compile(r"(?:^|[\s;{,'\"])(color|background(?:-color)?)\s*:\s*['\"]?(#[0-9a-fA-F]{3,6})")
SIZE = re.compile(r"fontSize\s*:\s*['\"]?(\d+(?:\.\d+)?)px")

contrast_bad, fonts_missing, scale_bad, bare_ctl = [], [], [], []
class_contrast_bad = []
for p, body in files(sys.argv[1:]):
    # --- contrast: only when both colours are literal hex in the same style object
    for style in re.findall(r"style=\{\{([^}]*)\}\}", body) + re.findall(r"style:\s*\{([^}]*)\}", body):
        d = {}
        for k, v in re.findall(r"(color|backgroundColor|background)\s*:\s*['\"]?(#[0-9a-fA-F]{3,6})", style):
            d["bg" if k != "color" else "fg"] = v
        if "fg" in d and "bg" in d:
            a, b = rgb(d["fg"]), rgb(d["bg"])
            if a and b and ratio(a, b) < 4.5:
                contrast_bad.append(f"{p} ({d['fg']} on {d['bg']} = {ratio(a, b):.2f}:1)")

    # --- class-based contrast: resolve Tailwind text-*/bg-* on the same element
    # The quote characters inside this pattern cannot be escaped for both the shell heredoc and
    # python, so the class expression is searched first and the string literal taken from it.
    for el_raw in re.findall(r"className=\{([^}]*)\}", body) + re.findall(r'className="([^"]*)"', body):
        el = el_raw.replace("`", "").replace("'", "").replace('"', "")
        t = TW_TEXT.search(el)
        b = TW_BG.search(el)
        bare = TW_BARE.findall(el)
        fg = bg = None
        fg_name = bg_name = ""
        if t:
            fg = tw_color(PALETTE, t.group(1), t.group(2))
            fg_name = f"text-{t.group(1)}-{t.group(2)}"
        if b:
            bg = tw_color(PALETTE, b.group(1), b.group(2))
            bg_name = f"bg-{b.group(1)}-{b.group(2)}"
        for prefix, name in bare:
            if prefix == "text" and not t:
                fg = tw_color(PALETTE, name, "")
                fg_name = f"text-{name}"
            if prefix == "bg" and not b:
                bg = tw_color(PALETTE, name, "")
                bg_name = f"bg-{name}"
        if fg and bg and ratio(fg, bg) < 4.5:
            class_contrast_bad.append(f"{p} ({fg_name} on {bg_name} = {ratio(fg, bg):.2f}:1)")

    # --- font must be loaded somewhere in the same tree
    for fam in set(re.findall(r"fontFamily\s*:\s*['\"]([A-Za-z0-9 ]+)['\"]", body)):
        fonts_missing.append((p, fam.strip()))

    # --- arbitrary px size that is in no token file
    for px in SIZE.findall(body):
        scale_bad.append((p, px))

    # --- form controls with no styling at all
    for tag, attrs in re.findall(r"<(select|input|textarea)\b([^>]*)>", body):
        if tag == "input" and re.search(r"type\s*=\s*['\"](hidden|checkbox|radio)['\"]", attrs):
            continue
        has_style = re.search(r"(className|class|style)\s*=", attrs)
        if not has_style:
            bare_ctl.append(f"{p} <{tag}>")

# a fontFamily is satisfied if ANY source or css file in the tree loads that family
all_bodies = [b for _, b in files(sys.argv[1:])]
loaded = set()
for b in all_bodies:
    for fam in re.findall(r"from\s+['\"]next/font/(?:google|local)['\"]", b):
        loaded.add("*nextfont*")
    for fam in re.findall(r"@font-face\s*\{[^}]*font-family\s*:\s*['\"]?([A-Za-z0-9 ]+)", b):
        loaded.add(fam.strip().lower())
    for fam in re.findall(r"fonts\.googleapis\.com[^\"']*family=([A-Za-z0-9+]+)", b):
        loaded.add(fam.replace("+", " ").lower())
    for fam in re.findall(r"@import\s+url\([^)]*family=([A-Za-z0-9+]+)", b):
        loaded.add(fam.replace("+", " ").lower())
    for fam in re.findall(r"import\s+\{\s*([A-Za-z0-9_]+)\s*\}\s+from\s+['\"]next/font", b):
        loaded.add(fam.lower())

missing = []
for p, fam in fonts_missing:
    f = fam.lower()
    if f in loaded or "*nextfont*" in loaded or f.replace(" ", "") in {x.replace(" ", "") for x in loaded}:
        continue
    missing.append(f"{p} ({fam})")
missing = sorted(set(missing))

print("CONTRAST||" + "; ".join(sorted(set(contrast_bad + class_contrast_bad))))
print("FONTS||" + "; ".join(missing))
print("SCALE||" + "; ".join(f"{p}:{px}px" for p, px in sorted(set(scale_bad))))
print("BARECTL||" + "; ".join(sorted(set(bare_ctl))))
PYEOF
)

        v_contrast=$(printf '%s\n' "$visual_report" | sed -n 's/^CONTRAST||//p')
        v_fonts=$(printf '%s\n' "$visual_report" | sed -n 's/^FONTS||//p')
        v_scale=$(printf '%s\n' "$visual_report" | sed -n 's/^SCALE||//p')
        v_bare=$(printf '%s\n' "$visual_report" | sed -n 's/^BARECTL||//p')

        # C1. Contrast below WCAG AA. Only literal hex pairs are compared, so this is arithmetic.
        if [ -n "$v_contrast" ]; then
            echo "  ❌ Accessibility: text/background contrast below WCAG AA 4.5:1 -> $v_contrast"
            echo "     Raise contrast or move the pair into DESIGN.md as a tested token."
            GATE_FAILED=1
        else
            echo "  ✅ Accessibility: no literal colour pair falls below 4.5:1"
        fi

        # C2. A font-family declared but never loaded renders as a fallback nobody chose.
        if [ -n "$v_fonts" ]; then
            echo "  ❌ Typography: font-family used but never loaded -> $v_fonts"
            echo "     Load it with next/font, @font-face, a <link> or an @import - or use the stack in DESIGN.md."
            GATE_FAILED=1
        else
            echo "  ✅ Typography: every declared font-family is loaded"
        fi

        # C3. Arbitrary px sizes bypass the type scale, which is how a page ends up with seven sizes.
        # The design tokens live in the M04 prototype folder; the harness root also carries a
        # DESIGN.md, and a project may only have one of the two. Check both.
        scale_src=""
        for cand in docs/design/DESIGN.md DESIGN.md docs/harness-root/DESIGN.md; do
            [ -f "$cand" ] && scale_src="$cand" && break
        done
        if [ -n "$v_scale" ]; then
            if [ -n "$scale_src" ] && grep -qoE "[0-9]+px" "$scale_src" 2>/dev/null; then
                unscaled=""
                for entry in $v_scale; do
                    px="${entry##*:}"
                    grep -q "$px" "$scale_src" 2>/dev/null || unscaled="$unscaled $entry"
                done
                if [ -n "$unscaled" ]; then
                    echo "  ❌ Typography: font size(s) not in the $scale_src type scale ->$unscaled"
                    GATE_FAILED=1
                else
                    echo "  ✅ Typography: every literal font size appears in the $scale_src scale"
                fi
            else
                echo "  ❌ Typography: hard-coded font size(s) but DESIGN.md defines no px type scale -> $v_scale"
                GATE_FAILED=1
            fi
        else
            echo "  ✅ Typography: no hard-coded font sizes outside the scale"
        fi

        # C4. A bare <select>/<input>/<textarea> renders the browser default - the unstyled
        # dropdown that ships when nobody ports the prototype's control.
        if [ -n "$v_bare" ]; then
            echo "  ❌ Components: form control(s) rendered with no className/style -> $v_bare"
            echo "     Port the control from the prototype; a native default control is a design defect."
            GATE_FAILED=1
        else
            echo "  ✅ Components: every form control carries styling"
        fi

        # C5. An FSD that asks for an upload / popover but ships only a text input lost a requirement.
        if [ -f docs/specs/FSD.md ]; then
            if grep -qiE "(upload|unggah|file input|attach|lampiran).*(\.jpg|\.pdf|\.png|kb|mb|file)" docs/specs/FSD.md; then
                if ! grep -rqiE "type=[\"']file[\"']|accept=[\"']|useDropzone|FileInput|UploadZone" $scan_dirs 2>/dev/null; then
                    echo "  ❌ Requirements: FSD specifies a file upload but no file input exists in the shipped source."
                    GATE_FAILED=1
                else
                    echo "  ✅ Requirements: the FSD file-upload requirement has a file input"
                fi
            fi
            if grep -qiE "(popover|searchable list|dropdown|combobox|autocomplete)" docs/specs/FSD.md; then
                if ! grep -rqiE "(combobox|listbox|Popover|Command|Dropdown|Select)" $scan_dirs 2>/dev/null; then
                    echo "  ❌ Requirements: FSD specifies a popover/combobox but no such component exists."
                    GATE_FAILED=1
                else
                    echo "  ✅ Requirements: the FSD popover/combobox requirement has a component"
                fi
            fi
        fi

        # 4h. Multi-Role Capability & Route Protection Guard (BLOCKER)
        # If FSD or SITEMAP defines operational roles (Staff / Operator / Manager),
        # verify that the codebase implements role-aware logic, session checks, or dedicated operational routing.
        fsd_file="docs/specs/FSD.md"
        [ -f "$fsd_file" ] || fsd_file="docs/specs/PROJECT_LITE.md"
        if [ -f "$fsd_file" ] && grep -qiE "Staff|Operator|Manager" "$fsd_file" 2>/dev/null; then
            has_role_handling=$(grep -rInE "(role.*===|role.*==|user\.role|session.*role|isStaff|isOwner|hasRole|requireRole|checkRole)" $scan_dirs 2>/dev/null \
                | grep -vE "(\.test\.|\.spec\.|__tests__|node_modules|\.d\.ts)" | wc -l | tr -d ' ')
            if [ "${has_role_handling:-0}" -eq 0 ]; then
                echo "  ❌ Multi-role architecture defined in $fsd_file (Staff/Operator/Manager) but zero role authorization checks (role === / user.role / requireRole) found in source!"
                echo "     Implement server-side role enforcement and frontend role masking to protect sensitive views and operations."
                GATE_FAILED=1
            else
                echo "  ✅ Multi-role authorization verified: ${has_role_handling} role-conditional check(s) found in source"
            fi
        fi

        # 4i. Zero Raw Browser Alerts Blocker (BLOCKER)
        # Catches alert(), window.alert(), confirm(), window.confirm(), prompt(), window.prompt() in UI code
        raw_alerts=$(grep -rInE "(window\.(alert|confirm|prompt)\(|\b(alert|confirm|prompt)\([\"'\`])" $scan_dirs 2>/dev/null \
            | grep -vE "(\.test\.|\.spec\.|__tests__|node_modules|\.d\.ts|\.json|\.md|config)" | wc -l | tr -d ' ')
        if [ "${raw_alerts:-0}" -gt 0 ]; then
            echo "  ❌ Anti-slop: found ${raw_alerts} raw browser alert/confirm/prompt call(s) in source!"
            echo "     Raw browser alerts are prohibited. Use custom Dialog/Modal or Toast (Sonner/HotToast) components styled to match system design tokens."
            GATE_FAILED=1
        else
            echo "  ✅ Anti-slop: zero raw browser alert/confirm/prompt calls in UI source"
        fi

        # 4j. Stray Debug console.log in Production Source (BLOCKER)
        # Catches console.log / console.debug left in production UI & API code
        stray_logs=$(grep -rInE "\bconsole\.(log|debug)\(" $scan_dirs 2>/dev/null \
            | grep -vE "(\.test\.|\.spec\.|__tests__|node_modules|\.d\.ts|\.json|\.md|scripts)" | wc -l | tr -d ' ')
        if [ "${stray_logs:-0}" -gt 0 ]; then
            echo "  ❌ Anti-slop: found ${stray_logs} stray debug console.log/debug call(s) in production source!"
            echo "     Remove leftover debug statements or route structured logs through a proper logger."
            GATE_FAILED=1
        else
            echo "  ✅ Anti-slop: zero stray console.log debug calls in production source"
        fi

        # 4k. TypeScript Escape Hatches (any Type Slop) (BLOCKER)
        # Catches ': any' or 'as any' in application source
        any_types=$(grep -rInE "(:[[:space:]]*any\b|as[[:space:]]+any\b)" $scan_dirs 2>/dev/null \
            | grep -vE "(\.test\.|\.spec\.|__tests__|node_modules|\.d\.ts|\.json|\.md)" | wc -l | tr -d ' ')
        if [ "${any_types:-0}" -gt 0 ]; then
            echo "  ❌ Anti-slop: found ${any_types} ': any' / 'as any' type bypasses in source!"
            echo "     Define explicit domain types/interfaces or use 'unknown' with proper type guards."
            GATE_FAILED=1
        else
            echo "  ✅ Anti-slop: zero unconstrained 'any' types in production source"
        fi
        # 4c. Raw emoji / emoticon in UI components & source (BLOCKER — row 26 of POLISH_AUDIT: zero emoticons mandate)
        # Codepoint ranges are matched with python3 on purpose: grep -P rejects \x{1F300} under
        # LC_ALL=C ("character code point value too large"), which is how CI runs, and the old
        # range skipped U+2600-U+26FF altogether - so ⚡ ⚙ ⚠ passed as "zero emoticons".
        raw_emojis=$(python3 - $scan_dirs <<'PYEOF' 2>/dev/null || echo 0
import os, re, sys
RANGES = [
    (0x2190, 0x21FF), (0x2300, 0x23FF), (0x25A0, 0x27BF), (0x2900, 0x297F),
    (0x2B00, 0x2BFF), (0x1F000, 0x1FAFF), (0xFE0F, 0xFE0F), (0x200D, 0x200D),
]
PAT = re.compile("[" + "".join(f"{chr(a)}-{chr(b)}" for a, b in RANGES) + "]")
SKIP = (".test.", ".spec.", "__tests__", "node_modules", ".d.ts", ".json", ".lock")
hits = 0
for root in sys.argv[1:]:
    for dirpath, dirnames, filenames in os.walk(root):
        dirnames[:] = [d for d in dirnames if d not in ("node_modules", ".next", "dist", "build", ".git")]
        for fn in filenames:
            if any(s in fn for s in SKIP):
                continue
            try:
                body = open(os.path.join(dirpath, fn), encoding="utf-8", errors="ignore").read()
            except OSError:
                continue
            hits += len(PAT.findall(body))
print(hits)
PYEOF
)
        raw_emojis=$(printf '%s' "$raw_emojis" | tr -dc '0-9')
        if [ "${raw_emojis:-0}" -gt 0 ]; then
            echo "  ❌ Anti-slop: found ${raw_emojis} raw emoji / emoticon character(s) in source (e.g. 🚀, 💡, ⚡, ⚙️, ✨)!"
            echo "     Raw unicode emojis are strictly forbidden in production code. Use cohesive SVG icons (e.g. Lucide) instead."
            GATE_FAILED=1
        else
            echo "  ✅ Anti-slop: zero raw emoticons detected in UI source"
        fi
        # 5. Hydration discipline.
        # Only a component that is ACTUALLY HYDRATED can mismatch, so the scan is
        # hydration-model aware — the same pattern means opposite things per stack:
        #   - Next.js App Router: a file declaring 'use client' hydrates; a file
        #     without it is a Server Component (never hydrated → Date.now() there is
        #     safe). Whether a directive-less file is imported under a client
        #     boundary is unknowable by grep (no import graph), so it is ADVISORY.
        #   - Astro: only an island with client:* hydrates; .astro pages do not.
        #   - Nuxt / SvelteKit / Remix / MERN+SSR: every component hydrates.
        # Within the hydrated set, a non-deterministic value with no defer hook
        # (useEffect/onMount/$effect) means the call ran during render — that is the
        # one case that can be stated as fact, so it is the only BLOCKER.
        # NOTE: Intl.*Format is deliberately NOT flagged — an explicit locale +
        # timeZone is the documented FIX; only bare toLocale* uses ambient locale.
        is_next_app=0
        for cfg in next.config.js next.config.mjs next.config.ts next.config.cjs; do
            [ -f "$cfg" ] && is_next_app=1 && break
        done
        is_astro=0
        for cfg in astro.config.mjs astro.config.ts astro.config.js; do
            [ -f "$cfg" ] && is_astro=1 && break
        done
        ui_files=$(find $scan_dirs -type f \( -name "*.tsx" -o -name "*.jsx" -o -name "*.vue" -o -name "*.svelte" -o -name "*.astro" \) 2>/dev/null \
            ! -name "*.server.*" ! -path "*/server/*" ! -path "*/api/*" | head -400)
        if [ -n "$ui_files" ]; then
            nd_pat="Date\.now\(|new Date\(|Math\.random\(|localStorage|sessionStorage|toLocaleString\(|toLocaleDateString\(|toLocaleTimeString\("
            hook_pat="useEffect|useLayoutEffect|onMount|onMounted|useMounted|\\\$effect|watchEffect|afterMount"
            hydration_blockers=0
            hydration_advisory=0
            hydration_safe=0
            while IFS= read -r uif; do
                [ -f "$uif" ] || continue
                grep -qE "$nd_pat" "$uif" 2>/dev/null || continue
                # Does this particular file hydrate on the client?
                hydrates=1
                if [ "$is_next_app" -eq 1 ]; then
                    grep -qE "['\"]use client['\"]" "$uif" 2>/dev/null || hydrates=0
                elif [ "$is_astro" -eq 1 ]; then
                    grep -qE "client:(load|idle|visible|media|only)" "$uif" 2>/dev/null || hydrates=0
                fi
                if [ "$hydrates" -eq 0 ]; then
                    # Server Component / static Astro page: never hydrated, so a
                    # render-time clock is correct static HTML, not a mismatch.
                    hydration_safe=$((hydration_safe + 1))
                    continue
                fi
                # A per-file exemption ('hydration-exempt: <reason>') is the human's
                # explicit acceptance of ONE known-unknowable node; a stated reason is
                # required, and it is still surfaced for review.
                if grep -qE "hydration-exempt:?[[:space:]]*[A-Za-z]" "$uif" 2>/dev/null; then
                    echo "  [INFO] Hydration exemption declared in $uif — reviewer must confirm it is a single node with a real reason."
                elif grep -qE "$hook_pat" "$uif" 2>/dev/null; then
                    hydration_advisory=$((hydration_advisory + 1))
                else
                    hydration_blockers=$((hydration_blockers + 1))
                    echo "  ❌ Hydration: $uif is client-hydrated and renders a non-deterministic value"
                    echo "     (Date.now/new Date/Math.random/localStorage/toLocale*) with no defer hook — server"
                    echo "     and client HTML will differ. Format server-side with an explicit locale + timeZone,"
                    echo "     pass the value in as a prop, or read it after mount."
                    echo "     See references/technical/HYDRATION_FREE_RENDERING.md."
                fi
            done <<EOF
$ui_files
EOF
            if [ "${hydration_blockers:-0}" -gt 0 ]; then
                GATE_FAILED=1
            else
                echo "  ✅ Hydration: no render-time non-determinism in hydrated component(s)"
            fi
            if [ "${hydration_safe:-0}" -gt 0 ]; then
                echo "  [INFO] Hydration: ${hydration_safe} server-only file(s) use a render-time value — correct (never hydrated)."
            fi
            if [ "${hydration_advisory:-0}" -gt 0 ]; then
                echo "  ⚠️  Hydration advisory: ${hydration_advisory} hydrated component(s) use non-deterministic values AND a"
                echo "     defer hook — confirm each call sits INSIDE the hook, not in render (VERIFY_LOCAL.md §4C)."
            fi
            # suppressHydrationWarning is a React attribute; Vue/Svelte/Astro have
            # their own (or none), so only React source is checked here.
            suppress_files=$(find $scan_dirs -type f \( -name "*.tsx" -o -name "*.jsx" \) 2>/dev/null \
                | xargs grep -lE "suppressHydrationWarning" 2>/dev/null | head -50)
            unexempt=0
            for sf in $suppress_files; do
                grep -qE "hydration-exempt" "$sf" 2>/dev/null || unexempt=$((unexempt + 1))
            done
            if [ "${unexempt:-0}" -gt 0 ]; then
                echo "  ❌ Hydration: ${unexempt} file(s) use suppressHydrationWarning without a justification."
                echo "     Fix the mismatch (deterministic format / post-mount read / client-only island). If one"
                echo "     node is genuinely unknowable, add a 'hydration-exempt: <reason>' comment next to it."
                GATE_FAILED=1
            fi
        fi
        # 6. Unlocked read-modify-write on shared state (ADVISORY — row 22 of POLISH_AUDIT; must be attested there)
        rmw_files=$(find $scan_dirs -type f \( -name "*.sql" -o -name "*.ts" -o -name "*.js" -o -name "*.py" -o -name "*.php" -o -name "*.rb" -o -name "*.go" \) 2>/dev/null | head -400)
        if [ -n "$rmw_files" ]; then
            unlocked=$(awk '/UPDATE .*(stock|balance|qty|quantity|count|version)/ { if (!lock) print FILENAME":"FNR } { if (/FOR UPDATE|version =|BEGIN/) lock=1; if (/COMMIT|ROLLBACK/) lock=0 }' $rmw_files 2>/dev/null | wc -l | tr -d ' ')
            if [ "${unlocked:-0}" -gt 0 ]; then
                echo "  ⚠️  Anti-slop advisory: ${unlocked} UPDATE on shared state outside a locked transaction (row 22 of POLISH_AUDIT). Verify each has a row lock, unique constraint, or compare-and-swap."
            else
                echo "  ✅ Anti-slop: no unlocked read-modify-write detected on shared state"
            fi
        fi
        # 7. Design inspiration adherence verification
        if [ -d "docs/design/inspiration" ] && [ "$(find docs/design/inspiration -type f 2>/dev/null | wc -l)" -gt 0 ]; then
            if [ -f "DESIGN.md" ]; then
                echo "  ✅ Visual inspiration: reference files present in docs/design/inspiration/ and DESIGN.md tracked"
            else
                echo "  ⚠️  Visual inspiration: inspiration files present but DESIGN.md missing at root"
            fi
        fi
    fi
    # ARCHITECTURE.md and CONVENTIONS.md are already strictly checked in STEP 2 for Medium+
    if [ "$is_m06_small" -eq 1 ]; then
        check_optional "ARCHITECTURE.md"
        check_optional "CONVENTIONS.md"
    fi
    check_optional "AI_REVIEW_LOG.md" "docs/qa/AI_REVIEW_LOG.md"
    check_optional "DEVELOPMENT_PROGRESS_TRACKER.md" "docs/pm/DEVELOPMENT_PROGRESS_TRACKER.md"
}
