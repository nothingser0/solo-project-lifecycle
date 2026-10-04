# Demo Feedback Form (M06.2)

> **Purpose**: Capture structured feedback after client demo  
> **Duration**: Client fills in 10-15 minutes  
> **When**: After each demo (within 3 days)  
> **Format**: Google Form or document

---

## Demo Information

**Demo Number**: Demo #___  
**Sprint**: Sprint #___  
**Demo Date**: [YYYY-MM-DD]  
**Features Shown**:
- [Feature 1]
- [Feature 2]
- [Feature 3]

**Feedback Due**: [Date] (3 days after demo)

---

## Section 1: Overall Impression

**How satisfied are you with the features demonstrated?**

☐ Very Satisfied (5/5) - Exceeds expectations  
☐ Satisfied (4/5) - Meets expectations  
☐ Neutral (3/5) - Some concerns  
☐ Unsatisfied (2/5) - Below expectations  
☐ Very Unsatisfied (1/5) - Major concerns

**Comments**:
_________________________________

---

## Section 2: Feature-Specific Feedback

### Feature 1: [Feature Name]

**Does this feature work as expected?**  
☐ Yes, perfect  
☐ Yes, with minor tweaks  
☐ No, needs changes

**What works well?**  
_________________________________

**What needs improvement?**  
_________________________________

**Priority**: ☐ Must fix ☐ Should fix ☐ Nice to have

---

### Feature 2: [Feature Name]

[Repeat format above]

---

### Feature 3: [Feature Name]

[Repeat format above]

---

## Section 3: Usability Questions

**Is the interface intuitive?**  
☐ Very easy to use  
☐ Easy with some learning  
☐ Confusing in places  
☐ Very confusing

**Specific confusing areas**:
_________________________________

---

**Is the workflow logical?**  
☐ Very logical  
☐ Mostly logical  
☐ Some steps confusing  
☐ Needs redesign

**What steps are confusing?**:
_________________________________

---

**Is the visual design acceptable?**  
☐ Looks great  
☐ Acceptable  
☐ Needs polish  
☐ Needs redesign

**Design feedback**:
_________________________________

---

## Section 4: Missing or Incorrect Functionality

**Did you notice anything missing that should be there?**

| What's Missing | Why It's Needed | Priority |
|:---------------|:----------------|:---------|
| [Item 1] | [Reason] | ☐ Must ☐ Should ☐ Could |
| [Item 2] | [Reason] | ☐ Must ☐ Should ☐ Could |
| [Item 3] | [Reason] | ☐ Must ☐ Should ☐ Could |

---

**Did you notice anything that works incorrectly?**

| What's Wrong | Expected Behavior | Severity |
|:-------------|:------------------|:---------|
| [Bug 1] | [Should do X] | ☐ Critical ☐ High ☐ Medium ☐ Low |
| [Bug 2] | [Should do X] | ☐ Critical ☐ High ☐ Medium ☐ Low |
| [Bug 3] | [Should do X] | ☐ Critical ☐ High ☐ Medium ☐ Low |

**Severity Guide**:
- **Critical**: Blocks major functionality, must fix before launch
- **High**: Major feature broken, workaround exists
- **Medium**: Minor bug, doesn't block usage
- **Low**: Cosmetic issue, polish

---

## Section 5: New Requests or Changes

**Any new features you'd like to add?**

| New Feature | Why It's Needed | In Scope? |
|:------------|:----------------|:----------|
| [Feature A] | [Business reason] | ☐ Yes ☐ No ☐ Unsure |
| [Feature B] | [Business reason] | ☐ Yes ☐ No ☐ Unsure |

**Note**: Features marked "No" = out of scope = separate quote

---

**Any existing features you'd like changed?**

| Feature to Change | Current Behavior | Desired Behavior |
|:------------------|:-----------------|:-----------------|
| [Feature X] | [Does A] | [Should do B] |
| [Feature Y] | [Does A] | [Should do B] |

---

## Section 6: Scope Clarification

**For each item above, developer will categorize**:

| Item | Category | Action |
|:-----|:---------|:-------|
| [Item 1] | ☐ Bug (covered) ☐ Enhancement (in scope) ☐ CR (out of scope) | [Fix/Quote/Defer] |
| [Item 2] | ☐ Bug ☐ Enhancement ☐ CR | [Fix/Quote/Defer] |
| [Item 3] | ☐ Bug ☐ Enhancement ☐ CR | [Fix/Quote/Defer] |

**Category Definitions**:
- **Bug**: Something that should work but doesn't → Fix for free
- **Enhancement**: Improvement to existing scope → Depends on impact
- **Change Request (CR)**: New feature or major change → Separate quote

---

## Section 7: Questions or Concerns

**Do you have any questions about what you saw?**  
_________________________________

**Any concerns about meeting the launch deadline?**  
_________________________________

**Anything else we should know?**  
_________________________________

---

## Section 8: Approval for Next Sprint

**Are you comfortable with us proceeding to next sprint?**  
☐ Yes, proceed as planned  
☐ Yes, but please address [specific items] first  
☐ No, let's discuss changes before continuing

**If "No", what needs to change?**:
_________________________________

---

## Section 9: Next Demo Preferences

**Next demo scheduled**: [Date]

**Preferred demo format**:  
☐ Live call (current format)  
☐ Screen recording only (async)  
☐ Live call + recording

**Preferred demo day/time**:  
_________________________________

---

---

## For Developer: How to Use This Form

### Step 1: Send Form After Demo (Within 1 Hour)

**Email Template**:
```
Subject: Demo Feedback - Sprint X

Hi [Client Name],

Thanks for joining the demo! Please share your feedback:
[Link to this form or Google Form]

Deadline: [Date] (3 days from now)

Your feedback helps us prioritize fixes and improvements for next sprint.

Questions? Reply to this email.

Best,
[Your Name]
```

---

### Step 2: Review Feedback (Within 24 Hours of Receiving)

**Triage Process**:

1. **Categorize Each Item**:
   - Bug → Add to bug tracker (Jira, Linear)
   - Enhancement (in scope) → Add to backlog
   - CR (out of scope) → Create quote

2. **Prioritize**:
   - Must fix: Critical bugs → Sprint N+1
   - Should fix: High/Medium bugs → Sprint N+1 or N+2
   - Nice to have: Low bugs → Backlog
   - Out of scope: Quote separately

3. **Respond to Client**:
   - Acknowledge feedback received
   - Share categorization
   - Propose action plan

---

### Step 3: Respond to Client (Within 48 Hours)

**Response Email Template**:
```
Subject: Re: Demo Feedback - Sprint X

Hi [Client Name],

Thanks for the detailed feedback! Here's how we'll address it:

BUGS (Will Fix):
1. [Bug A] - Critical → Fixing in Sprint N+1
2. [Bug B] - High → Fixing in Sprint N+1
3. [Bug C] - Low → Added to backlog

ENHANCEMENTS (In Scope):
1. [Enhancement A] - Adding to Sprint N+2
2. [Enhancement B] - Added to backlog

OUT OF SCOPE (Change Requests):
1. [Feature X] - Not in original scope → Quote: Rp 10M, +1 week
2. [Feature Y] - Major redesign → Quote: Rp 20M, +2 weeks

Want to proceed with CRs? Let's schedule a call to discuss.

Next sprint we'll focus on:
- Fixing critical bugs from your feedback
- [Planned features]

Next demo: [Date]

Best,
[Your Name]
```

---

## Feedback Analysis

**After 3-5 demos, analyze patterns**:

### Common Issues
- What bugs appear repeatedly?
- What features confuse users?
- What requests are most frequent?

### Metrics to Track
- Average satisfaction score
- Bug count per demo (decreasing = good)
- CR count per demo (high = scope unclear)
- Feedback turnaround time (goal: <3 days)

---

## Example: Filled Feedback Form

