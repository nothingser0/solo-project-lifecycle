# Brand Voice & Verbal Identity Guide

> **Module**: M04 (UI/UX Design & Prototyping) & M06 (Development Execution)  
> **Source**: Adapted from Strategic Brand Building & Verbal Identity frameworks.  
> **Objective**: Standardize interface copy, tone of voice, error messages, and customer interactions to ensure consistent, human-centered brand perception.

---

## 1. The Tone Spectrum (The 4 Personality Sliders)

Calibrate the brand's verbal personality across these 4 spectrums:

| Spectrum | Current Calibration (1 to 5) | Operational Meaning |
| :--- | :---: | :--- |
| **Formal vs. Conversational** | `[ 1 2 (3) 4 5 ]` | Level 1 = Legal/Banking; Level 3 = Modern Professional; Level 5 = Casual Chat. |
| **Direct vs. Expressive** | `[ 1 (2) 3 4 5 ]` | Level 1 = Extreme brevity/terse; Level 3 = Balanced; Level 5 = Storytelling. |
| **Serious vs. Playful** | `[ 1 (2) 3 4 5 ]` | Level 1 = Solemn mission-critical; Level 2 = Calm & confident; Level 5 = Humorous. |
| **Technical vs. Plainspoken**| `[ 1 2 (3) 4 5 ]` | Level 1 = Developer jargon; Level 3 = Industry-clear; Level 5 = Simplified for novices. |

---

## 2. Vocabulary & Grammar Rules (The Word Bank)

### A. Preferred Vocabulary (Use These)
* **Action-oriented verbs**: *"Deploy", "Export", "Connect", "Verify", "Launch"*.
* **Transparent status indicators**: *"Settled", "Pending sync", "Authorized", "Live"*.
* **Respectful clarity**: *"You've used 80% of storage", "Billing updates take effect on [Date]"*.

### B. Forbidden Banned Vocabulary (Never Use)
* ❌ **AI Slop**: *"Delve", "Leverage", "Revolutionize", "Robust", "Seamless", "Supercharge"*.
* ❌ **Passive-Aggressive Blame**: *"You failed to fill...", "Invalid input provided by user"*.
* ❌ **Dead-end Technical Codes**: *"Error code 0x80042109", "NullPointerException at line 42"*.

---

## 3. Humanized UI Error-State Translations

Every error message in the application must follow the **Empathetic Triad**:  
`[What happened in human terms] + [Why it happened without blaming user] + [Immediate clickable next step]`.

| Raw Engineering Error | Broken Default Message | Humanized Brand Voice Replacement |
| :--- | :--- | :--- |
| **Network Timeout (504)** | *"Connection timed out."* | *"We couldn't reach the server. Your data is safe. [Check Connection & Retry]"* |
| **Card Declined** | *"Transaction failed: Code 51."* | *"Your bank declined this charge. Please verify your card balance or [Try Another Payment Method]."* |
| **Validation Failure** | *"Password invalid."* | *"Passwords require at least 8 characters and 1 number. [Show requirements]"* |
| **Not Found (404)** | *"404 Not Found."* | *"This page moved or doesn't exist anymore. [Back to Dashboard]"* |
| **Rate Limit (429)** | *"Too many requests."* | *"You've reached the request limit for this minute. Please wait 30 seconds or [Upgrade Plan]."* |

---

## 4. Microcopy & UX Writing Quality Standards

Adapted from Stripe's systematic UX content design framework:

1. **Sentence Case Universal Standard**:
   - Always use sentence case for buttons, headings, labels, and table headers (e.g. *"Create new invoice"*, not Title Case *"Create New Invoice"*). Sentence case is easier to scan and sounds more conversational.
2. **Active Imperative Button Labels**:
   - Use active verbs directly stating the exact task: *"Download report"*, *"Send invitation"*, *"Delete project"*. Avoid vague nouns (e.g., *"Processing"*, *"Account Deletion"*).
3. **Front-Loaded Error Strings**:
   - Place the critical noun or requirement at the beginning of the sentence so mobile users immediately grasp the fix:  
     - ✅ *"Password must be at least 8 characters"*  
     - ❌ *"There is a requirement that your password has 8 characters"*
4. **Specific Destructive Verbs**:
   - Use *"Delete"* when removing data permanently. Use *"Remove"* only when unlinking or detaching an item from a list (without destroying the underlying record).
5. **Empty State Structure**:
   - Follow the **Trio Architecture**: `[Contextual Title] + [1-sentence value explanation] + [1 primary call-to-action button]`.
   - Example: *"No bank mutations imported yet. Upload your bank mutation CSV to automatically categorize tax deductions. [Import Mutation]"*
