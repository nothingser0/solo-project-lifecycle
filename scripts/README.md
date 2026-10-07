# Scripts Library Index

Automation, verification, and template tooling for the **solo-project-lifecycle** framework.

Each tool is available in both **Bash** (macOS/Linux) and **PowerShell** (Windows) implementations.

---

## Tool Catalog

| Script (Bash) | Script (PowerShell) | Purpose | Referenced In |
|---|---|---|---|
| [`scripts/validate-gate.sh`](./validate-gate.sh) | [`scripts/validate-gate.ps1`](./validate-gate.ps1) | Automated quality gate check between SDLC modules (M03, M09, M11) | `SKILL.md`, `README.md`, `docs/README.md` |
| [`scripts/check-package-versions.sh`](./check-package-versions.sh) | [`scripts/check-package-versions.ps1`](./check-package-versions.ps1) | Real-time registry queries (npm, composer, PyPI, Go) to avoid model knowledge cutoff | `docs/package-version-auto-check.md`, `docs/modules/05-architecture-specs.md` |
| [`scripts/verify-framework-version.sh`](./verify-framework-version.sh) | [`scripts/verify-framework-version.ps1`](./verify-framework-version.ps1) | Validates installed project lockfiles against versions pinned in `FSD.md` | `docs/modules/06-development-execution.md` |
| [`scripts/lint-template.sh`](./lint-template.sh) | [`scripts/lint-template.ps1`](./lint-template.ps1) | Lints markdown templates for unrendered placeholders (`[...]`, `<...>`) and structural validity | `SKILL.md`, `README.md` |
| [`scripts/template-picker.sh`](./template-picker.sh) | [`scripts/template-picker.ps1`](./template-picker.ps1) | Interactive CLI selector to scaffold project templates into designated project paths | `SKILL.md`, `README.md` |
| [`scripts/verify-all.sh`](./verify-all.sh) | [`scripts/verify-all.ps1`](./verify-all.ps1) | Comprehensive repository sanity and syntax checker | CI / Pre-Release |
| [`scripts/init-project.sh`](./init-project.sh) | [`scripts/init-project.ps1`](./init-project.ps1) | Deterministic project directory initializer per scale (small, solo-saas, medium, large) | `SKILL.md`, `docs/quickstart.md` |
| [`scripts/generate-fsd.sh`](./generate-fsd.sh) | [`scripts/generate-fsd.ps1`](./generate-fsd.ps1) | Auto-generates initial FSD.md skeleton with registry-pinned versions and DDL tables | Module 05 |
| [`scripts/calculate-size.sh`](./calculate-size.sh) | [`scripts/calculate-size.ps1`](./calculate-size.ps1) | Accurately calculates disk footprint (excl. .git) and estimated framework tokens | Quality Audits |
| [`scripts/build-dist.sh`](./build-dist.sh) | [`scripts/build-dist.ps1`](./build-dist.ps1) | Builds distribution bundle (dist/package/ and zip) for skill installation | Skill Distribution |
| [`scripts/load-test.js`](./load-test.js) | — | Universal k6 load testing script with p95 < 200ms latency thresholds | Module 05B, 07 |
| [`scripts/migrate-data.ts`](./migrate-data.ts) | — | Streaming batch ETL and data reconciliation script (Zod, 500-row chunks) | Module 08 |
| [`scripts/etl-import.js`](./etl-import.js) | — | Node.js production batch database importer | Module 10 |
| [`scripts/verify-links.js`](./verify-links.js) | — | Automated markdown relative link integrity checker (0 broken links) | CI / QA |
| [`scripts/verify-skill-frontmatter.js`](./verify-skill-frontmatter.js) | — | Automated validator for SKILL.md YAML frontmatter specification | CI / QA |

---

## 1. Quality Gate Validator (`validate-gate`)

Validates blocking gates before progressing between project phases:

```bash
# Bash (Linux / macOS)
./scripts/validate-gate.sh M03    # Commercial gate: SOW signed & Down Payment cleared
./scripts/validate-gate.sh M09    # Validation gate: UAT signed by Client PIC
./scripts/validate-gate.sh M11    # Handover gate: 100% final payment & BAST signed
```

```powershell
# PowerShell (Windows)
.\scripts\validate-gate.ps1 M03
.\scripts\validate-gate.ps1 M09
.\scripts\validate-gate.ps1 M11
```

---

## 2. Dynamic Package Version Checker (`check-package-versions`)

Queries package registries directly in real time to guarantee up-to-date dependency decisions in Module 05:
Supports 14 production stacks via official public registries (`nextjs`, `laravel`, `django`, `go`, `rails`, `mern`, `aspnet`, `spring`, `serverless`, `flutter`, `remix`, `astro`, `sveltekit`, `nuxt`):
```bash
# Query latest stable versions
./scripts/check-package-versions.sh nextjs
./scripts/check-package-versions.sh laravel
./scripts/check-package-versions.sh django
./scripts/check-package-versions.sh go
./scripts/check-package-versions.sh rails
```

```powershell
.\scripts\check-package-versions.ps1 -Framework nextjs
.\scripts\check-package-versions.ps1 -Framework laravel
.\scripts\check-package-versions.ps1 -Framework go
```

---

## 3. Framework Lockfile Verifier (`verify-framework-version`)

Ensures local scaffolding (`create-next-app`, `composer`, etc.) matches the architectural specifications in `docs/specs/FSD.md`:

```bash
# Bash
./scripts/verify-framework-version.sh

# PowerShell
.\scripts\verify-framework-version.ps1
```

---

## 4. Template Completeness Linter (`lint-template`)

Verifies that drafted specifications do not contain unfinished placeholder prompts before client review:

```bash
# Check single template or project specification
./scripts/lint-template.sh docs/specs/PRD.md
./scripts/lint-template.sh docs/pm/SOW_CONTRACT.md
```

```powershell
.\scripts\lint-template.ps1 docs/specs/PRD.md
```

---

## 5. Interactive Template Picker (`template-picker`)

Assists developers in quickly copying templates into designated folders (`docs/pm/`, `docs/specs/`, `./`):

```bash
# Launch interactive menu
./scripts/template-picker.sh
```

```powershell
.\scripts\template-picker.ps1
```