```
Demo #4 Feedback
Sprint #4
Demo Date: October 11, 2024
Features: Invoice creation, Email sending, Status tracking

---

OVERALL IMPRESSION:
Satisfaction: ⭐⭐⭐⭐ (4/5) - Satisfied

Comments: "Great progress! Invoice creation works smoothly. 
Email feature is exactly what we need. Minor tweaks needed."

---

FEATURE FEEDBACK:

Feature 1: Invoice Creation
Works as expected? Yes, with minor tweaks

What works well: "Auto-calculation is perfect. UI is clean."

What needs improvement: "Need discount field (we offer 10-20% discounts)"

Priority: Should fix

---

Feature 2: Email Sending
Works as expected? Yes, perfect

What works well: "PDF looks professional. Email delivery fast."

What needs improvement: "None, this is great!"

Priority: N/A

---

Feature 3: Status Tracking
Works as expected? Yes, with minor tweaks

What works well: "Status badges clear. Filters work."

What needs improvement: "Would be nice to see payment date, not just status"

Priority: Nice to have

---

USABILITY:

Interface: Easy to use ✓
Workflow: Very logical ✓
Visual design: Acceptable ✓

Design feedback: "Could use more color contrast on buttons"

---

MISSING FUNCTIONALITY:

| What's Missing | Why Needed | Priority |
| Discount field | We offer 10-20% discounts | Must |
| Payment date tracking | Know when client paid | Should |
| Invoice templates | Customize for clients | Could |

---

BUGS:

| Bug | Expected | Severity |
| Tax calculation wrong for 0% | Should show 0, shows blank | Medium |
| Email preview cuts off long items | Should wrap text | Low |

---

NEW REQUESTS:

| Feature | Why | In Scope? |
| Recurring invoices | Monthly clients | No |
| Multi-currency support | International clients | No |

---

SCOPE CLARIFICATION (Developer):

| Item | Category | Action |
| Discount field | Enhancement (in scope) | Add Sprint 5 |
| Payment date | Enhancement (in scope) | Add Sprint 6 |
| Tax calculation bug | Bug | Fix Sprint 5 |
| Email preview bug | Bug | Fix Sprint 5 |
| Recurring invoices | CR (out of scope) | Quote: Rp 15M |
| Multi-currency | CR (out of scope) | Quote: Rp 20M |

---

QUESTIONS:
"Can we change invoice numbering format? We use INV-2024-001"

CONCERNS:
"None, on track for December launch"

APPROVAL:
✓ Yes, proceed with Sprint 5 (please add discount field)

NEXT DEMO:
Preferred format: Live call + recording
Preferred time: Fridays, 3 PM
```

---

## Integration with Workflow

**Demo → Feedback → Action Cycle**:

1. **Friday**: Sprint demo
2. **Friday-Monday**: Client fills feedback form
3. **Tuesday**: Dev reviews and categorizes
4. **Wednesday**: Dev responds with action plan
5. **Thursday-Friday**: Dev updates backlog for next sprint
6. **Next Monday**: Sprint planning includes feedback items

**Feedback Loop**:
- Demo every 2 weeks
- Feedback within 3 days
- Action plan within 48 hours
- Fixes in next 1-2 sprints

---

## Tools

**Form Creation**:
- Google Forms (easiest)
- Typeform (prettier)
- Notion (embedded)
- Email (simple doc)

**Feedback Tracking**:
- Spreadsheet (simple)
- Notion database (organized)
- Jira/Linear (integrated with dev workflow)

---

## Feedback Form Checklist

Before sending:
- [ ] Form link works
- [ ] All features listed
- [ ] Deadline clear (3 days)
- [ ] Sent within 1 hour of demo

After receiving:
- [ ] Reviewed within 24 hours
- [ ] Items categorized
- [ ] Response sent within 48 hours
- [ ] Backlog updated

---

## Notes

**Feedback timing matters**: Send immediately after demo (while fresh in client's mind)

**Make it easy**: Google Form > long document

**Follow up**: If no response in 3 days, gentle reminder

**Act on feedback**: Show client you listen (builds trust)
