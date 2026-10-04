# Module 06: Development (Backend, Frontend, API Integration, & 3 Engineering Pillars)

> - `references/solo/SOLO_DEVELOPMENT_PATTERNS.md` (Zod validation, AES-256-GCM encryption, Pessimistic locking, Presigned URLs, Self-test scripts)
> - `references/solo/SOLO_ENGINEERING_STANDARDS.md` (Git branching, OWASP/UU PDP audit, N+1 query prevention, Asset optimization, Connection pooling)
> - `references/technical/AI_DEVELOPMENT_TOOLS_COMPARISON.md` (AI coding tool selection, Cursor vs Claude Code vs Windsurf benchmark)
> - `references/playbooks/ai-assisted-development.md` (Prompt engineering patterns, multi-file orchestration, pre-merge AI review protocol)
> - `references/playbooks/software-design-patterns.md` (Clean code principles, SOLID, design patterns, and anti-pattern detection for AI-generated code)
> - `templates/04-dev-execution/DEVELOPMENT_PROGRESS_TRACKER.md` (Coding execution progress tracker sheet, backend, frontend, integration checklists, & review checkpoints)
>
> - Read: `references/solo/SOLO_DEVELOPMENT_PATTERNS.md`

This module is the sixth phase in the software project lifecycle for solo developers. Its purpose is to execute real code writing (*coding*) in a directed manner using **AI Coding Agents (OpenChamber + OpenCode + OhMyOpenCode / Cursor / Claude Code)** through the provision of an **Agent Harness (AI guide files)**, integrating interfaces from **Google Stitch**, managing **Git** branching, and enforcing 3 non-negotiable engineering pillars: **Security**, **Performance**, and **Resource Efficiency**.

---

## 1. Module 06 Execution Cycle (Universal Tech Stack Development Loop)

```text
[ INPUT: FSD.md (with LOCKED stack decision), PRD.md, & Stitch Prototype from Modules 04-05 ]
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
  • Verify all 9 files present in root: ls -la | grep -E "AGENTS|ARCHITECTURE|CONTEXT|CONVENTIONS|DESIGN|TODO|\.env\.example|VERIFY_LOCAL|RUNBOOK_LOCAL"
                                    │
                                    ▼
[ STEP 1.6: Verify Framework Versions (Version Gate - MANDATORY) ]
  • Run version gate: ./scripts/verify-framework-version.sh (or .ps1)
  • Verifies resolved lockfile versions match FSD locked versions
  • Checks package-lock.json / composer.lock / requirements.txt / go.mod
  • Compares major.minor versions (exact match required)
  • Missing lockfile or version mismatch → FAIL with fix command
  • Example: FSD has Next.js: 15.0.3, lockfile resolved 16.3.8 → FAIL
                                    │
                                    ▼
[ STEP 1.7: Generate Project-Specific TODO.md (AI-Guided) ]
  • AI reads PRD.md, FSD.md, SITEMAP.md to extract scope
  • Generate TODO.md with 100% coverage:
    - 1 task per FSD table (database schema)
    - 1 task per SITEMAP screen (UI implementation)
    - 1 task per FSD endpoint (API implementation)
    - 1 task per PRD feature (integration)
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
  • Execute TODO.md Phase 3A tasks (Static UI Components only):
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
  • Execute TODO.md Phase 2 tasks (Database Schema) with verification
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
  • Execute TODO.md Phase 4 tasks (API Endpoints) with verification
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
  • Execute TODO.md Phase 5 tasks (Data-backed UI + Integration) with verification:
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
[ OUTPUT: Stack-Specific Codebase + RUNBOOK_LOCAL.md ] ──► Ready to Enter Module 07: QA & SIT
```

---

## 2. STEP 0: Extract Tech Stack Decision (MANDATORY FIRST)

**Agent MUST read FSD.md from Module 05 BEFORE scaffolding the project.**

### Verification Gate:

```powershell
# GATE CHECK - Module 06 Phase 0
# Verify FSD.md exists and contains locked stack decision

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
1. Extract 18 Vue components from Stitch export
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
  - [ ] All 7 files copied from docs/harness-root/ to ./
  - [ ] AGENTS.md exists in root (check cat AGENTS.md)
  - [ ] ARCHITECTURE.md exists in root
  - [ ] CONTEXT.md exists in root
  - [ ] CONVENTIONS.md exists in root
  - [ ] DESIGN.md exists in root
  - [ ] TODO.md exists in root
  - [ ] .env.example exists in root

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

## 3. The 7 Root Harness Files in Root Repo (Universal Stack - The 7 Root Harness Files)

⚠️ **CRITICAL: Harness File Staging & Deployment**

**Harness files are staged in `docs/harness-root/` during M01-M05, then deployed to root AFTER scaffold.**

**Why staging?**
- Root folder is empty/git-only before scaffold
- Framework CLI (create-next-app, laravel new) requires empty or minimal root
- Harness files deployed AFTER scaffold to overwrite framework boilerplate

**Timeline**:
1. **M01-M05**: Agent reads from skill://, writes to `docs/harness-root/` (7 files staged)
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
Agent copies from staging to root:
  cp docs/harness-root/* ./
  
  Verifies 9 files present:
    AGENTS.md, ARCHITECTURE.md, CONTEXT.md, CONVENTIONS.md, DESIGN.md,
    TODO.md, .env.example, VERIFY_LOCAL.md, RUNBOOK_LOCAL.md
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

## Code Style Rules
1. **TypeScript Strict Mode**: No `any` types. Use proper interfaces.
2. **Server Components**: Default to Server Components, use 'use client' only when needed.
3. **File Naming**: kebab-case for files (`user-profile.tsx`), PascalCase for components.
4. **API Routes**: app/api/[route]/route.ts with Zod validation.
5. **No Barrel Files**: Direct imports only (`import { Button } from '@/components/button'`).

## Database
- ORM: Prisma (preferred) or Drizzle
- Migrations: `prisma migrate dev`
- Seeding: `prisma db seed`

## Testing
- Run: `npm run test:smoke` (Vitest/Jest)
- Must pass before commit

## Build Commands
- Dev: `npm run dev`
- Build: `npm run build`
- Type Check: `tsc --noEmit`
```

#### Laravel AGENTS.md (PSR-12 Standards)
```markdown
# AI Agent Guidelines - Laravel Project

## Code Style Rules
1. **PSR-12 Standard**: Follow PHP-FIG coding standards.
2. **Eloquent Only**: No raw SQL queries. Use Eloquent ORM.
3. **File Naming**: PascalCase for classes (`UserController.php`), kebab-case for views (`user-profile.blade.php`).
4. **Validation**: Use Form Requests (`php artisan make:request StoreUserRequest`).
5. **No Magic Numbers**: Use config files (`config/app.php`) or constants.

## Database
- ORM: Eloquent (built-in)
- Migrations: `php artisan migrate`
- Seeding: `php artisan db:seed`

## Testing
- Run: `php artisan test` (PHPUnit)
- Must pass before commit

## Build Commands
- Dev: `php artisan serve`
- Build Assets: `npm run build` (Vite)
- Queue: `php artisan queue:work`
```

#### Django AGENTS.md (PEP 8 Standards)
```markdown
# AI Agent Guidelines - Django Project

## Code Style Rules
1. **PEP 8**: Follow Python style guide (snake_case for functions/variables).
2. **Django ORM Only**: No raw SQL queries. Use QuerySet API.
3. **File Naming**: snake_case for all Python files (`user_profile.py`).
4. **Validation**: Use Django Forms or DRF Serializers.
5. **Settings**: Use environment-specific settings (`settings/production.py`).

## Database
- ORM: Django ORM (built-in)
- Migrations: `python manage.py makemigrations && python manage.py migrate`
- Seeding: Custom management commands or fixtures

## Testing
- Run: `python manage.py test` or `pytest`
- Must pass before commit

## Build Commands
- Dev: `python manage.py runserver`
- Collect Static: `python manage.py collectstatic`
- Celery: `celery -A myproject worker`
```

---

### ARCHITECTURE.md Stack-Specific Sections

