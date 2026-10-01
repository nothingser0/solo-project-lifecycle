# PM Communication Guide: Business Communication Skills untuk Solo Developer

**Audience**: Solo developer yang berhadapan dengan stakeholder bisnis, klien, atau tim internal  
**Goal**: Master komunikasi profesional untuk membangun trust, mengelola ekspektasi, dan mempertahankan scope  
**Last Updated**: 2026-09-27

---

## 1. Foundation: Komunikasi adalah Pertahanan Scope Terbaik

**Prinsip Inti**:
- **Clarity > Politeness**: Jelas lebih penting dari sopan. Ambiguitas = scope creep.
- **Proactive > Reactive**: Update sebelum ditanya, bukan setelah krisis.
- **Data > Opinion**: "80% selesai" lebih baik dari "hampir selesai".
- **Options > Problems**: Jangan lapor masalah tanpa bawa 2-3 solusi.
- **Written > Verbal**: Semua keputusan konfirmasi tertulis dalam 2 jam.

---

## 2. Executive Summary Writing (Top-Down Communication)

### Struktur 1-Page Executive Summary

```markdown
## [Project Name] - Status Update [Date]

**Status**: 🟢 Green / 🟡 Yellow / 🔴 Red  
**Progress**: [X]% complete (Week [Y] of [Z])  
**Budget**: $[Spent] / $[Total] ([Z]% utilized)

---

### Key Wins (Top 3)
1. [Specific achievement with business impact]
2. [Milestone reached ahead of schedule]
3. [Risk mitigated successfully]

### Risks & Mitigation (Top 2)
1. **Risk**: [Description]  
   **Impact**: [High/Medium/Low] - [Business consequence]  
   **Mitigation**: [Action taken + ETA]

2. **Risk**: [Description]  
   **Impact**: [High/Medium/Low]  
   **Mitigation**: [Action taken + ETA]

### Blockers (If Any)
- **Blocker**: [Description]  
  **Owner**: [Who needs to act]  
  **Needed By**: [Deadline]  
  **Consequence if Unresolved**: [Impact]

### Next Milestone
[What's shipping next] - Target: [Date]

### Asks (Explicit Decisions Needed)
1. [Decision request with 2-3 options and recommendation]
2. [Approval request with deadline]
```

### Contoh Nyata: Bad vs Good

**❌ Bad (Vague, No Action)**:
> "Project berjalan lumayan lancar. Ada beberapa kendala kecil tapi sedang ditangani. Mungkin ada sedikit delay tapi insyaallah bisa selesai tepat waktu."

**✅ Good (Data-Driven, Actionable)**:
> **Status**: 🟡 Yellow (at risk)  
> **Progress**: 60% complete (Week 6 of 10)  
> **Risk**: Third-party payment API down for 2 days. Impact: Payment module delayed 3 days.  
> **Mitigation**: Switched to backup provider (Stripe → Xendit). Extra cost +$500, but keeps timeline on track.  
> **Ask**: Approve $500 budget increase by Friday EOD, or accept 1-week delay.

---

## 3. RAG Status (Red-Amber-Green) System

### Definisi Status

| Status | Meaning | Trigger | Action Required |
| :--- | :--- | :--- | :--- |
| 🟢 **Green** | On track | No blockers, timeline safe | Continue, routine updates |
| 🟡 **Yellow** | At risk | 1+ risk detected, mitigation active | Escalate to "Keep Satisfied" tier, increase update frequency |
| 🔴 **Red** | Blocked | Critical blocker >3 days, or timeline slip >2 weeks | Immediate escalation to CEO/CFO, crisis protocol |

### Kapan Mengubah Status?

**Green → Yellow**:
- Blocker muncul yang berpotensi delay >3 hari
- Budget burn rate >10% di atas forecast
- Key stakeholder tidak responsif >48 jam pada keputusan kritis

**Yellow → Red**:
- Blocker tidak resolved dalam 3 hari
- Timeline slip >2 minggu confirmed
- Budget overrun >20%
- Data breach / security incident

