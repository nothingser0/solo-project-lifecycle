# Modul 01: Idea & Feasibility Improvements

> **Purpose**: Supplement Modul 01 dengan 7 critical missing sections: Timeline, Scope Refinement, Gate FAIL Protocol, Scoring Rubric Detail, Scale Triage Boundary, Pre-Checklist, Risk Appetite.
>
> **Context**: Modul 01 evaluation score 3.8/5 (CONDITIONAL PASS). Core framework solid (3-Filter Triage, Feasibility 4 dimensi), tapi too heavy untuk lightweight feasibility check (include full Roadmap/OKR lebih cocok di Modul 02).

---

## 1. Timeline Estimation (Modul 01 Duration)

### 1.1 Timeline per Complexity Level

| Level | Total Durasi | Deliverable Scope | Use Case |
| :--- | :--- | :--- | :--- |
| **Fast-Track (Minimal)** | **1-2 hari** | IDEA_BRIEF.md basic (3-Filter Triage + Feasibility Scorecard + Scale Triage + Top 5 Risks), skip Roadmap/OKR/Backlog detail | Solo dev portfolio project, internal tool, tight deadline <2 minggu |
| **Standard (Recommended)** | **3-5 hari** | IDEA_BRIEF.md full (3-Filter + Feasibility + Scale + Risk Register 7-10 risks + Now/Next/Later Roadmap + Success Metrics), skip Backlog/OKR detail | B2B SaaS client work, funded startup, timeline 3+ bulan |
| **Enterprise (Formal)** | **1-2 minggu** | IDEA_BRIEF.md + Business Case formal (TAM/SAM/SOM, ROI calculation, Stakeholder Map, OKR Cascade, Risk Register 15+ risks dengan mitigation plan detail, Gantt chart timeline) | Enterprise client RFP, investor pitch deck preparation, board approval |

**Breakdown Standard (3-5 hari):**
- Day 1: 3-Filter Triage (Problem Statement, Core User Loop, MVP Razor) + Draft Feasibility Scorecard → 6-8 jam
- Day 2: Deep-dive Feasibility 4 dimensi (research tech stack, check regulatory, estimate timeline, validate WTP hypothesis) → 6-8 jam
- Day 3: Scale Triage + Risk Register (identify 7-10 risks, prioritize by likelihood×impact, draft mitigation) → 6-8 jam
- Day 4: Now/Next/Later Roadmap (breakdown fitur ke 3 bucket, estimasi timeline per bucket) → 4-6 jam
- Day 5: Success Metrics + Polish IDEA_BRIEF.md (KPI definition, format check, review) → 4-6 jam

**Total**: 26-36 jam → realistic untuk part-time 20h/week (1.5 minggu) atau full-time 40h/week (4-5 hari kerja).

---

## 2. Scope Refinement (What Belongs in Modul 01 vs Modul 02)

### 2.1 Current Problem (Scope Too Heavy)

Modul 01 saat ini include:
- ✅ **Core (Should Stay)**: 3-Filter Triage, Feasibility 4 dimensi, Scale Triage, Risk Register basic
- ⚠️ **Overlap Modul 02 (Should Move)**: Detailed Roadmap (Now/Next/Later dengan estimasi minggu-minggu), Backlog Management (Epic/Story/Task breakdown), OKR Framework (Quarterly OKR + KR breakdown), Resource Allocation (70-20-10 time budget, skill gap analysis)

**Issue**: Modul 01 jadi 5-10 hari kerja (terlalu lama untuk "feasibility check"). Seharusnya Modul 01 = **lightweight gate** (3-5 hari), Modul 02 = **detailed planning** (1-2 minggu).

### 2.2 Recommended Scope Split

**Modul 01 (Idea & Feasibility) - Keep:**
1. ✅ 3-Filter Triage (Problem Statement, Core User Loop, MVP Razor)
2. ✅ Feasibility Scorecard 4 dimensi (Teknis, Bandwidth, Regulasi, Komersial) dengan skor 1-5
3. ✅ Scale Triage (Kecil/Menengah/Besar/Enterprise classification)
4. ✅ Risk Register basic (Top 5-7 risks dengan likelihood×impact, mitigation 1-liner)
5. ✅ Success Metrics high-level (3-6 KPI untuk MVP launch, 3-month, 6-month)
6. ✅ Now/Next/Later Roadmap (fitur breakdown ke 3 bucket, NO timeline detail per fitur)

