# Template Index

Quick reference for all 90+ templates organized by use case.

---

## Quick Navigation

**New to framework?** Start here:
- **[Essentials (Top 20)](templates/essentials/)** - Most-used templates, 30-second discovery
- **[MVP Fast-Track](templates/by-use-case/mvp-fast-track/)** - Ship in 2-4 weeks (5 templates, 2 hours)
- **[Client Commercial](templates/by-use-case/client-commercial/)** - Fixed-price contracts + legal protection (5 templates, 4 hours)
- **[Technical Specs](templates/by-use-case/technical-specs/)** - Team documentation (PRD, FSD, API contracts) (7 templates, 12-18 hours)
- **[Operations](templates/by-use-case/operations/)** - Production deployment + incident response (5 templates, 3 hours)

**Alternative navigation**: Browse [by project phase](#by-project-phase) below (original structure)

---

## By Project Phase

### Phase 1: Discovery & Commercial (M00-M03)
**Use when**: Starting new project, defining scope, securing contract

| Template | Output Path | Use Case | Time to Fill |
|----------|-------------|----------|--------------|
| IDEA_BRIEF | `docs/pm/IDEA_BRIEF.md` | Feasibility 4-dimension scoring | 20 min |
| SCOPE_STATEMENT | `docs/pm/SCOPE_STATEMENT.md` | MoSCoW prioritization, Out-of-Scope boundary | 1 hour |
| SOW_CONTRACT | `docs/pm/SOW_CONTRACT.md` | Fixed-price contract, payment terms, Single PIC | 2 hours |
| MARKET_RESEARCH | `docs/pm/MARKET_RESEARCH.md` | TAM/SAM/SOM analysis, competitor audit | 4 hours |
| PRODUCT_STRATEGY | `docs/pm/PRODUCT_STRATEGY.md` | Vision, North Star Metric, Value Proposition | 2 hours |
| OKR | `docs/pm/OKR.md` | Quarterly objectives & key results | 1 hour |
| RISK_REGISTER | `docs/pm/RISK_REGISTER.md` | Risk assessment matrix, mitigation plans | 1 hour |
| BACKLOG | `docs/pm/BACKLOG.md` | User stories, RICE prioritization | 2 hours |

**Fast-track shortcut**: Use `PROJECT_LITE_TEMPLATE` (combines Idea + Scope + Specs in 1 file)

---

### Phase 2: Design (M04, M04B)
**Use when**: Designing UI/UX, establishing design system

| Template | Output Path | Use Case | Time to Fill |
|----------|-------------|----------|--------------|
| DESIGN.md | `DESIGN.md` (root) | Design tokens (colors, typography, spacing) | 30 min |
| DESIGN_SPEC | `docs/specs/DESIGN_SPEC.md` | Page inventory, responsive behavior, states | 2 hours |
| DESIGN_SYSTEM_AUDIT | `docs/design/DESIGN_SYSTEM_AUDIT.md` | Visual inconsistency audit (color/typography sprawl) | 1 hour |
| DESIGN_TOKENS_SPEC | `tokens/design-tokens.json` | Primitive + semantic tokens, platform outputs | 1 hour |
| COMPONENT_API_SPEC | `docs/design/COMPONENT_API_SPEC.md` | Props, variants, accessibility per component | 30 min/component |
| LOGO_DESIGN_BRIEF | `docs/design/LOGO_BRIEF.md` | Brand identity, logo requirements | 30 min |
| AB_TEST_HYPOTHESIS | `docs/analytics/AB_TEST_HYPOTHESIS.md` | Experiment design, success criteria | 20 min |

---

### Phase 3: Architecture & Specs (M05, M05B)
**Use when**: Writing technical specs, designing system architecture

| Template | Output Path | Use Case | Time to Fill |
|----------|-------------|----------|--------------|
| PRD | `docs/specs/PRD.md` | Product Requirements Document (formal) | 4 hours |
| FSD | `docs/specs/FSD.md` | Functional Spec (tech stack, DB schema, API contracts) | 6 hours |
| SYSTEM_DESIGN_DOC | `docs/specs/SYSTEM_DESIGN_DOC.md` | Load balancing, caching, high availability | 3 hours |
| CAPACITY_PLANNING | `docs/specs/CAPACITY_PLANNING.md` | Traffic projection, resource sizing | 2 hours |
| DISASTER_RECOVERY_PLAN | `docs/specs/DISASTER_RECOVERY_PLAN.md` | RPO/RTO, failover procedures | 2 hours |
| PROJECT_LITE | `PROJECT_LITE.md` (root) | **MVP all-in-one** (Idea+Scope+Arch) | 1 hour |

---

### Phase 4: Development Harness (M06)
**Use when**: Starting development, setting up AI agent workspace

| Template | Output Path | Use Case | Time to Fill |
|----------|-------------|----------|--------------|
| AGENTS.md | `AGENTS.md` (root) | AI agent instructions (MUST overwrite framework default) | 15 min |
| CONTEXT.md | `CONTEXT.md` (root) | Business context, Out-of-Scope reminders | 10 min |
| ARCHITECTURE.md | `ARCHITECTURE.md` (root) | Tech architecture summary for AI | 15 min |
| CONVENTIONS.md | `CONVENTIONS.md` (root) | Code style guide (kebab-case, no barrel exports) | 10 min |
| TODO.md | `TODO.md` (root) | Atomic task queue for sequential execution | 20 min |
| .env.example | `.env.example` (root) | Environment variable template | 10 min |
| RUNBOOK_LOCAL | `docs/RUNBOOK_LOCAL.md` | Local setup guide | 30 min |
| VERIFY_LOCAL | `docs/VERIFY_LOCAL.md` | Smoke test verification checklist | 20 min |

**Batch operation**: Use `template-picker.sh` option 10 to copy all 7 harness files at once

---

### Phase 5: QA & UAT (M07-M09)
**Use when**: Testing system, preparing for UAT

| Template | Output Path | Use Case | Time to Fill |
|----------|-------------|----------|--------------|
| SIT_WORKBOOK | `docs/qa/SIT_WORKBOOK.md` | System Integration Testing (third-party APIs) | 2 hours |
| SECURITY_AUDIT | `docs/qa/SECURITY_AUDIT.md` | OWASP Top 10, UU PDP compliance checklist | 3 hours |
| UAT_WORKBOOK | `docs/qa/UAT_WORKBOOK.md` | User Acceptance Testing guide for client | 2 hours |
| UAT_SIGNOFF | `docs/qa/UAT_SIGNOFF.md` | Formal sign-off document (Severity 1/2/3 triaging) | 30 min |

---

### Phase 6: Deployment & Handover (M10-M11)
**Use when**: Deploying to production, handing over to client

| Template | Output Path | Use Case | Time to Fill |
|----------|-------------|----------|--------------|
| DEPLOYMENT_PROTOCOL | `docs/DEPLOYMENT_PROTOCOL.md` | Go-live checklist (DNS, SSL, No Friday Deploy) | 1 hour |
| ROLLBACK_PLAN | `docs/ROLLBACK_PLAN.md` | 15-minute rollback procedure | 30 min |
| BAST | `contracts/BAST.md` | Berita Acara Serah Terima (legal handover) | 30 min |
| HANDOVER_PROTOCOL | `docs/HANDOVER_PROTOCOL.md` | Repo & credentials transfer | 20 min |
| USER_MANUAL | `docs/USER_MANUAL.md` | End-user documentation | 3 hours |

---

### Phase 7: Maintenance & Growth (M12-M13)
**Use when**: Post-launch support, growth experiments

| Template | Output Path | Use Case | Time to Fill |
|----------|-------------|----------|--------------|
| WARRANTY_POLICY | `docs/WARRANTY_POLICY.md` | Bug fix boundaries, SLA terms | 30 min |
| SLA_RETAINER_CONTRACT | `contracts/SLA_RETAINER.md` | Monthly retainer agreement | 1 hour |
| INCIDENT_RESPONSE | `docs/INCIDENT_RESPONSE.md` | RCA, post-mortem template | 1 hour |
| EVENT_TAXONOMY | `docs/analytics/EVENT_TAXONOMY.md` | Analytics event spec (verb_noun convention) | 2 hours |
| ANALYTICS_IMPLEMENTATION_PLAN | `docs/analytics/ANALYTICS_PLAN.md` | SDK integration, GDPR consent | 1 hour |
| DASHBOARD_SPEC | `docs/analytics/DASHBOARD_SPEC.md` | North Star Metric dashboard design | 1 hour |
| METRICS_BASELINE_REPORT | `docs/analytics/METRICS_BASELINE.md` | 30-day baseline after launch | 1 hour |
| GROWTH_EXPERIMENTS_BACKLOG | `docs/pm/GROWTH_BACKLOG.md` | RICE-scored experiments | 2 hours |
| AB_TEST_REPORT | `docs/analytics/AB_TEST_REPORT.md` | Experiment results, statistical significance | 30 min |

---

## By Use Case

### Quick Start MVP (2-4 weeks)
**Minimum viable templates**:
1. `PROJECT_LITE_TEMPLATE.md` → `PROJECT.md` (1 hour)
2. `DESIGN_MD_TEMPLATE.md` → `DESIGN.md` (30 min)
3. `DEPLOYMENT_PROTOCOL_TEMPLATE.md` → `DEPLOY.md` (20 min)

**Total time**: 1.5 hours documentation  
**Guide**: See `QUICK_START_MVP.md`

---

### Standard Client Project (1-3 months)
**Essential templates** (10-12 files):
1. IDEA_BRIEF (feasibility)
2. SCOPE_STATEMENT (MoSCoW)
3. SOW_CONTRACT (payment terms)
4. DESIGN.md (tokens)
5. DESIGN_SPEC (pages)
6. PRD (requirements)
7. FSD (tech specs)
8. 7 Harness files (AGENTS, CONTEXT, etc.)
9. SIT_WORKBOOK (testing)
10. UAT_SIGNOFF (client approval)
11. DEPLOYMENT_PROTOCOL (go-live)
12. BAST (handover)

**Total time**: 20-25 hours documentation  
**ROI**: Prevents 40-60 hours rework from scope creep

---

### Enterprise Project (6+ months)
**Full stack** (25-30 files):
- All Standard templates +
- MARKET_RESEARCH
- PRODUCT_STRATEGY
- RISK_REGISTER
- SYSTEM_DESIGN_DOC
- CAPACITY_PLANNING
- DISASTER_RECOVERY_PLAN
- SECURITY_AUDIT (formal pentest)
- WARRANTY_POLICY
- SLA_RETAINER_CONTRACT
- Full analytics suite (5 templates)

**Total time**: 60-80 hours documentation  
**Requirement**: Legal review for Indonesia compliance

---

## By Template Size

### Quick (< 30 min to fill)
- CONTEXT.md
- CONVENTIONS.md
- .env.example
- TODO.md (initial seed)
- LOGO_DESIGN_BRIEF
- AB_TEST_HYPOTHESIS
- HANDOVER_PROTOCOL
- BAST
- UAT_SIGNOFF
- DEPLOYMENT_PROTOCOL
- ROLLBACK_PLAN
- AB_TEST_REPORT

### Medium (30 min - 2 hours)
- IDEA_BRIEF
- SCOPE_STATEMENT
- OKR
- RISK_REGISTER
- DESIGN.md
- DESIGN_SPEC
- DESIGN_SYSTEM_AUDIT
- DESIGN_TOKENS_SPEC
- BACKLOG
- SIT_WORKBOOK
- UAT_WORKBOOK
- CAPACITY_PLANNING
- DISASTER_RECOVERY_PLAN
- SYSTEM_DESIGN_DOC
- EVENT_TAXONOMY
- ANALYTICS_IMPLEMENTATION_PLAN
- DASHBOARD_SPEC
- METRICS_BASELINE_REPORT
- GROWTH_EXPERIMENTS_BACKLOG

### Large (> 2 hours)
- SOW_CONTRACT
- MARKET_RESEARCH
- PRODUCT_STRATEGY
- PRD
- FSD
- USER_MANUAL
- SECURITY_AUDIT

---

## Tools

### Template Discovery
```bash
# Interactive picker (recommended)
./scripts/template-picker.sh

# List all templates
find templates -name "*TEMPLATE.md" | sort

# Search by keyword
grep -r "keyword" templates/ --include="*.md"
```

### Template Validation
```bash
# Validate filled template
./scripts/lint-template.sh docs/specs/PRD.md

# Check gate requirements
./scripts/validate-gate.sh M03
```

---

## Template Maintenance

**Last Updated**: 2026-10-02  
**Total Templates**: 90+  
**Coverage**: 13 modules, 9 phases, 4 project scales

**Contribute**:
- Missing template? Open issue with use case
- Found outdated pricing/tool? Submit PR
- Stack-specific variant needed? Request in discussions

---

**Quick Links**:
- [SKILL.md](SKILL.md) - Framework overview
- [QUICK_START_MVP.md](QUICK_START_MVP.md) - Fast-track guide
- [template-picker.sh](scripts/template-picker.sh) - Interactive CLI
