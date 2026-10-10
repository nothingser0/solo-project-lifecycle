# Module 10: Deployment & Production Go-Live (Official Launch to Production Environment)

This module is the tenth phase in the software project lifecycle for solo developers. Its purpose is to promote UAT-passed code from the `staging` branch to the `main` branch, configure official production infrastructure (Domain DNS, SSL TLS 1.3, Cloudflare, Production Database), execute zero-downtime database migrations, enable observability monitoring, and conduct post-deployment smoke testing until the system is officially **LIVE ON PRODUCTION**.

---

## 1. Execution Cycle of Module 10

```text
[ INPUT: Valid UAT Sign-Off Report (Module 09) & Stable Code on staging Branch ]
                                    │
                                    ▼
[ STEP 1: [GATE] Pre-Release Verification (Go / No-Go Gate) ]
  • Verify Signed UAT Sign-Off Report (Mandatory Prerequisite)
  • Local Build & Integration Test Gate: npm run build and npm run test:smoke MUST exit 0
  • Zero Agent Auto-Deploy / Auto-Push: Agent provides runbook only; human deploys
  • Safe Release Window: Prohibited to release Friday afternoon or before holidays
  • Database Snapshot Backup Prior to Migration Execution
                                    │
                                    ▼
[ STEP 2: Git Branch Merge & Official Version Tagging (SemVer Tag) ]
  • Merge staging ──► main (Clean Production Codebase)
  • Tag Release: git tag -a v1.0.0 -m "Release Production v1.0.0"
  • Push to Remote Repository to Trigger Production CI/CD Pipeline
                                    │
                                    ▼
[ STEP 3: Infrastructure Provisioning & Production Secrets ]
  • Configure Official Domain DNS (A / CNAME Record) & SSL TLS 1.3 Certificate
  • Configure Production Environment Variables (.env.production - Live Keys)
  • Switch Payment Gateway Credentials from Sandbox ──► Production Mode
                                    │
                                    ▼
[ STEP 4: Production Database Migration Execution (Zero-Downtime) ]
  • Execute SQL DDL Schema Migration on Production Database
  • Import Verified Client Real Data (Result from Module 08)
                                    │
                                    ▼
[ STEP 5: Monitoring Activation & Alert Bots (Live Observability) ]
  • Connect Sentry / Automated Error Tracker
  • Setup Uptime Healthcheck Monitor (Ping every 60 seconds to /api/health)
  • Verify Automated Daily Database Backup Schedule
                                    │
                                    ▼
[ STEP 6: Post-Deployment Verification Testing (Production Smoke Test) ]
  • Test Real Transactions on Public Domain (https://app.client.com)
  • Prepare GO_LIVE_REPORT.md Document
                                    │
                                    ▼
[ OUTPUT: System LIVE on Production & GO_LIVE_REPORT.md ] ──► Ready to Proceed to Module 11: Handover & BAST
```

---

## 2. Three Golden Rules of Solo Developer Deployment

1. **The "No Friday Deployment" Rule**:
   - PROHIBITED from launching a new system into production on **Friday afternoon, weekends, or the eve of a national public holiday**.
   - **Agent Check**: Before deploying, check current day. If Friday >14:00, Saturday, or Sunday → prompt user: "⚠️ Deployment postponed. Reschedule to Tuesday-Thursday 09:00-14:00 for optimal support window."
   - If unexpected issues arise, the solo developer will be trapped in emergency weekend overtime without support from the client's technical team or cloud vendor customer support.
   - Ideal release window: **Tuesday or Wednesday at 09:00–11:00 AM** (all parties on full alert).
2. **Real Production Credentials (Zero Sandbox Keys in Prod)**:
   - Ensure environment variables on the production server have been replaced with real accounts (Live Payment Gateway API Key, Live SMTP, Live Cloudflare R2), not staging sandbox test accounts.
3. **Mandatory Emergency Rollback Plan**:
   - Before hitting the deploy button, the solo dev must know exactly how to restore the system to its previous state within < 15 minutes in the event of a fatal failure.
4. **Project Readiness Gate (No Premature Deployments)**:
   - PROHIBITED from deploying or writing deployment runbooks before the project is fully functional locally.
   - Compilation (`npm run build`), database migrations, and core test suites must pass 100% with exit code 0 before initiating production deployment.

