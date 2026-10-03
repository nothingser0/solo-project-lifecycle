# Repository Organization Guide

> **Purpose**: Explain folder structure, module-to-template mapping, and design decisions.

**Last Updated**: 2026-10-03

---

## Overview

This repository uses a **14-module lifecycle** (M00-M13) organized into **10 template folders** (01-09) plus specialized directories. The numbering intentionally does NOT match 1:1 to allow logical grouping.

---

## Module-to-Folder Mapping

| Modules | Template Folder | Phase |
|:--------|:----------------|:------|
| M00, M01, M02, M03 | `templates/01-discovery-commercial/` | Discovery & Legal |
| M04, M04B | `templates/02-design/` | UI/UX & Design System |
| M05, M05B | `templates/03-architecture-specs/` | Architecture & Specs |
| M06 | `templates/04-dev-execution/` | Development Harness |
| M06B, M13 | `templates/09-product-growth/` | Analytics & Iteration |
| M07 | `templates/06-qa-uat/` (SIT only) | System Integration Testing |
| M08 | `templates/05-data-migration/` | Data Migration |
| M09 | `templates/06-qa-uat/` (UAT only) | User Acceptance Testing |
| M10, M11 | `templates/07-release-handover/` | Deployment & Handover |
| M12 | `templates/08-maintenance-ops/` | Warranty & Operations |

**Why non-sequential?**
- Logical grouping: QA (M07+M09) in one folder
- Execution order: Data migration (M08) after SIT (M07)
- Commercial bundling: Discovery phases (M00-M03) together

---

## Directory Structure

```
solo-project-lifecycle/
├── docs/
│   ├── README.md                    # Master index
│   └── modules/                     # 14 lifecycle modules (M00-M13)
│       ├── 00-ideation.md
│       ├── 01-market-research.md
│       └── ...
│
├── templates/
│   ├── 01-discovery-commercial/    # M00-M03: Idea → SOW
│   ├── 02-design/                  # M04: UI/UX, design system
│   │   ├── stitch-input/           # Google Stitch prompts
│   │   ├── stitch-output/          # Generated screens
│   │   └── references/             # Design inspiration
│   ├── 03-architecture-specs/      # M05: PRD, FSD, system design
│   ├── 04-dev-execution/           # M06: Harness + stack variants
│   │   ├── nextjs/
│   │   ├── laravel/
│   │   ├── django/
│   │   ├── go/
│   │   ├── rails/                  # Coming soon
│   │   ├── nuxt/                   # Coming soon
│   │   ├── sveltekit/              # Coming soon
│   │   ├── remix/                  # Coming soon
│   │   └── astro/                  # Coming soon
│   ├── 05-data-migration/          # M08: Migration plans
│   ├── 06-qa-uat/                  # M07+M09: SIT + UAT
│   ├── 07-release-handover/        # M10+M11: Deploy + BAST
│   ├── 08-maintenance-ops/         # M12: Warranty, SLA, incident
│   ├── 09-product-growth/          # M06B+M13: Analytics, iteration
│   ├── by-use-case/                # Specialized templates
│   │   ├── examples/               # Worked examples
│   │   │   └── legal-vault/        # Complete filled example
│   │   └── technical-specs/        # FSD examples by domain
│   └── essentials/                 # Quick reference templates
│
├── references/
│   ├── checklists/                 # Quality gate checklists
│   ├── pm/                         # Project management guides
│   ├── playbooks/                  # Workflow playbooks
│   ├── solo/                       # Solo dev guides
│   ├── stacks/                     # Tech stack quickstarts
│   │   ├── nextjs-15-quickstart.md
│   │   ├── laravel-11-quickstart.md
│   │   ├── django-5-quickstart.md
│   │   ├── go-1.23-quickstart.md
│   │   └── STACK_DECISION_METRICS.md
│   └── technical/                  # Technical reference docs
│
├── patterns/                       # Design patterns library
│   ├── authentication/
│   ├── validation/
│   ├── security/
│   └── git-workflow/
│
├── schemas/                        # JSON schemas for validation
│
└── scripts/                        # CLI tools
    ├── template-picker.sh
    └── template-picker.ps1
```

---

## Design Decisions

### Why Split References?

References are intentionally fragmented by audience and usage frequency:

| Location | Audience | When to Use |
|:---------|:---------|:------------|
| `templates/02-design/references/` | Designers | During Module 04 (design phase) |
| `references/checklists/` | All roles | Quality gates across all modules |
| `references/pm/` | PMs, clients | Discovery, planning, commercial |
| `references/playbooks/` | Developers | Development workflows |
| `references/solo/` | Solo devs | Self-sufficiency guides |
| `references/stacks/` | Architects | Stack selection (Module 05) |
| `references/technical/` | Developers | Implementation details |

**Benefit**: Context-specific references reduce cognitive load (designer doesn't see API patterns).

### Why QA Before Data Migration?

The folder order `05-data-migration` → `06-qa-uat` seems reversed, but execution order is:

1. **M07 (SIT)** - Test features in clean environment
2. **M08 (Migration)** - Import production data
3. **M09 (UAT)** - Test with real data

Folder numbering reflects *grouping logic* (data operations vs testing) not execution sequence.

### Why No templates/10-monitoring/?

Monitoring/observability are placed under `09-product-growth/` because:
- M06B (Instrumentation) is part of initial development
- M13 (Continuous Iteration) uses analytics to drive improvements
- Operational monitoring (M12) lives in `08-maintenance-ops/`

Creating a separate folder would fragment related analytics work.

### Why Empty Folders Removed?

- `templates/00-pre-engagement/` - No distinct templates (merged into M00-M01)
- `templates/checklists/` - Duplicated `references/checklists/`, caused confusion

---

## Navigation Tips

### Finding Templates

**By module number**: Check mapping table above  
**By phase**: Use folder numbering (01-09)  
**By stack**: Look in `templates/04-dev-execution/{stack}/`  
**By use case**: Browse `templates/by-use-case/`

### Common Paths

```bash
# Starting a project
docs/README.md                                  # Read overview
templates/01-discovery-commercial/              # Generate SOW

# Design phase
templates/02-design/DESIGN_SPEC_TEMPLATE.md    # Main design doc
templates/02-design/stitch-input/              # Stitch prompts

# Architecture
templates/03-architecture-specs/PRD_TEMPLATE.md
references/stacks/STACK_DECISION_METRICS.md    # Choose stack

# Development
templates/04-dev-execution/nextjs/AGENTS.md    # If Next.js chosen
templates/04-dev-execution/TODO_TEMPLATE.md    # Task breakdown

# QA & Launch
templates/06-qa-uat/SIT_WORKBOOK_TEMPLATE.md
templates/07-release-handover/DEPLOYMENT_PROTOCOL_TEMPLATE.md
```

---

## Future Reorganization (Breaking Change)

If this skill is ever restructured (v2.0), consider:

1. **Align folder numbers to modules** (00-13 instead of 01-09)
2. **Consolidate references** into single hierarchy
3. **Create templates/10-monitoring/** for observability
4. **Separate commercial from technical** (split 01-discovery-commercial/)

**Why not now?** Existing users rely on current paths. Breaking changes require major version bump + migration guide.

---

## Contributing

When adding templates:
- Place in correct module folder (use mapping table)
- Update `docs/README.md` master index
- Add to appropriate `references/` category if reusable
- Create worked example in `by-use-case/examples/` for complex templates

---

**Questions?** Open an issue or refer to `docs/README.md` for the complete module breakdown.
