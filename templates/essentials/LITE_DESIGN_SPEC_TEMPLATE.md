# DESIGN_SPEC.md — Small Path (LITE)

> Target: ≥1000B. 5-state matrix on primary screens only (1–3 main data screens); secondary screens Default only.

## State matrix

| State | Trigger | Visual rule |
| :--- | :--- | :--- |
| Default | data loaded | normal render |
| Loading | request in flight | skeleton (`animate-pulse`), same layout box |
| Empty | 0 rows | message + primary CTA |
| Error | request failed | banner + retry button + specific message |
| Success | mutation completed | toast (auto-dismiss 3–5s) |

## Screen coverage

| Screen ID | States implemented | Notes |
| :--- | :--- | :--- |
| SCR-003 | 5-state | primary (matches LITE_SITEMAP SCR-003) |
| SCR-004+ | Default only | secondary screens |

## Interaction rules

- Submit buttons stay enabled when pristine; click triggers validation + focuses first invalid field.
- Keyboard: `Enter` = primary search/submit; `Esc` = close modal.
- All destructive actions require confirm step.

## Design Freeze

**Gate-enforced** (`validate-gate.sh M04` fails without these — the AI agent may not fill them in):

- Approved by: [name] — solo projects: the human user self-approves; an AI agent may not
- Approved on: [YYYY-MM-DD]
- Scope frozen: changes after this line require a CR or documented scope note.
