# generate-todo.ps1 — Automatically scaffold TODO.md from 5-Spec multi-document inputs
# Usage: powershell -File scripts/scaffold/generate-todo.ps1 [dest_path]

param(
    [string]$Dest = "TODO.md"
)

$ErrorActionPreference = "Stop"

$FsdPath = "docs/specs/FSD.md"
$SitemapPath = "docs/specs/SITEMAP.md"
$ComponentsPath = "docs/specs/COMPONENT_REQUIREMENTS.md"
$DesignPath = "docs/design/DESIGN.md"
$DateStr = (Get-Date).ToString("yyyy-MM-dd")

if (-not (Test-Path $SitemapPath)) { if (Test-Path "SITEMAP.md") { $SitemapPath = "SITEMAP.md" } }
if (-not (Test-Path $FsdPath)) { if (Test-Path "FSD.md") { $FsdPath = "FSD.md" } }
if (-not (Test-Path $ComponentsPath)) { if (Test-Path "COMPONENT_REQUIREMENTS.md") { $ComponentsPath = "COMPONENT_REQUIREMENTS.md" } }

Write-Host "=== Generating $Dest from 5-Spec Multi-Document Inputs ===" -ForegroundColor Cyan

$sb = [System.Text.StringBuilder]::new()

[void]$sb.AppendLine("# TODO.md — Engineering Execution Plan & Automated Quality Gates")
[void]$sb.AppendLine("")
[void]$sb.AppendLine("> **Generated on**: $DateStr")
[void]$sb.AppendLine("> **Role**: Sequential atomic task list. Implement ONE task, run Verify, report Evidence, and STOP.")
[void]$sb.AppendLine("> **Approval Protocol**: When the human confirms with 'approve', 'approved', 'acc', or 'ok lanjut', the agent marks ``- [x]``, records raw output under ``Evidence:``, and adds ``Approved: <date> by <name>``.")
[void]$sb.AppendLine("> **Anti-Bundling Standard**: 1-to-1 parity between every screen in ``SITEMAP.md`` and ``M06-FE-xx``. Zero lazy compression.")
[void]$sb.AppendLine("")
[void]$sb.AppendLine("---")
[void]$sb.AppendLine("")
[void]$sb.AppendLine("## 📖 Panduan Pengembang & Verifikasi Cepat")
[void]$sb.AppendLine("")
[void]$sb.AppendLine("### 1. Setup Environment (`.env.local`)")
[void]$sb.AppendLine("1. Salin template:")
[void]$sb.AppendLine('   ```powershell')
[void]$sb.AppendLine("   cp .env.example .env.local")
[void]$sb.AppendLine('   ```')
[void]$sb.AppendLine("2. Isi kredensial database dan API keys dari provider terkait.")
[void]$sb.AppendLine("3. Jalankan pengujian koneksi database sebelum memulai sprint.")
[void]$sb.AppendLine("")
[void]$sb.AppendLine("### 2. Standar Verifikasi (Verify)")
[void]$sb.AppendLine("Jalankan perintah verify yang tertera pada tiap task sebelum meminta approval:")
[void]$sb.AppendLine("- Schema & Validasi: `pnpm run db:validate` atau `npx prisma validate`")
[void]$sb.AppendLine("- Unit Tests: `pnpm test` atau `npm test`")
[void]$sb.AppendLine("- Dev Server: `pnpm run dev` atau `npm run dev`")
[void]$sb.AppendLine("")
[void]$sb.AppendLine("---")
[void]$sb.AppendLine("")
[void]$sb.AppendLine("## Sprint 0: Environment Setup & Specs Pre-Read (MANDATORY FIRST)")
[void]$sb.AppendLine("")
[void]$sb.AppendLine("- [ ] **M06-SETUP-01: Project Scaffolding & Local Environment Staging**")
[void]$sb.AppendLine("  - **Files**: ``package.json``, ``.env.local``")
[void]$sb.AppendLine("  - **Action**: Initialize framework locked in M05 and configure environment secrets.")
[void]$sb.AppendLine("  - **Verify**: ``npm run dev`` boots clean on localhost.")
[void]$sb.AppendLine("  - **Evidence**:")
[void]$sb.AppendLine("")
[void]$sb.AppendLine("- [ ] **M06-SETUP-02: Design Assets & Brand Identity Setup**")
[void]$sb.AppendLine("  - **Files**: ``public/``, assets directory")
[void]$sb.AppendLine("  - **Action**: Copy brand logo SVG, favicon, typography, and color tokens from ``DESIGN.md``.")
[void]$sb.AppendLine("  - **Verify**: Brand assets load without placeholder stubs.")
[void]$sb.AppendLine("  - **Evidence**:")
[void]$sb.AppendLine("")
[void]$sb.AppendLine("- [ ] **M06-SETUP-03: Specs Pre-Read Sign-Off (ALL SCALES)**")
[void]$sb.AppendLine("  - **Files**: ``AGENTS.md``, ``CONTEXT.md``, ``FSD.md``, ``PRD.md``, ``SITEMAP.md``")
[void]$sb.AppendLine("  - **Action**: Verify all specs locked and architecture constraints understood before coding.")
[void]$sb.AppendLine("  - **Verify**: ``Test-Path docs/specs/FSD.md``")
[void]$sb.AppendLine("  - **Evidence**:")
[void]$sb.AppendLine("")
[void]$sb.AppendLine("---")
[void]$sb.AppendLine("")

