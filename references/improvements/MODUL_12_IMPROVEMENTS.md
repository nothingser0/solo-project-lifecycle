# Modul 12 Improvements: Warranty & SLA Retainer

## 1. Timeline Estimation (by Project Scale)

| Phase | Kecil (MVP) | Menengah (SaaS) | Besar | Enterprise |
|-------|-------------|-----------------|-------|-----------|
| Warranty Duration | 30 hari | 60 hari | 90 hari | 90 hari |
| WARRANTY_POLICY Writing | 1 jam | 2 jam | 3 jam | 4 jam (legal review) |
| INCIDENT_RESPONSE Setup | 2 jam | 3 jam | 4 jam | 8 jam (multi-tier) |
| SLA_RETAINER_CONTRACT Drafting | 2 jam | 3 jam | 4 jam | 8 jam (bilingual) |
| Average Bug Fixes (warranty) | 2-5 bugs | 5-10 bugs | 10-20 bugs | 20-40 bugs |
| Hotfix Time per Bug | 1-3 jam | 2-4 jam | 3-6 jam | 4-8 jam |
| Total Dev Time (warranty) | 4-15 jam | 15-40 jam | 40-120 jam | 80-320 jam |
| Retainer Proposal Prep | 2 jam | 3 jam | 4 jam | 8 jam |
| **TOTAL ACTIVE DEV TIME** | **11-23 jam** | **28-52 jam** | **55-137 jam** | **108-348 jam** |

### Assumptions
- Warranty duration = calendar days (NOT dev active time)
- Bug fix time = median (assumes standard bug complexity)
- Severity 1 bugs: 20% of total bugs (critical)
- Severity 2 bugs: 30% of total bugs (major)
- Severity 3 bugs: 50% of total bugs (minor)

### Bottlenecks
- Severity 1 after-hours: +2-4 jam response time (if outside working hours)
- Complex hotfix: +4-8 jam (if requires schema migration)
- Client testing delay: +1-3 hari per bug fix (client-side verification)

---

## 2. Incident Response Workflow (Break-Glass SOP)

### Problem
Modul 12 mentions "Break-Glass SOP" but lacks step-by-step incident response workflow.

### Solution: 5-Phase Incident Response

---

#### Phase 1: Detection & Triage (<15 minutes)

**Trigger Sources**:
- Sentry alert (error spike > 10x baseline)
- Uptime monitor (UptimeRobot, Pingdom) down alert
- Client WhatsApp/email: "Sistem tidak bisa diakses"
- Payment webhook failure (Midtrans/Stripe notification)

**Triage Actions**:
```bash
# 1. Check system status
curl -I https://app.client.com/api/health
# Expected: HTTP 200 OK
# If 500/502/503 → Server issue
# If timeout → Network/DNS issue

# 2. Check Sentry for error spike
# Dashboard: https://sentry.io/organizations/client-org/issues/
# Look for: new error patterns, specific endpoint failure

# 3. Check database connectivity
psql $DATABASE_URL -c "SELECT NOW();"
# If fails → Database down

# 4. Check third-party services
curl https://status.stripe.com/
curl https://status.midtrans.com/
# If degraded → External dependency issue
```

**Severity Classification**:

| Severity | Definition | Example | SLA Response | SLA Resolution |
|----------|-----------|---------|--------------|----------------|
| **S1: Critical** | Sistem down total, tidak ada workaround | Homepage 502, DB unreachable, payment broken | <2 jam | <24 jam |
| **S2: Major** | Fungsi utama broken, ada workaround manual | Export PDF gagal, notifikasi email delay | <8 jam | <48 jam |
| **S3: Minor** | Bug UI, fungsi sekunder broken | Typo, styling broken, filter lambat | Hari kerja berikutnya | <1 minggu |

**Triage Output**: 
- Severity level determined
- Affected component identified (Frontend/Backend/DB/Third-party)
- Initial hypothesis (e.g., "DB connection pool exhausted")

