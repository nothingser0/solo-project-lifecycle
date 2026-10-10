# Module 06: Development (Backend, Frontend, API Integration, & 3 Engineering Pillars)

> - `references/solo/SOLO_DEVELOPMENT_PATTERNS.md` (Zod validation, AES-256-GCM encryption, Pessimistic locking, Presigned URLs, Self-test scripts)
> - `references/solo/SOLO_ENGINEERING_STANDARDS.md` (Git branching, OWASP/UU PDP audit, N+1 query prevention, Asset optimization, Connection pooling)
> - `references/technical/AI_DEVELOPMENT_TOOLS_COMPARISON.md` (AI coding tool selection, Cursor vs Claude Code vs Windsurf benchmark)
> - `references/playbooks/ai-assisted-development.md` (Prompt engineering patterns, multi-file orchestration, pre-merge AI review protocol)
> - `references/playbooks/software-design-patterns.md` (Clean code principles, SOLID, design patterns, and anti-pattern detection for AI-generated code)
> - `templates/04-dev-execution/DEVELOPMENT_PROGRESS_TRACKER.md` (Coding execution progress tracker sheet, backend, frontend, integration checklists, & review checkpoints)
> - `templates/04-dev-execution/scripts/check-dependencies.sh` (Pre-install dependency compatibility and deprecation validation script)
> - `references/stacks/nextjs-quickstart.md` (Next.js App Router, React Server Components, Tailwind, Supabase setup)
> - `references/stacks/laravel-quickstart.md` (Laravel, Inertia.js, PostgreSQL/MySQL, Sanctum auth quickstart)
> - `references/stacks/django-quickstart.md` (Django, DRF, PostgreSQL, Vite/Tailwind, Celery quickstart)
> - `references/stacks/go-quickstart.md` (Go, Chi/Echo router, pgx, SQL migrations, Docker quickstart)
> - `references/technical/APM_PROFILING_RUNBOOK.md` (APM tracing, profiling CPU/memory bottlenecks, slow queries)
> - `templates/04-dev-execution/AI_CODE_REVIEW_CHECKLIST_TEMPLATE.md` (Automated AI pre-merge code review checklist)
> - `templates/04-dev-execution/AI_PROMPT_LIBRARY_TEMPLATE.md` (Standardized engineering prompt library for coding agents)
> - `patterns/validation/zod-patterns.md` (Zod schema patterns for API boundary parsing & validation)
> - `patterns/security/authentication.md` (Secure authentication, session handling, RBAC patterns)
> - `patterns/database/supabase-migrations.md` (Supabase migration, RLS policy enforcement patterns)
> - `patterns/git-workflow/branching-strategy.md` (Git branch flow, atomic commits, squash merge protocols)
> - `patterns/performance/caching-strategies.md` (Server-side & HTTP caching, cache invalidation protocols)
> - `patterns/performance/n-plus-one-prevention.md` (ORM eager loading, batching, N+1 query detection patterns)
>
> - Read: `references/solo/SOLO_DEVELOPMENT_PATTERNS.md`

This module is the sixth phase in the software project lifecycle for solo developers. Its purpose is to execute real code writing (*coding*) in a directed manner using **AI Coding Agents (Cursor / Claude Code / Windsurf / Codex CLI)** through the provision of an **Agent Harness (AI guide files)**, managing design implementation, managing **Git** branching, and enforcing 3 non-negotiable engineering pillars: **Security**, **Performance**, and **Resource Efficiency**.

---

## 1. Module 06 Execution Cycle (Universal Tech Stack Development Loop)

