# UAT Training Script Template

> **Purpose**: Train client team for UAT testing (M09)  
> **When**: Before UAT phase starts  
> **Duration**: 1-2 hour training session  
> **Target**: Large/Enterprise projects with multiple client testers

---

## UAT Training Agenda (90 minutes)

### Part 1: Introduction (15 min)
- What is UAT?
- Why client testing matters
- Training objectives
- Q&A expectations

### Part 2: System Overview (20 min)
- Login and navigation
- Key features demo
- User roles and permissions

### Part 3: Testing Process (30 min)
- How to test (step-by-step)
- How to report bugs
- Bug severity guidelines
- UAT workbook walkthrough

### Part 4: Hands-On Practice (20 min)
- Test a sample feature
- Report a sample bug
- Q&A

### Part 5: Next Steps (5 min)
- UAT timeline and expectations
- Support contact info

---

## Training Script

### Opening (5 min)

**Script**:
```
Good morning everyone! Thanks for joining this UAT training session.

I'm [Your Name], the developer working on [Project Name]. 

Today we'll cover:
1. What UAT is and why your testing is critical
2. How to navigate the system
3. How to test features properly
4. How to report issues

The training will take about 90 minutes. Feel free to ask questions anytime.

Let's get started!
```

---

### What is UAT? (10 min)

**Script**:
```
UAT stands for User Acceptance Testing. It's the final testing phase
before we launch the system to production.

Why is YOUR testing important?

1. You know the business process better than anyone
   - You'll catch issues developers might miss
   - You understand real-world workflows

2. This is your chance to request changes
   - After launch, changes become expensive
   - Now is the time to speak up

3. You're signing off that the system works
   - Your approval means we can launch
   - Your feedback helps us fix problems early

What UAT is NOT:
❌ Not trying to break the system on purpose
❌ Not requesting brand new features (that's a change request)
✅ Verifying the system does what we agreed in the requirements
```

**Slide**:
```
┌─────────────────────────────────────────┐
│         What is UAT?                    │
├─────────────────────────────────────────┤
│ ✓ Test if system meets requirements     │
│ ✓ Verify business workflows work        │
│ ✓ Find bugs before production launch    │
│                                         │
│ ✗ NOT trying to break the system       │
│ ✗ NOT requesting new features          │
└─────────────────────────────────────────┘
```

---

### System Overview (20 min)

**Script**:
```
Let me show you the system. I'll share my screen.

[Share screen showing staging URL]

This is the staging environment. It looks identical to production,
but it's safe to experiment here. You can't break anything!

Staging URL: https://staging.yourapp.com
(I'll send credentials after this session)

Let's walk through the main features...
```

**Demo Flow**:

1. **Login**
   ```
   First, logging in.
   
   [Enter email and password]
   
   Notice the "Remember me" checkbox. If checked, you stay logged in
   for 7 days. Otherwise, you'll need to log in again after closing
   the browser.
   
   [Click Login]
   
   Now we're on the dashboard.
   ```

2. **Dashboard**
   ```
   The dashboard shows:
   - Total orders this month (top left)
   - Recent orders (center)
   - Low stock alerts (right sidebar)
   
   Click any order to see details.
   ```

3. **Key Features**
   ```
   [Demo each key feature for 2-3 minutes]
   
   Feature 1: Create Order
   - Click "New Order"
   - Fill customer info
   - Add products (shows autocomplete)
   - Submit
   - Shows success message + order ID
   
   Feature 2: Manage Inventory
   - Click "Inventory" menu
   - Search for product
   - Update stock quantity
   - Save
   
   [Continue for all Must Have features]
   ```

**Questions to ask**:
```
Does this match your expectations?
Is anything confusing or unclear?
Any questions so far?
```

---

### Testing Process (30 min)

#### How to Test

**Script**:
```
Now, HOW to test properly.

You'll receive a UAT Workbook with 15-20 test cases.
Each test case has:
1. Feature name (e.g., "Create Order")
2. Steps to follow
3. Expected result
4. Pass/Fail checkbox
5. Notes field (for issues)

Let me show you an example...
```