---

#### Phase 2: Communication & Acknowledgment (<30 minutes)

**Notify Client** (template):
```
[INCIDENT] Sistem [Project Name] - [Brief Description]

Severity: [S1/S2/S3]
Reported: 2026-09-30 14:23 WIB
Status: INVESTIGATING

We have detected [issue description]. Our team is currently investigating.

Expected Resolution: [Timeline based on severity]
Next Update: [1 hour for S1, 4 hours for S2, 24 hours for S3]

You can monitor status at: [Status Page URL if exists]

— [Dev Name]
```

**Create Incident Log**:
```bash
# docs/incidents/2026-09-30-payment-webhook-failure.md
cat > docs/incidents/2026-09-30-payment-webhook-failure.md << 'EOF'
# Incident: Payment Webhook Failure

**Severity**: S1  
**Reported**: 2026-09-30 14:23 WIB  
**Detected By**: Midtrans notification failure alert  
**Affected Users**: All users attempting payment  
**Status**: INVESTIGATING

## Timeline
- 14:23 WIB: Alert received (webhook timeout)
- 14:25 WIB: Severity classified as S1
- 14:30 WIB: Client notified
- [ongoing]

## Hypothesis
Webhook endpoint returning 500 due to [reason TBD]

## Actions Taken
[to be filled during investigation]
EOF
```

---

#### Phase 3: Investigation & Root Cause Analysis (<2 hours for S1)

**Investigation Checklist**:

1. **Review Logs**:
```bash
# Vercel logs (last 1 hour)
vercel logs --since 1h

# Sentry error details
# Click into error → View full stack trace + breadcrumbs

# Database slow query log
# Supabase Dashboard → Logs → Slow Queries
```

2. **Reproduce Locally** (if possible):
```bash
# Checkout production branch
git checkout main
git pull origin main

# Use production-like env
cp .env.production .env.local

# Start local server
pnpm run dev

# Test affected endpoint
curl -X POST http://localhost:3000/api/webhooks/midtrans \
  -H "Content-Type: application/json" \
  -d @test-webhook-payload.json
```

3. **Check Recent Changes**:
```bash
# Last 3 commits before incident
git log --since="24 hours ago" --oneline

# Diff last deploy
git diff v1.0.1..v1.0.2
```

4. **Database Health Check**:
```sql
-- Connection pool status
SELECT count(*) as active_connections 
FROM pg_stat_activity 
WHERE state = 'active';
-- If > 80% of max_connections → pool exhaustion

-- Long-running queries
SELECT pid, now() - query_start as duration, query
FROM pg_stat_activity
WHERE state != 'idle' AND now() - query_start > interval '5 minutes';
-- Kill if needed: SELECT pg_terminate_backend(pid);
```

**Root Cause Hypotheses** (common patterns):

| Symptom | Likely Root Cause | Verification |
|---------|-------------------|--------------|
| **502 Bad Gateway** | Server OOM (out of memory) | Check Vercel metrics (Memory usage > 512MB) |
| **Timeout errors** | Slow DB query (N+1, missing index) | Check Supabase slow query log |
| **Random 500 errors** | Unhandled exception (null pointer) | Sentry stack trace |
| **Payment webhook fail** | IP whitelist blocking webhook source | Check Midtrans source IP vs firewall rules |
| **CORS errors** | Recent domain change or CSP header issue | Check response headers |

---

#### Phase 4: Fix & Deploy Hotfix (<4 hours for S1)

