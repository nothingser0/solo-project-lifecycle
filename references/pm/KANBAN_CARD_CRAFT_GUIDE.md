# Kanban Card Craft Guide (Solo Developer & Jira Optimization)

> **Purpose**: Reusable standard for writing scannable, punchy, and actionable Kanban cards for Solo Developers—eliminating manual field redundancy via Jira automation while maintaining strict quality gates.
> **Context**: Applied in **M02 (Scope Definition)** when creating the backlog, and throughout **M06–M13** for sprint execution. Complements `EPIC_BREAKDOWN_PATTERNS.md` (splitting) and `PM_PRIORITIZATION_FRAMEWORKS.md` (ranking).

---

## 1. Optimisasi Workflow & WIP Limits

Untuk menjaga fokus solo developer dan mencegah *context switching*:

```text
Backlog ──► To Do (5) ──► In Progress (2) ──► In Review (1) ──► Done
```

| Status | WIP Limit | Penjelasan Transisi Status (Maks. 1 Kalimat) |
|---|:---:|---|
| **Backlog** | ∞ | Menampung seluruh ide, tiket, dan kebutuhan fitur yang belum diprioritaskan untuk iterasi aktif. |
| **To Do** | **5** | Item yang sudah siap dikerjakan dengan spesifikasi jelas dan menunggu ditarik saat kapasitas WIP tersedia. |
| **In Progress** | **2** | Pekerjaan yang sedang aktif dikerjakan oleh developer (ideal 1 fokus utama per waktu). |
| **In Review** | **1** | Tahap pemeriksaan mandiri (self-review diff, validasi AC, uji akses) sebelum dinyatakan tuntas. |
| **Done** | ∞ | Seluruh acceptance criteria terpenuhi, lulus pengujian, dan hasil telah diterima. |

---

## 2. Otomatisasi Field (Eliminasi Redundansi Solo Project)

Karena proyek solo dikerjakan secara mandiri, hapus redundansi penulisan manual di setiap kartu:
- **Assignee**: Secara otomatis diatur via Jira Automation ke **"Assign to me"** saat kartu ditarik ke `In Progress`. **Tidak perlu ditulis manual di setiap kartu individual.**
- **Labels**: Hapus label `Solo` dari semua kartu karena seluruh board sudah pasti dikerjakan sendiri. Gunakan label **HANYA untuk kondisi khusus**, misalnya `blocked`.
- **Due Date**: Ditetapkan sebagai aturan global: **kosongkan kecuali ada hard deadline eksternal yang mengikat**. Baris due date dihapus dari setiap kartu individual.

---

## 3. Struktur Kartu yang Punchy dan Ringkas (Scannable)

Setiap kartu HANYA boleh berisi komponen berikut dalam baris-baris pendek scannable:
1. **ID & Judul**: Format `[ID] [Work Type] — Judul Singkat` (Contoh: `RK-019 [Story] — Masuk dan Keluar Akun`).
2. **Parent**: ID parent Epic jika kartu merupakan anak dari Epic (misal `Parent: RK-001`). Omit atau tulis `None` untuk kartu level Epic/mandiri.
3. **Priority**: Tingkat urgensi Jira (`Highest` / `High` / `Medium` / `Low`).
4. **Description**: **Maksimal 2 kalimat padat** yang langsung menjelaskan nilai atau deliverable konkret (bukan mengulang summary atau menyalin spesifikasi penuh).
5. **Acceptance Criteria**: Poin-poin checklist pendek (`- [ ] ...`) yang langsung dapat diverifikasi, tanpa kalimat berbunga-bunga.
6. **Estimate**: Estimasi durasi dalam jam (`X hours` atau `X–Y hours`).
7. **Dependencies**: Prasyarat kartu lain sebelum kartu ini bisa dikerjakan (`ID kartu` atau `None`).

---

## 4. Contoh Kartu Scannable per Work Type

Berikut 6 contoh kartu board scannable yang menerapkan seluruh optimisasi di atas:

### 1. Epic

```markdown
### [EPIC-01] [Epic] — Inventory Management Module
- **Priority**: Highest
- **Description**: Sediakan visibilitas stok multi-lokasi dan alur approval opname untuk memangkas phantom inventory. Menjadi sumber data terpusat transaksi masuk, keluar, dan penyesuaian barang.
- **Acceptance Criteria**:
  - [ ] Modul mencatat transaksi stock-in, stock-out, dan manual adjustment.
  - [ ] Filter stok berfungsi per lokasi toko.
  - [ ] Approval adjustment mewajibkan persetujuan Owner tanpa self-approval Manager.
- **Estimate**: 80–120 hours
- **Dependencies**: None
```

### 2. Story

```markdown
### [STORY-01] [Story] — Kasir POS Checkout & Cetak Struk
- **Parent**: EPIC-01
- **Priority**: Highest
- **Description**: Ring up transaksi penjualan walk-in dalam waktu <30 detik dengan pemotongan stok otomatis. Menghasilkan struk thermal 58mm/80mm di sisi client tanpa serverless PDF.
- **Acceptance Criteria**:
  - [ ] Kasir dapat mencari produk by SKU/nama dan memasukkan ke keranjang.
  - [ ] Stok berkurang otomatis secara atomic dalam satu database transaction.
  - [ ] Struk thermal siap cetak dalam waktu <2 detik setelah konfirmasi bayar.
- **Estimate**: 6–8 hours
- **Dependencies**: TASK-01
```

