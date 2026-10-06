# Bug Report Template

> **Purpose**: Standardized bug reporting for QA and clients  
> **When**: M07 QA phase or M09 UAT  
> **Format**: Copy to bug tracker (Jira, Linear, GitHub Issues)

---

## Bug Information

**Bug ID**: BUG-___  
**Reported By**: [Name]  
**Date**: [YYYY-MM-DD]  
**Environment**: ☐ Staging ☐ Production ☐ Local

---

## Bug Summary

**Title**: [Brief description in <80 chars]

**Example**: "Login fails with valid credentials"

---

## Severity

☐ **S1 - Critical**: Production down, no workaround, affects all users  
☐ **S2 - High**: Major feature broken, workaround exists  
☐ **S3 - Medium**: Minor bug, doesn't block core functionality  
☐ **S4 - Low**: Cosmetic issue, typo, polish

---

## Description

**What happened?**  
_________________________________

**What should happen?**  
_________________________________

---

## Steps to Reproduce

1. [Step 1]
2. [Step 2]
3. [Step 3]

**Expected Result**: [What should happen]  
**Actual Result**: [What actually happens]

---

## Frequency

**How often does this occur?**  
☐ Always (100%)  
☐ Often (>50%)  
☐ Sometimes (10-50%)  
☐ Rarely (<10%)

---

## Environment Details

**Browser**: [Chrome 119 / Firefox 120 / Safari 17]  
**OS**: [Windows 11 / macOS 14 / Android 13]  
**Screen Size**: [1920x1080 / Mobile 375x667]  
**User Role**: [Admin / User / Guest]

---

## Attachments

**Screenshot**: [Attach or paste URL]  
**Video**: [Loom link or attachment]  
**Console Errors**: 
```
[Paste console errors here]
```

**Network Logs** (if API issue):
```
[Paste network tab errors]
```

---

## Additional Context

**Related Features**: _________________________________  
**Recent Changes**: _________________________________  
**Workaround**: _________________________________

---

---

## Example: Filled Bug Report

```
BUG-042
Reported By: Sarah (QA)
Date: 2024-10-04
Environment: Staging

---

Title: Login fails with valid credentials

Severity: S1 - Critical

---

Description:

What happened?
Users cannot log in to the system even with correct email/password.
Login button shows loading spinner indefinitely, never redirects.

What should happen?
After entering valid credentials and clicking "Login", user should
be redirected to dashboard within 2 seconds.

---

Steps to Reproduce:
1. Go to https://staging.app.com/login
2. Enter email: test@example.com
3. Enter password: Test123!@#
4. Click "Login" button
5. Observe loading spinner never stops

Expected: Redirect to /dashboard
Actual: Spinner forever, no redirect, no error message

---

Frequency: Always (100%)

---

Environment:
Browser: Chrome 119.0.6045.105
OS: Windows 11
Screen: 1920x1080
User Role: Regular user (admin login works fine)

---

Attachments:
Screenshot: [shows loading spinner]
Video: https://loom.com/share/abc123

Console Errors:
POST https://api.staging.app.com/auth/login 401 Unauthorized
Error: Invalid token format

Network:
Request: POST /auth/login
Response: 401 {"error": "Invalid credentials"}
(But credentials ARE valid - verified in database)

---

Additional Context:
- Started happening after commit abc123 (session refactor)
- Only affects regular users, admin login works
- Workaround: Use admin account
- Related: Session management feature (BUG-040)
```

---

## Bug Report Checklist

Before submitting:
- [ ] Tried to reproduce at least twice
- [ ] Checked if already reported
- [ ] Clear steps to reproduce
- [ ] Screenshots/video attached
- [ ] Console errors included (if applicable)
- [ ] Severity assessed correctly

---

## Integration

**Bug Workflow**:
1. QA/Client reports bug (this template)
2. Dev triages severity
3. Dev fixes bug
4. QA verifies fix
5. Bug marked as closed
