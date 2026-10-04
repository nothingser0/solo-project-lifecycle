# Client Demo Script (M06.2)

> **Purpose**: Structure for bi-weekly client demos during development  
> **Duration**: 10-15 minutes  
> **When**: Mid-sprint or end-of-sprint (every 2 weeks)  
> **Target**: Medium/Large projects with client involvement

---

## Demo Information

**Demo Number**: Demo #___  
**Sprint**: Sprint #___  
**Date**: [YYYY-MM-DD]  
**Attendees**: 
- Client: _________________________________
- Team: _________________________________

---

## Pre-Demo Checklist

**24 Hours Before Demo**:
- [ ] Features deployed to staging environment
- [ ] Staging URL tested and working
- [ ] Test data seeded (realistic examples)
- [ ] Demo script prepared (this document)
- [ ] Screen recording backup (in case staging fails)
- [ ] Calendar invite sent with staging URL

**1 Hour Before Demo**:
- [ ] Log into staging, verify everything works
- [ ] Close unnecessary browser tabs
- [ ] Clear browser cache/cookies
- [ ] Test screen share (video + audio)
- [ ] Have fallback plan ready (screen recording)

---

## Demo Structure (10-15 min)

### Part 1: Recap (1 min)
**Script**:
```
"Good morning! Today I'll show you what we completed in Sprint X.
Quick recap: Last demo we showed [previous features].
This sprint we focused on [current sprint goal].
Let me walk you through..."
```

---

### Part 2: Feature Walkthrough (7-10 min)

**Show, Don't Tell**: Demonstrate features with realistic scenarios

#### Feature 1: [Feature Name]

**What it does**: [1-sentence description]

**Demo flow**:
1. Start at: [URL or screen]
2. Action: [Click/type/select]
3. Result: [What user sees]
4. Highlight: [Key benefit or detail]

**Script**:
```
"First, let me show you [Feature 1].
As a [user role], you can now [action].
Watch what happens when I [demonstrate]...
Notice how [highlight key benefit]."
```

**Time**: 2-3 minutes

---

#### Feature 2: [Feature Name]

[Repeat format above]

---

#### Feature 3: [Feature Name]

[Repeat format above]

---

### Part 3: Q&A (2-3 min)

**Script**:
```
"That's what we shipped this sprint.
Any questions so far?"
```

**Common Questions & Answers**:
- Q: "Can we change [X]?"
  - A: "Yes, that's configurable. Let me show you..." OR "That would be a scope change, we can discuss priority."
  
- Q: "What about [feature Y]?"
  - A: "That's planned for Sprint Z. Here's the timeline..."

- Q: "This looks different from mockup"
  - A: "Let me check the design... [compare]. We can adjust if needed."

---

### Part 4: Next Steps (1 min)

**Script**:
```
"Next sprint we'll focus on:
1. [Feature A]
2. [Feature B]
3. [Bug fixes from your feedback]

I'll send you staging credentials so you can test.
Please share feedback by [date] so we can address it next sprint.

Thanks for your time!"
```

---

## What to SHOW

**✅ DO Show**:
- Working features (completed, tested)
- Real user flows (login → create → save → view)
- Mobile responsive (if in scope)
- Key validations ("See how it prevents invalid input")
- Performance ("Notice how fast it loads")

**❌ DON'T Show**:
- Half-done features ("This will work next sprint")
- Debug mode / console logs
- Placeholder text ("Lorem ipsum")
- Known bugs ("Ignore this error")
- Code or technical details (unless client asks)

---

## What to HIDE

**Before demo, ensure these are NOT visible**:
- [ ] Debug tools closed (DevTools, console)
- [ ] Test data realistic (not "Test User 123")
- [ ] Dummy emails hidden (use real-looking emails)
- [ ] Error messages cleared
- [ ] Staging banner obvious ("STAGING - NOT PRODUCTION")

---

## Demo Anti-Patterns (Avoid!)

❌ **The Apology Tour**: "Sorry this isn't done yet..."  
✅ **Confidence**: "Here's what we shipped this sprint"

❌ **Technical Deep-Dive**: "So the API uses JWT tokens..."  
✅ **User Benefit**: "Login is secure and remembers you for 7 days"

❌ **Feature Dump**: Show 20 features in 5 minutes  
✅ **Focus**: 3-4 key features, demonstrated thoroughly

❌ **Live Coding**: "Let me just fix this real quick..."  
✅ **Prepared**: Everything tested before demo

❌ **Ignore Feedback**: "We'll discuss later"  
✅ **Acknowledge**: "Good point, let me note that down"

---

## Handling Demo Disasters

### Scenario 1: Staging is Down
**Backup Plan**: Screen recording
```
"Looks like staging is having issues. Let me show you 
a screen recording I prepared earlier..."
```

### Scenario 2: Feature Breaks During Demo
**Recovery**:
```
"This is a staging environment bug. Let me show you 
the screen recording of it working correctly..."
```

### Scenario 3: Client Hates It
**Stay Calm**:
```
"I appreciate the honest feedback. Let me understand 
what specifically doesn't work for you...
[Take notes]
We can adjust this next sprint."
```

### Scenario 4: Client Requests Scope Change
**Defer**:
```
"That's a great idea. Let me note that as a change request.
After this demo, we can discuss timeline and cost impact."
```

---

## Post-Demo Actions

**Immediately After** (5 min):
- [ ] Send thank-you email with demo recording link
- [ ] Share staging credentials (if not shared yet)
- [ ] Set deadline for feedback (e.g., "Please test by Friday")

