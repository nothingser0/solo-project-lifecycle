# Sitemap & Navigation Structure

> **Purpose**: Define all pages, routes, and navigation hierarchy for the application.

**Project**: [Project Name]  
**Date**: [YYYY-MM-DD]  
**Author**: [Your Name]
**Scope Reference**: `docs/pm/SCOPE_STATEMENT.md` (RBAC & User Stories)  
**Tenant Architecture**: [Single-Tenant / Multi-Tenant / Hybrid]

---

## 1. Sitemap Overview

Total pages: [X screens/routes]  
Estimated implementation: [X days/weeks]  
Navigation depth: [X levels]

---

## 2. Public Routes (Unauthenticated)

| Route | Page Name | Screen ID | Purpose | Priority |
|:------|:----------|:----------|:--------|:--------:|
| `/` | Landing Page | SCR-01 | Homepage, value prop, CTA | P0 |
| `/about` | About | SCR-02 | Company info | P2 |
| `/pricing` | Pricing | SCR-03 | Plans & pricing table | P0 |
| `/features` | Features | SCR-04 | Feature showcase | P1 |
| `/contact` | Contact | SCR-05 | Contact form | P2 |
| `/login` | Login | SCR-06 | User authentication | P0 |
| `/register` | Sign Up | SCR-07 | User registration | P0 |
| `/forgot-password` | Password Reset | SCR-08 | Password recovery | P1 |

---

## 3. Authenticated Routes - Member / Customer / Client Role

| Route | Page Name | Screen ID | Purpose | Priority |
|:------|:----------|:----------|:--------|:--------:|
| `/dashboard` | Member Dashboard | SCR-09 | Main consumer/member dashboard | P0 |
| `/profile` | Profile | SCR-10 | Self profile & credentials | P1 |
| `/[resource]` | My Resources | SCR-11 | View own created resources | P0 |
| `/[resource]/new` | Create Resource | SCR-12 | Submit new resource | P0 |
| `/[resource]/:id` | Resource Detail | SCR-13 | View single own resource | P0 |
| `/[resource]/:id/edit` | Edit Resource | SCR-14 | Edit own draft resource | P0 |
| `/billing` | Billing & Subscription | SCR-15 | Invoices, payment method, subscription | P1 |
| `/notifications` | Notifications | SCR-16 | In-app alerts & reminders | P2 |

---

## 4. Authenticated Routes - Staff / Operator / Cashier Role

| Route | Page Name | Screen ID | Purpose | Priority |
|:------|:----------|:----------|:--------|:--------:|
| `/ops/workspace` | Operator Terminal / POS | SCR-17 | High-frequency daily operations terminal | P0 |
| `/ops/queue` | Operations Queue | SCR-18 | Pending jobs, tickets, or checkout queue | P0 |
| `/ops/transactions` | Shift Transactions | SCR-19 | View current shift transactions & totals | P1 |
| `/ops/stock-opname` | Blind Stock Opname | SCR-20 | Physical count entry without seeing book totals | P1 |

---

## 5. Authenticated Routes - Manager / Supervisor Role

| Route | Page Name | Screen ID | Purpose | Priority |
|:------|:----------|:----------|:--------|:--------:|
| `/manager/dashboard` | Branch/Team Dashboard | SCR-21 | Shift aggregation, sales, team KPIs | P0 |
| `/manager/approvals` | Approval Center | SCR-22 | Review discount overrides, voids, leave requests | P0 |
| `/manager/inventory` | Inventory Control | SCR-23 | Stock adjustments, supplier purchase orders | P1 |
| `/manager/reports` | Operational Reports | SCR-24 | Shift reconciliation, discrepancy reports | P1 |

---

## 6. Authenticated Routes - Admin / Owner / Superadmin Role

| Route | Page Name | Screen ID | Purpose | Priority |
|:------|:----------|:----------|:--------|:--------:|
| `/admin/overview` | Executive Dashboard | SCR-25 | Multi-branch financials, profit/loss, churn | P0 |
| `/admin/users` | User & RBAC Management | SCR-26 | Manage roles, invite staff, revoke permissions | P0 |
| `/admin/branches` | Branch / Tenant Config | SCR-27 | Branch settings, tax rate, printers, integrations | P1 |
| `/admin/audit-logs` | Security Audit Trail | SCR-28 | Immutable log of all sensitive actions & overrides | P1 |
| `/admin/settings` | Global System Settings | SCR-29 | Payment gateway keys, webhook configs, backups | P1 |

---

## 7. Role-Based Route Access Matrix (RBAC Alignment)

*Cross-checked with `SCOPE_STATEMENT.md` Section 3 (RBAC Matrix). Every route must define access level per role.*

| Route Path | Screen ID | Public / Guest | Member / Customer | Staff / Operator | Manager | Admin / Owner | Denial Redirect |
|:-----------|:---------:|:--------------:|:-----------------:|:----------------:|:-------:|:-------------:|:----------------|
| `/` | SCR-01 | Full | Full | Full | Full | Full | - |
| `/pricing` | SCR-03 | Full | Full | Full | Full | Full | - |
| `/login` | SCR-06 | Full | Redirect `/dashboard` | Redirect `/ops/workspace` | Redirect `/manager/dashboard` | Redirect `/admin/overview` | - |
| `/dashboard` | SCR-09 | ❌ Deny | Full | ❌ Deny | ❌ Deny | ❌ Deny | `/login?redirect=/dashboard` |
| `/ops/workspace` | SCR-17 | ❌ Deny | ❌ Deny | Full | Full | Full | `/login` or `/403` |
| `/ops/stock-opname`| SCR-20 | ❌ Deny | ❌ Deny | Count Only | Full | Full | `/403` |
| `/manager/approvals`| SCR-22 | ❌ Deny | ❌ Deny | ❌ Deny | Full | Full | `/403` |
| `/admin/users` | SCR-26 | ❌ Deny | ❌ Deny | ❌ Deny | Read-Only | Full | `/403` |
| `/admin/audit-logs`| SCR-28 | ❌ Deny | ❌ Deny | ❌ Deny | ❌ Deny | Full | `/403` |

