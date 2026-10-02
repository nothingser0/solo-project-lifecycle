# PM Phase TODO Template (Modul 00 - Modul 03)

> Template daftar tugas atomik untuk fase Product Management, Discovery, Feasibility, Scope Definition, dan Legal/Commercial Negotiation.
> Aturan: Kerjakan secara terstruktur per modul. Setiap tugas harus memiliki bukti artefak (*artifact proof*) sebelum centang `[x]`. Modul ini wajib dituntaskan dan disetujui klien/stakeholder sebelum melangkah ke fase Desain & Arsitektur.

---

## Metadata Proyek
- **Nama Proyek**: [Nama Proyek / Sistem]
- **Klien / Inisiator Bisnis**: [Nama Perusahaan / Organisasi]
- **Product Manager / Solo Consultant**: [Nama Anda]
- **Tanggal Mulai**: [YYYY-MM-DD]
- **Target Selesai Fase PM**: [YYYY-MM-DD]
- **Versi Dokumen**: 1.0.0
- **Status Gerbang PM**: [ ] DRAFT | [ ] UNDER REVIEW | [ ] APPROVED / LOCKED

---

## 1. Modul 00: Riset Pasar, Kompetitor, & Strategi Produk (M00)

### 1.1 Riset Pasar & Peluang Bisnis
- [ ] `docs/01-discovery/market-research.md`: Hitung estimasi TAM, SAM, dan SOM dengan rumus kuantitatif - expect estimasi nilai pasar realistis terverifikasi data publik (BPS, Statista, laporan industri)
- [ ] `docs/01-discovery/market-research.md`: Analisis tren makro dan siklus adopsi pasar 3-5 tahun ke depan - expect kesimpulan arah tren pasar terdeskripsi jelas
- [ ] `docs/01-discovery/market-research.md`: Petakan lanskap regulasi dan kepatuhan hukum sektor terkait (UU PDP No. 27/2022, PSE Kominfo, izin OJK/BI/Kemenkes jika fintech/healthtech) - expect daftar regulasi dan prasyarat lisensi tercatat tanpa celah kepatuhan fatal

### 1.2 Analisis Kompetitor Mendalam
- [ ] `docs/01-discovery/competitive-analysis.md`: Identifikasi minimal 3 kompetitor langsung (*direct*) dan 2 kompetitor tidak langsung (*indirect*) - expect profil profil kompetitor lengkap
- [ ] `docs/01-discovery/competitive-analysis.md`: Susun tabel perbandingan fitur (*Feature Comparison Matrix*) berbasis kapabilitas inti sistem - expect diferensiasi fitur tampak jelas
- [ ] `docs/01-discovery/competitive-analysis.md`: Lakukan benchmarking struktur harga (*Pricing Model Benchmarking*) per kompetitor - expect gambaran batas atas dan bawah willingness to pay pasar
- [ ] `docs/01-discovery/competitive-analysis.md`: Buat diagram Positioning Map 2x2 (misal: Harga vs. Kustomisasi, atau Kemudahan vs. Kedalaman Fitur) - expect *white space* atau keunggulan komparatif produk teridentifikasi

### 1.3 Riset Pengguna & Kebutuhan Riil (User Research)
- [ ] `docs/01-discovery/user-research.md`: Rancang panduan wawancara pengguna (*User Interview Script*) dengan 8-10 pertanyaan mendalam berbasis perilaku riil - expect naskah wawancara tidak mengarahkan (*unbiased*)
- [ ] `docs/01-discovery/user-research.md`: Eksekusi wawancara terhadap 5-10 representasi target pengguna atau validasi survei minimal 30 responden - expect rekaman sintesis transkrip dan data empiris terkumpul
- [ ] `docs/01-discovery/personas.md`: Buat 2 persona pengguna utama menggunakan format Jobs-to-be-Done (JTBD), pains, gains, dan trigger emosional - expect persona berorientasi masalah konkret, bukan fiksi demografis semata
- [ ] `docs/01-discovery/user-journey-map.md`: Petakan User Journey Map alur saat ini (*as-is*) beserta titik friksi/frustrasi utama (*pain points*) - expect titik peluang optimasi terpapar transparan

