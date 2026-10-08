# Tech Stack Support Matrix

**Last Updated**: 2026-10-08  
**Benchmark Standards**: Modern 17 Tech Domains (October 2026 Official Stable Releases)

## Currently Supported (Full M06 Support)

Stacks with complete scaffold, AI harness templates in `templates/04-dev-execution/`, version gates, and verification commands:

| Stack | Scaffold Command | Templates in `templates/04-dev-execution/` | Version Gate Verification | Status |
|:------|:-----------------|:-------------------------------------------|:--------------------------|:-------|
| **Next.js** | `pnpm create next-app@latest` | `nextjs/` (AGENTS, ARCHITECTURE, CONVENTIONS, ENV) | npm Registry: `npm view next version` → package-lock.json | **PRODUCTION** |
| **Laravel** | `composer create-project laravel/laravel` | `laravel/` (AGENTS, ARCHITECTURE, CONVENTIONS, ENV) | Packagist API: `repo.packagist.org/p2/laravel/framework.json` → composer.lock | **PRODUCTION** |
| **Django** | `django-admin startproject` | `django/` (AGENTS, ARCHITECTURE, CONVENTIONS, ENV) | PyPI API: `pypi.org/pypi/django/json` → requirements.txt | **PRODUCTION** |
| **Go** | `go mod init` | `go/` (AGENTS, ARCHITECTURE, CONVENTIONS, ENV) | Go API & Proxy: `go.dev/dl` + `proxy.golang.org` → go.mod | **PRODUCTION** |
| **Ruby on Rails** | `rails new project-name --database=postgresql` | `rails/` (AGENTS, ARCHITECTURE, CONVENTIONS, .env.example) | RubyGems API: `rubygems.org/api/v1/gems/rails.json` → Gemfile.lock | **ROADMAP / BETA** |
| **Remix** | `npx create-remix@latest` | `remix/` (AGENTS, README) | npm Registry: `npm view @remix-run/dev version` → lockfile | **ROADMAP / BETA** |
| **MERN Stack** | `express-generator` + `create-react-app`/`vite` | `mern/` (AGENTS) | npm Registry: `npm view express version` → package-lock.json | **ROADMAP / BETA** |
| **ASP.NET Core** | `dotnet new webapi -n ProjectName` | `aspnet/` (AGENTS) | NuGet API: `api.nuget.org` → .csproj target | **ROADMAP / BETA** |
| **Spring Boot** | `spring init --dependencies=web,data-jpa` | `spring/` (AGENTS) | Maven Central / `start.spring.io` → pom.xml / build.gradle | **ROADMAP / BETA** |
| **JAMstack / Astro**| `npm create astro@latest` | `astro/`, `jamstack/` (AGENTS, README) | npm Registry: `npm view astro version` → package-lock.json | **ROADMAP / BETA** |
| **Serverless** | `serverless create` / `sam init` | `serverless/` (AGENTS) | npm Registry: `npm view serverless version` → template.yaml | **ROADMAP / BETA** |
| **Flutter** | `flutter create project_name` | `flutter/` (AGENTS) | Pub.dev API: `pub.dev/api/packages/flutter_lints` → pubspec.lock | **ROADMAP / BETA** |
| **SvelteKit** | `npm create svelte@latest` | `sveltekit/` (README) | npm Registry: `npm view @sveltejs/kit version` → package-lock.json | **ROADMAP / PLANNED** |
| **Nuxt** | `npx nuxi@latest init` | `nuxt/` (README) | npm Registry: `npm view nuxt version` → package-lock.json | **ROADMAP / PLANNED** |

---

## Official 2026 Verified Ecosystem Releases (October 2026 Baseline)

While M05 enforces real-time registry queries to avoid cutoff drift, the official baseline stable ecosystem versions as of October 2026 are:

| Ecosystem / Category | Primary Framework & Toolchain | Official 2026 Baseline | Key 2026 Architectural Paradigms |
|:---|:---|:---|:---|
| **Full-Stack PHP** | **Laravel 13.x** + Inertia.js v2 | PHP 8.4+, Vite | Native semantic/vector primitives, no-API single-file controllers |
| **High-Concurrency Backend** | **Go 1.27.x** (Fiber v3 / Chi) | Go 1.27 (1.26 LTS) | ~15MB RAM footprint, single-binary container, sqlc type-safe SQL |
| **Enterprise JVM** | **Spring Boot 4.1.x** | Java 21 LTS, Spring AI 2.0 | Project Loom Virtual Threads, GraalVM AOT, Indonesian Banking Standard |
| **Enterprise .NET** | **.NET 10.0.x (LTS)** / ASP.NET Core 10 | C# 13/14, Native AOT | Minimal API high throughput, Blazor full-stack, enterprise compliance |
| **Desktop & Cross-Platform** | **Tauri 2.12.x** (Rust 1.88+) | Rust + Svelte 5 / Solid | ~3MB installer, 50% lower RAM than Electron, Desktop + Mobile single codebase |
| **Frontend Non-React** | **Svelte 5.57.x** + SvelteKit 3.x | Vite 6 | Runes reactivity (`$state`, `$derived`, `$effect`), zero virtual-DOM overhead |
| **Python AI/Data & Web** | **FastAPI 0.142.x** / **Django 6.1.x** | Python 3.13 / 3.14t | Native async ORM, Celery / Redis queue, pgvector RAG integration |
| **Frontend React Meta** | **Next.js 15.x / 16.x** + React 19 | Node.js 22 LTS / Bun 1.2 | Server Actions, Route Handlers, App Router native streaming |
| **Vue Ecosystem** | **Vue 3.5.x** + Nuxt 4.5.x | Vite 6 | Composition API mature, Nuxt UI v3, Server Components |
| **Mobile Cross-Platform** | **Flutter 3.47.x** (Dart 3.13+) / **React Native 0.87** | Expo SDK 54/55 | Impeller GPU 120 FPS / New Architecture (Fabric + TurboModules) |
| **Enterprise TypeScript** | **Angular 22.x** | TypeScript Strict | Signal-based reactivity, Zoneless by default, standalone components |
| **Lightweight Edge / Scripting** | **Astro 5.x** / **Hono 4.13.x** | Bun / Cloudflare Workers | 0 KB JS default, Turso libSQL / D1, sub-millisecond edge routing |

---

## Anti-Overkill Stack Selection Matrix (By Project Scale)

Solo developers must adhere to the principle: **Never use a cannon to kill an ant**. Choosing a stack must match project scale to preserve velocity and eliminate unnecessary operational layers.

```
+--------------------------------------------------------------------------------------------------+
| PROJECT SCALE        | RECOMMENDED STACK (ANTI-OVERKILL)      | STRICTLY OVERKILL (DO NOT USE)   |
+--------------------------------------------------------------------------------------------------+
| Small (1-2 weeks)    | • Astro 5 + Hono + SQLite/Turso        | • Microservices / Kubernetes     |
| Micro-tools, utils,  | • CodeIgniter 4 / PHP + Alpine.js      | • Next.js + Redux + Celery + K8s |
| landing pages, calcs | • FastAPI Lite / Streamlit (Data demo) | • Heavy distributed event queues |
+--------------------------------------------------------------------------------------------------+
| Medium (2-4 weeks)   | • Laravel 13 + Inertia v2 + React/Vue  | • Distributed microservices      |
| Solo SaaS, niche B2B,| • Next.js 15/16 + Supabase (RLS/Auth)  | • Spring Boot 4 + Apache Kafka   |
| internal portals     | • SvelteKit 3 + PocketBase / Supabase  | • Multi-region service meshes    |
+--------------------------------------------------------------------------------------------------+
| Large (4-8 weeks)    | • Go 1.27 (Fiber v3) + React + Postgres| • Native unmanaged PHP scripts   |
| High concurrency,    | • FastAPI 0.142 + pgvector + Celery    |   without ORM / DB migrations    |
| TMS/WMS, multi-tenant| • NestJS + Fastify + Prisma/Drizzle    | • Single-file SQLite databases   |
+--------------------------------------------------------------------------------------------------+
| Enterprise (3-6+ mo) | • Spring Boot 4.1 (Java 21) + Angular  | • Serverless BaaS without audit  |
| Core banking, HIS,   | • .NET 10 (C#) + EF Core + SQL Server  | • Ephemeral zero-auth functions  |
| telecom BSS/OSS, ERP | • Postgres/Oracle + Kafka + Redis      | • Schema-less document stores    |
+--------------------------------------------------------------------------------------------------+
```

### Detailed Scale Breakdown:

1. **Small Scale (Micro-tool, Utilitas, Single-User MVP | 1–2 Weeks)**
   - **Target**: Deploy in 3–7 days with zero deployment friction.
   - **Option A (Ultra-Lightweight Modern JS)**: `Astro 5.x` or `Hono 4.13.x` (Bun/Edge) + Turso (libSQL) / SQLite. 0 KB JS by default, zero cold start.
   - **Option B (Rapid Server-Rendered PHP)**: `CodeIgniter 4.7.x` or lightweight PHP + Alpine.js + SQLite/MySQL. Zero build step, instant deployment on inexpensive hosting.
   - **Option C (Data / Scripting Demo)**: `FastAPI 0.142.x` + Jinja2 or `Streamlit`. Instant interactive UI for algorithmic or small ML pipelines.
   - **Overkill Red Flags**: Next.js App Router + Docker + Kubernetes + Kafka for a simple tax calculator or portfolio.

