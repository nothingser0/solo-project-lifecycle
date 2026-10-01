# Modul 09 Improvements: UAT Facilitation & Client Sign-Off

## 1. Timeline Estimation (by Project Scale)

| Phase | Kecil (MVP) | Menengah (SaaS) | Besar | Enterprise |
|-------|-------------|-----------------|-------|-----------|
| UAT Scenario Preparation | 2-3 jam | 4-6 jam | 8-12 jam | 16-24 jam |
| Kick-Off Session (30 min demo) | 1 jam | 1-2 jam | 2-3 jam | 4-6 jam (multi-stakeholder) |
| Client Testing Window | 2-3 hari | 5-7 hari | 7-10 hari | 10-14 hari |
| Bug Fix & Re-Test Cycles | 4-8 jam | 12-24 jam | 24-48 jam | 48-96 jam |
| UAT Report Writing | 1-2 jam | 2-3 jam | 4-6 jam | 8-12 jam |
| Sign-Off Negotiation | 1 jam (email) | 2-3 jam (meeting) | 4-6 jam (presentation) | 8-12 jam (legal review) |
| **TOTAL** | **3-5 hari** | **7-10 hari** | **10-14 hari** | **14-21 hari** |

### Assumptions
- Client testing window = calendar days (includes client-side delays)
- Dev active time = bug fix hours only
- Buffer 30% untuk scope creep disputes, sign-off negotiation, deemed acceptance clause enforcement

### Bottlenecks
- Client delayed testing: +2-5 hari (deemed acceptance clause enforcement needed)
- Scope creep disputes: +1-3 hari (CR documentation, SOW reference, client negotiation)
- Sign-off rejection: +2-4 hari (additional bug fixes, re-negotiation)

---

## 2. UAT Scenario Template Structure

### Conversion: PRD Acceptance Criteria → Test Steps

**PRD Acceptance Criteria Example**:
```markdown
## Feature: Document Upload

**Acceptance Criteria**:
- User can upload PDF/JPG files up to 10MB
- System validates file type and size
- System encrypts file with AES-256-GCM
- User receives success notification
- Uploaded document appears in document list
```

**UAT Scenario Template** (`docs/pm/UAT_SCENARIOS.md`):
```markdown
# UAT Scenarios: Document Upload Module

## Scenario 1: Upload Valid Document (Happy Path)

**Pre-Conditions**:
- User logged in as Freelancer role
- Dashboard page loaded

**Test Steps**:
1. Click "Upload Document" button
2. Select file: `sample-invoice.pdf` (size: 2.5MB)
3. Enter document title: "Invoice Q3 2026"
4. Select document type: "Income Proof"
5. Click "Submit" button

**Expected Results**:
- ✅ File upload progress bar shows 0% → 100%
- ✅ Success toast notification: "Document uploaded successfully"
- ✅ Document appears in "My Documents" list with status "Pending Review"
- ✅ File encrypted in S3 storage (verify via S3 console: file unreadable)

**Actual Results** (filled by client):
- [ ] Pass
- [ ] Fail (describe issue):

**Severity** (if failed):
- [ ] Blocker (Severity 1)
- [ ] Major (Severity 2)
- [ ] Minor (Severity 3)

**Tester**: [Client Name]  
**Date**: [Test Date]

---

## Scenario 2: Upload Oversized File (Validation Test)

**Pre-Conditions**:
- User logged in as Freelancer role
- Dashboard page loaded

**Test Steps**:
1. Click "Upload Document" button
2. Select file: `large-file.pdf` (size: 15MB)
3. Enter document title: "Large Invoice"
4. Click "Submit" button

**Expected Results**:
- ✅ Error message displayed: "File size exceeds 10MB limit"
- ✅ File NOT uploaded (check "My Documents" list: no new entry)
- ✅ User can retry with smaller file

**Actual Results** (filled by client):
- [ ] Pass
- [ ] Fail (describe issue):

**Severity** (if failed):
- [ ] Blocker (Severity 1)
- [ ] Major (Severity 2)
- [ ] Minor (Severity 3)

**Tester**: [Client Name]  
**Date**: [Test Date]

---

## Scenario 3: Upload Invalid File Type (Validation Test)

**Pre-Conditions**:
- User logged in as Freelancer role
- Dashboard page loaded

**Test Steps**:
1. Click "Upload Document" button
2. Select file: `document.docx` (Word file, not PDF/JPG)
3. Enter document title: "Word Document"
4. Click "Submit" button

**Expected Results**:
- ✅ Error message displayed: "Invalid file type. Only PDF and JPG allowed."
- ✅ File NOT uploaded
- ✅ User can retry with valid file type

**Actual Results** (filled by client):
- [ ] Pass
- [ ] Fail (describe issue):

**Severity** (if failed):
- [ ] Blocker (Severity 1)
- [ ] Major (Severity 2)
- [ ] Minor (Severity 3)

**Tester**: [Client Name]  
**Date**: [Test Date]
```

