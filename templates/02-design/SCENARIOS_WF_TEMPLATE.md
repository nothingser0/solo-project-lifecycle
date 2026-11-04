# SPESIFIKASI SKENARIO PENGUJIAN & ALUR PENGGUNA (RUNBOOK)
## [WF-XX]: [Nama Wireflow / Fitur Layar] ([SCR-XX])

> **Modul**: M04 · UI/UX & Prototyping (Transisi ke M05 Arsitektur Teknis / M06 Implementasi Frontend & Backend)  
> **Lokasi Output**: `docs/specs/wireflows/[WF-XX]_SCENARIOS.md`  
> **Acuan Desain**: `docs/design/screens/[role]/[screen-file].html`  
> **Fitur Terkait**: **[F-XX]** ([Nama Fitur P0/P1]), **[F-YY]** ([Fitur Terkait])  
> **User Stories / Task KANBAN**: `[ID-001]` ([Judul User Story/Epic])  
> **Hak Akses Layar**: [Publik / Member / Staff / Admin / Multi-Role]  

---

## 1. Ringkasan Eksekutif Layar & Arsitektur Visual

Layar **[WF-XX] (`[SCR-XX]`)** berfungsi sebagai [penjelasan tujuan fungsional layar dan perannya dalam alur sistem].

Prinsip arsitektural dan tata letak layar:
1. **[Prinsip 1, e.g. Single Entry Point / Clean Data Density]**: [Penjelasan]
2. **[Prinsip 2, e.g. RBAC Boundary & Data Masking]**: [Penjelasan pembatasan aksi]
3. **[Prinsip 3, e.g. Feedback & Graceful Fallback]**: [Penjelasan interaksi]

```text
┌──────────────────────────────────────────────────────────────────────────────────┐
│                           [WF-XX] WORKBENCH ARSITEKTUR LAYAR                     │
├────────────────────────────────────────┬─────────────────────────────────────────┤
│ 1. PANEL / SEKSI UTAMA KIRI            │ 2. PANEL / SEKSI KANAN / DETAIL         │
│    • Komponen A (Navigasi / Filter)    │    • Komponen B (Data Grid / Form)      │
│    • Action Bar                        │    • 5-State Indicators (Empty/Error)   │
└────────────────────────────────────────┴─────────────────────────────────────────┘
```

---

## 2. Matriks Data Baseline (Fixture Testing)

*Data rujukan awal (seed/fixture) yang digunakan untuk simulasi pengujian interaktif prototipe dan verifikasi M06/M07:*

| ID Akun | Peran (Role) | Nama Pengguna | Kredensial / Email Uji | Kata Sandi Uji | Entitas / Scope Data | Target Rute Pasca-Aksi | Lingkup Wewenang & Batasan Akses |
|---|---|---|---|---|---|---|---|
| **USR-01** | **[Peran Utama, e.g. Admin/Owner]** | [Nama Akun 1] | `admin@example.com` | `password123` | [Akses Penuh / Semua Cabang] | `/admin/dashboard` | **Akses Penuh**: Dapat mengelola semua data, mutasi finansial, dan audit log. |
| **USR-02** | **[Peran Staf, e.g. Operator]** | [Nama Akun 2] | `staff@example.com` | `password123` | [Operasional Lapangan] | `/ops/workspace` | **Operasional Terbatas**: Menginput transaksi harian; diblokir dari laporan laba bersih. |
| **USR-03** | **[Peran Customer/Member]** | [Nama Akun 3] | `user@example.com` | `password123` | [Data Pribadi Saja] | `/user/dashboard` | **Data Terisolasi**: Hanya melihat catatan miliknya sendiri. |
| **USR-04** | **[Akun Nonaktif / Disabled]** | [Nama Akun 4] | `disabled@example.com` | `password123` | [Akses Dicabut] | Ditolak (`403 Forbidden`) | **Akses Dibekukan**: Sistem menolak akses dengan toast peringatan. |
| **USR-05** | **[Akun Kedaluwarsa / Alumni]** | [Nama Akun 5] | `expired@example.com` | `password123` | [Arsip Riwayat Saja] | Mode Read-Only | **Mode Arsip**: Hanya dapat mengunduh riwayat; dilarang membuat mutasi baru. |

---

## 3. Daftar Skenario End-to-End Terperinci

---

### SKENARIO 01 (SK-01): [Nama Skenario Happy Path Utama, e.g. Eksekusi Berhasil sebagai Admin]
- **Tujuan**: Memastikan alur utama berjalan mulus sesuai harapan nominal (*Happy Path*).
- **Kondisi Awal (Pre-condition)**: [Status sesi pengguna dan data awal di layar].
- **Langkah-langkah**:
  1. [Langkah 1: Pengguna mengklik atau menginput data valid].
  2. [Langkah 2: Pengguna menekan tombol aksi utama].
