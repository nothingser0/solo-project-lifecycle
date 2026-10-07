# Module 02: Discovery & Scope Definition (Requirements Elicitation & Scope Locking)

> - `references/checklists/MODULE_02_EVALUATION_CHECKLIST.md` (MoSCoW quality check, User Stories INVEST validation, Database Schema validation, Tech Stack validation, NFR realism check, Timeline buffer, Risk completeness, Scope boundaries)
> - `references/checklists/REQUIREMENT_ELICITATION_GUIDE.md` (5-pillar elicitation question bank, Red-flags detection)


This module is the second stage in the software development lifecycle for solo developers. Its purpose is to extract real business requirements from stakeholders/clients, define technical boundaries, and lock **In-Scope vs Out-of-Scope** boundaries into the **`SCOPE_STATEMENT.md`** document before committing to contracts or detailed design.

**Pre-Contract Work**: Modules 00-02 (Discovery phase, 1-4 weeks) typically unpaid for new clients. DP (Down Payment, Termin 1) in Module 03 triggers paid work (Modules 03+ execution). For repeat clients, consider charging discovery fee upfront.

---

## 1. Execution Cycle of Module 02

```text
[ INPUT: IDEA_BRIEF.md Document from Module 01 ]
                      │
                      ▼
[ STEP 1: Targeted Discovery Interview (The 5 Pillars) ]
  • Real Business Objectives & Realistic Growth Ramp (50-100 Users Year 1)
  • Non-Circular North Star Metric & Pre-Launch Validation
  • User Persona Mapping & Access Boundaries
                      │
                      ▼
[ STEP 2: Problem-Solution Fit & MoSCoW Prioritization ]
  • 80/20 Root Cause Mapping (Must-Haves collectively ≥70%, each Must mapped to primary friction)
  • Target Segment Feature Fit (Drop mismatched segments like Cafe without BOM)
  • Dependency Contradiction Check (Gross Profit vs Deferred Expenses)
  • Mandatory SaaS Revenue Features (Billing, Offboarding, Admin Panel, Receipts)
  • Should-Have / Could-Have (Secondary Features)
  • Won't-Have (Rejected / Deferred Features)
                      │
                      ▼
[ STEP 3: Detailed RBAC Matrix & Approval Decision Tree ]
  • Role Permission Table (Owner, Manager, Kasir, Akuntan)
  • Multi-Location Access & Approval Workflow (Zero Self-Approval)
  • Permission Escalation & Role-Based Session Timeouts
                      │
                      ▼
[ STEP 4: Architecture Decisions & Database Schema Design ]
  • Multi-Tenant Schema (org_id on all tables, RLS via public.user_roles)
  • Financial Precision (DECIMAL, unit_cost snapshot, soft delete, append-only)
  • Architecture Realism (Offline/Real-time decision matrix, TTI <5s, client-side PDF)
  • Tech Stack Version Locking & Accurate Security Claims
                      │
                      ▼
[ STEP 5: Scope Boundary Locking, Tax Disclaimers & Legal Compliance ]
  • Explicit List: WHAT IS BUILT vs WHAT IS NOT BUILT
  • Tax Disclaimers (PP 55/2022 jo. PP 20/2026, Rp 500M threshold, non-PKP)
  • Mandatory UU PDP Compliance (Privacy Policy, ToS, DPA, 3Y Retention, PII Scrubbing)
                      │
                      ▼
[ STEP 6: Client Dependency Registration (Dependency SLA) ]
  • Sandbox credentials, master data CSV templates, 3-day turnaround SLA
                      │
                      ▼
[ STEP 7: Stakeholder Mapping, Communication & Realistic Timelines ]
  • Power/Interest Matrix (4 Quadrants)
  • Communication Plan & Escalation Path
  • Expectation Management & RACI Matrix
  • Phase Duration Guidelines & 20% Dev Buffer (CR freeze = QA - 2w)
                      │
                      ▼
[ OUTPUT: SCOPE_STATEMENT.md Document + Stakeholder Artifacts ] ──► Ready to Proceed to Next Module (M03 / M04)
```

---

## 2. Step-by-Step Execution

### Step 1: Targeted Discovery Interview
Conduct the interview using the guide in `references/checklists/REQUIREMENT_ELICITATION_GUIDE.md`:

#### 1.1 Decision Authority & Needs vs Wants
1. **Identify Decision Makers**: Ensure the interviewee has final commercial and technical authority to sign off on deliverables.
2. **Dissect Needs vs Wants**: Distinguish core revenue/operational blockers (*needs*) from cosmetic wishlists (*nice-to-have wishes*).

