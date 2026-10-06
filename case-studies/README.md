# Case Studies & Worked Examples

Real-world implementations and hypothetical examples demonstrating framework usage across all project scales.

---

## Real Project Case Studies

### 1. [MVP SaaS: Inventory Management](./01-mvp-saas-inventory.md)
**Scale**: Small (4 weeks)  
**Type**: Self-funded MVP  
**Stack**: Laravel 11 + Livewire + MySQL  
**Outcome**: 23 paying users, Rp 1.15M MRR after 3 months  

**Key Lessons**:
- Fast-track works for MVPs (saved 2 days vs no framework)
- Should still do M01 Feasibility (4 hours) + M07 Testing (1 day)
- Pricing too low (Rp 50K/mo) made scaling difficult

**Modules Used**: M04, M05, M06, M10 (fast-track, skipped docs)

---

### 2. [E-commerce Fashion MVP](./02-ecommerce-fashion-mvp.md)
**Scale**: Small (3 weeks / 21 working days)
**Type**: Client commercial project
**Stack**: Next.js 15 + Prisma + PostgreSQL + Midtrans
**Outcome**: Launched in 21 days; 340 orders and Rp 52.1M GMV by Month 3; 3.2% conversion rate.

**Key Lessons**:
- Scope discipline: Cut customer reviews and multi-currency for v1 to guarantee on-time launch
- Payment gateway webhook idempotency is critical to prevent duplicate order fulfillments
- Pre-written SOW change request clauses prevented 3 major unpaid scope additions

---

### 3. [CRM for Real Estate (Internal Tool)](./03-crm-real-estate-internal.md)
**Scale**: Small-Medium (4 weeks / 28 working days)
**Type**: Internal commercial agency tool
**Stack**: Laravel 11 + MySQL + Livewire + Filament Admin
**Outcome**: Launched in 28 days for 10 users; 420 leads managed; conversion increased from 12% to 18% (+50%); follow-up response time reduced by 75%.

**Key Lessons**:
- Boring tech ladder (Filament + Laravel) saved 10+ days compared to building a custom React admin panel
- Single PIC rule prevented conflicting requirements from 8 different sales agents
- Role-based access control (RBAC) eliminated lead theft and duplicate assignments

---

## Hypothetical Worked Examples

> **Note**: These are educational examples created to demonstrate framework usage patterns. They do not represent real projects and contain no actual client data, business outcomes, or performance metrics.

### 4. [Medium-Scale B2B SaaS Platform](./04-medium-b2b-saas-worked-example.md)
**Scale**: Medium (12 weeks)  
**Type**: Hypothetical worked example  
**Scenario**: Multi-tenant project management SaaS for marketing agencies  
**Stack**: Next.js 15 + Supabase + Stripe

**Demonstrates**:
- Full Medium-Scale workflow (M01-M11)
- Multi-tenancy with Row-Level Security (RLS)
- Payment integration (Stripe subscriptions)
- Real-time collaboration features
- Client portal implementation

**Framework Coverage**:
- ✅ Used: M01, M02, M03, M04, M05, M06, M07, M09, M10, M11
- ⏭️ Skipped: M00 (client requirements provided), M08 (no legacy data), M12 (30-day warranty only)

**Key Takeaways**:
- Out-of-scope list (M02) prevents feature creep
- SOW (M03) protects against unpaid change requests
- Supabase RLS handles multi-tenant security at database level

---

### 5. [Large-Scale Multi-System Integration](./05-large-system-integration-worked-example.md)
**Scale**: Large (25 weeks)  
**Type**: Hypothetical worked example  
**Scenario**: Hospital legacy system integration with billing, EHR, and government reporting  
**Stack**: Node.js + Bull (job queue) + PostgreSQL + Redis

**Demonstrates**:
- Full Large-Scale workflow (M00-M12)
- Legacy system modernization (API wrapper pattern)
- Data migration (500K records, validation, rollback)
- Compliance requirements (health data regulations)
- Blue-green deployment with zero downtime

**Framework Coverage**:
- ✅ Used: All modules M00-M12
- 🔍 Extended: M07 (7 days SIT for security), M09 (10 days UAT with training)

**Key Takeaways**:
- M00 Research critical for regulatory landscape
- M05B System Design (retry logic, encryption) prevents data loss
- Phased migration catches validation issues early
- Third-party compliance audit before go-live

---

## Scale Comparison

