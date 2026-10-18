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

### D. Mandatory HTTP Caching Headers
Every GET response should emit caching metadata to optimize bandwidth and client latency:
* `ETag`: Version hash including media type representation.
* `Cache-Control`: Max-age in seconds or `no-cache`.
* `Last-Modified`: RFC1123 timestamp of the resource state.
