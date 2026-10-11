# Data Retention Policy Template

> **Purpose**: Define how long to keep data and when to delete  
> **When**: M05 Architecture (before collecting user data)  
> **Target**: Enterprise projects with UU PDP No. 27/2022 or sectoral retention requirements

---

## Why Data Retention Matters

**Legal Requirements**:
- UU PDP / GDPR: Tidak boleh menyimpan data lebih lama dari tujuan pemrosesan
- Kemenkes/UU PDP: Rekam medis disimpan sesuai Permenkes (umumnya >= 5 tahun)
- Tax law: Keep financial records 7 years

**Business Reasons**:
- Reduce storage costs (delete old data)
- Reduce security risk (less data to protect)
- Reduce liability (can't breach data you don't have)

---

## Retention Periods by Data Type

### Customer Data

| Data Type | Retention | Rationale | Deletion Method |
|:----------|:----------|:----------|:----------------|
| **Active user account** | While account active | Business need | Soft delete on request |
| **Deleted user account** | 30 days | Allow recovery | Hard delete after 30 days |
| **Customer name, email** | 7 years after last activity | Legal (contracts) | Anonymize after 7 years |
| **Purchase history** | 7 years | Legal (tax) | Anonymize customer, keep transaction |
| **Payment card data** | Never store | PCI-DSS | Use tokens only |
| **Browsing history** | 90 days | Analytics | Rolling deletion |
| **Customer support tickets** | 3 years | Business need | Archive then delete |

---

### Authentication Data

| Data Type | Retention | Rationale | Deletion Method |
|:----------|:----------|:----------|:----------------|
| **Passwords (hashed)** | While account active | Security | Delete with account |
| **Session tokens** | 24 hours | Security | Auto-expire |
| **Password reset tokens** | 1 hour | Security | Auto-expire |
| **MFA secrets** | While MFA enabled | Security | Delete when disabled |
| **Login history** | 1 year | Security audit | Rolling deletion |

---

### Audit Logs

| Data Type | Retention | Rationale | Deletion Method |
|:----------|:----------|:----------|:----------------|
| **Security logs** | 1 year | SOC 2, ISO 27001 | Archive to cold storage |
| **Access logs (PII)** | 6 years | UU PDP / sektoral | Cold storage |
| **Application logs** | 90 days | Debugging | Rolling deletion |
| **Error logs** | 90 days | Debugging | Rolling deletion |

---

### Business Data

| Data Type | Retention | Rationale | Deletion Method |
|:----------|:----------|:----------|:----------------|
| **Invoices** | 7 years | Tax law | Archive then delete |
| **Contracts** | 7 years after expiry | Legal | Archive then delete |
| **Financial reports** | 7 years | Tax law | Archive then delete |
| **Employee records** | 7 years after termination | Legal | Archive then delete |

---

### Backups

| Data Type | Retention | Rationale | Deletion Method |
|:----------|:----------|:----------|:----------------|
| **Daily backups** | 7 days | Recovery | Auto-delete |
| **Weekly backups** | 4 weeks | Recovery | Auto-delete |
| **Monthly backups** | 12 months | Recovery | Auto-delete |
| **Annual backups** | 7 years | Legal | Archive then delete |

---

## Retention Rules

### Rule 1: Keep Only as Long as Needed

**GDPR Principle**: Data minimization

**Example**:
- ❌ Bad: Keep all customer data forever "just in case"
- ✅ Good: Delete customer data 30 days after account deletion

---

### Rule 2: Anonymize Instead of Delete (When Possible)

**Purpose**: Keep analytics, delete PII

**Example**:
```sql
-- Instead of DELETE, anonymize
UPDATE users 
SET 
  email = CONCAT('deleted_user_', id, '@example.com'),
  name = 'Deleted User',
  phone = NULL,
  address = NULL,
  deleted_at = NOW()
WHERE id = 12345;
```

**Result**: Analytics still work (user count, signup trends), but PII gone

---

### Rule 3: Legal Hold Overrides Retention

**When**: Lawsuit, investigation, audit

**Action**: Stop deletion until legal hold lifted

**Example**:
```sql
-- Mark records under legal hold
UPDATE customers 
SET legal_hold = TRUE, legal_hold_reason = 'Lawsuit case #2024-001'
WHERE id = 12345;

-- Skip deletion for legal hold records
DELETE FROM customers 
WHERE deleted_at < NOW() - INTERVAL '30 days'
  AND legal_hold = FALSE;
```

---

## Deletion Methods

### Soft Delete (Reversible)

**Method**: Mark as deleted, don't actually delete

**When**: User requests deletion, but might change mind

**Example**:
```sql
UPDATE users 
SET deleted_at = NOW() 
WHERE id = 12345;

-- Query excludes soft-deleted
SELECT * FROM users WHERE deleted_at IS NULL;
```

**Auto-purge**: Hard delete after 30 days

---

### Hard Delete (Permanent)

**Method**: Actually delete from database

**When**: Retention period expired

**Example**:
```sql
DELETE FROM users WHERE deleted_at < NOW() - INTERVAL '30 days';
```

---

### Anonymization

**Method**: Replace PII with fake data

