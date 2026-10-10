# Module 05: Architecture & Technical Specifications (PRD & FSD)

> - `references/solo/SOLO_ARCHITECTURE_GUIDE.md` (Boring Tech guide, SQL DDL integrity, OWASP Top 10, AES-256 encryption, UU PDP compliance)
> - `references/technical/DATA_ASSETS_MANAGEMENT.md` (Regulations data (tax rates, PTKP), Business rules/formulas, Reference data (city/bank list), Seed data, Localization)
> - `references/playbooks/software-design-patterns.md` (Clean code principles, SOLID, Repository/Service Layer patterns for FSD authoring)
> - `references/stacks/STACK_SUPPORT_MATRIX.md` (Supported tech stack evaluation matrix, maturity, solo dev suitability)
> - `templates/03-architecture-specs/CAPACITY_PLANNING_TEMPLATE.md` (MAU/RPS traffic projection, memory/storage sizing)
> - `templates/03-architecture-specs/DESIGN_PATTERN_DECISION_TREE_TEMPLATE.md` (Software architecture & design pattern decision tree)
> - `templates/03-architecture-specs/CODE_REVIEW_PATTERN_CHECKLIST_TEMPLATE.md` (Pre-commit architecture pattern review checklist)
>

This module is the fifth phase in the software project lifecycle for solo developers. Its purpose is to architect the entire "engine, data cabling, database, and security systems" behind the interface frozen in Module 04, producing two primary blueprints: **`PRD.md`** (*Product Requirement Document*) and **`FSD.md`** (*Functional Specification Document*).

---

## 1. Module 05 Execution Cycle

```text
[ INPUT: SCOPE_STATEMENT.md from Module 02 & DESIGN_SPEC.md from Module 04 ]
  • In Fast-Track Small Scale, input is unified PROJECT_LITE.md (replaces separate PRD/FSD generation).
  • Architecture decisions, stack locking, DDL, and API lists are pinned directly into Section 5 of PROJECT_LITE.md.
                                    │
                                    ▼
[ STEP 0: Tech Stack Discovery Questionnaire (NEW - MANDATORY) ]
  • 8 context discovery questions (team expertise, budget, scale, etc.)
  • Generate 2-3 stack options with cost/pros/cons comparison
  • User selects preferred stack (LOCK DECISION before FSD)
                                    │
                                    ▼
[ STEP 1: Generate Tech Stack Justification (Based on User Choice) ]
  • Context-specific reasoning for chosen stack
  • Tradeoffs analysis (alternatives rejected with reasons)
  • Deployment topology aligned with budget & scale
                                    │
                                    ▼
[ STEP 2: Database Schema Design (Database Schema & DDL) ]
  • Table Design, Primary/Foreign Keys, CHECK Constraints, and Indexes
  • Audit Trail Strategy (created_at, updated_at, actor_id, soft-delete)
  • Syntax adapted to chosen DB (PostgreSQL vs MySQL vs MongoDB)
                                    │
                                    ▼
[ STEP 3: API Contract Mapping & Endpoint Matrix ]
  • HTTP Verbs, Path, Authentication & Idempotency Headers
  • JSON Request & Response Payload Schema (Success vs Error Matrix)
  • API style adapted to stack (REST vs GraphQL vs tRPC)
                                    │
                                    ▼
[ STEP 4: Security Foundations & Regulatory Compliance (Security Blueprint) ]
  • Data Vault Encryption (AES-256-GCM / Envelope Encryption)
  • Session Management (HttpOnly Cookies, JWT Rotation) & Argon2id Hashing
  • OWASP Top 10 Protection, Rate Limiting, & UU PDP Compliance
  • Framework-specific security patterns
                                    │
                                    ▼
[ STEP 5: Module 04 Prototype → Module 06 Handoff Strategy ]
  • Define conversion strategy (Prototype → chosen framework)
  • Document component mapping (React → Vue/Svelte/Blade)
  • Extract design tokens for reuse in chosen stack
                                    │
                                    ▼
[ STEP 6: Finalization & Signing of PRD & FSD ]
  • Technical Review with Client Single PIC
  • Sign Technical Sign-Off
                                    │
                                    ▼
[ OUTPUT: PRD.md & FSD.md Documents ] ──► Ready to Enter Module 06: Development
```

---

## 2. Tech Stack Discovery Questionnaire (STEP 0 - MANDATORY)

**MANDATORY BEFORE generating FSD.** There is no "default stack" — all decisions are context-driven.

### Pre-Questionnaire: Version Check (NEW)

