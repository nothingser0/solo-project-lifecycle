# PM Prioritization Frameworks (Kerangka Prioritas untuk Solo Dev)

**Purpose**: Metode sistematis untuk memutuskan fitur mana yang dikerjakan dulu, sehingga resources terbatas solo dev digunakan optimal.

**Last Updated**: 2026-09-27

---

## 1. RICE Score (Recommended untuk Solo Dev)

**Formula**: `RICE Score = (Reach × Impact × Confidence) / Effort`

### 1.1 Reach (Jangkauan)
**Definisi**: Berapa banyak user yang terpengaruh oleh fitur ini dalam periode waktu tertentu?

**Unit**: Jumlah user per time period (misal: user/month, user/quarter)

**Contoh**:
- Feature "Password reset": 80% dari 100 users = **80 users/quarter**
- Feature "Dark mode": 30% dari 100 users = **30 users/quarter**
- Feature "Admin dashboard": 1 admin user = **1 user/quarter**

**Tips Solo Dev**: Gunakan data realistis. Jika belum ada user, estimasi berdasarkan persona target (contoh: "50 beta users dalam Q1, 80% akan gunakan ini = 40")

---

### 1.2 Impact (Dampak)
**Definisi**: Seberapa besar dampak fitur ini terhadap individual user?

**Skala** (gunakan multiple):
- **Massive (3.0)**: Game-changer, mengubah cara user menggunakan produk secara fundamental (contoh: core feature yang membuat produk berguna)
- **High (2.0)**: Signifikan meningkatkan experience atau mengatasi pain point major (contoh: notifikasi real-time mengurangi user harus refresh manual)
- **Medium (1.0)**: Improvement yang jelas dirasakan tapi tidak esensial (contoh: filter/search yang lebih baik)
- **Low (0.5)**: Nice-to-have, minor improvement (contoh: UI polish, animasi)
- **Minimal (0.25)**: Barely noticeable (contoh: perubahan copy text kecil)

**Contoh**:
- "User authentication" (tanpa ini produk tidak bisa dipakai) = **Massive (3.0)**
- "Export to PDF" (frequently requested, solves real pain) = **High (2.0)**
- "Dark mode" (aesthetic preference, tidak essential) = **Low (0.5)**

**Tips Solo Dev**: Jangan semua fitur jadi "High". Paksa diri ranking relatif antar fitur.

---

### 1.3 Confidence (Tingkat Keyakinan)
**Definisi**: Seberapa yakin kamu dengan estimasi Reach dan Impact?

**Skala** (persentase):
- **High (100%)**: Data kuantitatif kuat (misal: 10 user interviews, analytics data, pesaing punya fitur ini dan sukses)
- **Medium (80%)**: Beberapa bukti kualitatif (misal: 3–5 user request, assumption wajar)
- **Low (50%)**: Pure hypothesis, belum ada validasi (misal: "feeling" bahwa fitur ini penting)

**Contoh**:
- "Payment integration" (jelas butuh untuk monetization) = **100%**
- "Social login" (2 user request, tapi belum jelas seberapa penting) = **80%**
- "AI-powered recommendation" (ide bagus tapi belum ada demand nyata) = **50%**

**Tips Solo Dev**: Confidence rendah = sinyal untuk riset dulu (user interview, prototype) sebelum build.

---

### 1.4 Effort (Upaya Kerja)
**Definisi**: Berapa person-months (atau person-weeks) untuk complete fitur ini?

**Unit**: Person-months (gunakan 0.25 = 1 minggu untuk granularity)

**Contoh**:
- **0.25 (1 minggu)**: Simple CRUD API, minor UI change
- **0.5 (2 minggu)**: Standard feature dengan integration (misal: email notifications)
- **1.0 (1 bulan)**: Complex feature (misal: payment system dengan webhook)
- **2.0 (2 bulan)**: Very complex, multi-module (misal: full admin dashboard + role management)

**Tips Solo Dev**:
- Include testing, docs, deployment (bukan cuma coding time)
- Tambahkan buffer 20% untuk unknowns
- Jika effort > 1.5 months, break down menjadi smaller stories

---

### 1.5 RICE Score Calculation Examples

#### Example 1: Password Reset Feature
- **Reach**: 80 users/quarter (80% dari 100 beta users akan pakai ini)
- **Impact**: 2.0 (High — major pain point jika lupa password, harus email admin)
- **Confidence**: 100% (jelas ini fitur standard)
- **Effort**: 0.25 person-months (1 minggu)

