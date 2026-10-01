# Modul 02: Discovery & Scope Definition (Elisitasi Kebutuhan & Penguncian Lingkup)

> ⚠️ **MANDATORY: Load references BEFORE executing this module**:
> - `references/checklists/MODUL_02_EVALUATION_CHECKLIST.md` (MoSCoW quality check, User Stories INVEST validation, Database Schema validation, Tech Stack validation, NFR realism check, Timeline buffer, Risk completeness, Scope boundaries)
> - `references/checklists/REQUIREMENT_ELICITATION_GUIDE.md` (Bank pertanyaan elisitasi 5 pilar, Red-flags detection)
> - `references/improvements/MODUL_02_IMPROVEMENTS.md` (Timeline estimation, User story splitting rules, Sprint velocity tracking, Scope freeze protocol)
>
> Load via: `skill_view(name='solo-project-lifecycle', file_path='references/improvements/MODUL_02_IMPROVEMENTS.md')`

Modul ini adalah tahap kedua dalam siklus pengembangan perangkat lunak untuk solo developer. Tujuannya adalah mengekstrak kebutuhan bisnis riil dari pemangku kepentingan (stakeholder/klien), mendefinisikan batasan teknis, dan mengunci batasan **In-Scope vs Out-of-Scope** ke dalam dokumen **`SCOPE_STATEMENT.md`** sebelum masuk ke komitmen kontrak atau perancangan detail.

---

## 1. Siklus Eksekusi Modul 02

```text
[ INPUT: Dokumen IDEA_BRIEF.md dari Modul 01 ]
                      │
                      ▼
[ LANGKAH 1: Wawancara Discovery Terarah (The 5 Pillars) ]
  • Tujuan Bisnis Riil & Metrik Sukses
  • Pemetaan Persona Pengguna & Matriks Hak Akses
                      │
                      ▼
[ LANGKAH 2: Breakdown Fitur & Prioritas MoSCoW ]
  • Must-Have (Fitur Vital Rilis)
  • Should-Have / Could-Have (Fitur Sekunder)
  • Won't-Have (Fitur Ditolak / Ditunda)
                      │
                      ▼
[ LANGKAH 3: Penguncian Batasan Lingkup (Scope Defense) ]
  • Daftar Eksplisit: APA YANG DIBUAT vs APA YANG TIDAK DIBUAT
  • Asumsi Teknis & Batasan Arsitektur Awal
                      │
                      ▼
[ LANGKAH 4: Pendaftaran Ketergantungan Klien (Client Dependencies) ]
  • Data Master, Akses Server, Kredensial API Pihak Ketiga
  • Batas Waktu Penyerahan (Dependency SLA)
                      │
                      ▼
[ LANGKAH 5: Pemetaan Stakeholder & Komunikasi ]
  • Power/Interest Matrix (4 Kuadran)
  • Communication Plan & Escalation Path
  • Expectation Management & RACI Matrix
                      │
                      ▼
[ OUTPUT: Dokumen SCOPE_STATEMENT.md + Stakeholder Artifacts ] ──► Siap Lanjut ke Modul 03: Legal SOW & DP
```

---

## 2. Langkah demi Langkah Eksekusi

### Langkah 1: Wawancara Discovery Terarah
Jalankan wawancara menggunakan panduan di `references/checklists/REQUIREMENT_ELICITATION_GUIDE.md`:
1. **Identifikasi Pengambil Keputusan**: Pastikan orang yang diwawancarai memiliki wewenang final menyetujui fitur.
2. **Bedah Kebutuhan vs Keinginan**: Bedakan kebutuhan inti bisnis (*needs*) dengan fitur pemanis (*nice-to-have wishes*).
3. **Petakan Peran Pengguna (User Roles)**: Tentukan siapa saja yang login ke sistem dan hak akses spesifiknya (misal: Super Admin, Kasir, Pelanggan).

