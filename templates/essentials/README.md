# Essential Templates (Top 20)

**Purpose**: Most frequently used templates across all project types

**Discovery time**: 30 seconds (vs 5 minutes searching by-phase)

---

## Quick Start (Pick Your Path)

### Path A: Solo MVP (Internal Project)
**Time**: 2 hours | **Templates**: 5

1. `PROJECT_LITE.md` - All-in-one spec (1 hour)
2. `PROJECT_STATE.md` - Lifecycle state & cross-session handoff (15 min)
3. `DESIGN.md` - Design tokens (30 min)
4. `REQUIREMENT_MATRIX.md` - Traceability from user need to verification (30 min)
5. `VERIFICATION_PLAN.md` - Verification plan & gate protocols (20 min)
6. `AGENTS.md` - AI agent instructions (15 min)
7. `TODO.md` - Task queue (20 min)
8. `RUNBOOK_LOCAL.md` - Setup guide (20 min)

**Skip**: SOW, BAST, warranty (no client)

---

### Path B: Client Project (Fixed-Price)
**Time**: 6 hours | **Templates**: 10

**Pre-contract**:
1. `SCOPE_STATEMENT.md` - Scope boundary (1 hour)
2. `SOW_CONTRACT.md` - Contract (2 hours)

**Development**:
3. `PRD.md` - Product spec (4 hours)
4. `FSD.md` - Technical spec (6 hours)
5. `DESIGN.md` - Design tokens (30 min)
6. `DESIGN_SPEC.md` - Page inventory (2 hours)

**Post-delivery**:
7. `UAT_WORKBOOK.md` - User acceptance (2 hours)
8. `BAST.md` - Legal handover (30 min)
9. `WARRANTY_POLICY.md` - Support terms (30 min)
10. `DEPLOYMENT_PROTOCOL.md` - Go-live checklist (1 hour)

**Total**: 19.5 hours documentation

---

### Path C: Team Project (3+ Developers)
**Time**: 12 hours | **Templates**: 12

1. `PRD.md` - Product spec (4 hours)
2. `FSD.md` - Technical spec (6 hours)
3. `DESIGN_SPEC.md` - Design spec (2 hours)
4. `AGENTS.md` - AI instructions (15 min)
5. `CONTEXT.md` - Business context (10 min)
6. `ARCHITECTURE.md` - Tech summary (15 min)
7. `CONVENTIONS.md` - Code style (10 min)
8. `TODO.md` - Task queue (20 min)
9. `RUNBOOK_LOCAL.md` - Setup guide (30 min)
10. `UAT_WORKBOOK.md` - Testing guide (2 hours)
11. `DEPLOYMENT_PROTOCOL.md` - Deploy checklist (1 hour)
12. `SLA_RETAINER.md` - Support contract (1 hour)

---

## Top 20 Templates (Alphabetical)

### 1. AGENTS.md
**Path**: `../04-dev-execution/AGENTS_TEMPLATE.md`  
**Purpose**: AI agent instructions (coding standards, context)  
**Time**: 15 minutes  
**Must-use**: Every project with AI assistance  
**Output**: `docs/harness-root/AGENTS.md` (staged, deployed to root after scaffold)

```bash
# Stage during M01-M05 (before scaffold)
mkdir -p docs/harness-root
cp templates/04-dev-execution/AGENTS_TEMPLATE.md docs/harness-root/AGENTS.md

# Deploy after scaffold (M06)
cp docs/harness-root/AGENTS.md ./AGENTS.md
```

---

### 2. ARCHITECTURE.md
**Path**: `../04-dev-execution/ARCHITECTURE_TEMPLATE.md`  
**Purpose**: Tech architecture summary for AI/new developers  
**Time**: 15 minutes  
**Output**: `docs/harness-root/ARCHITECTURE.md` (staged, deployed to root after scaffold)

```bash
mkdir -p docs/harness-root
cp templates/04-dev-execution/ARCHITECTURE_TEMPLATE.md docs/harness-root/ARCHITECTURE.md
```

---

### 3. BAST.md
**Path**: `../07-release-handover/BAST_TEMPLATE.md`  
**Purpose**: Official Handover Report / BAST (legal handover)  
**Time**: 30 minutes  
**Must-use**: Client projects (trigger final payment)  
**Output**: `contracts/BAST.md`

```bash
mkdir -p contracts
cp templates/07-release-handover/BAST_TEMPLATE.md contracts/BAST.md
```

---

### 4. CONTEXT.md
**Path**: `../04-dev-execution/CONTEXT_TEMPLATE.md`  
**Purpose**: Business context, user roles, out-of-scope boundaries  
**Time**: 10 minutes  
**Output**: `docs/harness-root/CONTEXT.md` (staged, deployed to root after scaffold)