**RICE Score** = (80 × 2.0 × 1.0) / 0.25 = **640**

---

#### Example 2: AI-Powered Smart Suggestions
- **Reach**: 50 users/quarter (assume 50% dari users akan coba fitur ini)
- **Impact**: 2.0 (High — bisa hemat waktu user signifikan)
- **Confidence**: 50% (belum ada user request, pure hypothesis)
- **Effort**: 2.0 person-months (butuh ML model, training data, API integration)

**RICE Score** = (50 × 2.0 × 0.5) / 2.0 = **25**

---

#### Example 3: Dark Mode
- **Reach**: 30 users/quarter (30% prefer dark mode berdasarkan survey informal)
- **Impact**: 0.5 (Low — aesthetic preference, bukan functional improvement)
- **Confidence**: 80% (ada 3 user requests, data dari survey)
- **Effort**: 0.25 person-months (1 minggu untuk CSS + toggle logic)

**RICE Score** = (30 × 0.5 × 0.8) / 0.25 = **48**

---

#### Prioritization Result:
1. **Password Reset (640)** ← Build first
2. **Dark Mode (48)** ← Build second
3. **AI Suggestions (25)** ← Defer to later (high effort, low confidence)

---

### 1.6 RICE Score Worksheet Template

| Feature | Reach | Impact | Confidence | Effort | RICE Score | Priority |
| :--- | ---: | ---: | ---: | ---: | ---: | :--- |
| Password reset | 80 | 2.0 | 1.0 | 0.25 | **640** | P0 (Now) |
| Email notifications | 100 | 1.0 | 1.0 | 0.5 | **200** | P1 (Next) |
| Dark mode | 30 | 0.5 | 0.8 | 0.25 | **48** | P2 (Later) |
| Export to PDF | 60 | 1.0 | 1.0 | 0.25 | **240** | P1 (Next) |
| AI suggestions | 50 | 2.0 | 0.5 | 2.0 | **25** | P3 (Defer) |
| Social login | 40 | 0.5 | 0.8 | 0.5 | **32** | P2 (Later) |

**Sort by RICE Score** (highest first) untuk prioritas eksekusi.

---

## 2. MoSCoW Prioritization (Must/Should/Could/Won't)

**Gunakan untuk**: Quick triage saat awal project (sebelum detailed scoring)

### Must Have (P0)
- **Definisi**: Tanpa fitur ini, produk tidak usable atau tidak deliver core value
- **Kriteria**: MVP razor — hanya 3–5 fitur maksimal di kategori ini
- **Contoh**: User authentication, core processing engine, basic dashboard

### Should Have (P1)
- **Definisi**: Penting tapi bukan blocker untuk launch, tambahkan di beta/post-launch
- **Kriteria**: Fitur yang meningkatkan UX signifikan atau retention
- **Contoh**: Password reset, email notifications, export hasil

### Could Have (P2)
- **Definisi**: Nice-to-have, improvement tambahan jika ada waktu/budget
- **Kriteria**: Fitur yang requested tapi tidak urgent
- **Contoh**: Dark mode, social login, advanced filters

### Won't Have (P3)
- **Definisi**: Out of scope untuk current release, revisit di future
- **Kriteria**: Complex, low confidence, atau bukan focus area
- **Contoh**: Mobile app, multi-language, API untuk third-party

**Tips Solo Dev**: Start dengan MoSCoW untuk rough cut, lalu gunakan RICE untuk ranking detail dalam "Should Have" dan "Could Have".

---

## 3. Value vs Effort Matrix (2×2 Grid)

**Gunakan untuk**: Visualisasi prioritas secara cepat (useful untuk presentasi/stakeholder)

```
      HIGH VALUE
           │
   Quick   │   Strategic
   Wins    │   Bets
  (DO NOW) │ (PLAN CAREFULLY)
───────────┼───────────────── EFFORT
   Low     │   Money
   Hanging │   Pits
   Fruit   │  (AVOID)
           │
      LOW VALUE
```

### Quadrant 1: Quick Wins (High Value, Low Effort)
- **Action**: Do now, prioritize highest
- **Contoh**: Password reset (high user need, 1 week effort)

### Quadrant 2: Strategic Bets (High Value, High Effort)
- **Action**: Plan carefully, break into phases
- **Contoh**: Payment integration (critical for revenue, but complex)

