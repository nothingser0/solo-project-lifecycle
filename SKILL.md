---
name: solo-project-lifecycle
description: Software development lifecycle framework for solo developers. 14 modules covering discovery, design, development, QA, deployment, and maintenance. Use when starting projects, creating specs (PRD/FSD/SOW), planning architecture, or managing full project lifecycle.
trigger: Starting new project, scoping client work, writing technical specs, planning development phases, managing project lifecycle from idea to production
version: 2.0.0
updated: 2026-10-02
---

# Solo Project Lifecycle Framework

Complete SDLC framework for solo developers and small teams. 14 sequential modules from product discovery through post-launch maintenance.

## When to Use This Skill

- Starting new project (client work or personal MVP)
- Creating project documentation (PRD, FSD, SOW, technical specs)
- Planning development timeline and phases
- Managing client projects with governance gates
- Building MVPs with proper architecture
- Need structured lifecycle for software projects

## What's Included

**14 Modules**: M00-M13 covering full lifecycle
- Discovery & feasibility (M00-M01)
- Planning & legal (M02-M03)
- Design & architecture (M04-M05)
- Development & testing (M06-M09)
- Deployment & handover (M10-M11)
- Maintenance & growth (M12-M13)

**80+ Templates**: Ready-to-use project documents
- PRD, FSD, SOW contracts
- API specs, database schemas
- Test plans, deployment runbooks
- Handover docs, SLA contracts

**6 Code Patterns**: Validation, auth, performance, git workflow

**3 Real Case Studies**: Production projects with metrics
- Fashion e-commerce: 21 days → Rp 52M GMV
- Real estate CRM: 28 days → +58% revenue
- SaaS inventory: 4 weeks → 200 users

## Quick Start Paths

### MVP Fast-Track (2-4 weeks)
```
M04 (design 2d) → M05 (specs 1d) → M06 (dev 10d) → M10 (deploy 1d)
```
Use: `templates/essentials/` (8 core templates)

### Full Client Project (4-8 weeks)
```
All 14 modules with gate checkpoints:
- Gate 1 (M03): Signed SOW + down payment
- Gate 2 (M09): Client UAT sign-off
- Gate 3 (M11): Final handover + BAST
```
Use: `templates/by-use-case/client-commercial/`

## Main Files

- `docs/README.md` - Complete framework guide
- `docs/quickstart.md` - MVP 2-4 week path
- `docs/modules/` - 14 detailed modules
- `templates/` - 80+ project templates
- `patterns/` - Code patterns
- `case-studies/` - Real projects
- `references/` - Deep-dive guides
- `scripts/` - Automation (bash + PowerShell)

## Usage Examples

**Create PRD:**
```bash
cp templates/03-architecture-specs/PRD_FINAL_TEMPLATE.md project/PRD.md
vim project/PRD.md
./scripts/lint-template.sh project/PRD.md
```

**Validate Gate:**
```bash
./scripts/validate-gate.sh M03  # Commercial gate
./scripts/validate-gate.sh M09  # UAT gate
./scripts/validate-gate.sh M11  # Handover gate
```

**Pick Template:**
```bash
./scripts/template-picker.sh    # Interactive selector
```

## Module Structure

### Discovery Phase
- **M00**: Product Discovery (market research, competitors)
- **M01**: Idea Feasibility (4-dimension scoring)
- **M02**: Scope Definition (MoSCoW, RBAC)
- **M03**: Legal SOW (contract, down payment) [GATE 1]

### Design Phase
- **M04**: UI/UX Design (wireframes, prototypes)
- **M05**: Architecture (PRD, FSD, database schema)

### Development Phase
- **M06**: Development (backend, frontend, API)
- **M07**: QA (tests, security audit)
- **M08**: Data Migration (ETL, seeding)
- **M09**: UAT (client testing, sign-off) [GATE 2]