```text
[ INPUT: FSD.md (with LOCKED stack decision), PRD.md, & Design Prototype from Modules 04-05 ]
                                    │
                                    ▼
[ STEP 0: Extract Tech Stack Decision from FSD.md (MANDATORY FIRST) ]
  • Read FSD.md header → Extract locked stack (Next.js/Laravel/Django/Go/etc)
  • Read "Module 04 Handoff Strategy" section → Extract compatibility level (1-4)
  • Load stack-specific templates & scaffold commands
  • Verify stack decision matches Module 05 approval (GATE check)
                                    │
                                    ▼
[ STEP 1: Repository Initiation & Scaffold (Stack-Adapted) ]
  • Execute scaffold command for chosen stack:
    - Next.js: pnpm create next-app@latest
    - Laravel: composer create-project laravel/laravel --prefer-dist
    - Django: django-admin startproject
    - Go: mkdir + go mod init
  • Pin exact framework versions from FSD.md "Framework Versions (Pinned):" section:
    - Next.js: npm install next@{FSD.Next} react@{FSD.React} react-dom@{FSD.React}
    - Laravel: composer require laravel/framework:{FSD.Laravel}
    - Django: pip install django=={FSD.Django}
    - Go: Update go.mod with go {FSD.Go}
  • Git Init & Branching Strategy (main ──► staging ──► feat/*)
                                    │
                                    ▼
[ STEP 1.5: Deploy AI Harness Files to Root (AFTER Scaffold) ]
  • CRITICAL: Harness files deployed AFTER framework scaffold completes
  • Source: docs/harness-root/ (staged in M01-M05)
  • Target: ./ (project root)
  • Copy 9 files from staging to root:
    - Stack-specific: AGENTS.md, ARCHITECTURE.md, CONVENTIONS.md, .env.example
    - Universal: CONTEXT.md, DESIGN.md
    - Generated: TODO.md, VERIFY_LOCAL.md, RUNBOOK_LOCAL.md
  • OVERWRITES framework boilerplate (e.g., Next.js auto-generated AGENTS.md)
  • STRICT ORDER (NEVER REORDER): (1) scaffold MUST have finished → (2) copy staging to root → (3) verify 9 files exist in root → (4) ONLY THEN delete staging
  • Verify all 9 files present in root BEFORE any cleanup: ls -la | grep -E "AGENTS|ARCHITECTURE|CONTEXT|CONVENTIONS|DESIGN|TODO|\.env\.example|VERIFY_LOCAL|RUNBOOK_LOCAL"
  • Clean up staging ONLY after verification passes: rm -rf docs/harness-root/ (enforces single source of truth; git history serves as backup)
  • ⛔ Deleting docs/harness-root/ before the copy is verified destroys the only source of harness files. If scaffold has not run, keep staging intact.
  • Optional automation shortcut: ./scripts/scaffold/template-picker.sh --phase 4 --dest . (or .\scripts\scaffold\template-picker.ps1 -Phase 4)
                                    │
                                    ▼
[ STEP 1.6: Verify Framework Versions (Version Gate - MANDATORY) ]
  • Run version gate: ./scripts/verify/verify-framework-version.sh (or .ps1)
  • Verifies resolved lockfile versions match FSD locked versions
  • Checks package-lock.json / composer.lock / requirements.txt / go.mod
  • Compares major.minor versions (exact match required)
  • Missing lockfile or version mismatch → FAIL with fix command
  • Example: FSD has Next.js: 15.0.3, lockfile resolved 16.3.8 → FAIL
  • Anti-Overkill Runtime Sanity Check (References: `references/stacks/STACK_SUPPORT_MATRIX.md`):
    - Small Projects: No Docker clusters, microservices, or complex state stores.
    - Medium Projects: Monolith first (Laravel Inertia / Next.js / SvelteKit) without distributed Kafka or Kubernetes.
    - Large Projects: Go / FastAPI / NestJS modular service with single primary DB + Redis (WBS-phased into Medium chunks).
    - Enterprise (Non-Solo Capacity): Dialihkan ke Seri A Advisory (A03 Vendor Procurement & Governance; dilarang koding solo).
    - If agent detects architectural drift or unnecessary layers during scaffold/build, prune immediately.
                                    │
                                    ▼
[ STEP 1.7: Generate Project-Specific TODO.md (AI-Guided) ]
  • AI reads PRD.md, FSD.md, SITEMAP.md (or PROJECT_LITE.md in Small Scale) to extract scope
  • Generate TODO.md with 100% coverage:
    - 1 task per FSD/PROJECT_LITE table (database schema)
    - 1 task per SITEMAP screen (UI implementation)
    - 1 task per FSD/PROJECT_LITE endpoint (API implementation)
    - 1 task per PRD/PROJECT_LITE feature (integration)
  • Each task MUST include verification steps:
    - Verify: {stack-specific command to run}
    - Expected: {success criteria}
    - Evidence: {proof required - output/screenshot/query}
  • AI substitutes {placeholders} with stack-specific commands from FSD
  • Human validates coverage matrix (all entities mapped)
  • Commit TODO.md before coding starts
  • ENFORCEMENT: AI agents MUST complete Verify step before marking task [x]
                                    │
                                    ▼
[ STEP 2: Module 04 Prototype Conversion (4 Compatibility Levels) ]
  • Level 1 (React → Next.js/Remix): Direct copy (1 day, 95% reuse)
  • Level 2 (React → Vue/Svelte): Syntax conversion (3-4 days, 70% reuse)
  • Level 3 (React → Laravel Blade): Template rewrite (5-7 days, 0% code reuse)
  • Level 4 (React → Inertia.js): Hybrid glue layer (5-6 days, 70% reuse)
  • Execute strategy documented in FSD.md "Module 04 Handoff Strategy"
  • MANDATORY: Check framework docs for component syntax (Next.js Image, Laravel Blade, etc.)
  • Ensure UI Visuals are 100% Identical to Frozen Prototype
  • Execute TODO.md Sprint 3 tasks (Static UI Components & Design Tokens):
    - Landing, About, Terms, Login, Register screens (no data dependency)
    - Reusable UI components (Button, Input, Card, Modal)
    - Layout components (Header, Footer, Sidebar)
  • Phase Gate: Verify static screens render (Landing, Login, About) with mock data
  • Note: Data-backed screens moved to TODO Phase 5 (after DB+API ready)
                                    │
                                    ▼
[ STEP 3: Database Schema & Migrations (Framework-Adapted) ]
  • AI Reads ARCHITECTURE.md → Generate migrations matching chosen stack:
    - Next.js: Prisma/Drizzle schema + migrate
    - Laravel: Eloquent migrations + artisan migrate
    - Django: Django ORM models + makemigrations
    - Go: SQL migration files + golang-migrate
  • MANDATORY: Check ORM docs for syntax (Prisma schema, Eloquent relationships, Django models)
  • Verify ORM version matches docs (check package.json / composer.json / requirements.txt / go.mod)
  • Set up Database Pooling & Indexing on Foreign Key Columns
  • Execute Local Migrations & Seed Data (faker data for testing)
  • Execute TODO.md Sprint 1 tasks (Database Schema & DDL) with verification
  • Phase Gate: Verify migrations reversible, seed data works, tables exist
                                    │
                                    ▼
[ STEP 4: Backend API & 6 Engineering Pillars (Framework-Agnostic) ]
  • AI Reads TODO.md Sequentially → Build API endpoints according to FSD.md
  • MANDATORY: Check official framework docs before implementing (syntax changes per version)
  • Verify installed version matches docs examples (npm list / composer show / pip show / go version)
  • Implement validation library (Zod/Laravel Validation/Django Forms)
  • Security Pillar: Encryption, HttpOnly Cookies, Parameterized Queries
  • Performance Pillar: N+1 Prevention, Caching, Query Indexing
  • Resource Pillar: Connection Pooling, Stream Processing, Memory Management
  • Wire frontend components → backend endpoints (5 UI states: idle, loading, success, error, empty)
  • Execute TODO.md Sprint 2 tasks (Server Actions & API Endpoints) with verification
  • Phase Gate: Verify all FSD endpoints return correct status codes, validation works
                                    │
                                    ▼
[ STEP 5: Testing & Git Workflow (Stack-Adapted) ]
  • Run stack-specific tests:
    - Next.js: npm run test:smoke (Jest/Vitest)
    - Laravel: php artisan test (PHPUnit)
    - Django: python manage.py test (pytest)
    - Go: go test ./...
  • Audit: pnpm audit / composer audit / pip-audit
  • TypeScript check (if applicable): tsc --noEmit
  • Merge to branch staging → Tag milestone (Alpha ready)
  • Execute TODO.md Sprint 4 & Sprint 5 tasks (Integration Wire-Up, Automated Testing & QA) with verification:
    - Data-backed screens (Dashboard, Document List, Detail views)
    - Wire frontend → backend endpoints (POST /auth/login → LoginForm)
    - Implement 5 UI states per screen (idle, loading, success, error, empty)
  • Phase Gate: 
    - Verify ALL SITEMAP screens render (static + data-backed)
    - Verify UI→API integration works for data-backed screens
    - Verify 5 UI states implemented (idle, loading, success, error, empty)
    - Verify endpoint consumer mapping:
      * User-facing endpoints → UI screens exist (e.g., POST /auth/login → Login page)
      * Webhook endpoints → Provider config documented (e.g., POST /webhooks/stripe → webhook signature validation)
      * Internal/cron endpoints → Caller documented in RUNBOOK_LOCAL.md (e.g., GET /health → monitoring service)
      * Background job endpoints → Worker setup verified (e.g., POST /jobs/email → queue consumer)
                                    │
                                    ▼
[ OUTPUT: Stack-Specific Codebase + RUNBOOK_LOCAL.md ]
  • Small Scale: menyerap keamanan (SECURITY_CHECKLIST_SMALL.md) ──► Melompat ke Module 09-LITE (UAT)
  • Medium / Large: ──► Ready to Enter Module 07: QA & SIT on Staging
```