**Within 24 Hours**:
- [ ] Document feedback in `DEMO_FEEDBACK_FORM.md`
- [ ] Categorize: Bug / Enhancement / Scope Change
- [ ] Update sprint backlog with priority items

**Before Next Sprint**:
- [ ] Address critical feedback
- [ ] Defer nice-to-haves
- [ ] Communicate what will/won't be in next sprint

---

## Demo Email Template

**Subject**: `Sprint X Demo Recording & Staging Access`

```
Hi [Client Name],

Thanks for joining the demo today! Here's a summary:

WHAT WE SHOWED:
- ✅ [Feature 1]: [Brief description]
- ✅ [Feature 2]: [Brief description]  
- ✅ [Feature 3]: [Brief description]

DEMO RECORDING:
[Loom/YouTube/Drive link]

STAGING ACCESS:
URL: https://staging.yourapp.com
Login: demo@client.com
Password: [sent separately via secure method]

NEXT STEPS:
1. Please test features on staging by [Date]
2. Share feedback (what works, what doesn't, what's confusing)
3. Next demo: [Date] - we'll show [preview of next sprint]

Questions? Reply to this email or WhatsApp [phone].

Best,
[Your Name]
```

---

## Demo Checklist

**Preparation**:
- [ ] Features tested on staging
- [ ] Demo script written
- [ ] Screen recording backup ready
- [ ] Calendar invite sent
- [ ] Test data realistic

**During Demo**:
- [ ] Start on time
- [ ] Share screen clearly
- [ ] Speak slowly and clearly
- [ ] Take notes on feedback
- [ ] Stay within 15 minutes

**Follow-up**:
- [ ] Send recording within 1 hour
- [ ] Share staging credentials
- [ ] Document feedback
- [ ] Update backlog

---

## Example: Filled Demo Script

```
Demo #4 - Sprint #4
Date: October 11, 2024
Client: John Doe (ABC Company)
Team: Jane (Dev), Mike (Designer)

---

RECAP (1 min):
"Good morning John! Last demo we showed user authentication.
This sprint we focused on the invoice management module.
Let me walk you through..."

---

FEATURE 1: Create Invoice (3 min)

What: Users can create invoices with line items and auto-calculate totals

Demo Flow:
1. Start at dashboard → Click "New Invoice"
2. Fill client info, add 3 line items
3. Show auto-calculation (subtotal + tax = total)
4. Save → Show in invoice list

Script:
"First, creating an invoice. As an admin, you click 'New Invoice'.
You enter client details here, add line items - watch how it 
calculates the total automatically. When you save, it appears 
in your invoice list with a unique ID."

Highlight: "Notice the auto-calculation - no manual math errors."

---

FEATURE 2: Send Invoice by Email (2 min)

What: Send invoice as PDF attachment via email

Demo Flow:
1. Select invoice from list
2. Click "Send Email"
3. Show email preview with PDF
4. Send → Check inbox (show email received)

Script:
"Now sending the invoice. Select it, click 'Send Email'.
You get a preview - customize the message if needed.
Hit send... and here's the client receiving the email
with PDF attachment. Opens correctly, looks professional."

Highlight: "PDF generation is instant, email delivery within seconds."

---

FEATURE 3: Invoice Status Tracking (2 min)

What: Track invoice status (Draft, Sent, Paid)

Demo Flow:
1. Show invoice list with status badges
2. Mark invoice as "Paid"
3. Show status updated, filters work

Script:
"Finally, tracking payment status. See the status badges here?
Draft, Sent, Paid. When client pays, you mark it as Paid.
Status updates, and you can filter by status - super useful
for tracking outstanding payments."

Highlight: "Dashboard shows 5 unpaid invoices at a glance."

---

Q&A (3 min):

[John asks: "Can we add discounts?"]

Answer: "Great question. Discounts aren't in this sprint, 
but we can add it next sprint. Would you want percentage 
or fixed amount discounts?"

[John: "Percentage discount, 10-20% typical"]

Response: "Got it. I'll add that to next sprint backlog.
Anything else?"

---

NEXT STEPS (1 min):

"Next sprint we'll add:
1. Discount field
2. Invoice templates (customize logo/colors)
3. Expense tracking (per your earlier request)

I'll send you staging login so you can test invoicing.
Please share feedback by Monday so we can adjust next sprint.

Thanks John!"

---

POST-DEMO:
- ✅ Sent email with recording
- ✅ Added "Discount field" to Sprint 5 backlog
- ✅ Staging credentials sent via 1Password
- ✅ Feedback deadline: Monday, Oct 14
```

---

## Demo Recording Tools

**Screen Recording**:
- Loom (recommended - easy sharing)
- OBS Studio (free, high quality)
- Zoom (if demoing on call)
- QuickTime (Mac)

**Video Hosting**:
- Loom (auto-hosts)
- YouTube (unlisted link)
- Google Drive (restricted access)
- Vimeo (password-protected)

---

## Integration with Workflow

**Sprint Cycle**:
- Week 1: Development
- Week 2: Testing + **Mid-sprint demo**
- Week 3: Development
- Week 4: Testing + **End-of-sprint demo**

**Demo Frequency**:
- **Medium projects**: Every 2 weeks (end of sprint)
- **Large projects**: Every week (mid-sprint + end-of-sprint)
- **Small projects**: Every 3-4 weeks (less frequent)

---

## Notes

**Demo is not UAT**: Demo = "Here's what we built", UAT = "Does it meet requirements?"

**Manage expectations**: Only show completed features, not work-in-progress

**Record everything**: Even if client attends, send recording (they forget details)

**Celebrate wins**: "We shipped X features this sprint" (build momentum)