**Hotfix Branch Workflow**:
```bash
# 1. Create hotfix branch from main
git checkout main
git checkout -b fix/incident-20260930-webhook

# 2. Apply fix (example: add missing null check)
# Edit file: api/webhooks/midtrans/route.ts
# Add: if (!payload?.transaction_id) return NextResponse.json({ error: 'Invalid payload' }, { status: 400 });

# 3. Test fix locally
pnpm run test:smoke
curl -X POST http://localhost:3000/api/webhooks/midtrans -d @test-payload.json
# Expected: 200 OK

# 4. Commit with clear message
git add .
git commit -m "fix: handle null payload in Midtrans webhook

- Add null check for transaction_id before processing
- Return 400 Bad Request instead of 500 on invalid payload
- Incident: docs/incidents/2026-09-30-payment-webhook-failure.md
"

# 5. Push to GitHub (triggers CI)
git push origin fix/incident-20260930-webhook

# 6. Deploy to staging for verification
git checkout staging
git merge --no-ff fix/incident-20260930-webhook
git push origin staging
# Wait for Vercel deploy (~2 min)

# 7. Smoke test on staging
curl -X POST https://staging.app.client.com/api/webhooks/midtrans \
  -H "Content-Type: application/json" \
  -d @test-webhook-payload.json
# Expected: 200 OK

# 8. Deploy to production
git checkout main
git merge --no-ff fix/incident-20260930-webhook
git tag -a v1.0.3 -m "hotfix: Midtrans webhook null payload handling"
git push origin main --tags
# Vercel auto-deploys main → production (~2 min)
```

**Rollback Plan** (if hotfix makes it worse):
```bash
# Option 1: Revert commit
git revert HEAD
git push origin main

# Option 2: Redeploy previous version
vercel rollback https://app.client.com --yes
# Or via Vercel dashboard: Deployments → [previous deployment] → Promote to Production
```

---

#### Phase 5: Verification & Post-Mortem (<1 hour)

**Production Verification**:
```bash
# 1. Test affected endpoint
curl -X POST https://app.client.com/api/webhooks/midtrans \
  -H "Content-Type: application/json" \
  -d @test-webhook-payload.json
# Expected: 200 OK

# 2. Monitor Sentry for new errors (15 min)
# Dashboard: Check error rate returned to baseline

# 3. Check uptime monitor (green)
# UptimeRobot: https://app.client.com/api/health → UP

# 4. Request client to verify
# WhatsApp: "Fix telah di-deploy, mohon dicoba kembali proses payment"
```

**Update Incident Log**:
```markdown
## Resolution
**Root Cause**: Webhook handler did not validate `transaction_id` field, causing null pointer exception when Midtrans sent test webhook with empty payload.

**Fix**: Added null check + 400 Bad Request response for invalid payloads.

**Deploy**: v1.0.3 (2026-09-30 16:45 WIB)

**Verification**: 
- Staging test: ✅ Passed
- Production test: ✅ Passed
- Client confirmation: ✅ Payment successful at 16:50 WIB

**Resolved**: 2026-09-30 16:50 WIB  
**Total Downtime**: 2 hours 27 minutes (14:23 - 16:50)

## Timeline
- 14:23: Alert received
- 14:30: Client notified
- 14:45: Root cause identified (null payload)
- 15:15: Fix deployed to staging
- 15:30: Staging verified
- 16:45: Production deploy
- 16:50: Client confirmed resolution

## Prevention
- [ ] Add Midtrans webhook payload validation schema (Zod)
- [ ] Add integration test for webhook edge cases
- [ ] Add Sentry alert for webhook endpoint errors (threshold: 5 errors/min)
```

**Post-Mortem Review** (if S1 with >1 hour downtime):
- What went well? (fast detection, clear communication)
- What went wrong? (missing input validation, no integration test)
- Action items to prevent recurrence (add schema validation, improve tests)

---

### Incident Response Checklist

- [ ] Detection: Severity classified within 15 min
- [ ] Communication: Client notified within 30 min
- [ ] Investigation: Root cause identified within 2 hours (S1)
- [ ] Fix: Hotfix deployed to staging and verified
- [ ] Deploy: Production hotfix deployed with rollback plan ready
- [ ] Verification: Endpoint tested, Sentry monitored, client confirmed
- [ ] Documentation: Incident log updated with timeline + root cause
- [ ] Post-Mortem: Action items documented for prevention