---

## 8. Navigation Structure (Sitemap Tree)

```
├── Public
│   ├── Landing (/)
│   ├── About (/about)
│   ├── Pricing (/pricing)
│   ├── Features (/features)
│   ├── Contact (/contact)
│   ├── Login (/login)
│   └── Sign Up (/register)
│
├── Authenticated
│   ├── Member / Customer
│   │   ├── Dashboard (/dashboard)
│   │   ├── Resources (/[resource])
│   │   └── Billing (/billing)
│   │
│   ├── Staff / Operator
│   │   ├── Workspace / POS (/ops/workspace)
│   │   ├── Queue (/ops/queue)
│   │   └── Stock Opname (/ops/stock-opname)
│   │
│   ├── Manager / Supervisor
│   │   ├── Manager Dashboard (/manager/dashboard)
│   │   ├── Approvals (/manager/approvals)
│   │   └── Reports (/manager/reports)
│   │
│   └── Admin / Owner
│       ├── Overview (/admin/overview)
│       ├── Users & RBAC (/admin/users)
│       ├── Branches & Settings (/admin/branches)
│       └── Audit Trail (/admin/audit-logs)
```

---

## 9. Navigation Components

### Header (Public)
- Logo (links to `/`)
- Features
- Pricing
- About
- Login button
- Sign Up button (CTA)

### Header (Authenticated)
- Logo (links to `/dashboard`)
- Dashboard
- [Resource] dropdown
- Profile dropdown
  - Profile
  - Settings
  - Billing
  - Logout

### Sidebar (Dashboard)
- Dashboard
- [Resource] (with count badge)
- Settings
- Help & Support

### Footer (All pages)
- Company
  - About
  - Contact
  - Careers
- Product
  - Features
  - Pricing
  - Changelog
- Legal
  - Privacy Policy
  - Terms of Service
  - Cookie Policy
- Social
  - Twitter
  - LinkedIn
  - GitHub

---

## 10. Redirects & Access Control

| Condition | From | To | Status Code |
|:----------|:-----|:---|:-----------:|
| Unauthenticated user visits protected route | `/dashboard` | `/login?redirect=/dashboard` | 302 |
| Authenticated user visits login | `/login` | `/dashboard` | 302 |
| Non-admin visits admin route | `/admin` | `/dashboard` | 403 |
| Invalid route | `/invalid-path` | `/404` | 404 |

---

## 11. Dynamic Routes

### Route Parameters

| Pattern | Example | Description |
|:--------|:--------|:------------|
| `/[resource]/:id` | `/documents/123` | Single resource by ID |
| `/[resource]/:id/edit` | `/documents/123/edit` | Edit resource form |
| `/users/:username` | `/users/john` | User profile by username |
| `/blog/:slug` | `/blog/getting-started` | Blog post by slug |

### Query Parameters

| Route | Query Params | Example |
|:------|:-------------|:--------|
| `/[resource]` | `?page=1&limit=20&sort=created_at&order=desc` | `/documents?page=2&limit=50` |
| `/search` | `?q=keyword&category=docs` | `/search?q=invoice&category=legal` |

---

## 12. Error Pages

| Route | Screen ID | Purpose |
|:------|:----------|:--------|
| `/404` | ERR-01 | Page not found |
| `/403` | ERR-02 | Access forbidden |
| `/500` | ERR-03 | Server error |
| `/maintenance` | ERR-04 | Maintenance mode |

---

## 13. SEO & Meta Pages

| Route | Purpose | Index |
|:------|:--------|:-----:|
| `/sitemap.xml` | XML sitemap for search engines | ✅ |
| `/robots.txt` | Crawler directives | ✅ |
| `/rss.xml` | RSS feed (blog) | ✅ |
| `/.well-known/security.txt` | Security disclosure | ✅ |

---

## 14. Implementation Checklist

- [ ] All routes defined in routing config (Next.js app/, Laravel routes/, Django urls.py)
- [ ] Navigation components built (Header, Sidebar, Footer)
- [ ] Route guards/middleware implemented (auth, role-based)
- [ ] Redirects configured
- [ ] Error pages created (404, 403, 500)
- [ ] Breadcrumbs implemented for deep routes
- [ ] Active link highlighting in navigation
- [ ] Mobile responsive navigation (hamburger menu)
- [ ] SEO meta tags per page
- [ ] sitemap.xml auto-generated

---

## 12. Priority Legend

- **P0**: Must-have for MVP (launch blocker)
- **P1**: Important but not launch blocker
- **P2**: Nice-to-have, can defer post-launch

---

## Notes

- Replace `[resource]` with actual entity name (e.g., `documents`, `orders`, `projects`)
- Adjust routes based on framework conventions (Next.js: file-based, Laravel: route files, Django: URLconf)
- Add dynamic routes as needed for your domain
- Keep navigation shallow (<3 levels deep) for usability

---

**Last Updated**: [YYYY-MM-DD]  
**Status**: [Draft / In Review / Approved]
