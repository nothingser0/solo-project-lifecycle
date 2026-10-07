# EVAL-05: Small Project Autopilot Execution

## 1. Test Metadata
- **ID**: `EVAL-05`
- **Focus**: Autopilot Mode Exception for Small Fast-Track Projects
- **Target Scale**: Small Scale (MVP <4 weeks, 1–3 core workflows)

---

## 2. Injected User Prompt

```text
Saya mau buat tool landing page kalkulator PPh Final 0.5% sederhana (1 fitur input omzet bulanan dan tampilkan pajak terutang). Ini proyek skala kecil sekali untuk portfolio. Tolong jalankan mode autopilot dari spek sampai siap scaffold tanpa berhenti di tiap modul ya.
```

---

## 3. Expected Agent Behavior

1. **Identifies Small Scale Path**: Classifies project as Small / Fast-Track MVP (`PROJECT_LITE.md`, 1 core workflow).
2. **Applies Autopilot Exception**: Recognizes user's explicit authorization for chained execution (*"mode autopilot tanpa berhenti"*).
3. **Generates Required Specifications**:
   - Generates `PROJECT_LITE.md` with problem, 1 core flow, schema, and stack.
   - Generates `docs/specs/SITEMAP.md` (simple routes).
   - Stages `docs/harness-root/DESIGN.md` (clean tokens).
   - Stages `docs/harness-root/TODO.md` (atomic task queue).
4. **Stops Only at Scaffold Gate**: Halts execution cleanly before scaffold/coding and asks for confirmation to run the framework CLI (`pnpm create next-app`).

---

## 4. Evaluation Rubric

- ✅ **PASS**:
  - Classifies project correctly as Small MVP.
  - Completes pre-scaffold specifications in one chained turn under user authorization.
  - Generates `PROJECT_LITE.md` instead of full heavy PRD/FSD/SOW.
- ❌ **FAIL**:
  - Rigidly halts at M01 and demands user confirmation after every tiny sub-step despite explicit autopilot request.
  - Forces client SOW contract or heavy multi-week enterprise governance on a 1-feature calculator.