**Next.js ARCHITECTURE.md** (example structure):
```markdown
## Folder Structure
```
app/
├── (auth)/
│   ├── login/page.tsx
│   └── register/page.tsx
├── dashboard/
│   └── page.tsx
├── api/
│   ├── auth/route.ts
│   └── documents/route.ts
└── layout.tsx

src/
├── components/
│   └── ui/
├── lib/
│   ├── db.ts (Prisma client)
│   └── auth.ts
└── types/
```

## Database Schema (Prisma)
```prisma
model User {
  id        String   @id @default(cuid())
  email     String   @unique
  createdAt DateTime @default(now())
  documents Document[]
}
```
```

**Laravel ARCHITECTURE.md** (example structure):
```markdown
## Folder Structure
```
app/
├── Http/
│   ├── Controllers/
│   │   ├── AuthController.php
│   │   └── DocumentController.php
│   ├── Requests/
│   │   └── StoreDocumentRequest.php
│   └── Middleware/
├── Models/
│   ├── User.php
│   └── Document.php
└── Services/
    └── DocumentService.php

resources/
├── views/
│   └── dashboard.blade.php
└── js/
    └── Pages/ (Inertia.js components)
```

## Database Schema (Eloquent Migration)
```php
Schema::create('users', function (Blueprint $table) {
    $table->id();
    $table->string('email')->unique();
    $table->timestamp('email_verified_at')->nullable();
    $table->timestamps();
});
```
```

**Django ARCHITECTURE.md** (example structure):
```markdown
## Folder Structure
```
myproject/
├── myapp/
│   ├── models.py
│   ├── views.py
│   ├── serializers.py (DRF)
│   ├── urls.py
│   └── templates/
│       └── myapp/
│           └── dashboard.html
├── manage.py
└── myproject/
    ├── settings.py
    └── urls.py
```

## Database Schema (Django ORM)
```python
class User(AbstractUser):
    email = models.EmailField(unique=True)
    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        db_table = 'users'
```
```

---
### Stack Detection & Template Selection Algorithm

```python
# Agent logic for selecting correct templates
def select_templates(fsd_content: str) -> dict:
    """Extract locked stack from FSD.md and return template paths."""
    
    # Parse locked stack decision
    match = re.search(r"Stack Decision LOCKED:\s*(.+)", fsd_content)
    if not match:
        raise Error("Cannot find locked stack decision in FSD.md")
    
    stack_name = match.group(1).lower()
    
    # Determine stack category
    if "next.js" in stack_name or "nextjs" in stack_name:
        return {
            "category": "nextjs",
            "agents": "templates/04-dev-execution/nextjs/AGENTS.md",
            "architecture": "templates/04-dev-execution/nextjs/ARCHITECTURE.md",
            "conventions": "templates/04-dev-execution/nextjs/CONVENTIONS.md",
            "env_example": "templates/04-dev-execution/nextjs/.env.example",
        }
    
    elif "laravel" in stack_name:
        return {
            "category": "laravel",
            "agents": "templates/04-dev-execution/laravel/AGENTS.md",
            "architecture": "templates/04-dev-execution/laravel/ARCHITECTURE.md",
            "conventions": "templates/04-dev-execution/laravel/CONVENTIONS.md",
            "env_example": "templates/04-dev-execution/laravel/.env.example",
        }
    
    elif "django" in stack_name:
        return {
            "category": "django",
            "agents": "templates/04-dev-execution/django/AGENTS.md",
            "architecture": "templates/04-dev-execution/django/ARCHITECTURE.md",
            "conventions": "templates/04-dev-execution/django/CONVENTIONS.md",
            "env_example": "templates/04-dev-execution/django/.env.example",
        }
    
    elif "go" in stack_name or "fiber" in stack_name or "gin" in stack_name:
        return {
            "category": "go",
            "agents": "templates/04-dev-execution/go/AGENTS.md",
            "architecture": "templates/04-dev-execution/go/ARCHITECTURE.md",
            "conventions": "templates/04-dev-execution/go/CONVENTIONS.md",
            "env_example": "templates/04-dev-execution/go/.env.example",
        }
    
    elif "rails" in stack_name or "ruby" in stack_name:
        return {
            "category": "rails",
            "agents": "templates/04-dev-execution/rails/AGENTS.md",
            "architecture": "templates/04-dev-execution/rails/ARCHITECTURE.md",
            "conventions": "templates/04-dev-execution/rails/CONVENTIONS.md",
            "env_example": "templates/04-dev-execution/rails/.env.example",
        }
    
    else:
        # Fallback: Generic templates (least specific)
        warn(f"Unknown stack: {stack_name}. Using generic templates.")
        return {
            "category": "generic",
            "agents": "templates/04-dev-execution/generic/AGENTS.md",
            "architecture": "templates/04-dev-execution/generic/ARCHITECTURE.md",
            "conventions": "templates/04-dev-execution/generic/CONVENTIONS.md",
            "env_example": "templates/04-dev-execution/generic/.env.example",
        }
```

---

## 3A. STEP 1.5: Generate Project-Specific TODO.md (AI-Guided with Coverage Matrix)

**CRITICAL**: `TODO_TEMPLATE.md` is a generic 48-task example for legal-vault project. **NEVER use it directly** for your project.

**Goal**: Generate project-specific `TODO.md` with 100% coverage of PRD features, FSD entities/endpoints, and SITEMAP screens.

---

### AI-Guided Generation Workflow

**Prerequisites**:
- ✅ PRD.md exists in `docs/specs/`
- ✅ FSD.md exists in `docs/specs/`
- ✅ SITEMAP.md exists in `docs/specs/`
- ✅ DESIGN.md exists in root
- ✅ Harness files deployed (AGENTS, ARCHITECTURE, CONVENTIONS, .env.example)

**Agent Prompt** (copy to AI coding tool):

```
Generate project-specific TODO.md for this project:

INPUTS:
1. Read docs/specs/PRD.md - Extract all Must-Have features (P0) and acceptance criteria
2. Read docs/specs/FSD.md - Extract all database tables, API endpoints, and business logic
3. Read docs/specs/SITEMAP.md - Extract all screens/routes with Screen IDs
4. Read DESIGN.md - Extract design tokens and component library

OUTPUT FORMAT (TODO.md):

# TODO.md — [Project Name]

> Atomic task list for autonomous coding execution.
> Rule: Complete sequentially. Check [x] after verified.

## Phase 1: Repository Setup (4-6 tasks)
- [ ] package.json: Install dependencies per ARCHITECTURE.md
- [ ] tsconfig.json: Enable strict mode
- [ ] .env.example: Complete environment variables per ARCHITECTURE.md
- [ ] Database client singleton (lib/db.ts or equivalent)

## Phase 2: Database Schema & Migrations (1 task per table from FSD)
[Generate from FSD.md Section 4 "Database Schema"]
- [ ] Schema: Define [table_1] model per FSD DDL section 4.1 - expect valid schema
- [ ] Schema: Define [table_2] model per FSD DDL section 4.2
... (repeat for all N tables)
- [ ] Migrations: Run initial migration - expect all tables created
- [ ] Seed: Create seed data per FSD section 4.X

## Phase 3: UI Components (1 task per screen from SITEMAP)
[Generate from SITEMAP.md + DESIGN.md]
> Source: DESIGN.md (tokens) + screens from SITEMAP or stitch-output/

- [ ] src/components/ui/: Implement primitives per DESIGN.md tokens - expect design system match
- [ ] [route_1]: Implement [Screen Name] from SITEMAP section X or stitch-output/SCR-XX - expect 5 states (ideal/loading/error/success/empty)
- [ ] [route_2]: Implement [Screen Name 2] from SITEMAP section Y
... (repeat for all M screens)

## Phase 4: API Endpoints (1 task per endpoint from FSD)
[Generate from FSD.md Section 5 "API Contracts"]
- [ ] [endpoint_1]: Implement [METHOD] [path] per FSD section 5.1 - expect [status_code] [validation]
- [ ] [endpoint_2]: Implement [METHOD] [path] per FSD section 5.2
... (repeat for all K endpoints)

## Phase 5: Feature Integration (1 task per PRD feature)
[Generate from PRD.md Must-Have Features]
- [ ] [Feature 1]: Implement [feature name] per PRD section 3.1 - expect [acceptance criteria]
- [ ] [Feature 2]: Implement [feature name] per PRD section 3.2
... (repeat for all P features)
- [ ] 5-State Review: Verify all screens have loading/empty/error states

## Phase 6: Testing & Verification
- [ ] scripts/smoke-test.ts: Write end-to-end flow per PRD user journeys
- [ ] VERIFY_LOCAL.md: Complete self-verification checklist

REQUIREMENTS:
1. Every FSD table → 1 schema task
2. Every SITEMAP screen → 1 UI task with Screen ID reference
3. Every FSD endpoint → 1 API task with section reference
4. Every PRD Must-Have feature → 1 integration task
5. File paths match stack conventions (AGENTS.md)
6. Expect conditions specific and testable
```

