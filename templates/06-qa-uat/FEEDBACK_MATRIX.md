# UAT Feedback Prioritization Matrix

> **Purpose**: Triage and prioritize client feedback from UAT (M09)  
> **When**: After UAT testing, before final fixes  
> **Duration**: 1-2 hours review meeting  
> **Output**: Action plan (fix now / negotiate / quote separately)

---

## Feedback Categories

Every UAT feedback item falls into one of 6 categories:

| Category | Definition | Action |
|:---------|:-----------|:-------|
| **Bug** | Something broken that should work | Fix for free (covered in scope) |
| **Enhancement** | Improvement to existing feature | Evaluate if in scope |
| **Change Request (CR)** | New feature or major change | Separate quote (out of scope) |
| **User Error** | Misunderstanding how feature works | Training / documentation |
| **Won't Fix** | Not feasible or reasonable | Decline with explanation |
| **Future** | Good idea, but Phase 2 | Backlog for later |

---

## Priority Matrix

### Fix Now (Pre-Launch)

**Criteria**: Blocks launch or severely impacts usability

**Categories that qualify**:
- ✅ S1/S2 Bugs (critical/high severity)
- ✅ Enhancement if <4 hours work AND in scope
- ❌ Change Requests (never fix now, always quote)

**Examples**:
- Login fails with correct password → Fix now (S1 bug)
- Form validation too strict, rejects valid input → Fix now (S2 bug)
- Button text says "Submit" but should say "Save" → Fix now (<1 hour)

**Timeline Impact**: 0-2 days

---

### Negotiate (Post-Launch or Defer)

**Criteria**: Nice to have, not launch-blocking, in scope gray area

**Categories that qualify**:
- ✅ S3 Bugs (medium severity)
- ✅ Enhancement if in scope but >4 hours work
- ❌ Change Requests (quote separately)

**Examples**:
- Export CSV has extra comma → Negotiate (can fix manually)
- Add "Select All" checkbox → Negotiate (nice UX, but 6 hours work)
- Dashboard loads slow (4s) → Negotiate (works, just slow)

**Options**:
1. Fix post-launch (within warranty 30 days)
2. Defer to Phase 2
3. Quote as separate mini-project

**Timeline Impact**: +3-7 days (if accepted)

---

### Quote Separately (Change Request)

**Criteria**: New feature or major change outside original scope

**Categories that qualify**:
- ✅ Change Request (CR)
- ✅ Enhancement if fundamentally different from spec
- ❌ Bugs (never charge for bugs)

**Examples**:
- Add SMS notifications (originally email-only) → Quote
- Add dark mode (not in original mockups) → Quote
- Integrate with QuickBooks (not in scope) → Quote
- Redesign entire dashboard layout → Quote

**Process**:
1. Client requests CR during UAT
2. Dev estimates cost + timeline
3. Client decides: Accept (new quote) or Defer (Phase 2)
4. If accepted: Update SOW addendum, adjust timeline/payment

**Timeline Impact**: Variable (usually +1-4 weeks)

---

## Decision Tree

```
UAT Feedback Item
│
├─ Is it broken? (should work but doesn't)
│  ├─ YES → Bug
│  │  ├─ S1/S2 → Fix Now
│  │  └─ S3/S4 → Negotiate (post-launch)
│  └─ NO → Continue
│
├─ Is it in original scope?
│  ├─ YES → Enhancement
│  │  ├─ <4 hours → Fix Now
│  │  └─ >4 hours → Negotiate
│  └─ NO → Change Request (Quote Separately)
│
├─ Is it user misunderstanding?
│  └─ YES → User Error (training/docs)
│
├─ Is it technically feasible?
│  └─ NO → Won't Fix (explain why)
│
└─ Good idea but not urgent?
   └─ YES → Future (Phase 2 backlog)
```

---

## Feedback Triage Meeting (1-2 hours)

**Attendees**: Tech lead, QA, PM (optional: client)

**Agenda**:

### Part 1: Categorize (30 min)
- Go through each feedback item
- Assign category: Bug / Enhancement / CR / User Error / Won't Fix / Future

### Part 2: Prioritize (30 min)
- Bugs → S1/S2 = Fix Now, S3/S4 = Negotiate
- Enhancements → <4h = Fix Now, >4h = Negotiate
- CRs → Quote separately

### Part 3: Respond to Client (30 min)
- Draft response email
- Explain categorization
- Propose action plan

