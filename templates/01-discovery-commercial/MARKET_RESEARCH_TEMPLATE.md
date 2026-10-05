# Market Research Report

**Research Date**: [YYYY-MM-DD]  
**Created By**: [Team Name / Solo Dev]  
**Document Version**: 1.0  
**Status**: [Draft / Final / Under Review]

---

## 1. Executive Summary

**3-Sentence Summary**:
[Write the core conclusions of the market research: market size, growth trends, and regulatory feasibility]

**Go/No-Go Recommendation**:
- [ ] **GO**: Market is sufficiently large, positive growth trend, no fatal regulatory blockers.
- [ ] **PIVOT**: Market exists but requires positioning / target segment adjustment.
- [ ] **NO-GO**: Market is too small or possesses regulatory blockers unfeasible for a solo developer.

---

## 2. Market Sizing (TAM/SAM/SOM)

### 2.1 Total Addressable Market (TAM)

**TAM Definition**: The total potential market demand assuming zero geographic boundaries, competitors, or resource constraints.

**Calculation Method**:
```
TAM = [Total Market Units] × [Annual ARPU/ARPA]
```

**Calculation**:
```python
# Example: HR SaaS for Indonesian SMEs
total_indonesian_smes = 64_000_000  # BPS / Ministry of Cooperatives & SMEs data 2026
annual_arpu = 1_200_000  # Rp 100k/month × 12 months

TAM = total_indonesian_smes * annual_arpu
TAM = IDR 76.8 trillion

# Or in USD
TAM_usd = 64_000_000 * (100 / 15_000)  # $100/month
TAM_usd = $5.1 billion
```

**TAM Result**: Rp [X] trillion / $[Y] billion

**Data Sources**:
- [ ] BPS (Central Statistics Agency): [link / data year]
- [ ] Ministry of Cooperatives & SMEs: [link]
- [ ] Statista: [link]
- [ ] Gartner/Forrester Report: [report title, year]
- [ ] Internal data / primary survey: [methodology description]

---

### 2.2 Serviceable Addressable Market (SAM)

**SAM Definition**: The portion of TAM realistically addressable by your product (filtered by geography, digitalization level, and target customer profile).

**Filters Applied**:
1. **Geographic**: [Example: Indonesia only, or Greater Jakarta only]
2. **User Criteria**: [Example: SMEs with 5-50 employees, currently using computers]
3. **Digitalization**: [Example: Only SMEs already utilizing software/cloud tools]

**Calculation**:
```python
# Filter 1: SMEs with 5-50 employees (20% of total SMEs)
target_sme_size = 64_000_000 * 0.20 = 12_800_000

# Filter 2: Actively using software / digitized (8% of target SMEs)
digital_smes = 12_800_000 * 0.08 = 1_024_000

SAM = digital_smes * annual_arpu
SAM = 1_024_000 * IDR 1_200_000
SAM = IDR 1.23 trillion
```

**SAM Result**: Rp [X] billion / $[Y] million

**Assumptions & Validation**:
- Digitalization rate of [8%] based on: [source]
- Company size criteria of [5-50 employees] based on: [source]

---

### 2.3 Serviceable Obtainable Market (SOM)

**SOM Definition**: The portion of SAM realistically capturable in **Year 1** with limited resources (solo developer / small team).

**Realistic Market Share Assumptions**:
- **Year 1**: 0.01% - 0.1% of SAM (new market entry, unestablished brand)
- **Years 2-3**: 0.5% - 2% of SAM (product-market fit achieved, word-of-mouth compounding)

**Calculation**:
```python
# Conservative target: 0.05% market share in year 1
market_share_y1 = 0.0005

SOM_y1 = SAM * market_share_y1
SOM_y1 = IDR 1.23 trillion * 0.0005
SOM_y1 = IDR 615 million

# Or calculate by customer units target
target_paying_customers_y1 = 500  # 500 subscribed SMEs
annual_arpu = IDR 1_200_000

SOM_y1 = 500 * IDR 1_200_000 = IDR 600 million
```

