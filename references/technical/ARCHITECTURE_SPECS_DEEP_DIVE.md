# Architecture & Technical Specifications Deep-Dive Guide

> **Companion Reference for Module 05 (`docs/modules/05-architecture-specs.md`)**
> Contains detailed stack generation rubrics, universal stack evaluation scores (Next.js, Astro, Remix, Laravel), prototype-to-code conversion strategies, and M05B enterprise infrastructure scalability blueprints.

---

## Tech Stack Options Generation (Agent Execution)

After the user answers all 8 questions, the agent **MUST generate 2-3 stack options** in the following format:

### Option Template:

```markdown
## Stack Option A: [Name] (Recommended if [condition])

**Frontend**: [Framework] ([reasoning])
**Backend**: [Framework] ([reasoning])
**Database**: [Database] ([reasoning])
**File Storage**: [Service] ([reasoning])
**Deployment**: [Platform] ([reasoning])
**Monitoring**: [Service] ([reasoning])

**Total Monthly Cost**: $X-Y
**Setup Time**: X days/weeks
**Maintenance Effort**: Low/Medium/High

**Pros**:
- ✅ [Benefit 1 specific to user answers]
- ✅ [Benefit 2]
- ✅ [Benefit 3]

**Cons**:
- ❌ [Tradeoff 1]
- ❌ [Tradeoff 2]

**Best For**: [Suitable user profile]
**Avoid If**: [Unsuitable user profile]

**Stack Compatibility with Module 04 Prototype**:
- Design prototype → [Framework]: [Conversion strategy]
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
**Setup Time**: 2-3 days
**Maintenance**: Low (managed services, auto-updates)

**Pros**:
- ✅ Zero upfront cost (ideal for MVP validation)
- ✅ Auto-scaling (serverless functions 0→100 requests)
- ✅ SEO optimized (server-side rendering built-in)
- ✅ Fast iteration (git push auto-deploy)

**Cons**:
- ❌ Cold starts (300-500ms first request after idle)
- ❌ Bandwidth limits (100GB/month, overage = upgrade)
- ❌ Vendor lock-in (Vercel-specific features)

**Best For**: MVP, solo dev first project, testing market fit
**Avoid If**: Need guaranteed <200ms response, high traffic (>10K MAU)

**Prototype Conversion**: 
- ✅ **Direct copy** - Design tool generates React/Tailwind code
- Minimal refactoring: Import paths, component structure
- Estimated conversion time: 1 day


---

## Stack Option B: DigitalOcean Self-Hosted (Budget Alternative)

**Frontend**: Next.js 15 (static export) via Nginx
**Backend**: Node.js Express (PM2 process manager)
**Database**: PostgreSQL 16 (Docker container)
**File Storage**: DigitalOcean Spaces ($5/month, 250GB)
**Deployment**: DigitalOcean Droplet 2GB ($18/month)
**Monitoring**: Self-hosted Grafana + Prometheus (free)

**Total Monthly Cost**: $23/month
**Setup Time**: 5-7 days (manual server setup)
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

**Prototype Conversion**:
- ✅ **Direct copy** - Next.js static export compatible
- Add Express API layer (Prototype only generates frontend)
- Estimated conversion time: 2 days


---

## Stack Option C: Cloudflare Workers Full-Stack (Edge-First)

**Frontend**: Remix (Cloudflare Pages)
**Backend**: Cloudflare Workers (Hono framework)
**Database**: Turso (SQLite edge replicas)
**File Storage**: Cloudflare R2 ($0.015/GB, S3-compatible)
**Deployment**: Cloudflare Pages (free tier)
**Monitoring**: Cloudflare Analytics (free)

**Total Monthly Cost**: $5-15/month (depends on DB size)
**Setup Time**: 3-4 days
**Maintenance**: Low (edge platform, managed)

**Pros**:
- ✅ Global edge (deploy to 200+ cities, <50ms TTFB worldwide)
- ✅ No cold starts (Workers always warm)
- ✅ Cheapest storage (R2 = $0.015/GB vs S3 $0.023/GB)
- ✅ Unlimited bandwidth (no egress fees)

**Cons**:
- ❌ Learning curve (Workers API differs from Node.js)
- ❌ Limited Node.js compatibility (some npm packages unsupported)
- ❌ Turso learning curve (SQLite syntax, edge replication concepts)

**Best For**: Global user base, low-latency priority, modern edge-first stack
**Avoid If**: Need Node.js specific libraries, team unfamiliar with edge concepts

**Prototype Conversion**:
- ⚠️ **Moderate conversion** - React prototype → Remix requires route refactoring
- Components reusable, routes need restructuring (file-based → Remix conventions)
- Estimated conversion time: 3-4 days
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
**Setup Time**: 3-5 days
**Maintenance**: Low (familiar stack, Laravel artisan commands)

**Pros**:
- ✅ Team expertise (no learning curve, productive day 1)
- ✅ Laravel Eloquent ORM (powerful query builder for complex queries)
- ✅ Built-in admin panel (Laravel Nova optional)
- ✅ Mature ecosystem (100K+ packages, active community)

**Cons**:
- ❌ PHP stigma (harder to hire modern devs vs JS)
- ❌ Not serverless (requires traditional server management)

**Best For**: PHP teams, CRUD-heavy apps, traditional web apps
**Avoid If**: Team prefers JS/TS, requires serverless architecture

**Prototype Conversion**:
- ⚠️ **Full rewrite** - React prototype → Laravel Blade templates
- Strategy: Extract layout patterns from design specs, rewrite as Blade components
- Inertia.js option: Keep Vue components, wire to Laravel backend
- Estimated conversion time: 5-7 days (Blade) or 3-4 days (Inertia)


---

## Stack Option B: Next.js + Separate API (Hybrid, If Transitioning to JS)

**Frontend**: Next.js 15 (server components)
**Backend**: Laravel 11 API-only (RESTful endpoints)
**Database**: MySQL 8 managed ($15/month)
**Deployment**: Frontend on Vercel ($0), API on Railway ($10/month)

**Total Monthly Cost**: $25/month
**Setup Time**: 5-7 days
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
**Avoid If**: Solo dev (overhead not worth it), tight timeline

**Prototype Conversion**:
- ✅ **Direct copy** - React prototype → Next.js components
- Backend API: Laravel routes + Eloquent (familiar)
- Estimated conversion time: 2-3 days (frontend) + 3-4 days (API)
```

