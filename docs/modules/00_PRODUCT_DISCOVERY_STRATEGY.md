# Module 00: Product Discovery & Strategy

> **Templates to copy**: `templates/01-discovery-commercial/M00_LITE_TEMPLATE.md` (Solo SaaS 1-page validation) · `MARKET_RESEARCH_TEMPLATE.md`, `COMPETITIVE_LANDSCAPE_TEMPLATE.md`, `USER_RESEARCH_REPORT_TEMPLATE.md`, `PRODUCT_STRATEGY_TEMPLATE.md` (Full path)
> 📖 **Optional refs** (do NOT preload; open only when a step names one): `references/pre-sales/DISCOVERY_CALL_CHECKLIST.md` · `PROPOSAL_DECK.md` · `references/technical/DEEP_RESEARCH_METHODOLOGY.md`

> **Research method (inline — no need to open DEEP_RESEARCH_METHODOLOGY)**: (1) pick 5–10 real target users, not friends; (2) ask about past behavior, never hypotheticals ("what did you do last time X happened?"); (3) capture exact quotes + willingness-to-pay signal; (4) tag each finding ✅ real / 🔶 assumption / ❓ unknown; (5) a finding counts only with a verbatim quote + respondent ID.

**Purpose**: earliest gate — validate market demand before committing to an idea. Mandatory before M01 when PM-grade validation is needed.

**Routing (bound to `Delivery:` in `docs/pm/PROJECT_STATE.md`)**:
- `solo` (Solo SaaS): **MANDATORY** user validation (`docs/pm/MARKET_VALIDATION.md` or `M00_LITE.md`). Human interviews (>=3 verified) required.
- `client`: **SKIPPED** — scope and terms are client-defined. Proceed to M01 or M03.
- `internal` / `portfolio`: **SKIPPED**. Proceed to M01 or Fast-Track Intake.

---

## 1. Execution Cycle

```text
[ BUSINESS QUESTION / MARKET OPPORTUNITY ]
  → STEP 1: Market Research — TAM/SAM/SOM (segmented funnel, not vanity TAM),
    industry trends, regulatory landscape (PSE, UU PDP, OJK/BI, KBLI)
  → STEP 2: Competitive Analysis — 5–10 direct/indirect/substitute competitors,
    hands-on testing (install & use!), feature matrix, pricing benchmark, SWOT, 2x2 positioning
  → STEP 3: User Research — 5–10 interviews (≥3 verified for lite), 30–50+ surveys,
    JTBD personas, journey map, pain prioritization
  → STEP 4: Product Strategy — vision/mission, North Star Metric, Value Prop Canvas,
    3–5 strategic pillars, unit economics, kill criteria
  → GATE: Market Validation Pass → outputs in docs/pm/
```

---

## 1b. Canonical Gate Bar (single source of truth)

Quote this table; never restate it with different numbers (machine-enforced on `M00_LITE.md` §5).

| Signal | PASS | RETEST | KILL |
|---|---|---|---|
| Waitlist conversion, ≥100 visits | ≥ 5.0% | 2.0–4.9% → one 7-day sprint, more visits, re-test | < 2.0% |
| Survey intent-to-buy | ≥ 30% | 15–29% | < 15%, or < 30 respondents |
| Refundable deposits | ≥ 5 | 1–4 | 0 |
| Signed B2B LOIs | ≥ 2 | 1 | 0 |
| Verified interviews (`✅ Real` rows) | ≥ 3 of 5 attempts | — | < 3 |

Any PASS signal closes the gate; RETEST = best signal in RETEST; KILL = all in KILL.
🔒 **Never talk a number up**: a 3.1% result is written 3.1% and declares `RETEST` (the gate
fails on any mismatch with the §5 arithmetic). Research not yet run → `PENDING`, end turn.

## 2. Execution Rules (Condensed)

### Step 1 — Market Research (`docs/pm/MARKET_RESEARCH.md`)
- TAM/SAM/SOM with **Assumption IDs** and realistic funnel ranges; never naive top-down ("64M MSMEs × price"). Use top-down AND bottom-up cross-checks.
- Regulatory check (Indonesia): PSE registration, VAT/PPh (UU HPP, PP 55/2022 jo. PP 20/2026), KBLI/NIB, trademark (DJKI), UU PDP, payment licensing (never hold user funds; use Midtrans/Xendit), sector rules (healthtech/PSrE).
- Output must cite live source URLs with verification dates.

### Step 2 — Competitive Analysis (`docs/pm/COMPETITIVE_LANDSCAPE.md`)
- **Hands-on testing rule**: install/test each competitor (free tier/trial); record Test Date, Onboarding Time, friction notes. Always check free/government alternatives (SIAPIK, e-Faktur, Sheets templates). Every price figure needs a verified date + URL.
- Deliver: competitor list by type, feature matrix, pricing benchmarks, SWOT for top 3, positioning map, identified moat.

