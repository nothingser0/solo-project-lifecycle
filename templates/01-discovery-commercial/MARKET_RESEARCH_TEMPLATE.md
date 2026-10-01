# Market Research Report

**Tanggal Riset**: [YYYY-MM-DD]  
**Dibuat Oleh**: [Nama Tim/Solo Dev]  
**Versi Dokumen**: 1.0  
**Status**: [Draft / Final / Under Review]

---

## 1. Executive Summary

**Ringkasan 3 Kalimat**:
[Tuliskan kesimpulan utama riset pasar: ukuran pasar, tren pertumbuhan, dan kelayakan regulasi]

**Rekomendasi Go/No-Go**:
- [ ] **GO**: Pasar cukup besar, tren positif, tidak ada blocker regulasi fatal.
- [ ] **PIVOT**: Pasar ada tapi perlu penyesuaian positioning/target segment.
- [ ] **NO-GO**: Pasar terlalu kecil atau ada blocker regulasi yang tidak bisa diatasi solo dev.

---

## 2. Market Sizing (TAM/SAM/SOM)

### 2.1 Total Addressable Market (TAM)

**Definisi TAM**: Seluruh pasar potensial jika tidak ada batasan geografis, kompetitor, atau sumber daya.

**Metode Kalkulasi**:
```
TAM = [Jumlah Total Unit Pasar] × [ARPU/ARPA Tahunan]
```

**Kalkulasi**:
```python
# Contoh: SaaS HR untuk UKM Indonesia
jumlah_ukm_indonesia = 64_000_000  # Data BPS/Kemenkop 2024
arpu_tahunan = 1_200_000  # Rp 100k/bulan × 12 bulan

TAM = jumlah_ukm_indonesia * arpu_tahunan
TAM = Rp 76.8 triliun

# Atau pakai USD
TAM_usd = 64_000_000 * (100 / 15_000)  # $100/bulan
TAM_usd = $5.1 miliar
```

**Hasil TAM**: Rp [X] triliun / $[Y] miliar

**Sumber Data**:
- [ ] BPS (Badan Pusat Statistik): [link/tahun data]
- [ ] Kementerian Koperasi & UKM: [link]
- [ ] Statista: [link]
- [ ] Gartner/Forrester Report: [nama report, tahun]
- [ ] Data internal/survei primer: [deskripsi metodologi]

---

### 2.2 Serviceable Addressable Market (SAM)

**Definisi SAM**: Bagian dari TAM yang realistis bisa dilayani oleh produk Anda (filter geografis, digitalisasi, kriteria target user).

**Filter yang Digunakan**:
1. **Geografis**: [Contoh: Hanya Indonesia, atau hanya Jabodetabek]
2. **Kriteria User**: [Contoh: UKM dengan 5-50 karyawan, sudah pakai komputer]
3. **Digitalisasi**: [Contoh: Hanya UKM yang sudah pakai software/cloud]

**Kalkulasi**:
```python
# Filter 1: UKM dengan 5-50 karyawan (20% dari total UKM)
ukm_target_size = 64_000_000 * 0.20 = 12_800_000

# Filter 2: Sudah pakai software/digitalisasi aktif (8% dari UKM target)
ukm_digital = 12_800_000 * 0.08 = 1_024_000

SAM = ukm_digital * arpu_tahunan
SAM = 1_024_000 * Rp 1_200_000
SAM = Rp 1.23 triliun
```

**Hasil SAM**: Rp [X] miliar / $[Y] juta

**Asumsi & Validasi**:
- Persentase digitalisasi [8%] berdasarkan: [sumber]
- Kriteria ukuran perusahaan [5-50 karyawan] berdasarkan: [sumber]

---

### 2.3 Serviceable Obtainable Market (SOM)

**Definisi SOM**: Porsi SAM yang realistis bisa Anda raih di **Tahun 1** dengan sumber daya terbatas (solo dev/small team).

**Asumsi Market Share Realistis**:
- **Tahun 1**: 0.01% - 0.1% dari SAM (market masih baru, brand belum dikenal)
- **Tahun 2-3**: 0.5% - 2% dari SAM (product-market fit tercapai, word-of-mouth mulai jalan)

**Kalkulasi**:
```python
# Target konservatif: 0.05% market share di tahun 1
market_share_y1 = 0.0005

SOM_y1 = SAM * market_share_y1
SOM_y1 = Rp 1.23 triliun * 0.0005
SOM_y1 = Rp 615 juta

# Atau hitung dari unit customer target
target_paying_customers_y1 = 500  # 500 UKM berlangganan
arpu_tahunan = Rp 1_200_000

SOM_y1 = 500 * Rp 1_200_000 = Rp 600 juta
```

