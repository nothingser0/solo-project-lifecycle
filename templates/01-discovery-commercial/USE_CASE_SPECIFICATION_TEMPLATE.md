# Use Case Specification Template

> **Module**: M02 (Discovery & Scope) — produces `docs/specs/UC-<MODULE>-<NN>_<name>.md`
> **Source**: Adapted from `phucnt-bazone-vietnam/use-case-writer` (MIT) — the 13-field structure, the scoping rules (Cockburn), and the 20-point checklist. Rewritten for this framework.
> **Craft rules**: `references/ba/USE_CASE_SPECIFICATION_CRAFT_GUIDE.md` (actor↔system dialogue, postcondition-as-state, the 10 anti-patterns)
> **When NOT to use**: a one-line need belongs in `REQUIREMENTS_REGISTER_TEMPLATE.md`; a whole business process spanning several systems belongs in `BUSINESS_PROCESS_FLOW_TEMPLATE.md`.

---

## 1. Scope before you write

Most bad use cases are badly *scoped*, not badly written. Apply these four tests first; a UC that fails one is not ready to be drafted.

| Rule | Test | If it fails |
| :--- | :--- | :--- |
| **Coffee-break test** | After this UC completes, can the actor walk away without feeling the task is unfinished? | Too small — it is a sub-function. Fold it into a larger UC as an `Includes`. |
| **Goal level** | Summary (spans sessions) · **user-goal (one session)** · sub-function (a step) | Only user-goal level becomes a UC. Summary → several UCs. Sub-function → a step. |
| **One actor, one goal, one session** | Exactly one primary actor and one business goal, finished in one sitting | Two goals → two UCs. |
| **System boundary** | Every step is either *actor does something to the system* or *system responds to the actor* | A step with neither is a design detail, not part of the UC. |

### Splitting a large feature into a UC list

| Technique | How |
| :--- | :--- |
| **Goal-driven** | List every goal each actor has → one candidate UC per goal |
| **Event-driven** | List external triggers (user actions) and internal triggers (cron, batch) → one UC per trigger-response |
| **CRUD-driven** | For each business entity, ask which of Create/Read/Update/Delete the system needs → merge R-U-D when the logic is similar |

Output the list **before** writing any UC in detail, and let the user pick which one to draft first:

```
| UC ID      | UC Name (verb + noun)        | Primary Actor | Goal | Priority |
| UC-ORDER-01| Place a delivery order       | Customer      | ...  | High     |
```

---

## 2. The specification

```markdown
# UC-<MODULE>-<NN>: <Verb + object>

| Field | Value |
| :--- | :--- |
| **Use Case ID** | UC-<MODULE>-<NN> |
| **Actor** | **Primary:** <specific role>. **Secondary:** <supporting system or person> |
| **Description** | <2–3 sentences: WHY (reason) + WHAT (action) + OUTCOME (result)> |
| **Preconditions** | 1. <verifiable condition that must be true before start> |
| **Postconditions** | 1. <verifiable system state after success> |
| **Priority** | High / Medium / Low — <one-line justification> |
| **Frequency of use** | <N times per unit time>; peak <…> |
| **Normal course of events** | 1. <Actor action><br>2. <System response><br>3. … |
| **Alternative courses** | **UC-…AC.1: <name>** — at step <N>, if <condition>: <steps> → resume at step <M> |
| **Exceptions** | **UC-…EX.1: <name>** — Trigger: <…> · Response: <…> · Final state: <…> |
| **Includes** | UC-…: <sub-use-case> (invoked at step <N>) |
| **Special requirements** | **Performance** <…> · **Security** <…> · **Reliability** <…> · **Compliance** <…> |
| **Assumptions** | 1. <belief not yet verified> |
| **Notes and issues** | [TBD-1] <question> \| Owner: <…> \| Due: <…> \| Resolution: <…> |
```

---

## 3. Field rules that prevent the usual mistakes

**Name** — verb + object, active voice. `Enroll in course` ✅ · `Enrollment` ❌ (no verb) · `Learner enrolls` ❌ (actor included) · `Manage courses` ❌ (vague verb).

