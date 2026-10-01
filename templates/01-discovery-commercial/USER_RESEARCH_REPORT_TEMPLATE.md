# User Research Report

**Tanggal Riset**: [YYYY-MM-DD] s/d [YYYY-MM-DD]  
**Dibuat Oleh**: [Nama Tim/Solo Dev]  
**Versi Dokumen**: 1.0  
**Research Lead**: [Nama Researcher]

---

## 1. Executive Summary

**Research Objectives**:
[1-2 kalimat: Apa yang ingin divalidasi dari riset ini?]

**Key Findings (Top 3)**:
1. **[Finding 1]**: [Insight paling critical dari user research]
2. **[Finding 2]**: [Insight kedua]
3. **[Finding 3]**: [Insight ketiga]

**Intent-to-Buy Validation**:
- **Survey Result**: [X]% responden pilih "Pasti beli" atau "Mungkin beli"
- **Gate Pass Status**: ✅ PASS (≥30%) / ❌ FAIL (<30%)

**Recommendation**:
- [ ] **Proceed to Product Strategy**: Validated problem, clear user needs, sufficient intent-to-buy.
- [ ] **Pivot**: Pain points validated tapi solution fit belum jelas, perlu adjust positioning.
- [ ] **Stop**: Intent-to-buy <30%, tidak ada willingness to pay yang cukup.

---

## 2. Research Methodology

### 2.1 Sample Size & Demographics

**Qualitative Research (Interviews)**:
- **Total Interviews**: [X] orang
- **Duration per Interview**: [Y] menit rata-rata
- **Interview Method**: [Video call Zoom / Phone / In-person / Async written]
- **Incentive**: [Voucher Rp X / Gratis akses early-access / Tidak ada]

**Quantitative Research (Survey)**:
- **Total Respondents**: [X] orang
- **Survey Platform**: [Google Forms / Typeform / Tally]
- **Response Rate**: [X]% (jika ada email blast list)
- **Survey Duration**: [Median X menit to complete]

---

### 2.2 Respondent Demographics

**Geographic Distribution**:
| Wilayah | Jumlah | Persentase |
| :--- | :---: | :---: |
| Jabodetabek | [X] | [Y]% |
| Jawa Barat | [X] | [Y]% |
| Jawa Timur | [X] | [Y]% |
| Luar Jawa | [X] | [Y]% |

**Industry/Sector** (jika B2B):
| Industri | Jumlah | Persentase |
| :--- | :---: | :---: |
| Retail/FMCG | [X] | [Y]% |
| F&B/Restoran | [X] | [Y]% |
| Jasa Profesional | [X] | [Y]% |
| Manufaktur | [X] | [Y]% |
| Lainnya | [X] | [Y]% |

**Company Size** (jika B2B):
| Ukuran Perusahaan | Jumlah | Persentase |
| :--- | :---: | :---: |
| 1-5 karyawan | [X] | [Y]% |
| 6-20 karyawan | [X] | [Y]% |
| 21-50 karyawan | [X] | [Y]% |
| 51-200 karyawan | [X] | [Y]% |
| >200 karyawan | [X] | [Y]% |

**Age Range** (jika B2C):
| Usia | Jumlah | Persentase |
| :--- | :---: | :---: |
| 18-24 | [X] | [Y]% |
| 25-34 | [X] | [Y]% |
| 35-44 | [X] | [Y]% |
| 45-54 | [X] | [Y]% |
| 55+ | [X] | [Y]% |

---

## 3. Qualitative Insights (Interview Findings)

### 3.1 Interview Summary Table

| ID | Role/Title | Company/Context | Current Solution | Top Pain Point | WTP Range | Intent |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| U01 | [Manajer Operasional] | [Toko Retail 7 cabang] | [Excel + WA group] | [Selisih stok, kerugian 5-10 jt/bln] | Rp 200-500k/bln | Strong |
| U02 | [Owner UKM] | [Cafe chain 3 outlet] | [Manual pencatatan] | [Laporan penjualan lambat] | Rp 100-300k/bln | Moderate |
| U03 | [...] | [...] | [...] | [...] | [...] | [...] |
| ... | | | | | | |
| U10+ | | | | | | |

