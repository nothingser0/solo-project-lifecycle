# Production Deployment Protocol & Go-Live Report

> Combined document for production system deployment execution guide and post-release verification report.

---

## PART I: DEPLOYMENT RUNBOOK

### 1. Release Metadata
- **System Name**: [Application Name]
- **Target Release Version**: `v1.0.0`
- **Official Domain**: `https://app.client.com`
- **Release Date & Time**: [YYYY-MM-DD] at [09:00 - 11:00 UTC/WIB]
- **Release Engineer**: [Your Name]

---

### 2. Pre-Launch Checklist (Pre-Flight Sanity)

- [ ] **UAT Sign-Off**: `UAT_SIGNOFF_REPORT.md` document has been signed by Client Single PIC.
- [ ] **Safe Window**: Release scheduled during working days (Tuesday–Thursday morning), not Friday afternoon or weekend.
- [ ] **Snapshot Backup**: Production database manually backed up before executing migrations.
- [ ] **Environment Keys**: Production `.env` variables use LIVE credentials (not sandbox).

---

### 3. Deployment Execution Steps (Step-by-Step Commands)

#### Step 1: Branch Merge & Git Tagging
```bash
# Switch to main branch and merge from staging
git checkout main
git pull origin main
git merge --no-ff staging -m "chore: merge staging for production release v1.0.0"

# Tag official release version
git tag -a v1.0.0 -m "Release Production v1.0.0"
git push origin main --tags
```

#### Step 2: Production Database Migration
```bash
# Run SQL DDL schema migration
DATABASE_URL="postgresql://user:***@prod-host:5432/db_prod?sslmode=require" pnpm db:migrate
```

#### Step 3: Container Build & Deploy Execution
```bash
# If using Docker / Serverless:
# CI/CD pipeline runs automatically on git push tag v1.0.0
# Verify pipeline status in GitHub Actions / Cloud Hosting Dashboard
```

#### Step 4: DNS & SSL Certificate Verification (Web Deployment)
```bash
# Check DNS propagation
dig +short app.client.com
# Test SSL certificate status
curl -Iv https://app.client.com
```

#### Step 5: Mobile App Launch (Mobile Apps Only)
- [ ] **Android Keystore**: Release keystore `.jks` file securely stored in encrypted vault.
- [ ] **Build Android App Bundle**: `flutter build appbundle --release` or `cd android && ./gradlew bundleRelease` (produces `.aab` file).
- [ ] **Google Play Console**: Upload `.aab` to *Production* track (or run *Staged Rollout 20%*).
- [ ] **iOS Archive**: `flutter build ipa --release` or archive via Xcode with *Distribution Certificate* & *Provisioning Profile*.
- [ ] **Apple App Store Connect**: Upload `.ipa` via Transporter/Xcode $\to$ Submit for Review.
- [ ] **Force-Update Check**: Endpoint `/api/v1/app/version-check` returns minimum version `1.0.0`.

---

### 4. Monitoring & Alert Bot Activation (Observability)

- [ ] **Error Tracking**: Production Sentry DSN confirmed receiving test error events.
- [ ] **Uptime Ping**: Uptime Kuma / BetterStack actively monitoring `https://app.client.com/api/health` endpoint every 60 seconds.
- [ ] **Telegram/Slack/WA Alert**: Downtime notification bot connected to solo developer device.
- [ ] **Auto-Backup**: Daily backup cron job at 02:00 confirmed active.

---

## PART II: GO-LIVE VERIFICATION REPORT

### 1. Launch Metadata
- **System Name**: [Application Name]
- **Official Release Version**: `v1.0.0`
- **Official Public Domain**: `https://app.client.com`
- **Official Go-Live Time**: [YYYY-MM-DD] at [HH:MM UTC/WIB]
- **Lead Release Engineer**: [Your Name]
- **Operational Status**: **LIVE ON PRODUCTION (STABLE)**

---

### 2. Production Infrastructure Status

| Infrastructure Component | Service Provider | Configuration Status | Verification Result |
| :--- | :--- | :--- | :---: |
| **Domain & DNS** | Cloudflare / Provider | A & CNAME Records Active | DNS Resolution Passed |
| **Security Certificate** | Let's Encrypt / Cloudflare | TLS 1.3 Active (90-day validity) | SSL Labs Grade A |
| **Production Database** | Managed PostgreSQL v16 | Multi-AZ / Daily Backup Active | Connection Pool Stable |
| **Storage Vault** | Cloudflare R2 / AWS S3 | Private Bucket (AES-256-GCM Encryption) | Upload/Download Passed |
| **Payment Gateway** | Midtrans / Stripe / Xendit | **Production Mode (LIVE)** | Webhook Verified |
| **Transactional Email** | Resend / SendGrid | Sender Domain Verified (DKIM/SPF) | Delivery Rate 100% |

---

### 3. Post-Release Verification Test Results (Production Verification Testing)

Real transaction tests executed directly on public domain:

- [x] **PVT-01 (Authentication)**: Official Super Admin and Staff accounts successfully logged in to production system.
- [x] **PVT-02 (Document Creation)**: New draft document successfully inputted, rendered to official PDF, and securely stored in encrypted vault.
- [x] **PVT-03 (Digital Signature)**: Digital signature link opened on mobile device and signed successfully.
- [x] **PVT-04 (Real Transaction)**: Real payment transaction test successfully debited and updated order status instantly.
- [x] **PVT-05 (Observability)**: Uptime monitoring active with average latency of **125 ms** (target $< 200\text{ ms}$).

---

### 4. Operational Readiness Declaration

It is hereby declared that the software system is officially operating autonomously in the Production environment.

The project officially advances to the commercial closing and handover phase: **Module 11: [HANDOVER GATE] 100% Final Payment, Training, BAST, & Repository Handover**.

---

### 5. Go-Live Sign-Off Sheet

| Client Single PIC | Release Engineer |
| :--- | :--- |
| **Name**: _________________________ | **Name**: _________________________ |
| **Title**: ________________________ | **Title**: Independent Lead Engineer |
| **Date**: _________________________ | **Date**: _________________________ |
| **Signature**: | **Signature**: |
