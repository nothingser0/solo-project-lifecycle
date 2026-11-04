# Where a file goes

One rule: **an artefact goes where its reader looks for it, not where it was created.**
Before writing any project file, find its folder here. If you cannot, ask — do not invent a
new folder, and never duplicate a document into two folders to feel safe.

This file is generated from the two places that actually enforce placement
(`scripts/scaffold/init-project.sh` and `scripts/gates/`), so it cannot drift far from reality.

---

## 1. Project folders (written into the *user's* project, never into this framework)

| Folder | Holds | Examples |
|---|---|---|
| `docs/pm/` | Anything a project manager or the human reads to steer: state, scope, plans, commercial docs, reports | `PROJECT_STATE.md`, `SCOPE_STATEMENT.md`, `IDEA_BRIEF.md`, `STAKEHOLDER_MAP.md`, `MARKET_RESEARCH.md`, `USER_RESEARCH_REPORT.md`, `DATA_MIGRATION_PLAN.md`, `BAST.md`, `WARRANTY_POLICY.md`, `SOW_SMB.md` |
| `docs/specs/` | The frozen build contract. What engineers implement and gates check | `PRD.md`, `FSD.md`, `PROJECT_LITE.md`, `SITEMAP.md`, `DESIGN_SPEC.md`, `COMPONENT_REQUIREMENTS.md`, `LOGO_DESIGN_BRIEF.md`, `wireflows/` |
| `docs/design/` | Physical design artefacts, not prose about design | `inspiration/` (human-supplied reference; `notes.md` is agent analysis), `screens/<role>/`, `components/index.html`, `brand/`, `prompts/`, `shared/css/`, `shared/js/` |
| `docs/harness-root/` | The 9-file agent harness that gets copied to the project root at M06 | `AGENTS.md`, `CONTEXT.md`, `ARCHITECTURE.md`, `DESIGN.md`, `CONVENTIONS.md`, `TODO.md`, `.env.example`, `RUNBOOK_LOCAL.md`, `VERIFY_LOCAL.md` |
| `docs/qa/` | Test and assurance evidence | `SIT_WORKBOOK.md`, `UAT_WORKBOOK.md`, `UAT_SIGNOFF.md`, `UAT_SIGNOFF_SMALL.md`, `SECURITY_CHECKLIST_SMALL.md`, `SECURITY_AUDIT.md`, `POLISH_AUDIT.md` |
| `docs/governance/` | Decisions and controls a third party may audit | `ADR.md`, `RACI.md`, `CAB_APPROVAL.md`, `AUDIT_TRAIL_REQUIREMENTS.md` |
| `docs/security/` | The threat model and its outputs | `THREAT_MODEL_STRIDE.md` |
| `docs/ops/` | Runbooks and continuity | `DISASTER_RECOVERY_PLAN.md`, `RUNBOOK_OPS.md` |
| `docs/architecture/` | Large/enterprise blueprint artefacts | `ENTERPRISE_ARCHITECTURE_BLUEPRINT.md` |
| `docs/procurement/` | Vendor and purchasing records | `VENDOR_PROCUREMENT_SCHEDULE.md` |
| `contracts/` | Signed commercial instruments — never paraphrased into `docs/` | `SOW_CONTRACT.md`, `SOW_SMB.md`, `NDA.md`, `CONSULTING_AGREEMENT.md` |
| `assets/logo/` | Delivered vector brand assets | `logo.svg` and exports |
| project root | Only what tooling requires at the root | `AGENTS.md`, `TODO.md`, `DESIGN.md` (Small), plus `PROJECT_LITE.md` |

**Two folders, not both:** `docs/pm/UAT_SIGNOFF_REPORT.md` and `docs/qa/UAT_SIGNOFF.md` are
alternatives (the M09 gate accepts either). Pick one, preferably `docs/qa/`, which is where the
scaffold puts the template. The gate accepting both is tolerance for older projects, not an
invitation to write twice.

---

## 2. Framework folders (this repo — read-only during a project)

| Folder | Holds |
|---|---|
| `SKILL.md` | The entry point: scale router, core rules, context budget |
| `docs/modules/` | 14 phase runbooks `NN_*.md` + `A00–A04` advisory + `deep-dives/` (verbatim originals) + `variants/` |
| `docs/AUTHORITY.md` | Who may do what, per module |
| `docs/INDEX.json` | Machine manifest, regenerated — never hand-edited |
| `templates/` | Document bodies to copy **from**, numbered by module (`templates/06-qa-uat/` → M07/M09). See `templates/README.md` |
| `references/` | How-to guidance: `pm/`, `technical/`, `stacks/`, `design/`, `process/`, `taxonomy/`… |
| `patterns/` | Decision-rule patterns that change agent behaviour (Indonesia rails, UU PDP, threat modeling) |
| `archive/patterns/` | Superseded generic patterns kept for reference; loaded by no phase |
| `case-studies/` | Worked examples end to end |
| `scripts/gates/` | `validate-gate.sh` + `modules/M*.sh` — the enforcement |
| `scripts/scaffold/` | `init-project.sh`, `generate-todo.*`, `template-picker.*` |
| `scripts/verify/` | Repo integrity: links, INDEX parity, versions, regressions |
| `scripts/evals/` + `evals/scenarios/` | Behaviour scenarios (anti-yes-man, no-hallucination) |
| `patterns/`, `references/`, `templates/` | Consulted **only** when a module step names a file there |

---

## 3. The three questions that decide the folder

1. **Who reads it?** Human steering the project → `docs/pm/`. Engineer implementing → `docs/specs/`.
   Auditor → `docs/governance/`. A machine gate → wherever that gate's `check_required` says.
2. **Is it prose or an artefact?** Prose about design → `docs/specs/DESIGN_SPEC.md`.
   The actual HTML/CSS → `docs/design/`.
3. **Is it signed?** Signed commercial instrument → `contracts/`. Everything else → `docs/`.

If two answers conflict, the gate wins: `grep -rn "<FILENAME>" scripts/gates/` shows which
path is enforced. A gate that accepts two paths is documented in §1 above.
