# Module 06 Deep Dive: Development Execution (Extended Examples)

## Contents

- [Code Style Rules (per-stack AGENTS.md)](#code-style-rules-per-stack-agentsmd)
- [Code Style Rules](#code-style-rules)
- [Code Style Rules](#code-style-rules)
- [Code Style Rules](#code-style-rules)
- [Anti-Pattern Detection](#anti-pattern-detection)
- [Database Migration Anti-Patterns](#database-migration-anti-patterns)
- [Dependency Compatibility & Pre-Install Checks](#dependency-compatibility-pre-install-checks)
- [Known Security Risks](#known-security-risks)
- [9-File Harness: Staging & Template Examples](#9-file-harness-staging-template-examples)
- [3. The 9 Root Harness Files in Root Repo (Universal Stack - The 9 Root Harness Files)](#3-the-9-root-harness-files-in-root-repo-universal-stack---the-9-root-harness-files)
- [Anti-AI-Slop Directives](#anti-ai-slop-directives)
- [Phase-0 Gate Check & Extended Checklists](#phase-0-gate-check-extended-checklists)
- [Example FSD.md Header](#example-fsdmd-header)
- [Module 04 Handoff Strategy](#module-04-handoff-strategy)


> Verbatim extended examples extracted from `docs/modules/06_DEVELOPMENT_EXECUTION.md` (runbook). Read the runbook first; consult this file for full details.

## Code Style Rules (per-stack AGENTS.md)

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
## Anti-Pattern Detection

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
## Database Migration Anti-Patterns

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
## 9-File Harness: Staging & Template Examples

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
### Stack-Specific Template Examples

#### Next.js AGENTS.md (TypeScript Strict Mode)
```markdown
# AI Agent Guidelines - Next.js Project
```
## Anti-AI-Slop Directives

### Anti-AI-Slop Code Directives (Enforced across all AGENTS.md)
Every stack-specific `AGENTS.md` strictly bans these AI coding defects:
1. **Banned: Redundant & Obvious Comments**: No commenting what the code clearly does (e.g., `// Add 1 to x` above `x += 1`). No leaving `// TODO: Implement later` stubs in production files. No commented-out dead code.
2. **Banned: Silent Failures**: No `try { ... } catch {}` that swallows errors. All failures must be logged, rethrown, or surfaced as a typed error.
3. **Banned: Dead Code & Unused Imports**: No unreachable branches, unused variables, or orphaned imports.
4. **Race Conditions (Mandatory)**: Any read-modify-write on shared state (stock, balances, counters, booking slots, status transitions) must be atomic — DB transaction + row lock, unique constraint, or compare-and-swap. Webhooks/payment callbacks must be idempotent. Never check-then-act across two queries.
5. **Banned: Hallucinated Libraries & APIs**: No importing uninstalled or fictitious packages. Verify all dependencies exist before importing.

Related bans (security-focused, in every stack file): hardcoded secrets, unvalidated inputs, and raw SQL string concatenation.

> **Verification**: `validate-gate.sh M06` mechanically scans source for type-suppression escape hatches, placeholder TODO stubs, hardcoded secrets, narrating comments, and unlocked read-modify-write statements.

---

## Phase-0 Gate Check & Extended Checklists

### STEP 0 Gate-Check Script (PowerShell, from runbook v1)

```powershell
# GATE CHECK - Module 06 Phase 0: Verify locked stack decision exists
$state = if (Test-Path "docs/pm/PROJECT_STATE.md") { Get-Content "docs/pm/PROJECT_STATE.md" -Raw } else { "" }
$isSmall = ($state -match "(?i)Scale:\s*small") -or ((Test-Path "PROJECT_LITE.md") -and -not (Test-Path "docs/pm/PROJECT_STATE.md"))

if ($isSmall) {
    if (-not (Test-Path "PROJECT_LITE.md")) {
        Write-Error "GATE FAILED: PROJECT_LITE.md not found. Fast-Track Small Scale requires PROJECT_LITE.md."
        exit 1
    }
    Write-Host "PHASE 0 PASSED: Small Scale Fast-Track detected via PROJECT_LITE.md"
} else {
    if (-not (Test-Path "docs/specs/FSD.md")) {
        Write-Error "GATE FAILED: FSD.md not found. Module 06 requires FSD.md from Module 05."
        exit 1
    }
    $fsdContent = Get-Content "docs/specs/FSD.md" -Raw
    if ($fsdContent -notmatch "Stack Decision LOCKED:") {
        Write-Error "GATE FAILED: FSD.md missing locked stack decision. Re-run Module 05 questionnaire & lock stack."
        exit 1
    }
    if ($fsdContent -match "Stack Decision LOCKED:\s*(.+)") {
        Write-Host "PHASE 0 PASSED: Locked stack detected: $($matches[1].Trim())"
    }
    if ($fsdContent -notmatch "Module 04 Handoff Strategy") {
        Write-Error "GATE FAILED: FSD.md missing 'Module 04 Handoff Strategy' section. Update FSD.md."
        exit 1
    }
    Write-Host "FSD.md verification complete. Proceeding to scaffold..."
}
```

### Scaffold Gate: Verify Scaffold Matches FSD (pseudo-code)

```python
def verify_scaffold_matches_fsd():
    fsd_stack = parse_fsd_stack("docs/specs/FSD.md")  # e.g. "Laravel 11"
    if fsd_stack.startswith("Laravel"):
        if not exists("composer.json"): raise Error("FSD says Laravel, but no composer.json. Wrong scaffold.")
        if exists("package.json") and "next" in read("package.json"): raise Error("FSD says Laravel, but scaffolded Next.js. Re-scaffold.")
        laravel_version = json.load("composer.json")["require"]["laravel/framework"]
        if "11." not in laravel_version and fsd_stack == "Laravel 11": warn("Laravel version mismatch vs FSD.")
    elif fsd_stack.startswith("Next.js"):
        pkg = json.load("package.json")
        if "next" not in pkg.get("dependencies", {}): raise Error("package.json missing 'next'.")
        # Major version match (CRITICAL): FSD "Next.js 15" vs resolved "^16.0.0" -> BLOCKING
        if parse_major(pkg["dependencies"]["next"]) != parse_version(fsd_stack):
            raise Error(f"BLOCKING: version mismatch. Fix: npx create-next-app@{fsd_version} or update FSD.md")
        # Tailwind version detection (affects AGENTS.md syntax)
        if parse_major(pkg["dependencies"]["tailwindcss"]) >= 4:
            warn("Tailwind v4 detected. CSS-first config (not tailwind.config.js). Harness files must use v4 syntax.")
    elif fsd_stack.startswith("Django"):
        if not exists("manage.py"): raise Error("FSD says Django, but no manage.py. Wrong scaffold.")
    return {"framework": fsd_stack.split()[0].lower()}

def install_dependencies_with_fallback():
    # npm timeout loop (3x) wasted 6 minutes in the field -> switch to pnpm after 2 timeouts
    try: run("npm install", timeout=120)
    except TimeoutError:
        try: run("npm install", timeout=120)
        except TimeoutError:
            if not command_exists("pnpm"): run("npm install -g pnpm")
            run("pnpm install")
```

**Verification gates**: (1) framework type mismatch -> STOP, re-scaffold; (2) major version mismatch -> BLOCKING, fix first; (3) Tailwind v4 -> adjust harness files to v4 syntax; (4) npm timeout 2x -> auto-switch to pnpm.

### Post-Scaffold Checklist

```bash
# - [ ] Framework files exist (package.json / composer.json / manage.py)
# - [ ] Major version matches FSD.md (Next.js 15 = 15.x, not 16.x)
# - [ ] Tailwind version checked (v3 vs v4 affects config syntax)
# - [ ] Dependencies installed (fallback strategy if timeout)
# - [ ] No blocking advisories (e.g., eslint-config-next version mismatch)
# - [ ] Peer dependencies resolved (no [WARN] unmet peer)
# - [ ] No deprecated packages (search install output for deprecation warnings)
```

### Module Completion Checklist (Full Body)

**Pre-handoff quality gates:**
- Scaffold verification: framework type matches FSD; major version matches FSD; Tailwind version detected; dependencies installed; peer dependencies resolved (no `[WARN] unmet peer`); no deprecated packages in package.json/composer.json; no blocking advisories.
- Dependency compatibility (MANDATORY): `npm info <key-packages> peerDependencies`; Zod compatible with react-hook-form (v3.x, NOT v4); `@hookform/resolvers` matches Zod (v3.x for Zod v3); `@types/react` matches react major (18.x for react 18); `eslint-config-next` matches `next`; no deprecated packages (`npm view <pkg> deprecated`); local font packages preferred over CDN; spec-locked CVEs documented.
- Harness files deployed: all 9 copied from `docs/harness-root/` to root - `AGENTS.md`, `ARCHITECTURE.md`, `CONTEXT.md`, `CONVENTIONS.md`, `DESIGN.md`, `TODO.md`, `.env.example`, `RUNBOOK_LOCAL.md`, `VERIFY_LOCAL.md` (check with `cat AGENTS.md`).
- Smoke test: dev server starts (`npm run dev` / `php artisan serve`); no import errors on first load; linter runs clean (`npm run lint`); type check passes (`pnpm run type-check` or `tsc --noEmit`); no peer dependency warnings in `pnpm list`; database connection works (if applicable).

**NEVER declare "M06 complete" with outstanding checkboxes. "Deployed" != "Verified" - test execution required.**

### Template Selection Matrix (Stack-Specific Harness Paths)

| Template File | Next.js Path | Laravel Path | Django Path | Go Path |
|---|---|---|---|---|
| AGENTS.md | `templates/04-dev-execution/nextjs/AGENTS.md` | `templates/04-dev-execution/laravel/AGENTS.md` | `templates/04-dev-execution/django/AGENTS.md` | `templates/04-dev-execution/go/AGENTS.md` |
| ARCHITECTURE.md | `templates/04-dev-execution/nextjs/ARCHITECTURE.md` | `templates/04-dev-execution/laravel/ARCHITECTURE.md` | `templates/04-dev-execution/django/ARCHITECTURE.md` | `templates/04-dev-execution/go/ARCHITECTURE.md` |
| CONVENTIONS.md | `templates/04-dev-execution/nextjs/CONVENTIONS.md` | `templates/04-dev-execution/laravel/CONVENTIONS.md` | `templates/04-dev-execution/django/CONVENTIONS.md` | `templates/04-dev-execution/go/CONVENTIONS.md` |

### Extended Stack Scaffold Commands (Non-Primary Stacks)

| Detected Stack | Scaffold Command | ORM/Migration Tool |
|---|---|---|
| Remix | `npx create-remix@latest` | Prisma / Drizzle |
| SvelteKit | `npm create svelte@latest` | Prisma / Drizzle |
| Astro | `npm create astro@latest` | Prisma (API routes) |
| Laravel + Inertia | `composer create-project laravel/laravel && php artisan inertia:install vue` | Eloquent + Inertia |
| FastAPI | `mkdir myproject && poetry init` | SQLAlchemy / Tortoise ORM |
| Rails | `rails new myproject --database=postgresql --css=tailwind` | ActiveRecord |
| Spring Boot | `curl https://start.spring.io/starter.zip -o myproject.zip` | JPA / Hibernate |

### FSD.md Extraction Examples (Stack Config, Handoff, DB Syntax)

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

Agent extracts: `frontend_framework` = "Laravel Blade + Inertia.js"; `backend_framework` = "Laravel 11"; `database` = "MySQL 8"; `orm_tool` = "Eloquent".

```markdown
## Module 04 Handoff Strategy
**Compatibility Level**: Level 4 (Hybrid - Inertia.js)
**Conversion Plan**:
1. Extract 18 Vue components from component specs
2. Setup Inertia.js in Laravel (ziggy routes, Vite config)
3. Create Laravel routes for every page
**Estimated Conversion Time**: 5-7 days
```

Agent extracts: `compatibility_level` = 4; `conversion_approach` = "Hybrid - Inertia.js"; `estimated_days` = 5-7.

```sql
-- FSD.md contains MySQL syntax (NOT PostgreSQL) -> use matching migration tool
CREATE TABLE users (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  email VARCHAR(255) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

### Self-Verification Commands (GATE Exit Protocol)

```text
terminal('pnpm run type-check')  -> Exit code 0 (no TypeScript errors)
terminal('pnpm run test:smoke')  -> All assertions passed
terminal('pnpm audit')           -> No critical vulnerabilities
read VERIFY_LOCAL.md             -> Documented test results exist
terminal('git log -1')           -> Latest commit exists on staging branch
```

Approval prompt to user: *"All core features have been developed and verified locally (Smoke Test PASS). Is this development output approved before we initiate the next phase?"*