# Case Study: Internal CRM for Real Estate Agency

**Project**: Customer Relationship Management untuk Agen Properti  
**Timeline**: 4 minggu (28 hari kerja)  
**Budget**: Rp 60.000.000  
**Team**: 1 solo developer  
**Tech Stack**: Laravel 11 + MySQL + Livewire + Filament Admin

---

## Executive Summary

**Problem**: Real estate agency mengelola leads via spreadsheet Excel (data loss risk, no collaboration, manual follow-up)

**Solution**: Internal CRM dengan lead tracking, property database, automated follow-up reminders

**Results**:
- ✅ **Launch**: 28 hari (on-time)
- ✅ **Users**: 8 agents + 2 managers
- ✅ **Leads managed**: 420 leads (3 bulan pertama)
- ✅ **Conversion rate**: 12% → 18% (+50% improvement)
- ✅ **Follow-up response time**: 2 hari → 6 jam (75% reduction)
- ✅ **Data loss incidents**: 3/bulan → 0 (100% elimination)

---

## Project Background

**Client**: Mid-sized real estate agency (10 staff, Rp 2.4B annual revenue)

**Pain Points**:
1. Leads tersebar di WhatsApp, email, Excel (no single source of truth)
2. Agent lupa follow-up leads (opportunity loss)
3. Manager tidak bisa track agent performance
4. Data lead hilang saat staff keluar
5. Duplikasi leads antar agents (internal conflict)

**Business Impact**:
- Estimated lost revenue: Rp 300M/year (dari late follow-up)
- Staff time wasted: 2 jam/hari per agent (manual data entry)

---

## Budget & Timeline

### Budget Breakdown
```
Development        : Rp 48.000.000 (80%)
Server + Domain    : Rp  3.000.000 ( 5%)
SMS Gateway        : Rp  2.000.000 ( 3%)
Training           : Rp  2.000.000 ( 3%)
Buffer             : Rp  5.000.000 ( 9%)
─────────────────────────────────────
Total              : Rp 60.000.000
```

### Timeline
```
Week 1: Discovery + Legal      (7 hari)
Week 2: Design + Specs         (7 hari)
Week 3: Development            (7 hari)
Week 4: Testing + Deployment   (7 hari)
```

---

## Module Execution

### M00: Product Discovery (1 hari)

**Method**: Stakeholder interviews (2 agents + 1 manager)

**Key Findings**:
- **Lead sources**: 60% WhatsApp, 30% walk-in, 10% website form
- **Average leads**: 50/month per agent
- **Conversion cycle**: 30-90 hari (property sale)
- **Critical features**: Lead assignment, follow-up reminders, property matching

**Market Research**: Existing CRM (Salesforce, Zoho) terlalu kompleks & mahal (Rp 15M/year)

**Decision**: Build custom internal CRM (TCO 4x lebih murah dalam 3 tahun)

---

### M01: Idea & Feasibility (1 hari)

**Deliverable**: `docs/pm/IDEA_BRIEF.md`

**Feasibility Score**:
- **Technical**: 9/10 (standard CRUD + notifications)
- **Business**: 10/10 (clear ROI, Rp 300M opportunity)
- **Resource**: 8/10 (solo dev feasible, 4 weeks realistic)
- **Risk**: 7/10 (medium complexity, manageable)

**Overall**: 34/40 (85%) → **GREEN LIGHT**

---

### M02: Discovery & Scope (2 hari)

**Deliverable**: `docs/pm/SCOPE_STATEMENT.md`

**Must-Have Features** (MoSCoW):
- **Leads Management**: Create, assign, status tracking (New → Contacted → Qualified → Won/Lost)
- **Property Database**: Listings (dijual/disewa), price, location, agent assignment
- **Follow-up Reminders**: Auto-notification via WhatsApp/SMS (1 hari, 3 hari, 7 hari intervals)
- **Agent Dashboard**: My leads, upcoming follow-ups, conversion stats
- **Manager Dashboard**: Team performance, lead pipeline, revenue forecast
- **User Management**: Role-based access (Agent, Manager, Admin)

**Should-Have** (defer to v2):
- Email marketing integration
- Document management (SOW, contracts)
- Commission calculator

**Could-Have**:
- Mobile app (use mobile web responsive first)
- AI lead scoring

**Won't-Have**:
- Accounting integration
- Multi-branch support (single office only)