---

## 3. Retainer Pricing Formula

### Problem
Modul 12 suggests Bronze/Silver/Gold packages but no pricing guidance.

### Solution: Cost-Plus Pricing Model

---

### Formula

```
Monthly Retainer Price = (Base Cost + Risk Premium) × Profit Margin
```

**Components**:

1. **Base Cost** = Dev hourly rate × allocated hours
2. **Risk Premium** = 20-30% (for on-call, unpredictable workload)
3. **Profit Margin** = 1.5x - 2.5x (depends on client relationship, market rate)

---

### Example Calculation (Indonesia Market)

**Assumptions**:
- Solo dev hourly rate: Rp 250,000/jam (freelance standard)
- Working month: 160 jam (40 jam/minggu × 4 minggu)

---

#### Bronze Package (5 jam/bulan)

**Base Cost**:
```
5 jam × Rp 250,000 = Rp 1,250,000
```

**Risk Premium** (20%):
```
Rp 1,250,000 × 1.2 = Rp 1,500,000
```

**Profit Margin** (1.5x for basic package):
```
Rp 1,500,000 × 1.5 = Rp 2,250,000
```

**Price Rounding**:
```
Rp 2,250,000 → Rp 2,500,000/bulan (marketing friendly)
```

**Bronze Package Contents**:
- 5 jam kerja/bulan (konsultasi + bug fix minor)
- Monitoring 24/7 (Sentry + Uptime)
- Security patch updates (dependencies)
- Backup verification (restore test bulanan)
- Response SLA: Hari kerja (Senin-Jumat 09-17 WIB)

---

#### Silver Package (15 jam/bulan)

**Base Cost**:
```
15 jam × Rp 250,000 = Rp 3,750,000
```

**Risk Premium** (25%):
```
Rp 3,750,000 × 1.25 = Rp 4,687,500
```

**Profit Margin** (2x):
```
Rp 4,687,500 × 2 = Rp 9,375,000
```

**Price Rounding**:
```
Rp 9,375,000 → Rp 9,500,000/bulan
```

**Silver Package Contents**:
- 15 jam kerja/bulan (fitur minor + optimization)
- Semua fitur Bronze
- Priority bug fix (response <4 jam hari kerja)
- Monthly performance review (report + recommendations)
- Quarterly roadmap consultation (1 jam meeting)

---

#### Gold Package (30 jam/bulan)

**Base Cost**:
```
30 jam × Rp 250,000 = Rp 7,500,000
```

**Risk Premium** (30% for on-call):
```
Rp 7,500,000 × 1.3 = Rp 9,750,000
```

**Profit Margin** (2.5x for enterprise):
```
Rp 9,750,000 × 2.5 = Rp 24,375,000
```

**Price Rounding**:
```
Rp 24,375,000 → Rp 25,000,000/bulan
```

**Gold Package Contents**:
- 30 jam kerja/bulan (continuous feature development)
- Semua fitur Silver
- On-call support (weekend emergency untuk S1)
- Dedicated Slack/Discord channel
- Bi-weekly sprint planning (30 min standup)
- Quarterly business review (strategy alignment)

---

### Pricing Tiers Summary (Indonesia Market)

| Package | Hours/Month | Price (Rp) | Price (USD) | Effective Rate |
|---------|-------------|------------|-------------|----------------|
| **Bronze** | 5 | 2,500,000 | ~$170 | Rp 500k/jam |
| **Silver** | 15 | 9,500,000 | ~$640 | Rp 633k/jam |
| **Gold** | 30 | 25,000,000 | ~$1,680 | Rp 833k/jam |

**Notes**:
- Effective rate increases with higher tiers (economies of scale + premium for predictability)
- USD conversion: 1 USD = Rp 15,000 (approximate)

---

### Pricing Adjustments by Client Type

