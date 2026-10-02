# Deployment & Handover Phase TODO Template (Module 10 - Module 11)

> Atomic task checklist template for Production Release (Go-Live), Post-Deployment Verification, System Handover, and Final BAST Sign-Off with the Client.
> Rules: Execute deployment with strict discipline following the runbook. Ad-hoc manual changes (*cowboy deployments*) on production servers are strictly prohibited. Every step must have assertion evidence and a rollback procedure ready to execute at any time.

---

## Deployment & Handover Metadata
- **System Name**: [System / Application Name]
- **Production Target URL**: `https://app.clientdomain.com`
- **Lead Release Engineer / Solo Dev**: [Your Name]
- **Client Technical & Business PIC**: [Client PIC Name]
- **Deployment Window (Maintenance Window)**: [YYYY-MM-DD HH:mm - HH:mm UTC/Local]
- **Deployment Method**: Blue/Green | Canary | Rolling Update | Container Service
- **Release Gate Status**: [ ] PRE-FLIGHT | [ ] DEPLOYING | [ ] VERIFIED LIVE | [ ] HANDOVER COMPLETED

---

## 1. Module 10: Pre-Flight Checks (Pre-Flight Checks)

### 1.1 Team Preparation & Maintenance Window
- [ ] `deploy/pre-flight-checklist.md`: Establish release maintenance window during lowest traffic hours (e.g., Saturday/Sunday 23:00 - 03:00) - expect written schedule agreement with client
- [ ] `deploy/pre-flight-checklist.md`: Send official scheduled maintenance notification (banner/email) to users 48 hours and 2 hours prior to release - expect users informed
- [ ] `deploy/pre-flight-checklist.md`: Enforce Code Freeze: lock `main` or `release` branch in Git, prohibit new feature commits outside release patches that passed UAT - expect branch status stabilized