---

## Agent Decision Logic (After User Answers):

```python
# Pseudo-code for agent
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

After the agent presents 2-3 options:

**Agent prompt**:
```
I have generated 3 stack options based on your answers:
- Option A: Vercel Zero-Cost Stack ($0/month, recommended for MVP)
- Option B: DigitalOcean Self-Hosted ($23/month, no cold starts)
- Option C: Cloudflare Workers Edge ($5-15/month, global low-latency)

Please select one:
- Type "A" for Option A
- Type "B" for Option B
- Type "C" for Option C
- Or request a custom stack if none of these fit

⚠️ CRITICAL: Stack decision is LOCKED once selected. Mid-development stack changes = +2 weeks timeline impact.
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

This stack will be used to generate FSD.md (Steps 1-4).

Proceed to Step 1 (Database Schema Design)?
```

**GATE**: User MUST confirm stack choice before FSD generation proceeds.

---

## 3. Solo Developer Architecture Principles: "Universal Stack Evaluation"

**Core Principle**: There is no "default stack" or "preferred list". Every tech stack in the world is a candidate — the best one is the one that best fits the user's context.

### Stack Evaluation Criteria (Weighted Scoring System)

The agent evaluates ALL potential stacks across 8 criteria with weights:

| Criteria | Weight | Measurement | Example |
|----------|--------|-------------|---------|
| **Team Expertise Match** | 40% | Is the stack familiar to the team? | PHP team + Laravel = 10/10, PHP team + Go = 2/10 |
| **Budget Fit** | 20% | Total monthly cost vs budget | $0 budget + Vercel free = 10/10, $0 budget + AWS ECS = 0/10 |
| **Scale Appropriateness** | 15% | Can stack handle target load? | 100 users + monolith = 10/10, 100 users + K8s = 2/10 (overkill) |
| **Feature Compatibility** | 10% | Native support for critical feature? | SEO need + Next.js SSR = 10/10, SEO need + CRA = 3/10 |
| **Data Model Match** | 5% | DB paradigm fits data structure? | Fixed schema + PostgreSQL = 10/10, Flexible + MongoDB = 10/10 |
| **DevOps Simplicity** | 5% | Deployment complexity vs tolerance? | Zero-config need + Vercel = 10/10, Zero-config + K8s = 0/10 |
| **Compliance Support** | 3% | Built-in compliance features? | HIPAA + AWS compliant = 10/10, HIPAA + hobby VPS = 2/10 |
| **Ecosystem Maturity** | 2% | Community size, package availability | React (200K npm) = 10/10, new framework = 5/10 |

**Total Score**: 0-100 (weighted sum)

**Agent selects top 3 highest-scoring stacks** to present to the user.

---

### Anti-Overkill Stack Discipline (MANDATORY GATE)

Before finalizing stack options, cross-check against **`references/stacks/STACK_SUPPORT_MATRIX.md`** and enforce the anti-overkill principle:

1. **Scale Matching Guardrail**:
   - **Small Scale (1–2 weeks / Catalog #1–250)**: Prefer **Astro 5 + Hono / SQLite** or **CodeIgniter 4 / PHP + Alpine.js**. Strictly forbid microservices, Docker clusters, Next.js + Redux + Celery, or Kubernetes.
   - **Medium Scale (2–4 weeks / Catalog #251–500)**: Prefer **Laravel 13 + Inertia v2 + React/Vue** or **Next.js 15/16 + Supabase** or **SvelteKit 3 + PocketBase**. Strictly forbid multi-repo distributed architectures or Spring Boot + Kafka for solo delivery.
   - **Large Scale (4–8 weeks / Catalog #501–750)**: Prefer **Go 1.27 (Fiber v3) + Postgres** or **FastAPI 0.142 + Celery + pgvector** or **NestJS + Fastify**. Strictly forbid raw unmanaged scripts lacking database migrations.
   - **Enterprise Scale (3–6+ months / Catalog #751–1000)**: Prefer **Spring Boot 4.1 (Java 21) + Angular** or **.NET 10 (C#) + EF Core + SQL Server**. Strictly forbid hobby BaaS without complete internal audit logging and regulatory compliance.
2. **Anti-Slop Architecture Filter**:
   - Never recommend Kafka, Kubernetes, or multi-region service meshes when simple background queues (Laravel queues, Celery, BullMQ) and a single PostgreSQL instance handle the target workload.
   - If user asks for an overly complex stack for a simple project, the agent **MUST push back**: *"Stack X is overkill for this scale. Proposing Stack Y instead to preserve delivery speed and maintainability."*

---

### Stack Universe (Non-Exhaustive, Agent Can Recommend ANY Stack)

The agent is not restricted to this list, but these are common candidates across various scenarios:

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
- **Modern Monolith**: Laravel (Blade/Inertia), Rails (Hotwire), Django (HTMX), Phoenix (LiveView)
- **Meta-Frameworks**: Redwood.js, Blitz.js, T3 Stack, Create JD App

**Agent freedom**: If questionnaire answers point to an obscure but perfect-fit stack (e.g., Elixir Phoenix LiveView for a real-time dashboard without manual WebSocket complexity), the agent **MAY recommend it**.

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
1. **Next.js Full-Stack** (100 points) - Perfect match across all criteria
2. **Astro Hybrid** (98.4 points) - Excellent for content-heavy setups with islands
3. **Remix Edge** (96.6 points) - Modern alternative with edge deployment

**Agent presents 3 options** with full breakdown (cost, pros/cons, conversion strategy).

---

### Agent Presentation Format (After Scoring)

```markdown
📊 Tech Stack Evaluation Complete

Analyzed 47 stack combinations based on your answers.
Top 3 recommendations (score ≥95/100):

---

## Option A: Next.js Full-Stack (Score: 100/100) ⭐ RECOMMENDED

**Stack**:
- Frontend: Next.js 15 App Router (React 19, TypeScript)
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
**Setup Time**: 2-3 days
**Maintenance**: Low (managed services)