---

## 2. STEP 0: Extract Tech Stack Decision (MANDATORY FIRST)

**Agent MUST read the locked stack decision BEFORE scaffolding the project (from `docs/specs/FSD.md` or `PROJECT_LITE.md`).**

### Verification Gate:

```powershell
# GATE CHECK - Module 06 Phase 0
# Verify locked stack decision exists

$state = if (Test-Path "docs/pm/PROJECT_STATE.md") { Get-Content "docs/pm/PROJECT_STATE.md" -Raw } else { "" }
$isSmall = ($state -match "(?i)Scale:\s*small") -or ((Test-Path "PROJECT_LITE.md") -and -not (Test-Path "docs/pm/PROJECT_STATE.md"))

if ($isSmall) {
    if (-not (Test-Path "PROJECT_LITE.md")) {
        Write-Error "❌ GATE FAILED: PROJECT_LITE.md not found. Fast-Track Small Scale requires PROJECT_LITE.md."
        exit 1
    }
    Write-Host "✅ PHASE 0 PASSED: Small Scale Fast-Track detected via PROJECT_LITE.md"
} else {
if (-not (Test-Path "docs/specs/FSD.md")) {
    Write-Error "❌ GATE FAILED: FSD.md not found."
    Write-Error "Module 06 requires FSD.md from Module 05. Run Module 05 first."
    exit 1
}

$fsdContent = Get-Content "docs/specs/FSD.md" -Raw

# Check for locked stack decision
if ($fsdContent -notmatch "Stack Decision LOCKED:") {
    Write-Error "❌ GATE FAILED: FSD.md missing locked stack decision."
    Write-Error "Module 05 incomplete. Re-run Module 05 questionnaire & lock stack."
    exit 1
}

# Extract stack name
if ($fsdContent -match "Stack Decision LOCKED:\s*(.+)") {
    $lockedStack = $matches[1].Trim()
    Write-Host "✅ PHASE 0 PASSED: Locked stack detected: $lockedStack"
} else {
    Write-Error "❌ Cannot parse stack decision from FSD.md"
    exit 1
}

# Extract Module 04 handoff strategy
if ($fsdContent -notmatch "Module 04 Handoff Strategy") {
    Write-Error "❌ GATE FAILED: FSD.md missing 'Module 04 Handoff Strategy' section."
    Write-Error "Cannot determine prototype conversion approach. Update FSD.md."
    exit 1
}

Write-Host "✅ FSD.md verification complete. Proceeding to scaffold..."
}
```

---

### Extract Stack-Specific Configuration

Agent must parse FSD.md to extract:

**1. Tech Stack Components**:
```markdown
## Example FSD.md Header

Stack Decision LOCKED: Laravel Monolith (Option A)

**Chosen Stack**:
- Frontend: Laravel Blade + Inertia.js (Vue 3)
- Backend: Laravel 11
- Database: MySQL 8
- Deployment: DigitalOcean Droplet 4GB
- Monitoring: Laravel Telescope
```

**Agent extracts**:
- `frontend_framework`: "Laravel Blade + Inertia.js"
- `backend_framework`: "Laravel 11"
- `database`: "MySQL 8"
- `orm_tool`: "Eloquent" (inferred from Laravel)

**2. Module 04 Conversion Strategy**:
```markdown
## Module 04 Handoff Strategy

**Compatibility Level**: Level 4 (Hybrid - Inertia.js)

**Conversion Plan**:
1. Extract 18 Vue components from component specs
2. Setup Inertia.js in Laravel (ziggy routes, Vite config)
3. Create Laravel routes for every page
...
**Estimated Conversion Time**: 5-7 days
```

**Agent extracts**:
- `compatibility_level`: 4
- `conversion_approach`: "Hybrid - Inertia.js"
- `estimated_days`: 5-7