---

### UAT Scenario Checklist (Coverage)

**Must Cover** (Tier 1 — Critical Paths):
- [ ] User authentication (login, logout, session expiry)
- [ ] Core business workflow (create → process → approve → complete)
- [ ] Payment transaction (if applicable)
- [ ] Data validation (form field validation, error messages)
- [ ] File operations (upload, download, delete)

**Should Cover** (Tier 2 — Important Workflows):
- [ ] User registration & password reset
- [ ] Search & filtering
- [ ] Notification delivery (email, in-app)
- [ ] Report generation & export

**Nice to Cover** (Tier 3 — Edge Cases):
- [ ] Concurrent user actions (2 users edit same record)
- [ ] Browser compatibility (Chrome, Firefox, Safari, Mobile)
- [ ] Network interruption handling (upload mid-way)

---

## 3. Defect Triage Workflow

### Bug Reporting Medium (3 Options)

#### Option A: UAT Workbook (Recommended for Small Projects)

**Single markdown file** (`docs/pm/UAT_WORKBOOK.md`):
```markdown
# UAT Workbook: FreePajak

## Test Scenarios

### Scenario 1: Document Upload
**Status**: ❌ FAIL  
**Issue**: File upload stuck at 50%, no error message  
**Severity**: Blocker (Severity 1)  
**Reported by**: Budi (Client PIC)  
**Date**: 2026-09-30  

**Dev Response**:
- Root cause: S3 upload timeout (network latency)
- Fix: Increased timeout from 30s to 60s, added retry logic
- Fixed in commit: `a3f52b1`
- Status: FIXED (2026-09-30, 14:00)

**Retest Result** (client fills):
- [ ] Verified FIXED
- [ ] Still FAIL (describe):

---

### Scenario 2: Document Download
**Status**: ✅ PASS  
**Tested by**: Siti (Client Staff)  
**Date**: 2026-09-30
```

**Pros**: Simple, single source of truth, easy to track status  
**Cons**: Not scalable for >10 defects, no automated notifications

---

#### Option B: Spreadsheet (Google Sheets)

**Columns**:
- ID (auto-increment)
- Scenario Name
- Issue Description
- Severity (Blocker/Major/Minor/CR)
- Reported By
- Reported Date
- Dev Response
- Fix Commit
- Status (Open/In Progress/Fixed/Verified/Closed)
- Retest Date
- Retest Result (Pass/Fail)

**Pros**: Easy for non-technical clients, real-time collaboration, filter/sort  
**Cons**: No version control, easy to accidentally delete rows

**Sheet Link**: Share with client (edit access), dev monitors daily

---

#### Option C: Issue Tracker (Linear/Jira) — Enterprise Only

**Use when**:
- >20 defects expected
- Multiple stakeholders (QA team, business analyst, developers)
- Formal audit trail required

**Workflow**:
1. Client creates issue with template (scenario name, severity, screenshot)
2. Dev triages: valid bug → In Progress, scope creep → Rejected (link CR form)
3. Dev fixes → commit linked to issue
4. Client re-tests → closes issue

**Pros**: Professional, automated notifications, query/report capabilities  
**Cons**: Setup overhead, client training needed

---

### Defect Status Lifecycle

```text
OPEN (client reports bug)
  │
  ├─ Valid bug? 
  │  ├─ YES → IN PROGRESS (dev fixes)
  │  │         │
  │  │         ▼
  │  │       FIXED (commit pushed to staging)
  │  │         │
  │  │         ▼
  │  │       RETEST (client verifies)
  │  │         │
  │  │         ├─ Pass → VERIFIED/CLOSED
  │  │         └─ Fail → REOPENED (back to IN PROGRESS)
  │  │
  │  └─ NO (scope creep) → REJECTED (link CR form)
```

---

### Triage Decision Matrix (Dev Side)

**Bug Report**: "File upload gagal"

**Step 1: Reproduce**
```bash
# Dev reproduces in staging
curl -X POST https://staging.example.com/api/documents \
  -H 'Authorization: Bearer ***' \
  -F 'file=@test.pdf'
  
# Result: 500 Internal Server Error
```

**Step 2: Classify**
- ✅ **Valid Bug** (reproduces, violates PRD/FSD spec)
- ❌ **Cannot Reproduce** (client-side network issue, ask for screenshot/video)
- ❌ **Works as Designed** (client misunderstood spec, refer to PRD section X)
- ❌ **Scope Creep** (feature not in PRD, refer to CR form)

**Step 3: Assign Severity**
- **Blocker**: Core workflow broken (cannot upload any file)
- **Major**: Feature broken but workaround exists (upload fails for >5MB, but <5MB works)
- **Minor**: Cosmetic issue (upload success message typo "Succces")

**Step 4: Fix or Defer**
- Blocker: Fix immediately (<24 jam)
- Major: Fix before production deploy (<48 jam)
- Minor: Fix in next release or warranty period

---

## 4. Remote UAT Facilitation Protocol

### Scenario: Client di Luar Kota (Async Testing)

**Problem**: Cannot do 30-min kick-off video call (timezone, client busy).

**Solution**: Recorded Video Walkthrough

---

### Recorded Video Walkthrough Template

**Video Title**: "UAT Walkthrough: FreePajak System (15 menit)"

**Script**:
```
[00:00-01:00] Intro
"Halo Pak/Ibu [Nama PIC], ini adalah panduan singkat untuk menguji sistem FreePajak di server staging. Total ada 8 skenario yang perlu diuji, estimasi waktu 2-3 jam."

[01:00-03:00] Login & Dashboard
"Mari kita mulai dari Skenario 1: Login. Buka link staging: https://staging.freepajak.com. Masukkan email: admin@client.com, password: [lihat di email terpisah]. Klik Login. Anda akan masuk ke dashboard. Pastikan nama Anda muncul di pojok kanan atas."

[03:00-06:00] Document Upload (Scenario 2)
"Sekarang kita coba upload dokumen. Klik tombol 'Upload Dokumen Baru'. Pilih file PDF dari komputer Anda (maksimal 10MB). Isi judul dokumen, pilih tipe 'Bukti Penghasilan'. Klik Submit. Anda akan lihat progress bar 0-100%. Setelah selesai, dokumen akan muncul di daftar dengan status 'Menunggu Review'."

[06:00-09:00] Document Approval (Scenario 3)
"Login sebagai Manager (email: manager@client.com, password: [lihat email]). Buka menu 'Review Dokumen'. Pilih dokumen yang tadi diupload. Klik 'Approve'. Status dokumen berubah menjadi 'Disetujui'."

[09:00-12:00] Tax Calculation (Scenario 4)
"Sekarang kita uji kalkulasi pajak. Masukkan penghasilan bruto: 100000000 (100 juta). Pilih PTKP: TK/0 (tidak kawin, 0 tanggungan). Klik 'Hitung Pajak'. Sistem akan menampilkan PPh 21 terutang: 11.500.000 rupiah. Ini sesuai dengan UU HPP 2021."

[12:00-14:00] Error Handling (Scenario 5)
"Mari kita coba upload file yang terlalu besar. Pilih file >10MB. Klik Submit. Sistem harus menampilkan pesan error: 'Ukuran file melebihi 10MB'. Dokumen TIDAK boleh terupload."

[14:00-15:00] Closing
"Setelah menguji semua skenario, mohon isi kolom 'Actual Results' di file UAT_WORKBOOK.md. Jika ada yang tidak sesuai expected results, centang 'Fail' dan jelaskan masalahnya. Kirim file yang sudah diisi ke email saya. Terima kasih!"
```

**Delivery**:
1. Record screen + voiceover (Loom, OBS, Zoom recording)
2. Upload to Google Drive / YouTube (unlisted)
3. Send link to client via email with UAT_WORKBOOK.md attachment
4. Follow up after 3 days (gentle reminder)

---

### Async Communication Protocol

**Day 1 (Monday)**: Send video + UAT_WORKBOOK.md  
**Day 3 (Wednesday)**: Gentle reminder: "Pak/Bu, apakah ada kendala saat testing? Kami siap bantu via chat/call."  
**Day 5 (Friday)**: Formal notice: "Periode testing berakhir Senin depan, mohon hasil testing dapat dikirim sebelum tanggal X."  
**Day 8 (Monday)**: If no response, send deemed acceptance notice (SOW reference)

---

## 5. Sign-Off Rejection Handling

### Scenario: Client Refuses to Sign

**Client Statement**: "Saya belum bisa tandatangan, sistemnya belum sempurna. Masih ada yang perlu diperbaiki."

---

### Response Strategy (3-Step Protocol)

#### Step 1: Acknowledge & Clarify

**Dev Response**:
> "Saya memahami kekhawatiran Bapak/Ibu. Mari kita identifikasi bersama poin-poin yang masih dirasa kurang. Apakah temuan-temuan ini sudah tercatat di UAT_WORKBOOK.md? Jika belum, boleh saya minta untuk menuliskannya agar kami bisa evaluasi satu per satu?"

**Goal**: Get written list of issues (not verbal/vague complaints).

---

#### Step 2: Triage & Categorize

**Review each issue**:

| Issue | Category | Action |
|-------|----------|--------|
| "File upload kadang lambat" | Valid (Performance) | Fix if reproducible, otherwise note as Known Limitation (network-dependent) |
| "Tombol warna kurang menarik" | Valid (Cosmetic, Severity 3) | Defer to warranty period (not blocking production) |
| "Belum ada export ke Excel" | Scope Creep (Out-of-Scope) | Reject, offer CR form |
| "Sistem belum sempurna" | Vague (No Actionable Item) | Ask for specific examples |

**Dev Response** (after triage):
> "Dari 5 temuan yang Bapak/Ibu sampaikan:
> - 2 temuan valid (file upload lambat, typo di halaman login) → kami perbaiki dalam 48 jam
> - 1 temuan cosmetic (warna tombol) → dicatat sebagai perbaikan minor di masa garansi
> - 2 permintaan fitur baru (export Excel, WhatsApp notifikasi) → di luar scope PRD, kami buatkan lembar CR terpisah
>
> Setelah 2 bug valid diperbaiki, apakah Bapak/Ibu bersedia menandatangani UAT Sign-Off agar kami bisa lanjut ke produksi?"

---

#### Step 3: SOW Reference (If Still Rejected)

**If client still refuses without valid blocker**:

**Dev Response** (formal notice):
> "Sesuai SOW Pasal [X] Ayat [Y] tentang Kriteria Penerimaan, sistem dinyatakan lolos UAT jika:
> 1. Seluruh fitur di PRD berfungsi sesuai spesifikasi (✅ VERIFIED)
> 2. Tidak ada defect Severity 1 (Blocker) yang belum resolved (✅ VERIFIED)
> 3. Client telah melakukan testing dalam periode yang disepakati (✅ VERIFIED)
>
> Karena ketiga kriteria telah terpenuhi, kami mohon penandatanganan Berita Acara UAT dapat diselesaikan paling lambat [Date] agar jadwal peluncuran produksi tetap sesuai timeline kontrak. Jika ada keberatan teknis yang spesifik, mohon disampaikan secara tertulis beserta bukti screenshot/video agar kami bisa evaluasi lebih lanjut."

**Copy**: Project manager (if any), client's supervisor (if escalation needed)

---

### Sign-Off Rejection Scenarios & Responses

| Client Reason | Dev Response | Escalation |
|--------------|-------------|-----------|
| "Belum sempurna" (vague) | Ask for specific issues (written list) | SOW reference after 2nd refusal |
| "Ada bug X" (valid blocker) | Fix bug (<24 jam), retest, re-request sign-off | No escalation (valid concern) |
| "Mau tambah fitur Y" (scope creep) | Reject, offer CR form, sign-off current scope first | SOW scope boundary reference |
| "Atasan belum approve" (internal politics) | Extend deadline +3 hari, offer presentation to management | Deemed acceptance if >10 hari total |
| "Bayar dulu baru tanda tangan" (payment dispute) | SOW payment terms reference (UAT sign-off ≠ final payment) | Legal/contract team involvement |

---

### Deemed Acceptance Enforcement (Last Resort)

**When to use**:
- Client silent for >10 hari (no testing, no response to reminders)
- Client testing done, no blocker reported, but refuses to sign without valid reason

**Formal Notice Template**:
```
Subject: Notice of Deemed Acceptance — [Project Name]

Dear [Client PIC],

Mengacu pada:
1. Surat Perjanjian Kerja (SOW) No. [X] Pasal [Y] tentang Periode Pengujian UAT
2. Penyerahan akses server staging tanggal [Date]
3. Pengingat UAT tanggal [Date 1], [Date 2], [Date 3]

Dengan ini kami sampaikan bahwa periode pengujian UAT telah melewati batas waktu 10 (sepuluh) hari kerja tanpa adanya laporan cacat teknis kritis (Severity 1 Blocker) yang belum terselesaikan.

Sesuai ketentuan SOW Pasal [X] Ayat [Y], sistem secara hukum dinyatakan telah diterima secara memuaskan (**Deemed Accepted**) per tanggal [Date].

Dengan ini kami akan melanjutkan:
1. Merge branch staging → main
2. Deployment ke server produksi (Modul 10)
3. Penerbitan invoice pelunasan (sesuai term pembayaran SOW)

Jika ada keberatan teknis yang spesifik, mohon disampaikan paling lambat [Date + 2 hari] beserta bukti dokumentasi.

Hormat kami,
[Dev Name / Company]
```