**Modul 02 (Discovery & Scope) - Move Here:**
1. ➡️ Detailed Roadmap dengan Timeline (Week-by-week breakdown, dependency mapping, Gantt chart)
2. ➡️ Backlog Management (Epic→Story→Task hierarchy, Story Points estimation, RICE prioritization)
3. ➡️ OKR Framework (Quarterly OKR, KR breakdown, OKR Cascade Company→Product→Feature)
4. ➡️ Resource Allocation (70-20-10 time budget per Epic, Skill gap analysis, External dependency tracking)
5. ➡️ Risk Register detail (15+ risks, mitigation plan multi-step, contingency plan, monitoring cadence)

**Rationale**: Modul 01 answer "Should we build this?" (GO/PIVOT/KILL decision). Modul 02 answer "How do we build this?" (detailed planning execution).

---

## 3. Gate FAIL Protocol (What If Feasibility Score <14/20)

### 3.1 Current Gap

Modul 01 hanya define:
- ✅ Aggregate threshold: Total ≥14/20 (rata-rata 3.5/dimensi) = PASS
- ❌ Tidak ada guidance apa yang harus dilakukan jika score <14/20 (FAIL)

### 3.2 Gate Decision Matrix

| Feasibility Score | Gate Decision | Action Required |
| :--- | :--- | :--- |
| **≥17/20** | **STRONG GO** | Low-risk, proceed dengan timeline normal. No additional mitigation required. |
| **14-16/20** | **CONDITIONAL GO** | Moderate-risk, proceed tapi tambah buffer 30-50% timeline + mitigation plan untuk dimensi yang score <4. Review weekly. |
| **10-13/20** | **PIVOT REQUIRED** | High-risk, DO NOT proceed as-is. Options: Simplify scope, change tech stack, target niche market, defer 3-6 bulan. Re-evaluate setelah pivot. |
| **<10/20** | **KILL** | Project not feasible untuk solo dev/small team. Sunk cost <1 minggu riset = acceptable loss. Consider partnership atau stop completely. |

### 3.3 PIVOT Options (Score 10-13/20)

Jika Feasibility FAIL karena 1-2 dimensi low score, consider pivot:

**Pivot 1: Simplify Scope**
- Original: B2B SaaS multi-tenant dengan 10 fitur
- Pivot: B2C single-user tool dengan 3 fitur core
- Impact: Teknis 2→4 (less complex), Bandwidth 2→4 (faster MVP)

**Pivot 2: Change Tech Stack**
- Original: Custom backend Golang + React Native mobile app
- Pivot: No-code/low-code (Bubble.io, Webflow + Airtable, Supabase)
- Impact: Teknis 2→4 (mature platform), Bandwidth 2→4 (faster development)

**Pivot 3: Target Niche Market**
- Original: Tax software untuk semua freelancer Indonesia (3.7 juta TAM)
- Pivot: Tax software untuk freelancer developer only (500k TAM, less regulation complexity)
- Impact: Komersial 2→4 (niche WTP higher), Regulasi 3→5 (less edge case)

**Pivot 4: Defer Timeline**
- Original: Launch dalam 3 bulan
- Pivot: Launch dalam 6-9 bulan (acquire skill, build team, save budget)
- Impact: Bandwidth 2→4 (more realistic timeline), Teknis 2→3 (time untuk learning)

**Pivot 5: Find Co-Founder / Partner**
- Original: Solo dev (backend strong, design weak)
- Pivot: Solo dev + designer co-founder (equity split 70/30)
- Impact: Bandwidth 2→4 (shared workload), Teknis 3→5 (complementary skill)

### 3.4 KILL Criteria (Stop Project)

**Hard Stop jika:**
- ❌ Regulasi score 1-2 (butuh license OJK/Kominfo yang gak feasible solo dev, contoh: payment gateway, telemedicine)
- ❌ Teknis score 1 (butuh R&D berat >6 bulan, contoh: computer vision from scratch, custom blockchain)
- ❌ Komersial score 1 (WTP $0, market size <1,000 users, competitor dominan 90% market share)
- ❌ Total score <10/20 dengan NO pivot options (semua dimensi low, gak ada lever yang bisa di-improve)

**Soft Stop (Defer) jika:**
- ⚠️ Bandwidth score 2 + Solo dev burnout risk high → Defer 3-6 bulan, cari co-founder atau rest dulu
- ⚠️ Komersial score 2 + Zero budget untuk marketing → Defer sampai ada runway Rp 10-50 juta

