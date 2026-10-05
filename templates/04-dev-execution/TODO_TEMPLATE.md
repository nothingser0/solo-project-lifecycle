# TODO.md — Engineering Execution Plan & Automated Quality Gates

> **Role & Purpose**: Sequential atomic task list for AI Coding Agents (Cursor / Claude Code / Windsurf / Codex CLI).
> **Execution Rule**: Execute one task $\rightarrow$ run automated verification $\rightarrow$ record evidence $\rightarrow$ check `[x]` $\rightarrow$ advance to next task.
> **Integrity Mandate**: Zero unverified tasks. Zero hallucinated features outside In-Scope. Zero bypassed TypeScript compiler errors.
> **Scale & Domain Adaptability**: Adaptable across all software categories (CRM, CMS, HRIS, E-Commerce, Retail/POS, Fintech, Developer Tools) and all 4 scales:
> - **Small (MVP / Internal)**: Core database, UI shell, essential CRUD, and smoke tests (mark billing, webhooks, offline queues N/A).
> - **Medium (B2B SaaS / Agency)**: 7 Sprints covering multi-tenant RLS, state journals, mutation idempotency, and automated QA.
> - **Large / Enterprise**: Comprehensive execution covering high-concurrency row-locking, audit vaults, load testing, and disaster recovery.

### 100% Atomic Task Ratio Mandate (Anti-Macro Tasks)
Grouping multiple screens or multiple database tables into a single macro task (e.g., "Build SCR-01 to SCR-14" or "Create all database tables") is **strictly prohibited**.
Maintain an exact 1:1 ratio:
- 1 task per database table or migration unit (`M06-DB-xx`).
- 1 task per UI screen (`M06-FE-xx`) specifying exact `SCR-xx`, route, and 5-state matrix.
- 1 task per backend endpoint / Action / RPC (`M06-BE-xx`).
- Dedicated automated test tasks (`M06-TEST-xx`).

### Traceability Mapping Framework
| Task Prefix | Source Document | Primary Concrete Output |
| :--- | :--- | :--- |
| **`M06-DB-xx`** | `docs/specs/FSD.md` (§2, §3, §5) | `supabase/migrations/*.sql` (Tables, RLS, RPCs) |
| **`M06-FE-xx`** | `docs/specs/SITEMAP.md` & `DESIGN_SPEC.md` | `src/app/*` (UI Components & 100% SCR-xx Screens) |
| **`M06-BE-xx`** | `docs/specs/FSD.md` (§4, §5) & `PRD.md` | `src/actions/*.ts` & `src/app/api/v1/*` (Route Handlers) |
| **`M06-TEST-xx`**| `docs/specs/PRD.md` (Acceptance Criteria) | `tests/db/*` & `tests/e2e/*` (pgTAP / Playwright) |

---

## Sprint 1: Database Foundation, DDL Migrations & Atomic Operations

- [ ] **M06-DB-01: Relational Schema & 100% Foreign Key Indexing (Universal)**
  - Define all tables in FSD schema (core entities, authentication, audit logs, and domain tables).
  - Enforce `BIGINT` or `NUMERIC(15, 2)` for monetary values (no float rounding) and `NUMERIC(12, 3)` for fractional quantities.
  - Add explicit `CREATE INDEX` for every column referencing another table (`REFERENCES table(id)`).
  - Add arithmetic CHECK constraints (`net_amount = subtotal - discount`, `quantity > 0`).
  - **Verify**: Run database migration in local development container (`pnpm db:migrate` / `prisma migrate dev` / `supabase db push`).
  - **Expected**: Migration executes with exit code 0; all tables, constraints, and indexes created.
  - **Evidence**: Query `information_schema.tables` and `pg_indexes` confirming 100% table and FK index creation.