**Example Test Case**:
```
┌─────────────────────────────────────────────────────────┐
│ Test Case #1: Create Order                              │
├─────────────────────────────────────────────────────────┤
│ Steps:                                                   │
│ 1. Log in as Admin                                       │
│ 2. Click "New Order"                                     │
│ 3. Enter customer: "John Doe"                            │
│ 4. Add product: "Widget A" (quantity: 2)                 │
│ 5. Click "Submit"                                        │
│                                                          │
│ Expected Result:                                         │
│ - Success message appears                                │
│ - Order ID shown (e.g., ORD-001)                         │
│ - Order appears in "Recent Orders" list                  │
│                                                          │
│ Result: [ ] Pass  [ ] Fail                               │
│ Notes: ______________________________________            │
└─────────────────────────────────────────────────────────┘
```

**Script**:
```
How to test this:

Step 1: Follow the steps EXACTLY as written
- Don't skip steps
- Don't add extra steps
- Use the exact data mentioned (e.g., "John Doe")

Step 2: Compare actual result to expected result
- Does success message appear? ✓ or ✗
- Is order ID shown? ✓ or ✗
- Does order appear in list? ✓ or ✗

Step 3: Mark Pass or Fail
- Pass: All expected results match
- Fail: Any expected result doesn't match

Step 4: Write notes if Fail
- Describe what went wrong
- Screenshot if possible (Ctrl+Shift+S in Windows)
```

---

#### How to Report Bugs

**Script**:
```
If a test case fails, you found a bug! Here's how to report it.

Use the Bug Report Form I'll send you. Fill in:

1. Bug Title (1 sentence summary)
   Good: "Submit button not working on Create Order page"
   Bad: "It's broken"

2. Steps to Reproduce
   List exactly what you did to trigger the bug.
   
3. Expected vs Actual
   Expected: Success message appears
   Actual: Nothing happens, button just spins forever

4. Screenshot/Video
   Use Windows Snipping Tool (Win+Shift+S)
   Or record with Loom (I'll share link)

5. Severity
   S1 Critical: Can't use the system at all
   S2 High: Major feature broken, but workaround exists
   S3 Medium: Minor issue, doesn't block work
   S4 Low: Cosmetic issue (typo, spacing)
```

**Example Bug Report**:
```
Title: Submit button not working on Create Order page

Steps to Reproduce:
1. Log in as admin@example.com
2. Click "New Order"
3. Fill customer: "John Doe"
4. Add product: "Widget A" (qty: 2)
5. Click "Submit"

Expected: Success message + order ID shown
Actual: Button shows loading spinner forever, no error message

Severity: S2 High (can't create orders, workaround: use mobile app)

Screenshot: [attached]
```

---

#### Bug Severity Guidelines

**Script**:
```
How to decide severity?

S1 - Critical (Fix immediately):
- Can't log in at all
- System crashes
- Data loss
- Security issue
Example: "Login fails for all users"

S2 - High (Fix before launch):
- Major feature broken
- Workaround exists but slow
Example: "Create Order button broken (can use API directly)"

S3 - Medium (Fix if time allows):
- Minor bug, doesn't block work
- UI glitch
Example: "Date picker shows wrong year initially (can correct manually)"

S4 - Low (Nice to fix):
- Typo, spacing, cosmetic
- Very rare edge case
Example: "Button text says 'Submitt' (extra t)"

When in doubt, mark S2. We'll reclassify if needed.
```

---

### Hands-On Practice (20 min)

**Script**:
```
Now let's practice! I'll give you 15 minutes to test Feature X.

Everyone open staging: https://staging.yourapp.com
Login with test accounts (retrieved securely from password manager vault, NEVER pasted into chat):
- User 1: tester1@example.com / <REPLACE_ME_TEST_ACCOUNT_PASSWORD>
- User 2: tester2@example.com / <REPLACE_ME_TEST_ACCOUNT_PASSWORD>
- User 3: tester3@example.com / <REPLACE_ME_TEST_ACCOUNT_PASSWORD>

Task: Test "Create Order" feature
Follow Test Case #1 in the UAT Workbook (link in chat)

I'll be here to answer questions.

[Give 15 minutes for hands-on practice]

[After 15 minutes]

Great! Did everyone complete the test?
Any questions or issues?

[Answer questions]

[Ask someone to share their screen and demo bug reporting]

Perfect! That's exactly how to do it.
```