```bash
mkdir -p docs/harness-root
cp templates/04-dev-execution/CONTEXT_TEMPLATE.md docs/harness-root/CONTEXT.md
```

---

### 5. CONVENTIONS.md
**Path**: `../04-dev-execution/CONVENTIONS_TEMPLATE.md`  
**Purpose**: Code style rules (naming, formatting, patterns)  
**Time**: 10 minutes  
**Output**: `docs/harness-root/CONVENTIONS.md` (staged, deployed to root after scaffold)

```bash
mkdir -p docs/harness-root
cp templates/04-dev-execution/CONVENTIONS_TEMPLATE.md docs/harness-root/CONVENTIONS.md
```

---

### 6. DEPLOYMENT_PROTOCOL.md
**Path**: `../07-release-handover/DEPLOYMENT_PROTOCOL_TEMPLATE.md`  
**Purpose**: Go-live checklist (DNS, SSL, no Friday deploy)  
**Time**: 1 hour  
**Must-use**: Before production launch  
**Output**: `docs/DEPLOYMENT_PROTOCOL.md`

```bash
mkdir -p docs
cp templates/07-release-handover/DEPLOYMENT_PROTOCOL_TEMPLATE.md docs/DEPLOYMENT_PROTOCOL.md
```

---

### 7. DESIGN.md
**Path**: `../02-design/DESIGN_MD_TEMPLATE.md`  
**Purpose**: Design tokens for AI (colors, fonts, spacing)  
**Time**: 30 minutes  
**Must-use**: Every project  
**Output**: `docs/harness-root/DESIGN.md` (staged, deployed to root after scaffold)

```bash
mkdir -p docs/harness-root
cp templates/02-design/DESIGN_MD_TEMPLATE.md docs/harness-root/DESIGN.md
```

---

### 8. DESIGN_SPEC.md
**Path**: `../02-design/DESIGN_SPEC_TEMPLATE.md`  
**Purpose**: Page inventory, responsive behavior, states  
**Time**: 2 hours  
**Output**: `docs/specs/DESIGN_SPEC.md`

```bash
mkdir -p docs/specs
cp templates/02-design/DESIGN_SPEC_TEMPLATE.md docs/specs/DESIGN_SPEC.md
```

---

### 9. FSD.md
**Path**: `../03-architecture-specs/FSD_TECHNICAL_TEMPLATE.md`  
**Purpose**: Functional Spec (tech stack, DB schema, API)  
**Time**: 6 hours  
**Must-use**: Team projects (2+ developers)  
**Output**: `docs/specs/FSD.md`

```bash
cp templates/03-architecture-specs/FSD_TECHNICAL_TEMPLATE.md docs/specs/FSD.md
```

---

### 10. PRD.md
**Path**: `../03-architecture-specs/PRD_FINAL_TEMPLATE.md`  
**Purpose**: Product Requirements Document (formal)  
**Time**: 4 hours  
**Must-use**: Team projects or client work  
**Output**: `docs/specs/PRD.md`

```bash
cp templates/03-architecture-specs/PRD_FINAL_TEMPLATE.md docs/specs/PRD.md
```

---

### 11. PROJECT_LITE.md
**Path**: `../03-architecture-specs/PROJECT_LITE_TEMPLATE.md`  
**Purpose**: All-in-one spec for MVPs (replaces PRD+FSD)  
**Time**: 1 hour  
**Must-use**: Solo MVPs (<4 weeks)  
**Output**: `PROJECT_LITE.md` (project root)

```bash
cp templates/03-architecture-specs/PROJECT_LITE_TEMPLATE.md PROJECT_LITE.md
```

**Alternative to**: PRD + FSD + SCOPE_STATEMENT (saves 10 hours)

---

### 12. RUNBOOK_LOCAL.md
**Path**: `../04-dev-execution/RUNBOOK_LOCAL_TEMPLATE.md`  
**Purpose**: Local setup (clone → run → verify)  
**Time**: 30 minutes  
**Must-use**: Every project (for onboarding)  
**Output**: `docs/RUNBOOK_LOCAL.md`

```bash
mkdir -p docs
cp templates/04-dev-execution/RUNBOOK_LOCAL_TEMPLATE.md docs/RUNBOOK_LOCAL.md
```

---

### 13. SCOPE_STATEMENT.md
**Path**: `../01-discovery-commercial/SCOPE_STATEMENT_TEMPLATE.md`  
**Purpose**: MoSCoW prioritization, out-of-scope boundary  
**Time**: 1 hour  
**Must-use**: Client projects (prevents scope creep)  
**Output**: `docs/pm/SCOPE_STATEMENT.md`

