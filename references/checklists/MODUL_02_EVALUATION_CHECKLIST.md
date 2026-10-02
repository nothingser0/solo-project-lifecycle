# Modul 02: Scope Statement Evaluation Checklist

> **Purpose**: Checklist evaluasi kualitas SCOPE_STATEMENT.md setelah Modul 02 selesai, untuk catch common mistakes SEBELUM lanjut ke Modul 05 (System Design).
>
> **Context**: Scope Statement adalah kontrak antara developer dan stakeholder (atau diri sendiri untuk solo project). Kesalahan di sini akan propagate ke semua modul berikutnya (design, development, testing).

---

## 1. MoSCoW Prioritization Quality

### ✅ PASS Criteria

- [ ] **Must-Have features (8-12 items)** tercakup core user loop 3 langkah (Input → Process → Output)
- [ ] **Should-Have features (3-5 items)** jelas alasan ditunda (complexity, time, cost, external dependency)
- [ ] **Could-Have features (2-4 items)** nice-to-have, Premium/Pro tier candidates
- [ ] **Won't-Have features (4-8 items)** eksplisit dengan alasan (out-of-scope, mobile app, multi-language, third-party integration)
- [ ] **No ambiguity:** Tidak ada fitur yang "mungkin masuk" atau "tergantung waktu" (semua harus masuk salah satu bucket M/S/C/W)

### ❌ RED FLAGS

- ❌ Must-Have >15 features → **Overscoped, potong jadi 10 features** (rule: MVP harus bisa demo dalam 3 menit)
- ❌ Must-Have <5 features → **Underscoped, gak ada core value** (user gak mau pakai app yang cuma 3 fitur trivial)
- ❌ Won't-Have kosong → **Scope creep risk tinggi** (semua fitur masuk "Maybe", gak ada boundary tegas)
- ❌ Should-Have == Could-Have (beda gak jelas) → **Prioritas lemah, rework MoSCoW**

---

## 2. User Stories Quality (INVEST Criteria)

### ✅ PASS Criteria (Per Story)

**Format:**
```
As a [persona/role],
I want to [action/capability],
So that [business value/outcome].

Acceptance Criteria:
- [ ] Given [context], when [action], then [expected result]
- [ ] Given [context], when [action], then [expected result]
- [ ] Edge case: [negative scenario handling]
```

**Checklist per story:**
- [ ] **Independent:** Story bisa dikerjakan tanpa dependency story lain (atau dependency eksplisit disebutkan)
- [ ] **Negotiable:** Story bisa diubah/dipecah tanpa break system (bukan spec teknis rigid)
- [ ] **Valuable:** Story memberikan value langsung ke user (bukan "Setup database" atau "Install library")
- [ ] **Estimable:** Story bisa diestimasi effort (S/M/L atau story points 1-8)
- [ ] **Small:** Story bisa selesai 1-3 hari (jika >3 hari, pecah jadi sub-stories)
- [ ] **Testable:** Acceptance criteria measurable (bukan "UI harus bagus", tapi "Button width min 120px, contrast ratio 4.5:1")

### ❌ RED FLAGS

- ❌ Acceptance criteria vague: "User bisa login dengan mudah" → **Gak testable, define "mudah" (contoh: <3 klik, <10 detik)**
- ❌ Story terlalu besar: "Implement full dashboard" → **Epic, bukan story. Pecah jadi 5-10 sub-stories**
- ❌ Story teknis tanpa user value: "Setup Redis cache" → **Task, bukan story. Attach ke parent story "Dashboard load <2s"**
- ❌ Acceptance criteria hilang → **Gak ada definition of done, risk ambiguitas saat QA**

---

## 3. Database Schema (ERD) Quality

### ✅ PASS Criteria

**Normalization:**
- [ ] **1NF:** Semua kolom atomic (gak ada array/JSON di kolom, kecuali PostgreSQL JSONB untuk flexible schema)
- [ ] **2NF:** Semua non-key kolom depend on full primary key (gak ada partial dependency)
- [ ] **3NF:** Gak ada transitive dependency (kolom A → kolom B → kolom C)