- [ ] **M06-DB-02: Access Control, RLS & Security Definer Hardening (Universal)**
  - Enable RLS on multi-tenant tables: `ALTER TABLE [table] ENABLE ROW LEVEL SECURITY;` (or document single-tenant/internal N/A).
  - Create granular, role-differentiated policies (`SELECT`, `INSERT`, `UPDATE`, `DELETE`). Zero lax `FOR ALL` policies.
  - Harden helper functions: `CREATE OR REPLACE FUNCTION get_current_user_org_id() ... SET search_path = public, pg_temp STABLE;` with explicit `is_active = TRUE` check.
  - Provide onboarding bootstrap policy allowing first-time account and organization creation.
  - **Verify**: Automated RLS access tests (attempt cross-tenant SELECT and unauthorized staff INSERT).
  - **Expected**: Cross-tenant queries return 0 rows; unauthorized staff mutations rejected with policy violation.
  - **Evidence**: Test execution log or psql output showing permission denial.

- [ ] **M06-DB-03: Atomic Organization Registration RPC (Universal)**
  - Create stored procedure or atomic transaction `rpc_register_organization` creating organization, tenant owner user, and default workspace in a single transaction (`BEGIN ... COMMIT`).
  - **Verify**: Execute registration call with simulated mid-transaction failure (e.g. duplicate email).
  - **Expected**: Entire transaction rolls back atomically; zero orphaned organization rows created.
  - **Evidence**: Database query confirms 0 rows inserted in `organizations` after simulated failure.

- [ ] **M06-DB-04: Atomic Mutation Stored Procedure / Concurrency Guard (Conditional)**
  - *(Applicable for high-concurrency state transitions, checkouts, reservations, or balance deductions; mark N/A for low-concurrency CRUD)*
  - Implement atomic stored procedure (`rpc_execute_[mutation]`) with deterministic row-locking: `SELECT ... FOR UPDATE ORDER BY id ASC`.
  - Fetch official pricing/valuation from server tables (anti-tampering).
  - Record mutations into an append-only ledger (`inventory_movements`, `balance_movements`, or `entity_activity_logs`) and snapshot historical cost/value.
  - **Verify**: Simulate concurrent execution from 2 sessions attempting to mutate the exact same resource.
  - **Expected**: Second transaction waits cleanly for row lock release; zero deadlocks, zero negative overselling.
  - **Evidence**: Concurrency test log showing serialized lock acquisition and exact final balance match.

- [ ] **M06-DB-05: Sensitive Data Masking & Database Views (Conditional)**
  - *(Applicable if sensitive costs, margins, or executive salaries exist; mark N/A if all data is non-sensitive)*
  - Create secure database views for operational roles (e.g., `products_cashier_view`, `employee_public_view`) excluding sensitive cost prices (`buy_price`), gross margins, or salaries.
  - Revoke direct `SELECT` on sensitive base tables from operational staff roles; grant access strictly via secure views (`security_invoker = true`).
  - **Verify**: Query API / SDK with a Staff JWT requesting sensitive fields.
  - **Expected**: API omits sensitive fields; zero cost leaks over the network wire.
  - **Evidence**: Network HTTP response JSON showing absence of sensitive fields.

- [ ] **M06-DB-06: Idempotency Response Cache & Immutable Audit Log Tables (Universal)**
  - Create `idempotency_keys` table with unique constraint on `(org_id, idempotency_key)` to cache responses.
  - Create `audit_logs` table with strict RLS policies allowing only `SELECT` and `INSERT` (zero `UPDATE` / `DELETE`).
  - **Verify**: Execute an `UPDATE audit_logs SET action = 'tampered'` as an authenticated user.
  - **Expected**: Database rejects query with permission denied error.
  - **Evidence**: SQL error message confirming update rejection.

---

## Sprint 2: Design Tokens, UI Shell & Authentication Flows

