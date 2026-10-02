# Modul 06: Development (Backend, Frontend, Integrasi API, & 3 Pilar Rekayasa)

> ⚠️ **MANDATORY: Load references BEFORE executing this module**:
> - `references/solo/SOLO_DEVELOPMENT_PATTERNS.md` (Zod validation, AES-256-GCM encryption, Pessimistic locking, Presigned URLs, Self-test scripts)
> - `references/solo/SOLO_ENGINEERING_STANDARDS.md` (Git branching, OWASP/UU PDP audit, N+1 query prevention, Asset optimization, Connection pooling)
> - `references/improvements/MODUL_06_IMPROVEMENTS.md` (Timeline estimation 29-478 jam, AI agent delegation strategy, smoke test 3-tier, env var management, VERIFY_LOCAL template, Modul 04 dependency workflow)
> - `references/technical/AI_DEVELOPMENT_TOOLS_COMPARISON.md` (AI coding tool selection, Cursor vs Claude Code vs Windsurf benchmark)
> - `references/playbooks/ai-assisted-development.md` (Prompt engineering patterns, multi-file orchestration, pre-merge AI review protocol)
> - `references/playbooks/software-design-patterns.md` (Clean code principles, SOLID, design patterns, and anti-pattern detection for AI-generated code)
> - `templates/04-dev-execution/DEVELOPMENT_PROGRESS_TRACKER.md` (Lembar pelacak kemajuan eksekusi koding, checklist backend, frontend, integrasi, & pos pemeriksaan review)
>
> **MANDATORY: Load references BEFORE executing this module**:
> - Read: `references/solo/SOLO_DEVELOPMENT_PATTERNS.md`

Modul ini adalah tahap keenam dalam siklus hidup proyek perangkat lunak untuk solo developer. Tujuannya adalah mengeksekusi penulisan kode nyata (*coding*) secara terarah menggunakan bantuan **AI Coding Agents (OpenChamber + OpenCode + OhMyOpenCode / Cursor / Claude Code)** melalui penyediaan **Agent Harness (berkas pemandu AI)**, mengintegrasikan antarmuka dari **Google Stitch**, mengelola percabangan **Git**, serta menegakkan 3 pilar rekayasa non-negosiasi: **Keamanan (Security)**, **Performa (Performance)**, dan **Efisiensi Sumber Daya (Resource Efficiency)**.

---

## 1. Siklus Eksekusi Modul 06 (Universal Tech Stack Development Loop)

```text
[ INPUT: FSD.md (with LOCKED stack decision), PRD.md, & Stitch Prototype dari Modul 04-05 ]
                                    │
                                    ▼
[ LANGKAH 0: Extract Tech Stack Decision dari FSD.md (MANDATORY FIRST) ]
  • Read FSD.md header → Extract locked stack (Next.js/Laravel/Django/Go/etc)
  • Read "Module 04 Handoff Strategy" section → Extract compatibility level (1-4)
  • Load stack-specific templates & scaffold commands
  • Verify stack decision matches Module 05 approval (GATE check)
                                    │
                                    ▼
[ LANGKAH 1: Inisiasi Repositori & Scaffold (Stack-Adapted) ]
  • Execute scaffold command untuk chosen stack:
    - Next.js: pnpm create next-app@latest
    - Laravel: composer create-project laravel/laravel --prefer-dist
    - Django: django-admin startproject (verify Django version: pip install django>=4.2)
    - Go: mkdir + go mod init
  • Pasang 7 Berkas Harness AI (stack-specific templates)
  • Git Init & Strategi Percabangan (main ──► staging ──► feat/*)
                                    │
                                    ▼
[ LANGKAH 2: Module 04 Prototype Conversion (4 Compatibility Levels) ]
  • Level 1 (React → Next.js/Remix): Direct copy (1 hari, 95% reuse)
  • Level 2 (React → Vue/Svelte): Syntax conversion (3-4 hari, 70% reuse)
  • Level 3 (React → Laravel Blade): Template rewrite (5-7 hari, 0% code reuse)
  • Level 4 (React → Inertia.js): Hybrid glue layer (5-6 hari, 70% reuse)
  • Execute strategy documented di FSD.md "Module 04 Handoff Strategy"
  • Pastikan UI Visual 100% Identik dengan Prototipe Terkunci
                                    │
                                    ▼
[ LANGKAH 3: Database Schema & Migrations (Framework-Adapted) ]
  • AI Membaca ARCHITECTURE.md → Generate migrations sesuai chosen stack:
    - Next.js: Prisma/Drizzle schema + migrate
    - Laravel: Eloquent migrations + artisan migrate
    - Django: Django ORM models + makemigrations
    - Go: SQL migration files + golang-migrate
  • Pasang Database Pooling & Indexing pada Kolom Foreign Key
  • Eksekusi Migrasi Lokal & Seed Data (faker data untuk testing)
                                    │
                                    ▼
[ LANGKAH 4: Backend API & 6 Engineering Pillars (Framework-Agnostic) ]
  • AI Membaca TODO.md Sekuensial → Build API endpoints sesuai FSD.md
  • Implement validation library (Zod/Laravel Validation/Django Forms)
  • Pilar Security: Encryption, HttpOnly Cookies, Parameterized Queries
  • Pilar Performance: N+1 Prevention, Caching, Query Indexing
  • Pilar Resource: Connection Pooling, Stream Processing, Memory Management
  • Wire frontend components → backend endpoints (5 UI states: idle, loading, success, error, empty)
                                    │
                                    ▼
[ LANGKAH 5: Testing & Git Workflow (Stack-Adapted) ]
  • Run stack-specific tests:
    - Next.js: npm run test:smoke (Jest/Vitest)
    - Laravel: php artisan test (PHPUnit)
    - Django: python manage.py test (pytest)
    - Go: go test ./...
  • Audit: pnpm audit / composer audit / pip-audit
  • TypeScript check (if applicable): tsc --noEmit
  • Merge ke branch `staging` → Tag milestone (Alpha ready)
                                    │
                                    ▼
[ OUTPUT: Stack-Specific Codebase + RUNBOOK_LOCAL.md ] ──► Siap Masuk ke Modul 07: QA & SIT
```

