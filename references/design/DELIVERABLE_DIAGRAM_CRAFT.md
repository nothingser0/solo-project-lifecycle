# Deliverable Diagram Craft (SVG)

> **Module**: M04 (design handoff) & M05 (architecture specs) — the diagrams that ship **inside a client deliverable**
> **Source**: Principles adapted from `bybit-exchange/svg-diagram` (MIT) — block spacing, text-width estimation, paint order and the verification checklist. Written for this framework.
> **Scope limit — read this first.** This file governs **a new SVG figure you author from scratch** for a deliverable. It changes nothing that already exists:
> - **ASCII box diagrams stay.** `FSD_TECHNICAL_TEMPLATE.md` §2 ships one, and 20 of 56 files in `patterns/*` use box-drawing characters. Those are deliberate and correct — a text diagram diffs cleanly, renders in any editor, and needs no coordinates. Do not convert them because of this file.
> - **Mermaid stays.** Every `erDiagram`, sequence and flowchart already in the templates is the right tool and is not replaced by this file.
> - **The two rules that are safe to apply generally are §3.2 (block spacing) and §3.3 (text width)** — and even those only to SVG you are authoring, because they describe coordinates that ASCII and Mermaid do not have.
> **Flow rules**: `patterns/architecture/REPOSITORY_BACKED_ARCHITECTURE_DIAGRAM_PATTERN.md` governs *what* may be drawn (evidence-backed nodes). This file governs *how* the file is authored.

---

## 1. Mermaid first, SVG when it is not enough

| Need | Use |
| :--- | :--- |
| ERD, sequence, flowchart, class, state, gantt | **Mermaid** — text, diffable, renders everywhere, no coordinates |
| Brand-level figure, precise layout, CJK typography, a figure the client will print | **SVG** |

Reach for SVG only when Mermaid genuinely cannot express the figure. Mermaid is diffable and reviewable; a hand-placed SVG is neither, and every content change means touching coordinates.

**A plain text diagram is also a valid answer.** Most architecture figures in this framework are `text` blocks with box-drawing characters, and that is not a lower tier — it is the correct choice when the figure must survive copy-paste, email, and a terminal. SVG is for the case where layout itself carries meaning: a printed brand figure, a precise deployment topology, CJK typography. When in doubt, use the text diagram.

---

## 2. Where the file goes

- Put it next to the document: `docs/specs/foo.md` → `docs/specs/assets/foo-arch.svg`.
- Reference it with a relative path, with the file sitting beside the document: an image tag whose alt text is the figure title and whose source is the relative `.svg` path. **Never inline the SVG XML** into the markdown: it makes diffs unreadable and breaks the viewer.
- **When the data in the document changes, the SVG must change too.** A figure that contradicts the prose beside it is worse than no figure, because the reader trusts the picture first.

---

## 3. The five rules that prevent most bad SVGs

### 3.1 Nothing overlaps

- Text must not sit on a box or a line.
- A line must not cut through a box — unless it is an arrow terminating at that box.
- Keep 10–20px between text and lines.
- Put legends outside the diagram body (bottom or side), never over the content.

### 3.2 Block spacing: one standard

**≥25px between adjacent boxes; 25–30px recommended.** Breakdown: 5px start clearance + 11px end clearance and arrowhead + **≥6px of visible line** + safety margin ≈ 25px. Under 6px of visible line, an arrow degenerates into a dot.

Do not exceed ~30px. Wider spacing (>40px) reads as loose and stretches every connector. If the content looks small relative to the canvas at the end, tighten spacing or shrink the `viewBox` — do not add scenery.

### 3.3 Estimate text width before placing it

Overflow is the most common silent defect: the text renders, the figure looks fine at 100%, and the label collides with a neighbour at print size.

| Font size | Latin char | CJK char |
| :--- | :--- | :--- |
| 8px | 4.5px | 8px |
| 9px | 5.0px | 9px |
| 10px | 5.5px | 10px |
| 11px | 6.0px | 11px |
| 12px | 7.0px | 12px |

- `text-anchor="start"`: right edge ≈ `x + chars × charWidth`
- `text-anchor="middle"`: edges ≈ `x ± (chars × charWidth) / 2`
- `text-anchor="end"`: left edge ≈ `x − chars × charWidth`

**Check before committing**: text right edge + 10px < left edge of the neighbour on its right.

### 3.4 SVG has no z-index — paint order is the layer order

Elements painted **later** sit on top. Always author in this order:

1. Background boxes (grouping containers, swimlanes)
2. Connectors and arrows
3. Node boxes
4. Text labels
5. Legend

An arrow that disappears behind a box is a paint-order bug, not a routing bug.

### 3.5 Escape special characters

`&` → `&amp;` · `<` → `&lt;` · `>` → `&gt;`. A raw `<` in a label silently truncates the element and produces a blank region you will hunt for later.

---

## 4. Verification checklist (walk it yourself, before showing anyone)

- [ ] No overlaps between text, boxes and lines
- [ ] No text right edge intrudes on a neighbour (estimated from §3.3)
- [ ] ≥15px between a curve label and the nearest point on the curve
- [ ] Arrow clearance symmetric at both ends (5px), visible segment ≥6px
- [ ] Markers declare `markerUnits="userSpaceOnUse"`
- [ ] Thick strokes (>1.5) use the enlarged marker
- [ ] Connectors use C/Q curves — no right angles
- [ ] Labels centred (`text-anchor="middle"`) where they sit on a path
- [ ] Block spacing ≥25px (25–30px recommended)
- [ ] Title centred; boxes in a row are similar in size
- [ ] `width` attribute present; `viewBox` matches the content
- [ ] Box heights sufficient (one line ≥ font-size × 3)
- [ ] Top and bottom `viewBox` margins comparable (20–25px, measured from the title)
- [ ] Left and right padding symmetric — shift with `<g transform="translate(dx,0)">` if not
- [ ] Special characters escaped
- [ ] Every element inside the visible `viewBox` (bottom = lowest element + 25px)
- [ ] Every connector has a clear meaning — labelled, or source and target inferable
- [ ] Grouping boxes styled consistently (dash pattern, corner radius, fill, padding, title size)
- [ ] No large blank regions

**"Get it right on the first pass"** — do not rely on the client to notice the spacing is wrong. Walk this list before the figure reaches anyone.

---

## 5. Editing an existing SVG

1. **Collect the full change set first.** If the request names one adjustment, ask "anything else you want adjusted?" and get the whole list. Applying changes one at a time means re-placing the same elements repeatedly.
2. **Apply all changes at once**, with a written change list.
3. **When you move an element, update its dependents in lockstep** — the connector endpoints, the label position, and any boundary comment that recorded its coordinates.

Record element boundaries in comments so a later edit can find them.

---

## 6. Honest limit

There is no linter for these rules in this framework. The upstream project ships one (`svg-lint`) and states plainly that it is a maintainer tool, **not** an agent self-check gate. Without it, §4 is a checklist you must actually walk — and a figure that was never inspected should not be presented as finished.
