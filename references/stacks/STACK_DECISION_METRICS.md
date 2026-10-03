# Tech Stack Decision Metrics

> **Purpose**: Quantitative comparison data for stack selection (speed, resource efficiency, costs).

**Last Updated**: 2026-10-03  
**Source**: Benchmarks from production deployments, vendor documentation, community data

---

## 1. Build Time Performance

| Stack | Cold Build | Incremental Build | Hot Reload | Dev Server Start |
|:------|:-----------|:------------------|:-----------|:-----------------|
| **Next.js 15** (Turbopack) | 8-15s | 300-800ms | 50-200ms | 1-2s |
| **Next.js 15** (Webpack) | 15-30s | 1-3s | 300-600ms | 2-4s |
| **Laravel 11** (PHP) | N/A (interpreted) | N/A | 100-300ms | <1s |
| **Django 5** (Python) | N/A (interpreted) | N/A | 200-500ms | 1-2s |
| **Go 1.23** | 2-5s | 300-1000ms | N/A | <1s |
| **Rails 7** | N/A (interpreted) | N/A | 500ms-2s | 3-8s |
| **Nuxt 3** | 10-20s | 500ms-1.5s | 100-400ms | 2-3s |
| **SvelteKit** | 5-12s | 200-800ms | 50-150ms | 1-2s |
| **Remix** | 8-18s | 400ms-1.2s | 100-300ms | 1-2s |
| **Astro 4** | 3-8s | 100-500ms | 50-200ms | <1s |

**Notes:**
- Times measured on medium project (~50 routes, ~200 components)
- Incremental = after first build, changing 1 file
- Hot reload = time from save to browser refresh

---

## 2. Runtime Performance

### Cold Start (Serverless)

| Stack | Vercel Edge | Vercel Serverless | AWS Lambda | Fly.io (VPS) |
|:------|:------------|:------------------|:-----------|:-------------|
| **Next.js 15** | 50-150ms | 300-800ms | 500ms-1.5s | Always warm |
| **Laravel 11** | N/A | N/A | 1-3s | Always warm |
| **Django 5** | N/A | N/A | 1-2s | Always warm |
| **Go 1.23** | N/A | 100-300ms | 200-600ms | Always warm |
| **Nuxt 3** | 100-200ms | 400ms-1s | 600ms-2s | Always warm |
| **Remix** | N/A | 400ms-1s | 700ms-2s | Always warm |

### Request Latency (p95)

| Stack | Simple GET | Database Query | API Aggregation | SSR Page |
|:------|:-----------|:---------------|:----------------|:---------|
| **Next.js 15** | 20-50ms | 50-150ms | 100-300ms | 200-500ms |
| **Laravel 11** | 30-80ms | 60-200ms | 150-400ms | 300-800ms |
| **Django 5** | 25-70ms | 50-180ms | 120-350ms | 250-700ms |
| **Go 1.23** | 5-15ms | 15-50ms | 30-120ms | N/A (SPA) |
| **Rails 7** | 40-100ms | 80-250ms | 200-500ms | 400ms-1s |

---

## 3. Resource Efficiency

### Memory Footprint (Production)

| Stack | Base Memory | Per Request | 1K Concurrent | 10K Concurrent |
|:------|:------------|:------------|:--------------|:---------------|
| **Next.js 15** | 50-100MB | +0.5-2MB | 512MB-1GB | 2-4GB |
| **Laravel 11** (PHP-FPM) | 30-50MB/worker | +5-15MB | 1-2GB (20 workers) | 8-16GB (100 workers) |
| **Django 5** (Gunicorn) | 40-80MB/worker | +8-20MB | 1.5-3GB (20 workers) | 10-20GB (100 workers) |
| **Go 1.23** | 15-30MB | +50-200KB | 128-256MB | 512MB-1GB |
| **Rails 7** (Puma) | 80-150MB/worker | +10-30MB | 2-4GB (20 workers) | 12-24GB (80 workers) |

### CPU Overhead

| Stack | Idle CPU | Light Load (10 req/s) | Heavy Load (100 req/s) |
|:------|:---------|:----------------------|:-----------------------|
| **Next.js 15** | <5% | 10-20% | 40-70% |
| **Laravel 11** | <5% | 15-30% | 50-80% |
| **Django 5** | <5% | 12-25% | 45-75% |
| **Go 1.23** | <2% | 5-10% | 20-40% |
| **Rails 7** | <8% | 20-35% | 60-90% |

**Test environment**: 2 vCPU, 4GB RAM VPS

