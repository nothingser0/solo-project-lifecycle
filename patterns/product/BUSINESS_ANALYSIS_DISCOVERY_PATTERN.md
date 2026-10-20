# Business Analysis Discovery & Requirements Craft Pattern

> **Module**: M02 (Discovery & Scope), M05 (Architecture & Specs), M07 (QA)
> **Source**: Adapted from a published business-analysis-skills library (MIT, 53 skills across atomic / workflows / quality tracks).
> **Scope**: The elicitation-to-specification craft that sits between "client said something" and a locked scope: choosing the right elicitation technique, pressure-testing requirement wording, separating functional from non-functional and business rules, proving traceability, and running the review passes that catch a pack before the client does.

---

## 1. Why This Exists

`docs/modules/02_DISCOVERY_SCOPE.md` mandates a Discovery Interview, MoSCoW, Given-When-Then criteria, an RBAC matrix, and ≥3 Out-of-Scope exclusions. What it does **not** say is *how to run the interview*, *how to notice that a sentence is untestable*, or *which artifact closes which gap*. Without that craft, the same failure recurs: a scope statement that is formally complete but semantically hollow — every row present, every row ambiguous.

This pattern supplies the missing layer. It is technique, not ceremony: apply the subset the project needs, at the phase that needs it.

---

## 2. The Four Tracks

| Track | Question it answers | Load when |
|---|---|---|
| **Elicitation** | How do I find out what is actually true? | Before locking scope (M02), or when requirements feel thin |
| **Requirements craft** | Is this sentence testable, complete, and conflict-free? | While writing `SCOPE_STATEMENT.md` / `PRD.md` |
| **Strategy** | What external and competitive forces shape viability? | M00–M01, strategy-heavy or market-facing work |
| **Quality review** | What is wrong with this pack before sign-off? | End of M02, M05, and before M09 UAT |

---

## 3. Elicitation: Pick the Technique, Don't Default to "Interview"

Each technique has a different evidence quality and cost. Choosing deliberately is the whole point.

| Technique | Best for | Weak at | Solo-dev cost |
|---|---|---|---|
| **Interview** | Past behaviour, tacit workarounds, decision authority | Hypotheticals ("would you use…") | 30–60 min per person |
| **Questionnaire** | Breadth, ranking, willingness-to-pay bands | Anything requiring follow-up | Design + pilot + analysis |
| **Workshop** | Resolving disagreement between stakeholders in one room | Producing evidence; groupthink | Half day + facilitation |
| **Observation** | Work that people cannot accurately describe (tacit steps, real bottlenecks) | Rare events; sensitive sites | Site visit, no interview pressure |
| **Prototype / mock-up** | Requirements that text cannot pin down (layout, flow, density) | Backend rules and edge cases | Design time before M04 |
| **Document analysis** | Existing policy, regulations, legacy exports | Currency — documents drift from practice | Reading time |

### 3.1 The Elicitation Mix Decision

1. **State the objective** of this round in one sentence ("decide whether cashiers can void a sale").
2. **Name the evidence you need** and which technique produces it.
3. **Prefer the cheapest technique that produces that evidence** — a 5-question questionnaire beats a workshop for a ranking decision.
4. **Never substitute a technique for a missing stakeholder.** If the decision-maker is absent, no method compensates; log it as a dependency.

### 3.2 Question Design Discipline

- Ask about **past concrete actions**, never hypothetical intent ("How did you handle the last stock discrepancy?" not "Would you use a dashboard?").
- One question, one decision. A question that yields two answers cannot be analysed.
- **Pyramid / funnel / diamond** sequencing: broad context → narrow specifics → widen to implications. Starting narrow biases the answer.
- **Pilot every questionnaire** on 2–3 people before distribution: unclear questions, missing options, and length problems only appear in a real attempt.
- Record **who answered** and **when** — an unattributed finding cannot pass M00's evidence rule.

---

## 4. Requirements Craft: Making a Sentence Testable

