# Modul 05: Arsitektur & Spesifikasi Teknis (PRD & FSD)

> ⚠️ **MANDATORY: Load references BEFORE executing this module**:
> - `references/solo/SOLO_ARCHITECTURE_GUIDE.md` (Boring Tech guide, SQL DDL integrity, OWASP Top 10, AES-256 encryption, UU PDP compliance)
> - `references/technical/DATA_ASSETS_MANAGEMENT.md` (Regulations data (tax rates, PTKP), Business rules/formulas, Reference data (city/bank list), Seed data, Localization)
> - `references/improvements/MODUL_05_IMPROVEMENTS.md` (Timeline estimation, PRD vs FSD content matrix, API error standardization, database migration strategy, NFR template)
> - `references/playbooks/software-design-patterns.md` (Clean code principles, SOLID, Repository/Service Layer patterns for FSD authoring)
>
> **MANDATORY: Load references BEFORE executing this module**:
> - Read: `references/improvements/MODUL_05_IMPROVEMENTS.md`

Modul ini adalah tahap kelima dalam siklus hidup proyek perangkat lunak untuk solo developer. Tujuannya adalah merancang seluruh "mesin, kabel data, basis data, dan sistem keamanan" di balik antarmuka yang telah dibekukan pada Modul 04, menghasilkan dua cetak biru utama: **`PRD.md`** (*Product Requirement Document*) dan **`FSD.md`** (*Functional Specification Document*).

---

## 1. Siklus Eksekusi Modul 05

```text
[ INPUT: SCOPE_STATEMENT.md dari Modul 02 & DESIGN_SYSTEM.md dari Modul 04 ]
                                    │
                                    ▼
[ LANGKAH 0: Tech Stack Discovery Questionnaire (NEW - MANDATORY) ]
  • 8 pertanyaan context discovery (team expertise, budget, scale, etc)
  • Generate 2-3 stack options dengan cost/pros/cons comparison
  • User pilih preferred stack (LOCK DECISION sebelum FSD)
                                    │
                                    ▼
[ LANGKAH 1: Generate Tech Stack Justification (Based on User Choice) ]
  • Context-specific reasoning untuk chosen stack
  • Tradeoffs analysis (alternatives rejected dengan alasan)
  • Deployment topology sesuai budget & scale
                                    │
                                    ▼
[ LANGKAH 2: Perancangan Skema Basis Data (Database Schema & DDL) ]
  • Desain Tabel, Primary/Foreign Keys, Constraint CHECK, dan Indeks
  • Strategi Audit Trail (created_at, updated_at, actor_id, soft-delete)
  • Syntax adapted to chosen DB (PostgreSQL vs MySQL vs MongoDB)
                                    │
                                    ▼
[ LANGKAH 3: Pemetaan Kontrak API & Matriks Endpoint ]
  • HTTP Verbs, Path, Header Otentikasi & Idempotency
  • Skema Payload JSON Request & Respon (Sukses vs Error Matrix)
  • API style adapted to stack (REST vs GraphQL vs tRPC)
                                    │
                                    ▼
[ LANGKAH 4: Pondasi Keamanan & Kepatuhan Regulasi (Security Blueprint) ]
  • Enkripsi Data Vault (AES-256-GCM / Envelope Encryption)
  • Manajemen Sesi (HttpOnly Cookies, JWT Rotation) & Hashing Argon2id
  • Proteksi OWASP Top 10, Rate Limiting, & Kepatuhan UU PDP
  • Framework-specific security patterns
                                    │
                                    ▼
[ LANGKAH 5: Module 04 Prototype → Module 06 Handoff Strategy ]
  • Define conversion strategy (Stitch → chosen framework)
  • Document component mapping (React → Vue/Svelte/Blade)
  • Extract design tokens untuk reuse di stack terpilih
                                    │
                                    ▼
[ LANGKAH 6: Finalisasi & Penandatanganan PRD & FSD ]
  • Review Teknis Bersama Single PIC Klien
  • Tanda Tangan Technical Sign-Off
                                    │
                                    ▼
[ OUTPUT: Dokumen PRD.md & FSD.md ] ──► Siap Masuk ke Modul 06: Development
```

---

## 2. Tech Stack Discovery Questionnaire (LANGKAH 0 - MANDATORY)

**WAJIB DIJALANKAN SEBELUM generate FSD.** Tidak ada "default stack" - semua keputusan context-driven.

Agent wajib tanya user 8 pertanyaan ini dan tunggu jawaban sebelum recommend stack options:

### Question 1: Team Expertise
**"Apa tech stack yang tim/Anda sudah familiar dan produktif?"**

Options:
- [ ] JavaScript/TypeScript (React, Node.js, Next.js)
- [ ] PHP (Laravel, Symfony, CodeIgniter)
- [ ] Python (Django, Flask, FastAPI)
- [ ] Ruby (Rails, Sinatra)
- [ ] Go (Gin, Fiber, Echo)
- [ ] Java (Spring Boot)
- [ ] .NET (ASP.NET Core)
- [ ] Other: ___________

**Why this matters**: Learning curve 2 bulan vs 2 minggu. Gunakan existing expertise = faster delivery.

---

### Question 2: Database Experience
**"Database yang tim pernah pakai dan comfortable maintain?"**

Options:
- [ ] PostgreSQL
- [ ] MySQL / MariaDB
- [ ] MongoDB
- [ ] SQLite
- [ ] Firebase / Supabase
- [ ] None (first project - prefer managed service)

**Why this matters**: Wrong DB choice = schema migration nightmare di production.

---

### Question 3: Deployment Budget (Monthly)
**"Budget hosting per bulan yang available?"**

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
**"Berapa concurrent users target dalam 12 bulan pertama?"**

Options:
- [ ] <100 (MVP, internal tool, niche B2B)
- [ ] 100-1,000 (small B2B SaaS, local business)
- [ ] 1,000-10,000 (growing SaaS, regional app)
- [ ] 10,000-100,000 (high-growth startup)
- [ ] >100,000 (viral app, nationwide scale)

**Why this matters**:
- <100 users: Monolith cukup (PostgreSQL single instance)
- 10K users: Need caching (Redis), read replicas
- 100K users: Microservices, load balancer, CDN mandatory

---

### Question 5: Data Model Characteristics
**"Karakteristik data model aplikasi ini?"**

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
**"Seberapa nyaman handle deployment complexity?"**

Options:
- [ ] Zero-config (git push auto-deploy, no terminal commands)
- [ ] Low-config (Docker Compose, basic CI/CD)
- [ ] Medium (Kubernetes, Terraform basics)
- [ ] High (full control, custom infra, multi-region)

**Why this matters**:
- Zero-config: Vercel, Railway (easy tapi vendor lock-in)
- Low-config: DigitalOcean App Platform (Docker deploy via UI)
- Medium: AWS ECS, GCP Cloud Run (container orchestration)
- High: Kubernetes self-managed (full control, high maintenance)

---

### Question 7: Critical Feature Priority
**"Feature paling critical untuk aplikasi ini?"**

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
**"Regulatory compliance yang harus dipenuhi?"**

