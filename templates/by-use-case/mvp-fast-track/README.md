# MVP Fast-Track Templates

**Use case**: Ship MVP dalam 2-4 minggu tanpa full ceremony

**Time to complete**: 2-3 hours total (vs 20+ hours untuk full framework)

---

## Core Templates (Must Fill)

### 1. PROJECT_LITE.md
**Path**: `../../03-architecture-specs/PROJECT_LITE_TEMPLATE.md`  
**Purpose**: All-in-one spec (Idea + Scope + Architecture + Specs)  
**Time**: 1 hour  
**Output**: `PROJECT_LITE.md` (project root)

**Quick fill**:
```bash
cp templates/03-architecture-specs/PROJECT_LITE_TEMPLATE.md PROJECT_LITE.md
# Fill sections 1-7, skip optional sections
```

---

### 2. DESIGN.md
**Path**: `../../02-design/DESIGN_TEMPLATE.md`  
**Purpose**: Design tokens (colors, typography, spacing)  
**Time**: 30 minutes  
**Output**: `DESIGN.md` (project root)

```bash
cp templates/02-design/DESIGN_TEMPLATE.md DESIGN.md
# Define 1 primary color, 1-2 fonts, 4-6 spacing values
```

---

### 3. RUNBOOK_LOCAL.md
**Path**: `../../04-dev-execution/RUNBOOK_LOCAL_TEMPLATE.md`  
**Purpose**: Local setup instructions (clone → run → verify)  
**Time**: 20 minutes  
**Output**: `docs/RUNBOOK_LOCAL.md`

```bash
mkdir -p docs
cp templates/04-dev-execution/RUNBOOK_LOCAL_TEMPLATE.md docs/RUNBOOK_LOCAL.md
# Document `npm install && npm run dev` flow
```

---

## Optional Templates (Add Post-MVP)

### 4. DESIGN_SPEC.md
**Path**: `../../02-design/DESIGN_SPEC_TEMPLATE.md`  
**Purpose**: Page inventory, responsive breakpoints  
**Time**: 1 hour  
**When**: After 3+ pages designed

```bash
cp templates/02-design/DESIGN_SPEC_TEMPLATE.md docs/specs/DESIGN_SPEC.md
```

---

### 5. DEPLOY_CHECKLIST.md
**Path**: `../../07-release-handover/DEPLOYMENT_PROTOCOL_TEMPLATE.md`  
**Purpose**: Go-live checklist (DNS, SSL, env vars)  
**Time**: 30 minutes  
**When**: 1 week before launch

```bash
cp templates/07-release-handover/DEPLOYMENT_PROTOCOL_TEMPLATE.md docs/DEPLOYMENT_PROTOCOL.md
```

---

## Workflow: MVP in 2 Weeks

**Week 1 (Spec & Design)**:
1. Day 1-2: Fill `PROJECT_LITE.md` (scope + tech decisions)
2. Day 3: Fill `DESIGN.md` (design tokens)
3. Day 4-5: Build core pages (homepage, auth, 1 feature)

**Week 2 (Build & Ship)**:
1. Day 6-8: Implement backend API + frontend
2. Day 9: Fill `RUNBOOK_LOCAL.md` + smoke test
3. Day 10: Deploy to staging, fill `DEPLOY_CHECKLIST.md`

**Total templates**: 3 mandatory (2 hours), 2 optional (1.5 hours)

---

## Skip These for MVP

❌ **PRD_FINAL.md** - Too formal (4 hours), use `PROJECT_LITE.md` instead  
❌ **FSD.md** - Too detailed (6 hours), tech decisions in `PROJECT_LITE.md` sufficient  
❌ **DESIGN_SYSTEM_AUDIT.md** - Premature (no design system yet)  
❌ **SYSTEM_DESIGN_DOC.md** - Overkill (<10K users), add post-traction  
❌ **SOW_CONTRACT.md** - If internal/side project (use for client work only)

---

## Migration Path: MVP → Production

When you hit **5K+ MAU** or **need to scale team**, upgrade:

1. Extract `PROJECT_LITE.md` → `PRD.md` + `FSD.md` (4 hours)
2. Add `SYSTEM_DESIGN_DOC.md` for caching/HA (2 hours)
3. Create `DESIGN_SYSTEM_AUDIT.md` if visual inconsistency emerges (1 hour)
4. Add `SOW_CONTRACT.md` if converting client work (2 hours)

**See**: `../../README.md` for full framework navigation
