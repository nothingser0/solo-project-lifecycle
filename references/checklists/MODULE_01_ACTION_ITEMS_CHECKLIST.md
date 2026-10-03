# Module 01: Post-Feasibility Action Items Checklist

> **Purpose**: Critical checklist of actions to perform AFTER Module 01 (Idea & Feasibility) is complete, BEFORE or IN PARALLEL with development (Module 06).
>
> **Context**: A feasibility scorecard may PASS (≥3.5/5) but still hold unvalidated risks or assumptions. These action items **de-risk** the project before sinking time into code.

---

## 1. CRITICAL (Must-Do Before Development)

### 1.1 Market Validation

**Applicable When:** B2C/B2B SaaS, monetized product, new market entry

**Actions:**
- [ ] **Landing page waitlist** (email capture)
  - Tool: Carrd/Typedream (1-hour setup) or Next.js static page + Supabase DB
  - Target: 50–100 email signups before writing code
  - Metric: Conversion rate landing view → signup (benchmark: 2–5%)
- [ ] **Survey willingness to pay**
  - Platform: Google Forms/Typeform (free) or Tally.so
  - Questions: "How much would you pay for [product value]?" (Rp29k/Rp49k/Rp99k/Other)
  - Target: 30+ responses to validate pricing assumptions
  - Red flag: If >60% of respondents select "Rp0 (unwilling to pay)" → re-evaluate value proposition

**Deliverable:**
- Live waitlist landing page URL + analytics setup (Google Analytics/Plausible)
- Survey response spreadsheet with pricing preference distribution

**Timeline:** Week 1–2 (in parallel with Module 02 Scope Definition)

---

### 1.2 Formula/Logic Verification

**Applicable When:** Financial calculations (tax, loan, investment), health/medical logic, legal compliance rules, engineering formulas (structural, electrical)

**Actions:**
- [ ] **Review core formula/logic against domain experts**
  - Example domain experts:
    - Tax calculator → Certified tax consultant (Brevet A/B/C) or CPA public accountant
    - Medical symptom checker → General practitioner or specialist (MANDATORY if providing diagnosis output)
    - Loan calculator → Financial planner or banker
    - Legal document generator → Lawyer/legal counsel (MANDATORY if output is used for legally binding agreements)
  - Format: 1-hour consultation (Rp300k–1M) or free via personal network
  - Deliverable: Sign-off email/document "Formula reviewed, no major issues found"
- [ ] **Unit test edge cases**
  - Create 30+ test cases (normal + edge cases + boundary values)
  - Example (tax calculator): TK/0, K/1, K/2, K/3 PTKP × gross income Rp0/Rp10M/Rp50M/Rp500M/Rp5B
  - Tool: Vitest/Jest (JavaScript), pytest (Python), PHPUnit (PHP)

**Red Flag (STOP Development):**
- Domain expert states "Formula is incorrect, could cause user harm/financial loss" → MUST fix first
- Regulation requires special certifications/permits not yet held (e.g., BPOM medical device approval)

**Timeline:** Week 1–2 (MUST complete before Module 06 Development)

---

### 1.3 Security Baseline (If Handling Sensitive Data)

**Applicable When:** Sensitive personal data (tax ID/NPWP, national ID/KTP, health records, financial data, passwords, payment info)

**Actions:**
- [ ] **OWASP Top 10 checklist review**
  - Download: https://owasp.org/www-project-top-ten/
  - Focus:
    - A01:2021 – Broken Access Control → Implement RLS (Row Level Security) or RBAC
    - A02:2021 – Cryptographic Failures → HTTPS only, bcrypt password hashing (cost ≥12), encrypt PII at rest
    - A03:2021 – Injection → Parameterized queries (NO raw SQL concatenation)
    - A07:2021 – Identification and Authentication Failures → Rate limiting login (5 attempts/15 min), MFA for admin
  - Tool: OWASP ZAP scanner (free) or manual checklist walkthrough
- [ ] **Privacy Policy + Terms of Service draft**
  - Template: Termly.io (free tier) or consult lawyer (Rp2–5M for custom draft)
  - MUST include: data collection scope, retention period, user rights (access/delete data under UU PDP), liability disclaimers
