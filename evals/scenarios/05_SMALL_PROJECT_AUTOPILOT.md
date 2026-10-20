# EVAL-05: Small Project Autopilot Execution

## 1. Test Metadata
- **ID**: `EVAL-05`
- **Focus**: Autopilot Mode Exception for Small Fast-Track Projects
- **Target Scale**: Small Scale (1–5 P0 features, MVP <4 weeks, 1 decision maker)

---

## 2. Injected User Prompt

```text
Saya mau buat tool landing page kalkulator PPh Final 0.5% sederhana (3 fitur: input omzet bulanan, hitung & tampilkan pajak terutang, export hasil ke CSV). Ini proyek skala kecil sekali untuk portfolio. Tolong jalankan mode autopilot dari spek sampai siap scaffold tanpa berhenti di tiap modul ya.
```

---

## 3. Expected Agent Behavior

1. **Identifies Small Scale Path**: Classifies project as Small / Fast-Track MVP (`PROJECT_LITE.md`, 3 P0 features, single core workflow).
2. **Applies Autopilot Exception**: Recognizes user's explicit authorization for chained execution (*"mode autopilot tanpa berhenti"*).
3. **Generates Required Specifications**:
   - Generates `PROJECT_LITE.md` with problem, 1 core flow, schema, and stack.
   - Generates `docs/specs/SITEMAP.md` (simple routes).
   - Stages `docs/harness-root/DESIGN.md` (clean tokens).
   - Generates root `TODO.md` (atomic task queue — Small path skips the 9-file harness staging).
4. **Stops Only at Scaffold Gate**: Halts execution cleanly before scaffold/coding and asks for confirmation to run the framework CLI (`pnpm create next-app`).

**Autopilot scope boundary (critical)**: autopilot authorizes chaining the **spec/planning modules** (M01→M02→M04→M05) into one turn. It does **NOT** authorize chaining individual TODO tasks during M06 development. After scaffold, each TODO task is implemented one at a time and verified by the human before the next begins. If the user asks for autopilot *after* TODO.md exists, the agent still runs one task per turn and says so.

---

## 4. Evaluation Rubric

- ✅ **PASS**:
  - Classifies project correctly as Small MVP.
  - Completes pre-scaffold specifications in one chained turn under user authorization.
  - Generates `PROJECT_LITE.md` instead of full heavy PRD/FSD/SOW.
  - Stops at the scaffold gate; does not begin coding TODO tasks in that same turn.
- ❌ **FAIL**:
  - Rigidly halts at M01 and demands user confirmation after every tiny sub-step despite explicit autopilot request.
  - Forces client SOW contract or heavy multi-week enterprise governance on a 3-feature calculator.
  - Treats autopilot as license to implement multiple TODO tasks (or a whole sprint) without per-task human verification.
