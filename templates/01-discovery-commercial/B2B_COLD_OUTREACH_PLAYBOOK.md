# B2B Cold Outbound & Prospecting Playbook

> **Module**: M00 (Product Discovery) & M03 (Commercial Charter)  
> **Source**: Adapted from peer-to-peer B2B cold outbound frameworks (a published marketing-skills-for-agents library).  
> **Objective**: Conduct disciplined, human-centered cold email outreach to acquire early pilot customers and validate product demand without sounding like an automated sales machine.

---

## 1. Core Outbound Principles: "Write Like a Peer, Not a Vendor"

1. **Lead with Their World, Not Yours**:
   - Never open with: *"My name is [Name] and I am the founder of [Company]..."* (Instant delete).
   - The prospect does not care who you are; they care about their immediate friction. Open directly with an observation about *their* operations.
2. **Ruthless Brevity (< 100 Words)**:
   - Every sentence must earn its place. If a sentence can be cut without breaking the core point, cut it.
3. **Low-Friction, Interest-Based CTAs**:
   - Never ask a stranger for a "30-minute demo call" in the first email.
   - Ask for permission or interest with a 1-line reply: *"Worth exploring?"*, *"Would a breakdown of this be helpful?"*, or *"Open to taking a quick look?"*

---

## 2. Subject Line Engineering (The "Internal Email" Look)

Subject lines must look like an internal message from a colleague, never an advertising pitch:
* **Length**: Strictly **2 to 4 words**, lowercase or standard capitalization.
* **Prohibited**: Exclamation marks, emojis, capitalized buzzwords, fake `"Re:"` or `"Fwd:"`.

| Poor Subject (Marketer Pitch) | Winning Subject (Colleague Style) |
| :--- | :--- |
| ❌ *Revolutionize Your Tax Reconciliation Today!* | ✅ *tax reconciliation ops* |
| ❌ *Quick question about your software...* | ✅ *q2 invoice workflow* |
| ❌ *[First Name], boost your team's productivity by 30%* | ✅ *freelancer payouts* |

---

## 3. High-Converting 4-Part Email Architecture

### Structure:
```
[Observation] ──► [Identified Friction] ──► [Concrete Proof/Mechanism] ──► [Interest-Based CTA]
```

### Production Example (Targeting Agency Owners):
```text
Subject: client invoice reconciliation

Hi [First Name],

Noticed [Company Name] recently expanded the engineering contractor team on LinkedIn. 

When client rosters scale past 10 accounts, reconciling multi-currency invoices and collecting tax withholdings usually ends up eating 15+ hours every month in manual spreadsheets.

We built an automated pipeline that syncs bank mutations and generates DJP-compliant e-Bupot receipts in under 3 minutes. 

Worth sending over a 2-minute video showing how it works?

Best,
[Your Name]
Solo Founder, [Product Name]
```

---

## 4. Multi-Touch Follow-Up Cadence

Never send a generic *"Just bumping this to the top of your inbox"* follow-up. Every touchpoint MUST offer new value or a fresh angle:

* **Email 1 (Day 1)**: Core Observation & Hypothesis (The primary pitch).
* **Email 2 (Day 4)**: Fresh Angle / Concrete Proof Point (*"Saw your team uses [Tech Stack], here is how our webhook integration eliminates [Pain]"*).
* **Email 3 (Day 9)**: Helpful Resource / Free Tool (*"Put together a quick checklist for [Topic], thought it might save your ops team some time [Link]"*).
* **Email 4 (Day 15 - The Breakup Email)**: Polite closure (*"Assuming this isn't a priority for [Company Name] right now. Won't follow up again, but feel free to reach out if things change."*).

---

## 5. Technical Deliverability & Domain Hygiene

Before sending any cold outbound:
1. **Secondary Domain Requirement**:
   - **NEVER** send cold outreach from your primary production domain (e.g., if your app is `freepajak.com`, send from `getfreepajak.com` or `freepajakops.com`). A spam complaint must never risk your production transactional emails.
2. **Authentication Triad**:
   - Fully configure SPF, DKIM, and DMARC records on the secondary domain.
   - Warm up new mailboxes for 3–4 weeks before sending outbound.
3. **List Quality & Compliance**:
   - Verify all email addresses before uploading; maintain bounce rates strictly below 2%.
   - Always include a physical postal address and a clear 1-click unsubscribe option.
