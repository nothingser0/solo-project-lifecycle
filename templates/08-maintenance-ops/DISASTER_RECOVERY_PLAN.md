# Disaster Recovery Plan

> **Purpose**: Recover from catastrophic failures and ensure business continuity  
> **When**: Activated during major disasters (data center down, ransomware, natural disaster)  
> **Target**: Enterprise projects with critical uptime requirements

---

## Disaster Recovery Objectives

### RPO (Recovery Point Objective)
**Definition**: Maximum acceptable data loss

**Enterprise Standard**: RPO = 1 hour
- Data loss limited to last 1 hour
- Requires: Hourly backups or continuous replication

**Example**:
```
Disaster occurs at 3:00 PM
Last backup at 2:00 PM
Data loss: 1 hour (2:00 PM - 3:00 PM)
```

---

### RTO (Recovery Time Objective)
**Definition**: Maximum acceptable downtime

**Enterprise Standard**: RTO = 4 hours
- System restored within 4 hours
- Includes: Detection + failover + verification

**Example**:
```
Disaster detected: 3:00 PM
Recovery complete: 7:00 PM (4 hours)
```

---

## Disaster Scenarios

### Scenario 1: Primary Data Center Failure

**Cause**: AWS us-east-1 region outage, power failure, natural disaster

**Impact**: Complete service outage

**Recovery Strategy**: Failover to secondary region

**Steps**:
1. Detect outage (monitoring alerts)
2. Verify primary region is down (AWS Health Dashboard)
3. Activate DR plan
4. Redirect traffic to secondary region (Route 53 DNS failover)
5. Promote read replica to primary database
6. Verify application functionality
7. Monitor for issues

**RTO**: 30 minutes (automated failover)  
**RPO**: 5 minutes (continuous database replication)

---

### Scenario 2: Database Corruption

**Cause**: Software bug, admin error, hardware failure

**Impact**: Data inconsistency, query failures

**Recovery Strategy**: Restore from backup

**Steps**:
1. Detect corruption (failed queries, integrity check errors)
2. Stop write operations (enable read-only mode)
3. Identify last known good backup
4. Restore database from backup
5. Replay transaction logs (point-in-time recovery)
6. Verify data integrity
7. Re-enable write operations

**RTO**: 2 hours  
**RPO**: 15 minutes (transaction log replay)

---

### Scenario 3: Ransomware Attack

**Cause**: Malware encrypts production data

**Impact**: Data encrypted, system unusable

**Recovery Strategy**: Restore from offline backups

**Steps**:
1. Detect ransomware (encryption activity, ransom note)
2. Isolate infected systems (disconnect from network)
3. Do NOT pay ransom
4. Assess damage (which systems infected)
5. Restore clean systems from backups
6. Verify backups are clean (not infected)
7. Restore data from backups
8. Update security (patch vulnerabilities)
9. Monitor for reinfection

**RTO**: 8-24 hours (depends on infection scope)  
**RPO**: 24 hours (daily offline backups)

---

### Scenario 4: Accidental Data Deletion

**Cause**: Admin error (`DROP DATABASE`, `DELETE FROM users;`)

**Impact**: Critical data lost

**Recovery Strategy**: Point-in-time recovery

**Steps**:
1. Detect deletion (user reports, monitoring alerts)
2. Stop all write operations immediately
3. Identify deletion time (audit logs)
4. Restore database to snapshot before deletion
5. Replay transaction logs to recover recent data
6. Verify data restored
7. Investigate how deletion occurred (prevent recurrence)

**RTO**: 1 hour  
**RPO**: 15 minutes

---

### Scenario 5: Complete Infrastructure Loss

**Cause**: Account compromise, catastrophic failure

**Impact**: Everything gone (database, code, infrastructure)

**Recovery Strategy**: Rebuild from scratch using backups

**Steps**:
1. Secure new AWS account
2. Recreate infrastructure (Terraform/CloudFormation)
3. Restore database from off-site backups
4. Deploy application from Git repository
5. Restore configuration from secrets manager backup
6. Verify functionality
7. Update DNS to point to new infrastructure

**RTO**: 12-48 hours (full rebuild)  
**RPO**: 24 hours (daily off-site backups)

---

## Backup Strategy

### Database Backups

**Automated Daily Backups**:
- Schedule: 2:00 AM UTC (low traffic)
- Retention: 30 days
- Storage: AWS S3 (encrypted)
- Format: PostgreSQL dump or RDS snapshot

**Continuous Replication**:
- Read replica in different region
- Lag: <5 seconds
- Purpose: Failover database

**Point-in-Time Recovery**:
- Transaction logs archived every 5 minutes
- Retention: 7 days
- Allows restore to any minute in last 7 days

---

### Application Backups

