# Modul 00: Product Discovery & Strategy (Riset Pasar, Kompetitor, Pengguna, & Strategi Produk)

> ⚠️ **MANDATORY: Load references BEFORE executing this module**:
> - `references/improvements/MODUL_00_IMPROVEMENTS.md` (Timeline 3-4 minggu, Budget Rp1.5-11 juta, Respondent recruitment tactics, Competitive moat assessment, Skip decision tree, Expanded regulatory table)
> - `references/technical/DEEP_RESEARCH_METHODOLOGY.md` (Regulatory/compliance research, Competitor deep-dive analysis, Domain knowledge acquisition for fintech/healthtech/legaltech)
>
> **MANDATORY: Load references BEFORE executing this module**:
> - Read: `references/improvements/MODUL_00_IMPROVEMENTS.md`

Modul ini adalah **gerbang paling awal** dalam siklus pengembangan perangkat lunak untuk solo developer dan konsultan teknis yang mengerjakan proyek dengan anggaran waktu tak terbatas (*unlimited time budget*) dan kasus penggunaan perusahaan (*company use-case*). Modul ini wajib dieksekusi **SEBELUM Modul 01 (Idea & Feasibility)** ketika:
- Proyek membutuhkan standar Product Management (*PM*) tingkat industri.
- Ada kebutuhan validasi pasar, analisis kompetitor, dan penelitian pengguna mendalam sebelum menentukan fitur.

**Untuk proyek Fast-Track atau MVP dengan deadline ketat: SKIP modul ini dan langsung ke Modul 01 (Idea & Feasibility).**

---

## 1. Siklus Eksekusi Modul 00

```text
[ PERTANYAAN BISNIS / PELUANG PASAR ]
          │
          ▼
[ LANGKAH 1: Market Research (Riset Pasar) ]
  • TAM/SAM/SOM Calculation
  • Industry Trend Analysis
  • Regulatory Landscape Check
          │
          ▼
[ LANGKAH 2: Competitive Analysis (Analisis Kompetitor) ]
  • Competitor Identification (Direct & Indirect)
  • Feature Matrix Comparison
  • Pricing Benchmarking
  • SWOT Analysis per Competitor
  • Positioning Map (2x2 Matrix)
          │
          ▼
[ LANGKAH 3: User Research (Penelitian Pengguna) ]
  • Interview Guide (10+ users, 30-45 min each)
  • Survey Design (50+ respondents, quantitative validation)
  • Persona Creation (Jobs-to-be-Done Framework)
  • User Journey Mapping
  • Pain Point Prioritization
          │
          ▼
[ LANGKAH 4: Product Strategy (Strategi Produk) ]
  • Vision Statement (Aspirational, 3-5 years)
  • Mission Statement (Tactical, current state)
  • North Star Metric Definition + Rationale
  • Value Proposition Canvas (Gains/Pains/Jobs)
  • Strategic Pillars (3-5 Core Focus Areas)
          │
          ▼
[ GATE PROTOCOL: Market Validation Pass ]
  • Min 30% intent-to-buy from survey
  • Competitive moat identified
  • North Star Metric measurable
          │
          ▼
[ OUTPUT: 4 Dokumen PM ] ──► Siap Lanjut ke Modul 01: Idea & Feasibility
```

---

## 2. Langkah demi Langkah Eksekusi

### Langkah 1: Market Research (Riset Pasar)

Tujuan: Memahami ukuran pasar, pertumbuhan industri, dan batasan regulasi sebelum menghabiskan waktu untuk ide spesifik.

#### 1.1 TAM/SAM/SOM Calculation

**TAM (Total Addressable Market)**: Seluruh pasar jika tidak ada batasan (geografis, regulasi, kompetitor).
**SAM (Serviceable Addressable Market)**: Bagian dari TAM yang realistis dilayani oleh produk Anda.
**SOM (Serviceable Obtainable Market)**: Porsi SAM yang bisa Anda raih di tahun pertama dengan sumber daya terbatas.