- [ ] **M06-FE-01: Semantic CSS Tokens & TypeScript Strict Configuration (Universal)**
  - Declare CSS variables in `globals.css` matching `DESIGN.md`: base surfaces, typography, borders, triad status tokens (`--success/-border/-bg`, `--warning/-border/-bg`, `--destructive/-border/-bg`, `--info/-border/-bg`), and unified z-index scale.
  - Separate passive borders (`--border`, 1.3:1) from interactive input borders (`--input`, $\ge 3:1$).
  - Configure `tsconfig.json` with `strict: true` and `noUncheckedIndexedAccess: true`.
  - **Verify**: Run `pnpm type-check` and inspect computed CSS variables in browser DevTools.
  - **Expected**: Exit code 0, all tokens resolve to valid hex/rgba values.
  - **Evidence**: TypeScript compiler output log.

- [ ] **M06-FE-02: Public Marketing Shell & Authentication Flow (SCR-001, SCR-002)**
  - Implement landing page (`SCR-001`) and login portal (`SCR-002`) matching `DESIGN_SPEC.md`.
  - Form inputs MUST specify `text-base` (`16px`) universally across all viewports to prevent iOS Safari auto-zoom.
  - Anti-Disabled Pristine Rule: Submit buttons remain enabled in pristine state; clicking triggers validation, smooth-scrolls, and auto-focuses the first invalid field.
  - **Verify**: Open `/login` on simulated mobile/touch viewport; click submit with empty inputs.
  - **Expected**: Viewport does not auto-zoom; inline error messages ($\ge 13$px, $\ge 4.5:1$ contrast) render below inputs; first field focused.
  - **Evidence**: DevTools screenshot showing error states and element focus.

- [ ] **M06-FE-03: Onboarding & Workspace Setup Wizard (SCR-003)**
  - Implement multi-step onboarding wizard invoking `rpc_register_organization`.
  - Session management: In Next.js, ensure dynamic request functions are properly awaited (`await cookies()`).
  - Verify server-side session authentication using `supabase.auth.getUser()`.
  - **Verify**: Complete full onboarding flow from signup to dashboard redirect.
  - **Expected**: Organization, location, and owner account created in database; redirected to `/dashboard`.
  - **Evidence**: Network tab showing 200 OK RPC response and subsequent dashboard render.

---

## Sprint 3: Operational Dashboards, Master Data & Access Boundaries

- [ ] **M06-FE-04: Operational Dashboard & Analytical Widgets (SCR-003)**
  - Implement dashboard shell with responsive layout: desktop sidebar (240–260px, `border-l-4` active state) and mobile bottom navigation bar (`h-16`, auto-hiding on keyboard focus).
  - Implement 5-state matrix: Idle/Default, Loading Skeletons (`h-12 animate-pulse`), Empty State with CTA, Server Error Banner with retry button, and Success Toast.
  - **Verify**: Throttle network to Slow 3G in DevTools; simulate API error.
  - **Expected**: Skeleton loaders display during data fetch; error banner catches failure with actionable retry button.
  - **Evidence**: Screenshots of loading skeleton and error boundary states.

- [ ] **M06-FE-05: Team & Staff Management with Immediate Session Revocation**
  - Implement staff directory and role assignment (`Owner`, `Manager`, `Staff`, `Auditor`).
  - Implement active toggle (`is_active`): When a staff member is deactivated, RLS `is_active = TRUE` check denies data access immediately across all active sessions.
  - **Verify**: Deactivate staff user from admin panel while user has an active session open in an incognito window.
  - **Expected**: User's subsequent request is blocked immediately by RLS (`is_active = FALSE` returns null org); redirected to login.
  - **Evidence**: Screenshot showing access denied on deactivated session.