**Indexes:**
- [ ] Foreign key columns punya index (`user_id`, `client_id`, `transaction_id`)
- [ ] Query filter columns punya index (contoh: `WHERE date BETWEEN ... AND ...` → index on `date`)
- [ ] Composite index untuk multi-column query (contoh: `WHERE user_id = X AND year = Y` → index on `(user_id, year)`)

**Constraints:**
- [ ] Primary key (PK) ada di semua tabel
- [ ] Foreign key (FK) dengan ON DELETE CASCADE/SET NULL/RESTRICT (eksplisit, bukan default)
- [ ] UNIQUE constraint untuk data yang gak boleh duplikat (contoh: `email`, `npwp`, `(user_id, year, month, schema)`)
- [ ] NOT NULL untuk kolom wajib (id, email, name, user_id)
- [ ] CHECK constraint untuk validation (contoh: `CHECK (amount > 0)`, `CHECK (tier IN ('free', 'premium', 'pro'))`)

**Timestamps:**
- [ ] `created_at` TIMESTAMP DEFAULT NOW() ada di semua tabel (audit trail)
- [ ] `updated_at` TIMESTAMP DEFAULT NOW() untuk tabel yang sering diupdate (users, clients)

### ❌ RED FLAGS

- ❌ Missing foreign key → **Data integrity risk** (orphan records, gak bisa enforce relationship)
- ❌ Missing index pada foreign key → **Query slow >100ms** (full table scan)
- ❌ No UNIQUE constraint pada email/npwp → **Duplicate data risk**
- ❌ ON DELETE CASCADE gak eksplisit → **Default RESTRICT bisa block delete user** (harus manual delete children dulu)
- ❌ Kolom `status` VARCHAR tanpa CHECK constraint → **Invalid data masuk** (contoh: typo "premiun" instead of "premium")

**Common Missing Columns (Check per Use Case):**
- ❌ **Tier limit enforcement:** Missing `export_count`, `export_reset_date` untuk Free tier "max 1× export/tahun"
- ❌ **Historical snapshot:** Missing `ptkp_amount`, `exchange_rate_snapshot` untuk immutable calculation record (kalau PTKP/kurs berubah, historical data jadi gak akurat)
- ❌ **Soft delete:** Missing `deleted_at` TIMESTAMP NULL (jika requirement ada "Restore deleted account dalam 30 hari")
- ❌ **Multi-tenancy:** Missing `workspace_id`, `organization_id` (jika future plan B2B SaaS multi-tenant)

---

## 4. Tech Stack Validation

### ✅ PASS Criteria

**Maturity Check:**
- [ ] Framework main version (Next.js, React, Vue) versi **stable** (bukan alpha/beta/RC)
- [ ] Library core (database, auth, payment) punya **active maintenance** (last commit <6 bulan, GitHub issues responsif)
- [ ] API eksternal punya **public docs + SLA** (contoh: Stripe 99.99% uptime, rate limit jelas)

**Solo Dev Feasibility:**
- [ ] **Learning curve <1 minggu** untuk tech yang belum dikuasai (contoh: React Server Components, Supabase RLS)
- [ ] **Community support kuat:** Stack Overflow >1,000 questions, Discord/forum aktif
- [ ] **No vendor lock-in** (atau acceptable lock-in: contoh Vercel/Supabase bisa migrate ke self-hosted)

**Cost Projection:**
- [ ] **Free tier cukup untuk MVP** (100 users, 1GB storage, 10k API calls/month)
- [ ] **Paid tier price clear** (Supabase Pro $25/month, Vercel Pro $20/month, Midtrans 2% + Rp2,000/transaksi)
- [ ] **Break-even calculation** (MRR target vs hosting cost)

### ❌ RED FLAGS

