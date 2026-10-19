# Content Quality Scorecard

> **Module**: M04 (UI/UX) — scores interface copy before Design Freeze; reusable in M07 polish
> **Source**: Adapted from `content-designer/ux-writing-skill` (MIT) — the four quality standards, the criterion set and the 0–10 scoring model.
> **Why a scorecard**: "This copy reads well" is an opinion. Four standards scored 0–10 turn it into a finding with a number attached — and a number can be argued with, re-measured, and improved.

---

## 1. The four standards

Every string is judged on four axes, independently. A string can be concise and still fail.

| Standard | Question | Fails when |
| :--- | :--- | :--- |
| **Purposeful** | Does it help the user (or the business) achieve a goal? | It describes the system instead of the outcome |
| **Concise** | Is it the fewest words that keep the meaning? | It can lose a word without losing meaning |
| **Conversational** | Does it sound like something a person would say? | It reads like a log line or a legal notice |
| **Clear** | Is it unambiguous, accurate, and easy to understand? | Two people could read it differently |

**The independence rule**: score each axis separately. Averaging early hides the failure — a 9/10 on concise does not rescue a 4/10 on purposeful.

---

## 2. Criteria per standard

### Concise

- Every word has a distinct job — no "basically", "actually", "just"
- Each word adds meaning; removing any word loses something
- **40–60 characters per line** (≈45–65ch in CSS, `max-w-prose`)
- Short sentences and paragraphs — under 3–4 lines
- **Front-loaded**: the most important words come first
- Ordered by priority: critical → secondary → nice-to-know

### Purposeful

- Helps the user complete the task they came for
- Answers "why am I here?"
- Supports a business goal (conversion, engagement, retention) without contradicting the user's
- Reflects brand voice — recognisable as this product
- Value is evident **before** the ask
- Second person ("you"), outcome-focused, not feature-focused

### Conversational

- Sounds like something you would say aloud
- **Active voice** predominates (target ~85%)
- Connecting words present — prepositions ("to", "from", "with") and articles ("a", "an", "the"). Missing them is what makes copy sound robotic.
- Uses the user's own vocabulary, not internal jargon
- Personality appears where the context allows — and stays out of the way in serious moments

### Clear

- **Specific verbs**: "Delete" for permanent removal, "Remove" for unlinking, "Save" for saving. Never "OK" or "Submit" for either.
- Active imperative for buttons
- **Plain language**: ~7th-grade reading level for general audiences, ~10th for professional
- Titles say where you are, not just what the section is
- **Same word means the same thing** everywhere — documented in the style guide

---

## 3. Scoring

| Score | Meaning |
| :---: | :--- |
| **9–10** | Excellent — a best-practice example |
| **7–8** | Good — minor improvements possible |
| **5–6** | Adequate — notable issues to address |
| **3–4** | Needs work — significant problems |
| **0–2** | Poor — major revision required |

**Threshold**: a user-facing string below **7 on any axis** is a finding, not a preference. Below **5** it blocks Design Freeze.

---

## 4. Worked example

**Original**: *"An error occurred while processing your request. Please try again."*

| Axis | Score | Why |
| :--- | :---: | :--- |
| Concise | 6/10 | Wordy; "We couldn't process your request. Try again." says the same |
| Purposeful | 4/10 | Does not help the user fix anything or say what happened |
| Conversational | 5/10 | "An error occurred" is system-speak, not speech |
| Clear | 5/10 | Vague — which error, and what does "try again" change? |
| **Overall** | **5/10** | Adequate but needs significant improvement |

**Revised**: *"We couldn't save your changes. Check your connection and try again."*

| Axis | Score | Why |
| :--- | :---: | :--- |
| Concise | 9/10 | Brief, no wasted words |
| Purposeful | 8/10 | Names the likely cause and the next step |
| Conversational | 9/10 | Natural phrasing, active voice |
| Clear | 9/10 | Specific about what failed and what to do |
| **Overall** | **9/10** | Excellent |

**What changed**: the system became "we", the abstract "error occurred" became the concrete "couldn't save", and a dead-end instruction became a cause plus an action.

---

## 5. Where to apply it

| Context | Apply |
| :--- | :--- |
| A single string (button, label, error) | Score all four axes; fix anything under 7 |
| A screen or flow | Score the set; the weakest string sets the screen's score |
| Comparing two options | Score both; the higher total wins unless one axis is critical (e.g. clarity in an error) |
| Before and after an edit | Record both — the delta is the rationale |
| Tracking quality over time | Sample monthly; a falling average is a drift signal |

---

## 6. Honest limits

- **Scores are judgement, not measurement.** Unlike a contrast ratio, "purposeful 8/10" cannot be computed. Say so when reporting.
- **Reading level is measurable** — run a Flesch-Kincaid check if the claim matters. The 7th/10th-grade targets are guidelines, not thresholds to defend in court.
- **Character counts are measurable** — 40–60 characters per line is checkable with a ruler, not a feeling.
- **Localisation changes the maths.** Indonesian and German expand; a label tuned to 40 characters may overflow at 55. Check the longest locale before locking a button width.
- **The scorecard cannot tell you what to say.** It tells you when what you said is weak. The idea still has to come from the brief.
