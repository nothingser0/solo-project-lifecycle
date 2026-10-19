# API Design Guidelines & Best Practices Cheat Sheet Pattern

> **Module**: M05 (Architecture & Specs) & M06 (Development Execution)  
> **Source**: Adapted from `RestCheatSheet/api-cheat-sheet` (Collection Metaphor, No Naked IDs, Accept-header Versioning, and ETag Caching).  
> **Scope**: Advanced RESTful API conventions focusing on consumer-driven design, collection metaphors, hypermedia representation without naked IDs, Content-Type negotiation, and HTTP caching headers.

---

## 1. Key Advanced REST Principles

### A. The Collection Metaphor & No Naked IDs
* **Two primary URLs per resource**: 
  - Collection: `/orders`
  - Individual item: `/orders/{orderId}`
* **No Naked IDs**: Never embed raw database foreign keys (`user_id: 42`) in JSON responses without contextual reference objects or links. Always return rich representation objects or hypermedia references.

### B. Content-Type Negotiation for Polymorphic Actions
* Avoid bloating URLs with action sub-paths (e.g., avoid `POST /ratings/five_star` or `POST /ratings/thumbs_up`).
* Use custom **Content-Type headers** on a single route (`POST /ratings`) to handle polymorphic payloads:
  - `Content-Type: application/vnd.company.rating.thumbsup`
  - `Content-Type: application/vnd.company.rating.fivestar`

### C. Evolution Over Versioning (Accept Header)
* Prefer non-breaking additions to JSON response bodies (which require no versioning).
* When breaking schema changes are mandatory, version via the **Accept Header** (`Accept: application/vnd.company.v2+json`) rather than polluting the URL path (`/api/v1/...`).

### C2. Time Representation: ISO 8601 in UTC, Never Local

Every timestamp in a request or response body is **ISO 8601 with an explicit offset, stored and transmitted in UTC**:

```json
{ "created_at": "2026-10-19T14:23:07Z", "due_date": "2026-10-31" }
```

| Rule | Why |
| :--- | :--- |
| Timestamps carry `Z` or an explicit offset | Without it, `2026-10-19T14:23` is ambiguous — two clients in different zones read it differently |
| Store in UTC; convert only at display | Storing local time means every consumer must guess the original zone, and DST makes the guess wrong twice a year |
| Dates are `YYYY-MM-DD`, no time | A due date is not an instant. Adding `T00:00:00` to it creates an off-by-one-day bug for anyone west of UTC |
| Never a locale format in a payload | `19/10/2026` is unparseable without knowing the locale; the same string means two different days |
| Never an epoch number in a JSON API | It is readable only by machines, and the unit (s/m/ms) is a guess |

**This matters more here than in a US/EU project**: Indonesia is UTC+7, so a naive local-time field is off by seven hours for any consumer comparing it against a server log — and the error is silent, because the value is still a valid timestamp.

### D. Mandatory HTTP Caching Headers
Every GET response should emit caching metadata to optimize bandwidth and client latency:
* `ETag`: Version hash including media type representation.
* `Cache-Control`: Max-age in seconds or `no-cache`.
* `Last-Modified`: RFC1123 timestamp of the resource state.
