# SOC 2 & ISO 27001 Compliance Checklist

> **Purpose**: Prepare for SOC 2 and ISO 27001 audits  
> **When**: M05 Architecture + ongoing compliance maintenance  
> **Target**: Enterprise SaaS projects requiring security certifications

---

## SOC 2 Overview

**What is SOC 2?**: Service Organization Control 2 - security, availability, and confidentiality audit for SaaS companies

**Why needed**: Enterprise customers require SOC 2 before signing contracts

**Types**:
- **SOC 2 Type I**: Controls documented and in place (snapshot)
- **SOC 2 Type II**: Controls operating effectively over time (6-12 months)

**Cost**: $20k-80k (depending on company size, auditor)

**Timeline**: 6-12 months preparation + 3 months audit

---

## SOC 2 Trust Service Criteria

### 1. Security (Required)

**CC6.1: Logical Access**
- [ ] Multi-factor authentication (MFA) enforced for all users
- [ ] Role-based access control (RBAC) implemented
- [ ] Password policy (min 12 characters, complexity requirements)
- [ ] Access reviews quarterly (remove inactive users)
- [ ] Privileged access logged (admin actions)

**CC6.6: Encryption**
- [ ] Data encrypted at rest (AES-256)
- [ ] Data encrypted in transit (TLS 1.3)
- [ ] Encryption keys managed securely (AWS KMS, Azure Key Vault)

**CC7.2: System Monitoring**
- [ ] Security monitoring (SIEM configured)
- [ ] Intrusion detection (IDS/IPS)
- [ ] Log aggregation (centralized logging)
- [ ] Alerting on suspicious activity

**CC8.1: Change Management**
- [ ] Change control process documented
- [ ] Code review required (2+ approvals)
- [ ] Testing before production (staging environment)
- [ ] Deployment approval (CAB process)

---

### 2. Availability (Optional but Common)

**A1.2: System Availability**
- [ ] Uptime SLA defined (e.g., 99.9%)
- [ ] Monitoring configured (Datadog, CloudWatch)
- [ ] Incident response plan documented
- [ ] Disaster recovery plan tested

**A1.3: System Capacity**
- [ ] Capacity planning process
- [ ] Load testing quarterly
- [ ] Auto-scaling configured
- [ ] Performance monitoring

---

### 3. Confidentiality (Optional)

**C1.1: Confidential Data**
- [ ] Data classification policy
- [ ] Confidential data encrypted
- [ ] Access to confidential data logged
- [ ] Confidential data deleted when no longer needed

---

## ISO 27001 Overview

**What is ISO 27001?**: International standard for Information Security Management System (ISMS)

**Why needed**: Global recognition, often required for EU/international customers

**Cost**: $30k-100k (certification + ongoing maintenance)

**Timeline**: 6-12 months preparation + 3-6 months audit

---

## ISO 27001 Controls (114 controls in Annex A)

### Critical Controls (Top 20)

**A.5 - Information Security Policies**
- [ ] Information security policy documented
- [ ] Policy reviewed annually
- [ ] Policy approved by management
- [ ] Policy communicated to all employees

**A.6 - Organization of Information Security**
- [ ] Security roles defined (CISO, Security team)
- [ ] Segregation of duties (dev cannot deploy to prod)
- [ ] Contact with authorities (know who to call for breach)

**A.8 - Asset Management**
- [ ] Asset inventory (servers, databases, applications)
- [ ] Asset classification (public, internal, confidential, restricted)
- [ ] Asset ownership assigned
- [ ] Asset handling procedures

**A.9 - Access Control**
- [ ] Access control policy documented
- [ ] User access review (quarterly)
- [ ] Password policy enforced
- [ ] MFA for privileged access

**A.10 - Cryptography**
- [ ] Cryptographic controls policy
- [ ] Encryption at rest (AES-256)
- [ ] Encryption in transit (TLS 1.3)
- [ ] Key management (rotation, secure storage)

**A.12 - Operations Security**
- [ ] Change management procedure
- [ ] Capacity management
- [ ] Malware protection (antivirus, EDR)
- [ ] Backup policy (daily, tested quarterly)
- [ ] Log management (retention 1 year)

**A.13 - Communications Security**
- [ ] Network segmentation (DMZ, internal, database)
- [ ] Firewall rules documented
- [ ] Network monitoring
- [ ] Secure protocols only (HTTPS, SSH, SFTP)

**A.14 - System Acquisition, Development and Maintenance**
- [ ] Secure development lifecycle (SDLC)
- [ ] Security in development (code review, SAST, DAST)
- [ ] Test data sanitized (no production data in dev/test)

**A.16 - Information Security Incident Management**
- [ ] Incident response plan documented
- [ ] Incident reporting procedure
- [ ] Incidents logged and tracked
- [ ] Post-incident review (lessons learned)

