# Ongoing Compliance Monitoring & Automation

> **Purpose**: Automated compliance monitoring for GDPR, UU PDP No. 27/2022, and data protection regulations. Post-launch continuous compliance (M13).

---

## 1. Compliance Requirements by Region

| Regulation | Region | Key Requirements | Penalties |
|------------|--------|------------------|-----------|
| **UU PDP No. 27/2022** | Indonesia | Consent, data minimization, breach notification (3×24h), data deletion | Denda max Rp 6M atau 2% revenue |
| **GDPR** | EU | Consent, right to erasure, data portability, DPO (if >5K users) | €20M atau 4% revenue |
| **CCPA** | California | Right to know, delete, opt-out of sale | $2,500 per violation |
| **PIPEDA** | Canada | Consent, breach notification (ASAP), access requests | CAD $100K fine |

---

## 2. Automated Compliance Checks (M13 Ongoing)

### User Consent Tracking

**Problem**: Prove valid consent for data processing

**Solution**: Consent log table

```sql
CREATE TABLE consent_logs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id),
  consent_type VARCHAR(50) NOT NULL, -- 'marketing', 'analytics', 'data_processing'
  granted BOOLEAN NOT NULL,
  ip_address INET,
  user_agent TEXT,
  consent_version VARCHAR(10) NOT NULL, -- Track policy version
  timestamp TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_consent_user ON consent_logs(user_id, consent_type);
```

**Capture consent**:
```typescript
// app/api/consent/route.ts
export async function POST(request: Request) {
  const { userId, consentType, granted } = await request.json();
  
  await prisma.consentLog.create({
    data: {
      userId,
      consentType,
      granted,
      ipAddress: request.headers.get('x-forwarded-for'),
      userAgent: request.headers.get('user-agent'),
      consentVersion: '2024.10', // Update when policy changes
      timestamp: new Date(),
    },
  });
  
  return Response.json({ success: true });
}
```

**Automated check**:
```typescript
// Cron job: Daily consent audit
async function auditConsentCompliance() {
  // Find users with active data but no consent
  const usersWithoutConsent = await prisma.$queryRaw`
    SELECT u.id, u.email, u.created_at
    FROM users u
    WHERE NOT EXISTS (
      SELECT 1 FROM consent_logs c
      WHERE c.user_id = u.id 
        AND c.consent_type = 'data_processing'
        AND c.granted = true
    )
    AND u.created_at > '2024-10-26' -- UU PDP enforcement date
  `;
  
  if (usersWithoutConsent.length > 0) {
    await sendSlackAlert({
      channel: '#compliance',
      message: `⚠️ ${usersWithoutConsent.length} users without valid consent`,
    });
  }
}
```

---

### Data Retention Policy Enforcement

**UU PDP Pasal 14**: Data hanya boleh disimpan selama diperlukan

**Automated deletion**:
```typescript
// Cron job: Weekly data cleanup
async function enforceRetentionPolicy() {
  const now = new Date();
  
  // Delete inactive user data after 2 years
  const deletedUsers = await prisma.user.deleteMany({
    where: {
      lastLoginAt: { lt: new Date(now.getTime() - 2 * 365 * 24 * 60 * 60 * 1000) },
      deletionRequestedAt: null, // Not already requested
    },
  });
  
  // Delete audit logs older than 7 years (legal requirement)
  await prisma.auditLog.deleteMany({
    where: {
      createdAt: { lt: new Date(now.getTime() - 7 * 365 * 24 * 60 * 60 * 1000) },
    },
  });
  
  // Anonymize old order data (keep aggregate stats)
  await prisma.$executeRaw`
    UPDATE orders
    SET user_id = NULL, 
        shipping_address = 'REDACTED',
        email = 'deleted@example.com'
    WHERE created_at < NOW() - INTERVAL '3 years'
      AND user_id IS NOT NULL
  `;
  
  console.log(`Retention policy: Deleted ${deletedUsers.count} inactive users`);
}
```

---

### Right to Erasure (GDPR Art. 17 / UU PDP Pasal 35)

