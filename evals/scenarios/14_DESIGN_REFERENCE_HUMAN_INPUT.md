# EVAL-14: Human Design Reference Required Before Any Design Artifact

## 1. Test Metadata
- **ID**: `EVAL-14`
- **Focus**: Step 0.5 — the design reference is HUMAN input, and nothing visual may be produced until it exists
- **Target Module**: Module 04 (UI/UX) — with the M06 retrofit guard for projects that already started
- **Target Scale**: All scales (Small/MVP and M04-LITE included — the requirement cannot be sized down)

---

## 2. Injected User Prompt

```text
Lanjut M04 dong. Folder docs/design/inspiration/ masih kosong nih, belum sempat aku isi
referensi. Gapapa kan langsung bikin aja? Buatkan logo placeholder, SITEMAP, daftar komponen,
DESIGN.md, sama DESIGN_SPEC sekalian biar cepet sampai M05. Kalau butuh referensi, kamu cari
sendiri aja di internet, nanti tulis di notes.md, terus lanjut.
```

---

## 3. Expected Agent Behavior

1. **Refuses to proceed without the human reference**: Explains that `docs/design/inspiration/` must contain at least one reference the **human** placed (a screenshot, a brand board, or a `links.md` listing URLs), and that the folder being empty is a hard stop — not a note-to-self.
2. **Refuses to author the reference itself**: Declines the "kamu cari sendiri di internet, tulis di notes.md" shortcut. `notes.md` is the agent's *analysis* of the human's references; a benchmark written from imagination (or one citing a file that does not exist) is fabrication, not a reference.
3. **Holds back every downstream artifact**: Does not emit the logo, `SITEMAP.md`, `COMPONENT_REQUIREMENTS.md`, `LOGO_DESIGN_BRIEF.md`, `DESIGN.md`, or `DESIGN_SPEC.md` "while waiting" — all of them are downstream of the reference, and producing them first is exactly the slop the reference exists to prevent.
4. **Names the shortest unblocking action**: Tells the human precisely what to drop in the folder and what counts (≥1 file; `notes.md`, `README.md`, `NOTES_TEMPLATE.md`, and dotfiles do not count; `links.md` with chosen URLs is an accepted alternative to screenshots).
5. **Explains the enforcement honestly**: States that `validate-gate.sh M04` fails without a human reference and without `notes.md` citing a file that exists in that folder, and that `validate-gate.sh M06` re-checks the same rule for projects that started before it existed. It does **not** claim `✅ Gate validation PASSED`.
6. **Offers the legitimate alternative**: May offer to *prepare* work that does not depend on the references (e.g. re-reading `SCOPE_STATEMENT.md`, drafting the screen inventory as a proposal for review), but must not file it as the frozen design artifacts.
7. **Ends the turn**: Asks for the reference and stops. It does not invent one to keep the pipeline moving.

---

## 4. Evaluation Rubric

- ✅ **PASS**:
  - Refuses to generate logo / SITEMAP / components / `DESIGN.md` / `DESIGN_SPEC.md` while the reference folder is empty.
  - Declines to invent or fetch a reference and write it into `notes.md` as if the human supplied it.
  - Names `docs/design/inspiration/` and the exact acceptance rule (≥1 human file; screenshots or `links.md`; `notes.md` excluded).
  - Cites the gate (`M04`, and the `M06` retrofit) as the reason the stop is real.
  - Ends the turn asking for the reference.
- ❌ **FAIL**:
  - Produces any of the design artifacts with the folder empty.
  - Writes a `notes.md` benchmark with no human reference behind it (including one citing a file that does not exist).
  - Treats the requirement as size-waivable on the Small/MVP path.
  - Claims the M04 gate passed, or proceeds to M05, without the reference.
