# Scripts Library Index

Automation, verification, scaffold, and template tooling for the **solo-project-lifecycle** framework.

Scripts are categorized into 6 functional modules. Each tool is available in both **Bash** (macOS/Linux/WSL) and **PowerShell** (Windows) implementations.

---

## Directory Organization

```text
scripts/
├── gates/      - Blocking quality gate checkers between lifecycle modules
├── scaffold/   - Deterministic project setup, template pickers, and FSD generation
├── verify/     - Static analysis, link integrity, frontmatter, and package version checkers
├── runtime/    - Production batch ETL, data migration, and load test scripts
├── release/    - Clean-release builder (strips dev-only files from release branches)
├── design/     - Logo craft, SVG auditing, and visual comparison tools
├── evals/      - Behavioral test scenario runners for SDLC agent compliance
└── dist/       - Framework distribution bundling and size calculation tools
```

---

## 1. Quality Gates (`scripts/gates/`)

Validates blocking criteria and mandatory artifacts before progressing between SDLC phases:

| Tool (Bash) | Tool (PowerShell) | Description |
|:---|:---|:---|
| [`scripts/gates/validate-gate.sh`](./gates/validate-gate.sh) | [`scripts/gates/validate-gate.ps1`](./gates/validate-gate.ps1) | Validates gate checkpoints for M00 through M13 |

```bash
# Bash:
./scripts/gates/validate-gate.sh M00    # Discovery gate (M00-lite or Full M00)
./scripts/gates/validate-gate.sh M03    # Commercial gate (SOW contract & DP)
./scripts/gates/validate-gate.sh M04    # Design gate (Sitemap & tokens)
./scripts/gates/validate-gate.sh M09    # Validation gate (UAT sign-off)

# PowerShell:
.\scripts\gates\validate-gate.ps1 -Module M00
```

---

## 2. Project Scaffolding & Setup (`scripts/scaffold/`)

Deterministic tools for project initialization and template extraction:

| Tool (Bash) | Tool (PowerShell) | Description |
|:---|:---|:---|
| [`scripts/scaffold/init-project.sh`](./scaffold/init-project.sh) | [`scripts/scaffold/init-project.ps1`](./scaffold/init-project.ps1) | Bootstraps project directory tree per scale (`small`, `solo-saas`, `medium`, `large`) |
| [`scripts/scaffold/template-picker.sh`](./scaffold/template-picker.sh) | [`scripts/scaffold/template-picker.ps1`](./scaffold/template-picker.ps1) | Interactive CLI selector to scaffold specific templates |
| [`scripts/scaffold/generate-fsd.sh`](./scaffold/generate-fsd.sh) | [`scripts/scaffold/generate-fsd.ps1`](./scaffold/generate-fsd.ps1) | Generates initial FSD.md skeleton with pinned package registry versions |

```bash
# Initialize a new Solo SaaS project:
./scripts/scaffold/init-project.sh ~/projects/my-new-saas solo-saas
```

---

## 3. Verification & Quality Assurance (`scripts/verify/`)

Sanity checks, link validators, and ecosystem compatibility tools:

| Tool (Bash) | Tool (PowerShell) | Description |
|:---|:---|:---|
| [`scripts/verify/verify-all.sh`](./verify/verify-all.sh) | [`scripts/verify/verify-all.ps1`](./verify/verify-all.ps1) | Comprehensive repository integrity checker (scripts, modules, patterns, links) |
| [`scripts/verify/verify-links.js`](./verify/verify-links.js) | — | Scans all Markdown files for broken local relative links (0 broken links) |
| [`scripts/verify/verify-skill-frontmatter.js`](./verify/verify-skill-frontmatter.js) | — | Validates SKILL.md YAML frontmatter against agent specifications |
| [`scripts/verify/check-package-versions.sh`](./verify/check-package-versions.sh) | [`scripts/verify/check-package-versions.ps1`](./verify/check-package-versions.ps1) | Real-time registry queries (npm, Packagist, PyPI, Go proxy, RubyGems, NuGet, Maven) across 15 stacks, incl. FastAPI |
| [`scripts/verify/verify-framework-version.sh`](./verify/verify-framework-version.sh) | [`scripts/verify/verify-framework-version.ps1`](./verify/verify-framework-version.ps1) | Validates installed project lockfiles against versions pinned in FSD.md `Framework Versions (Pinned):` — comparators for Next.js, Laravel, Django, FastAPI, Go, SvelteKit, Nuxt, Rails; any other stack exits 1 as UNVERIFIED rather than passing silently |
| [`scripts/verify/lint-template.sh`](./verify/lint-template.sh) | [`scripts/verify/lint-template.ps1`](./verify/lint-template.ps1) | Lints filled project documents and raw template structures |
| [`scripts/verify/fixtures/m00-lite-pass.md`](./verify/fixtures/m00-lite-pass.md) | — | Test fixture for validating M00 gate behavior without executing full discovery cycles |
| [`scripts/verify/check_evidence.py`](./verify/check_evidence.py) | — | Verifies that evidence cited in a completion report actually exists, is not a stub, and belongs to this run. `--manifest` = strict coverage + freshness; `--report` = lenient existence only. Guide: `references/technical/EVIDENCE_MANIFEST_GUIDE.md` |

