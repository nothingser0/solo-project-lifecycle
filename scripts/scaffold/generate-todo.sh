#!/usr/bin/env bash
# generate-todo.sh — Automatically scaffold TODO.md from 5-Spec multi-document inputs
# Usage: ./scripts/scaffold/generate-todo.sh [dest_path]

set -euo pipefail

DEST="${1:-TODO.md}"
FSD_PATH="docs/specs/FSD.md"
SITEMAP_PATH="docs/specs/SITEMAP.md"
COMPONENTS_PATH="docs/specs/COMPONENT_REQUIREMENTS.md"
DESIGN_PATH="docs/design/DESIGN.md"
DATE=$(date +%Y-%m-%d 2>/dev/null || date -u +%F)

# Fallbacks
[ -f "$SITEMAP_PATH" ] || SITEMAP_PATH="SITEMAP.md"
[ -f "$FSD_PATH" ] || FSD_PATH="FSD.md"
[ -f "$COMPONENTS_PATH" ] || COMPONENTS_PATH="COMPONENT_REQUIREMENTS.md"

echo "=== Generating $DEST from 5-Spec Multi-Document Inputs ==="

cat <<EOF > "$DEST"
# TODO.md — Engineering Execution Plan & Automated Quality Gates

> **Generated on**: $DATE
> **Role**: Sequential atomic task list. Implement ONE task, run Verify, report Evidence, and STOP.
> **Approval Protocol**: When the human confirms with "approve", "approved", "acc", or "ok lanjut", the agent marks \`- [x]\`, records raw output under \`Evidence:\`, and adds \`Approved: <date> by <name>\`.
> **Anti-Bundling Standard**: 1-to-1 parity between every screen in \`SITEMAP.md\` and \`M06-FE-xx\`. Zero lazy compression.

---

## 📖 Panduan Pengembang & Verifikasi Cepat

### 1. Setup Environment (\`.env.local\`)
1. Salin template:
   \`\`\`powershell
   cp .env.example .env.local
   \`\`\`
2. Isi kredensial database dan API keys dari provider terkait.
3. Jalankan pengujian koneksi database sebelum memulai sprint.

### 2. Standar Verifikasi (Verify)
Jalankan perintah verify yang tertera pada tiap task sebelum meminta approval:
- Schema & Validasi: \`pnpm run db:validate\` atau \`npx prisma validate\`
- Unit Tests: \`pnpm test\` atau \`npm test\`
- Dev Server: \`pnpm run dev\` atau \`npm run dev\`

---

## Sprint 0: Environment Setup & Specs Pre-Read (MANDATORY FIRST)

- [ ] **M06-SETUP-01: Project Scaffolding & Local Environment Staging**
  - **Files**: \`package.json\`, \`.env.local\`
  - **Action**: Initialize framework locked in M05 and configure environment secrets.
  - **Verify**: \`npm run dev\` boots clean on localhost.
  - **Evidence**:

- [ ] **M06-SETUP-02: Design Assets & Brand Identity Setup**
  - **Files**: \`public/\`, assets directory
  - **Action**: Copy brand logo SVG, favicon, typography, and color tokens from \`DESIGN.md\`.
  - **Verify**: Brand assets load without placeholder stubs.
  - **Evidence**:

- [ ] **M06-SETUP-03: Specs Pre-Read Sign-Off (ALL SCALES)**
  - **Files**: \`AGENTS.md\`, \`CONTEXT.md\`, \`FSD.md\`, \`PRD.md\`, \`SITEMAP.md\`
  - **Action**: Verify all specs locked and architecture constraints understood before coding.
  - **Verify**: \`test -f docs/specs/FSD.md || test -f FSD.md\`
  - **Evidence**:

---
EOF

# Detect Authentication in SITEMAP or FSD
HAS_AUTH=0
if [ -f "$SITEMAP_PATH" ] && grep -qiE "/login|/auth|auth|authentication|SCR-02" "$SITEMAP_PATH"; then
    HAS_AUTH=1
elif [ -f "$FSD_PATH" ] && grep -qiE "supabase\.auth|nextauth|session|jwt|cookie|login" "$FSD_PATH"; then
    HAS_AUTH=1
fi

if [ $HAS_AUTH -eq 1 ]; then
cat <<EOF >> "$DEST"
## Sprint 1: Authentication & Authorization / RBAC (M06-AUTH)

- [ ] **M06-AUTH-01: Authentication Flow & Session Management**
  - **Files**: \`src/lib/auth/*\`, \`src/middleware.ts\`
  - **Action**: Implement login/logout session handling and secure cookie persistence.
  - **Verify**: Valid login returns authenticated session; invalid credentials return 401.
  - **Evidence**:

- [ ] **M06-AUTH-02: Role-Based Access Control (RBAC) & Route Protection**
  - **Files**: \`src/middleware.ts\`, route guards
  - **Action**: Implement route protection matrix per SITEMAP (redirect unauthenticated to \`/login\`).
  - **Verify**: Protected routes reject unauthorized requests with 403 or redirect to login.
  - **Evidence**:

---
EOF
fi

# Extract DB Tables from FSD.md or schema.prisma
cat <<EOF >> "$DEST"
## Sprint 2: Database Schema & Idempotent Migrations (M06-DB)

EOF

TABLES=""
if [ -f "$FSD_PATH" ]; then
    # Try SQL CREATE TABLE
    TABLES=$(grep -iE "CREATE TABLE" "$FSD_PATH" | awk '{print $3}' | tr -d '("`' | sort -u || true)
    # Try Prisma models if SQL empty
    if [ -z "$TABLES" ]; then
        TABLES=$(grep -E "^model [A-Za-z0-9_]+" "$FSD_PATH" | awk '{print $2}' | sort -u || true)
    fi