**When**: Need to keep record for analytics, but delete PII

**Example**:
```sql
UPDATE users 
SET 
  email = CONCAT('anon_', id, '@example.com'),
  name = 'Anonymous User',
  ip_address = NULL
WHERE last_login < NOW() - INTERVAL '7 years';
```

---

### Encryption Key Destruction

**Method**: Delete encryption key, making data unreadable

**When**: Fast deletion of large datasets

**Example**:
```
1. Data encrypted with key K1
2. To "delete": Destroy key K1
3. Data still exists but unreadable (crypto-shredding)
```

**Use case**: Delete millions of records quickly

---

## Automated Deletion

### Cron Job

```bash
#!/bin/bash
# /scripts/data-retention.sh

# Delete soft-deleted users after 30 days
psql -d production <<SQL
DELETE FROM users 
WHERE deleted_at < NOW() - INTERVAL '30 days'
  AND legal_hold = FALSE;
SQL

# Anonymize inactive users after 7 years
psql -d production <<SQL
UPDATE users 
SET 
  email = CONCAT('inactive_', id, '@example.com'),
  name = 'Inactive User',
  phone = NULL
WHERE last_login < NOW() - INTERVAL '7 years'
  AND anonymized = FALSE;
SQL

# Delete old logs
psql -d production <<SQL
DELETE FROM audit_log 
WHERE timestamp < NOW() - INTERVAL '1 year';
SQL

echo "Data retention job complete: $(date)"
```

**Schedule**: Daily at 3 AM

```cron
0 3 * * * /scripts/data-retention.sh
```

---

## User Rights (UU PDP No. 27/2022 & GDPR)

### Right to Erasure (Right to be Forgotten)

**Request**: User wants all their data deleted

**Process**:
1. Verify user identity (prevent malicious deletion)
2. Check for legal hold (cannot delete if under investigation)
3. Check for legal requirement (cannot delete tax records <7 years)
4. If OK, delete or anonymize data
5. Confirm deletion to user

**Timeline**: Within 30 days

---

### Right to Data Portability

**Request**: User wants to download all their data

**Response**: Provide JSON/CSV export

**Example**:
```json
{
  "user_id": "12345",
  "email": "john@example.com",
  "name": "John Doe",
  "created_at": "2020-01-15",
  "orders": [
    {"order_id": "ORD-001", "date": "2024-01-20", "total": "$50.00"}
  ],
  "support_tickets": [
    {"ticket_id": "TKT-001", "subject": "Refund request", "date": "2024-02-10"}
  ]
}
```

**Timeline**: Within 30 days

---

## Retention Policy Document

### Example Policy

**Effective Date**: 2024-01-01

**1. Purpose**

This policy defines how [Company Name] retains and deletes data to comply with legal requirements and protect user privacy.

---

**2. Scope**

Applies to all customer data, employee data, and business records.

---

**3. Retention Periods**

- Customer accounts: 7 years after deletion
- Financial records: 7 years
- Audit logs: 1 year
- Backups: 7/30/90/365 days depending on type

---

**4. Deletion Process**

- Automated daily job deletes expired data
- Manual deletion requests processed within 30 days
- Legal holds prevent deletion during investigations

---

**5. Exceptions**

- Legal hold: Deletion suspended
- Active litigation: Retain all related data
- Regulatory audit: Retain all relevant data

---

**6. Responsibilities**

- Data Protection Officer: Oversee retention policy
- Engineering: Implement automated deletion
- Legal: Define retention requirements

---

**7. Review**

Policy reviewed annually or when regulations change.

---

## Compliance Checklist

**GDPR**:
- [ ] Retention periods documented
- [ ] Automated deletion implemented
- [ ] User can request deletion (right to erasure)
- [ ] User can export data (right to portability)
- [ ] Deletion confirmed within 30 days

**HIPAA**:
- [ ] Health records retained 6 years
- [ ] Audit logs retained per policy
- [ ] Secure deletion method (overwrite, not just delete)

**PCI-DSS**:
- [ ] Never store full credit card numbers
- [ ] Cardholder data deleted when no longer needed
- [ ] Audit logs retained 1 year (3 months online, 9 archived)

**SOC 2**:
- [ ] Retention policy documented
- [ ] Automated deletion implemented
- [ ] Audit logs retained 1 year
- [ ] Annual policy review

---

## Checklist

**Setup**:
- [ ] Document retention periods per data type
- [ ] Implement soft delete (30-day grace period)
- [ ] Implement hard delete (automated cron job)
- [ ] Implement anonymization (for analytics)
- [ ] Set up legal hold process

**Ongoing**:
- [ ] Monthly: Review deletion logs
- [ ] Quarterly: Audit retention compliance
- [ ] Annually: Review and update policy
- [ ] Ad-hoc: Process user deletion requests

---

## Notes

**GDPR doesn't mean delete everything immediately**: Can keep data for legitimate business/legal needs

**Anonymized data ≠ deleted data**: Anonymization allows keeping analytics

**Test your deletion**: Verify data actually deleted, not just marked deleted

**Legal holds are critical**: Deleting evidence during lawsuit = sanctions
