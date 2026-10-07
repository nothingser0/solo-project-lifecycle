# Quick Start MVP Guide (2-4 Weeks)

> **Target**: Solo developers building simple MVPs (1-3 features, < Rp 20 million (~$1,250), < 4 weeks)  
> **Philosophy**: Ship working software fast, skip documentation overhead

---

## ⚠️ CRITICAL: Project Directory Setup

**Project initialization workflow**: Create project folder, initialize git, then generate docs.

```bash
# Step 1: Create project directory
mkdir ~/projects/my-mvp-app
cd ~/projects/my-mvp-app

# Step 2: Initialize git
git init

# Step 3: Generate specifications & planning docs
# Framework generates:
#   - docs/pm/ (PM documents)
#   - docs/specs/ (PRD, FSD)
#   - docs/harness-root/ (9 AI control files - STAGED, not in root yet)

# Step 4: After scaffold (npx create-next-app, etc.)
# Agent copies to root, then cleans up staging:
cp docs/harness-root/* ./ && cp docs/harness-root/.env.example ./ && rm -rf docs/harness-root/
```

**Why staging in docs/harness-root/?**
- Root folder empty/git-only before scaffold
- Framework CLI (create-next-app, laravel new) needs empty/minimal root
- Harness files deployed AFTER scaffold to avoid conflicts
- Staging folder removed after copy to enforce a single source of truth and prevent AI path drift

---

## When to Use This Guide

✅ **Use this if**:
- MVP / proof-of-concept (< 4 weeks timeline)
- 1-3 core features only
- Solo founder (you are owner & developer)
- Budget < Rp 20 million (~$1,250)
- Tech stack familiar (no learning curve)

❌ **Don't use this if**:
- Client project (requires formal contract → use full framework)
- Team > 1 developer
- Budget > Rp 50 million (~$3,150)
- Compliance required (banking, healthcare, government)
- >3 months timeline

---

## The 5-Step MVP Path (Skip 9 Modules)

```
Week 1: Idea → Specs (2 days)
Week 2-3: Build (10 days)
Week 4: Deploy (2 days)
```

### Skip These Modules
- ❌ M00 (Market Research) → Validate AFTER launch
- ❌ M01 (Feasibility) → Just build it
- ❌ M02 (Scope) → Keep it in your head or 1-page doc
- ❌ M03 (Legal/SOW) → No client = no contract
- ❌ M04 section 8 (Design System Foundation) → Use Tailwind defaults
- ❌ M05 section 6 (System Design & Infrastructure) → Single server is fine
- ❌ M06 section 6A (Analytics Setup) → Add post-launch
- ❌ M07 (QA/SIT) → Manual testing only
- ❌ M08 (Data Migration) → No legacy data
- ❌ M09 (UAT) → You are the user
- ❌ M11 (BAST & Handover) → No external client handover
- ❌ M13 (Operations & Growth) → Defer to post-launch

### Do These Only
- ✅ M04 (UI/UX) → 1 day design
- ✅ M05 (Architecture) → 1 day specs
- ✅ M06 (Development) → 10 days coding
- ✅ M10 (Deployment) → 1 day launch
- ✅ M12 (Warranty) → Self-maintain

> 💡 **For Solo SaaS with Multiple Features (4-10 features)**:
> Do NOT skip market validation completely. Use the **Solo SaaS Path** defined in `SKILL.md`:
> `M00-lite → M01 → M02 → M04 → M05 → M06 → M07 → M10 → M12 → M13`
> (Validates demand with 5 user interviews and waitlist test via `templates/01-discovery-commercial/M00_LITE_TEMPLATE.md`).

---

## Day-by-Day Execution

### Day 1: Idea → Specs (4 hours)

**Output**: 2 files total
1. `PROJECT_LITE.md` (or `PROJECT.md` — core specs)
2. `docs/harness-root/DESIGN.md` (UI tokens - staged)

