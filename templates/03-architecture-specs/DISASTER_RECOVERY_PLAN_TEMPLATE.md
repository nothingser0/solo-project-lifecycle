# Disaster Recovery Plan: [Project Name]

**Version**: 1.0  
**Date**: [YYYY-MM-DD]  
**Last Updated**: [YYYY-MM-DD]  
**Owner**: [DevOps Lead / CTO]  
**Status**: [Draft / Approved / Tested]

---

## 1. Executive Summary

**Purpose**: This document defines procedures to recover from catastrophic failures with minimal data loss and downtime.

**Recovery Objectives**:
- **RPO (Recovery Point Objective)**: Maximum acceptable data loss = [1 hour]
- **RTO (Recovery Time Objective)**: Maximum acceptable downtime = [30 minutes]

**Last DR Drill**: [Date] | **Result**: [Pass / Fail] | **Next Drill**: [Date]

---

## 2. Disaster Scenarios

### 2.1 Severity Classification

| Level | Description | Impact | Example | RTO Target |
|-------|-------------|--------|---------|------------|
| **S1 - Critical** | Total service outage | All users affected, revenue loss | Data center failure, database corruption | 30 min |
| **S2 - Major** | Significant degradation | Core features unavailable | Payment gateway down, API rate limit exceeded | 2 hours |
| **S3 - Minor** | Partial degradation | Non-critical features affected | Email delivery delayed, analytics down | 24 hours |

### 2.2 Covered Disaster Scenarios

**Infrastructure Failures**:
- [ ] Primary database server failure
- [ ] Application server cluster failure
- [ ] CDN/DNS provider outage
- [ ] Cloud region outage (AWS/GCP/Azure)
- [ ] Load balancer failure

**Data Disasters**:
- [ ] Database corruption
- [ ] Accidental data deletion (DROP TABLE)
- [ ] Ransomware / malicious data encryption
- [ ] Data breach requiring system isolation

**Software Failures**:
- [ ] Buggy deployment causing crashes
- [ ] Database migration failure
- [ ] Third-party API outage (payment, email, storage)
- [ ] DDoS attack

**Human Errors**:
- [ ] Accidental deletion of production resources
- [ ] Configuration error causing outage
- [ ] Secrets/credentials leaked

---

## 3. Backup Strategy

### 3.1 Database Backups

**Automated Backups** (PostgreSQL):
```bash
# Daily full backup at 02:00 UTC
# Cron: 0 2 * * * /scripts/backup-db.sh

#!/bin/bash
DATE=$(date +%Y%m%d_%H%M%S)
DB_NAME="production_db"
BACKUP_FILE="/tmp/backup_${DB_NAME}_${DATE}.sql.gz"

# Dump and compress
pg_dump $DATABASE_URL | gzip > $BACKUP_FILE

# Upload to S3 with encryption
aws s3 cp $BACKUP_FILE s3://backups-bucket/db/ \
  --storage-class STANDARD_IA \
  --server-side-encryption AES256

# Cleanup local file
rm $BACKUP_FILE

# Verify backup integrity
aws s3api head-object --bucket backups-bucket --key db/backup_${DB_NAME}_${DATE}.sql.gz
```

**Retention Policy**:
- **Daily backups**: Retained for 7 days
- **Weekly backups** (Sunday): Retained for 4 weeks
- **Monthly backups** (1st of month): Retained for 12 months
- **Yearly backups** (Jan 1st): Retained for 3 years

**Backup Verification**:
- **Automated**: Weekly restore to staging environment (Sundays 03:00 UTC)
- **Manual**: Quarterly full restore drill (documented below)

### 3.2 File Storage Backups

**S3/R2 Configuration**:
```json
{
  "versioning": "enabled",
  "lifecycle_rules": [
    {
      "id": "archive_old_versions",
      "status": "enabled",
      "noncurrent_version_expiration": {
        "days": 30
      }
    }
  ],
  "replication": {
    "enabled": true,
    "destination": "s3://backups-cross-region/",
    "rules": ["replicate_all"]
  }
}
```

