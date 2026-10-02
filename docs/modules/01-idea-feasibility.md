# Modul 01: Idea & Feasibility (Penyaringan Ide & Uji Kelayakan)

> - `references/checklists/MODUL_01_ACTION_ITEMS_CHECKLIST.md` (Post-feasibility action items: Market validation, Formula verification, Security baseline)
> - `references/checklists/FEASIBILITY_CRITERIA.md` (Detailed 4-dimension feasibility rubric)
> - `references/pm/PM_PRIORITIZATION_FRAMEWORKS.md` (RICE scoring formula, reach/impact/confidence rubrics, backlog prioritization worksheet)
>

Modul ini adalah gerbang pertama dalam siklus pengembangan perangkat lunak untuk solo developer. Tujuannya adalah mengubah ide mentah yang abstrak menjadi **Ringkasan Ide Teruji (Validated Idea Brief)** dengan batasan skala yang jelas sebelum waktu terbuang untuk menulis dokumen panjang atau koding.

**Solo Dev Tooling Prerequisites**:
- [ ] Password manager installed (Bitwarden/1Password) for secure credential sharing with clients
- [ ] Git client configured with proper email/name
- [ ] AI coding assistant ready (Cursor/Claude Code/Windsurf) if planning to use AI-assisted development

---

## 1. Siklus Eksekusi Modul 01

```text
[ IDE KASAR / MENTAH ]
          │
          ▼
[ LANGKAH 1: Saringan 3 Lapis (The 3-Filter Triage) ]
  • Masalah Riil & Nilai Unik
  • Core User Loop (Alur Utama Inti)
  • MVP Razor (Pemotongan Fitur Ekstrem)
          │
          ▼
[ LANGKAH 2: Uji 4 Dimensi Kelayakan (Feasibility Check) ]
  • Teknis (Tech Stack & Kesiapan API)
  • Bandwidth Solo Dev (Batas Waktu & Maintenance)
  • Regulasi & Legal (Izin Usaha, UU PDP, Liabilitas)
  • Ekonomi & Nilai Bisnis (Willingness to Pay / ROI)
          │
          ▼
[ LANGKAH 3: Determinasi Skala Proyek (Scale Classification) ]
  • Kecil (MVP / Freelance)
  • Menengah (B2B SaaS / Agensi)
  • Besar (Scale-Up / Multi-System)
  • Enterprise (Korporasi / Regulasi Ketat)
          │
          ▼
[ OUTPUT: Dokumen IDEA_BRIEF.md ] ──► Siap Lanjut ke Modul 02: Discovery & Scope
```

---

## 2. Langkah demi Langkah Eksekusi

### Langkah 1: Saringan 3 Lapis (The 3-Filter Triage)

Lakukan interogasi terarah terhadap ide mentah:

1. **Saringan Masalah (Problem Statement)**:
   - *Pertanyaan*: Siapa yang punya masalah ini, seberapa sering masalah ini terjadi, dan bagaimana mereka mengatasinya sekarang (manual, spreadsheet, jasa orang lain)?
   - *Prinsip*: Jangan membangun software untuk masalah yang cukup diselesaikan dengan Google Sheet atau form sederhana, kecuali ada kebutuhan otomasi/keamanan data khusus.
2. **Saringan Alur Utama (Core User Loop)**:
   - *Pertanyaan*: Apa alur 3 langkah dari interaksi pengguna?
   - *Format Baku*: `[User Input Data] ──► [Sistem Melakukan Proses/Transformasi] ──► [User Menerima Hasil/Value]`.
3. **Saringan Pemotongan Ekstrem (MVP Razor)**:
   - *Pertanyaan*: Jika aplikasi ini hanya boleh memiliki SATU fitur utama saat peluncuran pertama, fitur apa yang membuat pengguna tetap mau memakai aplikasi ini?
   - *Tindakan*: Singkirkan fitur sekunder (social login, dark mode, grafik analitik rumit, integrasi multi-gateway) ke daftar *Backlog Masa Depan*.

---

### Langkah 2: Uji 4 Dimensi Kelayakan (Feasibility Rubric)

Evaluasi kelayakan ide menggunakan skor 1–5 pada 4 dimensi:

| Dimensi Kelayakan | Pertanyaan Uji Kritis Solo Dev | Batas Minimum Lolos |
| :--- | :--- | :--- |
| **1. Kelayakan Teknis** | Apakah pustaka, SDK, dan API yang dibutuhkan sudah matang dan terdokumentasi? Apakah membutuhkan riset R&D komputasi berat? | Skor ≥3 (Jika butuh R&D berat sendirian, simplifikasi ide) |
| **2. Kelayakan Bandwidth** | Apakah aplikasi bisa diselesaikan dalam rentang waktu solo dev (maks. 1–3 bulan untuk rilis pertama)? Apakah biaya operasional hariannya rendah? | Skor ≥4 (Hindari arsitektur multi-service yang butuh on-call 24/7) |
| **3. Kelayakan Regulasi & Legal** | Apakah pengoperasian sistem melanggar hukum, membutuhkan izin khusus (OJK, Kominfo, Kemenkes), atau memegang data pribadi sensitif (UU PDP)? | Skor ≥4 (Jika ada risiko pidana/denda tanpa modal hukum, pivot/scope down) |
| **4. Kelayakan Komersial** | Apakah ada pihak yang bersedia membayar untuk sistem ini (B2B/B2C)? Jika pesanan klien, apakah budget realistis terhadap effort? | Skor ≥3 (Harus ada kejelasan sumber pendapatan atau margin yang layak) |

**Aggregate Threshold**: Total skor ≥14/20 (rata-rata 3.5 per dimensi). Proyek dengan total < 14 wajib disederhanakan atau ditolak.

*Lihat panduan lengkap di: `references/checklists/FEASIBILITY_CRITERIA.md`.*

---

### Langkah 3: Klasifikasi Skala Proyek (Scale Triage)

Tentukan kategori proyek sejak awal untuk menentukan seberapa berat formalitas dokumen berikutnya:

1. **Skala Kecil (MVP / Freelance Tool)**:
   - *Indikator*: Pengguna tunggal/tim kecil, 1–2 entitas data, waktu kerja < 1 bulan, tanpa integrasi sistem perbankan/regulasi.
   - *Arah Lanjutan*: Langsung susun 1-page Brief & Scope Statement sederhana, lewati charter formal.
   - **Fast-Track**: Jika feasibility ≥ 17/20 dan risk rendah, boleh skip M03 charter (langsung M04 design).
2. **Skala Menengah (B2B SaaS / Agensi)**:
   - *Indikator*: Multi-tenant, ada pembayaran berlangganan, autentikasi berbasis peran (RBAC), integrasi 1–3 API pihak ketiga, waktu kerja 1–3 bulan (exclusive range: ≥1 bulan dan <3 bulan).
   - *Arah Lanjutan*: Wajib menyusun PRD ringan, kontrak SOW resmi, dan arsitektur database modular.
3. **Skala Besar (Scale-Up / Platform Terdistribusi)**:
   - *Indikator*: Volume transaksi tinggi, concurrency tinggi, integrasi multi-sistem perusahaan, waktu kerja ≥3 bulan dan <6 bulan (exclusive range).
   - *Arah Lanjutan*: Wajib menyusun Project Charter, PRD formal, FSD mendalam, dan WBS terperinci.
4. **Skala Enterprise / Industri (Korporasi, Perbankan, BUMN)**:
   - *Indikator*: Kepatuhan regulasi ketat (UU PDP, ISO 27001, SOC2), multi-stakeholder internal klien, audit trail permanen, SLA uptime 99.9%, waktu kerja ≥6 bulan.
   - *Arah Lanjutan*: Wajib ada persetujuan formal legal, Project Charter bertandatangan, Single PIC terikat, FSD lengkap, dan RTM.

---

## 3. Artefak Keluaran (Deliverable)

Hasil akhir dari Modul 01 adalah berkas **`docs/pm/IDEA_BRIEF.md`** yang dibuat menggunakan template di `templates/01-discovery-commercial/IDEA_BRIEF_TEMPLATE.md`.

> 📁 **ATURAN LOKASI BERKAS MUTLAK**:
> Berkas ini WAJIB disimpan di dalam folder **`docs/pm/`** (bukan di root direktori).
> Root direktori `./` dicadangkan secara eksklusif hanya untuk 7 berkas kendali AI (Agent Harness) saat Modul 06 dimulai.

---

## 4. Product Roadmap (Peta Jalan Produk)

