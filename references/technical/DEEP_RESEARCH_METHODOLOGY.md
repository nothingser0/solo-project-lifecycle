# Deep Research Methodology: Regulatory, Competitor & Domain Analysis

Comprehensive guide for deep research before development — regulation/compliance, competitor analysis, and domain-specific knowledge acquisition.

**Last Updated**: 2026-09-29  
**Target**: Solo devs building regulated products (fintech, healthtech, legaltech, edtech)

---

## Table of Contents

1. [When to Do Deep Research](#1-when-to-do-deep-research)
2. [Regulatory & Compliance Research](#2-regulatory-compliance-research)
3. [Competitor Deep-Dive Analysis](#3-competitor-deep-dive-analysis)
4. [Domain Knowledge Acquisition](#4-domain-knowledge-acquisition)
5. [Research Deliverables Structure](#5-research-deliverables-structure)
6. [Validation & Citation Standards](#6-validation-citation-standards)

---

## 1. When to Do Deep Research

### 1.1 Triggers for Deep Research (vs Light Discovery)

**Do Deep Research (2-4 weeks) if**:
- ✅ Regulated industry (fintech, healthtech, legaltech, insurance, crypto)
- ✅ Domain-specific calculations (tax, payroll, insurance premium, medical dosage)
- ✅ Legal liability if wrong (incorrect tax advice → user fined, wrong medical info → harm)
- ✅ Competitive landscape unclear (10+ players, unclear positioning)
- ✅ Complex business rules (progressive tax brackets, insurance underwriting, loan scoring)
- ✅ International regulations (tax treaties, GDPR, cross-border payments)

**Skip Deep Research (do light discovery only) if**:
- ❌ Standard CRUD app (task manager, note-taking, inventory)
- ❌ Low liability (wrong output = minor inconvenience, no legal/financial harm)
- ❌ Competitor landscape obvious (Trello clone, Instagram clone)
- ❌ No domain-specific rules (general productivity, social media, e-commerce basics)

### 1.2 Research Phase Timeline

| Project Scale | Deep Research Duration | % of Total Timeline |
|---------------|------------------------|---------------------|
| MVP (4-8 weeks) | 3-5 days | 10-15% |
| Small (2-3 months) | 1-2 weeks | 15-20% |
| Medium (3-6 months) | 2-4 weeks | 20-25% |
| Large (6-12 months) | 4-8 weeks | 25-30% |

**Rule of thumb**: Regulated/complex domains need 20-30% time upfront for research to avoid rework later.

---

## 2. Regulatory & Compliance Research

### 2.1 Research Questions Framework

**Core Questions** (answer ALL before coding):

1. **What laws/regulations govern this product?**
   - Primary: UU, PP, Perpres, Permenkes, PMK, etc. (Indonesia)
   - Secondary: Industry standards (ISO, NIST), international treaties
   - Example: Tax calculator → UU HPP, PMK 168/2023, PP 20/2026

2. **What are the compliance requirements?**
   - Data privacy: UU PDP, GDPR (if EU users)
   - Financial: OJK regulations (if payment/lending)
   - Health: Kemenkes regulations (if medical advice/diagnosis)
   - Example: Tax data → encrypted storage, NPWP masking, audit trail

3. **What calculations/formulas must be accurate?**
   - Formula sources (government decree, industry standard)
   - Edge cases (thresholds, brackets, exceptions)
   - Example: PPh 21 progressive rates (5 brackets), PTKP categories (TK0-K3)

4. **What changes frequently?**
   - Tax rates (yearly budget law)
   - PTKP values (every 2-5 years)
   - Regulatory updates (quarterly/annually)
   - Mitigation: Versioned data (JSON with effective_date, changelog)

5. **What are the legal risks?**
   - User harm: Incorrect tax advice → user fined by DJP
   - Regulatory violation: Operating without license (e.g., insurance broker without AAJI)
   - Liability: Class-action if systemic error causes mass user losses
   - Mitigation: Disclaimer ("consult a certified tax consultant"), E&O insurance

### 2.2 Research Process (Step-by-Step)

#### Step 1: Identify Primary Sources (2-4 hours)

**Government sources** (authoritative):
- Indonesia: https://peraturan.bpk.go.id (UU/PP/Perpres/Permen)
- Tax: https://pajak.go.id, https://ortax.org
- Health: https://www.kemkes.go.id
- Finance: https://www.ojk.go.id

**Search strategy**:
```
Site-specific search (more accurate than Google):
- site:pajak.go.id "PPh 21" "bukan pegawai" "2026"
- site:peraturan.bpk.go.id "UU" "Harmonisasi Peraturan Perpajakan"
```

**Output**: List of 5-10 primary regulations with URLs

**Example** (FreePajak tax calculator):
```markdown
## Primary Regulations

1. UU No. 7 Tahun 2021 (UU HPP) — Tarif progresif PPh OP
   URL: https://peraturan.bpk.go.id/Details/195158/uu-no-7-tahun-2021
   
2. PMK No. 168/PMK.010/2023 — Non-employee PPh 21 (50% deemed profit rate / Norma)
   URL: https://jdih.kemenkeu.go.id/fulltext/2023/168~PMK.010~2023Per.pdf
   
3. PP No. 20 Tahun 2026 — PPh Final 0.5% influencer/content creator
   URL: [actual URL]
   
4. PMK No. 101/PMK.010/2016 — PTKP values (belum berubah per 2026)
   URL: https://jdih.kemenkeu.go.id/fulltext/2016/101~PMK.010~2016Per.pdf
```

#### Step 2: Extract Key Rules & Formulas (4-8 hours)

**For each regulation**:
1. Read full text (or key sections if 100+ pages)
2. Extract: Tarif, thresholds, formulas, exceptions, effective dates
3. Verify with secondary sources (Ortax articles, tax consultant blogs)
4. Create structured notes (Markdown tables, bullet lists)

**Example** (PPh 21 progressive rates):
```markdown
## Progressive PPh OP Rates (Article 17 HPP Law)

| Bracket | PKP Range | Rate | Cumulative Tax |
|---------|-----------|------|----------------|
| 1 | 0 - 60 juta | 5% | PKP × 5% |
| 2 | 60 - 250 juta | 15% | 3 juta + (PKP - 60 jt) × 15% |
| 3 | 250 - 500 juta | 25% | 31.5 juta + (PKP - 250 jt) × 25% |
| 4 | 500 juta - 5 miliar | 30% | 94 juta + (PKP - 500 jt) × 30% |
| 5 | > 5 miliar | 35% | 1.444 juta + (PKP - 5 M) × 35% |

**Source**: Law No. 7/2021 Article 17 paragraph (1) letter a  
**Effective**: 1 Januari 2022  
**Last Updated**: 28 September 2026 (no changes since 2022)
```

**Validation checklist**:
- [ ] Formula matches official source (copy-paste exact wording)
- [ ] Edge cases documented (PKP = 0, PKP = exact bracket threshold)
- [ ] Effective date noted (for versioning)
- [ ] Source URL cited

#### Step 3: Identify Data That Changes Frequently (2-3 hours)

**Create change log table**:
```markdown
## Regulatory Change History

| Data | Last Changed | Frequency | Next Review | Source |
|------|--------------|-----------|-------------|--------|
| PPh OP tarif | 2022-01-01 | Rare (5-10 years) | 2027+ | UU HPP |
| PTKP values | 2016-01-01 | Rare (5-10 years) | 2027+ | PMK 101/2016 |
| PPh Final 0.5% threshold | 2026-01-01 | Yearly (budget law) | 2027-01-01 | PP 20/2026 |
| Tax treaty rates | Varies by country | Per treaty update | Quarterly check | DJP website |
```

**Action**:
- High-frequency data → JSON versioned (with effective_date, changelog)
- Low-frequency data → Hardcoded OK (but document source for future update)

#### Step 4: Document Compliance Requirements (2-3 hours)

**Checklist format**:
```markdown
## Compliance Checklist — FreePajak

### Data Privacy (UU PDP)
- [ ] User consent for NPWP collection (checkbox on signup)
- [ ] NPWP masked in UI (show `12.345.678.9-***-***`)
- [ ] Data encrypted at rest (Supabase RLS + AES-256)
- [ ] User can delete all data (GDPR-style export + delete button)
- [ ] Privacy policy published (URL: /privacy)

### Tax Calculation Accuracy
- [ ] Source citation on every calculation screen ("Berdasarkan UU HPP 2021")
- [ ] Disclaimer: "Calculations are estimates. Consult a certified tax consultant."
- [ ] Version tagging for regulation data (v2026.1, v2027.1)
- [ ] Changelog for formula updates (notify users if recalculation needed)

### Financial Regulations (OJK — if payment processing)
- [ ] Not applicable (no payment gateway in MVP)
- [ ] Future: If premium subscription, use licensed payment gateway (Midtrans/Xendit)

### Legal Disclaimers
- [ ] Terms of Service: "Not a substitute for professional tax advice"
- [ ] Liability limitation: "User responsible for final SPT submission"
- [ ] No guarantee of accuracy (update lag between regulation change and app update)
```

#### Step 5: Write Research Document (4-6 hours)

**File**: `docs/research/RISET_REGULASI_[DOMAIN]_[YEAR].md`


```markdown
# Regulatory Research [Domain] [Year]

**Reference Document for**: [Project Name]  
**Research Date**: [Date]  
**Status**: VALIDATED / IN REVIEW / DRAFT

---

## Executive Summary
- Key regulations (3-5 primary laws)
- Key formulas (progressive tax, insurance premium, loan interest)
- Compliance requirements (data privacy, licensing, disclaimers)
- Change frequency (yearly, quarterly, rare)

## 1. [Regulation Category 1]
### 1.1 [Subtopic]
[Detailed explanation with tables, formulas, examples]

**Source**: [UU/PP/PMK citation with URL]  
**Effective Date**: [Date]  
**Last Verified**: [Date]

## 2. [Regulation Category 2]
...

## Appendix A: Primary Source Links
1. [Law name] — [URL]
2. [Regulation name] — [URL]

## Appendix B: Change Log
| Date | Regulation | Change | Impact |
|------|-----------|--------|--------|
| 2026-01-01 | PP 20/2026 | PPh Final threshold Rp500jt | Affects 30% users |

## Appendix C: Compliance Checklist
[Copy from Step 4]
```

**Example**: FreePajak wrote `RISET_REGULASI_PAJAK_FREELANCER_2026.md` (55KB, 1,520 lines, 21 chapters)

---

## 3. Competitor Deep-Dive Analysis

### 3.1 Research Questions Framework

**Core Questions**:

1. **Who are the direct competitors?** (same target user, same core value prop)
2. **Who are indirect competitors?** (different approach, same problem)
3. **What features do they have?** (feature matrix)
4. **What are their gaps?** (what they don't do well / don't do at all)
5. **What's their business model?** (pricing, revenue streams)
6. **What's their positioning?** (messaging, brand, target user)

### 3.2 Competitor Identification (2-3 hours)

**Search strategies**:
```
Google:
- "[problem] calculator Indonesia"
- "[domain] software Indonesia"
- "[user type] tools [domain]"

Example (tax calculator):
- "kalkulator pajak freelancer Indonesia"
- "software pajak UMKM"
- "tax planning assistant Indonesia"

Product Hunt:
- https://producthunt.com/search?q=tax+calculator
- Filter by country/language if applicable

App stores:
- Google Play: "pajak" "tax" "freelancer"
- iOS App Store: similar keywords

Industry reports:
- CB Insights, Crunchbase (for funded startups)
- Local tech news (Dailysocial.id, Tech in Asia)
```

**Output**: List of 6-10 competitors (3-5 direct, 3-5 indirect)

**Example** (FreePajak):
```markdown
## Competitor List

### Direct (same target: freelancer tax)
1. Ortax Kalkulator — https://kalkulator.ortax.org
2. Desent.io Pajak Freelancer — https://desent.io/pajak-freelancer
3. Putranto Alliance Tools — https://putranto-alliance.com/tools

### Indirect (broader target: SME / payroll)
4. KlikPajak (Mekari) — https://klikpajak.id
5. InfoPajak — https://infopajak.co.id
6. KantorKu Payroll — https://kantorku.id

### Adjacent (tax consultants, not software)
7. OnlinePajak — https://onlinepajak.com
```

### 3.3 Feature Matrix Creation (4-6 hours)

**For each competitor**:
1. Sign up / try demo (if free tier available)
2. Explore all pages (homepage, features, pricing, blog, help docs)
3. Take screenshots (homepage, feature pages, pricing)
4. Document features in spreadsheet/table

**Feature matrix template**:
```markdown
## Feature Comparison Matrix

| Feature | FreePajak | Ortax | Desent | KlikPajak | InfoPajak | KantorKu |
|---------|-----------|-------|--------|-----------|-----------|----------|
| **Core Features** | | | | | | |
| Tax calculator | ✅ Multi-scheme | ✅ One-shot | ❌ (blog only) | ✅ Enterprise | ✅ Basic | ❌ |
| Compare 3 schemes side-by-side | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Longitudinal tracking (history) | ✅ | ❌ | ❌ | ✅ | ❌ | ✅ (payroll) |
| Multi-client management | ✅ | ❌ | ❌ | ✅ | ❌ | ✅ |
| Export SPT-ready (Excel) | ✅ | ❌ | ❌ | ✅ (XML) | ❌ | ✅ |
| Reminder deadline | ✅ Email+WA | ❌ | ❌ | ✅ Email | ❌ | ✅ |
| **Advanced Features** | | | | | | |
| Tax treaties for 71 countries | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Crypto tax | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Payment gateway fee adjuster | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| **Pricing** | | | | | | |
| Free tier | ✅ (3 calc/mo) | ✅ Unlimited | ✅ N/A (blog) | ❌ Trial only | ✅ Unlimited | ❌ Trial only |
| Premium | Rp29-99k/mo | Gratis | N/A | Rp200k-2jt/mo | Gratis | Rp50-150k/emp/mo |
| **Target User** | | | | | | |
| Primary | Freelancer | Tax professional | Developer (edu) | Enterprise | General public | SME payroll |
```

**Gap identification**:
```markdown
## Gap Analysis

### Features NO competitor has:
1. ✅ Multi-skema comparison side-by-side (ALL competitors one-shot only)
2. ✅ Longitudinal tracking multi-client (Ortax/InfoPajak one-off, KlikPajak enterprise-only)
3. ✅ Tax treaty 71 negara (NO competitor covers international freelance)
4. ✅ Crypto payment tracking (NO competitor handles crypto income)

### Features competitors have that we DON'T (MVP scope):
1. ❌ e-Filing integration (KlikPajak/OnlinePajak) — Complex, requires DJP API
2. ❌ e-Faktur PPN (KlikPajak) — Not relevant for freelancer <Rp4.8M
3. ❌ Payroll bulk upload (KantorKu) — Not solo dev target
4. ❌ Tax consultant marketplace (OnlinePajak) — Different business model

### Opportunity = Gap × Pain Intensity
- **Highest opportunity**: Multi-scheme comparison (high pain: "confused about choosing scheme", no solution exists)
- **Medium opportunity**: Tax treaty (medium pain: "confused about foreign client taxes", Ortax partial coverage)
- **Low opportunity**: Crypto tracker (low pain: "still niche", few freelancers paid in crypto 2026)
```

### 3.4 Positioning Analysis (2-3 hours)

**For each competitor, document**:
1. Homepage headline (primary value prop)
2. Target user (explicit or inferred)
3. Pricing tier (free/freemium/paid-only)
4. Differentiator (what makes them unique)

**Example**:
```markdown
## Competitor Positioning

### 1. Ortax Kalkulator
- **Headline**: "Online Tax Calculator" (generic)
- **Target**: Tax professionals, accountants (not freelancer-specific)
- **Pricing**: Free (ad-supported)
- **Differentiator**: Trusted brand (20+ years, backed by tax consultants)
- **Weakness**: One-shot calculator (no account, no tracking, no export)

### 2. KlikPajak (Mekari)
- **Headline**: "Corporate Tax Solutions" (B2B focus)
- **Target**: SME 5-50 employees, enterprise
- **Pricing**: Rp200k-2M/month (too expensive for solopreneurs)
- **Differentiator**: Full compliance suite (e-Filing, e-Faktur, e-Bupot)
- **Weakness**: Overkill for 1-person freelancer (feature bloat, high price)

### 3. FreePajak (our positioning)
- **Headline**: "Calculate 3 Schemes. Choose the Most Cost-Effective. Save Millions."
- **Target**: Freelancer, solopreneur, content creator 1-person business
- **Pricing**: Freemium (Rp0-99k/bulan, 10x cheaper than KlikPajak)
- **Differentiator**: Tax planning assistant (compare 3 schemes, track multi-client, international)
- **Moat**: Tax treaty database (71 countries), crypto tracker, longitudinal history
```

**Positioning statement template**:
```
For [target user] who [pain point],
[product name] is a [category] that [key benefit],
unlike [competitor/alternative] which [competitor weakness].
```

**FreePajak example**:
> "For Indonesian freelancers & solopreneurs who struggle to choose the most cost-effective tax scheme (Final 0.5%, NPPN, General Rate) and find it cumbersome to track income from multiple clients (domestic/overseas/crypto), FreePajak is a tax planning assistant that automatically compares 3 schemes simultaneously, recommends the most cost-effective option, and provides multi-client tracking with SPT-ready export, unlike Ortax/InfoPajak which are one-shot calculators (data lost after completion) and KlikPajak which is enterprise-focused (Rp200k-2M/month, too expensive)."

### 3.5 Write Competitor Analysis Document (4-6 hours)

**File**: `docs/research/ANALISIS_KOMPETITOR_[PROJECT]_[YEAR].md`

**Structure**:
```markdown
# In-Depth Competitor Analysis: [Project Name]

**Project**: [Name]  
**Research Date**: [Date]  
**Target User**: [User segment]

---

## Executive Summary
- **[N] kompetitor** analyzed (X direct, Y indirect)
- **Gap terbesar**: [Primary gap — what no competitor does]
- **Opportunity**: [Your unique value prop]
- **Positioning**: [Your positioning statement]

## 1. [Competitor Name 1]
### Overview
- **Jenis**: [Tool/Platform/Blog/Consultant]
- **URL**: [Link]
- **Target**: [User type]
- **Harga**: [Free/Paid/Freemium]

### Features
[Bullet list 5-10 key features]

### Strengths
[What they do well]

### Weaknesses / Gaps
[What they miss, what users complain about]

### Business Model
[Revenue streams, pricing tiers]

## 2. [Competitor Name 2]
...

## Feature Comparison Matrix
[Table from Section 3.3]

## Gap Analysis
### Features NO competitor has
[List with checkmarks]

### Features competitors have that we DON'T
[List with X marks + rationale why we skip]

## Positioning Map
[Visual or text grid showing where each competitor sits on 2 axes]

Example axes:
- X-axis: Price (Low → High)
- Y-axis: Feature complexity (Simple → Enterprise)

## Our Positioning & Differentiator
[Positioning statement + tagline + moat]

## Recommendations
1. [Action item based on gap analysis]
2. [Marketing angle based on competitor weakness]
3. [Feature priority based on what works elsewhere]
```

**Example**: FreePajak wrote `ANALISIS_KOMPETITOR_FREEPAJAK_2026.md` (30KB, 726 lines, 6 competitors, full page/subpage breakdown)

---

## 4. Domain Knowledge Acquisition

### 4.1 When You Don't Know the Domain

**Example scenarios**:
- Developer building tax calculator → not a tax expert
- Designer building medical dosage app → not a doctor
- Engineer building loan scoring → not a credit analyst

**Risk**: Build wrong features, incorrect formulas, violate domain norms

**Solution**: Structured learning sprint (1-2 weeks before design)

### 4.2 Learning Sprint Framework (5-7 days)

**Day 1-2: Vocabulary & Concepts**
- Read 3-5 beginner articles/blog posts (e.g., "Freelancer Taxes for Beginners")
- Watch 2-3 YouTube explainer videos (visual learning)
- Create glossary (20-30 terms with definitions)

**Example glossary** (tax domain):
```markdown
## Tax Glossary

- **PKP (Penghasilan Kena Pajak)**: Taxable income after deductions (netto - PTKP)
- **PTKP**: Tax-free allowance (varies by marital status + dependents)
- **PPh 21**: Income tax for employees/contractors (withheld by payer)
- **PPh Final**: Final tax (not eligible for annual credit/refund)
- **NPPN**: Deemed profit percentage (50% for IT consultants, no bookkeeping needed)
- **SPT**: Tax return (1770 for individuals, due March 31)
- **Bukti Potong**: Withholding tax receipt (from client who withheld PPh 21)
- **DPP**: Tax base (gross income × NPPN percentage)
- **Tarif Progresif**: Progressive rates (5%, 15%, 25%, 30%, 35%)
```

**Day 3-4: Expert Interviews** (if possible)
- Find 2-3 domain experts (LinkedIn, Twitter, Reddit, forums)
- Offer Rp100-200k for 30-minute interview (or coffee chat if friendly)
- Ask:
  1. "What are the top 3 mistakes beginners make in [domain]?"
  2. "What edge cases should I be aware of?"
  3. "What data changes frequently vs rarely?"
  4. "What would make your life easier (pain points)?"

**Day 5-6: Hands-On Practice**
- Use existing tools (competitors) as a user
- Work through 3-5 realistic scenarios (e.g., calculate tax for 5 different income levels)
- Document edge cases encountered

**Day 7: Synthesis**
- Write 1-page "Domain Cheat Sheet" with:
  - Core concepts (top 10 terms)
  - Key formulas (with source citations)
  - Edge cases (thresholds, exceptions)
  - Compliance gotchas (legal risks)

---

## 5. Research Deliverables Structure

### 5.1 Folder Organization

```
/opt/data/home/project/[project-name]/
├── docs/
│   ├── research/                          # Research phase output
│   │   ├── RISET_REGULASI_[DOMAIN]_[YEAR].md
│   │   ├── ANALISIS_KOMPETITOR_[PROJECT]_[YEAR].md
│   │   ├── DOMAIN_CHEAT_SHEET.md
│   │   └── GLOSSARY.md
│   ├── pm/                                # PM deliverables (from Module 01-02)
│   │   ├── IDEA_BRIEF.md
│   │   └── SCOPE_STATEMENT.md
│   └── specs/                             # Design/tech specs (from Module 04-05)
│       ├── DESIGN.md
│       └── DESIGN_SPEC.md
└── data/                                  # Structured regulation data (JSON)
    └── regulations/
        ├── pph21-rates.json
        ├── ptkp-values.json
        └── metadata.json
```

### 5.2 File Naming Conventions

| File Type | Naming Pattern | Example |
|-----------|----------------|---------|
| Regulatory research | `RISET_REGULASI_[DOMAIN]_[YEAR].md` | `RISET_REGULASI_PAJAK_FREELANCER_2026.md` |
| Competitor analysis | `ANALISIS_KOMPETITOR_[PROJECT]_[YEAR].md` | `ANALISIS_KOMPETITOR_FREEPAJAK_2026.md` |
| Domain glossary | `GLOSSARY_[DOMAIN].md` | `GLOSSARY_TAX.md` |
| Domain cheat sheet | `DOMAIN_CHEAT_SHEET_[DOMAIN].md` | `DOMAIN_CHEAT_SHEET_INSURANCE.md` |
| Structured data | `[data-type]-[version].json` | `pph21-rates-v2026.1.json` |

### 5.3 Document Metadata (Frontmatter)

**Every research document starts with**:
```markdown
# [Document Title]

**Reference Document for**: [Project Name]  
**Research Date**: [YYYY-MM-DD]  
**Status**: DRAFT | IN REVIEW | VALIDATED  
**Researcher**: [Name]  
**Last Updated**: [YYYY-MM-DD]  

---

[Rest of document]
```

**Why metadata matters**:
- `Status: VALIDATED` → Safe to code against
- `Status: DRAFT` → Still need expert review
- `Last Updated` → Know if data stale (e.g., 2024 research for 2026 project → revalidate)

---

## 6. Validation & Citation Standards

### 6.1 Source Hierarchy (Most → Least Authoritative)

1. **Primary sources** (government, official standards):
   - Laws: UU, PP, Perpres, Permenkes, PMK
   - International: WHO guidelines, IEEE standards, ISO specs
   - Trust: ✅✅✅✅✅ (100% — use as single source of truth)

2. **Secondary sources** (expert interpretation):
   - Tax consultant blogs (Ortax, TaxPrime, DDTC)
   - Industry reports (Gartner, McKinsey, local research firms)
   - Academic papers (peer-reviewed journals)
   - Trust: ✅✅✅✅ (80% — cross-check with primary if conflict)

3. **Tertiary sources** (community, forums):
   - Reddit, Quora, Facebook groups
   - User-generated content
   - Trust: ✅✅ (40% — verify with authoritative source)

4. **Competitor claims** (marketing materials):
   - Competitor website copy, ads
   - Trust: ✅ (20% — verify by using product yourself)

### 6.2 Citation Format

**Inline citation** (every factual claim):
```markdown
Non-employee PPh 21 is calculated using 50% Norma (tax base = 50% × gross), then progressive rates without PTKP. **[Source: PMK 168/2023 Article 14]**

Indonesia-Singapore Tax Treaty: WHT 15% (Article 11 - Interest), 10% (Article 10 - Dividends). **[Source: P3B Indonesia-Singapura 2007, https://pajak.go.id/tax-treaty/singapore]**
```

**Footnotes** (if many citations):
```markdown
Non-employee PPh 21 is calculated using 50% Norma[^1], then progressive rates without PTKP[^2].

[^1]: PMK No. 168/PMK.010/2023 Article 14 — https://jdih.kemenkeu.go.id/...
[^2]: Law No. 7 of 2021 (HPP Law) Article 17 paragraph (1) letter a
```

**References section** (end of document):
```markdown
## References

### Primary Sources
1. Law No. 7 of 2021 (HPP Law) — Progressive PPh OP rates  
   https://peraturan.bpk.go.id/Details/195158/uu-no-7-tahun-2021
   
2. PMK No. 168/PMK.010/2023 — PPh 21 employee & non-employee  
   https://jdih.kemenkeu.go.id/fulltext/2023/168~PMK.010~2023Per.pdf

### Secondary Sources
3. Ortax (2026). "Freelancer PPh 21 Guide 2026"  
   https://ortax.org/pajak-freelance-2026

### Competitor Analysis
4. KlikPajak pricing page (accessed 2026-09-28)  
   https://klikpajak.id/pricing
```

### 6.3 Validation Checklist

**Before marking research as `VALIDATED`**:
- [ ] Every factual claim has source citation
- [ ] Primary sources verified (downloaded PDF, checked URL live)
- [ ] Formulas tested with 3-5 example calculations (manual check)
- [ ] Edge cases documented (thresholds, zero values, negative values)
- [ ] Effective dates noted (for versioning)
- [ ] Expert review (if possible — send to 1-2 domain experts for sanity check)
- [ ] Competitor features verified (signed up, tried demo, took screenshots)

---

## 7. When Research is "Done"

**Exit criteria** (all must be TRUE):
- ✅ All regulatory questions answered (laws, formulas, compliance)
- ✅ 6-10 competitors analyzed (feature matrix, gap analysis, positioning)
- ✅ Domain glossary created (20-30 terms defined)
- ✅ Research documents written:
  - `RISET_REGULASI_*.md` (status: VALIDATED)
  - `ANALISIS_KOMPETITOR_*.md` (status: VALIDATED)
  - `GLOSSARY_*.md`
- ✅ Structured data created (if needed):
  - `data/regulations/*.json` (versioned, source-cited)
- ✅ Validation checklist complete (all sources cited, formulas tested)

**Time budget check**:
- If research > 30% of total project timeline → scope down (too complex for solo dev)
- If research < 10% for regulated domain → risk of rework (not enough depth)

**Proceed to Module 02 (Scope Definition)** only after research is VALIDATED.

---

## 8. Tools & Resources

**Research Management**:
- Obsidian (Markdown notes with backlinks, graph view)
- Notion (databases for competitor tracking, feature matrix)
- Google Sheets (feature comparison table, gap analysis matrix)

**Source Management**:
- Zotero (citation manager, save PDFs with metadata)
- Pocket (save articles for later reading)
- Hypothesis (web annotation, highlight + comment on any page)

**Validation**:
- Google Sheets (test calculations with formulas)
- Python Jupyter Notebook (validate complex formulas with code)
- Vitest (unit tests for regulation calculations)

**Competitor Tracking**:
- Similarweb (traffic estimates, top pages)
- Wappalyzer (tech stack detection)
- BuiltWith (same as Wappalyzer)
- Archive.org Wayback Machine (historical competitor features)

---

## 9. Common Pitfalls & How to Avoid

| Pitfall | Symptom | Fix |
|---------|---------|-----|
| **Analysis paralysis** | Research for 4+ weeks, never start coding | Set hard deadline (2 weeks max for medium project), timebox each research phase |
| **Stale data** | Using 2023 regulations for 2026 project | Always check "Last Updated" date, verify current year regulations |
| **No source citations** | "I think PPh 21 is 5%" (no proof) | Every factual claim needs URL or law citation |
| **Skipping edge cases** | Calculator breaks when income = 0 or negative | Document edge cases explicitly: "Income < 0 → show error" |
| **Competitor bias** | Assume competitor feature list is accurate without verifying | Sign up, try demo, take screenshots (don't trust marketing copy) |
| **Domain expert overload** | Expert uses jargon you don't understand | Ask "Can you explain like I'm 5?" or "What's a simple analogy?" |
| **No validation** | Code against untested formula | Test formula manually with 3-5 examples before coding |

---

## 10. Case Study: FreePajak Research (Real Example)

**Project**: Tax planning assistant for Indonesian freelancers  
**Timeline**: 12 weeks total, 2 weeks research (16% of timeline)  
**Research output**: 150KB, 3,324 lines across 5 documents

### Research Breakdown:

| Document | Size | Lines | Time Spent | Status |
|----------|------|-------|------------|--------|
| RISET_REGULASI_PAJAK_FREELANCER_2026.md | 55KB | 1,520 | 8 hours | ✅ VALIDATED |
| ANALISIS_KOMPETITOR_FREEPAJAK_2026.md | 30KB | 726 | 6 hours | ✅ VALIDATED |
| IDEA_BRIEF.md | 22KB | 225 | 3 hours | ✅ COMPLETE |
| SCOPE_STATEMENT.md | 32KB | 562 | 4 hours | ✅ COMPLETE |
| LOGO_DESIGN_BRIEF.md | 11KB | 291 | 2 hours | ✅ READY |

**Total research time**: 23 hours (vs 240 hours total project = 9.6% — efficient)

### Key Findings:

**Regulatory research**:
- 3 tax schemes (Final 0.5%, NPPN, Progressive) → Must compare side-by-side
- 71 tax treaties → Unique differentiator (no competitor covers)
- PTKP categories (TK0-K3) → Need marital status + dependents input

**Competitor analysis**:
- 6 competitors analyzed (Ortax, KlikPajak, Desent, Putranto, InfoPajak, KantorKu)
- **Gap**: No longitudinal tracking (all one-shot calculators)
- **Gap**: No multi-skema comparison (user must use 3 separate calculators)
- **Opportunity**: Tax planning assistant (track + compare + recommend)

**Business impact**:
- Positioned as affordable (Rp29-99k/mo vs Rp200k-2jt kompetitor)
- Target freelancer (vs Ortax = tax professional, KlikPajak = enterprise)
- Moat: tax treaty database + crypto tracker (hard to replicate)

### What Went Well:
- ✅ Deep regulatory research → zero rework (formulas correct first time)
- ✅ Competitor page/subpage exploration → found gaps competitors missed
- ✅ Source citations → easy to update when regulations change

### What Could Improve:
- ⚠️ No expert interview (relied on blog posts only) → Risk: missed edge cases
- ⚠️ No user validation (didn't interview 5 freelancers to confirm pain) → Mitigated by Module 02 user stories

---

**Conclusion**: Deep research upfront (2 weeks) saved 4-6 weeks of potential rework (wrong formulas, wrong positioning, wrong features). ROI: 3x time saved.
