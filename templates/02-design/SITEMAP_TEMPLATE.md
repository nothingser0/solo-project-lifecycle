# Sitemap & Navigation Structure

> **Purpose**: Define all pages, routes, and navigation hierarchy for the application.

**Project**: [Project Name]  
**Date**: [YYYY-MM-DD]  
**Author**: [Your Name]

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

## 3. Protected Routes (Authenticated)

| Route | Page Name | Screen ID | Purpose | Priority |
|:------|:----------|:----------|:--------|:--------:|
| `/dashboard` | Dashboard | SCR-09 | Main user dashboard | P0 |
| `/profile` | Profile | SCR-10 | User profile & settings | P1 |
| `/[resource]` | Resource List | SCR-11 | Main resource listing | P0 |
| `/[resource]/new` | Create Resource | SCR-12 | Create new item | P0 |
| `/[resource]/:id` | Resource Detail | SCR-13 | View/edit single item | P0 |
| `/[resource]/:id/edit` | Edit Resource | SCR-14 | Edit form | P0 |
| `/settings` | Settings | SCR-15 | App settings | P1 |
| `/billing` | Billing | SCR-16 | Subscription & payment | P1 |

---

## 4. Admin Routes (Admin Role)

| Route | Page Name | Screen ID | Purpose | Priority |
|:------|:----------|:----------|:--------|:--------:|
| `/admin` | Admin Dashboard | SCR-17 | Admin overview | P1 |
| `/admin/users` | User Management | SCR-18 | Manage users | P1 |
| `/admin/settings` | System Settings | SCR-19 | Global config | P2 |

---

## 5. Navigation Structure (Sitemap Tree)

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
│   ├── Dashboard (/dashboard)
│   ├── Profile (/profile)
│   ├── [Resource] (/[resource])
│   │   ├── List
│   │   ├── Create (/new)
│   │   └── Detail (/:id)
│   ├── Settings (/settings)
│   └── Billing (/billing)
│
└── Admin
    ├── Dashboard (/admin)
    ├── Users (/admin/users)
    └── Settings (/admin/settings)
```

---

## 6. Navigation Components

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

## 7. Redirects & Access Control

| Condition | From | To | Status Code |
|:----------|:-----|:---|:-----------:|
| Unauthenticated user visits protected route | `/dashboard` | `/login?redirect=/dashboard` | 302 |
| Authenticated user visits login | `/login` | `/dashboard` | 302 |
| Non-admin visits admin route | `/admin` | `/dashboard` | 403 |
| Invalid route | `/invalid-path` | `/404` | 404 |

---

## 8. Dynamic Routes

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

## 9. Error Pages

| Route | Screen ID | Purpose |
|:------|:----------|:--------|
| `/404` | ERR-01 | Page not found |
| `/403` | ERR-02 | Access forbidden |
| `/500` | ERR-03 | Server error |
| `/maintenance` | ERR-04 | Maintenance mode |

---

## 10. SEO & Meta Pages

| Route | Purpose | Index |
|:------|:--------|:-----:|
| `/sitemap.xml` | XML sitemap for search engines | ✅ |
| `/robots.txt` | Crawler directives | ✅ |
| `/rss.xml` | RSS feed (blog) | ✅ |
| `/.well-known/security.txt` | Security disclosure | ✅ |

---

## 11. Implementation Checklist

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
