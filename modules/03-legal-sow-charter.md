# Modul 03: [GATE KOMERSIAL] Legal SOW, DP, & Single PIC Agreement

> ⚠️ **MANDATORY: Load references BEFORE executing this module**:
> - `references/improvements/MODUL_03_IMPROVEMENTS.md` (Scope creep rejection tactics, Change Request formula, Single PIC enforcement, Work Pause protocol, timeline estimation, SOW legal clauses, Payment term calculator, IP ownership templates, Change request pricing)
>
> Load via: `skill_view(name='solo-project-lifecycle', file_path='references/improvements/MODUL_03_IMPROVEMENTS.md')`

Modul ini adalah **GERBANG KOMERSIAL PEMBLOKIR (BLOCKING GATE)** dalam siklus hidup proyek solo developer. Aturan fundamental: **TIDAK ADA SATU BARIS KODE ATAU DESAIN DETAIL YANG DIKERJAKAN SEBELUM GERBANG INI LOLOS.**

Tujuannya adalah mengikat dokumen `SCOPE_STATEMENT.md` ke dalam perjanjian legal berkekuatan hukum, mengamankan uang muka (Down Payment), mengunci Single PIC dari pihak klien, dan menetapkan protokol Change Request.

---

## 1. Siklus Eksekusi Modul 03

```text
[ INPUT: Dokumen SCOPE_STATEMENT.md dari Modul 02 ]
                         │
                         ▼
[ LANGKAH 1: Penentuan Model Kontrak & Estimasi Komersial ]
  • Fixed-Price Milestone (Skala Kecil & Menengah)
  • Time & Materials / Retainer Bulanan (Skala Besar & Fleksibel)
                         │
                         ▼
[ LANGKAH 2: Penguncian Struktur Termin Pembayaran (Payment Milestones) ]
  • Termin 1 (DP 30–50%): Prasyarat memulai riset teknis & UI/UX
  • Termin Antara (Alpha/Beta): Terikat pada verifikasi deliverable
  • Termin Akhir (Pelunasan 100%): Prasyarat penyerahan repo & BAST
                         │
                         ▼
[ LANGKAH 3: Pengikatan Klausul Single PIC & SLA Respon ]
  • 1 Pengambil Keputusan Mutlak dari Pihak Klien
  • SLA Review Klien Maksimal 3 Hari Kerja (Keterlambatan = Geser Jadwal)
                         │
                         ▼
[ LANGKAH 4: Penetapan Klausul Proteksi Hukum Solo Developer ]
  • Batasan Tanggung Jawab (Liability Cap = Maksimal Nilai Kontrak)
  • Kepemilikan Source Code (IP ditahan sampai lunas 100%)
  • Protokol Perubahan Fitur (Change Request / CR Resmi)
                         │
                         ▼
[ OUTPUT: Dokumen SOW_CONTRACT.md & PROJECT_CHARTER.md ]
                         │
          ┌──────────────┴──────────────┐
          ▼                             ▼
    [ DP BELUM DITERIMA ]         [ DP SUDAH DITERIMA & KONTRAK SAH ]
    • JANGAN MULAI KODING         • Lolos Gate Komersial
    • Status: On-Hold             • Lanjut ke Modul 04: UI/UX Design
```

---

## 2. Langkah demi Langkah Eksekusi

### Langkah 1: Memilih Model Kontrak yang Tepat
1. **Fixed-Price (Harga Tetap Berbasis Milestone)**:
   - *Kapan Digunakan*: Lingkup di `SCOPE_STATEMENT.md` sudah sangat jelas dan klien tidak fleksibel terhadap anggaran.
   - *Kunci Solo Dev*: Wajib tambahkan buffer biaya 20–30% untuk mitigasi revisi wajar.
2. **Time & Materials / Monthly Retainer**:
   - *Kapan Digunakan*: Klien memiliki roadmap dinamis (*"fitur dipikirkan sambil jalan"*) atau proyek berskala Besar/Enterprise yang membutuhkan riset berkelanjutan.
   - *Kunci Solo Dev*: Tagihan per bulan atau per blok 40 jam kerja dengan pembayaran di muka setiap awal periode.

---

### Langkah 2: Menetapkan Struktur Termin Pembayaran Bertahap
Sebagai solo developer, jangan pernah menerima pembayaran di akhir proyek (100% saat selesai). Skema termin baku:

| Termin | Milestone / Kondisi Pembayaran | Persentase | Prasyarat Deliverable |
| :---: | :--- | :---: | :--- |
| **Termin 1 (DP)** | Tanda Tangan Kontrak & Inisiasi Proyek | **30% – 50%** | Penyerahan SOW & Project Charter yang disepakati |
| **Termin 2 (Alpha)**| Core Engine & Integrasi Database Selesai | **25% – 30%** | Demo fungsionalitas backend & UI dasar di lokal/staging |
| **Termin 3 (Beta)** | Integrasi Lengkap & Lolos UAT Internal | **20% – 25%** | Aplikasi siap diuji klien di Staging (SIT Pass) |
| **Termin 4 (Final)**| Go-Live Production & Serah Terima Resmi | **10% – 20%** | UAT Sign-off Klien disetujui, siap penyerahan BAST |

---

### Langkah 3: Menegakkan Aturan Single PIC
Klien korporasi sering memiliki banyak kepala yang saling bertolak belakang arahannya.
- Wajib cantumkan nama, jabatan, email, dan nomor telepon **1 orang Single PIC Klien**.
- Seluruh instruksi, persetujuan desain, hasil uji UAT, dan penandatanganan dokumen hanya sah jika ditandatangani oleh Single PIC tersebut.
- Masukkan klausul: *"Instruksi lisan atau permintaan tertulis dari staf klien di luar Single PIC yang ditunjuk tidak memiliki kekuatan mengikat developer."*

---

### Langkah 4: Mengunci Klausul Proteksi Hukum Vital Solo Dev
1. **Hak Kekayaan Intelektual (Intellectual Property / IP)**:
   - Source code, kredensial server, dan lisensi software sepenuhnya tetap menjadi hak milik intelektual Developer sampai seluruh pembayaran termin (100%) lunas.
2. **Batasan Ganti Rugi (Liability Cap)**:
   - Developer tidak bertanggung jawab atas kerugian tidak langsung, hilangnya keuntungan bisnis, atau kebocoran data akibat kelalaian penyimpanan password oleh karyawan klien.
   - Total liabilitas finansial maksimum developer dalam kondisi apapun dibatasi maksimal sebesar total nilai kontrak yang telah dibayarkan oleh klien.
3. **Mekanisme Change Request (CR)**:
   - Setiap fitur tambahan di luar `SCOPE_STATEMENT.md` wajib dituangkan ke lembar CR dengan formula: `Biaya Tambahan = Jam Estimasi x Tarif Per Jam` dan `Jadwal Rilis Bertambah X Hari`.

---

## 3. Adaptasi Berdasarkan Skala Proyek

| Aspek | Skala Kecil (MVP / Freelance) | Skala Menengah (B2B SaaS / Agensi) | Skala Besar & Enterprise |
| :--- | :--- | :--- | :--- |
| **Format Kontrak** | Invoice DP 50% + Scope Statement via Email | Dokumen SOW & Perjanjian Kerja Sama (PKS) | Master Service Agreement (MSA) + SOW formal |
| **Legalitas** | Tanda tangan elektronik (PDF signature) | Tanda tangan basah bermeterai / e-Meterai | Legal review dari tim hukum korporasi klien |
| **Termin DP** | Wajib 50% di muka | Minimal 30–40% di muka | Minimal 20–30% di muka (sesuai SOP korporat) |
| **Klausul NDA** | Cukup klausul kerahasiaan di dalam SOW | Non-Disclosure Agreement (NDA) standar | Mutual NDA formal + klausul UU PDP ketat |

---

## 4. Artefak Keluaran (Deliverables)

> 📁 **ATURAN LOKASI BERKAS MUTLAK**:
> Seluruh berkas Modul 03 WAJIB disimpan di dalam folder **`docs/pm/`** (bukan di root direktori).

1. **`docs/pm/SOW_CONTRACT.md`**: Dokumen kontrak kerja komersial gabungan (Project Charter + SOW) yang mengikat objektif, Single PIC, lingkup, biaya, termin pembayaran, dan klausul hukum (menggunakan template `templates/01-discovery-commercial/SOW_CONTRACT_CONSOLIDATED_TEMPLATE.md`).

> 💡 **ADAPTASI UNTUK SOLO DEV PRODUCT (PRODUK MANDIRI/INTERNAL)**:
> Jika proyek adalah produk mandiri tanpa klien eksternal, kontrak komersial dan penagihan DP dapat disesuaikan untuk internal, **NAMUN `docs/pm/PROJECT_CHARTER.md` TETAP WAJIB DIBUAT** untuk mengunci baseline jadwal, anggaran infrastruktur, dan batasan risiko. DILARANG melewatkan (skip) Modul 03 secara total!

---

## 5. Kriteria Kelulusan [GATE] (Gate Exit Criteria)