### Launch Phase
- **M10**: Deployment (production go-live)
- **M11**: Handover (BAST, training, credentials) [GATE 3]
- **M12**: Warranty (bug fixes, SLA)
- **M13**: Operations (metrics, iteration)

## Tech Stack Support

Framework is stack-agnostic. Quickstart guides:
- Frontend: React, Next.js 15, Vue, Svelte
- Backend: Node.js, Laravel 11, Django, Go
- Database: PostgreSQL, MySQL, Supabase
- Deploy: Vercel, Railway, AWS, DigitalOcean

See: `references/stacks/`

## Gate System

3 mandatory checkpoints for client projects:

**Commercial Gate (M03)**
- Signed SOW contract
- Down payment received
- Single PIC designated

**Validation Gate (M09)**
- UAT completed in staging
- Client sign-off document
- All P0/P1 bugs resolved

**Handover Gate (M11)**
- 100% payment received
- BAST signed and stamped
- Code + credentials transferred

## Module Skipping Rules

**MVP Projects**: Skip M00, M03, M08, M09, M11, M12
- Minimum: M04, M05, M06, M10 (4 modules)

**Solo Projects**: Skip M03, M09, M11
- No client = no contract/UAT/handover

**API-Only**: Skip M04 (UI/UX)
- Backend services, cron jobs, CLI tools

**Small Scale**: Skip M00, M05B, M06B
- <4 weeks, <3 features

## Template Organization

```
templates/
├── essentials/           # 8 most-used (quick access)
├── by-use-case/          # Organized by scenario
│   ├── mvp-fast-track/
│   ├── client-commercial/
│   ├── technical-specs/
│   └── operations/
├── 00-pre-engagement/    # Client intake
├── 01-discovery-commercial/  # Market research, SOW
├── 02-design/            # Design specs, prototypes
├── 03-architecture-specs/    # PRD, FSD, system design
├── 04-dev-execution/     # Dev harness, checklists
├── 05-data-migration/    # Migration plans
├── 06-qa-uat/            # Test plans, security
├── 07-release-handover/  # Deployment, BAST
├── 08-maintenance-ops/   # SLA, incidents
└── 09-product-growth/    # Analytics, A/B tests
```

## Key Concepts

**Progressive Loading**: Don't load all modules at once. Load specific module only when entering that phase.

**Turn-Stopping**: Agent must stop after each module completion. No batch execution.

**Scope Protection**: Every feature addition requires formal documentation. No unpaid work.

**Client Dependencies**: Timeline tied to client's speed providing data/approvals.

**Boring Tech**: Prefer mature, stable tech over bleeding-edge.

## Automation Scripts

**Bash (Linux/Mac):**
- `validate-gate.sh` - Gate checkpoint validation
- `lint-template.sh` - Template completeness check
- `template-picker.sh` - Interactive selector

**PowerShell (Windows):**
- `validate-gate.ps1`
- `lint-template.ps1`
- `template-picker.ps1`

## Related Skills

- `spec-driven-development` - Deep spec writing
- `backend-architecture` - API design
- `tdd` - Test-driven development
- `git-master` - Version control
- `performance-optimization` - Speed optimization

## Project Scale Matrix

| Scale | Timeline | Features | Modules Required |
|-------|----------|----------|------------------|
| Small (MVP) | 1-4 weeks | 1-3 | M04, M05, M06, M10 |
| Medium | 1-3 months | Auth, DB, Payment | M01-M13 (skip M00) |
| Large | 3-6 months | Multi-system | All 14 modules |
| Enterprise | 6+ months | Compliance, SOE | All + audits |

**Warranty by scale**: Small 30d, Medium 60d, Large 90d, Enterprise 90d+SLA

## Notes

- All templates fill-in-the-blank ready
- Cross-platform scripts (bash + PowerShell)
- 100% English documentation
- MIT licensed for commercial use
- Production-tested (3 case studies)

---

**Repository**: https://github.com/nothingser0/solo-project-lifecycle  
**License**: MIT  
**Version**: 2.0.0  
**Last Updated**: 2026-10-02