#### 1.2 Realistic Business Metrics Ramp (Avoid Fantasy Projections)
Solo developers must ground business metrics in achievable adoption curves. Claiming *"500 customers and Rp 50M MRR in Month 1"* is an anti-pattern.

| Timeline Post-Launch | Realistic Cumulative Customers | Monthly Acquisition Pace | Typical MRR (@ Rp 99k/mo) |
| :--- | :---: | :---: | :---: |
| **Month 1** | 5–10 | Beta cohort conversion | Rp 500k – Rp 1M |
| **Month 3** | 20–30 | +5–10 / month (organic referrals) | Rp 2M – Rp 3M |
| **Month 6** | 50–75 | +10–15 / month (initial PMF) | Rp 5M – Rp 7.5M |
| **Month 12** | 50–100 | +10–15 / month (scaling) | Rp 5M – Rp 10M |

- **Year 1 Target Baseline**: Model **50–100 paying customers** for early-stage B2B/SME SaaS (typically generating Rp 5–10M MRR).

#### 1.3 Retention vs LTV Metric Realism
- **D30 Retention Benchmark**: Expect **30%–40%** user retention after initial 30 days.
- **Average Customer Lifetime**: SME/UMKM SaaS exhibits annual churn of $30\%–50\%$. Never model customer lifetimes $>18$ months without historical data; assume **12–18 months** for initial LTV models.
- **Anti-Pattern Check**: Do NOT pair a high-churn metric (e.g., "D30 retention 40%") with an optimistic long lifetime (e.g., "LTV 24 months").

#### 1.4 Non-Circular North Star Metric
- ❌ *Circular Definition*: "70% of Weekly Active Users record $\ge 5$ transactions per week" (WAU is already defined by activity).
- ✅ *Non-Circular Definition*: "Active Tenant Rate = $70\%$ of signed-up organizations with $\ge 1$ login in the past 30 days record $\ge 5$ operational transactions per week."

#### 1.5 Pre-Launch Validation Integration
Include a pre-launch validation checkpoint in early discovery:
- **Pre-Launch Smoke Test Landing Page (Week 2)**: Lightweight landing page (Carrd/Webflow, 2 days effort) with email capture and willingness-to-pay question (*"Would you pay Rp 99k/month for this?"*).
- **Validation Gate**: Target 50–100 email signups prior to major development investment. If $<50$ signups occur in 2 weeks, reassess positioning before locking scope.

---

### Step 2: Problem-Solution Fit & MoSCoW Prioritization

#### 2.1 Problem-Solution Fit Validation (MANDATORY CROSS-CHECK)
Before prioritizing features into MoSCoW buckets, validate every proposed capability against root-cause research:

1. **80/20 Root Cause Mapping**:
   - Extract stated problem metrics according to your domain (e.g., Retail: stock discrepancy 10-15%; HRIS: unverified overtime leakage 12%; Legal: contract approval turnaround 5 days).
   - Dissect underlying causes: Identify primary operational bottlenecks ($\approx 80\%$) vs secondary friction ($\approx 20\%$).
   - **Rule**: The Must-Have (P0) feature set **collectively** must resolve $\ge 70\%$ of primary root causes, and **every individual Must-Have feature must directly map to at least one primary operational bottleneck** (resolving $\ge 50\%$ of that specific cause; zero vanity features in P0). Any standalone feature claiming P0 status that addresses only minor secondary friction ($<20\%$) must be demoted to Should-Have (P1) or Won't-Have (P3).
   - *Domain Examples*: Retail P0 = stock opname audit trail (not real-time branch sync); HRIS P0 = geofenced clock-in & tiered approval workflow (not AI facial recognition); Legal P0 = clause diff engine & role-based sign-off (not multi-jurisdictional AI chatbot).

2. **Target Segment Feature Dependency Audit**:
   - Map required capabilities per targeted user persona.
   - *Example*: Targeting "Cafe / Coffee Shop" requires Bill of Materials (BOM) for recipe ingredient deduction (coffee beans $\rightarrow$ espresso).
   - **Rule**: If the MVP excludes BOM, the agent **MUST DROP THE CAFE SEGMENT** from MVP scope or upgrade BOM to P0. Never retain a user persona whose pain points cannot be solved by the MVP feature set.

3. **Dependency Contradiction Check**:
   - If a feature generates reports claiming *"Net Profit (Revenue - COGS - Expenses)"*, verify whether expense tracking is in-scope.
   - If expense tracking is deferred to Phase 1.5, the report MUST be labeled *"Gross Profit only (Laba Kotor; Operational expenses deferred to Phase 1.5)"*.