**Send via**: Email (CC: client's supervisor if needed), registered mail (if high-value contract)

---

### Sign-Off Rejection Handling Checklist

- [ ] Acknowledge client concern (no defensive response)
- [ ] Get written list of issues (not verbal complaints)
- [ ] Triage: Valid bug vs Scope creep vs Vague complaint
- [ ] Fix valid blockers (<24 jam), defer cosmetic issues
- [ ] Reject scope creep (offer CR form)
- [ ] Re-request sign-off after blocker fixes
- [ ] SOW reference if still rejected without valid reason
- [ ] Deemed acceptance enforcement (>10 hari, formal notice)
- [ ] Document entire negotiation in project log (email thread, meeting notes)


---

## Solo Developer Focus

# Panduan Fasilitasi UAT & Negosiasi Solo Developer

Dokumen ini adalah buku panduan taktis bagi solo developer untuk memandu proses pengujian penerimaan pengguna (*User Acceptance Test* / UAT) bersama klien, mengelola temuan cacat, menangkis revisi liar, dan mengamankan penandatanganan Berita Acara tanpa konflik.

---

## 1. Psikologi Klien Saat Sesi UAT

Klien sering menunda-nunda sesi UAT atau mendadak merasa cemas menjelang peluncuran. Hal ini biasanya dipicu oleh dua alasan:
1. **Beban Kerja Harian**: Karyawan klien sibuk dengan tugas operasional kantor sehingga pengujian sistem dianggap sebagai beban tambahan.
2. **Kecemasan Tanggung Jawab**: Single PIC Klien takut disalahkan oleh direksinya jika sistem ada bug setelah rilis.

### Taktik Membuka UAT (The 30-Minute Kick-Off Session):
- **Jangan Beri Akses Begitu Saja**: Dilarang hanya mengirimkan email: *"Pak/Bu, ini link staging-nya silakan dites ya."* Klien akan bingung harus mulai dari mana dan akhirnya tidak melakukan pengujian.
- **Jadwalkan Sesi Walk-Through 30 Menit**:
  - Dampingi PIC Klien via video call (Zoom / Google Meet).
  - Tunjukkan berkas **`UAT_SCENARIOS.md`** di layar.
  - Bimbing PIC mencoba Skenario 1 (Login dan Buat Dokumen Pertama) secara langsung. Begitu mereka melihat alur pertama berhasil, kecemasan mereka akan hilang dan mereka siap melanjutkan mandiri.

---

## 2. Naskah Komunikasi Menangkis Scope Creep Berkedok Bug

Klien sering memanfaatkan sesi UAT untuk meminta fitur tambahan secara gratis dengan dalih "sistem belum lengkap":

### Kasus 1: "Mas, bisa sekalian ditambahin export ke PDF warna abu-abu dan kirim WhatsApp otomatis?"
**Pola Respon Solo Dev**:
> *"Usulan fitur integrasi WhatsApp ini sangat bagus untuk meningkatkan kecepatan notifikasi. Mari kita cek bersama dokumen spesifikasi PRD dan FSD v1.0 yang menjadi acuan kontrak kita. Di sana disepakati bahwa sistem menggunakan pengiriman Email Transaksional, sedangkan WhatsApp masuk ke dalam daftar rencana pengembangan lanjutan (Fase 2).*
>
> *Agar jadwal peluncuran sistem utama kita tidak tertunda, mari kita selesaikan pengesahan fitur yang ada saat ini terlebih dahulu. Setelah sistem live, kita bisa langsung lanjutkan implementasi WhatsApp melalui lembar Change Request (CR) terpisah."*

### Kasus 2: "Mas, tata letak form-nya kok begini ya, saya mau tombolnya dipindah ke kiri dan kolomnya dipecah jadi 3 tab."
**Pola Respon Solo Dev**:
> *"Tata letak saat ini disusun persis mengikuti berkas `DESIGN_SPEC.md` yang telah disahkan pada lembar **Design Freeze** tanggal [Tanggal Persetujuan Modul 04]. Karena struktur form ini sudah terikat dengan logika database di backend, perombakan susunan kolom saat ini akan membutuhkan rekonstruksi skema ulang.*
>
> *Saran terbaik saya, kita jalankan sistem dengan layout yang telah disepakati ini selama 30 hari masa operasional. Jika dari hasil penggunaan harian staf merasa butuh penyesuaian, kita lakukan optimalisasi pada jadwal rilis pembaruan berikutnya."*

---

## 3. Protokol Penegakan "Deemed Acceptance Clause" (Klien Mangkir)

Jika Klien tidak melakukan pengujian dan mengabaikan pesan pengembang selama masa testing window:

### Kronologi Penegakan Status Notice:
1. **Hari ke-3**: Kirim pesan pengingat ramah (*Gentle Reminder*):
   > *"Halo Pak/Bu [Nama PIC], menyambung pembukaan sesi UAT per tanggal [Tanggal], apakah ada kendala dalam mencoba Skenario UAT di staging? Kami siap mendampingi jika ada alur yang membutuhkan klarifikasi."*
2. **Hari ke-7**: Kirim surat pengingat resmi (*Formal Notice*):
   > *"Selamat siang Pak/Bu, kami mengingatkan bahwa periode pengujian UAT proyek [Nama Proyek] akan berakhir dalam 3 hari kerja (sesuai SOW pasal batas pengujian 7 hari kerja). Mohon catatan pengujian dapat diserahkan sebelum tanggal [Tenggat] agar jadwal rilis produksi tetap terjaga."*
3. **Hari ke-10**: Penerbitan Surat Penerimaan Otomatis (*Notice of Deemed Acceptance*):
   > *"Mengingat periode pengujian UAT telah melewati batas waktu 10 hari kerja tanpa adanya catatan cacat teknis kritis yang dilaporkan, maka sesuai ketentuan SOW Pasal [X] ayat [Y], sistem secara hukum dinyatakan telah diterima secara memuaskan (**Deemed Accepted**). Dengan ini kami akan melanjutkan persiapan deployment ke lingkungan produksi (Modul 10)."*
