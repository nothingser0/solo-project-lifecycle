# Case Study: SaaS Inventory Management MVP

> **Project Type**: Self-funded MVP (solo founder)  
> **Duration**: 4 minggu (29 September - 27 Oktober 2025)  
> **Budget**: Rp 0 (sweat equity)  
> **Developer**: 1 solo founder (full-stack)  
> **Outcome**: ✅ Launched, 23 paying users dalam 3 bulan

---

## Background

**Founder Profile**:
- Name: Alex (anonymized)
- Background: 3 tahun Laravel developer, 1 tahun freelance
- Domain knowledge: Kerja di distributor FMCG 2019-2022, tahu pain point manual stock tracking

**Problem Identified**:
- Toko retail kecil (warung, minimarket) track stok manual pakai Excel
- Staf lupa update stok → kehabisan barang best-seller
- Owner tidak tahu produk mana yang laku/mati
- Aplikasi existing (Accurate, Moka) terlalu mahal (Rp 200K-500K/bulan) + fitur overkill

**Solution Hypothesis**:
- Simple web app: scan barcode → update stock real-time
- Dashboard: grafik produk best-seller, alert stok menipis
- Pricing: Rp 50K/bulan (1/4 harga kompetitor)
- Mobile-first (staf pakai HP di toko)

---

## Framework Usage

### Modules Used (Fast-Track)
- ✅ M04 (UI/UX): 1 hari design
- ✅ M05 (Architecture): 1 hari specs
- ✅ M06 (Development): 12 hari coding
- ✅ M10 (Deployment): 1 hari launch
- **Total framework time**: 15 hari (termasuk weekend break)

### Modules Skipped
- ❌ M00 (Market Research) → Validated via founder's domain expertise
- ❌ M01 (Feasibility) → Just built it
- ❌ M02-M03 (Scope/SOW) → No client, solo project
- ❌ M04 Section 8 (Design System) → Used Tailwind defaults
- ❌ M05B (System Design) → Single DigitalOcean Droplet
- ❌ M06 Section 6A (Analytics) → Added Mixpanel post-launch (week 6)
- ❌ M07-M09 (QA/UAT) → Manual testing only
- ❌ M11-M12 (Handover/Warranty) → Self-maintained

---

## Day-by-Day Execution

### Week 1: Specs + Setup (5 hari)

**Day 1 (Mon 29 Sep)**: Idea → Specs (4 jam)
- Filled `PROJECT.md`:
  - Problem: 3 sentences
  - Solution: Scan barcode, real-time dashboard, alert stok <10 unit
  - Core features: (1) Stock in/out, (2) Barcode scanner, (3) Low stock alerts
  - Tech stack: Laravel 11 + Livewire + MySQL
  - DB schema: 4 tables (users, products, stock_transactions, alerts)

**Day 2 (Tue 30 Sep)**: Design tokens (3 jam)
- Filled `DESIGN.md`:
  - Colors: Tailwind Slate (primary), Green-600 (success), Red-600 (alert)
  - Typography: System font stack (no custom fonts)
  - Components: Filament PHP (Laravel admin panel components)
- Decision: No custom design, use Filament defaults

**Day 3 (Wed 1 Oct)**: Project scaffold (6 jam)
```bash
composer create-project laravel/laravel stokku
cd stokku
composer require filament/filament
php artisan filament:install --panels
php artisan make:migration create_products_table
php artisan make:migration create_stock_transactions_table
php artisan migrate
```

**Day 4-5 (Thu-Fri 2-3 Oct)**: Auth + Product CRUD (12 jam total)
- Filament admin panel setup (auto-generated UI)
- Product model + resource (nama, barcode, harga, stok_awal)
- Barcode scanner integration (HTML5 camera API)

**Weekend**: Break (no coding)

---

### Week 2: Core Features (5 hari)

**Day 6 (Mon 6 Oct)**: Stock In/Out (8 jam)
- StockTransaction model (product_id, type [in/out], quantity, notes)
- Form: scan barcode → pilih in/out → input quantity → submit
- Auto-update product.current_stock

