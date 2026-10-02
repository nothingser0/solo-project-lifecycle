# Modul 13: Product Operations & Continuous Iteration (Operasi Produk & Iterasi Berkelanjutan)

> ⚠️ **MANDATORY: Load references BEFORE executing this module**:
> - `references/improvements/MODUL_13_IMPROVEMENTS.md` (Timeline estimation, Metrics dashboard tool recommendations, Experiment documentation template)
> - `references/pm/RICE_SCORING_GUIDE.md` (RICE scoring formula, reach/impact/confidence rubrics, backlog prioritization worksheet)
>
> **MANDATORY: Load references BEFORE executing this module**:
> - Read: `references/improvements/MODUL_13_IMPROVEMENTS.md`

Modul ini adalah tahap **pasca-peluncuran** dalam siklus hidup produk perangkat lunak untuk solo developer. Dijalankan setelah Modul 12 (Warranty & SLA) ketika sistem telah stabil di produksi dan fokus beralih dari "membangun" menjadi "mengoptimalkan & mengembangkan" berdasarkan data riil pengguna. Tujuannya adalah membangun **kerangka operasional berbasis metrik** untuk meningkatkan produk secara berkelanjutan menggunakan data, bukan asumsi.

---

## 1. Siklus Eksekusi Modul 13

```text
[ INPUT: Sistem Produksi Stabil + Data Pengguna 30 Hari Pertama ]
                                    │
                                    ▼
[ LANGKAH 1: Metrics Baseline Collection (Pengumpulan Baseline Metrik) ]
  • Kumpulkan data metrik 30 hari pertama pasca-peluncuran
  • Hitung Mean, Median, P50/P90/P95 untuk semua metrik kunci
  • Bandingkan dengan benchmark industri (jika tersedia)
  • Setup sistem deteksi anomali (Sentry, Datadog, custom alerts)
                                    │
                                    ▼
[ LANGKAH 2: Feedback Loop Automation (Otomasi Umpan Balik Pengguna) ]
  • NPS Survey otomatis: Hari ke-7, Hari ke-30, Kuartalan
  • In-App Feedback Widget (Canny, UserVoice, Typeform embed)
  • Agregasi tiket support ke knowledge base (GitHub Issues → FAQ)
  • Feature Request Vote & Prioritization Board
                                    │
                                    ▼
[ LANGKAH 3: Cohort Analysis (Analisis Kelompok Pengguna) ]
  • Retention Cohorts: Day 1 / 7 / 30 / 90 retention rate
  • Behavioral Segmentation: Power Users vs Churners vs Casuals
  • Churn Prediction Signals (last_active > 14 days, low engagement)
  • Power User Identification (top 10% aktivitas)
                                    │
                                    ▼
[ LANGKAH 4: Feature Prioritization (Prioritas Fitur dengan RICE) ]
  • Terapkan RICE Framework: Reach × Impact × Confidence / Effort
  • Feature ROI Calculation: Expected Revenue - Development Cost
  • Opportunity Cost Analysis: Apa yang tidak dikerjakan jika pilih fitur X?
  • Quarterly Feature Review Workshop
                                    │
                                    ▼
[ LANGKAH 5: Growth Experiments Backlog (Daftar Eksperimen Pertumbuhan) ]
  • Setup Hypothesis Format (dari Modul 04 A/B Testing)
  • Prioritized Experiment Queue (sortir berdasarkan expected lift × ease)
  • Velocity Tracking: Target 2–4 eksperimen per bulan
  • Learning Repository: Dokumentasi hasil eksperimen (win/lose/neutral)
                                    │
                                    ▼
[ LANGKAH 6: Product Health Monitoring (Pemantauan Kesehatan Produk) ]
  • Weekly Metrics Review (15 menit standup metrics)
  • Monthly OKR Check-In (progres terhadap North Star Metric dari M00)
  • Quarterly Roadmap Review (prioritas ulang berdasarkan learnings)
  • Annual Strategy Refresh (pivot atau double-down decision)
                                    │
                                    ▼
[ LANGKAH 7: Scaling Considerations (Pertimbangan Skala) ]
  • Performance Degradation Signals (response time > 500ms P95)
  • Database Optimization Triggers (query time > 100ms, N+1 queries)
  • Infrastructure Cost Monitoring (cost per active user)
  • Team Expansion Indicators (solo dev overload > 60 jam/minggu)
                                    │
                                    ▼
[ OUTPUT: 4 Dokumen Operasi Produk + 1 Panduan Referensi ]
```

---

## 2. Prinsip Product Operations untuk Solo Developer

