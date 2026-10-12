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
| Stage | Small (3–7 Must) | Medium (8–15 Must) | Large (16–25 Must) |
|---|---|---|---|
| M04 UI/UX | 1 wk | 2–3 wks (30–50 screens + legal docs) | 3–4 wks |
| M05 Architecture | 0.5 wk | 1 wk (ERD + RLS) | 1–2 wks |
| M06 Development | 4–6 wks | 8–12 wks | 12–16 wks |
| M07 QA & SIT | 1 wk | 2 wks (automated + manual) | 2–3 wks |

Dev estimation: `Dev Weeks = [(Simple CRUD × 2.5 d) + (Complex Features × 1 wk)] × 1.20`. CR freeze exactly 2 weeks before QA starts (QA wk 17 → freeze wk 15). Phase 1.5 strictly post-launch (Small wk 5+, Medium wk 13+, Large wk 21+), never overlapping QA or launch. Closed beta (M07 wk 2): 5 representative business owners, 3-month free subscription, 60-min recorded remote usability sessions. Definition of Done: staging = per-PR preview deploy with isolated DB branch; pentest = manual multi-tenant RLS bypass attempts + automated Playwright cross-tenant access tests.

**Dependency SLA clause**: *"Any client dependency handover delay ≥ 3 business days automatically extends the target production launch date by an equal duration without liability."* Required inputs: Midtrans/Xendit sandbox keys, transactional email credentials, master data in standardized CSV/Excel templates, ≤3-business-day design approval turnaround.
