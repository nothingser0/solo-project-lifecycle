# Changelog

All notable changes to the `solo-project-lifecycle` framework will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [1.1.0] - 2026-10-07

### Added
- **Self-Initiated Product / Solo SaaS Path**: Added dedicated lifecycle path (`M00-lite → M01 → M02 → M04 → M05 → M06 → M07 → M10 → M12 → M13`), skipping client-specific contract gates while rigorously testing market validation.
- **M00-Lite Template**: Created `templates/01-discovery-commercial/M00_LITE_TEMPLATE.md` for rapid 1-page market validation (Assumption Register, 5 user interviews, waitlist smoke test, kill criteria).
- **Mandatory Primary Research Evidence Rules**: Prohibited synthetic/hallucinated research quotes; introduced `PENDING_PRIMARY_RESEARCH` gate status and Data Confidence Legend (`✅ VERIFIED`, `🔶 ASSUMPTION`, `❓ UNKNOWN`).
- **Assumption Register & Premise Testing**: Integrated into `IDEA_BRIEF_TEMPLATE.md`, `USER_RESEARCH_REPORT_TEMPLATE.md`, and `MARKET_RESEARCH_TEMPLATE.md`.
- **Proto-Persona Labeling**: All pre-interview personas explicitly labeled `Proto-Persona (Hipotesis)` until empirical validation.
- **Multi-Stakeholder Discovery**: Added interview guides for Group A (End Users), Group B (Economic Buyers), and Group C (Regulators/Enablers).
- **Behavioral Intent Validation**: Added metrics for landing page waitlists, pre-orders, and LOIs beyond stated survey intent.
- **Project State Tracking**: Created `templates/essentials/PROJECT_STATE_TEMPLATE.md` (`docs/pm/PROJECT_STATE.md`) with Cross-Document Consistency Matrix for cross-session resumption.
- **Multi-Role RBAC Navigation**: Upgraded `SITEMAP_TEMPLATE.md` and `COMPONENT_REQUIREMENTS_TEMPLATE.md` with role access matrices (Public, Member, Operator, Manager, Admin, Superadmin) and permission gate patterns.
- **Indonesian Compliance & Payment Patterns**:
  - `patterns/payments/indonesia-payment-gateways.md` (Midtrans, Xendit, QRIS, idempotent webhooks).
  - `patterns/compliance/uu-pdp-compliance.md` (UU PDP No. 27/2022, consent ledgers, right to erasure).
  - `patterns/offline/offline-first-sync.md` (IndexedDB/SQLite, mutation queue, conflict resolution).
  - `patterns/observability/logging-monitoring.md` (Pino JSON logging, trace correlation, Sentry PII masking).
  - `patterns/localization/i18n-indonesia.md` (Rupiah formatting, WIB/WITA/WIT, statutory tax rounding).
- **Missing CLI & ETL Scripts**: Implemented `scripts/generate-fsd.sh` / `.ps1`, `scripts/load-test.js`, `scripts/migrate-data.ts`, and `scripts/etl-import.js`.
- **Validation Tooling**: Added `scripts/verify-links.js` (markdown link checker) and `scripts/verify-skill-frontmatter.js`.
- **Evals Suite**: Added automated prompt/assertion evaluation scenarios in `evals/`.
- **Packaging Scripts**: Added `scripts/build-dist.sh`, `scripts/build-dist.ps1`, `scripts/calculate-size.sh`, and `scripts/calculate-size.ps1`.

### Changed
- **Indonesia-First Positioning**: Formally declared Indonesian statutory and commercial alignment in `SKILL.md` (Komdigi PSE Lingkup Privat, PPN 11%/PKP, OSS-RBA KBLI, DJKI, SOW, DP, BAST).
- **Regulatory Nomenclature**: Updated "Kominfo" references to "Komdigi (Kementerian Komunikasi dan Digital)".
- **Gate Validation Scripts**: Updated `scripts/validate-gate.sh` and `validate-gate.ps1` to enforce all 4 M00 artifacts or `M00_LITE.md`, validating intent-to-buy and checking `PENDING_PRIMARY_RESEARCH`.
- **Stack Quickstarts**: Renamed `references/stacks/*` to evergreen filenames (`nextjs-quickstart.md`, `laravel-quickstart.md`, `django-quickstart.md`, `go-quickstart.md`).
- **Neutralized Agent Phrasing**: Replaced agent-specific `read_file(...)` calls in module checklists with neutral reading verification directives.
- **CI Quality Workflow**: Removed `|| true` masking in `.github/workflows/ci.yml`, added PowerShell test execution, frontmatter validation, and link checks.

### Fixed
- **Secret Scanner False Positives**: Sanitized mock passwords (`password123`) and live API key placeholders (`sk_live_...`) across all templates and patterns.
- **Package Auto-Check Dead Code**: Removed unused variables and resolved SC2155 variable masking in `scripts/check-package-versions.sh` and `check-package-versions.ps1`.
- **Size Claims**: Harmonized repository size metrics to actual calculated disk footprint (~3.8MB, 270+ files).

---

## [1.0.0] - 2026-10-05

- Initial release of the 14-module solo project lifecycle framework.
- Core templates, quickstarts, and gate validation scripts.