---

## 2. LANGKAH 0: Extract Tech Stack Decision (MANDATORY FIRST)

**Agent WAJIB read FSD.md dari Module 05 SEBELUM scaffold project.**

### Verification Gate:

```powershell
# GATE CHECK - Module 06 Phase 0
# Verify FSD.md exists dan contains locked stack decision

if (-not (Test-Path "docs/specs/FSD.md")) {
    Write-Error "❌ GATE FAILED: FSD.md tidak ditemukan."
    Write-Error "Module 06 requires FSD.md dari Module 05. Run Module 05 first."
    exit 1
}

$fsdContent = Get-Content "docs/specs/FSD.md" -Raw

# Check for locked stack decision
if ($fsdContent -notmatch "Stack Decision LOCKED:") {
    Write-Error "❌ GATE FAILED: FSD.md tidak ada locked stack decision."
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

Agent must parse FSD.md untuk extract:

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
- `orm_tool`: "Eloquent" (inferred dari Laravel)

**2. Module 04 Conversion Strategy**:
```markdown
## Module 04 Handoff Strategy

**Compatibility Level**: Level 4 (Hybrid - Inertia.js)

**Conversion Plan**:
1. Extract 18 Vue components dari Stitch export
2. Setup Inertia.js di Laravel (ziggy routes, Vite config)
3. Create Laravel routes untuk setiap page
...
**Estimated Conversion Time**: 5-7 hari
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

Berdasarkan extracted stack, agent execute scaffold command yang sesuai:

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

**Agent must NOT assume Next.js** - scaffold command determined by FSD.md locked stack.

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

Agent must verify scaffold matches FSD.md:

```python
# Pseudo-code verification
def verify_scaffold_matches_fsd():
    fsd_stack = parse_fsd_stack("docs/specs/FSD.md")  # "Laravel 11"
    
    # Check package.json or composer.json exists
    if fsd_stack.startswith("Laravel"):
        if not exists("composer.json"):
            raise Error("FSD says Laravel, but no composer.json found. Wrong scaffold.")
        if exists("package.json") and "next" in read("package.json"):
            raise Error("FSD says Laravel, but scaffolded Next.js. Re-scaffold.")
    
    elif fsd_stack.startswith("Next.js"):
        if not exists("package.json"):
            raise Error("FSD says Next.js, but no package.json found.")
        pkg = json.load("package.json")
        if "next" not in pkg.get("dependencies", {}):
            raise Error("FSD says Next.js, but package.json missing 'next' dependency.")
    
    elif fsd_stack.startswith("Django"):
        if not exists("manage.py"):
            raise Error("FSD says Django, but no manage.py found. Wrong scaffold.")
    
    return True
```

**If mismatch detected**: Agent MUST stop and re-scaffold correct framework.

---

## 3. Tujuh Berkas Kendali AI di Root Repo (Universal Stack - The 7 Root Harness Files)

⚠️ **CRITICAL PRE-FLIGHT WARNING: Framework-Specific AGENTS.md Conflicts**