| Client Type | Profit Margin | Reasoning |
|-------------|---------------|-----------|
| **Startup/Nonprofit** | 1.3x - 1.5x | Goodwill, potential growth, portfolio value |
| **SME Local** | 1.5x - 2x | Standard market rate |
| **Corporate/Enterprise** | 2x - 2.5x | Higher expectations, complex approval, legal overhead |
| **International** | 2.5x - 3x | Currency risk, timezone challenges, legal complexity |

---

### Unused Hours Policy

**Option A: Rollover (Max 2 Months)**:
- Unused hours rollover to next month
- Max accumulation: 2x monthly allocation
- After 2 months: hours expire

**Option B: Use It or Lose It**:
- Unused hours expire end of month
- Simpler accounting, encourages utilization

**Option C: Discounted Carry-Over**:
- Unused hours rollover at 50% rate
- Example: 5 unused hours → 2.5 hours next month

**Recommendation**: Option A (rollover max 2 months) for client goodwill.

---

### Overage Hours Policy

**If client exceeds monthly allocation**:
- **Ad-hoc rate**: 1.5x normal hourly rate (Rp 375k/jam for standard Rp 250k/jam)
- **Discount for upgrade**: Offer to upgrade package mid-month (pro-rated)

**Example**:
```
Client on Bronze (5 jam), used 8 jam in Month 1.
Overage: 3 jam × Rp 375k = Rp 1,125,000 additional invoice

OR

Offer upgrade to Silver (15 jam) mid-month:
Silver price: Rp 9,500,000/bulan
Pro-rated (15 days): Rp 4,750,000
Already paid Bronze: Rp 2,500,000
Top-up: Rp 2,250,000 (cheaper than overage for client)
```

---

### Retainer Pricing Checklist

- [ ] Base cost calculated (hourly rate × allocated hours)
- [ ] Risk premium applied (20-30% for unpredictability)
- [ ] Profit margin determined (1.5x - 2.5x by client type)
- [ ] Price rounded to marketing-friendly number
- [ ] Package contents defined (hours + SLA + extras)
- [ ] Unused hours policy documented (rollover/expire)
- [ ] Overage hours policy documented (ad-hoc rate)
- [ ] Payment terms defined (monthly in advance via auto-debit)

---

## 4. Warranty Expiry Notification Automation

### Problem
Modul 12 mentions sending retainer proposal 14 days before warranty ends, but no automation setup.

### Solution: Automated Reminder via Cron + Email

---

### Implementation Options

---

#### Option A: Hermes Cron Job (Recommended for Solo Dev)

**Setup**:
```bash
# Create reminder script
cat > scripts/warranty-expiry-reminder.ts << 'EOF'
import { addDays, differenceInDays } from 'date-fns';

interface Project {
  name: string;
  clientEmail: string;
  warrantyStartDate: string; // ISO date
  warrantyDurationDays: number;
}

const projects: Project[] = [
  {
    name: 'FreePajak',
    clientEmail: 'zaini@freepajak.com',
    warrantyStartDate: '2026-09-01',
    warrantyDurationDays: 60
  },
  // Add more projects here
];

async function checkWarrantyExpiry() {
  const today = new Date();
  
  for (const project of projects) {
    const startDate = new Date(project.warrantyStartDate);
    const expiryDate = addDays(startDate, project.warrantyDurationDays);
    const daysUntilExpiry = differenceInDays(expiryDate, today);
    
    // Send reminder 14 days before expiry
    if (daysUntilExpiry === 14) {
      await sendRetainerProposal(project);
      console.log(`✅ Sent retainer proposal for ${project.name}`);
    }
    
    // Send final reminder 3 days before expiry
    if (daysUntilExpiry === 3) {
      await sendFinalReminder(project);
      console.log(`⚠️ Sent final reminder for ${project.name}`);
    }
    
    // Log expired warranties
    if (daysUntilExpiry === 0) {
      console.log(`🔴 Warranty expired today for ${project.name}`);
    }
  }
}

async function sendRetainerProposal(project: Project) {
  // Send email via SendGrid/Resend/Nodemailer
  const emailContent = `
