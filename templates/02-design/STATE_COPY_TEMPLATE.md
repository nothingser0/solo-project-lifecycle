# State Copy Template (Empty · Error · Success · Loading · Onboarding)

> **Module**: M04 (UI/UX) — fills the 5-state matrix in `DESIGN_SPEC.md` with **actual copy**, not placeholders
> **Purpose**: Every state a screen can be in needs words. This template writes them once, in the brand voice, instead of improvising during M06.
> **Output Location**: `docs/specs/STATE_COPY.md` (referenced from `DESIGN_SPEC.md` §5)
> **Rules**: `references/design/BRAND_VOICE_GUIDE.md` (voice, banned words) · `references/design/CONTENT_QUALITY_SCORECARD.md` (scoring; below 7 on any axis is a finding)
> **Source**: Adapted from `content-designer/ux-writing-skill` (MIT) — the state structures and the first-use vs cleared distinction.

---

## 1. Empty states — three different jobs

Most products ship one empty state for three unrelated situations. They need different words.

| Type | When | Tone | Structure |
| :--- | :--- | :--- | :--- |
| **First-use** | The user has never added anything | Inviting, benefit-led | `[What's empty] + [benefit of filling it] + [specific action]` |
| **User-cleared** | The user completed everything (inbox zero) | Positive, brief | `[Completion statement] + [when new items appear]` |
| **No-results** | A filter/search matched nothing | Neutral, corrective | `[What matched nothing] + [how to widen] + [clear filters]` |

```
First-use
  Title:  No projects yet
  Body:   Create your first project to start organising work.
  CTA:    Create project

User-cleared
  Title:  You're all caught up
  Body:   New orders will appear here.

No-results
  Title:  No invoices match "October"
  Body:   Try a different month, or clear the filter to see everything.
  CTA:    Clear filters
```

**Rules**
- Never say "No data" — it describes the database, not the situation.
- The first-use CTA must be the **same action** the screen's primary button performs. Two different labels for one action is a defect.
- A no-results state must never offer "Create" as the primary action — the user was looking for something that may already exist.

---

## 2. Error messages — by layer

| Layer | Where it appears | Structure | Example |
| :--- | :--- | :--- | :--- |
| **Validation** (inline) | Below/beside the field, on blur or submit | `[Field] [specific requirement]` | "Email must include @" |
| **System** (banner/modal) | When a backend operation fails | `[What failed] + [likely cause] + [recovery step]` | "We couldn't save your changes. Your connection may have dropped. **Retry**" |
| **Blocking** (full screen) | The app cannot continue | `[State] + [what still works] + [who to contact]` | "We're having trouble loading your workspace. Your data is safe. **Reload**" |

**Rules**
1. **Never blame the user.** "You entered an invalid email" → "Email must include @".
2. **Never a dead-end code.** "Error 0x80042109" → a sentence, with the code available on request.
3. **Name what still works** when something breaks. "Your data is safe" prevents support tickets.
4. **One action per error.** Two CTAs split attention at the moment the user is already frustrated.
5. **Errors are announced**, not just shown — `role="alert"` or `aria-live="polite"`, and the input carries `aria-describedby` + `aria-invalid` (see `templates/06-qa-uat/ACCESSIBILITY_AUDIT_TEMPLATE.md` §5).

---

## 3. Success and confirmation

| Type | Use | Structure |
| :--- | :--- | :--- |
| **Inline success** | A small change (saved, copied) | `[What happened]` — 1 line, or a toast |
| **Milestone success** | A completed flow (payment, publish) | `[What happened] + [what happens next] + [one next action]` |
| **Destructive confirmation** | Before an irreversible action | `[What will be lost] + [whether it can be undone] + [confirm verb]` |

```
Destructive confirmation
  Title:  Delete this project?
  Body:   12 documents and 3 members will lose access. This cannot be undone.
  Confirm: Delete project          ← the verb repeats the action
  Cancel:  Keep project            ← not "Cancel": name what is kept
```

**Rules**
- The confirm button repeats the verb ("Delete project", not "Yes" or "OK").
- The cancel button names what is kept ("Keep project", "Go back") — "Cancel" is ambiguous about whether the action or the dialog is being cancelled.
- State irreversibility explicitly. "This cannot be undone" is the sentence users actually read.
- A toast is **never** the only evidence of a critical success (payment, data export) — pair it with a persistent record.

---

## 4. Loading states

| Duration | What to say |
| :--- | :--- |
| < 300 ms | Nothing. A flash of "Loading…" is worse than a brief pause. |
| 300 ms – 3 s | Skeleton or spinner, no text needed |
| 3 – 10 s | `[What is happening]` — "Importing 1,240 rows…" |
| > 10 s | `[What is happening] + [progress or estimate] + [what to do meanwhile]` |
| Long / background | "You can leave this page — we'll email you when it's done." |

**Rules**
- Name the **thing**, not the mechanism: "Saving invoice…" beats "Processing…".
- Never a percentage that lies. If you cannot measure progress, use an indeterminate indicator.
- A loading state that never resolves needs a timeout with a recovery action.

---

## 5. Onboarding

```
Welcome → Setup → First Success → Next Steps
```

Each step answers four questions in the copy itself:

| Question | Answered by |
| :--- | :--- |
| Where am I? | A progress indicator ("Step 2 of 3") |
| What do I do here? | One instruction, imperative |
| Why does this matter? | One sentence of benefit |
| Can I skip? | A visible skip / "I'll do this later" |

**Principles**
1. **Value in the first session** — the user should finish something real, not a tour.
2. **Progressive disclosure** — do not explain features the user has not met.
3. **Optional wherever possible** — a mandatory step must justify itself in one sentence.
4. **Celebrate small wins** — acknowledge each completed step, briefly.
5. **Be concise** — users want to use the product, not read about it.

**Anti-pattern**: a welcome carousel that explains the product to someone who has not yet used it. Replace it with one action that produces a first success.

---

## 6. Completion checklist

- [ ] Every state in the `DESIGN_SPEC.md` 5-state matrix has **real copy**, not a placeholder
- [ ] Empty states are split by type (first-use / cleared / no-results)
- [ ] Every error names what failed **and** what to do
- [ ] No error blames the user; no raw error code is the whole message
- [ ] Destructive confirms repeat the verb; cancels name what is kept
- [ ] Success messages for irreversible actions persist somewhere beyond a toast
- [ ] Loading states over 3 s name the thing being loaded
- [ ] Onboarding ends in a first success, not a tour
- [ ] Every string scores ≥ 7 on all four axes (`CONTENT_QUALITY_SCORECARD.md`)
- [ ] Longest-locale length checked for buttons and labels (copy expands 20–35% in translation)
