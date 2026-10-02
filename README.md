# Solo Project Lifecycle

Software development framework for solo developers and small teams. Covers project lifecycle from discovery through production deployment and maintenance.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](./LICENSE)

---

## What This Is

**Comprehensive project management framework** for solo developers and small teams managing software projects:

- 14 modules covering discovery, design, development, QA, deployment, maintenance
- 80+ templates (PRD, FSD, SOW, test plans, deployment protocols)
- Real case studies with metrics
- Code patterns for common problems
- Scripts for validation and automation

Works with any tech stack. Built for solo developers, freelancers, consulting teams.

---

## Framework Architecture

**Repository size: ~9MB** (intentionally comprehensive)

This is a **skill framework/toolkit**, not a minimal starter template:

| Component | Size | Purpose |
|-----------|------|---------|
| Module library | 440KB | 14 lifecycle phases with detailed workflows |
| Template library | 869KB | 80+ production-ready templates |
| Reference guides | 604KB | Playbooks, patterns, deep-dive materials |
| Case studies | 52KB | Real project metrics and outcomes |
| Code patterns | 80KB | Reusable validation/auth/performance code |

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
├── templates/             80+ project templates
├── patterns/              Code patterns (validation, auth, performance)
├── case-studies/          3 real projects with outcomes
├── references/            Guides and playbooks
├── schemas/               JSON validation
└── scripts/               Automation tools
```

---

## Getting Started

### ⚠️ Important: Framework vs Project Separation

**This repository is a template library. Projects are created in separate directories.**

**Project initialization workflow**:

1. **Create project directory** (separate from framework)
2. **Initialize git**: `git init`
3. **Load skill in Omp/Kiro**: Agent generates `docs/pm/`, `docs/specs/`, `docs/harness-root/`
4. **Scaffold framework**: Run `npx create-next-app`, `laravel new`, etc.
5. **Deploy harness**: Agent copies `docs/harness-root/*` → `./` (root)

**Why `docs/harness-root/` staging?**
- Root folder empty/git-only before scaffold
- Framework CLI needs empty root
- Harness files deployed AFTER scaffold to avoid conflicts

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

# Load skill in Omp/Kiro: solo-project-lifecycle
# Agent generates:
#   - docs/pm/ (planning docs)
#   - docs/specs/ (PRD, FSD)
#   - docs/harness-root/ (7 AI control files - staged)

# After scaffold (npx create-next-app, etc.)
# Agent deploys: docs/harness-root/* → ./ (root)
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

- Frontend: React, Next.js 15, Vue, Svelte
- Backend: Node.js, Laravel 11, Django, Go
- Database: PostgreSQL, MySQL, Supabase
- Deploy: Vercel, Railway, AWS, DigitalOcean

See `references/stacks/` for setup instructions.

---

## Case Studies

**Fashion E-commerce**  
21 days, solo dev, Next.js + PostgreSQL  
Result: Rp 52M GMV in 3 months

**Real Estate CRM**  
28 days, Laravel + MySQL  
Result: +58% revenue, 40% time savings

**SaaS Inventory**  
4 weeks, Next.js + Supabase  
Result: 200 users, $2.4K MRR

Full details: `case-studies/`

---

## Scripts

**Bash (Linux/Mac):**
```bash
./scripts/validate-gate.sh     # Validate gate checkpoints
./scripts/lint-template.sh     # Check template completeness
./scripts/template-picker.sh   # Interactive template selector
```

**PowerShell (Windows):**
```powershell
.\scripts\validate-gate.ps1
.\scripts\lint-template.ps1
.\scripts\template-picker.ps1
```

---

## Contributing

Fork, branch, commit, push, PR.

Useful contributions:
- Additional case studies
- Stack-specific templates
- Translations
- Template improvements

---

## License

MIT License. See [LICENSE](./LICENSE).

Use for commercial projects, consulting, products, internal tools.

---

## Links

- [Framework Guide](./docs/README.md)
- [Quick Start](./docs/quickstart.md)
- [All Modules](./docs/modules/)
- [Templates](./templates/)
- [Issues](https://github.com/nothingser0/solo-project-lifecycle/issues)

---

Built by solo developers, for solo developers.

Last updated: 2026-10-02