### 1.4 Strategi Produk & Metrik Keberhasilan
- [ ] `docs/01-discovery/product-strategy.md`: Formulasikan Value Proposition Canvas dan positioning statement produk - expect kalimat proposisi nilai unik 1 paragraf padat
- [ ] `docs/01-discovery/product-strategy.md`: Tentukan 1 North Star Metric (NSM) dan 3-5 metrik pendukung (Input Metrics) - expect metrik terukur tanpa vanity metrics
- [ ] `docs/01-discovery/okrs.md`: Rumuskan Objective and Key Results (OKRs) untuk kuartal pertama pasca peluncuran - expect target angka realistis terdefinisi

---

## 2. Modul 01: Penyaringan Ide & Uji Kelayakan (M01)

### 2.1 Saringan 3 Lapis (The 3-Filter Triage)
- [ ] `docs/01-discovery/idea-brief.md`: Tuliskan Masalah Riil 1 kalimat & Solusi Unik 1 kalimat - expect masalah tidak dapat diselesaikan hanya dengan Google Spreadsheet gratis
- [ ] `docs/01-discovery/idea-brief.md`: Definisikan Core User Loop (Trigger -> Action -> Variable Reward -> Investment) - expect siklus interaksi inti jelas dalam < 3 langkah
- [ ] `docs/01-discovery/idea-brief.md`: Jalankan MVP Razor: coret semua fitur di luar Core User Loop - expect hanya tersisa 1-3 fitur esensial yang langsung memberikan nilai

### 2.2 Uji 4 Dimensi Kelayakan (Feasibility Assessment)
- [ ] `docs/01-discovery/feasibility-report.md`: Kelayakan Teknis (Technical) - Evaluasi kesiapan stack, ketersediaan API pihak ketiga, dan kompleksitas arsitektur untuk solo developer - expect skor teknis >= 4/5
- [ ] `docs/01-discovery/feasibility-report.md`: Kelayakan Bandwidth Solo Dev (Schedule/Capacity) - Hitung rasio kompleksitas vs batas waktu delivery - expect komitmen jam kerja masuk akal tanpa burnout
- [ ] `docs/01-discovery/feasibility-report.md`: Kelayakan Legal & Regulasi (Legal/Compliance) - Audit potensi liabilitas data pribadi, hak cipta, dan izin operasional - expect nol blocker hukum kategori fatal
- [ ] `docs/01-discovery/feasibility-report.md`: Kelayakan Ekonomi & Bisnis (Economic/ROI) - Uji Willingness to Pay, unit economics sederhana, dan margin solo dev - expect ROI positif dan kesiapan anggaran sponsor/klien

### 2.3 Klasifikasi Skala & Gerbang Keputusan
- [ ] `docs/01-discovery/scale-classification.md`: Tentukan klasifikasi skala proyek (Small MVP / Mid B2B SaaS / Large Multi-System / Enterprise) - expect rute eksekusi dan durasi terpetakan akurat
- [ ] `Gate Review Modul 01`: Tentukan status GO / PIVOT / KILL berdasarkan ambang skor kelayakan - expect keputusan formal disetujui pemangku kepentingan

---

## 3. Modul 02: Penentuan Ruang Lingkup & Backlog (M02)

### 3.1 Identifikasi Pemangku Kepentingan & Matriks RACI
- [ ] `docs/01-discovery/stakeholders.md`: Petakan seluruh stakeholder utama (Project Sponsor, Product Owner, End User, Compliance Lead) - expect kontak dan wewenang terdaftar
- [ ] `docs/01-discovery/raci-matrix.md`: Susun Matriks RACI (Responsible, Accountable, Consulted, Informed) untuk setiap fase deliverable proyek - expect single accountable party per deliverable tanpa ambiguitas