**Pros**:
- ✅ Zero upfront cost (validate MVP without spending)
- ✅ Huge ecosystem (shadcn/ui, 200K+ React packages)
- ✅ Hot reload, TypeScript strict mode, built-in optimization

**Cons**:
- ❌ Cold starts (300-500ms first request after 5min idle)
- ❌ Vendor lock-in (Vercel-specific features: Edge Middleware, ISR)

**Module 04 Handoff**: Direct copy (React prototype → Next.js, 1 day, 95% reuse)

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
**Setup Time**: 3-4 days
**Maintenance**: Low

**Pros**:
- ✅ Best performance (static HTML, minimal JS)
- ✅ Framework agnostic (use React, Vue, Svelte together)
- ✅ Content-focused (best for blogs, landing pages)

**Cons**:
- ❌ Smaller ecosystem vs Next.js (fewer examples)
- ❌ Learning curve (islands architecture is a new concept)

**Module 04 Handoff**: Component extraction (React prototype → Astro islands, 2 days, 80% reuse)

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
**Setup Time**: 3-4 days
**Maintenance**: Low

**Pros**:
- ✅ No cold starts (Fly.io always-on VMs)
- ✅ Progressive enhancement (works without JS)
- ✅ Edge-ready (deploy globally, <100ms latency)

**Cons**:
- ❌ Smaller ecosystem vs Next.js (newer framework, 2021)
- ❌ Not free ($5/month minimum)

**Module 04 Handoff**: Route restructuring (React prototype → Remix routes, 3 days, 70% reuse)

---

## Selection

Please select one:
- Type **"A"** for Next.js (recommended, free, familiar)
- Type **"B"** for Astro (best performance, content-focused)
- Type **"C"** for Remix (edge-first, no cold starts)
- Type **"Other"** to view 3 other options (ranks 4-6)

Stack decision LOCKS after selection. Changes later = +2 weeks timeline impact.

⚠️ WAITING FOR SELECTION...
```

**User responds**: "Option A" or "I choose Option B"

---

### Stack Validation Gate (MANDATORY After User Selection)

**After user selects stack option, agent validates decision against context and flags mismatches:**

#### Validation Checklist

**1. Team Expertise Alignment**
- [ ] Match confirmed: Team has experience with chosen stack
  - If NO: Document learning curve (estimated ramp-up time: X weeks)
  - Risk: Slower development, more bugs, dependency on external help

**2. Budget Reality Check**
- [ ] Cost validated: Monthly cost fits within budget (Question 2)
  - Selected stack cost: $X/month
  - User budget: $Y/month
  - If X > Y: Flag overage, propose cost reduction options

**3. Scale Appropriateness**
- [ ] Not over-engineering: Stack complexity matches scale (Question 3)
  - Scale: <100 users → Simple stack recommended (monolith, managed services)
  - Scale: 100-1K users → Monolith + caching usually sufficient
  - Scale: 1K-10K users → May need caching, read replicas (measure first)
  - Scale: 10K+ users → Likely needs load balancing, CDN (based on metrics)
  - **Red flag**: Premature optimization (Kafka for <100 users)

**4. Timeline Feasibility**
- [ ] Delivery realistic: Setup time + development fits timeline (Question 4)
  - Stack setup time: X days
  - Development time estimate: Y days
  - User timeline: Z days
  - If (X + Y) > Z: Flag unrealistic, propose simpler stack or extend timeline

**5. Maintenance Capacity**
- [ ] Ops burden acceptable: Team can maintain chosen stack (Question 5)
  - Self-hosted (DigitalOcean Droplet): Requires SSH, OS updates, backups
  - Managed (Vercel, Supabase): Minimal ops, auto-updates
  - If solo dev + self-hosted: Warn about ops burden (varies by stack)

**6. Integration Compatibility**
- [ ] Third-party support: Required integrations available (Question 6)
  - Payment gateway SDKs exist for chosen backend language
  - Email service compatible with chosen stack
  - Example: Stripe has official SDKs (Node.js, PHP, Python, Go)

**7. Compliance Feasibility**
- [ ] Regulatory match: Stack supports compliance requirements (Question 8)
  - HIPAA/ISO27001: Need audit logs, encryption at rest, access controls
  - PDP Law: User consent management, data deletion endpoints
  - If compliance required: Validate chosen DB/hosting has compliance certs

**8. Module 04 Handoff Strategy Validated**
- [ ] Prototype conversion feasible: Clear path from design specs to chosen stack
  - Direct copy (React → Next.js): 1 day
  - Syntax conversion (React → Vue): 3-4 days
  - Template rewrite (React → Blade): 5-7 days
  - Document in FSD.md "Module 04 Handoff Strategy" section

---

#### Validation Outcomes

**Pass (Green Light)** ✅:
- All 8 checks pass
- Action: Proceed to FSD.md generation with chosen stack

**Conditional Pass (Yellow Flag)** ⚠️:
- 1-2 checks have warnings (e.g., learning curve, tight timeline)
- Action: Flag warnings to user, document in FSD.md
- User decision: Proceed with acknowledgment or re-select stack

**Fail (Red Flag)** ❌:
- Multiple critical mismatches (budget overage >2x, compliance gap, technical impossibility)
- Action: Strongly recommend re-selection, explain risks
- User decision: Override and proceed (at own risk) or re-select
- Examples:
  - User budget $0, selected AWS stack ($50/month) → Fail
  - HIPAA required, selected Vercel Hobby (no BAA) → Fail
  - Solo dev, selected self-hosted Kubernetes → Fail (over-engineering)

**Agent flags mismatches but user has final decision. Document acknowledged risks in FSD.md.**

**Reference**: See `references/stacks/STACK_DECISION_METRICS.md` for detailed tradeoff analysis per stack combination.

---

### Handling "Other" Request (Ranks 4-6)

If user types "Other":

```markdown
## Alternative Options (Ranks 4-6):

### Option D: SvelteKit + Vercel (Score: 95.4/100)
- Similar to Next.js but uses Svelte (compile-time framework)
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

