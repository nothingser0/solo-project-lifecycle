# M00-Lite: Rapid Market Validation (Solo SaaS & Self-Initiated)

> **Purpose**: 1-page rapid market validation document for solo developers building self-initiated SaaS products. Replaces heavy multi-week PM documentation with an empirical 3-day validation sprint.
> **Rule**: DO NOT skip market validation for solo SaaS. Building without validation is the #1 cause of solo project failure.
> **Output Location**: `docs/pm/M00_LITE.md`

---

## 1. Project Metadata & Problem Pitch

- **Project Codename**: [e.g., MiniPOS / KasirKilat]
- **Target User**: [e.g., Micro-retail store owners with 1–3 branches in metropolitan areas]
- **Core Pain**: [e.g., Physical stock discrepancies vs Excel records averaging Rp 1–3M/month]
- **Proposed Solution**: [e.g., Offline-first cashier & inventory app syncing automatically to Cloud/WhatsApp]
- **Proposed Price Point**: Rp [X] / month (or $Y / month)
- **Validation Lead**: [Your Name / Solo Dev]
- **Date**: [YYYY-MM-DD]

---

## 2. Riskiest Assumption Register (RAT)

*Identify the top 3 premises that would kill the product if false. Test the riskiest one first:*

| ID | Core Hypothesis | Risk Level | Evidence Needed | Cheap Test Method | Kill Threshold (Ambang Gugur) | Outcome |
|:---|:----------------|:----------:|:----------------|:------------------|:------------------------------|:-------:|
| **ASM-01** | Users lose >Rp 1M/mo due to this friction | HIGH | 3 out of 5 respondents confirm material financial loss | 5 Deep user interviews | <2 respondents experience quantifiable loss | [✅/❌/⏳] |
| **ASM-02** | Users are willing to pay Rp [X]/mo | HIGH | Landing page waitlist with price anchor displayed | Waitlist page (100 targeted visits) | Waitlist signup conversion < 3% | [✅/❌/⏳] |
| **ASM-03** | MVP can be shipped by 1 dev in ≤4 weeks | HIGH | Tech stack validation & API sandbox check | Architecture POC spike | Architecture requires direct banking / clearance license | [✅/❌/⏳] |

---

## 3. Quick Competitor & Alternative Check

*Benchmark against 2 direct competitors and 1 free/government substitute:*

| Solution Name | Type | Price / Tier | Strengths | Critical Weaknesses | Unique Differentiator We Offer |
|:--------------|:-----|:-------------|:----------|:--------------------|:-------------------------------|
| [Competitor A] | Direct SaaS | Rp [X]/mo | Strong brand, rich feature set | Complex UI, demands 100% stable internet | Lightweight, 100% offline-first |
| [Competitor B] | Direct SaaS | Rp [Y]/mo | Affordable | No multi-branch or blind count support | Multi-branch with blind stock audit |
| **SIAPIK / Excel** | Free / Govt | Rp 0 | Zero cost, flexible | Manual entry, formula corruption risk | Automated receipts & instant cloud sync |

---

## 4. Qualitative User Discovery (5 User Interviews)

> ⚠️ **EVIDENCE RULE**: Data must originate from real user conversations. Never fabricate quotes.

| Respondent ID | Role / Business Type | Current Solution | Biggest Friction / Loss | Willingness to Pay | Evidence Status |
|:--------------|:---------------------|:-----------------|:------------------------|:-------------------|:---------------:|
| **INT-01** | [e.g., Grocery store, 2 staff] | Physical paper notebook | Monthly discrepancy ~Rp 800k | Willing to pay Rp 50k–100k/mo | [✅ Real / ⏳ Pending] |
| **INT-02** | [e.g., Pet shop, 1 branch] | Excel on cashier laptop | Laptop freezes, corrupt spreadsheets | Willing to pay Rp 100k/mo | [✅ Real / ⏳ Pending] |
| **INT-03** | [e.g., Boutique, 3 staff] | Commercial POS app X | Slow during offline, staff confusion | Willing to pay Rp 150k/mo if offline seamless | [✅ Real / ⏳ Pending] |
| **INT-04** | [Business Type] | [Current tool] | [Friction] | [WTP] | [✅ Real / ⏳ Pending] |
| **INT-05** | [Business Type] | [Current tool] | [Friction] | [WTP] | [✅ Real / ⏳ Pending] |

---

## 5. Behavioral Intent Validation (Waitlist / Smoke Test)

*Validate real behavior, not just polite verbal agreement:*

- **Landing Page URL / Platform**: [Link Carrd / Vercel / Google Form]
- **Traffic Source**: [Direct merchant communities / LinkedIn / Twitter / Google search ads]
- **Total Unique Visitors**: [X] visitors (Minimum target: $\ge 100$)
- **Total Waitlist / Email Signups**: [Y] signups
- **Conversion Rate**: $\frac{Y}{X} \times 100\% = \mathbf{[Z]\%}$
- **Waitlist-Conversion-Pct**: [angka persentase, e.g. 5.5]
- **Gate Pass Benchmark**: $\ge 5.0\%$ waitlist conversion with explicit pricing stated on page ($2.0\% - 4.9\%$ = 1x iteration sprint; $<2.0\%$ = KILL).

---

## 6. Unit Economics & Solo Capacity Sanity Check

- **Target ARPU**: Rp [X] / month
- **Estimated CAC**: Rp [Y] / customer (Test ads / organic outreach time)
- **Gross Margin Target**: $\ge 75\%$ after infrastructure hosting and Payment Gateway processing fees
- **Solo Dev Feasibility**:
  - [ ] Tech stack uses proven "Boring Tech" (Next.js / Laravel / Supabase / Postgres)
  - [ ] Zero unmanageable operational dependencies (no self-hosted websocket cluster without managed provider)
  - [ ] Compliance manageable: Private PSE registration filed, payments via licensed gateway

---

## 7. Kill Criteria & Gate Validation Outcome

### Kill Criteria Triggers:
1. **Market Kill**: Waitlist conversion $< 2\%$ after 200 targeted visitors OR $< 3$ of 5 interview respondents demonstrate intent to pay.
2. **Feasibility Kill**: Estimated MVP development timeline exceeds 6 weeks for 1 developer.
3. **Regulatory Kill**: Business model legally mandates banking or direct lending capital licenses exceeding solo founder capacity.

### Gate Decision (M00 Machine Validation Line):
Gate-Decision: PENDING

*(Options: PASS | PENDING | FAIL. Machine validator strictly rejects M00 until this line declares 'Gate-Decision: PASS', at least 3 interviews mark '✅ Real', and waitlist meets threshold).*
