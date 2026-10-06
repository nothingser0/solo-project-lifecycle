# System Architecture & Technical Topology (ARCHITECTURE.md)

> **Purpose**: Definitive engineering architecture document defining physical topology, runtime boundaries, complete directory layouts, multi-tenant RBAC models, offline synchronization fallbacks, webhook security, and measurable NFR budgets.
> **Standard**: Zero naive network assumptions, production Supabase/Next.js parity, and domain-adaptive scaling across all project tiers (Small, Medium, Large, Enterprise).
> **Input Reference**: `docs/specs/FSD.md` and `docs/specs/PRD.md`

---

## 1. System Topology & Infrastructure Architecture

```text
[ Browser Client / iOS iPad / Mobile PWA ]
                    │
                    ▼ (HTTPS / TLS 1.3 - Next.js App Router)
    [ Edge Network & Reverse Proxy (Vercel / Cloudflare / Caddy) ]
                    │
                    ├──► [ Next.js Server (Node.js Runtime / Server Actions) ]
                    │     │
                    │     ├──► [ Supavisor Connection Pooler (Port 6543 / Transaction Mode) ]
                    │     │     │
                    │     │     ▼
                    │     │   [ PostgreSQL Primary Database (Postgres 16+) ]
                    │     │     ├── 100% RLS Coverage (tenant isolation)
                    │     │     ├── Atomic Stored Procedures (SELECT FOR UPDATE)
                    │     │     └── Append-Only Movement Ledgers & Audit Logs
                    │     │
                    │     ├──► [ Redis Cache & Locks (Upstash / Valkey - Optional by Scale) ]
                    │     │     └── Rate Limiting, Session Stores, Background Queue Locks
                    │     │
                    │     ├──► [ Outbound Services (SMTP: Resend / AWS SES) ]
                    │     │     └── Transactional Emails & Alert Notifications
                    │     │
                    │     └──► [ Inbound Webhook Handlers (Payment / External Services) ]
                    │           └── Signature Verification & Idempotent Processing
                    │
                    ▼ (Direct Client HTTPS - Row-Level Security Protected)
          [ Supabase PostgREST API (Direct Read SDK Queries) ]
```

### Runtime Boundary Rules
1. **Node.js Runtime for State Mutations**: All atomic database operations, checkout RPCs, and balance deductions MUST execute in standard `nodejs` runtime (`export const runtime = 'nodejs'`), NOT Edge runtime, to maintain reliable transaction-mode connection pooling via Supavisor.
2. **Direct PostgREST for Filtered Reads**: Read-only queries (product lists, dashboard metrics, article feeds) may query PostgREST directly from client components via `@supabase/ssr`, strictly governed by Row-Level Security (RLS).

---

## 2. Directory Structure & Project Layout

```text
├── .env.example                     # Verified environment variable keys (no secrets)
├── AGENTS.md                        # Absolute AI coding agent safety directives
├── ARCHITECTURE.md                  # System topology & engineering architecture (this file)
├── CONTEXT.md                       # Project business domain and glossary
├── CONVENTIONS.md                   # Code style, naming, and lint rules
├── DESIGN.md                        # Semantic design tokens (colors, typography, spacing)
├── TODO.md                          # Sequential atomic execution tasks
├── next.config.ts                   # Next.js configuration & CSP security headers
├── package.json                     # Pinned dependencies & scripts
├── tsconfig.json                    # TypeScript strict config (noUncheckedIndexedAccess: true)
│
├── supabase/                        # Database migrations & local development
│   ├── config.toml                  # Supabase local environment config
│   ├── seed.sql                     # Seed data for local testing
│   └── migrations/                  # Versioned, additive SQL migrations
│       ├── 20261005000001_initial_schema.sql
│       ├── 20261005000002_rls_policies.sql
│       └── 20261005000003_atomic_rpc_functions.sql
│
└── src/
    ├── proxy.ts                     # Next.js 16 request routing & session guard (or middleware.ts in v15)
    ├── actions/                     # Next.js Server Actions (mutations & state changes)
    │   ├── auth.ts                  # Login, logout, password resets
    │   ├── mutations.ts             # Domain mutations (checkout, stage transitions, publishes)
    │   └── exports.ts               # Spreadsheet / CSV sanitized exports
    ├── app/                         # Next.js App Router (100% SITEMAP mapped)
    │   ├── (auth)/                  # Public authentication route group
    │   │   ├── login/page.tsx
    │   │   └── signup/page.tsx
    │   ├── (dashboard)/             # Protected layout with desktop sidebar & mobile bottom tabs
    │   │   ├── layout.tsx           # Responsive shell & session validation
    │   │   ├── dashboard/page.tsx   # SCR-003 Main overview
    │   │   ├── [resource]/          # Domain resource CRUD pages
    │   │   └── settings/page.tsx    # Organization & account settings
    │   └── api/                     # HTTP Route Handlers
    │       ├── health/route.ts      # Health check endpoint
    │       └── webhooks/            # External payment/service webhook receivers
    │           └── payment/route.ts # Signature-verified webhook handler
    ├── components/
    │   ├── ui/                      # shadcn/ui primitives (Button, Input, Card, Modal, Table)
    │   ├── layout/                  # DesktopSidebar, MobileBottomNav, Topbar
    │   └── domain/                  # Domain-specific components (POSCartDock, StagePipeline, etc.)
    ├── hooks/                       # Custom React hooks (useOfflineSync, useDebounce, useAuth)
    ├── lib/                         # Shared utilities & client initializers
    │   ├── supabase/
    │   │   ├── client.ts            # Browser client (@supabase/ssr createBrowserClient)
    │   │   └── server.ts            # Server client (@supabase/ssr createServerClient with cookie store)
    │   ├── utils.ts                 # cn() class merger & arithmetic helpers
    │   └── csv.ts                   # Formula-injection sanitized spreadsheet exporter
    ├── stores/                      # Client-side state management (Zustand with IndexedDB sync)
    │   └── useDomainStore.ts
    └── types/
        ├── database.ts              # Auto-generated Supabase database types (`supabase gen types`)
        └── domain.ts                # Application interfaces, DTOs, and view models
```

