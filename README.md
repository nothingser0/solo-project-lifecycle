# Solo Project Lifecycle Framework

A complete software development lifecycle framework for solo developers and small teams. Covers everything from initial product discovery through deployment and post-launch maintenance.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](./LICENSE)
[![Modules](https://img.shields.io/badge/modules-14-green.svg)](./docs/modules/)

---

## Overview

This framework provides structured guidance for managing software projects from start to finish. It includes 14 sequential modules, 80+ ready-to-use templates, real case studies, and automation scripts.

**Built for**: Solo developers, freelancers, small development teams, indie hackers

**Use cases**: Client projects, SaaS MVPs, internal tools, e-commerce platforms

---

## Features

- **14 Sequential Modules** covering complete SDLC from discovery to operations
- **80+ Templates** including PRD, FSD, SOW, API specs, test plans, deployment protocols
- **3 Real Case Studies** with documented timelines, budgets, and outcomes
- **Code Patterns** for validation, authentication, performance optimization
- **Stack-Agnostic** - works with any technology stack
- **Automation Scripts** for validation and template management
- **JSON Schemas** for document validation

---

## Prerequisites

**To use the framework:**
- Git for cloning the repository
- Text editor or IDE
- Basic understanding of software development

**To run automation scripts:**
- Bash (Linux/Mac) or PowerShell (Windows)
- Node.js 18+ (optional, for schema validation)

---

## Installation

Clone the repository:

```bash
git clone https://github.com/nothingser0/solo-project-lifecycle.git
cd solo-project-lifecycle
```

Browse the documentation:

```bash
# Framework overview
cat docs/README.md

# Quick start guide for MVPs
cat docs/quickstart.md

# List all modules
ls docs/modules/
```

Validate templates (optional):

```bash
# Bash
./scripts/validate-gate.sh

# PowerShell
.\scripts\validate-gate.ps1
```

---

## Usage

### For MVP Projects (2-4 Weeks)

Recommended module sequence:

1. **M01: Idea Feasibility** (4 hours) - Score your idea across 4 dimensions
2. **M04: UI/UX Design** (2-3 days) - Create wireframes and prototypes  
3. **M05: Architecture** (1-2 days) - Write PRD and technical specs
4. **M06: Development** (10-20 days) - Build features with checklists
5. **M07: QA** (1 day) - Run smoke tests and basic validation
6. **M10: Deployment** (1 day) - Deploy to production

Start here: `docs/quickstart.md`

Essential templates: `templates/essentials/`

### For Client Projects (4-8 Weeks)

Follow all 14 modules in sequence for complete project governance.

Use templates from: `templates/by-use-case/client-commercial/`

Key gates:
- **M03**: Signed SOW and contract
- **M09**: Client UAT sign-off
- **M11**: Final handover and BAST

### Example: Create PRD Document

```bash
# Copy template to your project
cp templates/03-architecture-specs/PRD_FINAL_TEMPLATE.md myproject/PRD.md

# Edit with your requirements
vim myproject/PRD.md

# Validate completeness
./scripts/lint-template.sh myproject/PRD.md

# Validate against JSON schema (optional)
npx ajv validate -s schemas/prd.schema.json -d myproject/PRD.json
```

---

## Project Structure

```
solo-project-lifecycle/
│
├── docs/
│   ├── README.md              # Framework guide and usage instructions
│   ├── modules/               # 14 sequential modules (M00-M13)
│   └── quickstart.md          # MVP fast-track guide
│
├── templates/
│   ├── essentials/            # 8 most-used templates
│   ├── by-use-case/           # Templates organized by project type
│   ├── 00-pre-engagement/     # Client intake and qualification
│   ├── 01-discovery-commercial/  # Market research, SOW, stakeholder maps
│   ├── 02-design/             # Design specs and prototypes
│   ├── 03-architecture-specs/ # PRD, FSD, system design
│   ├── 04-dev-execution/      # Development checklists and harness
│   ├── 05-data-migration/     # Migration plans and validation
│   ├── 06-qa-uat/             # Test plans and security audits
│   ├── 07-release-handover/   # Deployment protocols and BAST
│   ├── 08-maintenance-ops/    # SLA contracts and incident response
│   └── 09-product-growth/     # Analytics and A/B testing
│
├── patterns/
│   ├── validation/            # Form validation patterns with Zod
│   ├── security/              # Authentication and encryption
│   ├── performance/           # Caching and N+1 prevention
│   └── git-workflow/          # Branching strategy and commits
│
├── case-studies/
│   ├── 01-mvp-saas-inventory.md       # 4 weeks, 200 users
│   ├── 02-ecommerce-fashion-mvp.md    # 21 days, Rp 52M GMV
│   └── 03-crm-real-estate-internal.md # 28 days, +58% revenue
│
├── references/
│   ├── checklists/            # Feasibility criteria, evaluation guides
│   ├── playbooks/             # AI development, design patterns
│   ├── pm/                    # PM guides for analytics, prioritization
│   ├── solo/                  # Solo developer architecture guide
│   ├── stacks/                # Next.js 15, Laravel 11 quickstarts
│   └── technical/             # Deep research, compliance, design systems
│
├── schemas/                   # JSON validation schemas
├── scripts/                   # Automation and validation tools
├── README.md                  # This file
├── LICENSE                    # MIT License
└── .gitignore
```

---

## Module Overview

| Module | Phase | Duration | Description |
|--------|-------|----------|-------------|
| M00 | Discovery | 2-4 days | Product discovery, market research, competitive analysis |
| M01 | Discovery | 4 hours | Idea feasibility scoring (viability, desirability, feasibility, sustainability) |
| M02 | Planning | 1-2 days | Scope definition, MoSCoW prioritization, RBAC design |
| M03 | Planning | 4 hours | Legal SOW, contract terms, payment schedule |
| M04 | Design | 2-3 days | UI/UX design, wireframes, prototypes, design system |
| M05 | Architecture | 1-2 days | PRD, FSD, database schema, API contracts |
| M06 | Development | 10-20 days | Backend, frontend, integrations, unit tests |
| M07 | QA | 2-3 days | System integration testing, security audits, performance tests |
| M08 | Preparation | 1 day | Data migration, database seeding, content import |
| M09 | Validation | 2-3 days | User acceptance testing, client sign-off |
| M10 | Launch | 1 day | Production deployment, monitoring, rollback plan |
| M11 | Handover | 4 hours | Documentation handover, training, BAST signing |
| M12 | Support | Ongoing | Warranty period, bug fixes, SLA retainer |
| M13 | Growth | Ongoing | Product operations, analytics, feature iteration |

---

## Technology Support

Framework works with any technology stack. Quickstart guides included for:

**Frontend**: React, Next.js 15, Vue, Svelte  
**Backend**: Node.js, Laravel 11, Django, Go  
**Database**: PostgreSQL, MySQL, MongoDB, Supabase  
**Hosting**: Vercel, Railway, AWS, DigitalOcean, Cloudflare

See `references/stacks/` for detailed setup instructions.

---

## Real Case Studies

**Fashion E-commerce MVP**
- Timeline: 21 days
- Team: 1 developer
- Stack: Next.js 14, PostgreSQL, Midtrans
- Result: Rp 52M GMV in first 3 months

**Real Estate CRM (Internal)**
- Timeline: 28 days
- Team: 1 developer
- Stack: Laravel 11, MySQL, Livewire
- Result: +58% revenue increase, 40% time savings

**SaaS Inventory System**
- Timeline: 4 weeks
- Team: Solo developer
- Stack: Next.js, Supabase, Stripe
- Result: 200 active users, $2.4K MRR

Full details: `case-studies/`

---

## Contributing

Contributions welcome. To contribute:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/new-template`)
3. Commit your changes (`git commit -m 'Add new template'`)
4. Push to the branch (`git push origin feature/new-template`)
5. Open a Pull Request

**Contribution ideas:**
- Additional case studies from real projects
- Stack-specific templates (Ruby on Rails, Phoenix, etc.)
- Translations to other languages
- Template improvements based on field usage

---

## License

MIT License. See [LICENSE](./LICENSE) for full text.

You can use this framework for:
- Commercial client projects
- SaaS products and startups
- Consulting and agency work
- Internal company projects

---

## Documentation

**Main Guide**: [docs/README.md](./docs/README.md)  
**Quick Start**: [docs/quickstart.md](./docs/quickstart.md)  
**Module Details**: [docs/modules/](./docs/modules/)  
**Templates**: [templates/](./templates/)

---

## Support

**Issues and Questions**: [GitHub Issues](https://github.com/nothingser0/solo-project-lifecycle/issues)

**Status**: Production-ready, actively maintained

---

Built by solo developers, for solo developers.

Last updated: October 2026
