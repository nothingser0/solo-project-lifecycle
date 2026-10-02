# Changelog

All notable changes to the Solo Project Lifecycle framework.

Format based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

### Added
- Legal disclaimer to README and M03 (legal liability protection)
- `scripts/validate-gate.sh` - Gate checkpoint validation tool (M03, M09, M11)
- `scripts/lint-template.sh` - Template completeness validator
- `scripts/template-picker.sh` - Interactive template selection CLI
- `QUICK_START_MVP.md` - Fast-track guide for 2-4 week MVPs (300 lines)
- `references/case-studies/01-mvp-saas-inventory.md` - Real project walkthrough
- `audit/FRAMEWORK_WEAKNESSES.md` - Comprehensive gap analysis (14 issues)
- `ANTI_PATTERNS.md` - When NOT to use this framework

### Changed
- README: Removed AI agent focus, made framework-first
- `audit/FRAMEWORK_WEAKNESSES.md`: Corrected TODO count analysis (163 false positives)

### Fixed
- Git remote authentication (PAT → gh CLI)

---

## [1.0.0] - 2026-10-02

### Added
- **Core Modules** (17 total):
  - M00: Product Discovery & Strategy (TAM/SAM/SOM, competitors, user research)
  - M01: Idea & Feasibility (4-dimension scoring)
  - M02: Discovery & Scope Definition (MoSCoW, RBAC)
  - M03: Legal SOW, DP, Single PIC (commercial gate)
  - M04: UI/UX Design & Prototyping
  - M04B: Design System Foundation (tokens, components, governance)
  - M05: Architecture & Specs (PRD, FSD, DB schema, API contracts)
  - M05B: System Design & Infrastructure (load balancing, caching, HA)
  - M06: Development Execution (backend, frontend, integration)
  - M06B: Product Instrumentation & Analytics (Mixpanel, event taxonomy)
  - M07: Quality Assurance (SIT, security audit, load testing)
  - M08: Data Migration & Seeding
  - M09: UAT & Client Sign-off (validation gate)
  - M10: Deployment & Production Go-Live
  - M11: Handover & BAST (delivery gate)
  - M12: Warranty & SLA Retainer
  - M13: Product Operations & Continuous Iteration

- **Templates** (90+ files):
  - 01-discovery-commercial/ (13 templates: SOW, Scope, OKR, Risk Register, etc.)
  - 02-design/ (9 templates: Design System, Tokens, Component API, etc.)
  - 03-architecture-specs/ (8 templates: PRD, FSD, System Design, etc.)
  - 04-dev-execution/ (11 templates: AGENTS, TODO, CONTEXT, Harness files)
  - 05-data-migration/ (2 templates)
  - 06-qa-uat/ (4 templates)
  - 07-release-handover/ (5 templates)
  - 08-maintenance-ops/ (4 templates)
  - 09-product-growth/ (10 templates)
  - checklists/ (5 phase TODO templates)

- **References** (30+ guides):
  - solo/ (Solo dev patterns, engineering standards, UI/UX guide)
  - playbooks/ (AI-assisted dev, design patterns, software patterns)
  - pm/ (Analytics, communication, prioritization frameworks)
  - technical/ (Deep research, asset management, APM profiling)
  - checklists/ (Feasibility criteria, evaluation rubrics)

- **Audit Documentation**:
  - `audit/REPORT.md` - Comprehensive audit findings
  - `audit/REMAINING_FINDINGS_TODO.md` - 59/59 findings status
  - `audit/LEGAL_REVIEW_TODO.md` - F033-F037 pending lawyer review
  - `audit/REFACTOR_PLAN.md` - D1-D9 structure improvements

- **Core Features**:
  - Scale adaptation (Kecil/Menengah/Besar/Enterprise)
  - Fast-track mode for MVPs
  - Commercial protection gates (DP, UAT, Payment gates)
  - Indonesia legal compliance references (UU PDP, KUHPerdata, UU ITE)
  - Universal tech stack support (Next.js, Laravel, Django, Go, Flutter)

### Changed
- M04A renamed to M04B (consistency with M05B, M06B)
- All "Modul 04A" references updated to "04B"
- M13 RICE prioritization framework references consolidated

### Fixed
- **Audit Remediation** (59/59 findings addressed):
  - F001-F002: Critical LaTeX rendering + accessibility
  - F004, F023, F027-F028, F039-F040: High priority quick wins
  - F007, F011, F019: Data staleness + warranty mapping
  - F013-F014, B017: Unfixed findings batch
  - F022: PowerShell portability (added bash alternatives)
  - F024, F029, F031, F041-F042, F045, F049: High priority batch
  - F026, F030, F046-F047, F053: Final + cosmetic batch
  - F032, F037: Legal citations + F033-F036 lawyer review TODO
  - All Critical + High severity resolved (100%)

### Security
- ⚠️ F033-F037: Indonesia legal citations pending lawyer review (Rp 5-10M)
- Added legal disclaimer (NOT legal advice, consult qualified counsel)

---

## Version History

### Versioning Policy

**Semantic Versioning**: `MAJOR.MINOR.PATCH`

- **MAJOR**: Breaking changes (module structure changes, template relocations)
- **MINOR**: New features (new modules, new templates, new references)
- **PATCH**: Bug fixes (typo corrections, content updates, clarifications)

### Migration Guides

For breaking changes between major versions, see:
- `MIGRATION_v0_to_v1.md` (if upgrading from pre-1.0 versions)

---

## Roadmap

### v1.1.0 (Planned - Q4 2026)
- [ ] Stack-specific deep-dive guides (Next.js 15, Laravel 11, Django 5)
- [ ] Tool alternatives matrix (Mixpanel → Plausible, Railway → Coolify)
- [ ] 2 additional case studies (E-commerce Menengah, Enterprise BUMN)
- [ ] English translation of core modules

### v1.2.0 (Planned - Q1 2027)
- [ ] Framework Lite Edition (5 modules, 20 templates, 2000 lines)
- [ ] Automated gate validation (CI/CD checks)
- [ ] Template validation library (JSON schema)
- [ ] Progress tracking dashboard

### v2.0.0 (Planned - Q2 2027)
- [ ] Module restructuring (reduce from 17 to 12)
- [ ] Indonesia lawyer review completion (F033-F037)
- [ ] Breaking: Template paths reorganization
- [ ] Breaking: Mandatory vs optional module designation

---

## Contributing

See `README.md` section "Contributing" for:
- How to contribute
- Development standards
- Commit message conventions
- Pull request process

---

## Support

- **Issues**: https://github.com/nothingser0/solo-project-lifecycle/issues
- **Discussions**: https://github.com/nothingser0/solo-project-lifecycle/discussions
- **Documentation**: See `SKILL.md` and `modules/` directory

---

[Unreleased]: https://github.com/nothingser0/solo-project-lifecycle/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/nothingser0/solo-project-lifecycle/releases/tag/v1.0.0