**Interview Transcripts**: [Link ke folder Google Drive/Notion dengan transkrip lengkap, atau anonymized summary di appendix]

---

### 3.2 Synthesized Themes (Affinity Mapping)

**Theme 1: [Nama Theme, contoh: "Data Accuracy & Trust Issues"]**
- **Frequency**: [X]/[Total] responden mention tema ini
- **Representative Quotes**:
  > "Saya sering hitung manual stok vs sistem, selalu beda 10-15%. Jadi saya tidak percaya data." — U01, Manajer Operasional
  
  > "Staf cabang suka lupa input, atau salah tulis angka. Akhirnya data jadi sampah." — U04, Owner Retail

- **Implication for Product**:
  [Apa yang harus produk solve untuk address theme ini? Contoh: Perlu validation layer, barcode scanning untuk kurangi manual entry error]

---

**Theme 2: [Nama Theme, contoh: "Time Waste on Manual Admin"]**
- **Frequency**: [X]/[Total] responden
- **Representative Quotes**:
  > "Setiap akhir minggu saya habiskan 4-5 jam untuk compile laporan dari 7 cabang. Copy-paste Excel satu per satu." — U01

- **Implication for Product**:
  [Auto-consolidation report, real-time dashboard]

---

**Theme 3: [Nama Theme, contoh: "Lack of Actionable Insights"]**
- **Frequency**: [X]/[Total] responden
- **Representative Quotes**:
  > "Saya punya data penjualan lengkap di Excel, tapi tidak tahu produk mana yang slow-moving. Tidak ada alert." — U06

- **Implication for Product**:
  [Predictive analytics, alert system untuk anomali/threshold]

---

### 3.3 Jobs-to-be-Done Analysis

**Framework**: Ketika [situation], saya ingin [motivation], agar saya bisa [outcome].

**Top 5 Jobs Users Are Hiring Product For**:

1. **Job #1**: "Ketika cabang melakukan transaksi penjualan, saya ingin stok terupdate otomatis real-time, agar saya tidak perlu telepon tiap cabang untuk cek stok."
   - **Current Struggle**: Manual phone call/WA setiap hari, info sering outdated.
   - **Success Criteria**: Cek stok dari dashboard dalam <10 detik, data akurat 95%+.

2. **Job #2**: "Ketika akhir bulan, saya ingin laporan penjualan semua cabang otomatis tersedia, agar saya tidak buang waktu 4 jam compile Excel."
   - **Current Struggle**: Manual copy-paste dari berbagai file Excel.
   - **Success Criteria**: 1-klik generate report, export PDF/Excel, selesai dalam 30 detik.

3. **Job #3**: "Ketika produk mendekati habis, saya ingin dapat alert otomatis, agar saya tidak kehabisan barang best-seller."
   - **Current Struggle**: Tidak ada sistem monitoring, sering terlambat restock.
   - **Success Criteria**: Alert via WA/Email jika stok < threshold, lead time restock cukup.

4. **Job #4**: [...]

5. **Job #5**: [...]

---

### 3.4 Pain Point Severity Ranking

**Method**: Responden rank pain points dari 1 (tidak mengganggu) sampai 5 (sangat mengganggu).

| Pain Point | Avg. Severity (1-5) | Frequency (% mention) | Impact × Frequency Score |
| :--- | :---: | :---: | :---: |
| Selisih stok fisik vs catatan (kerugian uang) | 4.8 | 85% | 4.08 🔴 **Critical** |
| Proses manual memakan 4+ jam/minggu | 4.2 | 70% | 2.94 🟠 **High** |
| Tidak ada real-time visibility ke cabang | 3.9 | 60% | 2.34 🟡 **Medium** |
| Laporan tidak actionable (data dump aja) | 3.5 | 50% | 1.75 🟡 **Medium** |
| Setup/onboarding software lama (>30 menit) | 2.8 | 40% | 1.12 🟢 **Low** |

**Priority Pain Points to Solve in MVP** (Score ≥2.5):
1. Selisih stok fisik vs catatan
2. Proses manual memakan waktu
3. Tidak ada real-time visibility