---

## 4. Feasibility Scoring Rubric Detail (5/4/3/2/1 per Dimensi)

### 4.1 Current Gap

Modul 01 hanya kasih pertanyaan high-level per dimensi:
- "Apakah pustaka, SDK, dan API yang dibutuhkan sudah matang?" → Terlalu luas, sulit score 1-5

### 4.2 Scoring Rubric Expanded

#### Dimensi 1: Kelayakan Teknis

| Skor | Criteria | Example |
| :---: | :--- | :--- |
| **5** | API/SDK stable v1.0+, docs lengkap (API reference + tutorials + examples), community 10k+ users (Stack Overflow, Discord, GitHub), last commit <1 bulan, zero breaking changes dalam 12 bulan terakhir | Next.js, React, Supabase, Stripe |
| **4** | API/SDK v0.8-0.9 (near-stable), docs ada (API reference + quickstart), community 1k-10k users, last commit <6 bulan, minor breaking changes (migration guide tersedia) | Remix, Prisma, Railway |
| **3** | API/SDK beta (v0.5-0.7), docs partial (API reference only, no tutorial), community 100-1k users, last commit <1 tahun, moderate breaking changes (migration manual) | Astro (early 2023), Solid.js |
| **2** | API/SDK alpha (v0.1-0.4), docs minimal (README only), community <100 users, last commit >1 tahun atau maintenance inconsistent, frequent breaking changes | Experimental frameworks, indie tools |
| **1** | No API/SDK available, harus build from scratch, no reference implementation, no community support, pure R&D (6+ bulan research) | Custom computer vision model, blockchain dari nol |

#### Dimensi 2: Kelayakan Bandwidth (Solo Dev)

| Skor | Criteria | Example |
| :---: | :--- | :--- |
| **5** | MVP bisa selesai <4 minggu full-time (160 jam), maintenance <2 jam/minggu, single-person operation sustainable, no on-call 24/7 | Landing page + Waitlist form, Simple CRUD tool, Notion/Airtable automation |
| **4** | MVP 4-12 minggu (1-3 bulan), maintenance 2-5 jam/minggu, solo dev feasible dengan work-life balance, occasional monitoring (1-2× per hari cek logs) | SaaS kalkulator (FreePajak), Inventory management, CRM sederhana |
| **3** | MVP 3-6 bulan, maintenance 5-10 jam/minggu, solo dev butuh buffer 30-50% timeline, daily monitoring required (error tracking, uptime check) | Multi-tenant SaaS, Marketplace 2-sided, Payment processing integration |
| **2** | MVP 6-12 bulan, maintenance >10 jam/minggu, solo dev high burnout risk, on-call kadang-kadang (1-2× per bulan incident), butuh team 2-3 orang ideal | Real-time collaboration app, High-traffic platform, Complex workflow automation |
| **1** | MVP >12 bulan, maintenance 24/7 on-call, IMPOSSIBLE untuk solo dev (butuh team 5+ orang), critical uptime SLA 99.99% | Banking core system, Hospital EMR, Stock trading platform |

#### Dimensi 3: Kelayakan Regulasi & Legal

| Skor | Criteria | Example |
| :---: | :--- | :--- |
| **5** | No regulatory blocker, tidak handle data pribadi sensitif, disclaimer cukup (bukan licensed profession), UU PDP compliance basic (Privacy Policy + consent checkbox) | Portfolio website, Blog, Productivity tool (to-do list, note-taking) |
| **4** | Handle data pribadi non-sensitif (email, nama, phone), UU PDP compliance (Privacy Policy + Terms + consent + Delete Account), disclaimer "bukan nasihat profesional" eksplisit | SaaS B2B, CRM, Marketing automation, Tax calculator (estimasi, bukan tax filing resmi) |
| **3** | Handle data sensitif (NPWP, KTP, health data, financial data), UU PDP compliance strict (encryption, audit log, data breach notification), butuh legal review lawyer Rp 5-10 juta | Fintech (bukan payment gateway), Healthtech (bukan telemedicine), Edtech (bukan formal education) |
| **2** | Butuh izin/license non-critical (bisa di-apply online, approval <3 bulan, cost <Rp 10 juta), contoh: PMSE Kominfo untuk e-commerce, PIRT untuk F&B home industry | E-commerce (Tokopedia-like), F&B delivery app, Travel booking platform |
| **1** | Butuh izin/license CRITICAL (approval >6 bulan, cost >Rp 50 juta, audit annual, partnership dengan licensed entity mandatory), contoh: OJK untuk payment gateway/P2P lending, Kemenkes untuk telemedicine/alkes, BI untuk e-money | Payment gateway, P2P Lending, Telemedicine, E-Money/E-Wallet |

