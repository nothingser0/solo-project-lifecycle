# Module 02: Scope Statement Evaluation Checklist

> **Purpose**: Evaluation checklist for SCOPE_STATEMENT.md quality after completing Module 02, designed to catch common mistakes BEFORE advancing to Module 05 (System Design).
>
> **Context**: The Scope Statement is a contract between the developer and stakeholders (or oneself for a solo project). Mistakes here propagate into all downstream modules (design, development, testing).

---

## 1. MoSCoW Prioritization Quality

### ✅ PASS Criteria

- [ ] **Must-Have features (8-12 items)** cover the core 3-step user loop (Input → Process → Output)
- [ ] **Should-Have features (3-5 items)** have clear reasons for deferral (complexity, time, cost, external dependency)
- [ ] **Could-Have features (2-4 items)** are nice-to-have, Premium/Pro tier candidates
- [ ] **Won't-Have features (4-8 items)** are explicit with rationale (out-of-scope, mobile app, multi-language, third-party integration)
- [ ] **No ambiguity:** No features listed as "might include" or "time-permitting" (all must fall into M/S/C/W buckets)

### ❌ RED FLAGS

- ❌ Must-Have >15 features → **Overscoped, cut to 10 features** (rule: MVP must be demoable in 3 minutes)
- ❌ Must-Have <5 features → **Underscoped, lacks core value** (users won't use an app with only 3 trivial features)
- ❌ Won't-Have empty → **High scope creep risk** (all features categorized as "Maybe", lacking firm boundaries)
- ❌ Should-Have == Could-Have (distinction unclear) → **Weak prioritization, rework MoSCoW**

---

## 2. User Stories Quality (INVEST Criteria)

### ✅ PASS Criteria (Per Story)

**Format:**
```
As a [persona/role],
I want to [action/capability],
So that [business value/outcome].

Acceptance Criteria:
- [ ] Given [context], when [action], then [expected result]
- [ ] Given [context], when [action], then [expected result]
- [ ] Edge case: [negative scenario handling]
```

**Checklist per story:**
- [ ] **Independent:** Story can be implemented without hard dependency on other stories (or dependencies are explicitly identified)
- [ ] **Negotiable:** Story can be modified/split without breaking the system (not a rigid technical spec)
- [ ] **Valuable:** Story delivers direct value to the user (not "Setup database" or "Install library")
- [ ] **Estimable:** Story effort can be estimated (S/M/L or story points 1-8)
- [ ] **Small:** Story can be finished in 1-3 days (if >3 days, break into sub-stories)
- [ ] **Testable:** Acceptance criteria are measurable (not "UI should look good", but "Button width min 120px, contrast ratio 4.5:1")

### ❌ RED FLAGS

- ❌ Acceptance criteria vague: "User can log in easily" → **Untestable, define "easily" (e.g., <3 clicks, <10 seconds)**
- ❌ Story too large: "Implement full dashboard" → **Epic, not a story. Break into 5-10 sub-stories**
- ❌ Technical story without user value: "Setup Redis cache" → **Task, not a story. Attach to parent story "Dashboard loads in <2s"**
- ❌ Acceptance criteria missing → **No definition of done, risk of ambiguity during QA**

---

## 3. Database Schema (ERD) Quality

### ✅ PASS Criteria

**Normalization:**
- [ ] **1NF:** All columns atomic (no arrays/JSON in columns, except PostgreSQL JSONB for flexible schemas)
- [ ] **2NF:** All non-key columns depend on full primary key (no partial dependencies)
- [ ] **3NF:** No transitive dependencies (column A → column B → column C)

**Indexes:**
- [ ] Foreign key columns indexed (`user_id`, `client_id`, `transaction_id`)
- [ ] Query filter columns indexed (e.g., `WHERE date BETWEEN ... AND ...` → index on `date`)
- [ ] Composite indexes for multi-column queries (e.g., `WHERE user_id = X AND year = Y` → index on `(user_id, year)`)

**Constraints:**
- [ ] Primary key (PK) present on all tables
- [ ] Foreign key (FK) with explicit ON DELETE CASCADE/SET NULL/RESTRICT
- [ ] UNIQUE constraints for non-duplicate data (e.g., `email`, `npwp`, `(user_id, year, month, schema)`)
- [ ] NOT NULL on required columns (id, email, name, user_id)
- [ ] CHECK constraints for validation (e.g., `CHECK (amount > 0)`, `CHECK (tier IN ('free', 'premium', 'pro'))`)

**Timestamps:**
- [ ] `created_at` TIMESTAMP DEFAULT NOW() present on all tables (audit trail)
- [ ] `updated_at` TIMESTAMP DEFAULT NOW() on frequently updated tables (users, clients)

### ❌ RED FLAGS

- ❌ Missing foreign key → **Data integrity risk** (orphan records, cannot enforce relationships)
- ❌ Missing index on foreign key → **Slow queries >100ms** (full table scans)
- ❌ No UNIQUE constraint on email/tax ID → **Duplicate data risk**
- ❌ Implicit ON DELETE CASCADE → **Default RESTRICT can block user deletion** (requires manual child deletion first)
- ❌ Status VARCHAR column without CHECK constraint → **Invalid data insertion risk** (e.g., typo "premiun" instead of "premium")

**Common Missing Columns (Check per Use Case):**
- ❌ **Tier limit enforcement:** Missing `export_count`, `export_reset_date` for Free tier "max 1× export/year"
- ❌ **Historical snapshot:** Missing `ptkp_amount`, `exchange_rate_snapshot` for immutable calculation records (if PTKP/rates change, historical records become inaccurate)
- ❌ **Soft delete:** Missing `deleted_at` TIMESTAMP NULL (if requirements include "Restore deleted account within 30 days")
- ❌ **Multi-tenancy:** Missing `workspace_id`, `organization_id` (if future plan involves B2B multi-tenant SaaS)

---

## 4. Tech Stack Validation

### ✅ PASS Criteria

**Maturity Check:**
- [ ] Core framework version (Next.js, React, Vue) is **stable** (not alpha/beta/RC)
- [ ] Core libraries (database, auth, payments) are **actively maintained** (last commit <6 months, responsive GitHub issues)
- [ ] External APIs provide **public docs + SLA** (e.g., Stripe 99.99% uptime, clear rate limits)

**Solo Dev Feasibility:**
- [ ] **Learning curve <1 week** for unfamiliar technologies (e.g., React Server Components, Supabase RLS)
- [ ] **Strong community support:** Stack Overflow >1,000 questions, active Discord/forums
- [ ] **No vendor lock-in** (or acceptable lock-in: e.g., Vercel/Supabase can migrate to self-hosted)

**Cost Projection:**
- [ ] **Free tier sufficient for MVP** (100 users, 1GB storage, 10k API calls/month)
- [ ] **Clear paid tier pricing** (Supabase Pro $25/month, Vercel Pro $20/month, Midtrans 2% + Rp2,000/transaction)
- [ ] **Break-even calculation** (MRR target vs hosting cost)

### ❌ RED FLAGS

- ❌ Bleeding-edge tech (Next.js 16 canary, React 20 alpha) → **Breaking changes risk, unstable production**
- ❌ Unmaintained libraries (last commit >1 year, 50+ unresolved open issues) → **Security vulnerabilities, unpatched bugs**
- ❌ External API without public documentation → **Integration risk, trial-and-error debugging**
- ❌ Extreme vendor lock-in (proprietary DB format, no export option) → **Migration cost >1 month effort if vendor shuts down**
- ❌ Cost spiral (free tier 10 users, paid tier $500/month) → **Unreachable break-even for solo dev**

---

## 5. Non-Functional Requirements (NFR) Realism

### ✅ PASS Criteria

**Performance Targets:**
- [ ] **Page load <3s** (not <1s, unrealistic for dynamic content)
- [ ] **API response <1s** (not <100ms, unrealistic for complex queries + external APIs)
- [ ] **Export file generation <5s** (not <1s, files >1MB take time)

**Security Baseline:**
- [ ] **HTTPS only** (TLS 1.2+)
- [ ] **Password hashing** (bcrypt cost ≥12, Argon2, PBKDF2)
- [ ] **Auth tokens** (JWT httpOnly cookies, session expiry 7 days)
- [ ] **Rate limiting** (public endpoints 10 req/min, authenticated 60 req/min)
- [ ] **Input validation** (Zod/Yup schemas, HTML sanitization, parameterized SQL queries)

**Accessibility (WCAG 2.1 AA):**
- [ ] **Contrast ratio 4.5:1** (text vs background)
- [ ] **Keyboard navigation** (Tab order, Enter/Space button triggers)
- [ ] **ARIA labels** (screenreader-friendly)
- [ ] **Focus visible** (outline 2px solid on focused elements)

### ❌ RED FLAGS

- ❌ Unrealistic performance target: "API <50ms" → **Impossible with external API calls (network latency alone 20-100ms)**
- ❌ Missing HTTPS → **Plaintext passwords over network, MITM attack risk**
- ❌ Accessibility omitted → **Lawsuit risk (ADA compliance), 15% of users unable to use app**
- ❌ No rate limiting → **DDoS vulnerability, brute-force attacks, API cost spikes**

---

## 6. Timeline & Milestone Realism

### ✅ PASS Criteria

**Buffer Rule: 30-40% of Total Time**
- [ ] Timeline has **explicit buffer** (e.g., 12 weeks development + 3 weeks buffer = 15 weeks total)
- [ ] Minimum **2-week buffer** for a 3-month project (for sick leave, scope creep, complex bugs)

**Milestone Breakdown:**
- [ ] **Week 1-2:** Planning (Modules 02-04) → deliverables: SCOPE, DESIGN, wireframes
- [ ] **Week 3-4:** Technical design (Module 05) → deliverables: PRD, database DDL, API contracts
- [ ] **Week 5-X:** Development (iterative, 2-week sprints) → deliverable: working features per sprint
- [ ] **Week X-Y:** QA & testing → deliverables: unit tests with 80% coverage, E2E happy path
- [ ] **Week Y:** Deploy & launch → deliverables: production URL, documentation

**Dependency Check:**
- [ ] **External dependencies tracked** (API approvals, client design assets, domain purchases)
- [ ] **Critical path identified** (longest dependency chain, e.g., Auth setup → RBAC → Payment integration)

### ❌ RED FLAGS

- ❌ No buffer (timeline "exactly 12 weeks, no slack") → **99% probability of delay**
- ❌ Development phase >50% total timeline → **Planning/QA underestimated, rush at the end**
- ❌ Unmeasurable milestones: "Week 5: Build backend" → **Unclear definition of done, lacking concrete deliverables**
- ❌ Untracked external dependencies → **Unexpected blockers (e.g., Midtrans approval taking 2 weeks unexpectedly)**

---

## 7. Risk Register Completeness

### ✅ PASS Criteria (Per Risk)

**Format:**
```
| Risk | Likelihood (%) | Impact | Mitigation | Owner | Trigger | Contingency |
```

- [ ] **Likelihood quantified** (10-90%, not vague "Low/Medium/High")
- [ ] **Concrete impact** (revenue loss, X weeks delay, Y% user churn)
- [ ] **Actionable mitigation** (not "Monitor", but "Unit test 30+ scenarios + consultant review")
- [ ] **Assigned owner** (solo dev = developer name; if external dependency, owner = vendor)
- [ ] **Defined trigger** (condition when risk turns into an issue, e.g., "API down >1 hour")
- [ ] **Contingency plan** (fallback if mitigation fails, e.g., "Manual exchange rate input if API down")

**Coverage 5 Categories:**
- [ ] **Technical risk** (API deprecated, scaling bottleneck, tech debt)
- [ ] **Resource risk** (solo dev illness/burnout, skill gap)
- [ ] **Market risk** (competitor launch, low user adoption)
- [ ] **Legal/Compliance** (UU PDP violations, vendor ToS changes)
- [ ] **Financial risk** (budget overruns, revenue below projections)

### ❌ RED FLAGS

- ❌ Fewer than 5 risks → **Incomplete, minimum 7-10 risks for a 3-month project**
- ❌ No mitigation → **Risk register is just a list, not actionable**
- ❌ Generic mitigation: "Be careful" → **Unhelpful, define concrete actions**
- ❌ No high-impact risks (all marked "Low impact") → **Overconfidence, underestimating risk**

---

## 8. Scope Boundaries (In/Out) Explicitness

### ✅ PASS Criteria

**In-Scope (12-15 items):**
- [ ] **Development features** (10 Must-Haves from MoSCoW)
- [ ] **Testing scope** (unit test core logic 80%, E2E test happy path)
- [ ] **Deployment scope** (Vercel production, custom domain, SSL)
- [ ] **Documentation scope** (README, ENV vars, API docs)

**Out-of-Scope (8-12 items):**
- [ ] **Future features** (mobile app, multi-language, white-label)
- [ ] **Third-party integrations** (Coretax API, bank statement OCR, WhatsApp API)
- [ ] **Advanced features** (multi-year data, AI recommendations, real-time collaboration)

**Ambiguity Test:**
- [ ] **No "TBD" or "Maybe"** → all items belong in In or Out, zero grey area
- [ ] **No overlap** → items cannot appear in both In and Out simultaneously

### ❌ RED FLAGS

- ❌ Out-of-Scope empty → **Scope creep risk 90%, client/developer will assume "everything is included"**
- ❌ In-Scope >20 items → **Overscoped, cut to 12-15 items**
- ❌ Ambiguity: "Payment integration (if time permits)" → **Move to Out-of-Scope or commit to In-Scope**

---

## 9. Common Formula/Logic Errors (Domain-Specific)

### Tax Calculator (FreePajak Example)

**CRITICAL Formula Check:**
- [ ] **PPh Final 0.5%:** `Tax = Gross Turnover × 0.5%` (PP 20/2026, unlimited years for individuals)
- [ ] **NPPN 50%:**
  - ❌ INCORRECT: `(Gross × 50% - PTKP) × Progressive Rate`
  - ✅ CORRECT: `Net = Gross × 50%`, `PKP = Net - PTKP`, `Tax = PKP × Progressive Rate`
- [ ] **Progressive Rates:** Correct brackets (5% up to Rp60M, 15% Rp60-250M, 25% Rp250-500M, 30% Rp500M-5B, 35% >Rp5B under UU HPP 2021)
- [ ] **PTKP 2026:** TK/0 = Rp54M, K/0 = Rp58.5M, K/1 = Rp63M, K/2 = Rp67.5M, K/3 = Rp72M (PMK 141/2015, assume unchanged for 2026)

**Unit Test Scenarios (Min 10):**
- [ ] Turnover Rp0 → Tax Rp0 (edge case)
- [ ] Turnover Rp60M TK/0 → PKP Rp6M → Tax 5% = Rp300k (boundary PTKP)
- [ ] Turnover Rp500M K/1 → PKP Rp437M → Progressive tax Rp96.05M (multi-bracket)
- [ ] Domestic client withheld 2.5% → Tax credit deducted from tax due
- [ ] Foreign client no withholding → Full tax due (no tax credit)

### E-Commerce (Price Calculator Example)

**CRITICAL Formula Check:**
- [ ] **Subtotal:** `Σ(item.price × item.quantity)`
- [ ] **Discount:** Applied BEFORE or AFTER tax? (standard: before tax)
- [ ] **Tax (VAT/PPN 11%):** `(Subtotal - Discount) × 11%`
- [ ] **Shipping:** Flat rate, weight-based, or free threshold? (explicitly defined)
- [ ] **Total:** `Subtotal - Discount + Tax + Shipping`

---

## 10. Evaluation Scoring Rubric

### Scoring Matrix (1-5 per Aspect)

| Aspect | Weight | Score (1-5) | Weighted |
|--------|--------|-------------|----------|
| MoSCoW Prioritization | 15% | [X] | [X × 0.15] |
| User Stories Quality | 15% | [X] | [X × 0.15] |
| Database Schema | 20% | [X] | [X × 0.20] |
| Tech Stack | 10% | [X] | [X × 0.10] |
| NFR Realism | 10% | [X] | [X × 0.10] |
| Timeline & Milestones | 15% | [X] | [X × 0.15] |
| Risk Register | 10% | [X] | [X × 0.10] |
| Scope Boundaries | 5% | [X] | [X × 0.05] |
| **TOTAL** | **100%** | — | **[ΣWeighted]** |

**Gate Decision:**
- **≥4.0/5:** PASS (Go to Module 04/05)
- **3.0-3.9/5:** CONDITIONAL PASS (Fix red flags first, re-review)
- **<3.0/5:** FAIL (Rework Module 02 from scratch)

---

## 11. Action Items Template (Post-Evaluation)

**CRITICAL (Must-Fix Before Module 05):**
1. [ ] Fix formula/logic errors (e.g., incorrect NPPN calculation)
2. [ ] Add missing database columns (e.g., `export_count`, `ptkp_amount`)
3. [ ] Strengthen disclaimer/compliance (e.g., legal wording for UU PDP)
4. [ ] Adjust timeline buffer (add 2 weeks if total <12 weeks)
5. [ ] Define external API fallback (e.g., manual exchange rate input if API down)

**IMPORTANT (Should-Fix, Can Be Parallel):**
1. [ ] Revise Free tier limits (e.g., 3 clients → 5 clients)
2. [ ] Add composite indexes (e.g., `(user_id, year, month)`)
3. [ ] Clarify NFR targets (e.g., export <5s instead of <3s)
4. [ ] Expand risk register (add 3-5 risks if only 5 items)

**OPTIONAL (Nice-to-Have):**
1. [ ] Add Should-Have features to backlog (v1.1 roadmap)
2. [ ] Document tech spike POC results (if applicable)
3. [ ] Create user journey map (visual flow diagram)

---

## 12. Checklist Summary (Quick Gate)

**Minimum Bar to PASS Module 02:**
- ✅ MoSCoW: 8-12 Must-Have, 3-5 Should-Have, 4-8 Won't-Have
- ✅ User Stories: INVEST format, testable acceptance criteria
- ✅ Database: ERD 3-6 tables, foreign keys + indexes + constraints
- ✅ Tech Stack: Mature, active maintenance, free tier sufficient for MVP
- ✅ NFR: Performance/security/accessibility targets realistic
- ✅ Timeline: 12-16 weeks with 30% buffer
- ✅ Risk: 7-10 risks with mitigation + contingency
- ✅ Scope: In/Out explicit, no "TBD"

**If ANY of above = ❌ → STOP, fix first before Module 05**

---

**Last Updated:** 2026-09-30  
**Changelog:**
- 2026-09-30: Initial checklist based on FreePajak Module 02 evaluation (4.25/5, 10 potential issues identified: formula NPPN calculation, missing DB columns, strict Free tier limits, ambitious timeline)
