#!/usr/bin/env bash
# generate-todo.sh — Automatically scaffold TODO.md from FSD.md and SITEMAP.md
# Usage: ./scripts/scaffold/generate-todo.sh [dest_path]

set -euo pipefail

DEST="${1:-TODO.md}"
FSD_PATH="docs/specs/FSD.md"
SITEMAP_PATH="docs/specs/SITEMAP.md"
DATE=$(date +%Y-%m-%d 2>/dev/null || date -u +%F)

echo "=== Generating $DEST from Project Specs ==="

# Check requirements
if [ ! -f "$FSD_PATH" ]; then
    echo "⚠️ Warning: $FSD_PATH not found. Using generic defaults."
fi

cat <<EOF > "$DEST"
# TODO.md — Engineering Execution Plan & Automated Quality Gates

> **Generated on**: $DATE
> **Role**: Sequential atomic task list. Implement ONE task, run Verify, report Evidence, and STOP. Human approves before next task.

---

## Sprint 0: Environment Setup & Specs Pre-Read (MANDATORY FIRST)

- [ ] **M06-SETUP-01**: Environment & Secret Config
  - **Title**: Initialize local development configuration
  - **Files**: \`.env.local\`, \`package.json\`
  - **Verify**: \`pnpm run dev --version || npm run dev --version\`
  - **Evidence**:

- [ ] **M06-SETUP-02**: Database Connection & Base Migration Tool
  - **Title**: Configure database client and transaction pooler URL
  - **Files**: \`src/lib/db.ts\` or ORM config
  - **Verify**: \`pnpm run db:check || true\`
  - **Evidence**:

- [ ] **M06-SETUP-03**: Specs Pre-Read & Architecture Lock Verification
  - **Title**: Verify all specifications locked and contracts frozen
  - **Files**: \`docs/specs/FSD.md\`, \`docs/specs/DESIGN_SPEC.md\`
  - **Verify**: \`test -f docs/specs/FSD.md && echo "SPECS_VERIFIED_PASS"\`
  - **Evidence**:

---

## Sprint 1: Database Schema & Migrations (M06-DB)

EOF

# Extract DB tables from FSD.md if available
if [ -f "$FSD_PATH" ]; then
    TABLE_NAMES=$(grep -iE "CREATE TABLE" "$FSD_PATH" | awk '{print $3}' | tr -d '("`' || true)
    INDEX=1
    for TBL in $TABLE_NAMES; do
        PAD_ID=$(printf "%02d" "$INDEX")
        cat <<EOF >> "$DEST"