#### 2.2 MoSCoW Categorization Limits
Break each module into specific features with priority labels:

**Template**: `templates/01-discovery-commercial/MOSCOW_MATRIX.md` (60-min workshop format, decision tree, examples)

- **Must Have (P0)**: The system fails to function without this feature (e.g., order checkout, login authentication).
  - **Max Must-Haves by Scale**: Small: 3–7 features (1–3 core user flows) | Medium: 8–15 features | Large: 16–25 features | Enterprise: 26–40 features
  - If limits are exceeded, downgrade to Should-Have or Phase 2.
- **Should Have (P1)**: Important features with temporary manual workarounds (e.g., export reports to Excel).
- **Could Have (P2)**: Additional features if time and solo dev capacity permit (e.g., WhatsApp notifications).
- **Won't Have (P3)**: Features formally agreed not to be built in this phase (e.g., AI recommendation chatbot).

#### 2.3 Mandatory SaaS Revenue & Operations Features (P0 MVP)
Every commercial SaaS scope statement **MUST** include these operational capabilities in P0 *(Note: Untuk Internal Company Tools seperti HRIS internal atau tool operasional perusahaan sendiri, modul billing/subscription dikecualikan/dilewati)*:

1. **F-XX: Billing & Subscription Engine**:
   - Payment gateway integration (Midtrans, Xendit, or Stripe).
   - Subscription plans (e.g., Rp 99k/month) with automated invoice generation.
   - 14-day free trial without credit card requirement.
   - 7-day grace period post-expiry before access blocking.
   - Automated email reminder (3 days before expiration via transactional SMTP).
   - Middleware subscription guard (intercept expired tenants, redirect to `/settings/billing`).

2. **F-XX: Offboarding & Data Deletion Flow (UU PDP Compliance)**:
   - User initiates subscription cancellation.
   - 30-day grace period: Access blocked, data retained, one-click full data export to CSV/JSON.
   - Day 31: Tenant marked `is_deleted = true`, credentials revoked, data quarantined.
   - Day 90: Irreversible automated database purge satisfying the *"Right to be Forgotten"*.

3. **F-XX: Receipt Printing / Dispatch**:
   - Browser printing dialog (`window.print()`) with `@media print` CSS supporting 58mm and 80mm thermal printers.
   - WhatsApp and PDF dispatch deferred to Phase 1.5 if vendor API budgets are constrained.

4. **F-XX: Solo Developer Internal Admin Panel**:
   - Protected internal route (`/admin`) isolated from tenant users.
   - Organization directory, active user counts, storage utilization, and tenant error logs.
   - Manual subscription override tool (extend trial, grant comp account, manual activation).

---

### Step 3: Detailed RBAC Matrix & Approval Decision Tree

Vague role descriptions (e.g., *"Manager has full access"*) create authorization bugs. Define concrete permissions per role:
*(Contoh di bawah memakai arketipe Retail/Accounting. Sesuaikan peran dengan domain proyek: misal HRIS = Super Admin, HR Manager, Department Head, Karyawan; Edutech = Admin, Guru, Siswa, Orang Tua)*:
#### 3.1 Mandatory Role-Based Access Control (RBAC) Table

| Role Code | Role Name | Create | Read | Update | Delete / Void | Special Permissions & Guardrails |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **ROL-01** | **Owner** | All resources | All org locations | All resources | **Void only** (Immutable audit log; soft-delete via `is_active=false`) | Full organization control, staff invitations, billing management, financial statements |
| **ROL-02** | **Manager** | Transactions, stock adjustments | Assigned locations (`location_ids[]`) | Transactions, products | Void transactions (assigned locations only) | **Stock adjustment approval**: Approves adjustments $>Rp 1M$ or variance $>10\%$. **ZERO SELF-APPROVAL** |
| **ROL-03** | **Kasir** | **Sales transactions only** | Inventory (own location only) | Own same-day sales | **CANNOT VOID** (Must escalate to Manager) | **Hidden Buy Price**: Application query layer excludes `buy_price` / cost fields. Zero access to profit reports |
| **ROL-04** | **Akuntan** | None (read-only audit) | Financial statements, tax reports, ledgers | None | None | Read-only reporting access. Export PDF/Excel. Cannot alter operational balances |

#### 3.2 Location Assignment Architecture
- **Owner**: Global access across all organization locations automatically.
- **Manager**: Multi-location assignment via `user_roles.location_ids UUID[]` array.
- **Kasir**: Single location bound to first element of `location_ids`.