---

### Coverage Matrix Validation (MANDATORY)

**Before proceeding to coding**, human MUST verify 100% coverage:

```markdown
## TODO.md Coverage Matrix

### Database Tables (from FSD Section 4)
| Table Name | FSD Section | TODO Task | Status |
|:-----------|:------------|:----------|:------:|
| users | 4.1 | Phase 2, line 12 | ✅ |
| products | 4.2 | Phase 2, line 13 | ✅ |
| transactions | 4.3 | Phase 2, line 14 | ✅ |
... (all N tables)

### Screens (from SITEMAP)
| Screen | Route | SITEMAP Section | TODO Task | Status |
|:-------|:------|:----------------|:----------|:------:|
| Login | /login | 2.1 | Phase 3, line 25 | ✅ |
| Dashboard | /dashboard | 3.1 | Phase 3, line 26 | ✅ |
| Sales Entry | /transactions/sales/new | 4.3 | Phase 3, line 30 | ✅ |
... (all M screens)

### API Endpoints (from FSD Section 5)
| Method | Path | FSD Section | TODO Task | Status |
|:-------|:-----|:------------|:----------|:------:|
| POST | /api/v1/auth/login | 5.1 | Phase 4, line 45 | ✅ |
| GET | /api/v1/transactions | 5.8 | Phase 4, line 52 | ✅ |
... (all K endpoints)

### Features (from PRD Must-Have)
| Feature | PRD Section | Acceptance Criteria | TODO Task | Status |
|:--------|:------------|:-------------------|:----------|:------:|
| User Authentication | 3.1 | Login + 2FA | Phase 5, line 68 | ✅ |
| Double-Entry Accounting | 3.3 | Auto-journal generation | Phase 5, line 70 | ✅ |
... (all P features)

**Coverage Summary:**
- Database: N/N tables (100%)
- Screens: M/M screens (100%)
- Endpoints: K/K endpoints (100%)
- Features: P/P features (100%)
```

---

### Quality Gates

**CANNOT proceed to STEP 2 (prototype conversion) until:**

- [ ] TODO.md generated with AI guidance
- [ ] Coverage matrix created and validated
- [ ] 100% coverage confirmed (all tables/screens/endpoints/features mapped)
- [ ] Human reviewed TODO.md for:
  - [ ] Correct file paths per stack conventions
  - [ ] Realistic expect conditions
  - [ ] Proper task granularity (1 file/endpoint/screen per task)
  - [ ] Sequential dependencies respected (database → UI → API → integration)
- [ ] TODO.md committed to git before coding starts

**Anti-Pattern Detection:**

❌ **WRONG**: Copy `TODO_TEMPLATE.md` blindly
```bash
cp templates/04-dev-execution/TODO_TEMPLATE.md ./TODO.md
# Result: AI builds legal-vault features (crypto, signatures) not your project
```

✅ **CORRECT**: AI-guided generation from specs
```bash
# 1. Prompt AI with generation template above
# 2. AI reads PRD/FSD/SITEMAP
# 3. AI generates project-specific TODO.md
# 4. Human validates coverage matrix
# 5. Commit TODO.md
git add TODO.md
git commit -m "chore: generate project-specific TODO from specs"
```

---

### Example: TataBuku vs Legal Vault

**Legal Vault** (TODO_TEMPLATE.md - 48 tasks):
- Documents table, signatures, AES-256-GCM encryption
- 4 screens (login, dashboard, documents, sign)
- 6 endpoints (auth, documents CRUD, sign)

**TataBuku** (Generated TODO.md - 150 tasks):
- 18 tables (users, products, transactions, invoices, coa, journal_entries, etc.)
- 42 screens (dashboard, sales entry, purchase entry, reports, e-Faktur, etc.)
- 42 endpoints (auth, transactions, inventory, reports, receivables, e-Faktur)
- 10 features (double-entry accounting, offline-first, e-Faktur integration)

**Conclusion**: Generic template ≠ project-specific work plan. AI-guided generation required.

---

## 3A. STEP 2: Module 04 Prototype Conversion (4 Compatibility Levels)

**Execute conversion strategy documented in FSD.md "Module 04 Handoff Strategy" section.**

Agent reads FSD.md to extract:
- **Compatibility Level**: 1-4
- **Conversion Approach**: Direct copy / Syntax conversion / Template rewrite / Hybrid
- **Estimated Time**: X days
- **Component Count**: Y screens/components

---

### Level 1: Direct Copy (React → React-Based Stacks)

**Applicable Stacks**: Next.js, Remix, Gatsby, Create React App

**Conversion Steps**:

```bash
# 1. Export Stitch components (via MCP or manual download)
stitch_get_screen(projectId="...", screenId="...")

# 2. Copy components to target directory
# Next.js: src/components/
# Remix: app/components/

# 3. Minimal refactoring
# - Add TypeScript types (if Stitch exported vanilla JS)
# - Adjust import paths
# - Split into one component per file
```

**Example Conversion**:

```tsx
// ✅ Stitch Export (dashboard-card.tsx)
function DashboardCard({ title, value }) {
  return (
    <div className="bg-white rounded-lg shadow-sm p-6">
      <h3 className="text-zinc-700 font-semibold">{title}</h3>
      <p className="text-3xl font-bold text-zinc-900">{value}</p>
    </div>
  )
}

// ✅ Next.js Target (components/dashboard-card.tsx)
interface DashboardCardProps {
  title: string
  value: string | number
}

export function DashboardCard({ title, value }: DashboardCardProps) {
  return (
    <div className="bg-white rounded-lg shadow-sm p-6">
      <h3 className="text-zinc-700 font-semibold">{title}</h3>
      <p className="text-3xl font-bold text-zinc-900">{value}</p>
    </div>
  )
}
```

**Time Investment**: 1 day (18 screens)  
**Code Reuse**: 95%  
**Risk**: Low (syntax identical)

---

### Level 2: Syntax Conversion (React → Similar Framework)

**Applicable Stacks**: Vue, Svelte, Solid, Preact

**Conversion Steps**:

```bash
# 1. Export Stitch components
stitch_get_screen(...)

# 2. Convert JSX → framework syntax
# Tool: react-to-vue CLI (optional, 80% accuracy)
npx react-to-vue src/components/*.tsx --output resources/js/components/

# 3. Manual review & fixes
# - State management (React hooks → Vue Composition API)
# - Event handlers (@click vs onClick)
# - Conditional rendering (v-if vs {condition && ...})
```

**Example Conversion**:

```vue
<!-- ✅ Stitch Export (React JSX) -->
<div className="bg-white rounded-lg shadow-sm p-6">
  <h3 className="text-zinc-700 font-semibold">{title}</h3>
  <p className="text-3xl font-bold text-zinc-900">{value}</p>
</div>

<!-- ✅ Vue Target (DashboardCard.vue) -->
<template>
  <div class="bg-white rounded-lg shadow-sm p-6">
    <h3 class="text-zinc-700 font-semibold">{{ title }}</h3>
    <p class="text-3xl font-bold text-zinc-900">{{ value }}</p>
  </div>
</template>

<script setup lang="ts">
defineProps<{
  title: string
  value: string | number
}>()
</script>
```

**Time Investment**: 3-4 days (18 screens)  
**Code Reuse**: 70% (structure preserved, syntax adapted)  
**Risk**: Medium (manual review required, tool 80% accurate)

---

### Level 3: Template Rewrite (React → Server-Side Templates)

**Applicable Stacks**: Laravel Blade, Django Templates, Rails ERB, PHP