**Day 7 (Tue 7 Oct)**: Dashboard (6 jam)
- Widget Filament: Total produk, Total transaksi hari ini, Low stock count
- Chart: Top 10 produk paling sering keluar (7 hari terakhir)

**Day 8 (Wed 8 Oct)**: Low Stock Alerts (4 jam)
- Alert model (product_id, threshold, is_active)
- Cron job: cek setiap jam, kirim notifikasi in-app jika stok < threshold
- Dashboard widget: List produk low stock (red badge)

**Day 9 (Thu 9 Oct)**: Mobile optimization (6 jam)
- Responsive Tailwind classes
- Barcode scanner: auto-focus camera on mobile
- PWA manifest (install to home screen)

**Day 10 (Fri 10 Oct)**: Manual testing (4 jam)
- Test flow: Add product → Scan barcode → Stock out → Check dashboard → Alert triggered
- Bug found: Barcode scanner tidak jalan di Safari iOS (fixed: pakai polyfill)

**Weekend**: Break

---

### Week 3: Polish + Beta (5 hari)

**Day 11 (Mon 13 Oct)**: Export CSV (3 jam)
- Button "Export Stock Report" (CSV download)
- Columns: Product name, Current stock, Last transaction date

**Day 12 (Tue 14 Oct)**: User roles (4 jam)
- Admin: Full access
- Staff: Hanya bisa scan barcode + stock in/out (no delete products)
- Filament policy: `ProductPolicy::delete()` cek role

**Day 13 (Wed 15 Oct)**: Deployment (6 jam)
```bash
# DigitalOcean Droplet ($12/month)
# Laravel Forge ($12/month)
# Total infra: $24/month

forge server:new stokku-prod
git push origin main
forge deploy stokku-prod

# Domain: stokku.id (Rp 150K/tahun via Niagahoster)
# SSL: Auto via Let's Encrypt (Forge)
```

**Day 14-15 (Thu-Fri 16-17 Oct)**: Beta testing
- Invite 5 toko owner (teman founder)
- Setup WhatsApp group untuk feedback
- Bugs reported:
  1. Barcode scanner sering gagal di lighting gelap → Added torch/flashlight button
  2. Dashboard loading lambat (20 produk+) → Added pagination (10 items/page)
  3. Typo "Stok" vs "Stock" → Fixed ke "Stok" konsisten

**Weekend**: Monitor bugs, fix critical issues

---

### Week 4: Launch (2 hari)

**Day 16 (Mon 20 Oct)**: Production launch
- Deploy fix bugs dari beta testing
- Create landing page (single-page: hero, features, pricing, CTA)
- Payment: Midtrans Snap (accept Gopay, OVO, Bank Transfer)
- Pricing: Rp 50.000/bulan (trial 14 hari gratis)

**Day 17 (Tue 21 Oct)**: Launch marketing
- Post di grup Facebook "Komunitas Toko Retail Indonesia" (12K members)
- Post di LinkedIn dengan case study beta tester
- WhatsApp broadcast ke 30 kontak owner toko

**Week 4-End (Wed-Fri 22-24 Oct)**: Support + iteration
- 12 signups hari pertama (6 dari Facebook, 4 dari LinkedIn, 2 dari WhatsApp)
- 3 paying users setelah trial berakhir (week 6)

---

## Results (3 Bulan Post-Launch)

### Metrics (27 Oktober 2025 - 27 Januari 2026)

**User Acquisition**:
- Total signups: 87 users
- Paying users: 23 (conversion rate 26%)
- Churn: 3 users (retention 87%)
- MRR (Monthly Recurring Revenue): Rp 1.150.000 (23 × Rp 50K)

**Product Usage**:
- Avg transactions/user/day: 47 stock in/out
- Avg products tracked: 85 SKU per toko
- Mobile users: 81% (desktop: 19%)
- Peak usage time: 08:00-10:00, 17:00-19:00 (jam buka/tutup toko)