**Year 1 SOM Result**: Rp [X] million / $[Y]k  
**Year 1 Paying Customers Target**: [X] customers  
**MRR (Monthly Recurring Revenue) Target**: Rp [X] million/month

**Bottom-Up Validation**:
```
Targeting 500 paying customers by Month 12:
- Conversion rate signup → paid: 10%
- Requires 5,000 signups in year 1
- Average 417 signups/month
- Average 14 signups/day

Is this target realistic with available marketing channels? [Yes/No]
```

---

## 3. Industry Trend Analysis

### 3.1 Industry Growth Rate

**Historical Data (Past 3-5 Years)**:

| Year | Market Size | YoY Growth |
| :--- | :--- | :--- |
| 2024 | Rp [X] billion | - |
| 2025 | Rp [X] billion | +[Y]% |
| 2026 | Rp [X] billion | +[Y]% |
| 2027 | Rp [X] billion (est.) | +[Y]% |

**Data Source**: [Report name, year, URL]

**Interpretation**:
- [ ] **High Growth (>15% YoY)**: Booming industry, opportune timing for market entry.
- [ ] **Moderate Growth (5-15% YoY)**: Stable industry, established competitors but viable room for new entrants.
- [ ] **Low/Negative Growth (<5% YoY)**: Mature or declining industry, demands strong differentiation or pivot.

---

### 3.2 Technology Adoption Curve

**Target User Position on the Adoption Curve**:
```
Innovators (2.5%) → Early Adopters (13.5%) → Early Majority (34%) → Late Majority (34%) → Laggards (16%)
```

**Target User Classification**:
- [ ] **Innovators / Early Adopters**: Risk-tolerant, eager to adopt new technologies. Strategy: focus on product differentiation; premium pricing viable.
- [ ] **Early Majority**: Pragmatic, requiring social proof and case studies. Strategy: testimonials, case studies, risk-free trials.
- [ ] **Late Majority**: Skeptical, waits until technology becomes standard. Strategy: emphasize stability, simplicity, cost efficiency.

**Evidence / Indicators**:
[Example: Survey indicates 60% of target SMEs still rely on manual Excel → indicates Late Majority, requiring market education]

---

### 3.3 Macro Tailwinds & Headwinds

**Tailwinds (Positive Growth Drivers)**:
1. **[Tailwind Name 1]**: [Description]
   - Example: "Data Privacy Regulation (UU PDP) requires companies to use encrypted systems, preventing reliance on insecure manual spreadsheets."
2. **[Tailwind Name 2]**: [Description]
   - Example: "Pandemic accelerated digital adoption; previously cash-only SMEs now widely accept QRIS and e-wallets."
3. **[Tailwind Name 3]**: [Description]
   - Example: "Government subsidies for SME digitalization via specialized grant programs."

**Headwinds (Macro Risks & Barriers)**:
1. **[Headwind Name 1]**: [Description]
   - Example: "Economic slowdown → SMEs reducing discretionary software budgets to prioritize operational survival."
2. **[Headwind Name 2]**: [Description]
   - Example: "Big tech competitors (Google, Microsoft) potentially entering the market with bundled free offerings."

---

### 3.4 Google Trends Analysis

**Keyword**: `[primary product keyword, e.g., "online pos software"]`

**Trend Chart** (screenshot or data):
```
[Paste Google Trends screenshot or CSV data]
```

**Insight**:
- Search volume trend: [Rising / Falling / Stable] over the past 12 months.
- Peak season: [Month X-Y] → informs campaign timing.
- Geographic hotspot: [Province / city] → informs go-to-market priorities.

**Top Rising Related Queries**:
1. [Query 1] (+[X]% YoY)
2. [Query 2] (+[Y]% YoY)
3. [Query 3] (+[Z]% YoY)

---

## 4. Regulatory Landscape Check

### 4.1 Applicable Regulations (Indonesia)