**Formula Estimasi**:
```python
# Contoh: SaaS Akuntansi untuk UKM Indonesia
TAM = (jumlah_ukm_indonesia * arpu_tahunan)
    # 64 juta UKM (data Kemenkop 2022) * Rp 1.200.000/tahun
    # [UPDATE 2026: Verify latest BPS/Kemenkop UKM count]
    # TAM = Rp 76.8 triliun

SAM = TAM * (persentase_digitalisasi_aktif)
    # 64 jt UKM * 8% sudah pakai software * Rp 1.200.000
    # SAM = Rp 6.1 triliun

SOM_tahun_1 = SAM * (target_market_share_realistis)
    # Rp 6.1 triliun * 0.01% (1 dari 10.000 UKM digital)
    # 0.01% = 0.0001 dalam rumus Python (bukan 0.01)
    # SOM = Rp 610 juta/tahun (≈ 500 paying customers)
```

**Metode Validasi**:
- **Top-Down**: Ambil data laporan industri (Gartner, Statista, Kemenkop, BPS) → filter ke segmen target.
- **Bottom-Up**: Hitung dari unit ekonomi terkecil (jumlah restoran Jakarta * rata-rata pengeluaran software POS).

#### 1.2 Market Sizing Frameworks

| Framework | Kapan Digunakan | Contoh Aplikasi |
| :--- | :--- | :--- |
| **Substitution Analysis** | Produk menggantikan solusi lama | "Berapa orang yang saat ini bayar jasa notaris manual untuk legalisasi dokumen?" |
| **Proxy Metrics** | Pasar baru tanpa data langsung | "Jumlah pengguna aktif e-commerce (120 jt) * 15% pernah beli barang custom → 18 jt calon pengguna platform design-to-print" |
| **Value-Based Sizing** | B2B SaaS dengan ROI jelas | "Jika software menghemat 10 jam/minggu staf admin (Rp 5 jt/bulan gaji), WTP adalah Rp 1-2 jt/bulan" |

#### 1.3 Industry Trend Analysis

Gunakan Google Trends, laporan McKinsey/BCG Indonesia, dan riset startup (DailySocial.id, Katadata) untuk menemukan:
1. **Growth Trends**: Apakah industri tumbuh >10% YoY atau stagnan?
2. **Tech Adoption Curve**: Di mana posisi target pengguna (Early Adopter vs Late Majority)?
3. **Macro Tailwinds**: Regulasi baru (UU PDP), perubahan perilaku pasca-pandemi, subsidi pemerintah.

#### 1.4 Regulatory Landscape Check

| Sektor Industri | Regulasi Kritis Solo Dev Wajib Tahu |
| :--- | :--- |
| **Fintech / Payment** | OJK (PUJK, P2P Lending License), Bank Indonesia (GPN, QRIS wajib lisensi) |
| **Healthtech / Telemedicine** | Kemenkes (SIP dokter, rekam medis elektronik), Izin Edar Alkes |
| **Edtech / Online Course** | Kemendikbud (NPSN untuk pendidikan formal), Hak Cipta konten |
| **Data-Heavy Apps** | UU PDP No. 27/2022 (wajib consent management, data breach notification) |
| **E-Signature Apps** | Kominfo PSrE (wajib pakai vendor berizin jika tanda tangan legal binding) |

**Output Langkah 1**: Berkas **`docs/pm/MARKET_RESEARCH.md`** berisi:
- Hasil kalkulasi TAM/SAM/SOM dengan sumber data.
- Grafik tren industri (screenshot Google Trends atau tabel pertumbuhan YoY).
- Daftar regulasi yang mempengaruhi go-to-market.

---

### Langkah 2: Competitive Analysis (Analisis Kompetitor)

Tujuan: Memahami lanskap kompetitor untuk menemukan positioning gap dan *defensible moat*.

#### 2.1 Competitor Identification

