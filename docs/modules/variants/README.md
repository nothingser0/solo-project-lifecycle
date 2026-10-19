# Module Variants

Scale-specific alternatives to a main runbook. A variant **replaces** its parent module for one scale — it is not an extension or extra reading.

| Variant | Replaces | Use when | Load |
| :--- | :--- | :--- | :--- |
| `04_UIUX_LITE.md` | `../04_UIUX_PROTOTYPING.md` | **Small / MVP** scale (1–5 P0, solo, <4 weeks) | **instead of** the full runbook, never both |

## Relationship to the other subfolders

- `../` (this folder's parent) — the canonical runbooks, M00–M13 and the A-series. One per module.
- `../deep-dives/` — **optional depth** for a runbook step. Load only when a step says "deep dive".
- `variants/` (here) — **mutually exclusive alternatives**. Pick exactly one per module: the variant *or* the full runbook, decided by the scale in `docs/pm/PROJECT_STATE.md`.

## Why these live outside the parent folder

`scripts/verify/verify-all.sh` checks §2 (module presence) and §6 (runbook token budget ≤~2k) against `docs/modules/*.md`. Keeping variants one level down means the module-count check stays at exactly 14 runbooks + README, and a variant's size is not counted against the parent module's budget — they are read at different times and never co-loaded.

## Adding a variant

1. Name it `<module-number>_<NAME>_LITE.md` or `<module-number>_<NAME>_<SCALE>.md`.
2. State in its first line which module it replaces and for which scale.
3. Add a row to the table above.
4. Point the parent runbook's scale-calibration line at it.
5. Regenerate the index: `node scripts/verify/index-manifest.js`.