**User-initiated deletion**:
```typescript
// app/api/users/me/delete/route.ts
export async function POST(request: Request) {
  const userId = await getUserIdFromSession(request);
  
  // Step 1: Mark for deletion (grace period)
  await prisma.user.update({
    where: { id: userId },
    data: {
      deletionRequestedAt: new Date(),
      deletionScheduledAt: new Date(Date.now() + 30 * 24 * 60 * 60 * 1000), // 30 days
    },
  });
  
  // Step 2: Send confirmation email
  await sendEmail({
    to: user.email,
    subject: 'Data Deletion Request Confirmed',
    body: 'Your data will be deleted in 30 days. Log in to cancel.',
  });
  
  return Response.json({ 
    message: 'Deletion scheduled for 30 days from now',
    cancelable: true,
  });
}
```

**Automated execution**:
```typescript
// Cron job: Daily deletion queue processing
async function processDeletionQueue() {
  const usersToDelete = await prisma.user.findMany({
    where: {
      deletionScheduledAt: { lt: new Date() },
      deletionExecutedAt: null,
    },
  });
  
  for (const user of usersToDelete) {
    await deleteUserDataCompletely(user.id);
    
    // Create deletion audit log (required for compliance)
    await prisma.deletionLog.create({
      data: {
        userId: user.id,
        email: user.email, // Keep email for legal proof
        requestedAt: user.deletionRequestedAt,
        executedAt: new Date(),
        reason: 'user_request',
      },
    });
  }
  
  console.log(`Processed ${usersToDelete.length} deletion requests`);
}

async function deleteUserDataCompletely(userId: string) {
  // Transaction ensures atomic deletion
  await prisma.$transaction([
    prisma.order.deleteMany({ where: { userId } }),
    prisma.payment.deleteMany({ where: { userId } }),
    prisma.address.deleteMany({ where: { userId } }),
    prisma.notification.deleteMany({ where: { userId } }),
    prisma.session.deleteMany({ where: { userId } }),
    prisma.consentLog.deleteMany({ where: { userId } }),
    prisma.user.update({
      where: { id: userId },
      data: {
        email: `deleted-${userId}@example.com`,
        name: 'DELETED',
        phone: null,
        deletionExecutedAt: new Date(),
      },
    }),
  ]);
  
  // Delete files from storage
  await deleteUserFiles(userId);
}
```

---

### Data Breach Detection & Notification

**UU PDP Pasal 59**: Wajib lapor ke Menkominfo dalam 3×24 jam

**Automated anomaly detection**:
```typescript
// Cron job: Hourly security audit
async function detectSecurityAnomalies() {
  const now = new Date();
  const oneHourAgo = new Date(now.getTime() - 60 * 60 * 1000);
  
  // Anomaly 1: Excessive failed logins (possible credential stuffing)
  const failedLogins = await prisma.loginAttempt.count({
    where: {
      success: false,
      timestamp: { gte: oneHourAgo },
    },
  });
  
  if (failedLogins > 1000) {
    await triggerBreachProtocol({
      type: 'credential_stuffing_attack',
      severity: 'high',
      affectedUsers: failedLogins,
    });
  }
  
  // Anomaly 2: Mass data export (possible breach)
  const exports = await prisma.dataExport.count({
    where: {
      createdAt: { gte: oneHourAgo },
    },
  });
  
  if (exports > 100) {
    await triggerBreachProtocol({
      type: 'mass_data_export',
      severity: 'critical',
      affectedUsers: exports,
    });
  }
  
  // Anomaly 3: Unauthorized database access (check audit logs)
  const suspiciousQueries = await prisma.$queryRaw`
    SELECT COUNT(*) FROM audit_logs
    WHERE action = 'SELECT' 
      AND table_name = 'users'
      AND timestamp > NOW() - INTERVAL '1 hour'
      AND user_id NOT IN (SELECT id FROM admins)
  `;
  
  if (suspiciousQueries[0].count > 50) {
    await triggerBreachProtocol({
      type: 'unauthorized_data_access',
      severity: 'critical',
    });
  }
}

async function triggerBreachProtocol(breach: Breach) {
  // 1. Immediate alerts
  await sendSlackAlert({
    channel: '#security-incidents',
    message: `🚨 BREACH DETECTED: ${breach.type} (${breach.severity})`,
  });
  
  await sendEmail({
    to: 'legal@company.com',
    subject: `URGENT: Potential Data Breach - ${breach.type}`,
    body: `Severity: ${breach.severity}\nAffected users: ${breach.affectedUsers}`,
  });
  
  // 2. Lock down (if critical)
  if (breach.severity === 'critical') {
    await enableMaintenanceMode();
    await revokeAllSessions();
  }
  
  // 3. Create incident report
  await prisma.securityIncident.create({
    data: {
      type: breach.type,
      severity: breach.severity,
      detectedAt: new Date(),
      status: 'investigating',
    },
  });
  
  // 4. Start breach notification timer (3×24h for UU PDP)
  await scheduleBreachNotification(breach);
}
```