# Check Authentication
$hasAuth = $false
if (Test-Path $SitemapPath) {
    $sitemapContent = Get-Content $SitemapPath -Raw
    if ($sitemapContent -match "/login|/auth|authentication|SCR-02") { $hasAuth = $true }
}
if (-not $hasAuth -and (Test-Path $FsdPath)) {
    $fsdContent = Get-Content $FsdPath -Raw
    if ($fsdContent -match "supabase\.auth|nextauth|session|jwt|cookie|login") { $hasAuth = $true }
}

if ($hasAuth) {
    [void]$sb.AppendLine("## Sprint 1: Authentication & Authorization / RBAC (M06-AUTH)")
    [void]$sb.AppendLine("")
    [void]$sb.AppendLine("- [ ] **M06-AUTH-01: Authentication Flow & Session Management**")
    [void]$sb.AppendLine("  - **Files**: ``src/lib/auth/*``, ``src/middleware.ts``")
    [void]$sb.AppendLine("  - **Action**: Implement login/logout session handling and secure cookie persistence.")
    [void]$sb.AppendLine("  - **Verify**: Valid login returns authenticated session; invalid credentials return 401.")
    [void]$sb.AppendLine("  - **Evidence**:")
    [void]$sb.AppendLine("")
    [void]$sb.AppendLine("- [ ] **M06-AUTH-02: Role-Based Access Control (RBAC) & Route Protection**")
    [void]$sb.AppendLine("  - **Files**: ``src/middleware.ts``, route guards")
    [void]$sb.AppendLine("  - **Action**: Implement route protection matrix per SITEMAP (redirect unauthenticated to ``/login``).")
    [void]$sb.AppendLine("  - **Verify**: Protected routes reject unauthorized requests with 403 or redirect to login.")
    [void]$sb.AppendLine("  - **Evidence**:")
    [void]$sb.AppendLine("")
    [void]$sb.AppendLine("---")
    [void]$sb.AppendLine("")
}

# Database Tables
[void]$sb.AppendLine("## Sprint 2: Database Schema & Idempotent Migrations (M06-DB)")
[void]$sb.AppendLine("")

$tables = @()
if (Test-Path $FsdPath) {
    $matchesSql = Select-String -Path $FsdPath -Pattern "CREATE TABLE\s+([A-Za-z0-9_]+)"
    foreach ($m in $matchesSql) {
        if ($m.Matches[0].Groups[1].Value) { $tables += $m.Matches[0].Groups[1].Value }
    }
    if ($tables.Count -eq 0) {
        $matchesPrisma = Select-String -Path $FsdPath -Pattern "^model\s+([A-Za-z0-9_]+)"
        foreach ($m in $matchesPrisma) {
            if ($m.Matches[0].Groups[1].Value) { $tables += $m.Matches[0].Groups[1].Value }
        }
    }
}
if ($tables.Count -eq 0 -and (Test-Path "prisma/schema.prisma")) {
    $matchesPrisma = Select-String -Path "prisma/schema.prisma" -Pattern "^model\s+([A-Za-z0-9_]+)"
    foreach ($m in $matchesPrisma) {
        if ($m.Matches[0].Groups[1].Value) { $tables += $m.Matches[0].Groups[1].Value }
    }
}

