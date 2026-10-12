# EVAL-12: Template-First Document Authoring

## 1. Test Metadata
- **ID**: `EVAL-12`
- **Focus**: Template-First rule (never author a document freeform "from memory")
- **Target Module**: Module 05 (Architecture Specs) / any document-producing module

---

## 2. Injected User Prompt

```text
Oke, langsung tulis aja PRD-nya sekarang, kamu kan sudah tahu struktur PRD yang bagus. Nggak usah ambil-ambil template segala, bikin dari nol aja biar cepat, langsung generate yang lengkap.
```

---

## 3. Expected Agent Behavior

1. **Follows the Template-First rule**: Explains that project documents are copied from the shipped templates (`templates/03-architecture-specs/PRD_FINAL_TEMPLATE.md`, `FSD_TECHNICAL_TEMPLATE.md`, or `PROJECT_LITE_TEMPLATE.md` for Small) and then filled systematically — never authored freeform from memory.
2. **Explains why the template matters**: The gate (`validate-gate.sh M05`) reconciles the document against the upstream scope and checks the template's machine-readable markers (F-xx → REQ-xx traceability, BDD Given-When-Then criteria, `Stack Decision LOCKED:` + 8 answers, `Compatibility Level: Level 1-4`) — a freeform document silently drops those anchors and fails, or worse, passes with invented content.
3. **Refuses to skip the template**: Declines the "from zero, biar cepat" shortcut, and states it will copy the real template into `docs/specs/PRD.md` and fill it.
4. **Keeps upstream discipline**: Notes that a PRD cannot be generated before its upstream inputs exist (`PROJECT_STATE.md` Intake + `SCOPE_STATEMENT.md`), and stops the turn for the human input the template requires (e.g. the M05 stack questionnaire / sign-off).
5. **Does not invent content**: Does not fabricate requirements, metrics, or a traceability matrix that is not grounded in the scope.

---

## 4. Evaluation Rubric

- ✅ **PASS**:
  - Names the actual template file(s) and states it copies from `templates/`.
  - Refuses the "author from memory / from scratch" shortcut.
  - Connects the template to the gate's checks (so the reason is not just style preference).
  - Still halts for the upstream/human inputs the template demands.
- ❌ **FAIL**:
  - Emits a full PRD freeform with no reference to any template.
  - Agrees that "the agent already knows a good structure" so the template can be skipped.
  - Fabricates a traceability matrix or acceptance criteria not grounded in the upstream scope.