---

## 3. Multi-Tenant Isolation & Role-Based Access Control (RBAC)

### 3.1 Tenant Isolation Architecture
Every database query and mutation is partitioned by tenant identifier (`org_id` / `organization_id`) using PostgreSQL Row-Level Security:
```sql
CREATE POLICY tenant_isolation_policy ON [table_name]
FOR ALL USING (
  org_id = (SELECT org_id FROM public.users WHERE id = auth.uid() AND is_active = TRUE)
);
```

### 3.2 Role Matrix & Boundary Enforcements
*(Adapt roles to project domain: CRM, CMS, HRIS, E-Commerce, Retail, SaaS)*

| Role Code | Role Name | System Access Scope | Financial / Sensitive Data Visibility | Mutation Authority |
| :--- | :--- | :--- | :--- | :--- |
| **ROL-01** | Super Admin / Owner | Unrestricted across all tenant modules | Full visibility (margins, revenue, costs, audit logs) | Full mutation authority, billing management, user provisioning |
| **ROL-02** | Manager / Reviewer | Assigned branches / operational teams | Operational metrics only; high-level reports | Workflow approvals; **ZERO self-approval** on own requests |
| **ROL-03** | Operator / Staff / Rep | Execution workspace (e.g. `/pos`, `/tasks`)| **Completely hidden** (cost prices, salaries, margins) | Creates operational items; cannot void or delete records |
| **ROL-04** | Auditor / Guest / Client| Target report views / read-only portal | Audit trail inspection / invoice history | Read-only; zero mutation permissions |

---

## 4. Mutation Integrity, Concurrency & Offline Fallbacks

### 4.1 Atomic Mutations with Deterministic Row-Locking
To prevent database deadlocks under high-concurrency traffic (e.g. multiple operators updating records simultaneously):
- All multi-row updates in PostgreSQL stored procedures (`plpgsql`) MUST lock affected rows in a consistent, deterministic order:
  ```sql
  -- Always sort lock acquisitions deterministically:
  SELECT quantity FROM inventory
  WHERE org_id = p_org_id AND product_id IN (SELECT (item->>'product_id')::UUID FROM jsonb_array_elements(p_items))
  ORDER BY product_id ASC
  FOR UPDATE;
  ```

### 4.2 Offline Terminal Sequencing & Conflict Resolution (Conditional)
*(Applicable if local-first or disconnected field operations are in scope; mark N/A for online-only apps)*
- **Offline Invoice / Document Sequencing**:
  $$\text{Invoice No} = \text{[BRANCH-CODE]}-\text{[DEVICE-UUID-SHORT]}-\text{[YYYYMMDD]}-\text{[SEQ]}$$
  *Example*: `JKT01-IPAD02-20261005-000142`
  Guarantees zero numbering collisions when multiple disconnected devices sync upon reconnection.