### Step 3 — User Research (`docs/pm/USER_RESEARCH_REPORT.md`)
- **Evidence rule & The Mom Test protocol (non-negotiable)**: primary data from real humans only. Never ask hypothetical questions ("Would you buy X?"). Ask about concrete past actions ("How did you solve this last week? How much money/time did it cost?"). No fabricated quotes/percentages. If research not yet run, mark `PENDING_PRIMARY_RESEARCH` and set Gate-Decision: PENDING. Pre-data personas are `Proto-Persona (Hipotesis)`.
- 🧑 **HUMAN-ONLY — cannot be verified by any script**: conducting the 5–10 interviews, running the surveys/waitlist, and collecting the deposits or signed LOIs are the **human's** actions. The agent may draft instruments, summarise transcripts the human supplies, and fill the report — it must **not** invent responses, and it cannot tell whether the interviews actually happened. If the human has not run them, the agent records `PENDING_PRIMARY_RESEARCH` and **ends the turn**; it never proceeds on assumed research.
- Confidence legend: ✅ VERIFIED / 🔶 ASSUMPTION / ❓ UNKNOWN.
- Survey design: screener → pain severity (Likert) → Van Westendorp WTP → intent-to-buy. Gate bar: see §1b (any one PASS signal closes the gate).
- Output: anonymized interview summaries with verbatim quotes and explicit nominal WTP, survey charts, personas, journey map, pain Impact-Effort matrix.

### Step 4 — Product Strategy (`docs/pm/PRODUCT_STRATEGY.md`)
- Vision (3–5 yr) / Mission (tactical, differentiated); **North Star Metric** with formula, rationale, target, breakdown tree — must be instrumentable (no vanity metrics like "registered users").
- Value Proposition Canvas; 3–5 strategic pillars with success criteria.
- Unit economics: target price, CAC, LTV, gateway fees, PPN 11% + PPh 0.5%, gross margin ≥70%.
- **Kill criteria**: market kill (all signals in §1b's KILL column), economic kill (CAC > LTV/3), solo-feasibility kill (architecture beyond 1 dev).

---

## 3. Scale Adaptation

| Aspect | Small (Fast-Track) | Solo SaaS (Medium) | Non-Solo (A-Series) |
|---|---|---|---|
| Path | M00 SKIPPED (Intake Gate) | M00-lite mandatory | Routed to A00 (Bid/No-Bid) |
| Deliverable | `PROJECT_STATE.md` intake only | `docs/pm/M00_LITE.md` (1 page) | Tender-readiness pack |
| Stopping rule | Intake Gate | `Gate-Decision: PASS` per §1b (exit 0) | Formal Bid/No-Bid |

Full M00 path (4 documents) applies when the project requires industry-grade PM standards; M00-lite is the default for Solo SaaS.

---

## 4. Output Artifacts

All documents live in **`docs/pm/`** (never project root):
1. **Solo SaaS**: `docs/pm/MARKET_VALIDATION.md` (or `M00_LITE.md`) — consolidated assumption register, 5 interview attempts (≥3 verified), waitlist results, `Validated-by:` attribution, kill criteria.
2. **Full path**: `MARKET_RESEARCH.md`, `COMPETITIVE_LANDSCAPE.md`, `USER_RESEARCH_REPORT.md`, `PRODUCT_STRATEGY.md`.

---

## Gate Exit Protocol

M00 is **not** a stop point: on exit 0, chain directly into Module 01 in the same flow (SKILL.md rule 3 — stops are only the Client gates M03/M09/M11 and Small's two stops). Pause on `PENDING`, `FAIL`, or exit 3 (`RETEST`).

**Self-verification checklist**:
- [ ] TAM/SAM/SOM realistic; sources cited with URLs + verification dates
- [ ] Competitors tested hands-on (Test Date, Onboarding Time); free alternatives checked
- [ ] Research empirical (§1b bands); `Validated-by: <name> on <date>` present for PASS
- [ ] Moat identified; North Star Metric instrumentable; kill criteria defined

**Step 3 — Gate verification (MANDATORY)**: run the validator and paste its EXACT output. Do NOT use pre-filled hardcoded ✅ checklists:

```
[PASTE RAW OUTPUT OF: ./scripts/gates/validate-gate.sh M00]
```

Exit 1 = incomplete; exit 3 = RETEST (re-run after the optimisation sprint). Never edit a number, or the declared decision, to turn a failing run green.

**Report & continue** (exit 0 only): summarise market opportunity, competitive landscape, user validation and strategy, state the measured signal + North Star Metric, then proceed to M01.