2. **Medium Scale (Solo SaaS, B2B MVP, Regional Business Portal | 2–4 Weeks)**
   - **Target**: Ship production SaaS in 2–4 weeks; optimal sweet spot for solo developers.
   - **Option D (The Solo Developer King)**: `Laravel 13.x` + `Inertia.js v2` + Tailwind CSS + PostgreSQL/MySQL. Eliminates separate REST API layer; batteries-included auth, queue, and storage.
   - **Option E (Modern React BaaS)**: `Next.js 15/16` / `TanStack Start` + `Supabase` (Auth, Postgres RLS, Storage) + Drizzle ORM.
   - **Option F (High-Performance Svelte)**: `SvelteKit 3.x` + `PocketBase` (single-binary backend) or Supabase. Clean Runes reactivity, small footprint.
   - **Overkill Red Flags**: Separating frontend and backend repositories with Spring Boot + Kafka + microservices architecture.

3. **Large Scale (Multi-Tenant Logistics, TMS/WMS, B2B Multi-Vendor | 4–8 Weeks)**
   - **Target**: High concurrency, strict ledger integrity, resilient background worker processing.
   - **Option G (High-Performance Scalability)**: `Go 1.27.x` (Fiber v3 / Chi) + `sqlc` + React SPA (Vite) + PostgreSQL 17 + Redis 8. Minimal memory footprint (~20MB RAM), sub-millisecond execution.
   - **Option H (AI-Native RAG & Data Engine)**: `FastAPI 0.142.x` + Celery/Redis Queue + Supabase `pgvector` + React 19. Offloads heavy embeddings and LLM tasks to dedicated background workers.
   - **Option I (Modular TypeScript Monolith)**: `NestJS` (Fastify engine) + PostgreSQL + Prisma/Drizzle + Next.js client. Strict dependency injection for multi-developer team handoffs.
   - **Overkill Red Flags**: Unstructured PHP/Node scripts without database migrations or unindexed single-node SQLite for multi-tenant high concurrent writes.

4. **Enterprise Scale (Banking, Hospital HIS, Telecom BSS, Factory ERP | 3–6+ Months)**
   - **Target**: Institutional regulatory compliance (UU PDP, ISO 27001, OJK/BI), full audit trail, 99.99% reliability.
   - **Option J (Indonesian Banking & Corporate Standard)**: `Spring Boot 4.1.x` (Java 21 LTS) + Spring Security + JPA + Oracle/PostgreSQL + Apache Kafka + Angular 22 / Vue 3.5.
   - **Option K (Enterprise Windows & FinTech)**: `.NET 10 (LTS)` + ASP.NET Core 10 Minimal APIs + EF Core 10 + SQL Server / PostgreSQL.
   - **Overkill Red Flags**: Relying on uncertified third-party BaaS without complete internal database audit logging and compliance certifications.

---

## Version Resolution Protocol

**Note**: Versions are determined by M05 real-time registry check, NOT hardcoded by skill.
- M05 runs `npm view next version` → locks result in FSD.md
- M06 scaffolds @latest → pins exact FSD version → version gate validates lockfile
- Framework templates adapt dynamically; real-time queries prevent knowledge cutoff lag.
- Upstream major updates (e.g. Next.js 15→16, Laravel 11→13, Django 5→6, Go 1.23→1.27) are validated by `./scripts/verify/check-package-versions.sh <stack>` via HTTP registry queries without requiring local compiler installation.
- For the roadmap/beta/planned stacks, developers can utilize the generic harness files (`templates/04-dev-execution/AGENTS_TEMPLATE.md` and `CONTEXT_TEMPLATE.md`) and customize CLI commands in `RUNBOOK_LOCAL.md` per framework specs.

---

## Roadmap: Additional Stacks

### Phase 1: JavaScript Ecosystem (Estimated 10-15 days)

**1. Ruby on Rails** (5-7 days)
- Scaffold: `rails new project-name --database=postgresql --skip-git`
- Version gate: Parse Gemfile.lock for `rails (x.x.x)`
- Templates needed:
  - `AGENTS.md`: Ruby style (snake_case), Rails conventions, ActiveRecord patterns
  - `ARCHITECTURE.md`: MVC structure, app/models, app/controllers, app/views
  - `CONVENTIONS.md`: Ruby gems, Bundler, RSpec/Minitest
