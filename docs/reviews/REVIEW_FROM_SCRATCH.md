# Review from scratch — empty-paper pass over solo-project-lifecycle

> **Question**: if this were designed today, with no repo in front of us, what would it be?
> **Discipline**: this document was written from the brief alone. Every number in §2 and §4 is
> measured from the repo (`grep`/`wc`/gate counts), not remembered. Where the repo is better than
> the blank-page design, that is recorded too — the blank page is a probe, not the truth.

---

## 1. The brief (as written from empty paper)

> *A solo developer or a 1–3 person team wants to ship software without enterprise process.
> They need three things and nothing else: (a) a decision record so nothing is re-litigated,
> (b) a way to stop themselves from building the wrong thing, (c) a handoff so the next session
> — human or agent — knows where it stopped. Everything else is the framework's problem, not theirs.*

Written plainly, the brief asks for **three artefacts**, a **stop rule**, and a **handoff**. That
is one page, not 530 files.

### The blank-page design (what I would build today)

```
START
 └─ 1 question: "what is the one number that means this worked?"
     └─ write it in STATE.md (10 lines: goal, in-scope 3, out-of-scope 3, next action, open questions)
         └─ BUILD loop, one task at a time:
              task → do it → prove it with a command → human ticks → next
                  └─ STATE.md updated every stop
                      └─ SHIP when the goal line is measurable
```

Deliberately **absent** from the blank page:

- Documents that restate the brief (PRD, FSD, charter) — a 3-feature MVP's contract fits in one page.
- Phase numbering (M00…M13) — the numbers create the illusion that every phase must happen.
- Gate scripts — a solo dev's gate is "does the command pass?" not a 45-check runner.
- Skills, patterns, taxonomies — these assume the agent lacks domain knowledge; a competent model
  already knows what a REST endpoint or an index is.
- Roles/authority matrices — for one person, "who decides" is not a question.
- Design-system mandates — "use one icon set" is one sentence, not a Visual DNA list with 9 rules.

That design would be ~2 pages of prose, 1 state file, 1 gate command.

---

## 2. What the repo actually is (measured, not estimated)

| Dimension | Blank page | This repo |
|---|---|---|
| Files | ~3 | **530** |
| Prose volume | ~2 pages | **14 runbooks** (~150 KB) + 52 patterns + 66 references |
| Gate requirements | 1 command | **172 `❌` checks** across 19 module+advisory gates (M06 alone: **39**) |
| Forced human stops on the Small path | 0 explicit | **2 `[STOP]`** + M04 component ACC + M05 stack lock + per-task `[x]` approval |
| Templates the Small path needs | 0–1 | **17 copies** named by the scaffold |
| Machine-checked documents | 0 | **96 distinct artifact paths** |
| Decisions the human must sign | 0 | contract, SOW, Design Freeze, stack lock, UAT, BAST, capacity-risk |

The gap is not proportional — it is a **different category of thing**. The blank page is a
checklist; this repo is a delivery system with its own QA harness (135 regressions, 24 golden
outputs, 18 evals).

---

## 3. Where the repo is right and the blank page is wrong (three real corrections)

Being honest about the other direction, because a review that only finds over-engineering is
itself over-engineered:

1. **The blank page says "one page contract".** For a *solo MVP* that holds. For **client work**
   it does not: the DP milestone, the BAST, and the signed change-request boundary are not
   ceremony, they are the mechanism that gets paid. The repo is right to split by scale.
2. **The blank page trusts the model's knowledge.** The anti-hallucination rules only exist
   because models *do* invent APIs, seed data, and testimonials. The repo's `PENDING_PRIMARY_RESEARCH`
   marker and the M00 evidence thresholds (≥5.0% waitlist, ≥5 deposits, ≥2 LOIs) encode a
   discipline the blank page lacks entirely.
3. **The blank page has no handoff.** Its `STATE.md` is one file and would drift. The repo's
   gate-enforced `Next-Action:` / `Open-Decisions:` is genuinely better than anything on the
   blank page — it fails loudly instead of silently.

---

## 4. The three structural findings

### Finding A — the repo optimises for *evidence of process*, the brief asks for *progress*

The 96 gate-required artifact paths exist so a gate can prove a document exists. A solo dev's
real question is "am I closer to shipping?" — and nothing in the gate set answers that. Nothing
measures *time from idea to first working screen*, which is the only metric the brief cares about.

**Consequence**: 172 checks protect a paper trail, and no check protects momentum. This is why the
flow feels heavy even when the artifacts are small.

### Finding B — "one task per turn, human ticks every task" is a throughput ceiling

M06 rule: implement one TODO task → verify → END TURN → human approves `[x]`. Correct for quality,
but for a 30-task MVP it forces **30 round trips** on top of the 2 stops and the ACC gates. The
blank page has none. Neither extreme is right: the ceiling should be *risk-based* — batch the
trivial, one-at-a-time the destructive.

### Finding C — the framework's own size became a rule

SKILL.md spends 20 lines on "how not to load too much of this framework", and `deep-dives/` exists
to hold what the runbooks cannot. A framework that must budget its own context is telling you it
is larger than the job. This is measurable: SKILL.md 18 KB, deep-dives 284 KB, and the Small path
alone is ~25k tokens before any project work begins.

### Correction to this review — Finding 3 was already solved

The first draft of §5 proposed "make the Small path a first-class 1-page flow". **That already
exists and predates this review**: `docs/QUICKSTART.md` (465 lines) carries *The Small-Path MVP
Flow*, an explicit "Skip These Modules" table (M00, M01, M02, M03, M07, M08, M11, M13), a
"Do These Only" table for the 7 modules a Small project actually runs, a day-by-day Day 1–14 plan,
the template shortlist, and an upgrade path. `docs/modules/variants/04_UIUX_LITE.md` is the
matching M04 variant.

So the defect is **discoverability, not absence**: nothing in the scale router pointed at it. The
fix is one pointer in the router, not a new document. Recorded here because a review that proposes
building what already exists is the exact duplication this repository keeps finding in itself
(`check-anti-slop.py`, the duplicate `INCIDENT_RESPONSE_TEMPLATE.md`).

---

## 5. What changes if we accept the review

Ranked by evidence, not taste. **Deletions first** — the brief is met by removing, not adding.

| # | Change | Why | Risk |
|---|---|---|---|
| 1 | Replace the 2 `[STOP]`s and per-task approval with **one risk-based stop rule**: stop only for irreversible actions (contract, schema, deletion, payment) | Finding B; 30 round trips is real friction | medium — needs consent, not silent change |
| 2 | Add **one momentum metric** to PROJECT_STATE: date started, date of first working screen, date of ship | Finding A; no gate measures progress | low |
| 3 | ~~Make Small path a first-class 1-page flow~~ → **already exists** (`docs/QUICKSTART.md` § The Small-Path MVP Flow). Replaced by: one pointer from the SKILL.md scale router | Finding C; the flow existed but was unreachable from the entry point | **done, zero risk** |
| 4 | Keep: gate-enforced handoff, change fence, anti-yes-man, scale escalation for statutory compliance | §3 — these are the repo's real value | none |
| 5 | Delete nothing else this round | prunes are cheap only when nothing points at them | — |

---

## 6. Verdict

The **idea is sound and proven**; the **execution overshot the brief by an order of magnitude**.
But the overshoot is concentrated in three places (numeric phase ceremony, evidence-only gates,
per-task approval), not spread evenly — which means it is fixable in three changes, not a rewrite.

A rewrite would lose the three things the blank page got wrong (§3). The right move is subtraction
guided by the brief, not a new build.
