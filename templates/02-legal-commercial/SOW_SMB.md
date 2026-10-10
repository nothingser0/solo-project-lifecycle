# Statement of Work (SOW) - SMB Template

> **Purpose**: Simplified legal agreement for small-medium business clients  
> **When**: M03 Legal/Commercial (after proposal accepted)  
> **Duration**: 1-2 days to prepare and sign  
> **Simpler than**: Enterprise SOW (no legal review needed)

---

## Statement of Work

**Project**: [Project Name]  
**Client**: [Client Company Name]  
**Vendor**: [Your Company/Name]  
**Date**: [YYYY-MM-DD]  
**SOW Number**: SOW-[YYYY]-[001]

---

## 1. Project Overview

**Objective**:  
[1-2 sentences describing what you're building]

**Example**:
```
Build a web-based inventory management system to track product stock levels,
generate low-stock alerts, and provide daily inventory reports.
```

**Success Criteria**:
- [Deliverable 1 works as specified]
- [Deliverable 2 works as specified]
- [Client accepts in UAT phase]

---

## 2. Scope of Work

### In Scope

**Features** (from MoSCoW Must Have + Should Have):
1. [Feature 1]
2. [Feature 2]
3. [Feature 3]
4. [Feature 4]
5. [Feature 5]

**Deliverables**:
- Staging environment (for testing)
- Production deployment (live system)
- Source code (Git repository)
- Documentation (README, admin guide)
- 30-day warranty support

**Technical Stack**:
- Frontend: [Next.js / React / Laravel Blade]
- Backend: [Node.js / Laravel / Django]
- Database: [PostgreSQL / MySQL]
- Hosting: [Vercel / AWS / DigitalOcean]

---

### Out-of-Scope

**NOT included in this SOW**:
- [ ] Mobile app (native iOS/Android)
- [ ] [Feature X] (deferred to Phase 2)
- [ ] [Integration Y] (separate quote)
- [ ] Server maintenance after warranty
- [ ] Content creation (text, images)

**Note**: Features marked "Out of Scope" can be added via Change Request (separate cost/timeline).

---

## 3. Timeline

**Start Date**: [YYYY-MM-DD]  
**End Date**: [YYYY-MM-DD]  
**Duration**: [X weeks / Y months]

**Milestones**:

| Milestone | Deliverable | Due Date | Payment |
|:----------|:------------|:---------|:--------|
| M1 - Design Complete | UI/UX mockups approved | [Date] | 30% |
| M2 - Development Complete | Working system on staging | [Date] | 40% |
| M3 - Production Deploy | Live system + handover | [Date] | 30% |

**Total**: 3 milestones, [X weeks] duration

---

## 4. Budget & Payment Terms

**Total Project Cost**: Rp [Amount] (excluding tax)  
**Tax (PPN 11%)**: Rp [Amount]  
**Grand Total**: Rp [Amount] (including tax)

**Payment Schedule**:

| Payment | Amount | Due | Trigger |
|:--------|:-------|:----|:--------|
| DP (30%) | Rp [Amount] | [Date] | Upon SOW signing |
| Progress (40%) | Rp [Amount] | [Date] | Staging approval (M2) |
| Final (30%) | Rp [Amount] | [Date] | Production deploy (M3) |

**Payment Method**:
- Bank transfer to: [Bank name, Account number, Account name]
- Invoice issued before each payment
- Payment due within 7 days of invoice

**Late Payment**:
- Work paused if payment >14 days overdue
- 2% penalty per month on overdue amount

---

## 5. Client Responsibilities

**Client must provide**:
1. **Designated Single PIC**:
   - **Name**: [Client PIC Name]
   - **Title & Contact**: [Title] / [email@company.com] / [+628...]
   - **Authority**: The sole authorized individual on client side with authority to approve design mockups, scope adjustments, and milestone acceptance. Instructions from other client staff hold no binding authority.
2. **Content**: Text, images, logos, branding guidelines
3. **Access**: Credentials for existing systems (if integration needed)
4. **Feedback**: Timely approval within SLA (3 business days)
5. **Data**: Existing data for migration (if applicable)
6. **Availability**: Attend weekly sync calls (30 min)

**Client SLA**:
- Design approval: 3 business days
- UAT testing: 5 business days
- Bug feedback: 2 business days

**If client delays exceed 14 days**: Timeline extended accordingly (no cost).

---

## 6. Vendor Responsibilities

**Vendor will deliver**:
1. UI/UX design (mockups in Figma)
2. Fully functional web application
3. Staging environment for testing
4. Production deployment
5. Source code ownership transfer
6. Documentation (README, admin guide)
7. 30-day warranty support

**Vendor SLA**:
- Bug fixes (S1 Critical): 24 hours
- Bug fixes (S2 High): 3 business days
- Bug fixes (S3 Medium): 7 business days
- Bug fixes (S4 Low): Best effort

---

## 7. Change Request Process

**If client requests changes outside scope**:

1. Client submits written change request (email)
2. Vendor provides cost + timeline impact estimate (within 2 business days)
3. Client approves or rejects estimate
4. If approved: Update SOW addendum, adjust timeline/payment
5. If rejected: Proceed with original scope

**Example**:
```
Change Request: Add SMS notifications
Impact: +Rp 5M, +1 week timeline
Client decision: Approved / Deferred to Phase 2
```

**Minor tweaks** (< 2 hours work): No charge if within same milestone.

---

## 8. Acceptance Criteria

**Definition of Done** (per milestone):

### M1 - Design Complete
- [ ] All screens designed (per SITEMAP)
- [ ] Design system documented
- [ ] Client approves mockups in writing

### M2 - Development Complete
- [ ] All Must Have + Should Have features working
- [ ] Deployed to staging URL
- [ ] Client completes UAT testing
- [ ] S1/S2 bugs fixed

### M3 - Production Deploy
- [ ] Production URL live
- [ ] Smoke test passes (5 critical flows)
- [ ] Credentials handed over
- [ ] Client signs BAST (acceptance letter)

**Acceptance**:
- Client has 5 business days to test and accept each milestone
- **Deemed Acceptance (Klausul Klien Diam)**: if the Client provides no written feedback within **7 calendar days** after milestone delivery, the milestone is deemed approved and its invoice becomes due.
- Rejection must be in writing with specific issues

---

## 8.1 Gate Confirmation Log (M03 Exit)

> Mark `[x]` ONLY after verifying against the actual bank statement / signed copy. Do NOT pre-fill.

- [ ] SOW signed by both parties (dated copy filed)
- [ ] DP received in bank account — Date: [YYYY-MM-DD] | Amount: Rp [Amount]
- [ ] NDA signed (required when Client data is sensitive / commercial)

`Gate-Decision: PENDING`

---

## 9. Warranty & Support

**30-Day Warranty** (from production deploy):
- Bug fixes: Free (S1/S2/S3 severity)
- Scope: Bugs caused by vendor code
- Excluded: Hosting costs, third-party service costs, client-caused issues

**Post-Warranty Support** (optional):
- Monthly retainer: Rp [Amount]/month
- Covers: Bug fixes, minor enhancements, hosting maintenance
- Separate agreement after warranty ends

---

## 10. Intellectual Property

**Source Code Ownership**:
- Upon final payment: Client owns all source code
- Vendor transfers Git repository access
- Client can modify, distribute, resell code

**Third-Party Libraries**:
- Open-source libraries remain under original licenses
- Listed in `package.json` / `composer.json`

**Vendor Portfolio Rights**:
- Vendor may showcase project in portfolio (with client permission)
- Client logo/name usage requires written approval

---

## 11. Confidentiality

**Both parties agree**:
- Keep confidential information private
- Use information only for this project
- Delete/return confidential data after project ends

**Confidential Information**:
- Business plans, financials
- User data, customer lists
- Source code (before handover)
- API keys, passwords

**Exceptions**: Publicly available information, legally required disclosure.

---

## 12. Limitation of Liability

**Vendor liability limited to**:
- Maximum: Total project cost (Rp [Amount])
- Covers: Direct damages caused by vendor negligence
- Excludes: Lost profits, indirect damages, third-party claims

**Client agrees**:
- Vendor not responsible for hosting downtime (third-party)
- Vendor not responsible for data loss (client backup responsibility)
- Vendor not responsible for client misuse of software

---

## 13. Termination

**Either party may terminate if**:
- Other party breaches SOW (after 14-day cure notice)
- Other party becomes insolvent
- Force majeure exceeds 30 days

**Termination Payment**:
- Client pays for work completed to date (pro-rated)
- Vendor delivers work-in-progress
- No refund of DP

**Example**:
```
If terminated after M1 complete: Client pays 30% (M1 payment)
If terminated mid-M2: Client pays 30% + pro-rated M2 work
```

---

## 14. Dispute Resolution

**If dispute arises**:
1. Negotiate in good faith (14 days)
2. Mediation (if negotiation fails)
3. Arbitration in [City] (final and binding)

**Governing Law**: Laws of Indonesia  
**Jurisdiction**: [City] courts

---

## 15. General Terms

**Entire Agreement**:
- This SOW supersedes all prior agreements
- Amendments must be in writing

**Force Majeure**:
- Neither party liable for delays due to natural disasters, pandemics, war, etc.
- Timeline extended by delay duration

**Assignment**:
- Neither party can assign SOW without written consent

**Notices**:
- Email to addresses below deemed valid notice

---

## Signatures

**CLIENT**:

Name: _________________________________  
Title: _________________________________  
Company: _________________________________  
Date: _________________________________  
Signature: _________________________________

**VENDOR**:

Name: _________________________________  
Title: _________________________________  
Company: _________________________________  
Date: _________________________________  
Signature: _________________________________

---

---

## Notes for Using This Template

### Customization Points

1. **Timeline**: 2-6 months
2. **Payment Split**: 30/40/30 (Medium) or 50/50 (Small Fast-Track) - pick one
3. **Warranty**: 30 days standard, 60-90 days negotiable
4. **Tax**: PPN 11% (Indonesia) - adjust for your country

---

### When to Use SOW-SMB vs Full SOW

**Use SOW-SMB** (this template) if:
- Client is a small-medium business (no in-house legal department, won't redline)
- Straightforward project: 3-15 P0 features, no compliance/regulatory obligations
- Client data handled is low-sensitivity (no health, financial, or biometric data)

**Use Full SOW** if:
- Client has a legal team (will redline the contract)
- Scope exceeds 15 P0 features, or requires multi-party integrations
- Compliance/regulatory obligations apply (ISO 27001, SOC 2, UU PDP sensitive data, sector rules)

---

### Legal Disclaimer

**This is a template, not legal advice.**

- Review with lawyer before first use
- Customize for your jurisdiction
- May need notarization (materai in Indonesia)
- May need tax registration (NPWP in Indonesia)

**When in doubt**: Consult lawyer (costs Rp 2-5M, worth it for peace of mind).

---

## Integration with Workflow

**M02 Discovery**:
- Gather requirements → scope finalized

**M03 Legal/Commercial**:
- Proposal accepted → Draft SOW using this template
- Client reviews (1-2 days)
- Both parties sign → Send invoice for DP
- DP received → Start M04 Design

**Change Requests**:
- Client requests new feature → Addendum to SOW
- Update payment schedule + timeline

---

## Example: Filled SOW

```
STATEMENT OF WORK

Project: Inventory Management System
Client: ABC Retail Sdn Bhd
Vendor: XYZ Tech
Date: October 4, 2024
SOW Number: SOW-2024-012

---

1. PROJECT OVERVIEW

Objective:
Build a web-based inventory management system to track product stock 
levels, generate low-stock alerts, and provide daily inventory reports 
for ABC Retail's 8-person team managing 500 SKUs.

Success Criteria:
- Staff can add/remove stock via barcode scanning
- System sends low-stock alerts when qty < threshold
- Manager can view real-time inventory report

---

2. SCOPE OF WORK

In Scope (7 Must Have features):
1. User login (email/password, 10 users)
2. Product CRUD (create/view/edit/delete products)
3. Stock tracking (quantity in/out transactions)
4. Low stock alerts (email + dashboard notification)
5. Stock report (current inventory, CSV export)
6. Barcode scanning (camera or USB scanner)
7. Multi-user access (5-10 concurrent users)

Deliverables:
- Staging: https://staging.abcinventory.com
- Production: https://inventory.abcretail.com
- Source code: GitHub private repository
- Documentation: README, Admin guide
- 30-day warranty support

Technical Stack:
- Frontend: Next.js 14 + TypeScript
- Backend: Node.js + PostgreSQL
- Hosting: Vercel + Supabase

Out of Scope:
- Mobile app (web works on mobile browser)
- Accounting integration (QuickBooks sync → Phase 2)
- Multi-warehouse support (single location for MVP)

---

3. TIMELINE

Start: Oct 7, 2024
End: Dec 20, 2024
Duration: 11 weeks

Milestones:
| M1 - Design | Figma approved | Oct 25 | 30% (Rp 12M) |
| M2 - Development | Staging ready | Dec 6 | 40% (Rp 16M) |
| M3 - Production | Live + handover | Dec 20 | 30% (Rp 12M) |

---

4. BUDGET

Total: Rp 40,000,000 (excluding tax)
Tax (PPN 11%): Rp 4,400,000
Grand Total: Rp 44,400,000

Payment Schedule:
| DP (30%) | Rp 13,320,000 | Oct 7 | Upon signing |
| Progress (40%) | Rp 17,760,000 | Dec 6 | Staging approved |
| Final (30%) | Rp 13,320,000 | Dec 20 | Production deploy |

Bank: BCA 1234567890 (XYZ Tech)
Invoice: 7 days payment terms

---

[Sections 5-15: Use template above]

---

SIGNATURES

CLIENT:
Name: John Doe
Title: Operations Manager
Company: ABC Retail Sdn Bhd
Date: October 4, 2024
Signature: ___________________

VENDOR:
Name: Jane Smith
Title: Founder
Company: XYZ Tech
Date: October 4, 2024
Signature: ___________________
```

---

## Checklist

Before sending SOW:
- [ ] All scope from MoSCoW matrix included
- [ ] Budget matches quotation
- [ ] Timeline realistic (add buffer)
- [ ] Payment schedule clear
- [ ] Out of scope explicitly stated
- [ ] Client responsibilities listed

After signing:
- [ ] Both parties have signed copy
- [ ] Invoice sent for DP
- [ ] DP received → Start work
- [ ] SOW filed (Google Drive / Dropbox)
