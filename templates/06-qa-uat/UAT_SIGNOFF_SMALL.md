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

**Untested in-scope P0 criteria**: _____ (must be 0 unless an authorized exception and risk disposition are recorded)

---

## Bug Summary

| Bug ID | Severity | Description / evidence | Status / owner | Retest build / result |
|:-------|:---------|:------------|:-------|:-------|
| [ID] | [S1-S4 / CR] | [repro and evidence reference] | [status / owner] | [build / result] |

**Critical/High Bugs Remaining**: _____ (must be 0 to approve)

**Severity Definitions**:
- **S1 Critical**: Blocks major functionality, no workaround
- **S2 High**: Major feature broken, workaround exists
- **S3 Medium**: Minor bug, doesn't block usage
- **S4 Low**: Cosmetic issue

---

## Acceptance Criteria

Record the project-specific PRD/FSD acceptance-criterion IDs in the UAT workbook. Do not treat generic examples or an arbitrary response-time target as acceptance criteria.

---

## UAT Decision

**☐ GO** - UAT accepted; proceed to M10 release approval
**☐ CONDITIONAL GO** - Only with authorized risk acceptance and signed punch list
**☐ NO-GO / PENDING** - Production remains blocked until gaps are resolved or formally dispositioned

**If Conditional Approval, list deferred bugs**:
1. _________________________________
2. _________________________________
3. _________________________________

**Residual risks, owners, mitigations, and decision rationale**: _________________________________

**Tester(s)**: _________________________________
**Release veto authority**: _________________________________ (or N/A with reason)

---

## Client Sign-Off

I, the undersigned, confirm that:
1. I reviewed the recorded UAT results for the tested build and listed acceptance criteria
2. I understand the remaining defects, residual risks, and approved exceptions recorded above
3. My decision is the GO / NO-GO / PENDING decision selected above
4. A GO permits progression to M10 release approval; this UAT record alone does not authorize production deployment

**Client PIC Name**: _________________________________  
**Signature**: _________________________________  
**Date**: _________________________________

---

## Developer Acknowledgment

I confirm that:
1. All S1/S2 bugs identified during UAT have been fixed
2. The recorded UAT decision and residual risks are accurately reflected above
3. Any deferred defect has an owner, target date, and authorized disposition; deployment still requires M10 approval

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
- Test cases passed: [count]
- Unresolved release-blocking defects: [count]
- Decision: [GO / NO-GO / PENDING]
- Residual risks and authorized exceptions: [list or none]

Signed: [Client Name]
Date: [Today's Date]
```

**Developer**: Save this email as PDF for records.

---

## Next Steps After Sign-Off

Once UAT is approved:
1. **Developer**: Complete M10 release approval and deployment steps; UAT sign-off alone does not authorize deployment
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
> **Rule (M09-LITE)**: Follow M09 scale/delivery routing. For solo/internal delivery, record one named self-tester; an external tester is recommended when available. Client delivery still requires the Client Single PIC's approval.

**External Tester Name**: _________________________________
**Relationship**: [colleague / friend / target-user proxy]
**Test Date**: [YYYY-MM-DD]

**Solo Test Summary**:
- Total Test Cases: _____
- Test Cases Passed: _____
- Critical (S1) Bugs Remaining: _____ (must be 0)

**Solo UAT Decision**:
- [ ] **GO** - In-scope P0 criteria pass, no unresolved blocker, residual risks dispositioned
- [ ] **NO-GO / PENDING** - Gaps remain; production release stays blocked

**Machine Validation Line** (required for M09-LITE gate):
```
UAT-Decision: PASS
External-Tester: [Full Name]
```
