# Solo SaaS Project Charter & Self-Runway Commitment

> Internal governance document for **Solo SaaS & Self-Initiated Products**.
> Formalizes founder commitment, cloud runway budget, risk boundaries, and timeline gates without creating artificial client contracts.

---

## 1. Project Identity & Classification
- **Product Name**: [Product Codename / Public Name]
- **Founder / Solo Developer**: [Your Name]
- **Target Launch Date**: [YYYY-MM-DD] (Target: 1–3 Months)
- **Industry Archetype**: [Acronym] - [Archetype Name] (from references/taxonomy/SYSTEM_ARCHETYPES_250.md)
- **Catalog Benchmark**: #[251–500] - [Catalog Entry Name] (from references/taxonomy/PROJECT_CATALOG_1000.md)
- **Commercial Governance**: `[WAIVED - Solo SaaS / Self-Initiated]`

---

## 2. Runway Budget & Cost Ceiling
- **Monthly Cloud Budget Ceiling**: [e.g., $0–$25/month initially]
- **Target Infrastructure**: [e.g., Vercel / Cloudflare + Supabase / Neon + PostHog]
- **Third-Party API Cost Ceiling**: [e.g., $10/month for LLM tokens / Resend email]
- **Break-Even Target**: [e.g., 5 paying customers at $19/month = $95 MRR by Month 2]

---

## 3. Scope Discipline & Anti-Creep Razor
- **Core Loop**: [User Action] ──► [System Ledger/State Mutation] ──► [Instant Value Delivered]
- **Strictly In-Scope (Phase 1 Solo SaaS)**:
  1. [Core Feature 1]
  2. [Core Feature 2]
  3. [Authentication + RBAC]
  4. [Billing: Stripe / Midtrans / LemonSqueezy integration]
- **Strictly Out-of-Scope (Deferred to Post-Launch)**:
  1. No complex multi-tenant subdomains.
  2. No multi-currency billing.
  3. No custom enterprise SSO / SAML.

---

## 4. Kill & Pivot Thresholds (Ambang Gugur)
- **Week 4 Milestone**: Functional prototype with live auth and core loop deployed on staging. If missing, prune secondary features.
- **Week 8 Milestone**: Billing enabled and 5 customer discovery users onboarded.
- **Kill Threshold**: If zero paying users or $<10$% weekly retention after 60 days post-launch, freeze infrastructure costs and archive.

---

## 5. Sign-Off & Commitment
- **Sole Decision Maker (PIC)**: [Your Name]
- **Status**: `[COMMITTED / ACTIVE]`
- **Date**: [YYYY-MM-DD]