| Scale | Duration | Modules Used | Team Size | Example |
|-------|----------|--------------|-----------|---------|
| **Small** | 2-6 weeks | M04-M06, M10 (fast-track) | 1 dev | MVP SaaS Inventory |
| **Medium** | 10-14 weeks | M01-M11 (skip M00, M08) | 1-2 devs + designer | B2B SaaS Platform |
| **Large** | 20-28 weeks | M00-M13 (all modules) | 3-5 team members | System Integration |
| **Enterprise** | 24+ weeks | M00-M13 + custom phases | 5+ team + consultants | (No example yet) |

---

## Framework Patterns by Scale

### Small Scale (Fast-Track)
**Minimal viable process**:
```
M04 (Design) → M05 (Specs) → M06 (Code) → M10 (Deploy)
```

**When to add**:
- M01 Feasibility (4 hours) if validating new market
- M07 Testing (1 day) to catch critical bugs
- M06 Section 6A Analytics (2 hours) to avoid losing baseline data

**Skip safely**:
- M00 (validate post-launch)
- M02-M03 (solo projects, no client)
- M08 (no legacy data)
- M09 (no client UAT)
- M11-M12 (self-maintained)

---

### Medium Scale (Selective)
**Balanced process**:
```
M01-M03 → M04-M05 → M06 → M07 → M09 → M10-M11
```

**Critical modules**:
- ✅ M02 Scope (prevent feature creep)
- ✅ M03 SOW (protect against unpaid changes)
- ✅ M07 SIT (catch integration bugs)
- ✅ M09 UAT (client validates before launch)

**Skip if applicable**:
- M00 (if client provides requirements)
- M08 (if no legacy system)
- M12 (if 30-day warranty sufficient)

---

### Large Scale (Comprehensive)
**Full process**:
```
M00 → M01-M03 → M04-M05B → M06 → M07-M08 → M09 → M10-M11 → M12 → M13
```

**Do not skip**:
- ✅ M00 Research (regulatory/compliance requirements)
- ✅ M05B System Design (retry logic, error handling, scalability)
- ✅ M08 Migration (phased approach, validation, rollback)
- ✅ M12 Warranty (6-12 month support critical)

**Extended phases**:
- M07: 5-7 days (vs 3 days) for security/load testing
- M09: 7-10 days (vs 5 days) for staff training
- M10: 3 days (vs 1-2 days) for phased rollout

---

## How to Use These Examples

### For Planning
1. **Identify your scale** (Small/Medium/Large based on duration, features, team)
2. **Find matching case study** (similar tech stack, domain, constraints)
3. **Adapt timeline** (adjust for your team's velocity)
4. **Customize modules** (skip/extend based on your project needs)

### For Estimation
- **Small**: Case studies show 4-6 weeks realistic for solo dev MVP
- **Medium**: 10-12 weeks with 1-2 devs + part-time designer
- **Large**: 18-22 weeks with 3-5 team members + consultants

### For Client Proposals
- **Use real case studies** (01-03) for proof of framework effectiveness
- **Reference worked examples** (04-05) for scope/timeline estimation
- **Adapt payment milestones** from SOW examples

### For Learning
- **Read sequentially** (Small → Medium → Large) to see framework scaling
- **Compare modules used** to understand when to skip vs extend
- **Study error handling** in Large-Scale example for production patterns

---

## Contributing

**Real project case studies** require:
- Anonymized data (no client names, no sensitive metrics)
- Actual outcomes (user count, revenue, retention - with permission)
- Verifiable learnings (what worked, what failed, why)
- "Contributed by" attribution

**Worked examples** should:
- Clearly label as "Hypothetical worked example"
- Demonstrate specific framework patterns (not generic tutorials)
- Avoid fabricated business metrics (no fake revenue/user numbers)
- Focus on technical/process decisions (architecture, testing, deployment)

---

## Upcoming Examples

**Planned worked examples**:
- Enterprise-Scale: Compliance-heavy project (financial services, audit requirements)
- Mobile-First: React Native + API backend integration
- Greenfield vs Brownfield: Comparison of new build vs legacy modernization

**Real case studies** (pending contributor submissions):
- More Medium-Scale client projects
- Agency/consultancy perspective (managing multiple Small-Scale projects)
- Open-source project lifecycle (community-driven development)

---

**Last Updated**: 2026-10-04  
**Total Case Studies**: 3 real + 2 worked examples
