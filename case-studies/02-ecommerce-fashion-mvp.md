# Case Study: E-Commerce Platform MVP

**Project**: B2C Online Store for Fashion Brand  
**Timeline**: 3 weeks (21 working days)  
**Budget**: Rp 45.000.000  
**Team**: 1 solo developer  
**Tech Stack**: Next.js 15 + Prisma + PostgreSQL + Midtrans

---

## Executive Summary

**Problem**: Fashion brand selling via Instagram DM (manual order processing, payment tracking chaos)

**Solution**: E-commerce MVP with catalog, cart, checkout, payment gateway

**Results**:
- ✅ **Launch**: 21 days (on-time)
- ✅ **First sale**: 2 days post-launch
- ✅ **Month 1**: 127 orders, Rp 18.4M GMV
- ✅ **Month 3**: 340 orders, Rp 52.1M GMV
- ✅ **Conversion rate**: 3.2% (industry average 1-2%)

---

## Project Constraints

### Budget Breakdown
```
Development        : Rp 35.000.000 (77%)
Domain + Hosting   : Rp  2.000.000 ( 4%)
Payment Gateway Fee: Rp  3.000.000 ( 7%)
Buffer (contingency): Rp  5.000.000 (12%)
─────────────────────────────────────
Total              : Rp 45.000.000
```

### Timeline
```
Week 1: Discovery + Design     (5 days)
Week 2: Development            (5 days)
Week 3: Testing + Deployment   (5 days)
Buffer: 6 days (contingency)
```

---

## Module Execution

### M00-M01: Product Discovery (Skipped)
**Decision**: Client already validated market (Instagram followers 12K, engagement 4%)

**Time saved**: 3 days

---

### M02: Discovery & Scope (1 day)

**Deliverable**: `docs/pm/SCOPE_STATEMENT.md`

**Must-Have Features**:
- Product catalog (50 SKUs)
- Shopping cart
- Checkout flow
- Midtrans payment (bank transfer, e-wallet, CC)
- Order management (admin panel)
- WhatsApp notification (order confirmation)

**Out-of-Scope** (defer to v2):
- ❌ User reviews
- ❌ Wishlist
- ❌ Product recommendations
- ❌ Loyalty points
- ❌ Multi-language
- ❌ Mobile app

**Acceptance Criteria**:
- Users can browse, add to cart, checkout within 3 minutes
- Admin can manage products, view orders in 1 panel
- Payment callback from Midtrans integrated (<5 minutes delay)

---

### M03: Legal & SOW (1 day)

**Deliverable**: `contracts/SOW_CONTRACT.md`

**Payment Terms**:
- DP 40%: Rp 18.000.000 (signing)
- Progress 30%: Rp 13.500.000 (week 2 demo)
- Final 30%: Rp 13.500.000 (launch + BAST)

**IP Ownership**: Transfer to client after final payment

**Warranty**: 60 days bug fixes (excluding third-party API issues)

---

### M04: UI/UX Design (2 days)

**Deliverable**: `DESIGN.md` + Figma prototype

**Design System**:
```css
/* Design tokens */
--color-primary: #E91E63 (brand pink)
--color-secondary: #212121 (black)
--font-heading: Poppins
--font-body: Inter
--spacing-unit: 8px
```

**Pages Designed** (6 pages):
1. Homepage (hero + featured products)
2. Product listing (grid, filters)
3. Product detail (gallery, size selector, add to cart)
4. Cart (line items, quantity, checkout button)
5. Checkout (shipping address, payment method)
6. Order confirmation (order ID, payment instructions)

**Responsive**: Mobile-first (70% traffic from Instagram mobile)

**Tool**: Figma (free tier) + Vercel v0 for component prototyping

---

### M05: Architecture & Specs (2 days)

**Deliverable**: `PROJECT_LITE.md` (used instead of PRD+FSD)