- Verification: `bundle exec rspec`, `bundle audit`
- Use case: Rapid MVPs, startup prototyping, convention-over-configuration

**2. Remix** (2-3 days)
- Scaffold: `npx create-remix@latest`
- Version gate: package-lock.json (similar to Next.js)
- Templates needed:
  - `AGENTS.md`: Reuse Next.js base, add Remix-specific (loader/action patterns, nested routes)
  - `ARCHITECTURE.md`: app/routes structure, loader/action exports
- Verification: `npm run build`, `npm run typecheck`
- Use case: Progressive enhancement, web standards focus, nested routing

**3. MERN Stack** (3-4 days)
- Scaffold: Express.js generator + MongoDB setup scripts
- Version gate: package-lock.json
- Templates needed:
  - `AGENTS.md`: Express middleware patterns, Mongoose schemas
  - `ARCHITECTURE.md`: MongoDB collections, Express routes, React frontend
  - `CONVENTIONS.md`: NoSQL data modeling, aggregation pipelines
- Verification: `npm test`, `mongosh` validation
- Use case: Real-time apps, flexible NoSQL data, rapid iteration

---

### Phase 2: Enterprise Backends (Estimated 20-25 days)

**4. ASP.NET Core** (7-10 days)
- Scaffold: `dotnet new webapi -n ProjectName`
- Version gate: Parse .csproj for `<TargetFramework>net8.0</TargetFramework>` and NuGet packages
- Templates needed:
  - `AGENTS.md`: C# conventions (PascalCase, async/await, LINQ patterns)
  - `ARCHITECTURE.md`: Controllers, Models, Services pattern, Entity Framework
  - `CONVENTIONS.md`: Dependency injection, middleware pipeline, appsettings.json
- Verification: `dotnet test`, `dotnet build`
- Use case: Enterprise SaaS, finance, healthcare, Microsoft ecosystem integration

**5. Spring Boot** (7-10 days)
- Scaffold: `spring init --dependencies=web,data-jpa --build=maven`
- Version gate: Parse pom.xml (Maven) or build.gradle (Gradle) for Spring Boot version
- Templates needed:
  - `AGENTS.md`: Java conventions (camelCase, annotations, streams)
  - `ARCHITECTURE.md`: Controllers, Services, Repositories, JPA entities
  - `CONVENTIONS.md`: Maven/Gradle, application.properties, Bean lifecycle
- Verification: `mvn test` or `gradle test`, `mvn package`
- Use case: Banking, e-commerce, microservices, enterprise backends

**6. JAMstack** (3-5 days)
- Scaffold: `npm create astro@latest` or `npx degit 11ty/eleventy-base-blog`
- Version gate: package-lock.json
- Templates needed:
  - `AGENTS.md`: Subset of Next.js (no API routes, focus on SSG)
  - `ARCHITECTURE.md`: Static generation, content sources (Markdown/CMS)
  - `CONVENTIONS.md`: Build-time data fetching, CDN deployment
- Verification: `npm run build`, check dist/ output
- Use case: Marketing sites, blogs, documentation, high-performance static content

---

### Phase 3: Specialized Architectures (Estimated 25-30 days)

**7. Serverless** (10-15 days)
- Scaffold: `sam init` (AWS SAM) or `serverless create --template aws-nodejs`
- Version gate: Parse serverless.yml or template.yaml for runtime versions
- Templates needed:
  - `AGENTS.md`: Event-driven patterns, stateless functions, cold start optimization
  - `ARCHITECTURE.md`: Lambda functions, API Gateway, DynamoDB/S3 integration
  - `CONVENTIONS.md`: Infrastructure-as-code, environment variables, IAM policies
- Verification: `sam validate`, `serverless package`
- Use case: Event-driven systems, variable workloads, pay-per-use cost model
- **Note**: Different deployment model (not traditional server), separate M07 deployment guide needed

**8. Flutter** (10-15 days)
- Scaffold: `flutter create project_name`
- Version gate: Parse pubspec.lock for Flutter SDK and package versions
- Templates needed:
  - `AGENTS.md`: Dart conventions (camelCase, async/await, widget composition)
  - `ARCHITECTURE.md`: lib/screens, lib/widgets, lib/services, state management (Riverpod/Bloc)
  - `CONVENTIONS.md`: pubspec.yaml, platform channels, asset management
- Verification: `flutter analyze`, `flutter test`, `flutter build apk --debug`
- Use case: iOS + Android apps from single Dart codebase
- **Note**: Mobile lifecycle (app stores, device testing, platform-specific features) differs from web development