Choose D/E/F or "Back" to return to top 3.
```

The user can iterate until satisfied, or request a custom stack:

```
User: "How about Go + HTMX?"
Agent: [Re-score with Go Fiber + HTMX]
  Score: 67.2/100
  - Expertise: 4/40 (no Go experience) ❌
  - Budget: 18/20 ($5/month Fly.io)
  - Feature: 7/10 (HTMX partial SSR)
  
  Recommendation: NOT recommended for a JS-only team. Go learning curve 4-8 weeks.
  
  Proceed anyway? (Y/N)
```

---

## 4. Module 04 Prototype → Module 06 Handoff Strategy

**Problem**: The Design prototype (Module 04) is generated in a specific format (React/HTML), but the user selects a different stack (Laravel/Vue/Django).

**Solution**: Define the conversion strategy in FSD based on the stack compatibility level.

### Compatibility Levels:

#### **Level 1: Direct Copy (React-Based Stacks)**

**Applicable When**: User selects Next.js, Remix, Gatsby, Create React App

**Strategy**:
1. Export Prototype code (React + Tailwind)
2. Copy components directly into `components/` folder
3. Minimal refactoring:
   - Import paths adjustment
   - Component file structure (one component per file)
   - Add TypeScript types (if Prototype generated vanilla JS)

**Conversion Effort**: 1 day
**Conversion Rate**: 95% code reuse

**Example**:
```typescript
// component export (single file)
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

**Applicable When**: User selects Vue, Svelte, Solid, Preact

**Strategy**:
1. Extract component structure from design specs
2. Convert JSX → framework syntax
3. Keep Tailwind classes identical (design system preserved)
4. Rewrite state management (React hooks → Vue Composition API / Svelte stores)

**Conversion Effort**: 3-4 days (18 screens)
**Conversion Rate**: 70% structure reuse, 100% design reuse

**Example**:
```vue
<!-- component export (React JSX) -->
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
- `react-to-vue`: CLI tool to convert JSX → Vue SFC
- Manual review required (80% accuracy, requires fixes)

---

#### **Level 3: Template Rewrite (Server-Side Rendering)**

**Applicable When**: User selects Laravel Blade, Django Templates, Rails ERB, PHP

**Strategy**:
1. Design prototype = **visual reference only** (do not extract code)
2. Identify layout patterns:
   - Header (logo, nav, user menu)
   - Sidebar (if applicable)
   - Main content area (cards, tables, forms)
   - Footer
3. Rewrite as server-side templates using framework syntax
4. Extract Tailwind classes from design specs → copy to templates
5. Design tokens (DESIGN.md) → apply manually

**Conversion Effort**: 5-7 days (18 screens)
**Conversion Rate**: 0% code reuse, 100% design reuse (visual parity)

**Example**:
```blade
{{-- component export (React JSX) - reference only --}}
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

**Applicable When**: User selects Laravel + Inertia.js, Rails + Hotwire Turbo

**Strategy**:
1. Backend: Laravel/Rails (API routes, Eloquent/ActiveRecord)
2. Frontend: Keep Vue/React components from design specs
3. Glue layer: Inertia.js wires Vue components to Laravel routes
4. Conversion effort same as Level 2 (syntax conversion)

**Conversion Effort**: 3-4 days (frontend) + 2-3 days (backend wiring)
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
<!-- resources/js/Pages/Dashboard.vue (from design specs) -->
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

### FSD Documentation Requirement (Step 5):

**Section: "Module 04 Handoff Strategy"** in FSD.md must include:

```markdown
## Module 04 Prototype Conversion Strategy

**Chosen Stack**: [Laravel + Inertia.js + Vue 3]
**Compatibility Level**: Level 4 (Hybrid)

**Conversion Plan**:
1. Extract 18 Vue components from design specs export
2. Setup Inertia.js in Laravel project (ziggy routes, Vite config)
3. Create Laravel routes for every page (map SITEMAP.md → web.php)
4. Wire Vue components to Inertia::render() calls
5. Copy Tailwind config from DESIGN.md → tailwind.config.js
6. Test component rendering (ensure props match backend data structure)

**Estimated Conversion Time**: 5-7 days
- Day 1-2: Inertia.js setup + first 5 pages
- Day 3-4: Remaining 13 pages + component library
- Day 5: Polish (responsive, dark mode if applicable)
- Day 6-7: Testing + fixes

**Design System Preservation**:
- ✅ Tailwind classes preserved (bg-white, rounded-lg, shadow-sm, etc)
- ✅ Color palette from DESIGN.md applied (primary: #0891B2)
- ✅ Typography (Inter font, weights 400/600)
- ✅ Spacing scale (4/8/16/24/32px)

**Deviations from design specs Prototype** (if any):
- None expected (visual parity maintained)
- If deviations occur: Document in Module 06 change log
```

---

## 5. Step-by-Step Execution

### Step 1: Database Schema Design & DDL Integrity
1. Identify all data entities from forms in `DESIGN_SPEC.md`.
2. Write the complete relational schema in standard SQL DDL format.
3. Lock data integrity at the database level:
   - Use `UUIDv7` or `BIGINT` for Primary Keys.
   - **Monetary Precision**: Always use `BIGINT` for currency amounts (stored in smallest currency unit / full Rupiah). Avoid `FLOAT` or `DOUBLE` rounding traps.
   - **Quantity Precision**: Use `NUMERIC(12, 3)` for inventory/quantities to support fractional decimal units (kg, liters, metrics).
   - **100% Foreign Key Indexing**: Every column with `REFERENCES table(id)` MUST have an explicit `CREATE INDEX` to prevent full table scans under load.
   - **Strict Arithmetic CHECK Constraints**: Enforce domain validation at database level (e.g., `CHECK (net_amount = subtotal_amount - discount_amount)`, `CHECK (quantity > 0)`).
   - **Append-Only Movement Ledger**: Financial mutations and stock changes are logged as immutable event records in a movement ledger; current balances act as cached projections.
   - Set up `FOREIGN KEY` constraints with `ON DELETE RESTRICT` (never allow wild, untracked cascading deletions on transaction/ledger records).
   - **Idempotency Response Cache**: Create an `idempotency_keys` table to store server response payloads and prevent duplicate processing on network retries.