### 3.2 Pernyataan Ruang Lingkup (Scope Statement)
- [ ] `docs/01-discovery/scope-statement.md`: Rinci daftar eksplisit **In-Scope** (fitur, platform, integrasi yang wajib dibuat) - expect batasan fungsional tegas
- [ ] `docs/01-discovery/scope-statement.md`: Rinci daftar eksplisit **Out-of-Scope** (fitur yang dilarang dikerjakan dalam fase ini) - expect proteksi terhadap scope creep
- [ ] `docs/01-discovery/scope-statement.md`: Dokumentasikan **Asumsi Proyek** (ketersediaan data, response time review klien, API eksternal stabil) - expect asumsi terdokumentasi tertulis
- [ ] `docs/01-discovery/scope-statement.md`: Dokumentasikan **Batasan Proyek / Constraints** (deadline mati, pagu anggaran, batasan hardware/hosting) - expect batasan diakui kedua belah pihak

### 3.3 Dekomposisi Backlog & Prioritisasi Fitur
- [ ] `docs/01-discovery/backlog.md`: Uraikan kebutuhan menjadi Epics dan User Stories berstandar INVEST (*Independent, Negotiable, Valuable, Estimable, Small, Testable*) - expect user stories disertai Acceptance Criteria berformat Given-When-Then
- [ ] `docs/01-discovery/prioritization.md`: Terapkan metode MoSCoW (Must-have, Should-have, Could-have, Won't-have untuk rilis ini) - expect alokasi Must-Have <= 60% total kapasitas
- [ ] `docs/01-discovery/prioritization.md`: Lakukan scoring prioritas alternatif menggunakan framework RICE (*Reach, Impact, Confidence, Effort*) untuk backlog tier-2 - expect peringkat prioritas terurut objektif

### 3.4 Manajemen Risiko & Kontrol Perubahan
- [ ] `docs/01-discovery/risk-register.md`: Susun Risk Register (Deskripsi risiko, Kategori: Teknis/Bisnis/Operasional, Probabilitas 1-5, Dampak 1-5, Rencana Mitigasi, Contingency Plan) - expect mitigasi untuk semua risiko berkategori High/Critical
- [ ] `docs/01-discovery/change-management-protocol.md`: Tetapkan protokol Change Request (CR) resmi (formulir pengajuan CR, perhitungan dampak biaya/waktu, syarat approval tertulis) - expect kesepakatan tertulis bahwa perubahan scope di luar SOW akan menambah invoice dan waktu pengerjaan

---

## 4. Modul 03: Kontrak Hukum, SOW, & Project Charter (M03)

### 4.1 Penyusunan Scope of Work (SOW)
- [ ] `contracts/SOW_CONTRACT.md`: Tuliskan deskripsi objektif proyek, deliverables utama, dan spesifikasi deliverable per milestone - expect deskripsi deliverable konkret dan dapat diuji secara objektif
- [ ] `contracts/SOW_CONTRACT.md`: Pasang tabel Milestone Jadwal & Distribusi Pembayaran bertahap:
  - Milestone 1: Inisiasi, SOW & Desain Disetujui (DP 30% - 50%)
  - Milestone 2: Pengembangan Inti & SIT Selesai (30% - 40%)
  - Milestone 3: UAT Lolos & BAST Final Go-Live (10% - 20%)
  - expect tidak ada klausul pembayaran 100% di akhir proyek (*pay-at-the-end anti-pattern dicegah*)
- [ ] `contracts/SOW_CONTRACT.md`: Definisikan tata cara pengujian dan jendela waktu review klien (maksimal 5-7 hari kerja untuk memberikan feedback/approval per milestone) - expect klausul *deemed accepted* jika klien tidak merespons dalam batas waktu

### 4.2 Klausul Hak Cipta, Kerahasiaan, & Kewajiban
- [ ] `contracts/SOW_CONTRACT.md`: Tegaskan klausul Hak Kekayaan Intelektual (HAKI): Kepemilikan kode sumber baru beralih ke klien HANYA setelah seluruh pembayaran 100% lunas - expect perlindungan hak cipta solo dev terjaga
- [ ] `contracts/SOW_CONTRACT.md`: Cantumkan klausul Open Source Software (OSS) dan reusable boilerplate milik solo dev yang dikecualikan dari hak eksklusif klien - expect library generik terlindungi
- [ ] `contracts/SOW_CONTRACT.md`: Tetapkan Non-Disclosure Agreement (NDA) dua arah terkait perlindungan data rahasia bisnis dan kredensial sistem - expect kepatuhan UU PDP dan perlindungan rahasia dagang
- [ ] `contracts/SOW_CONTRACT.md`: Definisikan garansi cacat sistem (*Warranty Period*) selama 30-60 hari kalender HANYA untuk bug yang menyimpang dari SOW/FSD (bukan penambahan fitur baru) - expect batasan lingkup garansi tegas

### 4.3 Klausul Pemutusan, Keterlambatan, & Kill Fee
- [ ] `contracts/SOW_CONTRACT.md`: Cantumkan denda keterlambatan pembayaran invoice oleh klien (misal 0.1%/hari) dan hak solo dev untuk menghentikan sementara pekerjaan jika pembayaran macet - expect perlindungan arus kas solo dev
- [ ] `contracts/SOW_CONTRACT.md`: Pasang klausul *Kill Fee / Termination for Convenience*: jika proyek dibatalkan sepihak oleh klien, DP hangus dan seluruh pekerjaan yang telah selesai wajib dibayar prorata - expect mitigasi kerugian waktu sepihak
- [ ] `contracts/SOW_CONTRACT.md`: Tetapkan mekanisme eskalasi dan klausul penyelesaian sengketa (Musyawarah mufakat -> BANI / Pengadilan Negeri domisili penyedia) - expect yurisdiksi hukum jelas

### 4.4 Finalisasi Project Charter & Invoice Uang Muka (DP)
- [ ] `contracts/PROJECT_CHARTER.md`: Susun ringkasan Project Charter 1-2 halaman yang ditandatangani oleh Project Sponsor dan Lead Consultant - expect mandat otorisasi proyek resmi terbit
- [ ] `invoices/INVOICE_DOWN_PAYMENT.pdf`: Terbitkan invoice Uang Muka (Down Payment 30%-50%) sesuai nomor rekening resmi - expect invoice diterima dan tervalidasi finance klien
- [ ] `Proof of Payment`: Verifikasi penerimaan transfer dana DP masuk ke rekening bank sebelum pengerjaan desain/teknis dimulai - expect saldo efektif terkonfirmasi di rekening (Zero work without DP)

---

## 5. Gerbang Verifikasi Kelolosan Fase PM (Gate Pass PM to Design)

| Parameter Evaluasi | Standar Minimum Kelolosan | Status Verifikasi | Catatan Bukti |
| :--- | :--- | :---: | :--- |
| **Validasi Masalah & Pasar** | TAM/SAM terhitung, 5+ interview pengguna tuntas, diferensiasi kompetitor jelas | [ ] PASS | Dilampirkan di `docs/01-discovery/` |
| **Kelayakan & Skala** | Skor uji kelayakan 4 dimensi >= 4/5, skala proyek terdefinisi | [ ] PASS | Dilampirkan di `docs/01-discovery/feasibility-report.md` |
| **Ruang Lingkup Terkunci** | Scope statement In/Out terpasang, backlog MoSCoW tuntas | [ ] PASS | Dilampirkan di `docs/01-discovery/scope-statement.md` |
| **Legalitas & Finansial** | SOW & Kontrak ditandatangani kedua pihak (e-meterai), DP 30-50% masuk rekening | [ ] PASS | Dilampirkan di `contracts/` & bukti transfer bank |

### Keputusan Gerbang PM:
- [ ] **LULUS (GO TO DESIGN)**: Seluruh artefak M00-M03 lengkap, kontrak sah, DP cair. Lanjut ke Modul 04 (Design System & Prototyping).
- [ ] **TAHAN (HOLD / PENDING DP)**: Dokumen siap namun pembayaran DP belum masuk. Dilarang keras menulis kode atau membuat desain final!
- [ ] **TOLAK / PIVOT (REJECT / REDESIGN SCOPE)**: Ruang lingkup tidak realistis atau kesepakatan komersial tidak tercapai. Lakukan revisi scope atau batalkan proyek.
