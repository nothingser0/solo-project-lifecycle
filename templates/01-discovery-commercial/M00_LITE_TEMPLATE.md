# M00-Lite: Rapid Market Validation (Solo SaaS & Self-Initiated)

> **Purpose**: 1-page rapid market validation document for solo developers building self-initiated SaaS products. Replaces heavy multi-week PM documentation with an empirical 3-day validation sprint.
> **Rule**: DO NOT skip market validation for solo SaaS. Building without validation is the #1 cause of solo project failure.
> **Output Location**: `docs/pm/M00_LITE.md`

---

## 1. Project Metadata & Problem Pitch

- **Project Codename**: [e.g., MiniPOS / KasirKilat]
- **Provisional Target Segment**: [e.g., Micro-retail store owners with 1–3 branches in metropolitan areas; confirm the beachhead choice in Section 6]
- **Core Pain**: [e.g., Physical stock discrepancies vs Excel records averaging Rp 1–3M/month]
- **Proposed Solution**: [e.g., Offline-first cashier & inventory app syncing automatically to Cloud/WhatsApp]
- **Proposed Price Point**: Rp [X] / month
- **Validation Lead**: [Your Name / Solo Dev]
- **Date**: [YYYY-MM-DD]

---

## 2. Riskiest Assumption Register (RAT)

*Identify the top 3 premises that would kill the product if false. Test the riskiest one first:*

| ID | Core Hypothesis | Risk Level | Evidence Needed | Cheap Test Method | Kill Threshold (Ambang Gugur) | Outcome |
|:---|:----------------|:----------:|:----------------|:------------------|:------------------------------|:-------:|
| **ASM-01** | Users lose >Rp 1M/mo due to this friction | HIGH | 3 out of 5 respondents confirm material financial loss | 5 Deep user interviews | <2 respondents experience quantifiable loss | [✅/❌/⏳] |
| **ASM-02** | Users are willing to pay Rp [X]/mo | HIGH | Landing page waitlist with price anchor displayed | Waitlist page (≥100 targeted visits) | Waitlist signup conversion < 2.0% | [✅/❌/⏳] |
| **ASM-03** | MVP can be shipped by 1 dev in ≤4 weeks | HIGH | Tech stack validation & API sandbox check | Architecture POC spike | Architecture requires direct banking / clearance license | [✅/❌/⏳] |

---

## 3. Quick Competitor & Alternative Check

*Benchmark against 2 direct competitors and 1 free/government substitute:*

| Solution Name | Type | Price / Tier | Strengths | Critical Weaknesses | Evidence URL + checked date | Unique Differentiator We Offer |
|:--------------|:-----|:-------------|:----------|:--------------------|:-------------------------|:-------------------------------|
| [Competitor A] | Direct SaaS | Rp [X]/mo | Strong brand, rich feature set | Complex UI, demands 100% stable internet | [URL — YYYY-MM-DD] | Lightweight, 100% offline-first |
| [Competitor B] | Direct SaaS | Rp [Y]/mo | Affordable | No multi-branch or blind count support | [URL — YYYY-MM-DD] | Multi-branch with blind stock audit |
| **SIAPIK / Excel** | Free / Govt | Rp 0 | Zero cost, flexible | Manual entry, formula corruption risk | [URL — YYYY-MM-DD] | Automated receipts & instant cloud sync |

---

## 4. Qualitative User Discovery (5 User Interviews)

