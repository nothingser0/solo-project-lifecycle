# Backup and Restore Procedures

> **Purpose**: Document backup strategy and recovery procedures  
> **When**: M05 Architecture (before production deployment)  
> **Target**: Enterprise projects with critical data

---

## Backup Strategy

### RPO (Recovery Point Objective)
**Definition**: Maximum acceptable data loss

**Enterprise Standard**: RPO = 1 hour
- Lose at most 1 hour of data
- Requires: Hourly backups or continuous replication

---

### RTO (Recovery Time Objective)
**Definition**: Maximum acceptable downtime

**Enterprise Standard**: RTO = 4 hours
- System restored within 4 hours
- Includes: Detection + restore + verification

---

## Backup Types

### 1. Full Backup
**What**: Complete copy of all data

**Frequency**: Weekly (Sunday 2 AM)

**Retention**: 4 weeks (monthly archive)

**Storage**: AWS S3 (encrypted)

**Size**: 500GB

**Duration**: 2 hours

**Pros**: Complete, easy to restore  
**Cons**: Slow, storage-intensive

---

### 2. Incremental Backup
**What**: Changes since last backup

**Frequency**: Daily (2 AM)

**Retention**: 7 days

**Storage**: AWS S3

**Size**: 50GB/day average

**Duration**: 20 minutes

**Pros**: Fast, storage-efficient  
**Cons**: Restore requires full + all incrementals

---

### 3. Continuous Replication
**What**: Real-time data replication

**Method**: Database read replica (different region)

**Lag**: <5 seconds

**Purpose**: Disaster recovery failover

**Pros**: Near-zero data loss (RPO <5 sec)  
**Cons**: Costs 2x database

---

## What to Backup

### Database (Critical)
**PostgreSQL**:
```bash
# Full backup (Sunday)
pg_dump -Fc myapp_production > myapp_$(date +%Y%m%d).dump

# Compress and upload to S3
gzip myapp_$(date +%Y%m%d).dump
aws s3 cp myapp_$(date +%Y%m%d).dump.gz s3://myapp-backups/database/
```

**Retention**:
- Daily: 7 days
- Weekly: 4 weeks
- Monthly: 12 months

---

### User Uploads (Important)
**S3 Bucket**: `myapp-uploads`

**Versioning**: Enabled (keeps all versions)

**Cross-Region Replication**: us-east-1 → us-west-2

**Lifecycle Policy**:
- Current version: Indefinite
- Non-current versions: 90 days → delete

---

### Configuration (Critical)
**What**: Environment variables, secrets

**Method**: AWS Secrets Manager (versioned)

**Backup**:
```bash
# Export all secrets to JSON
aws secretsmanager list-secrets | \
  jq -r '.SecretList[].Name' | \
  xargs -I {} aws secretsmanager get-secret-value --secret-id {} > secrets_backup.json

# Encrypt and upload
gpg --encrypt --recipient admin@company.com secrets_backup.json
aws s3 cp secrets_backup.json.gpg s3://myapp-backups/secrets/$(date +%Y%m%d)/
```

---

### Infrastructure as Code (Critical)
**What**: Terraform state, CloudFormation templates

**Method**: Git + S3 versioning

**Backup**:
- Git repository: GitHub (mirrored to GitLab)
- Terraform state: S3 with versioning enabled

---

### Application Code (Critical)
**Method**: Git repository

**Backup**:
- Primary: GitHub
- Mirror: GitLab
- Local: Weekly Git bundle

```bash
# Create Git bundle
git bundle create myapp_$(date +%Y%m%d).bundle --all

# Upload to S3
aws s3 cp myapp_$(date +%Y%m%d).bundle s3://myapp-backups/code/
```

---

## Backup Schedule

| Asset | Frequency | Time (UTC) | Retention |
|:------|:----------|:-----------|:----------|
| **Database Full** | Weekly | Sun 2 AM | 4 weeks |
| **Database Incremental** | Daily | 2 AM | 7 days |
| **User Uploads** | Continuous | Real-time | 90 days (versions) |
| **Configuration** | Weekly | Sun 3 AM | 12 months |
| **Code** | Continuous | On push | Indefinite |
| **Terraform State** | Continuous | On apply | Indefinite (versioned) |

---

## Backup Automation

### Database Backup Script

**`/scripts/backup_database.sh`**:
```bash
#!/bin/bash
set -e

# Configuration
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/tmp/backups"
S3_BUCKET="s3://myapp-backups/database"
DB_NAME="myapp_production"

# Create backup directory
mkdir -p $BACKUP_DIR

# Database backup
echo "Starting database backup..."
pg_dump -Fc $DB_NAME > $BACKUP_DIR/$DB_NAME-$DATE.dump

# Compress
echo "Compressing backup..."
gzip $BACKUP_DIR/$DB_NAME-$DATE.dump

# Upload to S3
echo "Uploading to S3..."
aws s3 cp $BACKUP_DIR/$DB_NAME-$DATE.dump.gz $S3_BUCKET/

# Cleanup local backup
rm $BACKUP_DIR/$DB_NAME-$DATE.dump.gz

# Verify backup
echo "Verifying backup..."
aws s3 ls $S3_BUCKET/$DB_NAME-$DATE.dump.gz

echo "Backup complete: $DB_NAME-$DATE.dump.gz"

# Send notification
curl -X POST https://slack.com/api/chat.postMessage \
  -H "Authorization: Bearer $SLACK_TOKEN" \
  -d "channel=#backups" \
  -d "text=Database backup complete: $DB_NAME-$DATE.dump.gz"
```

---

### Cron Schedule