**Tech Stack Decision**:
```
Frontend:  Next.js 15 (App Router)
Backend:   Next.js API routes
Database:  PostgreSQL (Vercel Postgres)
ORM:       Prisma
Auth:      NextAuth.js (email/password)
Payment:   Midtrans Snap
Storage:   Cloudinary (product images)
Hosting:   Vercel (free tier → Pro on launch)
Monitoring: Vercel Analytics
```

**Database Schema** (6 tables):
```prisma
model Product {
  id          String   @id @default(cuid())
  name        String
  slug        String   @unique
  price       Int
  stock       Int
  imageUrl    String
  category    String
  createdAt   DateTime @default(now())
  orderItems  OrderItem[]
}

model Order {
  id              String   @id @default(cuid())
  userId          String?
  customerEmail   String
  customerName    String
  customerPhone   String
  shippingAddress String
  totalAmount     Int
  status          OrderStatus @default(PENDING)
  midtransOrderId String   @unique
  createdAt       DateTime @default(now())
  orderItems      OrderItem[]
}

enum OrderStatus {
  PENDING
  PAID
  SHIPPED
  DELIVERED
  CANCELLED
}

model OrderItem {
  id        String  @id @default(cuid())
  orderId   String
  productId String
  quantity  Int
  price     Int
  order     Order   @relation(fields: [orderId], references: [id])
  product   Product @relation(fields: [productId], references: [id])
}
```

**API Endpoints** (8 endpoints):
```
GET    /api/products           (list with filters)
GET    /api/products/[slug]    (detail)
POST   /api/cart               (add to cart, session-based)
GET    /api/cart               (get cart)
POST   /api/checkout           (create order + Midtrans token)
POST   /api/webhooks/midtrans  (payment callback)
GET    /api/orders             (user orders)
GET    /api/admin/orders       (admin panel)
```

**Non-Functional Requirements**:
- **Performance**: <2s page load (Lighthouse score >90)
- **Security**: HTTPS, CSRF protection, SQL injection prevention (Prisma ORM)
- **Availability**: 99.5% uptime (Vercel SLA)

---

### M06: Development (10 days)

**Week 1 (Backend)**:
- Day 1-2: Prisma setup, migrations, seed data (50 products)
- Day 3-4: API routes (products, cart, orders)
- Day 5: Midtrans integration + webhook

**Week 2 (Frontend)**:
- Day 6-7: Product listing + detail pages
- Day 8: Cart + checkout flow
- Day 9: Order confirmation + user dashboard
- Day 10: Admin panel (order management)

**Development Practices**:
- **Git**: Feature branches, conventional commits
- **Code**: TypeScript strict mode, Zod validation
- **Testing**: Manual smoke tests per feature (no automated tests for MVP)

**Challenges & Solutions**:

**Challenge 1**: Midtrans Snap popup blocked by Safari  
**Solution**: Added fallback redirect flow for iOS users

**Challenge 2**: Stock management race condition  
**Solution**: Optimistic locking with Prisma `update` + `where` version check

**Challenge 3**: Image upload slow (5MB photos from phone)  
**Solution**: Client-side compression with `browser-image-compression` before Cloudinary upload

---

### M07: Quality Assurance (2 days)

**Testing Approach**: Manual exploratory testing (no automated suite)

**Test Scenarios** (Critical Path):
1. **Happy Path**: Browse → Add to cart → Checkout → Pay → Order confirmed
2. **Payment Success**: Midtrans webhook triggers order status update
3. **Payment Failure**: User redirected to retry payment
4. **Stock Check**: Cannot checkout out-of-stock items
5. **Admin**: Can view/update order status

**Bugs Found** (7 total):
- **S1**: Payment webhook did not update order status (race condition fix)
- **S2**: Cart quantity could become negative (validation fix)
- **S3**: Mobile header menu did not close after click (CSS fix)
- **S2**: Product filter did not persist upon pagination (URL state fix)
- **S3**: Image lazy loading flicker (preload fix)
- **S3**: Typo in checkout form label (copy fix)
- **S3**: Footer social links broken (URL fix)