### 1.2 Production Infrastructure & Network Readiness
- [ ] `deploy/infrastructure-readiness.md`: Verify production server compute capacity (CPU, RAM, Disk I/O) ready for workload - expect resource allocations align with Capacity Planning document
- [ ] `deploy/infrastructure-readiness.md`: Configure public DNS records (A Record, CNAME, TXT records for SPF/DKIM) with low TTL (300 seconds) for fast propagation - expect DNS propagation monitored active
- [ ] `deploy/infrastructure-readiness.md`: Install and verify SSL/TLS certificates (Let's Encrypt / Cloudflare Edge Certificate) on primary domain and all subdomains - expect valid certificates and forced HTTPS redirection
- [ ] `deploy/infrastructure-readiness.md`: Configure Web Application Firewall (WAF) and DDoS protection on Cloudflare / AWS Shield (rate limiting rules, bot fight mode) - expect layer 7 protection active

### 1.3 Production Environment Variables & Secrets Audit
- [ ] `deploy/env-audit.md`: Prepare production configuration (`.env.production` or in Cloud Secret Manager / Doppler / Infisical / AWS Parameter Store) - expect zero staging dummy placeholders remaining
- [ ] `deploy/env-audit.md`: Run Zod / schema environment validator: `pnpm run check:env` - expect all mandatory variables fully defined without error
- [ ] `deploy/env-audit.md`: Verify active third-party production credentials:
  - Production Database URL with connection pooling (PgBouncer / Supabase pooler)
  - Production Payment Gateway API Keys & Webhook Secret
  - Production Email Service (Resend / AWS SES / SendGrid) domain verified
  - Production Object Storage (Cloudflare R2 / AWS S3) bucket permissions locked private
  - expect all third-party integrations respond with valid authentication status

### 1.4 Database Backup & Rollback Contingency Baseline
- [ ] `deploy/backup-verification.md`: Execute full database backup snapshot (*pg_dump*) immediately prior to release execution: `pg_dump -Fc -v -h <host> -U <user> <dbname> > backup_pre_deploy.dump` - expect dump file integrity verified and stored in secure off-site storage
- [ ] `deploy/rollback-plan.md`: Document step-by-step explicit Rollback Plan in case deployment fails - expect tested recovery shell commands
- [ ] `deploy/rollback-plan.md`: Define Rollback Triggers:
  - Database migration error that compromises schema integrity
  - Healthcheck endpoint `/healthz` fails to respond within 5 minutes post-release
  - Error rate on APM exceeds > 1% within first 15 minutes
  - Core user transaction failure cannot be patched within 30 minutes
  - expect uncompromising commitment to execute rollback if any trigger is met

---

## 2. Module 10: Deployment Execution Steps (Deployment Steps)

### 2.1 Production Database Migration Execution
- [ ] Enable temporary maintenance page (*Maintenance Page / 503 Service Unavailable Banner*) if deployment requires database schema downtime - expect incoming user traffic safely queued/held
- [ ] Run production database schema migration scripts: `pnpm prisma migrate deploy` (or equivalent migration tool) - expect migration completes with exit code 0 and zero constraint failures
- [ ] Verify new tables, indexes, and mandatory seed data (master reference data, initial superadmin account, role permissions) - expect production schema 100% synchronized with FSD design

### 2.2 Application Build Compilation & Distribution
- [ ] Execute optimized production build artifact: `pnpm build` (or trigger GitHub Actions CI/CD pipeline) - expect JS/CSS asset bundling succeeds without TypeScript errors or circular dependencies
- [ ] Deploy new container image / deploy serverless bundle to production compute cluster - expect container pull and new instance spawn proceed smoothly
- [ ] Invalidate CDN cache (*Cloudflare Cache Purge / AWS CloudFront Invalidation*) to ensure clients receive latest JavaScript and CSS assets - expect users avoid chunk load errors

### 2.3 Health Check Evaluation
- [ ] Test server readiness endpoint: `curl -I https://app.clientdomain.com/healthz` - expect HTTP 200 OK
- [ ] Test dependency service connections via internal diagnostic endpoint: database connection, Redis cache connection, worker queue connection, and disk access - expect all report `HEALTHY` status
- [ ] Disable maintenance page and route full live user traffic (*Switch traffic to live*) - expect public traffic flows normally

---

## 3. Module 10: Post-Deployment Verification (Post-Deployment Verification)

### 3.1 Production Smoke Testing (Live Smoke Testing)
- [ ] Execute critical flow tests directly in the production environment using dedicated operator test accounts:
  - User authentication flows (*Admin & Regular User Login*)
  - Core entity data creation and persistence
  - Cloud file upload and thumbnail image rendering
  - Payment simulation transaction / real processing flow
  - Transactional notification email delivery to real inbox
  - expect all core flows operate smoothly without disruption
- [ ] Clean up test data artifacts (*cleanup test artifacts*) or flag as testing data to avoid polluting client actual financial/analytics reports - expect clean production data integrity

### 3.2 Real-Time Log & Telemetry Monitoring
- [ ] Monitor live server streaming logs (*tail live logs*) for at least 30 minutes post-release - expect zero recurring unhandled exceptions, fatal crashes, or connection leaks
- [ ] Open APM & error tracking dashboard (Sentry / Datadog / Logflare) - expect zero new unhandled issue reports
- [ ] Inspect production server performance metrics (CPU load, Memory usage, Network traffic, Active DB Connections) - expect resource utilization within normal range (< 40%)
- [ ] Measure Core Web Vitals and Time to First Byte (TTFB) on live production pages - expect TTFB < 300 ms and First Contentful Paint (FCP) < 1.5 seconds

---

## 4. Module 11: System Handover & Documentation (Handover Tasks)

### 4.1 Operational & User Documentation Preparation
- [ ] `docs/03-handover/USER_MANUAL.pdf`: Compile end-user application manual (*User Manual*) with UI screenshots and workflow guides - expect manual easily understood by client operations staff
- [ ] `docs/03-handover/ADMIN_GUIDE.pdf`: Compile system administrator manual (*Admin Manual*): user management, role access controls, account reset procedures, and configuration settings navigation - expect comprehensive admin guide
- [ ] `docs/03-handover/OPERATIONAL_RUNBOOK.md`: Compile technical operational runbook for client IT team:
  - Service start/stop/restart operational guides
  - Daily database backup and restoration procedures
  - Credential and API key rotation procedures
  - Emergency troubleshooting playbooks
  - expect self-sufficient technical documentation enabling client IT team to operate the system

### 4.2 Training & Knowledge Transfer
- [ ] Schedule and conduct in-person / virtual Knowledge Transfer Session for client operations staff and IT team - expect attendance of all relevant PICs
- [ ] Document video recordings of training sessions and link them to project documentation repository - expect training materials neatly archived for future client staff onboarding
- [ ] Facilitate interactive Q&A session and self-guided practice for client staff - expect client team capable of executing all operational workflows unassisted

### 4.3 Source Code & Infrastructure Ownership Transfer
- [ ] Transfer Git repository ownership (GitHub / GitLab) to client official organization or invite client technical account as Owner - expect client has full control over source code
- [ ] Transfer cloud infrastructure access (Vercel, AWS, Cloudflare, Supabase, Neon) to client primary enterprise email - expect billing and account ownership transferred to client company
- [ ] `docs/03-handover/CREDENTIAL_VAULT.md`: Hand over all master credentials, database root passwords, API secrets, and encryption keys via secure encrypted channels (1Password / Bitwarden encrypted share link) - expect credentials never transmitted via unsecured chat or plain email
- [ ] Revoke or downgrade consultant/personal account privileges from Administrator to limited Maintenance role (if continuing on SLA) or remove completely if project engagement closes - expect access governance compliance

### 4.4 Final Handover Acceptance (Final BAST) & Final Payment Invoice
- [ ] `docs/03-handover/BAST_FINAL.pdf`: Issue official Final Handover Acceptance Certificate (*BAST Final*) containing:
  - Statement that all deliverables per SOW have been successfully delivered and function as specified
  - Official commencement date of the Warranty Period (*Warranty Period*)
  - Wet signature / digital certificate (e-Meterai / DocuSign) by Lead Consultant and Client Director / Project Sponsor
  - expect BAST document legally executed by both parties
- [ ] `invoices/INVOICE_FINAL_PAYMENT.pdf`: Issue final milestone payment invoice (Milestone 3: 10%-20%) - expect invoice delivered to client finance department with clear payment due date
- [ ] Verify receipt of final payment into bank account - expect all commercial project obligations 100% cleared

---

## 5. Deployment & Handover Phase Verification Gate

| Evaluation Parameter | Minimum Pass Standard | Verification Status | Evidence Notes |
| :--- | :--- | :---: | :--- |
| **Pre-Flight Readiness** | DNS propagated, SSL active, env secrets valid, pre-deploy DB backup successful | [ ] PASS | Attached in `deploy/` |
| **Release Execution** | Production DB migration succeeded, clean build, container up, `/healthz` HTTP 200 | [ ] PASS | Attached production release logs |
| **Production Smoke Test** | Core live transaction flows 100% passed, test data purged, Sentry 0 fatal errors | [ ] PASS | Attached smoke test evidence |
| **Documentation & Training** | User Manual, Admin Guide, and Runbook delivered; training sessions completed | [ ] PASS | Attached in `docs/03-handover/` |
| **Access & Credential Transfer** | Repo & cloud ownership transferred, credentials handed over via secure vault | [ ] PASS | Attached access transfer confirmation |
| **Final BAST & Final Payment** | Executed Final BAST with stamp/signature signed, final invoice paid 100% | [ ] PASS | Attached `BAST_FINAL.pdf` & wire transfer proof |

### Deployment Gate Decision:
- [ ] **FULLY COMPLETED (GO TO MAINTENANCE & WARRANTY - M12)**: System is live, Final BAST executed, and full ownership transferred to client. Transition project to warranty & maintenance in Module 12.
- [ ] **EMERGENCY ROLLBACK (EMERGENCY ROLLBACK)**: Fatal anomalies occurred in production post-release. Immediately execute rollback runbook to previous stable release!
- [ ] **PENDING BAST / HANDOVER (HOLD MILESTONE)**: System active in production but BAST document or administrative payments pending. Complete administrative handover.