---

## Example: Filled Feedback Matrix

**Project**: Inventory Management System  
**UAT Period**: Dec 1-5, 2024  
**Feedback Items**: 12  
**Triage Date**: Dec 6, 2024

---

### FIX NOW (Pre-Launch) - 3 items, 6 hours

| Item | Feedback | Category | Severity | Action | Est. |
|:-----|:---------|:---------|:---------|:-------|:-----|
| #1 | Barcode scan fails on iPhone Safari | Bug | S1 | Fix now | 3h |
| #2 | Low stock alert not sending emails | Bug | S2 | Fix now | 2h |
| #3 | Button says "Submit" should be "Save" | Enhancement | - | Fix now | 1h |

**Timeline Impact**: +1 day (Dec 7)

---

### NEGOTIATE (Post-Launch or Defer) - 4 items

| Item | Feedback | Category | Reason | Proposal |
|:-----|:---------|:---------|:-------|:---------|
| #4 | CSV export has extra comma | Bug (S3) | Works, just annoying | Fix post-launch (Day 3 of warranty) |
| #5 | Add "Select All" checkbox | Enhancement | Nice UX, 6h work | Fix post-launch (Day 7 of warranty) |
| #6 | Dashboard slow (4s load) | Bug (S3) | Works, but slow | Optimize post-launch (Day 10 of warranty) |
| #7 | Add product images | Enhancement | Nice feature, 8h work | Defer to Phase 2 (quote Rp 5M) |

**Timeline Impact**: 0 days (launch on schedule), fix during warranty

---

### QUOTE SEPARATELY (Change Requests) - 3 items

| Item | Feedback | Reason | Quote | Timeline |
|:-----|:---------|:-------|:------|:---------|
| #8 | Add SMS alerts | Not in scope (email only) | Rp 8M | +1 week |
| #9 | Integrate QuickBooks | Out of scope | Rp 20M | +3 weeks |
| #10 | Multi-warehouse support | Phase 2 feature | Rp 30M | +5 weeks |

**Decision**: Client defers all 3 to Phase 2 (2025 Q1)

---

### USER ERROR (Training) - 1 item

| Item | Feedback | Reality | Action |
|:-----|:---------|:--------|:-------|
| #11 | "Can't delete products" | Can delete, just need Admin role | Add to user guide, train staff |

---

### WON'T FIX - 1 item

| Item | Feedback | Reason | Explanation |
|:-----|:---------|:-------|:------------|
| #12 | Support Internet Explorer 11 | IE11 deprecated (2022), 0.1% users | Not feasible, recommend Chrome/Edge/Safari |

---

## Response to Client

**Email Template**:

```
Subject: UAT Feedback Review - Action Plan

Hi [Client Name],

Thanks for thorough UAT testing! We reviewed all 12 feedback items.
Here's our action plan:

FIX NOW (Pre-Launch) - 3 items:
✅ #1: Barcode scan iPhone bug → Fixing today
✅ #2: Email alerts not sending → Fixing today
✅ #3: Button text correction → Fixing today

Total: 6 hours, launching Dec 7 (1 day delay)

---

NEGOTIATE (Post-Launch or Defer) - 4 items:

Option A: Fix during warranty (30 days)
- #4: CSV export extra comma (Day 3)
- #5: Select All checkbox (Day 7)
- #6: Dashboard performance (Day 10)

Option B: Defer to Phase 2
- #7: Product images (quote: Rp 5M, +1 week)

Recommendation: Fix #4-6 during warranty (no cost), defer #7 to Phase 2.

---

CHANGE REQUESTS (Quote Separately) - 3 items:

| Feature | Quote | Timeline |
| SMS alerts | Rp 8M | +1 week |
| QuickBooks sync | Rp 20M | +3 weeks |
| Multi-warehouse | Rp 30M | +5 weeks |

You mentioned deferring these to 2025 Q1. We can revisit then.

---

USER ERROR / WON'T FIX - 2 items:

#11: "Can't delete" → Need Admin role (will train staff)
#12: IE11 support → Not feasible (IE deprecated), use Chrome/Edge

---

SUMMARY:

Launch: Dec 7 (1 day delay for 3 critical fixes)
Post-launch: Fix #4-6 during warranty (Days 3, 7, 10)
Phase 2 (2025 Q1): #7-10 (separate quotes)

Agree with this plan? Reply to confirm and we'll proceed.

Best,
[Your Name]
```

