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
        local lite="PROJECT_LITE.md"
        [ -f "$lite" ] || lite="docs/specs/PROJECT_LITE.md"
        check_required "$lite" "PROJECT_LITE.md" 1000
        if [ -f "$lite" ]; then
            if grep -iE "^\s*-\s*Feature|^\s*[0-9]+\.\s*\*\*\[Feature" "$lite" | grep -qiE "TBD|maybe|tentative|TBA|if time permits"; then
                echo "  ❌ Ambiguous terms (TBD/maybe/tentative) detected in $lite Must-Have features!"
                GATE_FAILED=1
            else
                echo "  ✅ Zero ambiguous terms in $lite Must-Have features"
            fi
            if grep -qiE "CREATE TABLE|model|table|database|schema" "$lite" && grep -qiE "/api|GET|POST|endpoints|routes" "$lite"; then
                echo "  ✅ Section 5 Architecture in $lite contains database schema and API contracts"
            else
                echo "  ❌ Section 5 Architecture in $lite missing database schema or API endpoint definitions!"
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

        # 1b. Pinned Framework & Ecosystem Libraries check (Anti-Slop Guard)
        if grep -qiE "Framework Versions.*\(Pinned\)" "$fsd"; then
            if grep -qiE -- "-\s*\*\*(Authentication|Auth)\*\*:" "$fsd" && \
               grep -qiE -- "-\s*\*\*(Form|Validation)\*\*:" "$fsd"; then
                echo "  ✅ Pinned ecosystem libraries (Auth, Validation, Framework) verified in FSD.md"
            else
                echo "  ❌ FSD.md missing explicit ecosystem library pinning (Authentication, Validation) in Framework Versions block!"
                GATE_FAILED=1
            fi
        else
            echo "  ❌ FSD.md missing 'Framework Versions & Ecosystem Libraries (Pinned)' section!"
            GATE_FAILED=1
        fi

        # 2. Database Schema DDL & Visual ERD existence (BLOCKER)
        if grep -qiE "CREATE TABLE|mongoose\.Schema|models\.Model|Schema::create|model [A-Za-z]+ \{" "$fsd"; then
            echo "  ✅ Database schema definition verified in FSD.md (DDL / ORM models present)"
        else
            echo "  ❌ FSD.md missing explicit database schema definition (CREATE TABLE / ORM models)!"
            GATE_FAILED=1
        fi
        if grep -qiE "erDiagram" "$fsd"; then
            echo "  ✅ Visual Entity Relationship Diagram (Mermaid erDiagram) verified in FSD.md"
        else
            echo "  ❌ FSD.md missing Visual ERD! Include a mermaid erDiagram block in Section 2.2."
            GATE_FAILED=1
        fi
        if grep -qiE "CREATE INDEX|idx_[A-Za-z0-9_]+|INDEX|uniqueIndex" "$fsd"; then
            echo "  ✅ Database performance indexing verified in FSD.md (indexes present)"
        else
            echo "  ❌ FSD.md missing explicit performance indexes (e.g. CREATE INDEX idx_* on foreign keys / query columns)!"
            GATE_FAILED=1
        fi

        # 3. API Endpoints contract verification (M05 STEP 4: minimum 10 endpoint headings).
        #    Count endpoint HEADINGS (one per endpoint), not body lines: the FSD template
        #    shows the verb+path in a heading, and the older pattern demanded a '####'
        #    prefix with no leading-space tolerance, so a template-faithful FSD scored 0
        #    and could never pass its own gate. The 10 floor matches STEP 4 / the exit
        #    criteria / the deep dive (this file previously enforced only 5).
        ep_count=$(grep -icE "^\s*#{2,6}\s*(GET|POST|PUT|PATCH|DELETE)\s+/|Route::(get|post|put|delete)|@(Get|Post|Put|Delete)Mapping" "$fsd" 2>/dev/null || echo 0)
        ep_count=$(echo "$ep_count" | tr -d ' ')
        if [ "${ep_count:-0}" -ge 10 ]; then
            echo "  ✅ API endpoint contracts verified ($ep_count endpoints documented)"
            # A heading is not a contract. Count headings that carry the four fields a
            # consumer needs: who may call it, what it takes, what success looks like,
            # and how it fails. Without this, ten empty headings satisfied the gate.
            contracted=$(awk '
                /^[[:space:]]*#{2,6}[[:space:]]*(GET|POST|PUT|PATCH|DELETE)[[:space:]]+\// {
                    if (inb && has_auth && has_req && has_succ && has_err) ok++
                    inb=1; has_auth=has_req=has_succ=has_err=0; next
                }
                /^[[:space:]]*#{1,6}[[:space:]]/ { if (inb) { if (has_auth && has_req && has_succ && has_err) ok++; inb=0 } }
                inb && /- \*\*Auth\*\*:/   { has_auth=1 }
                inb && /- \*\*(Request|Query|Headers)\*\*:/ { has_req=1 }
                inb && /- \*\*Success\*\*:/ { has_succ=1 }
                inb && /- \*\*Error\*\*:/   { has_err=1 }
                END { if (inb && has_auth && has_req && has_succ && has_err) ok++; print ok+0 }
            ' "$fsd" 2>/dev/null || echo 0)
            contracted=$(echo "$contracted" | tr -d ' ')
            if [ "${contracted:-0}" -ge 10 ]; then
                echo "  ✅ All $contracted endpoint blocks document Auth, Request, Success and Error"
            else
                echo "  ❌ Only ${contracted:-0} of ${ep_count} endpoint headings carry all four contract fields (Auth / Request|Query|Headers / Success / Error)."
                echo "     A heading is not a contract: document who may call it, what it takes, what success returns, and how it fails."
                GATE_FAILED=1
            fi
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

        # 4b. Object Storage & Media Architecture (Zero Base64 in DB)
        if grep -qiE "Object Storage|S3|R2|Supabase Storage|blob storage" "$fsd"; then
            echo "  ✅ Media & Object Storage architecture verified in FSD.md (Zero Base64 policy)"
        else
            echo "  ❌ FSD.md missing explicit Object Storage architecture (S3/R2/Supabase Storage) for media assets (Zero Base64 in DB)!"
            GATE_FAILED=1
        fi

        # 5. Multi-Tenant Row-Level Security (RLS) verification.
        # Trigger on the STRUCTURED Intake field (the same signal classify-scale.sh uses),
        # never on free-text search over PROJECT_STATE.md: that file's template ships the
        # literal line "- Intake-Branch-Hierarchy: [no | yes]", which contains "branch" and
        # so matched every project — including a genuinely single-tenant one — demanding RLS.
        intake_branch="$(get_field Intake-Branch-Hierarchy docs/pm/PROJECT_STATE.md | tr '[:upper:]' '[:lower:]')"
        if echo "$intake_branch" | grep -qE "^\s*(yes|ya|true|multi)" 2>/dev/null \
            || grep -qE "org_id|tenant_id" "$fsd" 2>/dev/null; then
            if grep -qiE "ROW LEVEL SECURITY|ENABLE ROW LEVEL SECURITY|rls" "$fsd"; then
                echo "  ✅ Multi-tenant isolation verified in FSD.md (Row-Level Security RLS present)"
            else
                echo "  ❌ FSD.md missing Row-Level Security (RLS) policies for multi-tenant data isolation!"
                GATE_FAILED=1
            fi
        else
            echo "  ✅ Single-tenant declared (Intake-Branch-Hierarchy: ${intake_branch:-no}) — RLS not required"
        fi

        # 6. Module 04 Handoff Strategy (BLOCKER). M06 STEP 0 parses this section to
        #    derive the prototype compatibility level; without it the agent reaches
        #    coding with no agreed way to turn the frozen prototype into components.
        if check_handoff_strategy "$fsd" "FSD.md"; then
            echo "  ✅ FSD.md records the Module 04 Handoff Strategy (prototype conversion plan)"
        else
            echo "  ❌ FSD.md missing the 'Module 04 Handoff Strategy' section (Level 1-4 + conversion plan)!"
            echo "     M06 STEP 0 reads it to know how the frozen prototype becomes code."
            GATE_FAILED=1
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
    # Handoff coverage for the SMALL path only. The FSD call above (check 6) runs
    # inside `if [ -f docs/specs/FSD.md ]`, so a Small project has no FSD and would
    # otherwise never be checked. Passing the path explicitly stops the old fallback,
    # which re-derived the document itself and could print ✅ for a DIFFERENT file
    # than the one the caller asked about.
    if [ ! -f "docs/specs/FSD.md" ]; then
        _m05_lite="PROJECT_LITE.md"
        [ -f "$_m05_lite" ] || _m05_lite="docs/specs/PROJECT_LITE.md"
        if [ -f "$_m05_lite" ]; then
            check_handoff_strategy "$_m05_lite" "PROJECT_LITE.md" || true
        fi
    fi
    check_tech_signoff || true
}