Product Operations berbeda dari Development Operations (DevOps). Fokusnya bukan pada server uptime atau deployment speed, melainkan pada **kualitas keputusan produk yang diambil berdasarkan data riil**.

| Parameter | Development Phase (M06) | Operations Phase (M13) |
| :--- | :--- | :--- |
| **Metrik Utama** | Code coverage, build time, deployment frequency | Retention rate, feature adoption, NPS, revenue per user |
| **Siklus Kerja** | Sprint 1-2 minggu dengan deadline tetap | Continuous iteration tanpa deadline kaku, prioritas dinamis |
| **Decision Maker** | Solo dev (teknis) | Data + Solo dev (product thinking) |
| **Success Criteria** | Fitur selesai sesuai spesifikasi | Fitur meningkatkan metrik bisnis yang ditargetkan |
| **Tooling** | GitHub, IDE, CI/CD pipeline | Analytics dashboard, cohort analysis, A/B testing platform |

**Prinsip Emas**: Setiap keputusan penambahan fitur wajib menjawab: *"Metrik mana yang akan bergerak jika fitur ini berhasil?"*

---

## 3. Langkah demi Langkah Eksekusi

### Langkah 1: Metrics Baseline Collection (Baseline Metrik 30 Hari Pertama)

Setelah sistem live di produksi selama minimal 30 hari kalender, kumpulkan data baseline untuk semua metrik kunci.

#### 1.1 Kategori Metrik Wajib Diukur

| Kategori Metrik | Metrik Spesifik | Query/Tool |
| :--- | :--- | :--- |
| **Akuisisi (Acquisition)** | Sign-up rate, traffic source breakdown | Google Analytics, Plausible, Posthog |
| **Aktivasi (Activation)** | % users yang complete onboarding / first core action dalam 24 jam | Custom event tracking (Posthog, Mixpanel) |
| **Retensi (Retention)** | Day 1 / 7 / 30 / 90 retention rate | Cohort analysis SQL query |
| **Referral** | Viral coefficient (berapa user baru per existing user) | Referral tracking (jika ada program referral) |
| **Revenue** | MRR (Monthly Recurring Revenue), ARPU (Average Revenue Per User), LTV (Lifetime Value) | Stripe Dashboard / payment provider analytics |
| **Engagement** | DAU/MAU ratio, session duration, feature usage frequency | Posthog feature flags + event tracking |
| **Performance** | Response time P50/P95, error rate, uptime % | Sentry, Datadog, Vercel Analytics |

#### 1.2 Hitung Statistik Deskriptif

Untuk setiap metrik, hitung:
- **Mean (Rata-rata)**: Nilai rerata, sensitif terhadap outlier.
- **Median (Nilai Tengah)**: Lebih robust terhadap outlier, cocok untuk distribution skewed.
- **Percentiles (P50/P90/P95)**: Untuk metrik performa (response time), gunakan P95 sebagai SLA threshold.

**Contoh SQL Query untuk Retention Cohort**:
```sql
-- Day 7 Retention Rate
WITH cohorts AS (
  SELECT 
    user_id,
    DATE_TRUNC('day', created_at) AS cohort_date,
    DATE_TRUNC('day', last_active_at) AS active_date
  FROM users
  WHERE created_at >= NOW() - INTERVAL '60 days'
)
SELECT 
  cohort_date,
  COUNT(DISTINCT user_id) AS cohort_size,
  COUNT(DISTINCT CASE WHEN active_date >= cohort_date + INTERVAL '7 days' THEN user_id END) AS retained_users,
  ROUND(100.0 * COUNT(DISTINCT CASE WHEN active_date >= cohort_date + INTERVAL '7 days' THEN user_id END) / COUNT(DISTINCT user_id), 2) AS retention_rate_pct
FROM cohorts
GROUP BY cohort_date
ORDER BY cohort_date DESC;
```

#### 1.3 Benchmark Comparison

Bandingkan baseline Anda dengan standar industri:

| Jenis Produk | Day 1 Retention | Day 7 Retention | Day 30 Retention | NPS Score |
| :--- | :--- | :--- | :--- | :--- |
| **SaaS B2B** | 60–80% | 40–60% | 25–40% | 30–50 |
| **Consumer Mobile App** | 25–40% | 10–20% | 5–10% | 10–30 |
| **E-Commerce** | 20–35% | 10–15% | 5–10% | 20–40 |
| **Marketplace** | 30–50% | 15–25% | 10–15% | 25–45 |

**Sumber Benchmark**: Mixpanel Benchmark Report, Lenny's Newsletter SaaS Metrics, OpenView SaaS Benchmarks.

**Jika metrik Anda di bawah benchmark**: Prioritaskan perbaikan onboarding dan aktivasi (LANGKAH 2 feedback loop).