**Direct Competitors**: Produk yang menyelesaikan masalah yang sama dengan cara yang sama.
**Indirect Competitors**: Produk yang menyelesaikan masalah yang sama dengan cara berbeda.
**Substitute Competitors**: Non-software yang pengguna pakai saat ini (Excel, WhatsApp group, jasa manual).

**Taktik Discovery**:
```bash
# Gunakan Google search operators
"<problem keyword> software site:id"
"<problem keyword> Indonesia pricing"
intitle:"<competitor name> review"

# Cek app store
https://play.google.com/store/search?q=<keyword>&c=apps&gl=ID
https://apps.apple.com/id/search?term=<keyword>

# Monitor ProductHunt/Indie Hackers untuk startup global
```

#### 2.2 Feature Matrix Comparison

Buat tabel perbandingan fitur kompetitor:

| Fitur | Kompetitor A | Kompetitor B | Kompetitor C | [Produk Anda] |
| :--- | :---: | :---: | :---: | :---: |
| Dashboard Analitik Real-Time | ✅ | ❌ | ✅ | ✅ |
| Export Laporan ke Excel | ✅ | ✅ | ❌ | ✅ |
| Integrasi WhatsApp Notifikasi | ❌ | ❌ | ✅ | ✅ |
| Mobile App (Android/iOS) | ✅ | ❌ | ✅ | ⏳ (Phase 2) |
| Multi-User RBAC | ❌ | ✅ | ✅ | ✅ |

**Analisis Gap**: Tandai fitur yang **TIDAK ADA DI SEMUA KOMPETITOR** tapi pengguna butuh (dari riset user interview).

#### 2.3 Pricing Benchmarking

Catat model harga kompetitor:
- **Freemium**: Fitur dasar gratis, fitur pro berbayar (Notion, Canva).
- **Tiered Subscription**: Bronze/Silver/Gold (Rp 99k, Rp 299k, Rp 999k/bulan).
- **Per-Seat Pricing**: Rp 50k/user/bulan (Slack, Mekari).
- **Usage-Based**: Rp 5/transaksi atau Rp 0.01/API call (Stripe, Midtrans).

**Positioning Price Anchor**:
- **Low-End Disruption**: 30-50% lebih murah dari incumbent (risiko: persepsi murah = fitur kurang).
- **Premium Positioning**: 20-30% lebih mahal dengan value prop jelas (contoh: "satu-satunya dengan enkripsi end-to-end").

#### 2.4 SWOT Analysis per Competitor

Untuk 3 kompetitor utama, buat SWOT:

**Contoh: Kompetitor A (Incumbent Besar)**
- **Strengths**: Brand awareness tinggi, integrasi banyak, support 24/7.
- **Weaknesses**: UI lawas, pricing mahal, tidak ada mobile app.
- **Opportunities**: Ekspansi ke segment UKM (mereka fokus enterprise).
- **Threats**: Bisa pivot cepat dengan modal besar jika lihat produk kita laku.

#### 2.5 Positioning Map (2x2 Matrix)

Buat visualisasi positioning dengan sumbu X dan Y yang relevan:

```
Harga Tinggi
      │
   [A]│     [C]
      │
──────┼──────────► Complexity (Simple → Advanced)
      │
   [B]│  [Produk Anda]
      │
Harga Rendah
```

**Output Langkah 2**: Berkas **`docs/pm/COMPETITIVE_LANDSCAPE.md`** berisi:
- Daftar 5-10 kompetitor dengan kategori (direct/indirect/substitute).
- Feature matrix tabel.
- Pricing benchmarking table.
- SWOT 3 kompetitor utama.
- Positioning map diagram (ASCII art atau link Excalidraw/Figma).

---

### Langkah 3: User Research (Penelitian Pengguna)

Tujuan: Validasi asumsi pasar dengan data kualitatif (interview) dan kuantitatif (survey).

#### 3.1 Interview Guide (10+ Users, 30-45 Min Each)

**Target Responden**:
- **Untuk B2B**: Decision maker (Direktur, Manajer Keuangan, IT Manager).
- **Untuk B2C**: Pengguna aktif solusi existing atau manual workaround.

