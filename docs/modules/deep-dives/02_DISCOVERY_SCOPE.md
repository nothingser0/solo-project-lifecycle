# M02 Deep Dive: Discovery & Scope — Extended Material

## Contents

- [1. Business Metrics Ramp Table (Full)](#1-business-metrics-ramp-table-full)
- [2. RBAC Matrix (Full Example — Retail/Accounting Archetype)](#2-rbac-matrix-full-example-retailaccounting-archetype)
- [3. SQL Schema Patterns (Full)](#3-sql-schema-patterns-full)
- [4. Architecture Decision Matrices (Full)](#4-architecture-decision-matrices-full)
- [5. Legal Templates (Full)](#5-legal-templates-full)
- [6. Stakeholder & Timeline Details](#6-stakeholder-timeline-details)


Companion to [`../02_DISCOVERY_SCOPE.md`](../02_DISCOVERY_SCOPE.md). Reference links: `references/checklists/MODULE_02_EVALUATION_CHECKLIST.md`, `references/checklists/REQUIREMENT_ELICITATION_GUIDE.md`, `references/pm/PM_COMMUNICATION_GUIDE.md`.

## 1. Business Metrics Ramp Table (Full)

| Timeline Post-Launch | Realistic Cumulative Customers | Monthly Acquisition | Typical MRR (@ Rp 99k) |
|---|---|---|---|
| Month 1 | 5–10 | Beta cohort conversion | Rp 500k – 1M |
| Month 3 | 20–30 | +5–10 / mo (organic referrals) | Rp 2M – 3M |
| Month 6 | 50–75 | +10–15 / mo (initial PMF) | Rp 5M – 7.5M |
| Month 12 | 50–100 | +10–15 / mo (scaling) | Rp 5M – 10M |

Year-1 baseline: 50–100 paying customers (Rp 5–10M MRR). Anti-patterns: "500 customers / Rp 50M MRR in Month 1"; pairing D30 retention 40% with 24-month LTV. D30 benchmark 30–40%; churn 30–50%/yr → lifetime 12–18 months.

**Non-circular NSM**: ❌ "70% of WAU record ≥5 tx/week" (circular). ✅ "Active Tenant Rate = 70% of signed-up organizations with ≥1 login in past 30 days record ≥5 operational transactions/week."

**Pre-launch smoke test**: Carrd/Webflow landing (2 days) with WTP question ("Would you pay Rp 99k/month?"). Gate: 50–100 signups in 2 weeks before major development investment.

## 2. RBAC Matrix (Full Example — Retail/Accounting Archetype)

| Role | Name | Create | Read | Update | Delete/Void | Special guardrails |
|---|---|---|---|---|---|---|
| ROL-01 | Owner | All resources | All org locations | All resources | **Void only** (immutable audit; soft-delete `is_active=false`) | Full control, staff invites, billing, financial statements |
| ROL-02 | Manager | Transactions, stock adjustments | Assigned locations (`location_ids[]`) | Transactions, products | Void (assigned locations only) | Approves adjustments >Rp 1M or variance >10%; **ZERO SELF-APPROVAL** |
| ROL-03 | Kasir | **Sales transactions only** | Inventory (own location only) | Own same-day sales | **CANNOT VOID** (escalate to Manager) | Hidden buy price (query layer excludes cost fields); zero profit-report access |
| ROL-04 | Akuntan | None | Financial statements, tax reports, ledgers | None | None | Read-only; export PDF/Excel; cannot alter balances |

**Location assignment**: Owner = global; Manager = `user_roles.location_ids UUID[]` multi-assignment; Kasir = bound to first element.

**Stock adjustment approval decision tree**:
```text
Kasir   ──► CANNOT CREATE (inventory read-only)
Manager ──► Value < Rp 1M AND variance < 10%   ──► Auto-Approved
Manager ──► Value ≥ Rp 1M OR variance ≥ 10%    ──► Requires OWNER approval
Manager ──► Own created adjustment (any value) ──► Requires OWNER approval (NO SELF-APPROVAL)
Owner   ──► Auto-Approved (highest authority)
```

**Session timeouts**: Kasir (shared POS hardware) 24-hour max with auto-lock on inactivity; Owner/Manager/Akuntan (personal) 7-day with refresh-token rotation.

## 3. SQL Schema Patterns (Full)

**RLS policy** (query the application table, not the protected auth schema):
```sql
-- ✅ CORRECT:
CREATE POLICY org_isolation ON transactions
FOR ALL USING (
  org_id = (SELECT org_id FROM public.user_roles WHERE user_id = auth.uid() LIMIT 1)
);
-- ❌ WRONG: org_id = auth.user_org_id() (auth schema is read-only)
```

**System audit trail**:
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

**Financial precision**: `DECIMAL(15,2)`/NUMERIC only (never FLOAT); `transaction_items.unit_cost DECIMAL(15,2) NOT NULL` snapshot at checkout (never recalculate COGS from current master data); `inventory_movements` append-only (no UPDATE/DELETE); transactions void via `voided_at` + `voided_by_user_id` (records permanent); no `balance_after` in movement records (race conditions) — compute via SUM triggers or read-model projections. Offline: `idempotency_key TEXT UNIQUE` + `device_timestamp TIMESTAMPTZ` (server `created_at` remains authoritative).

**Column-level security**: RLS filters rows not columns — hide `buy_price` via application query builders (Prisma select / Supabase `.select('id, name, sell_price')`).

## 4. Architecture Decision Matrices (Full)

**Offline-first**:
| Scale & Connectivity | Recommendation | Rationale |
|---|---|---|
| <100 users / 1–2 locations / stable 4G | Online-Only MVP | Defer offline sync; no conflict resolution |
| 100–500 users / intermittent 3G | Selective Offline | Cache catalogue; queue sales with retry guards |
| 500+ users / harsh connectivity | Full Offline-First | IndexedDB (Dexie) + append-only delta sync (never LWW) |

**Real-time**: latency >5s → 30-second polling or manual refresh; <5s → WebSocket broadcast channels (Supabase Realtime Broadcast); avoid Postgres Changes on large tables with complex RLS (subscriber overhead).

**Performance budgets**: TTI <5s on 3G (not <3s); initial JS <200KB gzipped; API p95 <500ms (Indonesia–Singapore baseline 50–100ms); client-side PDF via `@react-pdf/renderer` (avoid serverless Puppeteer: 50MB bundle, 10s timeouts).

**Version pinning**: Next.js `15.0.x`, React `19.0.x`, Tailwind `4.0.x`, TypeScript `5.6.x`, Dexie `4.0.x` — never "latest" or floating ranges.

**Accurate security claims**: ❌ "RLS prevents SQL injection" (RLS = authorization; SQLi prevented by parameterized queries) · ❌ "Supabase handles CSRF tokens" (mitigated via SameSite=Lax cookies) · ❌ "pgcrypto = at-rest encryption" (application tool; at-rest is AWS/PostgreSQL AES-256 storage).

## 5. Legal Templates (Full)

**UU PDP deliverables**:
- Privacy Policy: collection categories, actual server region (AWS Jakarta `ap-southeast-3` / Singapore `ap-southeast-1`), statutory retention (3–10 years financial records per UU KUP; HRIS employment records), sub-processors, deletion rights.
- ToS: availability limits, renewal terms, liability caps.

**Sentry PII scrubbing**:
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
      delete event.user.email; delete event.user.ip_address; delete event.user.username;
    }
    if (event.extra) {
      delete event.extra.customer_name; delete event.extra.email; delete event.extra.phone;
      delete event.extra.amount; delete event.extra.nik;
    }
    return event;
  }
});
```

**CSV formula-injection sanitization**:
```typescript
function sanitizeCSVCell(value: string): string {
  if (/^[\t\r\n=+@|-]/.test(value)) {
    return `'${value}`; // neutralize spreadsheet execution
  }
  return value;
}
```

**Tax disclaimers**: PPh UMKM — PP 55/2022 jo. PP 20/2026 (enacted 22 Apr 2026): 0.5% PPh Final facility has no time limit but is restricted to WP OP, PT Perorangan, Koperasi with turnover ≤ Rp 4.8B/yr; NOT eligible for CV, Firma, PT Non-Perorangan, BUMDes. Model the Rp 500M non-taxable threshold for WP OP. In-app: *"Perhitungan pajak bersifat estimasi operasional dan tidak menggantikan pelaporan resmi pada DJP. PPN tidak diperhitungkan (non-PKP)."* HRIS — PP 58/2023 & PMK 168/2023 (TER Kategori A/B/C) + BPJS Ketenagakerjaan & Kesehatan; in-app: *"Kalkulasi PPh 21 TER dan BPJS bersifat panduan internal; verifikasi akhir oleh pejabat pemotong pajak terdaftar."* General: *"Kalkulasi sistem ini bersifat alat bantu estimasi operasional dan tidak menggantikan opini profesional bersertifikasi atau pelaporan resmi regulator."*

## 6. Stakeholder & Timeline Details

**Power/Interest quadrants**: Manage Closely (paying owner) / Keep Satisfied (CFO, legal) / Keep Informed (power users, staff) / Monitor (end customers).

**Phase duration guidelines**:
| Stage | Small (1–5 Must) | Medium (6–15 Must) | Large (16–25 Must) |
|---|---|---|---|
| M04 UI/UX | 1 wk | 2–3 wks (30–50 screens + legal docs) | 3–4 wks |
| M05 Architecture | 0.5 wk | 1 wk (ERD + RLS) | 1–2 wks |
| M06 Development | 4–6 wks | 8–12 wks | 12–16 wks |
| M07 QA & SIT | 1 wk | 2 wks (automated + manual) | 2–3 wks |

Dev estimation: `Dev Weeks = [(Simple CRUD × 2.5 d) + (Complex Features × 1 wk)] × 1.20`. CR freeze exactly 2 weeks before QA starts (QA wk 17 → freeze wk 15). Phase 1.5 strictly post-launch (Small wk 5+, Medium wk 13+, Large wk 21+), never overlapping QA or launch. Closed beta (M07 wk 2): 5 representative business owners, 3-month free subscription, 60-min recorded remote usability sessions. Definition of Done: staging = per-PR preview deploy with isolated DB branch; pentest = manual multi-tenant RLS bypass attempts + automated Playwright cross-tenant access tests.

**Dependency SLA clause**: *"Any client dependency handover delay ≥ 3 business days automatically extends the target production launch date by an equal duration without liability."* Required inputs: Midtrans/Xendit sandbox keys, transactional email credentials, master data in standardized CSV/Excel templates, ≤3-business-day design approval turnaround.

## Runbook Originals (moved 2026-11-04)

Original text verbatim, so no clause is lost when a condensed step is ambiguous.

```markdown
# Module 02: Discovery & Scope Definition

> **Template to copy**: `templates/01-discovery-commercial/SCOPE_STATEMENT_TEMPLATE.md` · use cases: `templates/01-discovery-commercial/USE_CASE_SPECIFICATION_TEMPLATE.md` (scope first: coffee-break test + goal level, then the 14 fields, then the 20-point check) · client/Medium+: `templates/01-discovery-commercial/STAKEHOLDER_MAP_TEMPLATE.md` (→ `docs/pm/STAKEHOLDER_MAP.md`)
> **Decision ledger**: `templates/03-governance/DECISION_LOG_TEMPLATE.md` (→ `docs/DECISION_LOG.md`) — every decision across every phase, appended and superseded, never rewritten
> **Meeting records**: `templates/01-discovery-commercial/MEETING_NOTES_TEMPLATE.md` (→ `docs/pm/meetings/YYYY-MM-DD_<topic>.md`) — decisions, action items and open questions separated, never fabricated
> **Companion registers** (copy when needed): `BUSINESS_RULES_REGISTER_TEMPLATE.md` · `ASSUMPTIONS_CONSTRAINTS_TEMPLATE.md` · `REQUIREMENTS_REGISTER_TEMPLATE.md` (→ `docs/pm/`, same base name)
> 📖 **Optional refs**: `references/checklists/MODULE_02_EVALUATION_CHECKLIST.md` · `references/ba/USE_CASE_SPECIFICATION_CRAFT_GUIDE.md` · `references/ba/REQUIREMENTS_TRACEABILITY_AND_RTM_GUIDE.md` · `references/pm/STAKEHOLDER_REQUEST_DECODING_PLAYBOOK.md` · `references/pm/KANBAN_CARD_CRAFT_GUIDE.md` (Summary/Description craft, work-type examples, minimum card fields) · `references/pm/EPIC_BREAKDOWN_PATTERNS.md` (load only when an epic or implementation task is too large to slice) · `patterns/product/BUSINESS_ANALYSIS_DISCOVERY_PATTERN.md` (elicitation mix, ambiguity classes, review passes) (do NOT preload)

**Purpose**: extract real requirements, define technical boundaries, and lock **In/Out-of-Scope** into `SCOPE_STATEMENT.md` **before** contracts or design.

**Pre-Contract Work**: discovery (M00–02) is typically unpaid for new clients; DP (Milestone 1, M03) triggers paid work. Repeat clients: consider a discovery fee.

---

## 1. Execution Rules

### Step 1 — Discovery Interview (5 Pillars)
- Verify decision authority; dissect needs vs wants.
- **Outcome measures**: Gunakan baseline dan bukti bisnis yang sudah dikumpulkan di M00/M01 bila tersedia; jangan menyalin target pertumbuhan SaaS generik ke setiap proyek. Untuk proyek klien atau jalur tanpa M00, sepakati ukuran keberhasilan, definisi, baseline, target, sumber data, pemilik, dan jangka waktunya. Tandai nilai yang belum diketahui sebagai asumsi atau unknown.
- **Non-circular NSM**: ❌ "70% of WAU record ≥5 tx/wk" (circular). ✅ "70% of signups with ≥1 login in 30 days record ≥5 tx/wk."
- **Guardrail Metrics**: pair the North Star Metric with operational guardrails that must NOT degrade (e.g., checkout API p95 latency ≤500ms, inventory discrepancy ≤0.5%, zero unhandled transaction exceptions).
- Jika validasi pasar sudah dilakukan di M00, warisi hasilnya dan hindari mengulang smoke test atau wawancara yang sama. Untuk proyek yang melewati M00, gunakan kebutuhan elicitation M02 untuk menetapkan outcome dan batas ruang lingkup; jangan menganggap angka signup sebagai syarat universal.

### Step 2 — Problem-Solution Fit, MoSCoW & Acceptance Criteria
- Must-Haves **collectively** resolve ≥70% of root causes; every Must maps to a primary bottleneck (zero vanity P0s). Secondary-friction features demote to Should/Won't.
- **Workflow-to-scope map (conditional)**: Bila ada beberapa peran/alur inti atau irisan MVP belum jelas, petakan tujuan pengguna → aktivitas → langkah/tugas, lalu tandai irisan end-to-end yang tetap memberi hasil berguna. Gunakan peta untuk menemukan celah dan menentukan batas rilis; peta bukan backlog kedua. Hapus bagian peta dari template bila alur sudah jelas atau pemetaan tidak diperlukan.
- **Story slicing**: Setiap story harus menyampaikan nilai pengguna yang bisa diuji. Jika terlalu besar untuk diestimasi atau memuat beberapa alur/aturan, pecah pada batas alur kerja, variasi aturan/data, atau dependensi eksternal sambil menjaga tiap irisan tetap bernilai. Jangan memecah story pengguna menjadi tiket frontend/backend; detail tugas teknis diturunkan di tahap implementasi.
- **Epic hypotheses (for strategic epics)**: For each strategic epic or release slice, record the target user and outcome, an `If [change] for [user], then [measurable outcome], because [evidence]` hypothesis, the leading signal and target/time window, and the decision if the signal moves or does not. Link to existing outcome metrics and evidence; do not create a second roadmap or assume every atomic requirement needs its own hypothesis.
- **Oversized epic breakdown (conditional)**: When a story remains too large to estimate or deliver as one user-valued slice, use the relevant workflow, business-rule, data, CRUD, or spike pattern in `references/pm/EPIC_BREAKDOWN_PATTERNS.md`. Preserve a useful end-to-end user result in each M02 release slice; reserve implementation task breakdown for M06.
- **Prioritization**: Gunakan MoSCoW untuk menetapkan batas scope dan hitung P0 sesuai batas skala. Jangan menumpuk RICE/ICE di atas keputusan yang sama. Bila urutan P1/P2 masih perlu diputuskan, pilih satu metode yang sesuai dengan bukti dan konteks; skor tidak mengalahkan kebutuhan legal, keamanan, atau dependensi wajib.
- **Type before wording** (`patterns/product/BUSINESS_ANALYSIS_DISCOVERY_PATTERN.md` §4): classify each item as functional / non-functional / business rule / constraint first. Changes when the UI is redesigned → functional; must hold regardless → business rule. Ambiguity classes (§4.1) name the fix; banned-word table: `REQUIREMENTS_AMBIGUITY_CHECKLIST.md`.
- **Given-When-Then Acceptance Criteria**: Every P0 Must-Have User Story MUST include at least one concrete BDD scenario (`Given [initial context], When [action occurs], Then [expected outcome]`). Vague statements ("the system allows users to cancel orders") are invalid and block scope locking.
- **Scope red-team before lock**: Challenge the draft for unsupported features, missing or excluded users, outcomes with no observable measure, contradictory priorities, unpriced dependencies, weak acceptance criteria, and hidden legal/operational obligations. Record each material challenge, affected ID, evidence, and disposition (change, defer with reason, or reject with reason). The human scope owner resolves trade-offs and approves the lock; adversarial review does not silently change scope.
- **Test traceability**: Give each acceptance criterion a stable requirement/story ID and map it to a concrete test scenario. For interactive flows, use the canonical wireflow scenarios from M04 and reference their `WFxx` IDs instead of copying the same scenario into a second source. M07 must trace each in-scope criterion to an executed test and recorded evidence; uncovered criteria remain open.
- **Non-Functional Requirements (NFR) Baseline**: Explicitly define quantitative system boundaries:
  - Max concurrent users target for MVP (e.g. 50–100 active sessions).
  - Latency SLA target (API p95 ≤500ms, page TTI ≤3s on 4G).
  - Supported platforms (e.g. Chrome/Safari evergreen versions; legacy browser optimization is explicitly Out-of-Scope).
- Segment audit: if MVP excludes a capability a persona needs for core value (e.g., BOM for cafes), **drop the segment or upgrade the feature**.
- Dependency contradiction: deferred expense tracking ⇒ "Gross Profit (Laba Kotor)" only.
- MoSCoW P0 limits: Small 1–5 · Medium 6–15 · Large 16–25 (solo allowed with a signed `SOLO-CAPACITY-RISK-ACCEPTANCE.md`; a non-delegable obligation routes to A-Series) · >25 → A-Series advisory.
- **Mandatory SaaS revenue P0s** (except internal tools): billing & basic subscription/access check. Thermal receipt printing and complex admin overrides demote to P1/P2 unless explicitly required by the core business model.

### Step 3 — RBAC Matrix & Approval Tree
- Permission table per role (CRUD + guardrails), e.g., Owner/Manager/Kasir/Akuntan: Kasir cannot void or see buy price; Manager approval requires **ZERO SELF-APPROVAL**; Owner auto-approves.
- Locations via `user_roles.location_ids UUID[]`; session timeouts (shared POS 24h auto-lock, personal 7-day rotation).

### Step 4 — Architecture & Schema
- Multi-tenant: `org_id UUID NOT NULL` on every table (junctions included); RLS queries `public.user_roles`; column hiding in query builders (RLS filters rows, not columns).
- Financial: `DECIMAL(15,2)` (never FLOAT), `unit_cost` snapshot on line items, append-only `inventory_movements`, void via status columns, no `balance_after` (races); `idempotency_key` + `device_timestamp` if offline; `audit_logs` table.
- Realism: <100 users/1–2 locations → online-only MVP; TTI <5s on 3G, JS <200KB gz, API p95 <500ms; client-side PDF (no serverless Puppeteer); pin minor versions (never "latest"); accurate security claims (RLS ≠ SQLi prevention; at-rest is provider AES-256, not pgcrypto).

### Step 5 — Scope Boundaries & Legal
- Civil-law principle: everything not explicitly In-Scope is outside the developer's responsibility. Exclusions (≥3): legacy digitization, third-party licensing, local hardware/network faults, formal legal/tax counsel.
- Tax disclaimers citing regulations (PP 55/2022 jo. PP 20/2026 PPh UMKM; PP 58/2023 & PMK 168/2023 PPh 21 TER + BPJS) plus the general estimation disclaimer.
- UU PDP 27/2022: Privacy Policy (region, retention, sub-processors), ToS, Sentry PII scrubbing, CSV injection sanitization.
- ⚠️ **LEGAL REVIEW REQUIRED**: the agent may **draft** the Privacy Policy, ToS, and tax disclaimers as operational templates, but they are **not legal advice** and must carry the marker below until a qualified professional reviews them. Same rule as M03 and A00. The agent must never present drafted legal text as final or advice.

  ```text
  LEGAL-REVIEW: PENDING — DRAFT TEKNIS, WAJIB DITINJAU OLEH LEGAL COUNSEL / PAKAR PAJAK SEBELUM DIPUBLIKASIKAN
  ```

  The human flips the marker to `LEGAL-REVIEW: REVIEWED by <name> on <YYYY-MM-DD>` after review. Publishing legal text (privacy policy live on the domain, terms accepted at signup, tax figures in marketing) before that is a **FROZEN-spec violation**.

### Step 6 — Client Dependency SLA
Register inputs: sandbox keys, email credentials, master data CSV/Excel, ≤3-business-day approvals. Clause: delay ≥3 business days extends launch equally, without liability.

### Step 7 — Stakeholders & Timeline
- Power/Interest matrix (Manage Closely / Keep Satisfied / Keep Informed / Monitor); cadence + escalation.
- Durations: M04 1–3 wks; M05 0.5–1 wk; M06 4–16 wks; M07 1–3 wks. Dev formula: `[(simple CRUD × 2.5d) + (complex × 1wk)] × 1.20`. **CR freeze = QA start − 2 weeks.** Phase 1.5 strictly post-launch. Closed beta (M07 wk 2): 5 owners, 3-mo free, 60-min recorded sessions.

---

## 2. Scale Adaptation

| Aspect | Small | Medium | Large | Enterprise |
|---|---|---|---|---|
| Path | SKIPPED (`PROJECT_LITE.md`) | Full M02 mandatory | Full M02, solo under a signed risk acceptance | A01 (WBS) — non-delegable |
| RBAC | 1–2 roles | 3–5 roles + matrix | Corporate catalog |
| Stakeholder docs | Waived | MAP + PLAN (client/internal) | Corporate RACI |

---

## 3. Output Artifacts

All in **`docs/pm/`**:
1. **`docs/pm/SCOPE_STATEMENT.md`** (mandatory): objectives, outcome hypotheses when strategic epics exist, MoSCoW, stories, RBAC, In/Out-of-Scope, dependencies, SLA, and red-team dispositions. Stub-checked only (<40B fails) — quality is judged by the §Gate Exit Protocol checklist, not byte count.
2. **`STAKEHOLDER_MAP.md`**, **`COMMUNICATION_PLAN.md`**, **`RACI_MATRIX.md`** — client/internal; 1-page for solo.
3. Conditional: `RISK_REGISTER.md`, `REQUIREMENT_MATRIX.md`, `BACKLOG.md`, `OKR.md`.
4. **Use case specifications** (when the scope needs actor-level detail): `docs/pm/use-cases/UC-<MODULE>-<NN>_<name>.md` from `USE_CASE_SPECIFICATION_TEMPLATE.md`. One file per use case; each UC ID is cited from `REQUIREMENTS_REGISTER.md`.
5. **Type-separated registers** (copy only when needed; rules in `patterns/product/BUSINESS_ANALYSIS_DISCOVERY_PATTERN.md` §4): `BUSINESS_RULES_REGISTER.md` (each rule cites a source and an enforcement point — a rule enforced by nothing is an **orphan rule**) · `ASSUMPTIONS_CONSTRAINTS.md` (each assumption owned + testable; each constraint hard/soft with a design impact) · `REQUIREMENTS_REGISTER.md` (`FR-`/`NFR-`/`BR-`/`CON-` separated, each with a source and an acceptance criterion).

---

## Gate Exit Protocol

### STEP 0 — File Existence Check (BLOCKING)
`test -f docs/pm/SCOPE_STATEMENT.md` must succeed. If missing: **STOP IMMEDIATELY** — no validation, no summary, no prompt. Report `CRITICAL ERROR: SCOPE_STATEMENT.md file was not created. Module 02 FAILED - cannot proceed to Module 03 (Legal SOW & Charter).` and END TURN.

### STEP 1 — Content Validation
1. Stop/continue is governed by SKILL.md rule 3 (M03 is a gate only for Client projects; Small and Solo SaaS chain onward).
2. Checklist:
   - [ ] Required elements complete (Objectives, outcome hypotheses for strategic epics when applicable, RBAC, MoSCoW, Stories with Given-When-Then criteria, NFR baseline, Boundaries, SLA)
   - [ ] Must-Have count within scale limits; zero ambiguous terms (TBD/maybe/tentative) in Must rows
   - [ ] Must-Haves resolve ≥70% of root causes; personas need zero out-of-scope features
   - [ ] Multi-tenant schema (`org_id` + RLS via `public.user_roles`); financial precision (`DECIMAL`, `unit_cost` snapshot, append-only movements)
   - [ ] RBAC tree with zero self-approval; revenue features (billing + offboarding) in P0
   - [ ] NFR baseline defined (max concurrent users, API p95 latency, platform/browser boundary)
   - [ ] Legal compliance planned (Privacy Policy, ToS, tax disclaimers, PII scrubbing); legal/tax text carries a `LEGAL-REVIEW:` marker
   - [ ] `Scope-P0-Count` is a real number matching counted Must rows; `Scope-Lock-Decision` is `LOCKED`
   - [ ] Timeline: epic sum + 20% buffer; CR freeze = QA − 2 wks; ≥3 Out-of-Scope exclusions; confidence legend (✅/🔶/❓); dependencies with SLA
   - [ ] Red-team challenges recorded with affected IDs and dispositions; human scope owner resolved trade-offs before `Scope-Lock-Decision: LOCKED`
   - [ ] **Registers (if used) are sound**: no `BR-` row without a source + enforcement point (**zero orphan rules**); every ❓ assumption has an owner and a validation approach (never agent-validated); every hard constraint has a design impact, every soft one states its cost
3. Present scope summary: P0 features, Out-of-Scope list, client dependencies.

### STEP 2 — Gate Verification (MANDATORY)

```
[PASTE RAW OUTPUT OF: ./scripts/gates/validate-gate.sh M02]
```

**MANDATORY**: Execute `./scripts/gates/validate-gate.sh M02` (or `.ps1`). Exit 1 = incomplete; fix and re-run before declaring completion.

### STEP 3 — Report & Continue
Present the scope summary. Client projects pause for approval before M03 (a [GATE]); Solo SaaS / Small continue to M04 once the gate passes.
```