[GATE] ini dinyatakan **LOLOS (PASS)** jika dan hanya jika:
- [x] Dokumen `docs/pm/PROJECT_CHARTER.md` telah disahkan.
- [x] Kontrak SOW telah ditandatangani oleh Klien dan Developer (atau disahkan internal untuk solo product).
- [x] Single PIC Klien telah ditunjuk secara resmi.
- [x] **Dana Pembayaran DP (Termin 1) telah masuk dan terkonfirmasi di rekening bank Developer** (atau anggaran mandiri telah dialokasikan).

---

## 🛑 PROTOKOL [GATE] KELUAR & WAJIB BERHENTI

Setelah berkas `docs/pm/PROJECT_CHARTER.md` (dan `docs/pm/SOW_CONTRACT.md`) selesai ditulis:

### **LANGKAH 0: VERIFIKASI EKSISTENSI BERKAS (BLOCKING CHECK)**

**WAJIB DILAKUKAN SEBELUM VALIDASI KONTEN**:

1. **Cek keberadaan file output** menggunakan salah satu metode:
   - PowerShell: `Test-Path -LiteralPath "docs/pm/PROJECT_CHARTER.md"` → harus return `True`
   - Read tool: `read_file('docs/pm/PROJECT_CHARTER.md')` → harus sukses tanpa error
   - PowerShell: `Test-Path -LiteralPath "docs/pm/SOW_CONTRACT.md"` → harus return `True`
   - Read tool: `read_file('docs/pm/SOW_CONTRACT.md')` → harus sukses tanpa error

2. **JIKA FILE TIDAK ADA**:
   - ❌ **STOP IMMEDIATELY** - jangan lanjut validasi konten
   - ❌ **JANGAN tampilkan summary** ke user
   - ❌ **JANGAN ajukan konfirmasi DP**
   - ✅ **REPORT ERROR** ke user:
     ```
     CRITICAL ERROR: File PROJECT_CHARTER.md atau SOW_CONTRACT.md tidak tercipta.
     Module 03 FAILED - tidak bisa lanjut ke Module 04 (UI/UX Design).
     
     Kemungkinan penyebab:
     - Write permission denied pada folder docs/pm/
     - Path typo di tool call
     - Disk full
     
     Tolong investigasi issue ini sebelum lanjut.
     ```
   - ✅ **END TURN** dan tunggu user fix issue

3. **HANYA JIKA FILES EXIST**: Lanjut ke validasi konten di bawah

---

### **LANGKAH 1: VALIDASI KONTEN & DP CONFIRMATION**

1. **DILARANG KERAS langsung melanjutkan atau memanggil tool untuk Modul 04 dalam giliran (turn) yang sama!**
2. **VERIFIKASI KONTEN (Self-Verification Checklist)**:
   - [ ] `read_file('docs/pm/PROJECT_CHARTER.md')` → Confirm baseline dates set
   - [ ] `read_file('docs/pm/SOW_CONTRACT.md')` → Confirm termin structure documented (or BYPASS flag for internal)
   - [ ] Single PIC identified with contact info
   - [ ] Liability cap clause present
3. Tampilkan ringkasan komitmen kepada pengguna:
   - Target tanggal rilis go-live
   - Skema termin pembayaran & nominal DP (atau flag internal project)
   - Batasan risiko utama
4. **AKHIRI RESPON ANDA (END TURN)** dan tampilkan prompt konfirmasi Down Payment:

   ```
   📋 Gate Komersial: Konfirmasi Down Payment
   
   Dokumen SOW dan PROJECT_CHARTER telah selesai.
   
   ❓ Apakah Down Payment sebesar [Rp X] sudah diterima di rekening?
   
   Reply: SUDAH / YES / YA / OK untuk lanjut ke Modul 04 (UI/UX Design)
   Reply: BELUM / NO / NOT YET jika masih menunggu transfer
   
   (Solo dev internal product: reply BYPASS untuk skip DP gate)
   ```

4. **Fuzzy Match Logic**: Accept variations (sudah/SUDAH/yes/YES/ya/ok as CONFIRMED; belum/no/not yet as WAITING; bypass/BYPASS/skip for internal projects)
5. **JANGAN lanjut ke Modul 04** sampai user confirms DP received or bypass for internal
5. Setelah user confirm, log konfirmasi di PROJECT_CHARTER.md footer:
   ```markdown
   ---
   ## Log Konfirmasi Gate
   - **DP Confirmed**: [YYYY-MM-DD HH:MM WIB]
   - **Confirmed By**: [User Name]
   - **Next Module**: 04 (UI/UX Design & Prototyping)
   ```
6. Tunggu respon persetujuan eksplisit dari pengguna sebelum melangkah ke Modul 04.
