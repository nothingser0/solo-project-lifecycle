# Solo Project Lifecycle

A comprehensive, production-tested Software Development Life Cycle (SDLC) framework engineered for solo developers, technical founders, and lean engineering teams. It standardizes end-to-end execution from product discovery and commercial scoping to architecture, development, quality assurance, deployment, and post-launch maintenance.

The repository includes a taxonomy of 1,000 systems across 4 scale tiers, 250 industry software archetypes, 14 gate-controlled lifecycle modules, and 150+ operational templates and architectural patterns.

---

## Architecture & Structure

```
solo-project-lifecycle/
├── SKILL.md                 # Agent entry point and execution index
├── docs/
│   ├── modules/             # 14 lifecycle modules (M00 through M13)
│   ├── pm/                  # Product management runtime guides and trackers
│   └── quickstart.md        # Rapid onboarding guide
├── templates/
│   ├── 01-discovery-commercial/   # Market research, briefs, SOWs, and charters
│   ├── 02-design/                 # Design prompts, sitemaps, component specs
│   ├── 03-architecture-specs/     # PRD, FSD, and lite specification templates
│   ├── 04-dev-execution/          # Agent harnesses, conventions, stack baselines
│   ├── 05-data-migration/         # Migration plans and data reconciliation
│   ├── 06-qa-uat/                 # Test plans, test cases, and UAT signoff forms
│   └── 07-release-handover/       # Handover protocols, BAST, credentials vault
├── references/
│   ├── taxonomy/            # 1,000 system catalog and 250 software archetypes
│   ├── stacks/              # Framework matrix and stack quickstarts (Next.js, Laravel, Go, Django)
│   └── playbooks/           # Scale workflows (Small, Medium, Large, Enterprise)
├── patterns/                # Battle-tested implementation patterns (Auth, DB, Payments, PDP, Offline)
├── scripts/
│   ├── scaffold/            # Project init and template picker scripts (Bash/PowerShell)
│   ├── gates/               # Lifecycle gate validation automation
│   └── verify/              # Link, frontmatter, template, and stack version verifiers
└── evals/                   # Evaluation scenarios verifying SDLC agent compliance
```

---

## 14 Lifecycle Modules

| Phase | Module | Scope & Core Artifacts |
|:---|:---|:---|
| **Discovery** | `M00` Product Discovery | Market research, competitive analysis, value proposition |
| | `M01` Idea Feasibility | Technical feasibility, unit economics, risk matrices |
| | `M02` Discovery & Scoping | Requirements elicitation, scope baseline, user journeys |
| **Commercial** | `M03` Legal, SOW & Charter | SOW (client work), Solo SaaS Charter, BAST milestones |
| **Design** | `M04` UI/UX Prototyping | Wireframes, component requirements, token systems |
| **Specs** | `M05` Architecture & Specs | PRD, Technical FSD, entity models, API contracts |
| **Build** | `M06` Development Execution | Agent harnesses (`AGENTS.md`, `TODO.md`), TDD, atomic commits |
| | `M07` QA & System Integration | Integration testing, load tests, security baselines |
| | `M08` Data Migration & Seeding | Schema migrations, zero-downtime cutover, seed scripts |
| **Delivery** | `M09` UAT & Client Sign-Off | Acceptance testing, defect triage, sign-off protocol |
| | `M10` Production Deployment | CI/CD pipelines, release checklist, rollback procedures |
| | `M11` Handover & BAST | Official acceptance (BAST), documentation, secret rotation |
| **Operations**| `M12` Warranty & Retainer | SLA definition, incident response, retainer terms |
| | `M13` Operations & Iteration | Observability, metric tracking, feature iteration backlog |

---

## Project Sizing & Workflow Modes

The framework adapts governance overhead across 4 delivery scales:

1. **Small / MVP (1-2 weeks)**: Fast-track using consolidated templates (`M00_LITE`, `PROJECT_LITE_TEMPLATE`, unified `TODO.md`). Direct transition from spec to execution.
2. **Medium / Production Core (3-6 weeks)**: Standard gate controls with separated PRD, FSD, structured QA checkpoints, and milestone validations.
3. **Large / Multi-Service (7-12 weeks)**: Rigorous data migration plans, formal UAT cycles, reconciliation protocols, and security audits.
4. **Enterprise / Mission-Critical (12+ weeks)**: Full enterprise governance including regulatory compliance checks (e.g., UU PDP, GDPR), formal SLA agreements, and audited handover ceremonies.

Supported engagement models:
- **Solo SaaS**: Self-directed commercial track (waives client SOW/BAST, enforces Solo SaaS Charter and growth metrics).
- **Client / Bespoke Delivery**: Agency and freelance workflow with contractual milestones, change request tracking, and formal sign-offs.
- **Internal / Enterprise**: Departmental tooling and intranet systems with audit trails and staging cutovers.

---

## Automation Scripts

The `scripts/` directory provides cross-platform Bash and PowerShell utilities:

- **Project Scaffolding**:
  ```bash
  # Initialize a structured project workspace
  ./scripts/scaffold/init-project.sh --name "my-app" --scale "medium" --track "saas"
  ```
- **Gate Validation**:
  ```bash
  # Validate module readiness and required artifact presence
  ./scripts/gates/validate-gate.sh --module "M05"
  ```
- **Verification Suite**:
  ```bash
  # Verify template links, stack versions, and metadata integrity
  ./scripts/verify/verify-all.sh
  ```

---

## Getting Started

1. Consult `docs/quickstart.md` for a 10-minute setup walkthrough.
2. Choose a reference stack from `references/stacks/` (Next.js, Laravel, Go, Django, Rails, SvelteKit, FastAPI).
3. Review `references/taxonomy/SYSTEM_ARCHETYPES_250.md` to map standard features for your target system category.
4. Scaffold project governance and harness files using the `scripts/scaffold/` utilities.

---

## License

MIT License. See [LICENSE](LICENSE) for details.
