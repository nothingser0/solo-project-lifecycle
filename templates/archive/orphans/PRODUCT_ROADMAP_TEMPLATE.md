# Product Roadmap: [Nama Produk]

**Periode**: Q[X] 2026 (atau range bulan: Jan–Mar 2026)  
**Owner**: [Nama PIC / Solo Dev]  
**Last Updated**: YYYY-MM-DD  
**Status**: Draft / Active / Archived

---

## 1. Product Vision & North Star Metric

**Vision Statement** (1–2 kalimat):  
*"[Produk ini] membantu [target user] untuk [core value proposition] dengan cara [differentiator utama]."*

**North Star Metric**:  
*Metrik tunggal yang paling menunjukkan value produk ke user (contoh: "Jumlah dokumen berhasil diproses per minggu", "Monthly active projects").*

---

## 2. Now / Next / Later Roadmap

### 🔥 Now (Sprint/Cycle Sekarang: [Tanggal Mulai] – [Tanggal Selesai])

Fokus: **[Tema sprint, contoh: "MVP Core Features"]**

| Feature/Epic | Priority | Owner | Effort (SP) | Status | Dependencies | Notes |
| :--- | :--- | :--- | :---: | :--- | :--- | :--- |
| User Authentication (email + password) | P0 | Dev | 8 | In Progress | — | Must have for launch |
| Document Upload & Storage | P0 | Dev | 5 | Not Started | S3 bucket setup | Use Supabase Storage |
| Basic Dashboard (list view) | P0 | Dev | 5 | Not Started | Auth complete | Show uploaded docs |
| Email notification on process complete | P1 | Dev | 3 | Backlog | SMTP config | Nice to have |

**Exit Criteria (Definition of Done for "Now")**:
- [ ] All P0 features deployed to staging
- [ ] Core user loop tested by 2 internal users
- [ ] No P0 bugs blocking launch

---

### 🚀 Next (Next Sprint/Cycle: [Tanggal Mulai] – [Tanggal Selesai])

Fokus: **[Tema, contoh: "Activation & Retention"]**

| Feature/Epic | Priority | Owner | Effort (SP) | Depends On | Rationale (Why Next?) |
| :--- | :--- | :--- | :---: | :--- | :--- |
| Onboarding tutorial (3 steps) | P1 | Dev | 5 | Dashboard | Reduce drop-off after signup |
| Payment integration (Stripe/Midtrans) | P0 | Dev | 8 | Auth | Required for monetization |
| Export results to PDF | P1 | Dev | 3 | Processing engine | User-requested feature |
| Dark mode | P2 | Dev | 2 | — | Low effort, high user delight |

**Target Outcome**: 40% of beta users complete onboarding + 10 paying customers.

---

### 🔮 Later (Backlog 3–6 bulan ke depan)

Fokus: **[Tema, contoh: "Scale & Advanced Features"]**

| Feature/Epic | Priority | Owner | Effort (SP) | Why Later? | Review Date |
| :--- | :--- | :--- | :---: | :--- | :--- |
| API for third-party integration | P2 | Dev | 13 | Complex, need stable core first | Q2 2026 |
| AI-powered smart suggestions | P2 | Dev | 21 | Requires ML infra & data | Q3 2026 |
| Multi-language support (i18n) | P2 | Dev | 8 | No demand yet, nice-to-have | When 100+ international users |
| Mobile app (React Native) | P3 | TBD | 34 | Web-first strategy | When web DAU > 500 |

**Promotion Trigger**: Feature di "Later" naik ke "Next" jika:
- Ada urgent user demand (5+ requests)
- Competitor launch similar feature
- Dependencies selesai lebih cepat dari estimasi

---

## 3. Release Milestones & Timeline

```text
┌─────────────────────────────────────────────────────────────────────┐
│  W1-2    │  W3-4    │  W5-6    │  W7-8    │  W9-10   │  W11-12     │
├──────────┼──────────┼──────────┼──────────┼──────────┼─────────────┤
│ Tech     │ Alpha    │ Feature  │ Beta     │ Polish & │ Public      │
│ Spike    │ (Core    │ Complete │ (Closed  │ Security │ Launch 🚀   │
│          │  Loop)   │ (Now)    │  5 users)│  Audit   │             │
└─────────────────────────────────────────────────────────────────────┘

Week 1-2   : M0 - Technical Spike (validate hardest risk)
Week 3-4   : M1 - Alpha (internal dogfooding)
Week 5-6   : M2 - Feature Complete ("Now" items done)
Week 7-8   : M3 - Closed Beta (invite 5-10 real users)
Week 9-10  : M4 - Hardening (bug fixes, performance, security)
Week 11-12 : M5 - Public Launch (open registration)
```