#### 3.3 Stock Adjustment Approval Decision Tree
```text
Adjustment Created By ──► Authorization Rule
├── Kasir   ──► CANNOT CREATE (Inventory read-only)
├── Manager ──► Value < Rp 1.000.000 AND variance < 10% ──► Auto-Approved
├── Manager ──► Value ≥ Rp 1.000.000 OR variance ≥ 10%  ──► Requires OWNER Approval
├── Manager ──► Own created adjustment (Any amount)      ──► Requires OWNER Approval (NO SELF-APPROVAL)
└── Owner   ──► Auto-Approved (Highest internal authority)
   ```

#### 3.4 Session Timeout by Device Profile
- **Kasir (Shared POS Hardware)**: 24-hour maximum session with auto-lock on inactivity.
- **Owner / Manager / Akuntan (Personal Hardware)**: 7-day session with refresh token rotation.

---

### Step 4: Technical Architecture Constraints & Database Schema Design

#### 4.1 Database Schema Design Checklists
*(Sesuaikan dengan arsitektur deployment: Multi-tenant SaaS wajib partisi tenant, sedangkan single-tenant internal database cukup skema relasional standar)*:
**Multi-Tenant SaaS Guardrails**:
- [ ] **Universal Tenant Column**: Every table **MUST** include `org_id UUID NOT NULL REFERENCES organizations(id)`.
- [ ] **Junction Table Isolation**: Multi-to-multi tables (e.g., `transaction_items`) must include `org_id` directly to prevent tenant leakage.
- [ ] **Row-Level Security (RLS) Policy**: Query the application table, NOT the protected auth schema:
  ```sql
  -- ✅ CORRECT:
  CREATE POLICY org_isolation ON transactions
  FOR ALL USING (
    org_id = (SELECT org_id FROM public.user_roles WHERE user_id = auth.uid() LIMIT 1)
  );
  -- ❌ WRONG: org_id = auth.user_org_id() (Auth schema is read-only)
   ```
- [ ] **Column-Level Security Mitigation**: RLS filters rows, NOT columns. To hide `buy_price` from Cashiers, enforce column omission in application query builders (e.g., Prisma select / Supabase `.select('id, name, sell_price')`).

**Financial Domain Precision**:
- [ ] **Currency & Monetary Amounts**: Always use `DECIMAL(15, 2)` or `NUMERIC` (NEVER `FLOAT` or `DOUBLE`).
- [ ] **Unit Cost Snapshotting**: `transaction_items` **MUST** record `unit_cost DECIMAL(15, 2) NOT NULL` (the exact buy price at the second of checkout). Never recalculate historical COGS from current product master data.
- [ ] **Immutable Audit Log Pattern**:
  - `inventory_movements`: Append-only log. Never execute `UPDATE` or `DELETE`.
  - `transactions`: Status enum (`completed`, `void`, `returned`). Voiding sets `voided_at` and `voided_by_user_id`; records remain permanently.
  - **No `balance_after` in Movement Records**: Storing computed balances causes race conditions during concurrent offline submissions. Calculate balance dynamically via `SUM(quantity)` triggers or read-model projections.

**Offline Sync Columns (If Offline Supported)**:
- [ ] `idempotency_key TEXT UNIQUE`: Client-generated UUID preventing duplicate transaction sync.
- [ ] `device_timestamp TIMESTAMPTZ`: Captured from client clock (server `created_at` remains the authoritative source of truth).

**System Audit Trail Table**:
```sql
CREATE TABLE audit_logs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  org_id UUID NOT NULL REFERENCES organizations(id),
  user_id UUID REFERENCES auth.users(id),
  action TEXT NOT NULL,         -- e.g., 'STOCK_ADJUSTMENT_APPROVED'
  entity_type TEXT NOT NULL,    -- e.g., 'stock_adjustments'
  entity_id UUID NOT NULL,
  changes JSONB,                -- {"old": {...}, "new": {...}}
  ip_address INET,
  user_agent TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
```

#### 4.2 Architecture Decisions & Realism Check

**Offline-First Decision Matrix**:

| Scale & Connectivity | Architecture Recommendation | Rationale |
| :--- | :--- | :--- |
| **<100 users / 1–2 locations / Stable 4G** | **Online-Only MVP** | Defer offline sync to Phase 2; eliminates complex conflict resolution |
| **100–500 users / Intermittent 3G** | **Selective Offline** | Cache product catalogue; queue sales transactions with retry guards |
| **500+ users / Harsh connectivity** | **Full Offline-First** | IndexedDB (Dexie.js) + Append-only delta sync (Never Last-Write-Wins) |