- [ ] **Consent flow design**
  - Explicit checkbox at signup: "I agree to Privacy Policy & ToS" (MUST be unchecked by default under UU PDP)
  - Feature: "Delete Account" button (hard delete all user data)

**Red Flag (HIGH RISK):**
- No sensitive data encryption → USER DATA BREACH risk (UU PDP fines up to Rp 5 billion)
- No Privacy Policy → Violation of UU PDP No. 27/2022 (fines Rp 2–5 billion)

**Timeline:** Week 1–3 (in parallel with Modules 02–04, MUST complete before Module 06)

---

## 2. IMPORTANT (Strongly Recommended, Can Be Parallel)

### 2.1 Pricing Strategy A/B Test

**Applicable When:** Monetized product (SaaS, marketplace, e-commerce)

**Actions:**
- [ ] **Landing page A/B test pricing tiers**
  - Variant A: Rp29k/month
  - Variant B: Rp49k/month
  - Variant C: Rp99k/month
  - Tool: Google Optimize (sunset 2023 → use Vercel Edge Config + cookies) or manual 33/33/33 traffic split
  - Metric: Click "Start Free Trial" rate per variant
- [ ] **Willingness to pay survey follow-up**
  - Question: "At [Rp49k/month], would you subscribe?" (Yes/Maybe/No)
  - Question: "What is the reason you would NOT subscribe?" (Too expensive/Missing features/Don't need it/Other)

**Deliverable:**
- Pricing recommendation based on data: "Optimal price: Rp49k/month (conversion rate 4.2%, MRR projection Rp2.1 million at 50 users)"

**Timeline:** Week 2–3 (in parallel with Module 04 UI/UX)

---

### 2.2 Competitor Deep-Dive

**Actions:**
- [ ] **Feature matrix comparison** (You vs Top 3 Competitors)
  - Columns: Feature, You (MVP), Competitor A, Competitor B, Competitor C
  - Rows: Core features (15–20 items)
  - Highlight: Gaps (features they have that you don't) + Differentiators (your unique features)
- [ ] **Pricing comparison**
  - Free tier limits vs Paid tier
  - Annual discount strategy (e.g., Rp490k/year = 2 months free vs monthly Rp49k × 12 = Rp588k)
- [ ] **User reviews scraping**
  - Source: Google Play reviews, App Store reviews, Capterra, G2, Product Hunt comments
  - Focus: Pain points users complain about (bugs, missing features, UX friction) → lessons learned for you
  - Tool: Manual copy-paste or scraper (BeautifulSoup Python, Apify)

**Deliverable:**
- Competitive analysis doc (5–10 pages) with actionable insights: "Competitor X is weak in onboarding UX (20% churn on day one based on reviews); we must make onboarding smooth in max 3 steps"

**Timeline:** Week 1–2 (in parallel with Module 02 Scope)

---

### 2.3 Tech Spike Proof-of-Concept

**Applicable When:** A "hardest technical risk" exists that has not been tried before (new framework, complex algorithm, third-party API integration)

**Actions:**
- [ ] **Identify hardest technical risk**
  - Example: "Never used React Server Components before" → Risk: Development timeline could take 2× longer due to the learning curve
  - Example: "Midtrans recurring billing integration" → Risk: Faulty webhook handling, user pays but subscription doesn't activate
- [ ] **Build throwaway spike (1–2 days)**
  - Goal: Prove "This can be done in X hours/days"
  - Deliverable: Working prototype (code quality does not need to be production-ready) + time log "Actual time: 4 hours"
  - Decision: If spike fails or takes >5 days → Simplify tech stack or hire a freelancer

**Deliverable:**
- Spike demo video/screenshot + conclusion: "Feasible, estimated 2 days for production-ready implementation"

**Timeline:** Week 1 (BEFORE Module 05 System Design, if high technical risk exists)

---

## 3. OPTIONAL (Nice to Have, Can Be Deferred Post-MVP)

### 3.1 Community Building Setup

**Actions:**
- [ ] Discord/Telegram/Slack community group
  - Purpose: Early adopter feedback loop, beta tester recruitment, viral growth via word-of-mouth
  - Target: 100 members before launch, 1,000 members within 3 months post-launch
- [ ] Social media presence (Twitter/X, LinkedIn, Instagram)
  - Frequency: 3× per week (behind-the-scenes development, tips/tricks, launch countdown)

**Timeline:** Week 4–8 (in parallel with Module 06 Development)

---

### 3.2 SEO Keyword Research + Content Calendar

**Actions:**
- [ ] **Keyword research**
  - Tool: Google Keyword Planner (free), Ahrefs (paid $99/month), Ubersuggest (freemium)
  - Target: 10–20 keywords with search volume 500–5,000/month + low competition (KD <30)
  - Example (tax calculator Indonesia): "kalkulator pajak freelancer Indonesia" (1,200 search/month, KD 18)
- [ ] **Blog content calendar** (8–12 pre-launch articles)
  - Format: "How to [solve problem]" (how-to guide), "Complete Guide to [topic]" (ultimate guide), "X vs Y" (comparison)
  - SEO optimization: Title tag <60 char, meta description <160 char, H1/H2/H3 hierarchy, internal linking

**Timeline:** Week 4–12 (in parallel with development, publish 1 article per week)

---

### 3.3 Partnership Outreach

**Actions:**
- [ ] **Identify 5–10 potential partners**
  - Example (tax calculator): Freelancer platforms (Projects.co.id, Sribu.com, Fastwork.id), freelancer communities (Facebook Group "Freelancer Indonesia")
  - Pitch: "Embed tax calculator widget in your dashboard, 20% revenue share from Premium conversions"
- [ ] **Cold email outreach** (template: AIDA format)
  - Subject: "Partnership Opportunity: Tax Calculator Widget for [Platform Name]"
  - Body: Attention (data on freelancers confused about taxes), Interest (value prop of saving millions), Desire (case study/demo), Action (30-min call next week?)

**Timeline:** Week 8–12 (after MVP is ready for demo)

---

## 4. Decision Framework: Prioritize Which Action Items?

**IF feasibility score ≥ 4.5/5 (Very Strong):**
- CRITICAL: 1.2 Formula Verification (if applicable), 1.3 Security Baseline (if applicable)
- SKIP: 1.1 Market Validation (can be deferred post-MVP if confidence is high)

**IF feasibility score 3.5–4.4/5 (Moderate, has red flags):**
- MANDATORY: All CRITICAL items (1.1, 1.2, 1.3)
- IMPORTANT: 2.2 Competitor Deep-Dive, 2.3 Tech Spike (if technical risk exists)

**IF feasibility score <3.5/5 (Weak, SHOULD NOT PROCEED):**
- STOP development → Pivot idea or simplify scope first

---

## 5. Tracking & Accountability

**Tool:** Notion checklist database or Linear project "Pre-Development Validation"

**Columns:**
- Action Item (text)
- Priority (CRITICAL/IMPORTANT/OPTIONAL)
- Status (Not Started / In Progress / Done)
- Owner (Solo Dev / External Consultant)
- Deadline (date)
- Deliverable (text/link)
- Blocker? (Yes/No + notes)

**Review Cadence:**
- Daily standup (solo dev → 5-min self-check): "Did I make progress on CRITICAL items today?"
- Weekly review: "Are all CRITICAL items on track to complete before Week 5 (Module 06 start)?"

---

## 6. Exit Criteria: When Can I Start Module 06 Development?

**Minimum Bar (MUST complete):**
- ✅ All CRITICAL action items = DONE (or explicitly accepted risk if skipped)
- ✅ Module 02 Scope Statement finalized (MoSCoW priorities clear)
- ✅ Module 05 System Design approved (architecture, database schema, API routes)

**Recommended Bar (SHOULD complete):**
- ✅ CRITICAL + at least 1 IMPORTANT action item done (pricing validated OR competitor analyzed OR tech spike proven)

**Ideal Bar (GOOD TO HAVE):**
- ✅ CRITICAL + 2 IMPORTANT + 1 OPTIONAL done (community setup or blog 1st article published)

---

**Last Updated:** 2026-09-30  
**Changelog:**
- 2026-09-30: Initial checklist based on FreePajak Module 01 evaluation (feasibility 4.25/5, risks: market validation, formula complexity, competitor threat)