#### 1.4 Anomaly Detection Setup

Setup alert otomatis untuk mendeteksi pola abnormal:
```javascript
// Contoh: Cloudflare Workers script untuk alert anomali
async function checkDailyActiveUsers() {
  const today = await fetchDAU('2026-09-27');
  const baseline = await fetchAvgDAU(last30Days);
  
  if (today < baseline * 0.7) { // Drop > 30%
    await sendSlackAlert(`🚨 DAU drop anomaly: ${today} vs baseline ${baseline}`);
  }
}
```

**Output Langkah 1**: Dokumen **`docs/pm/METRICS_BASELINE_REPORT.md`** (gunakan template `templates/09-product-growth/METRICS_BASELINE_REPORT_TEMPLATE.md`).

---

### Langkah 2: Feedback Loop Automation (Otomasi Umpan Balik)

Feedback pengguna adalah sumber ide fitur terbaik. Otomasi pengumpulannya agar tidak bergantung pada ingatan manual.

#### 2.1 NPS Survey Automation (Net Promoter Score)

NPS mengukur loyalitas pengguna dengan satu pertanyaan: *"Seberapa besar kemungkinan Anda merekomendasikan produk ini ke rekan? (0–10)"*

**Klasifikasi**:
- **Promoters (9–10)**: Pengguna loyal, akan promosikan produk.
- **Passives (7–8)**: Puas tapi tidak antusias.
- **Detractors (0–6)**: Tidak puas, berpotensi churn.

**Formula NPS**: `NPS = % Promoters - % Detractors` (range: -100 hingga +100).

**Otomasi Trigger**:
```javascript
// Trigger NPS survey via email/in-app
const triggers = [
  { event: 'user_signup', delay: '7 days', campaign: 'NPS_Day7' },
  { event: 'user_signup', delay: '30 days', campaign: 'NPS_Day30' },
  { event: 'subscription_renewed', delay: '90 days', campaign: 'NPS_Quarterly' }
];
```

**Tool Recommendations**:
- **Gratis**: Typeform (50 responses/month), Google Forms + Zapier.
- **Berbayar**: Delighted ($99/month), SatisMeter, Refiner.

#### 2.2 In-App Feedback Widget

Pasang widget feedback di sudut aplikasi untuk menangkap feedback spontan.

**Implementasi Minimalis dengan Canny (Gratis untuk < 100 MAU)**:
```html
<!-- Embed Canny widget di dashboard app -->
<script>
  !function(w,d,i,s){function l(){if(!d.getElementById(i)){var f=d.getElementsByTagName(s)[0],e=d.createElement(s);e.type="text/javascript",e.async=!0,e.src="https://canny.io/sdk.js",f.parentNode.insertBefore(e,f)}}if("function"!=typeof w.Canny){var c=function(){c.q.push(arguments)};c.q=[],w.Canny=c,"complete"===d.readyState?l():w.attachEvent?w.attachEvent("onload",l):w.addEventListener("load",l,!1)}}(window,document,"canny-jssdk","script");
  
  Canny('render', {
    boardToken: 'YOUR_BOARD_TOKEN',
    basePath: '/feedback',
    ssoToken: user.cannyToken // Optional: SSO untuk link ke user account
  });
</script>
```

**Alternatif Lain**: UserVoice, Fider (open-source), custom form ke Notion database.

#### 2.3 Support Ticket Analysis

Agregasi tiket support ke dalam knowledge base:
1. **Tag Kategorisasi**: Bug, Feature Request, How-To, Payment Issue.
2. **Ekstraksi Pattern**: Jika > 5 tiket menanyakan hal yang sama → buat FAQ entry atau perbaiki UX.
3. **Automated Response Template**: Setup canned response untuk pertanyaan repetitif.

**Contoh Workflow dengan GitHub Issues**:
```bash
# Label otomatis berdasarkan keyword
gh api repos/{username}/{repo}/issues/123 -X PATCH \
  -f state='open' \
  -f labels='["bug", "high-priority"]'
```

**Output Langkah 2**: Setup sistem feedback aktif (NPS scheduled, widget live, tiket teraggregasi).

---

### Langkah 3: Cohort Analysis (Analisis Kelompok Pengguna)

Cohort analysis memecah pengguna berdasarkan waktu pendaftaran atau perilaku untuk menemukan pola retensi dan churn.

#### 3.1 Retention Cohorts (Kohor Retensi)

**Definisi**: Kelompok pengguna yang mendaftar di minggu/bulan yang sama, diikuti aktivitasnya dari waktu ke waktu.

**Contoh Tabel Cohort**:

| Signup Week | Cohort Size | Week 0 | Week 1 | Week 2 | Week 4 |
| :--- | ---: | ---: | ---: | ---: | ---: |
| 2026-09-01 | 120 | 100% | 45% | 32% | 18% |
| 2026-09-08 | 150 | 100% | 52% | 38% | 22% |
| 2026-09-15 | 180 | 100% | 48% | 35% | - |

**Insight**: Week 2 retention naik dari 32% → 38% setelah perbaikan onboarding. Teruskan improvement.

**Tool**: Mixpanel (paid), Posthog (open-source self-hosted), custom SQL query.

#### 3.2 Behavioral Segmentation

Kelompokkan pengguna berdasarkan perilaku aktual, bukan demografi:
- **Power Users**: Top 10% aktivitas (login harian, pakai advanced features).
- **Casual Users**: Login mingguan, pakai basic features only.
- **At-Risk Users**: Tidak login > 14 hari, tapi belum unsubscribe.
- **Churned Users**: Tidak aktif > 60 hari atau canceled subscription.

**Aksi Berbeda per Segmen**:
```javascript
// Contoh: Email retention campaign
if (segment === 'power_users') {
  sendEmail('invite_beta_feature'); // Engage dengan akses early
} else if (segment === 'at_risk') {
  sendEmail('win_back_offer'); // Diskon atau reminder value prop
}
```

#### 3.3 Churn Prediction Signals

Setup early warning system untuk users yang berpotensi churn:

**Churn Indicators**:
- `last_active_at > 14 days` untuk consumer app, `> 7 days` untuk daily-use tools.
- Login frequency menurun > 50% dari baseline.
- Tidak pernah pakai fitur kunci (activation milestone belum tercapai).

**Proactive Intervention**:
```sql
-- Identifikasi users at-risk
SELECT user_id, email, last_active_at, 
       DATE_PART('day', NOW() - last_active_at) AS days_inactive
FROM users
WHERE last_active_at < NOW() - INTERVAL '14 days'
  AND subscription_status = 'active'
ORDER BY days_inactive DESC;
```

Kirim targeted email: *"Kami melihat Anda belum login sejak [X] hari. Ada yang bisa kami bantu?"*

#### 3.4 Power User Identification

Power users adalah sumber feedback terbaik dan kandidat testimonial:
```sql
-- Identifikasi power users (top 10% aktivitas)
WITH activity_scores AS (
  SELECT user_id, 
         COUNT(*) AS total_sessions,
         SUM(session_duration_sec) AS total_time_sec
  FROM sessions
  WHERE created_at >= NOW() - INTERVAL '30 days'
  GROUP BY user_id
)
SELECT user_id, total_sessions, total_time_sec
FROM activity_scores
WHERE total_sessions >= (SELECT PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY total_sessions) FROM activity_scores);
```

**Aksi untuk Power Users**:
- Undang ke user advisory board (monthly call).
- Tawarkan akses beta feature early.
- Minta testimonial atau case study.

**Output Langkah 3**: Dashboard cohort analysis + list segmen pengguna terupdate mingguan.

---

### Langkah 4: Feature Prioritization (Prioritas Fitur dengan RICE)

RICE adalah framework scoring untuk memprioritaskan backlog fitur secara objektif.

*Panduan lengkap: `references/pm/RICE_SCORING_GUIDE.md`*

#### 4.1 RICE Framework

**Formula**:
```
RICE Score = (Reach × Impact × Confidence) / Effort
```

**Definisi Variabel**:
- **Reach**: Berapa banyak pengguna yang terpengaruh per kuartal? (angka absolut: 100, 500, 1000 users).
- **Impact**: Seberapa besar dampaknya per user? (skala: 0.25 = Minimal, 0.5 = Low, 1 = Medium, 2 = High, 3 = Massive).
- **Confidence**: Seberapa yakin estimasi ini? (persentase: 50% = Low, 80% = Medium, 100% = High).
- **Effort**: Berapa person-months (PM) untuk develop? (0.5 PM, 1 PM, 2 PM, dst).

**Contoh Perhitungan**:

| Fitur | Reach | Impact | Confidence | Effort (PM) | RICE Score |
| :--- | ---: | ---: | ---: | ---: | ---: |
| Dark Mode | 800 | 0.5 | 80% | 0.5 | 640 |
| Ekspor ke PDF | 500 | 1 | 100% | 1 | 500 |
| Multi-language | 1200 | 2 | 50% | 3 | 400 |
| Social Login (Google) | 600 | 0.5 | 80% | 0.5 | 480 |
| Advanced Analytics | 150 | 3 | 80% | 2 | 180 |