**Struktur Interview (5-Act Framework)**:
1. **Warm-Up (5 min)**: Kenalkan diri, jelaskan tujuan riset, minta izin rekam.
2. **Current State (10 min)**: "Ceritakan cara Anda menangani [problem] saat ini. Apa toolsnya? Berapa lama waktunya?"
3. **Pain Points (10 min)**: "Apa bagian paling menyebalkan dari proses ini? Pernah gagal/error? Dampaknya apa?"
4. **Desired Future (10 min)**: "Jika ada tongkat ajaib, seperti apa solusi ideal Anda? Fitur apa yang wajib ada?"
5. **Willingness to Pay (5 min)**: "Jika ada software yang menyelesaikan masalah ini, berapa budget bulanan yang wajar menurut Anda?"

**Pertanyaan Wajib (Jobs-to-be-Done Framework)**:
```
Q: "Ketika Anda menggunakan [existing solution], 
   pekerjaan apa yang sebenarnya Anda coba selesaikan?"

Q: "Apa yang membuat Anda beralih dari cara manual ke software 
   (atau sebaliknya)?"

Q: "Jika besok software Anda pakai hilang, apa yang akan Anda lakukan?"
```

**Red Flags dalam Interview**:
- Responden tidak punya masalah riil (hanya senang diajak ngobrol).
- Responden ngasih ide fitur banyak tapi tidak mau bayar ("maunya gratis aja").
- Responden bilang "semua fitur penting" tanpa prioritas jelas.

#### 3.2 Survey Design (50+ Respondents, Quantitative Validation)

Gunakan Google Forms / Typeform / Tally untuk survey terstruktur:

**Bagian 1: Screener (Filter Responden)**
```
Q1: Apakah Anda saat ini mengelola [specific task]? (Ya/Tidak)
    → Jika "Tidak", stop survey.

Q2: Seberapa sering Anda melakukan [task] ini?
    [ ] Setiap hari
    [ ] Beberapa kali seminggu
    [ ] Sebulan sekali
    [ ] Jarang (<1x/bulan) → diskualifikasi
```

**Bagian 2: Pain Point Severity (Likert Scale 1-5)**
```
Q: Seberapa besar masalah berikut mengganggu pekerjaan Anda?
   (1 = Tidak masalah, 5 = Sangat mengganggu)

- Proses manual memakan waktu > 2 jam/hari: [1][2][3][4][5]
- Sering terjadi kesalahan input data: [1][2][3][4][5]
- Sulit melacak riwayat perubahan: [1][2][3][4][5]
```

**Bagian 3: Willingness to Pay (Van Westendorp Price Sensitivity)**
```
Q: Harga berapa yang menurut Anda:
   - Terlalu murah (mencurigakan): Rp _______
   - Murah (good deal): Rp _______
   - Mahal (mulai ragu): Rp _______
   - Terlalu mahal (tidak akan beli): Rp _______
```

**Bagian 4: Intent to Buy**
```
Q: Jika software ini tersedia hari ini dengan harga Rp [X]/bulan, 
   apakah Anda akan:
   [ ] Pasti beli (Strong Intent)
   [ ] Mungkin beli (Moderate Intent)
   [ ] Perlu diskusi dengan tim dulu
   [ ] Tidak tertarik
```

**Gate Pass Criteria**: Minimum 30% dari 50+ responden (15 orang) pilih "Pasti beli" atau "Mungkin beli".

#### 3.3 Persona Creation (Jobs-to-be-Done Framework)

Buat 2-3 persona utama berdasarkan hasil interview:

**Template Persona**:
```markdown
## Persona 1: Budi — Manajer Operasional UKM Retail

**Demografi**:
- Usia: 32 tahun
- Lokasi: Jakarta
- Peran: Manajer toko retail chain (5 cabang)
- Tech Savviness: Moderate (pakai Instagram, WhatsApp Business, Excel)

**Jobs to Be Done**:
- Memantau stok barang real-time tanpa harus telepon ke setiap cabang.
- Membuat laporan penjualan mingguan untuk owner tanpa manual entry.
- Mendeteksi produk yang slow-moving untuk diskon.

**Pain Points** (diurutkan by severity):
1. **Critical**: Sering terjadi selisih stok fisik vs catatan (kerugian Rp 5-10 jt/bulan).
2. **High**: Spend 4 jam/minggu untuk compile Excel dari 5 cabang.
3. **Medium**: Owner sering tanya laporan mendadak, harus kerja lembur.

**Current Workaround**:
- Pakai Excel + WhatsApp group untuk laporan harian staf.
- Manual cek stok fisik setiap weekend.

**Willingness to Pay**: Rp 200k-500k/bulan (karena bisa hemat waktu lembur + kurangi selisih stok).

**Objections/Barriers**:
- "Apakah staf cabang (pendidikan SMA) bisa pakai?"
- "Apakah tetap bisa jalan jika internet putus?"
```

#### 3.4 User Journey Mapping

Petakan langkah pengguna dari awareness hingga retention:

**5-Stage Journey**:
1. **Awareness**: Bagaimana pengguna pertama kali tahu produk ada? (Google search "software kasir", rekomendasi teman, iklan FB).
2. **Consideration**: Apa yang mereka evaluasi? (Harga, ease of use, ada trial gratis?).
3. **Purchase/Signup**: Apa friction saat daftar? (Butuh kartu kredit? Setup rumit?).
4. **Onboarding/First Use**: Kapan mereka merasakan "aha moment"? (Berhasil input data pertama? Laporan pertama generate?).
5. **Retention/Advocacy**: Kenapa mereka stay atau churn? (Value konsisten vs "ribet, balik ke Excel").

**Mapping Pain & Opportunity**:
```
Stage: Onboarding
Current Experience: "Setup butuh 2 jam, bingung import data master."
Pain Level: ⭐⭐⭐⭐ (High)
Opportunity: "Buat import wizard 1-klik dari Excel template."
```

#### 3.5 Pain Point Prioritization (Impact-Effort Matrix)

Urutkan pain points berdasarkan **Impact to User** vs **Effort to Solve**:

```
High Impact
    │
 [1]│ [2]          [1] Selisih stok = kerugian uang
    │               → High priority (solve di MVP)
────┼────────►    [2] Laporan manual 4 jam/minggu
    │               → High priority (solve di MVP)
 [3]│ [4]          [3] Dark mode
    │               → Low priority (nice-to-have)
Low Impact        [4] Integrasi akuntansi Accurate
                    → Medium-High effort, delay ke Phase 2
```

**Output Langkah 3**: Berkas **`docs/pm/USER_RESEARCH_REPORT.md`** berisi:
- Transkrip rangkuman 10+ interview (anonymized).
- Survey result summary (charts: pain severity distribution, WTP histogram, intent-to-buy %).
- 2-3 persona lengkap dengan JTBD.
- User journey map dengan pain/opportunity annotations.
- Pain point prioritization matrix (screenshot atau ASCII table).

---

### Langkah 4: Product Strategy (Strategi Produk)

Tujuan: Mentransformasi insight riset menjadi strategi produk jangka panjang dengan metrik sukses yang measurable.

#### 4.1 Vision Statement (Aspirational, 3-5 Years)

**Formula**: `[Target User] + [Transformed Future State] + [Societal Impact]`

**Contoh**:
```
Vision: "Menjadi platform manajemen stok terpercaya bagi 100.000 UKM retail 
         Indonesia, menghilangkan kerugian akibat selisih stok, dan 
         memberdayakan owner usaha kecil untuk fokus ke pertumbuhan bisnis 
         daripada pusing administrasi."
```

**Test Kualitas Vision**:
- ✅ Inspiratif (bikin orang excited kerja ke arah itu).
- ✅ Aspirational (belum tercapai hari ini, tapi realistis dalam 3-5 tahun).
- ❌ Terlalu generik ("menjadi platform terbaik di Indonesia").