- [ ] **M06-FE-06: Resource Catalog Master Directory & Input Masking (SCR-005, SCR-006)**
  - Implement primary resource catalog with search, category filtering, and pagination.
  - Format monetary fields with `inputmode="numeric"` and live dot-thousand formatting (e.g., `Rp 1.250.000`), NEVER `<input type="number">`.
  - Verify data masking: When logged in as Staff/Operator, the UI and API queries use the restricted view, keeping sensitive costs/margins hidden.
  - **Verify**: Inspect browser Network tab response payload as Staff user.
  - **Expected**: Sensitive cost properties are undefined/absent in the JSON response payload.
  - **Evidence**: DevTools Network preview showing payload without cost fields.

---

## Sprint 4: Operational Execution & Input Safeguards (Domain-Adaptive)

- [ ] **M06-FE-07: Operational Execution Workspace / Action Canvas (SCR-004)**
  - *(Domain-Adaptive: POS for retail; Deal Pipeline Canvas for CRM; Block Editor for CMS; Attendance Terminal for HRIS)*
  - Implement split layout: resource selection on left, active cart/workspace on right (tablet/desktop) or bottom action dock (mobile).
  - Interactive touch targets strictly meet minimum $\ge 44\text{px} \times 44\text{px}$ (`h-11 min-w-11`).
  - Input Safety: Common entry keys (`Enter`) are bound strictly to item entry/search; final mutation/checkout is bound to dedicated action buttons or function keys (`F4`).
  - **Verify**: Simulate hardware scanner or rapid keyboard entry in search input.
  - **Expected**: Item adds to active workspace; search input clears and refocuses; final checkout is NOT triggered prematurely.
  - **Evidence**: Video or animated GIF recording action sequence.

- [ ] **M06-FE-08: Offline Queue & Collision-Free Device Sequencing (Conditional)**
  - *(Applicable if offline/local-first mode is in scope; mark N/A for online-only apps)*
  - Store pending mutations in client IndexedDB (Dexie.js).
  - Format offline invoice/document numbers with unique device prefix: `[BRANCH]-[DEVICE-UUID-SHORT]-[YYYYMMDD]-[SEQ]`.
  - Multi-event sync fallback for Safari iOS: register listeners for `online`, `visibilitychange`, and manual sync button.
  - **Verify**: Disconnect network in DevTools; complete 2 offline checkout transactions; reconnect network.
  - **Expected**: Transactions store in IndexedDB with unique sequential IDs; auto-sync executes upon reconnect via `rpc_execute_*` with idempotency keys.
  - **Evidence**: IndexedDB inspection screenshot and server database log confirming receipt.

- [ ] **M06-FE-09: Hardware Output & Receipt Printing Protocol (Conditional)**
  - *(Applicable to POS / thermal hardware; mark N/A for standard web apps)*
  - Implement `@media print` thermal receipt stylesheet (58mm/80mm width, 0 margins, monospaced font, dashed dividers).
  - Provide fallback: If printer disconnects, transaction remains locked in database and dialog offers "Cetak Ulang" without re-mutating stock.
  - **Verify**: Trigger print dialog for completed transaction.
  - **Expected**: Print preview renders cleanly at 58mm width; zero page headers/footers bleeding into receipt.
  - **Evidence**: Thermal print preview screenshot.

---

## Sprint 5: Transaction History, Backend Actions & Ledgers

- [ ] **M06-BE-01: Transaction History & Document Details (SCR-011, SCR-012)**
  - Implement transaction history table with date range, status, and filter controls.
  - Details view renders line items, snapshot costs (`unit_cost`), and audit metadata.
  - Spreadsheet Export Sanitization: Implement `sanitizeExportCell` to escape formula triggers (`=, +, -, @, \t, \r`) with `'` while preserving pure negative numbers (e.g. `"-150000"`).
  - **Verify**: Export CSV containing notes starting with `=SUM(A1:A10)` and a negative currency string `"-50000"`.
  - **Expected**: `=SUM` cell is exported as `'=SUM(A1:A10)`; negative number `-50000` remains numeric without single quote.
  - **Evidence**: Open exported CSV in text editor and Microsoft Excel confirming safe formula neutralization.