### Step 2: API Contract Mapping
Every action button on the interface must have a corresponding API endpoint defined in standard format:
- **Method & Route**: `POST /api/v1/documents`
- **Headers**:
  ```http
  Authorization: Bearer <TOKEN>
  Content-Type: application/json
  X-Idempotency-Key: <UUID>
  ```
- **JSON Request Payload**: Schema of input fields with data types and validation rules.
- **Success & Error Response**: Uniform format (`status`, `data`, `error: { code, message }`).

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
- [ ] Install OpenAPI generation library matching chosen stack
- [ ] Configure base info (title, version, servers, auth schemes)
- [ ] Annotate 100% public-facing endpoints (priorities: auth, core CRUD, webhooks)
- [ ] Generate spec: `pnpm swagger` / `php artisan l5-swagger:generate` / automatic
- [ ] Verify Swagger UI accessible (`/api/docs` or `/api/documentation`)
- [ ] Export `openapi.json` to `docs/specs/openapi.json` for version control
- [ ] Add to M06 development checklist: "Update OpenAPI annotations when adding endpoints"

**When to Skip OpenAPI**:
- ❌ Internal-only API with <5 endpoints
- ❌ GraphQL API (use GraphQL introspection instead)
- ❌ tRPC (TypeScript end-to-end type safety, no need for OpenAPI)
- ❌ MVP <4 weeks with zero external API consumers

**Benefits**:
- ✅ Auto-generated client SDKs (TypeScript, Python, Go) via `openapi-generator`
- ✅ API testing tools (Postman, Insomnia) can import OpenAPI spec
- ✅ Contract testing (Pact, Dredd) validates implementation vs spec
- ✅ Frontend devs can mock API responses during parallel development

---

### Step 3: Built-in Security Architecture & Database Isolation
Lock security protocols before writing code:
1. **Multi-Tenant RLS Coverage (100%)**:
   - Every tenant table without exception must declare `ALTER TABLE ... ENABLE ROW LEVEL SECURITY;`.
   - Implement role-differentiated policies for `SELECT`, `INSERT`, `UPDATE`, `DELETE`. Indiscriminate `FOR ALL` policies are strictly prohibited.
2. **Hardened `SECURITY DEFINER` Helper Functions**:
   - All helper functions reading auth state or organization mapping must explicitly declare `SET search_path = public, pg_temp STABLE` to prevent search-path privilege escalation exploits.
3. **Atomic Stored Procedures with Row-Locking**:
   - Critical multi-step mutations (checkout, payment settlement, inventory reduction) MUST be encapsulated in PostgreSQL RPC functions.
   - Enforce row-locking using `SELECT ... FOR UPDATE` on inventory/balance records to eliminate concurrent race conditions and overselling.
   - Server-Side Valuation: Calculate line-item totals directly from server master pricing to prevent browser client tampering.
4. **Database-View Data Masking (Anti-Leakage)**:
   - Sensitive fields (cost prices, gross margins, employee salaries) must be excluded at the database view projection level (e.g., `products_cashier_view`), never relying solely on frontend UI hiding.
5. **Immutable Audit Logging**:
   - `audit_logs` table must be protected with only `SELECT` and `INSERT` policies. `UPDATE` and `DELETE` are denied by default.
6. **Sensitive Document Storage (Vault)**:
   - PDF document files must be encrypted before entering cloud storage using AES-256-GCM. Encryption keys are managed separately (*Key Management Service*).
   - **KMS Implementation Ladder by Scale**:
     - **Small**: Environment variables (`process.env.ENCRYPTION_KEY`) + AWS Secrets Manager basic
     - **Medium**: HashiCorp Vault (self-hosted or HCP) with key rotation
     - **Large**: AWS KMS / GCP Cloud KMS with envelope encryption
     - **Enterprise**: Hardware Security Module (HSM) + FIPS 140-2 compliance
   - Document download links must use *Presigned URLs* with a maximum expiration of 15 minutes.
7. **Authentication & Passwords**:
   - Passwords must be hashed using **Argon2id** (or bcrypt with cost factor ≥12).
   - Session tokens are stored in `HttpOnly, Secure, SameSite=Strict` cookies to prevent token theft via Cross-Site Scripting (XSS) attacks.
8. **Request Rate Limiting**:
   - Sensitive endpoints (Login, Send OTP, Checkout) are protected by rate limiting (example: max 5 attempts per IP in 15 minutes).

### Step 4: PRD & FSD Document Preparation

Use `templates/03-architecture-specs/PRD_FINAL_TEMPLATE.md` to draft **`docs/specs/PRD.md`** and `templates/03-architecture-specs/FSD_TECHNICAL_TEMPLATE.md` for **`docs/specs/FSD.md`**.

#### PRD Architectural Requirements (The 7 Core Components)
Every `PRD.md` bridges business scope into robust technical reality. The architecture is **domain-neutral and scales across all software types** (CRM, CMS, HRIS, E-commerce, Fintech, SaaS, Developer Tools). Domain-specific modules (POS hardware, stock opname, statutory tax) are applied conditionally when present in `SCOPE_STATEMENT.md`, or marked N/A with reasoned justification for other domains.

1. **Functional Traceability Matrix (Universal)**: Complete mapping of every feature (`F-xx`) from `SCOPE_STATEMENT.md` to an explicit Technical Requirement ID (`REQ-xx`) and Screen ID (`SCR-xx`). Zero untracked features.
2. **Append-Only Ledger & State Architecture (Universal)**: Direct un-audited in-place balance overwrites (`UPDATE ... SET balance = balance - 1`) are strictly prohibited. State transitions and balance mutations are recorded as immutable event logs (e.g., `inventory_movements`, `audit_logs`, `deal_stage_history`, or `content_revisions`), with current state acting as a cached read-model projection.
3. **Idempotency & Interaction Safety (Universal)**:
   - State-changing mutation requests (payments, publish events, lead status updates) transmit a unique `idempotency_key` (UUID v4) enforced by database constraints to prevent duplicate processing.
   - Offline/disconnected sequencing: Define isolated device sequencing where multi-terminal offline operation is in scope (`[NODE]-[DEVICE]-[YYYYMMDD]-[SEQ]`).
   - Keyboard safety: Common entry keys (`Enter`) must not trigger premature final checkout or irreversible actions.