#### 4.2 Mission Statement (Tactical, Current State)

**Formula**: `[What We Do] + [For Whom] + [How We Do It Differently]`

**Contoh**:
```
Mission: "Membantu pemilik toko retail dengan 2-10 cabang melacak stok 
          real-time melalui aplikasi mobile yang bisa digunakan staf 
          dengan training <30 menit, tanpa butuh internet 24/7."
```

**Test Kualitas Mission**:
- ✅ Actionable (jelas apa yang dikerjakan hari ini).
- ✅ Specific (bukan "membantu semua orang").
- ✅ Differentiated (ada unique "how").

#### 4.3 North Star Metric Definition + Rationale

**North Star Metric (NSM)**: Satu metrik utama yang paling merepresentasikan value yang user terima.

**Template Definisi**:
```markdown
## North Star Metric: [Nama Metrik]

**Formula**: [Rumus kalkulasi]

**Rationale (Kenapa Metrik Ini?)**:
- Leading indicator untuk revenue (korelasi kuat dengan retention/MRR).
- Langsung mencerminkan user value (bukan vanity metric).
- Bisa dipengaruhi oleh tim product/engineering (actionable).

**Target Awal (3-6 Bulan Pertama)**: [Angka baseline → target]

**Breakdown Metrics (Tree)**:
```

**Contoh: SaaS Inventory Management**
```
North Star Metric: "Jumlah Transaksi Stok yang Di-track per Minggu"
  (Alasan: Semakin banyak transaksi di-track, semakin besar value untuk 
   user karena data akurat. Korelasi kuat dengan retention.)

Target: 500 transaksi/minggu/user → 2000 transaksi/minggu/user (bulan ke-6)

Breakdown:
├─ Acquisition: New users sign up per week
├─ Activation: % users yang input ≥10 transaksi di minggu pertama
├─ Engagement: % users yang aktif minimal 3x/minggu
└─ Retention: % users yang masih aktif di bulan ke-3
```

**Anti-Pattern NSM yang Salah**:
- ❌ "Total registered users" → vanity metric (banyak daftar tapi tidak pakai).
- ❌ "Time spent in app" → bukan selalu baik (user mungkin bingung).

#### 4.4 Value Proposition Canvas (Strategyzer Framework)

Gunakan template Gains/Pains/Jobs dari Strategyzer.com:

**Customer Profile (Right Side)**:
1. **Customer Jobs**: Apa yang user coba selesaikan? (functional, social, emotional).
2. **Pains**: Apa yang menghalangi mereka selesaikan job? (frustrasi, hambatan, risiko).
3. **Gains**: Apa outcome yang mereka inginkan? (saving time, saving money, status).

**Value Map (Left Side)**:
1. **Products & Services**: Apa yang produk tawarkan?
2. **Pain Relievers**: Bagaimana produk menghilangkan pains?
3. **Gain Creators**: Bagaimana produk menciptakan gains?

**Contoh Mapping**:
```
Customer Job: "Melacak stok real-time tanpa harus telepon cabang."

Pain: "Staf cabang sering lupa update, data tidak reliable."
Pain Reliever: "Auto-sync setiap transaksi ke cloud tanpa manual entry."

Gain: "Bisa bikin keputusan restock cepat, tidak kehabisan barang best-seller."
Gain Creator: "Alert otomatis jika stok di bawah threshold."
```

#### 4.5 Strategic Pillars (3-5 Core Focus Areas)

Tentukan 3-5 pilar strategis untuk guide product roadmap:

**Template Pilar**:
```markdown
## Pilar 1: [Nama Pilar]

**Definisi**: [1 kalimat positioning pilar ini]

**Key Initiatives (6-12 Bulan)**:
- [ ] Inisiatif A
- [ ] Inisiatif B

**Success Criteria**: [Metrik untuk ukur keberhasilan pilar]
```

