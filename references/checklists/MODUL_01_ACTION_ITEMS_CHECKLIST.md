# Modul 01: Post-Feasibility Action Items Checklist

> **Purpose**: Daftar tindakan kritis yang harus dilakukan SETELAH Modul 01 (Idea & Feasibility) selesai, SEBELUM atau PARALLEL dengan development (Modul 06).
>
> **Context**: Feasibility scorecard bisa LOLOS (≥3.5/5) tapi masih punya risk/assumption yang belum tervalidasi. Action items ini untuk **de-risk** project sebelum habis waktu coding.

---

## 1. KRITIS (Must-Do Sebelum Development)

### 1.1 Market Validation

**Applicable When:** B2C/B2B SaaS, monetized product, new market entry

**Actions:**
- [ ] **Landing page waitlist** (email capture)
  - Tool: Carrd/Typedream (1 jam setup) atau Next.js static page + Supabase DB
  - Target: 50–100 email signups sebelum mulai coding
  - Metric: Conversion rate landing view → signup (benchmark: 2–5%)
- [ ] **Survey willingness to pay**
  - Platform: Google Forms/Typeform (gratis) atau Tally.so
  - Questions: "Berapa kamu mau bayar untuk [product value]?" (Rp29rb/Rp49rb/Rp99rb/Lainnya)
  - Target: 30+ responses untuk validate pricing assumption
  - Red flag: Jika >60% responden pilih "Rp0 (tidak mau bayar)" → re-evaluate value prop

**Deliverable:**
- Waitlist landing page URL live + analytics setup (Google Analytics/Plausible)
- Survey response spreadsheet dengan pricing preference distribution

**Timeline:** Week 1–2 (parallel dengan Modul 02 Scope Definition)

---

### 1.2 Formula/Logic Verification

**Applicable When:** Financial calculations (tax, loan, investment), health/medical logic, legal compliance rules, engineering formulas (structural, electrical)

**Actions:**
- [ ] **Review rumus/logic inti vs domain expert**
  - Contoh domain expert:
    - Tax calculator → Konsultan pajak Brevet A/B/C atau akuntan publik CPA
    - Medical symptom checker → Dokter umum atau specialist (WAJIB jika ada diagnosis output)
    - Loan calculator → Financial planner atau banker
    - Legal document generator → Lawyer/legal counsel (WAJIB jika output dipakai untuk legal binding)
  - Format: 1-hour consultation (Rp300rb–1jt) atau gratis jika punya koneksi
  - Deliverable: Sign-off email/dokumen "Formula reviewed, no major issues found"
- [ ] **Unit test edge cases**
  - Buat 30+ test cases (normal + edge cases + boundary values)
  - Example (tax calculator): TK/0, K/1, K/2, K/3 PTKP × omzet Rp0/Rp10jt/Rp50jt/Rp500jt/Rp5M
  - Tool: Vitest/Jest (JavaScript), pytest (Python), PHPUnit (PHP)

**Red Flag (STOP Development):**
- Domain expert bilang "Formula salah, bisa bikin user rugi/bahaya" → WAJIB fix dulu
- Regulasi butuh sertifikasi/izin khusus yang belum dimiliki (contoh: medical device approval BPOM)

**Timeline:** Week 1–2 (MUST complete sebelum Modul 06 Development)

---

### 1.3 Security Baseline (Jika Handle Data Sensitif)

**Applicable When:** Data pribadi sensitif (NPWP, KTP, health records, financial data, password, payment info)

**Actions:**
- [ ] **OWASP Top 10 checklist review**
  - Download: https://owasp.org/www-project-top-ten/
  - Focus:
    - A01:2021 – Broken Access Control → Implement RLS (Row Level Security) atau RBAC
    - A02:2021 – Cryptographic Failures → HTTPS only, bcrypt password hashing (cost ≥12), encrypt PII at rest
    - A03:2021 – Injection → Parameterized queries (NO raw SQL concatenation)
    - A07:2021 – Identification and Authentication Failures → Rate limiting login (5 attempts/15 min), MFA untuk admin
  - Tool: OWASP ZAP scanner (gratis) atau manual checklist walkthrough
- [ ] **Privacy Policy + Terms of Service draft**
  - Template: Termly.io (gratis tier) atau consult lawyer (Rp2–5jt untuk custom draft)
  - WAJIB include: data collection scope, retention period, user rights (akses/hapus data per UU PDP), disclaimer liability
