# Modul 08: Data Migration & Seeding (Migrasi Data Warisan & Penyemaian Data)

> ⚠️ **MANDATORY: Load references BEFORE executing this module**:
> - `references/improvements/MODUL_08_IMPROVEMENTS.md` (Spreadsheet Hell avoidance, ETL automation with Zod, Batching, PII masking UU PDP, Data Sign-Off, timeline estimation 11-164 jam, data quality pre-flight checklist 6-step, error handling strategy matrix 3-tier, incremental migration strategy, production migration 3 strategies)
> - `references/technical/DATA_ASSETS_MANAGEMENT.md` (Seed data structure, Reference data (city/bank list), Versioning regulations data, Content data management)
>
> Load via: `skill_view(name='solo-project-lifecycle', file_path='references/improvements/MODUL_08_IMPROVEMENTS.md')`

Modul ini adalah tahap kedelapan dalam siklus hidup proyek perangkat lunak untuk solo developer. Tujuannya adalah memindahkan data warisan (*legacy data*) milik klien (dari Excel, CSV, sistem lama, atau database usang) ke dalam skema database baru secara otomatis, terenkripsi, dan tervalidasi sebelum sesi pengujian pengguna (UAT) di Modul 09 dimulai.

---

## 1. Siklus Eksekusi Modul 08

```text
[ INPUT: Data Mentah Klien (CSV/Excel/SQL) & Skema Database FSD.md ]
                                    │
                                    ▼
[ LANGKAH 1: Audit Data Sumber & Penetapan Batas Tanggung Jawab ]
  • Aturan Clean-In / Clean-Out: Klien bertanggung jawab membersihkan data (Data Hygiene)
  • Developer HANYA menulis skrip transformasi otomatis (ETL)
                                    │
                                    ▼
[ LANGKAH 2: Penyusunan Matriks Pemetaan Kolom (Data Mapping) ]
  • Pemetaan Kolom Sumber ──► Kolom Database Baru (Tipe Data, Default Values)
  • Normalisasi Relasi Entitas & Transformasi Format (Tanggal, Rupiah, Enum)
                                    │
                                    ▼
[ LANGKAH 3: Masking & Sanitasi Data Sensitif Staging (UU PDP) ]
  • Masking Data PII (NIK, Nomor Rekening, Password Lama) di Server Staging
  • Pencegahan Kebocoran Data Pribadi Nyata ke Lingkungan Non-Produksi
                                    │
                                    ▼
[ LANGKAH 4: Eksekusi Skrip ETL Berbasis Transaksi Atomik (Batch Load) ]
  • Ekstraksi (Parse file) ──► Transformasi (Zod Validation) ──► Load (Batch Insert)
  • Pembungkusan dalam Blok Transaksi Database (Rollback Otomatis jika Error)
                                    │
                                    ▼
[ LANGKAH 5: Rekonsiliasi Data & Pengesahan Klien (Data Sign-Off) ]
  • Perhitungan Baris Sumber vs Baris Terimpor (100% Match)
  • Penyusunan Dokumen MIGRATION_RECONCILIATION_REPORT.md
  • Single PIC Klien Menandatangani Persetujuan Data
                                    │
                                    ▼
[ OUTPUT: Database Staging Terisi Data Riil (PII Masked) & RECONCILIATION_REPORT.md ]

⚠️ PENTING: Modul ini hanya mengimpor data ke Staging. 
Migrasi data ke Production dilakukan terpisah di Modul 10 (3 opsi: ETL re-run, staging dump, atau manual CSV).
                                    │
                                    ▼
──► Siap Masuk ke Modul 09: UAT & Client Sign-Off
```

---

## 2. Prinsip Migrasi Solo Developer: "Clean-In, Clean-Out"

Salah satu jebakan terbesar yang menghabiskan waktu solo developer tanpa dibayar adalah **"Membersihkan Data Rusak Klien Secara Manual"**.

