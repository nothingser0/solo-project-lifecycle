# Solo Project Lifecycle

Software development framework for solo developers and small teams. Covers project lifecycle from discovery through production deployment and maintenance.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](./LICENSE)

---

## What This Is

**Comprehensive project management framework** for solo developers and small teams managing software projects:

- 14 modules covering discovery, design, development, QA, deployment, maintenance
- 1,000-system verified taxonomy (`references/taxonomy/PROJECT_CATALOG_1000.md`) across 4 scales
- 250 standard industry software archetypes (`references/taxonomy/SYSTEM_ARCHETYPES_250.md`)
- October 2026 official modern tech stack baseline & anti-overkill matrix across 17 engineering domains
- 150+ production-ready templates (PRD, FSD, SOW, test plans, deployment protocols)
- Real case studies with metrics
- Code patterns for common problems
- Scripts for validation and automation

Works with any tech stack. Built for solo developers, freelancers, consulting teams.

---

## Framework Architecture

**Repository size: ~3.9MB uncompressed framework content (270+ files)** (verified via `./scripts/calculate-size.sh`).
This is a **comprehensive skill framework/toolkit**, not a minimal starter template:

| Component | Size | Purpose |
|-----------|------|---------|
| Module library | 620KB | 14 lifecycle phases with detailed workflows |
| System taxonomy & catalog | 100KB | 250 industry archetypes & 1,000 system variations across 4 scales |
| Template library | 1.8MB | 170+ production-ready templates |
| Reference guides | 824KB | Playbooks, patterns, 2026 stack support matrix, deep-dive materials |
| Case studies | 100KB | 5 examples (3 real + 2 worked examples) |
| Code patterns | 188KB | 14 reusable patterns (API, testing, deployment, payments, UU PDP, etc.) |
| Scripts | 200KB | 20+ validation and automation tools (Bash + PowerShell) |

**Why this size?**  
Completeness = utility. Similar to design systems or testing frameworks - comprehensive by design. You use specific modules/templates on-demand, not everything at once.

**Not for you if:**  
- You want minimal boilerplate (<50KB)
- You prefer ad-hoc project management
- You work with established enterprise PM tools

**Perfect for:**  
- Solo devs managing client projects end-to-end
- Freelancers needing governance without corporate overhead
- Small teams wanting structured SDLC without bloat

---

## What's Included

```
solo-project-lifecycle/
├── docs/modules/          14 lifecycle modules (M00-M13)
├── templates/             150+ project templates
├── patterns/              12 code patterns (API, testing, deployment, database, security)
├── case-studies/          5 examples (3 real + 2 worked examples)
├── references/            Guides and playbooks
│   └── taxonomy/          250 industry archetypes & 1,000 project catalog
└── scripts/               Automation tools
```

---

## Getting Started

### ⚠️ Important: Framework vs Project Separation

**This repository is a template library. Projects are created in separate directories.**

**Project initialization workflow**:

1. **Create project directory** (separate from framework)
2. **Initialize git**: `git init`
3. **Initialize framework**: Generate planning docs (`docs/pm/`, `docs/specs/`, `docs/harness-root/`)
4. **Scaffold framework**: Run `npx create-next-app`, `laravel new`, etc.
5. **Deploy harness & clean staging**: Agent copies `docs/harness-root/*` and `.env.example` → `./` (root), then deletes `rm -rf docs/harness-root/`

**Why `docs/harness-root/` staging?**
- Root folder empty/git-only before scaffold
- Framework CLI needs empty root
- Harness files deployed AFTER scaffold to avoid conflicts
- Cleaning up `docs/harness-root/` after copy enforces a single source of truth and avoids AI agent path drift

---

**Clone the repo:**

```bash
# One-time framework setup
git clone https://github.com/nothingser0/solo-project-lifecycle.git
cd solo-project-lifecycle
```

**Start a new project:**

```bash
# Create project directory (OUTSIDE framework repo)
mkdir ~/projects/my-mvp-app
cd ~/projects/my-mvp-app
git init

# Initialize framework specs:
# Framework generates:
#   - docs/pm/ (planning docs)
#   - docs/specs/ (PRD, FSD)
#   - docs/harness-root/ (9 AI control files - staged)

# After scaffold (npx create-next-app, etc.)
# Agent deploys: cp docs/harness-root/* ./ && cp docs/harness-root/.env.example ./
# Clean up staging: rm -rf docs/harness-root/
```

---

## Usage

### Quick MVP (2-4 weeks)

Minimal path for solo projects:

1. M01: Idea Feasibility (4 hours)
2. M04: UI/UX Design (2-3 days)
3. M05: Architecture (1-2 days)
4. M06: Development (10-20 days)
5. M07: QA smoke tests (1 day)
6. M10: Deploy (1 day)