---

## 3. Step-by-Step Execution

**Deployment Patterns**: See `../../patterns/deployment/ci-cd-pipeline.md` for:
- GitHub Actions CI/CD setup (lint, test, build, deploy)
- Deployment strategies (blue-green, rolling, canary)
- Health checks and monitoring
- Automated rollback mechanisms
- Secrets management (GitHub Secrets, Vault)

### Step 1: Pre-Release Verification (Pre-Flight Checklist)

1. Verify `UAT_SIGNOFF_REPORT.md` file: Ensure the Client Single PIC signature is valid.

2. **CRITICAL: Verify Production Environment Variables**

   Before touching DNS or deployment, verify production ENV:

   ```bash
   # Verify payment gateway mode
   [[ "$PAYMENT_GATEWAY_MODE" =~ ^(production|live)$ ]] && echo "✅ Payment mode production" || echo "❌ NOT PRODUCTION"

   # Verify database URL (non-emitting check)
   echo "$DATABASE_URL" | grep -q -E 'prod|production|live' && echo "✅ Production DB verified" || echo "❌ INVALID DB TARGET"

   # Verify API keys (non-emitting prefix validation)
   if [[ "$STRIPE_SECRET_KEY" =~ ^sk_live_ ]]; then
     echo "✅ Stripe live key verified"
   else
     echo "❌ INVALID STRIPE KEY"
   fi

   # Verify JWT secret non-empty
   [[ -n "$JWT_SECRET" && ${#JWT_SECRET} -ge 32 ]] && echo "✅ JWT secret valid" || echo "❌ WEAK OR MISSING JWT SECRET"

   # Verify encryption key non-empty
   [[ -n "$ENCRYPTION_KEY" && ${#ENCRYPTION_KEY} -ge 32 ]] && echo "✅ Encryption key valid" || echo "❌ WEAK OR MISSING ENCRYPTION KEY"
   ```

   **Checklist Production ENV**:
   - [ ] `PAYMENT_GATEWAY_MODE=production` (NOT sandbox)
   - [ ] **STRIPE_SECRET_KEY** (if used) starts with `sk_live_` (not `sk_test_`)
   - [ ] **MIDTRANS_SERVER_KEY** (if used) does NOT contain `sandbox`
   - [ ] Run verification: `grep -E "sk_test|sandbox|test_" .env.production && echo "⚠️ TEST KEYS DETECTED" || echo "✓ Production keys verified"`
   - [ ] `DATABASE_URL` points to production DB
   - [ ] `STRIPE_SECRET_KEY` starts with `sk_live_`
   - [ ] `MIDTRANS_IS_PRODUCTION=true`
   - [ ] `SMTP_HOST` is production mail server (NOT mailtrap/mailpit)
   - [ ] `STORAGE_BUCKET` is production bucket (NOT staging)
   - [ ] `JWT_SECRET` different from staging
   - [ ] `ENCRYPTION_KEY` rotated for production
   - [ ] `CORS_ORIGIN` matches production domain
   - [ ] `SENTRY_DSN` with `environment: "production"`
   - [ ] `SESSION_SECRET` unique to production

   **STOP deployment if sandbox keys are still present!**

3. **Rollback Plan Dry-Run Verification**:

   - [ ] Rollback plan dry-run executed in staging (verify git revert + DB restore time)
   - [ ] Database migration rollback script tested (if DDL changes exist)
   - [ ] Documented: can we restore last known good state in <15 minutes?

   **WARNING**: DDL migrations (ADD COLUMN, DROP TABLE) may not be reversible without data loss. Test rollback procedure in staging first.

4. Take a manual snapshot backup of the production database (if updating an existing system):
   ```bash
   pg_dump -U postgres -d legal_vault_prod -F c -b -v -f "backup-pre-deploy-$(date +%Y%m%d).dump"
   ```

### Step 2: Git Merge & Official Version Tagging
1. Switch to branch `main` and merge code from `staging`:
   ```bash
   git checkout main
   git merge --no-ff staging
   ```
2. Tag the official version release:
   ```bash
   git tag -a v1.0.0 -m "Release Production v1.0.0 - Go-Live"
   git push origin main --tags
   ```