### Aturan Baku Perlindungan Solo Dev:
1. **Klien Pemilik Kebersihan Data (Client Owns Data Hygiene)**:
   - Klien wajib menyerahkan data yang sudah bersih dari baris ganda yang tidak valid, format sel yang rusak, atau data tanpa identitas.
   - Jika klien meminta developer merapikan ribuan baris spreadsheet manual, pekerjaan tersebut **WAJIB dimasukkan ke dalam Change Request (CR) jasa konsultasi data terpisah**.
2. **Validasi Skema Tanpa Pengecualian**:
   - Skrip migrasi wajib memvalidasi setiap baris menggunakan skema Zod/Pydantic.
   - Jika ada baris yang korup, skrip otomatis membuangnya ke file penampung `rejected-rows.csv` dengan keterangan alasan galat (*error reason*), tanpa mematikan seluruh proses.
3. **Kepatuhan Privasi Data (UU PDP No. 27/2022)**:
   - Di lingkungan **Staging**, data pribadi sensitif (NIK, nomor telepon pribadi, kata sandi lama) wajib disamarkan (*masked* / *faked*). 
   - **Production**: Data asli tanpa masking hanya dimasukkan saat migrasi final Modul 10 (3 opsi: ETL re-run, staging dump, atau manual CSV).

---

## 3. Langkah demi Langkah Eksekusi

### Langkah 1: Audit Data Sumber
1. Minta klien menyerahkan data dalam format digital terstruktur (CSV, Excel `.xlsx`, atau SQL Dump).
2. Periksa konsistensi tipe data:
   - Format tanggal (apakah `YYYY-MM-DD`, `DD/MM/YYYY`, atau teks acak).
   - Format angka finansial (apakah mengandung karakter `Rp`, titik, atau koma).
   - Integritas ID relasional (apakah foreign key mengarah ke data yang benar-benar ada).

### Langkah 2: Penyusunan Dokumen Rencana Migrasi (Mapping Matrix)
Susun tabel pemetaan dari format lama ke skema FSD baru:
- Contoh: Kolom Excel `"Nama Lengkap"` $\to$ Kolom SQL `users.full_name` (`VARCHAR(150)`).
- Contoh: Kolom Excel `"Tgl Lahir"` $\to$ Transformasi `new Date(row.tgl)` $\to$ `users.birth_date` (`DATE`).

### Langkah 3: Penulisan Skrip Otomasi ETL (Batch Loading)
Tuliskan skrip eksekusi mandiri (misal: `scripts/migrate-data.ts` atau script Python):
1. **Extract**: Baca berkas sumber menggunakan stream parser (`csv-parse` atau `exceljs`).
2. **Transform**: Validasi tiap baris dengan Zod. Generate UUIDv7 untuk primary key baru. Hash kata sandi sementara menggunakan Argon2id.
3. **Load**: Masukkan data ke database menggunakan operasi *Batch Insert* (`createMany` atau SQL `COPY`) per blok 500–1.000 baris di dalam transaksi atomik (`db.$transaction`).

### Langkah 4: Rekonsiliasi & Penanganan Baris Ditolak
1. Skrip menghitung:
   - Total baris di berkas sumber: $N_{\text{source}}$
   - Total baris berhasil diimpor: $N_{\text{imported}}$
   - Total baris gagal/korup: $N_{\text{rejected}}$
2. Seluruh baris yang gagal otomatis diekspor ke `rejected-rows.csv` lengkap dengan nomor baris dan pesan error validasinya.
3. Berikan berkas `rejected-rows.csv` kepada Klien untuk diperbaiki oleh tim operasional mereka.

### Langkah 5: Pengesahan Data Bersama Klien
1. Tampilkan dashboard Staging yang kini sudah menampilkan data riil milik klien (bukan data dummy "Lorem Ipsum").
2. Kirim berkas **`MIGRATION_RECONCILIATION_REPORT.md`** kepada Single PIC Klien.
3. Klien menandatangani lembar persetujuan data (*Data Sign-Off*).