**Hasil SOM Tahun 1**: Rp [X] juta / $[Y]k  
**Target Paying Customers Tahun 1**: [X] customers  
**MRR (Monthly Recurring Revenue) Target**: Rp [X] juta/bulan

**Validasi Bottom-Up**:
```
Jika target 500 paying customers di bulan ke-12:
- Conversion rate signup → paid: 10%
- Maka butuh 5,000 signups di tahun pertama
- Atau 417 signups/bulan rata-rata
- Atau 14 signups/hari

Apakah target ini realistis dengan channel marketing yang ada? [Ya/Tidak]
```

---

## 3. Industry Trend Analysis

### 3.1 Pertumbuhan Industri (Growth Rate)

**Data Historis 3-5 Tahun Terakhir**:

| Tahun | Ukuran Pasar | YoY Growth |
| :--- | :--- | :--- |
| 2022 | Rp [X] miliar | - |
| 2023 | Rp [X] miliar | +[Y]% |
| 2024 | Rp [X] miliar | +[Y]% |
| 2025 | Rp [X] miliar (est.) | +[Y]% |

**Sumber Data**: [Nama laporan, tahun, URL]

**Interpretasi**:
- [ ] **High Growth (>15% YoY)**: Industri sedang booming, good timing untuk masuk.
- [ ] **Moderate Growth (5-15% YoY)**: Industri stabil, kompetisi established tapi masih ada ruang.
- [ ] **Low/Negative Growth (<5% YoY)**: Industri mature/declining, butuh diferensiasi kuat atau pivot.

---

### 3.2 Technology Adoption Curve

**Posisi Target User di Adoption Curve**:
```
Innovators (2.5%) → Early Adopters (13.5%) → Early Majority (34%) → Late Majority (34%) → Laggards (16%)
```

**Target User Anda Berada di**:
- [ ] **Innovators/Early Adopters**: Risk-taker, mau coba teknologi baru. Strategi: focus product differentiation, premium pricing OK.
- [ ] **Early Majority**: Pragmatis, tunggu bukti social proof. Strategi: case studies, testimonials, free trial.
- [ ] **Late Majority**: Skeptis, tunggu teknologi jadi standar. Strategi: emphasize stability, simplicity, cost saving.

**Bukti/Indikator**:
[Contoh: Survey menunjukkan 60% UKM target masih pakai Excel manual → berarti Late Majority, butuh edukasi pasar]

---

### 3.3 Macro Tailwinds & Headwinds

**Tailwinds (Angin Pendorong Positif)**:
1. **[Nama Tailwind 1]**: [Deskripsi]
   - Contoh: "UU PDP No. 27/2022 memaksa perusahaan pakai sistem terenkripsi, tidak bisa lagi pakai spreadsheet manual."
2. **[Nama Tailwind 2]**: [Deskripsi]
   - Contoh: "Pandemic accelerated digital adoption, UKM yang tadinya cash-only sekarang terima QRIS/e-wallet."
3. **[Nama Tailwind 3]**: [Deskripsi]
   - Contoh: "Pemerintah subsidi digitalisasi UKM via program Kemenkop (hibah software)."

**Headwinds (Hambatan/Risiko Makro)**:
1. **[Nama Headwind 1]**: [Deskripsi]
   - Contoh: "Resesi ekonomi → UKM potong budget software, prioritas survival."
2. **[Nama Headwind 2]**: [Deskripsi]
   - Contoh: "Kompetitor big tech (Google, Microsoft) bisa pivot masuk market dengan produk bundled gratis."

---

### 3.4 Google Trends Analysis

**Keyword**: `[keyword utama produk, contoh: "software kasir online"]`

**Trend Chart** (screenshot atau data):
```
[Paste screenshot Google Trends atau data CSV]
```

**Insight**:
- Search volume trend: [Naik/Turun/Stabil] dalam 12 bulan terakhir.
- Peak season: [Bulan X-Y] → timing campaign.
- Geographic hotspot: [Provinsi/kota] → prioritas go-to-market.

**Related Queries yang Naik**:
1. [Query 1] (+[X]% YoY)
2. [Query 2] (+[Y]% YoY)
3. [Query 3] (+[Z]% YoY)

---

## 4. Regulatory Landscape Check