fi
if [ -z "$TABLES" ] && [ -f "prisma/schema.prisma" ]; then
    TABLES=$(grep -E "^model [A-Za-z0-9_]+" "prisma/schema.prisma" | awk '{print $2}' | sort -u || true)
fi

DB_INDEX=1
if [ -n "$TABLES" ]; then
    for TBL in $TABLES; do
        PAD_ID=$(printf "%02d" "$DB_INDEX")
        cat <<EOF >> "$DEST"
- [ ] **M06-DB-$PAD_ID: Schema Migration for Table/Model \`$TBL\`**
  - **Files**: \`src/db/schema/$TBL.ts\` or migrations
  - **Action**: Implement \`$TBL\` model with columns, foreign keys, and indexes.
  - **Verify**: \`pnpm run db:push || npx prisma validate\`
  - **Evidence**:

EOF
        DB_INDEX=$((DB_INDEX + 1))
    done
else
    cat <<EOF >> "$DEST"
- [ ] **M06-DB-01: Relational Schema & Performance Indexes**
  - **Files**: Database schema migrations
  - **Action**: Implement core relational tables with foreign key indexes.
  - **Verify**: Database migration executes with exit code 0.
  - **Evidence**:

EOF
    DB_INDEX=2
fi

PAD_ID=$(printf "%02d" "$DB_INDEX")
cat <<EOF >> "$DEST"
- [ ] **M06-DB-$PAD_ID: Idempotent Database Seeding Script**
  - **Files**: \`prisma/seed.ts\` or seeder class
  - **Action**: Implement seed script using deterministic UUIDs and UPSERT statements.
  - **Verify**: Running seed script twice produces zero duplicate key errors and identical row counts.
  - **Evidence**:

---

## Sprint 3: Backend Logic & Business Calculation Engines (M06-BE)

- [ ] **M06-BE-01: Core Entity Server Actions & API Mutations**
  - **Files**: \`src/actions/*\`, \`src/app/api/*\`
  - **Action**: Implement CRUD server actions with strict Zod schema validation.
  - **Verify**: Submitting invalid payload returns structured validation errors.
  - **Evidence**:

- [ ] **M06-BE-02: Core Business Calculation Engine**
  - **Files**: \`src/lib/engine/*\`
  - **Action**: Implement mathematical business calculation formulas per FSD.
  - **Verify**: Unit tests verify calculations across all boundary conditions.
  - **Evidence**:

---
EOF

# UI Primitives from COMPONENT_REQUIREMENTS.md
if [ -f "$COMPONENTS_PATH" ]; then
cat <<EOF >> "$DEST"
## Sprint 4: UI Design System & Component Primitives (M06-UI)

- [ ] **M06-UI-01: Atomic UI Primitives & Design Tokens**
  - **Files**: \`src/components/ui/*\`, \`globals.css\`
  - **Action**: Implement reusable primitives (\`Button\`, \`Input\`, \`Badge\`, \`Select\`, \`LoadingSpinner\`) with WCAG 2.2 AA compliance.
  - **Verify**: DevTools color contrast passes; inputs enforce 16px minimum font size.
  - **Evidence**:

- [ ] **M06-UI-02: Composite Interaction Components**
  - **Files**: \`src/components/*\`
  - **Action**: Implement composite patterns from COMPONENT_REQUIREMENTS (\`DataTable\`, \`Modal\`, \`ConfirmDialog\`, Entity Cards).
  - **Verify**: Modal focus traps active and Escape key dismisses overlay.
  - **Evidence**:

---
EOF
fi

# Frontend Screens from SITEMAP.md (1-to-1 Parity)
cat <<EOF >> "$DEST"
## Sprint 5: Frontend Views & Screen Coverage (M06-FE — 1-to-1 SITEMAP Parity)

EOF

FE_INDEX=1
if [ -f "$SITEMAP_PATH" ]; then
    # Extract lines containing SCR-[0-9]+
    SCR_LINES=$(grep -iE "SCR-[0-9]+" "$SITEMAP_PATH" | grep -v "mermaid" | grep -v "Total Screens" | sort -u || true)
    if [ -n "$SCR_LINES" ]; then
        # Parse table rows if available
        while IFS= read -r line; do
            [ -z "$line" ] && continue
            PAD_ID=$(printf "%02d" "$FE_INDEX")
            CLEAN_LINE=$(echo "$line" | tr -d '\r' | sed 's/^[ \t]*//' | sed 's/|/ /g')
            SCR_ID=$(echo "$line" | grep -oE "SCR-[0-9]+" | head -n 1 || echo "SCR-$PAD_ID")
            ROUTE=$(echo "$line" | grep -oE "/[a-zA-Z0-9_\-/:*]+" | head -n 1 || echo "")
            [ -z "$ROUTE" ] && ROUTE="/"
            cat <<EOF >> "$DEST"
- [ ] **M06-FE-$PAD_ID: Screen View [$SCR_ID] $CLEAN_LINE**
  - **Files**: \`src/app.../page.tsx\`
  - **Route**: \`$ROUTE\`
  - **Action**: Implement responsive screen with 5-state matrix (idle, loading, success, error, empty) matching DESIGN.md tokens.
  - **Verify**: \`curl -fsSL -o /dev/null -w "%{http_code}" http://localhost:3000$ROUTE | grep -E "200|307" || powershell -Command "(Invoke-WebRequest -Uri http://localhost:3000$ROUTE -UseBasicParsing).StatusCode"\`
  - **Expected**: HTTP 200 OK (or 307 redirect to /login); route resolves with zero 404.
  - **Evidence**:

EOF
            FE_INDEX=$((FE_INDEX + 1))
        done <<< "$SCR_LINES"
    fi
fi

if [ $FE_INDEX -eq 1 ]; then
    cat <<EOF >> "$DEST"
- [ ] **M06-FE-01: Screen Views & Shell Navigation**
  - **Files**: \`src/app/page.tsx\`, layout components
  - **Action**: Implement responsive shell layout and primary screen views.
  - **Verify**: \`npm run build\`
  - **Evidence**:

EOF
fi

cat <<EOF >> "$DEST"
---

## Sprint 6: System Integration & Webhooks (M06-INT)

- [ ] **M06-INT-01: Third-Party Webhooks & Gateway Integration**
  - **Files**: \`src/app/api/webhooks/*\`
  - **Action**: Implement webhook verification, replay defense, and idempotency key guards.
  - **Verify**: Simulated webhook payload processes cleanly without duplicate ledger entries.
  - **Evidence**:

---

## Sprint 7: Testing & Automated Quality Gate (M06-TEST & M06-GATE)

- [ ] **M06-TEST-01: Unit & Integration Test Suite**
  - **Files**: \`tests/unit/*\`, \`tests/integration/*\`
  - **Action**: Verify core business calculation formulas and server actions.
  - **Verify**: \`pnpm test || npm test\`
  - **Evidence**:

- [ ] **M06-GATE-01: Automated Lifecycle Gate Validation**
  - **Files**: \`RUNBOOK_LOCAL.md\`, \`VERIFY_LOCAL.md\`
  - **Action**: Verify 100% TODO task completion, zero compiler errors, and local test passes.
  - **Verify**: \`./scripts/gates/validate-gate.sh M06 || powershell -File scripts/gates/validate-gate.ps1 M06\`
  - **Evidence**:

EOF

echo "✅ $DEST generated successfully with full 5-spec decomposition!"
