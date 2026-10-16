# Requirements Ambiguity & Edge-Case Checklist

> **Module**: M02 (Scope Lock) & M05 (Architecture Specs)  
> **Source**: Adapted from Business Analysis Requirements Elicitation & Ambiguity Hunter patterns.  
> **Objective**: Eliminate vague client statements and undefined edge cases before locking the Scope of Work (SOW) or Functional Specification Document (FSD).

---

## 1. Vague Words Detector (Banned in SOW / FSD)

Never accept vague adjectives from clients or yourself. Replace each with measurable technical parameters:

| Vague Client Term | The Hidden Trap | Concrete Specification Requirement |
| :--- | :--- | :--- |
| *"Fast / Quick"* | Client expects instantaneous response under bad 4G network. | Define P95 latency (e.g. `P95 ≤ 300ms` for API, LCP `< 2.5s` on mobile). |
| *"Real-time"* | Requires expensive WebSocket servers vs simple polling. | Specify: WebSocket sync, Server-Sent Events (SSE), or polling interval (e.g. `every 30s`). |
| *"User-friendly"* | Subjective opinion used to demand infinite UI redesigns. | Define exact step count (e.g. `Checkout completed in ≤ 3 screens`). |
| *"Secure"* | Unbounded legal liability if an incident occurs. | Reference specific baseline (e.g. `OWASP Top 10, bcrypt hash cost 12, TLS 1.3`). |
| *"Seamless export"* | Format, volume, and filtering left undefined. | Define format, record limit, and timeout (e.g. `CSV/XLSX up to 10,000 rows within 5s`). |
| *"Flexible search"* | Expects Elasticsearch / AI semantic search on day 1. | Define exact mechanism: `ILIKE text match` vs `PostgreSQL pg_trgm fuzzy`. |
| *"Automated sync"* | Retry rules and failure alerts undefined. | Define schedule and error handling: `Cron daily at 02:00 UTC with email alert on failure`. |

---

## 2. The Edge-Case Triad (Mandatory for Every Feature)

Before marking any feature as "Scope Locked", verify how the system handles the 3 boundary states:

### A. Zero / Empty State
- [ ] What does the user see when they have 0 records? (Clear empty state graphic + Call-to-Action button, not a blank white screen).
- [ ] What happens when a search/filter returns 0 matches? (Informative message + "Clear filters" action).

### B. Extreme / Heavy State
- [ ] What happens if the text input is 10,000 characters or contains foreign unicode/emojis? (DB varchar limit, validation error toast).
- [ ] What happens if a user uploads a 500 MB file instead of a 2 MB avatar? (Client-side pre-validation + Cloudflare/Nginx 10 MB payload hard cap).
- [ ] What happens if a merchant has 50,000 inventory items? (Cursor-based pagination with `MAX_LIMIT=100`, never `SELECT *` unindexed).

### C. Network & Interruption State
- [ ] What happens if the user loses connection mid-transaction? (Client idempotency key prevents duplicate charges).
- [ ] What happens if a third-party webhook fails or arrives out of order? (HMAC verification + deduplication table with replay defense).

---

## 3. Ambiguity Sign-Off Gate

| Check | Status | Notes |
| :--- | :--- | :--- |
| **Zero banned vague words in SOW / FSD** | `[PASS / FAIL]` | All performance, search, and export specs are quantified. |
| **Empty, Extreme, and Network states defined** | `[PASS / FAIL]` | Edge-case behavior explicitly mapped per CRUD screen. |
| **Verified By** | `[Solo Dev]` | Date: `YYYY-MM-DD` |