Options:
- [ ] None (personal project, MVP)
- [ ] UU PDP (Indonesia - user consent, data deletion right)
- [ ] GDPR (EU - strict data protection)
- [ ] HIPAA (Healthcare US - encrypted PHI, audit logs)
- [ ] SOC2 / ISO27001 (Enterprise B2B - security audit)
- [ ] PCI-DSS (Payment processing - credit card data)

**Why this matters**:
- HIPAA/PCI-DSS: Managed cloud dengan compliance cert (AWS, Azure)
- ISO27001: Need audit logs (database triggers, Sentry logging)
- None: Simpler stack choices, faster iteration

---

## Tech Stack Options Generation (Agent Execution)

Setelah user jawab 8 pertanyaan, agent **WAJIB generate 2-3 stack options** dengan format:

### Option Template:

```markdown
## Stack Option A: [Name] (Recommended jika [condition])

**Frontend**: [Framework] ([reasoning])
**Backend**: [Framework] ([reasoning])
**Database**: [Database] ([reasoning])
**File Storage**: [Service] ([reasoning])
**Deployment**: [Platform] ([reasoning])
**Monitoring**: [Service] ([reasoning])

**Total Monthly Cost**: $X-Y
**Setup Time**: X hari/minggu
**Maintenance Effort**: Low/Medium/High

**Pros**:
- ✅ [Benefit 1 specific to user answers]
- ✅ [Benefit 2]
- ✅ [Benefit 3]

**Cons**:
- ❌ [Tradeoff 1]
- ❌ [Tradeoff 2]

**Best For**: [User profile yang cocok]
**Avoid If**: [User profile yang tidak cocok]

**Stack Compatibility with Module 04 Prototype**:
- Stitch/Figma prototype → [Framework]: [Conversion strategy]
  - React/Next.js: Direct copy (minimal refactoring)
  - Vue/Svelte: Convert JSX → SFC/component syntax
  - Laravel Blade: Extract layout patterns, rewrite as templates
```

### Example Options (Based on Common Scenarios):

#### Scenario: "JS familiar, $0 budget, <100 users, SEO important"

**Agent generates 3 options**:

```markdown
## Stack Option A: Vercel Zero-Cost Stack (Recommended)

**Frontend**: Next.js 15 App Router
**Backend**: Next.js API Routes (serverless)
**Database**: Supabase PostgreSQL (500MB free)
**File Storage**: Supabase Storage (1GB free)
**Deployment**: Vercel Hobby (free)
**Monitoring**: Sentry (5K errors/month free)

**Total Monthly Cost**: $0
**Setup Time**: 2-3 hari
**Maintenance**: Low (managed services, auto-updates)

**Pros**:
- ✅ Zero upfront cost (ideal untuk MVP validation)
- ✅ Auto-scaling (serverless functions 0→100 requests)
- ✅ SEO optimized (server-side rendering built-in)
- ✅ Fast iteration (git push auto-deploy)

**Cons**:
- ❌ Cold starts (300-500ms first request after idle)
- ❌ Bandwidth limits (100GB/month, overage = upgrade)
- ❌ Vendor lock-in (Vercel-specific features)

**Best For**: MVP, solo dev first project, testing market fit
**Avoid If**: Need guaranteed <200ms response, high traffic (>10K MAU)

**Stitch Prototype Conversion**: 
- ✅ **Direct copy** - Stitch generates React/Tailwind code
- Minimal refactoring: Import paths, component structure
- Estimated conversion time: 1 hari


---

## Stack Option B: DigitalOcean Self-Hosted (Budget Alternative)

**Frontend**: Next.js 15 (static export) via Nginx
**Backend**: Node.js Express (PM2 process manager)
**Database**: PostgreSQL 15 (Docker container)
**File Storage**: DigitalOcean Spaces ($5/month, 250GB)
**Deployment**: DigitalOcean Droplet 2GB ($18/month)
**Monitoring**: Self-hosted Grafana + Prometheus (free)

**Total Monthly Cost**: $23/month
**Setup Time**: 5-7 hari (manual server setup)
**Maintenance**: Medium (OS updates, security patches, backups)

**Pros**:
- ✅ No cold starts (always-on server)
- ✅ Unlimited bandwidth (DigitalOcean $18 = unlimited transfer)
- ✅ Full control (SSH access, custom configs)
- ✅ Cheaper at scale (fixed cost vs Vercel usage-based)

**Cons**:
- ❌ Manual DevOps (setup Nginx, SSL certs, backups)
- ❌ No auto-scaling (need manual vertical/horizontal scaling)
- ❌ Single point of failure (1 server down = app down)

**Best For**: Budget-conscious dev, comfortable with Linux, 100-1K users
**Avoid If**: Zero DevOps knowledge, need auto-scaling, compliance requirements

**Stitch Prototype Conversion**:
- ✅ **Direct copy** - Next.js static export compatible
- Add Express API layer (Stitch only generates frontend)
- Estimated conversion time: 2 hari


---

## Stack Option C: Cloudflare Workers Full-Stack (Edge-First)

**Frontend**: Remix (Cloudflare Pages)
**Backend**: Cloudflare Workers (Hono framework)
**Database**: Turso (SQLite edge replicas)
**File Storage**: Cloudflare R2 ($0.015/GB, S3-compatible)
**Deployment**: Cloudflare Pages (free tier)
**Monitoring**: Cloudflare Analytics (free)

**Total Monthly Cost**: $5-15/month (depends on DB size)
**Setup Time**: 3-4 hari
**Maintenance**: Low (edge platform, managed)

**Pros**:
- ✅ Global edge (deploy to 200+ cities, <50ms TTFB worldwide)
- ✅ No cold starts (Workers always warm)
- ✅ Cheapest storage (R2 = $0.015/GB vs S3 $0.023/GB)
- ✅ Unlimited bandwidth (no egress fees)

**Cons**:
- ❌ Learning curve (Workers API berbeda dari Node.js)
- ❌ Limited Node.js compatibility (some npm packages tidak support)
- ❌ Turso learning curve (SQLite syntax, edge replication concepts)

**Best For**: Global user base, low-latency priority, modern edge-first stack
**Avoid If**: Need Node.js specific libraries, team unfamiliar with edge concepts

**Stitch Prototype Conversion**:
- ⚠️ **Moderate conversion** - Stitch React → Remix requires route refactoring
- Components reusable, routes need restructuring (file-based → Remix conventions)
- Estimated conversion time: 3-4 hari
```

---

#### Scenario: "PHP expert, $50 budget, 1000 users, complex queries"

**Agent generates**:

```markdown
## Stack Option A: Laravel Monolith (Recommended - Leverage Expertise)

**Frontend**: Laravel Blade + Inertia.js (Vue 3 SPA)
**Backend**: Laravel 11 (API + Web routes)
**Database**: MySQL 8 on DigitalOcean ($15/month managed)
**File Storage**: DigitalOcean Spaces ($5/month)
**Deployment**: DigitalOcean Droplet 4GB ($24/month)
**Monitoring**: Laravel Telescope (free) + Sentry

**Total Monthly Cost**: $44/month
**Setup Time**: 3-5 hari
**Maintenance**: Low (familiar stack, Laravel artisan commands)

**Pros**:
- ✅ Team expertise (no learning curve, productive day 1)
- ✅ Laravel Eloquent ORM (powerful query builder untuk complex queries)
- ✅ Built-in admin panel (Laravel Nova optional)
- ✅ Mature ecosystem (100K+ packages, active community)

**Cons**:
- ❌ PHP stigma (harder to hire modern devs vs JS)
- ❌ Not serverless (need traditional server management)

**Best For**: PHP teams, CRUD-heavy apps, traditional web apps
**Avoid If**: Team prefers JS/TS, need serverless architecture

**Stitch Prototype Conversion**:
- ⚠️ **Full rewrite** - Stitch React → Laravel Blade templates
- Strategy: Extract layout patterns from Stitch, rewrite as Blade components
- Inertia.js option: Keep Vue components, wire to Laravel backend
- Estimated conversion time: 5-7 hari (Blade) or 3-4 hari (Inertia)


---

## Stack Option B: Next.js + Separate API (Hybrid, If Transitioning to JS)

**Frontend**: Next.js 15 (server components)
**Backend**: Laravel 11 API-only (RESTful endpoints)
**Database**: MySQL 8 managed ($15/month)
**Deployment**: Frontend on Vercel ($0), API on Railway ($10/month)

**Total Monthly Cost**: $25/month
**Setup Time**: 5-7 hari
**Maintenance**: Medium (two deployment targets)

**Pros**:
- ✅ Modern frontend (React ecosystem)
- ✅ Leverage Laravel backend expertise (keep familiar ORM)
- ✅ Decoupled (frontend/backend teams can work independently)

**Cons**:
- ❌ Learning curve (Laravel team learns React/Next.js)
- ❌ CORS complexity (cross-origin API calls)
- ❌ Two deployments (more moving parts)

**Best For**: Transitioning to modern JS stack, team split (PHP backend, JS frontend)
**Avoid If**: Solo dev (overhead tidak worth it), tight timeline

**Stitch Prototype Conversion**:
- ✅ **Direct copy** - Stitch React → Next.js components
- Backend API: Laravel routes + Eloquent (familiar)
- Estimated conversion time: 2-3 hari (frontend) + 3-4 hari (API)
```

---

## Agent Decision Logic (After User Answers):

```python
# Pseudo-code untuk agent
def generate_stack_options(answers):
    options = []
    
    # Rule 1: Leverage team expertise (HIGHEST PRIORITY)
    if answers['expertise'] == 'PHP':
        options.append(generate_laravel_stack())
    elif answers['expertise'] == 'Python':
        options.append(generate_django_stack())
    elif answers['expertise'] == 'JavaScript':
        options.append(generate_nextjs_stack())
    
    # Rule 2: Budget constraint
    if answers['budget'] == '$0':
        options.append(generate_free_tier_stack())  # Vercel + Supabase
    elif answers['budget'] == '$5-25':
        options.append(generate_vps_stack())  # DigitalOcean Droplet
    
    # Rule 3: Scale + data model
    if answers['scale'] == '<100' and answers['data_model'] == 'fixed':
        options.append(generate_monolith_stack())
    elif answers['scale'] == '>10000':
        options.append(generate_microservices_stack())
    
    # Rule 4: Critical feature
    if answers['feature'] == 'SEO':
        # Ensure SSR framework in all options
        options = filter_ssr_capable(options)
    elif answers['feature'] == 'Real-time':
        options = filter_websocket_capable(options)
    
    # Return top 3 options (max)
    return rank_by_fit_score(options)[:3]
```

---

## User Selection & Lock Decision

Setelah agent present 2-3 options:

**Agent prompt**:
```
Saya telah generate 3 stack options berdasarkan jawaban Anda:
- Option A: Vercel Zero-Cost Stack ($0/month, recommended untuk MVP)
- Option B: DigitalOcean Self-Hosted ($23/month, no cold starts)
- Option C: Cloudflare Workers Edge ($5-15/month, global low-latency)

Silakan pilih salah satu:
- Ketik "A" untuk Option A
- Ketik "B" untuk Option B
- Ketik "C" untuk Option C
- Atau request custom stack jika tidak ada yang cocok

⚠️ CRITICAL: Stack decision LOCKED setelah dipilih. Perubahan stack di tengah development = +2 minggu timeline.
```

**User types**: "A"

**Agent response**:
```
✅ Stack Decision LOCKED: Option A (Vercel Zero-Cost Stack)

Tech Stack Summary:
- Frontend: Next.js 15 App Router
- Backend: Next.js API Routes (serverless)
- Database: Supabase PostgreSQL
- Deployment: Vercel Hobby (free tier)

Stack ini akan digunakan untuk generate FSD.md (Langkah 1-4).

Lanjut ke Langkah 1 (Database Schema Design)?
```

**GATE**: User MUST confirm stack choice before FSD generation proceeds.

---

## 3. Prinsip Arsitektur Solo Developer: "Context-Aware Tech Ladder"

## 3. Prinsip Arsitektur Solo Developer: "Universal Stack Evaluation"

**Core Principle**: Tidak ada "default stack" atau "preferred list". Semua tech stack di dunia adalah kandidat - yang terbaik adalah yang paling cocok dengan context user.

### Stack Evaluation Criteria (Weighted Scoring System)

Agent evaluate SEMUA kemungkinan stack berdasarkan 8 kriteria dengan bobot:

| Criteria | Weight | Measurement | Example |
|----------|--------|-------------|---------|
| **Team Expertise Match** | 40% | Apakah stack familiar ke tim? | PHP team + Laravel = 10/10, PHP team + Go = 2/10 |
| **Budget Fit** | 20% | Total monthly cost vs budget | $0 budget + Vercel free = 10/10, $0 budget + AWS ECS = 0/10 |
| **Scale Appropriateness** | 15% | Stack handle target load? | 100 users + monolith = 10/10, 100 users + K8s = 2/10 (overkill) |
| **Feature Compatibility** | 10% | Stack native support critical feature? | SEO need + Next.js SSR = 10/10, SEO need + CRA = 3/10 |
| **Data Model Match** | 5% | DB paradigm cocok dengan data? | Fixed schema + PostgreSQL = 10/10, Flexible + MongoDB = 10/10 |
| **DevOps Simplicity** | 5% | Deployment complexity vs tolerance? | Zero-config need + Vercel = 10/10, Zero-config + K8s = 0/10 |
| **Compliance Support** | 3% | Built-in compliance features? | HIPAA + AWS compliant = 10/10, HIPAA + hobby VPS = 2/10 |
| **Ecosystem Maturity** | 2% | Community size, package availability | React (200K npm) = 10/10, new framework = 5/10 |

**Total Score**: 0-100 (weighted sum)

**Agent selects top 3 highest-scoring stacks** untuk present ke user.

---

### Stack Universe (Non-Exhaustive, Agent Can Recommend ANY Stack)

Agent tidak restricted ke list ini, tapi ini common candidates untuk berbagai scenarios:

#### Frontend Frameworks:
- **SSR-Capable**: Next.js, Nuxt.js, SvelteKit, Remix, SolidStart, Qwik City, Astro (hybrid), Fresh (Deno)
- **SPA**: React (Vite), Vue 3 (Vite), Svelte, Solid.js, Preact, Alpine.js
- **Mobile-First**: React Native, Flutter, Ionic, Capacitor
- **Static**: Astro, Eleventy, Hugo, Jekyll