- [ ] **M06-BE-02: Void & Cancellation Protocol (Reversal Entries)**
  - Operators/Staff CANNOT void completed records independently.
  - Void requires Manager or Owner authorization with mandatory explanation note ($\ge 10$ characters).
  - Executing void appends an immutable **reversal entry** to the movement ledger (`VOID_RETURN`) with positive quantity to restore balance.
  - **Verify**: Execute void on transaction #001 with reason "Salah input nominal oleh kasir".
  - **Expected**: Transaction status updates to `VOID`; new reversal movement appended to `inventory_movements`; original transaction record preserved.
  - **Evidence**: Query `transactions` and `inventory_movements` confirming status change and reversal row.

- [ ] **M06-BE-03: In-Flow Mutations & Receivables / Payables Ledgers**
  - Implement purchase order / incoming stock entry with mandatory snapshot of new unit buy price.
  - Implement receivables/payables installment tracking with separate `payment_records` table (not just a single scalar counter).
  - **Verify**: Record partial payment on an outstanding receivable invoice.
  - **Expected**: Payment record created with timestamp and actor ID; remaining balance decrements accurately.
  - **Evidence**: Database query showing ledger entries and updated balance.

---

## Sprint 6: Domain Integrity Workflows, Reconciliation, Tax & SaaS Billing

- [ ] **M06-BE-04: Domain Audit / Opname / Publishing Review (SCR-008, SCR-009, SCR-010)**
  - *(Domain-Adaptive: Inventory Blind Opname for retail; Deal Approval for CRM; Editorial Review for CMS)*
  - For Inventory Scope: Staff physical count screen renders ONLY item identification and empty count input; expected stock is **100% physically excluded from client DOM and API payload**. Management review calculates net variance accounting for in-flight transactions:
    $$\text{Net Variance} = \text{Count} - (\text{Snapshot} - \text{In-Flight Sales} + \text{In-Flight Purchases})$$
  - Escalation rule: Discrepancies exceeding defined threshold require Owner sign-off; Manager cannot self-approve own count.
  - **Verify**: Inspect network payload of staff opname screen; submit variance exceeding threshold.
  - **Expected**: Network payload contains 0 expected stock numbers; submitted opname routes to Owner approval queue with mandatory $\ge 10$-character note.
  - **Evidence**: DevTools network response screenshot and approval queue state.

- [ ] **M06-BE-05: Statutory Tax Calculations & In-App Disclaimers (Conditional)**
  - *(Conditional: Applicable if financial/tax calculations are in scope; mark N/A for non-statutory projects)*
  - Model official statutory rules from verified government legal sources: e.g. Indonesian SME turnover tax (PP 55/2022) with Rp 500M annual non-taxable threshold for individual taxpayers (WP OP) vs 0.5% flat from first Rupiah for corporate entities (Badan Usaha).
  - Calculate cumulative gross turnover starting January 1st (YTD).
  - Display persistent in-app disclaimers: *"Perhitungan bersifat estimasi operasional dan tidak menggantikan pelaporan resmi SPT ke regulator."*
  - **Verify**: Calculate tax for individual taxpayer with cumulative turnover of Rp 450M, then Rp 600M.
  - **Expected**: Tax for Rp 450M is Rp 0 (under threshold); tax for Rp 600M is calculated on the excess Rp 100M ($100\text{M} \times 0.5\% = \text{Rp } 500.000$).
  - **Evidence**: Test calculation output log.

