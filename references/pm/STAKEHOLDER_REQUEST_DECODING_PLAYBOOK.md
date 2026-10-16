# Stakeholder Request Decoding & Escalation Triaging Playbook

> **Module**: M02 (Discovery Scope) & M13 (Product Operations & Continuous Iteration)  
> **Source**: Adapted from chief-of-staff product management frameworks (`deanpeters/Product-Manager-Skills`).  
> **Objective**: Stop the reflex of coding to literal words; decode incoming client pings, executive escalations, and feature mandates into root jobs-to-be-done while protecting timeline integrity.

---

## 1. The Core Trap: Literal Ask vs. Job-to-Be-Done

When an urgent message arrives (e.g., *"Can we get a custom export feature into tomorrow's release? The executive sponsor is asking"*), average developers and junior PMs immediately open their IDE or sprint backlog to plan implementation.

**This is how builders construct the wrong thing with maximum efficiency.**

### The Critical Separation:
* **The Literal Ask**: What the sender typed on the screen (e.g., *"Build an automated CSV/Excel export tool with date filters"*).
* **The Job-to-Be-Done (JTBD)**: The underlying outcome the sender is actually chasing (e.g., *"I need a showable slide or table for the 9 AM board meeting to prove our team is responsive to operational metrics"*).

Responding to the literal ask when the underlying job is different guarantees wasted engineering hours and unmet expectations.

---

## 2. Success Criteria vs. Must-Haves (The Fundamental Distinction)

Conflating these two concepts causes scope disputes and rejected deliverables:

| Concept | Definition | Guiding Question | Example |
| :--- | :--- | :--- | :--- |
| **Must-Haves** | What goes *into the box* (the technical ingredients). | *"What components are required to build this?"* | CSV export endpoint, database query, date-range picker UI. |
| **Success Criteria** | The ruler used to *measure the box* (how the sender judges success). | *"How will the stakeholder judge whether this actually worked?"* | The director receives reconciled numbers before the audit deadline. |

> **Warning**: A deliverable can fulfill 100% of the technical must-haves and still fail the success criteria completely if the real operational pain remains unresolved.

---

## 3. The 4-Option Counter-Proposal Matrix

Never reply with a flat, combative "No", and never accept an unvalidated mandate that blows up your sprint. Offer structured counter-options:

```text
[ Incoming Request Evaluated ]
               │
   ┌───────────┼───────────┬───────────┐
   ▼           ▼           ▼           ▼
[ Option 1 ] [ Option 2 ] [ Option 3 ] [ Option 4 (Recommended) ]
Diplomatic    Fast 15m    Reframe as   Counter-Proposal Protecting
Brief Reply   Align Sync  Discovery    Outcome with Vertical Slice
```

* **Option 1: Diplomatic Brief Reply**: Used for low-stakes FYIs or minor clarification.
* **Option 2: 15-Minute Alignment Sync**: Used when power is high and ambiguity threatens strategic direction.
* **Option 3: Reframe as Discovery**: Shift a premature solution back into the Opportunity Solution Tree.
* **Option 4: Outcome-Protecting Counter-Proposal**: Offer a thin, demoable slice that satisfies 100% of the immediate success criteria in 10% of the engineering time:
  > *"To ensure the director has exact data for tomorrow morning's meeting without risking our production release stability, I can generate a verified manual export report by 5 PM today, and we can prioritize the automated self-serve pipeline during sprint planning next Tuesday."*

---

## 4. The Sticky-Note Triaging Checklist

For every incoming escalation, summarize using the **Sticky-Note Rule** (4–8 words per bullet, scannable in 30 seconds):

* [ ] **Sender Power & Stake**: *Upstream executive; high authority, high urgency.*
* [ ] **Literal Ask**: *Automated multi-currency billing reconciliation engine.*
* [ ] **Inferred Underlying Job**: *Needs audit reassurance for external tax inspection.*
* [ ] **Core Constraint**: *Fixed Friday compliance deadline; zero budget expansion.*
* [ ] **Counter-Proposal**: *Manual script run today; automated UI scheduled sprint 4.*