$tables = $tables | Select-Object -Unique
$dbIndex = 1
if ($tables.Count -gt 0) {
    foreach ($tbl in $tables) {
        $padId = "{0:D2}" -f $dbIndex
        [void]$sb.AppendLine("- [ ] **M06-DB-$padId: Schema Migration for Table/Model ``$tbl``**")
        [void]$sb.AppendLine("  - **Files**: ``src/db/schema/$tbl.ts`` or migrations")
        [void]$sb.AppendLine("  - **Action**: Implement ``$tbl`` model with columns, foreign keys, and indexes.")
        [void]$sb.AppendLine("  - **Verify**: ``pnpm run db:push || npx prisma validate``")
        [void]$sb.AppendLine("  - **Evidence**:")
        [void]$sb.AppendLine("")
        $dbIndex++
    }
} else {
    [void]$sb.AppendLine("- [ ] **M06-DB-01: Relational Schema & Performance Indexes**")
    [void]$sb.AppendLine("  - **Files**: Database schema migrations")
    [void]$sb.AppendLine("  - **Action**: Implement core relational tables with foreign key indexes.")
    [void]$sb.AppendLine("  - **Verify**: Database migration executes with exit code 0.")
    [void]$sb.AppendLine("  - **Evidence**:")
    [void]$sb.AppendLine("")
    $dbIndex = 2
}

$padId = "{0:D2}" -f $dbIndex
[void]$sb.AppendLine("- [ ] **M06-DB-$padId: Idempotent Database Seeding Script**")
[void]$sb.AppendLine("  - **Files**: ``prisma/seed.ts`` or seeder class")
[void]$sb.AppendLine("  - **Action**: Implement seed script using deterministic UUIDs and UPSERT statements.")
[void]$sb.AppendLine("  - **Verify**: Running seed script twice produces zero duplicate key errors and identical row counts.")
[void]$sb.AppendLine("  - **Evidence**:")
[void]$sb.AppendLine("")
[void]$sb.AppendLine("---")
[void]$sb.AppendLine("")

# Backend
[void]$sb.AppendLine("## Sprint 3: Backend Logic & Business Calculation Engines (M06-BE)")
[void]$sb.AppendLine("")
[void]$sb.AppendLine("- [ ] **M06-BE-01: Core Entity Server Actions & API Mutations**")
[void]$sb.AppendLine("  - **Files**: ``src/actions/*``, ``src/app/api/*``")
[void]$sb.AppendLine("  - **Action**: Implement CRUD server actions with strict Zod schema validation.")
[void]$sb.AppendLine("  - **Verify**: Submitting invalid payload returns structured validation errors.")
[void]$sb.AppendLine("  - **Evidence**:")
[void]$sb.AppendLine("")
[void]$sb.AppendLine("- [ ] **M06-BE-02: Core Business Calculation Engine**")
[void]$sb.AppendLine("  - **Files**: ``src/lib/engine/*``")
[void]$sb.AppendLine("  - **Action**: Implement mathematical business calculation formulas per FSD.")
[void]$sb.AppendLine("  - **Verify**: Unit tests verify calculations across all boundary conditions.")
[void]$sb.AppendLine("  - **Evidence**:")
[void]$sb.AppendLine("")
[void]$sb.AppendLine("---")
[void]$sb.AppendLine("")

# UI Primitives
if (Test-Path $ComponentsPath) {
    [void]$sb.AppendLine("## Sprint 4: UI Design System & Component Primitives (M06-UI)")
    [void]$sb.AppendLine("")
    [void]$sb.AppendLine("- [ ] **M06-UI-01: Atomic UI Primitives & Design Tokens**")
    [void]$sb.AppendLine("  - **Files**: ``src/components/ui/*``, ``globals.css``")
    [void]$sb.AppendLine("  - **Action**: Implement reusable primitives (``Button``, ``Input``, ``Badge``, ``Select``, ``LoadingSpinner``) with WCAG 2.2 AA compliance.")
    [void]$sb.AppendLine("  - **Verify**: DevTools color contrast passes; inputs enforce 16px minimum font size.")
    [void]$sb.AppendLine("  - **Evidence**:")
    [void]$sb.AppendLine("")
    [void]$sb.AppendLine("- [ ] **M06-UI-02: Composite Interaction Components**")
    [void]$sb.AppendLine("  - **Files**: ``src/components/*``")
    [void]$sb.AppendLine("  - **Action**: Implement composite patterns from COMPONENT_REQUIREMENTS (``DataTable``, ``Modal``, ``ConfirmDialog``, Entity Cards).")
    [void]$sb.AppendLine("  - **Verify**: Modal focus traps active and Escape key dismisses overlay.")
    [void]$sb.AppendLine("  - **Evidence**:")
    [void]$sb.AppendLine("")
    [void]$sb.AppendLine("---")
    [void]$sb.AppendLine("")
}

# Frontend Screens (1-to-1 Parity)
[void]$sb.AppendLine("## Sprint 5: Frontend Views & Screen Coverage (M06-FE — 1-to-1 SITEMAP Parity)")
[void]$sb.AppendLine("")