- ❌ Tech bleeding-edge (Next.js 16 canary, React 20 alpha) → **Breaking changes risk, production gak stable**
- ❌ Library unmaintained (last commit >1 tahun, 50+ open issues unresolved) → **Security vulnerability, bug gak difix**
- ❌ External API no public docs → **Integration risk, trial-error debugging**
- ❌ Vendor lock-in extreme (proprietary DB format, no export option) → **Migration cost >1 bulan effort jika vendor shutdown**
- ❌ Cost spiral (free tier 10 users, paid tier $500/month) → **Break-even gak reachable solo dev**

---

## 5. Non-Functional Requirements (NFR) Realism

### ✅ PASS Criteria

**Performance Targets:**
- [ ] **Page load <3s** (bukan <1s, unrealistic untuk dynamic content)
- [ ] **API response <1s** (bukan <100ms, unrealistic untuk complex query + external API)
- [ ] **Export file generation <5s** (bukan <1s, file >1MB butuh time)

**Security Baseline:**
- [ ] **HTTPS only** (TLS 1.2+)
- [ ] **Password hashing** (bcrypt cost ≥12, Argon2, PBKDF2)
- [ ] **Auth token** (JWT httpOnly cookie, session expiry 7 days)
- [ ] **Rate limiting** (public endpoints 10 req/min, authenticated 60 req/min)
- [ ] **Input validation** (Zod/Yup schema, sanitize HTML, parameterized SQL query)

**Accessibility (WCAG 2.1 AA):**
- [ ] **Contrast ratio 4.5:1** (text vs background)
- [ ] **Keyboard navigation** (Tab order, Enter/Space trigger buttons)
- [ ] **ARIA labels** (screenreader-friendly)
- [ ] **Focus visible** (outline 2px solid pada elemen focused)

### ❌ RED FLAGS

- ❌ Performance target unrealistic: "API <50ms" → **Impossible dengan external API call (network latency alone 20-100ms)**
- ❌ Security missing HTTPS → **Password plaintext over network, MITM attack risk**
- ❌ Accessibility gak disebutkan → **Lawsuit risk (ADA compliance), 15% user gak bisa pakai app**
- ❌ No rate limiting → **DDoS vulnerability, brute-force attack, API cost spike**

---

## 6. Timeline & Milestone Realism

### ✅ PASS Criteria

**Buffer Rule: 30-40% of Total Time**
- [ ] Timeline punya **explicit buffer** (contoh: 12 minggu development + 3 minggu buffer = 15 minggu total)
- [ ] Buffer min **2 minggu** untuk project 3 bulan (untuk sick leave, scope creep, bug kompleks)

**Milestone Breakdown:**
- [ ] **Week 1-2:** Planning (Modul 02-04) → deliverable SCOPE, DESIGN, wireframe
- [ ] **Week 3-4:** Technical design (Modul 05) → deliverable PRD, database DDL, API contract
- [ ] **Week 5-X:** Development (iterative, 2-week sprints) → deliverable working features per sprint
- [ ] **Week X-Y:** QA & testing → deliverable unit test 80% coverage, E2E happy path
- [ ] **Week Y:** Deploy & launch → deliverable production URL, docs

**Dependency Check:**
- [ ] **External dependencies tracked** (API approval, client design assets, domain purchase)
- [ ] **Critical path identified** (longest dependency chain, contoh: Auth setup → RBAC → Payment integration)

### ❌ RED FLAGS

- ❌ No buffer (timeline "exactly 12 weeks, no slack") → **99% akan delay**
- ❌ Development phase >50% total timeline → **Planning/QA underestimated, rush di akhir**
- ❌ Milestone tidak measurable: "Week 5: Build backend" → **Gak jelas done-nya kapan, apa deliverable konkrit?**
- ❌ External dependency gak ditrack → **Blocker surprise (contoh: Midtrans approval 2 minggu, gak diprediksi)**

---

## 7. Risk Register Completeness

### ✅ PASS Criteria (Per Risk)

**Format:**
```
| Risk | Likelihood (%) | Impact | Mitigation | Owner | Trigger | Contingency |
```