4. **Domain Logic Defense & Workflow Integrity (Domain-Conditional)**:
   - *Retail / Commerce Scope*: Two-phase opname blind count (physical count screens omit system expected quantities from DOM to prevent confirmation bias; management variance review requires explanatory notes).
   - *CRM Scope*: Lead qualification gate rules, deal stage transition validation, activity logging without orphan contacts.
   - *CMS Scope*: Editorial workflow lifecycle (Draft $\rightarrow$ In Review $\rightarrow$ Scheduled $\rightarrow$ Published), revision diffing, slug collision prevention.
   - *Other Domains*: Document equivalent domain boundary defenses or mark N/A with rationale.
5. **Multi-Layer Security & Database-Level Isolation (Universal)**:
   - Sensitive fields (cost prices in retail, deal value in restricted CRM roles, salaries in HRIS) are protected via dedicated database views or query-layer selection, never by frontend UI hiding alone.
   - Multi-tenant / organizational data isolation enforced via RLS policies.
   - Spreadsheet/CSV exports sanitize formula injection characters (`=`, `+`, `-`, `@`, `\t`, `\r`).
6. **Statutory & Sector Regulatory Compliance (Domain-Conditional)**:
   - If tax or statutory calculations are in scope: Cite verified, date-checked legal citations (e.g., PPh Final UMKM PP 55/2022 jo. PP 20/2026 for commerce, PPh 21 TER PMK 168/2023 for HRIS payroll) with mathematical formulas.
   - Persistent in-app legal disclaimers protecting against liability or malpractice claims.
   - For non-statutory projects (e.g., standard CMS or developer tool): Mark N/A.
7. **Release Acceptance Criteria (Given-When-Then BDD — Universal)**:
   - All core functional modules, critical workflows, and boundary conditions must include formal BDD test scenarios.

#### PRD Automated Quality Validation Checklist
Before submitting `docs/specs/PRD.md`, the agent MUST verify:
- [ ] **1. Full Traceability**: 100% of Scope Statement features are mapped in Section 2 to Technical Requirement IDs (`REQ-xx`) and Screen IDs (`SCR-xx`).
- [ ] **2. Immutable Ledger / Event Journal**: Balance mutations and critical state changes use append-only event journals; direct un-audited overwrites are eliminated.
- [ ] **3. Mutation Idempotency**: State-changing requests enforce `idempotency_key` unique constraints, with keyboard shortcut safeguards against premature submission.
- [ ] **4. Domain Workflow Defense**: Operational failure modes (e.g. blind count for inventory, deal transition guards for CRM, content revision locks for CMS) are defended or marked N/A with rationale.
- [ ] **5. Database-Layer Security**: Sensitive fields are protected via database views/queries, with tenant-scoped RLS and CSV formula injection sanitization.
- [ ] **6. BDD Acceptance Scenarios**: Core business workflows and critical edge cases are specified in Given-When-Then format.
- [ ] **7. Verified Statutory Compliance (If Applicable)**: Applicable statutory formulas cite date-verified regulations with required disclaimers, or are marked N/A.

- **`FSD.md`**: Contains absolute technical details (ERD diagram, SQL DDL script, API contract table, transaction state machines, and audit logging).

#### FSD Automated Quality Validation Checklist
Before submitting `docs/specs/FSD.md`, the agent MUST verify:
- [ ] **1. Data Access & RLS Scoping**: Multi-tenant tables enforce appropriate row-level security policies (`ENABLE ROW LEVEL SECURITY;` with granular role policies), or reasoned single-tenant/internal N/A documented.
- [ ] **2. Hardened Security Definer**: All helper functions declare `SET search_path = public, pg_temp STABLE`.
- [ ] **3. Atomic Mutations with Concurrency Guards**: High-risk concurrent mutations (e.g. checkout, reservations, balance deductions, state transitions) are wrapped in atomic database transactions or RPC procedures with row-locking (`FOR UPDATE`), or marked N/A with rationale for standard low-concurrency CRUD.
- [ ] **4. Accurate Data Types**: Monetary amounts avoid floating-point types (`BIGINT` or `NUMERIC`), and quantities support domain-required fractional precision.
- [ ] **5. 100% Foreign Key Indexes**: Every column with a `REFERENCES` constraint has an explicit `CREATE INDEX`.
- [ ] **6. Immutable Audit Trail**: Event journals, movement ledgers, and `audit_logs` protect historical records against un-audited `UPDATE` and `DELETE` operations.

### Step 5: Technical Sign-Off with Client
1. Solo developer presents PRD & FSD documents to the **Client Single PIC** (or executes self-review for solo products).
2. Verify both the PRD and FSD Automated Quality Validation Checklists.
3. Client signs the technical specification approval sheet (*Technical Sign-off*).
4. Once the FSD is signed, the scope, data schema, and technical logic are officially locked.

---

## 4. Adaptation Based on Project Scale

| Aspect | Small Scale (MVP / Freelance) | Medium Scale (B2B SaaS / Agency) | Large Scale & Enterprise |
| :--- | :--- | :--- | :--- |
| **PRD Document** | Concise (3–5 pages) | Modular structured (10–20 pages) | Full Formal Enterprise PRD |
| **FSD Document** | Core table schemas & API routes | Complete FSD: ERD, SQL DDL, API contracts | In-depth FSD, RTM, Disaster Recovery SOP |
| **Database Schema** | 3–6 relational tables | 10–20 tables with versioned migrations | 30+ tables, data partitioning, sharding plan |
| **Security** | HTTPS, password hashing, RLS | S3 AES-256, JWT rotation, rate limiter | Zero-knowledge vault, HSM, ISO 27001 audit |
| **Approval** | Written confirmation via email/chat | Signed Technical Sign-off sheet | Formal Sign-off CAB (Change Advisory Board) |

---


---

- Re-generate affected sections
- Re-run GATE verification
- Display updated summary
- Wait for approval again

**If user approves**:
- Mark Module 05 complete
- Proceed to Module 06 (Development Implementation)

---

## 7. System Design & Infrastructure Scalability [M05B - Enterprise Extension]