**Critical Files**:
- User uploads (avatars, documents): S3 versioning + cross-region replication
- Application assets (built JS/CSS): Backed up in Git + S3
- Logs: Shipped to Axiom/Datadog (30-day retention)

### 3.3 Infrastructure as Code Backups

**Git Repository**:
- All infrastructure code committed to private GitHub repo
- Protected main branch (require PR approval)
- Daily automated Git tags: `backup-YYYYMMDD`

**Secrets Backup**:
- Production secrets encrypted in Bitwarden vault (exported weekly to encrypted USB)
- `.env.production` stored in AWS Secrets Manager with versioning enabled

---

## 4. Recovery Procedures

### 4.1 S1: Database Primary Failure

**Scenario**: Primary database instance crashes or becomes unresponsive.

**Detection**:
- Health check fails: `/api/ready` returns 503
- Alert fired: "Database connection pool exhausted"
- Monitoring shows: No successful DB queries for 2 minutes

**Recovery Steps**:

**Option A: Automated Failover (RDS Multi-AZ / PlanetScale)**
```
Time: 0-5 minutes (automatic)
1. AWS RDS detects primary failure
2. Automatic failover to standby replica
3. DNS CNAME updated to point to new primary
4. Application reconnects automatically
5. Verify service restored via health checks
```

**Option B: Manual Failover to Read Replica**
```
Time: 10-15 minutes

Step 1: Promote read replica to primary (5 min)
$ aws rds promote-read-replica \
  --db-instance-identifier prod-db-replica-1

Step 2: Update application DATABASE_URL (2 min)
$ vercel env rm DATABASE_URL production
$ vercel env add DATABASE_URL production
# Enter new connection string from promoted replica

Step 3: Redeploy application (3 min)
$ vercel --prod

Step 4: Verify (2 min)
- Test write operation: Create test user
- Check health endpoint: curl https://app.example.com/api/ready
- Monitor error rate: Should return to < 0.1%

Step 5: Recreate read replica (background, 30 min)
$ aws rds create-db-instance-read-replica \
  --db-instance-identifier prod-db-replica-new \
  --source-db-instance-identifier prod-db-primary
```

**Post-Recovery**:
- [ ] Document incident timeline in post-mortem
- [ ] Analyze root cause (disk failure, memory exhaustion, etc.)
- [ ] Schedule primary instance replacement if hardware failure

### 4.2 S1: Database Corruption / Data Loss

**Scenario**: Accidental `DROP TABLE` or data corruption detected.

**Recovery Steps**:

```
Time: 15-30 minutes

Step 1: Isolate affected database (1 min)
- Revoke write permissions from application
- Enable read-only mode on database

Step 2: Identify last known good backup (2 min)
$ aws s3 ls s3://backups-bucket/db/ | grep $(date -d "yesterday" +%Y%m%d)
# Identify backup timestamp before corruption

Step 3: Restore backup to temporary instance (10 min)
$ aws rds restore-db-instance-from-db-snapshot \
  --db-instance-identifier prod-db-restore-temp \
  --db-snapshot-identifier backup-20240127-020000

Step 4: Validate restored data (5 min)
$ psql $TEMP_DATABASE_URL
> SELECT COUNT(*) FROM users;  -- Verify row counts
> SELECT MAX(created_at) FROM orders;  -- Verify latest timestamp

Step 5: Merge recent data if needed (10 min)
# If corruption happened 2 hours ago, export data from 02:00-04:00 from corrupt DB
$ pg_dump --data-only --table=orders \
  --where="created_at >= '2024-01-27 02:00:00'" \
  $OLD_DATABASE_URL > recent_data.sql

# Import into restored DB
$ psql $TEMP_DATABASE_URL < recent_data.sql

Step 6: Switch to restored database (3 min)
- Update DATABASE_URL to point to restored instance
- Redeploy application
- Monitor for errors

Step 7: Decommission corrupt database (after 24h validation)
```