- [ ] **Likelihood quantified** (10-90%, bukan "Low/Medium/High" vague)
- [ ] **Impact konkrit** (Rp loss, delay X weeks, user churn Y%)
- [ ] **Mitigation actionable** (bukan "Monitor", tapi "Unit test 30+ scenario + review konsultan")
- [ ] **Owner assigned** (solo dev = developer name, tapi jika ada external dependency, owner = vendor)
- [ ] **Trigger defined** (kondisi kapan risk jadi issue, contoh: "API down >1 jam")
- [ ] **Contingency plan** (fallback jika mitigation gagal, contoh: "Manual input kurs jika API down")

**Coverage 5 Categories:**
- [ ] **Technical risk** (API deprecated, scaling bottleneck, tech debt)
- [ ] **Resource risk** (solo dev sakit/burnout, skill gap)
- [ ] **Market risk** (competitor launch, user adoption rendah)
- [ ] **Legal/Compliance** (UU PDP pelanggaran, vendor ToS berubah)
- [ ] **Financial risk** (budget overrun, revenue gak sesuai proyeksi)

### ❌ RED FLAGS

- ❌ Risk <5 items → **Incomplete, minimum 7-10 risks untuk project 3 bulan**
- ❌ No mitigation → **Risk register cuma list, gak actionable**
- ❌ Mitigation generic: "Be careful" → **Gak membantu, define concrete action**
- ❌ No high-impact risk (semua "Low impact") → **Overconfident, underestimate risk**

---

## 8. Scope Boundaries (In/Out) Explicitness

### ✅ PASS Criteria

**In-Scope (12-15 items):**
- [ ] **Development features** (10 Must-Have dari MoSCoW)
- [ ] **Testing scope** (unit test core logic 80%, E2E test happy path)
- [ ] **Deployment scope** (Vercel production, custom domain, SSL)
- [ ] **Documentation scope** (README, ENV vars, API docs)

**Out-of-Scope (8-12 items):**
- [ ] **Future features** (mobile app, multi-language, white-label)
- [ ] **Third-party integration** (Coretax API, bank statement OCR, WhatsApp API)
- [ ] **Advanced features** (multi-year data, AI recommendation, real-time collaboration)

**Ambiguity Test:**
- [ ] **No "TBD" atau "Maybe"** → semua item masuk In atau Out, gak ada grey area
- [ ] **No overlap** → item gak masuk In dan Out sekaligus

### ❌ RED FLAGS

- ❌ Out-of-Scope kosong → **Scope creep risk 90%, client/developer akan assume "semua masuk"**
- ❌ In-Scope >20 items → **Overscoped, potong jadi 12-15 items**
- ❌ Ambiguity: "Payment integration (jika ada waktu)" → **Move ke Out-of-Scope atau commit In-Scope**

---

## 9. Common Formula/Logic Errors (Domain-Specific)

### Tax Calculator (FreePajak Example)

**CRITICAL Formula Check:**
- [ ] **PPh Final 0.5%:** `Pajak = Omzet Bruto × 0.5%` (PP 20/2026, unlimited tahun untuk OP)
- [ ] **NPPN 50%:**
  - ❌ SALAH: `(Bruto × 50% - PTKP) × Tarif Progresif`
  - ✅ BENAR: `Neto = Bruto × 50%`, `PKP = Neto - PTKP`, `Pajak = PKP × Tarif Progresif`
- [ ] **Tarif Progresif:** Bracket correct (5% s/d Rp60 jt, 15% Rp60-250 jt, 25% Rp250-500 jt, 30% Rp500-5M, 35% >Rp5M per UU HPP 2021)
- [ ] **PTKP 2026:** TK/0 = Rp54 juta, K/0 = Rp58.5 juta, K/1 = Rp63 juta, K/2 = Rp67.5 juta, K/3 = Rp72 juta (PMK 141/2015, belum update 2026 assume sama)

**Unit Test Scenario (Min 10):**
- [ ] Omzet Rp0 → Pajak Rp0 (edge case)
- [ ] Omzet Rp60 juta TK/0 → PKP Rp6 juta → Pajak 5% = Rp300rb (boundary PTKP)
- [ ] Omzet Rp500 juta K/1 → PKP Rp437 juta → Pajak progresif Rp96.05 juta (multi-bracket)
- [ ] Client DN withheld 2.5% → Kredit pajak dikurangi dari pajak terutang
- [ ] Client LN no withheld → Full pajak terutang (no kredit pajak)

