# SaaS Churn Prevention & Cancellation Flow Playbook

> **Module**: M13 (Product Operations & Continuous Iteration)  
> **Source**: Adapted from SaaS retention engineering frameworks (`coreyhaines31/marketingskills`).  
> **Objective**: Eliminate voluntary customer loss through dynamic save offers and recover involuntary payment failures without intrusive dark patterns.

---

## 1. The 5-Step Cancel Flow Architecture

Every self-serve SaaS product must implement an ethical, frictionless 5-step offboarding sequence:

```
[Trigger in Account Settings]
            │
            ▼
[Step 1: 1-Question Exit Survey]
            │
            ▼
[Step 2: Dynamic Save Offer (Matched to Reason)]
      ┌─────┴────────────────────────┐
   [Accepted]                    [Declined]
      │                              │
      ▼                              ▼
[Apply Save Benefit]         [Step 3: Transparent Confirmation]
                                     │
                                     ▼
                             [Step 4: Post-Cancel Reactivation Path]
```

### Step 1: Exit Survey Structure (Single Select)
Ask exactly 1 question with 5–7 mutually exclusive reasons:
1. **Too expensive** $\to$ *Triggers discount or downgrade save offer.*
2. **Not using it enough** $\to$ *Triggers subscription pause or onboarding assist.*
3. **Missing a feature** $\to$ *Triggers roadmap sneak-peek or workaround guide.*
4. **Switching to a competitor** $\to$ *Triggers competitive differentiator summary.*
5. **Technical issues / bugs** $\to$ *Triggers immediate high-priority support escalation.*
6. **Temporary / project ended** $\to$ *Triggers subscription pause.*
7. **Business closed** $\to$ *Respectfully skips all save offers.*

---

## 2. Dynamic Save Offer Matrix

Never show a generic blanket discount. Match the incentive directly to customer friction:

| Stated Cancel Reason | Primary Save Offer | Fallback Save Offer | Anti-Pattern to Avoid |
| :--- | :--- | :--- | :--- |
| **Too expensive** | **20%–30% discount for 2–3 months** (state exact IDR/USD amount saved). | Downgrade to lower tier ("Right-size plan"). | Never offer 50%+ discounts (trains users to cancel for deals). |
| **Not using enough** | **Pause Subscription (1 to 3 months)**. Retain data intact. | 1-on-1 walkthrough session. | Never allow indefinite pauses (>3 months rarely reactivate). |
| **Missing feature** | Roadmap timeline preview + beta access invite. | Direct founder feedback chat. | Never promise unbuilt features without firm release dates. |
| **Technical bugs** | Instant Priority Support ticket creation + 1-month credit. | Direct developer triage call. | Never argue with user reports. |
| **Temporary need** | **1-click Account Pause** (auto-reactivates on date X). | Downgrade to free maintenance tier. | Never purge account data immediately upon pause. |

---

## 3. Involuntary Churn & Dunning Logic

Up to 40% of SaaS churn is caused by expired cards, billing timeouts, or failed bank webhooks (involuntary churn):

1. **Smart Retry Cadence**:
   - Retry failed charges on Day 1, Day 3, Day 5, and Day 7 after failure.
   - Do not lock account access immediately on initial failure; provide a 7-day grace period.
2. **Pre-Dunning & In-App Alerts**:
   - 15 days before credit card expiration: Display subtle warning banner on dashboard.
   - On payment failure: Display non-blocking amber warning with direct link to update billing info.
3. **Automated Dunning Emails**:
   - Email 1 (Day 0): Polite notice ("We couldn't process your payment. Your data is safe. [Update Payment]").
   - Email 2 (Day 4): Reminder with direct 1-click update link (no login wall required).
   - Email 3 (Day 7): Final notice before downgrading account to read-only status.

---

## 4. Ethical Compliance & Click-to-Cancel Standard

Under FTC Click-to-Cancel rules and global consumer protection standards:
* **Zero Hidden Buttons**: Canceling must take the same number of clicks as subscribing.
* **No Forced Phone Calls / Support Chats**: If a user signed up online, they must be able to cancel online self-serve.
* **Clear Expiration Notice**: Explicitly state that access remains active until the end of the current billing cycle:  
  *"Your subscription will remain active until [End of Billing Cycle]. You will not be charged again."*