**Real-Time Sync Decision Matrix**:
- Latency requirement $>5$ seconds $\rightarrow$ Implement 30-second polling or manual refresh button.
- Latency requirement $<5$ seconds $\rightarrow$ Use WebSocket Broadcast channels (Supabase Realtime Broadcast).
- Avoid Postgres Changes Realtime on large tables with complex RLS due to heavy server-side subscriber overhead.

**Realistic Performance Budgets**:
- **Time to Interactive (TTI) on 3G**: Realistic target is **$<5$ seconds** (not $<3$s) with an initial JS bundle budget of **$<200$ KB gzipped**.
- **API p95 Response Time**: Target **$<500$ ms** (accounting for Indonesia-to-Singapore cloud baseline latency of $50–100$ ms).
- **Client-Side PDF Generation**: Use `@react-pdf/renderer` in browser. Avoid serverless Puppeteer on Vercel due to $50$ MB bundle bloat and $10$-second function timeouts.

**Tech Stack Version Locking**:
Pin minor versions in specification (e.g., Next.js `15.0.x`, React `19.0.x`, Tailwind `4.0.x`, TypeScript `5.6.x`, Dexie `4.0.x`). Never specify `"latest"` or floating semver ranges.

**Accurate Security Claims**:
- ❌ *"SQL injection prevented by RLS"* $\rightarrow$ Misleading. RLS is authorization. SQL injection is prevented by parameterized queries.
- ❌ *"CSRF tokens handled by Supabase"* $\rightarrow$ Inaccurate. Supabase Auth mitigates CSRF using `SameSite=Lax` cookies.
- ❌ *"Encryption at-rest via pgcrypto"* $\rightarrow$ Misleading. pgcrypto is an application tool. Database encryption at-rest is handled by AWS/PostgreSQL AES-256 storage.

---

### Step 5: Scope Boundary Locking, Tax Disclaimers & Legal Compliance

#### 5.1 In-Scope vs Out-of-Scope (Scope Defense)
Civil law principle: *"Everything not explicitly documented as In-Scope is strictly outside the developer's responsibility."*

Mandatory Out-of-Scope exclusions:
1. Manual physical paper digitization or entry of corrupted legacy databases.
2. Licensing costs for third-party fonts, commercial icon sets, or cloud vendor API subscription tiers.
3. Local hardware malfunctions, network router misconfigurations, or point-of-sale thermal printer driver corruptions.
4. Formal legal counsel or tax advisory certifications.

#### 5.2 Tax & Statutory Disclaimers (Domain-Specific)
If the system includes automated tax, payroll, or statutory calculations, cite the authoritative regulation for your specific sector and jurisdiction:

**1. Retail / SME Commerce (PPh UMKM)**:
- Regulation: **PP 55/2022 jo. PP 20/2026** (enacted 22 April 2026). The time limit for the 0.5% PPh Final facility is permanently eliminated, but the facility is **strictly restricted** to **Wajib Pajak Orang Pribadi (WP OP)**, **PT Perorangan**, and **Koperasi** with gross turnover $\le$ Rp 4.8 billion/year. It is **no longer eligible** for CV, Firma, PT Non-Perorangan, or BUMDes.
- Model the **Rp 500.000.000/year non-taxable gross turnover threshold** strictly for individual taxpayers (WP OP).
- Mandatory In-App Disclaimer: *"Perhitungan pajak bersifat estimasi operasional dan tidak menggantikan pelaporan resmi pada DJP. PPN tidak diperhitungkan (non-PKP)."*

**2. HRIS / Payroll (PPh 21 & Social Security)**:
- Regulation: **PP 58/2023 & PMK 168/2023** (PPh 21 skema Tarif Efektif Rata-rata / TER Kategori A, B, C) + BPJS Ketenagakerjaan & BPJS Kesehatan.
- Mandatory In-App Disclaimer: *"Kalkulasi pemotongan PPh 21 TER dan BPJS bersifat panduan internal penggajian; verifikasi akhir dilakukan oleh pejabat pemotong pajak (withholding tax agent) terdaftar."*

**3. General Rule for All Domains**:
- **Mandatory In-App Disclaimers**:
  - *"Kalkulasi sistem ini bersifat alat bantu estimasi operasional dan tidak menggantikan opini profesional bersertifikasi atau pelaporan resmi regulator."*