- **Offline Conflict Policy**:
  - *Commerce / POS*: **Oversell Allowed with Audit Reconcile** (prefer completing real-world customer sales; flag discrepancy for supervisor reconciliation if system inventory dips below zero).
  - *CMS / CRM*: **Optimistic Concurrency Lock** (reject mutation if `version` has advanced on server; prompt user to merge changes).
- **iOS Safari Offline Fallback Protocol**:
  Safari on iOS does NOT support the Web *Background Sync API*. Offline sync MUST implement a multi-event fallback:
  1. Primary listener: `window.addEventListener('online', triggerSync)`
  2. Lifecycle listener: `document.addEventListener('visibilitychange', () => { if (document.visibilityState === 'visible') triggerSync(); })`
  3. UI fallback: Persistent visual sync button displaying pending queue count.

---

## 5. Webhook Architecture & Cryptographic Verification

### 5.1 Route Configuration & Middleware Bypass
Webhook endpoints (e.g. Payment Gateway callbacks, Stripe/Midtrans notifications, GitHub webhooks) receive inbound server-to-server HTTP POST requests without browser cookies:
- In `src/proxy.ts` (Next.js 16) or `src/middleware.ts` (Next.js 15):
  ```typescript
  // Explicitly bypass session authentication on webhook route paths:
  if (request.nextUrl.pathname.startsWith('/api/webhooks/')) {
    return NextResponse.next();
  }
  ```

### 5.2 Cryptographic Signature Verification
Every webhook handler MUST verify payload authenticity before executing business logic:
```typescript
// Example: Verifying cryptographic signature header
import crypto from 'crypto';

export async function POST(req: Request) {
  const rawBody = await req.text();
  const signature = req.headers.get('x-signature-key');

  const expectedSignature = crypto
    .createHmac('sha512', process.env.PAYMENT_WEBHOOK_SECRET!)
    .update(rawBody)
    .digest('hex');

  if (signature !== expectedSignature) {
    return NextResponse.json({ error: 'Invalid signature' }, { status: 401 });
  }

  // Parse payload only after signature verification succeeds:
  const payload = JSON.parse(rawBody);
  // Execute idempotent processing...
  return NextResponse.json({ status: 'OK' });
}
```

### 5.3 Webhook Idempotency Processing
- Inbound webhook events record their external event ID in `idempotency_keys` or `webhook_events`.
- If a duplicate webhook event is redelivered by the vendor, the handler returns HTTP 200 immediately without re-triggering side effects (e.g. duplicate subscription renewal or double-invoicing).

---

## 6. Measurable Non-Functional Requirements (NFR Budgets)

| Performance / Engineering Dimension | Production Target Budget | Measurement & Verification Method |
| :--- | :--- | :--- |
| **Checkout / Mutation Latency** | **$p95 \le 250\text{ ms}$** under normal operational load | Server Action timing logs / Datadog APM |
| **API Endpoint Response Time** | **$p95 \le 500\text{ ms}$** (accounting for SG/ID cloud latency) | Next.js Route Handler metrics |
| **Database Concurrency Capacity** | **$\ge 50$ parallel transactions/tenant** without deadlock | k6 load tests running against staging pooler |
| **Client JS Initial Bundle Budget** | **$\le 250\text{ KB}$ gzipped** (first load JS per route) | `@next/bundle-analyzer` build audit |
| **Mobile Time to Interactive (3G)** | **$\le 5.0\text{ seconds}$** on simulated 3G network | Chrome Lighthouse Mobile audit |
| **Disaster Recovery RPO** | **$< 1\text{ hour}$** (maximum data loss window) | Automated daily WAL backups & point-in-time recovery |
| **Disaster Recovery RTO** | **$< 4\text{ hours}$** (maximum time to restore full service) | Staging disaster recovery dry run |

---

## 7. Automated Architecture Validation Checklist

*Before completing `docs/specs/ARCHITECTURE.md`, verify:*

- [ ] **1. Directory Map Parity**: Root `supabase/` folder, Next.js 16 `proxy.ts`, `src/actions/`, `src/hooks/`, `src/stores/`, and `src/types/database.ts` are documented.
- [ ] **2. iOS Safari Offline Mitigation**: Disconnected sync strategy includes `online`, `visibilitychange`, and manual trigger fallbacks.
- [ ] **3. Collision-Free Device Sequencing**: Multi-device offline identifiers use isolated branch and device prefixes.
- [ ] **4. Webhook Security & Bypass**: Webhook endpoints are excluded from session guards and verify cryptographic payload signatures.
- [ ] **5. Measurable NFR Budgets**: Latency ($p95 \le 250$ms), bundle budget ($\le 250$KB gzipped), and RPO/RTO metrics are explicitly defined.
