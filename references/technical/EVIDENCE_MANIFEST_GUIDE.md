# Evidence Manifest — Proving a Completion Claim

> **Module**: M06 (Development), M07 (QA), M09 (UAT) — any module where an agent claims work is done
> **Source**: Adapted from `majidmanzarpour/threejs-game-skills` (MIT) — the manifest/capture-set model, the stub-size floors, and the freshness rule. Reimplemented framework-agnostic as `scripts/verify/check_evidence.py`.
> **Problem it solves**: an agent writes *"verified — screenshot at `artifacts/x.png`"* and the file is missing, zero bytes, or from last week's run. None of that is detectable by reading the sentence.

---

## 1. The three failure modes of "evidence"

| Failure | What it looks like | Caught by |
| :--- | :--- | :--- |
| **Missing** | The cited path does not exist | path resolution |
| **Stub** | The file exists but is 0 bytes, or a truncated write | per-format size floor |
| **Stale** | The file exists and is real — but from an earlier run, relabelled | run-id comparison |

A fourth failure is invisible to any script: the file is real, current, and shows the wrong thing. That requires a human looking at it.

---

## 2. Two modes

```bash
# Strict — a declared capture set from ONE run
python3 scripts/verify/check_evidence.py . --manifest artifacts/evidence.json

# Lenient — every path cited in a markdown report must exist and not be a stub
python3 scripts/verify/check_evidence.py . --report artifacts/final-evidence.md
```

**Lenient mode cannot prove coverage or freshness.** It only proves the files exist. Say so when reporting its result — never upgrade "the paths resolve" into "the work is verified".

---

## 3. The manifest

Write `artifacts/evidence.json` in the project:

```json
{
  "version": 1,
  "runId": "pass-1",
  "captures": [
    { "mode": "desktop", "state": "active-play",
      "report": "artifacts/pass-1/desktop-active-play.json" },
    { "mode": "mobile",  "state": "active-play",
      "report": "artifacts/pass-1/mobile-active-play.json" }
  ],
  "artifacts": ["artifacts/pass-1/locomotion.webm", "public/logo.svg"]
}
```

**Rules the checker enforces**

| Rule | Why |
| :--- | :--- |
| `runId` present and non-empty | Evidence must be attributable to one run |
| `captures` non-empty, distinct `mode`/`state` pairs | A single viewport is not a coverage claim |
| Each `report` exists and is ≥ the format floor | A 0-byte PNG resolves but proves nothing |
| Each report's `runId` matches the manifest's | Relabelled old evidence is not evidence |
| Each report's `ok` is not `false` | A recorded failure cannot be cited as proof |
| Declared `artifacts` exist and are not stubs | A referenced file must be real |

**Declare only what this change requires.** A full desktop+mobile build needs active play in both plus the relevant failure or stress states. A narrow HUD fix needs the affected desktop state. Dropping a required entry because its capture failed is not allowed — the failure is the finding.

**Use a fresh run ID and output directory when code or assets change.** Never relabel an old report.

---

## 4. What the checker cannot do

Be explicit about this in any report that cites it:

| Not proven by the checker | Who proves it |
| :--- | :--- |
| That the screenshot shows the right thing | A human looking at it |
| That motion feels right | A human watching the recording |
| That the build actually succeeded | The build's own exit code, quoted |
| That input, audio, or performance work | Their own measurements |
| That every required state was captured | The manifest's declared set — which a human chose |

The checker proves **artifact coverage**, not quality. An agent that reports `✅ evidence check passed` as if it meant "the work is good" has misrepresented the tool.

---

## 5. Where this fits the lifecycle

| Module | Use |
| :--- | :--- |
| **M06** (per task) | A task's `Evidence` field cites real files. `check_evidence.py --report` catches a fabricated citation before the human approves. |
| **M06 GATE** | The completion report cites `artifacts/final-evidence.md`; the checker confirms every cited path resolves. |
| **M07** | SIT workbook rows cite screenshots, load-test output, audit JSON — all checkable. |
| **M09 / M10** | UAT evidence and go-live PVT screenshots are the artifacts a client dispute turns on. |

**Do not over-apply this.** A one-line CSS fix does not need a manifest. The manifest exists for work where "did it actually happen?" is a real question — a UI feature, a responsive pass, a migration, a release.

---

## 6. Honest reporting template

```markdown
## Evidence
- Run: `pass-1` (2026-10-19)
- Manifest: `artifacts/evidence.json` — 2 captures (desktop/mobile, active-play)
- Checker: `✅ 3 artifacts resolved` (strict mode)
- I looked at: `artifacts/pass-1/desktop-active-play.png` — the HUD overlaps the
  minimap at 1440px; logged as defect D-04.
- Not verified: frame-rate on a low-end device (no device available).
```

The last two lines are the ones that make an evidence block honest. The checker cannot write them, and an agent that omits them is claiming more than it proved.