#### 5.3 Mandatory Data Privacy Compliance (UU PDP No. 27/2022)
Every application storing user or customer information must incorporate compliance deliverables:
1. **Privacy Policy (Kebijakan Privasi)**: Documenting data collection categories, actual server region/residency (e.g., AWS Jakarta `ap-southeast-3` / Singapore `ap-southeast-1`), statutory retention periods (e.g., 3-10 years for financial records under UU KUP, employment records for HRIS), third-party sub-processors, and user deletion rights.
2. **Terms of Service (Syarat & Ketentuan)**: Stating platform availability limitations, subscription renewal terms, and liability caps.
3. **PII Scrubbing in Error Monitoring (Sentry)**:
   ```javascript
   // sentry.client.config.js
   Sentry.init({
     beforeSend(event) {
       if (event.request) {
         delete event.request.cookies;
         delete event.request.headers;
         delete event.request.data;
         if (typeof event.request.query_string === 'string') {
           event.request.query_string = event.request.query_string.replace(/token=[^&]+/gi, 'token=[REDACTED]');
         }
       }
       if (event.user) {
         delete event.user.email;
         delete event.user.ip_address;
         delete event.user.username;
       }
       if (event.extra) {
         delete event.extra.customer_name;
         delete event.extra.email;
         delete event.extra.phone;
         delete event.extra.amount;
         delete event.extra.nik;
       }
       return event;
     }
   });
   ```
