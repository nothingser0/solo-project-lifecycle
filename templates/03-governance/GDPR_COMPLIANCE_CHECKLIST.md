# GDPR Compliance Checklist

> **Purpose**: Ensure GDPR compliance for Enterprise systems handling EU user data  
> **When**: M05 Architecture + M07 Security audit  
> **Target**: Enterprise projects with EU users or GDPR requirements

---

## GDPR Overview

**GDPR** = General Data Protection Regulation (EU law, effective May 2018)

**Applies to**:
- Companies processing EU residents' personal data
- Companies offering services to EU residents
- Regardless of company location (global reach)

**Penalties**:
- Up to €20M or 4% of global annual revenue (whichever is higher)
- Per violation

---

## Personal Data Categories

### Regular Personal Data
- Name, email, phone, address
- IP address, device ID, cookies
- Location data, photos
- Social media profiles

### Special Category Data (Extra Protections)
- Racial/ethnic origin
- Political opinions
- Religious beliefs
- Health data
- Sexual orientation
- Biometric data (fingerprints, facial recognition)
- Genetic data

**Special data requires**: Explicit consent + extra security

---

## GDPR Principles (Article 5)

1. **Lawfulness, Fairness, Transparency**
   - [ ] Legal basis for processing (consent, contract, legal obligation)
   - [ ] Privacy policy clearly explains data use
   - [ ] No hidden data collection

2. **Purpose Limitation**
   - [ ] Data collected for specific purpose only
   - [ ] No repurposing without consent

3. **Data Minimization**
   - [ ] Collect only necessary data
   - [ ] Don't collect "just in case"

4. **Accuracy**
   - [ ] Data kept up-to-date
   - [ ] Users can correct inaccurate data

5. **Storage Limitation**
   - [ ] Data deleted when no longer needed
   - [ ] Retention policy documented

6. **Integrity & Confidentiality**
   - [ ] Data encrypted at rest and in transit
   - [ ] Access controls enforced

7. **Accountability**
   - [ ] Demonstrate compliance (documentation)
   - [ ] Data Protection Impact Assessment (DPIA) for high-risk processing

---

## GDPR Implementation Checklist

### 1. Legal Basis for Processing

**Choose one legal basis per processing activity**:

- [ ] **Consent**: User explicitly agrees (checkbox, not pre-ticked)
  - Example: Marketing emails
  - Must be: Freely given, specific, informed, unambiguous
  - Withdrawable at any time (easy unsubscribe)

- [ ] **Contract**: Necessary to fulfill contract
  - Example: Shipping address for e-commerce order
  
- [ ] **Legal Obligation**: Required by law
  - Example: Tax records retention
  
- [ ] **Vital Interests**: Life-or-death situation
  - Example: Medical emergency data sharing
  
- [ ] **Public Task**: Official authority task
  - Example: Government services
  
- [ ] **Legitimate Interest**: Business need (not overriding user rights)
  - Example: Fraud detection, network security

**Document**: Create "Legal Basis Register" mapping each data type to legal basis

---

### 2. Privacy Policy

**Required Content**:
- [ ] Identity of data controller (company name, contact)
- [ ] Data Protection Officer contact (if applicable)
- [ ] Types of data collected
- [ ] Purpose of data collection
- [ ] Legal basis for processing
- [ ] Data recipients (who we share with)
- [ ] Data retention period
- [ ] User rights (access, deletion, portability, etc.)
- [ ] Right to lodge complaint with supervisory authority
- [ ] Whether data transferred outside EU (safeguards)
- [ ] Automated decision-making/profiling (if any)

**Requirements**:
- [ ] Written in plain language (no legal jargon)
- [ ] Easily accessible (link in footer, during signup)
- [ ] Version history maintained
- [ ] Notify users of material changes

**Template URL**: [Link to privacy policy generator]

---

### 3. User Rights Implementation

#### Right to Access (Article 15)
- [ ] User can download all their personal data
- [ ] Format: JSON, CSV, or PDF
- [ ] Response time: Within 1 month
- [ ] Free of charge (first request)

**Implementation**:
```typescript
// API endpoint: GET /api/user/data-export
// Returns: ZIP file with all user data
```

---

#### Right to Rectification (Article 16)
- [ ] User can update inaccurate data
- [ ] Changes applied within 1 month

**Implementation**: Standard account settings page

---

#### Right to Erasure / "Right to be Forgotten" (Article 17)
- [ ] User can delete their account
- [ ] All personal data deleted within 30 days
- [ ] Exceptions: Legal obligation, legal claims