### 4.1 The Five Ambiguity Classes

Every flagged requirement falls into exactly one of these; naming the class tells you the fix.

| Class | Symptom | Fix |
|---|---|---|
| **Missing information** | Actor, trigger, or object undefined | Ask; do not invent |
| **Conflict** | Two requirements cannot both hold | Route to `requirements-conflict` resolution (§4.3) |
| **Hidden assumption** | A condition is implied but unstated | Promote to the assumption register |
| **Scope uncertainty** | Boundary of "done" unclear | Define in/out explicitly |
| **Unverifiable statement** | "fast", "user-friendly", "secure", "intuitive", "scalable" | Replace with a measurable threshold |

`templates/01-discovery-commercial/REQUIREMENTS_AMBIGUITY_CHECKLIST.md` holds the concrete banned-word → measurable-specification table and the edge-case triad. This pattern supplies the classification and the process around it.

### 4.2 Functional vs Non-Functional vs Business Rule

The three are routinely collapsed into one blob, which is how a business rule ends up "tested" by a UI test.

- **Functional** — the system does X when Y happens. Verifiable by a scenario.
- **Non-functional** — a measurable quality of how it does it (p95 ≤ 500 ms, 99.0% availability, RPO ≤ 24 h). Verifiable by measurement, not by a click-path.
- **Business rule** — a constraint the organisation imposes on any implementation (a discount above 15% requires manager approval; a tax invoice must carry a 16-digit NPWP). Verifiable by a rule test, and it must survive a UI redesign.

**Rule**: a requirement that changes when the UI changes is functional; a requirement that must hold regardless of the UI is a business rule. Misclassifying the second as the first is how rules silently disappear in a rewrite.

### 4.3 Conflict Resolution

When two requirements conflict:
1. Record both with their sources — never silently pick one.
2. Classify: logical contradiction / duplicated intent in different words / NFR tradeoff / scope mismatch.
3. Name the **owner who must decide** (usually the Client Single PIC on client work, the human on solo work).
4. Offer resolution options with consequences; do not choose.

An agent may never "resolve" a contradiction by assuming which side wins — that is a business decision (`docs/AUTHORITY.md`).

### 4.4 Completeness Audit

A requirement set is thin when it omits any of: actors, triggers, preconditions, postconditions, data, validation, permissions, error handling, NFRs, support/operations, reporting, auditability, rollout, maintenance.

Mark each as **absent / weak / deferred** — the distinction matters, because "deferred" is a decision and "absent" is an oversight.

### 4.5 Acceptance Criteria Discipline