**Contoh: SaaS Inventory**
```
Pilar 1: Reliability & Offline-First
  → Sistem harus tetap bisa dipakai saat internet mati.
  Key Initiatives: Implement IndexedDB sync, background queue, conflict resolution.
  Success: ≥95% transaksi berhasil di-sync tanpa data loss.

Pilar 2: Ease of Use for Non-Tech Staff
  → Onboarding <30 menit, tidak butuh training formal.
  Key Initiatives: Wizard setup, video tutorial in-app, Indonesian UI/UX.
  Success: ≥80% new users selesaikan first transaction dalam 10 menit.

Pilar 3: Actionable Insights (bukan hanya data dump)
  → User dapat keputusan bisnis langsung dari dashboard.
  Key Initiatives: Predictive restock alerts, slow-moving product detection.
  Success: ≥50% users pakai insights untuk bikin keputusan per minggu.
```

**Output Langkah 4**: Berkas **`docs/pm/PRODUCT_STRATEGY.md`** berisi:
- Vision & Mission Statement.
- North Star Metric dengan formula, rationale, target, dan breakdown tree.
- Value Proposition Canvas (Gains/Pains/Jobs mapping).
- 3-5 Strategic Pillars dengan initiatives dan success criteria.

---

## 3. Adaptasi Berdasarkan Skala Proyek

| Aspek | Solo Dev Product (Mandiri) | B2B SaaS Client | Enterprise Client |
| :--- | :--- | :--- | :--- |
| **Market Research Depth** | TAM/SAM/SOM estimasi cepat (1-2 hari), pakai data sekunder | Riset industri formal, lakukan primary research (survey 50+ responden) | Commissioned report (partnership dengan konsultan riset market), compliance check mendalam |
| **Competitive Analysis** | 3-5 kompetitor utama, feature matrix dasar | 5-10 kompetitor, SWOT lengkap, pricing benchmarking detail | 10+ kompetitor, Porter's Five Forces, IP/patent landscape analysis |
| **User Research** | 5-10 interview, survey 30+ responden | 10-20 interview stakeholder, survey 50-100 responden, persona validation workshop | Multi-phase research (discovery → validation → usability testing), 30+ interview, 200+ survey, ethnographic study |
| **Product Strategy** | Vision/Mission 1-page, NSM sederhana | Vision/Mission formal, NSM dengan breakdown metrics, Value Prop Canvas | Business case formal, 3-year roadmap, strategic alignment dengan corporate OKRs |

---

## 4. Artefak Keluaran (Deliverable)

Hasil akhir dari Modul 00 adalah **4 dokumen PM** yang dibuat menggunakan template di folder `templates/01-discovery-commercial/`:

1. **`docs/pm/MARKET_RESEARCH.md`**: Hasil TAM/SAM/SOM, industry trends, regulatory landscape.
   - Template: `templates/01-discovery-commercial/MARKET_RESEARCH_TEMPLATE.md`
2. **`docs/pm/COMPETITIVE_LANDSCAPE.md`**: Analisis 5-10 kompetitor, feature matrix, SWOT, positioning map.
   - Template: `templates/01-discovery-commercial/COMPETITIVE_LANDSCAPE_TEMPLATE.md`
3. **`docs/pm/USER_RESEARCH_REPORT.md`**: Rangkuman interview/survey, persona JTBD, user journey, pain matrix.
   - Template: `templates/01-discovery-commercial/USER_RESEARCH_REPORT_TEMPLATE.md`
4. **`docs/pm/PRODUCT_STRATEGY.md`**: Vision/Mission, North Star Metric, Value Prop Canvas, Strategic Pillars.
   - Template: `templates/01-discovery-commercial/PRODUCT_STRATEGY_TEMPLATE.md`

> 📁 **ATURAN LOKASI BERKAS MUTLAK**:
> Semua dokumen WAJIB disimpan di dalam folder **`docs/pm/`** (bukan di root direktori).
> Root direktori `./` dicadangkan secara eksklusif hanya untuk 7 berkas kendali AI (Agent Harness) saat Modul 06 dimulai.