> 🎯 **WHEN TO USE THIS SECTION?**
> - **MANDATORY for Enterprise** projects (HA/DR, multi-AZ, capacity planning)
> - **Optional for Large** projects: MAU >10K, RPS >100, need HA/DR
> - **Skip for Small/Medium** projects (use base M05 PRD/FSD only)
> - **Viral growth expected**: Traffic spikes, auto-scaling required
> - **Real-time features**: WebSockets, streaming, sub-second latency
> - **Compliance**: Data residency, multi-region, audit trails
>
> **SKIP THIS SECTION IF:**
> - MVP <10K MAU with single VPS sufficient
> - Prototyping/POC without production load
> - PaaS handles scaling (Vercel/Railway auto-scale)

---

### 🔴 Enterprise Scale: Architecture & Infrastructure Templates

**When**: Budget >Rp 500M, 100K+ MAU, multi-region, SOC 2/ISO 27001 compliance

**Architecture Decision Records**:
- `templates/03-governance/ADR_TEMPLATE.md` - Document context, decision, consequences, alternatives
  - **Use for**: Database choice (PostgreSQL vs MongoDB), cloud provider (AWS vs GCP), microservices vs monolith
  - **Why**: Enterprise audits require architecture decision audit trail

**Infrastructure as Code**:
- `templates/04-dev-execution/IAC_GUIDE.md` - Terraform/Pulumi/CloudFormation for AWS/GCP/Azure
  - **Use for**: Reproducible infrastructure provisioning (VPC, RDS, S3, IAM roles)
  - **Why**: SOC 2 requires version-controlled, auditable infrastructure changes

**Capacity Planning**:
- `templates/08-maintenance-ops/CAPACITY_PLANNING_GUIDE.md` - Scale projections (1K → 10K → 100K users)
  - **Use for**: Infrastructure cost estimates, auto-scaling triggers, database sharding thresholds
  - **Why**: Enterprise contracts demand capacity planning before signing

**Disaster Recovery**:
- `templates/08-maintenance-ops/DISASTER_RECOVERY_PLAN.md` - RTO/RPO targets, failover procedures
  - **Use for**: Multi-region failover, database replication, backup/restore testing
  - **Why**: Banking/healthcare require <4hr RTO, <1hr RPO (regulatory compliance)

**Service Levels**:
- `templates/08-maintenance-ops/SLA_SLO_DEFINITIONS.md` - 99.9% uptime, <200ms p95 latency, incident SLA
  - **Use for**: Contractual uptime guarantees, API latency targets, support response times
  - **Why**: Enterprise SLA penalties (downtime = refunds)

**Audit Logging**:
- `templates/03-governance/AUDIT_TRAIL_REQUIREMENTS.md` - Log auth, data access, config changes
  - **Use for**: CloudWatch/Splunk immutable audit logs, retention policies
  - **Why**: SOC 2/ISO 27001 require complete audit trail

**M05B Outputs** (Enterprise):
- `docs/specs/SYSTEM_DESIGN.md` (load balancing, caching, async workers, sharding)
- `docs/specs/CAPACITY_PLANNING.md` (cost projections, scaling thresholds)
- `docs/ops/DISASTER_RECOVERY.md` (RTO/RPO, backup procedures, failover runbook)
- `docs/architecture/decisions/*.md` (ADR files for major decisions)

---

**Objective**: Design scalable, reliable, performant infrastructure — boring tech, decision trees, explicit trade-offs.

---

### 6.1 Performance & Scalability Fundamentals

**Vertical vs Horizontal Scaling Decision Tree**:
```
MAU < 10K?     → Single VPS vertical ($24→$48/mo upgrade)
MAU 10K-100K?  → Horizontal app layer (2-3 instances) + DB read replica
MAU > 100K?    → Auto-scaling + CDN + caching mandatory
```

**CAP Theorem Trade-offs** (pick 2):
- **CP** (Consistency + Partition tolerance): Bank, payment, inventory
- **AP** (Availability + Partition tolerance): Social feed, analytics
- **CA** (Consistency + Availability): Single-region monolith (default solo dev)

**Performance Budgets**:
- **Core Web Vitals**: LCP <2.5s, FID <100ms, CLS <0.1
- **API Latency**: p50 <200ms, p95 <500ms, p99 <1s
- **Error Rate**: <0.1%

**Capacity Planning Formula**:
```
Max RPS = (Worker Count × Worker Throughput) / Safety Factor

Example Next.js Vercel:
- Workers: 0-100 auto-scale
- Throughput: ~50 RPS/instance
- Safety: 2× (50% headroom)
- Max sustained: 2500 RPS
```

---

### 6.2 Caching Strategy

**HTTP Caching Headers**:
```javascript
// Cache static assets 1 year
res.setHeader('Cache-Control', 'public, max-age=31536000, immutable');

// Cache API responses 5 minutes
res.setHeader('Cache-Control', 'public, max-age=300, s-maxage=3600');
```

**Redis Caching Patterns**:
```javascript
// Cache-aside pattern
async function getUser(id) {
  const cached = await redis.get(`user:${id}`);
  if (cached) return JSON.parse(cached);
  
  const user = await db.user.findUnique({ where: { id } });
  await redis.set(`user:${id}`, JSON.stringify(user), 'EX', 300);
  return user;
}
```

**CDN Strategy**:
- **Static assets**: Cloudflare/Vercel Edge (cache forever, immutable)
- **API responses**: Edge caching with `stale-while-revalidate`
- **Images**: On-demand optimization (Next.js Image, Cloudinary)

---

### 6.3 Database Optimization

**Index Strategy**:
```sql
-- Compound index for common queries
CREATE INDEX idx_orders_user_status ON orders(user_id, status, created_at);

-- Partial index for active records
CREATE INDEX idx_active_users ON users(email) WHERE deleted_at IS NULL;
```

**Query Optimization**:
- **N+1 Prevention**: Use `include`/`with` for eager loading
- **Pagination**: Cursor-based for large datasets (not offset/limit)
- **Read Replicas**: Route read queries to replicas (PostgreSQL streaming replication)

**Connection Pooling**:
```
Pool Size = (Core Count × 2) + Spindle Count
Example 4 vCPU + SSD: (4 × 2) + 1 = 9 connections/instance
```

