# Maintenance Warranty Policy

> Official terms governing coverage, boundaries, service hours, and reporting procedures for bug fixes during the post-BAST warranty period.

---

## 1. Warranty Parameters
- **System Name**: [Application Name]
- **Client Party**: [Client Company Name]
- **Lead Developer**: [Your Name]
- **BAST Reference Number**: BAST/[PROJECT_ID]/[YEAR]
- **Warranty Start Date**: [YYYY-MM-DD] (Per BAST sign-off date)
- **Warranty End Date**: [YYYY-MM-DD] (30 / 60 / 90 Calendar Days)

---

## 2. Warranty Coverage (What Is Included & Protected)

Warranty applies **EXCLUSIVELY to genuine bug fixes (Bug Fixes)**:
1. Programming logic defects where system behavior deviates from agreed technical specification documents (**FSD.md** or **PRD.md**).
2. Critical security vulnerabilities (*security vulnerability*) in application code written by the Developer.
3. Internal server errors (*HTTP 500 Server Error*) triggered during normal workflow paths approved during UAT sessions.

---

## 3. Warranty Exclusions (What Is NOT Included)

The warranty is legally **INAPPLICABLE** under the following conditions:
1. **New Feature Requests (New Features)**: Adding new modules, creating new document templates, or modifying report layouts not specified in the PRD.
2. **Visual Design Changes (UI Layout)**: Moving button placements, altering brand colors, or restructuring navigation sitemaps after *Design Freeze* sign-off.
3. **User Operational Errors (User Error)**: Accidental master data deletion by client staff, mass forgotten passwords, or client office hardware malware infections.
4. **External Third-Party Changes**: API endpoint breaking changes, abrupt policy updates, or server outages from external providers (Payment Gateways, Cloudflare, AWS/GCP, SMTP).
5. **Unauthorized Code Modification**: Source code modified or altered by client internal teams or third parties without written authorization from the Developer.

---

## 4. Service Hours & Service Level Agreement (SLA) Matrix

- **Official Service Hours**: **Monday to Friday, 09:00 – 17:00 UTC/Local** (Excluding national public holidays).
- **Official Reporting Channel**: Email to `[email-support@domain.com]` or designated official technical communication channel.

| Issue Classification | Issue Definition | Initial Response Time | Resolution Target |
| :--- | :--- | :---: | :---: |
| **Severity 1 (Critical)** | Entire system down (*down*), payment transactions failing completely, data corruption | **$< 2$ Business Hours** | **$< 24$ Business Hours** |
| **Severity 2 (Major)** | Core feature impaired but a workaround exists | **$< 8$ Business Hours** | **$< 48$ Business Hours** |
| **Severity 3 (Minor)** | Minor typo (*typo*), slight cosmetic visual misalignment | **$< 24$ Business Hours** | Scheduled in weekly maintenance release |

---

## 5. Post-Warranty Procedures

Upon expiration of the warranty period:
- All forms of bug fixes, security updates, and technical support will be billed at standard industry hourly rates (*Time & Materials*) or governed under a **Monthly Retainer SLA (Maintenance Agreement)**.
