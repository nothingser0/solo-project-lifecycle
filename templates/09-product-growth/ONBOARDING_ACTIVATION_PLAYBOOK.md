# SaaS Onboarding & User Activation Playbook

> **Module**: M04 (UX Flows) & M13 (Product Operations & Continuous Iteration)  
> **Source**: Adapted from product-led onboarding and activation frameworks (a published marketing-skills-for-agents library).  
> **Objective**: Drive new users from signup to their core "aha moment" within the first session while eliminating activation blockers.

---

## 1. The Minimum Path to Value (MPTV)

The single goal of the first user session is reaching the **Aha Moment** (the first moment the customer experiences tangible product value):

```
[Signup Complete] ──► [Step 1: Role/Goal Select] ──► [Step 2: Instant Template/Sample Data] ──► [AHA MOMENT]
     (0 sec)                   (15 sec)                                (30 sec)                  (< 60 sec)
```

### The 60-Second Rule
If a new user does not experience core value within **60 seconds** of entering the dashboard, first-session abandonment rises above 60%.

---

## 2. Onboarding Psychology Mechanics

### A. The Endowed Progress Effect (The 20% Head-Start)
Never present an onboarding checklist starting at `0% Complete`:
* Automatically pre-check Step 1 (e.g. `[x] Account created & email verified`).
* Opening a checklist at **20%–25% progress** triggers psychological momentum and boosts overall completion by up to **40%**.

### B. Mario Kart Boosters vs. Blockers (Friction Elimination)
* **Boosters (Accelerants to add)**:
  - Pre-populated dummy/demo data so dashboards look alive, not empty.
  - 1-click industry templates matching the user's role.
  - Micro-celebration animations (confetti/badge) on first successful action.
* **Blockers (Friction to remove)**:
  - Do NOT demand phone numbers, company tax IDs, or full profiles before letting users see the dashboard.
  - Defer secondary configuration to post-activation settings.

---

## 3. The 4-Step Interactive Checklist Pattern

For self-serve SaaS products, limit the onboarding guide to **3–5 high-impact milestones**:

```markdown
### Getting Started with [Product Name] (25% Complete)
- [x] Step 1: Create your account
- [ ] Step 2: Set up your first [Core Resource] (Takes < 2 min)  --> [Start Action]
- [ ] Step 3: Invite 1 teammate or connect external integration   --> [Connect]
- [ ] Step 4: Export or publish your first result                 --> [Preview]
```

* **Always dismissable**: Provide an explicit `[Hide Guide]` option so power users are never trapped in forced walkthrough modals.
* **Value-ordered**: The first incomplete task MUST be the task that delivers immediate utility.

---

## 4. Multi-Channel Activation Email Triggers

Coordinate transactional emails with in-app behavioral states:

| Trigger Event | Timing | Email Objective & Copy Hook |
| :--- | :--- | :--- |
| **Account Created** | Immediate (0m) | Welcome message + 1 direct link to the MPTV action. |
| **Incomplete Setup** | 24 hours later | *"Can we help you set up [Core Feature]?"* + link to 1-minute video demo. |
| **Aha Moment Reached** | Immediate | Congratulations + next power-user tip (e.g. keyboard shortcuts, integration). |
| **Stalled User (Inactive)**| 4 days later | Value reminder highlighting time/money saved by active peers in their sector. |