#### Backend Frameworks:
- **JavaScript/TypeScript**: Express, Fastify, Nest.js, Hono, Elysia (Bun)
- **PHP**: Laravel, Symfony, CodeIgniter, Slim, Lumen
- **Python**: Django, FastAPI, Flask, Sanic, Tornado
- **Go**: Gin, Fiber, Echo, Chi, Gorilla
- **Ruby**: Rails, Sinatra, Hanami
- **Java**: Spring Boot, Quarkus, Micronaut
- **.NET**: ASP.NET Core, Minimal APIs
- **Rust**: Actix-web, Rocket, Axum, Warp
- **Elixir**: Phoenix, Plug
- **Kotlin**: Ktor, Spring Boot (Kotlin)

#### Databases:
- **Relational**: PostgreSQL, MySQL, MariaDB, SQLite, CockroachDB, PlanetScale
- **NoSQL Document**: MongoDB, CouchDB, RavenDB
- **NoSQL Key-Value**: Redis, DragonflyDB, KeyDB
- **NoSQL Graph**: Neo4j, ArangoDB, Dgraph
- **Time-Series**: TimescaleDB, InfluxDB, QuestDB
- **Serverless**: Supabase, Neon, Turso, PlanetScale

#### Deployment Platforms:
- **Zero-Config PaaS**: Vercel, Netlify, Railway, Render, Fly.io, Cloudflare Pages
- **Container PaaS**: DigitalOcean App Platform, Heroku, Google Cloud Run, AWS App Runner
- **VPS**: DigitalOcean Droplets, Linode, Vultr, Hetzner
- **Kubernetes**: AWS EKS, GCP GKE, DigitalOcean Kubernetes, self-hosted
- **Edge**: Cloudflare Workers, Deno Deploy, Netlify Edge Functions

#### Hybrid/Full-Stack:
- **Monolith Modern**: Laravel (Blade/Inertia), Rails (Hotwire), Django (HTMX), Phoenix (LiveView)
- **Meta-Frameworks**: Redwood.js, Blitz.js, T3 Stack, Create JD App

**Agent freedom**: Jika questionnaire answers point ke obscure tapi perfect-fit stack (e.g., Elixir Phoenix LiveView untuk real-time dashboard tanpa complexity WebSocket manual), agent **BOLEH recommend**.

---

### Scoring Example (Transparent Logic)

**User Answers**:
1. Expertise: JavaScript/TypeScript ✅
2. Budget: $0/month
3. Scale: <100 users
4. Data Model: Fixed schema
5. DevOps: Zero-config
6. Feature: SEO (public content)
7. Compliance: None
8. Database: PostgreSQL

**Agent Evaluation** (top 10 candidates):

| Stack | Expertise (40%) | Budget (20%) | Scale (15%) | Feature (10%) | Data (5%) | DevOps (5%) | Compliance (3%) | Ecosystem (2%) | **Total** |
|-------|-----------------|--------------|-------------|---------------|-----------|-------------|-----------------|----------------|-----------|
| **Next.js + Vercel + Supabase** | 40 (10/10 JS) | 20 (10/10 free) | 15 (10/10 scale) | 10 (10/10 SSR) | 5 (10/10 PG) | 5 (10/10 zero) | 3 (10/10) | 2 (10/10 huge) | **100** ✅ |
| **Remix + Fly.io + Supabase** | 40 (10/10 JS) | 18 (9/10 $5/mo) | 15 (10/10) | 10 (10/10 SSR) | 5 (10/10 PG) | 4 (8/10 low) | 3 (10/10) | 1.6 (8/10) | **96.6** ✅ |
| **Astro + Netlify + Supabase** | 40 (10/10 JS) | 20 (10/10 free) | 15 (10/10) | 9 (9/10 SSG+SSR) | 5 (10/10 PG) | 5 (10/10 zero) | 3 (10/10) | 1.4 (7/10) | **98.4** ✅ |
| **SvelteKit + Vercel + Supabase** | 36 (9/10 similar) | 20 (10/10 free) | 15 (10/10) | 10 (10/10 SSR) | 5 (10/10 PG) | 5 (10/10 zero) | 3 (10/10) | 1.4 (7/10) | **95.4** |
| **Laravel + DO + MySQL** | 8 (2/10 no PHP) | 4 (2/10 $44/mo) | 15 (10/10) | 7 (7/10 Blade) | 5 (10/10) | 2 (4/10 manual) | 3 (10/10) | 1.8 (9/10) | **45.8** ❌ |
| **Go Fiber + Fly.io + PG** | 4 (1/10 no Go) | 18 (9/10 $5/mo) | 15 (10/10) | 5 (5/10 no SSR) | 5 (10/10 PG) | 3 (6/10 Docker) | 3 (10/10) | 1.2 (6/10) | **54.2** ❌ |

**Top 3 Recommendations** (score ≥95):
1. **Next.js Full-Stack** (100 points) - Perfect match semua criteria
2. **Astro Hybrid** (98.4 points) - Excellent untuk content-heavy dengan islands
3. **Remix Edge** (96.6 points) - Modern alternative dengan edge deployment

**Agent presents 3 options** dengan full breakdown (cost, pros/cons, conversion strategy).

---

### Agent Presentation Format (After Scoring)

