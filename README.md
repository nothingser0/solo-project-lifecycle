# Solo Project Lifecycle

> **Complete SDLC framework for solo developers and technical consultants** — Execute projects from small MVPs to enterprise systems with structured workflows, commercial protection, and quality gates.

> ⚠️ **LEGAL DISCLAIMER**: This framework provides general SDLC guidance and is NOT legal advice. References to Indonesian regulations (UU PDP, KUHPerdata, UU ITE) are educational only and have NOT been verified by licensed Indonesian lawyers. Always consult qualified legal counsel for contract drafting, regulatory compliance, and legal matters. Framework authors assume no liability for legal decisions based on this content.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)](https://github.com/nothingser0/solo-project-lifecycle)
[![Language](https://img.shields.io/badge/lang-Indonesian-red.svg)]()

---

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Quick Start](#quick-start)
- [Installation](#installation)
- [Usage](#usage)
- [Project Structure](#project-structure)
- [Documentation](#documentation)
- [Contributing](#contributing)
- [License](#license)

---

## 🎯 Overview

**Solo Project Lifecycle** adalah framework SDLC lengkap untuk solo developer dan technical consultant yang menjalankan proyek freelance atau produk sendiri. Framework ini mencakup 13 modul dari discovery hingga production maintenance, lengkap dengan 100+ template dokumen, checklist, dan panduan best practices.

**Problem yang diselesaikan**:
- ❌ Scope creep tanpa batas
- ❌ Kerja gratis tanpa kontrak jelas
- ❌ Tidak tahu harus mulai dari mana
- ❌ Client expectations tidak terkontrol
- ❌ Legal compliance (UU PDP, UU ITE) diabaikan

**Solution**:
- ✅ 12-stage gated pipeline dengan stop point jelas
- ✅ Template kontrak & payment terms bertahap
- ✅ Fast-track mode untuk MVP (2-6 minggu)
- ✅ Protection rules anti-kerja gratis (no DP = no code)
- ✅ Built-in compliance untuk regulasi Indonesia

---

## ✨ Features

### Core Pipeline (13 Modules)
- **00-01**: Product Discovery & Feasibility (TAM/SAM/SOM, 4-dimension scoring)
- **02-03**: Scope Definition & Legal SOW (contracts, payment terms, Single PIC)
- **04-05**: UI/UX Design & Technical Architecture (PRD, FSD, DB schema, API contracts)
- **06-07**: Development Execution & QA (coding, SIT, security audit, load testing)
- **08-09**: Data Migration & UAT (ETL scripts, client sign-off)
- **10-11**: Deployment & Handover (production release, BAST, training)
- **12-13**: Warranty & Continuous Iteration (bug fixes, retainer, growth experiments)

### Protection Mechanisms
- **Commercial Gates**: No DP → no code, no UAT Pass → no production, no payment → no source code
- **Scope Protection**: Change Request protocol, deemed acceptance clause, out-of-scope rejection
- **Client Dependency SLA**: Client delays auto-shift timeline without penalty

### Templates & Checklists (100+ files)
- Legal: SOW Contract, NDA, BAST, SLA Retainer
- PM: Project Charter, SCOPE_STATEMENT, RISK_REGISTER, OKR
- Design: DESIGN_SPEC, DESIGN_SYSTEM_AUDIT, Component API Spec
- Technical: PRD, FSD, SYSTEM_DESIGN_DOC, API Contract
- QA: SIT_WORKBOOK, SECURITY_AUDIT, UAT_SIGNOFF
- Operations: DEPLOYMENT_PROTOCOL, RUNBOOK_LOCAL, INCIDENT_RESPONSE

### Scale Adaptation
| Scale | Duration | Deliverables | Testing | Formality |
|-------|----------|--------------|---------|-----------|
| **Kecil (MVP)** | 2-6 minggu | PRD ringkas, UI Stitch, minimal docs | Smoke test manual | Email confirmation |
| **Menengah** | 1-3 bulan | PRD modular, FSD, API contract | Automated tests, SIT, UAT | BAST bermeterai, garansi 30-60 hari |
| **Besar** | 3-6 bulan | PRD formal, FSD mendalam, WBS | Test pyramid, Pentest | Zero-downtime deploy, garansi 90 hari |
| **Enterprise** | >6 bulan | Business Case, Charter, RTM | Third-party Pentest, DR drill | CAB approval, formal SLA |

---

## 🚀 Quick Start

### Option 1: Fast-Track MVP (2-6 minggu)

```bash
# 1. Clone framework
git clone https://github.com/nothingser0/solo-project-lifecycle.git
cd solo-project-lifecycle

# 2. Copy templates ke project kamu
cp -r templates/03-architecture-specs/PRD_TEMPLATE.md ../your-project/docs/specs/PRD.md
cp -r templates/03-architecture-specs/FSD_TEMPLATE.md ../your-project/docs/specs/FSD.md

# 3. Baca modul yang relevan
# - modules/04-uiux-prototyping.md (Design)
# - modules/05-architecture-specs.md (Tech specs)
# - modules/06-development-execution.md (Coding)
# - modules/10-deployment-production.md (Launch)
```

**Skip untuk MVP**: Market research (M00), Feasibility (M01), Formal SOW (M03), Design System (M04B), System Design (M05B)

### Option 2: Standard Flow (Proyek Komersial 1-6 bulan)

```bash
# Ikuti 13 modul secara berurutan
# Setiap modul punya:
#   - Input prerequisites
#   - Step-by-step execution guide
#   - Template dokumen
#   - Output deliverables
#   - Gate checkpoint (stop sampai approved)
```

**Example flow**:
```
Scenario: Client ingin sistem dokumen digital, budget 50 juta, 3 bulan

Step 1: Baca SKILL.md → Identifikasi skala = Menengah
Step 2: Baca modules/01-idea-feasibility.md → Scoring: 16/20 ✓ GO
Step 3: Baca modules/02-discovery-scope.md → Buat SCOPE_STATEMENT.md
Step 4: Baca modules/03-legal-sow-charter.md → Buat kontrak SOW
Step 5: Terima DP 30-50% → Baru mulai design & development
Step 6-13: Ikuti modul sampai deployment & handover
```

---

## 📦 Installation

### Clone Repository

```bash
git clone https://github.com/nothingser0/solo-project-lifecycle.git
cd solo-project-lifecycle
```

```bash
# Count templates
find templates -name "*.md" | wc -l
```

---

## 💻 Usage

### Workflow

1. **Identify scale**: Read `SKILL.md` section "Project Scale Table"
2. **Read module**: Open `modules/{NN}-{name}.md` untuk step-by-step guide
3. **Copy template**: Dari `templates/{phase}/` ke `docs/` project kamu
4. **Fill & execute**: Ikuti instruksi modul, isi template, deliver output
5. **Gate check**: Verifikasi deliverables sebelum lanjut modul berikutnya

### Example: Menengah Project (3 months, Rp 50M)

```bash
# Phase 1: Discovery & Scope (Week 1)
modules/00-product-discovery-strategy.md  → docs/pm/PRODUCT_STRATEGY.md
modules/01-idea-feasibility.md             → docs/pm/FEASIBILITY_REPORT.md
modules/02-discovery-scope.md              → docs/pm/SCOPE_STATEMENT.md

# Phase 2: Legal & Payment (Week 1)
modules/03-legal-sow-charter.md            → contracts/SOW_CONTRACT.md
# → Get DP (30-50%) before proceeding

# Phase 3: Design (Week 2-3)
modules/04-uiux-prototyping.md             → docs/design/DESIGN.md + Stitch prototype
modules/05-architecture-specs.md           → docs/specs/PRD.md + FSD.md

# Phase 4: Development (Week 4-10)
modules/06-development-execution.md        → Code + VERIFY_LOCAL.md

# Phase 5: Testing (Week 11)
modules/07-quality-assurance-sit.md        → docs/qa/SIT_REPORT.md
modules/08-data-migration-seeding.md       → scripts/etl/ + RECONCILIATION.md
modules/09-uat-client-signoff.md           → docs/qa/UAT_SIGNOFF.md

# Phase 6: Deployment (Week 12)
modules/10-deployment-production.md        → GO_LIVE_REPORT.md
modules/11-handover-bast.md                → contracts/BAST.md
# → Get final payment (10-20%) before source code handover

# Phase 7: Warranty (Week 13-16)
modules/12-warranty-sla-retainer.md        → contracts/WARRANTY_POLICY.md
```

---

## 📁 Project Structure

### This Repository

```
solo-project-lifecycle/
├── modules/           # 13 modul SDLC lengkap
│   ├── 00-product-discovery-strategy.md
│   ├── 01-idea-feasibility.md
│   ├── 02-discovery-scope.md
│   ├── 03-legal-sow-charter.md
│   ├── 04-uiux-prototyping.md
│   ├── 04B-design-system-foundation.md
│   ├── 05-architecture-specs.md
│   ├── 05B-system-design-infrastructure.md
│   ├── 06-development-execution.md
│   ├── 06B-product-instrumentation.md
│   ├── 07-quality-assurance-sit.md
│   ├── 08-data-migration-seeding.md
│   ├── 09-uat-client-signoff.md
│   ├── 10-deployment-production.md
│   ├── 11-handover-bast.md
│   ├── 12-warranty-sla-retainer.md
│   └── 13-product-operations-iteration.md
│
├── templates/         # Template untuk semua dokumen
│   ├── 01-discovery-commercial/    # SOW, Charter, Scope
│   ├── 02-design/                  # Design specs, tokens, component API
│   ├── 03-architecture-specs/      # PRD, FSD, System Design
│   ├── 04-dev-execution/           # Harness AI files, Context, TODO
│   ├── 05-data-migration/          # ETL plans, reconciliation
│   ├── 06-qa-uat/                  # SIT, Security Audit, UAT
│   ├── 07-release-handover/        # BAST, Deployment Protocol
│   ├── 08-maintenance-ops/         # Incident Response, SLA Contract
│   └── 09-product-growth/          # Analytics, A/B Test, Metrics
│
├── references/        # Panduan, checklist, best practices
│   ├── checklists/                 # Action items, evaluation criteria
│   ├── solo/                       # Solo dev patterns & standards
│   ├── playbooks/                  # AI development, design patterns
│   ├── pm/                         # Analytics, communication, prioritization
│   └── technical/                  # Deep research, design systems, asset mgmt
│
├── audit/             # Audit findings & remediation
├── SKILL.md          # Skill definition
├── LICENSE           # MIT License
└── README.md
```

### Your Project (After Setup)

```
your-project/
├── src/              # Source code (stack-specific)
│
├── docs/
│   ├── pm/           # Project management docs
│   ├── specs/        # Technical specs (PRD, FSD)
│   ├── design/       # Design system & UI/UX
│   ├── analytics/    # Event tracking & metrics
│   └── qa/           # Test reports, audit results
│
├── contracts/        # Legal documents (SOW, BAST, NDA)
├── scripts/          # ETL, deployment, maintenance scripts
│
├── AGENTS.md         # AI agent instructions
├── CONTEXT.md        # Business context
├── ARCHITECTURE.md   # Tech architecture
├── DESIGN.md         # Design tokens
├── CONVENTIONS.md    # Code style guide
├── TODO.md           # Task queue
├── .env.example      # Environment variables template
└── .gitignore
```

---

## 📚 Documentation

### Core Docs
- **[SKILL.md](SKILL.md)**: Framework overview, principles, module map
- **[modules/](modules/)**: 13 modul eksekusi dengan step-by-step guide
- **[templates/](templates/)**: 100+ ready-to-use document templates
- **[references/](references/)**: Best practices, checklists, patterns

### Key References
- **Solo Development Patterns**: `references/solo/SOLO_DEVELOPMENT_PATTERNS.md`
- **Engineering Standards**: `references/solo/SOLO_ENGINEERING_STANDARDS.md`
- **Feasibility Criteria**: `references/checklists/FEASIBILITY_CRITERIA.md`
- **PM Analytics Setup**: `references/pm/PM_ANALYTICS_SETUP_GUIDE.md`
- **AI-Assisted Development**: `references/playbooks/ai-assisted-development.md`

### Audit & Quality
- **Audit Report**: `audit/REPORT.md`
- **Remediation Status**: `audit/REMAINING_FINDINGS_TODO.md` (59/59 fixed)
- **Legal Review**: `audit/LEGAL_REVIEW_TODO.md` (F033-F036 pending lawyer)

---

## 🤝 Contributing

Contributions welcome! Framework ini open-source dan aktif dikembangkan.

### How to Contribute

1. **Fork** repository
2. **Create branch**: `git checkout -b feature/improvement-name`
3. **Make changes**: Follow existing conventions
4. **Test**: Validate against audit criteria
5. **Commit**: Use conventional commits (`feat:`, `fix:`, `docs:`)
6. **Push**: `git push origin feature/improvement-name`
7. **Pull Request**: Describe changes and rationale

### Areas for Contribution

- ✅ **Templates**: Stack-specific templates (Flutter, Golang, FastAPI)
- ✅ **Translations**: English version of modules
- ✅ **Legal Review**: Indonesia lawyer review for F032-F037 findings
- ✅ **Cross-Platform**: Bash alternatives for PowerShell commands (F022)
- ✅ **Portability**: Generic instructions replacing `skill_view()` (F004)
- ✅ **Examples**: Real project case studies
- ✅ **Automation**: CI checks per `audit/D7-AUTOMATION.md`

### Development Standards

- **Language**: Bahasa Indonesia (primary), English (secondary)
- **Format**: Markdown, 80-120 chars/line
- **Naming**: `{NN}{L?}-kebab-case.md` (e.g., `06-development-execution.md`)
- **No LaTeX**: Use Unicode (`≥`, `≤`, `→`) instead of `$\ge$`
- **No personal names**: Use generic placeholders
- **Versioning**: Semantic versioning (v1.0.0)

---

## 📄 License

[MIT License](LICENSE) - Free for commercial and personal use.

Copyright (c) 2024-2026 Solo Project Lifecycle Contributors

Permission granted to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies. See LICENSE file for full terms.

---

**Built by solo developers, for solo developers.**  
*Defend your scope. Protect your time. Deliver with confidence.*