**Before asking tech stack questions, run real-time version check directly against official registry APIs**:

```bash
# Check current ecosystem state for target framework via official registry APIs:
./scripts/verify/check-package-versions.sh <nextjs|laravel|django|go|rails|mern|aspnet|spring|serverless|flutter|remix|astro|sveltekit|nuxt>
# OR
.\scripts\verify\check-package-versions.ps1 -Framework <nextjs|laravel|django|go|rails|mern|aspnet|spring|serverless|flutter|remix|astro|sveltekit|nuxt>
```

**Universal Registry Sources (Zero Local Toolchain Dependency)**:
| Ecosystem / Stack | Official Registry Source | Query Method | Verified Upstream Targets |
| :--- | :--- | :--- | :--- |
| **Next.js / Node** | npm Registry | `npm view <pkg> version` | `next`, `react`, `tailwindcss`, `zod`, `@supabase/ssr` |
| **Laravel / PHP** | Packagist API | `repo.packagist.org/p2/laravel/framework.json` | `laravel/framework`, `breeze`, `sanctum`, PHP req |
| **Django / Python** | PyPI JSON API | `pypi.org/pypi/django/json` | `django`, `djangorestframework`, `psycopg`, Python req |
| **Go / Golang** | Go Official API & Proxy | `go.dev/dl/?mode=json` & `proxy.golang.org` | Stable Go runtime, `gin`, `gorm`, `pgx` |
| **Ruby on Rails** | RubyGems API | `rubygems.org/api/v1/gems/rails.json` | `rails`, `puma`, `pg`, Ruby req |
| **SvelteKit** | npm Registry | `npm view @sveltejs/kit version` | `@sveltejs/kit`, `svelte` |
| **Nuxt** | npm Registry | `npm view nuxt version` | `nuxt`, `vue` |
| **Flutter / Dart** | Pub.dev API | `pub.dev/api/packages/flutter_lints` | `flutter_lints`, `http`, `provider` |

**Why**: AI models suffer from knowledge cutoff lag (e.g., assuming Next.js 14 when Next.js 15/16 is current, or assuming Laravel 10 when Laravel 11/13 is current). Real-time registry queries ensure architectural recommendations use actual current stable releases without requiring developers to pre-install local compilers (Composer, PHP, Python, Go) before scaffolding.

**Output provides**:
- Current stable versions directly from upstream registries.
- Deprecation warnings (e.g., `@supabase/auth-helpers-nextjs` $\rightarrow$ `@supabase/ssr`).
- Compatibility analysis & breaking change warnings (e.g., Zod v4 vs react-hook-form, Tailwind v4 PostCSS breaking changes).
- Recommended scaffold commands and exact pinned version definitions.

#### Agent Validation Rules (Step 0 Exit Gate)

Before completing Step 0 and recommending tech stacks in Module 05:
1. [ ] **Zero Unverified Web Search Reliance**: Dependency versions MUST be verified via live registry queries (`check-package-versions.sh` / `.ps1` or direct registry endpoints), NEVER guessed or hallucinated from outdated training data.
2. [ ] **Breaking Changes & Pinning Strategy**:
   - When detecting a bleeding-edge major version with ecosystem incompatibilities (e.g., Tailwind v4 breaking config changes, Zod v4 incompatible with resolvers), the agent **MUST** document an explicit pinning recommendation to the proven stable version (e.g., Tailwind v3.4, Zod v3.23.8).
3. [ ] **Direct Synchronization to `FSD.md`**:
   - All detected and agreed versions MUST be transcribed verbatim into the `Framework Versions (Pinned):` section of `docs/specs/FSD.md`.
   - This guarantees that the Module 06 automated gate (`verify-framework-version.sh`) will succeed without version mismatches.

---

The agent must ask the user these 8 questions and wait for answers before recommending stack options:

### Question 1: Team Expertise
**"What tech stack is the team/you already familiar with and productive in?"**

Options:
- [ ] JavaScript/TypeScript (React, Node.js, Next.js)
- [ ] PHP (Laravel, Symfony, CodeIgniter)
- [ ] Python (Django, Flask, FastAPI)
- [ ] Ruby (Rails, Sinatra)
- [ ] Go (Gin, Fiber, Echo)
- [ ] Java (Spring Boot)
- [ ] .NET (ASP.NET Core)
- [ ] Other: ___________

**Why this matters**: 2-month learning curve vs 2 weeks. Leveraging existing expertise = faster delivery.

---

### Question 2: Database Experience
**"Which database has the team used and feels comfortable maintaining?"**