**Data Loss Assessment**:
- RPO = Time since last backup (max 1 hour with hourly backups)
- Notify affected users if data created after last backup is lost

### 4.3 S1: Application Deployment Failure

**Scenario**: New deployment causes crashes, infinite loops, or errors > 10%.

**Recovery Steps**:

```
Time: 2-5 minutes

Step 1: Immediate rollback (1 min)
# Vercel 1-click rollback
$ vercel rollback --prod

# Or AWS ECS
$ aws ecs update-service --cluster prod --service app \
  --task-definition app:previous-revision

Step 2: Verify rollback success (1 min)
- Error rate returns to < 0.1%
- p95 latency < 500ms
- Health checks passing

Step 3: Clear CDN cache (1 min)
$ curl -X POST "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/purge_cache" \
  -H "Authorization: Bearer $CF_API_TOKEN" \
  -d '{"purge_everything":true}'

Step 4: Notify team (1 min)
- Post in #incidents: "Deployment rolled back, investigating root cause"
- Update status page: "Service restored, investigating issue"
```

**Post-Rollback**:
- [ ] Analyze deployment logs for root cause
- [ ] Reproduce failure in staging
- [ ] Fix bug and re-deploy with extra monitoring

### 4.4 S2: Third-Party Service Outage (Stripe, SendGrid, etc.)

**Scenario**: Payment gateway or email service unavailable.

**Recovery Steps**:

```
Time: Immediate (graceful degradation)

Step 1: Enable fallback mode (code should auto-detect)
try {
  await stripe.charges.create({ amount });
} catch (error) {
  // Fallback: Save order as "payment_pending"
  await prisma.order.create({
    data: { ...orderData, status: 'payment_pending' },
  });
  // Queue for retry when service restored
  await paymentQueue.add({ orderId, retry: true });
}

Step 2: Notify users
- Show banner: "Payment processing temporarily delayed, your order is saved"
- Send email: "Complete payment via link: https://app.example.com/orders/123/pay"

Step 3: Monitor third-party status page
- Stripe: https://status.stripe.com
- SendGrid: https://status.sendgrid.com

Step 4: Retry queued operations when service restored
$ node scripts/retry-failed-payments.js
```

### 4.5 S1: Complete Cloud Region Outage (AWS us-east-1 down)

**Scenario**: Entire AWS region unavailable (rare but catastrophic).

**Recovery Steps** (only if multi-region setup exists):

```
Time: 30-60 minutes

Step 1: Verify outage scope (5 min)
- Check AWS Status Page: https://health.aws.amazon.com
- Confirm all services in region are down

Step 2: Activate DR region (10 min)
- DNS failover: Update Route53 to point to us-west-2
- Verify DR database replica is available
- Scale up DR application instances

Step 3: Validate DR region (10 min)
- Test user login flow
- Test order creation
- Verify payment processing

Step 4: Monitor and communicate (ongoing)
- Update status page: "Traffic routed to backup region"
- Monitor error rates in DR region
- Prepare for failback when primary region restored
```

**Solo Dev Reality**: Multi-region DR is expensive and complex. Instead:
- Use managed services with built-in HA (Vercel, PlanetScale auto-deploy globally)
- Accept 30-60 min RTO if full region outage occurs (extremely rare)
- Focus on fast backup restoration over multi-region complexity

---

## 5. Communication Plan

### 5.1 Incident Notification Flow

**Internal Team**:
```
Detection (0 min) → #incidents Slack channel → Incident Commander assigned
└─> Update every 15 min until resolved
```

**External Users**:
```
S1 Incident (5 min) → Status page updated: "Investigating"
                    → Twitter/X post (if public-facing app)
                    → Email to enterprise customers (if B2B)

Resolved (30 min)  → Status page: "Resolved"
                    → Post-mortem published (24h later)
```