### 4.1 Regulasi yang Berlaku (Indonesia)

**Industri/Sektor**: [Fintech / Healthtech / Edtech / General SaaS / dll.]

| Regulasi | Deskripsi Singkat | Dampak ke Produk | Compliance Action Required |
| :--- | :--- | :--- | :--- |
| **UU PDP No. 27/2022** | Perlindungan data pribadi | Wajib consent management, enkripsi at-rest/transit, data breach notification | [ ] Implement GDPR-style consent UI<br>[ ] Setup AES-256 encryption<br>[ ] Buat incident response plan |
| **UU ITE No. 19/2016** | Transaksi dan tanda tangan elektronik | E-signature sah jika pakai PSrE berizin (Privy, VIDA, dll.) | [ ] Integrasi Privy API (Rp 3k/signature)<br>[ ] Atau pakai disclaimer "tanda tangan digital non-legal-binding" |
| **Peraturan OJK** | (Jika Fintech/Payment) | Wajib izin PUJK untuk proses payment, atau pakai gateway berlisensi | [ ] Pakai Midtrans/Xendit (sudah berizin)<br>[ ] DILARANG simpan data kartu kredit |
| **Kemenkes** | (Jika Healthtech) | Rekam medis elektronik wajib aman, dokter wajib punya SIP | [ ] Verifikasi SIP dokter di onboarding<br>[ ] Enkripsi rekam medis, audit trail |
| **Kemendikbud** | (Jika Edtech formal) | Izin penyelenggaraan pendidikan formal | [ ] Skip jika hanya kursus online (non-formal) |

---

### 4.2 Blocker Regulasi Fatal

**Apakah ada regulasi yang TIDAK BISA dipenuhi solo dev?**

- [ ] **TIDAK ADA BLOCKER**: Regulasi bisa dipenuhi dengan integrasi vendor pihak ketiga atau implementasi teknis standar.
- [ ] **BLOCKER MINOR**: Ada compliance cost (misal: wajib pakai PSrE berlisensi Rp 3k/signature), tapi masih affordable.
- [ ] **BLOCKER FATAL**: Ada izin wajib yang butuh modal besar (contoh: izin OJK untuk payment gateway sendiri butuh Rp 10 miliar modal + audit), atau ada risiko pidana tinggi tanpa perlindungan hukum.

**Jika Blocker Fatal**: **STOP PROJECT** atau **PIVOT** ke model bisnis yang tidak kena regulasi berat.

---

### 4.3 International Compliance (Jika Target Global)

| Regulasi | Wilayah | Dampak |
| :--- | :--- | :--- |
| **GDPR** | Uni Eropa | Wajib consent, right to be forgotten, data breach notification 72 jam |
| **CCPA** | California, AS | Consumer privacy rights, opt-out selling data |
| **PIPEDA** | Kanada | Data privacy consent |

**Action**: [Tidak perlu / Implement di Phase 2 / Wajib di MVP]

---

## 5. Kesimpulan & Rekomendasi

**Market Opportunity Grade**: [A / B / C / D / F]

**Kriteria Grading**:
- **A (Excellent)**: TAM >$1B, SAM >$100M, SOM Y1 >$1M, growth >15% YoY, no fatal regulatory blocker.
- **B (Good)**: TAM >$500M, SAM >$50M, SOM Y1 >$500k, growth 10-15% YoY, minor compliance cost.
- **C (Fair)**: TAM >$100M, SAM >$10M, SOM Y1 >$100k, growth 5-10% YoY, need careful positioning.
- **D (Risky)**: TAM <$100M, SAM <$10M, growth <5% YoY, high compliance burden.
- **F (No-Go)**: Fatal regulatory blocker, atau market too small untuk sustainable business.

**Go-to-Market Recommendation**:
1. **Primary Target Segment**: [Segmen mana yang paling feasible untuk attack pertama]
2. **Geographic Priority**: [Kota/provinsi mana yang mulai duluan]
3. **Timing**: [Launch sekarang / tunggu event X / skip dan pivot]

**Next Steps**:
- [ ] Proceed to Competitive Analysis (Modul 00 - Langkah 2)
- [ ] Revisi TAM/SAM/SOM jika asumsi tidak valid
- [ ] Escalate regulatory blocker ke legal counsel (jika B2B enterprise client)

---

**Disetujui Oleh**:  
**Nama**: [Solo Dev / PM Lead]  
**Tanggal**: [YYYY-MM-DD]