> ⚠️ **EVIDENCE RULE & THE MOM TEST PROTOCOL**: Data must originate from real user conversations. Never fabricate quotes.
>
> **The Mom Test Guardrails**:
> - ❌ Never ask: *"Would you buy an app that does X?"* or *"Do you like this idea?"* (People will lie out of politeness).
> - ✅ Ask about past behavior: *"How did you handle this problem last week?"*
> - ✅ Ask about tangible cost: *"What did you pay or how many hours did you waste trying to fix it?"*
>
> Requirements for `✅ Real` status:
> 1. Verbatim quote detailing measurable past pain (not hypothetical interest).
> 2. Specific stated Willingness-to-Pay (WTP) in nominal currency (e.g. "Rp 100k/mo"), not vague approval.
> State must explicitly be marked as `✅ Real` for verified customer conversations or `⏳ Pending` for planned ones.
>
> **Summary integrity**: Interview transcripts and AI summaries do not replace source evidence. Verify any quote, number, or reported claim against an interview ID and timestamp/note locator. Record whether transcription or external AI processing was used and confirm the required consent/authorization first; use pseudonyms in this shared report.

| Respondent ID | Role / Business Type | Current Solution | Biggest Friction / Loss | Willingness to Pay | Evidence Status |
|:--------------|:---------------------|:-----------------|:------------------------|:-------------------|:---------------:|
| **INT-01** | [e.g., Grocery store, 2 staff] | Physical paper notebook | Monthly discrepancy ~Rp 800k | Willing to pay Rp 50k–100k/mo | ⏳ Pending |
| **INT-02** | [e.g., Pet shop, 1 branch] | Excel on cashier laptop | Laptop freezes, corrupt spreadsheets | Willing to pay Rp 100k/mo | ⏳ Pending |
| **INT-03** | [e.g., Boutique, 3 staff] | Commercial POS app X | Slow during offline, staff confusion | Willing to pay Rp 150k/mo if offline seamless | ⏳ Pending |
| **INT-04** | [Business Type] | [Current tool] | [Friction] | [WTP] | ⏳ Pending |
| **INT-05** | [Business Type] | [Current tool] | [Friction] | [WTP] | ⏳ Pending |

If a participant asks for a feature, capture its source `INT-xx`, underlying job/outcome, and current workaround. Treat it as a discovery signal; test whether the need is shared and important before moving a solution into the MVP scope.

### Opportunity Solution Tree (lite)

Start from one measurable user outcome, branch into opportunities supported by interview evidence, then compare at least two plausible solutions for each priority opportunity. Link each solution to its riskiest assumption and smallest credible test before adding it to MVP scope. Use `patterns/product/SOLO_DISCOVERY_PLAYBOOK.md` for the full OST workflow; keep detailed test results in the shared assumption ledger when this page is too small.

| Desired outcome (measure, baseline → target, timeframe) | Opportunity (user need + source `INT-xx`) | Candidate solutions (at least 2) | Riskiest assumption + test | Decision |
|:--|:--|:--|:--|:--|
| [e.g., reduce time spent reconciling stock; baseline → target by date] | [Observed need; interview/source IDs] | [A: simplest operational option; B: software option] | [Assumption; test and success signal] | [Keep testing / pursue / drop] |

---

## 5. Behavioral Intent Validation (Waitlist / Smoke Test)

*Validate real behavior, not just polite verbal agreement:*

- **Landing Page URL / Platform**: [Link Carrd / Vercel / Google Form]
- **Traffic Source**: [Direct merchant communities / LinkedIn / Twitter / Google search ads]
- **Total Unique Visitors**: [X]
- **Total Waitlist / Email Signups**: [Y]
- **Conversion Rate**: ([Y] / [X]) × 100% = [Z]%
- **Waitlist-Conversion-Pct**: [e.g. 6.4]
- **Intent-to-Buy-Pct**: [e.g. 34] (survey: % answering "definitely/probably buy"; 0 if no survey run)
- **Alternative-Proof**: deposits: [0] | loi: [0] (refundable pre-order deposits / signed LOIs, if any)

> **Sample floor**: the rate is only evidence above **≥100 targeted visits**. A
> conversion rate computed from fewer visits is not a result — raise the traffic,
> not the claim.

**Canonical verdict** (single source of truth — the gate reads the same numbers):