**3. Database Schema Syntax**:
```sql
-- FSD.md contains MySQL syntax
CREATE TABLE users (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  email VARCHAR(255) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

**Agent recognizes**: MySQL syntax (not PostgreSQL) → use appropriate migration tool.

---

### Stack-Specific Scaffold Commands

Based on the extracted stack, the agent executes the matching scaffold command:

| Detected Stack | Scaffold Command | ORM/Migration Tool |
|----------------|------------------|-------------------|
| **Next.js** | `pnpm create next-app@latest --typescript --tailwind --app` | Prisma / Drizzle |
| **Remix** | `npx create-remix@latest` | Prisma / Drizzle |
| **SvelteKit** | `npm create svelte@latest` | Prisma / Drizzle |
| **Astro** | `npm create astro@latest` | Prisma (API routes) |
| **Laravel** | `composer create-project laravel/laravel` | Eloquent (built-in) |
| **Laravel + Inertia** | `composer create-project laravel/laravel && php artisan inertia:install vue` | Eloquent + Inertia |
| **Django** | `django-admin startproject myproject && python manage.py startapp core` | Django ORM (built-in) |
| **FastAPI** | `mkdir myproject && cd myproject && poetry init` | SQLAlchemy / Tortoise ORM |
| **Go (Fiber)** | `mkdir myproject && go mod init github.com/user/myproject` | GORM / sqlx |
| **Rails** | `rails new myproject --database=postgresql --css=tailwind` | ActiveRecord (built-in) |
| **Spring Boot** | `curl https://start.spring.io/starter.zip -o myproject.zip` | JPA / Hibernate |

**Agent must NOT assume Next.js** — scaffold command is strictly determined by the FSD.md locked stack.

---

### Template Selection Matrix

Agent selects template files based on stack:

| Template File | Next.js Path | Laravel Path | Django Path | Go Path |
|---------------|--------------|--------------|-------------|---------|
| **AGENTS.md** | `templates/04-dev-execution/nextjs/AGENTS.md` | `templates/04-dev-execution/laravel/AGENTS.md` | `templates/04-dev-execution/django/AGENTS.md` | `templates/04-dev-execution/go/AGENTS.md` |
| **ARCHITECTURE.md** | `templates/04-dev-execution/nextjs/ARCHITECTURE.md` | `templates/04-dev-execution/laravel/ARCHITECTURE.md` | `templates/04-dev-execution/django/ARCHITECTURE.md` | `templates/04-dev-execution/go/ARCHITECTURE.md` |
| **CONVENTIONS.md** | `templates/04-dev-execution/nextjs/CONVENTIONS.md` | `templates/04-dev-execution/laravel/CONVENTIONS.md` | `templates/04-dev-execution/django/CONVENTIONS.md` | `templates/04-dev-execution/go/CONVENTIONS.md` |

**Stack-specific differences**:

**Next.js AGENTS.md** (example):
```markdown
## Code Style Rules
- Use Server Components by default
- No `any` types - strict TypeScript
- Zod validation for all API inputs
- File naming: kebab-case
```

**Laravel AGENTS.md** (example):
```markdown
## Code Style Rules
- Use Form Requests for validation
- No raw SQL queries - use Eloquent
- Follow PSR-12 coding standard
- File naming: PascalCase for classes, kebab-case for views
```

**Django AGENTS.md** (example):
```markdown
## Code Style Rules
- Use Django Forms / DRF Serializers for validation
- No raw SQL queries - use Django ORM
- Follow PEP 8 style guide
- File naming: snake_case
```

---

### Anti-Pattern Detection (AI SLOP Prevention)

Agent must verify scaffold matches FSD.md with expanded checks:

```python
# Pseudo-code verification
def verify_scaffold_matches_fsd():
    fsd_stack = parse_fsd_stack("docs/specs/FSD.md")  # "Laravel 11"
    
    # 1. Framework type check
    if fsd_stack.startswith("Laravel"):
        if not exists("composer.json"):
            raise Error("FSD says Laravel, but no composer.json found. Wrong scaffold.")
        if exists("package.json") and "next" in read("package.json"):
            raise Error("FSD says Laravel, but scaffolded Next.js. Re-scaffold.")
        
        # Version check
        composer = json.load("composer.json")
        laravel_version = composer["require"]["laravel/framework"]
        if "11." not in laravel_version and fsd_stack == "Laravel 11":
            warn("FSD specifies Laravel 11, but scaffolded version mismatch. Consider downgrade.")
    
    elif fsd_stack.startswith("Next.js"):
        if not exists("package.json"):
            raise Error("FSD says Next.js, but no package.json found.")
        pkg = json.load("package.json")
        if "next" not in pkg.get("dependencies", {}):
            raise Error("FSD says Next.js, but package.json missing 'next' dependency.")
        
        # 2. Major version match (CRITICAL)
        next_version = pkg["dependencies"]["next"]
        fsd_version = parse_version(fsd_stack)  # "Next.js 15" → 15
        actual_version = parse_major(next_version)  # "^16.0.0" → 16
        
        if actual_version != fsd_version:
            raise Error(f"BLOCKING: FSD specifies Next.js {fsd_version}, scaffolded {actual_version}. "
                       f"Version mismatch causes API incompatibilities. "
                       f"Fix: npx create-next-app@{fsd_version} or update FSD.md")
        
        # 3. Tailwind version detection (affects AGENTS.md syntax)
        if "tailwindcss" in pkg.get("dependencies", {}):
            tw_version = parse_major(pkg["dependencies"]["tailwindcss"])
            if tw_version >= 4:
                warn("Tailwind v4 detected. Uses CSS-first config (not tailwind.config.js). "
                     "AGENTS.md/CONVENTIONS.md must reference v4 syntax.")
                return {"framework": "nextjs", "tailwind_version": 4}
            else:
                return {"framework": "nextjs", "tailwind_version": 3}
    
    elif fsd_stack.startswith("Django"):
        if not exists("manage.py"):
            raise Error("FSD says Django, but no manage.py found. Wrong scaffold.")
    
    return {"framework": fsd_stack.split()[0].lower()}

# 4. Package manager fallback strategy
def install_dependencies_with_fallback():
    """
    Attempt npm install with timeout fallback to pnpm.
    User feedback: npm timeout loop (3x) wasted 6 minutes.
    """
    try:
        run("npm install", timeout=120)  # 2 min timeout
    except TimeoutError:
        warn("npm install timeout (1st attempt). Retrying once...")
        try:
            run("npm install", timeout=120)
        except TimeoutError:
            warn("npm install timeout (2nd attempt). Switching to pnpm...")
            if not command_exists("pnpm"):
                run("npm install -g pnpm")
            run("pnpm install")  # pnpm usually faster for large node_modules
```