- [ ] **M06-BE-06: SaaS Subscription Engine & Webhook Security (Conditional)**
  - *(Applicable to commercial SaaS products; mark N/A for internal tools)*
  - Integrate payment gateway (Midtrans / Xendit / Stripe) with 14-day trial and 7-day grace period.
  - Webhook Security: Exclude `/api/webhooks/payment` from session auth guards; verify cryptographic payload signature (HMAC SHA-512 / SHA-256); cross-check `gross_amount` with database invoice.
  - Enforce idempotency: Log external event ID in `idempotency_keys`; duplicate webhook events return HTTP 200 without duplicate renewals.
  - Offboarding: 30-day grace period (access blocked, export available) $\rightarrow$ 90-day hard database purge.
  - **Verify**: Dispatch simulated webhook event with invalid signature, then valid signature, then duplicate event.
  - **Expected**: Invalid signature rejected with 401; valid signature activates subscription; duplicate returns 200 without side effects.
  - **Evidence**: Webhook server logs showing signature verification and idempotent return.

---

## Sprint 7: Automated Quality Assurance, Concurrency & Release Gates

- [ ] **M06-TEST-01: Automated RLS & Security Test Suite (Universal)**
  - Write automated tests (using Vitest / Jest / pgTAP) verifying multi-tenant isolation:
    1. User Org A cannot SELECT, INSERT, UPDATE, or DELETE records in Org B.
    2. Operational staff cannot query sensitive cost fields directly via raw queries or view bypassing.
    3. Deactivated user token cannot execute mutations.
    4. Audit logs and movement ledgers reject any `UPDATE` or `DELETE` statements.
  - **Verify**: Run automated security test suite: `pnpm test:security`.
  - **Expected**: 100% assertions pass with exit code 0.
  - **Evidence**: Test runner output log.

- [ ] **M06-TEST-02: Database Concurrency & Anti-Deadlock Load Test (Conditional)**
  - *(Applicable to multi-user concurrent mutation systems; mark N/A for single-user tools)*
  - Execute concurrency script dispatching 50 parallel mutation requests against overlapping resources.
  - **Verify**: Run concurrency benchmark script (`k6` or Node.js parallel script).
  - **Expected**: Zero PostgreSQL deadlocks (`SQLSTATE 40P01`); all transactions complete or serialize cleanly; final stock/balance matches ledger sum.
  - **Evidence**: Concurrency test report showing 0 deadlock errors and verified balance reconciliation.

- [ ] **M06-TEST-03: End-to-End User Journey Tests (Playwright) (Universal)**
  - Write Playwright E2E tests for the core user loop: Login $\rightarrow$ Action Mutation $\rightarrow$ State Transition $\rightarrow$ Receipt/Report $\rightarrow$ Audit Verification.
  - Test keyboard navigation: Tab order, focus rings visible, and ESC closing modals.
  - **Verify**: Run headless E2E suite: `pnpm test:e2e`.
  - **Expected**: All critical path journeys pass; zero hydration errors, zero console errors.
  - **Evidence**: Playwright test report summary and video recording.

- [ ] **M06-TEST-04: Asset Budget & Production Build Verification (Universal)**
  - Execute production build: `pnpm build`.
  - Verify client initial JavaScript bundle weight is $\le 250\text{ KB}$ gzipped per route using `@next/bundle-analyzer`.
  - Verify zero TypeScript compiler suppressions (`// @ts-ignore`, `as any`) exist in the repository:
    `! grep -rn "// @ts-ignore" src/ && ! grep -rn "as any" src/`
  - **Verify**: Run type-check, lint, and bundle check.
  - **Expected**: Exit code 0, bundle sizes within budget, clean lint audit.
  - **Evidence**: Build terminal output showing route bundle sizes.

- [ ] **M06-TEST-05: Staging Deployment & Disaster Recovery Dry Run (Universal)**
  - Deploy build to staging environment (Vercel Preview / isolated staging container).
  - Perform environment variable security check: Verify no live production secret keys (`sk_live_`) leaked into staging configuration.
  - Perform rollback dry run: Verify automated backup restoration can recover staging database within defined RTO ($<4$ hours).
  - **Verify**: Execute staging smoke test and test database restore script.
  - **Expected**: Staging application accessible and fully functional; backup restores without data corruption.
  - **Evidence**: Staging URL live check and backup restore completion timestamp.