---

## 3. Data Subject Access Requests (DSAR)

**GDPR Art. 15 / UU PDP Pasal 33**: User berhak minta salinan data mereka

**Automated export**:
```typescript
// app/api/users/me/export/route.ts
export async function POST(request: Request) {
  const userId = await getUserIdFromSession(request);
  
  // Collect all user data
  const userData = await prisma.user.findUnique({
    where: { id: userId },
    include: {
      orders: true,
      payments: true,
      addresses: true,
      consentLogs: true,
      loginHistory: true,
    },
  });
  
  // Generate JSON export
  const exportData = {
    personal_info: {
      email: userData.email,
      name: userData.name,
      phone: userData.phone,
      created_at: userData.createdAt,
    },
    orders: userData.orders.map(order => ({
      id: order.id,
      total: order.total,
      status: order.status,
      created_at: order.createdAt,
    })),
    consent_history: userData.consentLogs,
    login_history: userData.loginHistory,
  };
  
  // Store export temporarily (24-hour expiry)
  const exportId = generateSecureToken();
  await redis.set(
    `export:${exportId}`,
    JSON.stringify(exportData),
    'EX',
    24 * 60 * 60,
  );
  
  // Send download link via email (not in response for security)
  await sendEmail({
    to: userData.email,
    subject: 'Your Data Export is Ready',
    body: `Download: ${process.env.APP_URL}/exports/${exportId}\n\nExpires in 24 hours.`,
  });
  
  // Log DSAR for compliance audit trail
  await prisma.dsarLog.create({
    data: {
      userId,
      requestType: 'export',
      requestedAt: new Date(),
      fulfilledAt: new Date(),
    },
  });
  
  return Response.json({ message: 'Export link sent to your email' });
}
```

---

## 4. Cookie Consent Management

**GDPR/UU PDP**: Wajib consent sebelum set cookies non-essential

**Frontend implementation**:
```typescript
// components/CookieConsent.tsx
'use client';
import { useState, useEffect } from 'react';

export function CookieConsent() {
  const [show, setShow] = useState(false);
  
  useEffect(() => {
    const consent = localStorage.getItem('cookie_consent');
    if (!consent) setShow(true);
  }, []);
  
  async function handleAccept(type: 'all' | 'essential') {
    await fetch('/api/consent', {
      method: 'POST',
      body: JSON.stringify({
        consentType: 'cookies',
        granted: type === 'all',
        categories: {
          essential: true,
          analytics: type === 'all',
          marketing: type === 'all',
        },
      }),
    });
    
    localStorage.setItem('cookie_consent', type);
    
    // Load analytics only if consented
    if (type === 'all') {
      loadGoogleAnalytics();
      loadMixpanel();
    }
    
    setShow(false);
  }
  
  if (!show) return null;
  
  return (
    <div className="fixed bottom-0 inset-x-0 bg-zinc-900 text-white p-4">
      <p>We use cookies to improve your experience.</p>
      <div className="flex gap-2 mt-2">
        <button onClick={() => handleAccept('essential')}>
          Essential Only
        </button>
        <button onClick={() => handleAccept('all')}>
          Accept All
        </button>
      </div>
    </div>
  );
}
```

---

## 5. Compliance Dashboard (M13 Ongoing)