- One criterion = actor + trigger + observable outcome.
- Cover the **success path and the important failure paths** (validation, permission denied, state conflict, empty result).
- Prefer Given-When-Then; it forces the precondition to be stated.
- Mark any criterion **blocked by unresolved ambiguity** rather than writing a criterion that cannot be verified.
- No implementation detail unless it is genuinely required (e.g. an audit trail field the client's auditor demands).

---

## 5. Strategy Techniques (M00–M01 only)

Load these when the work is market-facing or the client asks for a strategic diagnosis. Each produces a decision input, never a decision.

| Technique | Output | Guardrail |
|---|---|---|
| **PESTLE** | External scan by political / economic / sociocultural / technological / legal / environmental | Indonesia-specific regulatory items belong here (UU PDP, OJK/BI, PPN) — cite the instrument, not a paraphrase |
| **Porter's Five Forces** | Competitive pressure by force | Rate each force and name the evidence; an unrated list is decoration |
| **SWOT (prioritised)** | Strengths/weaknesses/opportunities/threats, then the few that matter | An unprioritised SWOT is a brainstorm, not an analysis |
| **Value Proposition Canvas** | Jobs / pains / gains ↔ pain relievers / gain creators | Every claimed gain needs a source; "customers want it simpler" is not evidence |
| **CATWOE + root definition** | Purposeful system definition (Customers, Actors, Transformation, Worldview, Owner, Environment) | Use when the problem is political or the stakeholders disagree about what the system *is* |
| **SEE-I** | State / Elaborate / Exemplify / Illustrate a concept | Use to kill terminology drift before it reaches a spec |

**Rule**: these inform a decision; they do not make one. Present findings with implications and let the human decide.

---

## 6. The Review Passes (run before sign-off)

Five independent passes, each with a different lens. Running only one is why packs pass review and still fail delivery.

| Pass | Catches | Run at |
|---|---|---|
| **Evidence gap** | Claims that outrun their evidence; unsupported assertions | End of M00, end of M02 |
| **Requirements quality** | Unclear, infeasible, untestable, unprioritised, untraceable requirements | Before M02 scope lock |
| **Deliverable consistency** | Terminology drift, scope drift, role/model mismatch between artifacts | Before M05 sign-off and before M09 |
| **Assumptions & constraints** | Implicit assumptions scattered across artifacts, unowned dependencies | Continuous; consolidated at M02 |
| **Critical thinking / bias** | Preferred-solution bias, oversimplification, weak logic | Before any GO / KILL / PIVOT recommendation |

### 6.1 Review Output Contract

Every review pass returns:
1. **Severity-ranked findings** — not a flat list.
2. **The specific fix**, not generic criticism ("rewrite REQ-04 to name the approver role" beats "improve clarity").
3. **A verdict** — ready / not ready, with the blocking items named.

A review that returns "looks good" without naming what it checked is not a review.

---

## 7. Traceability Minimum

The full RTM is in `references/ba/REQUIREMENTS_TRACEABILITY_AND_RTM_GUIDE.md`. The minimum this pattern enforces:

```
Goal (G-xx) → Requirement (FR/NFR/BR-xx) → Acceptance criterion (AC-xx) → Test → Evidence
```

- Every requirement traces **up** to a goal. No goal → unauthorised scope creep.
- Every requirement traces **down** to at least one acceptance criterion. No criterion → cannot be verified.
- Every business rule traces to a source (regulation, policy document, named decision-maker).
- Broken links are findings, not gaps to be quietly filled.

---

## 8. Scale Application

| Scale | Apply | Skip |
|---|---|---|
| **Small / MVP** | §4.1 ambiguity classes, §4.5 acceptance criteria, `BUSINESS_RULES_REGISTER_TEMPLATE.md`, one review pass (requirements quality). Acceptance criteria live in `SCOPE_STATEMENT_TEMPLATE.md` §4.2; the code-level DoD lives in `BACKLOG_TEMPLATE.md` §8 | Strategy techniques, workshops, full RTM, five-pass review |
| **Solo SaaS** | + §3.1 elicitation mix, §4.4 completeness audit, §5 PESTLE + value proposition, evidence-gap review at M00 | Workshops, observation studies, RACI |
| **Client Medium** | Full §3–§7; all five review passes before M02 lock and before M09; RACI + stakeholder register + communication plan | CATWOE/SSM unless the problem is genuinely political |
| **Large** | Full set + traceability matrix as a gate artifact + observation study on the real operational site | — |
| **Enterprise** | Routed to A00–A04; this pattern supplies the technique vocabulary the advisory pack cites, but the governance artifacts are the A-series deliverables | — |

---

## 9. Failure Modes

1. **Technique theatre** — running a SWOT because it was asked for, without a decision attached to it.
2. **Ambiguity laundering** — rewriting a vague requirement into polished prose that is still unverifiable.
3. **Assumption smuggling** — resolving an open question by quietly assuming an answer.
4. **Single-pass review** — checking consistency but never evidence, or vice versa.
5. **Blob collapse** — one requirements list mixing functional, non-functional, and business rules, so nothing can be tested at the right level.
6. **Traceability theatre** — a matrix that exists but whose rows were filled after the fact to look complete.
7. **Invented stakeholder intent** — writing what the client "must have meant". This violates `docs/AUTHORITY.md` rule 8.