**Prioritas**: Kerjakan Dark Mode (score 640) terlebih dahulu.

#### 4.2 Feature ROI Calculation

Hitung return on investment untuk fitur berbayar:
```
Feature ROI = (Expected Incremental Revenue - Development Cost) / Development Cost × 100%
```

**Contoh**:
- **Fitur Premium Export**: Development cost Rp 10 juta (40 jam × Rp 250k/jam).
- **Expected Revenue**: 50 users upgrade ke tier berbayar (+Rp 50k/bulan) = Rp 2.5 juta/bulan.
- **Payback Period**: 10 juta / 2.5 juta = 4 bulan.
- **ROI per tahun**: (2.5 juta × 12 - 10 juta) / 10 juta = 200%.

Prioritaskan fitur dengan payback period < 6 bulan.

#### 4.3 Opportunity Cost Analysis

Setiap fitur yang dipilih = fitur lain yang tidak dikerjakan.

**Pertanyaan Wajib Dijawab**:
- Jika saya kerjakan Fitur A selama 2 bulan, fitur mana yang tertunda?
- Apakah Fitur A lebih urgent daripada memperbaiki retention rate yang sedang turun?

**Framework Decision Matrix**:

| Kuadran | Impact (Y-Axis) | Urgency (X-Axis) | Keputusan |
| :--- | :--- | :--- | :--- |
| **Q1: Do First** | High | High | Kerjakan segera (bug kritis, churn blocker) |
| **Q2: Schedule** | High | Low | Masuk roadmap kuartal depan (strategic features) |
| **Q3: Delegate/Automate** | Low | High | Cari solusi low-code atau outsource |
| **Q4: Drop** | Low | Low | Buang dari backlog |

**Output Langkah 4**: Backlog fitur dengan RICE score terurut, diupdate setiap bulan (gunakan `templates/09-product-growth/GROWTH_EXPERIMENTS_BACKLOG_TEMPLATE.md`).

---

### Langkah 5: Growth Experiments Backlog (Daftar Eksperimen)

Setiap fitur atau perubahan UX adalah eksperimen. Dokumentasikan hipotesis dan hasil untuk building institutional knowledge.

#### 5.1 Hypothesis Format (dari Modul 04 A/B Testing)

**Template Hipotesis Eksperimen**:
```
We believe that [CHANGE]
will result in [IMPACT]
for [TARGET SEGMENT]
because [RATIONALE].

We will measure success by [METRIC DEFINITION & THRESHOLD].
```

**Contoh**:
```
We believe that adding social proof badges ("1,234 users love this feature")
will result in 15% increase in feature adoption rate
for new users in their first 7 days
because users trust features validated by peers (source: Nielsen Norman Group social proof study).

We will measure success by tracking "feature_used" event Day 1-7 cohort comparison.
```

#### 5.2 Experiment Queue Prioritization

Sortir eksperimen berdasarkan:
1. **Expected Lift × Ease**: (Impact 1-10) × (Kemudahan implementasi 1-10).
2. **Strategic Alignment**: Apakah eksperimen ini align dengan North Star Metric (M00)?

**Contoh Queue**:

| Eksperimen | Expected Lift | Ease | Priority Score | Status |
| :--- | ---: | ---: | ---: | :--- |
| Email reminder untuk incomplete signups | 8 | 9 | 72 | Running |
| Personalized onboarding flow | 9 | 5 | 45 | Backlog |
| Gamifikasi poin loyalty | 6 | 3 | 18 | Backlog |

#### 5.3 Velocity Tracking

Target eksperimen untuk solo developer: **2–4 eksperimen per bulan** (1 eksperimen per 1-2 minggu).

**Tracking Metrics**:
- Jumlah eksperimen launched.
- Win rate (% eksperimen yang beat control).
- Average setup time (dari ide → launch).

**Learning Repository**: Dokumentasikan semua eksperimen (win, lose, neutral) di folder `docs/experiments/`:
```
docs/experiments/
├── 2026-09-experiment-001-social-proof-badges.md
├── 2026-09-experiment-002-email-drip-sequence.md
└── 2026-10-experiment-003-pricing-page-redesign.md
```

**Output Langkah 5**: Growth Experiments Backlog diupdate setiap sprint (gunakan `templates/09-product-growth/GROWTH_EXPERIMENTS_BACKLOG_TEMPLATE.md`).

---

### Langkah 6: Product Health Monitoring (Pemantauan Kesehatan Produk)

Monitoring berkelanjutan dengan ritme tetap mencegah drifting tanpa arah.

#### 6.1 Weekly Metrics Review (15 Menit Standup)

Setiap Senin pagi, review snapshot metrik:
- **Akuisisi**: Berapa signup baru minggu lalu vs target?
- **Aktivasi**: % signup yang complete onboarding?
- **Retensi**: Day 7 retention rate cohort minggu lalu?
- **Revenue**: MRR pertumbuhan vs churn?
- **Bug/Performance**: Ada spike error rate atau response time degradation?

**Format Dashboard Minimalis**:
```yaml
# Product Health Dashboard (Week 39, 2026)
Signups: 45 (target: 50) ❌
Activation Rate: 68% (baseline: 65%) ✅
Day 7 Retention: 42% (baseline: 40%) ✅
MRR: Rp 12.5 jt (growth: +8% MoM) ✅
P95 Response Time: 520ms (SLA: 500ms) ⚠️
Critical Bugs: 0 ✅
```

Tool: Notion database, Google Sheets auto-update via API, atau Grafana dashboard.

#### 6.2 Monthly OKR Check-In (Alignment ke M00 North Star)

Setiap akhir bulan, evaluasi progres terhadap **North Star Metric** (dari Modul 00):
- Apakah North Star Metric bergerak naik?
- Key Result mana yang on-track vs at-risk?
- Apakah ada blocker yang perlu di-escalate?

**Contoh North Star Metric**:
- **SaaS B2B**: Weekly Active Companies (WAC).
- **E-Commerce**: Gross Merchandise Value (GMV) per month.
- **Marketplace**: Successful Transactions per week.

**Template Monthly Review**:
```markdown
# Monthly OKR Review (September 2026)

North Star Metric: Weekly Active Companies (WAC)
- Target Q3: 120 WAC
- Actual: 105 WAC (88% of target) ⚠️

Key Results:
- KR1: Increase activation rate to 70% → Achieved 68% ✅
- KR2: Reduce churn to < 5%/month → Actual 6.2% ❌
- KR3: Launch 2 enterprise features → Launched 1/2 ⚠️

Blockers:
- High churn dari segment "small teams" → need better onboarding.

Actions Next Month:
- Prioritize churn reduction experiments.
- Interview churned users untuk qualitative insight.
```

#### 6.3 Quarterly Roadmap Review

Setiap kuartal, review roadmap:
- Fitur mana yang deliver impact vs yang tidak?
- Ada learnings baru dari eksperimen yang perlu pivot strategy?
- Apakah prioritas kuartal depan masih relevan?

**Decision Framework**:
- **Double Down**: Jika fitur/channel berhasil, alokasikan lebih banyak resource.
- **Pivot**: Jika hipotesis terbukti salah, ubah approach.
- **Kill**: Jika fitur tidak dipakai (< 5% adoption setelah 3 bulan), deprecate.

#### 6.4 Annual Strategy Refresh

Setiap tahun, revisit Modul 00 (Product Discovery & Strategy):
- Apakah Vision Statement masih relevan?
- Apakah kompetitor landscape berubah?
- Apakah ada peluang pasar baru atau ancaman baru (regulasi, teknologi)?

**Output Langkah 6**: Weekly dashboard + Monthly OKR doc + Quarterly roadmap update (gunakan `templates/09-product-growth/PRODUCT_HEALTH_DASHBOARD_TEMPLATE.md`).

---

### Langkah 7: Scaling Considerations (Pertimbangan Skala)

Monitoring signals untuk mengetahui kapan sistem atau tim perlu di-scale.

#### 7.1 Performance Degradation Signals

**Trigger Scale-Up Infrastruktur**:
- Response time P95 > 500ms secara konsisten.
- Database query time > 100ms untuk query kritis.
- N+1 query problem muncul di Sentry (banyak query untuk satu page load).
- CPU/Memory usage > 80% di jam peak.

**Aksi**:
- Database indexing audit (run `EXPLAIN ANALYZE` untuk slow queries).
- Caching layer (Redis untuk session/query results).
- CDN untuk static assets (Cloudflare, Vercel Edge).
- Vertical scaling server (upgrade tier) atau horizontal scaling (load balancer + multiple instances).

#### 7.2 Database Optimization Triggers

**Tanda Perlu Optimasi DB**:
- Tabel utama > 1 juta rows tanpa partitioning.
- Full table scan di query log.
- Backup time > 30 menit.

**Strategi Optimasi**:
```sql
-- Index untuk kolom yang sering di-filter/join
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_orders_created_at ON orders(created_at DESC);

-- Partitioning untuk tabel besar (time-series data)
CREATE TABLE events_2026_09 PARTITION OF events
FOR VALUES FROM ('2026-09-01') TO ('2026-10-01');
```

#### 7.3 Infrastructure Cost Monitoring