**Actor** — never `User`. Name the role (`Warehouse Clerk`, `Finance Approver`). Primary = initiates and benefits. Secondary = supports (payment gateway, OTP service).

**Preconditions** — must be verifiable, and are **not** business rules. `Customer has an active account` ✅ · `Customer is motivated to buy` ❌ (not verifiable).

**Postconditions** — a **state**, not an action. `Order status = CONFIRMED; stock decremented by 1` ✅ · `System sends a confirmation email` ❌ (that is an action; state the resulting state instead).

**Normal course** — numbered, one action per step, explicit subject, alternating actor/system. **No `if`/`else`/loops** — those belong in alternative courses and exceptions.

> ❌ `1. If the customer has a voucher, apply it; otherwise proceed to payment.`
> ✅ `1. Customer selects a voucher.` / `2. System validates the voucher against BR-PRICE-004 and applies the discount.`

**Alternative course** — a different path that **still succeeds**. Must state *at which step* it branches and *where it rejoins*.

**Exception** — the goal **fails**. Every exception needs three things: trigger, system response, and final state. `An error occurred` is not an exception.

**Includes** — points to another UC that exists. A dangling include is a broken reference, not a plan.

**Special requirements** — non-functional only (performance, security, compliance). A functional requirement here is a misplaced requirement.

**Assumptions** — beliefs, not requirements. If the build depends on it being true, it is a precondition or a `[NEED:]`, not an assumption.

---

## 4. The 20-point check (run before handover)

| # | Check |
| :-: | :--- |
| C1 | Name is verb + object, active voice |
| C2 | Passes the coffee-break test (user-goal level) |
| C3 | ID is unique and follows the convention |
| C4 | Exactly one primary actor, one business goal |
| C5 | System boundary is clear — does not bleed into another UC |
| C6 | Actor is a specific role, not "User" |
| C7 | Description answers WHY + WHAT + OUTCOME |
| C8 | Frequency is quantified, not "sometimes" |
| C9 | Preconditions are verifiable, not disguised business rules |
| C10 | Postconditions cover the success state and every system change |
| C11 | Preconditions are not confused with assumptions |
| C12 | Normal course is numbered, one action per step |
| C13 | Actor and system steps alternate with explicit subjects |
| C14 | No embedded `if`/`else`/loop in the normal course |
| C15 | Flow runs from trigger to postcondition with no dangling step |
| C16 | Every alternative course states "at step N" and where it rejoins |
| C17 | Every exception has trigger + response + final state |
| C18 | Common failures covered: timeout, invalid input, network, permission denied, concurrency conflict |
| C19 | Every `Includes` points to a UC that exists |
| C20 | Special requirements do not duplicate functional requirements |

Report as `Item | Status | Note` with ✅ / ❌ / ⚠️. **A UC with any ❌ is not ready for M05.**

---

## 5. Anti-patterns

| Anti-pattern | What it looks like | Fix |
| :--- | :--- | :--- |
| **UC as UI flow** | Every button click and popup | Describe the actor–system dialogue, not the wireframe |
| **UC as user story** | "As a user I want…" | A UC is a detailed interaction; a story is a one-liner |
| **UC as business process** | Several people and systems across days | One actor, one system, one session |
| **Vague verbs** | "Manage", "Handle", "Process" | A specific action verb |
| **Mixing concerns** | Enrollment + payment + notification in one UC | Split with `Includes` |
| **Happy path only** | No exceptions | Map failure modes systematically |
| **Unverifiable preconditions** | "System is ready" | A checkable condition |

---

## 6. Delivering it

- **Sequential drafting is the default for review-heavy work**: write the fields in five groups (identification+actor+description → conditions+priority+frequency → normal course → alternatives+exceptions → includes+special+assumptions+notes) and pause for confirmation between groups. One confirmation per group catches scope errors before they propagate into eight fields.
- **If the user asks for the whole UC at once, give it** — but say once that sequential mode catches more issues, then drop it.
- **File naming**: `docs/specs/UC-<MODULE>-<NN>_<kebab-name>.md`.
- **Traceability**: link the UC ID from `REQUIREMENTS_REGISTER_TEMPLATE.md` so a requirement and its UC cannot drift apart.