```markdown
📊 Tech Stack Evaluation Complete

Analyzed 47 stack combinations based on your answers.
Top 3 recommendations (score ≥95/100):

---

## Option A: Next.js Full-Stack (Score: 100/100) ⭐ RECOMMENDED

**Stack**:
- Frontend: Next.js 15 App Router (React 18, TypeScript)
- Backend: Next.js API Routes (serverless functions)
- Database: Supabase PostgreSQL (500MB free tier)
- File Storage: Supabase Storage (1GB free)
- Deployment: Vercel Hobby (free, auto-scaling)
- Monitoring: Sentry (5K errors/month free)

**Why This Scored Highest**:
- ✅ Expertise match: 10/10 (you know JS/TS)
- ✅ Budget: 10/10 (100% free stack, $0/month)
- ✅ Feature: 10/10 (native SSR for SEO)
- ✅ DevOps: 10/10 (git push auto-deploy)

**Monthly Cost**: $0 (until 100GB bandwidth exceeded)
**Setup Time**: 2-3 hari
**Maintenance**: Low (managed services)

**Pros**:
- ✅ Zero upfront cost (validate MVP without spending)
- ✅ Huge ecosystem (shadcn/ui, 200K+ React packages)
- ✅ Hot reload, TypeScript strict mode, built-in optimization

**Cons**:
- ❌ Cold starts (300-500ms first request after 5min idle)
- ❌ Vendor lock-in (Vercel-specific features: Edge Middleware, ISR)

**Module 04 Handoff**: Direct copy (Stitch React → Next.js, 1 hari, 95% reuse)

---

## Option B: Astro Hybrid (Score: 98.4/100)

**Stack**:
- Frontend: Astro 4 (islands architecture, partial hydration)
- UI Framework: React (only for interactive islands)
- Backend: Astro API Routes (edge functions)
- Database: Supabase PostgreSQL
- Deployment: Netlify (free tier, edge functions)

**Why This Scored High**:
- ✅ Budget: 10/10 (free)
- ✅ SEO: 9/10 (static by default, optional SSR)
- ✅ Performance: Ships 90% less JS than Next.js (faster page load)

**Monthly Cost**: $0
**Setup Time**: 3-4 hari
**Maintenance**: Low

**Pros**:
- ✅ Best performance (static HTML, minimal JS)
- ✅ Framework agnostic (use React, Vue, Svelte together)
- ✅ Content-focused (best untuk blog, landing page)

**Cons**:
- ❌ Smaller ecosystem vs Next.js (fewer examples)
- ❌ Learning curve (islands architecture concept baru)

**Module 04 Handoff**: Component extraction (Stitch React → Astro islands, 2 hari, 80% reuse)

---

## Option C: Remix on Fly.io (Score: 96.6/100)

**Stack**:
- Frontend: Remix (React meta-framework)
- Backend: Remix loaders/actions (edge-ready)
- Database: Supabase PostgreSQL
- Deployment: Fly.io ($5/month, 2 small VMs globally)

**Why This Scored High**:
- ✅ Expertise: 10/10 (React-based)
- ✅ SEO: 10/10 (SSR + progressive enhancement)
- ✅ Modern DX (nested routes, error boundaries)

**Monthly Cost**: $5
**Setup Time**: 3-4 hari
**Maintenance**: Low

**Pros**:
- ✅ No cold starts (Fly.io always-on VMs)
- ✅ Progressive enhancement (works without JS)
- ✅ Edge-ready (deploy globally, <100ms latency)

**Cons**:
- ❌ Smaller ecosystem vs Next.js (newer framework, 2021)
- ❌ Not free ($5/month minimum)

**Module 04 Handoff**: Route restructuring (Stitch React → Remix routes, 3 hari, 70% reuse)

---

## Selection

Pilih salah satu:
- Ketik **"A"** untuk Next.js (recommended, free, familiar)
- Ketik **"B"** untuk Astro (best performance, content-focused)
- Ketik **"C"** untuk Remix (edge-first, no cold starts)
- Ketik **"Other"** untuk lihat 3 options lain (ranks 4-6)

Stack decision LOCKS after selection. Changes later = +2 minggu timeline.

⚠️ WAITING FOR SELECTION...
```

---

### Handling "Other" Request (Ranks 4-6)

Jika user type "Other":

```markdown
## Alternative Options (Ranks 4-6):

### Option D: SvelteKit + Vercel (Score: 95.4/100)
- Similar to Next.js tapi pakai Svelte (compile-time framework)
- Pros: Smaller bundle, faster runtime
- Cons: Smaller ecosystem vs React

### Option E: Nuxt.js + Netlify (Score: 93.8/100)
- Vue alternative to Next.js
- Pros: Vue 3 Composition API, auto-imports
- Cons: Learning curve if coming from React

### Option F: T3 Stack (Score: 92.1/100)
- Next.js + tRPC + Prisma + Tailwind
- Pros: End-to-end type safety, no API contracts
- Cons: Opinionated, tRPC learning curve

Pilih D/E/F atau "Back" untuk kembali ke top 3.
```

User bisa loop sampai satisfied, atau request custom stack:

```
User: "Bagaimana dengan Go + HTMX?"
Agent: [Re-score dengan Go Fiber + HTMX]
  Score: 67.2/100
  - Expertise: 4/40 (no Go experience) ❌
  - Budget: 18/20 ($5/month Fly.io)
  - Feature: 7/10 (HTMX partial SSR)
  
  Recommendation: NOT recommended untuk tim JS-only. Go learning curve 4-8 minggu.
  
  Proceed anyway? (Y/N)
```

---

## 4. Module 04 Prototype → Module 06 Handoff Strategy

**Problem**: Stitch/Figma prototype (Module 04) generated dalam format tertentu (React/HTML), tapi user pilih stack berbeda (Laravel/Vue/Django).

**Solution**: Define conversion strategy di FSD based on stack compatibility level.

### Compatibility Levels:

#### **Level 1: Direct Copy (React-Based Stacks)**

**Applicable When**: User pilih Next.js, Remix, Gatsby, Create React App

**Strategy**:
1. Export Stitch code (React + Tailwind)
2. Copy components langsung ke `components/` folder
3. Minimal refactoring:
   - Import paths adjustment
   - Component file structure (one component per file)
   - Add TypeScript types (jika Stitch generate vanilla JS)

**Conversion Effort**: 1 hari
**Conversion Rate**: 95% code reuse

**Example**:
```typescript
// Stitch export (single file)
function DashboardCard({ title, value }) {
  return (
    <div className="bg-white rounded-lg shadow-sm p-6">
      <h3 className="text-zinc-700 font-semibold">{title}</h3>
      <p className="text-3xl font-bold text-zinc-900">{value}</p>
    </div>
  )
}

// Module 06 (Next.js) - minimal refactor
// components/DashboardCard.tsx
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

---

#### **Level 2: Syntax Conversion (Similar Framework)**

**Applicable When**: User pilih Vue, Svelte, Solid, Preact

**Strategy**:
1. Extract component structure dari Stitch
2. Convert JSX → framework syntax
3. Keep Tailwind classes identical (design system preserved)
4. Rewrite state management (React hooks → Vue Composition API / Svelte stores)

**Conversion Effort**: 3-4 hari (18 screens)
**Conversion Rate**: 70% structure reuse, 100% design reuse

**Example**:
```vue
<!-- Stitch export (React JSX) -->
<div className="bg-white rounded-lg shadow-sm p-6">
  <h3 className="text-zinc-700 font-semibold">{title}</h3>
  <p className="text-3xl font-bold text-zinc-900">{value}</p>
</div>

<!-- Module 06 (Vue SFC) - syntax conversion -->
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

**Conversion Tools** (Optional automation):
- `react-to-vue`: CLI tool convert JSX → Vue SFC
- Manual review required (80% accuracy, need fixes)

---

#### **Level 3: Template Rewrite (Server-Side Rendering)**

**Applicable When**: User pilih Laravel Blade, Django Templates, Rails ERB, PHP

**Strategy**:
1. Stitch prototype = **visual reference only** (tidak extract code)
2. Identify layout patterns:
   - Header (logo, nav, user menu)
   - Sidebar (if applicable)
   - Main content area (cards, tables, forms)
   - Footer
3. Rewrite as server-side templates dengan framework syntax
4. Extract Tailwind classes dari Stitch → copy ke templates
5. Design tokens (DESIGN.md) → apply manual

**Conversion Effort**: 5-7 hari (18 screens)
**Conversion Rate**: 0% code reuse, 100% design reuse (visual parity)

**Example**:
```blade
{{-- Stitch export (React JSX) - reference only --}}
<div className="bg-white rounded-lg shadow-sm p-6">
  <h3 className="text-zinc-700 font-semibold">{title}</h3>
  <p className="text-3xl font-bold text-zinc-900">{value}</p>
</div>

{{-- Module 06 (Laravel Blade) - manual rewrite --}}
<div class="bg-white rounded-lg shadow-sm p-6">
  <h3 class="text-zinc-700 font-semibold">{{ $title }}</h3>
  <p class="text-3xl font-bold text-zinc-900">{{ $value }}</p>
</div>
```

