# Problem Framing Canvas

> **Module**: M00 (Product Discovery) — before `PRODUCT_STRATEGY_TEMPLATE.md` or any solution is named
> **Output Location**: `docs/pm/PROBLEM_FRAMING.md`
> **License note**: The three-phase structure (Look Inward / Look Outward / Reframe) is the MITRE Problem Framing Canvas, a published public framework. This template is written for this framework; no text was copied from any CC BY-NC-SA source.
> **Why before solutions**: A brief that starts with "we need X" has already chosen the answer. This canvas exists to make that choice visible while it is still reversible.

> **Not a parallel track.** M00 Step 3 already covers three things this canvas depends on, and this file **does not replace them**:
> - **Evidence legend** ✅ VERIFIED / 🔶 ASSUMPTION / ❓ UNKNOWN — defined as a gate rule in `docs/modules/00_PRODUCT_DISCOVERY_STRATEGY.md` §Step 3. This template uses those symbols with those meanings.
> - **Opportunity Solution Tree** (Outcome → Opportunities → Solutions → Assumption Tests) — mandated in the same step; use it once Phase 3 below has produced a reframed problem.
> - **Pre-data personas** — M00 Step 3 names these `Proto-Persona (Hipotesis)`; §2.1/§2.3 below feeds that artefact, it does not duplicate it.
>
> What this canvas adds is the part before those: interrogating the problem *itself*, including our own contribution to it.

---

## When to use it

| Situation | Use it? |
| :--- | :--- |
| A stakeholder has already named the solution ("build us an app") | **Yes** — the solution is the symptom |
| The problem has been restated three times and keeps drifting | **Yes** |
| A validated problem with a chosen solution, ready to build | No — go to `PRODUCT_STRATEGY_TEMPLATE.md` |
| A tactical bug or a small tweak | No — over-analysis costs more than the fix |
| A problem you already solved once and are repeating | **Yes** — repetition usually means the framing was wrong |

---

## Phase 1 — Look Inward

The uncomfortable part. Most bad problem statements are bad because the team's own assumptions were never examined.

### 1.1 What is the problem, as symptoms?

Describe what is *observed*, not what is inferred. Symptoms are countable; problems are interpretations.

| Symptom | Where observed | How often |
| :--- | :--- | :--- |
| | | |

> If you cannot fill this table from evidence, the rest of the canvas is speculation. Mark it ❓ UNKNOWN and proceed with that label visible.

### 1.2 Why hasn't this been solved already?

The answer is usually one of these, and each implies a different strategy:

| Reason | What it implies |
| :--- | :--- |
| **Nobody noticed** | The fix is awareness, not engineering |
| **Noticed, not prioritised** | The fix is a cost-of-inaction argument |
| **Tried and failed** | Find out why before trying again — this is the most expensive to ignore |
| **Too hard / too expensive** | The fix is a scope or constraint change |
| **Nobody owns it** | The fix is an assignment, not a build |
| **It benefits someone to leave it** | The fix is political, and no amount of code will land it |

### 1.3 How are we part of the problem?

Answer honestly. Common forms: our process created the workaround; our incentives reward the wrong behaviour; we asked leading questions in research; we only talked to people who already agreed.

| Our contribution | Evidence |
| :--- | :--- |
| | |

---

## Phase 2 — Look Outward

### 2.1 Who experiences it?

| Who | When / where | Consequence for them | Severity (1–5) |
| :--- | :--- | :--- | :---: |
| | | | |

### 2.2 Who else has it — and who does not?

The second half is the more useful one. **People who do not have the problem reveal the boundary condition.**

| Group | Has the problem? | Why / why not |
| :--- | :---: | :--- |
| | | |

### 2.3 Who has been left out?

Name the groups not represented in the evidence. This is not a formality — it is the most common source of a product that ships correctly and fails in the field.

| Group excluded | Why they were missed | How to reach them |
| :--- | :--- | :--- |
| | | |

### 2.4 Who benefits from the problem continuing to exist?

Someone usually does: an incumbent vendor, an internal team whose headcount depends on it, a middleman. Naming it changes the plan.

| Beneficiary | What they gain | Will they resist? |
| :--- | :--- | :--- |
| | | |

---

## Phase 3 — Reframe

### 3.1 Stated another way, the problem is…

One paragraph. No solutions, no product names, no adjectives.

### 3.2 How might we…

```
How might we [action] as we aim to [outcome]?
```

**Rules for the HMW statement**
- **Not so broad it is meaningless** ("How might we improve retail?") and **not so narrow it contains the answer** ("How might we build an offline Android app?"). A HMW that names the technology has already made the decision.
- One action verb. One outcome.
- If it can be answered with "yes" or "no", it is not a HMW.

### 3.3 What would make us abandon this framing?

Write the disconfirming evidence **before** you start building. If nothing could change your mind, the canvas was theatre.

| If we learned… | Then this framing is wrong and we should… |
| :--- | :--- |
| | |

---

## Evidence grading

Every claim on this canvas carries one of three marks. Mixing them silently is how an assumption becomes a requirement.

Uses the framework's canonical legend (`docs/modules/00_PRODUCT_DISCOVERY_STRATEGY.md` §Step 3) — same symbols, same meanings. Do not invent a fourth state.

| Mark | Meaning | Allowed to justify |
| :--- | :--- | :--- |
| ✅ **VERIFIED** | Observed in data, a recorded interview, or a cited document | A decision |
| 🔶 **ASSUMPTION** | Team belief or extrapolation, registered and unverified | A hypothesis to test — never a requirement |
| ❓ **UNKNOWN** | Not yet investigated | Nothing — it is a research task that blocks scope lock |

**Inference has no symbol of its own.** If you reasoned from verified facts, say so in the evidence column ("derived from ✅ interview INT-03") and keep the mark 🔶 until it is checked. A separate "inferred" symbol is how an assumption gets promoted to a fact by accident.

**Rule**: a problem statement resting on more ❓ and 🔶 than ✅ is not ready. It is a research plan wearing a strategy document's clothes.

---

## Exit checklist

- [ ] Symptoms are listed separately from the interpretation of them
- [ ] "Why hasn't this been solved" has an answer that is not "nobody thought of it" — or that answer is justified
- [ ] Our own contribution to the problem is written down
- [ ] At least one group that does **not** have the problem is named
- [ ] At least one excluded group is named, with a plan to reach them
- [ ] The HMW statement names no technology and could not be answered yes/no
- [ ] Disconfirming evidence is written down
- [ ] Evidence grades are marked, and ✅ outnumbers ❓ + 🔶