### Quadrant 3: Low Hanging Fruit (Low Value, Low Effort)
- **Action**: Do if spare time, atau delegate
- **Contoh**: UI polish, copy improvements

### Quadrant 4: Money Pits (Low Value, High Effort)
- **Action**: Avoid atau defer indefinitely
- **Contoh**: AI features with unclear ROI, over-engineered architecture

**Tips Solo Dev**: Jika ragu, tanya diri sendiri: "Apakah effort ini worth 10x result?" Jika tidak, masuk Money Pit.

---

## 4. Kano Model (User Satisfaction vs Feature Presence)

**Gunakan untuk**: Memahami tipe fitur berdasarkan user reaction

### Performance Features
- **Definisi**: Semakin ada, semakin puas (linear relationship)
- **Contoh**: Speed (faster = better), accuracy (higher = better)
- **Prioritas**: Medium (invest sampai diminishing returns)

### Basic Features (Must-Haves)
- **Definisi**: Jika tidak ada, user sangat tidak puas. Jika ada, user neutral (expected).
- **Contoh**: Security (HTTPS, auth), data tidak hilang
- **Prioritas**: P0 (harus ada, tapi tidak perlu over-invest)

### Excitement Features (Delighters)
- **Definisi**: Jika tidak ada, user neutral. Jika ada, user sangat senang (unexpected delight).
- **Contoh**: Dark mode, fun animations, Easter eggs
- **Prioritas**: P2–P3 (good for differentiation, tapi low priority untuk MVP)

**Tips Solo Dev**: Fokus ke Basic features dulu (prevent dissatisfaction), lalu Performance features (deliver promised value), baru Excitement features (differentiation).

---

## 5. ICE Score (Simplified RICE)

**Formula**: `ICE Score = (Impact + Confidence + Ease) / 3`

**Gunakan jika**: RICE terlalu complex, butuh metode lebih cepat

- **Impact**: Skala 1–10 (1 = minimal, 10 = massive)
- **Confidence**: Skala 1–10 (1 = pure guess, 10 = validated data)
- **Ease**: Skala 1–10 (1 = very hard, 10 = trivial)

**Contoh**:
- Password reset: (8 + 10 + 8) / 3 = **8.7**
- AI suggestions: (8 + 4 + 2) / 3 = **4.7**

**Tips Solo Dev**: Gunakan ICE untuk quick triage, RICE untuk final prioritization.

---

## 6. Weighted Scoring Model (Custom Criteria)

**Gunakan jika**: Ada criteria spesifik selain RICE (misal: strategic alignment, technical debt reduction)

### Example Criteria:
- User Value (30% weight)
- Revenue Impact (25% weight)
- Strategic Alignment (20% weight)
- Technical Feasibility (15% weight)
- Risk Reduction (10% weight)

**Scoring**: Each criterion rated 1–5, multiply by weight, sum total.

**Tips Solo Dev**: Jangan over-complicate. RICE sudah cover most cases. Gunakan weighted scoring hanya jika ada unique constraints (misal: comply dengan client requirements yang spesifik).

---

## 7. Prioritization Anti-Patterns (Apa yang TIDAK Boleh Dilakukan)

### ❌ HiPPO (Highest Paid Person's Opinion)
- **Problem**: Prioritize berdasarkan siapa yang paling keras protes/demand
- **Fix**: Gunakan framework objektif (RICE), data-driven

### ❌ "Everything is P0"
- **Problem**: Semua fitur dianggap urgent, tidak ada prioritas nyata
- **Fix**: Paksa rank relatif. Max 3–5 fitur di P0.

### ❌ "Shiny Object Syndrome"
- **Problem**: Chase fitur baru terus, tidak finish yang lama
- **Fix**: Commit to roadmap, resist new ideas mid-sprint

### ❌ "Build It Because We Can"
- **Problem**: Prioritize fitur teknis yang cool tapi zero user value
- **Fix**: Setiap fitur harus ada user value yang jelas (not tech flex)

### ❌ "Analysis Paralysis"
- **Problem**: Terlalu lama analyze/prioritize, tidak mulai build
- **Fix**: Time-box prioritization (max 2 hours), use rough estimates, iterate later

---

## 8. Practical Prioritization Workflow (Solo Dev)

### Step 1: Brain Dump (15 min)
- List semua fitur ideas (dari user feedback, competitive analysis, own ideas)
- Aim for 20–30 items