**Tailwind Integration** (Laravel example):
```bash
# Install Tailwind in Laravel
npm install -D tailwindcss postcss autoprefixer
npx tailwindcss init

# tailwind.config.js (copy from DESIGN.md)
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

#### **Level 4: Hybrid (Inertia.js / Hotwire)**

**Applicable When**: User pilih Laravel + Inertia.js, Rails + Hotwire Turbo

**Strategy**:
1. Backend: Laravel/Rails (API routes, Eloquent/ActiveRecord)
2. Frontend: Keep Vue/React components dari Stitch
3. Glue layer: Inertia.js wires Vue components to Laravel routes
4. Conversion effort sama dengan Level 2 (syntax conversion)

**Conversion Effort**: 3-4 hari (frontend) + 2-3 hari (backend wiring)
**Conversion Rate**: 70% code reuse (Vue components), 100% design reuse

**Example**:
```php
// Laravel route (Inertia.js)
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
<!-- resources/js/Pages/Dashboard.vue (from Stitch) -->
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

---

### FSD Documentation Requirement (Langkah 5):

**Section: "Module 04 Handoff Strategy"** di FSD.md wajib include:

```markdown
## Module 04 Prototype Conversion Strategy

**Chosen Stack**: [Laravel + Inertia.js + Vue 3]
**Compatibility Level**: Level 4 (Hybrid)

**Conversion Plan**:
1. Extract 18 Vue components dari Stitch export
2. Setup Inertia.js di Laravel project (ziggy routes, Vite config)
3. Create Laravel routes untuk setiap page (map SITEMAP.md → web.php)
4. Wire Vue components to Inertia::render() calls
5. Copy Tailwind config dari DESIGN.md → tailwind.config.js
6. Test component rendering (ensure props match backend data structure)

**Estimated Conversion Time**: 5-7 hari
- Day 1-2: Inertia.js setup + first 5 pages
- Day 3-4: Remaining 13 pages + component library
- Day 5: Polish (responsive, dark mode if applicable)
- Day 6-7: Testing + fixes

**Design System Preservation**:
- ✅ Tailwind classes preserved (bg-white, rounded-lg, shadow-sm, etc)
- ✅ Color palette dari DESIGN.md applied (primary: #0891B2)
- ✅ Typography (Inter font, weights 400/600)
- ✅ Spacing scale (4/8/16/24/32px)

**Deviations from Stitch Prototype** (if any):
- None expected (visual parity maintained)
- If deviations occur: Document in Module 06 change log
```

---

## 5. Langkah demi Langkah Eksekusi

### Langkah 1: Perancangan Skema Basis Data
1. Identifikasi seluruh entitas data dari formulir di `DESIGN_SPEC.md`.
2. Tuliskan skema relasional lengkap dalam format SQL DDL baku.
3. Kunci integritas data di level basis data:
   - Gunakan `UUIDv7` atau `BIGINT` untuk Primary Key.
   - Pasang relasi `FOREIGN KEY` dengan `ON DELETE RESTRICT` (jangan biarkan data transaksi terhapus otomatis secara liar).
   - Pasang constraint `CHECK` (misal: `CHECK (nominal >= 0)`).
   - Pasang indeks pada kolom yang sering dicari (`WHERE user_id = ... AND status = ...`).

### Langkah 2: Pemetaan Kontrak API (API Contract)
Setiap tombol aksi di antarmuka harus memiliki pasangan endpoint API yang terdefinisi dengan format baku:
- **Metode & Rute**: `POST /api/v1/documents`
- **Headers**:
  ```http
  Authorization: Bearer <TOKEN>
  Content-Type: application/json
  X-Idempotency-Key: <UUID>
  ```
- **Payload Request JSON**: Skema field input beserta tipe data dan aturan validasi.
- **Respon Sukses & Respon Error**: Format seragam (`status`, `data`, `error: { code, message }`).

#### OpenAPI/Swagger Documentation Generation

**Automated API documentation is MANDATORY for projects with 10+ endpoints or external API consumers (B2B, mobile apps, third-party integrations).**

**Implementation Ladder by Stack**:

| Stack | Tool | Implementation | Auto-Generate | Status |
|-------|------|----------------|---------------|--------|
| **Next.js/Node.js** | `swagger-jsdoc` + `swagger-ui-express` | JSDoc annotations in route files | ✅ Runtime | Recommended |
| **FastAPI (Python)** | Built-in OpenAPI | Type hints in endpoint decorators | ✅ Automatic | Best-in-class |
| **Laravel** | `darkaonline/l5-swagger` | PHPDoc annotations in controllers | ✅ artisan command | Standard |
| **Go Fiber/Gin** | `swaggo/swag` | Swagger comments in handlers | ✅ swag init | Required manual |
| **Rails** | `rswag` gem | RSpec request specs → OpenAPI | ✅ rake task | Test-driven |
| **Django REST** | `drf-spectacular` | DRF serializers → OpenAPI | ✅ Automatic | Built-in |

---

**Setup Example: Next.js API Routes**

```bash
# Install dependencies
pnpm add swagger-jsdoc swagger-ui-express
pnpm add -D @types/swagger-jsdoc @types/swagger-ui-express
```

**File: `app/api/swagger/route.ts`** (OpenAPI spec generator)
```typescript
import swaggerJsdoc from 'swagger-jsdoc';
import { NextResponse } from 'next/server';

const options = {
  definition: {
    openapi: '3.0.0',
    info: {
      title: 'Project API Documentation',
      version: '1.0.0',
      description: 'Auto-generated from JSDoc annotations',
    },
    servers: [
      { url: 'http://localhost:3000', description: 'Development' },
      { url: 'https://api.project.com', description: 'Production' },
    ],
    components: {
      securitySchemes: {
        bearerAuth: {
          type: 'http',
          scheme: 'bearer',
          bearerFormat: 'JWT',
        },
      },
    },
  },
  apis: ['./app/api/**/*.ts'], // Scan all route files
};

const swaggerSpec = swaggerJsdoc(options);

export async function GET() {
  return NextResponse.json(swaggerSpec);
}
```

**File: `app/api/docs/page.tsx`** (Swagger UI)
```typescript
'use client';
import SwaggerUI from 'swagger-ui-react';
import 'swagger-ui-react/swagger-ui.css';

export default function ApiDocs() {
  return <SwaggerUI url="/api/swagger" />;
}
```

**Annotated Route Example: `app/api/documents/route.ts`**
```typescript
/**
 * @swagger
 * /api/documents:
 *   post:
 *     summary: Create new document
 *     tags: [Documents]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - title
 *               - content
 *             properties:
 *               title:
 *                 type: string
 *                 example: "Contract Agreement"
 *               content:
 *                 type: string
 *                 example: "Legal document content..."
 *               tags:
 *                 type: array
 *                 items:
 *                   type: string
 *     responses:
 *       201:
 *         description: Document created successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 status:
 *                   type: string
 *                   example: "success"
 *                 data:
 *                   type: object
 *                   properties:
 *                     id:
 *                       type: string
 *                       example: "01HQZX..."
 *                     title:
 *                       type: string
 *       401:
 *         description: Unauthorized
 *       422:
 *         description: Validation error
 */
export async function POST(request: Request) {
  // Implementation...
}
```