---

## 4. Quantitative Insights (Survey Results)

### 4.1 Screener & Qualification

**Q: Apakah Anda saat ini mengelola [specific task/problem]?**
- Ya: [X]% → Proceed to full survey
- Tidak: [Y]% → Survey terminated

**Q: Seberapa sering Anda melakukan [task] ini?**
- Setiap hari: [X]%
- Beberapa kali seminggu: [X]%
- Sebulan sekali: [X]%
- Jarang (<1x/bulan): [X]% → Diskualifikasi

**Qualified Respondents**: [X] dari [Y] total responses

---

### 4.2 Pain Point Severity Distribution

**Q: Seberapa besar masalah berikut mengganggu pekerjaan Anda? (1 = Tidak masalah, 5 = Sangat mengganggu)**

**Pain Point 1: [Deskripsi masalah]**
```
Rating Distribution:
1 (Tidak masalah):   ▓▓░░░░░░░░ 10%
2 (Sedikit masalah): ▓▓▓░░░░░░░ 15%
3 (Cukup masalah):   ▓▓▓▓▓░░░░░ 25%
4 (Masalah besar):   ▓▓▓▓▓▓▓░░░ 35% 
5 (Sangat menggangu):▓▓▓▓░░░░░░ 15%

Rata-rata: 3.4 / 5.0
Median: 4
```

**Pain Point 2: [...]**
[Ulangi untuk setiap pain point]

---

### 4.3 Current Solution Usage

**Q: Apa yang Anda gunakan saat ini untuk menangani [problem]?**

| Solusi | Persentase |
| :--- | :--- |
| Excel manual | 45% ▓▓▓▓▓▓▓▓▓░ |
| Software kompetitor A | 20% ▓▓▓▓░░░░░░ |
| Software kompetitor B | 10% ▓▓░░░░░░░░ |
| Pen & paper | 15% ▓▓▓░░░░░░░ |
| Tidak pakai sistem | 10% ▓▓░░░░░░░░ |

**Insight**: 70% responden pakai solusi manual/non-software → besar opportunity untuk convert mereka.

---

### 4.4 Willingness to Pay (Van Westendorp Analysis)

**Q: Harga berapa yang menurut Anda...**

**Distribution Chart**:
```
Rp 0     50k    100k   150k   200k   250k   300k   350k   400k
│────────┼──────┼──────┼──────┼──────┼──────┼──────┼──────│
Terlalu Murah:        ▲ (50k median)
Murah (good deal):             ▲ (100k median)
Mahal (mulai ragu):                      ▲ (250k median)
Terlalu Mahal:                                   ▲ (350k median)

Optimal Price Point (OPP): Rp 150k - Rp 200k
└─ Intersection of "Murah" and "Mahal" curves
```

