# BAST Email Template (Small Scale)

> **Purpose**: Email format for handover sign-off (replaces formal BAST document for small projects)  
> **When**: M11 Release & Handover  
> **Legal Value**: Client's reply "APPROVED" serves as acceptance proof

---

## Email Template

**Subject**: `[PROJECT NAME] - Final Handover & Acceptance`

---

**To**: [Client PIC Name] <client-email@example.com>  
**From**: [Your Name] <developer-email@example.com>  
**Date**: [Today's Date]

---

Dear [Client Name],

We are pleased to inform you that **[Project Name]** development is complete and ready for final handover. Please review the deliverables below and confirm acceptance by replying to this email.

---

## 1. Deliverables Checklist

Please verify that the following have been delivered:

### Application Access
- [ ] **Production URL**: https://yourdomain.com
- [ ] **Admin Panel URL**: https://yourdomain.com/admin
- [ ] **Admin Credentials**: [provided separately via secure channel]

### Source Code & Documentation
- [ ] **Source Code Repository**: [GitHub link] (access granted)
- [ ] **README.md**: Setup and deployment instructions
- [ ] **API Documentation** (if applicable): [link or file]

### Credentials & Access
- [ ] **Database Access**: [host, credentials provided separately]
- [ ] **Hosting Account**: [Vercel/AWS/DigitalOcean dashboard access]
- [ ] **Domain Management**: [registrar access or transferred]
- [ ] **Email Service**: [SMTP credentials or service dashboard]
- [ ] **Payment Gateway**: [Midtrans/Xendit test & production keys]

### Documentation
- [ ] **User Manual**: [link or PDF attached]
- [ ] **Admin Guide**: [link or PDF attached]
- [ ] **Warranty Policy**: Attached (30 days bug fix coverage)

### Support Materials
- [ ] **Training Session**: Completed on [Date]
- [ ] **Support Contact**: developer-email@example.com
- [ ] **Warranty Period**: 30 days from today

---

## 2. UAT Completion

User Acceptance Testing was completed on **[UAT End Date]** with the following results:

- **Test Cases**: 15/15 passed
- **Critical Bugs**: 0 remaining (all fixed)
- **UAT Sign-Off**: Received on [Date]

---

## 3. Known Limitations (if any)

The following are **out of scope** and not included:

- [Feature A] - can be added as Change Request
- [Feature B] - not in original scope
- [Browser C] - compatibility not included

---

## 4. Warranty Terms

**Coverage Period**: 30 days (until [End Date])  
**What's Covered**: Bug fixes for delivered functionality  
**What's NOT Covered**: New features, user errors, third-party issues

Full warranty policy is attached: `WARRANTY_POLICY.pdf`

---

## 5. Post-Warranty Support Options

After the 30-day warranty period:

- **Pay-per-incident**: Rp 500K - Rp 2M per fix
- **Monthly Retainer**: Rp 3M - Rp 5M per month (4-8 hours support)
- **No Support**: Source code transferred, client maintains internally

---

## 6. Payment Confirmation

**Final Payment**: Rp [Amount] (50% balance)  
**Payment Due**: Within 7 days of acceptance  
**Account Details**: [Bank name, account number]

---

## 7. Acceptance Confirmation

**Please reply to this email with the following statement to confirm acceptance:**

```
I, [Client Name], on behalf of [Company Name], confirm that I have:
- Reviewed all deliverables listed above
- Completed UAT successfully
- Received all credentials and documentation
- Understood the warranty terms

I hereby APPROVE the final handover of [Project Name].

Signed: [Your Name]
Date: [Today's Date]
```

**Important**: Your reply to this email serves as legal acceptance of the project. Please save this email thread for your records.

---

## 8. Next Steps

After your approval:
1. **We will**: Invoice final payment (50% balance)
2. **You pay**: Within 7 days
3. **Warranty starts**: From today for 30 days
4. **Support**: Email us for any issues (warranty terms apply)

---

## 9. Thank You

Thank you for choosing us for this project. We are available during the warranty period for any bug fixes or issues.

If you have any questions before confirming acceptance, please let us know.

Best regards,

**[Your Name]**  
[Your Title]  
[Your Company]  
[Your Phone]  
[Your Email]

---

## Attachments

1. `WARRANTY_POLICY.pdf`
2. `USER_MANUAL.pdf` (if applicable)
3. `ADMIN_GUIDE.pdf` (if applicable)

---

---

## For Developer: How to Use This Template

### Step 1: Prepare Before Sending
- [ ] Test all URLs work
- [ ] Verify all credentials are correct (double-check!)
- [ ] Generate PDFs for attachments
- [ ] Save copy of this email (you'll need it for invoicing)

### Step 2: Send Email
- [ ] Fill in all `[placeholders]`
- [ ] Attach warranty policy PDF
- [ ] Send from professional email (not Gmail personal)
- [ ] CC yourself for records

### Step 3: Wait for Client Reply
- [ ] Client should reply with "APPROVED" statement within 2-3 days
- [ ] If no reply after 3 days, follow up via WhatsApp/phone
- [ ] If client requests changes, assess if bug (warranty) or CR (quote)

### Step 4: After Approval Received
- [ ] **Save client's approval reply email as PDF** (legal proof!)
- [ ] Send invoice for final payment (50%)
- [ ] Start warranty countdown (30 days from approval date)
- [ ] Set calendar reminder for warranty end date

---

## Sample Client Approval Reply

```
From: client@example.com
To: developer@example.com
Subject: Re: [PROJECT NAME] - Final Handover & Acceptance

I, John Doe, on behalf of ABC Company, confirm that I have:
- Reviewed all deliverables listed above
- Completed UAT successfully
- Received all credentials and documentation
- Understood the warranty terms

I hereby APPROVE the final handover of TataBuku.

Signed: John Doe
Date: October 4, 2024
```

**Save this as PDF**: `BAST_TataBuku_Approved_2024-10-04.pdf`

---

## Legal Notes

**Why Email Format?**
- Small projects (<Rp 50M) don't need formal BAST document
- Email approval is legally valid (electronic signature law)
- Faster turnaround (no printing, scanning, mailing)
- Easy to archive and reference

**When to Use Formal BAST?**
- Project value >Rp 50M
- Government/corporate client requires it
- Legal team mandates formal document
- Multiple sign-off levels needed

For formal BAST, use `templates/07-release-handover/BAST_TEMPLATE.md`

---

## Red Flags (Don't Handover If...)

**STOP! Don't send this email if:**
- [ ] UAT not completed (unresolved S1/S2 bugs)
- [ ] Client hasn't paid DP or milestones (handover = leverage lost)
- [ ] Credentials not tested (double-check EVERYTHING)
- [ ] Source code not pushed to repository
- [ ] No backup of production database

**Rule**: Handover only when everything is 100% ready and paid up to current milestone.

---

## Troubleshooting

**Client says**: "I'll pay after I test it on my own"
**Response**: "UAT already completed and approved on [Date]. Warranty starts after acceptance, which is today. Payment terms are 7 days post-acceptance per agreement."

**Client says**: "Can you add feature X before I approve?"
**Response**: "Feature X was not in original scope. I can quote it as a Change Request, or we proceed with handover and add it later. What do you prefer?"

**Client ignores email for 1 week**
**Action**: 
1. WhatsApp: "Hi, just following up on handover email sent [date]. Let me know if you need clarification."
2. If still no reply after 2 weeks: Schedule call to walk through deliverables
3. If client is ghosting: Send formal reminder (registered mail if needed)

---

## Integration with Workflow

**M11 Handover Steps**:
1. Complete all deliverables (code, docs, credentials)
2. Send this BAST email
3. Wait for client approval reply (2-3 days)
4. Save approval reply as PDF
5. Send invoice for final payment
6. Start 30-day warranty countdown
7. Hand over complete → Move to M12 (if warranty work needed)