**Agent workflow**:
```bash
# Read template from skill repo, write to user's project directory
# 1. Read: skill://solo-project-lifecycle/templates/03-architecture-specs/PROJECT_LITE_TEMPLATE.md
# 2. Write: ./PROJECT_LITE.md (or ./PROJECT.md in project root)
# 3. Fill sections (20 min each):
# 1. Problem (3 sentences)
# 2. Solution (5 bullet points)
# 3. Core features (3 max)
# 4. Tech stack (pick from Boring Tech ladder)
# 5. Database schema (3-5 tables max)
```

**MVP Problem Statement** (3 sentences):
```markdown
## Problem
[WHO] has problem [WHAT] because [WHY].
Currently they solve it by [CURRENT_SOLUTION].
This costs them [TIME/MONEY/FRUSTRATION].
```

**MVP Solution** (5 bullets max):
```markdown
## Solution
- Feature 1: [verb + noun + outcome]
- Feature 2: [verb + noun + outcome]
- Feature 3: [verb + noun + outcome]
- Non-feature: We will NOT build [scope boundary]
- Success metric: [1 number you track]
```

**Tech Stack Decision** (pick one row):
```markdown
| Stack | Best For | Setup Time |
|-------|----------|------------|
| Next.js 15 + Supabase | Web app, rapid prototyping | 1 hour |
| Laravel 11 + MySQL | CRUD-heavy, familiar with PHP | 2 hours |
| Django + PostgreSQL | Data-heavy, admin panel needed | 2 hours |
| Vite + Firebase | Frontend-only, no backend logic | 30 min |
```

**Database Schema** (SQL DDL only, 3-5 tables max):
```sql
-- Example: Todo App MVP
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email VARCHAR(255) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE todos (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  title VARCHAR(255) NOT NULL,
  completed BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Max 5 tables for MVP. More = not MVP.
```

---

### Day 2: Design (4 hours)

**Output**: `docs/harness-root/DESIGN.md` (design tokens only, no mockups - staged)

**Agent workflow**:
```bash
# Read template from skill repo, write to user's project directory
# 1. Read: skill://solo-project-lifecycle/templates/02-design/DESIGN_MD_TEMPLATE.md
# 2. Write: docs/harness-root/DESIGN.md (staged for deployment after scaffold)
# 3. If Next.js: suggest running `npx shadcn@latest init` (Zinc palette, default radius)
```

**MVP Design Tokens** (15 min):
```markdown
## Colors
- Primary: Zinc-900 (dark mode: Zinc-50)
- Accent: Blue-600
- Error: Red-600
- Success: Green-600

## Typography
- Font: Inter (system fallback: sans-serif)
- Scale: text-sm, text-base, text-lg, text-xl

## Spacing
- Base: 4px (Tailwind default)
- Scale: 2, 4, 8, 16, 24, 32, 48

## Components
- Use shadcn/ui Button, Input, Card, Badge
- NO custom components for MVP
```

**Skip**:
- ❌ Figma mockups (waste 2 days)
- ❌ Logo design (use text logo)
- ❌ Custom illustrations (use Lucide icons)
- ❌ Responsive mobile design (desktop-first, mobile acceptable)

---

### Day 3-12: Build (10 days @ 8 hours/day)

**Pre-build setup**:

1. **Scaffold framework** (Day 3 morning):
   ```bash
   # Next.js
   npx create-next-app@latest . --typescript --tailwind --app
   
   # Laravel
   composer create-project laravel/laravel .
   
   # Django
   poetry init && django-admin startproject myproject .
   ```

2. **Deploy AI harness files**:
   ```bash
   # Agent copies staged files to root
   # Source: docs/harness-root/AGENTS.md, ARCHITECTURE.md, etc.
   # Target: ./AGENTS.md, ./ARCHITECTURE.md, etc. (root)
   # Overwrites framework boilerplate if exists (e.g., Next.js AGENTS.md)
   cp docs/harness-root/* ./ && cp docs/harness-root/.env.example ./ && rm -rf docs/harness-root/
   ```

