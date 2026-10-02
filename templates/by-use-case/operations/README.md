# Operations Templates

**Use case**: Production deployment, incident response, ongoing maintenance

**Critical for**: Live systems with real users

---

## Pre-Deployment

### 1. RUNBOOK_LOCAL.md
**Path**: `../../04-dev-execution/RUNBOOK_LOCAL_TEMPLATE.md`  
**Purpose**: Local development setup (clone → run → verify)  
**Time**: 30 minutes  
**When**: Before first developer onboarding

**Output**: `docs/RUNBOOK_LOCAL.md`

```bash
mkdir -p docs
cp templates/04-dev-execution/RUNBOOK_LOCAL_TEMPLATE.md docs/RUNBOOK_LOCAL.md
# Document: git clone, npm install, .env setup, npm run dev
```

**Must include**:
- Prerequisites (Node.js 20+, PostgreSQL 16)
- Environment variables (`.env.example` → `.env`)
- Database setup (`npx prisma migrate dev`)
- Smoke test (`curl http://localhost:3000/api/health`)

**Test**: New developer should be running in <15 minutes

---

### 2. DEPLOYMENT_PROTOCOL.md
**Path**: `../../07-release-handover/DEPLOYMENT_PROTOCOL_TEMPLATE.md`  
**Purpose**: Go-live checklist (DNS, SSL, environment variables)  
**Time**: 1 hour  
**When**: 1 week before production launch

**Output**: `docs/DEPLOYMENT_PROTOCOL.md`

```bash
cp templates/07-release-handover/DEPLOYMENT_PROTOCOL_TEMPLATE.md docs/DEPLOYMENT_PROTOCOL.md
# Checklist: domain ready, SSL valid, env vars set, backup configured
```