Multiple frameworks auto-generate conflicting `AGENTS.md` or similar files:
- **Next.js**: `create-next-app` generates 9-line boilerplate `AGENTS.md`
- **Laravel**: No conflict (Laravel doesn't generate AGENTS.md)
- **Rails**: Generates `README.md` (rename to `README_FRAMEWORK.md`)
- **Django**: No conflict

**WAJIB overwrite/check IMMEDIATELY** after scaffold:
```bash
# Next.js (MANDATORY)
cp templates/04-dev-execution/nextjs/AGENTS.md AGENTS.md

# Laravel
cp templates/04-dev-execution/laravel/AGENTS.md AGENTS.md

# Django
cp templates/04-dev-execution/django/AGENTS.md AGENTS.md

# Go
cp templates/04-dev-execution/go/AGENTS.md AGENTS.md
```

**NEVER skip this step!** Framework boilerplate lacks 6 Engineering Pillars enforcement.

---

*Panduan evaluasi & pemilihan AI coding tool: `references/technical/AI_DEVELOPMENT_TOOLS_COMPARISON.md`*

Sebelum memicu agen AI untuk menulis kode, letakkan 7 berkas kendali ini di root folder proyek:

| No | Nama Berkas | Sumber Rujukan (Stack-Specific) | Fungsi untuk AI Coding Agent |
| :---: | :--- | :--- | :--- |
| **1** | **`AGENTS.md`** | `templates/04-dev-execution/{stack}/AGENTS_TEMPLATE.md` | Aturan main mutlak: larangan tipe `any` (TS) atau raw SQL, perintah build/test, dan format commit. **Stack-specific**: Next.js (Server Components), Laravel (Eloquent), Django (ORM). |
| **2** | **`CONTEXT.md`** | `templates/04-dev-execution/CONTEXT_TEMPLATE.md` | Konteks bisnis, peran user (RBAC), dan daftar batas tegas *Out-of-Scope* agar AI tidak halusinasi. **Universal** (same for all stacks). |
| **3** | **`ARCHITECTURE.md`** | `templates/04-dev-execution/{stack}/ARCHITECTURE_TEMPLATE.md` | Rangkuman FSD: struktur folder, skema tabel, dan kontrak rute API JSON. **Stack-specific**: Next.js (`app/` dir), Laravel (`app/Http`), Django (`myapp/views.py`). |
| **4** | **`DESIGN.md`** | `templates/02-design/DESIGN_MD_TEMPLATE.md` | Token visual dari Modul 04: palet Zinc, 1 aksen brand, font Inter, border 1px flat. **Universal** (design tokens framework-agnostic). |
| **5** | **`CONVENTIONS.md`** | `templates/04-dev-execution/{stack}/CONVENTIONS_TEMPLATE.md` | Aturan gaya koding: penamaan `kebab-case` (Next.js), `PascalCase` (Laravel), `snake_case` (Django/Python). **Stack-specific**. |
| **6** | **`.env.example`** | `templates/04-dev-execution/{stack}/ENV_EXAMPLE_TEMPLATE.md` | Kamus variabel lingkungan baku agar AI tidak mengarang nama key database/rahasia. **Stack-specific**: Next.js (`DATABASE_URL`), Laravel (`DB_CONNECTION`), Django (`DATABASES`). |
| **7** | **`TODO.md`** | `templates/04-dev-execution/TODO_TEMPLATE.md` | Daftar tugas atomik sekuensial yang dicentang `[x]` satu per satu oleh AI. **Universal** (task structure same across stacks). |

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
    """Extract locked stack dari FSD.md dan return template paths."""
    
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

## 3A. LANGKAH 2: Module 04 Prototype Conversion (4 Compatibility Levels)

**Execute conversion strategy documented di FSD.md "Module 04 Handoff Strategy" section.**

Agent reads FSD.md extract:
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

# 2. Copy components ke target directory
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

**Time Investment**: 1 hari (18 screens)  
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

**Time Investment**: 3-4 hari (18 screens)  
**Code Reuse**: 70% (structure preserved, syntax adapted)  
**Risk**: Medium (manual review required, tool 80% accurate)

---

### Level 3: Template Rewrite (React → Server-Side Templates)

**Applicable Stacks**: Laravel Blade, Django Templates, Rails ERB, PHP

**Conversion Strategy**: Stitch prototype = **visual reference only**

**Conversion Steps**:

```bash
# 1. Open Stitch prototype di browser sebagai reference
# 2. Identify layout patterns:
#    - Header (logo, nav, user menu)
#    - Sidebar (if exists)
#    - Main content area
#    - Footer

# 3. Manual rewrite as server templates
# Laravel: resources/views/*.blade.php
# Django: templates/myapp/*.html

# 4. Extract Tailwind classes dari Stitch → copy ke templates
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

**Time Investment**: 5-7 hari (18 screens)  
**Code Reuse**: 0% (code rewrite), 100% (design preserved)  
**Risk**: High (manual effort, error-prone)

**Tailwind Integration** (Laravel example):
```bash
# Install Tailwind di Laravel
npm install -D tailwindcss postcss autoprefixer
npx tailwindcss init

# tailwind.config.js (copy theme dari DESIGN.md)
module.exports = {
  content: ['./resources/**/*.blade.php'],
  theme: {
    extend: {
      colors: {
        primary: '#0891B2',  // Dari DESIGN.md
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

# 4. Copy Stitch components ke framework structure
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
<!-- Copied dari Stitch export dengan minimal changes -->
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

**Time Investment**: 5-6 hari (setup 2 hari + conversion 3-4 hari)  
**Code Reuse**: 70% (Vue/React components preserved)  
**Risk**: Medium (glue layer complexity)

---

### Conversion Verification Checklist

After conversion complete, verify:

- [ ] **Visual Parity**: UI matches Stitch prototype 100% (compare screenshots)
- [ ] **Design Tokens Applied**: Colors, fonts, spacing dari DESIGN.md consistent
- [ ] **Responsive**: Mobile/tablet/desktop layouts work (test breakpoints)
- [ ] **All Screens Converted**: X/Y screens complete (track di TODO.md)
- [ ] **Components Functional**: No broken imports, props correctly typed
- [ ] **5 UI States Implemented**: idle, loading, success, error, empty (for interactive components)

**Gate**: Cannot proceed to backend API (LANGKAH 4) sampai frontend conversion complete & verified.

---

## 3B. Strategi Percabangan Git Solo Developer (Git Branching & Clean Production)

Percabangan disesuaikan dengan skala proyek:

| Scale | Branch Structure | Rationale |
|-------|------------------|-----------|
| **Kecil** | `main` only (direct commits or single dev branch) | Overhead rendah, solo dev MVP/freelance |
| **Menengah** | `main` + `staging` (optional feat/* for large features) | Integration testing sebelum production |
| **Besar/Enterprise** | `main` + `staging` + `feat/*` (strict feature branches) | Formal review gates, client demos |

**Besar/Enterprise Branching Flow**:

```text
[ main ] ──────────────(Release Tag v1.0.0 - Production Clean)─────────────────►
   ▲
   │ (Merge setelah UAT Pass)
[ staging ] ───────────(Integration & Client Demo)─────────────────────────────►
   ▲
   │ (Merge setelah lolos tes lokal)
   ├── [ feat/auth-login ] ───────► (Selesai ──► Merge ke staging)
   ├── [ feat/document-vault ] ───► (Selesai ──► Merge ke staging)
   └── [ fix/pdf-render-bug ] ────► (Selesai ──► Merge ke staging)
```

### Aturan Baku Branching (Besar/Enterprise):
1. **Branch `main` (Production)**:
   - Kode produksi 100% stabil yang sudah lolos UAT klien.
   - Bersih dari berkas internal dev: berkas seperti `TODO.md` dan catatan draf internal tidak boleh mengotori branch produksi (diatur via `.gitignore` produksi atau build docker ignore).
   - Selalu diberi label SemVer: `git tag -a v1.0.0 -m "Release v1.0.0"`.
2. **Branch `staging` (Integration)**:
   - Wadah integrasi seluruh fitur yang siap diuji di server Staging. Klien menguji fitur di environment ini.
3. **Branch `feat/[nama-fitur]`**:
   - Cabang kerja solo dev untuk setiap item besar di `TODO.md`.
   - Setelah tugas selesai dan lulus `smoke-test` lokal, branch di-merge ke `staging`.
4. **Format Pesan Commit (Conventional Commits)**:
   - `feat(vault): implement streaming AES-256 encryption for PDF upload`
   - `fix(auth): correct Argon2id memory cost parameter`
   - `perf(db): add index on documents(creator_id, status)`

---

## 4. Enam Pilar Kualitas Rekayasa (The 6 Engineering Pillars - Universal)

**Framework-agnostic principles** - applicable to semua tech stacks dari Module 05.

Pengkodean bukan hanya tentang "fitur berjalan", melainkan wajib memenuhi 6 standar rekayasa:

### Pilar 1: Keamanan Defensif (Security by Design)

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
- File dokumen: AES-256-GCM sebelum storage
- Password: Argon2id (preferred) atau bcrypt (min cost 12)
- Token sesi: HttpOnly, Secure, SameSite=Strict cookies

**Audit Dependensi** (Stack-specific):
- Next.js: `pnpm audit` atau `npm audit`
- Laravel: `composer audit`
- Django: `pip-audit` atau `safety check`
- Go: `govulncheck`

---

### Pilar 2: Performa & Kecepatan (Performance Engineering)

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
foreach ($users as $user) {
    $posts = $user->posts; // N queries!
}

// ✅ CORRECT (eager loading)
$users = User::with('posts')->get();
```

**Database Indexing** (Universal principle):
```sql
-- Index pada foreign keys (MANDATORY)
CREATE INDEX idx_documents_user_id ON documents(user_id);
CREATE INDEX idx_documents_status ON documents(status);

-- Composite index untuk filter queries
CREATE INDEX idx_documents_user_status ON documents(user_id, status);
```

**Caching Strategy**:
- Data master (jarang berubah): Cache 1-24 jam
- User sessions: Redis dengan TTL
- API responses: Cache-Control headers

---

### Pilar 3: Efisiensi Sumber Daya & Biaya (Resource & Cost Efficiency)
- **Validasi Ketat di Pintu Masuk**: Semua data request wajib melalui skema Zod.
- **Enkripsi Data Sensitif (UU PDP No. 27/2022)**: File dokumen dienkripsi AES-256-GCM sebelum masuk storage; password di-hash menggunakan Argon2id; token sesi disimpan di cookie `HttpOnly, Secure, SameSite=Strict`.
- **Audit Dependensi**: Jalankan `pnpm audit` secara berkala untuk memastikan tidak ada pustaka open-source yang memiliki celah keamanan (*vulnerability*).

### Pilar 2: Performa & Kecepatan (Performance Engineering)
- **Pencegahan N+1 Query**: Dilarang menjalankan query database di dalam perulangan loop. Gunakan `include`/`select` relasi atau batched query.
- **Database Indexing**: Pasang indeks pada setiap kolom Foreign Key dan kolom filter pencarian (`WHERE status = ...`).
- **Zero Layout Shift & Optimasi Aset**: Gunakan Next.js `<Image>` untuk kompresi WebP otomatis dan skeleton loader untuk mencegah pergeseran tampilan saat memuat data.
- **Caching**: Terapkan in-memory caching (Redis) untuk data master yang jarang berubah.

### Pilar 3: Efisiensi Sumber Daya & Biaya (Resource & Cost Efficiency)
- **Database Connection Pooling**: PostgreSQL memiliki batas koneksi terbatas. Selalu gunakan connection pooling (Prisma Accelerate, Supabase Pooler, atau PgBouncer) agar serverless functions tidak menenggelamkan database (*connection exhaustion*).
- **Streaming Files**: File PDF atau dokumen besar diproses menggunakan **Node.js Stream** (bukan `fs.readFileSync` ke dalam RAM) agar konsumsi memori server tetap rendah di bawah 256 MB.
- **Minimal Docker Footprint**: Jika menggunakan Docker, gunakan teknik *multi-stage build* berbasis Alpine Linux agar ukuran image kontainer kecil (< 150 MB) dan hemat biaya hosting.

### Pilar 4: Observabilitas & Ketahanan (Observability & Reliability)
- **Structured JSON Logging**: Log menggunakan format JSON (Pino) dengan trace ID, actor ID, dan error stack untuk kemudahan filter log di cloud.
- **Healthcheck & Graceful Shutdown**: Sediakan rute `GET /api/health` dan tangani sinyal `SIGTERM` untuk menutup koneksi database secara tertib.

### Pilar 5: Kemudahan Perawatan & Kebersihan Tipe (Maintainability & Type Hygiene)
- **Single Source of Truth Tipe Data**: Seluruh tipe TypeScript diturunkan dari Zod (`z.infer<typeof Schema>`), dilarang duplikasi manual.
- **Haram Barrel Files (`index.ts`)**: Impor langsung dari file spesifik untuk mencegah circular dependencies dan mempercepat tree-shaking.
- **Early Returns (Guard Clauses)**: Tangani error di baris awal fungsi, hindari struktur if-else bersarang.
- **Clean Code & Design Patterns**: Terapkan prinsip SOLID dan pola arsitektur sesuai `references/playbooks/software-design-patterns.md`.

### Pilar 6: Ketahanan Data & Pemulihan (Data Durability & Disaster Recovery)
- **Soft-Delete Mutlak**: Dokumen transaksi legal DILARANG dihapus permanen (`DELETE FROM`). Gunakan kolom `deleted_at`.
- **Integritas Transaksi Atomik**: Mutasi multi-tabel wajib dibungkus dalam blok `db.$transaction` untuk mencegah korupsi data sebagian.

---

## 5. Langkah demi Langkah Eksekusi

### Langkah 1: Persiapan Repositori & Tooling

**Input**: Kebutuhan dari `FSD.md` dan `PRD.md`.

**Aktivitas**:

1. **Buat repositori Git lokal** (jika belum ada):

   ```bash
   git init
   git branch -M main
   ```

2. **Scaffold framework bahasa pilihan**:

   **PENTING: Protokol Anti-Konflik Framework-Agnostic**

   Banyak CLI framework modern **menolak eksekusi jika direktori target tidak kosong**. Karena Modul 01-05 sudah menghasilkan folder `docs/pm/` dan `docs/specs/`, strategi scaffold berbeda per framework:

   | Framework | Empty Dir? | AGENTS.md Conflict? | Scaffold Protocol |
   |-----------|------------|---------------------|-------------------|
   | **Next.js 15+** | Yes (strict) | **YES** (auto-gen 9 lines) | Temp folder → copy → **WAJIB overwrite AGENTS.md** (see warning above) |
   | **Laravel** | No (tolerates files) | No | Direct scaffold: `composer create-project laravel/laravel .` |
   | **Django/FastAPI** | No | No | Direct init: `poetry init` / `django-admin startproject . .` |
   | **Flutter** | Yes (strict) | No | Temp folder → copy (no AGENTS.md conflict) |

   **Next.js Protocol** (ONLY if using Next.js):
   ```bash
   # Scaffold di folder KOSONG baru
   mkdir ../temp_scaffold
   cd ../temp_scaffold
   pnpm create next-app@latest . --typescript --tailwind --app --no-src-dir=false --import-alias "@/*"
   
   # Copy framework files ke project folder
   cd ../project_folder
   cp -r ../temp_scaffold/* .
   cp -r ../temp_scaffold/.* . 2>/dev/null || true
   
   # Cleanup temp
   rm -rf ../temp_scaffold
   
   # CRITICAL: Overwrite Next.js AGENTS.md boilerplate (3rd reminder)
   # Get template from ROOT_HARNESS_BUNDLE (portable path)
    cp templates/04-dev-execution/root-harness/AGENTS_TEMPLATE.md AGENTS.md
   ```

   **Laravel Protocol**:
   ```bash
   # Direct scaffold (no conflict)
   composer create-project laravel/laravel .
   
   # Copy 7 harness files from ROOT_HARNESS_BUNDLE (portable)
    cp templates/04-dev-execution/root-harness/AGENTS_TEMPLATE.md AGENTS.md
    cp templates/04-dev-execution/root-harness/CONTEXT_TEMPLATE.md CONTEXT.md
    cp templates/04-dev-execution/root-harness/ARCHITECTURE_TEMPLATE.md ARCHITECTURE.md
    cp templates/04-dev-execution/root-harness/CONVENTIONS_TEMPLATE.md CONVENTIONS.md
    cp templates/04-dev-execution/root-harness/TODO_TEMPLATE.md TODO.md
    cp templates/04-dev-execution/root-harness/DESIGN_MD_TEMPLATE.md DESIGN.md
    cp templates/04-dev-execution/root-harness/ENV_EXAMPLE_TEMPLATE.md .env.example
   ```

   **Django/FastAPI Protocol**:
   ```bash
   # Direct init
   poetry init  # or: django-admin startproject myproject .
   
   # Copy 7 harness files from ROOT_HARNESS_BUNDLE (portable)
    cp templates/04-dev-execution/root-harness/AGENTS_TEMPLATE.md AGENTS.md
    cp templates/04-dev-execution/root-harness/CONTEXT_TEMPLATE.md CONTEXT.md
    cp templates/04-dev-execution/root-harness/ARCHITECTURE_TEMPLATE.md ARCHITECTURE.md
    cp templates/04-dev-execution/root-harness/CONVENTIONS_TEMPLATE.md CONVENTIONS.md
    cp templates/04-dev-execution/root-harness/TODO_TEMPLATE.md TODO.md
    cp templates/04-dev-execution/root-harness/DESIGN_MD_TEMPLATE.md DESIGN.md
    cp templates/04-dev-execution/root-harness/ENV_EXAMPLE_TEMPLATE.md .env.example
   ```

   **Flutter Protocol**:
   ```bash
   # Scaffold di folder KOSONG
   mkdir ../temp_scaffold
   cd ../temp_scaffold
   flutter create --org com.klien --project-name legal_vault .
   
   # Copy ke project folder
   cd ../project_folder
   cp -r ../temp_scaffold/* .
   
   # Cleanup + copy harness from ROOT_HARNESS_BUNDLE (portable, no AGENTS.md conflict)
   rm -rf ../temp_scaffold
    cp templates/04-dev-execution/root-harness/AGENTS_TEMPLATE.md AGENTS.md
    cp templates/04-dev-execution/root-harness/CONTEXT_TEMPLATE.md CONTEXT.md
    cp templates/04-dev-execution/root-harness/ARCHITECTURE_TEMPLATE.md ARCHITECTURE.md
    cp templates/04-dev-execution/root-harness/CONVENTIONS_TEMPLATE.md CONVENTIONS.md
    cp templates/04-dev-execution/root-harness/TODO_TEMPLATE.md TODO.md
    cp templates/04-dev-execution/root-harness/DESIGN_MD_TEMPLATE.md DESIGN.md
    cp templates/04-dev-execution/root-harness/ENV_EXAMPLE_TEMPLATE.md .env.example
   # ... (copy 6 other files)
   ```

3. **Verifikasi 7 Root Harness Files terpasang**:

   ```bash
   # Fixed verification: .env.example has no .md extension
   ls -1 | grep -E '^(AGENTS|CONTEXT|ARCHITECTURE|DESIGN|CONVENTIONS|TODO)\.md$' && ls -1 .env.example
   ```

   Expected output: 6 .md files + .env.example (7 total).

4. **Buat branch staging**: `git checkout -b staging`

5. **Commit awal** untuk mengunci harness dan scaffolding:
   ```bash
   git add .
   git commit -m "chore: initial project scaffolding with 7 AI harness files"
   ```

### Langkah 2: Implementasi Komponen UI (Stitch atau Manual Scaffold)

**Opsi A: Import dari Google Stitch (Jika Screen ID Tersedia)**
1. Baca Screen ID dari `DESIGN_SYSTEM.md` (Bagian II: Inventaris Layar).
2. Instruksikan OpenCode (jika Stitch MCP tersedia):
   > *"Gunakan tool `stitch_get_screen` untuk Screen ID yang terdaftar. Ekstrak kode HTML/Tailwind menjadi komponen React di `src/components/ui/` dan pasang halamannya di `src/app/`."*
3. Jalankan `pnpm dev` untuk verifikasi UI identik dengan desain.

**Opsi B: Scaffold Manual (Tanpa Stitch)**
1. Baca deskripsi layar dari `DESIGN_SYSTEM.md` (sitemap + token warna/tipografi).
2. Buat komponen UI shell kosong dengan struktur folder yang benar:
   ```bash
   mkdir -p src/components/ui src/app/{dashboard,documents,login}
   ```
3. Instruksikan AI untuk generate komponen berdasarkan DESIGN_SYSTEM.md tanpa Stitch:
   > *"Baca `DESIGN_SYSTEM.md`. Buat komponen React/Vue/Flutter sesuai palet Zinc, font Inter, border flat 1px. Scaffold halaman login, dashboard, document list."*

### Langkah 3: Eksekusi Migrasi Basis Data & Seeding
1. **Verifikasi Staging ENV**: Before migrations, verify `.env` (staging):
   ```bash
   # Check no production keys leaked to staging
   grep -E '(DATABASE_URL|STRIPE_SECRET_KEY|AWS_SECRET)' .env
   # Confirm staging endpoints (e.g., Stripe test mode key prefix sk_test_)
   ```
2. Instruksikan agen AI (OpenCode):
   > *"Baca ARCHITECTURE.md bagian Database Models. Buat skema Prisma/Drizzle lengkap dengan konstrain CHECK, relasi foreign key, dan indeks performa. Jalankan migrasinya."*
3. Jalankan migrasi: `pnpm db:migrate`
4. Jalankan seeding data awal: `pnpm db:seed`

### Langkah 4: Koding Backend API, Layanan Vault, & Wiring UI
1. Instruksikan agen AI mengeksekusi item pada `TODO.md` satu per satu:
   - Terapkan validasi Zod pada handler API.
   - Buat layanan enkripsi stream AES-256-GCM ke S3/R2 dan presigned URL 15 menit.
   - Sambungkan form UI Stitch ke endpoint API via `fetch` atau Server Actions.
   - Pastikan kelima kondisi layar berfungsi: *Skeleton Loader*, *Empty State*, *Inline Error Message*, dan *Toast Notifikasi*.
   - Terapkan pola prompt engineering & multi-file orchestration dari `references/playbooks/ai-assisted-development.md`.

### Langkah 5: Uji Asersi Mandiri (Smoke Test Lokal)
Jalankan skrip uji cepat:
```bash
pnpm run test:smoke
```
Pastikan kompilasi bersih (`pnpm run type-check`) dan audit dependensi aman (`pnpm audit`).

---

## 5A. Backend Development TODO Checklist (Detailed Breakdown)

**Detailed checklist**: Lihat [`appendices/06-development/backend-checklist.md`](../appendices/06-development/backend-checklist.md)

Checklist komprehensif mencakup:
1. **Database Setup & Migrations**: Connection pooling, schema definition, indexing strategy, soft-delete, seeders
2. **API Endpoints Development**: Authentication endpoints, CRUD, search/filtering, pagination
3. **Middleware Implementation**: Auth middleware, RBAC, validation, rate limiting, security headers
4. **Background Jobs & Queues**: Worker setup, async tasks, retry policies, DLQ
5. **File Upload & Storage**: Presigned URLs, validation, encryption at-rest
6. **Email & Notifications**: Transactional email, templates, in-app notifications, webhook handlers

**Quick reference** untuk AI coding agents:
```
> "Load backend checklist: appendices/06-development/backend-checklist.md"
> "Verify database migrations reversible and seeders functional"
> "Audit API endpoints for tenant isolation and IDOR prevention"
```

---

## 5B. Frontend Development TODO Checklist (Detailed Breakdown)

**Detailed checklist**: Lihat [`appendices/06-development/frontend-checklist.md`](../appendices/06-development/frontend-checklist.md)

Checklist komprehensif mencakup:
1. **Component Library & Design System**: Token sync, UI atoms (Button, Input), molecules (Toast, Modal), navigation, WCAG AA compliance
2. **Pages & Routing**: Layout hierarchy, auth pages, dashboard pages, error boundaries
3. **State Management**: Server-state (TanStack Query/SWR), client UI state (Zustand), URL sync
4. **Form Handling & Validation**: React Hook Form + Zod, inline validation, double-submit protection
5. **API Integration**: HTTP client abstraction, file upload progress, optimistic updates
6. **The 5 UI States**: Idle, Loading (skeleton), Success (toast), Error (retry), Empty (CTA)

**Quick reference** untuk AI coding agents:
```
> "Load frontend checklist: appendices/06-development/frontend-checklist.md"
> "Verify WCAG AA contrast ratios and keyboard navigation"
> "Audit forms for Zod validation and optimistic UI rollback"
```

---

## 5C. Integration TODO Checklist (Third-Party & Infrastructure)

**Detailed checklist**: Lihat [`appendices/06-development/integration-checklist.md`](../appendices/06-development/integration-checklist.md)

Checklist komprehensif mencakup:
1. **Payment Gateway (Stripe/Midtrans)**: Sandbox setup, transaction initiation, webhook cryptographic validation, idempotency, atomic status transitions
2. **Transactional Email (SendGrid/Resend)**: DNS verification (SPF/DKIM/DMARC), email client isolation, automated receipts
3. **File Storage (S3/R2)**: Bucket CORS config, least-privilege IAM, lifecycle policies
4. **Product Analytics (Mixpanel/GA4/PostHog)**: Privacy-compliant init, core telemetry mapping, PII scrubbing
5. **Application Monitoring (Sentry)**: SDK installation, sensitive data scrubbing, performance tracing, health checks

**Quick reference** untuk AI coding agents:
```
> "Load integration checklist: appendices/06-development/integration-checklist.md"
> "Verify webhook signature validation and idempotency handling"
> "Audit Sentry beforeSend filter for credential leaks"
```

---

## 5D. Code Review Milestone Checkpoints (Solo Developer & AI Code Gates)

Dalam pengembangan mandiri (solo developer) dengan akselerasi AI Coding Agents, *code review* dilakukan secara berlapis pada 4 pos pemeriksaan kunci (*milestone gates*) sebelum branch di-merge ke `staging` atau dinaikkan ke pengujian Modul 07:

```text
[Feat Branches] ──► [Checkpoint 1: Foundation Gate] ──► staging
                                  │
[Auth & Core]   ──► [Checkpoint 2: Alpha Release Gate] ──► Termin 2 (25-30%)
                                  │
[Integrations]  ──► [Checkpoint 3: Third-Party & Security] ──► staging
                                  │
[Full Hardening]──► [Checkpoint 4: Beta & Staging Freeze] ──► Termin 3 (20-25%) ──► Modul 07 (QA & SIT)
```

### Checkpoint 1: Scaffolding & Foundation Gate
- **Pemicu**: Scaffolding selesai, 7 AI harness files terpasang, skema database awal terbentuk.
- **Target Branch**: `feat/scaffold` ──► `staging`
- **Daftar Periksa Wajib**:
  - [ ] Seluruh 7 berkas harness AI berada di root proyek dan disesuaikan dengan FSD.md.
  - [ ] TypeScript strict mode aktif (`tsc --noEmit` exit 0 tanpa pesan error).
  - [ ] Tidak ada tipe `any` yang terdeteksi di seluruh berkas kode baru.
  - [ ] Skema database dan migrasi pertama berhasil dieksekusi di database lokal.
  - [ ] File `.env.example` mencantumkan seluruh variabel environment yang digunakan dalam kode tanpa membocorkan nilai rahasia asli.
- **Protokol Review AI**:
  > *"Jalankan audit pada branch `feat/scaffold`. Pastikan arsitektur folder konsisten, tidak ada circular dependencies, dan skema database memiliki konstrain integritas data yang kokoh."*

### Checkpoint 2: Core Data & Domain Gate (Termin 2 Alpha Release Gate)
- **Pemicu**: Modul autentikasi selesai, API CRUD entitas inti berfungsi, dan UI form awal tersambung.
- **Target Milestone**: Termin 2 Alpha Release (25% s/d 30% Pembayaran Proyek).
- **Daftar Periksa Wajib**:
  - [ ] Autentikasi end-to-end berfungsi dengan penyimpanan JWT/sesi di HttpOnly cookie (`SameSite=Lax`, `Secure`).
  - [ ] Validasi skema Zod aktif pada setiap handler API dan form UI.
  - [ ] Isolasi tenant diverifikasi: Pengguna dari Tenant A tidak dapat mengakses entitas milik Tenant B via IDOR.
  - [ ] Enkripsi AES-256-GCM aktif melindungi dokumen/data sensitif.
  - [ ] Smoke test lokal tahap 1 lulus 100%.
- **Keputusan Gate**:
  - **LULUS**: Terbitkan Invoice Termin 2 ke Klien beserta video demo / laporan verifikasi lokal.
  - **GAGAL**: Perbaiki celah keamanan atau bug logika sebelum menagih termin.

### Checkpoint 3: Third-Party & Infrastructure Integration Gate
- **Pemicu**: Integrasi payment gateway, transactional email, cloud storage, analitik, dan monitoring selesai.
- **Target Branch**: `feat/integrations` ──► `staging`
- **Daftar Periksa Wajib**:
  - [ ] Webhook payment gateway memvalidasi tanda tangan kriptografis dan menerapkan penanganan idempotensi mutlak.
  - [ ] Upload file langsung ke cloud storage via presigned URL teruji, dengan validasi MIME-type berbasis magic bytes.
  - [ ] Email transaksional terkirim dengan template HTML bersih dan memiliki fallback text.
  - [ ] Rate limiting aktif melindungi endpoint login dan endpoint publik dari serangan brute-force.
  - [ ] Audit dependensi (`pnpm audit` / `composer audit`) bersih dari kerentanan kategori High atau Critical.
- **Protokol Review AI**:
  > *"Periksa seluruh implementasi webhook dan file upload. Pastikan penanganan replay attack aman, token signing tervalidasi, dan berkas tidak dapat dieksekusi secara sembarangan di server."*

### Checkpoint 4: Release Candidate & Staging Freeze Gate (Termin 3 Beta Release Gate)
- **Pemicu**: Seluruh fitur backend dan frontend tersambung, 5 UI states terpasang, siap masuk ke Modul 07 QA & SIT.
- **Target Milestone**: Termin 3 Beta Release (20% s/d 25% Pembayaran Proyek).
- **Daftar Periksa Wajib**:
  - [ ] Defensive UI: Seluruh halaman dan komponen telah menerapkan 5 UI States (Idle, Loading skeleton, Success feedback, Error alert, Empty state).
  - [ ] Bebas N+1 query: Seluruh relasi data dalam daftar/tabel telah dioptimasi dengan query `include`/`with` dan foreign key terindeks.
  - [ ] Sentry / APM aktif menangkap unhandled errors dengan filter scrubbing data sensitif.
  - [ ] Smoke test lengkap (`test:smoke`) berhasil 100%.
  - [ ] Lembar `VERIFY_LOCAL.md` dan `DEVELOPMENT_PROGRESS_TRACKER.md` terisi lengkap dan ditandatangani.
  - [ ] Branch `staging` bersih, ter-freeze, dan diberi tag rilis (contoh: `git tag -a v0.9.0-beta -m "Beta release ready for QA"`).
- **Keputusan Gate**:
  - **LULUS**: Lanjut ke **Modul 07: Quality Assurance & SIT di Staging**. Terbitkan Invoice Termin 3 jika disepakati pada kontrak.
  - **GAGAL**: Tunda rilis, tuntaskan hutang teknis di `DEVELOPMENT_PROGRESS_TRACKER.md`.

---

## 6. Pencapaian Milestone Pembayaran (Termin Gates)

1. **Milestone Alpha (Termin 2 - 25% s/d 30%)**:
   - *Kriteria Lolos*: Basis data termigrasi, otentikasi login aktif, alur pembuatan draf dokumen berjalan lokal, dan pilar keamanan/performa dasar terverifikasi di branch `staging`.
   - *Tindakan*: Terbitkan Invoice Termin 2 ke Klien.
   - *Template*: Use accounting software (Wave/Invoicely) or simple format: Project name, Termin 2 (Alpha 25-30%), Amount, Due date, Payment method.
2. **Milestone Beta (Termin 3 - 20% s/d 25%)**:
   - *Kriteria Lolos*: Seluruh modul backend, frontend, vault terenkripsi terhubung lengkap serta siap diuji coba di server Staging.
   - *Tindakan*: Lanjut ke Modul 07 (QA & SIT) sebelum UAT klien.

---

## 7. Artefak Keluaran (Deliverables)

1. **Source Code Repositori Git**: Basis kode bersih dengan branch `staging` aktif dan riwayat commit terstruktur.
2. **`RUNBOOK_LOCAL.md`**: Panduan lengkap setup environment, migrasi DB, dan menjalankan aplikasi di lokal (menggunakan `templates/04-dev-execution/RUNBOOK_LOCAL_TEMPLATE.md`).
3. **`VERIFY_LOCAL.md`**: Lembar hasil verifikasi mandiri bahwa seluruh endpoint FSD, 3 pilar rekayasa, dan alur Stitch berfungsi 100% (menggunakan `templates/04-dev-execution/VERIFY_LOCAL_TEMPLATE.md`).
4. **`AI_REVIEW_LOG.md`**: Log protokol review kode AI pre-merge sesuai panduan `references/playbooks/ai-assisted-development.md`.
5. **`DEVELOPMENT_PROGRESS_TRACKER.md`**: Lembar pelacak kemajuan eksekusi koding, checklist backend, frontend, integrasi, dan pos pemeriksaan code review (menggunakan `templates/04-dev-execution/DEVELOPMENT_PROGRESS_TRACKER.md`).

---

## 8. Kriteria Kelulusan [GATE] (Gate Exit Criteria)

[GATE] Modul 06 dinyatakan **LOLOS (PASS)** jika:
- [x] Percabangan Git terstruktur (`main`, `staging`, `feat/*`) dengan commit rapi.
- [x] 7 berkas kendali AI (Agent Harness) terpasang di root proyek.
- [x] Komponen Google Stitch telah diekstrak via MCP dan terhubung ke backend API.
- [x] Kode sumber berhasil di-build tanpa error kompilasi TypeScript (`tsc --noEmit` exit 0).
- [x] Migrasi basis data berjalan mulus dengan indeks pencarian terpasang.
- [x] Enkripsi file vault AES-256-GCM berbasis stream berhasil menyimpan dan membaca dokumen via presigned URL.
- [x] Skrip uji mandiri (`smoke-test`) lulus 100% dan audit dependensi (`pnpm audit`) bebas celah kritis.

---

## 🛑 PROTOKOL [GATE] KELUAR & WAJIB BERHENTI

Setelah koding selesai dan skrip `smoke-test` lulus 100%:
1. **DILARANG KERAS langsung melanjutkan atau memanggil tool untuk Modul 07 dalam giliran (turn) yang sama!**
2. **VERIFIKASI DIRI (Self-Verification Checklist)**:
   - [ ] `terminal('pnpm run type-check')` → Exit code 0 (no TypeScript errors)
   - [ ] `terminal('pnpm run test:smoke')` → All assertions passed
   - [ ] `terminal('pnpm audit')` → No critical vulnerabilities
   - [ ] `read_file('VERIFY_LOCAL.md')` → Documented test results exist
   - [ ] `terminal('git log -1')` → Latest commit exists on staging branch
3. Tampilkan ringkasan hasil development lokal kepada pengguna:
   - Hasil uji kompilasi dan smoke test lokal
   - Bukti fungsionalitas di `VERIFY_LOCAL.md`
   - Kesiapan pengujian integrasi Staging (Termin 2 Alpha Release)
4. **AKHIRI RESPON ANDA (END TURN)** dan ajukan konfirmasi kepada pengguna:
   > *"Seluruh fitur inti telah selesai dikoding dan diverifikasi lokal (Smoke Test PASS). Apakah hasil development ini disetujui sebelum kita membuka Modul 07 (Quality Assurance & SIT di Staging)?"*
5. Tunggu respon persetujuan eksplisit dari pengguna sebelum melangkah ke Modul 07.
