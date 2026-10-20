# API Design Guidelines & Best Practices Cheat Sheet Pattern

> **Module**: M05 (Architecture & Specs) & M06 (Development Execution)  
> **Source**: Adapted from a public API cheat sheet (Collection Metaphor, No Naked IDs, Accept-header Versioning, ETag Caching) and a learn-api-design` (URI-versioning cache rationale, sparse fieldsets, `415 Unsupported Media Type`). **§C2 is source-derived but extended.** The source says, in one line, *"Use ISO 8601 timepoint formats for dates in representations."* §C2 keeps that rule and adds what the line does not state: UTC storage, the date-versus-instant distinction, and the multi-zone consequence — cross-checked against `patterns/localization/I18N_INDONESIA.md`.  
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

### C. Evolution First; Version Only When Forced

**This framework uses a URL path segment, not the Accept header.** `docs/modules/05_ARCHITECTURE_SPECS.md` requires endpoint headings of the form `#### POST /api/v1/...`, and `patterns/architecture/RESTFUL_API_DESIGN_PATTERN.md` uses `/api/v1/...` in every example. Follow that.

**The technical reason, not just the tooling one.** A URL path segment is **cache-friendly**: the same URI always maps to the same representation, so a shared cache can store and serve it with no extra logic. Header and media-type versioning put the version in a request header, which forces every cache and CDN in the path to honour `Vary: Accept` — and forget it, and one version's response is served to another version's client. The same trait makes URI versioning easier to route and to reason about. The gate counting `#### POST /api/v1/...` headings is a consequence of that choice, not the reason for it.

* **Prefer evolution.** Additive changes to a JSON response need no version at all. Exhaust that first — most "we need v2" requests are one new optional field.
* **When a breaking change is unavoidable**, add a URL path segment (`/api/v2/...`) as the first node, and keep it a **platform** version: do not version individual endpoints separately.
* **Adding a required field to a request body** is the change most likely to force a version, because existing clients omit it.
* **The Accept-header alternative** (`Accept: application/vnd.company.v2+json`) is what REST purists recommend, and it is genuinely better for content negotiation across several representations. It is **not** used in this framework, because a header version forces every cache in the path to honour `Vary: Accept`, and because every template here shows a path version. Do not introduce it in one file and URL versioning in another — that is the inconsistency this note exists to prevent.

### C2. Time Representation: ISO 8601 in UTC, Never Local

Every timestamp in a request or response body is **ISO 8601 with an explicit offset, stored and transmitted in UTC**:

```json
{ "created_at": "2026-10-19T14:23:07Z", "due_date": "2026-10-31" }
```

| Rule | Why |
| :--- | :--- |
| Timestamps carry `Z` or an explicit offset | Without it, `2026-10-19T14:23` is ambiguous — two clients in different zones read it differently |
| Store in UTC; convert only at display | Storing local time means every consumer must guess the original zone. Indonesia does not observe DST, so the failure there is a fixed 7–9 h offset plus disagreement between regions; for clients in DST countries the same mistake shifts twice a year. |
| Dates are `YYYY-MM-DD`, no time | A due date is not an instant. Adding `T00:00:00` to it creates an off-by-one-day bug for anyone west of UTC |
| Never a locale format in a payload | `19/10/2026` is unparseable without knowing the locale; the same string means two different days |
| Never an epoch number in a JSON API | It is readable only by machines, and the unit (s/m/ms) is a guess |

**This matters more here than in a US/EU project.** Indonesia spans **three zones** — WIB UTC+7, WITA UTC+8, WIT UTC+9 (`patterns/localization/I18N_INDONESIA.md`). A naive local-time field is therefore off by 7–9 hours against UTC, and by up to 2 hours **between Indonesian regions** — a Jakarta dashboard and a Jayapura dashboard would disagree about which day an event happened. The error is silent, because the value is still a valid timestamp.

### C3. Let Clients Choose Fields; Reject Wrong Media Types

**Field projection (`?fields=`) — the cheapest bandwidth win.** The client asks for the columns it will use:

```http
GET /items?fields=id,name,price&status=sold&sort=-price
```

A list endpoint that returns every column forces every consumer to download and discard the rest. On a mobile client it is the difference between a 4 KB and a 40 KB response. Two rules keep it safe: the allowed field set is **explicit** (never `SELECT *` from an arbitrary request parameter — that is a data-leak and injection surface), and the default response without `fields` stays stable so existing clients are unaffected.

**`415 Unsupported Media Type` for a wrong write body.** If the API returns JSON, it accepts JSON. When a `POST`/`PUT`/`PATCH` arrives with a `Content-Type` the endpoint does not accept, return **415**, not 400 and not a silent parse failure:

```http
POST /api/v1/orders
Content-Type: application/xml        →  415 Unsupported Media Type
```

400 means "the body was malformed"; 415 means "the body is in a language this endpoint does not speak". Collapsing them tells the client to check its syntax when the real problem is its format — and it makes a wrong-framework integration look like a bug in the data.

### D. Mandatory HTTP Caching Headers
Every GET response should emit caching metadata to optimize bandwidth and client latency:
* `ETag`: Version hash including media type representation.
* `Cache-Control`: Max-age in seconds or `no-cache`.
* `Last-Modified`: RFC1123 timestamp of the resource state.