### Step 3: DNS & SSL Configuration

> 🛡️ **LEVERAGE-SAFE COMMERCIAL HANDOVER RULE (`Delivery: client`)**:
> - Under the standardized 30/40/30 contract (`03-legal-sow-charter.md:76` and `SOW_CONTRACT_CONSOLIDATED_TEMPLATE.md:111`), **Milestone 3 (Final 30%) is payable prior to DNS production pointing and BAST handover**.
> - In Module 10, the developer deploys to a **developer-controlled production/preview server** to execute PVT testing and produce `GO_LIVE_REPORT.md`.
> - Pointing the Client's official primary domain (`app.client.com`) and transferring master cloud/repo credentials **MUST BE HELD AS COMMERCIAL LEVERAGE** until 100% final payment clears in Module 11 (`11-handover-bast.md:57-63`).
> - For `Delivery: solo | internal | portfolio`, configure the primary production domain directly.

1. Log into the domain provider's DNS dashboard (Cloudflare, Niagahoster, Route53).
2. Point DNS Records (Staged / Production based on delivery model):
   - `Type A`: `@` → Production Server IP / Load Balancer.
   - `CNAME`: `app` or `www` → hosting domain (Vercel / Cloud Run).
3. Verify DNS propagation using `dig` or `nslookup`.
4. Ensure SSL certificate is issued and achieves at least a **Grade A** rating on SSL Labs (TLS 1.3 enabled).


> **M08 CONDITIONAL BYPASS**: M08 Data Migration is skipped for greenfield projects (no legacy data to import).
> - IF M08 executed: Follow data import and reconciliation steps below
> - IF M08 skipped (greenfield): Skip to Step 5 (schema migration), verify seed data only
### Step 4: Import Verified Client Real Data (Result from Module 08)

**IMPORTANT**: This data originates from Module 08 results that passed UAT. Choose one of the following 3 methods to migrate data to production:

**OPTION A: Re-run ETL Script to Production** (Recommended - Fresh Import)

If source data (Excel/CSV) is still available and unchanged since UAT:

```bash
# Run ETL script directly against production DB
DATABASE_URL="postgresql://user:***@prod-db:5432/db" node scripts/runtime/etl-import.js --source data/client-final.xlsx

# Verify row count
psql $DATABASE_URL -c "SELECT COUNT(*) FROM documents;"
psql $DATABASE_URL -c "SELECT COUNT(*) FROM users;"
```

**Benefit**: Fresh data, no staging artifacts, reconciliation identical to UAT.

---

**OPTION B: Copy Staging Database to Production** (Faster - Staging Dump)

If staging DB data has already passed UAT without alterations:

**Pre-Migration Test Data Verification** (MANDATORY before dump):

```bash
# Verify no test data in staging
psql $STAGING_DB_URL -c "SELECT COUNT(*) FROM users WHERE email LIKE '%test%';"
# Expected: 0 test accounts

psql $STAGING_DB_URL -c "SELECT COUNT(*) FROM documents WHERE title = 'Test Document';"
# Expected: 0 test documents

psql $STAGING_DB_URL -c "SELECT COUNT(*) FROM users WHERE email LIKE '%@example.com';"
# Expected: 0 example.com emails (common test pattern)
```

**STOP if test data found!** Clean staging DB before proceeding.

```bash
# Dump staging DB
pg_dump -U postgres -h staging-db -d legal_vault_staging -F c -b -v -f staging-uat-approved.dump

# Restore to production DB
pg_restore -U postgres -h prod-db -d legal_vault_prod -v staging-uat-approved.dump

# Verify row count match
psql postgresql://prod-db/legal_vault_prod -c "SELECT COUNT(*) FROM documents;"
```

**Risk**: Ensure staging DB is clean and no test data is mixed in.

---

**OPTION C: Manual Migration (Last Resort)**

If data volume is small (<100 rows) and ETL script is unavailable:

```bash
# Export staging data to CSV
psql postgresql://staging-db/legal_vault_staging -c "COPY documents TO STDOUT WITH CSV HEADER" > documents.csv

# Import to production
psql postgresql://prod-db/legal_vault_prod -c "COPY documents FROM STDIN WITH CSV HEADER" < documents.csv
```