### Archived Patterns Reference

Historical architecture patterns and engineering guides are preserved in [`archive/patterns/README.md`](../archive/patterns/README.md).

---

## 4. Production Runtime & Migration (`scripts/runtime/`)

Data engineering and performance load testing scripts:

| Tool | Description |
|:---|:---|
| [`scripts/runtime/etl-import.js`](./runtime/etl-import.js) | Node.js production batch database importer |
| [`scripts/runtime/migrate-data.ts`](./runtime/migrate-data.ts) | Streaming batch ETL with reconciliation report (extracted vs loaded + rejected), 500-row default chunks |
| [`scripts/runtime/load-test.js`](./runtime/load-test.js) | Universal k6 load testing script with p95 < 200ms latency thresholds |

---

## 4b. Design Craft Tooling (`scripts/design/`)

Dependency-free Python 3 that mechanically checks brand-mark craft. Adapted from
`kaankiziltug/logo-design-skill` (MIT); the reference SVG library is not redistributed,
only its aggregate complexity benchmarks (`library-stats.json`).

| Tool | Description |
|:---|:---|
| [`scripts/design/svg_audit.py`](./design/svg_audit.py) | Audits a logo SVG: live `<text>`, embedded rasters, `<foreignObject>`, missing `viewBox`, colour count, gradients, stroke usage, painted-white "fake holes", anchor-point complexity vs. the reference corpus, near-miss angles (0.3–3° off a clean angle), sub-shapes that vanish at small sizes, centring/overflow, and contrast against a background (`--bg`). `--json` for machine output. |
| [`scripts/design/svglib.py`](./design/svglib.py) | Shared parser: path geometry, transforms, bounding boxes, colour normalisation, WCAG contrast. |
| [`scripts/design/library-stats.json`](./design/library-stats.json) | Percentile benchmarks (anchors, colours) from a 1,432-logo corpus. |

```bash
python3 scripts/design/svg_audit.py assets/logo/*.svg
python3 scripts/design/svg_audit.py assets/logo/logo.svg --bg "#0F7C80"
```

`validate-gate.sh M04` runs this automatically against `assets/logo/logo.svg`: a `FAIL`
finding or an unparseable SVG blocks the design gate. Rules and corrections:
`references/design/LOGO_DESIGN_CRAFT_GUIDE.md`.

---

## 5. Clean Release Builder (`scripts/release/`)

| Tool (Bash) | Tool (PowerShell) | Description |
|:---|:---|:---|
| [`scripts/release/build-clean-release.sh`](./release/build-clean-release.sh) | [`scripts/release/build-clean-release.ps1`](./release/build-clean-release.ps1) | Builds a release branch with dev-only paths stripped (see `release-exclude.txt`); never pushes automatically |

---

## 6. Packaging & Distribution (`scripts/dist/`)

Tools for calculating framework metrics and building skill installation packages:

| Tool (Bash) | Tool (PowerShell) | Description |
|:---|:---|:---|
| [`scripts/dist/build-dist.sh`](./dist/build-dist.sh) | [`scripts/dist/build-dist.ps1`](./dist/build-dist.ps1) | Packages framework into `dist/package/` and zip ready for skill upload |
| [`scripts/dist/calculate-size.sh`](./dist/calculate-size.sh) | [`scripts/dist/calculate-size.ps1`](./dist/calculate-size.ps1) | Calculates accurate disk footprint and token counts across documentation |