### Step 2: MoSCoW Quick Triage (30 min)
- Categorize: Must (P0), Should (P1), Could (P2), Won't (P3)
- Jika lebih dari 5 items di "Must", re-evaluate (too many)

### Step 3: RICE Scoring (1–2 hours)
- Score all P0 and P1 items with RICE
- Use worksheet/spreadsheet untuk tracking

### Step 4: Sort & Review (15 min)
- Sort by RICE score descending
- Sanity check: "Does this order make sense intuitively?"
- Adjust jika ada outlier (contoh: RICE high tapi intuitively tidak urgent)

### Step 5: Commit to Top 5 (5 min)
- Pick top 5 untuk "Now" (current sprint/cycle)
- Next 5–10 masuk "Next"
- Rest masuk "Later" atau "Icebox"

### Step 6: Revisit Monthly
- Re-score based on new data (user feedback, market changes)
- Promote/demote features as needed

**Total Time**: ~3 hours per month (worth it untuk avoid building wrong things)

---

## 9. Tools untuk Prioritization

### Spreadsheet (Google Sheets / Excel)
- **Pros**: Simple, flexible, free
- **Cons**: Manual calculation, no automation
- **Best for**: Solo dev, < 50 features

### Notion Database
- **Pros**: Visual (board/table view), formulas for auto-calc RICE
- **Cons**: Requires setup
- **Best for**: Solo dev who wants integrated with project docs

### Linear (Issues)
- **Pros**: Built-in priority field, roadmap view, integrates with dev workflow
- **Cons**: No native RICE scoring (need custom fields)
- **Best for**: Solo dev yang sudah pakai Linear untuk issue tracking

### Productboard
- **Pros**: Purpose-built for product prioritization, RICE built-in, user feedback aggregation
- **Cons**: Expensive ($20/month+), overkill for solo dev
- **Best for**: Small team (2+ people) atau solo dev with budget

**Recommendation**: Start dengan Google Sheets (template below), upgrade ke Notion/Linear jika butuh integration.

---

## 10. RICE Scoring Spreadsheet Template

**Copy this to Google Sheets / Excel**:

```
| Feature Name | Reach | Impact | Confidence | Effort | RICE Score | Priority | Status | Owner | Notes |
|--------------|-------|--------|------------|--------|------------|----------|--------|-------|-------|
| Password reset | 80 | 2.0 | 1.0 | 0.25 | =B2*C2*D2/E2 | P0 | Backlog | Dev | Standard feature |
| Email notifs | 100 | 1.0 | 1.0 | 0.5 | =B3*C3*D3/E3 | P1 | Backlog | Dev | Use SendGrid |
| Dark mode | 30 | 0.5 | 0.8 | 0.25 | =B4*C4*D4/E4 | P2 | Backlog | Dev | Low effort win |
```

**Formulas**:
- RICE Score column: `=Reach*Impact*Confidence/Effort`
- Sort by RICE Score descending untuk auto-prioritize

**Download**: _(Create this template in `/templates/pm/RICE_SCORING_WORKSHEET.xlsx` if needed)_

---

## 11. When to Re-Prioritize (Triggers)

- **Weekly**: Quick review top 5 items (still relevant?)
- **Monthly**: Full re-score of backlog
- **Ad-hoc triggers**:
  - Major user feedback (5+ requests for same feature)
  - Competitor launches similar feature
  - Technical blocker discovered (effort increased 2x)
  - Strategy pivot (target user changes)
  - Scope cut needed (deadline pressure, reduce to P0 only)

---

## 12. Summary Cheat Sheet

**Choose Framework Based On**:
- **RICE**: Default choice, balanced and data-driven
- **MoSCoW**: Quick triage, early-stage project
- **Value/Effort Matrix**: Visual presentation for stakeholders
- **Kano Model**: Understanding user psychology/satisfaction
- **ICE**: Faster than RICE, less granular

**Solo Dev Golden Rules**:
1. **Max 5 items in "Now"** — focus beats quantity
2. **Score ruthlessly** — not everything is high impact
3. **Use data** — interview 5 users beats 100 assumptions
4. **Revisit monthly** — priorities change, backlog should too
5. **Communicate decisions** — write down why feature X > Y (for future self)

---

**📌 Next Steps**: Apply RICE to your backlog → Move top 5 to "Now" → Start building → Revisit next month
