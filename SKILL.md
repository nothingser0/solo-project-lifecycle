---
name: solo-project-lifecycle
description: Complete software development lifecycle framework for solo developers. Use when starting new projects, scoping client work, creating PRDs/FSD, planning architecture, or managing full project lifecycle from discovery through deployment and maintenance.
trigger: Starting new project, scoping client work, creating technical specs, planning development phases, managing project lifecycle
version: 2.0.0
author: nothingser0
updated: 2026-10-02
---

# Solo Project Lifecycle Framework

End-to-end software development lifecycle framework for solo developers and small teams. Covers 14 modules from product discovery through production deployment and post-launch maintenance.

## When to Use This Skill

- Starting a new project (client work or personal MVP)
- Creating project documentation (PRD, FSD, SOW, technical specs)
- Planning development phases and timelines
- Managing client projects with proper governance
- Need structured approach for software project lifecycle
- Building MVPs with proper architecture planning

## What This Skill Provides

**14 Sequential Modules:**
- M00-M01: Discovery & feasibility
- M02-M03: Planning & legal
- M04-M05: Design & architecture
- M06-M08: Development & migration
- M09-M11: Testing, UAT & handover
- M12-M13: Maintenance & growth

**80+ Templates:**
- PRD, FSD, SOW contracts
- API specs, database schemas
- Test plans, deployment protocols
- Handover documents, SLA contracts

**Code Patterns:**
- Validation (Zod schemas)
- Authentication & security
- Performance optimization
- Git workflow

**3 Real Case Studies:**
- Fashion e-commerce (21 days, Rp 52M GMV)
- Real estate CRM (28 days, +58% revenue)
- SaaS inventory (4 weeks, 200 users)

## Quick Start

### For MVP Projects (2-4 weeks)
```
M01 (4h) → M04 (2-3d) → M05 (1-2d) → M06 (10-20d) → M07 (1d) → M10 (1d)
```

Use templates from: `templates/essentials/`

### For Client Projects (4-8 weeks)
Follow all 14 modules with gate checkpoints:
- Gate 1 (M03): Signed SOW + down payment
- Gate 2 (M09): UAT sign-off
- Gate 3 (M11): Final handover + BAST

Use templates from: `templates/by-use-case/client-commercial/`

## Main Files

- `docs/README.md` - Complete framework overview
- `docs/quickstart.md` - MVP fast-track guide
- `docs/modules/` - 14 detailed module guides
- `templates/` - All project templates
- `patterns/` - Code patterns library
- `case-studies/` - Real project examples

## Example Usage

**Creating PRD:**
```bash
cp templates/03-architecture-specs/PRD_FINAL_TEMPLATE.md project/PRD.md
# Fill in requirements
./scripts/lint-template.sh project/PRD.md
```

**Gate Validation:**
```bash
./scripts/validate-gate.sh M03  # Check commercial gate
./scripts/validate-gate.sh M09  # Check UAT gate
```

**Template Selection:**
```bash
./scripts/template-picker.sh    # Interactive picker
```

## Tech Stack Support

Stack-agnostic framework. Quickstart guides for:
- Frontend: React, Next.js 15, Vue, Svelte
- Backend: Node.js, Laravel 11, Django, Go
- Database: PostgreSQL, MySQL, Supabase
- Deploy: Vercel, Railway, AWS, DigitalOcean

See `references/stacks/` for detailed setup.

## Key Concepts

**Gate System**: 3 checkpoints ensure project governance
- Commercial gate: Legal protection before work starts
- Validation gate: Client approval before deployment
- Handover gate: Final payment + documentation transfer

**Module Skipping**: Not all modules required for every project
- MVPs: Skip M00, M03, M08, M09, M11, M12 (6-module path)
- Solo projects: Skip M03 (SOW), M09 (UAT), M11 (handover)
- Maintenance only: Start at M12

**Template Hierarchy**:
- `essentials/` - 8 most-used templates
- `by-use-case/` - Organized by project type
- `00-09/` - Organized by module phase

## Related Skills

- `spec-driven-development` - Deep spec writing
- `backend-architecture` - API design patterns
- `tdd` - Test-driven development
- `git-master` - Version control workflows
- `performance-optimization` - Speed optimization

## Notes

- Framework is production-tested (3 case studies included)
- All templates are fill-in-the-blank ready
- Automation scripts for validation included
- Cross-platform support (Bash + PowerShell)
- 100% English documentation
- MIT licensed for commercial use

---

**Repository**: https://github.com/nothingser0/solo-project-lifecycle
**License**: MIT
**Last Updated**: 2026-10-02