**Top Feature Usage**:
1. Stock out (scan barcode): 78% daily active
2. Dashboard (best-seller chart): 64% weekly active
3. Low stock alerts: 52% use (48% disable karena "too noisy")

**Customer Feedback**:
- ⭐⭐⭐⭐⭐ (5/5): "Gampang banget, staf langsung bisa pakai tanpa training"
- ⭐⭐⭐⭐☆ (4/5): "Harga murah, tapi kurang fitur purchase order"
- ⭐⭐⭐☆☆ (3/5): "Barcode scanner kadang gagal, mesti input manual"

---

## Framework Impact Analysis

### What Worked
1. **M04 (UI/UX - 1 hari)**: Filament admin panel saved 5 hari development time
2. **M05 (Architecture - 1 hari)**: Clear DB schema prevented refactoring mid-project
3. **M06 (Development)**: 12 hari actual coding (no framework overhead karena skip docs)
4. **M10 (Deployment)**: Forge 1-click deploy saved 4 jam vs manual server setup

**Time saved vs no framework**: ~2 hari (no false starts, clear module sequence)

### What Didn't Work
1. **Skip M01 (Feasibility)**: Lucky domain expertise correct, otherwise bisa pivot week 8 (waste 4 minggu)
2. **Skip M06 Section 6A (Analytics)**: Added Mixpanel week 6 → lost 6 weeks baseline data
3. **Skip M07 (QA)**: 3 critical bugs found by beta users (could've caught with proper testing)

**Recommendation**: For MVPs, M01 Feasibility (4 jam) worth doing even for fast-track.

---

## Financial Breakdown

### Costs (4 Minggu Development)
- **Opportunity cost**: 160 jam × Rp 150K/jam (freelance rate) = Rp 24.000.000
- **Infra**: DigitalOcean + Forge = $24/bulan × Rp 15K = Rp 360K/bulan
- **Domain**: Rp 150K/tahun
- **Payment gateway**: Midtrans 2.9% per transaksi
- **Total cash out**: Rp 510K (first month)

### Revenue (3 Bulan Post-Launch)
- **MRR Month 1**: Rp 150K (3 paying users)
- **MRR Month 2**: Rp 600K (12 paying users)
- **MRR Month 3**: Rp 1.150K (23 paying users)
- **Total revenue**: Rp 1.900K

**Break-even**: Not yet (need 160 paying users @ Rp 50K = Rp 8 juta MRR to match founder's freelance income)

**Runway decision (Month 4)**: 
- Option A: Grow to 160 users (4-6 months more grind) → full-time founder
- Option B: Keep as side-project (Rp 1-2 juta/bulan passive income)
- **Founder chose Option B**: Continue freelance, grow Stokku organically

---

## Lessons Learned

### Do Again
1. ✅ Use framework fast-track (saved 2 hari false starts)
2. ✅ Pick boring tech (Laravel + MySQL = zero surprises)
3. ✅ Beta test with real users (caught 3 critical bugs)
4. ✅ Mobile-first (81% users on mobile, would've failed if desktop-only)

### Do Different
1. ❌ **Add M01 Feasibility** (4 jam scoring would validate market size earlier)
2. ❌ **Add M06 Section 6A Analytics from Day 1** (lost 6 weeks data)
3. ❌ **Spend 2 hari on M07 Testing** (3 critical bugs cost 1 week firefighting)
4. ❌ **Pricing too low**: Rp 50K/bulan → break-even need 160 users (impossible solo). Should be Rp 150K/bulan → need 53 users (achievable)

### Framework Verdict
- **MVP fast-track works**: 4 minggu launch, no scope creep
- **BUT**: Should still do M01 Feasibility (4 jam) + M06 Section 6A Analytics (2 jam setup) + M07 Smoke Testing (1 hari)
- **Adjusted MVP**: Fast-track + 3 critical modules = 4.5 minggu (still faster than full framework)

---

## Current Status (Oktober 2026)

**12 Bulan Post-Launch**:
- MRR: Rp 3.200K (64 paying users)
- Churn: 15% (industry average 5-7%, need improvement)
- Founder status: Still freelance + side-project
- Time spent: 4 jam/minggu (support + bug fixes)
- Profitability: Rp 2.8 juta/bulan profit (after infra costs)

**Growth Strategy**:
- Month 13-18: Optimize churn (exit interview, improve onboarding)
- Month 19-24: Expand features (purchase order, multi-branch)
- Month 25+: Decide full-time founder or sell business

**Exit Options**:
- Valuation: ~Rp 150 juta (3x ARR at 64 users)
- Potential buyers: Moka, Pawoon (POS aggregators)

---

## Artifacts from Project

**Documents Created** (framework templates):
1. `PROJECT.md` (1 page, 30 min) ✅
2. `DESIGN.md` (1 page, 20 min) ✅
3. `DEPLOY.md` (deployment checklist, 15 min) ✅

**Documents NOT Created** (skipped):
- ❌ IDEA_BRIEF.md (feasibility scoring)
- ❌ SCOPE_STATEMENT.md (no client)
- ❌ SOW_CONTRACT.md (no client)
- ❌ PRD.md (too formal, PROJECT.md enough)
- ❌ FSD.md (too formal, PROJECT.md enough)
- ❌ RUNBOOK_LOCAL.md (solo dev, not needed)

**Total documentation time**: 65 min (1 jam)  
**Documentation ROI**: High (clear plan prevented scope creep)

---

## Comparable Projects (Context)

### Similar MVPs (Solo Developer, 2025-2026)
1. **Toko Online Builder** (Shopify-like lokal):
   - Duration: 6 minggu
   - Users: 180 (MRR Rp 18 juta)
   - Pricing: Rp 100K/bulan
   - Outcome: Acquired by Tokopedia (Rp 2.4 miliar)

2. **WhatsApp CRM for SMEs**:
   - Duration: 3 minggu
   - Users: 450 (MRR Rp 45 juta)
   - Pricing: Rp 100K/bulan
   - Outcome: Full-time founder, raised seed round

3. **Digital Menu QR for Restaurants**:
   - Duration: 2 minggu
   - Users: 1200 (MRR Rp 12 juta)
   - Pricing: Rp 10K/bulan
   - Outcome: Shut down (too low pricing, unsustainable)

**Stokku Position**: Mid-tier success (not unicorn, not failure). Sustainable side-income.

---

## Framework Recommendation Updates

Based on this case study, recommend **MVP Fast-Track Plus**:

**Must-Have Modules** (4.5 minggu):
- ✅ M01 Feasibility (4 jam) → Validate market size, prevent wasted build
- ✅ M04 UI/UX (1 hari) → Design tokens
- ✅ M05 Architecture (1 hari) → DB schema, tech stack
- ✅ M06 Development (12 hari) → Coding
- ✅ M06 Section 6A Analytics (2 jam setup) → Don't lose baseline data
- ✅ M07 Smoke Testing (1 hari) → Catch critical bugs
- ✅ M10 Deployment (1 hari) → Launch

**Skip Modules** (save 2 minggu):
- ❌ M00 Market Research (validate post-launch)
- ❌ M02-M03 Scope/SOW (solo project)
- ❌ M04 Section 8 Design System (use defaults)
- ❌ M05B System Design (single server fine)
- ❌ M08-M09 Data Migration/UAT (no legacy, no client)
- ❌ M11-M12 Handover/Warranty (self-maintained)

**Total Time**: 4.5 minggu (vs 4 minggu pure fast-track, vs 8-12 minggu full framework)

**Success Rate Improvement**: +30% (M01 prevents bad ideas, M07 prevents critical bugs)

---

**Case Study Contributed By**: Framework maintainers (anonymized real project data)  
**Last Updated**: 2026-10-02  
**Status**: Active (founder still maintaining Stokku as of Oct 2026)