3. **Verify harness installed**:
   ```bash
   ls -1 | grep -E '^(AGENTS|CONTEXT|ARCHITECTURE|DESIGN|CONVENTIONS|TODO|RUNBOOK_LOCAL|VERIFY_LOCAL)\.md$'
   ls -1 .env.example
   # Expected: 9 files total
   ```

**Week 1 (Day 3-7): Backend + Auth**
- Day 3: Scaffold + harness deployment + DB migrations
- Day 4: Auth (register, login, logout)
- Day 5-7: Core feature 1 (CRUD endpoints)

**Week 2 (Day 8-12): Frontend + Integration**
- Day 8-9: Core feature 1 (UI)
- Day 10: Core feature 2 (backend + frontend)
- Day 11: Core feature 3 (backend + frontend)
- Day 12: Polish + manual testing

**Development Checklist** (atomic tasks):
```markdown
Backend (5 days):
- [ ] Scaffold project (npx create-next-app / composer create-project)
- [ ] Setup DB connection + migrations
- [ ] Auth: POST /api/auth/register (hash password Argon2)
- [ ] Auth: POST /api/auth/login (return HttpOnly cookie)
- [ ] Auth: POST /api/auth/logout
- [ ] Auth: GET /api/auth/me (current user)
- [ ] Feature 1: GET /api/[resource] (list with pagination)
- [ ] Feature 1: POST /api/[resource] (create with Zod validation)
- [ ] Feature 1: PATCH /api/[resource]/:id (update)
- [ ] Feature 1: DELETE /api/[resource]/:id (soft delete)

Frontend (5 days):
- [ ] Layout: Header + Sidebar (collapsible)
- [ ] Auth: Login page (/login)
- [ ] Auth: Register page (/register)
- [ ] Dashboard: Landing page after login
- [ ] Feature 1: List page (table with search + pagination)
- [ ] Feature 1: Create form (modal or dedicated page)
- [ ] Feature 1: Edit form
- [ ] Feature 1: Delete confirmation dialog
- [ ] Feature 2 & 3: Repeat CRUD pattern
- [ ] Error handling: Toast notifications (Sonner)

Testing (1 day):
- [ ] Smoke test: Register → Login → Create → Edit → Delete
- [ ] Test on Chrome + Safari
- [ ] Test on desktop + mobile viewport
```

**MVP Engineering Rules**:
1. **No abstractions**: Copy-paste code, DRY later during refactoring
2. **No tests**: Manual testing only (automated tests post-launch)
3. **No optimization**: Premature optimization = wasted time
4. **Hardcode OK**: Magic numbers, inline styles → fine for MVP
5. **Ship bugs**: Non-critical bugs = post-launch fix

---

### Day 13-14: Deploy (2 days)

**Day 13: Staging Deploy**
```bash
# Next.js → Vercel (5 min)
vercel --prod

# Laravel → Laravel Forge or DigitalOcean (2 hours)
# Django → Railway or Render (30 min)

# Configure:
- [ ] Environment variables (.env)
- [ ] Database (PostgreSQL/MySQL)
- [ ] Domain (optional, use [project].vercel.app for MVP)
```

**Day 14: Production Launch**
```bash
# Pre-launch checklist (30 min):
- [ ] HTTPS enabled (auto via Vercel/Railway)
- [ ] Signup works end-to-end
- [ ] Core feature 1 works
- [ ] Core feature 2 works
- [ ] Core feature 3 works
- [ ] Error tracking (Sentry free tier)

# Launch:
- [ ] Share link with 5 beta users
- [ ] Monitor errors via Sentry
- [ ] Fix critical bugs within 24 hours
```

---

## MVP Don'ts (Common Traps)