**Industry / Sector**: [Fintech / Healthtech / Edtech / General SaaS / etc.]

| Regulation | Brief Description | Product Impact | Compliance Action Required |
| :--- | :--- | :--- | :--- |
| **UU PDP No. 27/2022** | Personal Data Protection | Mandatory consent management, encryption at-rest/transit, 72h data breach notification | [ ] Implement consent management UI<br>[ ] Setup AES-256 encryption<br>[ ] Draft incident response plan |
| **UU ITE No. 19/2016** | Electronic Transactions & Signatures | E-signatures legally binding via certified Electronic Certificate Providers (PSrE) | [ ] Integrate certified PSrE API<br>[ ] Or provide clear non-certified digital signature disclaimer |
| **OJK Regulations** | (If Fintech / Payments) | Mandatory financial service provider licensing, or partner with licensed gateway | [ ] Use licensed gateway (Midtrans/Xendit)<br>[ ] NEVER store raw credit card data |
| **Ministry of Health** | (If Healthtech) | Electronic medical records must be secured, practitioners require valid licenses (SIP) | [ ] Verify practitioner license at onboarding<br>[ ] Encrypt medical records, maintain audit trails |
| **Ministry of Education** | (If Formal Edtech) | Formal educational delivery permits | [ ] Not applicable if non-formal online courses |

---

### 4.2 Fatal Regulatory Blockers

**Are there regulations that CANNOT be fulfilled by a solo developer?**

- [ ] **NO BLOCKERS**: Regulations can be met via third-party integrations or standard technical controls.
- [ ] **MINOR BLOCKER**: Compliance costs exist (e.g., licensed signature API at Rp 3k/signature), but remain economically viable.
- [ ] **FATAL BLOCKER**: Mandatory licensing requires substantial paid-in capital (e.g., direct payment gateway license requiring billions in capital + exhaustive audit), or introduces severe criminal liability without corporate legal protection.

**If Fatal Blocker**: **STOP PROJECT** or **PIVOT** to a low-regulatory business model.

---

### 4.3 International Compliance (If Targeting Global Markets)

| Regulation | Region | Impact |
| :--- | :--- | :--- |
| **GDPR** | European Union | Mandatory user consent, right to be forgotten, 72-hour breach notification |
| **CCPA** | California, USA | Consumer privacy rights, opt-out of data sale |
| **PIPEDA** | Canada | Data privacy consent requirements |

**Action**: [Not applicable / Implement in Phase 2 / Mandatory for MVP]

---

## 5. Conclusions & Recommendations

**Market Opportunity Grade**: [A / B / C / D / F]

**Grading Criteria**:
- **A (Excellent)**: TAM >$1B, SAM >$100M, SOM Y1 >$1M, growth >15% YoY, zero fatal regulatory blockers.
- **B (Good)**: TAM >$500M, SAM >$50M, SOM Y1 >$500k, growth 10-15% YoY, minor manageable compliance costs.
- **C (Fair)**: TAM >$100M, SAM >$10M, SOM Y1 >$100k, growth 5-10% YoY, requires precise positioning.
- **D (Risky)**: TAM <$100M, SAM <$10M, growth <5% YoY, heavy compliance burden.
- **F (No-Go)**: Fatal regulatory blockers or market too small for sustainable operations.

**Go-to-Market Recommendation**:
1. **Primary Target Segment**: [Most feasible initial segment to penetrate]
2. **Geographic Priority**: [Initial focus cities/provinces]
3. **Timing**: [Launch now / await event X / pivot]

**Next Steps**:
- [ ] Proceed to Competitive Analysis (Module 00 - Step 2)
- [ ] Revisit TAM/SAM/SOM if underlying assumptions invalidate
- [ ] Escalate regulatory blockers to legal counsel (if B2B enterprise client)

---

**Approved By**:  
**Name**: [Solo Dev / PM Lead]  
**Date**: [YYYY-MM-DD]