---

### 6.4 High Availability & Disaster Recovery

**SLA Targets**:
| Uptime % | Downtime/year | Downtime/month | Solo Dev Realistic? |
|----------|---------------|----------------|---------------------|
| 99%      | 3.65 days     | 7.2 hours      | ✅ Yes (managed DB) |
| 99.9%    | 8.76 hours    | 43.2 minutes   | ✅ Yes (multi-AZ)   |
| 99.99%   | 52.6 minutes  | 4.32 minutes   | ❌ Needs team       |

**Backup Strategy**:
```bash
# Daily automated backups (Supabase/PlanetScale managed)
# 30-day retention
# Point-in-time recovery (PITR) last 7 days
```

**Health Checks**:
```javascript
// GET /api/healthz (liveness)
export function GET() {
  return Response.json({ status: 'ok' });
}

// GET /api/readyz (readiness)
export async function GET() {
  const dbOk = await prisma.$queryRaw`SELECT 1`;
  const redisOk = await redis.ping();
  return Response.json({ db: !!dbOk, redis: redisOk === 'PONG' });
}
```

---

### 6.5 Load Balancing & Auto-Scaling

**Load Balancer Options**:
- **PaaS**: Vercel/Railway (built-in, zero config)
- **DIY**: Nginx reverse proxy or Cloudflare Load Balancing
- **Enterprise**: AWS ALB/NLB with target groups

**Auto-Scaling Rules** (AWS/DigitalOcean):
```yaml
min_instances: 2
max_instances: 10
target_cpu: 70%
scale_up: +2 instances if CPU >70% for 5 minutes
scale_down: -1 instance if CPU <30% for 10 minutes
```

---

### 6.6 Monitoring & Observability

**Golden Signals**:
1. **Latency**: p50/p95/p99 response time
2. **Traffic**: RPS (requests per second)
3. **Errors**: 4xx/5xx rate
4. **Saturation**: CPU/memory/disk usage

**Monitoring Stack**:
- **APM**: Sentry Performance Monitoring ($26/mo)
- **Logs**: Vercel Logs (integrated) or BetterStack ($15/mo)
- **Metrics**: Grafana Cloud free tier or Prometheus self-hosted

**Alert Thresholds**:
```yaml
- p95_latency > 1s for 5 minutes → Page on-call
- error_rate > 1% for 5 minutes → Slack alert
- cpu_usage > 85% for 10 minutes → Auto-scale trigger
```

---

### 6.7 Security Hardening

**DDoS Protection**:
- Cloudflare Free tier (5 seconds under attack mode)
- Rate limiting: 100 req/min per IP (authenticated), 10 req/min (anonymous)

**WAF Rules** (Web Application Firewall):
- Block SQL injection patterns
- XSS prevention (CSP headers)
- CSRF token validation

**Secrets Management**:
```bash
# .env.production (encrypted at rest)
DATABASE_URL="postgresql://..."  # Supabase connection pooler
REDIS_URL="redis://..."          # Upstash Redis
SECRET_KEY="..."                 # Rotate every 90 days
```

---

### 6.8 Cost Optimization

**Solo Dev Budget Targets**:
- **<1K MAU**: $0-20/mo (free tier PaaS)
- **1K-10K MAU**: $20-100/mo (Vercel Pro + managed DB)
- **10K-50K MAU**: $100-300/mo (multi-instance + CDN)

**Cost Reduction Strategies**:
1. **Cold storage**: Move old data to S3 Glacier ($0.004/GB/mo)
2. **Aggressive caching**: CDN cache hit rate >90%
3. **Serverless functions**: Pay per invocation not per hour
4. **Reserved instances**: 40% discount for 1-year commit (AWS/DO)

---

### 6.9 Load Testing & Capacity Planning

**k6 Load Test Script**:
```javascript
import http from 'k6/http';

export let options = {
  stages: [
    { duration: '2m', target: 100 },  // Ramp-up
    { duration: '5m', target: 100 },  // Sustained
    { duration: '2m', target: 0 },    // Ramp-down
  ],
  thresholds: {
    http_req_duration: ['p(95)<500'],
    http_req_failed: ['rate<0.01'],
  },
};

export default function () {
  http.get('https://staging.example.com/api/health');
}
```

Run: `k6 run scripts/runtime/load-test.js`

---

### 6.10 Output Artifacts

| Artifact | Location | Purpose |
|----------|----------|---------|
| **System Design Doc** | `docs/specs/SYSTEM_DESIGN.md` | Infrastructure architecture, scaling strategy |
| **Load Test Report** | `docs/load-test/report.html` | Performance benchmarks, bottlenecks |
| **DR Runbook** | `docs/ops/DISASTER_RECOVERY.md` | Backup restoration, failover procedures |

**Template Sources**:
- `templates/03-architecture-specs/SYSTEM_DESIGN_DOC_TEMPLATE.md`
- `templates/03-architecture-specs/DISASTER_RECOVERY_PLAN_TEMPLATE.md`

---

### 6.11 Integration with Other Modules

| Module | Integration Point |
|--------|-------------------|
| **M05 (Architecture)** | FSD.md tech stack informs infrastructure choices |
| **M06 (Development)** | Performance budgets enforced via CI/CD |
| **M07 (QA)** | Load testing validates capacity planning |
| **M10 (Deployment)** | Auto-scaling policies deployed with app |
| **M12 (Warranty)** | SLA targets define support response times |

---

### 6.12 Gate Exit Criteria

Section 6 is declared **PASSED** if:
- [ ] Performance budgets documented (LCP, API latency targets)
- [ ] Caching strategy defined (HTTP headers, Redis patterns, CDN)
- [ ] Database optimization plan (indexes, read replicas, connection pooling)
- [ ] Monitoring setup (APM, logs, alert thresholds)
- [ ] Load test results validate capacity planning (k6 report)
- [ ] DR runbook created (backup restoration, failover procedures)

**END RESPONSE** and confirm:
> *"System design complete: Performance budgets set, caching strategy defined, monitoring configured. Load test report: p95 latency [X]ms, error rate [Y]%. Ready to proceed to M06 (Development)?"*

---
- Carry forward FSD.md + chosen stack as blueprint for coding