**Source Code**:
- GitHub (primary)
- GitLab mirror (secondary)
- Local backup: Weekly Git bundle

**Configuration**:
- Secrets: AWS Secrets Manager (replicated to secondary region)
- Infrastructure as Code: Terraform state in S3 (versioned)
- Environment variables: Documented in runbook

---

### File Storage Backups

**User Uploads**:
- Storage: AWS S3
- Versioning: Enabled (keep all versions)
- Replication: Cross-region replication to us-west-2
- Lifecycle: Delete after 90 days

---

### Backup Verification

**Monthly Restore Test**:
- [ ] Restore database from backup
- [ ] Verify data integrity (row counts, checksums)
- [ ] Test application against restored database
- [ ] Document restore time (track against RTO)

**Quarterly DR Drill**:
- [ ] Full disaster recovery simulation
- [ ] Failover to secondary region
- [ ] Test all recovery procedures
- [ ] Document findings and improve plan

---

## Failover Architecture

### Multi-Region Setup

**Primary Region**: AWS us-east-1 (Virginia)
- Application servers: 10 instances
- Database: PostgreSQL RDS (primary)
- Load balancer: ALB

**Secondary Region**: AWS us-west-2 (Oregon)
- Application servers: 2 instances (warm standby)
- Database: PostgreSQL RDS (read replica)
- Load balancer: ALB

**DNS Failover**: Route 53 health checks
- Monitor primary region every 30 seconds
- If 3 consecutive failures: Failover to secondary region
- TTL: 60 seconds (fast DNS propagation)

---

### Database Failover

**Automated Failover**:
1. Primary database fails
2. RDS detects failure (health check)
3. Read replica promoted to primary (automatic)
4. Application reconnects to new primary
5. Duration: 1-2 minutes

**Manual Failover** (if automated fails):
```bash
# Promote read replica to primary
aws rds promote-read-replica \
  --db-instance-identifier db-replica-us-west-2

# Update application connection string
export DATABASE_URL=postgresql://user:pass@new-primary:5432/db
```

---

## Recovery Procedures

### Procedure 1: Database Restore from Backup

**When**: Database corrupted, data deleted accidentally

**Steps**:
```bash
# 1. Stop application (prevent writes)
kubectl scale deployment/api --replicas=0

# 2. Download latest backup from S3
aws s3 cp s3://backups/db-2024-10-04.dump /tmp/

# 3. Restore to temporary database
pg_restore -d postgres -C /tmp/db-2024-10-04.dump

# 4. Verify data integrity
psql -d production -c "SELECT COUNT(*) FROM users;"

# 5. Point application to restored database
export DATABASE_URL=postgresql://user:pass@restored-db:5432/production

# 6. Restart application
kubectl scale deployment/api --replicas=10

# 7. Monitor for issues
```

**Duration**: 1-2 hours

---

### Procedure 2: Failover to Secondary Region

**When**: Primary region down (AWS outage, data center failure)

**Steps**:
```bash
# 1. Verify primary region is down
aws ec2 describe-instances --region us-east-1
# (no response or errors)

# 2. Promote read replica in secondary region
aws rds promote-read-replica \
  --db-instance-identifier db-us-west-2 \
  --region us-west-2

# 3. Scale up application in secondary region
kubectl scale deployment/api --replicas=10 --context us-west-2

# 4. Update DNS to point to secondary region
aws route53 change-resource-record-sets \
  --hosted-zone-id Z123 \
  --change-batch file://failover.json

# 5. Verify traffic flowing to secondary region
curl https://api.yourcompany.com

# 6. Monitor for issues
```

**Duration**: 15-30 minutes

---

### Procedure 3: Restore from Ransomware

**When**: Production system encrypted by ransomware

**Steps**:
```bash
# 1. Isolate infected systems
# Disconnect from network, power down affected servers

# 2. Create new clean infrastructure
terraform apply -var="environment=dr-clean"

# 3. Restore database from clean backup
# Use backup from before infection (verify clean with antivirus)
aws s3 cp s3://backups/db-2024-10-03.dump /tmp/
pg_restore -d postgres -C /tmp/db-2024-10-03.dump

# 4. Deploy clean application code
git clone https://github.com/yourcompany/app.git
kubectl apply -f k8s/

# 5. Update DNS to point to clean infrastructure
# (Only after verifying clean)

# 6. Notify users of incident
# Email explaining downtime and recovery

# 7. Investigate how ransomware entered
# Patch vulnerabilities, update security
```

**Duration**: 8-24 hours

---

## Communication Plan

### Internal Communication (During DR)

**Slack #disaster-recovery Channel**:
```
🔴 DISASTER RECOVERY ACTIVATED
Disaster: AWS us-east-1 region down
Impact: Complete service outage
DR Plan: Failover to us-west-2
Status: In progress
Updates: Every 15 minutes
```