**Out-of-Scope**:
- ❌ Public-facing website
- ❌ Payment processing
- ❌ Property portal integration (99.co, Rumah123)

**Acceptance Criteria**:
- Agent dapat input lead baru dalam <2 menit
- Manager dapat view semua leads & assign agents dalam 1 dashboard
- System send otomatis follow-up reminder via WhatsApp
- Zero data loss (database backup daily)

---

### M03: Legal & SOW (2 hari)

**Deliverable**: `contracts/SOW_CONTRACT.md`

**Contract Type**: Fixed-price with milestone payments

**Payment Terms**:
- DP 30%: Rp 18.000.000 (signing)
- Progress 40%: Rp 24.000.000 (week 3 demo)
- Final 30%: Rp 18.000.000 (UAT sign-off)

**Scope Lock**: No feature changes after specs approved (change request = additional invoice)

**IP Ownership**: Client owns source code + database after final payment

**Warranty**: 90 hari bug fixes + on-site training (2 sesi @ 2 jam)

**SLA Post-Warranty**: Rp 5.000.000/bulan (20 hours support, bug fixes, feature requests)

**Data Privacy**: Compliant dengan UU PDP No. 27/2022 (data lead adalah data pribadi)

---

### M04: UI/UX Design (3 hari)

**Deliverable**: `DESIGN.md` + Figma prototype

**Design System**:
```css
/* Design tokens */
--color-primary: #1E40AF (blue - trust)
--color-success: #16A34A (green - won deals)
--color-warning: #F59E0B (yellow - pending)
--color-danger: #DC2626 (red - lost deals)
--font-heading: Inter Bold
--font-body: Inter Regular
```

**Key Screens** (8 screens):
1. **Login** (email + password)
2. **Agent Dashboard** (lead count, follow-up tasks, recent activity)
3. **Lead List** (table with filters: status, agent, date range)
4. **Lead Detail** (contact info, property interest, follow-up history, notes)
5. **Lead Create/Edit** (form with validation)
6. **Property List** (grid view with search)
7. **Property Detail** (photos, specs, price, agent assignment)
8. **Manager Dashboard** (team KPIs, lead pipeline chart, top performers)

**UI Framework**: Filament Admin (Laravel package, pre-built admin UI)

**Mobile**: Responsive breakpoints (agents use tablets di lapangan)

---

### M05: Architecture & Specs (3 hari)

**Deliverable**: `docs/specs/FSD.md`

**Tech Stack Rationale**:
```
Backend:   Laravel 11 (mature, rapid dev, large community)
Frontend:  Livewire 3 (reactive without Vue/React complexity)
Admin UI:  Filament 3 (pre-built CRUD, saves 10+ days)
Database:  MySQL 8 (familiar to client IT team)
Queue:     Laravel Queue (database driver, SMS/WhatsApp jobs)
SMS/WA:    Fonnte API (Rp 150/SMS, Rp 200/WA)
Hosting:   VPS (Hetzner, Rp 300K/month)
Monitoring: Laravel Telescope (debugging)
Backup:    Daily mysqldump to S3 (R2)
```

**Database Schema** (7 tables):
```sql
CREATE TABLE users (
  id BIGINT PRIMARY KEY,
  name VARCHAR(255),
  email VARCHAR(255) UNIQUE,
  role ENUM('admin', 'manager', 'agent'),
  password VARCHAR(255),
  created_at TIMESTAMP
);

CREATE TABLE leads (
  id BIGINT PRIMARY KEY,
  name VARCHAR(255),
  phone VARCHAR(20),
  email VARCHAR(255),
  source ENUM('whatsapp', 'walk_in', 'website', 'referral'),
  status ENUM('new', 'contacted', 'qualified', 'won', 'lost'),
  property_interest TEXT,
  budget_min INT,
  budget_max INT,
  assigned_agent_id BIGINT,
  next_follow_up_at TIMESTAMP,
  created_at TIMESTAMP,
  updated_at TIMESTAMP,
  FOREIGN KEY (assigned_agent_id) REFERENCES users(id)
);

CREATE TABLE properties (
  id BIGINT PRIMARY KEY,
  title VARCHAR(255),
  type ENUM('house', 'apartment', 'land', 'commercial'),
  listing_type ENUM('sale', 'rent'),
  price BIGINT,
  location VARCHAR(255),
  bedrooms INT,
  bathrooms INT,
  land_area INT, -- m2
  building_area INT, -- m2
  description TEXT,
  images JSON, -- array of URLs
  agent_id BIGINT,
  status ENUM('available', 'sold', 'rented'),
  created_at TIMESTAMP,
  FOREIGN KEY (agent_id) REFERENCES users(id)
);

CREATE TABLE follow_ups (
  id BIGINT PRIMARY KEY,
  lead_id BIGINT,
  agent_id BIGINT,
  type ENUM('call', 'whatsapp', 'meeting', 'email'),
  notes TEXT,
  next_action_at TIMESTAMP,
  completed_at TIMESTAMP,
  created_at TIMESTAMP,
  FOREIGN KEY (lead_id) REFERENCES leads(id),
  FOREIGN KEY (agent_id) REFERENCES users(id)
);

CREATE TABLE notifications (
  id BIGINT PRIMARY KEY,
  user_id BIGINT,
  type ENUM('follow_up_reminder', 'lead_assigned', 'lead_won'),
  message TEXT,
  read_at TIMESTAMP,
  created_at TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id)
);
```