### E-Commerce (Price Calculator Example)

**CRITICAL Formula Check:**
- [ ] **Subtotal:** `Σ(item.price × item.quantity)`
- [ ] **Discount:** Applied BEFORE or AFTER tax? (standard: before tax)
- [ ] **Tax (PPN 11%):** `(Subtotal - Discount) × 11%`
- [ ] **Shipping:** Flat rate, weight-based, atau free threshold? (define explicit)
- [ ] **Total:** `Subtotal - Discount + Tax + Shipping`

---

## 10. Evaluation Scoring Rubric

### Scoring Matrix (1-5 per Aspect)

| Aspect | Weight | Score (1-5) | Weighted |
|--------|--------|-------------|----------|
| MoSCoW Prioritization | 15% | [X] | [X × 0.15] |
| User Stories Quality | 15% | [X] | [X × 0.15] |
| Database Schema | 20% | [X] | [X × 0.20] |
| Tech Stack | 10% | [X] | [X × 0.10] |
| NFR Realism | 10% | [X] | [X × 0.10] |
| Timeline & Milestones | 15% | [X] | [X × 0.15] |
| Risk Register | 10% | [X] | [X × 0.10] |
| Scope Boundaries | 5% | [X] | [X × 0.05] |
| **TOTAL** | **100%** | — | **[ΣWeighted]** |

**Gate Decision:**
- **≥4.0/5:** PASS (Go to Modul 04/05)
- **3.0-3.9/5:** CONDITIONAL PASS (Fix red flags dulu, re-review)
- **<3.0/5:** FAIL (Rework Modul 02 dari awal)

---

## 11. Action Items Template (Post-Evaluation)

**CRITICAL (Must-Fix Before Modul 05):**
1. [ ] Fix formula/logic errors (contoh: NPPN calculation salah)
2. [ ] Add missing database columns (contoh: `export_count`, `ptkp_amount`)
3. [ ] Strengthen disclaimer/compliance (contoh: legal wording untuk UU PDP)
4. [ ] Adjust timeline buffer (tambah 2 minggu jika total <12 minggu)
5. [ ] Define external API fallback (contoh: kurs manual input jika API down)

**IMPORTANT (Should-Fix, Bisa Parallel):**
1. [ ] Revise Free tier limits (contoh: 3 client → 5 client)
2. [ ] Add composite indexes (contoh: `(user_id, year, month)`)
3. [ ] Clarify NFR targets (contoh: export <5s bukan <3s)
4. [ ] Expand risk register (tambah 3-5 risks jika cuma 5 items)

**OPTIONAL (Nice-to-Have):**
1. [ ] Add Should-Have features to backlog (v1.1 roadmap)
2. [ ] Document tech spike POC results (if applicable)
3. [ ] Create user journey map (visual flow diagram)

---

## 12. Checklist Summary (Quick Gate)

**Minimum Bar to PASS Modul 02:**
- ✅ MoSCoW: 8-12 Must-Have, 3-5 Should-Have, 4-8 Won't-Have
- ✅ User Stories: INVEST format, acceptance criteria testable
- ✅ Database: ERD 3-6 tables, foreign keys + indexes + constraints
- ✅ Tech Stack: Mature, active maintenance, free tier cukup MVP
- ✅ NFR: Performance/security/accessibility targets realistic
- ✅ Timeline: 12-16 weeks with 30% buffer
- ✅ Risk: 7-10 risks with mitigation + contingency
- ✅ Scope: In/Out explicit, no "TBD"

**If ANY of above = ❌ → STOP, fix dulu before Modul 05**

---

**Last Updated:** 2026-09-30  
**Changelog:**
- 2026-09-30: Initial checklist based on FreePajak Modul 02 evaluation (4.25/5, 10 potential issues identified: formula NPPN salah, missing DB columns, Free tier limits ketat, timeline ambisius)