- [ ] **Consent flow design**
  - Explicit checkbox saat signup: "Saya setuju Privacy Policy & ToS" (WAJIB unchecked default, per UU PDP)
  - Feature: "Delete Account" button (hard delete semua data user)

**Red Flag (HIGH RISK):**
- Tidak ada enkripsi data sensitif → USER DATA BREACH risk (denda UU PDP Rp5 miliar)
- Tidak ada Privacy Policy → Pelanggaran UU PDP No. 27/2022 (denda Rp2–5 miliar)

**Timeline:** Week 1–3 (parallel dengan Modul 02–04, MUST complete sebelum Modul 06)

---

## 2. PENTING (Strongly Recommended, Bisa Parallel)

### 2.1 Pricing Strategy A/B Test

**Applicable When:** Monetized product (SaaS, marketplace, e-commerce)

**Actions:**
- [ ] **Landing page A/B test pricing tiers**
  - Variant A: Rp29rb/bulan
  - Variant B: Rp49rb/bulan
  - Variant C: Rp99rb/bulan
  - Tool: Google Optimize (gratis, sunset 2023 → gunakan Vercel Edge Config + cookie) atau manual split 33/33/33 traffic
  - Metric: Click "Start Free Trial" rate per variant
- [ ] **Willingness to pay survey follow-up**
  - Question: "Pada harga [Rp49rb/bulan], apakah kamu akan subscribe?" (Ya/Mungkin/Tidak)
  - Question: "Apa alasan kamu TIDAK akan subscribe?" (Terlalu mahal/Fitur kurang/Gak butuh/Lainnya)

**Deliverable:**
- Pricing recommendation based on data: "Optimal price: Rp49rb/bulan (conversion rate 4.2%, MRR projection Rp2.1 juta at 50 users)"

**Timeline:** Week 2–3 (parallel dengan Modul 04 UI/UX)

---

### 2.2 Competitor Deep-Dive

**Actions:**
- [ ] **Feature matrix comparison** (You vs Top 3 Competitors)
  - Columns: Feature, You (MVP), Competitor A, Competitor B, Competitor C
  - Rows: Core features (15–20 items)
  - Highlight: Gaps (fitur yang mereka punya, kamu belum) + Differentiators (fitur unik kamu)
- [ ] **Pricing comparison**
  - Free tier limits vs Paid tier
  - Annual discount strategy (contoh: Rp490rb/tahun = 2 bulan gratis vs bulanan Rp49rb × 12 = Rp588rb)
- [ ] **User reviews scraping**
  - Source: Google Play reviews, App Store reviews, Capterra, G2, Product Hunt comments
  - Focus: Pain points users complain (bugs, missing features, UX friction) → jadi lesson learned untuk kamu
  - Tool: Manual copy-paste atau scraper (BeautifulSoup Python, Apify)

**Deliverable:**
- Competitive analysis doc (5–10 pages) dengan actionable insights: "Competitor X lemah di onboarding UX (20% churn di hari pertama per reviews), kita harus bikin onboarding smooth max 3 steps"

**Timeline:** Week 1–2 (parallel dengan Modul 02 Scope)

---

### 2.3 Tech Spike Proof-of-Concept

**Applicable When:** Ada "hardest technical risk" yang belum pernah dicoba (new framework, complex algorithm, third-party API integration)

**Actions:**
- [ ] **Identify hardest technical risk**
  - Example: "Belum pernah pakai React Server Components" → Risk: Development timeline bisa 2× lebih lama karena learning curve
  - Example: "Integrasi Midtrans recurring billing" → Risk: Webhook handling salah, user bayar tapi subscription gak aktif
- [ ] **Build throwaway spike (1–2 hari)**
  - Goal: Prove "This can be done in X hours/days"
  - Deliverable: Working prototype (boleh code jelek, no production-ready) + time log "Actual time: 4 hours"
  - Decision: Jika spike gagal/butuh >5 hari → Simplify tech stack atau hire freelancer

**Deliverable:**
- Spike demo video/screenshot + conclusion: "Feasible, estimated 2 days for production-ready implementation"

**Timeline:** Week 1 (BEFORE Modul 05 System Design, jika ada high technical risk)

---

## 3. OPSIONAL (Nice to Have, Bisa Ditunda Post-MVP)

### 3.1 Community Building Setup