---

### Next Steps (5 min)

**Script**:
```
Excellent work everyone! Here's what happens next:

1. UAT Testing Period: October 7-11 (5 business days)
   - Test at your own pace
   - Aim to complete all test cases
   - Report bugs as you find them

2. Support During UAT:
   - Slack channel: #uat-testing (I'll add you)
   - Email: dev@example.com
   - Response time: <4 hours during business hours

3. Deliverables:
   - Completed UAT Workbook (all test cases marked Pass/Fail)
   - Bug reports (via form)
   - Final sign-off (if all critical bugs fixed)

4. What I'll Do:
   - Fix S1/S2 bugs during UAT period
   - Respond to questions within 4 hours
   - Send daily progress update

5. After UAT:
   - We review all feedback
   - Fix remaining bugs
   - Schedule production launch

Any questions?

[Answer questions]

Great! I'll send you:
- UAT Workbook (Google Sheets)
- Bug Report Form (Google Form)
- Staging credentials (1Password link)
- Loom recording of this training

Thanks for your time! Looking forward to your feedback.
```

---

## Training Materials to Send

### Email Template (Post-Training)

```
Subject: UAT Training - Materials & Next Steps

Hi UAT Team,

Thanks for attending today's training session!

TRAINING RECORDING:
[Loom link - 90 min recording]

UAT MATERIALS:
1. UAT Workbook: [Google Sheets link]
2. Bug Report Form: [Google Form link]
3. Staging Credentials: [1Password share link]

UAT PERIOD:
Start: Oct 7, 9 AM
End: Oct 11, 5 PM
(5 business days)

SUPPORT:
- Slack: #uat-testing
- Email: dev@example.com
- Response time: <4 hours

DELIVERABLES:
Please complete by Oct 11:
- [ ] All test cases tested (Pass/Fail marked)
- [ ] Bugs reported via form
- [ ] Final sign-off (if all S1/S2 bugs fixed)

DAILY CHECK-IN:
I'll send daily summary:
- Bugs reported
- Bugs fixed
- Outstanding issues

Questions? Reply to this email or ping me on Slack.

Thanks!
[Your Name]
```

---

## UAT Workbook Template

**Google Sheets structure**:

| Test ID | Feature | Steps | Expected Result | Pass/Fail | Notes | Severity | Screenshot |
|:--------|:--------|:------|:----------------|:----------|:------|:---------|:-----------|
| TC-01 | Login | 1. Open app<br>2. Enter email<br>3. Click Login | Dashboard appears | [ ] Pass<br>[ ] Fail | | | |
| TC-02 | Create Order | ... | ... | [ ] Pass<br>[ ] Fail | | | |

---

## Troubleshooting Common Questions

**Q: "I forgot my password, how do I reset?"**  
A: Click "Forgot Password" on login page, or I can reset it manually.

**Q: "Staging is down, I can't access it"**  
A: Let me check... [verify staging status]. If down, I'll fix within 1 hour.

**Q: "Is this a bug or expected behavior?"**  
A: [Compare to requirements doc]. If not documented, report it as potential bug.

**Q: "I found 20 bugs, is that too many?"**  
A: Great! That's exactly what UAT is for. Report them all.

**Q: "Should I test on mobile?"**  
A: Yes, if mobile is in scope. Test on your actual phone (not just browser resize).

---

## Checklist

Before training:
- [ ] Staging environment working
- [ ] Test accounts created
- [ ] UAT Workbook prepared
- [ ] Bug Report Form created
- [ ] Training slides ready
- [ ] Screen share tested

During training:
- [ ] Record session (Loom/Zoom)
- [ ] Demo each key feature
- [ ] Walk through test case example
- [ ] Hands-on practice (15 min)
- [ ] Answer all questions

After training:
- [ ] Send recording + materials within 1 hour
- [ ] Add team to Slack channel
- [ ] Share staging credentials
- [ ] Set up daily check-in reminder

---

## Notes

**Training tone**: Patient, encouraging, not condescending

**Keep it simple**: Avoid technical jargon

**Record everything**: Clients forget, recording helps

**Hands-on is critical**: Practice beats slides every time