4. **CSV Formula Injection Sanitization**:
   ```typescript
   function sanitizeCSVCell(value: string): string {
     if (/^[\t\r\n=+@|-]/.test(value)) {
       return `'${value}`; // Prepend single quote to neutralize spreadsheet execution
     }
     return value;
   }
   ```

---

### Step 6: Client Dependency Registration (Dependency SLA)
List everything the client must provide to prevent work blockages:
- Payment gateway sandbox keys (Midtrans/Xendit) and transactional email credentials.
- Initial master data in standardized digital templates (CSV/Excel).
- Design approval turnarounds within a strict 3-business-day window.

Include the contractual clause: *Any client dependency handover delay $\ge 3$ business days automatically extends the target production launch date by an equal duration without liability.*

---

### Step 7: Stakeholder Mapping, Communication & Realistic Timelines

#### 7.1 Stakeholder Identification & Power/Interest Matrix
Map all participants into 4 quadrants: Manage Closely (Paying Owner), Keep Satisfied (CFO/Legal), Keep Informed (Power User/Staff), Monitor (End Customers).

#### 7.2 Phase Duration Guidelines & Buffer Rules

| Lifecycle Stage | Small MVP (3–7 Must-Haves) | Medium SaaS (8–15 Must-Haves) | Large Platform (16–25 Must-Haves) |
| :--- | :---: | :---: | :---: |
| **M04 UI/UX Design** | 1 week | **2–3 weeks** (30–50 screens + legal docs) | 3–4 weeks |
| **M05 Architecture** | 0.5 week | **1 week** (ERD + RLS policies) | 1–2 weeks |
| **M06 Development** | 4–6 weeks | **8–12 weeks** | 12–16 weeks |
| **M07 QA & SIT** | 1 week | **2 weeks** (Automated + Manual) | 2–3 weeks |

- **Development Estimation Formula**:
  $$\text{Dev Weeks} = \left[ (\text{Simple CRUD} \times 2.5\text{ days}) + (\text{Complex Features} \times 1\text{ week}) \right] \times 1.20\text{ (Buffer)}$$
- **Change Request (CR) Freeze**: Locked exactly **2 weeks before QA starts** (e.g., if QA starts Week 17, CR freeze is strictly enforced at Week 15).
- **Phase 1.5 Execution Window**: Scheduled strictly post-launch (e.g., Week 5+ for Small MVP, Week 13+ for Medium Solo SaaS, Week 21+ for Large systems), NEVER overlapping with active QA or initial launch.
- **Closed Beta Testing (M07 Week 2)**: Recruit 5 representative business owners with a 3-month free subscription incentive. Conduct 60-minute remote recorded usability sessions.
- **Definition of Done (DoD) Clarification**:
  - *Staging*: Automatic Vercel Preview deployment per pull request with isolated database branch.
  - *Penetration Testing*: Manual security audit testing multi-tenant RLS bypass attempts plus automated Playwright cross-tenant data access tests.

---

## 3. Adaptation Based on Project Scale

| Aspect | Small Scale (MVP / Freelance) | Medium Scale (B2B SaaS / Agency) | Large Scale & Enterprise |
| :--- | :--- | :--- | :--- |
| **Interview Duration** | 1 chat/call session (30–60 min) | 2–3 discovery sessions (1–2 weeks) | Tiered workshops per division (2–4 weeks) |
| **Persona Depth** | 1–2 simple user roles | 3–5 roles with RBAC matrix | Multi-division, department hierarchy, Okta/AD SSO |
| **Scope Document** | 1-page Scope Checklist | Formal Scope Statement & API outline | Full Scope Statement, RTM draft, Compliance scope |
| **Dependencies** | Basic hosting access & payment keys | 2–4 cloud service integrations | Legacy ERP integrations, internal firewall approvals |

---

## 4. Output Artifacts (Deliverables)

### Mandatory Documents (Core Deliverables)

1. **`docs/pm/SCOPE_STATEMENT.md`** (Primary deliverable)
   - Template: `templates/01-discovery-commercial/SCOPE_STATEMENT_TEMPLATE.md`
   - Contents: In-Scope, Out-of-Scope, MoSCoW prioritization, client dependencies

2. **`docs/pm/STAKEHOLDER_MAP.md`** (Company/team projects)
   - Template: `templates/01-discovery-commercial/STAKEHOLDER_MAP_TEMPLATE.md`
   - Contents: Power/Interest matrix, stakeholder register, influence network
   - **Solo dev projects**: Optional (can be condensed to 1 page if only 1-2 clients)

3. **`docs/pm/COMMUNICATION_PLAN.md`** (Company/team projects)
   - Template: `templates/01-discovery-commercial/COMMUNICATION_PLAN_TEMPLATE.md`
   - Contents: Cadence per stakeholder, status report schedule, escalation matrix
   - **Solo dev projects**: Simplified version (1-page update schedule + 1 escalation contact)

4. **`docs/pm/RACI_MATRIX.md`** (Company/team projects)
   - Template: `templates/01-discovery-commercial/RACI_MATRIX_TEMPLATE.md`
   - Contents: Responsible/Accountable/Consulted/Informed per deliverable
   - **Solo dev projects**: Optional (typically: Solo Dev = R, Client = A for most items)

### Complementary Governance & Planning Artifacts (Conditional)

5. **`docs/pm/RISK_REGISTER.md`** (Medium / Large / Client projects with operational exposure)
   - Template: `templates/01-discovery-commercial/RISK_REGISTER_TEMPLATE.md`
6. **`docs/pm/REQUIREMENT_MATRIX.md`** (Traceability from pain points to screens & tests)
   - Template: `templates/01-discovery-commercial/REQUIREMENT_MATRIX_TEMPLATE.md`
7. **`docs/pm/BACKLOG.md`** & **`docs/pm/OKR.md`** (Sprint planning and metric tracking)
   - Templates: `templates/01-discovery-commercial/BACKLOG_TEMPLATE.md` & `OKR_TEMPLATE.md`

### Reference Guide

- **`references/pm/PM_COMMUNICATION_GUIDE.md`**: Business communication skills, status report templates, stakeholder management tactics

> 📁 **ABSOLUTE FILE LOCATION RULE**:
> All PM documents MUST be stored inside the **`docs/pm/`** directory (never in the root directory).
> Storing scope documents in the project root is strictly prohibited.

### Adaptation Based on Context

**Solo Developer (Freelance/Consultant)**:
- **Mandatory**: SCOPE_STATEMENT.md
- **Optional**: STAKEHOLDER_MAP.md (1-page simplified), COMMUNICATION_PLAN.md (1-page), RACI_MATRIX.md (skip if only 2 people)

**Company/Team (Internal or B2B)**:
- **Mandatory**: All 4 documents above
- **Rationale**: Multiple stakeholders, complex approval chains, clear decision-making authority needed

---

## 🛑 [GATE] EXIT & MANDATORY STOP PROTOCOL

After the file `docs/pm/SCOPE_STATEMENT.md` has been written:

### **STEP 0: FILE EXISTENCE VERIFICATION (BLOCKING CHECK)**

**MANDATORY BEFORE CONTENT VALIDATION**:

1. **Verify output file existence** using one of the following methods:
   - PowerShell: `Test-Path -LiteralPath "docs/pm/SCOPE_STATEMENT.md"` → must return `True`
   - Bash/Zsh: `test -f "docs/pm/SCOPE_STATEMENT.md" && echo "True" || echo "False"`
   - Read and verify file `docs/pm/SCOPE_STATEMENT.md` → must succeed without error

2. **IF FILE DOES NOT EXIST**:
   - ❌ **STOP IMMEDIATELY** - do not proceed to content validation
   - ❌ **DO NOT present summary** to user
   - ❌ **DO NOT prompt for scope confirmation**
   - ✅ **REPORT ERROR** to user:
     ```
     CRITICAL ERROR: SCOPE_STATEMENT.md file was not created.
     Module 02 FAILED - cannot proceed to Module 03 (Legal SOW & Charter).
     
     Possible causes:
     - Write permission denied on docs/pm/ directory
     - Path typo in tool call
     - Disk full
     
     Please investigate this issue before proceeding.
     ```
   - ✅ **END TURN** and wait for user to fix issue

3. **ONLY IF FILE EXISTS**: Proceed to content validation below

---

### **STEP 1: CONTENT VALIDATION & SCOPE CONFIRMATION**

1. **STRICTLY FORBIDDEN to proceed directly or invoke tools for Module 03 within the same turn!**
2. **CONTENT VERIFICATION (Self-Verification Checklist)**:
   - [ ] Read and verify file `docs/pm/SCOPE_STATEMENT.md` → Confirm all required sections (Objectives, RBAC, MoSCoW, User Stories, Boundaries, SLA) are complete
   - [ ] Must-Have count strictly within scale limits: Small (3–7), Medium (8–15), Large (16–25)
   - [ ] Zero ambiguous terms ("TBD", "maybe", "if time permits", "tentative") in Must-Have rows
   - [ ] **Problem-Solution Fit**: Must-Haves collectively resolve $\ge 70\%$ of root causes, and every individual Must maps to at least one primary friction
   - [ ] **Target Segment Dependency**: Retained personas require zero out-of-scope features to experience core value
   - [ ] **Multi-Tenant Schema**: Every table includes `org_id UUID NOT NULL` with RLS querying `public.user_roles`
   - [ ] **Financial Precision**: Money stored as `DECIMAL`, `unit_cost` snapshot present in line items, movements append-only
   - [ ] **RBAC Approval Workflow**: Documented decision tree with zero self-approval for managers
   - [ ] **Mandatory Revenue Features**: Billing & subscription engine (F-XX) and offboarding flow included in P0
   - [ ] **Legal Compliance**: Privacy Policy, Terms of Service, PP 55/2022 jo. PP 20/2026 tax disclaimers, and Sentry PII scrubbing planned
   - [ ] **Realistic Timeline**: Epic sum + 20% buffer matches timeline claim; CR freeze set to QA start minus 2 weeks
   - [ ] Out-of-Scope section documented with ≥3 explicit exclusions
   - [ ] Data Confidence Legend declared (`[✅ / 🔶 / ❓]`)
   - [ ] Client dependencies listed with SLA timeline
3. Present a scope boundary summary to the user:
   - List of Must-Have (P0) features
   - Explicit list of Out-of-Scope features prohibited from being built
   - Data/access dependencies required from client (Dependency SLA)
4. **END YOUR RESPONSE (END TURN)** and ask for confirmation from the user:
   - **If Solo SaaS / Self-Initiated Project**:
     > *"Document `docs/pm/SCOPE_STATEMENT.md` completed with [X] Must-Have features and locked scope boundaries. As a self-initiated product, commercial SOW (M03) is skipped. Proceed to Module 04 (UI/UX Prototyping)?"*  
     > *(Indonesian: "Dokumen `docs/pm/SCOPE_STATEMENT.md` selesai dengan [X] fitur Must-Have. Untuk produk solo SaaS, kontrak SOW dilewati. Apakah disetujui untuk lanjut ke Modul 04 (UI/UX Prototyping)?")*
   - **If Client Commercial Project**:
     > *"Document `docs/pm/SCOPE_STATEMENT.md` completed with [X] Must-Have features and locked scope boundaries. Proceed to Module 03 (Legal SOW & Project Charter) to finalize milestone terms and down payment gate?"*  
     > *(Indonesian: "Dokumen `docs/pm/SCOPE_STATEMENT.md` selesai dengan [X] fitur Must-Have. Apakah disetujui untuk lanjut ke Modul 03 (Legal SOW & Project Charter) untuk penguncian termin dan DP?")*
   - **If Small Fast-Track MVP**:
     > *"Document `docs/pm/SCOPE_STATEMENT.md` (or `PROJECT_LITE.md`) completed. Proceed to Module 04/M05 (Rapid Specifications & UI Tokens)?"*
5. Wait for explicit user approval before proceeding to the designated next module.