Dear ${project.name} Team,

Your warranty period will end in 14 days (expires: ${addDays(new Date(project.warrantyStartDate), project.warrantyDurationDays).toLocaleDateString('id-ID')}).

To ensure continued support, we're offering our Monthly Retainer packages:

🥉 Bronze (Rp 2.5 jt/bulan): 5 hours, monitoring, security patches
🥈 Silver (Rp 9.5 jt/bulan): 15 hours, priority support, performance reviews
🥇 Gold (Rp 25 jt/bulan): 30 hours, on-call, dedicated channel

Full proposal attached: [RETAINER_PROPOSAL.pdf]

Let's schedule a 15-minute call to discuss which package fits your needs.

Best regards,
[Dev Name]
  `;
  
  // TODO: Replace with actual email sending logic
  console.log(`Email preview:\n${emailContent}`);
}

async function sendFinalReminder(project: Project) {
  const emailContent = `
Dear ${project.name} Team,

FINAL REMINDER: Your warranty expires in 3 days.

After expiry:
- Bug fixes: Hourly billing (Rp 375k/jam)
- No guaranteed response SLA

Lock in Monthly Retainer rate before expiry (offer valid until warranty end).

Reply to this email to proceed.

Best regards,
[Dev Name]
  `;
  
  console.log(`Final reminder email:\n${emailContent}`);
}

checkWarrantyExpiry();
EOF

# Schedule via Hermes cron (daily check at 9 AM)
# In Hermes: tool_call(cronjob_manage, action='create', schedule='0 9 * * *', command='bun scripts/warranty-expiry-reminder.ts')
```

---

#### Option B: GitHub Actions (Free Tier)

**Setup**:
```yaml
# .github/workflows/warranty-reminder.yml
name: Warranty Expiry Reminder

on:
  schedule:
    - cron: '0 1 * * *' # Daily at 9 AM WIB (1 AM UTC)
  workflow_dispatch: # Manual trigger

jobs:
  check-warranty:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Bun
        uses: oven-sh/setup-bun@v1
        
      - name: Install dependencies
        run: bun install
        
      - name: Check warranty expiry
        run: bun scripts/warranty-expiry-reminder.ts
        env:
          SENDGRID_API_KEY: ${{ secrets.SENDGRID_API_KEY }}
          DEV_EMAIL: ${{ secrets.DEV_EMAIL }}
```

---

#### Option C: Notion Database + Zapier (No-Code)

**Setup**:
1. Create Notion database: `Warranty Tracker`
   - Columns: Project Name, Client Email, Warranty Start, Warranty Duration, Status
2. Add formula column: `Days Until Expiry` = `Warranty Start + Warranty Duration - Today()`
3. Create Zapier workflow:
   - Trigger: Notion database item where `Days Until Expiry = 14`
   - Action: Send email via Gmail/SendGrid

**Pros**: No coding, visual dashboard  
**Cons**: Zapier paid plan required for daily polling

---

### Email Template: Retainer Proposal

**Subject**: Warranty Ends in 14 Days — Monthly Retainer Options for [Project Name]

