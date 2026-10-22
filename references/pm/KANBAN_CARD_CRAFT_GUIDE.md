# Kanban Card Craft Guide

> **Purpose**: Reusable standard for writing Kanban cards that are scannable, actionable, and self-contained — regardless of tool (GitHub Projects, Linear, Notion, Jira, physical board).
> **Context**: Applied in **M02 (Scope Definition)** when populating the backlog, and throughout **M06–M13** when cards move through sprints. Complements `EPIC_BREAKDOWN_PATTERNS.md` (splitting) and `PM_PRIORITIZATION_FRAMEWORKS.md` (ranking).

---

## 1. Summary (Judul Kartu)

The Summary is the **one-line title** visible on the board. Every team member should understand the card's intent from the Summary alone — without opening it.

### Rules

| Rule | Rationale |
|---|---|
| **Specific verb + noun** | "Add CSV export to Invoice list" beats "Export feature" |
| **Max ~12 words** | Longer titles get truncated in board columns |
| **No implementation details** | "Implement Zustand store for cart" is a Task title, not a Story title |
| **No vague qualifiers** | Ban: "Improve", "Enhance", "Handle", "Various" — unless quantified |
| **Unique within the backlog** | If two cards sound identical, they are either duplicates or under-specified |

### Anti-Patterns

| ❌ Bad Summary | ✅ Better Summary |
|---|---|
| Fix bug | Fix: negative stock quantity allowed on adjustment form |
| Authentication | Implement email+password login with session cookie |
| UI improvements | Redesign dashboard metric cards to match brand tokens |
| Research payment | Spike: evaluate Midtrans vs Xendit webhook reliability |
| Various fixes | (split into individual cards) |

---

## 2. Description (Deskripsi Kartu)

The Description is **not** a copy of the Summary and **not** a full spec paste. It answers three questions:

1. **Why** — context, business motivation, or user pain this card addresses.
2. **What (scope)** — deliverables and boundaries; what "done" looks like.
3. **What NOT** — explicit exclusions to prevent scope creep within the card.

### Writing Principles