**All bugs fixed**: 1.5 days

---

### M08: Data Migration (0.5 days)

**Data**: 50 SKUs from client spreadsheet

**Migration Script**:
```typescript
// scripts/seed-products.ts
import { PrismaClient } from '@prisma/client';
import { parse } from 'csv-parse/sync';
import fs from 'fs';

const prisma = new PrismaClient();

const csv = fs.readFileSync('data/products.csv', 'utf-8');
const records = parse(csv, { columns: true });

for (const record of records) {
  await prisma.product.create({
    data: {
      name: record.name,
      slug: slugify(record.name),
      price: parseInt(record.price),
      stock: parseInt(record.stock),
      imageUrl: record.imageUrl, // Pre-uploaded to Cloudinary
      category: record.category,
    },
  });
}
```

**Validation**: Manual QA check of 50 products in staging

---

### M09: UAT (1 day)

**Testers**: Client + 2 staff members

**UAT Checklist** (10 scenarios):
- ✅ Browse products by category
- ✅ Search by product name
- ✅ Add to cart (multiple items)
- ✅ Update cart quantity
- ✅ Remove from cart
- ✅ Checkout with valid address
- ✅ Select payment method (bank transfer, e-wallet)
- ✅ Receive email order confirmation
- ✅ Check order status
- ✅ Admin view & update orders

**Sign-off**: Client approved launch

---

### M10: Deployment (1 day)

**Platform**: Vercel Pro ($20/month)

**Environment Variables**:
```bash
DATABASE_URL="postgresql://..."
MIDTRANS_SERVER_KEY="SB-Mid-server-..."
MIDTRANS_CLIENT_KEY="SB-Mid-client-..."
CLOUDINARY_URL="cloudinary://..."
NEXTAUTH_SECRET="..."
NEXTAUTH_URL="https://tokofashion.com"
```

**Pre-Launch Checklist**:
- ✅ Domain DNS pointed (tokofashion.com)
- ✅ SSL certificate auto-provisioned (Vercel)
- ✅ Production database migrated
- ✅ 50 products seeded
- ✅ Payment gateway production mode enabled
- ✅ Error monitoring active (Vercel Analytics)
- ✅ Backup scheduled (Vercel Postgres daily)

**Launch**: 2026-09-01 (3 weeks on-time)

---

### M11: Handover (0.5 days)

**Deliverables**:
- ✅ Source code (GitHub private repo)
- ✅ Admin credentials
- ✅ Vercel project access
- ✅ Midtrans dashboard access
- ✅ `docs/RUNBOOK_LOCAL.md` (local development guide)
- ✅ `docs/USER_MANUAL.md` (admin panel guide)

**BAST Signed**: 2026-09-02  
**Final Payment**: Received 2026-09-03

---

## Results & Metrics

### Month 1 (September 2026)
- **Orders**: 127
- **GMV**: Rp 18.400.000
- **AOV** (Average Order Value): Rp 145.000
- **Conversion Rate**: 3.2% (vs Instagram DM 0.8%)
- **Traffic**: 3,940 visitors (68% mobile)
- **Page Load**: 1.8s avg (Lighthouse 94)

### Month 3 (November 2026)
- **Orders**: 340 (+168%)
- **GMV**: Rp 52.100.000 (+183%)
- **AOV**: Rp 153.000 (+5%)
- **Conversion Rate**: 3.5%
- **Traffic**: 9,710 visitors (+146%)
- **Repeat Customers**: 23%

---

## Client Feedback

> "Previously it was completely manual via Instagram DM, frequently missing payment confirmations. Now everything is automated; the time I spend managing orders dropped from 5 hours/day to 30 minutes/day. ROI was recovered in 2.5 months!"  
> — Owner, Fashion Brand

---

## Lessons Learned