**A.17 - Business Continuity**
- [ ] Business continuity plan
- [ ] Disaster recovery plan
- [ ] Backup and restore tested quarterly
- [ ] RTO/RPO defined (e.g., 4 hours / 1 hour)

**A.18 - Compliance**
- [ ] Legal requirements identified (GDPR, HIPAA, etc.)
- [ ] Compliance reviews (annual)
- [ ] Data protection impact assessments (DPIA)
- [ ] Records retention policy

---

## Compliance Checklist by Category

### People & Organization

**Policies & Procedures**:
- [ ] Information security policy
- [ ] Acceptable use policy
- [ ] Data classification policy
- [ ] Access control policy
- [ ] Incident response plan
- [ ] Business continuity plan
- [ ] Disaster recovery plan
- [ ] Change management procedure
- [ ] Vendor management policy

**Training**:
- [ ] Security awareness training (annual, all employees)
- [ ] Phishing simulation (quarterly)
- [ ] Training records maintained

**HR**:
- [ ] Background checks for employees
- [ ] NDA signed by all employees
- [ ] Security responsibilities in job descriptions
- [ ] Offboarding procedure (revoke access immediately)

---

### Technology

**Access Control**:
- [ ] MFA enforced (email, admin panels, SSH)
- [ ] RBAC implemented (least privilege)
- [ ] Password policy (12+ chars, complexity, rotation)
- [ ] Access reviews (quarterly)
- [ ] Session timeout (30 min inactivity)

**Encryption**:
- [ ] At rest: AES-256 (database, S3, EBS)
- [ ] In transit: TLS 1.3 (API, website)
- [ ] Key management: AWS KMS or equivalent
- [ ] Sensitive data tokenized (credit cards)

**Monitoring & Logging**:
- [ ] Centralized logging (CloudWatch, Splunk)
- [ ] Security monitoring (SIEM)
- [ ] Audit logs immutable (cannot delete)
- [ ] Log retention: 1 year minimum
- [ ] Real-time alerting (failed logins, privilege escalation)

**Vulnerability Management**:
- [ ] Dependency scanning (Snyk, Dependabot)
- [ ] SAST (static analysis - SonarQube, Semgrep)
- [ ] DAST (dynamic analysis - OWASP ZAP)
- [ ] Penetration testing (annual)
- [ ] Vulnerability remediation (critical: 7 days, high: 30 days)

**Backup & Recovery**:
- [ ] Daily automated backups
- [ ] Backup encryption
- [ ] Backup testing (quarterly restore test)
- [ ] Offsite backup storage (different region)
- [ ] RTO ≤4 hours, RPO ≤1 hour

---

### Processes

**Change Management**:
- [ ] Change request process (RFC)
- [ ] Testing before production
- [ ] Approval before deployment (CAB)
- [ ] Rollback plan for all changes
- [ ] Post-deployment monitoring

**Incident Management**:
- [ ] Incident response team defined
- [ ] Incident severity levels (P0-P4)
- [ ] Incident response procedures
- [ ] Post-incident reviews (blameless)
- [ ] Incident metrics tracked

**Vendor Management**:
- [ ] Vendor risk assessment (before contract)
- [ ] Data Processing Agreements (DPA) signed
- [ ] Annual vendor security review
- [ ] Vendor access logged and monitored

---

## Evidence Collection

**SOC 2/ISO 27001 requires evidence** for every control:

### Policy Documents
- [ ] All policies documented (Word/PDF)
- [ ] All policies approved (signature, date)
- [ ] All policies published (intranet, Confluence)

### Access Control Evidence
- [ ] User access list (export from Okta, AWS IAM)
- [ ] Access review logs (quarterly reviews documented)
- [ ] MFA enforcement (screenshot of settings)
- [ ] Password policy (screenshot of settings)

### Monitoring Evidence
- [ ] Security alerts (sample alerts from last 6 months)
- [ ] Incident tickets (Jira tickets for security incidents)
- [ ] Vulnerability scan reports (monthly Snyk reports)

### Training Evidence
- [ ] Training completion records (LMS screenshots)
- [ ] Phishing simulation results (quarterly reports)
- [ ] Training materials (slides, videos)

### Backup Evidence
- [ ] Backup logs (successful backups for 6 months)
- [ ] Restore test results (quarterly test documentation)
- [ ] Backup monitoring alerts

### Change Management Evidence
- [ ] Change tickets (sample 10 changes from last 6 months)
- [ ] Code review approvals (GitHub PR approvals)
- [ ] Deployment logs (CI/CD pipeline logs)

---

## Audit Preparation Timeline

### 6 Months Before Audit

**Month 1-2: Gap Analysis**
- [ ] Compare current state vs requirements
- [ ] Identify missing controls
- [ ] Prioritize critical gaps

**Month 3-4: Implementation**
- [ ] Implement missing controls
- [ ] Document policies and procedures
- [ ] Configure monitoring and logging