**Body**:
```
Hi [Client Name],

Your warranty period for [Project Name] will end on [Expiry Date] (14 days from now).

During warranty, we've resolved:
- [X] bug fixes
- [Y] hours of support
- [Z] security patches

To ensure uninterrupted support after warranty, I'm offering three Monthly Retainer packages:

┌─────────────────────────────────────┐
│ 🥉 BRONZE — Rp 2,500,000/bulan     │
├─────────────────────────────────────┤
│ ✅ 5 hours/month                    │
│ ✅ 24/7 monitoring (Sentry + Uptime)│
│ ✅ Security patch updates           │
│ ✅ Monthly backup verification      │
│ ✅ Response SLA: 1 business day     │
└─────────────────────────────────────┘

┌─────────────────────────────────────┐
│ 🥈 SILVER — Rp 9,500,000/bulan     │
├─────────────────────────────────────┤
│ ✅ 15 hours/month                   │
│ ✅ All Bronze features              │
│ ✅ Priority bug fix (<4 jam)        │
│ ✅ Monthly performance review       │
│ ✅ Quarterly roadmap consultation   │
└─────────────────────────────────────┘

┌─────────────────────────────────────┐
│ 🥇 GOLD — Rp 25,000,000/bulan      │
├─────────────────────────────────────┤
│ ✅ 30 hours/month                   │
│ ✅ All Silver features              │
│ ✅ Weekend emergency support (S1)   │
│ ✅ Dedicated Slack channel          │
│ ✅ Bi-weekly sprint planning        │
└─────────────────────────────────────┘

WITHOUT RETAINER:
- Hourly billing: Rp 375,000/jam (1.5x standard rate)
- No guaranteed response time
- No proactive monitoring

NEXT STEPS:
Reply to this email with your preferred package, and I'll send the contract for signature.

Questions? Let's hop on a 15-min call: [Calendly link]

Best regards,
[Dev Name]
[Phone]
[Email]

P.S. Lock in current pricing before [Expiry Date] — rates may increase for new engagements.
```

---

### Automation Checklist

- [ ] Project warranty dates tracked (spreadsheet/Notion/database)
- [ ] Reminder script created (Hermes cron/GitHub Actions/Zapier)
- [ ] Email template prepared (retainer proposal + pricing)
- [ ] Schedule set (14 days before + 3 days before expiry)
- [ ] Test run executed (verify email sends correctly)
- [ ] Fallback: Manual calendar reminder (if automation fails)
- [ ] Conversion tracking (% clients who sign retainer)


---

## Solo Developer Focus

# Panduan Pemeliharaan Retainer Bulanan & SLA Solo Developer

Dokumen ini adalah buku pedoman taktis bagi solo developer untuk mengubah bisnis berbasis proyek satu kali (*one-off project*) menjadi arus kas bulanan berulang yang stabil (*Monthly Recurring Revenue* / MRR) melalui kontrak pemeliharaan (*Retainer SLA*), mengelola kepanikan klien, dan menegakkan batas jam kerja tanpa burnout.

---

## 1. Transformasi Arus Kas: Dari Proyek Lepas ke Retainer Bulanan

Kelemahan terbesar solo developer adalah siklus "Pesta dan Paceklik" (*Feast and Famine*): bulan ini mendapat uang besar dari proyek, bulan depan pendapatan nol karena harus mencari klien baru.

### Solusi: Mesin Retainer Pemeliharaan
Setiap proyek yang selesai di Modul 11 wajib ditawari kontrak pemeliharaan bulanan (Modul 12).
- Jika Anda memiliki **3–5 klien retainer** @ Rp 3.000.000 s/d Rp 7.000.000 per bulan:
  - Anda memiliki pendapatan dasar bulanan tetap sebesar **Rp 15.000.000 – Rp 35.000.000/bulan**.
  - Waktu yang dihabiskan untuk maintenance preventif per klien rata-rata hanya **3–5 jam per bulan**.

---

## 2. Struktur Formula Paket Retainer Solo Developer