**Verification gates**:
1. **Framework type mismatch** → STOP, re-scaffold correct framework
2. **Major version mismatch** → BLOCKING, fix before proceeding (causes API breaks)
3. **Tailwind v4 detected** → Adjust harness files to use v4 syntax (CSS-first config)
4. **npm timeout (2x)** → Auto-switch to pnpm (avoid 3rd retry loop)

**Post-scaffold checklist**:
```bash
# Verify scaffold output structure
- [ ] Framework files exist (package.json / composer.json / manage.py)
- [ ] Major version matches FSD.md (Next.js 15 = 15.x, not 16.x)
- [ ] Tailwind version checked (v3 vs v4 affects config syntax)
- [ ] Dependencies installed (with fallback strategy if timeout)
- [ ] No blocking advisories (eslint-config-next version mismatch, etc.)
- [ ] Peer dependencies resolved (check pnpm/npm warnings)
- [ ] No deprecated packages (search for deprecation warnings in install output)
```

**If blocking issues found**: Fix IMMEDIATELY before generating harness files. Harness files (AGENTS.md, CONVENTIONS.md) embed framework/library syntax that must match actual versions.

---

### Database Migration Anti-Patterns

**Common errors caught from user feedback**:

#### 1. Foreign Key Forward Reference (Topological Sort)
```sql
-- ❌ WRONG: References table not yet created
CREATE TABLE time_entries (
  id UUID PRIMARY KEY,
  invoice_id UUID REFERENCES invoices(id)  -- invoices doesn't exist yet!
);

CREATE TABLE invoices (
  id UUID PRIMARY KEY
);

-- ✅ CORRECT: Parent tables first
CREATE TABLE invoices (
  id UUID PRIMARY KEY
);

CREATE TABLE time_entries (
  id UUID PRIMARY KEY,
  invoice_id UUID REFERENCES invoices(id)  -- invoices exists now
);
```

**Rule**: Topological sort - tables with no foreign keys first, then tables that reference them.

**Dependency order example**:
1. `users` (no deps)
2. `profiles` → users
3. `clients` → users
4. `projects` → clients
5. `invoices` → projects
6. `time_entries` → invoices
7. `expenses` → invoices

#### 2. UUID Generation Function (Modern Postgres)
```sql
-- ❌ WRONG: Requires uuid-ossp extension
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4()
);

-- ✅ CORRECT: Built-in Postgres 13+ (Supabase default)
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid()
);
```

**Rule**: For Supabase/modern Postgres (13+), always use `gen_random_uuid()` (no extension needed).

#### 3. Peer Dependencies Check
```bash
# After npm/pnpm install, check for warnings:
pnpm install
# Look for: [WARN] unmet peer dependency "@supabase/supabase-js@^2.0.0"

# Fix immediately:
pnpm add @supabase/supabase-js
```

**Rule**: Read install warnings. Unmet peer dependencies = runtime errors.

#### 4. Deprecated Packages
```bash
# Check deprecation warnings during install:
npm WARN deprecated @supabase/auth-helpers-nextjs@0.10.0

# ✅ Remove immediately, find replacement:
npm uninstall @supabase/auth-helpers-nextjs
# Use @supabase/ssr instead (current recommended)
```

**Rule**: Deprecation warning = immediate action. Don't proceed with deprecated packages.

---

## Dependency Compatibility & Pre-Install Checks

**CRITICAL: Check compatibility BEFORE installing any package.**

### Pre-Install Verification Workflow

```bash
# STEP 1: Check peer dependencies (MANDATORY)
npm info <package-name> peerDependencies

# STEP 2: Check deprecation status
npm view <package-name> deprecated

# STEP 3: Check current stable version
npm view <package-name> version

# STEP 4: If installing, pin to compatible version
pnpm add <package-name>@<compatible-version>
```

### Common Compatibility Matrices

#### Next.js Ecosystem (v15.x)
```
next@15.x requires:
  - react@18.x (NOT 19.x)
  - @types/react@18.x (NOT 19.x)
  - eslint-config-next@15.x (must match next version)
  - tailwindcss@3.x (v4 has breaking changes)
```

#### Form Validation Stack
```
react-hook-form@7.x + Zod validation:
  - zod@3.x (v4 has breaking changes with existing ecosystem)
  - @hookform/resolvers@3.x (v5 requires Zod v4, breaks with v3)
```

#### Supabase Auth Stack
```
✅ CURRENT (2026):
  - @supabase/ssr@latest (official auth solution)
  - @supabase/supabase-js@2.x (peer dependency)

❌ DEPRECATED:
  - @supabase/auth-helpers-nextjs (discontinued, no security updates)
  - @supabase/auth-helpers-react (discontinued)
```

### Critical Dependency Errors (User-Reported)

#### Error 1: Zod v4 Incompatibility
```bash
# ❌ WRONG: Installs v4.6.5 (breaks react-hook-form)
pnpm add zod

# ✅ CORRECT: Pin to v3.x
pnpm add zod@^3.23.8

# Verify compatibility:
npm info react-hook-form peerDependencies
# Shows: "zod": "^3.0.0" → v4 NOT supported
```

**Why v4 breaks**: API changes in `.refine()`, `.transform()`, schema composition.

