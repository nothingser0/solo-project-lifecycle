# Audit Trail Requirements Template

> **Purpose**: Define audit logging requirements for compliance  
> **When**: M05 Architecture (before implementing audit logs)  
> **Target**: Enterprise projects with SOC 2, ISO 27001, HIPAA, or PCI-DSS requirements

---

## What is an Audit Trail?

**Definition**: Chronological record of system activities to enable reconstruction and examination of sequence of events.

**Purpose**:
- Security monitoring (detect unauthorized access)
- Compliance (SOC 2, ISO 27001, HIPAA, PCI-DSS)
- Forensics (investigate incidents)
- Accountability (who did what, when)

---

## What to Log

### 1. Authentication Events

**Events**:
- User login (successful)
- User login (failed)
- Password reset
- Multi-factor authentication
- Session timeout
- User logout

**Log Fields**:
- Timestamp (UTC)
- User ID
- IP address
- User agent
- Action (login, logout, etc.)
- Result (success, failure)
- Failure reason (if failed)

**Example**:
```json
{
  "timestamp": "2024-10-04T12:30:45Z",
  "event_type": "authentication",
  "action": "login",
  "user_id": "user_12345",
  "username": "john.doe@example.com",
  "ip_address": "203.0.113.42",
  "user_agent": "Mozilla/5.0...",
  "result": "success",
  "session_id": "sess_abc123"
}
```

---

### 2. Authorization Events

**Events**:
- Access granted (user views resource)
- Access denied (insufficient permissions)
- Permission changes (role assigned/revoked)
- Privileged action (admin operation)

**Log Fields**:
- Timestamp
- User ID
- Resource accessed (table, record, file)
- Action attempted (read, write, delete)
- Result (granted, denied)
- Reason (if denied)

**Example**:
```json
{
  "timestamp": "2024-10-04T12:31:00Z",
  "event_type": "authorization",
  "action": "read",
  "user_id": "user_12345",
  "resource_type": "customer_record",
  "resource_id": "cust_98765",
  "result": "granted",
  "permissions": ["customer:read"]
}
```

---

### 3. Data Access (Sensitive Data)

**Events**:
- View PII (customer name, email, phone)
- View restricted data (SSN, credit card)
- Export data (CSV, PDF download)
- Search/query data

**Log Fields**:
- Timestamp
- User ID
- Data type (PII, PHI, payment card)
- Action (view, export, search)
- Record count
- Purpose (if provided)

**Example**:
```json
{
  "timestamp": "2024-10-04T12:32:00Z",
  "event_type": "data_access",
  "action": "view",
  "user_id": "admin_456",
  "data_type": "customer_ssn",
  "record_id": "cust_98765",
  "data_classification": "restricted",
  "purpose": "customer support ticket #12345"
}
```

---

### 4. Data Modifications

**Events**:
- Create record
- Update record
- Delete record
- Bulk operations

**Log Fields**:
- Timestamp
- User ID
- Record type
- Record ID
- Action (create, update, delete)
- Old value (for updates)
- New value (for updates)
- Change reason (if provided)

**Example**:
```json
{
  "timestamp": "2024-10-04T12:33:00Z",
  "event_type": "data_modification",
  "action": "update",
  "user_id": "user_12345",
  "record_type": "customer",
  "record_id": "cust_98765",
  "field_changed": "email",
  "old_value": "old@example.com",
  "new_value": "new@example.com",
  "reason": "User requested email change"
}
```

---

### 5. System Configuration Changes

**Events**:
- User role created/modified
- Permission policy changed
- System settings changed
- Feature flags toggled
- API keys created/revoked

**Log Fields**:
- Timestamp
- Admin user ID
- Configuration type
- Old value
- New value
- Reason

**Example**:
```json
{
  "timestamp": "2024-10-04T12:34:00Z",
  "event_type": "configuration_change",
  "action": "update",
  "admin_id": "admin_456",
  "config_type": "user_role",
  "role_name": "customer_support",
  "permission_added": "view_customer_ssn",
  "reason": "Support escalation process"
}
```

---

### 6. Security Events

**Events**:
- Failed login attempts (>5)
- Account lockout
- Password change
- API rate limit exceeded
- Suspicious activity detected

**Example**:
```json
{
  "timestamp": "2024-10-04T12:35:00Z",
  "event_type": "security",
  "action": "account_lockout",
  "user_id": "user_12345",
  "ip_address": "203.0.113.42",
  "reason": "5 failed login attempts in 5 minutes",
  "lockout_duration": "15 minutes"
}
```

---

## What NOT to Log

**Never Log**:
- ❌ Passwords (even hashed)
- ❌ Credit card numbers (full PAN)
- ❌ Social security numbers (full SSN)
- ❌ API keys or tokens
- ❌ Encryption keys

**Why**: Logs may be stored less securely than production data

**Instead**:
- Log "password changed" (not the password value)
- Log "payment processed" with last 4 digits only
- Log "API key revoked" (not the key value)

---

## Audit Log Requirements

### 1. Immutability

**Requirement**: Logs cannot be modified or deleted

**Implementation**:
- Write-only log storage
- Separate log database (not application DB)
- Append-only log files

**Verification**:
```sql
-- PostgreSQL: Revoke UPDATE/DELETE on audit table
REVOKE UPDATE, DELETE ON audit_log FROM app_user;
GRANT INSERT, SELECT ON audit_log TO app_user;
```