---

**FastAPI Example (Python)** - Zero configuration needed:
```python
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel

app = FastAPI(
    title="Project API",
    version="1.0.0",
    description="Auto-generated OpenAPI docs"
)

class DocumentCreate(BaseModel):
    title: str
    content: str
    tags: list[str] = []

@app.post("/api/documents", status_code=201)
async def create_document(doc: DocumentCreate):
    """
    Create new document
    
    - **title**: Document title (required)
    - **content**: Document body (required)
    - **tags**: Optional tags
    """
    return {"status": "success", "data": {"id": "01HQZX..."}}

# Auto-generated docs at: /docs (Swagger UI) and /redoc (ReDoc)
```

---

**Laravel Example**:
```bash
# Install package
composer require darkaonline/l5-swagger
php artisan vendor:publish --provider "L5Swagger\L5SwaggerServiceProvider"
```

```php
/**
 * @OA\Post(
 *     path="/api/documents",
 *     summary="Create new document",
 *     tags={"Documents"},
 *     security={{"bearerAuth":{}}},
 *     @OA\RequestBody(
 *         required=true,
 *         @OA\JsonContent(
 *             required={"title","content"},
 *             @OA\Property(property="title", type="string", example="Contract"),
 *             @OA\Property(property="content", type="string")
 *         )
 *     ),
 *     @OA\Response(response=201, description="Created")
 * )
 */
public function store(Request $request) {
    // Implementation...
}
```

```bash
# Generate OpenAPI spec
php artisan l5-swagger:generate
# Access docs at: /api/documentation
```

---

**OpenAPI Integration Checklist**:
- [ ] Install OpenAPI generation library sesuai stack
- [ ] Configure base info (title, version, servers, auth schemes)
- [ ] Annotate 100% public-facing endpoints (prioritas: auth, core CRUD, webhooks)
- [ ] Generate spec: `pnpm swagger` / `php artisan l5-swagger:generate` / automatic
- [ ] Verify Swagger UI accessible (`/api/docs` atau `/api/documentation`)
- [ ] Export `openapi.json` to `docs/specs/openapi.json` for version control
- [ ] Add to M06 development checklist: "Update OpenAPI annotations when adding endpoints"

**When to Skip OpenAPI**:
- ❌ Internal-only API dengan <5 endpoints
- ❌ GraphQL API (use GraphQL introspection instead)
- ❌ tRPC (TypeScript end-to-end type safety, no need for OpenAPI)
- ❌ MVP <4 minggu dengan zero external API consumers

**Benefits**:
- ✅ Auto-generated client SDKs (TypeScript, Python, Go) via `openapi-generator`
- ✅ API testing tools (Postman, Insomnia) can import OpenAPI spec
- ✅ Contract testing (Pact, Dredd) validates implementation vs spec
- ✅ Frontend devs can mock API responses during parallel development

---

### Langkah 3: Arsitektur Keamanan Terpasang (Built-in Security)
Kunci protokol keamanan sebelum menulis kode:
1. **Penyimpanan Dokumen Sensitif (Vault)**:
   - File PDF dokumen wajib dienkripsi sebelum masuk cloud storage menggunakan AES-256-GCM. Kunci enkripsi dikelola terpisah (*Key Management Service*).
   - **KMS Implementation Ladder by Scale**:
     - **Kecil**: Environment variables (`process.env.ENCRYPTION_KEY`) + AWS Secrets Manager basic
     - **Menengah**: HashiCorp Vault (self-hosted or HCP) with key rotation
     - **Besar**: AWS KMS / GCP Cloud KMS with envelope encryption
     - **Enterprise**: Hardware Security Module (HSM) + FIPS 140-2 compliance
   - Tautan unduhan dokumen wajib menggunakan *Presigned URL* dengan masa kedaluwarsa maksimal 15 menit.
2. **Otentikasi & Password**:
   - Password wajib di-hash menggunakan **Argon2id** (atau bcrypt dengan cost factor ≥12).
   - Token sesi disimpan di `HttpOnly, Secure, SameSite=Strict` cookie untuk mencegah pencurian token melalui serangan Cross-Site Scripting (XSS).
3. **Pembatasan Laju Request (Rate Limiting)**:
   - Endpoint sensitif (Login, Kirim OTP, Checkout) diproteksi pembatasan laju (contoh: maksimal 5 percobaan per IP dalam 15 menit).

### Langkah 4: Penyusunan Dokumen PRD & FSD
- **`PRD.md`**: Memuat ringkasan kebutuhan fungsional bisnis, matriks hak akses pengguna (RBAC), metrik keberhasilan (KPI), dan batasan non-fungsional (NFR: latency < 200 ms, uptime 99.9%).
- **`FSD.md`**: Memuat detail teknis mutlak (diagram ERD, script SQL DDL, tabel API contract, state machine transaksi, dan audit logging).

### Langkah 5: Technical Sign-Off Bersama Klien
- Solo dev memaparkan dokumen PRD & FSD ke **Single PIC Klien**.
- Klien menandatangani lembar persetujuan spesifikasi teknis (*Technical Sign-off*).
- Dengan ditandatanganinya FSD, lingkup dan logika teknis resmi terkunci.

---

## 4. Adaptasi Berdasarkan Skala Proyek

| Aspek | Skala Kecil (MVP / Freelance) | Skala Menengah (B2B SaaS / Agensi) | Skala Besar & Enterprise |
| :--- | :--- | :--- | :--- |
| **Dokumen PRD** | Ringkas (3–5 halaman) | Modular terstruktur (10–20 halaman) | Formal Enterprise PRD lengkap |
| **Dokumen FSD** | Skema tabel & rute API inti | FSD lengkap: ERD, SQL DDL, API contracts | FSD mendalam, RTM, Disaster Recovery SOP |
| **Skema Database** | 3–6 tabel relasional | 10–20 tabel dengan migrasi terversi | 30+ tabel, partisi data, sharding plan |
| **Keamanan** | HTTPS, password hashing, RLS | S3 AES-256, JWT rotation, rate limiter | Zero-knowledge vault, HSM, ISO 27001 audit |
| **Approval** | Persetujuan via email/chat tertulis | Tanda tangan lembar Technical Sign-off | Formal Sign-off CAB (Change Advisory Board) |

---

## 5. Artefak Keluaran (Deliverables)

> 📁 **ATURAN LOKASI BERKAS MUTLAK**:
> Seluruh dokumen spesifikasi Modul 05 WAJIB disimpan di dalam folder **`docs/specs/`** (bukan di root direktori).
> DILARANG menaruh `PRD.md` atau `FSD.md` di root proyek.

Modul ini menghasilkan 2 dokumen teknis utama:
1. **`docs/specs/PRD.md`**: Dokumen kebutuhan produk fungsional dan non-fungsional (menggunakan `templates/03-architecture-specs/PRD_FINAL_TEMPLATE.md`).
2. **`docs/specs/FSD.md`**: Dokumen spesifikasi teknis fungsional, skema database DDL, API contracts, dan arsitektur keamanan (menggunakan `templates/03-architecture-specs/FSD_TECHNICAL_TEMPLATE.md`).

