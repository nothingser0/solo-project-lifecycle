# UAT Sign-Off Form (Small Scale)

> **Purpose**: Simple 1-page approval for UAT completion  
> **When**: After completing UAT testing (before M11 handover)  
> **Format**: Can be email reply or printed form

---

## Project Information

**Project Name**: _________________________________  
**Client Company**: _________________________________  
**Client PIC**: _________________________________  
**Developer**: _________________________________  
**UAT Period**: _____________ to _____________

---

## Test Summary

**Total Test Cases**: _____ (typically 10-15 for small projects)  
**Test Cases Passed**: _____  
**Test Cases Failed**: _____  
**Test Cases Blocked**: _____

**Pass Rate**: _____% (must be ≥90% to approve)

---

## Bug Summary

| Bug ID | Severity | Description | Status |
|:-------|:---------|:------------|:-------|
| 1 | S1 Critical | | ☐ Fixed ☐ Open |
| 2 | S2 High | | ☐ Fixed ☐ Open |
| 3 | S3 Medium | | ☐ Fixed ☐ Open |
| 4 | S4 Low | | ☐ Fixed ☐ Open |

**Critical/High Bugs Remaining**: _____ (must be 0 to approve)

**Severity Definitions**:
- **S1 Critical**: Blocks major functionality, no workaround
- **S2 High**: Major feature broken, workaround exists
- **S3 Medium**: Minor bug, doesn't block usage
- **S4 Low**: Cosmetic issue

---

## Acceptance Criteria

Check all that apply:

- [ ] All critical features (login, CRUD, etc.) work as expected
- [ ] No S1 or S2 bugs remaining (all fixed and verified)
- [ ] Application loads within acceptable time (<3 seconds)
- [ ] Forms validate inputs correctly
- [ ] Data saves and persists correctly
- [ ] User permissions/roles work correctly (if applicable)
- [ ] Mobile responsive (if in scope)
- [ ] Email notifications working (if in scope)
- [ ] Export/report features working (if in scope)

---

## UAT Decision

**☐ APPROVED** - Ready for production deployment  
**☐ CONDITIONAL APPROVAL** - Approved with S3/S4 bugs to be fixed post-launch  
**☐ REJECTED** - Major issues remain, requires re-testing

**If Conditional Approval, list deferred bugs**:
1. _________________________________
2. _________________________________
3. _________________________________

---

## Client Sign-Off

I, the undersigned, confirm that:
1. I have tested the application according to the UAT Workbook
2. I understand the bug severity levels and remaining issues
3. I accept the current state of the application for production deployment
4. I understand that S3/S4 bugs (if any) will be addressed during the 30-day warranty period

**Client PIC Name**: _________________________________  
**Signature**: _________________________________  
**Date**: _________________________________

---

## Developer Acknowledgment

I confirm that:
1. All S1/S2 bugs identified during UAT have been fixed
2. The application is ready for production deployment
3. I will address S3/S4 bugs during the warranty period (if conditional approval)

**Developer Name**: _________________________________  
**Signature**: _________________________________  
**Date**: _________________________________

---

---

## Email Sign-Off Alternative (Simpler)

If printed form is inconvenient, client can reply to UAT summary email with:

```
Subject: Re: UAT Sign-Off - [Project Name]

I, [Client Name], confirm that UAT is APPROVED.

Test Summary:
- Test cases passed: 15/15
- Critical bugs: 0
- Ready for production: YES

Signed: [Client Name]
Date: [Today's Date]
```

**Developer**: Save this email as PDF for records.

---

## Next Steps After Sign-Off

Once UAT is approved:
1. **Developer**: Deploy to production
2. **Developer**: Send M11 BAST handover email (see `BAST_EMAIL_SMALL.md`)
3. **Client**: Final acceptance and payment
4. **Both**: 30-day warranty period begins

---

## Notes

**For Developer**:
- Don't proceed to M11 without UAT sign-off
- UAT approval ≠ final acceptance (M11 BAST is final)
- Save signed form or approval email for records

**For Client**:
- UAT is your last chance to request changes before production
- After this, changes are out-of-scope (warranty covers bugs only)
- Be thorough in testing - don't rush!

---

## Red Flags (Don't Sign If...)

**Client should NOT approve if**:
- [ ] Login doesn't work
- [ ] Data doesn't save
- [ ] Critical features missing
- [ ] Application constantly crashes
- [ ] Major UI broken (unusable)

**These are S1/S2 bugs - must be fixed before approval!**

---

## Sample Filled Form

```
Project Name: TataBuku Accounting
Client Company: PT ABC
Client PIC: John Doe
Developer: Jane Developer
UAT Period: Sep 25 - Sep 30, 2024

Test Summary:
Total Test Cases: 15
Test Cases Passed: 15
Test Cases Failed: 0
Test Cases Blocked: 0
Pass Rate: 100%

Bug Summary:
No critical or high bugs remaining.
1 low-priority bug: Export button text typo (deferred to warranty).

Acceptance Criteria:
[✓] All checked

UAT Decision:
[✓] CONDITIONAL APPROVAL
Deferred bugs:
1. Export button says "Exprot" (typo)

Client Sign-Off:
Name: John Doe
Signature: [signed]
Date: Sep 30, 2024

Developer Acknowledgment:
Name: Jane Developer
Signature: [signed]
Date: Sep 30, 2024
```

---

## Integration with Workflow

**M09 UAT → M11 Handover**:
1. Client tests using `UAT_WORKBOOK_SMALL.md`
2. Developer fixes S1/S2 bugs
3. Client signs this `UAT_SIGNOFF_SMALL.md`
4. Developer proceeds to M11 (sends `BAST_EMAIL_SMALL.md`)
5. Client approves handover → Final payment → Warranty starts

---

## Solo / Portfolio Variant (Non-Client Delivery)

> Use this section INSTEAD of Client Sign-Off when `Delivery: solo` or `portfolio` (no external client).
> **Rule (M09-LITE)**: minimum **1 external tester** (a real person other than you) MUST be recorded. Self-approval alone is NOT accepted.

**External Tester Name**: _________________________________
**Relationship**: [colleague / friend / target-user proxy]
**Test Date**: [YYYY-MM-DD]

**Solo Test Summary**:
- Total Test Cases: _____
- Test Cases Passed: _____
- Critical (S1) Bugs Remaining: _____ (must be 0)

**Solo UAT Decision**:
- [ ] **APPROVED** - Zero S1/S2 bugs, external tester confirmed core flow works
- [ ] **REJECTED** - Critical issues remain, requires re-testing

**Machine Validation Line** (required for M09-LITE gate):
```
UAT-Decision: PASS
External-Tester: [Full Name]
```
