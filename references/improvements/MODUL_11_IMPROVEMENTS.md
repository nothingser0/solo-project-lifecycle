# Modul 11 Improvements: Handover & BAST

## 1. Timeline Estimation (by Project Scale)

| Phase | Kecil (MVP) | Menengah (SaaS) | Besar | Enterprise |
|-------|-------------|-----------------|-------|-----------|
| Invoice Generation | 30 min | 1 jam | 2 jam | 4 jam (legal review) |
| Training Sessions | 2 jam (1 session) | 4 jam (2 sessions) | 8 jam (4 sessions) | 16 jam (multi-department) |
| USER_MANUAL Writing | 2-3 jam | 4-6 jam | 8-12 jam | 16-24 jam |
| Payment Wait Time | 3-7 hari | 7-14 hari | 14-30 hari | 30-60 hari (corporate finance) |
| Credential Preparation | 1 jam | 2 jam | 4 jam | 8 jam (audit trail) |
| Repo Transfer | 30 min | 1 jam | 2 jam | 4 jam (multi-repo) |
| BAST Signing | 1 jam (digital) | 2 jam (meeting) | 4 jam (presentation) | 8 jam (legal ceremony) |
| **TOTAL** | **4-6 hari** | **9-16 hari** | **16-32 hari** | **32-62 hari** |

### Assumptions
- Payment wait time = calendar days (client-side delay, NOT dev active time)
- Dev active time = 6-11 jam total (training + docs + handover execution)
- Buffer 50% untuk payment delays, client rescheduling training sessions

### Bottlenecks
- Payment delay: +7-30 hari (corporate finance approval chain)
- Training reschedules: +2-5 hari (client stakeholder conflicts)
- BAST legal review: +3-7 hari (enterprise contracts only)

---

## 2. Credential Handover Checklist

### Pre-Handover Verification

**Before transferring ANY credentials**, verify:
- [ ] Payment 100% received (check bank statement, NOT invoice marked paid)
- [ ] BAST signed by client (physical signature or digital via DocuSign/Privy)
- [ ] Training sessions completed (recorded videos delivered)
- [ ] USER_MANUAL.md delivered and acknowledged

**STOP if any item unchecked!**

---

### Credential Inventory Template

**`docs/pm/CREDENTIAL_INVENTORY.md`**:
```markdown
# Credential Inventory: Handover to [Client Name]

**Project**: [Project Name]  
**Handover Date**: 2026-09-30  
**Transferred By**: [Dev Name]  
**Received By**: [Client PIC Name]

---

## 1. Git Repository Access

**Repository**: https://github.com/client-org/project-name  
**Transfer Method**: GitHub Organization Transfer  
**New Owner**: client-org (GitHub organization)  
**Transfer Completed**: ✅ 2026-09-30 14:30 WIB  
**Verification**: Client PIC confirmed access via email

---

## 2. Production Server Access

### 2.1 Cloud Provider (Vercel/Railway/AWS)

**Platform**: Vercel  
**Account Email**: admin@client.com  
**Transfer Method**: Invite as Owner → Remove dev access  
**Credentials Delivered**: N/A (OAuth login via client Google Workspace)  
**Transfer Completed**: ✅ 2026-09-30 14:45 WIB

### 2.2 Database Access

**Provider**: Supabase  
**Database**: project-prod (PostgreSQL)  
**Connection String**: Delivered via Bitwarden Send (expired after 1 access)  
**Bitwarden Send Link**: https://send.bitwarden.com/***  
**Expiry**: 24 hours or 1 access (whichever first)  
**Accessed By Client**: ✅ 2026-09-30 15:00 WIB

---

## 3. Third-Party Service Accounts

### 3.1 Payment Gateway (Stripe/Midtrans)

**Service**: Midtrans  
**Account Email**: finance@client.com (already owned by client)  
**API Keys**: Client manages own keys (integrated via dashboard)  
**Dev Access**: Removed ✅ 2026-09-30 15:15 WIB

### 3.2 Email Service (SendGrid)

**Service**: SendGrid  
**Account Email**: noreply@client.com  
**API Key**: Delivered via Bitwarden Send  
**Transfer Method**: Client creates new key, dev removes old key  
**Transfer Completed**: ✅ 2026-09-30 15:30 WIB

### 3.3 Storage (AWS S3/Cloudflare R2)

**Service**: Cloudflare R2  
**Bucket**: project-prod-documents  
**Access Key ID**: Delivered via Bitwarden Send  
**Secret Access Key**: Delivered via Bitwarden Send  
**Transfer Completed**: ✅ 2026-09-30 15:45 WIB

### 3.4 Monitoring (Sentry)

**Service**: Sentry  
**Organization**: client-org  
**Transfer Method**: Invite client as Owner → Remove dev  
**Transfer Completed**: ✅ 2026-09-30 16:00 WIB

---

## 4. Domain & DNS

**Domain**: app.client.com  
**Registrar**: Niagahoster (client owns domain)  
**DNS Provider**: Cloudflare  
**Cloudflare Account**: admin@client.com  
**Transfer Method**: Invite as Super Administrator → Remove dev  
**Transfer Completed**: ✅ 2026-09-30 16:15 WIB

---

## 5. CI/CD & Deployment

**Platform**: Vercel  
**Webhook**: Removed dev GitHub PAT, client added org token  
**Deployment Access**: Client team has full deploy access  
**Transfer Completed**: ✅ 2026-09-30 16:30 WIB

---

## 6. Documentation Access

**Location**: GitHub Wiki + `/docs` folder in repo  
**Access**: Client has full read/write via repo ownership  
**Additional Docs Delivered**:
- [ ] USER_MANUAL.md (emailed + in repo)
- [ ] RUNBOOK.md (deployment procedures)
- [ ] ARCHITECTURE.md (system design)
- [ ] ENV_EXAMPLE.md (environment variables reference)

---

## 7. Admin Accounts (Application Level)

**Super Admin Email**: admin@client.com  
**Password**: Client set own password during training session  
**2FA**: Enabled (client's authenticator app)  
**Backup Codes**: Delivered to client via secure channel

---

## 8. Verification Checklist

**Post-Handover Verification** (client performs):
- [ ] Can access GitHub repo (read + write)
- [ ] Can deploy to production (Vercel dashboard access)
- [ ] Can connect to database (via connection string)
- [ ] Can login to admin dashboard (super admin account)
- [ ] Can view Sentry errors (monitoring access)
- [ ] Can manage domain DNS (Cloudflare access)

**Client Sign-Off**: ✅ All verifications passed (email confirmation 2026-09-30 17:00 WIB)

---

## 9. Dev Access Removal Confirmation

**Actions Taken**:
- [x] Removed from GitHub repo (no longer member)
- [x] Removed from Vercel project (no deploy access)
- [x] Removed from Supabase project (no DB access)
- [x] Removed from Sentry organization
- [x] Removed from Cloudflare account
- [x] Revoked all Personal Access Tokens (GitHub, API keys)
- [x] Deleted staging/dev resources (cost optimization)

**Final Status**: Dev has ZERO access to production systems ✅

---

## 10. Emergency Contact

**Warranty Period**: 30 days (2026-09-30 to 2026-10-30)  
**Support Channel**: email support@devname.com (warranty issues only)  
**After Warranty**: Monthly Retainer SLA or hourly billing

**Handover Complete**: ✅ 2026-09-30 17:00 WIB
```

---

### Bitwarden Send Best Practices

**Why Bitwarden Send**:
- One-time access link (expires after 1 view)
- Encrypted end-to-end
- No account required for recipient
- Audit trail (you know when accessed)

**Setup**:
```bash
# Install Bitwarden CLI
npm install -g @bitwarden/cli

# Login
bw login

# Create send (one-time text)
echo "DATABASE_URL=postgresql://***" | bw send create --text --name "Production DB Credentials" --maxAccessCount 1

# Output:
# https://send.bitwarden.com/#/***
# Share this link with client via email
```

**Alternative Tools**:
- 1Password (similar send feature)
- Yopass (open-source, self-hosted)
- PrivateBin (self-hosted pastebin)

---

## 3. Repository Transfer Verification Protocol

### Problem
Repo transfer may fail or incomplete (webhooks not migrated, secrets missing, CI/CD broken).

### Solution: 3-Step Verification

---

#### Step 1: Pre-Transfer Backup

```bash
# Clone full repo with all branches
git clone --mirror https://github.com/dev-account/project-name.git project-backup.git

# Backup size verification
du -sh project-backup.git
# Expected: similar to original repo size

# Archive for safety
tar -czf project-backup-20260930.tar.gz project-backup.git

# Store backup offsite (Google Drive, S3)
```

---

#### Step 2: Execute Transfer

**GitHub Organization Transfer**:
1. Repo Settings → Danger Zone → Transfer ownership
2. Enter new owner: `client-org`
3. Confirm transfer

**GitLab Project Transfer**:
1. Project Settings → General → Advanced → Transfer project
2. Select namespace: `client-org`
3. Confirm transfer

---

#### Step 3: Post-Transfer Verification

**Client-Side Verification Checklist**:
```bash
# 1. Clone repo from new location
git clone https://github.com/client-org/project-name.git

# 2. Verify all branches transferred
git branch -a
# Expected: main, staging, all feature branches

# 3. Verify commit history intact
git log --oneline | head -10
# Expected: all recent commits present

# 4. Verify tags transferred
git tag -l
# Expected: v1.0.0, v1.0.1, etc.

# 5. Verify GitHub Actions/CI still works
# Push test commit to trigger CI
git commit --allow-empty -m "Test CI after transfer"
git push origin main

# 6. Check Actions tab (should trigger build)
```

**Dev-Side Verification**:
```bash
# 1. Verify old repo redirects to new location
# GitHub automatically creates redirect
curl -I https://github.com/dev-account/project-name
# Expected: HTTP 301 redirect to client-org/project-name

# 2. Verify dev no longer has write access
git push origin main
# Expected: Permission denied (publickey) or 403 Forbidden

# 3. Verify dev removed from collaborators
# GitHub → Repo → Settings → Collaborators
# Expected: dev-account NOT in list
```

---

#### Common Transfer Issues & Fixes

| Issue | Symptom | Fix |
|-------|---------|-----|
| **Webhooks not migrated** | CI/CD broken after transfer | Client re-adds webhooks (Vercel, Discord) |
| **Secrets not transferred** | Build fails (missing API keys) | Client re-adds GitHub Secrets (Settings → Secrets) |
| **Branch protection lost** | Main branch unprotected | Client re-enables branch protection rules |
| **GitHub Pages broken** | Custom domain not working | Client re-configures custom domain in Settings |

---

### Transfer Verification Checklist

- [ ] Pre-transfer backup created and stored offsite
- [ ] Transfer executed (GitHub/GitLab transfer complete)
- [ ] Client can clone repo from new location
- [ ] All branches present (`git branch -a`)
- [ ] Commit history intact (`git log`)
- [ ] Tags transferred (`git tag -l`)
- [ ] CI/CD pipeline works (test push successful)
- [ ] Webhooks re-added (if needed)
- [ ] Secrets re-added (if needed)
- [ ] Branch protection re-enabled
- [ ] Dev access removed (verified by attempting push)

---

## 4. Payment Dispute Protocol

### Scenario: Client Refuses Final Payment

**Common Excuses**:
- "Sistem masih ada bug" (there are still bugs)
- "Belum sempurna" (not perfect yet)
- "Atasan belum approve" (boss hasn't approved)
- "Anggaran belum cair" (budget not released)
- "Bayar bertahap setelah live 3 bulan" (pay gradually after 3 months live)

---

### Response Strategy (4-Step Escalation)

#### Step 1: Acknowledge & Clarify (<24 hours)

**Dev Response**:
> "Saya memahami kekhawatiran Bapak/Ibu. Mari kita identifikasi bersama:
> 1. Apakah ada bug kritis (Severity 1) yang belum diperbaiki? Jika ya, mohon dikirim screenshot/video agar kami segera perbaiki (covered by warranty).
> 2. Sistem saat ini telah lolos UAT (Berita Acara UAT tertanggal [Date]) dan telah live di produksi (GO_LIVE_REPORT tanggal [Date]).
> 3. Sesuai SOW Pasal [X] tentang Term Pembayaran, pelunasan (Termin 4: [%]) jatuh tempo pada [Date] (7 hari sejak go-live).
>
> Apakah ada kendala spesifik yang menghalangi proses pembayaran? Kami siap membantu koordinasi jika ada missing dokumen atau approval internal yang perlu difasilitasi."

**Goal**: Get specific reason (not vague complaints) + show willingness to help.

---

#### Step 2: SOW Reference + Evidence (Day 3)

**If no payment or vague response after 3 days**:

**Dev Response** (formal notice):
> Subject: Payment Reminder — Invoice #[X] Overdue (Termin 4)
>
> Dear [Client PIC],
>
> Mengacu pada:
> 1. Surat Perjanjian Kerja (SOW) No. [X] Pasal [Y] tentang Term Pembayaran
> 2. Berita Acara UAT tertanggal [Date] (sistem dinyatakan lolos UAT)
> 3. GO_LIVE_REPORT tertanggal [Date] (sistem telah live di produksi)
> 4. Invoice #[X] tanggal [Date] dengan jatuh tempo [Date]
>
> Dengan ini kami mengingatkan bahwa pembayaran Termin 4 (pelunasan [%]) telah melewati jatuh tempo sejak [X] hari.
>
> Kami memahami bahwa proses approval internal memerlukan waktu. Mohon konfirmasi:
> 1. Estimasi tanggal pembayaran dapat dilakukan (target: [Date])
> 2. Dokumen tambahan yang diperlukan untuk proses approval (jika ada)
>
> Kami siap menyerahkan dokumentasi lengkap (BAST, USER_MANUAL, source code) segera setelah pembayaran terkonfirmasi sesuai kebijakan "Payment-Gated Handover" di SOW Pasal [Z].
>
> Hormat kami,
> [Dev Name]

**Attachment**: SOW PDF (highlight payment terms), UAT_SIGNOFF_REPORT.md, GO_LIVE_REPORT.md

---

#### Step 3: Withhold Handover (Day 7)

**If still no payment after 7 days**:

**Dev Actions**:
- [ ] Do NOT transfer repo ownership
- [ ] Do NOT share production credentials
- [ ] Do NOT sign BAST
- [ ] System remains live (client can use it), but dev retains infrastructure control

**Dev Response** (firm but professional):
> Subject: Payment Overdue Notice — Handover on Hold
>
> Dear [Client PIC],
>
> Pembayaran Termin 4 (Invoice #[X]) telah melewati jatuh tempo sejak 7 hari (seharusnya dibayar tanggal [Date]).
>
> Sesuai SOW Pasal [Z] tentang "Payment-Gated Handover", proses serah terima aset berikut ditahan hingga pembayaran terkonfirmasi:
> - Transfer kepemilikan repositori GitHub
> - Kredensial akses production server
> - Penandatanganan Berita Acara Serah Terima (BAST)
>
> Sistem saat ini tetap beroperasi normal di produksi untuk mendukung operasional Bapak/Ibu, namun kendali infrastruktur (root access) belum diserahkan.
>
> Mohon pembayaran dapat diselesaikan paling lambat [Date + 3 hari] agar proses handover dapat dilanjutkan sesuai jadwal.
>
> Jika ada kendala pembayaran yang memerlukan negosiasi ulang term (misal: split payment 2 tahap), kami terbuka untuk diskusi.
>
> Hormat kami,
> [Dev Name]

**Copy**: Client's supervisor (if escalation needed), legal team (if contract dispute)

---

#### Step 4: Legal Escalation or Collection (Day 14)

**If no payment or no negotiation after 14 days**:

**Option A: Negotiated Settlement**:
- Split payment: 50% now, 50% in 30 days
- Partial handover: Transfer repo, withhold root access until full payment
- Extend warranty: Additional 30 days warranty as compensation for delay

**Option B: Legal Action**:
- Send legal demand letter (via lawyer, Rp 2-5 juta fee)
- File small claims court (if amount < Rp 500 juta)
- Report to debt collection agency (if corporate client)

**Option C: Cut Losses (Last Resort)**:
- If amount small (<Rp 10 juta) and legal cost high
- Transfer ownership, close project, blacklist client
- Document case as lesson learned

---

### Payment Dispute Decision Matrix

| Client Response | Dev Action | Escalation |
|----------------|------------|-----------|
| **Pays within 7 days** | Proceed with handover | No escalation |
| **Requests extension (valid reason)** | Grant 7-day extension once | No escalation |
| **Vague excuses, no payment plan** | Withhold handover, formal notice | SOW reference (Step 2) |
| **Silent (no response >7 days)** | Withhold handover, firm notice | Legal warning (Step 3) |
| **Refuses payment (dispute)** | Freeze handover, negotiate | Legal action (Step 4) |
| **Bankruptcy/unable to pay** | Cut losses, transfer ownership | Blacklist client |

---

### Payment Dispute Checklist

- [ ] SOW payment terms clearly defined (termin %, jatuh tempo)
- [ ] Payment-gated handover clause in SOW (no pay, no root)
- [ ] Evidence collected (UAT sign-off, GO_LIVE report, invoice)
- [ ] Escalation timeline documented (Day 0/3/7/14)
- [ ] Client supervisor contact info available (for escalation)
- [ ] Legal consultation budget allocated (Rp 2-5 juta)
- [ ] Blacklist criteria defined (when to cut losses)
- [ ] Lesson learned documented (improve SOW for next project)


---

## Solo Developer Focus

# Panduan Serah Terima & BAST Solo Developer

Dokumen ini adalah pedoman taktis bagi solo developer dan konsultan teknis dalam mengeksekusi penutupan proyek, mengamankan pelunasan tagihan 100%, menetapkan batasan jatah pelatihan, memindahkan repositori, dan menandatangani Berita Acara Serah Terima (BAST) yang sah secara hukum.

---

## 1. Disiplin "Payment-Gated Handover": Menjaga Posisi Tawar Solo Dev

Banyak solo developer pemula melakukan kesalahan fatal: *menyerahkan akses admin root, mengalihkan repositori GitHub, dan menandatangani BAST sebelum pembayaran termin terakhir masuk ke rekening.*

### Realita di Perusahaan Klien:
Begitu tim teknis klien sudah memegang repositori dan password server, urgensi divisi keuangan (*finance*) mereka untuk mencairkan sisa tagihan Anda akan menurun drastis. Proses pembayaran sering diundur berminggu-minggu dengan berbagai alasan birokrasi internal.

### Urutan Mutlak Penyerahan Aset:
```text
1. Sistem Live di Produksi (Klien login sebagai User Biasa / Demo)
                    │
                    ▼
2. Terbitkan Invoice Pelunasan (Termin Final 10%–20%)
                    │
                    ▼
3. Tunggu Dana Masuk & Terverifikasi di Rekening Bank Anda
                    │
       ┌────────────┴────────────┐
       ▼                         ▼
 [ DANA BELUM CAIR ]       [ DANA SUDAH LUNAS 100% ]
 Tahan transfer repo       1. Laksanakan Sesi Training (1–2x)
 Tahan password root       2. Transfer Kepemilikan GitHub/Cloud
 Berikan akses tester      3. Tanda Tangani BAST Bermeterai
                           4. Masa Garansi Resmi Dimulai
```

---

## 2. Pengelolaan Jatah Pelatihan Pengguna (Training Quota)

Jangan biarkan diri Anda menjadi staf layanan pelanggan (*customer service*) atau tukang training gratisan selamanya.

### Aturan Baku Sesi Pelatihan:
1. **Batas Jatah Maksimal 2 Sesi**:
   - *Sesi 1 (60 Menit)*: Pelatihan alur operasional staf pengguna harian.
   - *Sesi 2 (60 Menit)*: Pelatihan konfigurasi dan manajemen untuk Super Admin.
2. **Wajib Merekam Video Sesi**:
   - Seluruh sesi pelatihan daring wajib direkam (format MP4).
   - Unggah rekaman tersebut ke Google Drive atau link privat dan serahkan bersama berkas `USER_MANUAL.md`.
3. **Klausul Pelatihan Tambahan**:
   - Jika di masa mendatang klien merekrut karyawan baru dan meminta developer melatih ulang secara tatap muka/online, cantumkan aturan: *"Pelatihan tambahan di luar 2 sesi yang disepakati dikenakan biaya jasa profesional sebesar Rp [X] per sesi."*

---

## 3. Protokol Penyerahan Kredensial Terenkripsi (Zero Plaintext)

Jangan pernah mengirimkan kredensial server produksi melalui pesan WhatsApp atau email teks terbuka karena rentan disadap atau tersimpan di backup cloud ponsel yang tidak aman.

### Gunakan Jalur Sekali Pakai (One-Time Secret Sharing):
- Gunakan layanan gratis seperti **Bitwarden Send** (`bitwarden.com/send`), **Yopass** (`yopass.se`), atau **1Password Share**.
- Atur parameter keamanan:
  - *Masa berlaku tautan*: Maksimal 24 jam.
  - *Batas pembukaan*: Otomatis hancur setelah dibuka 1 kali (*Delete after 1 view*).
  - *Kata sandi tambahan*: Berikan password pembuka tautan melalui media yang berbeda (misal: link dikirim via Email, password pembuka dikirim via SMS/Telepon).

---

## 4. Nilai Hukum BAST di Indonesia

Dokumen **Berita Acara Serah Terima (BAST)** adalah dokumen paling krusial bagi solo developer di mata hukum Indonesia (KUHPerdata Pasal 1320 & 1338):

1. **Bukti Pemenuhan Kewajiban**:
   - BAST adalah bukti mutlak bahwa developer telah menyelesaikan seluruh kewajibannya sesuai kontrak SOW. Klien tidak bisa lagi menggugat atau menuduh developer melakukan wanprestasi (*default/breach of contract*).
2. **Kunci Pembatas Scope Creep**:
   - Begitu BAST ditandatangani, klien tidak berhak meminta fitur baru secara gratis. Segala permintaan tambahan otomatis menjadi objek kontrak baru atau jasa Change Request berbayar.
3. **Penanda Resmi Mulai Garansi**:
   - Masa garansi (30/60/90 hari) **BARU MULAI DIHITUNG** sejak tanggal tanda tangan BAST. Tanpa BAST, klien sering menuntut garansi seumur hidup.
4. **Meterai Rp 10.000,-**:
   - Dokumen BAST wajib dibubuhi meterai fisik Rp 10.000,- yang ditandatangani menimpa meterai, atau menggunakan **e-Meterai Peruri** resmi untuk format digital.