#### Dimensi 4: Kelayakan Komersial (Willingness to Pay / ROI)

| Skor | Criteria | Example |
| :---: | :--- | :--- |
| **5** | Strong WTP validated (survey 50+ responden, 40%+ intent-to-buy "Pasti beli"), ROI jelas untuk user (save 10+ jam/bulan atau Rp 5+ juta/tahun), competitor pricing Rp 50k-500k/bulan (market educated) | B2B SaaS (CRM, Accounting, HR), Developer tools (paid API, monitoring) |
| **4** | Moderate WTP validated (survey 30+ responden, 30-40% intent-to-buy), ROI medium (save 5 jam/bulan atau Rp 1-5 juta/tahun), freemium model dengan conversion benchmark 3-5% | Productivity SaaS (project management, collaboration), Content creation tools |
| **3** | Weak WTP (survey <30 responden atau 20-30% intent-to-buy), ROI soft (convenience, tidak direct monetary saving), market belum educated (butuh heavy marketing) | Consumer app (lifestyle, entertainment), Niche B2C tool |
| **2** | Unclear WTP (no validation, assumption only), monetization belum clear (ads? affiliate? donation?), market size <10k users, competitor mostly free | Indie hacker side project, Experimental app, Community-driven tool |
| **1** | Zero WTP (user expect gratis forever), no monetization path, pure "nice to have" (bukan "must have"), market <1k users, competitor dominant free | Personal blog, Open-source library (no sponsorship), Hobby project |

---

## 5. Scale Triage Boundary Clarification

### 5.1 Current Ambiguity

Modul 01 state:
- Menengah: 1-3 bulan (exclusive range: ≥1 bulan dan <3 bulan)
- Besar: ≥3 bulan dan <6 bulan (exclusive range)

**Issue**: Project tepat 3 bulan masuk mana? Menengah atau Besar?

### 5.2 Clarified Boundary

| Skala | Timeline (Minggu) | Timeline (Bulan) | Entities | Team Size | Indikator Lain |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Kecil** | <4 minggu | <1 bulan | 1-2 entitas data | Solo dev (1 orang) | No payment, no multi-tenant, no RBAC |
| **Menengah** | 4-12 minggu | 1-3 bulan | 3-6 entitas data | Solo dev atau 2 orang | Freemium/payment, multi-tenant, RBAC basic, 1-3 API integration |
| **Besar** | 12-24 minggu | 3-6 bulan | 7-15 entitas data | Team 3-5 orang | High concurrency, multi-sistem integration, advanced RBAC, 5+ API |
| **Enterprise** | >24 minggu | >6 bulan | 15+ entitas data | Team 5+ orang | ISO 27001/SOC2, audit trail, SLA 99.9%, compliance strict |

**Decision Rule**:
- Project 12 minggu (3 bulan tepat) → Masuk **Menengah** (boundary upper limit)
- Project 24 minggu (6 bulan tepat) → Masuk **Besar** (boundary upper limit)

---

## 6. Pre-Modul 01 Checklist (Idea Validation Gate)

### 6.1 Problem Statement

**Issue**: Tidak semua "ide" siap masuk Modul 01 (waste 3-5 hari untuk ide yang belum mature).

### 6.2 Pre-Flight Checklist

**Before starting Modul 01 (invest 3-5 hari), validate:**

- [ ] **Ide bukan "solution looking for problem"**  
  → Ada problem statement jelas (bukan "aku mau bikin app X keren" tapi "freelancer Indonesia struggle dengan Y")

- [ ] **Target user identified & reachable**  
  → Bukan "semua orang" atau "anyone who needs X"  
  → Specific: "Freelancer developer Indonesia, omzet Rp 10-30 juta/bulan, umur 25-35 tahun, lokasi Jakarta/Bandung/Surabaya"

- [ ] **Existing workaround exist (proof problem is real)**  
  → User pakai apa sekarang? Manual Excel? Google Sheets? Competitor app? Jasa konsultan?  
  → Kalau user TIDAK pakai workaround sama sekali → problem mungkin tidak cukup painful