- [ ] **M06-DB-$PAD_ID**: Schema Migration for Table \`$TBL\`
  - **Title**: Implement table \`$TBL\` with indexes and constraints
  - **Files**: \`src/db/schema/$TBL.ts\` or \`migrations/*_$TBL.sql\`
  - **Verify**: \`pnpm run db:migrate || npm run db:migrate\`
  - **Evidence**:

EOF
        INDEX=$((INDEX + 1))
    done
else
    cat <<EOF >> "$DEST"
- [ ] **M06-DB-01**: Core Schema Migrations
  - **Title**: Implement foundational database tables and RLS
  - **Files**: \`migrations/001_core_schema.sql\`
  - **Verify**: \`pnpm run db:migrate\`
  - **Evidence**:

EOF
fi

cat <<EOF >> "$DEST"
---

## Sprint 2: Backend API Endpoints & Mutations (M06-BE)

EOF

# Extract API endpoints from FSD.md if available
if [ -f "$FSD_PATH" ]; then
    ENDPOINTS=$(grep -iE "(\`POST|\`GET|\`PUT|\`DELETE|\`PATCH) /api/" "$FSD_PATH" | head -n 15 || true)
    INDEX=1
    if [ -n "$ENDPOINTS" ]; then
        while IFS= read -r line; do
            [ -z "$line" ] && continue
            PAD_ID=$(printf "%02d" "$INDEX")
            CLEAN_EP=$(echo "$line" | tr -d '\r' | sed 's/^[ \t]*//')
            cat <<EOF >> "$DEST"
- [ ] **M06-BE-$PAD_ID**: API Endpoint $CLEAN_EP
  - **Title**: Implement route with Zod schema validation & auth check
  - **Files**: \`src/app/api/.../route.ts\`
  - **Verify**: \`pnpm test tests/api || true\`
  - **Evidence**:

EOF
            INDEX=$((INDEX + 1))
        done <<< "$ENDPOINTS"
    else
        cat <<EOF >> "$DEST"
- [ ] **M06-BE-01**: Core REST / Server Action Endpoints
  - **Title**: Implement CRUD mutations and validation schemas
  - **Files**: \`src/actions/*\`
  - **Verify**: \`pnpm test\`
  - **Evidence**:

EOF
    fi
else
    cat <<EOF >> "$DEST"
- [ ] **M06-BE-01**: Core REST / Server Action Endpoints
  - **Title**: Implement CRUD mutations and validation schemas
  - **Files**: \`src/actions/*\`
  - **Verify**: \`pnpm test\`
  - **Evidence**:

EOF
fi

cat <<EOF >> "$DEST"
---

## Sprint 3: Frontend Wireflow & UI Components (M06-FE)

EOF

# Extract Screens from SITEMAP.md if available
if [ -f "$SITEMAP_PATH" ]; then
    SCREENS=$(grep -iE "SCR-[0-9]+" "$SITEMAP_PATH" | head -n 15 || true)
    INDEX=1
    if [ -n "$SCREENS" ]; then
        while IFS= read -r line; do
            [ -z "$line" ] && continue
            PAD_ID=$(printf "%02d" "$INDEX")
            SCR_NAME=$(echo "$line" | tr -d '\r' | sed 's/^[ \t]*//')
            cat <<EOF >> "$DEST"
- [ ] **M06-FE-$PAD_ID**: Screen View $SCR_NAME
  - **Title**: Implement responsive UI with 5-state matrix & pending submit guards
  - **Files**: \`src/app/.../page.tsx\`
  - **Verify**: \`pnpm run build\`
  - **Evidence**:

EOF
            INDEX=$((INDEX + 1))
        done <<< "$SCREENS"
    else
        cat <<EOF >> "$DEST"
- [ ] **M06-FE-01**: Shell & Core Screens
  - **Title**: Implement responsive layout and primary data screens
  - **Files**: \`src/app/page.tsx\`
  - **Verify**: \`pnpm run build\`
  - **Evidence**:

EOF
    fi
else
    cat <<EOF >> "$DEST"
- [ ] **M06-FE-01**: Shell & Core Screens
  - **Title**: Implement responsive layout and primary data screens
  - **Files**: \`src/app/page.tsx\`
  - **Verify**: \`pnpm run build\`
  - **Evidence**:

EOF
fi

cat <<EOF >> "$DEST"
---

## Sprint 4: System Integration & Webhooks (M06-INT)

- [ ] **M06-INT-01**: Payment Gateway & Webhook Handlers
  - **Title**: Implement signature verification, replay defense, and idempotency
  - **Files**: \`src/app/api/webhooks/payment/route.ts\`
  - **Verify**: \`bash templates/06-qa-uat/fixtures/test-webhook.sh || true\`
  - **Evidence**:

---

## Sprint 5: Testing & Quality Gate (M06-TEST & M06-GATE)

- [ ] **M06-TEST-01**: Unit & Integration Test Suite
  - **Title**: Verify business logic, crypto calculations, and API contracts
  - **Files**: \`tests/unit/*\`, \`tests/integration/*\`
  - **Verify**: \`pnpm run test\`
  - **Evidence**:

- [ ] **M06-GATE-01**: Automated Lifecycle Gate Validation
  - **Title**: Run M06 gate verification check
  - **Files**: \`RUNBOOK_LOCAL.md\`, \`VERIFY_LOCAL.md\`
  - **Verify**: \`./scripts/gates/validate-gate.sh M06\`
  - **Evidence**:

EOF

echo "✅ $DEST generated successfully!"