> 💡 *Rujukan pola arsitektur & clean code FSD*: `references/playbooks/software-design-patterns.md`.

---

## 6. Kriteria Kelulusan [GATE] (Gate Exit Criteria)

[GATE] Modul 05 dinyatakan **LOLOS (PASS)** jika:

### Phase 0: Tech Stack Discovery (BLOCKING)
- [x] **8-question questionnaire completed** (user answered all questions)
- [x] **2-3 stack options generated** dengan cost/pros/cons comparison
- [x] **User selected preferred stack** (LOCKED decision, cannot change without +2 minggu timeline impact)
- [x] **Stack selection documented** di FSD.md header section

### Phase 1-4: FSD Content (BLOCKING)
- [x] **Tech stack justification documented** (context-specific reasoning, alternatives rejected dengan alasan)
- [x] **Database schema written** dalam SQL DDL syntax sesuai chosen DB (PostgreSQL/MySQL/MongoDB)
- [x] **API endpoints documented** (minimum 10 endpoints dengan request/response examples)
- [x] **Security blueprint complete** (encryption, hashing, rate limiting, framework-specific patterns)
- [x] **Module 04 handoff strategy documented** (conversion plan dari Stitch → chosen stack)

### Phase 5: File Verification (BLOCKING)
- [x] **`docs/specs/PRD.md` exists** (≥3000 bytes, contains RBAC matrix, NFR thresholds)
- [x] **`docs/specs/FSD.md` exists** (≥8000 bytes, contains all technical sections)

### Phase 6: User Approval (BLOCKING)
- [x] **Technical Sign-Off obtained** dari Single PIC Klien atau solo developer self-approval

---

## 🛑 PROTOKOL [GATE] KELUAR & WAJIB BERHENTI

### LANGKAH 0: Tech Stack Discovery (MANDATORY FIRST)

**Agent WAJIB execute questionnaire SEBELUM generate FSD**:

```powershell
# GATE CHECK - Module 05 Phase 0
# Verify questionnaire answered before FSD generation

$questionnaireComplete = $false
$stackLocked = $false

# Agent must track user answers dalam memory atau temp file
# Check if all 8 questions answered
if ($answeredQuestions -lt 8) {
    Write-Error "❌ PHASE 0 GATE FAILED: Only $answeredQuestions/8 questions answered."
    Write-Error "Complete questionnaire before generating stack options."
    exit 1
}

# Check if stack selected
if (-not $selectedStack) {
    Write-Error "❌ PHASE 0 GATE FAILED: User belum pilih stack dari options."
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

### LANGKAH 1-4: Generate FSD Content

After stack locked, agent proceeds to generate FSD sections based on chosen stack.

**Content must adapt to stack**:
- PostgreSQL chosen → SQL DDL syntax with FOREIGN KEY, CHECK constraints
- MongoDB chosen → Mongoose schema syntax, no foreign keys
- Laravel chosen → Eloquent migration syntax
- Django chosen → Django ORM models syntax

**Anti-Pattern** (AI SLOP):
- ❌ Always generate PostgreSQL schema tanpa check chosen DB
- ❌ Always recommend Next.js API routes tanpa check chosen backend
- ❌ Generic "best practices" tidak sesuai framework

---

### LANGKAH 5: File Existence Verification

```powershell
# GATE CHECK - Module 05 File Verification
$requiredFiles = @(
    @{Path="docs/specs/PRD.md"; MinSize=3000},
    @{Path="docs/specs/FSD.md"; MinSize=8000}
)

$allPassed = $true

foreach ($file in $requiredFiles) {
    if (-not (Test-Path $file.Path)) {
        Write-Error "❌ GATE FAILED: File $($file.Path) tidak ditemukan."
        $allPassed = $false
    } else {
        $size = (Get-Item $file.Path).Length
        if ($size -lt $file.MinSize) {
            Write-Error "❌ GATE FAILED: File $($file.Path) terlalu kecil ($size bytes < $($file.MinSize) minimum)."
            $allPassed = $false
        } else {
            Write-Host "✅ $($file.Path) verified ($size bytes)"
        }
    }
}

if (-not $allPassed) {
    Write-Error "`n🛑 MODULE 05 GATE FAILED: Missing atau incomplete files."
    exit 1
}
```

---

### LANGKAH 6: Content Validation

```python
# Pseudo-code untuk agent verification
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
        raise GateError(f"FSD.md hanya ada {endpoint_count} endpoints (minimum 10)")
    
    # Verify database schema (SQL or NoSQL syntax)
    if ("CREATE TABLE" not in fsd) and ("mongoose.Schema" not in fsd) and ("models.Model" not in fsd):
        raise GateError("FSD.md missing database schema definition")
    
    # Verify Module 04 handoff strategy
    if "Prototype Conversion Strategy" not in fsd:
        raise GateError("FSD.md missing Module 04 handoff strategy")
    
    return True
```

---

### LANGKAH 7: Display Summary & User Approval

Setelah semua checks passed:

```
✅ MODULE 05 COMPLETE - Architecture & FSD Ready

Files Generated:
- ✅ PRD.md (12.4KB) - Product requirements document
- ✅ FSD.md (34.8KB) - Functional specification document

Tech Stack Summary (LOCKED):
- Frontend: Next.js 15 App Router
- Backend: Next.js API Routes (serverless)
- Database: Supabase PostgreSQL
- Deployment: Vercel Hobby (free tier)
- Monitoring: Sentry

FSD Content Summary:
- ✅ Tech Stack Justification: Context-specific reasoning (team JS expertise, $0 budget, SEO priority)
- ✅ Database Schema: 5 tables (users, documents, signatures, audit_logs, sessions), 12 relationships, 18 indexes
- ✅ API Endpoints: 24 endpoints (auth, documents, signatures, users) dengan request/response examples
- ✅ Security: JWT auth (HttpOnly cookies), Argon2id password hashing, rate limiting (5 attempts/15min), AES-256 file encryption
- ✅ Module 04 Handoff: Direct copy strategy (Stitch React → Next.js, 95% code reuse, 1 hari conversion)

Performance Requirements:
- Page load: <2s (P95)
- API response: <500ms (P95)
- Concurrent users: 100 (auto-scaling serverless)

Next Steps:
1. Review FSD.md (verify tech decisions align dengan expectations)
2. If revisions needed: Request changes now (before Module 06 coding)
3. If approved: Confirm "FSD approved, start Module 06 development"

⚠️ CRITICAL: Stack cannot change after approval without +2 minggu timeline impact (database migration, API rewrite, component conversion).

⚠️ WAITING FOR USER CONFIRMATION - Do NOT proceed to Module 06 automatically.
```

---

### LANGKAH 8: STOP & Wait for Approval

**DILARANG KERAS** melanjutkan ke Module 06 dalam turn yang sama.

Agent harus:
1. **END TURN** setelah display summary
2. **WAIT** for explicit user approval: "FSD approved" atau "Lanjut Module 06"
3. Only proceed after confirmation received

**Jika user request changes**:
- Re-generate affected sections
- Re-run GATE verification
- Display updated summary
- Wait for approval again

**Jika user approve**:
- Mark Module 05 complete
- Proceed to Module 06 (Development Implementation)
- Carry forward FSD.md + chosen stack sebagai blueprint untuk coding