**Critical checks**:
- [ ] **Domain**: DNS A record → production IP (propagation 24-48 hours)
- [ ] **SSL**: HTTPS certificate valid (Let's Encrypt auto-renewal enabled)
- [ ] **Environment**: Production `.env` (no test API keys)
- [ ] **Database**: Connection pool sized (max_connections = 100)
- [ ] **Backup**: Automated daily backup (retention 30 days)
- [ ] **Monitoring**: Uptime check (UptimeRobot / Better Stack)
- [ ] **No Friday Deploy**: Launch Tuesday-Thursday only

---

### 3. ROLLBACK_PLAN.md
**Path**: `../../07-release-handover/ROLLBACK_PLAN_TEMPLATE.md`  
**Purpose**: 15-minute rollback procedure if deployment fails  
**Time**: 30 minutes  
**When**: Before first production deployment

**Output**: `docs/ROLLBACK_PLAN.md`

```bash
cp templates/07-release-handover/ROLLBACK_PLAN_TEMPLATE.md docs/ROLLBACK_PLAN.md
# Document: how to revert to last-known-good version
```

**Rollback triggers**:
- 5xx errors >10% of requests (5 minutes)
- Critical feature broken (payment, auth)
- Database migration failed (data loss risk)

**Rollback steps** (15 minutes max):
1. Revert application code: `git revert HEAD && git push`
2. Rollback database: `npx prisma migrate resolve --rolled-back <migration>`
3. Clear cache: `redis-cli FLUSHDB`
4. Verify: Smoke test production URL
5. Notify: Post incident in Slack

---

## Post-Deployment

### 4. INCIDENT_RESPONSE.md
**Path**: `../../08-maintenance-ops/INCIDENT_RESPONSE_TEMPLATE.md`  
**Purpose**: Incident triage & resolution playbook  
**Time**: 1 hour  
**When**: After first production deployment

**Output**: `docs/INCIDENT_RESPONSE.md`

```bash
cp templates/08-maintenance-ops/INCIDENT_RESPONSE_TEMPLATE.md docs/INCIDENT_RESPONSE.md
# Define: Severity 1-3 SLA, escalation path, postmortem template
```

**Severity levels**:
- **Severity 1** (production down): 15-min response, 2-hour fix, notify CEO
- **Severity 2** (feature broken): 1-hour response, 24-hour fix, notify PM
- **Severity 3** (minor bug): Best-effort, next sprint

**Incident flow**:
1. **Detect**: Monitoring alert → Slack notification
2. **Triage**: Assess severity (S1/S2/S3)
3. **Mitigate**: Rollback or hotfix (S1: 2-hour deadline)
4. **Resolve**: Root cause fix + regression test
5. **Postmortem**: Document incident (5 Whys analysis)

---

### 5. SLA_RETAINER.md
**Path**: `../../08-maintenance-ops/SLA_RETAINER_TEMPLATE.md`  
**Purpose**: Ongoing support contract (monthly retainer)  
**Time**: 1 hour  
**When**: Client wants post-warranty support

**Output**: `contracts/SLA_RETAINER.md`

```bash
mkdir -p contracts
cp templates/08-maintenance-ops/SLA_RETAINER_TEMPLATE.md contracts/SLA_RETAINER.md
# Define: monthly fee, hour bucket, SLA per severity
```

**Standard SLA**:
| Severity | Response Time | Resolution Time | Examples |
|----------|--------------|----------------|----------|
| **Critical** | 2 hours | 8 hours | Production down, payment broken |
| **High** | 8 hours | 48 hours | Login error, data export fail |
| **Medium** | 24 hours | 5 days | UI bug, slow query |
| **Low** | 48 hours | Best-effort | Feature request, cosmetic fix |

**Pricing models**:
1. **Hour bucket**: Rp 10M/month for 20 hours (unused hours rollover 1 month)
2. **Unlimited bugs**: Rp 5M/month (bug fixes only, no features)
3. **Per-incident**: Rp 2M flat per bug (no monthly commitment)

---

## Monitoring & Health

### 6. Health Check Endpoint
**Not a template - Code requirement**

**Implementation** (`/api/health`):
```typescript
export async function GET() {
  const checks = {
    database: await checkDatabase(),
    redis: await checkRedis(),
    s3: await checkS3(),
  };
  
  const healthy = Object.values(checks).every(v => v);
  return Response.json(checks, { status: healthy ? 200 : 503 });
}
```

**Monitor with**:
- **UptimeRobot**: Free 50 monitors, 5-min interval
- **Better Stack**: $10/month, 30-sec interval, incident management
- **Cronitor**: Cron job monitoring + heartbeat checks

---

### 7. Error Tracking
**Not a template - Service requirement**

**Recommended tools**:
- **Sentry**: Free 5K errors/month, source maps, breadcrumbs
- **Rollbar**: Alternative to Sentry, better grouping
- **LogRocket**: Session replay + error tracking (expensive)

**Setup** (Next.js + Sentry):
```bash
npx @sentry/wizard@latest -i nextjs
# Auto-configures sentry.client.config.ts + sentry.server.config.ts
```

---

## Operations Maturity Levels

### Level 0: Cowboy Ops (DANGEROUS)
- ❌ No runbook (setup tribal knowledge)
- ❌ Manual deployment (`git pull` on server)
- ❌ No monitoring (learn about downtime from users)
- ❌ No backup (production = only copy)

**Risk**: One bad deploy wipes database, no recovery

---

### Level 1: Minimum Viable Ops (ACCEPTABLE FOR MVP)
- ✅ RUNBOOK_LOCAL.md (documented setup)
- ✅ Automated deployment (Vercel / Render)
- ✅ Uptime monitoring (UptimeRobot free tier)
- ✅ Daily automated backup (platform-managed)

**Time**: 2 hours setup, good enough for <1K users

---

### Level 2: Professional Ops (PRODUCTION-READY)
- ✅ DEPLOYMENT_PROTOCOL.md + ROLLBACK_PLAN.md
- ✅ INCIDENT_RESPONSE.md playbook
- ✅ Error tracking (Sentry)
- ✅ Health check endpoint
- ✅ Database backups (daily + 30-day retention)
- ✅ SLA documented (client contracts)

**Time**: 5 hours setup, required for >5K users or client work

---

### Level 3: Enterprise Ops (OVERKILL FOR MOST)
- ✅ All Level 2 items
- ✅ Observability (Datadog / New Relic)
- ✅ On-call rotation (PagerDuty)
- ✅ Chaos engineering (failure injection tests)
- ✅ Multi-region failover
- ✅ 99.99% SLA with penalties

**Time**: 40+ hours setup, only for high-stakes systems

---

## Operations Checklist

**Before launch**:
- [ ] RUNBOOK_LOCAL.md tested by fresh developer
- [ ] DEPLOYMENT_PROTOCOL.md checklist 100% complete
- [ ] ROLLBACK_PLAN.md tested in staging
- [ ] Health check endpoint returns 200
- [ ] Uptime monitor configured (5-min pings)
- [ ] Error tracking installed (Sentry DSN set)
- [ ] Database backup automated (daily at 2 AM)

**After launch**:
- [ ] INCIDENT_RESPONSE.md shared with team
- [ ] SLA_RETAINER.md signed (if client work)
- [ ] Postmortem after first incident
- [ ] Runbook updated based on real issues

---

**See also**:
- `../mvp-fast-track/` - Minimal deployment checklist
- `../client-commercial/` - SLA_RETAINER for client contracts
- `../../08-maintenance-ops/` - Full maintenance templates
