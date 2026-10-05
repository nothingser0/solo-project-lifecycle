# Data Classification Policy Template

> **Purpose**: Classify and protect data based on sensitivity  
> **When**: M05 Architecture (before handling sensitive data)  
> **Target**: Enterprise projects with compliance requirements (GDPR, HIPAA, SOC 2)

---

## Data Classification Levels

### Level 1: Public
**Definition**: Data intended for public disclosure

**Examples**:
- Marketing materials
- Press releases
- Public website content
- Published documentation

**Protection**:
- No special protection required
- Can be shared freely

**Storage**: Public web servers, CDN

**Compliance**: None required

---

### Level 2: Internal
**Definition**: Data for internal use, not sensitive

**Examples**:
- Internal memos
- Meeting notes
- Non-confidential email
- Company announcements

**Protection**:
- Require authentication
- Not public-facing

**Storage**: Internal file servers, Confluence

**Compliance**: Basic access control

---

### Level 3: Confidential
**Definition**: Sensitive business data

**Examples**:
- Customer contracts
- Financial reports
- Business plans
- Employee records
- Source code

**Protection**:
- Encryption at rest
- Access control (role-based)
- Audit logging
- Need-to-know basis

**Storage**: Encrypted databases, S3 with encryption

**Compliance**: GDPR, SOC 2

**Incident**: Report to manager within 24 hours

---

### Level 4: Restricted (Highly Confidential)
**Definition**: Highly sensitive, regulated data

**Examples**:
- Credit card numbers (PCI-DSS)
- Social security numbers
- Health records (HIPAA)
- Authentication credentials
- Encryption keys
- Personal identifiable information (PII)

**Protection**:
- Encryption at rest (AES-256)
- Encryption in transit (TLS 1.3)
- Multi-factor authentication
- Audit logging (immutable)
- Data masking in non-production
- Access limited to authorized personnel

**Storage**: Encrypted databases, AWS KMS, Secrets Manager

**Compliance**: GDPR, PCI-DSS, HIPAA, SOC 2

**Incident**: Report to security team immediately, notify affected users within 72 hours (GDPR)

---

## Data Classification Matrix

| Data Type | Classification | Encryption | Access Control | Retention | Example |
|:----------|:--------------|:-----------|:--------------|:----------|:--------|
| **Marketing content** | Public | Optional | None | Indefinite | Blog posts |
| **Meeting notes** | Internal | Optional | Authenticated users | 1 year | Confluence docs |
| **Source code** | Confidential | At rest | Role-based (developers) | Indefinite | GitHub repos |
| **Customer email** | Confidential | At rest + transit | Role-based | 7 years | CRM database |
| **Credit card numbers** | Restricted | At rest + transit | PCI-compliant | Per PCI-DSS | Payment gateway |
| **Passwords** | Restricted | Hashed (bcrypt) | Owner only | Until changed | User table |
| **SSN** | Restricted | At rest + transit | HR only | 7 years | Employee records |
| **Health data** | Restricted | At rest + transit | Authorized medical only | Per HIPAA | Patient records |

---

## Data Handling Requirements

### Public Data

**Transmission**: Any method (HTTP, email, Slack)

**Storage**: Any location

**Disposal**: No special requirements

**Example**:
```
Marketing blog post can be:
- Sent via email
- Posted on public website
- Shared on social media
- No encryption needed
```

---

### Internal Data

**Transmission**: Encrypted channels (HTTPS, TLS email)

**Storage**: Internal servers (not public-facing)

**Disposal**: Standard deletion (not recoverable)

**Example**:
```
Internal memo should be:
- Stored on Confluence (requires login)
- Sent via company email (TLS)
- Not shared on public Slack channels
```

---

### Confidential Data

**Transmission**: Encrypted channels only (HTTPS, VPN, encrypted email)

**Storage**: Encrypted at rest (AES-256)

**Access Control**: Role-based, need-to-know