Options:
- [ ] PostgreSQL
- [ ] MySQL / MariaDB
- [ ] MongoDB
- [ ] SQLite
- [ ] Firebase / Supabase
- [ ] None (first project - prefer managed service)

**Why this matters**: Wrong DB choice = schema migration nightmare in production.

---

### Question 3: Deployment Budget (Monthly)
**"What is the available monthly hosting budget?"**

Options:
- [ ] $0 (free tier only - MVP/personal project)
- [ ] $5-25 (small VPS - early startup)
- [ ] $25-100 (managed PaaS - growing product)
- [ ] $100-500 (enterprise managed - scale)
- [ ] $500+ (enterprise cloud - compliance)

**Why this matters**: 
- $0: Vercel Hobby + Supabase free (cold starts, bandwidth limits)
- $50: DigitalOcean Droplet (full control, no cold starts)
- $200: Vercel Pro + managed DB (auto-scale, zero-config)

---

### Question 4: Expected Scale (Year 1 Target)
**"What is the target concurrent user count within the first 12 months?"**

Options:
- [ ] <100 (MVP, internal tool, niche B2B)
- [ ] 100-1,000 (small B2B SaaS, local business)
- [ ] 1,000-10,000 (growing SaaS, regional app)
- [ ] 10,000-100,000 (high-growth startup)
- [ ] >100,000 (viral app, nationwide scale)

**Why this matters**:
- <100 users: Monolith is sufficient (PostgreSQL single instance)
- 10K users: Needs caching (Redis), read replicas
- 100K users: Microservices, load balancer, CDN mandatory

---

### Question 5: Data Model Characteristics
**"What are the data model characteristics of this application?"**

Options:
- [ ] Fixed schema (relational, predictable fields - e.g., invoice, user profile)
- [ ] Flexible schema (JSON-heavy, dynamic fields - e.g., CMS, form builder)
- [ ] Mixed (some fixed tables + some flexible JSON fields)
- [ ] Time-series (logs, metrics, events - append-only)
- [ ] Graph (social network, recommendation engine)

**Why this matters**:
- Fixed schema → PostgreSQL (strong typing, foreign keys)
- Flexible schema → MongoDB (schemaless, easy iteration)
- Time-series → TimescaleDB / InfluxDB
- Graph → Neo4j

---

### Question 6: DevOps Complexity Tolerance
**"How comfortable are you handling deployment complexity?"**

Options:
- [ ] Zero-config (git push auto-deploy, no terminal commands)
- [ ] Low-config (Docker Compose, basic CI/CD)
- [ ] Medium (Kubernetes, Terraform basics)
- [ ] High (full control, custom infra, multi-region)

**Why this matters**:
- Zero-config: Vercel, Railway (easy but vendor lock-in)
- Low-config: DigitalOcean App Platform (Docker deploy via UI)
- Medium: AWS ECS, GCP Cloud Run (container orchestration)
- High: Kubernetes self-managed (full control, high maintenance)

---

### Question 7: Critical Feature Priority
**"What is the most critical feature for this application?"**

Options:
- [ ] SEO (public content, need server-side rendering)
- [ ] Real-time (chat, live updates, WebSockets)
- [ ] Complex queries (analytics, reports, data aggregation)
- [ ] File processing (uploads, image resizing, video encoding)
- [ ] API-first (mobile app, third-party integrations)
- [ ] Admin dashboard (internal tool, CRUD operations)

**Why this matters**:
- SEO priority → Next.js (SSR), Nuxt.js, SvelteKit
- Real-time → Go/Node.js (WebSocket support), Elixir Phoenix
- Complex queries → PostgreSQL (window functions, CTEs), avoid NoSQL
- File processing → Background jobs (Celery, Bull), object storage (S3)

---

### Question 8: Compliance Requirements
**"What regulatory compliance must be satisfied?"**

Options:
- [ ] None (personal project, MVP)
- [ ] UU PDP (Indonesia - user consent, data deletion right)
- [ ] GDPR (EU - strict data protection)
- [ ] Sektor kesehatan (Kemenkes SatuSehat, UU PDP - enkripsi rekam medis, audit log kekal)
- [ ] SOC2 / ISO27001 (Enterprise B2B - security audit)
- [ ] PCI-DSS (Payment processing - credit card data)

**Why this matters**:
- HIPAA/PCI-DSS: Managed cloud with compliance certifications (AWS, Azure)
- ISO27001: Need audit logs (database triggers, Sentry logging)
- None: Simpler stack choices, faster iteration

---