---

## Feedback Matrix Rules

### Rule 1: Bugs are Always Free
**Why**: Client paid for working software, bugs are vendor's responsibility

**Exception**: If client changes requirements mid-project, "bug" might be CR.

**Example**:
- Original spec: "Export to CSV"
- UAT feedback: "Export is missing columns A, B, C"
- Reality: Columns A, B, C were never in spec → CR, not bug

---

### Rule 2: Enhancements <4 Hours = Goodwill Fix
**Why**: Small tweaks build trust, cost <1% of project

**Examples** (fix for free):
- Change button color
- Adjust spacing
- Reword error message
- Add field label

---

### Rule 3: Scope Creep ≠ Enhancement
**Why**: "Just one more feature" destroys timeline

**Pattern**:
- Original: List products
- UAT: "Can we add advanced filters?" → Enhancement? No, CR!

**Test**: Was it in MoSCoW matrix?
- YES → Enhancement (evaluate effort)
- NO → Change Request (quote)

---

### Rule 4: Communicate Timeline Impact
**Why**: Client needs to understand tradeoffs

**Example**:
```
You requested 5 enhancements during UAT.
Options:
A) Fix all 5 → Launch Dec 15 (+1 week delay)
B) Fix critical 2 → Launch Dec 8 (on schedule)
C) Fix all 5 post-launch → Launch Dec 8, updates Day 10-15

Recommendation: Option C (launch on time, polish during warranty)
```

---

## Common Scenarios

### Scenario 1: Client Says "But this is obvious!"
**Client**: "Of course it should have SMS alerts, that's obvious!"  
**Reality**: Not in spec, not quoted, not built.

**Response**:
```
I understand SMS would be valuable. However, original scope specified
email alerts only (see SOW Section 2, Item 4).

SMS requires:
- Twilio integration (Rp 3M setup)
- Per-message costs (Rp 500/SMS)
- 1 week development

Happy to add as Phase 2. Quote: Rp 8M + ongoing SMS costs.
```

---

### Scenario 2: Too Much Feedback
**Problem**: Client reports 50+ items during UAT

**Response**:
1. Categorize all 50 items
2. Show impact: "Fixing all 50 = 4 weeks delay + Rp 20M cost"
3. Force prioritization: "Pick top 5 must-fix items"
4. Defer rest to post-launch or Phase 2

---

### Scenario 3: Client Refuses to Pay for CR
**Client**: "This should be included!"  
**Reality**: It's clearly out of scope.

**Response**:
```
I've reviewed the original MoSCoW matrix and SOW.
[Feature X] was not included (see attached docs).

Two options:
A) Add to current scope → Update SOW, adjust timeline/budget
B) Defer to Phase 2 → Separate quote after launch

Cannot proceed without signed SOW addendum (if Option A).
```

**If client insists**: Stand firm or walk away (scope creep kills projects).

---

## Integration with Workflow

**M09 UAT**:
1. Client tests (5 days)
2. Client submits feedback (DEMO_FEEDBACK_FORM.md)
3. Dev triages feedback (this matrix)
4. Dev responds with action plan (email template above)
5. Client approves plan
6. Dev fixes "Fix Now" items
7. Launch
8. Dev fixes "Negotiate" items during warranty

---

## Tools

**Feedback Tracking**:
- Spreadsheet (this matrix)
- Notion database
- Linear/Jira issues
- Google Form → Sheet

**Categorization**:
- Label: Bug-S1, Bug-S2, Enhancement, CR, User-Error, Won't-Fix, Future

---

## Checklist

After UAT:
- [ ] All feedback items categorized
- [ ] Effort estimated for each item
- [ ] Timeline impact calculated
- [ ] Response email drafted
- [ ] Client approves action plan

Before launch:
- [ ] "Fix Now" items complete
- [ ] "Negotiate" items scheduled (warranty or Phase 2)
- [ ] "Quote" items documented for future
- [ ] "User Error" items added to user guide

---

## Notes

**Feedback is not a wish list**: Just because client wants it doesn't mean you build it.

**Scope is sacred**: Original MoSCoW + SOW defines scope. Everything else = CR.

**Warranty ≠ Free labor**: Warranty covers bugs, not new features.

**Communicate often**: Weekly update on post-launch fixes builds trust.
