# Solo Project Lifecycle Framework

> Complete framework for solo developers shipping production software from idea to deployment.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](./LICENSE)
[![Modules](https://img.shields.io/badge/modules-14-green.svg)](./docs/modules/)

---

## Quick Start

**14 Sequential Modules**: Discovery → Design → Development → QA → Deployment → Maintenance

| Module | Name | Duration | Skip for MVP? |
|--------|------|----------|---------------|
| M00 | Product Discovery | 2-4 days | ❌ Recommended |
| M01 | Idea Feasibility | 4 hours | ✅ Yes |
| M02 | Scope Definition | 1-2 days | ❌ No |
| M03 | Legal SOW | 4 hours | ✅ Yes (solo) |
| M04 | UI/UX Design | 2-3 days | ❌ No |
| M05 | Architecture & Specs | 1-2 days | ❌ No |
| M06 | Development | 10-20 days | ❌ No |
| M07 | Quality Assurance | 2-3 days | ⚠️ Partial |
| M08 | Data Migration | 1 day | ✅ Yes (new projects) |
| M09 | UAT & Sign-off | 2-3 days | ✅ Yes (solo) |
| M10 | Deployment | 1 day | ❌ No |
| M11 | Handover | 4 hours | ✅ Yes (solo) |
| M12 | Warranty & SLA | Ongoing | ⚠️ Optional |
| M13 | Operations | Ongoing | ⚠️ Post-launch |

**MVP Fast-Track** (2-4 weeks): M01 → M04 → M05 → M06 → M07 (smoke) → M10

---

## What's Inside?

```
solo-project-lifecycle/
├── docs/
│   ├── README.md          # Framework guide
│   ├── modules/           # 14 detailed modules
│   └── quickstart.md      # MVP guide
├── templates/             # 90+ templates (PRD, FSD, SOW, etc.)
├── patterns/              # Code patterns (validation, security)
├── case-studies/          # 3 real projects
├── schemas/               # JSON validation
├── scripts/               # Automation tools
└── references/            # Deep-dive guides
```

---

## Getting Started

### 1. Read the Framework
Start here: **[docs/README.md](./docs/README.md)** - Complete framework overview

Quick guide: **[docs/quickstart.md](./docs/quickstart.md)** - 2-4 week MVP track

### 2. Choose Your Templates
Browse: **[templates/](./templates/)** - 90+ templates organized by phase

Essentials: **[templates/essentials/](./templates/essentials/)** - 8 most-used templates

### 3. See Real Examples
- [Fashion E-commerce](./case-studies/02-ecommerce-fashion-mvp.md) - 21 days → Rp 52M GMV
- [Real Estate CRM](./case-studies/03-crm-real-estate-internal.md) - 28 days → +58% revenue
- [SaaS Inventory](./case-studies/01-mvp-saas-inventory.md) - 4 weeks → 200 users

---

## Tech Stack Support

**Frontend**: React, Next.js, Vue, Svelte  
**Backend**: Node.js, Laravel, Django, Go  
**Database**: PostgreSQL, MySQL, Supabase  
**Deploy**: Vercel, Railway, AWS, DigitalOcean

Stack guides: [references/stacks/](./references/stacks/)

---

## Features

✅ **14 sequential modules** (full lifecycle coverage)  
✅ **90+ templates** (PRD, FSD, SOW, API specs, test plans)  
✅ **3 case studies** (real projects with metrics)  
✅ **Code patterns** (validation, security, performance)  
✅ **Automation scripts** (validation, template picker)  
✅ **Stack-agnostic** (works with any tech stack)

---

## Scripts

```bash
# Validate gate checkpoints
./scripts/validate-gate.sh

# Check template completeness
./scripts/lint-template.sh templates/03-architecture-specs/PRD_TEMPLATE.md

# Interactive template picker
./scripts/template-picker.sh
```

PowerShell versions available: `*.ps1`

---

## License

MIT License - see [LICENSE](./LICENSE)

Commercial use allowed for client projects, products, consulting.

---

## Support

**Docs**: [docs/README.md](./docs/README.md)  
**Issues**: [GitHub Issues](https://github.com/nothingser0/solo-project-lifecycle/issues)

**Status**: Production-ready, actively maintained

---

**Ready to ship?** Start here: [docs/README.md](./docs/README.md)