- **Hasil Diharapkan**:
  - Validasi formulir lolos tanpa pesan error.
  - Tampil indikator proses (Loading spinner / disable sementara pada tombol aksi).
  - Toast / notifikasi sukses tampil: *"[Pesan sukses konkret]"* (Tipe: `success`).
  - Browser melakukan transisi / pengalihan ke `[Rute Target]`.

---

### SKENARIO 02 (SK-02): [Nama Skenario Happy Path Peran Berbeda, e.g. Akses Staf dengan Pembatasan Wewenang]
- **Tujuan**: Memastikan segmentasi hak akses dan data masking bekerja secara akurat.
- **Kondisi Awal**: [Pengguna login sebagai staf operasional].
- **Langkah-langkah**:
  1. [Buka halaman / lakukan aksi sebagai staf].
- **Hasil Diharapkan**:
  - Sistem menampilkan elemen khusus staf.
  - Data sensitif (misal: laba, omzet total, kunci API) disembunyikan / di-masking secara visual.
  - Menu yang dilarang tidak dapat diakses atau diarahkan ke rute izin.

---

### SKENARIO 03 (SK-03): [Skenario Sad Path 1: Validasi Field Kosong / Format Salah]
- **Tujuan**: Memastikan validasi sisi klien bekerja sebelum request dikirim (*Anti-Disabled Pristine*).
- **Kondisi Awal**: Formulir berada pada kondisi kosong atau berisi format tidak valid.
- **Langkah-langkah**:
  1. Kosongkan field wajib -> Klik tombol kirim.
  2. Masukkan format tidak valid (misal: email tanpa `@` atau angka negatif).
- **Hasil Diharapkan**:
  - Form submit dicegah seketika.
  - Muncul pesan error inline di bawah field terkait (font ≥13px, kontras ≥4.5:1).
  - Kursor otomatis fokus (*autofocus*) ke input pertama yang bermasalah dengan highlight border merah.

---

### SKENARIO 04 (SK-04): [Skenario Sad Path 2: Kredensial Salah / Penolakan Otorisasi]
- **Tujuan**: Menguji penanganan umpan balik saat kredensial salah atau aksi ditolak server.
- **Kondisi Awal**: Pengguna memasukkan data yang tidak cocok atau akun tidak memiliki wewenang.
- **Langkah-langkah**:
  1. Klik tombol submit dengan data yang salah -> Amati respons UI.
- **Hasil Diharapkan**:
  - Tombol submit menampilkan loading sejenak.
  - Tampil Toast Bahaya / Error Banner: *"[Pesan error informatif dan santun]"*.
  - Field input dibersihkan / di-reset sesuai standar keamanan tanpa memuat ulang seluruh halaman (*no full reload*).

---

### SKENARIO 05 (SK-05): [Skenario Edge Case Domain 1: Akun Dinonaktifkan / Akses Kedaluwarsa]
- **Tujuan**: Memverifikasi penanganan akun berstatus dibekukan / kontrak berakhir.
- **Kondisi Awal**: Pengguna dengan status `disabled` atau `alumni` mencoba melakukan aksi.
- **Langkah-langkah**:
  1. Input data akun USR-04 (Disabled) -> Klik submit.
- **Hasil Diharapkan**:
  - Sistem menolak aksi dengan respons `HTTP 403 Forbidden`.
  - Tampil Modal Peringatan / Toast: *"Akun Anda sedang dinonaktifkan. Silakan hubungi pengelola."*
  - Pengguna tidak diberi akses masuk ke dasbor aktif.

---

### SKENARIO 06 (SK-06): [Skenario Edge Case Domain 2: Multi-Entitas / Seleksi Data Kompleks]
- **Tujuan**: Memastikan alur untuk pengguna yang memiliki banyak data/kamar/cabang berjalan mulus.
- **Kondisi Awal**: Pengguna memiliki lebih dari 1 entitas terkait.
- **Langkah-langkah**:
  1. Masuk ke halaman -> Buka switcher entitas/kamar.
  2. Pilih entitas B -> Amati pembaruan konteks data.
- **Hasil Diharapkan**:
  - Seluruh data tabel/dashboard ter-filter secara dinamis sesuai entitas yang dipilih tanpa terjadi kebocoran data silang (*zero cross-tenant leak*).

---

### SKENARIO 07 (SK-07): [Skenario Ketahanan Jaringan & Recovery: Network Timeout / Server 500]
- **Tujuan**: Menguji ketahanan UI saat jaringan terputus atau server mengembalikan error 500.
- **Kondisi Awal**: Simulasi koneksi offline atau server timeout.
- **Langkah-langkah**:
  1. Matikan koneksi / picu respons gagal -> Klik aksi muat ulang / submit.
- **Hasil Diharapkan**:
  - Tampil Banner / Toast Error: *"Koneksi terputus. Silakan periksa jaringan Anda."*
  - Muncul tombol aksi **"Coba Lagi (Retry)"**.
  - Toast error **TIDAK HILANG OTOMATIS** (*non-dismissing error rule*) sampai pengguna menutupnya atau jaringan pulih.
