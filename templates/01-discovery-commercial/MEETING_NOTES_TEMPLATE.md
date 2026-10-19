# Meeting Notes → Decisions & Action Items Template

> **Module**: M02 (Discovery & Scope) — turn raw interview / workshop / kickoff notes into records that survive
> **Output Location**: `docs/pm/meetings/YYYY-MM-DD_<topic>.md`
> **Source**: Adapted from `luckybajaj22031996/pm-ba-claude-skills` (MIT) — the decisions / action items / open questions separation and the "never fabricate a decision" rule. Rewritten for this framework.
> **Companion**: `MEETING_CADENCE_GUIDE.md` (which meetings exist) · `INTERVIEW_GUIDE_TEMPLATE.md` (the instrument that produces these notes) · `COMMUNICATION_PLAN_TEMPLATE.md`

---

## 1. The rule that matters

**Discussion is not a decision.** Most meeting notes fail because a topic that was *talked about* is written up as though it were *settled*. Six weeks later someone builds against a decision nobody made.

| The notes said | What it is | Where it goes |
| :--- | :--- | :--- |
| "We agreed to use Postgres" | Decision | **Decisions** |
| "Postgres came up and seemed reasonable" | Discussion | **Summary** — not a decision |
| "Can someone check the pricing?" | Action item | **Action items**, owner `[Unassigned]` if unnamed |
| "We should think about scaling" | Open question | **Open questions** |
| "Let's take this offline" | Deferred | **Open questions**, marked deferred |

**Never invent a decision to make the notes look complete.** If a section is genuinely empty, write *"No explicit decisions were identified in these notes"* and move on. An empty section is information; a fabricated one is a defect.

---

## 2. The record

```markdown
# <Meeting title>

| Field | Value |
| :--- | :--- |
| **Date** | YYYY-MM-DD |
| **Attendees** | <names, roles> |
| **Type** | Kickoff / Discovery interview / Workshop / Review / Steering |
| **Notes by** | <name> |
| **Source** | <recording, transcript, or "notes only — not recorded"> |

## Summary

<What happened, in 2 minutes of reading. Past tense. Each point 2–3 sentences.>
<Organise under topic headings if the meeting had distinct agenda items; flat otherwise.>

## Decisions

| # | Decision | Rationale | Made by | Date |
| :-: | :--- | :--- | :--- | :--- |
| D1 | <definitive statement — "The system will use X", not "X was discussed"> | | | |

> A decision is something agreed, resolved, or committed to. If the room only explored options, it is not here.

## Action items

| # | Action | Owner | Due | Status |
| :-: | :--- | :--- | :--- | :--- |
| 1 | <a specific, doable task> | <name / [Unassigned]> | <date / TBD> | Open |

> "I'll look into it" and "can you check X" are action items. Record them, with `[Unassigned]` rather than guessing who meant it.

## Open questions

| # | Question | Raised by | Status |
| :-: | :--- | :--- | :--- |
| Q1 | <unresolved> | | Open / Deferred / Answered YYYY-MM-DD |

## Assumptions introduced

| # | Assumption | Basis | Needs verification by |
| :-: | :--- | :--- | :--- |
| A1 | <something believed but not stated by a stakeholder> | | |
```

---

## 3. Extraction rules

**Decisions** — write as a definitive statement. `The team will use React for the frontend` ✅ · `React was discussed as an option` ❌. If the rationale is not in the notes, leave it blank; do not reconstruct one.

**Action items** — must be specific and doable. `Check the payment gateway's webhook retry behaviour by Friday` ✅ · `Look into payments` ❌. Owner unknown → `[Unassigned]`, never a guessed name. Deadline unknown → `TBD`, never a plausible date.

**Open questions** — everything raised and not resolved, including items explicitly deferred ("let's take this offline") and questions asked that nobody answered.

**Assumptions** — the dangerous category. Anything you inferred while writing the summary that a participant did not actually say. Record it here so it can be challenged. This is the meeting-notes equivalent of the framework's 🔶 ASSUMPTION mark.

---

## 4. What not to record

- **Verbatim transcripts.** The point is synthesis; a transcript is a source artifact, not a deliverable. Keep it separately if it exists and link it.
- **Blame and personality conflict.** Record the decision and the objection, not who was frustrated with whom.
- **Secrets and unrelated personal data.** Check before sharing the file; a meeting note is easy to forward.
- **Routine chatter and unchanged status.** These notes exist to be re-read; padding reduces the chance anyone will.

---

## 5. Exit checklist

- [ ] Every entry under **Decisions** is something that was actually agreed, not merely discussed
- [ ] Every action item has an owner (`[Unassigned]` counts) and a due date (`TBD` counts)
- [ ] Every deferral appears under Open questions, not omitted
- [ ] Assumptions are separated from decisions
- [ ] The summary is readable in two minutes
- [ ] No fabricated rationale, owner, date, or decision
- [ ] File name matches `YYYY-MM-DD_<topic>.md` so the folder sorts chronologically
