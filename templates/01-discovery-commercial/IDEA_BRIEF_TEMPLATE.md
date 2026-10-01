# Idea Brief & Feasibility Scorecard

> Dokumen penyaring ide awal untuk memvalidasi kelayakan teknis, operasional, dan komersial sebelum masuk ke perancangan spesifikasi formal.

---

## 1. Metadata Proyek
- **Nama Ide / Sandi Proyek**: [Contoh: AutoLegalDoc / VaultSign]
- **Inisiator / Solo Dev**: [Nama Anda]
- **Tanggal Evaluasi**: [YYYY-MM-DD]
- **Target Skala Awal**: [Kecil (MVP) / Menengah (SaaS) / Besar / Enterprise]

---

## 2. Ringkasan Ide (Elevator Pitch)
> **Format Formula**: Untuk **[Target Pengguna]** yang mengalami **[Masalah Spesifik]**, **[Nama Produk]** adalah solusi **[Kategori Perangkat Lunak]** yang mampu **[Manfaat Inti / Nilai Unik]**, berbeda dari alternatif manual/eksisting karena **[Keunggulan Pembeda]**.

- **Elevator Pitch**: 
  *[Tuliskan 1–2 kalimat rangkuman berdasarkan formula di atas]*

---

## 3. Hasil Saringan 3 Lapis (The 3-Filter Triage)

### 3.1 Problem Statement (Masalah Riil)
- **Masalah Utama**: [Jelaskan pain point terbesar pengguna saat ini]
- **Solusi Alternatif Saat Ini**: [Bagaimana cara mereka menyelesaikan masalah ini sekarang? Contoh: Excel manual, jasa notaris mahal, template Google Drive]
- **Dampak Buruk Jika Tidak Diselesaikan**: [Risiko waktu hilang, kebocoran data rahasia, kesalahan klausul hukum]

### 3.2 Core User Loop (Alur Utama 3 Langkah)
1. **Langkah 1 (Input)**: [Contoh: Pengguna memilih template NDA dan mengisi form data para pihak]
2. **Langkah 2 (Proses)**: [Contoh: Sistem merender dokumen PDF resmi dan membubuhkan link verifikasi tanda tangan]
3. **Langkah 3 (Output / Value)**: [Contoh: Para pihak menandatangani digital, dokumen terenkripsi otomatis tersimpan di vault aman]

### 3.3 Pemotongan Fitur Ekstrem (The MVP Razor)

| Fitur Masuk Rilis Pertama (In-Scope MVP) | Fitur Dibuang / Ditunda ke Fase Lanjutan (Out-of-Scope) |
| :--- | :--- |
| • [Fitur Inti 1: Misal Template NDA & Kontrak Freelance] | • [Fitur Ditunda: Pembuat Invoice otomatis] |
| • [Fitur Inti 2: Tanda tangan canvas + hash audit trail] | • [Fitur Ditunda: Integrasi e-Meterai Peruri / PSrE Berbayar] |
| • [Fitur Inti 3: Penyimpanan terenkripsi dasar S3 AES-256] | • [Fitur Ditunda: Multi-team workspace & custom branding] |

---

## 4. Kartu Skor Kelayakan Solo Developer (Feasibility Scorecard)

*Beri nilai 1 (Sangat Buruk / Tidak Layak) sampai 5 (Sangat Bagus / Sangat Layak)*

| Dimensi Kelayakan | Skor (1–5) | Analisis & Justifikasi Solo Developer |
| :--- | :---: | :--- |
| **1. Kelayakan Teknis (Technical)** | [ ] / 5 | [Apakah teknologi & pustaka sudah matang? Ada kendala komputasi berat?] |
| **2. Kelayakan Bandwidth (Solo Effort)** | [ ] / 5 | [Bisakah diselesaikan solo dalam 2–8 minggu? Beban maintenance harian?] |
| **3. Kelayakan Regulasi & Legal (Compliance)** | [ ] / 5 | [Apakah melanggar izin hukum/OJK/Kominfo? Kepatuhan data sensitif/UU PDP?] |
| **4. Kelayakan Komersial / Nilai Proyek (Economic)**| [ ] / 5 | [Apakah ada willingness to pay? Berapa potensi margin atau nilai kontrak?] |
| **TOTAL SKOR RATA-RATA** | **[ ] / 5** | *(Total nilai dibagi 4)* |

### Keputusan Gerbang (Gate Decision)
- [ ] **GO (Lolos)**: Skor rata-rata $\ge 3.5$ dan tidak ada dimensi yang bernilai $< 3$. Lanjut ke Modul 02.
- [ ] **PIVOT (Sesuaikan)**: Ada dimensi bernilai $< 3$ (misal: regulasi terlalu rumit). Pangkas fitur agar kembali layak.
- [ ] **KILL (Gugurkan)**: Masalah tidak nyata, biaya teknis terlalu tinggi untuk solo dev, atau risiko hukum berat.

---

## 5. Parameter Klasifikasi Skala yang Ditetapkan

- **Skala Terpilih**: `[Kecil / Menengah / Besar / Enterprise]`
- **Alasan Pemilihan**: [Sebutkan alasan penentuan tier berdasarkan kompleksitas dan kepatuhan hukum]
- **Target Waktu Pengembangan**: [Contoh: 3 Minggu untuk MVP]

---

## 6. Tindak Lanjut ke Modul 02: Discovery & Scope
Daftar pertanyaan yang harus dijawab pada sesi discovery berikutnya:
1. [Pertanyaan 1: Misal: Pustaka PDF generator mana yang paling stabil untuk Node.js?]
2. [Pertanyaan 2: Misal: Bagaimana arsitektur penyimpanan kunci enkripsi per-user?]
3. [Pertanyaan 3: Misal: Apakah format audit trail tanda tangan sudah memenuhi KUHPerdata Pasal 1865?]