> 📚 **EXTENDED STACK COMPARISONS & SYSTEM DESIGN DEEP DIVE**:
> For the universal stack evaluation rubrics, Astro/Remix/Laravel detailed comparisons, M04 prototype conversion patterns, and M05B enterprise infrastructure blueprints, consult:
> - [`references/technical/ARCHITECTURE_SPECS_DEEP_DIVE.md`](../../references/technical/ARCHITECTURE_SPECS_DEEP_DIVE.md)

---

## 5. Output Artifacts (Deliverables)

> 📁 **MANDATORY FILE LOCATION RULES**:
> All Module 05 specification documents MUST be stored inside the folder **`docs/specs/`** (not in the root directory).
> Placing `PRD.md` or `FSD.md` in the project root is STRICTLY FORBIDDEN.

This module produces 2 primary technical documents:
1. **`docs/specs/PRD.md`**: Functional and non-functional product requirement document (using `templates/03-architecture-specs/PRD_FINAL_TEMPLATE.md`).
2. **`docs/specs/FSD.md`**: Functional technical specification document, database DDL schema, API contracts, and security architecture (using `templates/03-architecture-specs/FSD_TECHNICAL_TEMPLATE.md`).

> 💡 *Reference for architectural patterns & clean code FSD*: `references/playbooks/software-design-patterns.md`.

---

## 6. Gate Exit Criteria [GATE]

[GATE] Module 05 is declared **PASSED** if:

### Phase 0: Tech Stack Discovery (BLOCKING)
- [ ] **8-question questionnaire completed** (user answered all questions)
- [ ] **2-3 stack options generated** with cost/pros/cons comparison
- [ ] **User selected preferred stack** (LOCKED decision, cannot change without +2 weeks timeline impact)
- [ ] **Stack selection documented** in FSD.md header section

### Phase 1-4: FSD Content (BLOCKING)
- [ ] **Tech stack justification documented** (context-specific reasoning, alternatives rejected with reasons)
- [ ] **Database schema written** in SQL DDL syntax matching chosen DB (PostgreSQL/MySQL/MongoDB)
- [ ] **API endpoints documented** (minimum 10 endpoints with request/response examples)
- [ ] **Security blueprint complete** (encryption, hashing, rate limiting, framework-specific patterns)
- [ ] **Module 04 handoff strategy documented** (conversion plan from design specs → chosen stack)

### Phase 5: File Verification (BLOCKING)
- [ ] **`docs/specs/PRD.md` exists** (proportionate to scale: 3–5 pages for Small MVP, 10–20 pages for Medium; contains traceability matrix, domain logic defense or reasoned N/A, and BDD criteria)
- [ ] **`docs/specs/FSD.md` exists** (proportionate to scale; contains verified DDL schema, security & access controls appropriate to architecture, atomic transactions for high-risk mutations or reasoned N/A, and API contracts)

### Phase 6: User Approval (BLOCKING)
- [ ] **Technical Sign-Off obtained** from Client Single PIC or solo developer self-approval

---

## 🛑 PROTOCOL [GATE] EXIT & MANDATORY STOP

### STEP 0: Tech Stack Discovery (MANDATORY FIRST)

**Agent MUST execute questionnaire BEFORE generating FSD**:

```powershell
# GATE CHECK - Module 05 Phase 0
# Verify questionnaire answered before FSD generation

$questionnaireComplete = $false
$stackLocked = $false

# Agent must track user answers in memory or temp file
# Check if all 8 questions answered
if ($answeredQuestions -lt 8) {
    Write-Error "❌ PHASE 0 GATE FAILED: Only $answeredQuestions/8 questions answered."
    Write-Error "Complete questionnaire before generating stack options."
    exit 1
}

# Check if stack selected
if (-not $selectedStack) {
    Write-Error "❌ PHASE 0 GATE FAILED: User has not selected a stack from options."
    Write-Error "Present 2-3 options → user MUST select → then proceed to FSD."
    exit 1
}

Write-Host "✅ PHASE 0 PASSED: Questionnaire complete, Stack locked ($selectedStack)"
```

**Agent prompt after questionnaire**:
```
📋 Tech Stack Discovery Complete

User Answers Summary:
1. Team Expertise: JavaScript/TypeScript
2. Database: PostgreSQL
3. Budget: $0/month
4. Scale: <100 users
5. Data Model: Fixed schema
6. DevOps: Zero-config
7. Critical Feature: SEO
8. Compliance: UU PDP

Generating stack options...

[Agent generates 2-3 options here]

Please select stack (A/B/C) to proceed. Decision LOCKS tech stack for this project.

⚠️ WAITING FOR STACK SELECTION - Cannot generate FSD without locked stack decision.
```