---

**Post-Migration Verification (MANDATORY)**:

```bash
# Check row count consistency (IF M08 executed: match M08 reconciliation report)
echo "Users: $(psql $PROD_DB_URL -tAc 'SELECT COUNT(*) FROM users')"
echo "Documents: $(psql $PROD_DB_URL -tAc 'SELECT COUNT(*) FROM documents')"

# Check data integrity
psql $PROD_DB_URL -c "SELECT * FROM documents WHERE created_at IS NULL LIMIT 5;"
# Expected: 0 rows (no NULL timestamps)

# Check foreign key integrity
psql $PROD_DB_URL -c "SELECT COUNT(*) FROM documents d LEFT JOIN users u ON d.creator_id = u.id WHERE u.id IS NULL;"
# Expected: 0 (no orphaned documents)

# Verify application-level data access
curl -X POST https://app.client.com/api/auth/login \
  -d '{"email":"admin@client.com","password":"***"}' \
  | jq '.token' # Should return valid JWT

# Verify document retrieval
curl https://app.client.com/api/documents?limit=5 \
  -H "Authorization: Bearer ***" # Should return real documents
```

**IF M08 executed**: Match row count with UAT_SIGNOFF_REPORT.md Section "Data Migration Reconciliation".  
**IF M08 skipped** (Small/Medium greenfield): Verify seed data exists (admin user, sample records).

---

### Step 5: Production Database Schema Migration Execution

Execute SQL DDL schema migration on the production database:

```bash
DATABASE_URL="postgresql://user:***@prod-db:5432/db" pnpm db:migrate
```

*Solo Dev Note: Ensure migration scripts are additive (only adding new columns/tables); destructive commands (`DROP COLUMN` / `TRUNCATE`) are strictly prohibited.*

### Step 6: Observability & Alerting Activation
1. Ensure production environment Sentry DSN is active (`environment: "production"`).
2. Register the URL `https://app.client.com/api/health` with an uptime monitoring service (Uptime Kuma, BetterStack, or Cronitor).
3. Connect alert bots to a Telegram group or the solo dev's WhatsApp number for instant notifications if the server goes down.

### Step 7: Production Verification Test (PVT)
Open a browser on the official public domain:
1. Test authentication login flow with production accounts.
2. Test creating 1 sample document and ensure the PDF generates and stores in the production storage bucket.
3. Perform 1 real low-nominal payment transaction (e.g. Rp 10.000 via QRIS) to validate the production payment gateway webhook.
4. Compile test evidence into the **`GO_LIVE_REPORT.md`** document.

---

## 4. Mobile App Deployment Specific Workflow (Android & iOS)

If the project includes a mobile application (Flutter / React Native / Native), the deployment process involves App Store Ecosystem characteristics distinct from web:

```text
[ SOURCE CODE STAGING ]
           │
           ├──────────────────────────────────────┐
           ▼                                      ▼
   [ ANDROID RELEASE ]                     [ IOS RELEASE ]
   • Signing: Release Keystore (.jks)     • Signing: Distribution Cert & Provisioning Profile
   • Build: Android App Bundle (.aab)     • Build: iOS Archive (.ipa) via Xcode / Fastlane
   • Beta: Internal App Sharing           • Beta: Apple TestFlight Internal/External
           │                                      │
           ▼                                      ▼
[ GOOGLE PLAY CONSOLE ]                    [ APPLE APP STORE CONNECT ]
• Review: 24–72 Hours (Automated & Manual) • Review: 24–48 Hours (Strict Apple Guidelines)
• Phased Rollout: 10% ──► 50% ──► 100%    • Phased Release: 7-Day Phased
```

### 4.1 Key Management & Signing (Keystore & Certificates)
- **Android**: Generate production keystore and store the `.jks` file along with alias passwords in an encrypted vault (Bitwarden). *If the keystore is lost, the application can never be updated on the Google Play Store again.*
- **iOS**: Enroll in the Client's Apple Developer Program ($99/year). Create distribution certificates and App Store Provisioning Profiles.