See `docs/quickstart.md` for details.

### Full Client Project (4-8 weeks)

Complete governance for paid client work:

- Follow all 14 modules in sequence
- Use templates from `templates/by-use-case/client-commercial/`
- Gate checkpoints at M03 (signed SOW), M09 (UAT), M11 (handover)

### Using Templates

```bash
# Copy template to your project
cp templates/03-architecture-specs/PRD_FINAL_TEMPLATE.md myproject/PRD.md

# Fill in your requirements
vim myproject/PRD.md

# Validate completeness (optional)
./scripts/lint-template.sh myproject/PRD.md
```

---

## Module List

| Module | Phase | Duration | Description |
|--------|-------|----------|-------------|
| M00 | Discovery | 2-4 days | Market research, competitor analysis |
| M01 | Discovery | 4 hours | Idea feasibility scoring |
| M02 | Planning | 1-2 days | Scope definition, prioritization |
| M03 | Planning | 4 hours | SOW contract, terms |
| M04 | Design | 2-3 days | UI/UX design, prototyping |
| M05 | Architecture | 1-2 days | PRD, FSD, technical specs |
| M06 | Development | 10-20 days | Build, test, integrate |
| M07 | QA | 2-3 days | Testing, security audit |
| M08 | Preparation | 1 day | Data migration |
| M09 | Validation | 2-3 days | UAT, sign-off |
| M10 | Launch | 1 day | Deploy to production |
| M11 | Handover | 4 hours | Documentation, training |
| M12 | Support | Ongoing | Warranty, bug fixes |
| M13 | Growth | Ongoing | Analytics, iteration |

Complete module docs: `docs/modules/`

---

## Tech Stacks

Framework is stack-agnostic. Quickstart guides for:

- Frontend: React, Next.js (v15–v16+), Vue, Svelte
- Backend: Node.js, Laravel (v11–v13+), Django (v5–v6+), Go (v1.23–v1.27+)
- Database: PostgreSQL, MySQL, Supabase
- Deploy: Vercel, Railway, AWS, DigitalOcean

See `references/stacks/` for setup instructions.

---

## Case Studies

### Real Projects (Anonymized)

**1. MVP SaaS Inventory (Small Scale)**  
4 weeks, Laravel + MySQL, solo founder  
Result: 23 paying users, Rp 1.15M MRR after 3 months

**2. E-commerce Fashion MVP**  
Real anonymized client project

**3. Real Estate CRM (Internal Tool)**  
Real anonymized agency project

### Worked Examples (Hypothetical)

**4. Medium-Scale B2B SaaS Platform**  
12 weeks, Next.js + Supabase, multi-tenant with Stripe  
Demonstrates: M01-M11 workflow, RLS security, real-time features

**5. Large-Scale System Integration**  
25 weeks, Node.js + PostgreSQL, hospital legacy integration  
Demonstrates: M00-M12 full workflow, data migration, compliance

Full details: `case-studies/`

---

## Scripts

**Bash (Linux/Mac):**
```bash
./scripts/gates/validate-gate.sh              # Validate gate checkpoints (M00-M13)
./scripts/scaffold/init-project.sh            # Bootstrap new project directory per scale
./scripts/verify/check-package-versions.sh     # Real-time registry dependency checks (14 stacks)
./scripts/verify/verify-framework-version.sh   # Validate lockfile against FSD
./scripts/verify/lint-template.sh              # Check template completeness
./scripts/scaffold/template-picker.sh          # Interactive template selector
./scripts/verify/verify-all.sh                 # Repository sanity and integrity check
```

**PowerShell (Windows):**
```powershell
.\scripts\gates\validate-gate.ps1
.\scripts\scaffold\init-project.ps1
.\scripts\verify\check-package-versions.ps1   # 14 stacks supported (-Framework <stack>)
.\scripts\verify\verify-framework-version.ps1
.\scripts\verify\lint-template.ps1
.\scripts\scaffold\template-picker.ps1
.\scripts\verify\verify-all.ps1
```

---

## License

Useful contributions:
- Additional case studies
- Stack-specific templates
- Translations
- Template improvements

---

MIT License. See [LICENSE](./LICENSE).

Use for commercial projects, consulting, products, internal tools.

---

## Links

- [Framework Guide](./docs/README.md)
- [Quick Start](./docs/quickstart.md)
- [All Modules](./docs/modules/)
- [Templates](./templates/)
- [Patterns](./patterns/)
- [References](./references/)
- [Scripts](./scripts/)
- [Issues](https://github.com/nothingser0/solo-project-lifecycle/issues)

---

Built by solo developers, for solo developers.

Last updated: 2026-10-08