---

### 2. Integrity

**Requirement**: Detect if logs are tampered with

**Implementation**:
- Cryptographic hashing (SHA-256)
- Chain logs (each log references hash of previous)

**Example**:
```javascript
function logEvent(event) {
  const previousHash = getLastLogHash();
  const eventData = JSON.stringify(event);
  const currentHash = sha256(previousHash + eventData);
  
  saveLog({
    ...event,
    previous_hash: previousHash,
    current_hash: currentHash
  });
}
```

---

### 3. Completeness

**Requirement**: All security-relevant events logged

**Coverage**:
- 100% authentication events
- 100% authorization failures
- 100% sensitive data access
- 100% configuration changes

**Testing**:
- Quarterly audit log review
- Verify no gaps in timeline

---

### 4. Retention

**Requirement**: Logs retained per compliance needs

| Compliance | Retention Period |
|:-----------|:----------------|
| **SOC 2** | 1 year |
| **HIPAA** | 6 years |
| **PCI-DSS** | 1 year (3 months online, 9 months archive) |
| **GDPR** | As long as data processed + 1 year |

**Storage**:
- Hot storage (recent 3 months): Fast query
- Cold storage (older): Archived (S3 Glacier)

---

### 5. Access Control

**Requirement**: Only authorized users can view logs

**Access**:
- Security team: Full access
- Compliance team: Read-only
- Support team: No access to audit logs
- Regular users: No access

**Implementation**:
```sql
-- Grant audit log access to security team only
GRANT SELECT ON audit_log TO security_team;
```

---

### 6. Monitoring & Alerting

**Requirement**: Real-time alerting on suspicious activity

**Alerts**:
- 5+ failed logins from same IP in 5 minutes
- Admin user accesses PII outside business hours
- Bulk data export (>1000 records)
- Permission escalation (user gains admin role)

**Tool**: SIEM (Security Information and Event Management)
- Splunk
- Datadog Security Monitoring
- AWS CloudWatch Logs Insights

---

## Audit Log Schema

### Database Table: `audit_log`

```sql
CREATE TABLE audit_log (
  id BIGSERIAL PRIMARY KEY,
  timestamp TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  event_type VARCHAR(50) NOT NULL,
  action VARCHAR(50) NOT NULL,
  user_id VARCHAR(100),
  ip_address INET,
  user_agent TEXT,
  resource_type VARCHAR(100),
  resource_id VARCHAR(100),
  result VARCHAR(20),
  old_value JSONB,
  new_value JSONB,
  reason TEXT,
  session_id VARCHAR(100),
  request_id VARCHAR(100),
  previous_hash VARCHAR(64),
  current_hash VARCHAR(64) NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_audit_timestamp ON audit_log(timestamp);
CREATE INDEX idx_audit_user ON audit_log(user_id);
CREATE INDEX idx_audit_resource ON audit_log(resource_type, resource_id);
CREATE INDEX idx_audit_event_type ON audit_log(event_type);
```

---

## Implementation Example

### Application Code

```javascript
// Node.js + Express middleware
const auditLog = require('./audit-logger');

app.use(auditLog.middleware());

// Audit authentication
app.post('/api/login', async (req, res) => {
  const { email, password } = req.body;
  
  try {
    const user = await authenticate(email, password);
    
    await auditLog.log({
      event_type: 'authentication',
      action: 'login',
      user_id: user.id,
      ip_address: req.ip,
      result: 'success'
    });
    
    res.json({ token: user.token });
  } catch (error) {
    await auditLog.log({
      event_type: 'authentication',
      action: 'login',
      user_id: email,
      ip_address: req.ip,
      result: 'failure',
      reason: error.message
    });
    
    res.status(401).json({ error: 'Invalid credentials' });
  }
});

// Audit data access
app.get('/api/customers/:id', async (req, res) => {
  const customer = await Customer.findById(req.params.id);
  
  await auditLog.log({
    event_type: 'data_access',
    action: 'view',
    user_id: req.user.id,
    resource_type: 'customer',
    resource_id: req.params.id,
    data_classification: 'confidential'
  });
  
  res.json(customer);
});
```

---

## Audit Log Review

**Frequency**: Weekly (automated) + Quarterly (manual)

**Weekly Automated Review**:
- Failed login attempts >100/week
- Unauthorized access attempts
- Bulk data exports
- After-hours admin activity

**Quarterly Manual Review**:
- Sample 100 random log entries
- Verify legitimate activity
- Identify anomalies
- Update alert rules

---

## Compliance Checklist

**SOC 2**:
- [ ] All authentication events logged
- [ ] All authorization failures logged
- [ ] Logs retained 1 year
- [ ] Logs immutable (cannot modify/delete)
- [ ] Access restricted (security team only)
- [ ] Weekly log review

**HIPAA**:
- [ ] All PHI access logged
- [ ] Logs retained 6 years
- [ ] Integrity verification (hashing)
- [ ] Quarterly audit log review

**PCI-DSS**:
- [ ] All cardholder data access logged
- [ ] Logs retained 1 year
- [ ] Real-time alerting on suspicious activity
- [ ] Daily log review (automated)

---

## Notes

**Log everything security-relevant**: Better to over-log than under-log

**Never log secrets**: Passwords, keys, tokens

**Immutability is critical**: Attackers often delete logs to cover tracks

**Test your alerting**: Simulate attacks to verify alerts trigger