### 4.2 Pre-Public Beta Testing Strategy (TestFlight & Internal Sharing)
- Directly releasing the first build to public production is prohibited.
- **Android**: Upload to the **Internal Testing** track in Google Play Console $\to$ share link with Client Single PIC for verification on real Android devices.
- **iOS**: Upload to **TestFlight** $\to$ invite Client Single PIC Apple ID email address to test on real iPhone devices.

### 4.3 Factoring in App Store Review Buffer
- Unlike web which can be released instantly in 2 minutes, mobile releases depend on human review schedules:
  - Apple App Store: Requires **24–48 business hours**.
  - Google Play Console: Requires **24–72 business hours** (especially for new developer accounts).
- **Client Complaint Mitigation Strategy**: State in the schedule that mobile go-live dates are calculated from when the app status changes to *Ready for Sale / Published* by app stores.

### 4.4 Rollback & Mobile Emergency Updates (OTA & Force Update)
- Mobile apps cannot be rolled back instantly if critical bugs reach users.
- **Mandatory Force-Update Mechanism**: Mobile apps must include a minimum version check on the splash screen (`GET /api/v1/app/version-check`). In the event of a critical bug, the backend can force users to update to the latest version before accessing the dashboard.
- **Over-The-Air (OTA) Updates**: For React Native (Expo Updates) or Flutter (Shorebird), implement an OTA patch mechanism so minor JavaScript/Dart bug fixes can be deployed immediately without going through app store review again.

---

## 5. Adaptation by Project Scale

| Deployment Aspect | 🔵 Small Scale (Fast-Track MVP) | 🟢 Medium Scale (B2B SaaS / Agency) | 🟡 Large Scale (High-Availability) | 🔴 Enterprise (Non-Solo Capacity) |
| :--- | :--- | :--- | :--- | :--- |
| **Infrastructure** | PaaS (Vercel / Railway / Render) | Managed Cloud Run / Docker VPS + Managed DB | Multi-region AWS/GCP, Private VPC, Redis cluster | **Dialihkan ke Seri A (Fase A03/A00)** |
| **Release Strategy** | Instant rolling restart (< 1 min) | Blue-Green Deployment / Container Swap | Phased Canary Deployment (10% $\to$ 50% $\to$ 100%) | Tata kelola arsitektur rilis vendor korporat |
| **Release Schedule** | Regular business hours (Tuesday morning) | Scheduled maintenance (Tuesday 10:00 WIB) | Scheduled maintenance window with CAB RFC | Pengawasan komite CAB & arsitektur rilis korporat |
| **Rollback Plan** | Git revert + automated instant rollback | Standby container swap / backup snapshot | Wajib `docs/pm/ROLLBACK_PLAN.md` (drill <15 min) | Disaster Recovery & Business Continuity Dossier |

---

### 🔴 Enterprise Scale: Routed to Non-Solo Capacity Advisory (Phase A03/A00)

> ⚠️ **SOLO CAPACITY LIMITATION ENFORCEMENT**:  
> Projects classified as **Enterprise Scale** ($\ge 26$ P0 features, legacy core migrations, or strict regulatory statutory mandates) **EXCEED SOLO DEVELOPER CAPACITY**.  
> Solo developers MUST NOT execute high-blast-radius enterprise production cutovers single-handedly.  
> Instead, the solo consultant executes **Phase A03/A00 Advisory Handover** to define Change Advisory Board (CAB) governance, review vendor deployment runbooks, and verify RFC compliance.

**Change Control & CAB Governance**:
- `templates/03-governance/CAB_PROCESS.md` - Change Advisory Board approval workflow
  - **RFC (Request for Change)**: Submit 3 business days before deployment
  - **CAB review**: Risk assessment, blast radius, rollback plan, maintenance window approval
  - **Why**: Banking/government require formal change control (audit trail, stakeholder approval)

**Advisory Release Gate for Enterprise**:
- CAB RFC documented and approved (`templates/03-governance/CAB_PROCESS.md`)
- Disaster Recovery / Business Continuity Plan aligned (`templates/08-maintenance-ops/DISASTER_RECOVERY_PLAN.md`)
- Vendor deployment runbook reviewed with client DevOps leadership

---

## 6. Deliverables

> 📁 **MANDATORY FILE LOCATION RULE**:
> Runbooks and go-live reports MUST be stored in the **`docs/`** or **`docs/pm/`** folder.