**Price Sensitivity**:
- **Too Cheap (suspicious)**: <Rp 50k
- **Good Value Zone**: Rp 100k - Rp 200k 🎯
- **Expensive but Acceptable**: Rp 200k - Rp 300k
- **Too Expensive (won't buy)**: >Rp 350k

**Recommendation**: Launch pricing di **Rp 99k - Rp 149k/bulan** untuk maximize adoption di early-stage.

---

### 4.5 Intent-to-Buy

**Q: Jika software ini tersedia hari ini dengan harga Rp [X]/bulan, apakah Anda akan:**

| Response | Persentase | Count |
| :--- | :--- | :--- |
| Pasti beli (Strong Intent) | 25% ▓▓▓▓▓░░░░░ | [X] |
| Mungkin beli (Moderate Intent) | 35% ▓▓▓▓▓▓▓░░░ | [Y] |
| Perlu diskusi dengan tim dulu | 20% ▓▓▓▓░░░░░░ | [Z] |
| Tidak tertarik | 20% ▓▓▓▓░░░░░░ | [W] |

**Total Intent-to-Buy (Pasti + Mungkin)**: **60%** ✅ **PASS GATE** (≥30%)

**Early Adopter Pool Estimate**:
```python
# Dari 50 responden survey
strong_intent = 25% * 50 = 12 orang
moderate_intent = 35% * 50 = 18 orang

# Asumsi conversion rate realistis:
# Strong intent → paid: 50% conversion
# Moderate intent → paid: 20% conversion

expected_paying_customers_from_survey = (12 * 0.5) + (18 * 0.2) = 6 + 3.6 = 9-10 customers

# Jika kita bisa reach 1000 orang dengan profil serupa:
potential_customers = (1000 * 0.25 * 0.5) + (1000 * 0.35 * 0.2) = 125 + 70 = 195 customers
```

---

### 4.6 Feature Prioritization (Kano Model)

**Q: Jika fitur [X] ada, seberapa senang Anda? Jika tidak ada, seberapa kecewa Anda?**

| Fitur | Must-Have | Performance | Delighter | Indifferent |
| :--- | :---: | :---: | :---: | :---: |
| Real-time stock sync | ✅ 80% | | | |
| Auto-generate report | ✅ 70% | | | |
| Barcode scanner integration | | ✅ 60% | | |
| WhatsApp notification | | | ✅ 50% | |
| Dark mode | | | | ✅ 20% |
| Multi-currency support | | | | ✅ 15% |

**Interpretation**:
- **Must-Have**: Jika tidak ada, user sangat kecewa. Wajib ada di MVP.
- **Performance**: Semakin bagus implementasinya, semakin senang user. Prioritas medium.
- **Delighter**: User tidak expect, tapi jika ada mereka surprised. Nice-to-have.
- **Indifferent**: User tidak peduli ada atau tidak. Skip di MVP.

---

## 5. Persona Creation (Jobs-to-be-Done Framework)

### Persona 1: [Nama Persona, contoh: "Budi — Manajer Operasional UKM Retail"]

**Demografi**:
- **Usia**: 32 tahun
- **Lokasi**: Jakarta Selatan
- **Pendidikan**: S1 Manajemen
- **Peran**: Manajer Operasional (mengelola 5-7 cabang toko retail)
- **Pengalaman Kerja**: 8 tahun di industri retail
- **Tech Savviness**: Moderate (pakai Instagram, WhatsApp Business, Excel, pernah coba software akuntansi)
- **Gaji/Budget Authority**: Rp 12-18 juta/bulan, bisa approve budget software sampai Rp 500k/bulan

---

**Jobs to Be Done**:
1. **Primary Job**: Memantau stok barang real-time tanpa harus telepon ke setiap cabang.
2. **Secondary Job**: Membuat laporan penjualan mingguan untuk owner tanpa manual entry.
3. **Tertiary Job**: Mendeteksi produk yang slow-moving untuk diskon proaktif.

---

**Current Workflow (As-Is)**:
```
06:00 - Bangun, cek WA group "Tim Operasional" untuk laporan stok cabang
08:00 - Ke kantor pusat, buka Excel master inventory
09:00 - Telepon 7 kepala cabang satu per satu untuk validasi stok fisik
11:00 - Manual input data stok ke Excel (prone to typo)
14:00 - Owner minta laporan penjualan minggu ini, mulai compile data
16:00 - Selesai compile, kirim via email (total 4 jam kerja untuk admin)
```

---

**Pain Points** (ranked by severity):
1. **🔴 Critical**: Sering terjadi selisih stok fisik vs catatan (kerugian Rp 5-10 jt/bulan karena barang "hilang" atau salah catat).
2. **🟠 High**: Spend 4 jam/minggu untuk compile Excel dari 7 cabang (manual, repetitive, boring).
3. **🟡 Medium**: Owner sering tanya laporan mendadak (weekend/malam), harus kerja lembur dadakan.
4. **🟢 Low**: Sulit track produk mana yang laku vs slow-moving (hanya feeling/intuisi, no data-driven decision).

---

**Goals & Desired Outcomes**:
- **Efficiency Goal**: Kurangi waktu admin dari 4 jam/minggu jadi <30 menit/minggu.
- **Accuracy Goal**: Selisih stok <2% (dari sekarang ~10-15%).
- **Peace of Mind**: Tidak perlu khawatir owner tanya laporan mendadak, karena data always ready.
- **Career Goal**: Pakai data untuk propose strategi bisnis ke owner (misal: "Produk X slow-moving 3 bulan, sebaiknya diskon"), naik jadi GM.

---

**Current Workaround & Frustrations**:
- **Workaround**: Pakai Excel + WhatsApp group untuk laporan harian staf. Manual cek stok fisik setiap weekend.
- **Frustration #1**: "Staf cabang sering lupa update WA group, atau salah tulis angka. Saya jadi polisi yang harus ngomel tiap hari."
- **Frustration #2**: "Excel saya punya 15 sheet untuk 7 cabang. Setiap kali owner minta laporan beda format, saya harus utak-atik lagi formula."
- **Frustration #3**: "Software enterprise kayak [Kompetitor A] terlalu mahal (Rp 500k/bulan) dan ribet setupnya. Butuh 1 minggu training."

---

**Willingness to Pay**: Rp 200k - Rp 500k/bulan
- **Rationale**: Hemat waktu 4 jam/minggu = 16 jam/bulan. Jika gaji Budi Rp 15 jt/bulan (Rp 94k/jam), value time saving = Rp 1.5 jt/bulan. Plus kurangi kerugian selisih stok Rp 5-10 jt/bulan.
- **Budget Approval**: Budi bisa approve sendiri sampai Rp 500k/bulan. Di atas itu butuh approval owner.

---

**Objections & Barriers to Adoption**:
1. **"Apakah staf cabang (pendidikan SMA, umur 40+) bisa pakai?"**
   - Need: UI super simple, Bahasa Indonesia, video tutorial, onboarding <15 menit.
2. **"Apakah tetap bisa jalan jika internet putus?"**
   - Need: Offline-first architecture, data sync otomatis saat online kembali.
3. **"Bagaimana migrasi data dari Excel saya yang sudah ada?"**
   - Need: Import wizard 1-klik dari Excel template.
4. **"Apakah data aman? Saya tidak mau data penjualan bocor ke kompetitor."**
   - Need: Enkripsi AES-256, compliance statement UU PDP, audit trail.

---

**Preferred Communication Channels**:
- **Discovery**: Google Search ("software inventory toko"), rekomendasi teman sesama manajer ops, grup WhatsApp/Telegram komunitas retail.
- **Evaluation**: Free trial 14 hari (harus bisa setup sendiri tanpa sales call), baca case study/testimonial.
- **Support**: WhatsApp Business chat (prefer async daripada telepon), knowledge base Bahasa Indonesia, video tutorial YouTube.

---

**Quote (Representative)**:
> "Saya butuh software yang bisa saya setup dalam 30 menit, staf saya langsung bisa pakai tanpa training formal, dan harga tidak bunuh cash flow UKM. Kalau bisa solve 3 ini, saya pasti beli."

---

### Persona 2: [Nama Persona Lain]

[Ulangi struktur yang sama untuk persona 2-3]

---

## 6. User Journey Mapping

### Journey Map: Persona 1 (Budi - Manajer Operasional)

**Stage 1: Awareness (Trigger)**
- **Scenario**: Owner komplain soal selisih stok lagi, ancam potong bonus Budi jika tidak solve.
- **Touchpoint**: Budi Google search "cara mengatasi selisih stok toko" → menemukan artikel blog → mention software inventory → mulai riset.
- **Emotion**: 😰 Stressed, desperate untuk cari solusi.
- **Pain**: Tidak tahu harus mulai dari mana, banyak pilihan software, takut salah pilih.
- **Opportunity**: SEO content marketing (blog/video "5 Cara Kurangi Selisih Stok"), retargeting ads.

---

**Stage 2: Consideration (Research)**
- **Scenario**: Budi compare 3-4 software (buka website, baca review, tanya di grup WA).
- **Touchpoint**: Website landing page, pricing page, comparison chart, testimoni video, grup Facebook "Komunitas Retail Indonesia".
- **Emotion**: 🤔 Skeptis, overwhelmed dengan pilihan.
- **Pain**: "Semua software claim bagus, tapi mana yang beneran cocok untuk UKM kayak saya?" "Apakah harga sesuai fitur?"
- **Opportunity**: 
  - Social proof (case study UKM lokal serupa, testimoni video owner toko).
  - Free trial tanpa CC (remove barrier).
  - Comparison table transparent (vs kompetitor A, B, C).

---

**Stage 3: Purchase/Signup (Conversion)**
- **Scenario**: Budi decide coba free trial, klik "Daftar Gratis 14 Hari".
- **Touchpoint**: Signup form, onboarding wizard, setup assistance.
- **Emotion**: 😬 Anxious (takut ribet, takut buang waktu trial percuma).
- **Pain**: 
  - Signup form terlalu panjang (minta terlalu banyak info).
  - Onboarding tidak jelas (stuck di langkah 2, tidak tahu next apa).
  - Import data Excel gagal (format tidak cocok, error message tidak jelas).
- **Opportunity**:
  - Onboarding wizard step-by-step (progress bar, estimated time: "3 menit setup").
  - Import wizard 1-klik (auto-detect column, tolerant formatting).
  - Live chat / WA support jika stuck.

---

**Stage 4: Onboarding/First Use (Aha Moment)**
- **Scenario**: Budi berhasil import data, ajak 2 staf cabang coba input transaksi, lihat dashboard update real-time.
- **Touchpoint**: Dashboard, first transaction, first report generated.
- **Emotion**: 🤩 Delighted ("Wah, real-time beneran! Staf cabang bilang gampang!").
- **Pain**: 
  - Tidak tahu fitur apa yang harus dipakai dulu (too many options, overwhelm).
  - Staf cabang komplain UI membingungkan (terlalu banyak menu, Bahasa Inggris).
- **Opportunity**:
  - Onboarding checklist (guided first 5 tasks: "1. Input transaksi pertama, 2. Cek dashboard, 3. Generate laporan").
  - Celebrate first milestone (confetti animation, "Selamat! Transaksi pertama berhasil!").
  - Video tutorial in-app (embed YouTube 2-3 menit).

**Aha Moment Definition**: Budi lihat dashboard update real-time setelah staf cabang input transaksi, dan berhasil generate laporan penjualan dalam <30 detik (vs 4 jam manual Excel).

---

**Stage 5: Retention (Habitual Use)**
- **Scenario**: Budi dan tim pakai software setiap hari, sudah jadi workflow default.
- **Touchpoint**: Daily dashboard check, weekly report generation, monthly billing reminder.
- **Emotion**: 😌 Relieved (hidup lebih gampang, owner happy).
- **Pain**: 
  - Churn risk jika ada bug yang mengganggu workflow (contoh: data sync gagal, laporan error).
  - Churn risk jika kompetitor offer lebih murah atau fitur lebih banyak.
  - Churn risk jika owner potong budget (resesi, toko tutup).
- **Opportunity**:
  - Customer success check-in (email/WA setiap 30 hari: "Gimana pengalaman pakai software? Ada kendala?").
  - Upsell fitur advanced (contoh: "Upgrade ke plan Pro untuk dapat predictive restock alerts").
  - Build switching cost (integrasi dengan accounting software, data historical banyak, ribet pindah).

---

**Stage 6: Advocacy (Word-of-Mouth)**
- **Scenario**: Budi recommend software ke teman sesama manajer ops di grup WhatsApp.
- **Touchpoint**: Referral program, testimonial request, case study interview.
- **Emotion**: 😊 Proud (bangga pakai software yang solve problem, mau share).
- **Pain**: Tidak ada incentive untuk refer (kenapa harus promosiin gratis?).
- **Opportunity**:
  - Referral program (refer 3 teman, dapat 1 bulan gratis atau diskon 20%).
  - Gamification (leaderboard top referrer, badge "Community Champion").
  - Feature di case study (publikasi di blog/social media, boost kredibilitas Budi di industri).

---

## 7. Pain Point Prioritization (Impact-Effort Matrix)

**Methodology**: Plot pain points berdasarkan **Impact to User** (seberapa parah masalahnya) vs **Effort to Solve** (seberapa susah develop solusinya).

```
High Impact
    │
    │  [1] Selisih stok     [2] Manual admin 4 jam/minggu
    │      (kerugian uang)       (time waste)
    │
    │  
────┼────────────────────────────────────────────► Effort to Solve
    │                                               (Low → High)
    │  [3] Setup lama       [4] Tidak ada mobile app
    │      (>30 menit)           (akses terbatas)
    │
Low Impact
```

**Prioritization Decision**:

**Quadrant 1 (High Impact, Low Effort)**: 🎯 **DO FIRST IN MVP**
- [Pain #1]: Selisih stok fisik vs catatan
  - **Solution**: Real-time sync, barcode scanner integration, validation layer.
  - **Effort**: Medium (2-3 minggu dev time).
- [Pain #2]: Manual admin 4 jam/minggu
  - **Solution**: Auto-consolidation report, 1-klik export PDF/Excel.
  - **Effort**: Low (1 minggu dev time).

**Quadrant 2 (High Impact, High Effort)**: 🚀 **DO IN PHASE 2**
- [Pain #5]: Tidak ada actionable insights (data dump aja)
  - **Solution**: Predictive analytics, ML model untuk forecast demand.
  - **Effort**: High (4-6 minggu + data science expertise).

**Quadrant 3 (Low Impact, Low Effort)**: ✅ **DO IF TIME PERMITS**
- [Pain #3]: Setup lama (>30 menit)
  - **Solution**: Onboarding wizard, import template.
  - **Effort**: Low (1 minggu).

**Quadrant 4 (Low Impact, High Effort)**: ❌ **DON'T DO / DEPRIORITIZE**
- [Pain #4]: Tidak ada mobile app native
  - **Solution**: Build native iOS/Android app.
  - **Effort**: High (8-12 minggu + maintenance burden).
  - **Alternative**: Responsive PWA sudah cukup untuk use case ini.

---

## 8. Research Limitations & Biases

**Known Limitations**:
1. **Sample Size**: [X] interviews dan [Y] survey bukan representative untuk seluruh market Indonesia. Generalisasi harus hati-hati.
2. **Selection Bias**: Responden yang respond survey/interview cenderung yang sudah aware dengan problem (survivor bias). User yang tidak aware mungkin tidak terwakili.
3. **Social Desirability Bias**: Dalam interview, responden mungkin bilang "ya saya akan beli" untuk please interviewer, tapi real behavior beda. Harus validasi dengan actual purchase behavior di MVP.
4. **Geographic Limitation**: [X]% responden dari Jabodetabek, insight mungkin tidak applicable untuk daerah luar Jawa.

**Mitigation**:
- Combine qualitative (deep understanding) dengan quantitative (statistical validation).
- Track actual conversion rate di MVP untuk validate intent-to-buy claim.
- Iterate research setiap 3-6 bulan untuk update assumptions.

---

## 9. Next Steps & Recommendations

**For Product Development**:
1. **MVP Feature Prioritization**: Focus solve Pain #1 (selisih stok) dan Pain #2 (manual admin time waste) terlebih dahulu.
2. **UX Requirements**: Onboarding harus <15 menit, UI Bahasa Indonesia, offline-first architecture.
3. **Pricing Strategy**: Launch di Rp 99k-149k/bulan (sweet spot dari WTP analysis).

**For Go-to-Market**:
1. **Target Segment**: UKM retail 5-20 karyawan, Jabodetabek, sudah pakai Excel/manual system.
2. **Messaging**: "Stop buang 4 jam/minggu compile Excel. Rp 99k/bulan, setup 15 menit, staf SMA bisa pakai."
3. **Channel**: SEO content (blog pain point), komunitas WhatsApp/Telegram owner toko, referral program.

**For Further Research**:
- [ ] Usability testing prototype (5-10 users, moderated task-based testing)
- [ ] Pricing experiment A/B test (Rp 99k vs Rp 149k conversion rate)
- [ ] Expand geographic coverage (riset user luar Jawa)

---

**Appendix**:
- [Link to full interview transcripts]
- [Link to raw survey data CSV]
- [Link to affinity mapping Miro/FigJam board]

---

**Disetujui Oleh**:  
**Nama**: [Solo Dev / PM Lead]  
**Tanggal**: [YYYY-MM-DD]