| Evidence | Verdict | What to do |
|:--|:--|:--|
| Waitlist ≥ 5.0% of ≥100 visits, **or** intent-to-buy ≥ 30%, **or** ≥5 refundable deposits, **or** ≥2 signed LOIs | `PASS` | Proceed to M01 |
| Waitlist 2.0–4.9%, no other evidence | `RETEST` | Fix the copy/value-prop, run one 7-day sprint, re-test with more visits, then re-run the M00 gate |
| Waitlist < 2.0% of ≥100 visits, no other evidence | `FAIL` | Market kill — stop, do not build |
| Interviews/survey not yet run by a human | `PENDING` | Mark `PENDING_PRIMARY_RESEARCH` and end the turn |

> ⚠️ **A rate below 5.0% cannot be written as `PASS`**, and a real band must not be
> *inflated* to fit a `PASS` either — the gate reconciles the declared decision
> against the numbers in this section.

---

## 6. Unit Economics & Solo Capacity Sanity Check

- **Beachhead Decision**: [Compare up to 3 segments using evidenced pain/urgency, willingness-to-pay signal, buyer reachability, and solo serviceability. Name the selected segment and link evidence; label unsupported judgments as assumptions.]
- **First 100 Users Acquisition Channel**: [Name one low-cost organic/direct channel for the selected segment; state why qualified users are reachable there and the smallest first test, including its success signal.]
- **Target ARPU**: Rp [X] / month
- **Estimated CAC**: Rp [Y] / customer (Test ads / organic outreach time)
- **Gross Margin Target**: ≥ 70% after infrastructure hosting and Payment Gateway processing fees
- **Solo Dev Feasibility**:
  - [ ] Tech stack uses proven "Boring Tech" (Next.js / Laravel / Supabase / Postgres)
  - [ ] Zero unmanageable operational dependencies (no self-hosted websocket cluster without managed provider)
  - [ ] Compliance manageable: Private PSE registration filed, payments via licensed gateway

---

## 7. Kill Criteria & Gate Validation Outcome

### Kill Criteria Triggers:
1. **Market Kill**: Waitlist conversion < 2.0% after ≥100 targeted visitors OR < 3 of 5 interview respondents demonstrate intent to pay.
2. **Feasibility Kill**: Estimated MVP development timeline exceeds 6 weeks for 1 developer.
3. **Regulatory Kill**: Business model legally mandates banking or direct lending capital licenses exceeding solo founder capacity.

### Gate Decision (M00 Machine Validation Line):
Gate-Decision: PENDING

### Human Validation Attribution

Validated-by: [Human Name] on [YYYY-MM-DD]

*(The agent may draft and fill this report, but a human runs the interviews and the
waitlist test. Required for `Gate-Decision: PASS`.)*

---

### Machine Validation Contract

The gate (`./scripts/gates/validate-gate.sh M00`) parses the lines above and rejects
the document unless **all** of the following hold. Keep the field names spelled
as shown — bullets, bold and a trailing `%` are tolerated; a stale `[placeholder]`
or `X` is not.

| # | Condition |
|:--|:--|
| 1 | Sections present: Riskiest Assumption Register, User Discovery, Behavioral Intent, Kill Criteria |
| 2 | No unresolved `[...]` placeholders anywhere in the document |
| 3 | `Gate-Decision:` declares exactly `PASS \| RETEST \| PENDING \| FAIL` |
| 4 | ≥ 3 rows of `INT-0x` marked `✅ Real` (of the 5 attempts) |
| 5 | `Total Unique Visitors` ≥ 100 |
| 6 | Signups ≤ Visitors, and `Waitlist-Conversion-Pct` agrees with signups/visitors (±1.0 pp) |
| 7 | Declared decision matches the computed band (PASS / RETEST / KILL) |
| 8 | For `PASS`: `Validated-by: <name> on <YYYY-MM-DD>` recorded |

Exit codes: `0` = PASS · `1` = FAILED/blocked · `3` = RETEST (not passed — do not chain to M01 yet).