Setelah ide lolos uji kelayakan, susun peta jalan yang memberikan visibilitas timeline dan prioritas eksekusi:

### 4.1 Framework Now/Next/Later

- **Now (0–1 bulan)**: Fitur inti MVP yang HARUS ada untuk peluncuran pertama (Core User Loop)
- **Next (1–3 bulan)**: Fitur pendukung yang meningkatkan retention/revenue (contoh: notifikasi, integrasi pembayaran)
- **Later (3–6 bulan+)**: Nice-to-have features & eksperimen (contoh: dark mode, advanced analytics, AI features)

### 4.2 Timeline Estimation & Dependency Mapping

- Gunakan T-shirt sizing (XS/S/M/L/XL) atau story points untuk estimasi relatif
- Identifikasi dependensi kritis: Feature B tidak bisa dimulai sebelum Feature A selesai
- Tandai external dependencies (API vendor, third-party approval) dengan flag risiko tinggi

### 4.3 Release Milestones

| Milestone | Target | Core Deliverables | Exit Criteria |
| :--- | :--- | :--- | :--- |
| **M0: Technical Spike** | Week 1 | Proof of concept core algorithm/integration | Can demo the hardest technical risk |
| **M1: Alpha (Internal)** | Week 4 | Core user loop works end-to-end | Solo dev can complete full workflow |
| **M2: Beta (Closed)** | Week 8 | 3–5 real users testing | At least 2 users complete workflow without help |
| **M3: Public Launch** | Week 12 | Production-ready with docs | Ready for public traffic & payments |

### 4.4 Roadmap Tools Setup

- **Notion**: Template database dengan status (Now/Next/Later/Done), owner, dependencies, effort
- **Linear**: Roadmap view dengan cycles (sprint), project milestones, dan automated triage
- **Productboard**: Feature scoring (RICE), user feedback aggregation, roadmap visualization

*Panduan setup lengkap: `references/pm/PM_TOOLS_SETUP_GUIDE.md`*

---

## 5. Backlog Management (Pengelolaan Daftar Kerja)

Breakdown dari roadmap ke unit eksekusi yang actionable:

### 5.1 Hierarchy: Epic → Story → Task

- **Epic**: Fitur besar yang butuh 2–4 minggu (contoh: "User Authentication System")
- **Story**: Unit kerja 1–3 hari yang memberikan value (contoh: "As a user, I want to login with email so I can access my account")
- **Task**: Implementasi teknis sub-bagian story (contoh: "Create POST /api/auth/login endpoint", "Hash password with bcrypt")

### 5.2 User Story Format (Standar Industri)

```
As a [persona/role],
I want to [action/capability],
So that [business value/outcome].

Acceptance Criteria:
- [ ] Given [context], when [action], then [expected result]
- [ ] Given [context], when [action], then [expected result]
- [ ] Edge case: [negative case handling]
```

### 5.3 Story Point Estimation (Fibonacci Scale)

- **1 point**: Trivial change (rename variable, update copy text) — 15 min
- **2 points**: Simple CRUD API or UI component — 1–2 hours
- **3 points**: Standard feature dengan business logic sederhana — half day
- **5 points**: Complex feature dengan integration — 1 day
- **8 points**: Very complex, needs design discussion — 2–3 days
- **13 points**: Epic-level, harus dipecah lebih kecil

*Jika story > 8 points, WAJIB breakdown menjadi sub-stories.*

### 5.4 Backlog Prioritization (RICE Score)

Formula: **RICE Score = (Reach × Impact × Confidence) / Effort**

- **Reach**: Jumlah user yang terpengaruh per periode (contoh: 100 users/month)
- **Impact**: Skala dampak (Massive=3, High=2, Medium=1, Low=0.5, Minimal=0.25)
- **Confidence**: Tingkat keyakinan data (High=100%, Medium=80%, Low=50%)
- **Effort**: Person-months untuk complete (contoh: 0.5 = 2 minggu solo dev)

Contoh:
- Story A: (500 × 3 × 1.0) / 0.5 = **3000** (prioritas tertinggi)
- Story B: (50 × 2 × 0.8) / 2.0 = **40** (prioritas rendah)

*Worksheet lengkap: `references/pm/PM_PRIORITIZATION_FRAMEWORKS.md`*

### 5.5 Jira/Linear Project Setup

- **Jira**: Epic → Story → Subtask hierarchy, Custom fields (RICE score), Automation rules (auto-assign, status sync)
- **Linear**: Project → Issue → Sub-issue, Labels (#now #next #later), Cycles (sprint), Triage view

*Setup guide step-by-step: `references/pm/PM_TOOLS_SETUP_GUIDE.md`*

*Template backlog: `templates/01-discovery-commercial/BACKLOG_TEMPLATE.md`*

---

## 6. OKR/KPI Framework (Kerangka Metrik & Target)

Tetapkan target terukur untuk align eksekusi dengan goals bisnis:

### 6.1 Quarterly OKR Template

**Objective** (Qualitative goal, inspiring): *"Launch MVP and validate product-market fit"*

**Key Results** (Quantitative, measurable, time-bound):
1. KR1: Acquire 50 beta users by end of Q1
2. KR2: Achieve 40% weekly active user (WAU) retention by week 8
3. KR3: Collect 20 user feedback sessions with actionable insights

### 6.2 Key Results Measurable Criteria

Setiap KR HARUS memiliki:
- **Baseline**: Nilai awal (contoh: 0 users saat ini)
- **Target**: Nilai yang ingin dicapai (contoh: 50 users)
- **Metric Definition**: Cara mengukur (contoh: "Unique users yang complete signup flow")
- **Data Source**: Dari mana data diambil (contoh: "PostgreSQL users table, status='active'")

### 6.3 KPI Dashboard Design

**Kategori Metrik**:
- **Acquisition**: Signups/week, conversion rate landing → signup
- **Activation**: % users yang complete onboarding dalam 24 jam
- **Retention**: D1/D7/D30 retention rate, weekly active users (WAU)
- **Revenue** (jika applicable): MRR (Monthly Recurring Revenue), ARPU (Average Revenue Per User)
- **Technical Health**: API p95 latency, error rate, uptime %

**Tools**: Metabase/Superset (self-hosted), Mixpanel/Amplitude (SaaS), atau custom dashboard dengan Grafana + PostgreSQL

### 6.4 Metric Ownership (RACI Matrix)

| Metrik | Responsible | Accountable | Consulted | Informed |
| :--- | :--- | :--- | :--- | :--- |
| Weekly signups | Developer (track code) | PM/Founder (target) | Marketing | Investors |
| API uptime | Developer (monitor) | Developer (fix) | — | Users (status page) |
| User retention | PM/Founder (analyze) | PM/Founder (decide) | Developer (impl) | Team |

*Template OKR lengkap: `templates/01-discovery-commercial/OKR_TEMPLATE.md`*

---

## 7. Risk Register (Daftar Risiko Komprehensif)

Antisipasi risiko sejak awal untuk mengurangi firefighting:

### 7.1 Risk Identification Workshop

**5 Kategori Risiko**:
1. **Technical**: API vendor deprecated, scaling bottleneck, tech debt
2. **Resource**: Solo dev sakit/burnout, skill gap (contoh: tidak bisa infrastruktur)
3. **Market**: Competitor launch similar product, user adoption rendah
4. **Legal/Compliance**: Pelanggaran UU PDP, vendor ToS berubah
5. **Financial**: Budget overrun, revenue tidak sesuai proyeksi

### 7.2 Risk Assessment Matrix (Likelihood × Impact)

| Likelihood | Impact Low (1) | Impact Medium (2) | Impact High (3) |
| :--- | :---: | :---: | :---: |
| **High (3)** | 3 (Monitor) | 6 (Mitigate) | **9 (Urgent)** |
| **Medium (2)** | 2 (Accept) | 4 (Monitor) | 6 (Mitigate) |
| **Low (1)** | 1 (Accept) | 2 (Accept) | 3 (Monitor) |

**Action Threshold**:
- Score 7–9: Wajib mitigation plan SEBELUM mulai development
- Score 4–6: Monitor aktif, siapkan contingency plan
- Score 1–3: Accept risk, review quarterly

### 7.3 Mitigation Strategies Per Risk

Contoh:
- **Risk**: "Main payment gateway (Midtrans) API down during launch" (Likelihood=2, Impact=3, Score=6)
  - **Mitigation**: Integrate backup gateway (Xendit) di week 6, test failover logic
  - **Contingency**: Manual payment confirmation via bank transfer jika kedua gateway down
  - **Owner**: Developer
  - **Review Date**: 2 weeks before launch

### 7.4 Monitoring Cadence & Escalation Protocol

- **Weekly**: Review top 3 risks (score ≥6) dalam standup/weekly review
- **Monthly**: Re-assess likelihood & impact semua risks, update mitigation status
- **Escalation**: Jika risk score naik dari 4 → 7+, trigger emergency planning session

*Template risk register: `templates/01-discovery-commercial/RISK_REGISTER_TEMPLATE.md`*

---

## 8. Resource Allocation (Alokasi Sumber Daya)

Mapping effort realistis untuk solo dev atau small team:

### 8.1 Time Budget Per Epic

Gunakan rule **70-20-10**:
- **70%**: Development (coding, testing, deployment)
- **20%**: Planning & design (architecture, mockups, PRD)
- **10%**: Buffer untuk unexpected issues (bug fixes, vendor downtime)

Contoh: Epic "User Auth System" = 2 minggu total
- Development: 7 days (coding auth flow, testing, deploy)
- Planning: 2 days (design DB schema, security review, API contract)
- Buffer: 1 day (handle edge cases, fix integration bugs)

### 8.2 Skill Gap Analysis

Identifikasi keahlian yang BELUM dimiliki tapi DIBUTUHKAN proyek:

| Skill Required | Current Level | Target Level | Learning Path | Time Investment |
| :--- | :--- | :--- | :--- | :--- |
| React Server Components | Beginner | Intermediate | Official docs + 2 tutorials | 2 days |
| Stripe webhook security | None | Proficient | Stripe docs + test with CLI | 1 day |
| AWS CDK infra-as-code | None | Basic | CDK workshop + deploy 1 stack | 3 days |

**Decision Point**: Jika total learning time > 20% project timeline, pertimbangkan:
- Simplify tech stack (gunakan yang sudah dikuasai)
- Hire freelancer untuk specific task
- Extend timeline untuk accommodate learning

### 8.3 External Dependency Tracking

| Dependency | Type | Status | Risk | Contact/Docs | Mitigation |
| :--- | :--- | :--- | :--- | :--- | :--- |
| WhatsApp Business API approval | Vendor | Pending | High | Meta Business Support | Fallback: Email notifications |
| SSL cert for custom domain | Infrastructure | Not started | Low | Let's Encrypt docs | Auto-renew with Certbot |
| Client design assets (logo, color) | Stakeholder | Waiting | Medium | client@email.com | Use placeholder, finalize week 2 |

**Tracking Cadence**: Update status setiap 2–3 hari untuk dependencies dengan risk High/Medium.

---

## 🛑 PROTOKOL [GATE] KELUAR & WAJIB BERHENTI

Setelah berkas `docs/pm/IDEA_BRIEF.md` selesai ditulis:
1. **DILARANG KERAS langsung melanjutkan atau memanggil tool untuk Modul 02 dalam giliran (turn) yang sama!**
2. **VERIFIKASI DIRI (Self-Verification Checklist)**:
   - [ ] `read_file('docs/pm/IDEA_BRIEF.md')` → Confirm file exists, 80+ lines
   - [ ] Feasibility score calculated (X/5) ada di file
   - [ ] Skala proyek (Kecil/Menengah/Besar/Enterprise) tertulis
   - [ ] Core loop 3 langkah terdokumentasi
3. Tampilkan ringkasan singkat hasil Modul 01 kepada pengguna:
   - Elevator pitch ide produk
   - Core loop 3 langkah
   - Hasil skor kelayakan (Feasibility Scorecard) & skala yang ditetapkan
4. **AKHIRI RESPON ANDA (END TURN)** dan ajukan konfirmasi kepada pengguna:
   > *"Dokumen `docs/pm/IDEA_BRIEF.md` telah selesai disusun dengan skor kelayakan [X/5] dan skala [Tier]. Apakah ringkasan ini sudah sesuai, atau ada poin yang ingin disesuaikan sebelum kita lanjut ke Modul 02 (Discovery & Scope Definition)?"*
5. Agen HANYA boleh melangkah ke Modul 02 SETELAH pengguna memberikan respon persetujuan (misal: *"ok"*, *"lanjut"*, *"setuju"*). Izin seperti *"isi dulu nanti saya review"* HANYA berlaku untuk Modul 01 ini saja, bukan izin memborong modul berikutnya!