- [ ] **Willingness to pay hypothesis (monetization clarity)**  
  → Gratis forever (ads/affiliate)? Freemium (free tier + paid Rp 50k/bulan)? Paid upfront (Rp 500k one-time)?  
  → Kalau gak ada monetization hypothesis → risk komersial score 1-2

**If NO to ≥2 checklist above:**

→ **Spend 1-2 hari riset dulu** (Google Trends, Reddit, Twitter/X search, user interview 3-5 orang informal) sebelum masuk Modul 01.

**Tools untuk Quick Validation (1-2 hari):**
- **Google Trends**: Cek search volume keyword problem (trending up/down/flat?)
- **Reddit/Kaskus**: Search subreddit/forum, ada thread complaint tentang problem ini?
- **Twitter/X Advanced Search**: `"[problem keyword]" lang:id` → ada orang nge-tweet struggle dengan problem ini?
- **Facebook Group**: Join group target user (contoh: "Freelancer Indonesia"), baca post 1-2 minggu terakhir, ada yang mention problem?
- **Cold DM 3-5 user**: DM ke target user di LinkedIn/Instagram, tanya "Apakah kamu pernah struggle dengan [problem]? Boleh chat 10 menit?" (no incentive, cuma validasi cepat)

**Gate Pass Criteria:**
- ✅ Min 3/4 checklist terpenuhi → Proceed ke Modul 01
- ❌ <3/4 checklist → Riset 1-2 hari dulu, re-check, baru masuk Modul 01

---

## 7. Risk Appetite Threshold (How Much Risk is Acceptable?)

### 7.1 Current Gap

Modul 01 ada Risk Assessment Matrix (Likelihood × Impact → Score 1-9), tapi tidak ada guidance "berapa total risk score yang acceptable?"

### 7.2 Risk Appetite per Project Type

| Project Type | Max Acceptable Total Risk Score | Max Acceptable Single Risk Score | Mitigation Required |
| :--- | :---: | :---: | :--- |
| **Solo Dev Product (Portfolio)** | ≤30 | ≤6 | Mitigation untuk risk score ≥6 (top 3-5 risks). Accept risk score 4-5 dengan monitor quarterly. |
| **B2B SaaS Client Work** | ≤20 | ≤4 | Mitigation untuk risk score ≥4 (semua medium-high risks). Monthly review. Contingency plan untuk top 3 risks. |
| **Enterprise Client** | ≤10 | ≤3 | Mitigation untuk SEMUA risks (even score 2-3). Weekly review. Contingency + escalation protocol untuk semua risks. |

**Formula**:
```
Total Risk Score = Σ (Likelihood × Impact) for all identified risks

Example (Solo Dev, 7 risks):
Risk 1: L=3 × I=3 = 9 (Urgent mitigation)
Risk 2: L=2 × I=3 = 6 (Mitigation required)
Risk 3: L=2 × I=2 = 4 (Monitor)
Risk 4: L=2 × I=1 = 2 (Accept)
Risk 5: L=1 × I=3 = 3 (Monitor)
Risk 6: L=1 × I=2 = 2 (Accept)
Risk 7: L=1 × I=1 = 1 (Accept)

Total = 9+6+4+2+3+2+1 = 27 (PASS, <30 threshold)
```

### 7.3 Risk Score Interpretation

| Total Score | Verdict | Action |
| :--- | :--- | :--- |
| **≤10** | **Very Low Risk** | Proceed dengan confidence tinggi. Minimal monitoring (monthly review cukup). |
| **11-20** | **Low Risk** | Proceed. Fokus mitigation pada top 3 risks (score ≥6). Weekly/bi-weekly review. |
| **21-30** | **Moderate Risk** | Proceed dengan caution. Mitigation plan detail untuk top 5 risks. Tambah buffer 30% timeline. Weekly review mandatory. |
| **31-40** | **High Risk** | CONDITIONAL GO. Mitigation plan + contingency untuk top 7 risks. Tambah buffer 50% timeline. Consider pivot atau defer. |
| **>40** | **Very High Risk** | STOP atau PIVOT. Risk terlalu tinggi untuk solo dev/small team. Re-evaluate scope, tech stack, atau target market. |

---

## 8. Additional Improvements (Should-Have, Not Critical)

### 8.1 Kano Model (Feature Prioritization for MVP Razor)

