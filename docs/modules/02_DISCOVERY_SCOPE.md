# Module 02: Discovery & Scope Definition

> **Templates**: `templates/01-discovery-commercial/SCOPE_STATEMENT_TEMPLATE.md` · `USE_CASE_SPECIFICATION_TEMPLATE.md` (scope first: coffee-break test + goal level, then the 14 fields, then the 20-point check) · `STAKEHOLDER_MAP_TEMPLATE.md` (client/Medium+ → `docs/pm/STAKEHOLDER_MAP.md`) · `MEETING_NOTES_TEMPLATE.md` (→ `docs/pm/meetings/YYYY-MM-DD_<topic>.md`; decisions, action items and open questions kept separate, never fabricated) · companion registers when needed: `BUSINESS_RULES_REGISTER` · `ASSUMPTIONS_CONSTRAINTS` · `REQUIREMENTS_REGISTER` (→ `docs/pm/`, same base name).
> **Pushback applies here**: scope creep and vanity P0s are pushed back on, not absorbed — protocol in `references/process/ANTI_YES_MAN.md`.
> **Decision ledger**: `templates/03-governance/DECISION_LOG_TEMPLATE.md` (→ `docs/DECISION_LOG.md`) — every decision, every phase, appended and superseded, never rewritten.
> **Optional refs** (do NOT preload): `references/checklists/MODULE_02_EVALUATION_CHECKLIST.md` · `references/ba/USE_CASE_SPECIFICATION_CRAFT_GUIDE.md` · `references/ba/REQUIREMENTS_TRACEABILITY_AND_RTM_GUIDE.md` · `references/pm/EPIC_BREAKDOWN_PATTERNS.md` (only when an epic is too large to slice) · `patterns/product/BUSINESS_ANALYSIS_DISCOVERY_PATTERN.md` (elicitation mix, ambiguity classes, review passes).

**Purpose**: extract real requirements, define technical boundaries, and lock **In/Out-of-Scope** into `SCOPE_STATEMENT.md` **before** contracts or design.

**Pre-Contract Work**: discovery (M00–02) is typically unpaid for new clients; DP (Milestone 1, M03) triggers paid work. Repeat clients: consider a discovery fee.

---

## 1. Execution Rules

### Step 1 — Discovery Interview (5 Pillars)
- Verify decision authority and separate needs from wants.
- **Outcome measures**: reuse the baseline and business evidence from M00/M01 when it exists — never copy generic SaaS growth targets into every project. For client work or a path without M00, agree the success measure, definition, baseline, target, data source, owner and horizon; record anything unknown as an assumption or `unknown`.
- **Non-circular NSM**: ❌ "70% of WAU record ≥5 tx/wk" (circular) → ✅ "70% of signups with ≥1 login in 30 days record ≥5 tx/wk".
- **Guardrail metrics** pair with the North Star and must not degrade (e.g. checkout p95 ≤500ms, inventory discrepancy ≤0.5%, zero unhandled transaction exceptions).
- If M00 validation exists, inherit it — do not repeat the same smoke test or interviews. Skipping M00 means M02 elicitation sets the outcomes and boundaries; signup counts are never a universal requirement.

