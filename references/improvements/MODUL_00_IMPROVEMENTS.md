# Modul 00: Product Discovery & Strategy Improvements

> **Purpose**: Supplement Modul 00 dengan 6 critical missing sections: Timeline, Budget, Respondent Recruitment, Competitive Moat, NSM Anti-Patterns, Skip Decision Tree.
>
> **Context**: Modul 00 evaluation score 3.4/5 (CONDITIONAL PASS). Framework solid, tapi missing practical guidance untuk execution (berapa lama? berapa biaya? gimana cari responden?).

---

## 1. Timeline & Budget Estimation

### 1.1 Timeline Estimation per Skala

| Skala Proyek | Total Durasi | Market Research | Competitive Analysis | User Research | Product Strategy |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Solo Dev Product** | **3-4 minggu** | 1 minggu (TAM/SAM/SOM sekunder, trend analysis) | 1 minggu (5 kompetitor, feature matrix, SWOT) | 1-2 minggu (10 interview × 45 min, survey 30-50 responden, transkrip, persona) | 1 minggu (Vision/Mission, NSM, Strategic Pillars) |
| **B2B SaaS Client** | **6-8 minggu** | 2 minggu (primary research, regulatory deep-dive) | 2 minggu (10 kompetitor, SWOT, pricing benchmarking) | 3-4 minggu (20 interview stakeholder, survey 100 responden, persona validation workshop) | 1-2 minggu (formal Vision/Mission, NSM breakdown, Value Prop Canvas workshop) |
| **Enterprise Client** | **12-16 minggu** | 4 minggu (commissioned report, consultant partnership) | 3 minggu (10+ kompetitor, Porter's Five Forces, IP/patent landscape) | 6-8 minggu (30+ interview, 200+ survey, ethnographic study, usability testing) | 3-4 minggu (business case formal, 3-year roadmap, strategic alignment workshop) |

**Catatan:**
- Timeline assume part-time 20h/week (solo dev) atau full-time 40h/week (client work).
- User research = bottleneck terbesar (recruitment + scheduling + transkrip + analysis).
- Buffer 20-30% untuk respondent no-show, reschedule, atau insight ambiguitas yang butuh follow-up interview.

### 1.2 Budget Estimation (Solo Dev Product)

| Item | Cost Range (IDR) | Notes |
| :--- | :--- | :--- |
| **Interview Incentive** | Rp 1.000.000 - Rp 3.000.000 | 10 user × Rp 100k-300k/interview (B2C: Rp 100k, B2B decision maker: Rp 200-300k) |
| **Survey Panel (Optional)** | Rp 0 - Rp 5.000.000 | Gratis jika network sendiri (Facebook Group, LinkedIn). Paid panel (Jakpat.co): Rp 50-100k/responden × 50 = Rp 2.5-5 juta |
| **Tools Subscription** | Rp 500.000 - Rp 1.000.000/bulan | Typeform Pro (Rp 400k/bulan), Notion Team (Rp 200k/bulan), Figma Pro (Rp 300k/bulan), Google Workspace (Rp 200k/bulan) |
| **Market Research Data** | Rp 0 - Rp 2.000.000 | Gratis: BPS, Kemenkop, Google Trends. Paid: Statista report (Rp 1-2 juta/report) |
| **Total (Min-Max)** | **Rp 1.500.000 - Rp 11.000.000** | Solo dev bootstrap: Rp 1.5-3 juta (gratis survey + basic tools). Solo dev proper: Rp 5-8 juta (paid panel + pro tools). |

**Budget B2B SaaS Client:** Rp 20-50 juta (include consultant fee Rp 10-30 juta untuk facilitation workshop + reporting).  
**Budget Enterprise Client:** Rp 100-300 juta (commissioned research, multi-phase study, stakeholder alignment workshop).

---

## 2. Respondent Recruitment Tactics

**Challenge**: Bagaimana cari 10 user untuk interview (especially B2B decision maker) dan 50+ responden survey?

### 2.1 B2C Recruitment

1. **Facebook Group**: Post di group relevant (contoh: "Freelancer Indonesia", "Komunitas UKM"). Tawarkan incentive Rp 100k e-wallet (GoPay/OVO/DANA) untuk 30-min interview.
2. **Reddit/Kaskus**: Post di subreddit Indonesia atau forum Kaskus (contoh: r/indonesia, FJB Kaskus). Hindari spam, kasih value dulu (share insight atau template gratis).
3. **Twitter/X**: Tweet dengan hashtag relevant (#FreelancerIndonesia, #UKMIndonesia). DM ke follower yang engage.
4. **Instagram**: Post story "Looking for [target user] untuk riset produk, ada incentive Rp 100k". Tag akun komunitas relevant.
5. **Cold DM**: Cari user di LinkedIn/Instagram yang fit persona, kirim DM personal (bukan template spam).

### 2.2 B2B Recruitment

1. **LinkedIn Sales Navigator**: Filter by job title ("Manajer Keuangan", "Direktur Operasional", "IT Manager"), company size (10-500 employees), industry.
2. **Cold Email Template** (response rate 5-10%):
   ```
   Subject: Riset produk [industry] — 15 menit chat, Rp 200k incentive
   
   Hi [Nama],
   
   Saya [Your Name], sedang riset untuk produk [brief description].
   Saya tertarik mendengar pengalaman Anda soal [specific pain point].
   
   Apakah Anda available untuk 15-min call minggu ini?
   Sebagai terima kasih, saya transfer Rp 200k ke rekening/e-wallet Anda.
   
   Calendar link: [Calendly link]
   
   Best,
   [Your Name]
   ```
3. **Warm Intro**: Minta referral dari network (ex-colleague, founder friend, investor). Conversion rate 30-50% (jauh lebih tinggi dari cold outreach).
4. **LinkedIn/Facebook Ads** (Budget Rp 500k-1 juta): Target by job title + industry, CTA "Daftar riset produk, dapat Rp 200k".

### 2.3 Paid Panel (Shortcut, Budget Tinggi)

- **Jakpat.co**: Respondent pool 300k+ Indonesia, filter by demografi/psikografi. Cost: Rp 50-100k/responden (min 30 responden).
- **Respondent.io**: Global B2B panel (C-level, VP, Director). Cost: $100-200/respondent (Rp 1.5-3 juta/interview).
- **UserTesting.com**: Video-recorded usability test. Cost: $49/respondent (Rp 750k).

### 2.4 Sample Size Justification

- **Interview 10 user**: Reach "saturation point" (insight baru stop muncul setelah user ke-8-10, per Nielsen Norman Group research 2000).
- **Survey 30 responden**: Minimum untuk statistical significance (95% confidence level, ±18% margin of error).
- **Survey 50 responden**: Ideal untuk ±14% margin of error.
- **Survey 100 responden**: ±10% margin of error (recommended untuk B2B SaaS validation).

---

## 3. Competitive Moat Assessment (Buy vs Build Decision)

### 3.1 Five Types of Competitive Moat

1. **Tech Moat**: Fitur teknis yang competitor butuh >6 bulan untuk replicate.
   - Contoh: Offline-first sync engine, real-time collaboration algorithm, proprietary ML model.
   - Durability: 6-24 bulan (tergantung complexity).

2. **Network Effect Moat**: Value produk naik dengan jumlah user (marketplace 2-sided, social platform).
   - Contoh: Tokopedia (buyer & seller), Gojek (driver & passenger).
   - Durability: 12-36 bulan (hard to disrupt once critical mass tercapai).

3. **Brand/Trust Moat**: Sertifikasi, compliance, atau regulasi barrier.
   - Contoh: ISO 27001, BPOM approval, OJK license, partnership dengan government.
   - Durability: 24-60 bulan (regulatory barrier tinggi).

4. **Switching Cost Moat**: User sulit migrate karena data lock-in atau integrasi deep.
   - Contoh: CRM dengan 2 tahun data customer, ERP terintegrasi 10 sistem internal.
   - Durability: 12-36 bulan (tergantung stickiness data/workflow).

5. **Cost Advantage Moat**: Unit economics 30%+ lebih baik dari kompetitor (ekonomi skala, proprietary supply chain).
   - Contoh: Cloud provider dengan data center sendiri, aggregator dengan exclusive supplier deal.
   - Durability: 18-48 bulan (sampai kompetitor scale up).

### 3.2 Gate Pass Criteria

**Minimum**: 1 moat dengan **durability ≥12 bulan** (competitor gak bisa copy dalam 1 tahun).

**Ideal**: 2+ moat (contoh: Tech Moat + Switching Cost = defensible combination).

### 3.3 Red Flags (Consider Pivot atau Partnership)

- ❌ 3+ kompetitor funded >$10M (Series A+) dengan feature matrix overlap 80%+.
- ❌ Kompetitor pricing 50% lebih murah dengan margin sehat (indikasi cost advantage moat mereka).
- ❌ Tidak ada moat yang identified (pure commodity product, easy to replicate dalam 3 bulan).

### 3.4 Decision Tree

```
Apakah ada ≥1 moat dengan durability ≥12 bulan?
├─ YES → Proceed dengan focused differentiation
└─ NO → Options:
    ├─ Pivot ke niche market lebih sempit (reduce competition)
    ├─ Partnership/white-label dengan incumbent (jadi supplier, bukan competitor)
    └─ STOP project (market too competitive, ROI rendah untuk solo dev)
```

---

## 4. North Star Metric: Anti-Patterns Expanded

### 4.1 Seven Common NSM Mistakes

1. ❌ **"Total registered users"** → Vanity metric (banyak daftar tapi tidak pakai, churn tinggi).
2. ❌ **"Time spent in app"** → Bukan selalu baik (user mungkin bingung, atau stuck troubleshooting).
3. ❌ **"Total page views"** → Tidak korelasi dengan retention atau revenue (user bisa spam refresh).
4. ❌ **"Number of features shipped"** → Output, bukan outcome (fitur banyak tapi gak ada yang pakai).
5. ❌ **"Daily active users (DAU)"** → Bisa dimanipulasi dengan push notification spam, tidak reflect value.
6. ❌ **"App downloads"** → Install ≠ active use (70% app di-uninstall dalam 30 hari pertama).
7. ❌ **"Revenue" (untuk early-stage)** → Lagging indicator, tidak actionable untuk product team (sales-driven, bukan product-driven).

### 4.2 Good NSM Examples (Industry Best Practices)

| Company | North Star Metric | Rationale |
| :--- | :--- | :--- |
| **Slack** | Teams sending 2,000+ messages/week | Engagement threshold = sticky team (high retention predictor) |
| **Airbnb** | Nights booked | Core transaction, reflect host & guest value |
| **Spotify** | Time spent listening | Content consumption = retention predictor |
| **Notion** | Workspaces with 3+ active members | Collaboration = network effect (switching cost tinggi) |
| **Dropbox** | Files shared between users | Collaboration moment = stickiness (bukan solo use) |
| **Netflix** | Hours watched per subscriber | Content engagement = churn prevention |
| **GitHub** | Commits per week | Developer engagement = product value realized |

### 4.3 NSM Formula Template

```
North Star Metric: [Action] by [User Segment] per [Time Period]

Example:
- BAD: "Number of transactions" (too generic, no user value clarity)
- GOOD: "Successful payments by active merchants per week" (specific action + segment + time)
```

---

## 5. Strategic Pillars Sequencing (Prioritas Eksekusi)

### 5.1 Year-by-Year Focus

| Timeline | Focus Pillars | Rationale |
| :--- | :--- | :--- |
| **Year 1 (MVP-PMF)** | Pilar 1 + Pilar 2 | Core differentiation (contoh: reliability offline-first) + table stakes (contoh: ease of use). **Focus**: Prove product-market fit dengan 2 pillars executed well. |
| **Year 2 (Growth)** | Pilar 3 + retain Pilar 1-2 | Add expansion pillar (contoh: actionable insights, integrations) untuk increase ARPU & reduce churn. Maintain pillars 1-2 quality (avoid tech debt). |
| **Year 3+ (Scale)** | Mature all 5 pillars | Add pillars 4-5 (contoh: Enterprise features, API/SDK, white-label, global expansion). Full maturity mode. |

### 5.2 Anti-Pattern

❌ **Jangan kerjakan 5 pillars parallel di Year 1** → Resource spread thin, semua pillar half-baked, tidak ada differentiation jelas (worse than no pillar sama sekali).

✅ **Do:** Execute 1-2 pillars DEEPLY (10× better than competitor pada pillar tersebut), baru expand.

---

## 6. Decision Tree: When to SKIP vs EXECUTE Modul 00

### SKIP Modul 00 (Langsung ke Modul 01) jika:

- ✅ **Project deadline <3 bulan** (tidak cukup waktu untuk riset 3-4 minggu, langsung feasibility check Modul 01).
- ✅ **Solo product portfolio project** dengan budget Rp 0 (tidak ada budget untuk interview incentive Rp 1-3 juta atau paid survey).
- ✅ **Internal tool** untuk 1-10 users saja (tidak ada market risk, user sudah known, tidak butuh competitive analysis).
- ✅ **Founder sudah domain expert** (5+ tahun kerja di industri, intimate knowledge tentang user pain points, tidak butuh user research dari nol).
- ✅ **Pivot cepat dari produk existing** (sudah ada user base, tinggal iterasi fitur, bukan launch produk baru).

### WAJIB EXECUTE Modul 00 jika:

- ✅ **B2B SaaS client work** (client expect PM rigor: TAM/SAM/SOM, competitive landscape, user validation sebelum development).
- ✅ **Fundraising pitch preparation** (investor minta market size, competitive analysis, user intent-to-buy data untuk validate thesis).
- ✅ **New market entry** (solo dev tidak familiar dengan domain, high risk launch tanpa user research, butuh validate problem exist).
- ✅ **Enterprise client RFP** (requirement formal: market research report, user persona, product strategy alignment dengan corporate goals).
- ✅ **Regulated industry** (Fintech, Healthtech, Edtech) → wajib regulatory landscape check Modul 00 sebelum invest development (avoid pivot forced by compliance issue).

### Decision Rule of Thumb

- **Budget <Rp 5 juta + Timeline <3 bulan** → SKIP Modul 00, langsung Modul 01.
- **Budget ≥Rp 10 juta + Timeline ≥3 bulan + Unknown market** → EXECUTE Modul 00.

### Flowchart

```
START
  │
  ▼
Apakah budget ≥Rp 5 juta?
├─ NO → SKIP Modul 00 (langsung Modul 01)
└─ YES
     │
     ▼
  Apakah timeline ≥3 bulan?
  ├─ NO → SKIP Modul 00
  └─ YES
       │
       ▼
    Apakah founder domain expert (5+ tahun)?
    ├─ YES → SKIP Modul 00 (kecuali client/investor requirement)
    └─ NO → EXECUTE Modul 00 (riset pasar + user validation)
```

---

## 7. Regulatory Landscape Expanded (10 Sektor)

| Sektor Industri | Regulasi Kritis Solo Dev Wajib Tahu |
| :--- | :--- |
| **Fintech / Payment** | OJK (PUJK, P2P Lending License), Bank Indonesia (GPN, QRIS wajib lisensi) |
| **Healthtech / Telemedicine** | Kemenkes (SIP dokter, rekam medis elektronik), Izin Edar Alkes |
| **Edtech / Online Course** | Kemendikbud (NPSN untuk pendidikan formal), Hak Cipta konten |
| **Data-Heavy Apps** | UU PDP No. 27/2022 (wajib consent management, data breach notification) |
| **E-Signature Apps** | Kominfo PSrE (wajib pakai vendor berizin jika tanda tangan legal binding) |
| **E-Commerce / Marketplace** | Izin PMSE Kominfo (wajib untuk transaksi >Rp1M/bulan), SKU BPOM (makanan/kosmetik), SNI (produk elektronik) |
| **Logistics / Ekspedisi** | PJPTI (Penyelenggara Jasa Titipan), SIUP transportasi |
| **Travel / Pariwisata** | SIUP pariwisata (Kemenparekraf), IATA accreditation (untuk tiket pesawat) |
| **Crypto / Blockchain** | Bappebti (wajib daftar sebagai pedagang aset kripto), BI (dilarang sebagai alat bayar) |
| **F&B Delivery / Cloud Kitchen** | Izin usaha mikro OSS, PIRT (industri rumah tangga), Halal MUI (optional tapi recommended) |

**Action Item**: Check regulatory blocker di week 1 Market Research, sebelum invest 3-4 minggu riset full. Jika blocker critical (butuh OJK license tapi gak feasible), STOP atau PIVOT immediately.

---

**Last Updated:** 2026-09-30  
**Changelog:**
- 2026-09-30: Initial improvements based on Modul 00 evaluation (score 3.4/5, CONDITIONAL PASS). Added 6 critical missing sections: Timeline (3-4 minggu solo dev), Budget (Rp 1.5-11 juta), Respondent Recruitment (LinkedIn, Jakpat, cold email template), Competitive Moat (5 types + durability ≥12 bulan), NSM Anti-Patterns (7 mistakes + 7 good examples), Skip Decision Tree (budget <Rp5 juta + timeline <3 bulan → SKIP).