**Month 5-6: Testing & Evidence**
- [ ] Test all controls (quarterly access review, backup restore)
- [ ] Collect evidence (screenshots, logs, tickets)
- [ ] Conduct internal audit (pre-audit)

### 3 Months During Audit

**Month 1: Opening Meeting**
- Auditor kickoff meeting
- Provide policy documents
- Schedule interviews

**Month 2: Testing**
- Auditor reviews evidence
- Auditor conducts interviews
- Respond to auditor questions

**Month 3: Closing**
- Auditor findings presented
- Remediate any issues
- Receive audit report

---

## Common Audit Findings (How to Avoid)

**Finding 1: Incomplete Access Reviews**
- ❌ Access review spreadsheet shows "last updated 8 months ago"
- ✅ Quarterly access reviews with signed approval

**Finding 2: No MFA on Admin Accounts**
- ❌ Admin can log in with password only
- ✅ MFA enforced for all privileged access

**Finding 3: Unpatched Vulnerabilities**
- ❌ Critical vulnerability open for 45 days
- ✅ SLA: Critical patched within 7 days (show evidence)

**Finding 4: No Backup Testing**
- ❌ "We have backups" but never tested restore
- ✅ Quarterly restore test with documentation

**Finding 5: Missing Audit Logs**
- ❌ Admin actions not logged
- ✅ All privileged actions logged (immutable logs)

---

## Compliance Tools

**GRC (Governance, Risk, Compliance) Platforms**:
- Vanta (automates SOC 2 compliance, $40k/year)
- Drata (SOC 2 automation, $30k/year)
- Secureframe (SOC 2 + ISO 27001, $25k/year)
- Tugboat Logic (manual but cheaper, $15k/year)

**Benefits**:
- Automate evidence collection (AWS logs, GitHub, etc.)
- Continuous monitoring (alerts when out of compliance)
- Pre-built policies and procedures
- Auditor collaboration portal

**Recommendation**: Use GRC platform (saves 100+ hours of manual work)

---

## Compliance Checklist

**Initial Setup**:
- [ ] Choose certification (SOC 2, ISO 27001, or both)
- [ ] Choose auditor (Big 4, specialized firms)
- [ ] Set timeline (6-12 months)
- [ ] Budget allocation ($50k-150k total)

**Ongoing Maintenance**:
- [ ] Quarterly access reviews
- [ ] Quarterly backup restore tests
- [ ] Annual security training
- [ ] Annual policy review
- [ ] Annual penetration test
- [ ] Continuous evidence collection

**Audit Preparation**:
- [ ] Collect 6 months of evidence
- [ ] Conduct internal pre-audit
- [ ] Fix any gaps found
- [ ] Prepare interview responses
- [ ] Organize evidence repository

---

## Cost Breakdown

**SOC 2 Type II** (Total: $40k-80k):
- Auditor fees: $20k-40k
- GRC platform: $30k-40k/year
- Penetration test: $15k-25k
- Consultant (optional): $10k-30k

**ISO 27001** (Total: $50k-100k):
- Auditor fees: $30k-60k
- Certification body: $5k-10k
- Gap analysis consultant: $15k-30k
- Implementation: Internal time (200-400 hours)

**Both** (Total: $70k-150k):
- Significant overlap, cheaper to do both together

---

## Checklist Template

```
SOC 2 / ISO 27001 COMPLIANCE CHECKLIST

POLICIES (All documented and approved):
[ ] Information security policy
[ ] Access control policy
[ ] Data classification policy
[ ] Incident response plan
[ ] Business continuity plan
[ ] Disaster recovery plan
[ ] Change management procedure
[ ] Vendor management policy

ACCESS CONTROL:
[ ] MFA enforced (all users)
[ ] RBAC implemented
[ ] Password policy (12+ chars)
[ ] Quarterly access reviews

ENCRYPTION:
[ ] At rest: AES-256
[ ] In transit: TLS 1.3
[ ] Key management: KMS

MONITORING:
[ ] Centralized logging
[ ] SIEM configured
[ ] Audit logs immutable
[ ] Real-time alerting

VULNERABILITY MANAGEMENT:
[ ] Dependency scanning (daily)
[ ] SAST/DAST (weekly)
[ ] Penetration test (annual)
[ ] Patch SLA (critical: 7 days)

BACKUP & DR:
[ ] Daily backups
[ ] Quarterly restore tests
[ ] RTO ≤4 hours, RPO ≤1 hour

TRAINING:
[ ] Annual security awareness
[ ] Quarterly phishing simulation

EVIDENCE COLLECTION:
[ ] 6 months of logs
[ ] Access review records
[ ] Training completion records
[ ] Incident tickets
[ ] Backup test results
```

---

## Notes

**SOC 2 is not a one-time effort**: Requires ongoing maintenance

**Automate evidence collection**: Use GRC platform to save time

**Start early**: 6-12 months preparation minimum

**Hire consultant**: If first audit, consultant saves time and headaches