### 3. Task

```markdown
### [TASK-01] [Task] — Migrasi Skema Append-Only inventory_movements
- **Parent**: EPIC-01
- **Priority**: Highest
- **Description**: Buat migrasi tabel riwayat mutasi stok append-only tanpa kolom balance_after untuk mencegah race condition. Hitung saldo stok real-time melalui agregasi query SUM.
- **Acceptance Criteria**:
  - [ ] Tabel memiliki kolom quantity bertipe DECIMAL(12,3) dan indeks foreign key lengkap.
  - [ ] RLS policy mengisolasi data per org_id melalui public.user_roles.
  - [ ] Constraint CHECK mencegah nilai kuantitas nol.
- **Estimate**: 2–3 hours
- **Dependencies**: None
```

### 4. Bug

```markdown
### [BUG-01] [Bug] — Fix: Saldo Minus pada Form Adjustment
- **Parent**: EPIC-01
- **Priority**: Highest
- **Description**: Form adjustment menerima kuantitas negatif yang melebihi stok fisik dan memicu saldo minus. Tambahkan validasi ketersediaan stok sebelum eksekusi mutasi.
- **Acceptance Criteria**:
  - [ ] Server action menolak pengurangan kuantitas yang melebihi stok fisik (HTTP 422).
  - [ ] Form menampilkan pesan error validasi yang jelas bagi operator.
  - [ ] Mutasi ditolak tanpa meninggalkan data parsial di database.
- **Estimate**: 1–2 hours
- **Dependencies**: None
```

### 5. Spike

```markdown
### [SPIKE-01] [Spike] — Evaluasi Reliabilitas Midtrans Snap vs Xendit Invoice
- **Priority**: High
- **Description**: Uji keandalan webhook dan latensi redirect pembayaran di sandbox untuk menentukan provider pembayaran SaaS. Dokumentasikan perbandingan ke DECISION_LOG.md.
- **Acceptance Criteria**:
  - [ ] Kirim 10 payload webhook uji ke tiap provider dan catat delivery rate.
  - [ ] Uji responsivitas checkout redirect pada mobile viewport.
  - [ ] Catat rekomendasi keputusan final di docs/DECISION_LOG.md.
- **Estimate**: 4 hours
- **Dependencies**: None
```

### 6. Chore

```markdown
### [CHORE-01] [Chore] — Migrasi Tailwind CSS v3 ke v4
- **Priority**: Medium
- **Description**: Ganti konfigurasi tailwind.config.ts ke arsitektur CSS-first @theme v4. Memastikan keselarasan token desain tanpa mengubah tampilan komponen pengguna.
- **Acceptance Criteria**:
  - [ ] Build lokal dan typecheck lulus dengan exit code 0.
  - [ ] Token warna dan tipografi di globals.css berfungsi normal.
  - [ ] Zero visual regression pada seluruh layar yang sudah ada.
- **Estimate**: 4–6 hours
- **Dependencies**: None
```

---

## 5. Work Type vs Priority — Dua Dimensi Berbeda

Work Type mengklasifikasikan **karakter pekerjaan**, sedangkan Priority menentukan **urutan eksekusi**. Keduanya independen:

| Dimensi | Pertanyaan yang Dijawab | Nilai / Opsi |
|---|---|---|
| **Work Type** | *Apa sifat pekerjaan ini?* | `Epic` · `Story` · `Task` · `Bug` · `Spike` · `Chore` |
| **Priority Jira** | *Seberapa cepat harus dikerjakan?* | `Highest` (P0) · `High` (P1) · `Medium` (P2) · `Low` (P3) |

Contoh independensi:
- Bug typo label $\rightarrow$ Work Type: `Bug`, Priority: `Low`
- Bug saldo minus $\rightarrow$ Work Type: `Bug`, Priority: `Highest`
- Upgrade dependency berkala $\rightarrow$ Work Type: `Chore`, Priority: `Medium`
- Fitur login launch MVP $\rightarrow$ Work Type: `Story`, Priority: `Highest`

---

## 6. Quick Reference Card Skeleton (Scannable Solo Standard)

Gunakan template ringkas berikut saat membuat kartu baru:

```markdown
### [ID] [Work Type] — Judul Singkat
- **Parent**: <ID Epic bila kartu anak, atau hapus baris ini>
- **Priority**: Highest | High | Medium | Low
- **Description**: <Maksimal 2 kalimat padat yang langsung menjelaskan nilai/deliverable konkret>.
- **Acceptance Criteria**:
  - [ ] <Kriteria 1 - checklist singkat dan konkret>
  - [ ] <Kriteria 2 - checklist singkat dan konkret>
- **Estimate**: <X hours / X–Y hours>
- **Dependencies**: <ID kartu atau None>
```

---

## 7. Pemetaan ke `TODO.md` (M06 Development Execution)

Ketika kartu ditarik ke Sprint Coding di Module 06, kartu Story/Task ditranslasikan ke `TODO.md` menjadi checklist tugas atomik (<2 jam):

| Kartu Kanban (Scannable) | Task di `TODO.md` |
|---|---|
| `[ID]` + `Judul` | Task ID (`M06-FE-01`) + Title |
| `Description` | Action |
| `Acceptance Criteria` | Expected & Verify Command |
| `Dependencies` | Depends |
| `Estimate` | Posisi sprint dan batas turn eksekusi |