This module produces 3 authoritative execution documents:
1. **`docs/pm/DEPLOYMENT_PROTOCOL.md`**: Deployment runbook, target topology, zero-downtime migration steps, and PVT checklists (using `templates/07-release-handover/DEPLOYMENT_PROTOCOL_TEMPLATE.md`).
2. **`docs/pm/GO_LIVE_REPORT.md`**: Post-deployment verification test (PVT) proof, live endpoint status, and SSL rating attestation (using `templates/07-release-handover/GO_LIVE_REPORT_TEMPLATE.md`).
3. **`docs/pm/ROLLBACK_PLAN.md`**: Emergency recovery procedures ensuring <15 minute restoration in case of cutover failure (using `templates/07-release-handover/ROLLBACK_PLAN_TEMPLATE.md`; mandatory for Large Scale).

---

## 7. Gate Exit Criteria [GATE]

[GATE] Module 10 is declared **PASSED (PASS)** if:
- [ ] Branch `main` has been tagged with official SemVer version (`v1.0.0`).
- [ ] Official domain (`https://app.client.com`) is active with valid SSL/TLS 1.3 encryption.
- [ ] Production database migration successfully executed without data loss.
- [ ] All environment variables use live production accounts (not sandbox).
- [ ] Post-release real transaction test (*PVT*) succeeded 100%.
- [ ] Uptime monitoring system and Sentry error tracker are active.

---

## 🛑 EXIT [GATE] PROTOCOL & MANDATORY STOP

After the system is officially Live in Production and the PVT report is published:

### **STEP 0: FILE EXISTENCE VERIFICATION (BLOCKING CHECK)**

**MANDATORY BEFORE CONTENT VALIDATION**:

1. **Check output file existence** using one of the following methods:
   - PowerShell: `Test-Path -LiteralPath "docs/pm/GO_LIVE_REPORT.md"` → must return `True`
   - Read and verify file `docs/pm/GO_LIVE_REPORT.md` → must succeed without error

2. **IF FILE DOES NOT EXIST**:
   - ❌ **STOP IMMEDIATELY** - do not proceed to content validation
   - ❌ **DO NOT display summary** to user
   - ❌ **DO NOT request confirmation** to proceed to Module 11
   - ✅ **REPORT ERROR** to user:
     ```
     CRITICAL ERROR: File GO_LIVE_REPORT.md was not created.
     Module 10 FAILED - cannot proceed to Module 11 (Handover & BAST).
     
     Possible causes:
     - Write permission denied on docs/pm/ folder
     - Path typo in tool call
     - Disk full
     
     Please investigate this issue before proceeding.
     ```
   - ✅ **END TURN** and wait for user to fix issue

3. **ONLY IF FILE EXISTS**: Proceed to content validation below

---

### **STEP 1: CONTENT VALIDATION & PRODUCTION VERIFICATION**

1. **STRICTLY PROHIBITED from directly handing over repositories, root passwords, or calling tools for Module 11 within the same turn!**
2. **Verify production deployment**:
   - [ ] Read and verify file `docs/pm/GO_LIVE_REPORT.md` → Confirm PVT tests PASS
   - [ ] Confirm domain live with valid SSL (https://app.client.com accessible)
   - [ ] Confirm monitoring active (Sentry DSN, uptime checker)
   - [ ] Confirm production transaction tested successfully
3. Present production go-live success status to user:
   - Official active production domain
   - Real transaction verification test (PVT) results
   - Uptime monitoring status & Sentry error tracker
4. **END YOUR RESPONSE (END TURN)** and ask user for confirmation:
   > *(For Client Delivery)*: *"The system is verified production-ready on live infrastructure (PVT PASS). Verification evidence is documented in `docs/pm/GO_LIVE_REPORT.md`. Are you ready to issue the final 30% settlement invoice before official domain pointing and repository transfer in Module 11?"*  
   > *(For Solo / Internal Delivery)*: *"The system is officially LIVE on the production server. Verification evidence is documented in `docs/pm/GO_LIVE_REPORT.md`. Are you ready to proceed to Module 12 (Operations & Runbook)?"*
5. Wait for explicit approval response from user before advancing to Module 11.