**Agent MUST END TURN and wait for user input.**

---

### STEP 1-4: Generate FSD Content

After stack is locked, agent proceeds to generate FSD sections based on the chosen stack.

**Content must adapt to stack**:
- PostgreSQL chosen → SQL DDL syntax with FOREIGN KEY, CHECK constraints
- MongoDB chosen → Mongoose schema syntax, no foreign keys
- Laravel chosen → Eloquent migration syntax
- Django chosen → Django ORM models syntax

**Anti-Pattern** (AI SLOP):
- ❌ Always generate PostgreSQL schema without checking chosen DB
- ❌ Always recommend Next.js API routes without checking chosen backend
- ❌ Generic "best practices" not aligned with the framework

---

### STEP 5: File Existence Verification

```powershell
# GATE CHECK - Module 05 File Verification
$requiredFiles = @(
    @{Path="docs/specs/PRD.md"; MinSize=3000},
    @{Path="docs/specs/FSD.md"; MinSize=8000}
)

$allPassed = $true

foreach ($file in $requiredFiles) {
    if (-not (Test-Path $file.Path)) {
        Write-Error "❌ GATE FAILED: File $($file.Path) not found."
        $allPassed = $false
    } else {
        $size = (Get-Item $file.Path).Length
        if ($size -lt $file.MinSize) {
            Write-Error "❌ GATE FAILED: File $($file.Path) is too small ($size bytes < $($file.MinSize) minimum)."
            $allPassed = $false
        } else {
            Write-Host "✅ $($file.Path) verified ($size bytes)"
        }
    }
}

if (-not $allPassed) {
    Write-Error "`n🛑 MODULE 05 GATE FAILED: Missing or incomplete files."
    exit 1
}
```

---

### STEP 6: Content Validation

```python
# Pseudo-code for agent verification
def verify_fsd_content():
    fsd = read_file("docs/specs/FSD.md")
    
    # Check required sections
    required_sections = [
        "Tech Stack Justification",
        "Database Schema",
        "API Endpoints",
        "Security Specifications",
        "Module 04 Handoff Strategy"
    ]
    
    for section in required_sections:
        if section not in fsd:
            raise GateError(f"FSD.md missing section: {section}")
    
    # Verify tech stack locked
    if "Stack Decision LOCKED:" not in fsd:
        raise GateError("FSD.md missing locked stack decision documentation")
    
    # Verify API endpoint count
    endpoint_count = fsd.count("#### POST") + fsd.count("#### GET") + fsd.count("#### PUT") + fsd.count("#### DELETE")
    if endpoint_count < 10:
        raise GateError(f"FSD.md only contains {endpoint_count} endpoints (minimum 10)")
    
    # Verify database schema (SQL or NoSQL syntax)
    if ("CREATE TABLE" not in fsd) and ("mongoose.Schema" not in fsd) and ("models.Model" not in fsd):
        raise GateError("FSD.md missing database schema definition")
    
    # Verify Module 04 handoff strategy
    if "Prototype Conversion Strategy" not in fsd:
        raise GateError("FSD.md missing Module 04 handoff strategy")
    
    return True
```

---

### STEP 7: Display Summary & User Approval

**MANDATORY**: Execute `./scripts/gates/validate-gate.sh M05` (or `.ps1`). Paste the EXACT terminal output into your response.

Do NOT use pre-filled completion checklists with hardcoded `✅`. Output must be derived from the actual validator execution:

```
[PASTE RAW OUTPUT OF: ./scripts/gates/validate-gate.sh M05]
```

If the script exits with `❌ Gate validation FAILED`, you MUST NOT declare completion or stop the turn. Fix missing or undersized artifacts and re-run.

Only after `✅ Gate validation PASSED` (exit code 0), present the handoff prompt:

```
Module 05 Gate PASSED. All architectural specifications verified.

Next Steps:
1. Review FSD.md (verify tech decisions align with expectations)
2. If revisions needed: Request changes now (before Module 06 coding)
3. If approved: Confirm "FSD approved, start Module 06 development"

⚠️ CRITICAL: Stack cannot change after approval without +2 weeks timeline impact (database migration, API rewrite, component conversion).
```

---

### STEP 8: STOP & Wait for Approval

**STRICTLY FORBIDDEN** to proceed to Module 06 within the same turn.

The agent must:
1. **END TURN** after displaying summary
2. **WAIT** for explicit user approval: "FSD approved" or "Proceed to Module 06"
3. Only proceed after confirmation received

**If user requests changes**:
