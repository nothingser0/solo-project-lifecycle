# Tool Alternatives Matrix

> **Purpose**: Prevent framework decay when tools deprecate or pricing changes  
> **Status**: Alternatives verified as of 2026-10-02

---

## Design & Prototyping

### UI Component Libraries
| Tool | Status | Pricing | Alternative | Migration Path |
|------|--------|---------|-------------|----------------|
| **Google Stitch** | ❌ Deprecated 2024 | Free | v0.dev (Vercel) | Export JSX → v0.dev prompt |
| | | | shadcn/ui | Manual component port |
| | | | Tailwind UI | Copy examples ($299 one-time) |
| **v0.dev** | ✅ Active | Free tier | Bolt.new | Export code → Bolt import |
| **shadcn/ui** | ✅ Active | Free (MIT) | Radix UI (primitive) | Already using Radix underneath |
| **Tailwind UI** | ✅ Active | $299 one-time | shadcn/ui | Rebuild from free components |

**Recommendation**: Use shadcn/ui (free, no lock-in, CLI-driven)

---

### Design Tokens & Style Dictionary
| Tool | Status | Pricing | Alternative | Migration Path |
|------|--------|---------|-------------|----------------|
| **Style Dictionary** | ✅ Active | Free (Apache) | Theo (Salesforce) | JSON format compatible |
| **Figma Tokens** | ✅ Active | Free | Token Studio | Export JSON → import |
| **Diez** | ⚠️ Low activity | Free | Style Dictionary | Custom transformer |

**Recommendation**: Style Dictionary (industry standard, framework-agnostic)

---

## Analytics & Product Instrumentation

### Product Analytics
| Tool | Status | Pricing 2026 | Alternative | Migration Path |
|------|--------|--------------|-------------|----------------|
| **Mixpanel** | ✅ Active | $25/mo (10K MTU) → $999/mo (100K MTU) | Plausible Analytics | Export events → custom ETL |
| | | Spike at scale | PostHog (self-hosted) | SDK swap (~4 hours) |
| | | | Umami (self-hosted) | Lighter weight, no funnel |
| **Amplitude** | ✅ Active | Free tier 10M events/mo | Mixpanel | Compatible SDK |
| | | $49/mo starter | PostHog | SDK migration guide |
| **PostHog** | ✅ Active | Free (self-hosted) | N/A (self-host recommended) | - |
| | | $0.00031/event (cloud) | | |
| **Plausible** | ✅ Active | $9/mo (10K pageviews) | Umami (self-hosted) | Lighter, no user tracking |
| **Google Analytics 4** | ✅ Active | Free | Plausible | Privacy-focused alternative |

**Pricing Reality Check**:
- Mixpanel free tier: 10K MTU (Monthly Tracked Users)
- At 50K users: ~$500-800/mo (not $25/mo as documented in M06B)
- PostHog self-hosted: $0/mo (but need server maintenance)

**Recommendation for MVPs**: 
- Start: Google Analytics 4 (free, easy)
- At product-market fit: PostHog self-hosted (cost-effective at scale)
- Enterprise: Mixpanel (if budget allows)

---

### Error Tracking
| Tool | Status | Pricing 2026 | Alternative | Migration Path |
|------|--------|--------------|-------------|----------------|
| **Sentry** | ✅ Active | Free (5K errors/mo) | GlitchTip (self-hosted) | Sentry-compatible API |
| | | $26/mo (50K errors) | Bugsnag | SDK swap |
| | | $80/mo (250K errors) | Rollbar | SDK swap |
| **GlitchTip** | ✅ Active | Free (self-hosted) | Sentry | Drop-in replacement |
| **Rollbar** | ✅ Active | $49/mo (50K errors) | Sentry | Similar pricing |

**Recommendation**: Sentry free tier sufficient for most solo dev projects

---

## Hosting & Infrastructure

### Platform-as-a-Service (PaaS)
| Tool | Status | Pricing 2026 Reality | Alternative | Migration Path |
|------|--------|---------------------|-------------|----------------|
| **Railway** | ✅ Active | $5/mo claimed → **Reality: $20-50/mo** production | Coolify (self-hosted) | Dockerfile deploy |
| | | $0.000231/GB-hour (usage-based) | Dokploy (self-hosted) | Docker Compose |
| | | Spikes common | Render | Similar pricing |
| **Vercel** | ✅ Active | Free (hobby) | Netlify | Git push deploy |
| | | $20/mo (Pro) → $150/mo+ at scale | Cloudflare Pages | Next.js compatible |
| **Render** | ✅ Active | Free tier (slow spin-up) | Railway | Similar UX |
| | | $7/mo (512MB RAM) | Fly.io | Better pricing |
| **Fly.io** | ✅ Active | $1.94/mo (256MB RAM) | Railway | Dockerfile deploy |
| | | $3.88/mo (512MB RAM) | | |

**Cost Reality**:
- Railway "~$5/mo" → actual $20-50/mo with DB + Redis
- Vercel free tier → bandwidth overage charges common
- Self-hosted: $12-24/mo DigitalOcean Droplet via Coolify/Dokploy

**Recommendation**: 
- MVP: Vercel free tier (frontend) + Supabase free tier (backend)
- Scale: Self-host via Coolify on $12/mo Hetzner VPS

---

### Self-Hosted PaaS (Heroku Alternative)
| Tool | Status | Pricing | Features | Migration Path |
|------|--------|---------|----------|----------------|
| **Coolify** | ✅ Active | Free (self-host on VPS) | Docker, Git deploy, SSL auto | Import Dockerfile |
| **Dokploy** | ✅ Active | Free (self-host) | Simpler than Coolify | Docker Compose |
| **CapRover** | ✅ Active | Free (self-host) | Heroku-like UX | One-click apps |

**VPS Providers** (for self-hosting):
- Hetzner: €4.51/mo (CAX11 ARM, 2 vCPU, 4GB RAM) - Best value
- DigitalOcean: $12/mo (2GB RAM) - Easier for beginners
- Vultr: $6/mo (1GB RAM, NVMe)

**ROI**: Self-host saves $100-200/mo at scale vs Railway/Render

---

## Database

### Managed PostgreSQL
| Tool | Status | Pricing 2026 | Alternative | Migration Path |
|------|--------|--------------|-------------|----------------|
| **Supabase** | ✅ Active | Free (500MB, 2 concurrent) | Neon | pg_dump → restore |
| | | $25/mo (8GB, 60 concurrent) | Railway Postgres | |
| **Neon** | ✅ Active | Free (3GB, serverless) | Supabase | pg_dump → restore |
| | | $19/mo (10GB, autoscaling) | | |
| **Railway Postgres** | ✅ Active | $5/mo + usage | Self-host | pg_dump → VPS |
| **DigitalOcean Managed** | ✅ Active | $15/mo (1GB RAM) | Self-host | pg_dump → VPS |

**Recommendation**: 
- MVP: Supabase free tier
- Production: Neon (better scaling) or self-host ($12/mo VPS)

---

### Redis / Cache
| Tool | Status | Pricing 2026 | Alternative | Migration Path |
|------|--------|--------------|-------------|----------------|
| **Upstash Redis** | ✅ Active | Free (10K commands/day) | Valkey (self-hosted) | Drop-in Redis replacement |
| | | $0.2/100K commands | Redis (self-hosted) | |
| **Redis Cloud** | ✅ Active | Free (30MB) | Upstash | Compatible |
| | | $5/mo (100MB) | | |
| **Valkey** | ✅ Active | Free (self-hosted) | N/A | Fork of Redis 7.2 |

**Recommendation**: Upstash free tier → Valkey self-hosted at scale

---

## Payment Gateways

### Indonesia Payment
| Tool | Status | Pricing 2026 | Alternative | Migration Path |
|------|--------|--------------|-------------|----------------|
| **Midtrans** | ✅ Active | 2.9% + Rp 0 | Xendit | SDK swap (~2 hours) |
| **Xendit** | ✅ Active | 2.9% + Rp 0 | Midtrans | Similar API |
| **Doku** | ✅ Active | 3.0% + Rp 0 | Midtrans | SDK different |

### International Payment
| Tool | Status | Pricing 2026 | Alternative | Migration Path |
|------|--------|--------------|-------------|----------------|
| **Stripe** | ✅ Active | 2.9% + $0.30 | Paddle | SDK swap |
| | | Rp 3.9% + Rp 3000 (Indonesia) | Lemon Squeezy | |
| **Paddle** | ✅ Active | 5% + $0.50 | Stripe | Handles VAT/tax |
| **Lemon Squeezy** | ✅ Active | 5% + $0.50 | Paddle | SaaS-focused |

**Recommendation**: 
- Indonesia-only: Midtrans (most popular, well-documented)
- International: Stripe (best developer experience)

---

## Email Services

### Transactional Email
| Tool | Status | Pricing 2026 | Alternative | Migration Path |
|------|--------|--------------|-------------|----------------|
| **SendGrid** | ✅ Active | Free (100 emails/day) | Resend | API similar |
| | | $19.95/mo (50K emails) | Postmark | SDK swap |
| **Resend** | ✅ Active | Free (100 emails/day) | SendGrid | Better DX |
| | | $20/mo (50K emails) | | |
| **Postmark** | ✅ Active | $15/mo (10K emails) | Resend | Best deliverability |
| **AWS SES** | ✅ Active | $0.10/1000 emails | Self-host (Postal) | Cheapest at scale |

**Recommendation**: 
- MVP: Resend (best DX, free tier)
- Scale: AWS SES (cheapest at 100K+ emails/mo)

---

## File Storage

### Object Storage
| Tool | Status | Pricing 2026 | Alternative | Migration Path |
|------|--------|--------------|-------------|----------------|
| **AWS S3** | ✅ Active | $0.023/GB/mo | Cloudflare R2 | S3-compatible API |
| | | $0.09/GB egress | | |
| **Cloudflare R2** | ✅ Active | $0.015/GB/mo | AWS S3 | No egress fees |
| | | $0.00/GB egress | Backblaze B2 | |
| **Backblaze B2** | ✅ Active | $0.005/GB/mo | Cloudflare R2 | Cheapest |
| | | Free egress (1GB/GB stored) | | |
| **Supabase Storage** | ✅ Active | Free (1GB) | S3 | Different API |
| | | $0.021/GB/mo (100GB+) | | |

**Cost Comparison** (100GB stored, 500GB transfer/mo):
- AWS S3: $2.30 storage + $45 egress = **$47.30/mo**
- Cloudflare R2: $1.50 storage + $0 egress = **$1.50/mo**
- Backblaze B2: $0.50 storage + $0 egress = **$0.50/mo**

**Recommendation**: Cloudflare R2 (best balance of price & reliability)

---

## CI/CD & Automation

### CI/CD
| Tool | Status | Pricing 2026 | Alternative | Migration Path |
|------|--------|--------------|-------------|----------------|
| **GitHub Actions** | ✅ Active | Free (2K min/mo) | GitLab CI | YAML similar |
| | | $0.008/min (>2K) | Self-host runner | |
| **GitLab CI** | ✅ Active | Free (400 min/mo) | GitHub Actions | Port YAML |
| **Vercel Deploy** | ✅ Active | Free (hobby) | Netlify | Git push |

**Recommendation**: GitHub Actions (most integrated, sufficient free tier)

---

## Deprecated Tools (Do NOT Use)

| Tool | Status | Replacement | Reason |
|------|--------|-------------|--------|
| **Google Stitch** | ❌ Deprecated 2024 | v0.dev / shadcn/ui | Service shut down |
| **Heroku Free Tier** | ❌ Removed 2022 | Railway / Render | Pricing changed |
| **Redis (licensed)** | ⚠️ License change 2024 | Valkey / KeyDB | SSPL license |

---

## Migration Priority Matrix

| Urgency | Criteria | Action |
|---------|----------|--------|
| **Immediate** | Service deprecated or shutting down | Migrate now (1-2 days) |
| **High** | Pricing increased >50% | Evaluate alternatives (1 week) |
| **Medium** | New better alternative exists | Add to roadmap (1-3 months) |
| **Low** | Current tool working fine | Monitor, no action |

---

## Update Schedule

**Monthly**: Check for pricing changes (Stripe, Midtrans, Mixpanel)  
**Quarterly**: Review new tools (Product Hunt, HN launches)  
**Yearly**: Re-evaluate entire stack (cost optimization)

**Last Updated**: 2026-10-02  
**Next Review**: 2027-01-02

---

**Contribute**: Found outdated pricing? Submit PR with evidence (screenshot, official pricing page link)