**Metrik Cost Efficiency**:
```
Cost per Active User (CAU) = Total Infrastructure Cost / Monthly Active Users
```

**Benchmark**:
- **Good**: CAU < $1 untuk consumer app, < $10 untuk B2B SaaS.
- **At Risk**: CAU meningkat tanpa pertumbuhan fitur/pengguna yang signifikan.

**Contoh Tracking**:
```markdown
# Infrastructure Cost (September 2026)
- Vercel: $120/month
- Supabase: $25/month
- Sentry: $29/month
- Total: $174/month

MAU: 350 users
CAU: $0.50/user ✅ (target: < $1)
```

**Aksi jika CAU meningkat tajam**:
- Audit unused resources (staging environment yang lupa dimatikan).
- Optimize asset delivery (compress images, lazy load).
- Negotiate pricing tier dengan vendor.

#### 7.4 Team Expansion Indicators

**Solo dev overload signals**:
- Work hours > 60 jam/minggu secara konsisten.
- Support tickets tidak terbalas > 48 jam.
- Roadmap velocity turun > 50% (karena kebanyakan fire-fighting).
- Critical bug fix tertunda karena tidak ada bandwidth.

**Opsi Scale Team**:
1. **Part-time VA/Support**: Outsource support tickets ke VA (Rp 2-3 jt/bulan).
2. **Freelance Developer**: Hire untuk fitur spesifik (project-based).
3. **Co-founder/Partner**: Jika revenue > Rp 50 jt/bulan dan sustainable.

**Output Langkah 7**: Monitoring dashboard scaling metrics (performance, cost, workload).

---

## 4. Adaptasi Berdasarkan Skala Proyek

| Parameter Operasi | Skala Kecil (MVP) | Skala Menengah (B2B SaaS) | Skala Besar (Enterprise) |
| :--- | :--- | :--- | :--- |
| **Frekuensi Review Metrik** | Mingguan (manual check) | Harian (automated dashboard) | Real-time (alerting system) |
| **Cohort Analysis** | Manual SQL query bulanan | Mixpanel/Posthog mingguan | Data warehouse + BI tool (Looker, Metabase) |
| **NPS Survey** | 1x per kuartal (manual email) | Otomatis trigger via Delighted | Enterprise NPS tool + CSAT tracking |
| **Experiment Velocity** | 1-2 per bulan | 2-4 per bulan | 1-2 per minggu (dedicated growth team) |
| **Scaling Threshold** | > 1000 MAU atau $5k MRR | > 10k MAU atau $50k MRR | > 100k MAU atau $500k MRR |

---

## 5. Artefak Keluaran (Deliverables)

> 📁 **ATURAN LOKASI BERKAS MUTLAK**:
> Seluruh dokumen metrik, eksperimen, dan product health WAJIB disimpan di dalam folder **`docs/pm/`** (untuk PM docs) dan **`docs/analytics/`** (untuk laporan metrik).

Modul ini menghasilkan 4 dokumen operasi + 1 panduan referensi:

1. **`docs/analytics/METRICS_BASELINE_REPORT.md`**: Laporan baseline metrik 30 hari pertama pasca-peluncuran (menggunakan `templates/09-product-growth/METRICS_BASELINE_REPORT_TEMPLATE.md`).
2. **`docs/pm/GROWTH_EXPERIMENTS_BACKLOG.md`**: Daftar eksperimen pertumbuhan dengan RICE score dan tracking hasil (menggunakan `templates/09-product-growth/GROWTH_EXPERIMENTS_BACKLOG_TEMPLATE.md`).
3. **`docs/pm/PRODUCT_HEALTH_DASHBOARD.md`**: Dashboard kesehatan produk untuk weekly/monthly/quarterly review (menggunakan `templates/09-product-growth/PRODUCT_HEALTH_DASHBOARD_TEMPLATE.md`).
4. **`docs/pm/SCALING_SIGNALS.md`**: Dokumentasi threshold dan trigger untuk scale infrastruktur/team.
5. **`references/pm/PM_CONTINUOUS_IMPROVEMENT_GUIDE.md`**: Panduan referensi lengkap untuk continuous iteration best practices.
6. **`references/pm/RICE_SCORING_GUIDE.md`**: Panduan RICE scoring dan prioritisasi backlog.

---

## 6. Kriteria Kelulusan [GATE] (Gate Exit Criteria)

[GATE] Modul 13 dinyatakan **BERHASIL & CONTINUOUS ITERATION BERJALAN** jika:

- [x] Baseline metrik 30 hari pertama telah dikumpulkan dan terdokumentasi (`METRICS_BASELINE_REPORT.md`).
- [x] Sistem feedback loop otomatis telah aktif (NPS survey scheduled, in-app widget live, tiket teraggregasi).
- [x] Cohort analysis dashboard atau SQL query tersedia dan dijalankan minimal 1x per bulan.
- [x] Backlog fitur telah diprioritaskan menggunakan RICE framework (`GROWTH_EXPERIMENTS_BACKLOG.md`).
- [x] Minimal 1 growth experiment telah launched dan hasilnya didokumentasikan.
- [x] Weekly metrics review ritual telah berjalan minimal 4 minggu berturut-turut.
- [x] Scaling signals monitoring system telah setup (performance, cost, workload alerts).

---

## 7. Integrasi dengan Modul Lain

Modul 13 adalah **titik konvergensi** dari seluruh siklus hidup produk:

| Modul Terkait | Integrasi ke M13 |
| :--- | :--- |
| **M00: Product Discovery & Strategy** | North Star Metric dari M00 menjadi anchor untuk OKR tracking dan prioritas fitur. |
| **M01: Idea & Feasibility** | OKR di M01 di-check progressnya setiap bulan di M13 monthly review. |
| **M04: UI/UX Prototyping** | Hypothesis format dari M04 A/B testing digunakan untuk growth experiments di M13. |
| **M06B: Analytics Implementation** | Event tracking dan dashboard di M06B menjadi data source untuk cohort analysis M13. |
| **M10: Deployment & Production** | Performance metrics dari M10 monitoring di-review di M13 scaling considerations. |
| **M12: Warranty & SLA** | Insiden dan support tickets dari M12 dianalisis di M13 untuk perbaikan produk. |

---

## 🔄 PROTOKOL CONTINUOUS ITERATION (LIFECYCLE CONTINUES)

Setelah seluruh tahapan Modul 13 setup:

### **LANGKAH 0: VERIFIKASI EKSISTENSI BERKAS (BLOCKING CHECK)**

**WAJIB DILAKUKAN SEBELUM DECLARE SETUP COMPLETE**:

1. **Cek keberadaan file output** menggunakan salah satu metode:
   - PowerShell: `Test-Path -LiteralPath "docs/analytics/METRICS_BASELINE_REPORT.md"` → harus return `True`
   - Read tool: `read_file('docs/analytics/METRICS_BASELINE_REPORT.md')` → harus sukses tanpa error
   - PowerShell: `Test-Path -LiteralPath "docs/pm/GROWTH_EXPERIMENTS_BACKLOG.md"` → harus return `True`
   - Read tool: `read_file('docs/pm/GROWTH_EXPERIMENTS_BACKLOG.md')` → harus sukses tanpa error

2. **JIKA FILE TIDAK ADA**:
   - ❌ **STOP IMMEDIATELY** - jangan declare setup complete
   - ❌ **JANGAN tampilkan continuous iteration success** ke user
   - ✅ **REPORT ERROR** ke user:
     ```
     CRITICAL ERROR: File METRICS_BASELINE_REPORT.md atau GROWTH_EXPERIMENTS_BACKLOG.md tidak tercipta.
     Module 13 INCOMPLETE - continuous iteration setup FAILED.
     
     Kemungkinan penyebab:
     - Write permission denied pada folder docs/analytics/ atau docs/pm/
     - Path typo di tool call
     - Disk full
     
     Tolong investigasi issue ini sebelum declare setup complete.
     ```
   - ✅ **END TURN** dan tunggu user fix issue

3. **HANYA JIKA FILES EXIST**: Lanjut ke continuous iteration protocol di bawah

---

### **LANGKAH 1: CONTINUOUS ITERATION PROTOCOL**

1. **Verifikasi setup complete**:
   - [ ] `read_file('docs/analytics/METRICS_BASELINE_REPORT.md')` → Confirm baseline metrics documented
   - [ ] `read_file('docs/pm/GROWTH_EXPERIMENTS_BACKLOG.md')` → Confirm RICE-scored backlog exists
   - [ ] Confirm feedback loop active (NPS, widget, tickets)
   - [ ] Confirm weekly metrics review ritual established
2. **Ini adalah modul yang tidak pernah "selesai"**. Continuous iteration berjalan selama produk masih aktif.
3. Review dan update artefak M13 setiap kuartal untuk merefleksikan learnings baru.
4. **Jika Anda memutuskan untuk pivot atau sunset produk**, dokumentasikan keputusan di `docs/pm/PRODUCT_LIFECYCLE_DECISION.md` dengan data pendukung dari M13 metrics.

**SIKLUS HIDUP PRODUK LENGKAP**: M00 → M01 → ... → M12 → **M13 (Continuous Loop)** → (Pivot/Scale/Sunset Decision).