❌ **Don't**:
1. Build admin panel (use database GUI tool)
2. Build user settings page (hardcode defaults)
3. Build email verification (skip for MVP, add later)
4. Build password reset (users can re-register)
5. Build roles/permissions (everyone admin for MVP)
6. Build notifications (email users manually)
7. Build export CSV (users can screenshot)
8. Build dark mode (pick one, usually light)
9. Build mobile app (PWA is enough)
10. Build API documentation (you're the only user)

✅ **Do instead**:
- Focus on 1 core workflow end-to-end
- Launch in 2-4 weeks
- Get 10 users using it
- Iterate based on real feedback

---

## Post-Launch (Week 5+)

**When MVP proves traction** (>10 active users, >50% retention):
1. Read full framework `docs/README.md`
2. Add proper monitoring (M06 section 6A - Analytics)
3. Write tests for critical paths (M07)
4. Refactor code (remove copy-paste)
5. Add admin panel
6. Scale infrastructure (M05 section 6 - System Design)

**When MVP fails** (<5 users, <20% retention):
- Pivot or kill
- Don't waste time polishing a product nobody wants
- Total time wasted: 2-4 weeks (acceptable)

---

## MVP Success Metrics

Track 1 number only:
- **SaaS**: Weekly Active Users (WAU)
- **Marketplace**: Transactions per week
- **Content**: Daily content submissions
- **Community**: Daily messages sent

If number grows week-over-week → MVP working → invest more.  
If number flat/declining → MVP failing → pivot or stop.

---

## Templates You Actually Need

**Agent workflow**: Read templates from skill repo `templates/` directory, write to user's project working directory:

```bash
# Agent instructions (not shell commands):
# 1. Core specs - Read from skill, write to user project root
#    Source: skill://solo-project-lifecycle/templates/03-architecture-specs/PROJECT_LITE_TEMPLATE.md
#    Target: ./PROJECT_LITE.md (or ./PROJECT.md)

# 2. Design tokens - Read from skill, write to harness staging
#    Source: skill://solo-project-lifecycle/templates/02-design/DESIGN_MD_TEMPLATE.md
#    Target: docs/harness-root/DESIGN.md

# 3. Deployment checklist - Read from skill, write to user project root
#    Source: skill://solo-project-lifecycle/templates/07-release-handover/DEPLOYMENT_PROTOCOL_TEMPLATE.md
#    Target: ./DEPLOY.md
```

Total documentation: 3 files, <5 pages.  
Total time on docs: 4 hours.  
Time saved: 32 hours (vs full framework).

---

## When to Upgrade to Full Framework

Upgrade when:
- ✅ MVP has >50 active users
- ✅ Raising funding or signing first client
- ✅ Hiring second developer (need proper docs)
- ✅ Compliance required (banking, healthcare)
- ✅ Budget increases >Rp 50 million (~$3,150)

Then read:
- `docs/modules/02-discovery-scope.md` (scope protection)
- `docs/modules/03-legal-sow-charter.md` (contracts)
- `docs/modules/05-architecture-specs.md` section 6 (scaling & infrastructure)
- `docs/modules/07-quality-assurance-sit.md` (testing)

---

## FAQ

**Q: Can I skip design entirely?**  
A: No. Spend 4 hours on `docs/harness-root/DESIGN.md` (tokens only, staged). Ugly UI = 0 users.

**Q: Can I use WordPress/Bubble/Webflow?**  
A: Yes if truly no-code. But if you write ANY custom code, use proper framework (Next.js/Laravel).

**Q: Should I buy domain + hosting first?**  
A: No. Use free tier (Vercel/Railway/Supabase). Buy domain only after 10 users.

**Q: What if I need payments?**  
A: Stripe Checkout (pre-built UI). Don't build custom payment form for MVP.

**Q: What if I need authentication?**  
A: Supabase Auth or NextAuth. Don't build custom auth for MVP.

**Q: My MVP is taking >4 weeks. What's wrong?**  
A: You're building too many features. Cut scope to 3 max. If still >4 weeks, your tech stack too slow (switch to Next.js + Supabase).

---

**Remember**: MVP = Minimum **Viable** Product, not Minimum **Valuable** Product.  
Viable = works end-to-end, users can complete 1 core workflow.  
Polish, features, scale = post-launch.

**Ship in 2-4 weeks or don't ship at all.**