**`/etc/cron.d/myapp-backups`**:
```cron
# Database full backup (Sunday 2 AM)
0 2 * * 0 /scripts/backup_database.sh full

# Database incremental backup (Daily 2 AM, Mon-Sat)
0 2 * * 1-6 /scripts/backup_database.sh incremental

# Configuration backup (Sunday 3 AM)
0 3 * * 0 /scripts/backup_config.sh
```

---

## Restore Procedures

### Restore Database (Most Common)

**Scenario**: Database corrupted, need to restore from backup

**Steps**:
```bash
# 1. Stop application (prevent writes)
kubectl scale deployment/api --replicas=0

# 2. Download latest backup
aws s3 cp s3://myapp-backups/database/myapp_20241004.dump.gz /tmp/

# 3. Decompress
gunzip /tmp/myapp_20241004.dump.gz

# 4. Restore database
pg_restore -d myapp_production --clean --if-exists /tmp/myapp_20241004.dump

# 5. Verify data integrity
psql -d myapp_production -c "SELECT COUNT(*) FROM users;"
# Expected: ~50,000 rows

# 6. Restart application
kubectl scale deployment/api --replicas=10

# 7. Monitor for issues
kubectl logs -f deployment/api
```

**Duration**: 1-2 hours (depends on database size)

**Data Loss**: Up to 24 hours (last full backup)

---

### Point-in-Time Recovery (PITR)

**Scenario**: Need to restore to specific time (e.g., before accidental deletion)

**Requirements**:
- PostgreSQL WAL (Write-Ahead Logging) archiving enabled
- Transaction logs backed up every 5 minutes

**Steps**:
```bash
# 1. Restore from base backup
pg_restore -d myapp_production /tmp/myapp_base_backup.dump

# 2. Apply transaction logs up to target time
# Target: 2024-10-04 14:30:00 (before deletion at 14:35)
echo "recovery_target_time = '2024-10-04 14:30:00'" > recovery.conf

# 3. Start PostgreSQL in recovery mode
pg_ctl start -D /var/lib/postgresql/data

# 4. Verify recovered data
psql -d myapp_production -c "SELECT * FROM users WHERE deleted_at IS NULL;"

# 5. Promote to primary
pg_ctl promote -D /var/lib/postgresql/data
```

**Duration**: 30 minutes - 2 hours

**Data Loss**: Minimal (5 minutes max)

---

### Restore User Uploads

**Scenario**: S3 bucket accidentally deleted

**Steps**:
```bash
# 1. List deleted objects (versioning enabled)
aws s3api list-object-versions --bucket myapp-uploads \
  --query 'DeleteMarkers[].{Key:Key,VersionId:VersionId}'

# 2. Restore all deleted objects
aws s3api list-object-versions --bucket myapp-uploads \
  --query 'DeleteMarkers[].{Key:Key,VersionId:VersionId}' | \
  jq -r '.[] | "\(.Key) \(.VersionId)"' | \
  while read key versionId; do
    aws s3api delete-object --bucket myapp-uploads --key "$key" --version-id "$versionId"
  done

# 3. Verify restoration
aws s3 ls s3://myapp-uploads/ --recursive | wc -l
# Expected: ~100,000 files
```

**Duration**: 10-30 minutes

**Data Loss**: Zero (versioning preserves all files)

---

## Backup Verification

### Monthly Restore Test

**Purpose**: Ensure backups are valid and restore procedure works

**Schedule**: First Sunday of every month

**Steps**:
1. Create temporary test database
2. Restore from latest backup
3. Verify data integrity (row counts, checksums)
4. Test application against restored database
5. Document results
6. Delete test database

**Success Criteria**:
- Restore completes without errors
- Data integrity checks pass
- Application functions correctly

**Log Results**:
```
Date: 2024-10-06
Backup: myapp_20241004.dump.gz
Restore Time: 45 minutes
Data Integrity: ✅ Pass (users: 50,123 rows)
Application Test: ✅ Pass (login works, queries return results)
```

---

## Backup Monitoring

### Backup Success Alerts

**Datadog Monitor**:
```yaml
name: Database Backup Failed
query: "logs('service:backup status:error').rollup('count').last('1h') > 0"
message: |
  Database backup failed!
  Check logs: https://app.datadoghq.com/logs?query=service:backup
  
  @pagerduty-backup-oncall
```

---

### Backup Age Alert

**CloudWatch Alarm**:
```yaml
# Alert if latest backup older than 36 hours
AlarmName: BackupTooOld
MetricName: TimeSinceLastBackup
Threshold: 129600  # 36 hours in seconds
ComparisonOperator: GreaterThanThreshold
```

---

## Disaster Recovery

**See**: `DISASTER_RECOVERY_PLAN.md` for full DR procedures

**Quick Reference**:
- Data center failure → Failover to secondary region (30 min)
- Database corruption → Restore from backup (2 hours)
- Ransomware → Restore from offline backup (8-24 hours)

---

## Backup Checklist

**Setup**:
- [ ] Automated daily database backups
- [ ] S3 versioning enabled (user uploads)
- [ ] Cross-region replication configured
- [ ] Backup monitoring alerts set up
- [ ] Restore procedures documented

**Monthly**:
- [ ] Test restore from backup
- [ ] Verify data integrity
- [ ] Update documentation if procedures changed
- [ ] Review backup retention policy

**After Incidents**:
- [ ] Document what happened
- [ ] Update restore procedures
- [ ] Adjust backup frequency if needed

---

## Notes

**Test your backups**: Untested backups are not backups

**Automate everything**: Manual backups get forgotten

**3-2-1 Rule**: 3 copies, 2 different media, 1 off-site

**Encrypt backups**: Especially if stored off-site