---

## 🛑 PROTOKOL [GATE] KELUAR & WAJIB BERHENTI

Setelah keempat berkas PM selesai ditulis:

1. **DILARANG KERAS langsung melanjutkan atau memanggil tool untuk Modul 01 dalam giliran (turn) yang sama!**

2. **VERIFIKASI DIRI (Self-Verification Checklist)**:
   - [ ] `read_file('docs/pm/MARKET_RESEARCH.md')` → Confirm TAM/SAM/SOM ada, sumber data dicantumkan
   - [ ] `read_file('docs/pm/COMPETITIVE_LANDSCAPE.md')` → Min 5 kompetitor, feature matrix ada, positioning map ada
   - [ ] `read_file('docs/pm/USER_RESEARCH_REPORT.md')` → Min 10 interview insights, survey result (sample size ≥30), 2-3 persona lengkap
   - [ ] `read_file('docs/pm/PRODUCT_STRATEGY.md')` → Vision/Mission tertulis, North Star Metric defined dengan formula + rationale, 3-5 Strategic Pillars ada

3. **GATE PASS CRITERIA** (Market Validation):
   - [ ] **Intent-to-Buy ≥30%**: Dari survey minimal 50 responden, minimal 30% (15 orang) pilih "Pasti beli" atau "Mungkin beli".
   - [ ] **Competitive Moat Identified**: Ada minimal 1 diferensiasi jelas yang kompetitor tidak punya atau sulit tiru (contoh: offline-first architecture, specific niche focus).
   - [ ] **North Star Metric Measurable**: NSM bisa di-track dengan instrumentasi teknis (event logging, DB query).

   **Jika Gate Pass GAGAL**:
   - Intent-to-buy <30% → **PIVOT atau STOP**: Ide tidak validated, jangan lanjut ke development.
   - Tidak ada competitive moat → **PIVOT positioning** atau temukan unique value prop lain.
   - NSM tidak measurable → Revisi NSM hingga bisa di-instrument.

4. Tampilkan ringkasan hasil Modul 00 kepada pengguna:
   ```
   ## Ringkasan Product Discovery & Strategy

   **Market Opportunity**:
   - TAM: [angka], SAM: [angka], SOM Tahun 1: [angka]
   - Tren industri: [insight 1-2 kalimat]
   - Regulatory blocker: [ada/tidak]

   **Competitive Landscape**:
   - [X] kompetitor direct, [Y] kompetitor indirect
   - Positioning gap: [diferensiasi unik kita]
   - Pricing anchor: [strategi harga]

   **User Validation**:
   - [X] interview, [Y] survey responden
   - Top 3 Pain Points: [1], [2], [3]
   - Intent-to-Buy: [Z]% (Gate Pass: ✅/❌)

   **Product Strategy**:
   - North Star Metric: [nama metrik + target]
   - Strategic Pillars: [pilar 1], [pilar 2], [pilar 3]
   ```

5. **AKHIRI RESPON ANDA (END TURN)** dan ajukan konfirmasi kepada pengguna:
   > *"Modul 00 (Product Discovery & Strategy) telah selesai dengan [X]% intent-to-buy dan North Star Metric '[NSM]' telah defined. Gate validation: [PASS/FAIL]. Apakah strategi produk ini sudah sesuai, atau ada insight yang perlu disesuaikan sebelum kita lanjut ke Modul 01 (Idea & Feasibility)?*
   > 
   > *Jika Gate FAIL, saya rekomendasikan PIVOT atau STOP project. Jika Gate PASS, kita bisa lanjut ke Modul 01 untuk breakdown teknis dan feasibility check."*

6. Agen HANYA boleh melangkah ke Modul 01 SETELAH pengguna memberikan respon persetujuan (misal: *"ok"*, *"lanjut"*, *"setuju"*) DAN Gate Pass criteria terpenuhi.