### Concurrent Connection Capacity

| Stack | Max Concurrent (2GB RAM) | Max Concurrent (4GB RAM) | Notes |
|:------|:-------------------------|:-------------------------|:------|
| **Next.js 15** | 500-1,000 | 2,000-4,000 | Event loop, non-blocking I/O |
| **Laravel 11** | 100-200 | 200-400 | Worker-based, blocking I/O |
| **Django 5** | 150-300 | 300-600 | Worker-based, async available |
| **Go 1.23** | 5,000-10,000 | 20,000-50,000 | Goroutines, highly concurrent |
| **Rails 7** | 80-150 | 150-300 | Worker-based, high memory per worker |

---

## 4. Development Velocity

### Time to First Feature (Solo Developer)

| Stack | Setup | Auth | CRUD | Deploy | Total (MVP) |
|:------|:------|:-----|:-----|:-------|:------------|
| **Next.js 15** | 1h | 4h | 8h | 2h | 2-3 days |
| **Laravel 11** | 1h | 2h | 6h | 3h | 2 days |
| **Django 5** | 1.5h | 3h | 8h | 3h | 2-3 days |
| **Go 1.23** | 2h | 6h | 12h | 2h | 3-4 days |
| **Rails 7** | 1h | 1h | 4h | 3h | 1-2 days |

**Assumptions**: Experienced developer, standard features, no design complexity

### Learning Curve (Junior Developer)

| Stack | Beginner Productive | Intermediate | Advanced | Ecosystem Mastery |
|:------|:-------------------|:-------------|:---------|:------------------|
| **Next.js 15** | 2-3 weeks | 2-3 months | 6-12 months | 1-2 years |
| **Laravel 11** | 1-2 weeks | 1-2 months | 4-8 months | 1 year |
| **Django 5** | 2-3 weeks | 2-4 months | 6-12 months | 1-2 years |
| **Go 1.23** | 3-4 weeks | 3-6 months | 8-12 months | 1.5-2 years |
| **Rails 7** | 1-2 weeks | 1-2 months | 4-8 months | 1 year |

---

## 5. Hosting & Operational Costs

### Monthly Hosting (Small App: <1K users, <10K req/day)

| Stack | Free Tier | Budget ($5-10) | Standard ($20-50) | Notes |
|:------|:----------|:---------------|:------------------|:------|
| **Next.js 15** | Vercel Hobby (free) | Vercel Pro $20 | Vercel Team $50 | Includes CDN, edge |
| **Laravel 11** | N/A | DigitalOcean $6 | Forge $12 + DO $12 | Requires VPS |
| **Django 5** | Fly.io free tier | Railway $5 | Fly.io $15-30 | Postgres extra $5-10 |
| **Go 1.23** | Fly.io free tier | Fly.io $5-10 | Railway $20 | Tiny binary, cheap |
| **Rails 7** | Heroku eco $5 | Heroku Basic $7 | Heroku Standard $25 | Includes Postgres |

### Monthly Hosting (Medium App: 10K users, 500K req/day)

| Stack | Minimum | Recommended | Enterprise | Notes |
|:------|:--------|:------------|:-----------|:------|
| **Next.js 15** | $50 (Vercel) | $150 (Vercel Pro) | $500+ (Vercel Enterprise) | Scales automatically |
| **Laravel 11** | $24 (2GB VPS) | $48 (4GB + cache) | $200+ (load balancer) | Manual scaling |
| **Django 5** | $30 (Railway) | $80 (dedicated) | $300+ (K8s) | Needs separate cache/queue |
| **Go 1.23** | $12 (1GB VPS) | $24 (2GB VPS) | $100+ (managed) | Very efficient |
| **Rails 7** | $50 (Heroku) | $100 (Heroku) | $400+ (Heroku) | Memory hungry |

### Database Costs (Managed PostgreSQL 16)

| Provider | Hobby | Production | High Availability | Storage |
|:---------|:------|:-----------|:------------------|:--------|
| **Supabase** | Free (500MB) | $25 (8GB) | $100 (custom) | $0.125/GB |
| **Neon** | Free (3GB) | $19 (unlimited) | $69 (HA) | Included |
| **Railway** | $5 (1GB) | $15 (5GB) | Custom | $0.25/GB |
| **DigitalOcean** | $15 (1GB/10GB) | $30 (2GB/25GB) | $60 (HA) | Included |
| **RDS** (AWS) | $13 (db.t3.micro) | $60 (db.t3.small) | $120+ (Multi-AZ) | $0.10/GB |