### Step 2 — Problem-Solution Fit, MoSCoW & Acceptance Criteria
- Must-Haves **collectively** resolve ≥70% of root causes, each mapped to a primary bottleneck (zero vanity P0s); secondary friction demotes to Should/Won't.
- **Workflow-to-scope map** (only when roles/flows overlap or the MVP slice is unclear): user goal → activity → steps, mark the end-to-end slice that still delivers a useful result, and use it to find gaps — it is not a second backlog. Drop the section when flows are clear.
- **Story slicing**: each story delivers testable user value. Split on workflow boundary, rule/data variation or external dependency when it cannot be estimated or carries several flows; never split a user story into frontend/backend tickets — technical breakdown belongs to implementation.
- **Epic hypotheses** (strategic epics only): target user and outcome, `If [change] for [user], then [measurable outcome], because [evidence]`, the leading signal with target and window, and the decision if it moves or not. Link to existing outcome evidence; no second roadmap, no hypothesis per atomic requirement.
- **Oversized epic breakdown**: when a story still cannot be delivered as one user-valued slice, use the workflow / business-rule / data / CRUD / spike pattern in `references/pm/EPIC_BREAKDOWN_PATTERNS.md`, keeping an end-to-end user result per M02 release slice. Implementation breakdown stays in M06.
- **Prioritization**: MoSCoW sets the scope boundary and the P0 count. Do not stack RICE/ICE on top of the same decision; if P1/P2 order is still open, pick one method that fits the evidence, and never let a score outrank legal, security or mandatory dependencies.
- **Type before wording** (`BUSINESS_ANALYSIS_DISCOVERY_PATTERN.md` §4): classify as functional / non-functional / business rule / constraint first — changing when the UI is redesigned is functional, must-hold-regardless is a business rule. Ambiguity classes (§4.1) name the fix; banned words: `REQUIREMENTS_AMBIGUITY_CHECKLIST.md`.
- **Given-When-Then**: every P0 Must-Have story carries ≥1 concrete BDD scenario. "The system allows users to cancel orders" is invalid and blocks scope lock.
- **Scope red-team before lock**: challenge unsupported features, missing or excluded users, outcomes with no observable measure, contradictory priorities, unpriced dependencies, weak acceptance criteria and hidden legal/operational obligations. Record each challenge with affected ID, evidence and disposition (change / defer with reason / reject with reason). The human scope owner resolves trade-offs and approves; the red-team never silently changes scope.
- **Test traceability**: give each acceptance criterion a stable requirement/story ID and map it to a test scenario. For interactive flows reference the canonical M04 wireflow `WFxx` IDs instead of copying the scenario again. M07 must trace every in-scope criterion to an executed test with evidence; uncovered criteria stay open.
- **NFR baseline** (quantitative): max concurrent sessions for MVP (e.g. 50–100), latency SLA (API p95 ≤500ms, page TTI ≤3s on 4G), supported platforms (evergreen Chrome/Safari; legacy browser optimisation explicitly Out-of-Scope).
- Segment audit: if the MVP withholds a capability a persona needs for core value (e.g. BOM for cafés), **drop the segment or upgrade the feature**.
- Dependency contradiction: deferring expense tracking ⇒ "Gross Profit (Laba Kotor)" only.
- MoSCoW P0 limits: Small 1–5 · Medium 6–15 · Large 16–25 (solo only with a signed `SOLO-CAPACITY-RISK-ACCEPTANCE.md`; a non-delegable obligation routes to A-Series) · >25 → A-Series advisory.
- **Mandatory SaaS revenue P0s** (internal tools excepted): billing and basic subscription/access check. Thermal receipt printing and complex admin overrides stay P1/P2 unless the business model demands them.

### Step 3 — RBAC Matrix & Approval Tree
- Permission table per role (CRUD + guardrails), e.g. Owner/Manager/Kasir/Akuntan: Kasir cannot void an order or see buy price; Manager approval requires **ZERO SELF-APPROVAL**; Owner auto-approves.
- Locations via `user_roles.location_ids UUID[]`; session timeouts (shared POS 24h auto-lock, personal 7-day rotation).