**Stakeholder Notification**:
- CEO, CTO: Immediate call
- Executive team: Email within 15 minutes
- All staff: Slack announcement

---

### External Communication

**Status Page**:
```
[Oct 4, 03:00 UTC] Major Outage
We are experiencing a complete service outage due to AWS 
region failure. We have activated our disaster recovery 
plan and are failing over to a secondary region.

ETA: 30 minutes

Updates: Every 15 minutes
```

**Customer Email** (after recovery):
```
Subject: Service Restored - Disaster Recovery Update

Dear Customers,

On October 4, 2024 at 03:00 UTC, we experienced a complete 
service outage due to an AWS us-east-1 region failure.

Our disaster recovery plan was immediately activated, and 
we successfully failed over to our secondary region (us-west-2) 
within 25 minutes.

Timeline:
- 03:00 UTC: Outage detected
- 03:05 UTC: DR plan activated
- 03:25 UTC: Service restored in secondary region
- Total downtime: 25 minutes

No data was lost. All systems are now fully operational.

We apologize for the inconvenience.

Sincerely,
The [Company] Team
```

---

## DR Testing Schedule

**Monthly**:
- [ ] Backup restore test (verify backups work)
- [ ] Review and update DR plan

**Quarterly**:
- [ ] Full DR drill (failover to secondary region)
- [ ] Tabletop exercise (walk through scenarios)

**Annually**:
- [ ] Comprehensive DR audit
- [ ] Update RPO/RTO based on business needs
- [ ] Review insurance coverage

---

## DR Checklist

**Before Disaster**:
- [ ] Automated backups running daily
- [ ] Backups tested monthly (restore and verify)
- [ ] Secondary region configured (warm standby)
- [ ] DNS failover configured and tested
- [ ] DR plan documented and accessible (printed copy)
- [ ] Team trained on DR procedures
- [ ] Contact list updated (on-call, stakeholders)

**During Disaster**:
- [ ] Assess severity and impact
- [ ] Activate DR plan (declare disaster)
- [ ] Notify stakeholders
- [ ] Execute recovery procedures
- [ ] Document timeline and actions
- [ ] Communicate with customers

**After Recovery**:
- [ ] Verify all systems operational
- [ ] Monitor for issues (24-48 hours)
- [ ] Conduct post-mortem
- [ ] Update DR plan based on learnings
- [ ] Restore redundancy (rebuild primary if needed)

---

## DR Team Roles

**DR Coordinator** (CTO or VP Engineering):
- Declares disaster
- Authorizes DR plan activation
- Communicates with executives

**Technical Lead**:
- Executes recovery procedures
- Coordinates engineering team
- Verifies system functionality

**Communications Lead**:
- Updates status page
- Sends customer emails
- Handles media inquiries

**Operations Lead**:
- Manages infrastructure failover
- Monitors system health
- Coordinates with cloud providers

---

## Insurance & Financial

**Cyber Insurance**:
- Coverage: $5M for data breach, ransomware
- Deductible: $25k
- Includes: Legal fees, customer notification, credit monitoring

**Business Interruption Insurance**:
- Coverage: Revenue loss during outage
- Waiting period: 8 hours
- Maximum payout: $1M

**Claim Process**:
1. Document incident (timeline, impact, costs)
2. Notify insurance within 24 hours
3. Preserve evidence (logs, forensics)
4. File claim with documentation

---

## Tools & Resources

**Backup Tools**:
- AWS RDS Automated Backups
- pg_dump (PostgreSQL)
- Restic (incremental backups)

**DR Automation**:
- Terraform (infrastructure as code)
- Ansible (configuration management)
- AWS CloudFormation

**Monitoring**:
- AWS Health Dashboard
- Datadog (multi-region monitoring)
- PagerDuty (alerting)

**Communication**:
- Statuspage.io (status page)
- Slack (internal coordination)
- Email (customer notification)

---

## Lessons from Real Disasters

**Case Study 1: GitLab Database Incident (2017)**
- Incident: Database backup failed, production database deleted
- Recovery: 6 hours, lost 6 hours of data (RPO violated)
- Lesson: Test backup restores regularly

**Case Study 2: AWS us-east-1 Outage (2021)**
- Incident: Power failure in AWS data center
- Recovery: 7 hours for full recovery
- Lesson: Multi-region architecture critical

**Case Study 3: Code Spaces Shutdown (2014)**
- Incident: Ransomware + backup deletion
- Recovery: Could not recover, company shut down
- Lesson: Off-site backups, air-gapped from production

---

## Notes

**Test your backups**: Untested backups are not backups

**Multi-region is expensive but critical**: Cost of downtime >> cost of redundancy

**Automate DR procedures**: Manual failover = human error + slow

**DR plan is living document**: Update after every drill and real incident
