# Warranty Policy (Small Scale)

> **Target**: Solo MVP / Small projects  
> **Duration**: 30 days post-launch  
> **Purpose**: Define what's covered vs out of scope post-handover

---

## 1. Warranty Period

**Start Date**: Project handover date (M11 BAST signed)  
**End Date**: 30 days after handover  
**Coverage**: Bug fixes only (see Section 3)

---

## 2. What's Covered (FREE)

### 2.1 Software Bugs
Defects in functionality that was delivered and working at handover:

- [ ] **Feature not working**: Function worked during UAT, now broken
- [ ] **Data corruption**: App corrupts/loses data due to code defect
- [ ] **Security vulnerability**: Critical security issue discovered post-launch
- [ ] **Performance regression**: Significant slowdown from baseline (>2x slower)

**Examples**:
- Login button worked in UAT, now returns 500 error → **COVERED**
- Export CSV feature produces corrupt file → **COVERED**
- SQL injection vulnerability found → **COVERED**

---

## 3. What's NOT Covered (Out of Scope)

### 3.1 New Features or Changes
Any modification to scope/features:

- ❌ "Can we add a new report?"
- ❌ "Change the dashboard layout"
- ❌ "Add SMS notification (only email was in scope)"

**Decision**: Quote separately as Change Request (CR)

---

### 3.2 User Error or Misuse
Problems caused by incorrect usage:

- ❌ User deleted data manually via database
- ❌ User entered invalid data (e.g., negative quantity)
- ❌ User shared password, account compromised

**Decision**: Provide guidance, not code fix

---

### 3.3 Third-Party Service Issues
External services beyond our control:

- ❌ Payment gateway downtime (Midtrans, Xendit)
- ❌ Email delivery failure (SMTP provider issue)
- ❌ Hosting downtime (Vercel, AWS, DigitalOcean)

**Decision**: Help troubleshoot, but fix is on third-party

---

### 3.4 Infrastructure Changes
Changes to hosting/environment after handover:

- ❌ Client changed server configuration
- ❌ Client upgraded database version
- ❌ Client moved to different hosting

**Decision**: Quote as support engagement

---

### 3.5 Browser/Device Compatibility Beyond Scope
Browsers/devices NOT in original scope:

- ❌ "It doesn't work on Internet Explorer 11" (if not in scope)
- ❌ "iPad layout broken" (if only desktop was scoped)

**Decision**: Original scope defines coverage (e.g., "Chrome/Firefox/Safari desktop")

---

### 3.6 Content or Data Updates
Non-technical updates:

- ❌ "Update company logo"
- ❌ "Change product descriptions"
- ❌ "Bulk update 100 records"

**Decision**: Provide admin panel training, client does updates

---

### 3.7 Training or Consultation
Post-handover support:

- ❌ "How do I use the admin panel again?"
- ❌ "What's the best way to handle this workflow?"

**Decision**: Training was in M11, reference documentation

---

## 4. Response Time (SLA)

| Severity | Description | Response Time | Fix Time |
|:---------|:------------|:--------------|:---------|
| **S1 - Critical** | Production down, no workaround | 4 hours | 24 hours |
| **S2 - High** | Major feature broken, workaround exists | 24 hours | 3 days |
| **S3 - Medium** | Minor bug, doesn't block usage | 3 days | 7 days |
| **S4 - Low** | Cosmetic issue, typo | 7 days | 14 days |

**Example**:
- Login completely broken, users can't access → **S1 Critical**
- Export CSV has formatting issue, manual fix possible → **S2 High**
- Button text typo → **S4 Low**

---

## 5. How to Report Issues

### Reporting Channel
**Email**: [developer-email@example.com]  
**Subject**: `[WARRANTY] Project Name - Issue Description`

### Required Information
Please include:
1. **Issue description**: What's broken?
2. **Steps to reproduce**: How to trigger the bug?
3. **Expected vs actual**: What should happen vs what happens?
4. **Screenshots/video**: Visual evidence
5. **Browser/device**: Chrome 119, Windows 11

**Example report**:
```
Subject: [WARRANTY] TataBuku - Login Returns 500 Error

Description: Users cannot log in since 5 PM today.

Steps to reproduce:
1. Go to /login
2. Enter valid email/password
3. Click "Login"
4. Error 500 appears

Expected: Redirect to /dashboard
Actual: 500 Internal Server Error

Screenshot: [attached]
Browser: Chrome 119, Windows 11
```

---

## 6. Issue Resolution Process

1. **Developer acknowledges** (within SLA response time)
2. **Developer investigates** and classifies (bug vs out-of-scope)
3. **If bug**: Developer fixes and deploys
4. **If out-of-scope**: Developer explains + provides quote for CR
5. **Client verifies fix** (within 2 business days)

---

## 7. After Warranty Period

### Post-Warranty Options

**Option 1: Pay-per-incident**
- Bug fix: Rp 500K - Rp 2M per issue (depends on complexity)
- New feature: Quote separately

**Option 2: Monthly retainer** (if client needs ongoing support)
- Rp 3M - Rp 5M per month
- Includes: 4-8 hours support, minor bug fixes, small changes

**Option 3: No support**
- Source code transferred, client maintains internally

---

## 8. Warranty Boundaries Enforcement

### Example Decision Tree

**Client reports**: "Dashboard is slow"
1. Was it slow during UAT? 
   - **No** → Bug (covered)
   - **Yes** → Baseline performance (not covered unless 2x worse)

**Client requests**: "Add export to PDF"
1. Was PDF export in original scope?
   - **No** → New feature (not covered, quote CR)
   - **Yes** → Bug (covered)

**Client reports**: "Email not sending"
1. Is SMTP provider responding?
   - **No** → Third-party issue (not covered, help troubleshoot)
   - **Yes** → Code bug (covered)

---

## 9. Warranty Termination Conditions

Warranty VOID if:
- Client modified source code
- Client changed hosting without notice
- Client refused to provide access for bug investigation
- Client violated payment terms

---

## 10. Sign-Off

This warranty policy was explained during handover (M11) and acknowledged:

**Client PIC**: ___________________________  
**Signature**: ___________________________  
**Date**: ___________________________

**Developer**: ___________________________  
**Signature**: ___________________________  
**Date**: ___________________________

---

## Attachment

Include this policy in M11 handover email:
- Attach as PDF: `WARRANTY_POLICY.pdf`
- Reference in BAST document
- Save client's acknowledgment email

---

## Notes for Developer

**Be firm but fair**:
- Bug = covered (fix for free)
- New feature = quote separately
- User error = guide, not fix
- Third-party = help, not responsible

**Document everything**:
- Save all issue reports
- Log time spent on warranty fixes
- If client abuses warranty (requests features as "bugs"), politely clarify using this document