### Step 4 — Architecture & Schema
- Multi-tenant: `org_id UUID NOT NULL` on every table including junctions; RLS queries `public.user_roles`; column hiding in query builders (RLS filters rows, not columns).
- Financial: `DECIMAL(15,2)` never FLOAT; `unit_cost` snapshot on line items; append-only `inventory_movements`; void via status column; no `balance_after` (races); `idempotency_key` + `device_timestamp` when offline; `audit_logs` table.
- Realism: <100 users on 1–2 locations → online-only MVP; TTI <5s on 3G; JS <200KB gzip; API p95 <500ms; client-side PDF (no serverless Puppeteer); pin minor versions, never "latest"; honest security claims (RLS ≠ SQLi prevention; at-rest is the provider's AES-256, not pgcrypto).

### Step 5 — Scope Boundaries & Legal
- Civil-law principle: anything not explicitly In-Scope is outside the developer's responsibility. Write ≥3 exclusions (legacy digitisation, third-party licensing, local hardware/network faults, formal legal or tax counsel).
- Tax disclaimers cite the regulation (PP 55/2022 jo. PP 20/2026 PPh UMKM; PP 58/2023 & PMK 168/2023 PPh 21 TER + BPJS) plus the general estimation disclaimer.
- UU PDP 27/2022: Privacy Policy (region, retention, sub-processors), ToS, Sentry PII scrubbing, CSV-injection sanitisation.
- ⚠️ **LEGAL REVIEW REQUIRED** — the agent may **draft** Privacy Policy, ToS and tax disclaimers as operational templates, but they are **not legal advice**. Same rule as M03 and A00: never present drafted legal text as final. Until a professional reviews it, the marker stays:

  ```text
  LEGAL-REVIEW: PENDING — DRAFT TEKNIS, WAJIB DITINJAU OLEH LEGAL COUNSEL / PAKAR PAJAK SEBELUM DIPUBLIKASIKAN
  ```

  The human flips it to `LEGAL-REVIEW: REVIEWED by <name> on <YYYY-MM-DD>`. Publishing legal text before that is a **FROZEN-spec violation**.

### Step 6 — Client Dependency SLA
Register the client inputs — sandbox keys, email credentials, master data CSV/Excel — with ≤3-business-day approvals. Clause: a delay of ≥3 business days extends the launch by the same amount, without liability.

### Step 7 — Stakeholders & Timeline
- Power/Interest matrix (Manage Closely / Keep Satisfied / Keep Informed / Monitor) with cadence and escalation.
- Durations: M04 1–3 wks · M05 0.5–1 wk · M06 4–16 wks · M07 1–3 wks. Dev formula: `[(simple CRUD × 2.5d) + (complex × 1wk)] × 1.20`. **CR freeze = QA start − 2 weeks.** Phase 1.5 is strictly post-launch. Closed beta at M07 week 2: 5 owners, 3 months free, 60-minute recorded sessions.

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
1. **`SCOPE_STATEMENT.md`** (mandatory): objectives, outcome hypotheses for strategic epics, MoSCoW, stories, RBAC, In/Out-of-Scope, dependencies, SLA, red-team dispositions. Stub-checked only (<40B fails); quality is judged by the Gate Exit Protocol below, not byte count.
2. **`STAKEHOLDER_MAP.md`**, **`COMMUNICATION_PLAN.md`**, **`RACI_MATRIX.md`** — client/internal; one page for solo.
3. Conditional: `RISK_REGISTER.md`, `REQUIREMENT_MATRIX.md`, `BACKLOG.md`, `OKR.md`.
4. **Use cases** where actor-level detail is needed: `docs/pm/use-cases/UC-<MODULE>-<NN>_<name>.md`, one file per use case, each UC ID cited from `REQUIREMENTS_REGISTER.md`.
5. **Type-separated registers**, only when needed (rules in `BUSINESS_ANALYSIS_DISCOVERY_PATTERN.md` §4): `BUSINESS_RULES_REGISTER.md` (each rule cites source + enforcement point — a rule enforced by nothing is an **orphan rule**) · `ASSUMPTIONS_CONSTRAINTS.md` (each assumption owned and testable; each constraint hard/soft with its design impact) · `REQUIREMENTS_REGISTER.md` (`FR-`/`NFR-`/`BR-`/`CON-` separated, each with source and acceptance criterion).

---

## Gate Exit Protocol

### STEP 0 — File Existence Check (BLOCKING)
`test -f docs/pm/SCOPE_STATEMENT.md` must succeed. Missing → **STOP IMMEDIATELY**: no validation, no summary, no prompt. Report `CRITICAL ERROR: SCOPE_STATEMENT.md file was not created. Module 02 FAILED - cannot proceed to Module 03 (Legal SOW & Charter).` and END TURN.

### STEP 1 — Content Validation
1. Stop/continue is governed by SKILL.md rule 3 (M03 gates only Client projects; Small and Solo SaaS chain onward).
2. Checklist:
   - [ ] Required elements present: objectives, outcome hypotheses for strategic epics, RBAC, MoSCoW, stories with Given-When-Then, NFR baseline, boundaries, SLA.
   - [ ] Must-Have count inside the scale limit; zero TBD/maybe/tentative in Must rows.
   - [ ] Must-Haves resolve ≥70% of root causes; no persona depends on an out-of-scope feature.
   - [ ] Multi-tenant schema (`org_id` + RLS via `public.user_roles`); financial precision (`DECIMAL`, `unit_cost` snapshot, append-only movements).
   - [ ] RBAC tree with zero self-approval; revenue features (billing + offboarding) in P0.
   - [ ] NFR baseline defined (max concurrent sessions, API p95, platform/browser boundary).
   - [ ] Legal work planned (Privacy Policy, ToS, tax disclaimers, PII scrubbing); every legal/tax text carries a `LEGAL-REVIEW:` marker.
   - [ ] `Scope-P0-Count` matches the counted Must rows; `Scope-Lock-Decision: LOCKED`.
   - [ ] Timeline: epic sum + 20% buffer; CR freeze = QA − 2 wks; ≥3 Out-of-Scope exclusions; confidence legend (✅/🔶/❓); dependencies with SLA.
   - [ ] Red-team challenges recorded with affected IDs and dispositions; the human scope owner resolved trade-offs before LOCKED.
   - [ ] Registers (if used) sound: no `BR-` row without source + enforcement point (**zero orphan rules**); every ❓ assumption has an owner and validation approach (never agent-validated); every hard constraint names its design impact and every soft one its cost.
3. Present the scope summary: P0 features, Out-of-Scope list, client dependencies.

### STEP 2 — Gate Verification (MANDATORY)

```
[PASTE RAW OUTPUT OF: ./scripts/gates/validate-gate.sh M02]
```

**MANDATORY**: execute `./scripts/gates/validate-gate.sh M02` (or `.ps1`). Exit 1 = incomplete — fix and re-run before declaring completion.

### STEP 3 — Report & Continue
Present the scope summary. Client projects pause for approval before M03 (a [GATE]); Solo SaaS / Small continue to M04 once the gate passes.