---

## 6. Licensing & Tool Costs

### Framework & Core Libraries

| Stack | Framework | UI Library | ORM | Queue/Jobs | Total/Year |
|:------|:----------|:-----------|:----|:-----------|:-----------|
| **Next.js 15** | Free (MIT) | shadcn Free | Prisma Free (<100K rows) | Inngest Free | $0 |
| **Laravel 11** | Free (MIT) | Free | Eloquent Free | Queue Free | $0 |
| **Django 5** | Free (BSD) | Free | Django ORM Free | Celery Free | $0 |
| **Go 1.23** | Free (BSD) | N/A | GORM Free | Free | $0 |
| **Rails 7** | Free (MIT) | Free | ActiveRecord Free | Sidekiq Free* | $0-179 |

*Sidekiq Pro $179/year for advanced features

### Commercial Tooling (Optional but Common)

| Category | Tool | Cost | Alternative (Free) |
|:---------|:-----|:-----|:-------------------|
| **Error Tracking** | Sentry | $26-80/mo | OpenTelemetry + self-hosted |
| **APM** | New Relic | $49-99/mo | Prometheus + Grafana |
| **Email** | Resend | $20/mo (50K) | Amazon SES ($0.10/1K) |
| **Search** | Algolia | $0-1,500/mo | Meilisearch (self-hosted) |
| **CI/CD** | GitHub Actions | $0-21/mo | Self-hosted runners |
| **Monitoring** | Datadog | $15-31/host | Grafana Cloud free tier |

### Developer Labor Cost (Market Rates 2026, Remote)

| Stack | Junior ($) | Mid ($) | Senior ($) | Availability |
|:------|:-----------|:--------|:-----------|:-------------|
| **Next.js 15** | $40-60/h | $70-100/h | $120-180/h | High |
| **Laravel 11** | $30-50/h | $60-90/h | $100-150/h | High |
| **Django 5** | $40-60/h | $70-100/h | $110-160/h | Medium |
| **Go 1.23** | $50-70/h | $90-130/h | $140-200/h | Medium-Low |
| **Rails 7** | $35-55/h | $65-95/h | $100-140/h | Medium |

---

## 7. Deployment Time

| Stack | Initial Deploy | Update Deploy | Rollback | Zero-Downtime |
|:------|:---------------|:--------------|:---------|:--------------|
| **Next.js 15** | 2-5 min | 1-3 min | Instant | ✅ (Vercel) |
| **Laravel 11** | 5-10 min | 2-5 min | 1-2 min | ⚠️ (manual) |
| **Django 5** | 3-8 min | 2-4 min | 1-2 min | ⚠️ (needs setup) |
| **Go 1.23** | 2-4 min | 1-2 min | 30s-1 min | ✅ (small binary) |
| **Rails 7** | 5-15 min | 3-8 min | 2-3 min | ⚠️ (manual) |

---

## 8. Decision Matrix

Use these metrics to score stacks in Module 05's weighted evaluation:

### Speed Priority (Build + Runtime)
1. **Go** (fastest runtime, fast builds)
2. **Astro** (fastest builds)
3. **SvelteKit** (fast builds, good runtime)
4. **Next.js** (Turbopack fast, good runtime)
5. **Django** (interpreted, decent runtime)

### Budget Priority (Total Cost of Ownership)
1. **Go** (cheapest hosting, efficient)
2. **Next.js** (free tier generous)
3. **Laravel** (cheap VPS)
4. **Django** (moderate hosting)
5. **Rails** (expensive hosting + memory)

### Complexity Priority (Learning Curve + Velocity)
1. **Rails** (fastest MVP)
2. **Laravel** (conventions, batteries included)
3. **Next.js** (good DX, modern)
4. **Django** (admin, mature)
5. **Go** (more boilerplate, typed)

### Resource Efficiency (Concurrent Users per $)
1. **Go** (10K+ connections on 2GB)
2. **Next.js** (2K connections on 2GB)
3. **Django** (300 connections on 2GB)
4. **Laravel** (200 connections on 2GB)
5. **Rails** (150 connections on 2GB)

---

## References

- [Next.js Benchmarks](https://nextjs.org/docs)
- [TechEmpower Benchmarks](https://www.techempower.com/benchmarks/)
- [Cloud Provider Pricing](https://instances.vantage.sh/)
- Production telemetry from 50+ solo projects (2024-2026)

---

**Note**: Metrics are approximations based on typical use cases. Actual performance varies by implementation quality, caching strategy, database optimization, and infrastructure configuration.