| Nama Paket | Sasaran Klien | Fasilitas & Alokasi Waktu | Biaya Rekomendasi / Bulan | SLA & Jam Kerja |
| :--- | :--- | :--- | :---: | :--- |
| **Bronze (Essential)** | Skala Kecil (MVP / Startup tahap awal) | Pemantauan Uptime 24/7, Sentry monitoring, update patch keamanan dependensi bulanan, 1x uji restore backup DB. Alokasi: **4 Jam / Bulan**. | Rp 2.500.000 – Rp 4.000.000 | Support jam kerja only (Senin–Jumat 09:00–17:00 WIB). Response time: 24 jam. |
| **Silver (Standard)** | Skala Menengah (B2B SaaS / Agensi) | Seluruh fasilitas Bronze + Alokasi **8 Jam / Bulan** untuk penambahan fitur minor / penyesuaian form. | Rp 5.000.000 – Rp 8.000.000 | Support jam kerja + On-call Senin–Jumat 08:00–20:00 WIB. Response time: 12 jam. |
| **Gold (Enterprise)** | Skala Besar / Korporasi | Seluruh fasilitas Silver + Alokasi **16 Jam / Bulan** + Dukungan On-Call akhir pekan untuk gangguan *Severity 1* (Sistem Down). | Rp 12.000.000 – Rp 20.000.000 | Support 24/7 untuk Severity 1 only. Response time: 4 jam. Max 2 emergency di luar jam retainer per bulan. |

### Burnout Hard-Limit (Anti-Burnout Protection)

**Batas Keras untuk Semua Tier:**
- **Max 2 production emergency** di luar jam retainer per bulan.
- Emergency ke-3+ dalam bulan yang sama = **upgrade tier wajib** atau tambahan biaya **Rp 500.000 per incident**.
- Emergency definition: **Severity 1 only** (sistem mati total, data loss risk, security breach). Permintaan perubahan teks/styling di hari Minggu bukan emergency.

**Protokol Emergency:**
```
IF incident_count > 2 AND current_month:
    Kirim email: "Pak/Bu, bulan ini sudah terjadi 2 emergency.
                  Emergency berikutnya dikenakan biaya Rp 500K per incident
                  atau kami rekomendasikan upgrade ke tier Gold."
    JANGAN langsung kerja tanpa konfirmasi biaya
```

---

## 3. Protokol Menangani Kepanikan Klien ("Klien Panik di WhatsApp")

Klien sering mengirim pesan histeris dengan tanda seru berderet: *"MAS APLIKASI ERROR SEMUA CEPAT DIBENERIN INI BISNIS BERHENTI!!!"*

### SOP 3 Langkah Menenangkan Klien (The Calming Protocol):
1. **Langkah 1: Jangan Ikut Panik, Akui Pesan Seketika ($< 15\text{ Menit}$)**:
   > *"Halo Pak/Bu [Nama PIC], terima kasih laporannya. Pesan sudah saya terima dan saat ini sedang saya cek di dashboard monitoring server."*
2. **Langkah 2: Mintakan Fakta Teknis Objektif (Isolasi Masalah)**:
   > *"Mohon bantu kirimkan tangkapan layar (screenshot) layar yang error dan apakah kendala ini dialami oleh seluruh staf kantor atau hanya pada 1 komputer tertentu?"*
3. **Langkah 3: Cek Dashboard Riil (Sentry / Uptime)**:
   - Sering kali kendala tersebut ternyata bukan sistem down, melainkan staf klien lupa password, koneksi WiFi kantor klien terputus, atau salah menginput format data.
   - Tunjukkan hasil investigasi berbasis fakta secara tenang dan solutif.

---

## 4. Disiplin Jam Kerja & Batas On-Call (Anti-Burnout)

Solo developer bukan robot. Jangan pernah menjanjikan dukungan siaga 24 jam sehari jika klien hanya membayar paket pemeliharaan murah:

1. **Kunci Jam Kerja di Kontrak**:
   - Jam operasional resmi adalah **Senin s/d Jumat pukul 09.00 – 17.00 WIB**.
   - Pesan yang masuk di hari Sabtu/Minggu atau malam hari akan ditangani pada hari kerja berikutnya pada pukul 09.00 WIB.
2. **Pengecualian On-Call Khusus**:
   - Respon di luar jam kerja (malam/akhir pekan) **HANYA BERLAKU** untuk insiden **Severity 1 (Sistem Mati Total)** pada Klien yang mengambil **Paket Gold Enterprise**.
   - Permintaan penambahan teks form atau revisi tampilan di hari Minggu wajib ditolak secara sopan dan dikerjakan hari Senin.
