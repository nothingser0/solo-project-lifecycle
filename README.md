# Solo Project Lifecycle Framework

End-to-end framework for solo developers and small teams managing full software development lifecycle from discovery to production deployment and maintenance.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](./LICENSE)
[![Modules](https://img.shields.io/badge/modules-14-green.svg)](./docs/modules/)

---

## What This Is

A complete project management framework covering all phases of software development:

- **Product Discovery** - Market research, competitor analysis, user research
- **Planning & Design** - Requirements, scope, UI/UX prototyping
- **Architecture** - Technical specifications, database design, API contracts
- **Development** - Backend, frontend, integrations with detailed checklists
- **Quality Assurance** - Testing protocols, security audits
- **Deployment** - Production deployment procedures
- **Maintenance** - Post-launch support, warranty, operations

Built for solo developers and small teams shipping production software without enterprise bureaucracy.

---

## Key Features

- **14 Sequential Modules** covering complete SDLC (M00-M13)
- **80+ Ready-to-Use Templates** for PRD, FSD, SOW, API specs, test plans
- **3 Real Case Studies** from actual projects with documented metrics
- **Code Patterns Library** for validation, security, performance optimization
- **Stack-Agnostic** - works with any tech stack (Next.js, Laravel, Django, Go, etc.)
- **JSON Validation Schemas** for automated document validation
- **Automation Scripts** for gate validation and template management

---

## Prerequisites

**For Using the Framework:**
- Git (for cloning the repository)
- Text editor or IDE
- Basic understanding of software development lifecycle

**For Running Automation Scripts:**
- Bash shell (Linux/Mac) or PowerShell (Windows)
- Node.js 18+ (optional, for JSON schema validation)

---

## Installation

### Clone the Repository

```bash
git clone https://github.com/nothingser0/solo-project-lifecycle.git
cd solo-project-lifecycle
```

### Browse Documentation

```bash
# Read framework overview
cat docs/README.md

# List all modules
ls docs/modules/

# View specific module
cat docs/modules/00-product-discovery-strategy.md
```

### Validate Templates (Optional)

```bash
# Bash (Linux/Mac)
./scripts/validate-gate.sh

# PowerShell (Windows)
.\scripts\validate-gate.ps1
```

---

## Usage

### Quick Start: MVP Fast-Track (2-4 Weeks)

For solo developers building an MVP:

1. **Read Quick Start Guide**
   ```bash
   cat docs/quickstart.md
   ```

2. **Use Essential Templates**
   - Browse `templates/essentials/` for most-used 8 templates
   - Start with `PRD_FINAL_TEMPLATE.md` and `FSD_TECHNICAL_TEMPLATE.md`

3. **Follow Minimal Module Path**
   - M01: Idea Feasibility (4 hours)
   - M04: UI/UX Design (2-3 days)
   - M05: Architecture & Specs (1-2 days)
   - M06: Development (10-20 days)
   - M07: Quality Assurance (smoke tests, 1 day)
   - M10: Deployment (1 day)

### Full Client Project (4-8 Weeks)

For freelancers or agencies with paying clients:

1. **Complete Module Sequence**
   ```bash
   # Read all 14 modules in order
   for i in {00..13}; do
       cat docs/modules/${i}-*.md
   done
   ```

2. **Use By-Use-Case Templates**
   - `templates/by-use-case/client-commercial/` for client projects
   - Follow templates in sequential order per module

3. **Implement Gate Checkpoints**
   ```bash
   # Validate gate completion at M03, M09, M11
   ./scripts/validate-gate.sh
   ```

### Example: Create PRD Document

```bash
# 1. Copy template to your project
cp templates/03-architecture-specs/PRD_FINAL_TEMPLATE.md myproject/docs/PRD.md

# 2. Fill in template sections
vim myproject/docs/PRD.md

# 3. Validate completeness (optional)
./scripts/lint-template.sh myproject/docs/PRD.md

# 4. Validate against schema (optional)
npx ajv validate -s schemas/prd.schema.json -d myproject/docs/PRD.json
```

---

## Project Structure

```
solo-project-lifecycle/
├── docs/
│   ├── README.md              # Framework overview and usage guide
│   ├── modules/               # 14 sequential lifecycle modules (M00-M13)
│   └── quickstart.md          # MVP fast-track guide (2-4 weeks)
│
├── templates/
│   ├── essentials/            # 8 most-used templates (quick access)
│   ├── by-use-case/           # Templates organized by scenario
│   │   ├── mvp-fast-track/    # For solo dev MVPs
│   │   ├── client-commercial/ # For paid client projects
│   │   ├── technical-specs/   # Architecture-heavy projects
│   │   └── operations/        # Post-launch maintenance
│   ├── 00-pre-engagement/     # Client intake forms
│   ├── 01-discovery-commercial/ # Market research, SOW, stakeholder maps
│   ├── 02-design/             # Design specs, prototypes, design system
│   ├── 03-architecture-specs/ # PRD, FSD, system design
│   ├── 04-dev-execution/      # Development harness, checklists
│   ├── 05-data-migration/     # Migration plans, reconciliation
│   ├── 06-qa-uat/             # Test plans, security audits
│   ├── 07-release-handover/   # Deployment protocols, BAST
│   ├── 08-maintenance-ops/    # SLA contracts, incident response
│   └── 09-product-growth/     # Analytics, A/B tests, GTM strategy
│
├── patterns/
│   ├── validation/            # Zod schemas, form validation patterns
│   ├── security/              # Authentication, encryption patterns
│   ├── performance/           # N+1 prevention, caching strategies
│   └── git-workflow/          # Branching strategy, commit conventions
│
├── case-studies/              # Real project examples with metrics
│   ├── 01-mvp-saas-inventory.md    # 4 weeks, 200 active users
│   ├── 02-ecommerce-fashion-mvp.md # 21 days → Rp 52M GMV
│   └── 03-crm-real-estate-internal.md # 28 days → +58% revenue
│
├── references/
│   ├── checklists/            # Feasibility criteria, evaluation rubrics
│   ├── playbooks/             # AI-assisted development, design patterns
│   ├── pm/                    # Analytics, prioritization frameworks
│   ├── solo/                  # Solo dev patterns, architecture guide
│   ├── stacks/                # Next.js 15, Laravel 11 quickstarts
│   └── technical/             # Deep research, compliance, design systems
│
├── schemas/                   # JSON validation schemas
│   ├── prd.schema.json        # Product Requirements Document
│   ├── fsd.schema.json        # Functional Specification Document
│   └── sow.schema.json        # Statement of Work
│
├── scripts/                   # Automation tools
│   ├── validate-gate.sh       # Gate checkpoint validation (bash)
│   ├── validate-gate.ps1      # Gate checkpoint validation (PowerShell)
│   ├── lint-template.sh       # Template completeness checker
│   └── template-picker.sh     # Interactive template selector
│
├── README.md                  # This file
├── LICENSE                    # MIT License
└── .gitignore                 # Git ignore rules
```

---

## Module Overview

| Module | Phase | Duration | Description |
|--------|-------|----------|-------------|
| **M00** | Discovery | 2-4 days | Market research, competitor analysis, user research |
| **M01** | Discovery | 4 hours | Idea feasibility scoring (4 dimensions) |
| **M02** | Planning | 1-2 days | Scope definition, MoSCoW prioritization, RBAC |
| **M03** | Planning | 4 hours | Legal SOW contract, payment terms, change requests |
| **M04** | Design | 2-3 days | UI/UX design, prototyping, design system |
| **M05** | Architecture | 1-2 days | PRD, FSD, database schema, API contracts |
| **M06** | Development | 10-20 days | Backend, frontend, integrations, testing |
| **M07** | QA | 2-3 days | System integration testing, security audits |
| **M08** | Preparation | 1 day | Data migration, database seeding |
| **M09** | Validation | 2-3 days | User acceptance testing, client sign-off |
| **M10** | Launch | 1 day | Production deployment, monitoring setup |
| **M11** | Handover | 4 hours | Documentation handover, BAST signing |
| **M12** | Support | Ongoing | Warranty period, SLA retainer |
| **M13** | Growth | Ongoing | Product operations, analytics, iteration |

**Recommended Path for MVPs**: M01 → M04 → M05 → M06 → M07 (smoke tests) → M10

---

## Tech Stack Support

Framework is stack-agnostic. Includes quickstart guides for popular stacks:

- **Frontend**: React, Next.js 15, Vue, Svelte
- **Backend**: Node.js, Laravel 11, Django, Go
- **Database**: PostgreSQL, MySQL, MongoDB, Supabase
- **Deployment**: Vercel, Railway, AWS, DigitalOcean, Cloudflare

See `references/stacks/` for detailed setup instructions.

---

## Contributing

Contributions welcome. Please:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/improvement`)
3. Commit changes (`git commit -m 'Add improvement'`)
4. Push to branch (`git push origin feature/improvement`)
5. Open a Pull Request

**Areas for Contribution:**
- Additional case studies (anonymized real projects)
- Stack-specific templates (Ruby on Rails, Phoenix, etc.)
- Translation to other languages
- Template improvements based on real usage

---

## License

MIT License - see [LICENSE](./LICENSE) file for details.

Commercial use allowed. Use this framework for client projects, products, or consulting services.

---

## Support

**Documentation**: [docs/README.md](./docs/README.md)  
**Quick Start**: [docs/quickstart.md](./docs/quickstart.md)  
**Issues**: [GitHub Issues](https://github.com/nothingser0/solo-project-lifecycle/issues)

---

**Maintained by solo developers, for solo developers.**

Last updated: 2026-10-02