**Audit Logging**: All access logged

**Disposal**: Secure deletion (overwrite, cannot recover)

**Example**:
```
Customer contract should be:
- Stored in encrypted S3 bucket
- Accessed only by sales team (RBAC)
- Transmitted via encrypted email or DocuSign
- All views logged (who, when, what)
- Deleted securely when retention period expires
```

---

### Restricted Data

**Transmission**: Encrypted channels + additional controls (tokenization, data masking)

**Storage**: 
- Encrypted at rest (AES-256)
- Encrypted in transit (TLS 1.3)
- Tokenization (replace sensitive data with tokens)

**Access Control**: 
- Multi-factor authentication required
- Minimum privilege principle
- Time-limited access

**Audit Logging**: 
- Immutable logs (cannot be deleted/modified)
- Real-time alerting for access
- Quarterly access reviews

**Disposal**: 
- Secure deletion (overwrite multiple times)
- Certificate of destruction

**Example - Credit Card Number**:
```
Credit card should be:
- Never stored in plain text
- Tokenized (Stripe token replaces actual number)
- PCI-DSS compliant storage (if must store)
- Transmitted only via PCI-compliant channels
- Masked in UI (show last 4 digits only)
- Access logged and alerted
```

**Example - Password**:
```
Password should be:
- Hashed with bcrypt (not encrypted, not plain text)
- Salt unique per user
- Never logged (even in error logs)
- Never transmitted in URL
- Reset via secure token (expires in 1 hour)
```

---

## Data at Rest (Storage)

### Public & Internal
**Encryption**: Optional

**Example**:
```
# S3 bucket for public website
aws s3 mb s3://company-website-public
# No encryption needed
```

---

### Confidential
**Encryption**: AES-256 at rest

**Example**:
```
# S3 bucket with default encryption
aws s3api put-bucket-encryption \
  --bucket company-confidential \
  --server-side-encryption-configuration '{
    "Rules": [{
      "ApplyServerSideEncryptionByDefault": {
        "SSEAlgorithm": "AES256"
      }
    }]
  }'
```

---

### Restricted
**Encryption**: AES-256 at rest + Key Management Service (KMS)

**Example**:
```
# S3 bucket with KMS encryption
aws s3api put-bucket-encryption \
  --bucket company-restricted \
  --server-side-encryption-configuration '{
    "Rules": [{
      "ApplyServerSideEncryptionByDefault": {
        "SSEAlgorithm": "aws:kms",
        "KMSMasterKeyID": "arn:aws:kms:us-east-1:123456789:key/abc123"
      }
    }]
  }'
```

**Database**:
```sql
-- PostgreSQL: Encrypt column
CREATE EXTENSION pgcrypto;

-- Store encrypted SSN
INSERT INTO employees (ssn_encrypted)
VALUES (pgp_sym_encrypt('123-45-6789', 'encryption-key'));

-- Retrieve decrypted SSN (only authorized users)
SELECT pgp_sym_decrypt(ssn_encrypted, 'encryption-key') FROM employees;
```

---

## Data in Transit (Transmission)

### Public & Internal
**Encryption**: HTTPS (TLS 1.2+)

---

### Confidential & Restricted
**Encryption**: TLS 1.3

**Example**:
```nginx
# Nginx: Force TLS 1.3
server {
  listen 443 ssl;
  ssl_protocols TLSv1.3;
  ssl_ciphers HIGH:!aNULL:!MD5;
}
```

---

## Data Masking (Non-Production)

**Problem**: Dev/staging environments should not contain real sensitive data

**Solution**: Mask or anonymize restricted data

**Example - Credit Card Masking**:
```javascript
// Production: Real credit card
const creditCard = "4532123456789012";

// Dev/Staging: Masked
const creditCard = "4532********9012";
```

**Example - Email Masking**:
```javascript
// Production
const email = "john.doe@example.com";

// Dev/Staging
const email = "user123@example.com"; // Anonymized
```

**Example - Database Masking**:
```sql
-- Production database backup → Staging
UPDATE users SET email = CONCAT('user', id, '@example.com');
UPDATE users SET phone = '555-0100';
UPDATE users SET ssn = NULL;
```

---

## Data Retention

| Data Type | Retention Period | Rationale |
|:----------|:----------------|:----------|
| **Customer data** | 7 years | Legal requirement (tax) |
| **Financial records** | 7 years | Legal requirement |
| **Audit logs** | 1 year | Security/compliance |
| **Backups** | 30 days | Recovery window |
| **Credit card data** | Not stored | PCI-DSS (use tokens) |
| **Session tokens** | 24 hours | Security |
| **Password reset tokens** | 1 hour | Security |

**Deletion**:
- Automatic deletion after retention period
- User can request deletion (GDPR right to erasure)

---

## Access Control

### Role-Based Access Control (RBAC)

| Role | Public | Internal | Confidential | Restricted |
|:-----|:-------|:---------|:-------------|:-----------|
| **Public** | ✅ Read | ❌ | ❌ | ❌ |
| **Employee** | ✅ Read | ✅ Read | ❌ | ❌ |
| **Developer** | ✅ Read | ✅ Read | ✅ Read (code) | ❌ |
| **Manager** | ✅ Read | ✅ Read/Write | ✅ Read | ❌ |
| **Admin** | ✅ Full | ✅ Full | ✅ Full | ✅ Read (limited) |
| **Security Team** | ✅ Full | ✅ Full | ✅ Full | ✅ Full |

---

## Data Breach Response

### Detection
- Automated alerts (unauthorized access)
- User reports
- Security audits

---

### Response (Restricted Data Breach)

**Immediate (0-4 hours)**:
1. Contain breach (disable compromised accounts)
2. Assess scope (how many records affected)
3. Notify security team

**Short-term (4-72 hours)**:
1. Investigate root cause
2. Notify supervisory authority (GDPR: 72 hours)
3. Notify affected users (if high risk)
4. Implement fixes

**Long-term (72+ hours)**:
1. Post-mortem
2. Update security policies
3. Additional monitoring

---

## Compliance Mapping

### GDPR (EU Users)
- Personal data = Confidential or Restricted
- Encryption required (at rest + transit)
- Breach notification: 72 hours
- Right to erasure: Delete on request

---

### PCI-DSS (Credit Cards)
- Credit card numbers = Restricted
- Never store CVV
- Tokenization required
- Quarterly scans
- Annual audit

---

### HIPAA (Healthcare)
- Health data = Restricted
- Encryption required
- Audit logging
- Business Associate Agreement (BAA) with vendors

---

### SOC 2 (SaaS)
- Customer data = Confidential minimum
- Access controls
- Audit logging
- Encryption
- Annual audit

---

## Checklist

**Before Project Starts**:
- [ ] Identify data types collected
- [ ] Classify each data type (Public, Internal, Confidential, Restricted)
- [ ] Define retention periods
- [ ] Document access controls (RBAC)

**During Development**:
- [ ] Encrypt Restricted data at rest (AES-256)
- [ ] Encrypt Confidential+ data in transit (TLS 1.3)
- [ ] Implement audit logging for Restricted data
- [ ] Mask sensitive data in dev/staging
- [ ] Never log Restricted data (passwords, credit cards)

**Before Launch**:
- [ ] Security review (penetration test)
- [ ] Privacy policy updated
- [ ] Data classification documented
- [ ] Team trained on data handling

**Ongoing**:
- [ ] Quarterly access reviews
- [ ] Annual security audit
- [ ] Update classification as data types change

---

## Notes

**When in doubt, classify higher**: Better to over-protect than under-protect

**Never downgrade classification**: Once Restricted, always Restricted

**Train all team members**: Everyone must understand data classification

**Document exceptions**: If storing Restricted data, document why and how it's protected