**Use Case**: Classify fitur ke 3 kategori untuk decide MVP scope.

| Kategori | Definisi | MVP Decision | Example |
| :--- | :--- | :--- | :--- |
| **Must-Be (Basic)** | Jika tidak ada, user langsung abandon. Presence = neutral, Absence = sangat negative. | **MUST include di MVP** | Login, Save data, Core calculation |
| **Performance (Linear)** | Semakin baik, semakin tinggi satisfaction. Linear relationship. | **Include 1-2 core Performance** | Speed (<2s load), Accuracy (95%+), Ease of use |
| **Delighter (Exciting)** | Unexpected feature, bikin "wow". Presence = sangat positive, Absence = neutral (user gak expect). | **SKIP di MVP, add v1.1** | AI suggestion, Dark mode, Gamification |

**MVP Razor Formula**: Must-Be (all) + Performance (1-2 core) + Delighter (0)

### 8.2 Prioritization Framework Comparison

| Framework | Best For | Pros | Cons |
| :--- | :--- | :--- | :--- |
| **RICE** | B2B SaaS, data-driven team | Quantitative, objective, force trade-off clarity | Butuh data (Reach, Impact, Confidence), time-consuming |
| **MoSCoW** | Fixed-scope project, waterfall | Simple, stakeholder-friendly, visual clear | Subjective (semua fitur jadi "Must-Have"), no trade-off clarity |
| **ICE** | Startup MVP, quick & dirty | Fast (3 inputs: Impact/Confidence/Ease), actionable | Less rigorous than RICE, subjective scoring |
| **WSJF** | SAFe/Agile enterprise | Cost of Delay focus, align dengan business priority | Complex (butuh training SAFe), overkill untuk solo dev |
| **Value vs Effort (2×2)** | Visual prioritization, workshop | Intuitive, stakeholder workshop-friendly, quick | Subjective placement, no formula quantitative |

**Recommendation**: 
- Solo dev MVP → ICE (fast)
- B2B SaaS client → RICE (rigorous)
- Stakeholder workshop → Value vs Effort 2×2 (visual)

### 8.3 OKR Cascade Example (Company → Product → Feature)

```
Company OKR (Q1 2027): "Achieve $1M ARR by end of Q1"
  │
  ├─ Sales OKR: "Close 50 enterprise deals ($20k ACV each)"
  │
  └─ Product OKR: "Increase active users 50k → 100k by Q1"
       │
       ├─ Feature OKR (Onboarding): "Activation rate 20% → 40% (2× improvement)"
       │   ├─ KR1: 80% new users complete onboarding wizard (vs 40% current)
       │   ├─ KR2: Time-to-first-value <10 min (vs 30 min current)
       │   └─ KR3: D1 retention 50% → 70%
       │
       ├─ Feature OKR (Retention): "D30 retention 30% → 50%"
       │   ├─ KR1: Weekly active usage 2× → 3× per week
       │   ├─ KR2: Feature adoption (use 3+ features) 30% → 50%
       │   └─ KR3: NPS score 30 → 50
       │
       └─ Feature OKR (Referral): "Viral coefficient 0.3 → 0.7"
           ├─ KR1: 20% users invite ≥1 friend (vs 5% current)
           ├─ KR2: Invite acceptance rate 30% → 50%
           └─ KR3: Referred user activation 40% → 60%
```

---

**Last Updated:** 2026-09-30  
**Changelog:**
- 2026-09-30: Initial improvements based on Modul 01 evaluation (score 3.8/5, CONDITIONAL PASS). Added 7 critical sections: Timeline (1-2 hari fast-track, 3-5 hari standard, 1-2 minggu enterprise), Scope Refinement (move Roadmap/Backlog/OKR detail ke Modul 02), Gate FAIL Protocol (score <14 → PIVOT/DEFER/PARTNER/KILL, 14-16 CONDITIONAL GO, ≥17 STRONG GO), Scoring Rubric Detail (5/4/3/2/1 per dimensi Teknis/Bandwidth/Regulasi/Komersial), Scale Triage Boundary (4/12/24 minggu clarified), Pre-Checklist (4-point validation sebelum invest 3-5 hari Modul 01), Risk Appetite (solo dev ≤30, B2B ≤20, Enterprise ≤10 total risk score). Plus 3 should-have: Kano Model, Prioritization Framework Comparison, OKR Cascade.