### Milestone Detail

| Milestone | Target Date | Core Deliverables | Exit Criteria | Risk Flag |
| :--- | :--- | :--- | :--- | :--- |
| **M0: Tech Spike** | 2026-01-15 | Proof of concept for core algorithm | Can demo end-to-end in 5 min | API vendor delay |
| **M1: Alpha** | 2026-01-31 | Auth + Upload + Process working | Solo dev completes full workflow | None |
| **M2: Feature Complete** | 2026-02-15 | All P0 "Now" features deployed | Pass QA checklist (50 items) | Scope creep |
| **M3: Closed Beta** | 2026-02-28 | 5 users testing daily | 2+ users retain after week 1 | User recruitment |
| **M4: Hardening** | 2026-03-15 | Fix all critical bugs, load test | 0 P0 bugs, API p95 < 500ms | Performance bottleneck |
| **M5: Public Launch** | 2026-03-31 | Production ready + docs | Landing page live, payment works | Payment gateway approval |

---

## 4. Dependency Map

**Critical Path** (blocking dependencies):
1. ✅ AWS account setup → S3 bucket creation
2. 🟡 Auth backend complete → Dashboard can show user data
3. 🟡 Payment integration approved → Can accept real transactions
4. 🔴 Beta user recruitment → Can test activation features

**Legend**:
- ✅ Done
- 🟡 In Progress
- 🔴 Blocked / Not Started

**External Dependencies** (outside dev control):
- Payment gateway approval: Expected 5–7 business days (apply by Week 4)
- SSL certificate for custom domain: Auto-issue with Certbot (1 day)
- Client logo/branding assets: Waiting on client (fallback: use placeholder)

---

## 5. Assumptions & Constraints

**Assumptions**:
- Solo dev availability: 6 hours/day, 5 days/week (30 hours/week)
- No major scope changes during "Now" phase
- Third-party APIs (Stripe, AWS) remain stable

**Constraints**:
- Budget: Max $200/month for infrastructure + SaaS tools
- Tech stack: Next.js + Supabase + Vercel (no deviation without approval)
- Compliance: Must comply with UU PDP (Indonesia data protection law)

---

## 6. Success Metrics (How We Know Roadmap Works)

| Phase | Leading Indicator | Lagging Indicator | Target |
| :--- | :--- | :--- | :--- |
| **Now (MVP)** | # of internal test sessions | Features deployed to prod | 10 sessions, 5 features |
| **Next (Beta)** | Weekly active beta users | User retention D7 | 10 WAU, 40% D7 retention |
| **Later (Scale)** | API call volume | Monthly recurring revenue | 10k calls/month, $500 MRR |

---

## 7. Roadmap Review Cadence

- **Weekly**: Review "Now" progress, update status, flag blockers
- **Bi-weekly**: Reassess "Next" priorities, promote/demote features based on learnings
- **Monthly**: Update "Later" based on user feedback, market changes, tech breakthroughs
- **Quarterly**: Full roadmap refresh (new Now/Next/Later for next Q)

---

## 8. Change Log

| Date | Change | Reason | Approved By |
| :--- | :--- | :--- | :--- |
| 2026-01-10 | Added "Export to PDF" to Next | 3 user requests in beta feedback | Solo Dev |
| 2026-01-25 | Moved "Dark mode" from Later to Next | Low effort (2 SP), high delight | Solo Dev |
| 2026-02-05 | Removed "Social login" from Now | Scope cut to meet M1 deadline | Solo Dev |

---

## 📌 Quick Reference Links

- **Backlog Detail**: `docs/pm/BACKLOG.md`
- **OKRs**: `docs/pm/OKR_Q1_2026.md`
- **Risk Register**: `docs/pm/RISK_REGISTER.md`
- **Technical Architecture**: `docs/design/FSD_ARCHITECTURE.md`

---

**🚨 Roadmap Philosophy (Solo Dev Constraints)**:
- **Ruthless prioritization**: Only 3–5 items in "Now" at any time
- **Bias to action**: Ship imperfect > perfect planning
- **No sacred cows**: Features can be demoted/removed if not delivering value
- **Time-box everything**: If a feature takes 2× estimated effort, stop and reassess