**Red → Yellow → Green**:
- Hanya setelah mitigation action terbukti efektif (bukan sekadar plan)
- Tunggu 1 sprint cycle untuk konfirmasi stabilitas

---

## 4. Status Report Format (Weekly Update)

### Template untuk "Keep Informed" Tier (Slack/Discord)

```markdown
**[Project Name] - Week [X] Update**

**Last Week** ✅:
- Shipped: User authentication (OAuth2 + 2FA)
- Shipped: Payment gateway integration (Stripe test mode)
- Fixed: 3 P1 bugs from QA testing

**This Week** 🎯:
- Goal: Complete product catalog CRUD APIs
- Goal: Start mobile responsive layout
- Milestone: Deploy to staging by Friday

**Blockers** 🚧:
- Waiting for design approval on checkout page (sent Mon, no reply yet)
  - **Ask**: @Designer need feedback by Wed EOD or proceeding with current version

**Metrics**:
- Progress: 65% → 70% (+5%)
- Test coverage: 75% (target: 80%)
- P0 bugs: 0 | P1 bugs: 2 (down from 5)
```

### Template untuk "Keep Satisfied" Tier (Email - Bi-weekly)

**Subject**: [Project Name] - Bi-weekly Status Report 🟢 [Date]

```markdown
**Status**: 🟢 Green (on track)

**Progress Summary**:
- 70% feature completion (Week 7 of 10)
- $28K spent / $40K budget (70% utilized, on track)
- 0 critical bugs, 2 minor bugs in triage

**Recent Achievements**:
1. User authentication module live on staging (OAuth2, 2FA, password reset)
2. Payment gateway integrated and tested (Stripe)
3. API documentation published (OpenAPI spec)

**Coming Next 2 Weeks**:
1. Complete product catalog + shopping cart
2. QA testing sprint (target: 80% test coverage)
3. Security audit preparation

**Risks**:
1. **Client data migration delayed by client team** (Medium impact)
   - Mitigation: Building mock data generator, real data can be imported post-launch
   - Status: Escalated to Client CEO on [Date]

**No blockers requiring executive action at this time.**

**Budget & Timeline**: On track for [Launch Date] within approved budget.

---
**Next Update**: [Date]
```

---

## 5. Risk Communication (Early Warning System)

### Formula Komunikasi Risk

```
[Risk Name] - Impact: [H/M/L], Probability: [H/M/L]

**Scenario**: [What could go wrong]
**Impact**: [Business consequence if it happens]
**Current Status**: [Is it happening now or potential?]

**Mitigation Options**:
1. [Option A]: [Description] - Cost: [X], Time: [Y], Pros/Cons
2. [Option B]: [Description] - Cost: [X], Time: [Y], Pros/Cons
3. [Option C]: [Description] - Cost: [X], Time: [Y], Pros/Cons

**Recommendation**: [Option X] because [reasoning]
**Decision Needed By**: [Date] (after this date, we default to [Option X])
```

### Contoh Nyata

**❌ Bad (Vague, Panic Mode)**:
> "Ada masalah besar dengan server! Kayaknya database bakal overload kalau user banyak. Harus di-fix sekarang atau nanti crash!"

