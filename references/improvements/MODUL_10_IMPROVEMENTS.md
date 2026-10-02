# Modul 10 Improvements: Deployment & Production Go-Live

## 1. Timeline Estimation (by Project Scale)

| Phase | Kecil (MVP) | Menengah (SaaS) | Besar | Enterprise |
|-------|-------------|-----------------|-------|-----------|
| Pre-Flight Checklist | 1-2 jam | 2-3 jam | 4-6 jam | 8-12 jam |
| Git Merge & Tagging | 30 min | 1 jam | 2 jam | 4 jam (multi-repo) |
| Infrastructure Setup | 1-2 jam | 3-4 jam | 6-8 jam | 12-16 jam (multi-region) |
| Database Migration | 1-2 jam | 2-4 jam | 4-8 jam | 8-16 jam (zero-downtime) |
| Data Import (M08 strategy) | 1-2 jam | 3-6 jam | 6-12 jam | 12-24 jam (staging dump) |
| DNS Cutover | 30 min | 1 jam | 2 jam | 4 jam (multi-domain) |
| Production Smoke Test | 1-2 jam | 2-3 jam | 4-6 jam | 8-12 jam |
| Monitoring Setup | 1 jam | 2 jam | 4 jam | 8 jam |
| Go-Live Report | 1 jam | 2 jam | 4 jam | 8 jam |
| **TOTAL** | **8-13 jam (1-2 hari)** | **18-28 jam (2.5-3.5 hari)** | **36-56 jam (4.5-7 hari)** | **72-112 jam (9-14 hari)** |

### Assumptions
- Deploy window: Selasa/Rabu 09:00-17:00 (8 jam kerja/hari)
- No unexpected issues (add 50% buffer for troubleshooting)
- Client stakeholder available for smoke test validation