### What Worked ✅
1. **PROJECT_LITE over PRD+FSD**: Saved 4 hours, sufficient for MVP
2. **Midtrans Snap**: Out-of-box payment UI (vs custom integration 3+ days)
3. **Vercel deployment**: Zero DevOps time (vs VPS setup 2+ days)
4. **Mobile-first design**: Matched user behavior (70% mobile traffic)
5. **Conventional commits**: Easy rollback when payment webhook broke

### What Could Be Better ⚠️
1. **No automated tests**: Manual regression testing took 2 days (would've saved with test suite)
2. **Image optimization**: Should've used Next.js Image component from start (added week 2)
3. **Stock management**: Should've designed with concurrency in mind (fixed with optimistic locking)
4. **No staging environment**: Bugs found in production (added staging post-launch)

### What to Avoid ❌
1. **Over-engineering**: Almost added recommendation engine (would've delayed 1 week)
2. **Custom payment UI**: Midtrans Snap saved 3 days vs building from scratch
3. **Feature creep**: Client requested reviews mid-development (deferred to v2)

---

## Cost Breakdown (Actual)

```
Development (21 days @ Rp 1.5M/day): Rp 31.500.000
Domain (.com 1 year)                : Rp    200.000
Vercel Pro (3 months)               : Rp    900.000
Midtrans fee (2.9% of Rp 70M GMV)  : Rp  2.030.000
Cloudinary (image hosting)          : Rp    300.000
Contingency used (bug fixes OT)     : Rp  2.070.000
───────────────────────────────────────────────────
Total                               : Rp 37.000.000
Under budget                        : Rp  8.000.000
```

---

## Tech Stack Retrospective

**Would use again**:
- ✅ Next.js 15 (excellent DX, fast iteration)
- ✅ Prisma (type-safe, migrations easy)
- ✅ Vercel (deploy in 2 min, zero config)
- ✅ Midtrans Snap (payment UI out-of-box)

**Would change**:
- ⚠️ Add automated tests early (E2E with Playwright)
- ⚠️ Use Next.js Image component from start (manual optimization wasted 4 hours)
- ⚠️ Setup staging from day 1 (not post-launch)

---

## v2 Roadmap (Post-Launch)

**Planned for Month 4-6**:
1. Product reviews (boost social proof)
2. Wishlist (increase repeat visits)
3. Abandoned cart recovery (WhatsApp reminder)
4. Promo codes (seasonal campaigns)
5. Product recommendations (AI-based)

**Budget v2**: Rp 25.000.000 (15 days development)

---

## Framework Application

**Modules Used**: 11/14 (79%)
- ✅ M02 (Discovery)
- ✅ M03 (SOW)
- ✅ M04 (Design)
- ✅ M05 (Specs - PROJECT_LITE)
- ✅ M06 (Development)
- ✅ M07 (QA)
- ✅ M08 (Migration)
- ✅ M09 (UAT)
- ✅ M10 (Deployment)
- ✅ M11 (Handover)
- ✅ M12 (Warranty 60 days)

**Skipped**:
- ❌ M00 (Product Discovery - already validated)
- ❌ M01 (Feasibility - straightforward e-commerce)
- ❌ M13 (Ops - not needed for MVP)

**Time vs Estimate**:
- Framework estimate: 29-478 hours (M06 guidance)
- Actual: 168 hours (21 days × 8 hours)
- **Accuracy**: Within range (lower bound, solo dev efficiency)

---

## Conclusion

E-commerce MVP launched **on-time, under-budget**, generating **Rp 52M GMV** within 3 months. The Solo Project Lifecycle framework proved well-suited for **solo developer + client commercial projects**.

**Key Success Factors**:
1. Clear scope definition (M02 SCOPE_STATEMENT)
2. Legal protection (M03 SOW with milestone payments)
3. MVP mindset (defer non-critical features)
4. Proven tech stack (Next.js + Vercel + Midtrans)
5. Fast iteration (21-day execution)

---

**Repo**: (Private - client confidential)  
**Live**: https://tokofashion.com (anonymized)  
**Date**: September 2026