**✅ Good (Structured, Options-Oriented)**:
> **Risk**: Database Performance at Scale - Impact: High, Probability: Medium
>
> **Scenario**: Current database schema can handle ~500 concurrent users. If launch campaign brings >1000 users, response time could degrade to >10s (unusable).
>
> **Impact**: User churn, negative reviews, potential revenue loss ~$5K/week
>
> **Current Status**: Not happening yet (we're in beta with 50 users), but launch in 2 weeks
>
> **Mitigation Options**:
> 1. **Database Optimization** (add indexes, query refactor): $0 cost, 3 days work
>    - Pros: No infrastructure cost, likely solves 80% of issue
>    - Cons: May not be enough if traffic >2000 users
>
> 2. **Vertical Scaling** (upgrade database tier): +$200/month, 1 day work
>    - Pros: Quick, proven solution
>    - Cons: Ongoing cost, doesn't scale beyond 2000 users
>
> 3. **Horizontal Scaling** (read replicas + load balancer): +$500/month, 5 days work
>    - Pros: Scales to 10K+ users
>    - Cons: High cost, delays launch by 1 week
>
> **Recommendation**: Option 1 now (3 days), Option 2 if needed post-launch. Cheaper to optimize first, scale later based on real data.
>
> **Decision Needed By**: Friday EOD (so we finish optimization before launch week)

---

## 6. Scope Creep Defense Scripts

### Script 1: The "Small Feature" Request

**Klien**: "Bisa tambahin fitur X? Cuma kecil kok, seharusnya cepat kan?"

**❌ Bad Response**:
> "Oh iya bisa kok, nanti saya coba ya."

**✅ Good Response**:
> "Bisa, tapi mari kita lihat trade-off-nya. Fitur X butuh estimasi 2-3 hari dev time karena [alasan teknis singkat]. Kita punya 3 opsi:
> 1. **Masukkan sprint ini**: Timeline geser 3 hari, atau kita drop fitur Y yang sudah di-plan
> 2. **Masukkan Phase 2** (post-launch): Tidak ganggu timeline current release
> 3. **Paid change order**: +$X jika di luar scope original yang sudah disepakati
>
> Yang mana yang paling sesuai prioritas bisnis Anda?"

### Script 2: The "Just Make It Work" Ambiguity

**Klien**: "Dashboard-nya harus user-friendly ya, biar mudah dipakai."

**❌ Bad Response**:
> "Siap, akan saya buat user-friendly."

**✅ Good Response**:
> "Noted. Supaya kita satu persepsi, boleh saya konfirmasi definisi 'user-friendly' di konteks ini:
> - Apakah maksudnya: Loading time <2 detik?
> - Atau: Max 3 klik untuk akses fitur utama?
> - Atau: Mobile-responsive (bisa dipakai di HP)?
> - Atau: Ada tutorial/onboarding pertama kali login?
>
> Kalau saya tangkap, prioritas tertinggi adalah [X] dan [Y]. Betul begitu?"

### Script 3: The "Why Is This Taking So Long?"

**Klien**: "Kok lama ya? Bukannya cuma CRUD biasa?"

**❌ Bad Response**:
> "Ini kompleks, banyak yang harus dipikirkan." (Defensif, vague)

**✅ Good Response**:
> "Betul, secara konsep CRUD memang standar. Tapi ada beberapa requirement yang bikin waktu lebih lama:
> 1. **Security**: Encrypt sensitive data, implement RBAC untuk 3 user roles
> 2. **Validation**: 12 business rules yang harus dicek sebelum save data
> 3. **Integration**: Sync dengan 2 external APIs yang rate-limited
>
> Dari 5 hari estimasi, breakdown-nya:
> - 2 hari: Core CRUD (sudah selesai)
> - 2 hari: Security + validation (in progress)
> - 1 hari: API integration + testing
>
> Kalau mau lebih cepat, kita bisa temporary skip API integration (tambahkan nanti), hemat 1 hari. Mau?"

---

## 7. Handling Difficult Stakeholders

### Type 1: The Micromanager

**Ciri-ciri**:
- Tanya progress setiap hari (berkali-kali)
- Minta status update untuk setiap task kecil
- Tidak percaya kalau tidak lihat bukti (screenshot, video)

**Strategi**:
1. **Proactive Daily Update** (pagi 09:00 sebelum mereka tanya):
   ```
   **Today's Focus**: Completing checkout flow backend API
   **Expected Done By**: EOD today
   **Demo Link**: https://staging.example.com/checkout (credentials: demo/demo123)
   ```

2. **Set Update Schedule**: 
   > "Supaya lebih efisien, saya akan kirim update pagi jam 09:00 dan sore jam 17:00 setiap hari. Jika ada blocker urgent, saya kabari immediate. Dengan cara ini kita bisa tetap sinkron tanpa interupsi di tengah coding. Setuju?"

3. **Over-Document**:
   - Commit messages jelas
   - Staging environment always accessible
   - Loom video untuk demo progress

### Type 2: The Scope Creeper

**Ciri-ciri**:
- Setiap minggu ada "ide bagus" baru
- "Cuma tambah kecil kok" adalah mantra mereka
- Tidak sadar akumulasi "kecil" = delay besar

**Strategi**:
1. **Change Request Form** (formal process):
   ```markdown
   **Feature Request**: [Name]
   **Business Value**: [Why this matters]
   **Estimated Effort**: [X days]
   **Impact on Timeline**: [+X days delay OR drop feature Y]
   **Budget Impact**: [+$X or within existing scope?]
   **Proposed Phase**: [Current sprint / Phase 2 / Paid extension]
   ```

2. **Visual Timeline Impact**:
   - Tunjukkan Gantt chart: "Tambah fitur ini = geser launch dari 15 Nov jadi 30 Nov"
   - Gunakan trade-off: "Mau fitur ini masuk, mana yang mau di-drop: A, B, atau C?"

3. **Iron Triangle Script**:
   > "Kita punya 3 variabel: Scope, Time, Quality. Saat ini kita locked di Time (launch 15 Nov) dan Quality (80% test coverage). Kalau Scope nambah, salah satu variabel lain harus flex. Mau yang mana?"

### Type 3: The Silent Approver

**Ciri-ciri**:
- Tidak reply email/Slack untuk approval request
- "Nanti saya liat dulu" tapi tidak pernah selesai review
- Blocking progress karena tidak ada sign-off

**Strategi**:
1. **Time-Bound Approval**:
   > "Design mockup sudah saya kirim via Figma (link: ...). Need approval by Wednesday 17:00 WIB. Jika belum ada feedback by deadline, saya proceed dengan asumsi approved untuk keep timeline on track. Setuju?"

2. **Escalation Warning**:
   > "API spec approval sudah pending 3 hari. Jika tidak ada feedback by tomorrow EOD, saya akan escalate ke [Boss/PO] supaya tidak block dev team. Prefer to get your input first if possible."

3. **Default to Last Agreed Version**:
   > "Since no feedback received on Version 3, I'm proceeding with Version 2 (last approved). Can always iterate in Phase 2 if needed."

### Type 4: The "I'll Know It When I See It"

**Ciri-ciri**:
- Tidak bisa articulate requirement secara jelas
- Revisi design/feature berkali-kali setelah development dimulai
- "Hmm, kayaknya bukan gini deh" setelah lihat hasil

**Strategi**:
1. **Prototype-First Approach**:
   - Buat low-fidelity wireframe/mockup sebelum coding
   - 30-min feedback session setelah mockup
   - Lock design before development

2. **Revision Budget**:
   > "Design revision: Max 2 rounds included in contract. Round 3+ = change order +$X per round. Ini untuk protect timeline kita berdua."

3. **Reference Examples**:
   > "Supaya kita align, bisa kasih contoh website/app yang style-nya Anda suka? Misal: 'Seperti Tokopedia tapi lebih minimalis' atau 'Seperti Notion tapi lebih colorful'."

---

## 8. Email vs Slack vs Call (Choosing the Right Channel)

### Decision Matrix

| Situation | Channel | Why |
| :--- | :--- | :--- |
| **Daily tactical update** | Slack/Discord | Fast, informal, searchable |
| **Approval request** | Email (with Slack reminder) | Written record, formal |
| **Complex decision with options** | Email (detailed) + Call (discuss) | Allows prep time + real-time Q&A |
| **Scope change negotiation** | Call → Email confirmation | Human negotiation + paper trail |
| **Crisis/P0 incident** | Call/WhatsApp → Slack update | Immediate attention + broadcast |
| **Weekly status** | Email (cc all) | Broadcast, reference-able |
| **Casual check-in** | Slack DM | Low-pressure, quick sync |

### Email Subject Line Best Practices

**❌ Bad**:
> "Update"
> "Question"
> "Need help"

**✅ Good**:
> "[Project X] - Design Approval Needed by Wed EOD"
> "[Project X] - Week 7 Status Report 🟢 (70% complete)"
> "[Project X] - URGENT: API Integration Blocked - Decision Needed"

**Formula**: `[Project Name] - [Action Required / Status] - [Urgency/Deadline]`

---

## 9. Meeting Facilitation Skills

### Pre-Meeting (24h Before)

**Send Agenda**:
```markdown
**Meeting**: [Project X] - Weekly Sync
**Date**: [Date] [Time] [Timezone]
**Duration**: 30 min (hard stop)
**Attendees**: [Names]
**Location**: [Zoom link]

**Agenda**:
1. Progress review (10 min): Demo feature X
2. Blockers discussion (10 min): Payment API integration issue
3. Next week priorities (5 min): Confirm top 3 tasks
4. Decisions needed (5 min): Approve budget increase $2K for SMS gateway

**Pre-read** (optional): [Link to doc/dashboard]

**Goal**: Leave meeting with clear decision on budget and unblocked on payment API
```

### During Meeting

**Time Management**:
- Start on time (even if people late)
- Timebox each agenda item
- "Let's park that for later" for off-topic discussions
- 5-min warning before hard stop

**Decision Capture**:
- Designate note-taker (not the facilitator)
- Record decisions in real-time (shared doc)
- Action items: Owner + Deadline

**Handling Tangents**:
> "That's important, but off-agenda. Let's add to parking lot and schedule separate 15-min to discuss."

### Post-Meeting (Within 2h)

**Send Meeting Notes**:
```markdown
**Meeting Notes**: [Project X] - Weekly Sync - [Date]

**Attendees**: [Present] | **Absent**: [Names]

**Decisions Made**:
1. ✅ Approved $2K budget for SMS gateway (Twilio)
2. ✅ Agreed to drop Feature Y to keep timeline on track
3. ⏸️ Postponed decision on mobile app to Phase 2

**Action Items**:
- [ ] @SoloDev: Setup Twilio account by Wed
- [ ] @Designer: Send revised mockup by Fri EOD
- [ ] @ProductOwner: Confirm client approval on scope change by Mon

**Parking Lot** (for future discussion):
- Feature Z enhancement
- Q2 roadmap planning

**Next Meeting**: [Date] [Time]
```

---

## 10. Negotiation & Conflict Resolution

### Negotiation Framework: BATNA (Best Alternative to Negotiated Agreement)

**Before Negotiation, Prepare**:
1. **Your Position**: What you want
2. **Their Position**: What they want
3. **Your BATNA**: What you'll do if negotiation fails
4. **Their BATNA**: What they'll do if negotiation fails
5. **ZOPA (Zone of Possible Agreement)**: Overlap between your bottom line and their top line

**Example: Budget Negotiation**

- **Client**: Budget only $30K
- **You**: Need $40K to deliver all features
- **Your BATNA**: Drop 30% of features to fit $30K budget
- **Their BATNA**: Find another developer (risk: delay 2 months)
- **ZOPA**: $32K-$38K (if you optimize, they stretch budget)

**Negotiation Script**:
> "Saya pahami budget constraint $30K. Untuk deliver semua fitur butuh $40K. Ada 3 opsi:
> 1. **Full scope**: $40K, 10 weeks
> 2. **Phase 1 (MVP)**: $30K, 6 weeks → Phase 2 (remaining): $10K, 4 weeks
> 3. **Reduced scope**: $30K, 10 weeks, drop Feature X, Y, Z
>
> Yang mana yang paling align dengan prioritas bisnis Anda?"

### Conflict Resolution: DESC Model

**D = Describe** (Facts, no judgment):
> "Design mockup sudah 3 kali revisi, dan setiap kali setelah development dimulai."

**E = Express** (Impact on you):
> "Ini membuat development terhambat, karena harus re-code yang sudah jadi. Timeline berisiko delay 2 minggu."

**S = Specify** (What you want):
> "Going forward, saya usulkan: Design locked before dev starts. Max 2 revision rounds. Round 3+ = paid change order."

**C = Consequences** (Positive if they agree, negative if not):
> "Dengan cara ini, kita bisa deliver on time and on budget. Kalau tidak, risk delay dan budget overrun yang merugikan kita berdua."

---

## 11. Cultural & Personality Adaptation

### High-Context vs Low-Context Cultures

**Low-Context** (Barat: US, Jerman, Belanda):
- Direct communication preferred
- "No" means no
- Written agreements paramount
- Conflict addressed head-on

**High-Context** (Asia: Indonesia, Jepang, Thailand):
- Indirect communication, save face
- "Yes" might mean "maybe" or "I heard you"
- Relationship > contract
- Conflict avoided or softened

**Adaptation Strategy**:

**For High-Context Clients**:
- Add buffer: "Seharusnya selesai minggu depan" → Anda plan 2 minggu
- Read between lines: "Sepertinya bagus" ≠ approval, follow up
- Build relationship first: 10-min small talk before business

**For Low-Context Clients**:
- Be direct: "This will delay timeline by 1 week" (no sugar-coating)
- Document everything: Email confirms all verbal discussions
- Set explicit expectations: "Silence = approval" must be stated upfront

### Personality Types (DISC Model - Quick Guide)

**D (Dominant)**: Results-focused, impatient, decisive
- **Communication Style**: Bottom-line first, bullet points, no fluff
- **What They Want**: "Will this work? How much? When?"
- **Example**: "Option A: $30K, 8 weeks. Recommend."

**I (Influencer)**: People-focused, enthusiastic, optimistic
- **Communication Style**: Storytelling, visuals, positive framing
- **What They Want**: "How will users love this?"
- **Example**: "Imagine users opening the app and seeing..."

**S (Steady)**: Process-focused, patient, reliable
- **Communication Style**: Step-by-step, reassurance, consistency
- **What They Want**: "What's the plan? Is it safe?"
- **Example**: "Here's the 5-step deployment plan. We've tested this 3 times."

**C (Conscientious)**: Detail-focused, analytical, skeptical
- **Communication Style**: Data, charts, accuracy, options
- **What They Want**: "Show me the data. What are the risks?"
- **Example**: "Test coverage 80%, P0 bugs: 0, P1 bugs: 2. Risk analysis attached."

---

## 12. Common Communication Mistakes (Anti-Patterns)

### Mistake 1: The "Almost Done" Trap

**❌ Problem**:
> "Hampir selesai kok, tinggal sedikit lagi." (Diucapkan 3 minggu berturut-turut)

**✅ Fix**:
> "Progress: 75% complete. Remaining tasks: X (2 days), Y (1 day), Z (3 days). ETA: Friday."

### Mistake 2: Over-Promising to Please

**❌ Problem**:
> "Bisa, saya coba ya!" (Padahal tidak yakin feasible)

**✅ Fix**:
> "Menarik idenya. Biar saya riset dulu 1-2 hari untuk feasibility check. Saya update kembali Kamis dengan estimasi akurat."

### Mistake 3: Hiding Bad News

**❌ Problem**:
> (Tahu ada blocker besar tapi diam 1 minggu sampai krisis)

**✅ Fix**:
> (Hari ke-1 blocker): "FYI, ada blocker X. Estimasi 2-3 hari untuk resolve. Update daily."

### Mistake 4: Technical Jargon to Non-Tech Stakeholders

**❌ Problem**:
> "CORS preflight failed karena OPTIONS request tidak return proper headers dari backend."

**✅ Fix**:
> "Ada issue komunikasi antara frontend dan backend. Sedang diperbaiki, estimasi selesai besok."

### Mistake 5: No Follow-Up on Verbal Decisions

**❌ Problem**:
> (Meeting: "Ok approved") → (2 minggu kemudian: "Loh kok fitur ini ada? Saya tidak setuju!")

**✅ Fix**:
> (Email 2 jam setelah meeting): "Confirming today's decision: Approved $2K budget for SMS gateway. Development starts tomorrow."

---

## 13. Templates Quick Reference

### 1. Daily Standup (Async Slack)
```
**Yesterday**: ✅ [Done items]
**Today**: 🎯 [Focus items]
**Blockers**: 🚧 [Issues] or "None"
```

### 2. Weekly Status Report
```
**Status**: 🟢/🟡/🔴
**Progress**: X% (Week Y of Z)
**Wins**: [3 items]
**Next Week**: [3 goals]
**Blockers**: [If any]
**Asks**: [Explicit requests]
```

### 3. Risk Report
```
**Risk**: [Name] - Impact: H/M/L, Probability: H/M/L
**Scenario**: [What could happen]
**Impact**: [Business consequence]
**Options**: [2-3 mitigation choices]
**Recommendation**: [Your pick + why]
**Decision By**: [Date]
```

### 4. Change Request
```
**Feature**: [Name]
**Business Value**: [Why needed]
**Effort**: [X days]
**Timeline Impact**: [+Y days OR drop feature Z]
**Budget Impact**: [+$X]
**Proposed**: [Current sprint / Phase 2 / Paid]
```

### 5. Meeting Notes
```
**Decisions**: [Numbered list]
**Action Items**: [@Owner: Task - Deadline]
**Parking Lot**: [Deferred topics]
**Next Meeting**: [Date/Time]
```

---

## 14. Checklist: Communication Hygiene

Daily:
- [ ] Send morning standup update to "Manage Closely" tier (09:00)
- [ ] Reply to all Slack/email within SLA (<2h for urgent, <24h for others)
- [ ] Confirm verbal decisions in writing within 2h

Weekly:
- [ ] Send status report to "Keep Informed" tier (Fri EOD)
- [ ] Update project dashboard (progress %, blocker status)
- [ ] Review upcoming week priorities with Product Owner

Bi-weekly:
- [ ] Send executive summary to "Keep Satisfied" tier
- [ ] Risk register review (any new risks?)

Monthly:
- [ ] Executive review prep (1-page summary)
- [ ] Stakeholder engagement scorecard update
- [ ] Communication plan adjustment (if needed)

Before Every Meeting:
- [ ] Send agenda 24h before
- [ ] Prepare demos/visuals
- [ ] Define meeting goal

After Every Meeting:
- [ ] Send meeting notes within 2h
- [ ] Confirm action items with owners
- [ ] Schedule next meeting

---

## 15. Resources & Further Reading

### Books
- "Crucial Conversations" - Patterson, Grenny, et al. (Conflict resolution)
- "Never Split the Difference" - Chris Voss (Negotiation)
- "The Pyramid Principle" - Barbara Minto (Executive communication)
- "Radical Candor" - Kim Scott (Direct feedback)

### Tools
- **Status Dashboards**: Linear, Jira, Notion
- **Time Tracking**: Toggl, Clockify
- **Demo Videos**: Loom, Vimeo Record
- **Documentation**: Notion, Confluence, Google Docs

### Skills to Practice
1. **Executive summary writing**: Take any project update, rewrite as 1-page top-down summary
2. **Option framing**: For every problem, force yourself to generate 3 solutions before reporting
3. **Time-bound asks**: Never say "need your input" without "by [date]"
4. **Meeting facilitation**: Record yourself, analyze: Did you stay on time? Capture decisions?

---

## Appendix: Communication Style Adapters

### Formal (Legal, Executive, Compliance)
- Subject line: `[Official] [Project X] - [Topic]`
- Salutation: "Dear [Title] [Last Name],"
- Language: "We respectfully request approval for..."
- Close: "Sincerely, [Full Name]"

### Professional (Product Owner, Manager)
- Subject line: `[Project X] - [Topic]`
- Salutation: "Hi [First Name],"
- Language: "Need your decision on..."
- Close: "Best, [First Name]"

### Casual (Designer, Dev Team, QA)
- Subject line: `[Project X] - quick question`
- Salutation: "Hey [Name],"
- Language: "Quick heads up..."
- Close: "Thanks!"

**Rule of Thumb**: Match the recipient's style. If they write formal, reply formal. If they Slack "yo" you, Slack "hey" back.

---

**End of PM Communication Guide**

**Last Updated**: 2026-09-27  
**Maintained By**: Solo Project Development Skill (Module 02)
