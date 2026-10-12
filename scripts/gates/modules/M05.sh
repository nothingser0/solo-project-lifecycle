#!/usr/bin/env bash
# Gate: M05 — extracted from validate-gate.sh (verbatim body).
# Sourced by the dispatcher; do NOT execute directly.
# Shared helpers (check_required/check_optional/check_intake_gate/...) come
# from ../lib/checks.sh, which the dispatcher sources before this file.

# --- gate_M05 ------------------------------------------------------
gate_M05() {
    echo "=== M05: Architecture & Specs Gate Checklist ==="
    check_intake_gate || true
    if is_small_scale; then
        echo "  [INFO] Detected Small-Scale Fast-Track MVP path (PROJECT_LITE.md)"
        check_required "PROJECT_LITE.md" "" 1000
        if [ -f "PROJECT_LITE.md" ]; then
            if grep -iE "^\s*-\s*Feature|^\s*[0-9]+\.\s*\*\*\[Feature" "PROJECT_LITE.md" | grep -qiE "TBD|maybe|tentative|TBA|if time permits"; then
                echo "  ❌ Ambiguous terms (TBD/maybe/tentative) detected in PROJECT_LITE.md Must-Have features!"
                GATE_FAILED=1
            else
                echo "  ✅ Zero ambiguous terms in PROJECT_LITE.md Must-Have features"
            fi
            # Check Section 5 Architecture contains DDL/tables and API routes
            if grep -qiE "CREATE TABLE|model|table|database|schema" "PROJECT_LITE.md" && grep -qiE "/api|GET|POST|endpoints|routes" "PROJECT_LITE.md"; then
                echo "  ✅ Section 5 Architecture in PROJECT_LITE.md contains database schema and API contracts"
            else
                echo "  ❌ Section 5 Architecture in PROJECT_LITE.md missing database schema or API endpoint definitions!"
                GATE_FAILED=1
            fi
        fi
        check_optional "docs/specs/PRD.md"
        check_optional "docs/specs/FSD.md"
    else
    check_required "docs/specs/PRD.md" "" 2000
    check_required "docs/specs/FSD.md" "" 2000

    # Content verification for PRD.md (Medium & Large scales)
    if [ -f "docs/specs/PRD.md" ]; then
        prd="docs/specs/PRD.md"
        # A2: core section headings must be present (from PRD_FINAL_TEMPLATE.md)
        check_sections "$prd" "Document Metadata" "Functional Traceability Matrix"
        # 1. Traceability Matrix verification (REQ-xx / F-xx mapping)
        if grep -qiE "REQ-[0-9]+" "$prd" && grep -qiE "F-[0-9]+" "$prd"; then
            echo "  ✅ PRD.md functional traceability matrix verified (F-xx -> REQ-xx mapped)"
        else
            echo "  ❌ PRD.md missing functional traceability matrix (must map F-xx features to REQ-xx requirements)!"
            GATE_FAILED=1
        fi
        # 2. BDD Acceptance Criteria (Given-When-Then format)
        if grep -qiE "Given " "$prd" && grep -qiE "When " "$prd" && grep -qiE "Then " "$prd"; then
            echo "  ✅ PRD.md BDD release acceptance scenarios verified (Given-When-Then format)"
        else
            echo "  ❌ PRD.md missing Given-When-Then BDD acceptance scenarios in Section 8!"
            GATE_FAILED=1
        fi
    fi

    # Content verification for FSD.md (Medium & Large scales)
    if [ -f "docs/specs/FSD.md" ]; then
        fsd="docs/specs/FSD.md"
        # A2: core section headings must be present (from FSD_TECHNICAL_TEMPLATE.md)
        check_sections "$fsd" "Document Metadata" "Component Architecture" "Relational Database Schema"

        # 2. Database Schema DDL existence (BLOCKER)
        if grep -qiE "CREATE TABLE|mongoose\.Schema|models\.Model|Schema::create|model [A-Za-z]+ \{" "$fsd"; then
            echo "  ✅ Database schema definition verified in FSD.md (DDL / ORM models present)"
        else
            echo "  ❌ FSD.md missing explicit database schema definition (CREATE TABLE / ORM models)!"
            GATE_FAILED=1
        fi

        # 3. API Endpoints contract verification. STEP 4 and the exit criteria both
        #    promise an endpoint matrix of at least 10 (5 was enforced here while the
        #    runbook and deep dive both said 10 — a promise the script did not keep).
        ep_count=$(grep -iE "####\s*(GET|POST|PUT|PATCH|DELETE)|Route::(get|post|put|delete)|@(Get|Post|Put|Delete)Mapping|path:\s*/api" "$fsd" 2>/dev/null | wc -l || echo 0)
        ep_count=$(echo "$ep_count" | tr -d ' ')
        if [ "${ep_count:-0}" -ge 10 ]; then
            echo "  ✅ API endpoint contracts verified ($ep_count endpoints documented)"
        else
            echo "  ❌ FSD.md insufficient API endpoint contracts: found only ${ep_count:-0} endpoints (minimum 10 required by M05 STEP 4)!"
            GATE_FAILED=1
        fi

        # 4. Idempotency Key table verification for financial/mutation systems
        intake_sensitive="$(get_field Intake-Sensitive-Data docs/pm/PROJECT_STATE.md | tr '[:upper:]' '[:lower:]')"
        if [ "$intake_sensitive" = "yes" ]; then
            if grep -qiE "idempotency_keys|idempotency" "$fsd"; then
                echo "  ✅ Idempotency protection schema verified in FSD.md (idempotency_keys table present)"
            else
                echo "  ❌ FSD.md missing idempotency_keys table for financial/mutation project!"
                GATE_FAILED=1
            fi
        fi

        # 5. Multi-Tenant Row-Level Security (RLS) verification
        if grep -qiE "multi-tenant|branch|cabang|tenant|organization" docs/pm/PROJECT_STATE.md 2>/dev/null || grep -qiE "org_id|tenant_id" "$fsd"; then
            if grep -qiE "ROW LEVEL SECURITY|ENABLE ROW LEVEL SECURITY|rls" "$fsd"; then
                echo "  ✅ Multi-tenant isolation verified in FSD.md (Row-Level Security RLS present)"
            else
                echo "  ❌ FSD.md missing Row-Level Security (RLS) policies for multi-tenant data isolation!"
                GATE_FAILED=1
            fi
        fi
    fi

    # Architecture Decision Record is MANDATORY for Medium+ (justify architectural style choices)
    m05_scale="$(get_field Scale docs/pm/PROJECT_STATE.md | tr '[:upper:]' '[:lower:]')"
    if [ "$m05_scale" = "medium" ] || [ "$m05_scale" = "large" ] || [ "$m05_scale" = "enterprise" ]; then
        echo "  [INFO] Medium+ scale detected: Architecture Decision Record (ADR) is MANDATORY."
        check_required "docs/governance/ADR.md" "docs/specs/ADR.md" 500
    fi

    if [ "$m05_scale" = "enterprise" ]; then
        echo "  [INFO] Enterprise scale detected: ADR and Audit Trail Specs are MANDATORY."
        check_required "docs/governance/AUDIT_TRAIL_REQUIREMENTS.md" "docs/specs/AUDIT_TRAIL_REQUIREMENTS.md"
    fi
    check_optional "PROJECT_LITE.md"
    fi

    # 6. Stack Decision LOCKED — applies to BOTH paths (Small pins it in
    #    PROJECT_LITE.md, Medium+ in FSD.md). Kept OUTSIDE the scale branches:
    #    it was previously nested inside the FSD.md branch, so the Small path
    #    was never checked at all.
    m05_lock_target=""
    [ -f "PROJECT_LITE.md" ] && m05_lock_target="PROJECT_LITE.md"
    [ -z "$m05_lock_target" ] && [ -f "docs/specs/FSD.md" ] && m05_lock_target="docs/specs/FSD.md"
    if [ -n "$m05_lock_target" ]; then
        if grep -qiE "Stack Decision LOCKED:" "$m05_lock_target"; then
            echo "  ✅ Locked tech stack decision documented in $m05_lock_target"
        else
            echo "  ❌ $m05_lock_target missing locked tech stack decision ('Stack Decision LOCKED:')!"
            GATE_FAILED=1
        fi
    fi

    # 7. Stack lock must be backed by the 8 recorded questionnaire answers (human input).
    # '|| true' keeps the checklist running under 'set -e' so ALL failures print.
    check_stack_questionnaire || true

    # 8. Deliverables M05 STEP 5 and STEP 7 promise but nothing verified: the
    #    security blueprint, the Module 04 handoff that M06 STEP 0 depends on,
    #    and the human technical sign-off the templates ship blank. All three run
    #    for BOTH paths — a false-green here propagates into M06 unreviewed.
    check_security_blueprint || true
    check_handoff_strategy || true
    check_tech_signoff || true
}