```bash
mkdir -p docs/pm
cp templates/01-discovery-commercial/SCOPE_STATEMENT_TEMPLATE.md docs/pm/SCOPE_STATEMENT.md
```

---

### 14. SLA_RETAINER.md
**Path**: `../08-maintenance-ops/SLA_RETAINER_CONTRACT_TEMPLATE.md`  
**Purpose**: Monthly support contract  
**Time**: 1 hour  
**Output**: `contracts/SLA_RETAINER.md`

```bash
mkdir -p contracts
cp templates/08-maintenance-ops/SLA_RETAINER_CONTRACT_TEMPLATE.md contracts/SLA_RETAINER.md
```

---

### 15. SOW_CONTRACT.md
**Path**: `../01-discovery-commercial/SOW_CONTRACT_CONSOLIDATED_TEMPLATE.md`  
**Purpose**: Fixed-price contract (payment terms, IP ownership)  
**Time**: 2 hours  
**Must-use**: Client projects (legal protection)  
**Output**: `contracts/SOW_CONTRACT.md`

```bash
mkdir -p contracts
cp templates/01-discovery-commercial/SOW_CONTRACT_CONSOLIDATED_TEMPLATE.md contracts/SOW_CONTRACT.md
```

---

### 16. TODO.md
**Path**: `../04-dev-execution/TODO_TEMPLATE.md`  
**Purpose**: Atomic task queue for AI agents  
**Time**: 20 minutes  
**Must-use**: AI-assisted development  
**Output**: `docs/harness-root/TODO.md` (staged, deployed to root after scaffold)

```bash
mkdir -p docs/harness-root
cp templates/04-dev-execution/TODO_TEMPLATE.md docs/harness-root/TODO.md
```

---

### 17. UAT_WORKBOOK.md
**Path**: `../06-qa-uat/UAT_WORKBOOK_TEMPLATE.md`  
**Purpose**: User Acceptance Testing guide for client  
**Time**: 2 hours  
**Must-use**: Client projects (before BAST)  
**Output**: `docs/qa/UAT_WORKBOOK.md`

```bash
mkdir -p docs/qa
cp templates/06-qa-uat/UAT_WORKBOOK_TEMPLATE.md docs/qa/UAT_WORKBOOK.md
```

---

### 18. WARRANTY_POLICY.md
**Path**: `../08-maintenance-ops/WARRANTY_POLICY_TEMPLATE.md`  
**Purpose**: Post-launch support terms (60-day bug fixes)  
**Time**: 30 minutes  
**Must-use**: Client projects  
**Output**: `contracts/WARRANTY_POLICY.md`

```bash
mkdir -p contracts
cp templates/08-maintenance-ops/WARRANTY_POLICY_TEMPLATE.md contracts/WARRANTY_POLICY.md
```

---

### 19. .env.example
**Path**: `../04-dev-execution/ENV_EXAMPLE_TEMPLATE.md`  
**Purpose**: Environment variable template  
**Time**: 10 minutes  
**Must-use**: Every project  
**Output**: `docs/harness-root/.env.example` (staged, deployed to root after scaffold)

```bash
mkdir -p docs/harness-root
cp templates/04-dev-execution/ENV_EXAMPLE_TEMPLATE.md docs/harness-root/.env.example
```

---

### 20. DB_SCHEMA.sql
**Path**: Write manually in `db/schema.sql`  
**Purpose**: Database schema DDL (no template file)  
**Time**: 2 hours  
**Output**: `db/schema.sql`

> **Note**: Write database schema directly based on FSD.md database section. No template file exists.

---

## Usage Stats (Framework Analysis)

| Template | Usage | Time | ROI |
|----------|-------|------|-----|
| PROJECT_LITE | 90% | 1h | Very High |
| DESIGN | 95% | 30m | Very High |
| AGENTS | 80% | 15m | High |
| TODO | 75% | 20m | High |
| RUNBOOK_LOCAL | 100% | 30m | Critical |
| SOW_CONTRACT | 60% | 2h | High (client work) |
| PRD | 40% | 4h | Medium (team >2) |
| FSD | 40% | 6h | Medium (team >2) |
| BAST | 60% | 30m | High (legal closure) |
| DEPLOYMENT_PROTOCOL | 100% | 1h | Critical |

**Observation**: Top 5 templates cover 80% of project needs (Pareto principle)

---

**See also**:
- `../by-use-case/mvp-fast-track/` - Minimal MVP workflow
- `../by-use-case/client-commercial/` - Client project workflow
- `../by-use-case/technical-specs/` - Team documentation workflow
- `../by-use-case/operations/` - Production operations workflow