- **Context over repetition**: do not restate the Summary. Instead, explain *why* this work matters.
- **Outcome over process**: describe the expected result, not step-by-step implementation instructions (those belong in the task's Action field or a linked spec).
- **Link, don't paste**: reference the spec section (`PRD.md §3.2`, `FSD.md §Auth`) instead of copying 200 lines into the Description.
- **Constraint-forward**: surface the hardest constraint or risk first — the reader's attention peaks at the opening.

### Description Template (Adaptable)

```markdown
**Context**: <1–2 sentences on why this card exists — user problem, business goal, or dependency trigger>

**Scope**:
- <deliverable 1>
- <deliverable 2>
- ...

**Out of Scope**: <things explicitly NOT included in this card>

**References**: <links to PRD section, FSD table, Figma frame, or Use Case ID>
```

---

## 3. Description Examples by Work Type

### Epic

> **Summary**: Inventory Management Module
>
> **Description**:
> **Context**: Retail tenants currently track stock in spreadsheets, causing ≥15% phantom inventory. This epic delivers real-time stock visibility across locations.
>
> **Scope**:
> - Stock-in (purchase orders), stock-out (sales deduction), manual adjustments
> - Multi-location view with per-location filtering
> - Adjustment approval workflow (Manager creates → Owner approves; zero self-approval)
>
> **Out of Scope**: Automated reorder points and supplier management (Phase 2). Barcode scanner integration deferred to P2.
>
> **References**: PRD.md §4 "Inventory", SCOPE_STATEMENT.md Must-Have #3–#7

### Story

> **Summary**: Kasir records a walk-in sale and prints receipt
>
> **Description**:
> **Context**: The POS operator (Kasir) needs to ring up a sale in <30 seconds per transaction during peak hours. This is the primary revenue-generating user flow.
>
> **Scope**:
> - Product search by name/SKU, add to cart, apply cash/QRIS payment
> - Auto-deduct stock on completed sale (atomic: transaction + inventory movement in single DB tx)
> - Generate thermal receipt (client-side, no serverless PDF)
>
> **Out of Scope**: Split payment, store credit, and refund — separate stories. Kasir cannot void (escalate to Manager per RBAC matrix).
>
> **Acceptance Criteria**:
> ```gherkin
> Given a Kasir with 3 items in cart
> When payment is confirmed
> Then stock decreases by sold quantities
>   And a thermal receipt renders within 2 seconds
>   And the transaction appears in sales history
> ```
>
> **References**: PRD.md §4.1 "Point of Sale", FSD.md §Transaction Schema

### Task

> **Summary**: Create `inventory_movements` migration with append-only constraint
>
> **Description**:
> **Context**: Supports the Inventory Management epic. This table is the single source of truth for stock calculations — no UPDATE/DELETE allowed (append-only audit trail). `balance_after` column intentionally omitted to prevent race conditions; current stock is computed via `SUM(quantity)` grouped by `product_id` + `location_id`.
>
> **Scope**:
> - Migration file with `DECIMAL(12,3)` quantity, FK indexes, `CHECK(quantity <> 0)`
> - RLS policy scoped to `org_id` via `public.user_roles`
>
> **Out of Scope**: Seeder data (separate task M06-DB-02). No triggers or materialized views at this stage.
>
> **References**: FSD.md §Schema "inventory_movements", deep-dive/02 §3 "SQL Schema Patterns"

### Bug

> **Summary**: Fix: negative stock quantity allowed on adjustment form
>
> **Description**:
> **Context**: QA discovered that the stock adjustment form accepts `quantity = -500` for a product with only 3 units in stock, creating phantom negative inventory. This violates the business rule that stock-out adjustments must not exceed current available quantity.
>
> **Steps to Reproduce**:
> 1. Login as Manager at location-01
> 2. Navigate to Stock Adjustments → New Adjustment
> 3. Select product "Kopi Arabika 250g" (current stock: 3)
> 4. Enter quantity: -500, reason: "Rusak"
> 5. Submit → succeeds (should fail)
>
> **Expected**: Validation error "Adjustment quantity exceeds available stock (3 units)"
> **Actual**: Adjustment saved, stock becomes -497
>
> **Root Cause (if known)**: Server action `createAdjustment` validates Zod schema shape but does not check current stock level before inserting.
>
> **References**: PRD.md §4.3 AC-INV-05, FSD.md §Business Rules BR-INV-02

### Spike

> **Summary**: Spike: evaluate Midtrans Snap vs Xendit Invoice for checkout UX
>
> **Description**:
> **Context**: FSD locks the payment gateway to either Midtrans or Xendit but defers the specific product selection. We need a time-boxed comparison before implementing the payment integration story.
>
> **Scope** (max 4 hours):
> - Set up sandbox for both providers
> - Test webhook delivery reliability (fire 10 test webhooks each, measure delivery rate and latency)
> - Compare: redirect UX, supported payment methods (QRIS, VA, e-wallet), settlement callback schema
> - Document findings in `docs/spikes/SPIKE-PAY-01.md`
>
> **Decision Output**: Recommendation with trade-off table → recorded in `DECISION_LOG.md`
>
> **Out of Scope**: Production integration, fee negotiation, contract signing.
>
> **References**: FSD.md §Integration "Payment Gateway", patterns/payments/INDONESIA_PAYMENT_GATEWAYS.md

### Chore

> **Summary**: Upgrade Tailwind CSS from v3.4 to v4.0 and migrate config
>
> **Description**:
> **Context**: The design system tokens in `DESIGN.md` target Tailwind v4's CSS-first configuration. Staying on v3 creates divergence between design specs and code. This is a maintenance task with no user-visible feature change.
>
> **Scope**:
> - Replace `tailwind.config.ts` with CSS-based `@theme` directives
> - Update `@apply` usages that break in v4 (ref: Tailwind v4 migration guide)
> - Verify `pnpm build` exit 0 with zero visual regression
>
> **Out of Scope**: New design tokens or component restyling — this is a 1:1 migration only.
>
> **Risk**: v4 changes `@apply` behavior in component libraries. Run visual diff on all screens post-migration.

---

## 4. Minimum Card Fields

Every Kanban card — regardless of tool — must carry these fields. Fields marked *(conditional)* are added only when applicable.

| # | Field | Format | Required | Notes |
|---|---|---|---|---|
| 1 | **ID** | `<PREFIX>-<NNN>` | ✅ | Unique, sequential. Prefix by project or module (e.g., `INV-042`, `M06-FE-03`). Never reuse after deletion. |
| 2 | **Summary** | ≤12 words | ✅ | See §1 rules above |
| 3 | **Description** | Structured prose | ✅ | See §2–3 above. Minimum: Context + Scope + Out of Scope. |
| 4 | **Work Type** | Enum | ✅ | `Epic` · `Story` · `Task` · `Bug` · `Spike` · `Chore` — see §5 |
| 5 | **Status** | Enum | ✅ | `Backlog` → `Ready` → `In Progress` → `Review` → `Done` (or board-specific columns) |
| 6 | **Priority** | Enum | ✅ | `P0-Critical` · `P1-High` · `P2-Medium` · `P3-Low` — see §5 |
| 7 | **Acceptance Criteria** | Given-When-Then | ✅ for Story/Bug | At least 1 BDD scenario per Story; for Bug: expected vs actual behavior |
| 8 | **Estimate** | T-shirt or hours | ✅ | `XS` (<1h) · `S` (1–4h) · `M` (4–8h) · `L` (1–2d) · `XL` (2–5d). Anything >XL must be split. |
| 9 | **Assignee** | Person | *(conditional)* | Solo projects: implicit. Team: mandatory when status ≥ Ready. |
| 10 | **Dependencies** | Card ID list | *(conditional)* | `Depends: M06-DB-01, M06-AUTH-01`. Only list direct blockers, not transitive. |
| 11 | **Blocker** | Flag + reason | *(conditional)* | Set when the card is blocked by an external factor (client input, third-party API, approval). Include: what is blocking, who owns unblocking, and the SLA. |
| 12 | **Sprint / Iteration** | Label | *(conditional)* | Assigned when card enters Ready or In Progress. |
| 13 | **Labels / Tags** | Free-form | *(conditional)* | Module area (`inventory`, `auth`, `billing`), platform (`frontend`, `backend`, `infra`). |

---

## 5. Work Type vs Priority — They Are Not the Same Thing

A common mistake is conflating **what kind of work** a card represents with **how urgent** it is. They are orthogonal dimensions:

### Work Type (Jenis Pekerjaan) — *What* is this card?

Work Type classifies the **nature** of the deliverable. It determines how the card is structured, reviewed, and accepted.

| Work Type | Definition | Key Characteristic |
|---|---|---|
| **Epic** | A large initiative spanning multiple Stories/Tasks | Not directly implementable; breaks down into children |
| **Story** | A user-facing capability described from the user's perspective | Has Acceptance Criteria (Given-When-Then); delivers observable value |
| **Task** | A technical unit of work (migration, config, refactor) | Developer-facing; may not be visible to end users |
| **Bug** | A defect — behavior deviates from locked spec | Has Steps to Reproduce + Expected vs Actual |
| **Spike** | Time-boxed research or proof-of-concept | Output is a *decision* or *document*, not production code |
| **Chore** | Maintenance, upgrade, or housekeeping work | No new functionality; keeps the system healthy |

### Priority (Prioritas) — *When* should this card be worked on?

Priority determines **urgency and scheduling order**. It is independent of Work Type.

| Priority | Meaning | SLA Guidance |
|---|---|---|
| **P0-Critical** | Blocks the release or causes data loss / revenue impact | Must be resolved in current sprint; all other work paused |
| **P1-High** | Required for the current milestone (Must-Have in MoSCoW) | Scheduled in the current or next sprint |
| **P2-Medium** | Important but not blocking (Should-Have) | Scheduled within the current phase |
| **P3-Low** | Nice-to-have or future consideration (Could-Have / Won't) | Backlog; scheduled only when capacity permits |

### Why the distinction matters

Any Work Type can have any Priority:

| Example | Work Type | Priority |
|---|---|---|
| Login flow for MVP launch | Story | P0-Critical |
| Upgrade Node.js from 20 to 22 LTS | Chore | P2-Medium |
| Negative stock bug in production | Bug | P0-Critical |
| Typo in admin settings label | Bug | P3-Low |
| Evaluate auth provider (Supabase Auth vs Clerk) | Spike | P1-High |
| Add dark mode toggle | Story | P3-Low |

Mixing them up leads to bad prioritization: treating every Bug as P0 ("bugs are always urgent") or treating every Chore as P3 ("maintenance can always wait"). **Assign both fields independently based on the card's actual impact.**

---

## 6. Quick Reference Card Skeleton

Copy-paste this skeleton when creating a new card:

```markdown
## [ID] Summary

**Work Type**: Epic | Story | Task | Bug | Spike | Chore
**Priority**: P0-Critical | P1-High | P2-Medium | P3-Low
**Status**: Backlog
**Estimate**: XS | S | M | L | XL
**Depends**: <card IDs or "None">
**Blocker**: <None | description + owner + SLA>

### Description

**Context**: <why this card exists>

**Scope**:
- <deliverable 1>
- <deliverable 2>

**Out of Scope**: <exclusions>

### Acceptance Criteria

<!-- For Story/Bug: at least 1 Given-When-Then scenario -->
```gherkin
Given <initial context>
When <action occurs>
Then <expected outcome>
```

### References

- <link to PRD/FSD section, Figma frame, Use Case ID, or upstream card>
```

---

## 7. Mapping to `TODO.md` Tasks (M06)

When cards enter development execution (Module 06), each Story or Task maps to a `TODO.md` entry with 8 mandatory elements (see `templates/04-dev-execution/TODO_TEMPLATE.md`):

| Kanban Card Field | TODO.md Equivalent |
|---|---|
| ID | Task ID (`M06-FE-01`) |
| Summary | Title & single objective |
| Description (Scope) | Action |
| Description (Out of Scope) | Out of Scope |
| Acceptance Criteria | Verify & Expected |
| Dependencies | Depends |
| Status | `- [ ]` / `- [~]` / `- [!]` / `- [x]` |
| Estimate | (implicit in sprint placement) |

Epics do not appear in `TODO.md` directly — they are tracked as sprint section headers or in `BACKLOG.md`. Spikes produce a decision document, not a code commit.