### Langkah 2: Breakdown Fitur & Prioritisasi MoSCoW
Setiap modul dipecah menjadi fitur spesifik dengan label prioritas:
- **Must Have (P0)**: Sistem gagal berfungsi tanpa fitur ini (contoh: checkout order, otentikasi login).
  - **Max Must-Haves by Scale**: Kecil: 3–7 fitur | Menengah: 8–15 fitur | Besar: 16–25 fitur | Enterprise: 26–40 fitur
  - Jika melebihi batas, degradasi ke Should-Have atau phase 2.
- **Should Have (P1)**: Fitur penting tapi ada cara manual alternatif sementara (contoh: export laporan ke Excel).
- **Could Have (P2)**: Fitur tambahan jika waktu dan kapasitas solo dev tersisa (contoh: notifikasi WhatsApp).
- **Won't Have (P3)**: Fitur yang secara resmi disepakati tidak dibuat di fase ini (contoh: AI chatbot rekomendasi).

### Langkah 3: Penguncian Batasan Lingkup (In-Scope vs Out-of-Scope)
Solo developer wajib menuliskan bagian **Out-of-Scope** dengan detail agresif. Prinsip hukum perdata: *"Semua yang tidak tertulis secara eksplisit sebagai In-Scope adalah di luar tanggung jawab developer."*

Contoh Out-of-Scope standar yang wajib dicantumkan:
- Migrasi data manual dari buku/kertas fisik atau format database yang rusak.
- Pembelian lisensi font, aset gambar stok berbayar, atau biaya langganan API pihak ketiga.
- Penanganan kendala jaringan lokal, hardware scanner rusak, atau komputer kantor klien yang terinfeksi malware.

### Langkah 4: Identifikasi Ketergantungan Klien (Client Dependency SLA)
Daftar seluruh hal yang wajib disediakan klien agar pengerjaan tidak terhambat:
- Akun sandbox dan API secret key (payment gateway, email sender, cloud hosting).
- Master data awal dalam format digital terstruktur (CSV/JSON/Excel).
- Ketersediaan Single PIC untuk sesi klarifikasi mingguan.

Tentukan klausul: *Setiap keterlambatan penyerahan dependensi oleh klien $\ge 3$ hari kerja otomatis menggeser target rilis sistem tanpa denda bagi developer.*

### Langkah 5: Pemetaan Stakeholder & Komunikasi

**Stakeholder Identification & Power/Interest Matrix**

Petakan seluruh pemangku kepentingan menggunakan matriks Power/Interest (4 kuadran):

1. **Manage Closely** (Power Tinggi, Interest Tinggi): Pengambil keputusan utama yang harus di-update rutin dan dikonsultasi untuk keputusan besar.
   - *Contoh Solo Dev*: Client/user langsung yang membayar proyek.
   - *Contoh Company*: Product Owner, Engineering Lead, CTO.

2. **Keep Satisfied** (Power Tinggi, Interest Rendah): Punya wewenang tapi tidak terlibat harian. Perlu status update berkala agar tidak menghalangi approval.
   - *Contoh Solo Dev*: Bos/atasan klien yang menandatangani invoice.
   - *Contoh Company*: CFO, Legal, Compliance team.

3. **Keep Informed** (Power Rendah, Interest Tinggi): Terlibat aktif dalam eksekusi tapi tidak memutuskan scope. Komunikasi taktis harian/mingguan.
   - *Contoh Solo Dev*: User power/champion yang memberikan feedback UI/UX.
   - *Contoh Company*: Designer, QA, DevOps engineer, Marketing.

4. **Monitor** (Power Rendah, Interest Rendah): Stakeholder pasif yang hanya perlu tahu hasil akhir.
   - *Contoh Solo Dev*: Tim internal klien yang akan memakai sistem setelah launch.
   - *Contoh Company*: Sales team, external partner.

Gunakan template di `templates/01-discovery-commercial/STAKEHOLDER_MAP_TEMPLATE.md` untuk mendokumentasikan pemetaan ini.

**Communication Plan per Stakeholder**

Tentukan cadence komunikasi berdasarkan kuadran:

| Stakeholder Tier | Cadence | Channel | Format |
| :--- | :--- | :--- | :--- |
| **Manage Closely** | Daily/Weekly sync | Slack/Discord + 30-min call | Status dashboard + decision items |
| **Keep Satisfied** | Bi-weekly/Monthly | Email summary | Executive summary (1-page, RAG status) |
| **Keep Informed** | Weekly standup | Slack/Discord + shared doc | Detailed progress update, blockers |
| **Monitor** | Milestone report | Email broadcast | Launch announcement, major release notes |

**Escalation Path**: Definisikan kapan masalah harus di-escalate ke tier lebih tinggi:
- Blocker $\ge$ 3 hari tanpa resolusi → Escalate ke "Keep Satisfied"
- Scope creep request → Escalate ke "Manage Closely" untuk keputusan
- Budget/Timeline overrun risk → Escalate ke CFO/Financial stakeholder

Gunakan template di `templates/01-discovery-commercial/COMMUNICATION_PLAN_TEMPLATE.md`.

**Expectation Management (Realitas vs Janji)**

Kunci pertahanan scope adalah alignment ekspektasi sejak awal:

1. **Success Criteria Alignment Workshop**: Sebelum kick-off, gelar sesi 1 jam untuk sepakati definisi "done" yang terukur.
   - *Bad*: "Dashboard yang bagus dan user-friendly."
   - *Good*: "Dashboard dengan 5 widget wajib (X, Y, Z), response time <2s, mobile-responsive, tested di Chrome/Safari."

2. **Scope Boundary Communication**: Jelaskan batasan **In-Scope vs Out-of-Scope** dengan bahasa bisnis, bukan teknis.
   - *Bad*: "Kami tidak support horizontal pod autoscaling di Kubernetes."
   - *Good*: "Sistem akan otomatis scale untuk 100-500 user concurrent. Jika traffic melonjak >500 user, perlu upgrade infrastruktur terpisah (estimasi biaya +$X)."

3. **Timeline Reality Check (Under-Promise, Over-Deliver)**:
   - Formula buffer waktu solo dev: `Estimasi teknis × 1.5` (50% buffer untuk bug fix, scope clarification, dependency delay).
   - Komunikasikan: *"Timeline konservatif adalah 8 minggu. Jika semua berjalan lancar, mungkin selesai minggu ke-6, tapi kita commit ke minggu ke-8."*

4. **Trade-Off Transparency (Iron Triangle: Scope/Time/Quality)**:
   - Jika klien push deadline: "Untuk selesai 2 minggu lebih cepat, kita harus drop fitur X dan Y, atau terima technical debt yang akan memperlambat fase 2."
   - Jika klien tambah fitur: "Fitur Z menambah 10 hari dev time. Mau geser deadline atau drop fitur lain?"

**RACI Matrix untuk Deliverable Utama**

Definisikan tanggung jawab per deliverable menggunakan matriks RACI:
- **R (Responsible)**: Yang mengerjakan tugas.
- **A (Accountable)**: Yang memiliki approval final (hanya 1 orang per item).
- **C (Consulted)**: Yang perlu dikonsultasi sebelum keputusan.
- **I (Informed)**: Yang perlu tahu hasilnya tapi tidak terlibat eksekusi.

| Deliverable | R | A | C | I |
| :--- | :--- | :--- | :--- | :--- |
| **Scope Statement** | Solo Dev | Client/PO | Designer, QA | Exec |
| **UI/UX Design** | Designer | Client/PO | Solo Dev | Marketing |
| **Backend API** | Solo Dev | Tech Lead | Security Reviewer | QA |
| **Deployment** | Solo Dev/DevOps | CTO | Client PIC | Support Team |

Gunakan template di `templates/01-discovery-commercial/RACI_MATRIX_TEMPLATE.md`.

**Business Communication Skills untuk Solo Dev**

5 pola komunikasi wajib dikuasai:

1. **Executive Summary (Top-Down, 1-Page Max)**:
   ```
   **Status**: 🟢 Green (on track) / 🟡 Yellow (at risk) / 🔴 Red (blocked)
   **Progress**: 40% complete (Week 4 of 10)
   **Key Wins**: Feature X shipped, API integration done
   **Blockers**: Waiting for client data (3 days overdue)
   **Next Week**: Complete Feature Y, start QA testing
   **Asks**: Need client approval on design mockup by Friday
   ```