#### Error 2: @hookform/resolvers Version Mismatch
```bash
# ❌ WRONG: v5 requires Zod v4
pnpm add @hookform/resolvers@latest  # installs v5.9.1

# ✅ CORRECT: v3.x for Zod v3
pnpm add @hookform/resolvers@^3.9.1

# Runtime error if mismatched:
# TypeError: zodResolver is not a function
```

#### Error 3: Type Package Version Mismatch
```bash
# ❌ WRONG: @types/react v19 with React v18
pnpm add @types/react@latest

# ✅ CORRECT: Types must match runtime
pnpm add @types/react@18.3.11 @types/react-dom@18.3.1

# Verify:
grep '"react"' package.json  # Check React version
grep '@types/react' package.json  # Must match major version
```

### Font Loading Fallback Strategy

**Problem**: `next/font/google` CDN timeouts (network blocking/slow).

```typescript
// ❌ FRAGILE: Depends on Google Fonts CDN
import { Geist } from 'next/font/google'

const geist = Geist({ subsets: ['latin'] })

// ✅ RELIABLE: Local font package (no network dependency)
import { GeistSans } from 'geist/font/sans'
import { GeistMono } from 'geist/font/mono'

// Install first:
// pnpm add geist
```

**Rule**: Prefer local font packages over CDN for dev reliability.

### Deprecated Package Handling

```bash
# Check before install:
npm view @supabase/auth-helpers-nextjs deprecated
# Output: "Package discontinued. Use @supabase/ssr"

# If deprecated found:
# 1. Find official replacement (check package README or migration guide)
# 2. DO NOT INSTALL deprecated package
# 3. Use replacement immediately

# Example migration:
pnpm remove @supabase/auth-helpers-nextjs
pnpm add @supabase/ssr @supabase/supabase-js
```

**Deprecation types**:
- **Critical**: Security vulnerabilities (Next.js CVE warnings) → upgrade ASAP or document risk
- **High**: Runtime packages discontinued → find replacement before install
- **Low**: Dev dependencies (ESLint) → lower priority, but track for future upgrade

### Security Vulnerability Handling

```bash
# Example: Next.js 15.0.3 CVE warning
npm WARN deprecated next@15.0.3: CVE-2025-66478

# Decision matrix:
# 1. FSD locks version → Document as known risk in README
# 2. No spec lock → Upgrade to patched version
# 3. Critical CVE + locked → Escalate to user for spec change approval
```

**Documentation template**:
```markdown
## Known Security Risks

- **next@15.0.3**: CVE-2025-66478 (unspecified vulnerability)
  - Status: Tracked, locked per FSD.md requirement
  - Mitigation: [describe workaround if available]
  - Upgrade path: [when spec allows upgrade to 15.0.4+]
```

---

## Module Completion Checklist

**Before declaring M06 complete**, verify ALL items:

### Pre-handoff Quality Gates
```
Scaffold verification:
  - [ ] Framework type matches FSD.md (Next.js / Laravel / Django)
  - [ ] Major version matches FSD.md (Next.js 15 = 15.x, NOT 16.x)
  - [ ] Tailwind version detected (v3 vs v4)
  - [ ] Dependencies installed successfully
  - [ ] Peer dependencies resolved (no [WARN] unmet peer)
  - [ ] No deprecated packages in package.json/composer.json
  - [ ] No blocking advisories (version mismatches fixed)

Dependency compatibility checks (MANDATORY):
  - [ ] Run: npm info <key-packages> peerDependencies
  - [ ] Zod version compatible with react-hook-form (v3.x, NOT v4)
  - [ ] @hookform/resolvers matches Zod version (v3.x for Zod v3)
  - [ ] @types/react matches react version (18.x for react 18)
  - [ ] eslint-config-next matches next version
  - [ ] No deprecated packages installed (check npm view <pkg> deprecated)
  - [ ] Font loading strategy: Local packages preferred over CDN
  - [ ] Security vulnerabilities documented (if spec-locked versions have CVEs)

Harness files deployed:
  - [ ] All 9 files copied from docs/harness-root/ to ./
  - [ ] AGENTS.md exists in root (check cat AGENTS.md)
  - [ ] ARCHITECTURE.md exists in root
  - [ ] CONTEXT.md exists in root
  - [ ] CONVENTIONS.md exists in root
  - [ ] DESIGN.md exists in root
  - [ ] TODO.md exists in root
  - [ ] .env.example exists in root
  - [ ] RUNBOOK_LOCAL.md exists in root
  - [ ] VERIFY_LOCAL.md exists in root

Smoke test:
  - [ ] Dev server starts (npm run dev / php artisan serve)
  - [ ] No import errors on first load
  - [ ] Linter runs without errors (npm run lint)
  - [ ] Type check passes (pnpm run type-check or tsc --noEmit)
  - [ ] No peer dependency warnings in pnpm list
  - [ ] Database connection works (if applicable)
```

**NEVER declare "M06 complete" with outstanding checkboxes.**

**If any checkbox fails**: Fix immediately. "Deployed" ≠ "Verified". Test execution required.

---

## 3. The 9 Root Harness Files in Root Repo (Universal Stack - The 9 Root Harness Files)

⚠️ **CRITICAL: Harness File Staging & Deployment**

**Harness files are staged in `docs/harness-root/` during M01-M05, then deployed to root AFTER scaffold.**

**Why staging?**
- Root folder is empty/git-only before scaffold
- Framework CLI (create-next-app, laravel new) requires empty or minimal root
- Harness files deployed AFTER scaffold to overwrite framework boilerplate

**Timeline**:
1. **M01-M05**: Agent reads from skill://, writes to `docs/harness-root/` (9 files staged)
2. **M06 scaffold**: User runs framework CLI
3. **M06 deployment** (this step): Agent copies `docs/harness-root/*` → `./`
4. **M06+ development**: Code with harness files in root

---