**API Integration**:
- **Fonnte API**: POST /send (WhatsApp/SMS)
- **Backup**: AWS S3-compatible (Cloudflare R2)

**Security**:
- HTTPS (Let's Encrypt SSL)
- CSRF protection (Laravel default)
- SQL injection prevention (Eloquent ORM)
- Password hashing (bcrypt cost 12)
- Role-based access control (Spatie Permission package)

---

### M06: Development (14 hari)

**Week 1 (Backend + Auth)**:
- Day 1-2: Laravel setup, migrations, seeders (test data)
- Day 3-4: Authentication (Laravel Breeze), role permissions
- Day 5-6: Lead CRUD (Eloquent models, relationships)
- Day 7: Property CRUD

**Week 2 (Features + Automation)**:
- Day 8-9: Follow-up tracking, notes, timeline
- Day 10: Automated follow-up reminders (queue jobs)
- Day 11: WhatsApp/SMS integration (Fonnte)
- Day 12-13: Dashboard (charts with LaravelDaily Charts)
- Day 14: Manager reports (lead pipeline, conversion rates)

**Tech Highlights**:

**Filament Resources** (rapid CRUD generation):
```php
php artisan make:filament-resource Lead --generate
// Generates: LeadResource.php, CreateLead.php, EditLead.php, ListLeads.php
```

**Follow-up Reminder Job**:
```php
// app/Jobs/SendFollowUpReminder.php
class SendFollowUpReminder implements ShouldQueue
{
    public function handle()
    {
        $dueFollowUps = FollowUp::where('next_action_at', '<=', now())
            ->whereNull('completed_at')
            ->with('lead', 'agent')
            ->get();

        foreach ($dueFollowUps as $followUp) {
            // Send WhatsApp via Fonnte
            Http::post('https://api.fonnte.com/send', [
                'target' => $followUp->agent->phone,
                'message' => "Reminder: Follow up {$followUp->lead->name} ({$followUp->lead->phone})",
                'token' => config('services.fonnte.token'),
            ]);

            // Create notification
            Notification::create([
                'user_id' => $followUp->agent_id,
                'type' => 'follow_up_reminder',
                'message' => "Follow up {$followUp->lead->name}",
            ]);
        }
    }
}
```

**Scheduled Task** (Laravel Cron):
```php
// app/Console/Kernel.php
protected function schedule(Schedule $schedule)
{
    $schedule->job(new SendFollowUpReminder)->hourly();
    $schedule->command('backup:run')->daily();
}
```

---

### M07: Quality Assurance (3 hari)

**Testing Strategy**: Manual + Feature tests

**Test Coverage**:
- **Feature Tests**: Lead CRUD, property CRUD, follow-up reminders (PHPUnit)
- **Manual Tests**: End-to-end user flows (8 agents)

**Test Results**:
- 24 feature tests, all passing
- 12 bugs found during manual testing (8 fixed immediately, 4 deferred to v2)

**Critical Bugs Fixed**:
- **S1**: Follow-up job tidak send WhatsApp (API token typo)
- **S1**: Manager tidak bisa assign lead ke agent (permission missing)
- **S2**: Lead status tidak update saat follow-up completed
- **S2**: Property filter by price range broken (SQL query error)

---

### M08: Data Migration (2 hari)

**Source Data**: Excel spreadsheet (520 leads historis, 80 properties)

**Migration Script**:
```php
php artisan make:command MigrateExcelLeads

// Import leads with Excel package
Excel::import(new LeadsImport, 'leads.xlsx');

// Assign agents round-robin
$agents = User::where('role', 'agent')->get();
foreach ($leads as $index => $lead) {
    $lead->assigned_agent_id = $agents[$index % $agents->count()]->id;
    $lead->save();
}
```

**Data Validation**: 
- 520 leads imported
- 18 duplicates removed (same phone number)
- Final count: 502 unique leads

---

### M09: UAT (2 hari)

**Testers**: 3 agents + 1 manager

**UAT Scenarios** (15 scenarios):
- ✅ Agent login, view my leads
- ✅ Create new lead (dari WhatsApp inquiry)
- ✅ Assign lead to another agent (manager only)
- ✅ Add follow-up note, schedule next action
- ✅ Mark follow-up as completed
- ✅ Receive WhatsApp reminder 1 hari before follow-up
- ✅ Change lead status (New → Qualified → Won)
- ✅ Search properties by location, price, type
- ✅ View property detail, assign to lead
- ✅ Manager view team dashboard (lead count, conversion rate)
- ✅ Manager export leads to Excel
- ✅ View notification bell (unread follow-ups)
- ✅ Update own profile (phone, password)
- ✅ Admin add new user (agent)
- ✅ Check data persistence after page refresh

**Sign-off**: Client approved with 2 minor UI tweaks (font size, button color)

---

### M10: Deployment (2 hari)

**Hosting**: Hetzner VPS (CPX31: 4 vCPU, 8GB RAM, Rp 450K/month)

**Server Setup**:
```bash
# Ubuntu 22.04
sudo apt update
sudo apt install nginx php8.3-fpm mysql-server redis-server

# Laravel Forge (automated deployment)
# Connected to GitHub repo
# Push to main branch = auto-deploy
```

**Environment**:
```bash
APP_ENV=production
APP_DEBUG=false
DB_HOST=localhost
DB_DATABASE=crm_realestate
QUEUE_CONNECTION=redis
FONNTE_TOKEN=xxx
```

**Pre-Launch Checklist**:
- ✅ Domain DNS pointed (crm.agenproperti.com)
- ✅ SSL certificate installed (Let's Encrypt)
- ✅ Production database migrated (502 leads)
- ✅ Queue worker active (supervisor)
- ✅ Cron job scheduled (hourly reminders)
- ✅ Daily backup to R2 configured
- ✅ Laravel Telescope enabled (debugging)

**Launch**: 2026-09-25 (28 hari on-time)

---

### M11: Handover & Training (3 hari)

**Training Sessions** (2 sesi):
1. **Agent Training** (2 jam): Lead input, follow-up tracking, property search
2. **Manager Training** (2 jam): Team dashboard, lead assignment, reports

**Deliverables**:
- ✅ `docs/USER_MANUAL.md` (30 halaman, screenshot per fitur)
- ✅ Admin credentials (3 roles: admin, manager, agent)
- ✅ Database backup procedure
- ✅ Server access (SSH, Forge dashboard)

**BAST Signed**: 2026-09-28  
**Final Payment**: Received 2026-09-30

---

### M12: Warranty & Support (90 hari)

**Warranty Period**: 90 hari (hingga 2026-12-28)

**Support Provided**:
- Bug fixes: 5 minor bugs (UI glitches, notification delays)
- Feature requests deferred to v2: 3 (email integration, commission calculator)
- On-call support: 2 jam/minggu rata-rata

**Post-Warranty SLA**: Client subscribe Rp 5M/bulan (started 2027-01-01)

---

## Results & Impact

### Quantitative Metrics (3 Months Post-Launch)

**Lead Management**:
- **Total leads**: 420 (vs 380 pre-CRM, +10% karena agents lebih rajin input)
- **Conversion rate**: 18% (vs 12% pre-CRM, **+50% improvement**)
- **Closed deals**: 76 (vs 46 pre-CRM, **+65% increase**)
- **Revenue**: Rp 2.85B (3 bulan) vs Rp 1.8B (historical, **+58%**)

**Operational Efficiency**:
- **Follow-up response time**: 6 jam avg (vs 2 hari, **75% reduction**)
- **Data entry time**: 2 menit/lead (vs 10 menit manual Excel)
- **Manager oversight**: Real-time dashboard (vs weekly manual reports)
- **Data loss incidents**: 0 (vs 3/bulan, **100% elimination**)

**User Adoption**:
- **Daily active users**: 9/10 staff (90%)
- **Mobile usage**: 40% (agents di lapangan)
- **Average session**: 15 menit/hari per agent

---

### Qualitative Feedback

**Agent (4.5/5 satisfaction)**:
> "Sekarang gak pernah miss follow-up lagi. Reminder WhatsApp sangat membantu. Conversion naik karena follow-up tepat waktu."

**Manager (5/5 satisfaction)**:
> "Dashboard real-time game changer. Bisa langsung lihat siapa agent yang performa bagus, mana lead yang stuck. Sebelumnya harus manual tanya satu-satu."

**Owner**:
> "ROI balik dalam 2 bulan. Revenue naik 58%, productivity naik. Worth every penny."

---

## Lessons Learned

### What Worked ✅

1. **Filament Admin**: Saved 10+ days vs building admin UI from scratch
2. **Laravel Breeze**: Auth scaffold in 1 hour vs 1 day custom
3. **Queue Jobs**: Async WhatsApp sending (no blocking requests)
4. **On-site Training**: 2 sesi hands-on lebih efektif vs manual PDF
5. **Incremental Migration**: Import historis leads post-launch (not blocking)

### What Could Be Better ⚠️

1. **No automated E2E tests**: Manual UAT took 2 hari (Dusk would've saved time)
2. **WhatsApp API rate limit**: Hit 100 msg/hour cap (need upgrade plan)
3. **Mobile app**: Agents request native app (mobile web sufficient for now)
4. **Email integration**: Deferred to v2 but agents requested early

### What to Avoid ❌

1. **Over-customizing Filament**: Stick to defaults (custom UI ate 3 extra days)
2. **Real-time everything**: Not needed, hourly batch jobs sufficient
3. **Complex permissions**: Initially 10 roles, simplified to 3 (agent, manager, admin)

---

## Framework Application

**Modules Used**: 12/14 (86%)
- ✅ M00 (Product Discovery)
- ✅ M01 (Feasibility)
- ✅ M02 (Scope)
- ✅ M03 (SOW)
- ✅ M04 (Design)
- ✅ M05 (FSD)
- ✅ M06 (Development)
- ✅ M07 (QA)
- ✅ M08 (Migration)
- ✅ M09 (UAT)
- ✅ M10 (Deployment)
- ✅ M11 (Handover)
- ✅ M12 (Warranty)

**Skipped**:
- ❌ M13 (Operations - post-warranty only)

**Time vs Estimate**:
- Framework estimate: 29-478 jam (M06 guidance)
- Actual: 224 jam (28 days × 8 hours)
- **Accuracy**: Within range (mid-range, internal tool complexity)

---

## Tech Stack Retrospective

**Would use again**:
- ✅ Laravel 11 (excellent for internal tools, rapid dev)
- ✅ Filament 3 (saved massive time on admin UI)
- ✅ MySQL (familiar to client IT, easy handover)
- ✅ Livewire (reactive without heavy JS framework)
- ✅ Fonnte (reliable SMS/WhatsApp, Rp 150/msg affordable)

**Would change**:
- ⚠️ Add Laravel Dusk (automated browser tests)
- ⚠️ Use Laravel Horizon (Redis queue monitoring, not Telescope)
- ⚠️ Setup staging environment earlier (not week 3)

---

## v2 Roadmap

**Planned Features** (Q4 2026):
1. Email integration (Gmail/Outlook sync)
2. Document management (upload SOW, contracts)
3. Commission calculator (auto-calculate from closed deals)
4. AI lead scoring (predict conversion likelihood)
5. Multi-branch support (expansion to 2 cabang)

**Budget**: Rp 35.000.000 (20 hari development)

---

## Conclusion

Internal CRM launched **on-time, on-budget**, meningkatkan **conversion rate 50%** dan **revenue 58%** dalam 3 bulan. Laravel + Filament terbukti cocok untuk **internal tools dengan rapid development needs**.

**Key Success Factors**:
1. Clear pain points → focused feature set
2. Stakeholder buy-in (training sessions critical)
3. Proven tech stack (Laravel ecosystem mature)
4. Automated workflows (follow-up reminders = killer feature)
5. Data migration post-launch (not blocking deployment)

---

**Repo**: (Private - client confidential)  
**Date**: September 2026  
**Client Industry**: Real Estate  
**Project Type**: Internal CRM