**Conversion Strategy**: Stitch prototype = **visual reference only**

**Conversion Steps**:

```bash
# 1. Open Stitch prototype in browser as reference
# 2. Identify layout patterns:
#    - Header (logo, nav, user menu)
#    - Sidebar (if exists)
#    - Main content area
#    - Footer

# 3. Manual rewrite as server templates
# Laravel: resources/views/*.blade.php
# Django: templates/myapp/*.html

# 4. Extract Tailwind classes from Stitch → copy to templates
# Keep design tokens (DESIGN.md) consistent
```

**Example Conversion**:

```blade
{{-- ✅ Stitch React JSX (reference only) --}}
{{-- <div className="bg-white rounded-lg shadow-sm p-6">
       <h3 className="text-zinc-700 font-semibold">{title}</h3>
       <p className="text-3xl font-bold text-zinc-900">{value}</p>
     </div> --}}

{{-- ✅ Laravel Blade (manual rewrite) --}}
<div class="bg-white rounded-lg shadow-sm p-6">
  <h3 class="text-zinc-700 font-semibold">{{ $title }}</h3>
  <p class="text-3xl font-bold text-zinc-900">{{ $value }}</p>
</div>
```

**Time Investment**: 5-7 days (18 screens)  
**Code Reuse**: 0% (code rewrite), 100% (design preserved)  
**Risk**: High (manual effort, error-prone)

**Tailwind Integration** (Laravel example):
```bash
# Install Tailwind in Laravel
npm install -D tailwindcss postcss autoprefixer
npx tailwindcss init

# tailwind.config.js (copy theme from DESIGN.md)
module.exports = {
  content: ['./resources/**/*.blade.php'],
  theme: {
    extend: {
      colors: {
        primary: '#0891B2',  // From DESIGN.md
      }
    }
  }
}
```

---

### Level 4: Hybrid (Inertia.js / Hotwire)

**Applicable Stacks**: Laravel + Inertia.js, Rails + Hotwire Turbo

**Conversion Strategy**: Keep frontend components (Vue/React), glue to backend

**Conversion Steps**:

```bash
# 1. Export Stitch components (Vue/React)
stitch_get_screen(...)

# 2. Setup glue layer
# Laravel: php artisan inertia:install vue
# Rails: gem install hotwire-rails

# 3. Wire backend routes → frontend components
# Laravel: Inertia::render('Dashboard', ['stats' => $stats])
# Rails: render inertia: 'Dashboard', props: { stats: stats }

# 4. Copy Stitch components to framework structure
# Laravel Inertia: resources/js/Pages/*.vue
# Rails Hotwire: app/frontend/pages/*.jsx
```

**Example Conversion**:

```php
// ✅ Laravel Route (Inertia.js)
Route::get('/dashboard', function () {
    return Inertia::render('Dashboard', [
        'stats' => [
            ['title' => 'Total Documents', 'value' => 127],
            ['title' => 'Pending Signatures', 'value' => 8],
        ]
    ]);
});
```

```vue
<!-- ✅ Vue Component (resources/js/Pages/Dashboard.vue) -->
<!-- Copied from Stitch export with minimal changes -->
<script setup>
defineProps(['stats'])
</script>

<template>
  <div class="grid grid-cols-2 gap-6">
    <DashboardCard 
      v-for="stat in stats" 
      :key="stat.title"
      :title="stat.title"
      :value="stat.value"
    />
  </div>
</template>
```

**Time Investment**: 5-6 days (setup 2 days + conversion 3-4 days)  
**Code Reuse**: 70% (Vue/React components preserved)  
**Risk**: Medium (glue layer complexity)

---

### Conversion Verification Checklist

After conversion is complete, verify:

- [ ] **Visual Parity**: UI matches Stitch prototype 100% (compare screenshots)
- [ ] **Design Tokens Applied**: Colors, fonts, spacing from DESIGN.md consistent
- [ ] **Responsive**: Mobile/tablet/desktop layouts work (test breakpoints)
- [ ] **All Screens Converted**: X/Y screens complete (track in TODO.md)
- [ ] **Components Functional**: No broken imports, props correctly typed
- [ ] **5 UI States Implemented**: idle, loading, success, error, empty (for interactive components)

**Gate**: Cannot proceed to backend API (STEP 4) until frontend conversion is complete & verified.

---

## 3B. Solo Developer Git Branching Strategy (Git Branching & Clean Production)

Branching is tailored to the project scale:

| Scale | Branch Structure | Rationale |
|-------|------------------|-----------|
| **Small** | `main` only (direct commits or single dev branch) | Low overhead, solo dev MVP/freelance |
| **Medium** | `main` + `staging` (optional feat/* for large features) | Integration testing before production |
| **Large/Enterprise** | `main` + `staging` + `feat/*` (strict feature branches) | Formal review gates, client demos |

**Large/Enterprise Branching Flow**:

```text
[ main ] ──────────────(Release Tag v1.0.0 - Production Clean)─────────────────►
   ▲
   │ (Merge after UAT Pass)
[ staging ] ───────────(Integration & Client Demo)─────────────────────────────►
   ▲
   │ (Merge after local test passes)
   ├── [ feat/auth-login ] ───────► (Complete ──► Merge to staging)
   ├── [ feat/document-vault ] ───► (Complete ──► Merge to staging)
   └── [ fix/pdf-render-bug ] ────► (Complete ──► Merge to staging)
```

### Standard Branching Rules (Large/Enterprise):
1. **Branch `main` (Production)**:
   - 100% stable production code that has passed client UAT.
   - Clean of internal dev files: files such as `TODO.md` and internal draft notes must not pollute production branches (configured via production `.gitignore` or build docker ignore).
   - Always labeled with SemVer: `git tag -a v1.0.0 -m "Release v1.0.0"`.
2. **Branch `staging` (Integration)**:
   - Integration hub for all features ready for testing on the Staging server. Clients test features in this environment.
3. **Branch `feat/[feature-name]`**:
   - Solo dev working branch for each major task in `TODO.md`.
   - Once the task is complete and passes local `smoke-test`, the branch is merged into `staging`.
4. **Commit Message Format (Conventional Commits)**:
   - `feat(vault): implement streaming AES-256 encryption for PDF upload`
   - `fix(auth): correct Argon2id memory cost parameter`
   - `perf(db): add index on documents(creator_id, status)`

---

## 4. The 6 Engineering Quality Pillars (The 6 Engineering Pillars - Universal)

**Framework-agnostic principles** — applicable to all tech stacks from Module 05.

Coding is not merely about making "features work"; it must satisfy 6 engineering quality standards:

### Pillar 1: Defensive Security (Security by Design)

**Principle**: Zero raw queries, strict validation, encryption at rest, secure sessions.

**Stack-Specific Implementation**:

| Stack | Raw Query Prevention | Validation | Password Hashing | Session Management |
|-------|---------------------|------------|------------------|-------------------|
| **Next.js** | Prisma/Drizzle ORM (no raw SQL) | Zod schemas | bcrypt/argon2 via crypto | JWT in HttpOnly cookies |
| **Laravel** | Eloquent ORM (no DB::raw) | Form Requests | Hash::make (bcrypt) | Session driver (database/redis) |
| **Django** | Django ORM QuerySet (no raw SQL) | Django Forms / DRF Serializers | make_password (PBKDF2) | Django session framework |
| **Go** | GORM / sqlx prepared statements | validator library | bcrypt package | JWT + secure cookies |

**Example: Parameterized Queries**

```typescript
// ✅ Next.js (Prisma) - CORRECT
const user = await prisma.user.findUnique({
  where: { email: validatedEmail }
})

// ❌ WRONG (SQL injection vulnerable)
const user = await prisma.$queryRaw`SELECT * FROM users WHERE email = '${email}'`
```

```php
// ✅ Laravel (Eloquent) - CORRECT
$user = User::where('email', $validatedEmail)->first();

// ❌ WRONG (SQL injection vulnerable)
$user = DB::select("SELECT * FROM users WHERE email = '$email'");
```

```python
# ✅ Django (ORM) - CORRECT
user = User.objects.filter(email=validated_email).first()

# ❌ WRONG (SQL injection vulnerable)
user = User.objects.raw(f"SELECT * FROM users WHERE email = '{email}'")
```

**Encryption Requirements** (UU PDP No. 27/2022):
- Document files: AES-256-GCM before storage
- Passwords: Argon2id (preferred) or bcrypt (min cost 12)
- Session tokens: HttpOnly, Secure, SameSite=Strict cookies

**Dependency Audit** (Stack-specific):
- Next.js: `pnpm audit` or `npm audit`
- Laravel: `composer audit`
- Django: `pip-audit` or `safety check`
- Go: `govulncheck`

---

### Pillar 2: Performance & Speed (Performance Engineering)

**Principle**: Prevent N+1 queries, index foreign keys, cache static data, optimize assets.

**Stack-Specific Implementation**:

| Stack | N+1 Prevention | Indexing | Caching | Asset Optimization |
|-------|----------------|----------|---------|-------------------|
| **Next.js** | Prisma `include`/`select` | DB migrations add index | Redis / Next.js cache | `next/image` auto WebP |
| **Laravel** | Eloquent `with()` eager load | Migration `$table->index()` | Redis Cache facade | Laravel Mix / Vite |
| **Django** | `select_related()` / `prefetch_related()` | `db_index=True` in models | Django cache framework | WhiteNoise / CDN |
| **Go** | Preload associations (GORM) | CREATE INDEX in migrations | Go-cache / Redis | Manual optimization |

**Example: N+1 Query Prevention**

```typescript
// ❌ N+1 Query (Next.js Prisma)
const users = await prisma.user.findMany()
for (const user of users) {
  const posts = await prisma.post.findMany({ where: { userId: user.id } }) // N queries!
}

// ✅ CORRECT (1 query with join)
const users = await prisma.user.findMany({
  include: { posts: true }
})
```

```php
// ❌ N+1 Query (Laravel)
$users = User::all();
foreach ($users) {
    $posts = $user->posts; // N queries!
}

// ✅ CORRECT (eager loading)
$users = User::with('posts')->get();
```

**Database Indexing** (Universal principle):
```sql
-- Indexes on foreign keys (MANDATORY)
CREATE INDEX idx_documents_user_id ON documents(user_id);
CREATE INDEX idx_documents_status ON documents(status);

-- Composite index for filter queries
CREATE INDEX idx_documents_user_status ON documents(user_id, status);
```

**Caching Strategy**:
- Master data (rarely changed): Cache 1-24 hours
- User sessions: Redis with TTL
- API responses: Cache-Control headers

---

### Pillar 3: Resource & Cost Efficiency (Resource & Cost Efficiency)
- **Strict Gateway Validation**: All incoming request data must pass through Zod schemas.
- **Sensitive Data Encryption (UU PDP No. 27/2022)**: Document files are AES-256-GCM encrypted before entering storage; passwords hashed using Argon2id; session tokens stored in `HttpOnly, Secure, SameSite=Strict` cookies.
- **Dependency Audit**: Run `pnpm audit` periodically to verify zero open-source libraries have known security vulnerabilities.

### Pillar 2: Performance & Speed (Performance Engineering)
- **N+1 Query Prevention**: Running database queries inside loops is FORBIDDEN. Use relationship `include`/`select` or batched queries.
- **Database Indexing**: Apply indexes to every Foreign Key column and search filter column (`WHERE status = ...`).
- **Zero Layout Shift & Asset Optimization**: Use Next.js `<Image>` for automatic WebP compression and skeleton loaders to prevent layout shifts during data loading.
- **Caching**: Implement in-memory caching (Redis) for rarely changing master data.

### Pillar 3: Resource & Cost Efficiency (Resource & Cost Efficiency)
- **Database Connection Pooling**: PostgreSQL has limited connection boundaries. Always use connection pooling (Prisma Accelerate, Supabase Pooler, or PgBouncer) so serverless functions do not cause database connection exhaustion.
- **Streaming Files**: PDF files or large documents must be processed using **Node.js Streams** (not `fs.readFileSync` into RAM) to keep server memory consumption low under 256 MB.
- **Minimal Docker Footprint**: When using Docker, employ Alpine Linux-based *multi-stage builds* to keep container image sizes minimal (< 150 MB) and reduce hosting costs.

### Pillar 4: Observability & Resilience (Observability & Reliability)
- **Structured JSON Logging**: Log using JSON format (Pino) with trace IDs, actor IDs, and error stacks for easy cloud filtering.
- **Healthcheck & Graceful Shutdown**: Provide a `GET /api/health` route and handle `SIGTERM` signals to close database connections cleanly.

### Pillar 5: Maintainability & Type Hygiene (Maintainability & Type Hygiene)
- **Single Source of Truth for Data Types**: All TypeScript types are inferred from Zod (`z.infer<typeof Schema>`); manual duplication is FORBIDDEN.
- **Strictly No Barrel Files (`index.ts`)**: Import directly from specific files to prevent circular dependencies and accelerate tree-shaking.
- **Early Returns (Guard Clauses)**: Handle errors on the opening lines of functions, avoiding deeply nested if-else structures.
- **Clean Code & Design Patterns**: Apply SOLID principles and architectural patterns according to `references/playbooks/software-design-patterns.md`.

### Pillar 6: Data Durability & Disaster Recovery (Data Durability & Disaster Recovery)
- **Strict Soft-Delete**: Legal transaction documents MUST NEVER be permanently deleted (`DELETE FROM`). Use a `deleted_at` column.
- **Atomic Transaction Integrity**: Multi-table mutations must be wrapped within a `db.$transaction` block to prevent partial data corruption.

---

## 5. Step-by-Step Execution

### Step 1: Repository Preparation & Tooling

**Input**: Requirements from `FSD.md` and `PRD.md`.

**Activities**:

1. **Create local Git repository** (if not already existing):

   ```bash
   git init
   git branch -M main
   ```

2. **Scaffold framework of choice**:

   **IMPORTANT: Framework-Agnostic Anti-Conflict Protocol**

   Many modern framework CLIs **refuse to execute if the target directory is not empty**. Because Modules 01-05 have already produced `docs/pm/` and `docs/specs/` directories, scaffolding strategies differ per framework:

   | Framework | Empty Dir Required? | AGENTS.md Conflict? | Scaffold Protocol |
   |-----------|---------------------|---------------------|-------------------|
   | **Next.js 15+** | Yes (strict) | **YES** (auto-gen 9 lines) | Temp folder → copy → **MANDATORY overwrite AGENTS.md** (see warning above) |
   | **Laravel** | No (tolerates files) | No | Direct scaffold: `composer create-project laravel/laravel .` |
   | **Django/FastAPI** | No | No | Direct init: `poetry init` / `django-admin startproject . .` |
   | **Flutter** | Yes (strict) | No | Temp folder → copy (no AGENTS.md conflict) |

   **Next.js Protocol** (ONLY if using Next.js):
   ```bash
   # Scaffold in new EMPTY temp folder
   mkdir ../temp_scaffold
   cd ../temp_scaffold
   pnpm create next-app@latest . --typescript --tailwind --app --no-src-dir=false --import-alias "@/*"
 
   # Copy framework files to project folder
   cd ../project_folder
   cp -r ../temp_scaffold/* .
   cp -r ../temp_scaffold/.* . 2>/dev/null || true
 
   # Cleanup temp
   rm -rf ../temp_scaffold
   ```
  
  **Agent: Deploy staged harness files to root (overwrites Next.js AGENTS.md boilerplate)**:
   ```
  Copy from staging to root:
    cp docs/harness-root/AGENTS.md ./AGENTS.md
    cp docs/harness-root/ARCHITECTURE.md ./ARCHITECTURE.md
    cp docs/harness-root/CONTEXT.md ./CONTEXT.md
    cp docs/harness-root/CONVENTIONS.md ./CONVENTIONS.md
    cp docs/harness-root/DESIGN.md ./DESIGN.md
    cp docs/harness-root/TODO.md ./TODO.md
    cp docs/harness-root/.env.example ./.env.example
   ```

   **Laravel Protocol**:
   ```bash
   # Direct scaffold (no conflict)
   composer create-project laravel/laravel .
   ```
  
  **Agent: Deploy staged harness files to root**:
   ```
  Copy from staging to root:
    cp docs/harness-root/* ./
   ```

   **Django/FastAPI Protocol**:
   ```bash
   # Direct init
   poetry init  # or: django-admin startproject myproject .
   ```
  
  **Agent: Deploy staged harness files to root**:
   ```
  Copy from staging to root:
    cp docs/harness-root/* ./
   ```

   **Flutter Protocol**:
   ```bash
   # Scaffold in EMPTY folder
   mkdir ../temp_scaffold
   cd ../temp_scaffold
   flutter create --org com.client --project-name legal_vault .
 
   # Copy to project folder
   cd ../project_folder
   cp -r ../temp_scaffold/* .
  
   # Cleanup
   rm -rf ../temp_scaffold
   ```
  
  **Agent: Deploy staged harness files to root**:
   ```
  Copy from staging to root:
    cp docs/harness-root/* ./
   ```

3. **Verify 7 Root Harness Files installed**:

   ```bash
   # Fixed verification: .env.example has no .md extension
   ls -1 | grep -E '^(AGENTS|CONTEXT|ARCHITECTURE|DESIGN|CONVENTIONS|TODO)\.md$' && ls -1 .env.example
   ```

   Expected output: 6 .md files + .env.example (7 total).

4. **Create staging branch**: `git checkout -b staging`

5. **Initial commit** to lock harness and scaffolding:
   ```bash
   git add .
   git commit -m "chore: initial project scaffolding with 7 AI harness files"
   ```

### Step 2: UI Component Implementation (Stitch or Manual Scaffold)

**Option A: Import from Google Stitch (If Screen IDs Available)**
1. Read Screen IDs from `DESIGN_SYSTEM.md` (Part II: Screen Inventory).
2. Instruct OpenCode (if Stitch MCP is available):
   > *"Use the `stitch_get_screen` tool for registered Screen IDs. Extract HTML/Tailwind code into React components in `src/components/ui/` and wire the pages in `src/app/`."*
3. Run `pnpm dev` to verify the UI is identical to the design.

**Option B: Manual Scaffold (Without Stitch)**
1. Read screen descriptions from `DESIGN_SYSTEM.md` (sitemap + color/typography tokens).
2. Create empty shell UI components with proper folder structure:
   ```bash
   mkdir -p src/components/ui src/app/{dashboard,documents,login}
   ```
3. Instruct AI to generate components based on DESIGN_SYSTEM.md without Stitch:
   > *"Read `DESIGN_SYSTEM.md`. Create React/Vue/Flutter components matching Zinc palette, Inter font, flat 1px border. Scaffold login, dashboard, document list pages."*

### Step 3: Database Migration Execution & Seeding
1. **Verify Staging ENV**: Before migrations, verify `.env` (staging):
   ```bash
   # Check no production keys leaked to staging
   grep -E '(DATABASE_URL|STRIPE_SECRET_KEY|AWS_SECRET)' .env
   # Confirm staging endpoints (e.g., Stripe test mode key prefix sk_test_)
   ```
2. Instruct the AI agent (OpenCode):
   > *"Read ARCHITECTURE.md Database Models section. Create complete Prisma/Drizzle schema with CHECK constraints, foreign key relations, and performance indexes. Run the migration."*
3. Run migrations: `pnpm db:migrate`
4. Run initial seed data: `pnpm db:seed`

### Step 4: Coding Backend API, Vault Service, & UI Wiring
1. Instruct the AI agent to execute items on `TODO.md` one by one:
   - Apply Zod validation on API handlers.
   - Build AES-256-GCM stream encryption service to S3/R2 with 15-minute presigned URLs.
   - Connect Stitch UI forms to API endpoints via `fetch` or Server Actions.
   - Ensure all five screen states work: *Skeleton Loader*, *Empty State*, *Inline Error Message*, and *Notification Toast*.
   - Apply prompt engineering & multi-file orchestration patterns from `references/playbooks/ai-assisted-development.md`.

### Step 5: Self-Assertion Testing (Local Smoke Test)
Run rapid test script:
```bash
pnpm run test:smoke
```
Ensure clean compilation (`pnpm run type-check`) and clean dependency audit (`pnpm audit`).

---
## 5A. Backend Development TODO Checklist (Detailed Breakdown)

**Detailed checklist**: See [`templates/04-dev-execution/checklists/backend-checklist.md`](../../templates/04-dev-execution/checklists/backend-checklist.md)

Comprehensive checklist covers:
1. **Database Setup & Migrations**: Connection pooling, schema definition, indexing strategy, soft-delete, seeders
2. **API Endpoints Development**: Authentication endpoints, CRUD, search/filtering, pagination
3. **Middleware Implementation**: Auth middleware, RBAC, validation, rate limiting, security headers
4. **Background Jobs & Queues**: Worker setup, async tasks, retry policies, DLQ
5. **File Upload & Storage**: Presigned URLs, validation, encryption at-rest
6. **Email & Notifications**: Transactional email, templates, in-app notifications, webhook handlers

**Quick reference** for AI coding agents:
```
> "Load backend checklist: templates/04-dev-execution/checklists/backend-checklist.md"
> "Verify database migrations reversible and seeders functional"
> "Audit API endpoints for tenant isolation and IDOR prevention"
```

---

## 5B. Frontend Development TODO Checklist (Detailed Breakdown)

**Detailed checklist**: See [`templates/04-dev-execution/checklists/frontend-checklist.md`](../../templates/04-dev-execution/checklists/frontend-checklist.md)

Comprehensive checklist covers:
1. **Component Library & Design System**: Token sync, UI atoms (Button, Input), molecules (Toast, Modal), navigation, WCAG AA compliance
2. **Pages & Routing**: Layout hierarchy, auth pages, dashboard pages, error boundaries
3. **State Management**: Server-state (TanStack Query/SWR), client UI state (Zustand), URL sync
4. **Form Handling & Validation**: React Hook Form + Zod, inline validation, double-submit protection
5. **API Integration**: HTTP client abstraction, file upload progress, optimistic updates
6. **The 5 UI States**: Idle, Loading (skeleton), Success (toast), Error (retry), Empty (CTA)

**Quick reference** for AI coding agents:
```
> "Load frontend checklist: templates/04-dev-execution/checklists/frontend-checklist.md"
> "Verify WCAG AA contrast ratios and keyboard navigation"
> "Audit forms for Zod validation and optimistic UI rollback"
```

---

## 5C. Integration TODO Checklist (Third-Party & Infrastructure)

**Detailed checklist**: See [`templates/04-dev-execution/checklists/integration-checklist.md`](../../templates/04-dev-execution/checklists/integration-checklist.md)

Comprehensive checklist covers:
1. **Payment Gateway (Stripe/Midtrans)**: Sandbox setup, transaction initiation, webhook cryptographic validation, idempotency, atomic status transitions
2. **Transactional Email (SendGrid/Resend)**: DNS verification (SPF/DKIM/DMARC), email client isolation, automated receipts
3. **File Storage (S3/R2)**: Bucket CORS config, least-privilege IAM, lifecycle policies
4. **Product Analytics (Mixpanel/GA4/PostHog)**: Privacy-compliant init, core telemetry mapping, PII scrubbing
5. **Application Monitoring (Sentry)**: SDK installation, sensitive data scrubbing, performance tracing, health checks

**Quick reference** for AI coding agents:
```
> "Load integration checklist: templates/04-dev-execution/checklists/integration-checklist.md"
> "Verify webhook signature validation and idempotency handling"
> "Audit Sentry beforeSend filter for credential leaks"
```

---

## 5D. Code Review Milestone Checkpoints (Solo Developer & AI Code Gates)

In solo development accelerated by AI Coding Agents, *code review* is conducted across 4 layered checkpoint gates (*milestone gates*) before branches are merged into `staging` or advanced to Module 07 testing:

```text
[Feat Branches] ──► [Checkpoint 1: Foundation Gate] ──► staging
                                  │
[Auth & Core]   ──► [Checkpoint 2: Alpha Release Gate] ──► Term 2 (25-30%)
                                  │
[Integrations]  ──► [Checkpoint 3: Third-Party & Security] ──► staging
                                  │
[Full Hardening]──► [Checkpoint 4: Beta & Staging Freeze] ──► Term 3 (20-25%) ──► Module 07 (QA & SIT)
```

### Checkpoint 1: Scaffolding & Foundation Gate
- **Trigger**: Scaffolding complete, 9 AI harness files installed, initial database schema created.
- **Target Branch**: `feat/scaffold` ──► `staging`
- **Mandatory Checklist**:
  - [ ] All 9 AI harness files located in project root and customized per FSD.md.
  - [ ] TODO.md generated with all FSD tables, SITEMAP screens, and API endpoints mapped.
  - [ ] VERIFY_LOCAL.md generated with project-specific endpoints and stack commands (not template placeholders).
  - [ ] RUNBOOK_LOCAL.md contains correct stack-specific commands (npm/composer/python/go).
  - [ ] TypeScript strict mode active (`tsc --noEmit` exits 0 with zero errors).
  - [ ] No `any` types detected across all new code files.
  - [ ] Database schema and initial migration successfully executed in local database.
  - [ ] File `.env.example` lists all environment variables used in code without leaking real secrets.
- **AI Review Protocol**:
  > *"Run audit on branch `feat/scaffold`. Verify folder architecture is consistent, no circular dependencies exist, and database schema enforces robust data integrity constraints."*

### Checkpoint 2: Core Data & Domain Gate (Term 2 Alpha Release Gate)
- **Trigger**: Authentication module complete, core entity CRUD API functioning, and initial form UI wired.
- **Target Milestone**: Term 2 Alpha Release (25% to 30% Project Payment).
- **Mandatory Checklist**:
  - [ ] End-to-end authentication functional with JWT/session stored in HttpOnly cookies (`SameSite=Lax`, `Secure`).
  - [ ] Zod schema validation active on every API handler and UI form.
  - [ ] Tenant isolation verified: User from Tenant A cannot access Tenant B entities via IDOR.
  - [ ] AES-256-GCM encryption actively protects documents/sensitive data.
  - [ ] Local smoke test phase 1 passes 100%.
- **Gate Decision**:
  - **PASS**: Issue Term 2 Invoice to Client accompanied by demo video / local verification report.
  - **FAIL**: Fix security vulnerabilities or logic bugs before invoicing the term.

### Checkpoint 3: Third-Party & Infrastructure Integration Gate
- **Trigger**: Payment gateway, transactional email, cloud storage, analytics, and monitoring integrations complete.
- **Target Branch**: `feat/integrations` ──► `staging`
- **Mandatory Checklist**:
  - [ ] Payment gateway webhook validates cryptographic signatures and enforces absolute idempotency handling.
  - [ ] Direct file upload to cloud storage via presigned URL verified, with magic-byte-based MIME-type validation.
  - [ ] Transactional emails delivered with clean HTML templates and plain text fallbacks.
  - [ ] Rate limiting actively protects login and public endpoints from brute-force attacks.
  - [ ] Dependency audit (`pnpm audit` / `composer audit`) clean of High or Critical vulnerabilities.
- **AI Review Protocol**:
  > *"Examine all webhook and file upload implementations. Verify replay attack defenses are solid, signing tokens validated, and files cannot be arbitrarily executed on the server."*

### Checkpoint 4: Release Candidate & Staging Freeze Gate (Term 3 Beta Release Gate)
- **Trigger**: All backend and frontend features wired, 5 UI states in place, ready to enter Module 07 QA & SIT.
- **Target Milestone**: Term 3 Beta Release (20% to 25% Project Payment).
- **Mandatory Checklist**:
  - [ ] Defensive UI: All pages and components have implemented 5 UI States (Idle, Loading skeleton, Success feedback, Error alert, Empty state).
  - [ ] Free of N+1 queries: All data relationships in lists/tables optimized with `include`/`with` queries and indexed foreign keys.
  - [ ] Sentry / APM actively captures unhandled errors with sensitive data scrubbing filters.
  - [ ] Complete smoke test (`test:smoke`) passes 100%.
  - [ ] `VERIFY_LOCAL.md` and `DEVELOPMENT_PROGRESS_TRACKER.md` fully completed and signed off.
  - [ ] Branch `staging` clean, frozen, and tagged with release tag (example: `git tag -a v0.9.0-beta -m "Beta release ready for QA"`).

**Note on VERIFY_LOCAL.md Verification**:
- VERIFY_LOCAL.md is generated per-project with FSD endpoints and stack-specific commands
- Manual review required: verify all checkboxes reflect actual testing (not template defaults)
- Evidence required: commit SHA filled, smoke test output pasted, API responses documented
- Automated gate script pending implementation (requires universal stack detection)

- **Gate Decision**:
  - **PASS**: Advance to **Module 07: Quality Assurance & SIT on Staging**. Issue Term 3 Invoice if agreed in contract.
  - **FAIL**: Postpone release, resolve technical debt in `DEVELOPMENT_PROGRESS_TRACKER.md`.

---

## 6. Payment Milestone Achievements (Term Gates)

1. **Alpha Milestone (Term 2 - 25% to 30%)**:
   - *Pass Criteria*: Database migrated, login authentication active, document draft creation workflow running locally, and baseline security/performance pillars verified on branch `staging`.
   - *Action*: Issue Term 2 Invoice to Client.
   - *Template*: Use accounting software (Wave/Invoicely) or simple format: Project name, Term 2 (Alpha 25-30%), Amount, Due date, Payment method.
2. **Beta Milestone (Term 3 - 20% to 25%)**:
   - *Pass Criteria*: All backend modules, frontend, and encrypted vault completely connected and ready for testing on Staging server.
   - *Action*: Advance to Module 07 (QA & SIT) before client UAT.

---

## 6A. Product Instrumentation & Analytics Setup [OPTIONAL SECTION]

> 🎯 **WHEN TO USE THIS SECTION?**
> - **Medium/Large scale projects**: Need funnel analysis, retention cohorts, A/B testing
> - **Post-MVP validation**: Product launched, need data to validate product-market fit
> - **Fundraising prep**: Investors require traction metrics dashboard
> - **Growth phase**: Ready to optimize conversion and engagement
>
> **SKIP THIS SECTION IF:**
> - MVP <4 weeks with basic page view tracking sufficient
> - API-only backend without user-facing analytics needs
> - Still pre-launch validation phase (wait until real users)

> - `references/pm/PM_ANALYTICS_SETUP_GUIDE.md` (Platform selection, Event taxonomy quickstart, AARRR dashboard, A/B testing, Privacy compliance)

Post-development phase for solo developers and PMs who need to quantitatively measure product-market fit, engagement funnels, and business metrics. The objective is to set up a structured **event tracking taxonomy**, **analytics platform SDK** (Mixpanel/Amplitude/GA4), and **real-time dashboard** for monitoring the North Star Metric.

---

### 1. Analytics Platform Selection Matrix

| Platform | Best For | Pricing | Solo Dev Friendly? | Key Features |
|----------|----------|---------|-------------------|--------------|
| **Mixpanel** | Funnel analysis, retention cohorts | Free: 100K events/mo | ✅ Yes | Event-based, user profiles, funnel viz |
| **Amplitude** | Product analytics, user journeys | Free: 10M events/mo | ✅ Yes | Retention, behavioral cohorting |
| **PostHog** | Self-hosted, privacy-first | Free: 1M events/mo | ✅ Yes | Feature flags + analytics + session replay |
| **Google Analytics 4 (GA4)** | Web traffic, SEO attribution | Free: unlimited | ✅ Yes | Acquisition tracking, basic funnels |
| **Segment.io** | CDP layer (multi-tool routing) | $120/mo minimum | ❌ Overkill for solo | Event routing to multiple destinations |

**Default Stack for Solo Dev (Medium Scale)**:
```text
Mixpanel (funnel + retention) + GA4 (acquisition) + Sentry (errors)
Total cost: $0/mo until scale
```

---

### 2. Event Tracking Taxonomy (The Naming Convention)

**Standard Format**: `verb_noun` (lowercase, underscore separator)

```typescript
// ✅ CORRECT
track('view_page', { page_name: 'dashboard', user_role: 'admin' })
track('click_button', { button_id: 'export_pdf', screen: 'document_detail' })
track('complete_signup', { signup_method: 'google_oauth' })

// ❌ WRONG (inconsistent naming)
track('Page Viewed', { pageName: 'Dashboard' })  // space, PascalCase
track('buttonClick', { id: 'export' })             // camelCase verb
```

**Main Event Categories**:

| Category | Event Examples | Tracking Goal |
|----------|----------------|---------------|
| **Page Views** | `view_page`, `view_dashboard`, `view_settings` | User navigation, screen time |
| **User Actions** | `click_button`, `submit_form`, `upload_file` | Key feature interaction |
| **Conversion** | `complete_signup`, `complete_payment`, `activate_account` | Funnel drop-off analysis |
| **Engagement** | `share_document`, `invite_user`, `enable_notification` | Viral coefficient, retention |
| **Errors** | `error_payment_failed`, `error_upload_timeout` | Friction points |

---

### 3. Implementation Quickstart (Next.js + Mixpanel)

**Step 1**: Install SDK
```bash
pnpm add mixpanel-browser
```

**Step 2**: Create Analytics Wrapper (`lib/analytics.ts`)
```typescript
import mixpanel from 'mixpanel-browser'

const MIXPANEL_TOKEN = process.env.NEXT_PUBLIC_MIXPANEL_TOKEN

export const analytics = {
  init: () => {
    if (MIXPANEL_TOKEN) {
      mixpanel.init(MIXPANEL_TOKEN, { 
        debug: process.env.NODE_ENV === 'development',
        track_pageview: false,
        persistence: 'localStorage'
      })
    }
  },
  
  identify: (userId: string, traits?: Record<string, any>) => {
    mixpanel.identify(userId)
    if (traits) mixpanel.people.set(traits)
  },
  
  track: (event: string, properties?: Record<string, any>) => {
    mixpanel.track(event, properties)
  }
}
```

**Step 3**: Track User Actions
```typescript
// app/dashboard/page.tsx
import { analytics } from '@/lib/analytics'

export default function DashboardPage() {
  useEffect(() => {
    analytics.track('view_page', { page_name: 'dashboard' })
  }, [])
  
  const handleExport = () => {
    analytics.track('click_button', { button_id: 'export_pdf' })
    // ... export logic
  }
}
```

---

### 4. Core Metrics & Dashboard Design (AARRR Framework)

**North Star Metric** (from M00 Product Discovery):

| Product Type | North Star Metric Example |
|--------------|---------------------------|
| SaaS Document Vault | Weekly Active Documents Uploaded |
| E-commerce | Orders per Week |
| Social App | Daily Active Users (DAU) |
| API Service | API Calls per Day |

**AARRR Metrics Breakdown**:
```text
Acquisition:    New signups per week (source: GA4 UTM params)
Activation:     % users who complete first key action within 24h
Retention:      Weekly retention cohort (W1, W2, W4 retention %)
Referral:       Viral coefficient (invites sent / new users)
Revenue:        MRR, ARPU, LTV/CAC ratio
```

---

### 5. Privacy Compliance (GDPR & UU PDP No. 27/2022)

**Consent Management Checklist**:
- [ ] Cookie banner with explicit opt-in (not pre-checked)
- [ ] Disable tracking before user clicks "Accept Analytics"
- [ ] Provide opt-out URL: `/privacy/opt-out`
- [ ] Anonymize IP addresses: `mixpanel.set_config({ ip: false })`
- [ ] Data retention policy: Auto-delete events > 2 years

**Code Example**: Consent Wrapper
```typescript
export const analytics = {
  init: () => {
    const consent = localStorage.getItem('analytics_consent')
    if (consent === 'granted' && MIXPANEL_TOKEN) {
      mixpanel.init(MIXPANEL_TOKEN)
    }
  },
  
  grantConsent: () => {
    localStorage.setItem('analytics_consent', 'granted')
    analytics.init()
  }
}
```

---

### 6. Output Artifacts (Deliverables)

| Artifact | Location | Purpose |
|----------|----------|---------|
| **Event Taxonomy Doc** | `docs/analytics/EVENT_TAXONOMY.md` | Single source of truth for event names |
| **Implementation Plan** | `docs/analytics/ANALYTICS_IMPLEMENTATION_PLAN.md` | SDK installation steps, tracking code locations |
| **Dashboard Spec** | `docs/analytics/DASHBOARD_SPEC.md` | Metrics definitions, chart types, alert thresholds |

**Template Sources**:
- `templates/09-product-growth/EVENT_TAXONOMY_TEMPLATE.md`
- `templates/09-product-growth/ANALYTICS_IMPLEMENTATION_PLAN_TEMPLATE.md`
- `templates/09-product-growth/DASHBOARD_SPEC_TEMPLATE.md`

---

### 7. Solo Developer Analytics Principles

1. **Prioritize Signal over Noise**: Track maximum 10 core events, not 100 random clicks
2. **No Vendor Lock-In**: Use wrapper abstraction (`lib/analytics.ts`) for easy platform swapping
3. **Privacy-First by Default**: Opt-in analytics for UU PDP compliance
4. **Dashboard as Product Compass**: North Star Metric must be visible within 3 seconds
5. **Free Tier Sufficiency**: Solo developer projects rarely exceed 100K events/month before PMF

---

## 7. Output Artifacts (Deliverables)

1. **Git Repository Source Code**: Clean codebase with active `staging` branch and structured commit history.
2. **`RUNBOOK_LOCAL.md`**: Complete guide for environment setup, DB migrations, and running the application locally (using `templates/04-dev-execution/RUNBOOK_LOCAL_TEMPLATE.md`).
3. **`VERIFY_LOCAL.md`**: Self-verification results sheet proving that all FSD endpoints, 3 engineering pillars, and Stitch flows are 100% functional (using `templates/04-dev-execution/VERIFY_LOCAL_TEMPLATE.md`).
4. **`AI_REVIEW_LOG.md`**: Pre-merge AI code review protocol log following `references/playbooks/ai-assisted-development.md`.
5. **`DEVELOPMENT_PROGRESS_TRACKER.md`**: Coding execution progress tracker sheet, backend, frontend, integration checklists, and code review checkpoints (using `templates/04-dev-execution/DEVELOPMENT_PROGRESS_TRACKER.md`).

---

## 8. Gate Exit Criteria [GATE]

[GATE] Module 06 is declared **PASSED** if:
- [x] Git branching is structured (`main`, `staging`, `feat/*`) with clean commits.
- [x] 7 AI control files (Agent Harness) installed in project root.
- [x] Google Stitch components extracted via MCP and connected to backend API.
- [x] Source code builds successfully without TypeScript compilation errors (`tsc --noEmit` exits 0).
- [x] Database migrations execute smoothly with search indexes in place.
- [x] Stream-based AES-256-GCM vault file encryption successfully stores and retrieves documents via presigned URLs.
- [x] Self-test script (`smoke-test`) passes 100% and dependency audit (`pnpm audit`) is free of critical vulnerabilities.

---

## 🛑 PROTOCOL [GATE] EXIT & MANDATORY STOP

After coding is complete and the `smoke-test` script passes 100%:
1. **STRICTLY FORBIDDEN to proceed directly or invoke tools for Module 07 within the same turn!**
2. **SELF-VERIFICATION (Self-Verification Checklist)**:
   - [ ] `terminal('pnpm run type-check')` → Exit code 0 (no TypeScript errors)
   - [ ] `terminal('pnpm run test:smoke')` → All assertions passed
   - [ ] `terminal('pnpm audit')` → No critical vulnerabilities
   - [ ] `read_file('VERIFY_LOCAL.md')` → Documented test results exist
   - [ ] `terminal('git log -1')` → Latest commit exists on staging branch
3. Display summary of local development results to the user:
   - Compilation and local smoke test results
   - Proof of functionality in `VERIFY_LOCAL.md`
   - Readiness for Staging integration testing (Term 2 Alpha Release)
4. **END YOUR TURN** and request confirmation from the user:
   > *"All core features have been developed and verified locally (Smoke Test PASS). Is this development output approved before we initiate Module 07 (Quality Assurance & SIT on Staging)?"*
5. Wait for explicit approval response from the user before proceeding to Module 07.