### 5.2 Status Page Template

**StatusPage.io / Custom Status Page**:

```
🔴 Major Outage (S1)
We are experiencing a complete service outage affecting all users.
Our team is actively investigating and working on a fix.

Started: 2024-01-27 14:23 UTC
Last Update: 2024-01-27 14:38 UTC
Next Update: 2024-01-27 14:45 UTC

Updates:
- 14:38 UTC: Identified database issue, restoring from backup
- 14:23 UTC: Investigating reports of 503 errors
```

### 5.3 Contact List

| Role | Name | Phone | Email | Backup |
|------|------|-------|-------|--------|
| Incident Commander | [Name] | [+62xxx] | [email] | [Backup Name] |
| Database Admin | [Name] | [+62xxx] | [email] | [Backup Name] |
| DevOps Engineer | [Name] | [+62xxx] | [email] | [Backup Name] |
| CTO / Technical Lead | [Name] | [+62xxx] | [email] | — |

**Escalation Path**:
- 0-15 min: On-call engineer handles
- 15-30 min: Escalate to Incident Commander
- 30+ min: Escalate to CTO

---

## 6. DR Drill Schedule

### 6.1 Quarterly Disaster Recovery Drill

**Objective**: Validate recovery procedures and team readiness.

**Drill Date**: [Next drill: Q1 2024 - March 15]

**Drill Scenario**: Database corruption requiring restore from backup

**Participants**:
- Incident Commander: [Name]
- Database Admin: [Name]
- DevOps Engineer: [Name]
- Observer: [Name - takes notes, times each step]

**Drill Procedure**:
```
1. [09:00] Simulate incident: Rename production database to trigger failure
2. [09:01] Incident Commander receives alert, declares drill start
3. [09:02] Follow "4.2 Database Corruption" recovery procedure
4. [09:30] Verify restored database is operational
5. [09:35] Rollback drill (restore original database)
6. [10:00] Post-drill debrief meeting

Success Criteria:
- [ ] RTO met: Service restored within 30 minutes
- [ ] RPO met: Data loss < 1 hour
- [ ] All team members followed documented procedures
- [ ] No critical steps missing from runbook
```

**Post-Drill Actions**:
- [ ] Document actual RTO/RPO achieved
- [ ] Update runbook with lessons learned
- [ ] Fix any gaps in automation or documentation

### 6.2 Drill Results Log

| Date | Scenario | RTO Target | RTO Actual | Pass/Fail | Issues Found |
|------|----------|------------|------------|-----------|--------------|
| 2024-01-15 | DB restore | 30 min | 25 min | ✅ Pass | None |
| [Next drill] | — | 30 min | — | — | — |

---

## 7. Recovery Validation Checklist

After any disaster recovery, validate these items before declaring "fully recovered":

**Application Health**:
- [ ] All health checks passing (`/api/health`, `/api/ready`)
- [ ] Error rate < 0.1% for 10 minutes
- [ ] p95 latency < 500ms
- [ ] No 5xx errors in last 5 minutes

**Data Integrity**:
- [ ] Row counts match expected values (compare with previous day)
- [ ] Latest records have recent timestamps (no stale data)
- [ ] Test write operation successful (create + delete test record)
- [ ] Foreign key constraints intact (no orphaned records)

**Functionality**:
- [ ] User login works
- [ ] Order creation works (end-to-end test)
- [ ] Payment processing works (test transaction)
- [ ] Email delivery works (send test email)

**Monitoring & Alerting**:
- [ ] All monitoring dashboards show green
- [ ] Alert rules are active (not silenced)
- [ ] Log aggregation receiving data
- [ ] Backup jobs scheduled correctly

**External Communication**:
- [ ] Status page updated to "All systems operational"
- [ ] Incident post-mortem drafted (publish within 24h)
- [ ] Customer support team notified of resolution

