# Module 02: Discovery & Scope Definition

> **Template to copy**: `templates/01-discovery-commercial/SCOPE_STATEMENT_TEMPLATE.md` · use cases: `templates/01-discovery-commercial/USE_CASE_SPECIFICATION_TEMPLATE.md` (scope first: coffee-break test + goal level, then the 14 fields, then the 20-point check) · client/Medium+: `templates/01-discovery-commercial/STAKEHOLDER_MAP_TEMPLATE.md` (→ `docs/pm/STAKEHOLDER_MAP.md`)
> **Decision ledger**: `templates/03-governance/DECISION_LOG_TEMPLATE.md` (→ `docs/DECISION_LOG.md`) — every decision across every phase, appended and superseded, never rewritten
> **Meeting records**: `templates/01-discovery-commercial/MEETING_NOTES_TEMPLATE.md` (→ `docs/pm/meetings/YYYY-MM-DD_<topic>.md`) — decisions, action items and open questions separated, never fabricated
> **Companion registers** (copy when needed): `BUSINESS_RULES_REGISTER_TEMPLATE.md` · `ASSUMPTIONS_CONSTRAINTS_TEMPLATE.md` · `REQUIREMENTS_REGISTER_TEMPLATE.md` (→ `docs/pm/`, same base name)
> 📖 **Optional ref**: `references/checklists/MODULE_02_EVALUATION_CHECKLIST.md` · `references/ba/USE_CASE_SPECIFICATION_CRAFT_GUIDE.md` · `references/ba/REQUIREMENTS_TRACEABILITY_AND_RTM_GUIDE.md` · `references/pm/STAKEHOLDER_REQUEST_DECODING_PLAYBOOK.md` · `patterns/product/BUSINESS_ANALYSIS_DISCOVERY_PATTERN.md` (elicitation mix, ambiguity classes, review passes) (do NOT preload)

**Purpose**: extract real requirements, define technical boundaries, and lock **In/Out-of-Scope** into `SCOPE_STATEMENT.md` **before** contracts or design.

**Pre-Contract Work**: discovery (M00–02) is typically unpaid for new clients; DP (Milestone 1, M03) triggers paid work. Repeat clients: consider a discovery fee.

---

## 1. Execution Rules

### Step 1 — Discovery Interview (5 Pillars)
- Verify decision authority; dissect needs vs wants.
- **Metrics ramp**: Month 1: 5–10 customers; Month 6: 50–75; Year-1 baseline 50–100 paying (Rp 5–10M MRR @ Rp 99k). D30 retention 30–40%; churn 30–50%/yr → lifetime 12–18 mo; never pair high churn with long LTV.
- **Non-circular NSM**: ❌ "70% of WAU record ≥5 tx/wk" (circular). ✅ "70% of signups with ≥1 login in 30 days record ≥5 tx/wk."
- **Guardrail Metrics**: pair the North Star Metric with operational guardrails that must NOT degrade (e.g., checkout API p95 latency ≤500ms, inventory discrepancy ≤0.5%, zero unhandled transaction exceptions).
- **Pre-launch validation**: smoke landing page by Week 2; 50–100 signups before major investment, else reassess positioning.

### Step 2 — Problem-Solution Fit, MoSCoW & Acceptance Criteria
- Must-Haves **collectively** resolve ≥70% of root causes; every Must maps to a primary bottleneck (zero vanity P0s). Secondary-friction features demote to Should/Won't.
- **Type before wording** (`patterns/product/BUSINESS_ANALYSIS_DISCOVERY_PATTERN.md` §4): classify each item as functional / non-functional / business rule / constraint first. Changes when the UI is redesigned → functional; must hold regardless → business rule. Ambiguity classes (§4.1) name the fix; banned-word table: `REQUIREMENTS_AMBIGUITY_CHECKLIST.md`.
- **Given-When-Then Acceptance Criteria**: Every P0 Must-Have User Story MUST include at least one concrete BDD scenario (`Given [initial context], When [action occurs], Then [expected outcome]`). Vague statements ("the system allows users to cancel orders") are invalid and block scope locking.
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
1. **`docs/pm/SCOPE_STATEMENT.md`** (mandatory): objectives, MoSCoW, stories, RBAC, In/Out-of-Scope, dependencies, SLA. Stub-checked only (<40B fails) — quality is judged by the §Gate Exit Protocol checklist, not byte count.
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
   - [ ] All sections complete (Objectives, RBAC, MoSCoW, Stories with Given-When-Then criteria, NFR baseline, Boundaries, SLA)
   - [ ] Must-Have count within scale limits; zero ambiguous terms (TBD/maybe/tentative) in Must rows
   - [ ] Must-Haves resolve ≥70% of root causes; personas need zero out-of-scope features
   - [ ] Multi-tenant schema (`org_id` + RLS via `public.user_roles`); financial precision (`DECIMAL`, `unit_cost` snapshot, append-only movements)
   - [ ] RBAC tree with zero self-approval; revenue features (billing + offboarding) in P0
   - [ ] NFR baseline defined (max concurrent users, API p95 latency, platform/browser boundary)
   - [ ] Legal compliance planned (Privacy Policy, ToS, tax disclaimers, PII scrubbing); legal/tax text carries a `LEGAL-REVIEW:` marker
   - [ ] `Scope-P0-Count` is a real number matching counted Must rows; `Scope-Lock-Decision` is `LOCKED`
   - [ ] Timeline: epic sum + 20% buffer; CR freeze = QA − 2 wks; ≥3 Out-of-Scope exclusions; confidence legend (✅/🔶/❓); dependencies with SLA
   - [ ] **Registers (if used) are sound**: no `BR-` row without a source + enforcement point (**zero orphan rules**); every ❓ assumption has an owner and a validation approach (never agent-validated); every hard constraint has a design impact, every soft one states its cost
3. Present scope summary: P0 features, Out-of-Scope list, client dependencies.

### STEP 2 — Gate Verification (MANDATORY)

```
[PASTE RAW OUTPUT OF: ./scripts/gates/validate-gate.sh M02]
```

**MANDATORY**: Execute `./scripts/gates/validate-gate.sh M02` (or `.ps1`). Exit 1 = incomplete; fix and re-run before declaring completion.

### STEP 3 — Report & Continue
Present the scope summary. Client projects pause for approval before M03 (a [GATE]); Solo SaaS / Small continue to M04 once the gate passes.
