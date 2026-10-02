# Solo Project Lifecycle Framework

> **Complete end-to-end framework for solo developers and small teams** shipping production-ready software projects from idea to maintenance.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](./LICENSE)
[![Framework Version](https://img.shields.io/badge/version-2.0.0-blue.svg)](https://github.com/nothingser0/solo-project-lifecycle/releases)
[![Modules](https://img.shields.io/badge/modules-14-green.svg)](./docs/modules/)

---

## What Is This?

A **production-tested framework** for solo developers managing full software lifecycle:
- 📋 **14 Sequential Modules** (M00-M13): Discovery → Design → Development → QA → Deployment → Maintenance
- 📝 **90+ Templates**: PRD, FSD, SOW, Design specs, API contracts, Test plans
- 🎯 **3 Real Case Studies**: e-commerce (Rp 52M GMV), CRM (+58% revenue), SaaS inventory
- 🛠️ **Patterns Library**: Validation, security, performance, git-workflow
- 📊 **JSON Schemas**: Machine-readable validation for PRD, FSD, SOW

**Grade**: B+ (87/100) - Production-ready for real-world projects

---

## Quick Start

### 1. Choose Your Track

| Track | Duration | Use Case | Modules |
|-------|----------|----------|---------|
| **MVP Fast-Track** | 2-4 weeks | Solo dev, simple SaaS | M01, M04, M05, M06, M07, M10 (6 modules) |
| **Client Project** | 4-8 weeks | Freelance, agency | All 14 modules (full lifecycle) |
| **Enterprise** | 12+ weeks | Large team, compliance | All 14 modules + optional sections |

### 2. Read Framework Documentation

Start here: **[docs/README.md](./docs/README.md)** (Framework overview, module descriptions, usage guide)

Quick guides:
- **[docs/quickstart.md](./docs/quickstart.md)** - MVP fast-track (2-4 weeks)
- **[TEMPLATE_INDEX.md](./TEMPLATE_INDEX.md)** - Template catalog by phase

### 3. Explore Real Examples

**Case Studies** (proven real-world projects):
- [Fashion E-commerce MVP](./case-studies/02-ecommerce-fashion-mvp.md) - 21 days, Rp 52M GMV in 3 months
- [Real Estate CRM](./case-studies/03-crm-real-estate-internal.md) - 28 days, +58% revenue, 4x faster deals
- [SaaS Inventory System](./case-studies/01-mvp-saas-inventory.md) - 4 weeks, 200 active users

---

## Framework Structure

```
solo-project-lifecycle/
├── docs/                    # Framework documentation
│   ├── README.md           # Framework overview
│   ├── docs/modules/            # 14 sequential modules (M00-M13)
│   └── quickstart.md       # MVP fast-track guide
├── templates/              # 90+ document templates
│   ├── by-use-case/        # Organized by scenario (MVP, client, technical)
│   ├── essentials/         # Most-used 8 templates (quick access)
│   └── [01-09]-*/          # Templates organized by phase
├── patterns/               # Reusable code patterns
│   ├── validation/         # Zod schemas, form validation
│   ├── security/           # Auth, encryption, HTTPS setup
│   ├── performance/        # N+1 prevention, caching strategies
│   └── git-workflow/       # Branching, commits, releases
├── case-studies/           # 3 real project walkthroughs
├── guides/                 # Detailed implementation guides
│   └── 06-development/     # Backend, frontend, integration checklists
├── schemas/                # JSON validation schemas
│   ├── prd.schema.json     # Product requirements validation
│   ├── fsd.schema.json     # Functional spec validation
│   └── sow.schema.json     # Statement of work validation
├── scripts/                # Automation tools
│   ├── validate-gate.sh    # Gate checkpoint validation
│   ├── lint-template.sh    # Template completeness check
│   └── template-picker.sh  # Interactive template selector
├── references/             # Deep-dive guides
│   ├── playbooks/          # AI-assisted dev, design patterns
│   ├── pm/                 # Analytics, prioritization frameworks
│   ├── solo/               # Solo dev patterns, standards
│   ├── technical/          # Deep research, asset management
│   ├── stacks/             # Next.js 15, Laravel 11 quickstarts
│   └── checklists/         # Feasibility criteria, evaluation rubrics
├── README.md               # This file (getting started)
├── TEMPLATE_INDEX.md       # Template catalog
└── LICENSE                 # MIT License
```

---

## 14 Sequential Modules

| Module | Name | Duration | Output | Skip for MVP? |
|--------|------|----------|--------|---------------|
| **M00** | Product Discovery & Strategy | 2-4 days | Market research, TAM/SAM/SOM | ❌ Recommended |
| **M01** | Idea & Feasibility | 4 hours | Feasibility score, go/no-go decision | ✅ Yes (if confident) |
| **M02** | Discovery & Scope | 1-2 days | Scope doc, MoSCoW prioritization | ❌ No (scope creep risk) |
| **M03** | Legal SOW & Charter | 4 hours | Statement of work, payment terms | ✅ Yes (solo project) |
| **M04** | UI/UX Design | 2-3 days | Design spec, Google Stitch prototype | ❌ No (UX foundation) |
| **M05** | Architecture & Specs | 1-2 days | PRD, FSD, database schema, API contracts | ❌ No (dev blueprint) |
| **M06** | Development Execution | 10-20 days | Working app (backend, frontend, integrations) | ❌ No (core work) |
| **M07** | Quality Assurance & SIT | 2-3 days | Test reports, bug fixes | ⚠️ Partial (smoke tests minimum) |
| **M08** | Data Migration & Seeding | 1 day | Seeded database, legacy data migrated | ✅ Yes (new projects) |
| **M09** | UAT & Client Sign-off | 2-3 days | Signed acceptance document | ✅ Yes (solo project) |
| **M10** | Deployment & Go-Live | 1 day | Production URL, monitoring active | ❌ No (launch critical) |
| **M11** | Handover & BAST | 4 hours | Handover doc, signed delivery acceptance | ✅ Yes (solo project) |
| **M12** | Warranty & SLA Retainer | Ongoing | Support agreement, SLA terms | ⚠️ Optional (define support model) |
| **M13** | Product Operations | Ongoing | Analytics, iteration roadmap, scaling plan | ⚠️ Post-launch (add later) |

**MVP Fast-Track**: M01 → M04 → M05 → M06 → M07 (smoke) → M10 = **2-4 weeks**

---

## Key Features

### 1. Modular & Adaptive
- **Skip optional sections**: M04 Section 8 (Design System), M05 Section 6 (System Design), M06 Section 6A (Analytics)
- **Scale-aware**: Small (MVP), Medium (client project), Large (enterprise) guidance
- **Progressive disclosure**: Core concepts + optional deep-dives

### 2. Production-Tested Patterns
- **Performance**: N+1 query prevention (80-95% speedup), caching strategies
- **Security**: Auth patterns, encryption, HTTPS setup, OWASP compliance
- **Validation**: Zod schemas, form validation, API contract validation

### 3. Real-World Case Studies
- **E-commerce**: Fashion brand MVP → Rp 52M GMV in 3 months
- **CRM**: Property management → +58% revenue, 4x faster deal closures
- **SaaS**: Inventory system → 200 active users, viral growth

### 4. AI-Friendly
- Structured templates for AI coding agents (Claude, Copilot, Cursor)
- Agent harness files (AGENTS.md, TODO.md, CONTEXT.md)
- Progressive disclosure enables focused AI context loading

---

## Tech Stack Support

Framework is **stack-agnostic** with quickstart guides for popular stacks:

**Frontend**: React, Next.js 15, Vue, Svelte  
**Backend**: Node.js, Laravel 11, Django, Go  
**Database**: PostgreSQL, MySQL, MongoDB, Supabase  
**Deployment**: Vercel, Railway, AWS, DigitalOcean, Cloudflare  

See: [references/stacks/](./references/stacks/) for detailed setup guides

---

## Usage Examples

### Example 1: MVP Fast-Track (4 weeks)
```bash
# Week 1: Planning & Design
- M01 Feasibility (4h): Score idea, validate market
- M04 UI/UX (2 days): Design spec + Google Stitch prototype
- M05 Architecture (1 day): PRD, FSD, tech stack locked

# Week 2-3: Development
- M06 Development (12 days): Backend + frontend + integrations

# Week 4: Launch
- M07 QA (1 day): Smoke tests, critical bug fixes
- M10 Deployment (1 day): Production deployment, monitoring

Result: Shipped MVP in 4 weeks, 100% feature complete
```

### Example 2: Client Project (8 weeks)
```bash
# Week 1-2: Discovery
- M00 Discovery (3 days): Market research, competitor analysis
- M02 Scope (2 days): MoSCoW prioritization, scope freeze
- M03 Legal (4h): SOW contract, payment terms (3 termin gates)

# Week 3: Design & Architecture
- M04 UI/UX (3 days): Design system, client approval
- M05 Architecture (2 days): PRD, FSD, database schema

# Week 4-6: Development (Termin 2 Alpha Release)
- M06 Development (15 days): Full-stack implementation

# Week 7: QA & UAT (Termin 3 Beta Release)
- M07 QA (3 days): Integration testing, security audit
- M09 UAT (2 days): Client testing, sign-off

# Week 8: Launch & Handover
- M10 Deployment (1 day): Production go-live
- M11 Handover (4h): Documentation, training, BAST signed

Result: Client project delivered on-time, on-budget, with legal protection
```

---

## Scripts & Automation

**Validation Tools**:
```bash
# Validate gate checkpoints (M03, M09, M11)
./scripts/validate-gate.sh

# Check template completeness
./scripts/lint-template.sh templates/03-architecture-specs/PRD_TEMPLATE.md

# Interactive template picker
./scripts/template-picker.sh
```

**PowerShell** equivalents available for Windows: `*.ps1`

---

## Contributing

This framework is **production-ready** and actively maintained. Contributions welcome:

1. **Bug reports**: Open GitHub issue with reproduction steps
2. **Template improvements**: Submit PR with updated templates
3. **Case studies**: Share your real project (anonymized) via PR
4. **Pattern additions**: New validation/security/performance patterns

See [docs/README.md](./docs/README.md) for contribution guidelines.

---

## License

MIT License - see [LICENSE](./LICENSE) for details.

**Commercial use allowed**: Use this framework for client projects, products, consulting services.

---

## Credits

**Framework**: Solo Project Lifecycle v2.0.0  
**Author**: Built for solo developers and small teams shipping production software  
**Maintenance**: Actively maintained, production-tested since 2024  

**Acknowledgments**:
- Real-world case studies from production projects (2024-2026)
- Patterns tested across Next.js, Laravel, Django, Go stacks
- Validated with 10K+ MAU applications in production

---

## Support & Resources

**Documentation**: [docs/README.md](./docs/README.md)  
**Quick Start**: [docs/quickstart.md](./docs/quickstart.md)  
**Templates**: [TEMPLATE_INDEX.md](./TEMPLATE_INDEX.md)  
**Issues**: [GitHub Issues](https://github.com/nothingser0/solo-project-lifecycle/issues)  

**Framework Status**: Production-ready, grade B+ (87/100), 14 modules, 90+ templates, 3 case studies

---

**Ready to ship production software solo? Start here: [docs/README.md](./docs/README.md)**