---

## 8. Post-Incident Review (PIR)

**Template**: Complete within 24 hours of incident resolution

### 8.1 Incident Summary

**Incident ID**: [INC-2024-001]  
**Date**: [YYYY-MM-DD]  
**Duration**: [Start time] - [End time] = [Total downtime]  
**Severity**: [S1 / S2 / S3]  
**Root Cause**: [One-sentence description]

### 8.2 Timeline

| Time (UTC) | Event | Action Taken |
|------------|-------|--------------|
| 14:23 | Alert fired: Database connection timeout | On-call engineer paged |
| 14:25 | Incident Commander joined incident channel | Declared S1 incident |
| 14:30 | Identified primary DB crashed | Initiated failover to replica |
| 14:38 | Replica promoted to primary | Updated DATABASE_URL, redeployed app |
| 14:42 | Service restored | Monitoring shows error rate normalized |
| 14:50 | Post-incident validation complete | Declared "fully recovered" |

**Total Downtime**: 27 minutes  
**RTO Target**: 30 minutes ✅ Met

### 8.3 Impact Assessment

**Users Affected**: [~1,200 active users at time of incident]  
**Revenue Impact**: [~$500 lost sales during outage]  
**Data Loss**: [None - RPO met]

### 8.4 What Went Well

- Automated alerts fired immediately (within 1 minute of failure)
- Team followed runbook accurately
- RTO target met (27 min < 30 min target)
- No data loss

### 8.5 What Went Wrong

- Read replica promotion took longer than expected (10 min instead of 5 min)
- Delay caused by manual DNS update (should be automated)

### 8.6 Action Items

| Action | Owner | Due Date | Status |
|--------|-------|----------|--------|
| Automate DNS failover using Route53 health checks | DevOps | 2024-02-01 | 🟡 In Progress |
| Add read replica promotion playbook to runbook | DevOps | 2024-01-28 | ✅ Done |
| Schedule quarterly DR drill | CTO | 2024-03-15 | 🟢 Scheduled |

---

## 9. Appendix

### 9.1 Access Credentials

**Emergency Access** (stored in Bitwarden vault `DR-Emergency`):
- AWS Root Account MFA recovery codes
- Database admin passwords
- DNS provider API keys
- Cloud provider support phone numbers

**Break-Glass Procedure**: If primary engineers unavailable, CTO can access Bitwarden vault using emergency USB backup.

### 9.2 Vendor Support Contacts

| Vendor | Support Tier | Contact | SLA |
|--------|--------------|---------|-----|
| AWS | Business Support | [Phone], [Case portal] | 1-hour response (S1) |
| Cloudflare | Enterprise | [Account Manager], [Support email] | 15-min response |
| Vercel | Pro | [Support email] | 24-hour response |
| Supabase | Pro | [Support email] | 4-hour response |

### 9.3 Quick Reference Commands

**Database Restore**:
```bash
# List available backups
aws s3 ls s3://backups-bucket/db/

# Download and restore
aws s3 cp s3://backups-bucket/db/backup_20240127_020000.sql.gz /tmp/
gunzip /tmp/backup_20240127_020000.sql.gz
psql $DATABASE_URL < /tmp/backup_20240127_020000.sql
```

**Deployment Rollback**:
```bash
# Vercel
vercel rollback --prod

# AWS ECS
aws ecs update-service --cluster prod --service app --force-new-deployment
```

**Emergency Contact**:
```bash
# Send SMS alert to team
curl -X POST https://api.twilio.com/Messages \
  -d "To=+62xxx" -d "Body=DR Event: Database failure, initiating recovery"
```

---

**Document Approval**:
- **Prepared by**: [Name, DevOps Engineer]  
- **Reviewed by**: [Name, CTO]  
- **Approved by**: [Name, CEO/CTO]  
- **Date**: [YYYY-MM-DD]

**Next Review**: [Quarterly - Q2 2024]