---

### Excluded from Roadmap (Not Standalone Frameworks)

**LAMP** (Linux + Apache + MySQL + PHP)
- **Decision**: Raw PHP without framework → recommend Laravel instead
- Laravel is modern PHP with routing, ORM, security - no reason to support raw PHP

**Android Kotlin**
- **Decision**: Native single-platform mobile → recommend Flutter for cross-platform instead
- If user specifically needs Kotlin, they're doing native development (outside solo web workflow)

**AI/ML Stack** (TensorFlow/PyTorch)
- **Decision**: Not a web framework - it's a complementary layer added to backends
- Django/Flask + TensorFlow is supported via Django templates + custom integration

**Blockchain** (Ethereum, Hyperledger, Solidity)
- **Decision**: Specialized domain with fundamentally different development paradigm
- Smart contract deployment, gas optimization, consensus ≠ CRUD web apps
- Outside scope of solo web project lifecycle

---

## Recommendation for New Projects

### Web Applications (SaaS, Dashboards, CRMs)
- **Rapid Prototyping**: Next.js (React + TypeScript) - check latest stable in M05
- **API-Heavy Backend**: Laravel or Django - check latest stable in M05
- **Microservices**: Go - check latest stable in M05

### Mobile Applications
- **Status**: Not yet supported by skill
- **Workaround**: Use Next.js + PWA for cross-platform web apps

### Enterprise/Legacy
- **PHP**: Use Laravel (modern PHP framework, check latest in M05)
- **.NET/Java**: Pending template development

### Version Selection Process

**M05 Module: Real-Time Version Check**
```bash
# Step 1: Check registry for latest stable
npm view next version          # Output: 16.3.8 (example, actual varies)
composer show laravel/framework --latest  # Output: 11.5.2 (example)
pip index versions django | head -1       # Output: 5.1.3 (example)
go version                                # Check installed Go toolchain

# Step 2: Lock in FSD.md
## Framework Versions (Pinned):
- Next.js: 16.3.8
- React: 19.2.8
- Node.js: 22.11.0

# Step 3: Human approves locked versions
# Step 4: M06 scaffolds + pins exact versions from FSD
```

**Why Real-Time Check?**
- Skill written 2026-10-03, but used 2027-04-15 → Next.js might be 17.x
- Security patches: Django 5.0.1 → 5.0.8 (critical fixes)
- Breaking changes: User decides to lock known-stable version vs bleeding edge

---

## Adding New Stack Support

Required components for M06 production support:

### 1. Scaffold Command
```bash
# Example: Ruby on Rails
rails new project-name --database=postgresql --skip-git
```

### 2. Version Gate Script
- Parse lockfile format (Gemfile.lock, packages-lock.json, etc.)
- Extract major.minor versions
- Compare against FSD.md locked versions

### 3. Harness Templates
- `templates/04-dev-execution/{stack}/AGENTS.md`
- `templates/04-dev-execution/{stack}/ARCHITECTURE.md`
- `templates/04-dev-execution/{stack}/CONVENTIONS.md`
- `templates/04-dev-execution/{stack}/.env.example`

### 4. Verification Commands (Stack-Specific)
```markdown
# Next.js
npm run type-check && npm run build

# Laravel
php artisan test && composer audit

# Django
python manage.py test && pip-audit

# Go
go test ./... && go build

# Rails (example for new stack)
bundle exec rspec && bundle audit
```

### 5. VERIFY_LOCAL Template Adaptation
- Stack-specific test commands
- Framework-specific error patterns (hydration for SSR, N+1 for ORM)
- Ecosystem-specific security checks

---

## Implementation Status

**Current Coverage**: 14 stacks tracked (4 Production, 8 Beta / Roadmap, 2 Planned)
**Tracked Stacks**: Next.js, Laravel, Django, Go, Rails, Remix, MERN, ASP.NET Core, Spring Boot, JAMstack, Serverless, Flutter, SvelteKit, Nuxt.
**Maintenance Strategy**: Continuous real-time package checking via M05 version gates.

**Expansion Strategy**: Demand-driven
- Phase 1 (Rails/Remix/MERN): Implement when JavaScript/Ruby clients appear
- Phase 2 (.NET/Spring/JAMstack): Implement for enterprise clients
- Phase 3 (Serverless/Flutter): Implement for specialized projects

**Truth**: Skill supports FRAMEWORKS not VERSIONS
- ✅ Templates adapt to framework patterns (routing, ORM, validation)
- ✅ Version locked per-project in M05 via real-time registry check
- ✅ Cross-major-version compatibility requires template validation per major release