### Bottlenecks
- DNS propagation: +2-24 jam (global propagation, TTL-dependent)
- Database migration (>100k rows): +4-12 jam (batch processing)
- SSL certificate issuance delay: +1-4 jam (Let's Encrypt rate limit, domain verification)
- Client approval delay (smoke test sign-off): +1-2 hari

---

## 2. Blue-Green Deployment Strategy

### Problem
Rolling deployment (replace staging with production directly) causes downtime for existing users.

### Solution: Blue-Green Deployment

**Concept**: Run 2 identical production environments (Blue = current, Green = new). Switch traffic atomically.

---

### Infrastructure Setup

#### Platform-Specific Implementations

**Vercel** (Built-in Blue-Green):
```bash
# Deploy to preview environment (Green)
vercel --prod

# Vercel automatically:
# 1. Deploys new version to temporary URL (xxx-yyy.vercel.app)
# 2. Runs health checks
# 3. Switches production domain atomically if healthy
```

**Railway** (Manual Blue-Green):
```bash
# Step 1: Deploy new service (Green)
railway up --service app-green --environment production

# Step 2: Test Green environment
curl https://app-green-production.up.railway.app/api/health
# Expected: {"status":"healthy"}

# Step 3: Switch domain (atomic cutover)
# Railway dashboard → Networking → Custom Domain
# Point app.client.com → app-green service

# Step 4: Monitor traffic (5 min grace period)

# Step 5: Decommission Blue (after 24h stability)
railway service delete app-blue
```

**Docker + Nginx** (Manual Blue-Green):
```bash
# Step 1: Deploy Green container
docker-compose -f docker-compose.green.yml up -d

# docker-compose.green.yml
services:
  app-green:
    image: myapp:v2.0.0
    ports:
      - "3001:3000"  # Green runs on port 3001

# Step 2: Test Green
curl http://localhost:3001/api/health

# Step 3: Nginx cutover (atomic)
# /etc/nginx/sites-enabled/myapp.conf
upstream backend {
    server localhost:3001;  # Switch from 3000 (Blue) to 3001 (Green)
}

# Reload Nginx (zero downtime)
sudo nginx -t && sudo systemctl reload nginx

# Step 4: Monitor traffic
tail -f /var/log/nginx/access.log

# Step 5: Stop Blue container (after 24h)
docker stop app-blue
```

---

### Blue-Green Cutover Checklist

**Pre-Cutover**:
- [ ] Green environment deployed and tested (smoke test passed)
- [ ] Database migrations applied to shared production DB
- [ ] Green environment ENV vars match production (verified)
- [ ] Load balancer/proxy config prepared (not yet switched)

**Cutover (Atomic)**:
- [ ] Lower DNS TTL to 300s (5 min) — 24h before cutover
- [ ] Switch traffic: Blue → Green (load balancer config change)
- [ ] Verify new traffic routing to Green (check logs)
- [ ] Monitor error rate (should remain <1%)

**Post-Cutover**:
- [ ] Blue environment kept running (24h grace period for rollback)
- [ ] Monitor Sentry/logs for new errors
- [ ] Client smoke test validation
- [ ] Decommission Blue after 24h stability

---

### Rollback Protocol (Green → Blue)

**Trigger**: Error rate >5% or critical bug in Green

**Rollback Steps** (<5 minutes):
```bash
# Step 1: Revert load balancer config
# Nginx example:
upstream backend {
    server localhost:3000;  # Revert to Blue (port 3000)
}
sudo nginx -t && sudo systemctl reload nginx

# Railway example:
# Dashboard → Networking → Point domain back to app-blue service

# Step 2: Verify traffic back to Blue
curl https://app.client.com/api/health
# Should hit Blue container (check container logs)

# Step 3: Notify stakeholders
# "Rollback executed: reverted to v1.0.0 due to [reason]"
```

**Database Rollback** (if DDL changes):
```bash
# If Green introduced new columns (ADD COLUMN):
# No rollback needed (Blue ignores new columns)

# If Green dropped columns (DROP COLUMN):
# Rollback requires DB restore from pre-migration backup
pg_restore -U postgres -d myapp_prod backup-pre-deploy-20260930.dump
```

---

## 3. DNS Cutover Protocol

### Scenario: Staging Subdomain → Production Domain

**Before**: `https://staging.client.com` (working)  
**After**: `https://app.client.com` (production domain)

---

### Step-by-Step DNS Cutover

#### Phase 1: Pre-Cutover (24h before)

**1. Lower DNS TTL**:
```bash
# Cloudflare DNS dashboard
# Record: app.client.com → current-ip
# TTL: 86400 (24h) → 300 (5 min)
```

**2. Verify Staging SSL**:
```bash
# Ensure staging.client.com has valid SSL
curl -I https://staging.client.com
# Expected: HTTP/2 200, valid cert
```

**3. Prepare Production DNS Record**:
```bash
# DO NOT activate yet, just prepare:
# Type: A
# Name: app
# Value: <production-server-ip>
# TTL: 300
# Proxy: Yes (if Cloudflare)
```

---

#### Phase 2: Cutover (Deploy Day, 09:00 WIB)

**1. Activate Production DNS**:
```bash
# Cloudflare dashboard → DNS → Add Record
# Type: A
# Name: app
# Value: 203.0.113.42 (production server IP)
# TTL: 300 (5 min)
# Proxy: Enabled (Orange cloud icon)
# Click "Save"
```

**2. Verify Propagation** (wait 5-10 min):
```bash
# Check DNS resolution
dig app.client.com +short
# Expected: Cloudflare proxy IP (not direct server IP if proxied)

# Check HTTP response
curl -I https://app.client.com
# Expected: HTTP/2 200, valid SSL cert for app.client.com
```

**3. SSL Certificate Issuance** (if new domain):
```bash
# Vercel/Railway: Automatic SSL (no action needed)

# Self-hosted (Let's Encrypt + Certbot):
sudo certbot --nginx -d app.client.com
# Follow prompts, verify domain ownership

# Cloudflare: Automatic (Universal SSL)
# Check: SSL/TLS tab → Edge Certificates → Status: Active
```

---

#### Phase 3: Post-Cutover Validation

**1. Multi-Location DNS Check**:
```bash
# Use online tools:
# https://dnschecker.org/#A/app.client.com
# Verify all regions resolve to correct IP
```

**2. Production Smoke Test**:
```bash
# Test from external network (not localhost)
curl -X POST https://app.client.com/api/auth/login \
  -d '{"email":"test@client.com","password":"***"}'
# Expected: {"status":"success","token":"***"}

# Test file upload
curl -X POST https://app.client.com/api/documents \
  -H 'Authorization: Bearer ***' \
  -F 'file=@test.pdf'
# Expected: {"status":"success","id":"doc_***"}
```

**3. Monitor Traffic Shift**:
```bash
# Check server logs for new traffic
tail -f /var/log/nginx/access.log | grep app.client.com
# Should see requests to app.client.com (not staging.client.com)

# Check analytics
# Mixpanel/Google Analytics → Real-time → Verify traffic on new domain
```

---

#### Phase 4: Staging Decommission (Optional, +7 days)

**After 7 days stability**:
```bash
# Option A: Delete staging subdomain
# Cloudflare → DNS → Delete staging.client.com A record

# Option B: Redirect staging → production
# Nginx config:
server {
    listen 443 ssl;
    server_name staging.client.com;
    return 301 https://app.client.com$request_uri;
}
```

---

### DNS Cutover Checklist

- [ ] DNS TTL lowered to 300s (24h before cutover)
- [ ] Production DNS record prepared (not activated)
- [ ] SSL certificate plan verified (auto or manual)
- [ ] Cutover executed (DNS record activated)
- [ ] Propagation verified (dig, dnschecker.org)
- [ ] SSL certificate issued and valid
- [ ] Production smoke test passed (login, upload, payment)
- [ ] Traffic monitored (logs, analytics)
- [ ] Staging subdomain redirected or decommissioned (+7 days)

---

## 4. Rollback Execution Playbook

### Goal: Revert to Last Known Good State in <15 Minutes

---

### Rollback Triggers (When to Execute)

| Trigger | Severity | Action |
|---------|----------|--------|
| **Error rate >10%** (Sentry) | Critical | Immediate rollback |
| **Database corruption** | Critical | Rollback + restore DB backup |
| **Payment gateway fails** | Critical | Rollback + notify client |
| **Critical bug (data loss risk)** | Critical | Rollback + hotfix |
| **Performance degradation >2x** | High | Rollback or scale up |
| **Minor UI bug** | Low | No rollback, hotfix next deploy |

---

### Rollback Playbook (Step-by-Step)

#### Scenario: Deployed v2.0.0, Need to Revert to v1.9.0

---

#### Step 1: Identify Last Good Version (<2 min)

```bash
# Check git tags
git tag -l --sort=-version:refname | head -5
# Output:
# v2.0.0 (current, broken)
# v1.9.0 (last known good)
# v1.8.5

# Verify v1.9.0 commit
git show v1.9.0 --oneline
# Output: a3f52b1 (HEAD -> main, tag: v1.9.0) Release v1.9.0
```

---

#### Step 2: Revert Application Code (<3 min)

**Option A: Git Revert (Preferred)**:
```bash
# Revert to v1.9.0 (creates new commit)
git revert --no-commit v2.0.0..HEAD
git commit -m "Rollback: Revert to v1.9.0 due to critical bug"
git push origin main
```

**Option B: Force Push (Destructive, Last Resort)**:
```bash
# Reset to v1.9.0 (loses v2.0.0 commits)
git reset --hard v1.9.0
git push --force origin main
```

**Platform-Specific Deployment**:

**Vercel**:
```bash
# Redeploy v1.9.0
vercel --prod
# Or: Vercel dashboard → Deployments → v1.9.0 → Promote to Production
```

**Railway**:
```bash
# Redeploy v1.9.0
railway up --environment production
```

**Docker**:
```bash
# Pull v1.9.0 image
docker pull myapp:v1.9.0

# Stop current container
docker stop myapp-prod

# Start v1.9.0 container
docker run -d --name myapp-prod -p 3000:3000 myapp:v1.9.0

# Verify
curl http://localhost:3000/api/health
```

---

#### Step 3: Revert Database (if DDL changes) (<5 min)

**Scenario A: v2.0.0 Added Column (Safe)**:
```sql
-- v2.0.0 migration: ALTER TABLE users ADD COLUMN phone TEXT;
-- Rollback: No action needed (v1.9.0 ignores new column)
```

**Scenario B: v2.0.0 Dropped Column (Destructive)**:
```sql
-- v2.0.0 migration: ALTER TABLE users DROP COLUMN legacy_id;
-- Rollback: Restore from backup
pg_restore -U postgres -d myapp_prod backup-pre-deploy-20260930.dump
```

**Scenario C: v2.0.0 Changed Data (e.g., migration script updated rows)**:
```bash
# Restore database from pre-migration backup
pg_restore -U postgres -d myapp_prod backup-pre-deploy-20260930.dump

# Verify row count
psql myapp_prod -c "SELECT COUNT(*) FROM users;"
# Should match pre-migration count
```

---

#### Step 4: Verify Rollback (<3 min)

```bash
# 1. Check application version
curl https://app.client.com/api/version
# Expected: {"version":"1.9.0"}

# 2. Test critical workflow (login)
curl -X POST https://app.client.com/api/auth/login \
  -d '{"email":"test@client.com","password":"***"}'
# Expected: {"status":"success","token":"***"}

# 3. Check error rate (Sentry)
# Sentry dashboard → Issues → Last 15 minutes
# Expected: Error rate back to <1%

# 4. Monitor traffic
tail -f /var/log/nginx/access.log
# Expected: 200 OK responses, no 500 errors
```

---

#### Step 5: Post-Rollback Actions (<5 min)

**1. Notify Stakeholders**:
```
Subject: Production Rollback Executed — v2.0.0 → v1.9.0

Dear [Client PIC],

We have executed a rollback of the production system to version 1.9.0 at [Time] due to [critical bug description].

Current Status:
- System: Stable, running v1.9.0
- Error rate: <1% (back to normal)
- User impact: [X] users affected during [Y] minutes downtime

Root Cause:
[Brief description, e.g., "Payment webhook signature validation bug"]

Next Steps:
1. Hotfix in progress (ETA: [Time])
2. Re-deploy with fix (ETA: [Date])
3. Post-mortem report (ETA: [Date])

Users can continue normal operations on v1.9.0.

Best regards,
[Dev Name]
```

**2. Document Incident**:
```markdown
# Incident Report: Rollback v2.0.0 → v1.9.0

**Date**: 2026-09-30 14:30 WIB
**Duration**: 12 minutes (14:30 - 14:42)
**Severity**: Critical

## Trigger
Error rate spiked to 15% after v2.0.0 deployment.

## Root Cause
Payment webhook signature validation bug (line 145, payment.controller.ts).

## Impact
- 23 users affected (failed payment processing)
- No data loss
- 12 minutes partial downtime

## Resolution
- Rollback executed (14:35 - 14:42)
- Hotfix deployed (v2.0.1) at 16:00
- All affected users notified via email

## Prevention
- Add payment webhook integration test (missing in v2.0.0)
- Staging environment must test payment flow before production
```

**3. Plan Hotfix**:
```bash
# Create hotfix branch
git checkout -b hotfix/v2.0.1 v1.9.0

# Apply fix
# ... fix bug ...

# Test thoroughly in staging
pnpm test
pnpm test:e2e

# Deploy hotfix
git tag v2.0.1
git push origin hotfix/v2.0.1 --tags

# Schedule re-deployment (next day, Rabu 09:00)
```

---

### Rollback Time Budget

| Step | Target Time | Critical Path |
|------|-------------|---------------|
| Identify issue | <2 min | Sentry alert |
| Revert application code | <3 min | Git + platform deploy |
| Revert database (if needed) | <5 min | Restore from backup |
| Verify rollback | <3 min | Smoke test |
| Notify stakeholders | <5 min | Email template |
| **TOTAL** | **<15 min** | **Automated rollback script** |

---

### Automated Rollback Script

**`scripts/rollback-production.sh`**:
```bash
#!/bin/bash
set -e

LAST_GOOD_VERSION=$1

if [ -z "$LAST_GOOD_VERSION" ]; then
    echo "Usage: ./rollback-production.sh v1.9.0"
    exit 1
fi

echo "🔄 Rolling back to $LAST_GOOD_VERSION..."

# Step 1: Revert code
git revert --no-commit HEAD
git commit -m "Rollback: Revert to $LAST_GOOD_VERSION"
git push origin main

# Step 2: Deploy
vercel --prod  # Or: railway up --environment production

# Step 3: Verify
sleep 30  # Wait for deployment
STATUS=$(curl -s -o /dev/null -w "%{http_code}" https://app.client.com/api/health)

if [ "$STATUS" -eq 200 ]; then
    echo "✅ Rollback successful (HTTP $STATUS)"
    # Send notification
    curl -X POST $DISCORD_WEBHOOK_URL \
      -d "{\"content\":\"✅ Rollback to $LAST_GOOD_VERSION successful\"}"
else
    echo "❌ Rollback failed (HTTP $STATUS)"
    exit 1
fi
```

**Usage**:
```bash
./scripts/rollback-production.sh v1.9.0
```

---

### Rollback Checklist

- [ ] Last known good version identified (git tag)
- [ ] Database backup verified (can restore in <5 min)
- [ ] Rollback script tested in staging
- [ ] Client stakeholder notified (rollback plan approved)
- [ ] Monitoring alerts configured (error rate >10% triggers alert)
- [ ] Rollback executed (<15 min)
- [ ] Production smoke test passed (login, payment, upload)
- [ ] Incident report documented
- [ ] Hotfix planned (next deployment)

---

## 5. Production Monitoring Setup Checklist

### Goal: Detect Issues Before Users Report Them

---

### Monitoring Stack (3-Tier)

#### Tier 1: Error Tracking (Sentry)

**Setup**:
```bash
# Install Sentry SDK
pnpm add @sentry/nextjs

# Configure sentry.client.config.ts
import * as Sentry from '@sentry/nextjs';

Sentry.init({
  dsn: process.env.SENTRY_DSN,
  environment: 'production',  // NOT staging
  tracesSampleRate: 0.1,      // 10% transactions (cost-optimized)
  beforeSend(event, hint) {
    // Filter out known non-critical errors
    if (event.exception?.values?.[0]?.value?.includes('Network request failed')) {
      return null;  // Don't send network timeouts (user-side issue)
    }
    return event;
  },
});
```

**Alert Rules** (Sentry Dashboard → Alerts):
- [ ] Error rate >10 errors/min → Slack/Discord webhook
- [ ] New issue (first occurrence) → Email notification
- [ ] Payment-related errors → Immediate PagerDuty/SMS

---

#### Tier 2: Uptime Monitoring (BetterStack/UptimeRobot)

**Setup**:
1. Add monitor: `https://app.client.com/api/health`
2. Check interval: 60 seconds
3. Alert channels: Email + Discord webhook
4. Timeout: 30 seconds

**Healthcheck Endpoint** (`/api/health`):
```typescript
// app/api/health/route.ts
import { db } from '@/lib/db';
import { redis } from '@/lib/redis';

export async function GET() {
  try {
    // Check database
    await db.$queryRaw`SELECT 1`;

    // Check Redis (optional)
    await redis.ping();

    return Response.json({
      status: 'healthy',
      timestamp: new Date().toISOString(),
      version: process.env.APP_VERSION || 'unknown',
    });
  } catch (error) {
    return Response.json(
      {
        status: 'unhealthy',
        error: error.message,
        timestamp: new Date().toISOString(),
      },
      { status: 503 }
    );
  }
}
```

**Alert Rules**:
- [ ] HTTP status ≠200 → Alert (down)
- [ ] Response time >5s → Warning (degraded)
- [ ] 3 consecutive failures → Critical (outage)

---

#### Tier 3: Performance Monitoring (Optional, Sentry APM)

**Setup** (if budget allows):
```typescript
// Sentry APM (Application Performance Monitoring)
Sentry.init({
  dsn: process.env.SENTRY_DSN,
  tracesSampleRate: 0.1,  // 10% transactions
  profilesSampleRate: 0.1, // 10% profiles
});
```

**Monitored Metrics**:
- API latency (P50, P95, P99)
- Database query time
- External API call duration (payment gateway, email)
- Page load time (frontend)

**Alert Rules** (if P95 latency >500ms for 5 min):
- [ ] Investigate slow queries
- [ ] Scale up server resources
- [ ] Optimize N+1 queries

---

### Alert Routing Matrix

| Alert Type | Severity | Destination | Response Time |
|-----------|----------|-------------|---------------|
| **Error rate >10%** | Critical | Discord + Email + SMS | <15 min (rollback trigger) |
| **Site down (uptime)** | Critical | Discord + SMS | <15 min (investigate + rollback) |
| **Payment error** | Critical | Discord + Email | <30 min (manual verification) |
| **Slow API (P95 >500ms)** | Warning | Email only | <24 hour (optimization task) |
| **New Sentry issue** | Info | Email only | <48 hour (triage + fix) |

---

### Discord Webhook Setup

**Create Webhook**:
1. Discord Server → Settings → Integrations → Webhooks → New Webhook
2. Name: "Production Alerts"
3. Channel: #production-alerts
4. Copy webhook URL: `https://discord.com/api/webhooks/***`

**Test Alert**:
```bash
curl -X POST https://discord.com/api/webhooks/*** \
  -H 'Content-Type: application/json' \
  -d '{
    "content": "🔴 **CRITICAL**: Error rate 15% (threshold: 10%)",
    "embeds": [{
      "title": "Production Alert",
      "description": "Deployment v2.0.0 causing errors",
      "color": 15158332,
      "fields": [
        {"name": "Error Rate", "value": "15%", "inline": true},
        {"name": "Version", "value": "v2.0.0", "inline": true}
      ],
      "timestamp": "'$(date -u +%Y-%m-%dT%H:%M:%S.000Z)'"
    }]
  }'
```

---

### Monitoring Setup Checklist

**Error Tracking**:
- [ ] Sentry DSN configured (production environment)
- [ ] Error sample rate set (10% transactions)
- [ ] Alert rules configured (>10 errors/min)
- [ ] Test error sent (verify alert received)

**Uptime Monitoring**:
- [ ] Healthcheck endpoint deployed (`/api/health`)
- [ ] Monitor added (60s interval)
- [ ] Alert channels configured (Email + Discord)
- [ ] Test downtime simulation (verify alert)

**Performance Monitoring** (optional):
- [ ] APM enabled (Sentry traces)
- [ ] Slow query alerts configured (P95 >500ms)

**Alert Routing**:
- [ ] Discord webhook configured
- [ ] Email notifications enabled
- [ ] SMS alerts for critical (optional)
- [ ] Escalation policy documented (who to call at 2 AM?)

**Backup & Recovery**:
- [ ] Daily DB backup automated (cron job)
- [ ] Backup restoration tested (can restore in <10 min)
- [ ] Backup retention policy (30 days minimum)

**Documentation**:
- [ ] Runbook created (`docs/deploy/RUNBOOK.md`)
- [ ] Rollback playbook tested
- [ ] Incident response protocol documented
- [ ] On-call schedule (if applicable)


---

## Solo Developer Focus

# Panduan Deployment & Go-Live Produksi Solo Developer

Dokumen ini adalah buku pedoman praktis bagi solo developer dalam merencanakan, mengonfigurasi, dan mengeksekusi peluncuran perangkat lunak ke lingkungan produksi dengan aman, minim downtime, dan bebas kepanikan.

---

## 1. Waktu Rilis & Manajemen Risiko (Deploy Day Risk Matrix)

### Matriks Risiko Deploy Berdasarkan Hari

| Hari | Risk Level | Mitigation Required | Rekomendasi |
|------|-----------|---------------------|-------------|
| **Senin–Kamis** | Low | Standard checklist: backup DB, rollback script ready, healthcheck endpoint tested | ✅ **Ideal window** — full team/support available |
| **Jumat** | Medium | + Rollback script tested manually, + klien informed "support terbatas weekend", + backup verified restorable, + avoid Jumat sore (> 15:00 WIB) | ⚠️ **Proceed with caution** — solo dev kadang cuma bisa deploy Jumat malem after day job. Boleh asal mitigasi lengkap. |
| **Sabtu–Minggu** | High | AVOID kecuali emergency hotfix critical + full backup verified + klien aware zero SLA weekend | 🚫 **Emergency only** — burnout risk tinggi |

### Waktu Deploy Optimal (Senin–Kamis)
- **Jam Terbaik**: **Pukul 09.00 – 11.00 pagi** (WIB).
- **Alasannya**: Seluruh jam kerja masih tersisa seharian penuh jika ada kendala. Tim operasional klien sedang aktif di kantor untuk memvalidasi alur kerja, dan dukungan pelanggan (*customer support*) vendor cloud/payment gateway responsif penuh.

### Kapan Deploy Malam Hari Diizinkan?
- **Hanya** pada proyek Enterprise yang mewajibkan *Scheduled Maintenance Window* (misal: bank/BUMN jam 23.00–01.00 WIB).
- Deploy tengah malam saat tubuh lelah meningkatkan risiko kesalahan ketik konfigurasi sebesar 300%.

---

## 2. Pola Migrasi Basis Data Tanpa Henti (Zero-Downtime Migration)

Jika memperbarui aplikasi yang sudah memiliki pengguna aktif, gunakan pola **Expand and Contract (Tiga Fase)** untuk menghindari downtime:

1. **Fase 1 (Expand)**:
   - Tambahkan tabel atau kolom baru dengan sifat *nullable* atau miliki nilai default:
     ```sql
     -- AMAN: Menambah kolom baru tanpa merusak kode lama
     ALTER TABLE users ADD COLUMN phone_number VARCHAR(20) NULL;
     ```
2. **Fase 2 (Transition)**:
   - Deploy kode baru yang mulai menulis data ke kolom baru dan kolom lama secara bersamaan.
3. **Fase 3 (Contract)**:
   - Setelah seluruh data lama terkonversi, barulah hapus kolom lama pada rilis minor berikutnya.
   - DILARANG menggunakan perintah destruktif seperti `DROP TABLE` atau `ALTER COLUMN ... TYPE` mendadak di jam sibuk.

---

## 3. Taktik DNS Propagation & SSL Hardening

1. **Turunkan Nilai TTL 24 Jam Sebelum Go-Live**:
   - Satu hari sebelum peluncuran, ubah nilai TTL (*Time-To-Live*) pada DNS record domain dari `86400` (24 jam) menjadi **`300` (5 menit)**.
   - Hal ini memastikan bahwa saat Anda mengubah IP server saat go-live, seluruh perangkat pengguna di internet akan mengenali server baru dalam waktu 5 menit, bukan menunggu seharian.
2. **Konfigurasi SSL Paling Aman**:
   - Jika menggunakan Cloudflare, gunakan mode **"Full (Strict)"** agar enkripsi berjalan penuh dari browser pengguna ke Cloudflare, dan dari Cloudflare ke server aplikasi Anda.

---

## 4. Setup Otomatisasi Backup Harian & Alerting

### 4.1 Skrip Otomatisasi Backup PostgreSQL ke Cloud Storage
Buat skrip `scripts/backup-db.sh` dan pasang di crontab server:
```bash
#!/bin/bash
BACKUP_DIR="/tmp/backups"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
FILENAME="db_backup_$TIMESTAMP.sql.gz"

mkdir -p $BACKUP_DIR
# Dump dan kompresi basis data
pg_dump -U postgres -d legal_vault_prod | gzip > "$BACKUP_DIR/$FILENAME"

# Upload ke Cloudflare R2 / S3 via AWS CLI
aws s3 cp "$BACKUP_DIR/$FILENAME" "s3://legal-backup-bucket/daily/$FILENAME" --endpoint-url https://<account_id>.r2.cloudflarestorage.com

# Hapus backup lokal
rm -f "$BACKUP_DIR/$FILENAME"
echo "Backup $FILENAME berhasil diupload ke cloud storage."
```

Pasang di Cron Linux:
```text
# Berjalan setiap hari pukul 02.00 dini hari
0 2 * * * /bin/bash /app/scripts/backup-db.sh >> /var/log/db-backup.log 2>&1
```

### 4.2 Bot Alerting Down Telegram Gratis
Pasang pemantauan uptime gratis (Uptime Kuma atau BetterStack) yang mengecek endpoint `GET /api/health` setiap 60 detik. Hubungkan webhook ke bot Telegram solo dev agar Anda mendapat notifikasi seketika jika server mengalami kendala jaringan.

---

## 5. Panduan Khusus Rilis Aplikasi Mobile (Android & iOS)

### 5.1 Perlindungan Kunci Keystore Android
- Kunci `release-keystore.jks` adalah identitas unik aplikasi di Google Play Store. Jika kunci ini hilang atau terhapus:
  - Google Play Console **TIDAK MENGIZINKAN** pembaruan aplikasi selamanya (harus membuat nama paket baru dari nol dan kehilangan seluruh pengguna).
  - *SOP Solo Dev*: Wajib backup file `.jks` ke password vault terenkripsi (Bitwarden) dan simpan salinan cadangan di cold storage aman.

### 5.2 Strategi Menghadapi Review Apple App Store
- Apple memiliki tim peninjau manusia yang sangat ketat:
  - Sediakan akun demo penguji aktif (`tester-apple@domain.com` / password) di kolom *App Review Information* di App Store Connect.
  - Cantumkan tautan Kebijakan Privasi (*Privacy Policy URL*) dan Syarat Ketentuan (*Terms of Service*) yang valid di web.
  - Sediakan tombol *"Hapus Akun"* di dalam aplikasi jika aplikasi memiliki fitur registrasi (Pedoman Apple Guideline 5.1.1 wajib).

### 5.3 Pembaruan Tanpa Toko Aplikasi (Over-The-Air / OTA Updates)
- Untuk aplikasi React Native (Expo) atau Flutter (Shorebird):
  - Pasang modul OTA update agar Anda dapat merilis perbaikan bug darurat (*hotfix*) langsung ke ponsel pengguna dalam hitungan menit tanpa harus menunggu proses peninjauan toko aplikasi selama 2 hari.