**Implementation**:
```typescript
// API endpoint: DELETE /api/user/account
// Anonymizes or deletes all user records
```

**Considerations**:
- Soft delete vs hard delete
- Retain anonymized analytics data (no personal identifiers)
- Backups: Delete from backups within 90 days

---

#### Right to Data Portability (Article 20)
- [ ] User can export data in machine-readable format
- [ ] Can transfer to another service

**Format**: JSON (structured, machine-readable)

---

#### Right to Object (Article 21)
- [ ] User can object to processing (e.g., marketing)
- [ ] Easy opt-out mechanism

**Implementation**: Unsubscribe link in every marketing email

---

#### Right to Restrict Processing (Article 18)
- [ ] User can request temporary processing stop
- [ ] Data stored but not used

---

### 4. Consent Management

**Consent Requirements**:
- [ ] Affirmative action (click checkbox, not pre-ticked)
- [ ] Separate consent for different purposes
  - ❌ "I agree to Terms and Privacy Policy" (bundled)
  - ✅ "I agree to receive marketing emails" (separate)
- [ ] Easy to withdraw (as easy as giving consent)
- [ ] Record of consent (timestamp, IP, consent text)

**Example**:
```html
<form>
  <input type="checkbox" id="terms" required>
  <label for="terms">I agree to the Terms of Service</label>
  
  <input type="checkbox" id="privacy" required>
  <label for="privacy">I agree to the Privacy Policy</label>
  
  <input type="checkbox" id="marketing">
  <label for="marketing">I want to receive marketing emails (optional)</label>
</form>
```

**Consent Log**:
```json
{
  "user_id": "123",
  "consent_type": "marketing_emails",
  "granted": true,
  "timestamp": "2024-10-04T12:00:00Z",
  "ip_address": "203.0.113.1",
  "consent_text": "I want to receive marketing emails about new features."
}
```

---

### 5. Data Security

**Encryption**:
- [ ] Data at rest: AES-256 encryption
- [ ] Data in transit: TLS 1.3
- [ ] Database: Encrypted backups

**Access Controls**:
- [ ] Role-based access control (RBAC)
- [ ] Principle of least privilege
- [ ] Multi-factor authentication for admin access

**Audit Logs**:
- [ ] Log all personal data access
- [ ] Log retention: 1 year
- [ ] Cannot be deleted or modified

**Example Log**:
```json
{
  "timestamp": "2024-10-04T12:00:00Z",
  "user": "admin@example.com",
  "action": "VIEW_USER_PROFILE",
  "resource": "user_id:123",
  "ip_address": "203.0.113.5"
}
```

---

### 6. Data Breach Notification

**Notification to Supervisory Authority**:
- [ ] Report within 72 hours of becoming aware
- [ ] Describe nature of breach
- [ ] Number of data subjects affected
- [ ] Likely consequences
- [ ] Measures taken to address breach

**Notification to Data Subjects**:
- [ ] Required if high risk to rights and freedoms
- [ ] Clear, plain language
- [ ] Describe nature of breach and likely consequences
- [ ] Recommend measures to mitigate harm

**Incident Response Plan**: See `INCIDENT_RESPONSE_PLAN.md`

---

### 7. Data Processing Agreements (DPA)

**With Third-Party Processors** (subcontractors):
- [ ] Signed DPA with Stripe (payment processing)
- [ ] Signed DPA with SendGrid (email service)
- [ ] Signed DPA with AWS (hosting)
- [ ] Signed DPA with any vendor processing EU user data

**DPA Must Include**:
- Scope, duration, nature of processing
- Types of personal data
- Security measures
- Subprocessor approval process
- Data breach notification obligations
- Data deletion obligations

---

### 8. International Data Transfers

**Transfers Outside EU**:
- [ ] Use Standard Contractual Clauses (SCCs)
- [ ] Or: Transfer to countries with adequacy decision (UK, Switzerland, etc.)
- [ ] Or: Use Binding Corporate Rules (BCRs)

**Example**: AWS hosting in US (non-adequate country)
- [ ] Signed AWS Data Processing Addendum (includes SCCs)
- [ ] Documented in privacy policy

---

### 9. Data Protection Impact Assessment (DPIA)

**Required when**:
- Processing special category data (health, biometric)
- Large-scale profiling or automated decision-making
- Systematic monitoring (e.g., CCTV)
- Processing vulnerable subjects (children)

**DPIA Content**:
- [ ] Description of processing operations
- [ ] Purposes of processing
- [ ] Assessment of necessity and proportionality
- [ ] Assessment of risks to data subjects
- [ ] Measures to address risks
- [ ] Safeguards and security measures

**Template**: [Link to DPIA template]

---

### 10. Data Protection Officer (DPO)

**Required if**:
- Public authority (except courts)
- Core activities involve large-scale regular/systematic monitoring
- Core activities involve large-scale processing of special category data

**DPO Duties**:
- Monitor GDPR compliance
- Advise on data protection obligations
- Cooperate with supervisory authority
- Act as point of contact for data subjects

**If Not Required**: Still designate someone responsible (Privacy Officer)

---

## GDPR Checklist Summary

### Before Launch
- [ ] Privacy policy published
- [ ] Cookie consent banner (if using non-essential cookies)
- [ ] Data processing inventory created
- [ ] Legal basis determined for each processing activity
- [ ] Data retention policy defined
- [ ] User rights endpoints implemented (export, delete)
- [ ] Consent management system implemented
- [ ] Data security measures in place (encryption, access control)
- [ ] DPAs signed with all processors
- [ ] Staff trained on GDPR obligations

### Ongoing Compliance
- [ ] Privacy policy reviewed annually
- [ ] Data protection audit annually
- [ ] User rights requests responded to within 1 month
- [ ] Consent records maintained
- [ ] Data breach procedures tested
- [ ] New processing activities reviewed (DPIA if needed)

---

## Common GDPR Violations

### 1. Insufficient Legal Basis
❌ **Violation**: Collecting data without consent or other legal basis  
✅ **Fix**: Obtain explicit consent or identify another legal basis

### 2. Non-Compliant Consent
❌ **Violation**: Pre-ticked checkboxes, bundled consent  
✅ **Fix**: Require affirmative action, separate consents

### 3. No Privacy Policy
❌ **Violation**: No explanation of data use  
✅ **Fix**: Publish comprehensive privacy policy

### 4. Cannot Delete Data
❌ **Violation**: No account deletion feature  
✅ **Fix**: Implement "Delete Account" button

### 5. Weak Security
❌ **Violation**: Plaintext passwords, no encryption  
✅ **Fix**: Hash passwords (bcrypt), encrypt data (AES-256)

### 6. Late Breach Notification
❌ **Violation**: Reporting breach after 72 hours  
✅ **Fix**: Incident response plan with 72-hour deadline

### 7. No DPA with Vendors
❌ **Violation**: Using email service without DPA  
✅ **Fix**: Sign DPA with all data processors

---

## GDPR Compliance Tools

**Consent Management**:
- OneTrust
- Cookiebot
- TrustArc

**Privacy Policy Generators**:
- Termly
- TermsFeed
- FreePrivacyPolicy.com

**Data Mapping**:
- OneTrust Data Mapping
- Collibra
- Egnyte

**Encryption**:
- AWS KMS (Key Management Service)
- HashiCorp Vault
- Azure Key Vault

---

## GDPR Resources

**Official**:
- GDPR text: https://gdpr-info.eu
- European Data Protection Board: https://edpb.europa.eu
- ICO (UK): https://ico.org.uk/for-organisations/guide-to-data-protection/guide-to-the-general-data-protection-regulation-gdpr/

**Guides**:
- GDPR checklist: https://gdpr.eu/checklist
- Privacy policy generator: https://www.freeprivacypolicy.com

---

## Checklist

Pre-launch:
- [ ] Privacy policy written and published
- [ ] Cookie consent banner (if needed)
- [ ] User data export feature
- [ ] Account deletion feature
- [ ] Consent checkboxes (separate, not pre-ticked)
- [ ] Data encryption (AES-256 at rest, TLS 1.3 in transit)
- [ ] DPAs signed with vendors
- [ ] Incident response plan documented

Post-launch:
- [ ] Monitor user rights requests (respond within 1 month)
- [ ] Log data access (audit trail)
- [ ] Annual privacy policy review
- [ ] Annual data protection audit
- [ ] Staff GDPR training (annually)

---

## Notes

**GDPR is not just EU**: UK, Brazil (LGPD), California (CCPA) have similar laws

**Compliance is ongoing**: Not one-time checklist, requires continuous monitoring

**Consult lawyer**: This checklist is guidance, not legal advice

**When in doubt, ask for consent**: Strongest legal basis