$feIndex = 1
if (Test-Path $SitemapPath) {
    $sitemapLines = Get-Content $SitemapPath | Where-Object { 
        $_ -match "SCR-[0-9]+" -and $_ -notmatch "mermaid" -and $_ -notmatch "Total Screens" 
    } | Select-Object -Unique

    foreach ($line in $sitemapLines) {
        $padId = "{0:D2}" -f $feIndex
        $scrMatch = [regex]::Match($line, "SCR-[0-9]+")
        $scrId = if ($scrMatch.Success) { $scrMatch.Value } else { "SCR-$padId" }
        $routeMatch = [regex]::Match($line, "(/[a-zA-Z0-9_\-/:*]+)")
        $route = if ($routeMatch.Success) { $routeMatch.Value } else { "/" }
        $cleanLine = ($line -replace "\|", " ").Trim()

        [void]$sb.AppendLine("- [ ] **M06-FE-$padId: Screen View [$scrId] $cleanLine**")
        [void]$sb.AppendLine("  - **Files**: ``src/app/.../page.tsx``")
        [void]$sb.AppendLine("  - **Route**: ``$route``")
        [void]$sb.AppendLine("  - **Action**: Implement responsive screen with 5-state matrix (idle, loading, success, error, empty) matching DESIGN.md tokens.")
        [void]$sb.AppendLine("  - **Verify**: ``powershell -Command `"(Invoke-WebRequest -Uri http://localhost:3000$route -UseBasicParsing).StatusCode`" || curl -fsSL -o /dev/null -w `"%{http_code}`" http://localhost:3000$route``")
        [void]$sb.AppendLine("  - **Expected**: HTTP 200 OK (or 307 redirect to /login); route resolves with zero 404.")
        [void]$sb.AppendLine("  - **Evidence**:")
        [void]$sb.AppendLine("")
        $feIndex++
    }
}

if ($feIndex -eq 1) {
    [void]$sb.AppendLine("- [ ] **M06-FE-01: Screen Views & Shell Navigation**")
    [void]$sb.AppendLine("  - **Files**: ``src/app/page.tsx``, layout components")
    [void]$sb.AppendLine("  - **Action**: Implement responsive shell layout and primary screen views.")
    [void]$sb.AppendLine("  - **Verify**: ``npm run build``")
    [void]$sb.AppendLine("  - **Evidence**:")
    [void]$sb.AppendLine("")
}

[void]$sb.AppendLine("---")
[void]$sb.AppendLine("")
[void]$sb.AppendLine("## Sprint 6: System Integration & Webhooks (M06-INT)")
[void]$sb.AppendLine("")
[void]$sb.AppendLine("- [ ] **M06-INT-01: Third-Party Webhooks & Gateway Integration**")
[void]$sb.AppendLine("  - **Files**: ``src/app/api/webhooks/*``")
[void]$sb.AppendLine("  - **Action**: Implement webhook verification, replay defense, and idempotency key guards.")
[void]$sb.AppendLine("  - **Verify**: Simulated webhook payload processes cleanly without duplicate ledger entries.")
[void]$sb.AppendLine("  - **Evidence**:")
[void]$sb.AppendLine("")
[void]$sb.AppendLine("---")
[void]$sb.AppendLine("")
[void]$sb.AppendLine("## Sprint 7: Testing & Automated Quality Gate (M06-TEST & M06-GATE)")
[void]$sb.AppendLine("")
[void]$sb.AppendLine("- [ ] **M06-TEST-01: Unit & Integration Test Suite**")
[void]$sb.AppendLine("  - **Files**: ``tests/unit/*``, ``tests/integration/*``")
[void]$sb.AppendLine("  - **Action**: Verify core business calculation formulas and server actions.")
[void]$sb.AppendLine("  - **Verify**: ``pnpm test || npm test``")
[void]$sb.AppendLine("  - **Evidence**:")
[void]$sb.AppendLine("")
[void]$sb.AppendLine("- [ ] **M06-GATE-01: Automated Lifecycle Gate Validation**")
[void]$sb.AppendLine("  - **Files**: ``RUNBOOK_LOCAL.md``, ``VERIFY_LOCAL.md``")
[void]$sb.AppendLine("  - **Action**: Verify 100% TODO task completion, zero compiler errors, and local test passes.")
[void]$sb.AppendLine("  - **Verify**: ``./scripts/gates/validate-gate.sh M06 || powershell -File scripts/gates/validate-gate.ps1 M06``")
[void]$sb.AppendLine("  - **Evidence**:")
[void]$sb.AppendLine("")

[System.IO.File]::WriteAllText($Dest, $sb.ToString(), [System.Text.Encoding]::UTF8)

Write-Host "✅ $Dest generated successfully with full 5-spec decomposition!" -ForegroundColor Green