⚠️ **CRITICAL PRE-FLIGHT WARNING: Framework-Specific AGENTS.md Conflicts**

Multiple frameworks auto-generate conflicting `AGENTS.md` or similar files:
- **Next.js**: `create-next-app` generates 9-line boilerplate `AGENTS.md`
- **Laravel**: No conflict (Laravel does not generate AGENTS.md)
- **Rails**: Generates `README.md` (rename to `README_FRAMEWORK.md`)
- **Django**: No conflict

**Agent deployment workflow (MANDATORY after scaffold)**:

```
Copy staged harness files from docs/harness-root/ to project root:

  Source: docs/harness-root/
  Target: ./ (project root)

  Files (9 total):
    - AGENTS.md (overwrites Next.js boilerplate if exists)
    - ARCHITECTURE.md
    - CONTEXT.md
    - CONVENTIONS.md
    - DESIGN.md
    - TODO.md
    - .env.example
    - VERIFY_LOCAL.md (generated from template, customized per FSD)
    - RUNBOOK_LOCAL.md (generated from template, customized per stack)
```

**Note**: VERIFY_LOCAL.md and RUNBOOK_LOCAL.md require project-specific generation.
Templates contain placeholders that MUST be replaced with FSD endpoints, stack commands, and actual screens.

**NEVER skip deployment!** Framework boilerplate lacks engineering standards.

---

*AI coding tool evaluation & selection guide: `references/technical/AI_DEVELOPMENT_TOOLS_COMPARISON.md`*

Before triggering AI agents to write code, place these 7 control files in the project root folder:

**Prerequisites**: Scaffold completed, deploying staged harness files to root.

**Staging workflow (M01-M05)**:
```
Agent reads stack-specific templates from skill://, writes to staging:
  Source: skill://solo-project-lifecycle/templates/04-dev-execution/{stack}/
  Target: docs/harness-root/
  
  Stack files (nextjs | laravel | django | go):
    - AGENTS.md, ARCHITECTURE.md, CONVENTIONS.md, .env.example
  
  Universal files:
    - CONTEXT.md, DESIGN.md
  
  Generated files (require FSD/SITEMAP data):
    - TODO.md (from TODO_TEMPLATE.md + FSD tables + SITEMAP screens)
    - VERIFY_LOCAL.md (from VERIFY_LOCAL_TEMPLATE.md + FSD endpoints + stack commands)
    - RUNBOOK_LOCAL.md (from RUNBOOK_LOCAL_TEMPLATE.md + stack-specific commands)
  
  Template → Target mapping:
    skill://templates/04-dev-execution/VERIFY_LOCAL_TEMPLATE.md → docs/harness-root/VERIFY_LOCAL.md
    skill://templates/04-dev-execution/RUNBOOK_LOCAL_TEMPLATE.md → docs/harness-root/RUNBOOK_LOCAL.md
    skill://templates/04-dev-execution/TODO_TEMPLATE.md → docs/harness-root/TODO.md
  
  Generation process:
    1. Read FSD.md: extract tables, endpoints, security features
    2. Read SITEMAP.md: extract screens
    3. Read ARCHITECTURE.md: extract stack (nextjs|laravel|django|go)
    4. Substitute placeholders in templates with actual project data
    5. Write generated files to docs/harness-root/
```

**Deployment workflow (M06 after scaffold)**:
```
⛔ STRICT ORDER — run top to bottom, NEVER reorder:

  # Step 1: Confirm scaffold already finished (create-next-app / laravel new / django-admin / go mod init)

  # Step 2: Copy from staging to root
  cp docs/harness-root/* ./
  cp docs/harness-root/.env.example ./

  # Step 3: Verify 9 files present in root (MUST pass before step 4)
  ls -1 | grep -E '^(AGENTS|CONTEXT|ARCHITECTURE|DESIGN|CONVENTIONS|TODO|RUNBOOK_LOCAL|VERIFY_LOCAL)\.md$'
  ls -1 .env.example
  # Expected: 9 files total:
    AGENTS.md, ARCHITECTURE.md, CONTEXT.md, CONVENTIONS.md, DESIGN.md,
    TODO.md, .env.example, VERIFY_LOCAL.md, RUNBOOK_LOCAL.md

  # Step 4: ONLY after step 3 passes — delete staging
  rm -rf docs/harness-root/  # Clean up duplicate staging to prevent AI path drift

⛔ NEVER run step 4 before step 3 passes. If scaffold has not run, keep docs/harness-root/ intact.
```

| No | File Name | Reference Source (Stack-Specific) | Function for AI Coding Agent |
| :---: | :--- | :--- | :--- |
| **1** | **`AGENTS.md`** | `templates/04-dev-execution/{stack}/AGENTS.md` | Absolute ground rules: prohibition of `any` types (TS) or raw SQL, build/test commands, and commit format. **Stack-specific**: Next.js (Server Components), Laravel (Eloquent), Django (ORM). |
| **2** | **`CONTEXT.md`** | `templates/04-dev-execution/CONTEXT_TEMPLATE.md` | Business context, user roles (RBAC), and strict *Out-of-Scope* boundaries to prevent AI hallucination. **Universal** (same for all stacks). |
| **3** | **`ARCHITECTURE.md`** | `templates/04-dev-execution/{stack}/ARCHITECTURE.md` | FSD summary: folder structure, table schemas, and JSON API route contracts. **Stack-specific**: Next.js (`app/` dir), Laravel (`app/Http`), Django (`myapp/views.py`). |
| **4** | **`DESIGN.md`** | `templates/02-design/DESIGN_MD_TEMPLATE.md` | Visual tokens from Module 04: Zinc palette, 1 brand accent, Inter font, flat 1px border. **Universal** (design tokens are framework-agnostic). |
| **5** | **`CONVENTIONS.md`** | `templates/04-dev-execution/{stack}/CONVENTIONS.md` | Code style rules: naming conventions like `kebab-case` (Next.js), `PascalCase` (Laravel), `snake_case` (Django/Python). **Stack-specific**. |
| **6** | **`.env.example`** | `templates/04-dev-execution/{stack}/ENV_EXAMPLE.md` | Standard environment variable dictionary so AI does not invent database/secret key names. **Stack-specific**: Next.js (`DATABASE_URL`), Laravel (`DB_CONNECTION`), Django (`DATABASES`). |
| **7** | **`TODO.md`** | `templates/04-dev-execution/TODO_TEMPLATE.md` | Sequential atomic task list checked off `[x]` one by one by AI. **Universal** (task structure identical across stacks). |