2. **Status Report Format (RAG + Blockers + Asks)**:
   - Kirim setiap Jumat EOD ke "Manage Closely" tier.
   - Struktur: What shipped this week → What's next week → Blockers → Explicit asks.

3. **Risk Communication (Early Warning + Mitigation Options)**:
   - *Bad*: "Ada masalah dengan API pihak ketiga." (vague, no action)
   - *Good*: "API pihak ketiga down 2 hari. Opsi: (1) Tunggu mereka fix (ETA unknown), (2) Ganti provider lain (+3 hari dev), (3) Build mock API sementara (+2 hari). Rekomendasi: Opsi 2. Need decision by tomorrow."

4. **Scope Creep Defense Script**:
   - Klien: "Bisa tambahin fitur X? Cuma kecil kok."
   - Solo Dev: "Fitur X butuh Y hari. Kalau mau masuk sprint ini, harus drop fitur Z atau geser deadline. Atau kita masukkan ke Phase 2 setelah launch?"

5. **Handling Difficult Stakeholders**:
   - **The Micromanager**: Kirim daily update proaktif (pagi 09:00) sebelum mereka tanya. Kurangi frekuensi interupsi.
   - **The Scope Creeper**: Selalu jawab tambahan fitur dengan trade-off (time/budget). Jangan langsung bilang "bisa" tanpa negotiation.
   - **The Silent Approver**: Set deadline approval: "Need design approval by Wednesday EOD, atau kita lanjut dengan asumsi approved untuk keep timeline on track."

Panduan lengkap lihat `references/pm/PM_COMMUNICATION_GUIDE.md`.

---

## 3. Adaptasi Berdasarkan Skala Proyek

| Aspek | Skala Kecil (MVP / Freelance) | Skala Menengah (B2B SaaS / Agensi) | Skala Besar & Enterprise |
| :--- | :--- | :--- | :--- |
| **Durasi Wawancara** | 1 sesi chat/call (30–60 menit) | 2–3 sesi discovery (1–2 minggu) | Workshop berjenjang per divisi (2–4 minggu) |
| **Kedalaman Persona** | 1–2 user role sederhana | 3–5 role dengan matriks RBAC | Multi-divisi, hierarki departemen, SSO Okta/AD |
| **Dokumen Scope** | 1-page Scope Checklist | Formal Scope Statement & API outline | Scope Statement lengkap, RTM draft, Compliance scope |
| **Ketergantungan** | Akses hosting & payment key dasar | Integrasi 2–4 layanan cloud | Integrasi legacy system/ERP, izin firewall internal |

---

## 4. Artefak Keluaran (Deliverable)

### Dokumen Wajib (Core Deliverables)

1. **`docs/pm/SCOPE_STATEMENT.md`** (Primary deliverable)
   - Template: `templates/01-discovery-commercial/SCOPE_STATEMENT_TEMPLATE.md`
   - Isi: In-Scope, Out-of-Scope, MoSCoW prioritization, client dependencies

2. **`docs/pm/STAKEHOLDER_MAP.md`** (Company/team projects)
   - Template: `templates/01-discovery-commercial/STAKEHOLDER_MAP_TEMPLATE.md`
   - Isi: Power/Interest matrix, stakeholder register, influence network
   - **Solo dev projects**: Optional (bisa disingkat 1 halaman jika hanya 1-2 klien)

3. **`docs/pm/COMMUNICATION_PLAN.md`** (Company/team projects)
   - Template: `templates/01-discovery-commercial/COMMUNICATION_PLAN_TEMPLATE.md`
   - Isi: Cadence per stakeholder, status report schedule, escalation matrix
   - **Solo dev projects**: Simplified version (1-page update schedule + 1 escalation contact)

4. **`docs/pm/RACI_MATRIX.md`** (Company/team projects)
   - Template: `templates/01-discovery-commercial/RACI_MATRIX_TEMPLATE.md`
   - Isi: Responsible/Accountable/Consulted/Informed per deliverable
   - **Solo dev projects**: Optional (typically: Solo Dev = R, Client = A for most items)

