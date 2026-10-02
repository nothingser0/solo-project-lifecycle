# Solo Project Lifecycle

> **Operational software framework for solo developers and technical consultants** — Execute projects from Small (MVP) to Enterprise scale with work boundary protection, AI automation, and graduated quality gates.

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

**Solo Project Lifecycle** adalah framework SDLC komprehensif yang dirancang khusus untuk solo developer dan konsultan teknis yang menjalankan proyek freelance atau produk sendiri. Framework ini mencakup 13 modul dari fase discovery hingga production maintenance, lengkap dengan template dokumen, checklist, dan panduan best practices.

**Problem yang diselesaikan**:
- ❌ Scope creep tanpa batas
- ❌ Kerja gratis tanpa kontrak jelas
- ❌ Tidak tahu harus mulai dari mana
- ❌ Client expectations tidak terkontrol
- ❌ Legal compliance (UU PDP, UU ITE) diabaikan

**Solution**:
- ✅ 12-stage gated pipeline dengan stop point jelas
- ✅ Template kontrak & payment terms bertahap
- ✅ Fast-track mode untuk MVP (skip dokumentasi berlebihan)
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

### Fast-Track (MVP in 1-4 weeks)

```bash
# 1. Copy minimal template
cp templates/03-architecture-specs/PROJECT_LITE_TEMPLATE.md ./PROJECT.md

# 2. Fill business context (20 min)
# 3. Pick tech stack from ladder (Next.js/Laravel/Django)
# 4. Generate UI with Google Stitch (modules/04)
# 5. Start coding (modules/06)
```

**Skip**: Market research (00), Feasibility (01), Formal SOW (03), Design System (04A), System Design (05B)

### Standard Flow (Commercial Project)

```bash
# 1. Load skill in AI agent
skill(name='solo-project-lifecycle')

# 2. Agent guides through 13 modules sequentially
# Each module has:
#   - Input prerequisites
#   - Step-by-step execution
#   - Output deliverables
#   - Gate verification (stop until approved)
```

**Example conversation**:
```
User: "Client mau bikin sistem dokumen digital, budget 50 juta, deadline 3 bulan"

Agent: 
1. Skala: Menengah (3 bulan, budget realistis)
2. Load: modules/01-idea-feasibility.md
3. Scoring: Technical=4, Bandwidth=4, Legal=3, Commercial=5 → Total 16/20 ✓
4. Next: Module 02 (Scope & Requirements)
```

---

## 📦 Installation

### As AI Agent Skill

**For OpenCode / Claude Desktop**:

```bash
cd ~/.omp/agent/skills/
git clone https://github.com/nothingser0/solo-project-lifecycle.git
```

**For Cursor / Windsurf**:
```bash
cd ~/Library/Application\ Support/Cursor/skills/  # macOS
cd ~/.config/cursor/skills/  # Linux
git clone https://github.com/nothingser0/solo-project-lifecycle.git
```

**For Generic Use** (no AI agent):
```bash
git clone https://github.com/nothingser0/solo-project-lifecycle.git
cd solo-project-lifecycle

# Browse modules/ and templates/ manually
# Copy templates to your project as needed
```

### Verify Installation

```bash
# Check SKILL.md exists
cat SKILL.md | head -20

# List all modules
ls -1 modules/*.md

# Count templates
find templates -name "*.md" | wc -l
```

---

## 💻 Usage

### With AI Agent

1. **Load skill**: `skill(name='solo-project-lifecycle')`
2. **Agent reads** `SKILL.md` and understands 13-module pipeline
3. **Agent asks** project scale (Kecil/Menengah/Besar/Enterprise)
4. **Agent loads** appropriate module on-demand (progressive disclosure)
5. **Agent executes** module steps and generates deliverables
6. **Agent stops** at gate checkpoint, waits for user approval

### Manual Use (No Agent)

1. **Identify scale**: Read `SKILL.md` section "Project Scale Table"
2. **Pick module path**:
   - Fast-Track: 04 → 06 → 10
   - Standard: 00 → 01 → 02 → 03 → 04 → 05 → 06 → 07 → 08 → 09 → 10 → 11
   - Enterprise: All modules + 04A, 05B, 06B
3. **Read module**: Open `modules/{NN}-{name}.md`
4. **Copy template**: From `templates/{phase}/` to `docs/`
5. **Fill template**: Follow module instructions
6. **Verify gate**: Check "GATE CHECK BEFORE EXIT" section

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
│   ├── 04A-design-system-foundation.md
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

### Core Documentation
- **[SKILL.md](SKILL.md)**: Framework overview, principles, module map
- **[modules/](modules/)**: 13 execution modules with step-by-step instructions
- **[templates/](templates/)**: 100+ ready-to-use document templates
- **[references/](references/)**: Best practices, checklists, patterns

### Key Guides
- **Solo Development Patterns**: `references/solo/SOLO_DEVELOPMENT_PATTERNS.md`
- **Engineering Standards**: `references/solo/SOLO_ENGINEERING_STANDARDS.md`
- **Feasibility Criteria**: `references/checklists/FEASIBILITY_CRITERIA.md`
- **PM Analytics Setup**: `references/pm/PM_ANALYTICS_SETUP_GUIDE.md`
- **AI-Assisted Development**: `references/playbooks/ai-assisted-development.md`

### Audit & Quality
- **Audit Report**: `audit/REPORT.md` (59 findings, 85% accuracy)
- **Remediation Progress**: `audit/REMEDIATION_PROGRESS.md` (16/59 fixed, all Critical cleared)
- **Refactor Plan**: `audit/REFACTOR_PLAN.md` (D1-D9 structure improvements)

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

- ✅ **Templates**: Add stack-specific templates (Flutter, Golang, FastAPI)
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