---

## 4. Adaptasi Berdasarkan Skala Proyek

| Aspek Migrasi Data | Skala Kecil (MVP / Freelance) | Skala Menengah (B2B SaaS / Agensi) | Skala Besar & Enterprise |
| :--- | :--- | :--- | :--- |
| **Volume Data** | $< 1.000$ baris data | $1.000 – 100.000$ baris data | $> 100.000$ baris data / Multi-database |
| **Format Sumber** | File Excel tunggal / CSV | Beberapa file Excel + Database MySQL lama | Database Oracle/SAP, legacy API, data terdistribusi |
| **Metode Eksekusi** | Skrip TypeScript sederhana satu kali jalan | Skrip ETL terstruktur dengan batching & logging | ETL Pipeline modular, rollback plan bertingkat |
| **Sanitasi PII Staging** | Ganti nama & email generik | Skrip masking otomatis NIK & telepon | Data Anonymization Engine sesuai audit ISO/PDP |
| **Formalitas Sign-Off** | Konfirmasi via chat/email tertulis | Lembar `RECONCILIATION_REPORT.md` signed | Berita Acara Migrasi Data Resmi bermeterai |

---

## 5. Artefak Keluaran (Deliverables)

> 📁 **ATURAN LOKASI BERKAS MUTLAK**:
> Dokumen rencana migrasi dan laporan rekonsiliasi data WAJIB disimpan di folder **`docs/pm/`**.

Modul ini menghasilkan 3 artefak utama:
1. **`docs/pm/DATA_MIGRATION_PLAN.md`**: Dokumen pemetaan kolom sumber ke target, aturan transformasi, dan batas kepemilikan data (menggunakan `templates/05-data-migration/DATA_MIGRATION_PLAN_TEMPLATE.md`).
2. **`docs/pm/MIGRATION_RECONCILIATION_REPORT.md`**: Laporan bukti perbandingan jumlah data sumber vs target, daftar baris ditolak, dan lembar persetujuan PIC Klien (menggunakan `templates/05-data-migration/RECONCILIATION_REPORT_TEMPLATE.md`).
3. **Database Staging Terisi Data Riil**: Basis data di server Staging yang telah siap digunakan untuk sesi pengujian UAT.

---

## 6. Kriteria Kelulusan [GATE] (Gate Exit Criteria)

[GATE] Modul 08 dinyatakan **LOLOS (PASS)** jika:
- [x] Dokumen pemetaan kolom (`docs/pm/DATA_MIGRATION_PLAN.md`) telah disepakati.
- [x] Skrip ETL berhasil mengimpor seluruh data valid tanpa memicu integritas foreign key error.
- [x] Data sensitif di server Staging telah disanitasi/disamarkan sesuai UU PDP.
- [x] Seluruh baris gagal telah diekspor ke `rejected-rows.csv` dan diserahkan ke klien.
- [x] **Single PIC Klien telah menandatangani lembar pengesahan rekonsiliasi data.**

---

## 🛑 PROTOKOL [GATE] KELUAR & WAJIB BERHENTI

Setelah data berhasil dimigrasi dan laporan rekonsiliasi terbit:
1. **DILARANG KERAS langsung melanjutkan atau memanggil tool untuk Modul 09 dalam giliran (turn) yang sama!**
2. Tampilkan ringkasan rekonsiliasi data (jumlah baris sukses vs ditolak) kepada pengguna.
3. **AKHIRI RESPON ANDA (END TURN)** dan ajukan konfirmasi kepada pengguna:
   > *"Data telah berhasil dimigrasi ke database Staging dengan akurasi rekonsiliasi terverifikasi. Apakah data ini disetujui (Data Sign-Off) sebelum kita membuka sesi pengujian pengguna di Modul 09 (UAT & Sign-Off)?"*
4. Tunggu respon persetujuan eksplisit dari pengguna sebelum melangkah ke Modul 09.