**Automated weekly compliance report**:
```typescript
// Cron job: Weekly compliance summary
async function generateComplianceReport() {
  const report = {
    period: 'Last 7 days',
    metrics: {
      dsar_requests: await prisma.dsarLog.count({
        where: { requestedAt: { gte: sevenDaysAgo } },
      }),
      deletion_requests: await prisma.user.count({
        where: { deletionRequestedAt: { gte: sevenDaysAgo } },
      }),
      consent_violations: await findUsersWithoutConsent(),
      retention_policy_executed: await prisma.deletionLog.count({
        where: { executedAt: { gte: sevenDaysAgo } },
      }),
      security_incidents: await prisma.securityIncident.count({
        where: { detectedAt: { gte: sevenDaysAgo } },
      }),
    },
    compliance_score: calculateComplianceScore(),
  };
  
  await sendEmail({
    to: 'compliance@company.com',
    subject: 'Weekly Compliance Report',
    body: JSON.stringify(report, null, 2),
  });
}

function calculateComplianceScore(): number {
  // Scorecard (0-100)
  let score = 100;
  
  // Deduct points for violations
  if (usersWithoutConsent > 0) score -= 20;
  if (overdueDeletions > 0) score -= 15;
  if (unansweredDSARs > 0) score -= 25;
  if (securityIncidents > 0) score -= 30;
  
  return Math.max(score, 0);
}
```

---

## 6. Cron Job Schedule (M13 Integration)

**Add to crontab or serverless scheduler**:

```yaml
# cron.yaml (Google Cloud Scheduler / AWS EventBridge)
- name: compliance-consent-audit
  schedule: "0 9 * * *" # Daily 9 AM
  handler: /api/cron/compliance/consent-audit
  
- name: compliance-retention-policy
  schedule: "0 3 * * 0" # Weekly Sunday 3 AM
  handler: /api/cron/compliance/retention-policy
  
- name: compliance-deletion-queue
  schedule: "0 4 * * *" # Daily 4 AM
  handler: /api/cron/compliance/deletion-queue
  
- name: compliance-security-audit
  schedule: "0 * * * *" # Hourly
  handler: /api/cron/compliance/security-audit
  
- name: compliance-weekly-report
  schedule: "0 10 * * 1" # Monday 10 AM
  handler: /api/cron/compliance/weekly-report
```

---

## 7. Compliance Checklist (M13 Post-Launch)

### Initial Setup (Week 1)
- [ ] Consent tracking table created
- [ ] Cookie consent banner deployed
- [ ] DSAR export endpoint tested
- [ ] Deletion request flow tested
- [ ] Retention policy configured
- [ ] Breach detection alerts configured

### Monthly Audit
- [ ] Review consent logs (100% coverage)
- [ ] Check retention policy execution
- [ ] Process pending DSAR requests (<30 days)
- [ ] Process pending deletions (<30 days grace period)
- [ ] Review security incident logs
- [ ] Update privacy policy (if changes)

### Quarterly Review
- [ ] Full compliance audit (external if >10K users)
- [ ] Update consent management (new regulations)
- [ ] Test breach notification protocol
- [ ] Train team on GDPR/UU PDP updates
- [ ] Review third-party processor agreements (DPA)

---

## 8. Third-Party Processor Management

**GDPR Art. 28 / UU PDP Pasal 21**: Data Processor Agreement (DPA) wajib

**Vendor compliance checklist**:

| Vendor | Service | DPA Signed? | Data Location | Last Audit |
|--------|---------|-------------|---------------|------------|
| AWS | Hosting | ✅ Yes | Singapore (ap-southeast-1) | 2026-10 |
| Supabase | Database | ✅ Yes | AWS Singapore | 2026-09 |
| Sentry | Monitoring | ✅ Yes | EU (de-1) | 2026-08 |
| Stripe | Payments | ✅ Yes | Global (PCI-DSS) | 2026-10 |
| SendGrid | Email | ✅ Yes | US (BAA available) | 2026-07 |

**Automated DPA expiry alert**:
```typescript
// Track DPA renewals
const dpaExpirations = [
  { vendor: 'AWS', expiresAt: '2027-10-01' },
  { vendor: 'Supabase', expiresAt: '2027-09-15' },
];

// Cron: Monthly DPA expiry check
async function checkDPAExpirations() {
  const sixtyDaysFromNow = new Date(Date.now() + 60 * 24 * 60 * 60 * 1000);
  
  for (const dpa of dpaExpirations) {
    if (new Date(dpa.expiresAt) < sixtyDaysFromNow) {
      await sendSlackAlert({
        channel: '#legal',
        message: `⚠️ DPA with ${dpa.vendor} expires in <60 days. Renew now.`,
      });
    }
  }
}
```

---

**Created**: 2026-10-02  
**Version**: 1.0  
**Integration**: Add to M13 ongoing operations, M06B analytics setup
