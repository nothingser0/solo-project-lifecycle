# SITEMAP.md — Small Path (LITE)

> Target: ≥1000B. One page. Screens for a 3–7 feature MVP only.

## Screen inventory

| Screen ID | Route | Purpose | States needed |
| :--- | :--- | :--- | :--- |
| SCR-001 | `/` | [landing / entry] | Default |
| SCR-002 | `/login` | Authentication | Default, Error |
| SCR-003 | [primary data screen] | [core workflow] | 5-state (Default, Loading, Empty, Error, Success) — see DESIGN_SPEC |

*Rule: 5-state matrix applies to primary screens only (1–3 screens, SCR-003+). Secondary screens need Default state only.*

## Navigation

- **Desktop**: [sidebar / topbar] with [items]
- **Mobile**: [bottom nav / hamburger] with [items]

## Screen details

### SCR-003 — [primary screen]
- **Entry points**: [links/redirects from]
- **Primary action**: [the one job of this screen]
- **Data shown**: [fields/list/table summary]
- **Empty state**: [message + CTA]
- **Error state**: [message + retry]