**Actions:**
- [ ] Discord/Telegram/Slack community group
  - Purpose: Early adopter feedback loop, beta tester recruitment, viral growth via word-of-mouth
  - Target: 100 members sebelum launch, 1,000 members dalam 3 bulan post-launch
- [ ] Social media presence (Twitter/X, LinkedIn, Instagram)
  - Frequency: 3× per minggu (behind-the-scenes development, tips/tricks, launch countdown)

**Timeline:** Week 4–8 (parallel dengan Modul 06 Development)

---

### 3.2 SEO Keyword Research + Content Calendar

**Actions:**
- [ ] **Keyword research**
  - Tool: Google Keyword Planner (gratis), Ahrefs (paid $99/bulan), Ubersuggest (freemium)
  - Target: 10–20 keywords dengan search volume 500–5,000/month + low competition (KD <30)
  - Example (tax calculator Indonesia): "kalkulator pajak freelancer Indonesia" (1,200 search/month, KD 18)
- [ ] **Blog content calendar** (8–12 artikel pre-launch)
  - Format: "Cara [solve problem]" (how-to guide), "Panduan Lengkap [topic]" (ultimate guide), "X vs Y" (comparison)
  - SEO optimization: Title tag <60 char, meta description <160 char, H1/H2/H3 hierarchy, internal linking

**Timeline:** Week 4–12 (parallel dengan development, publish 1 artikel per minggu)

---

### 3.3 Partnership Outreach

**Actions:**
- [ ] **Identify 5–10 potential partners**
  - Example (tax calculator): Platform freelancer (Projects.co.id, Sribu.com, Fastwork.id), komunitas freelancer (Facebook Group "Freelancer Indonesia")
  - Pitch: "Embed kalkulator pajak di dashboard kamu, revenue share 20% dari Premium conversions"
- [ ] **Cold email outreach** (template: AIDA format)
  - Subject: "Partnership Opportunity: Tax Calculator Widget untuk [Platform Name]"
  - Body: Attention (data freelancer bingung pajak), Interest (value prop hemat jutaan), Desire (case study/demo), Action (30-min call next week?)

**Timeline:** Week 8–12 (setelah MVP ready untuk demo)

---

## 4. Decision Framework: Prioritize Which Action Items?

**IF feasibility score ≥ 4.5/5 (Very Strong):**
- KRITIS: 1.2 Formula Verification (jika applicable), 1.3 Security Baseline (jika applicable)
- SKIP: 1.1 Market Validation (bisa ditunda post-MVP jika confidence tinggi)

**IF feasibility score 3.5–4.4/5 (Moderate, ada red flags):**
- WAJIB: Semua KRITIS (1.1, 1.2, 1.3)
- PENTING: 2.2 Competitor Deep-Dive, 2.3 Tech Spike (jika ada technical risk)

**IF feasibility score <3.5/5 (Weak, SHOULD NOT PROCEED):**
- STOP development → Pivot ide atau simplify scope dulu

---

## 5. Tracking & Accountability

**Tool:** Notion checklist database atau Linear project "Pre-Development Validation"

**Columns:**
- Action Item (text)
- Priority (KRITIS/PENTING/OPSIONAL)
- Status (Not Started / In Progress / Done)
- Owner (Solo Dev / External Consultant)
- Deadline (date)
- Deliverable (text/link)
- Blocker? (Yes/No + notes)

**Review Cadence:**
- Daily standup (solo dev → 5-min self-check): "Did I make progress on KRITIS items today?"
- Weekly review: "Are all KRITIS items on track to complete before Week 5 (Modul 06 start)?"

---

## 6. Exit Criteria: When Can I Start Modul 06 Development?

**Minimum Bar (MUST complete):**
- ✅ All KRITIS action items = DONE (or explicitly accepted risk jika skip)
- ✅ Modul 02 Scope Statement finalized (MoSCoW priorities clear)
- ✅ Modul 05 System Design approved (architecture, database schema, API routes)

**Recommended Bar (SHOULD complete):**
- ✅ KRITIS + at least 1 PENTING action item done (pricing validated OR competitor analyzed OR tech spike proven)

**Ideal Bar (GOOD TO HAVE):**
- ✅ KRITIS + 2 PENTING + 1 OPSIONAL done (community setup or blog 1st article published)

---

**Last Updated:** 2026-09-30  
**Changelog:**
- 2026-09-30: Initial checklist based on FreePajak Modul 01 evaluation (feasibility 4.25/5, risks: market validation, formula complexity, competitor threat)