---

### Stack-Specific Template Examples

#### Next.js AGENTS.md (TypeScript Strict Mode)
```markdown
# AI Agent Guidelines - Next.js Project
```

### Anti-AI-Slop Code Directives (Enforced across all AGENTS.md)
Every stack-specific `AGENTS.md` strictly bans these 5 common AI coding defects:
1. **Banned: Redundant & Obvious Comments**: No commenting what the code clearly does (e.g., `// Add 1 to x` above `x += 1`). No leaving `// TODO: Implement later` stubs in production files.
2. **Banned: Verbose & Duplicated Logic**: No copy-pasting the same logic 5 times. Must extract shared helpers, custom hooks, or service layers.
3. **Banned: Hallucinated Libraries**: No importing uninstalled or fictitious packages. Verify all dependencies against `package.json` before importing.
4. **Banned: Silent Failures & Empty Catch**: No `try { ... } catch {}` that swallows errors. All failures must be logged or surfaced cleanly.
5. **Banned: Hardcoded Secrets & Unvalidated Inputs**: 100% of external inputs must be validated via Zod/schemas; zero raw SQL string concatenation; zero hardcoded API keys.

> 📚 **EXTENDED HARNESS IMPLEMENTATIONS & SPRINT RUNBOOKS**:
> For framework-specific DDL/ORM code styles (Next.js/Prisma, Laravel/Eloquent, Django/ORM), sprint-by-sprint execution guides (Sprints 0–6), and M06B enterprise product instrumentation, consult:
> - [`references/technical/DEV_EXECUTION_DEEP_DIVE.md`](../../references/technical/DEV_EXECUTION_DEEP_DIVE.md)

---

## 8. Output Artifacts (Deliverables)

1. **Git Repository Source Code**: Clean codebase with active `staging` branch and structured commit history.
2. **`RUNBOOK_LOCAL.md`**: Complete guide for environment setup, DB migrations, and running the application locally (using `templates/04-dev-execution/RUNBOOK_LOCAL_TEMPLATE.md`).
3. **`VERIFY_LOCAL.md`**: Self-verification results sheet proving that all FSD endpoints, 3 engineering pillars, and Design flows are 100% functional (using `templates/04-dev-execution/VERIFY_LOCAL_TEMPLATE.md`).
4. **`AI_REVIEW_LOG.md`**: Pre-merge AI code review protocol log following `references/playbooks/ai-assisted-development.md`.
5. **`DEVELOPMENT_PROGRESS_TRACKER.md`**: Coding execution progress tracker sheet, backend, frontend, integration checklists, and code review checkpoints (using `templates/04-dev-execution/DEVELOPMENT_PROGRESS_TRACKER.md`).

---

## 9. Gate Exit Criteria [GATE]

[GATE] Module 06 is declared **PASSED** if:
- [ ] Git branching is structured (`main`, `staging`, `feat/*`) with clean commits.
- [ ] 5 Core Harness files verified in project root: `AGENTS.md`, `CONTEXT.md`, `TODO.md`, `RUNBOOK_LOCAL.md`, `VERIFY_LOCAL.md` (≥500 bytes each).
- [ ] **Small Scale Mandatory Exit Check**: `docs/qa/SECURITY_CHECKLIST_SMALL.md` verified (≥300 bytes; menyerap audit keamanan M07).
- [ ] Design specs components extracted via MCP and connected to backend API.
- [ ] Source code builds successfully without TypeScript compilation errors (`tsc --noEmit` exits 0).
- [ ] Database migrations execute smoothly with search indexes in place.
- [ ] Stream-based AES-256-GCM vault file encryption successfully stores and retrieves documents via presigned URLs.
- [ ] Self-test script (`smoke-test`) passes 100% and dependency audit (`pnpm audit`) is free of critical vulnerabilities.

---

## 🛑 PROTOCOL [GATE] EXIT & MANDATORY STOP

After coding is complete and the `smoke-test` script passes 100%:
1. **STRICTLY FORBIDDEN to proceed directly to the next module within the same turn!**
2. **SELF-VERIFICATION (Self-Verification Checklist)**:
   - [ ] `terminal('pnpm run type-check')` → Exit code 0 (no TypeScript errors)
   - [ ] `terminal('pnpm run test:smoke')` → All assertions passed
   - [ ] `terminal('pnpm audit')` → No critical vulnerabilities
   - [ ] Read and verify file `VERIFY_LOCAL.md` → Documented test results exist
   - [ ] *(Small Scale only)*: `docs/qa/SECURITY_CHECKLIST_SMALL.md` filled and checked
   - [ ] `terminal('git log -1')` → Latest commit exists on staging branch
3. Display summary of local development results to the user:
   - Compilation and local smoke test results
   - Proof of functionality in `VERIFY_LOCAL.md`
   - Readiness for next phase:
     - **Small Scale**: Proceed to **Module 09-LITE (UAT Sign-off)**, skipping M07 & M08.
     - **Medium & Large**: Proceed to **Module 07 (Quality Assurance & SIT on Staging)**.
4. **END YOUR TURN** and request confirmation from the user:
   > *"All core features have been developed and verified locally (Smoke Test PASS). Is this development output approved before we initiate the next phase?"*
5. Wait for explicit approval response from the user before proceeding.