### Reference Guide

- **`references/pm/PM_COMMUNICATION_GUIDE.md`**: Business communication skills, status report templates, stakeholder management tactics

> 📁 **ATURAN LOKASI BERKAS MUTLAK**:
> Semua dokumen PM WAJIB disimpan di dalam folder **`docs/pm/`** (bukan di root direktori).
> Dilarang meletakkan dokumen lingkup kerja di root proyek.

### Adaptasi Berdasarkan Konteks

**Solo Developer (Freelance/Konsultan)**:
- **Wajib**: SCOPE_STATEMENT.md
- **Opsional**: STAKEHOLDER_MAP.md (1-page simplified), COMMUNICATION_PLAN.md (1-page), RACI_MATRIX.md (skip jika cuma 2 orang)

**Company/Team (Internal atau B2B)**:
- **Wajib**: Semua 4 dokumen di atas
- **Alasan**: Multiple stakeholders, complex approval chain, perlu clarity siapa decide apa

---

## 🛑 PROTOKOL [GATE] KELUAR & WAJIB BERHENTI

Setelah berkas `docs/pm/SCOPE_STATEMENT.md` selesai ditulis:

### **LANGKAH 0: VERIFIKASI EKSISTENSI BERKAS (BLOCKING CHECK)**

**WAJIB DILAKUKAN SEBELUM VALIDASI KONTEN**:

1. **Cek keberadaan file output** menggunakan salah satu metode:
   - PowerShell: `Test-Path -LiteralPath "docs/pm/SCOPE_STATEMENT.md"` → harus return `True`
   - Read tool: `read_file('docs/pm/SCOPE_STATEMENT.md')` → harus sukses tanpa error

2. **JIKA FILE TIDAK ADA**:
   - ❌ **STOP IMMEDIATELY** - jangan lanjut validasi konten
   - ❌ **JANGAN tampilkan summary** ke user
   - ❌ **JANGAN ajukan konfirmasi scope**
   - ✅ **REPORT ERROR** ke user:
     ```
     CRITICAL ERROR: File SCOPE_STATEMENT.md tidak tercipta.
     Module 02 FAILED - tidak bisa lanjut ke Module 03 (Legal SOW & Charter).
     
     Kemungkinan penyebab:
     - Write permission denied pada folder docs/pm/
     - Path typo di tool call
     - Disk full
     
     Tolong investigasi issue ini sebelum lanjut.
     ```
   - ✅ **END TURN** dan tunggu user fix issue

3. **HANYA JIKA FILE EXISTS**: Lanjut ke validasi konten di bawah

---

### **LANGKAH 1: VALIDASI KONTEN & SCOPE CONFIRMATION**

1. **DILARANG KERAS langsung melanjutkan atau memanggil tool untuk Modul 03 dalam giliran (turn) yang sama!**
2. **VERIFIKASI KONTEN (Self-Verification Checklist)**:
   - [ ] `read_file('docs/pm/SCOPE_STATEMENT.md')` → Confirm 60+ lines
   - [ ] Must-Have count within scale limits (3-7 Kecil, 8-15 Menengah, etc.)
   - [ ] Out-of-Scope section documented with ≥3 explicit exclusions
   - [ ] Client dependencies listed with SLA timeline
3. Tampilkan ringkasan batasan lingkup kepada pengguna:
   - Daftar fitur Must-Have (P0)
   - Daftar tegas fitur Out-of-Scope yang dilarang dibuat
   - Ketergantungan data/akses dari klien (Dependency SLA)
4. **AKHIRI RESPON ANDA (END TURN)** dan ajukan konfirmasi kepada pengguna:
   > *"Dokumen `docs/pm/SCOPE_STATEMENT.md` telah selesai disusun dengan [X] fitur Must-Have dan batasan Out-of-Scope yang terkunci. Apakah batasan lingkup ini sudah disepakati sebelum kita lanjut ke Modul 03 (Legal SOW & Project Charter)?"*
5. Tunggu respon persetujuan eksplisit dari pengguna sebelum melangkah ke Modul 03.
