# Production Distributed Systems Checklist (The "Vibe Coder" Reality Check)

> **Purpose**: A pragmatic production checklist covering 111 distributed systems, database, concurrency, runtime, release, observability, security, resilience, protocol, and incident-response realities that pure prompt-based (vibe) coding typically misses. Use during **Module 05 (Architecture)**, **Module 07 (QA/Security)** and **Module 10 (Production Deployment)**, filtered by project scale.

---

## 1–19: Edge, Delivery, Resilience & Async Foundations

### 1–5: Edge, Traffic & Perimeter
1. **Rate Limiting**: Protect endpoints from brute-force and DDoS (Redis/Upstash sliding window or Cloudflare WAF).
2. **Caching**: Multi-layer strategy (Browser → CDN/Edge → Redis → DB query cache). Define TTL and invalidation hooks.
3. **Load Balancing**: Distribute ingress traffic across nodes (round-robin, least connections, IP hash).
4. **Reverse Proxies**: Terminate TLS, normalize headers, strip backend internals (Nginx, Caddy, Cloudflare Tunnels).
5. **API Gateways**: Unified entry point for routing, auth validation, protocol translation (Kong, Traefik, Cloudflare Workers).

### 6–10: Infrastructure, Delivery & Resilience
6. **CI/CD**: Automated lint, test, container build, staged rollout (`PROJECT_CI_TEMPLATE.yml`).
7. **Docker**: Immutable containerization, multi-stage builds, non-root execution.
8. **Kubernetes**: Container orchestration (*Enterprise / Large only — never for solo SaaS/MVP*).
9. **Service Discovery**: Dynamic service registration and lookup (*microservices scale only*).
10. **Circuit Breakers**: Prevent cascading failure when downstream or third-party hangs (Resilience4j, Envoy).

### 11–14: Network Resilience & Data Integrity
11. **Timeouts**: Explicit connect and read timeouts on every external HTTP/RPC call. No infinite waits.
12. **Retries**: Configurable retry policy for transient faults, always paired with jitter.
13. **Exponential Backoff**: Increase delay between attempts to prevent retry stampedes.
14. **Idempotency**: Duplicate requests (retries, network replays) must produce identical outcomes — idempotency keys on API mutations, no double charge.

### 15–19: Async Processing & Distributed Data
15. **Message Queues**: Decouple heavy work from request-response cycles (RabbitMQ, SQS, BullMQ).
16. **Pub/Sub**: Broadcast domain events to independent subscribers (Redis Pub/Sub, Kafka).
17. **Event-Driven Architecture**: State changes from immutable event logs instead of tight synchronous coupling.
18. **Distributed Transactions**: Cross-database/service consistency (2PC or transactional Outbox).
19. **Saga Pattern**: Long-running business transactions via compensating actions instead of distributed locks.

---

## 20–41: Realtime, Database, Consistency & Concurrency

### 20–24: Async Failure Handling & Realtime Transports
20. **Dead Letter Queues**: Undeliverable/poison messages go to a DLQ with alerting and replay tooling. A queue without a DLQ silently loses money.
21. **Cron Jobs**: Scheduled work must be idempotent, timezone-explicit (UTC stored), overlap-guarded (advisory lock), and observable (last run, duration, failures).
22. **WebSockets**: Bidirectional persistent connection. Needs heartbeat/ping-pong, reconnect with backoff, auth on handshake, and message ordering rules.
23. **Long Polling**: Fallback when WS/SSE unavailable. Bounded hold time (e.g. 25–30s), must not pin server threads, returns empty on timeout.
24. **Server-Sent Events**: One-way server push over plain HTTP. Auto-reconnect built in, but no client→server channel; use `Last-Event-ID` for resume.

### 25–32: Database Performance & Scaling
25. **Database Indexing**: Index every foreign key and every column in a hot `WHERE`/`ORDER BY`/`JOIN`. Composite index column order matters (equality first, then range). Unused indexes cost write throughput.
26. **Query Optimization**: `EXPLAIN ANALYZE` before optimizing. Hunt seq scans on large tables, avoid `SELECT *`, paginate with keyset not `OFFSET` on deep pages.
27. **N+1 Queries**: One query per row in a loop. Fix with eager loading, `JOIN`, or batched `IN` / DataLoader. Invisible in dev with 10 rows, fatal with 10k.
28. **Connection Pooling**: Bounded pool sized to DB `max_connections` (not to app concurrency). Use PgBouncer/Prisma pooler/serverless pooler. Leaked connections are a slow-motion outage.
29. **Read Replicas**: Offload reads, accept replication lag. Never read-your-own-write from a replica right after a mutation — route to primary.
30. **Sharding**: Split data across independent nodes by shard key. Choose a high-cardinality, evenly distributed key; resharding is expensive, plan the key first.
31. **Partitioning**: Split one logical table into physical partitions (time/range/hash) inside one database. Cheaper than sharding; enables partition pruning and instant drops.
32. **Replication**: Primary→replica log shipping (async or sync). Async = possible data loss on failover; sync = write latency cost. Document the RPO you accepted.

### 33–35: Distributed Consensus & Consistency
33. **Leader Election**: Single writer among peers (Raft, etcd, Postgres advisory lock, Redis Redlock with caveats). Required wherever a singleton job or writer must be guaranteed.
34. **CAP Theorem**: Under network partition you choose consistency or availability. Name the choice per subsystem explicitly — "we are CP for billing, AP for feed" is a real design statement.
35. **Eventual Consistency**: Replicas converge over time. Every read path must state its staleness tolerance, and UI must not assume instant global consistency.

### 36–41: Concurrency, Locking & Resource Safety
36. **Optimistic Locking**: Version/timestamp column, retry on conflict. Best for low-contention updates and stateless HTTP flows.
37. **Pessimistic Locking**: `SELECT ... FOR UPDATE`, row locks held for the transaction. Correct for high-contention counters and inventory; keep transactions short or you queue the whole table.
38. **Distributed Locks**: Cross-process mutual exclusion (Redis, etcd, DB advisory locks). Must have TTL, fencing token, and safe release — a lock without expiry becomes a permanent outage.
39. **Race Conditions**: Concurrent read-modify-write losing updates. Fix with atomic SQL (`SET x = x + 1`), unique constraints, locking, or a queue. Constraints beat application-level checks.
40. **Deadlocks**: Two transactions each holding what the other needs. Prevent by consistent lock ordering, short transactions, and retry-on-deadlock handling. The DB will kill one; your code must survive it.
41. **Memory Leaks**: Unbounded caches, missed listeners, unclosed streams/connections, retained closures. Watch RSS trend over hours, heap snapshots under load — a leak always ends in an OOM restart at 3 AM.

---

## 42–59: Runtime, Scaling, Release & Observability

### 42–45: Runtime & Flow Control
42. **Garbage Collection**: Know your GC (V8 young/old gen, JVM G1/ZGC, Go concurrent tri-color). Long pauses come from heap growth and allocation churn, not from GC itself. Tune heap limits before tuning GC flags.
43. **Thread Safety**: Shared mutable state across threads/coroutines is the bug source. Prefer immutability, per-request state, and atomic ops. In Node/Python-async the danger is interleaved `await` on shared objects, not real parallelism.
44. **Backpressure**: A fast producer and slow consumer ends in unbounded memory. Bound queues, reject or shed load, and propagate pressure upstream (streams `highWaterMark`, 429 on overload).
45. **Autoscaling**: Scale on a signal that leads load (queue depth, CPU, RPS per pod), not on lagging ones. Always set min/max and a stabilization window, or you get thrash scaling up and down every minute.

### 46–50: Scaling & Content Delivery
46. **Horizontal Scaling**: Add instances. Requires stateless app, externalized sessions, shared storage. This is the default for web tiers.
47. **Vertical Scaling**: Bigger machine. Simplest and often cheapest at small scale; hard ceiling and single point of failure. Start vertical, go horizontal when you hit the ceiling.
48. **CDN**: Static assets and cacheable responses served from edge PoPs. Requires correct `Cache-Control`, immutable hashed filenames, and purge capability. Without cache headers a CDN does nothing.
49. **Edge Caching**: Cache at the request boundary (CDN, Next.js ISR, Cloudflare KV). Define per-route policy: `s-maxage`, `stale-while-revalidate`. Personalized responses must be `private, no-store`.
50. **Cache Invalidation**: The hard part. Use versioned keys, short TTLs plus explicit purge on write, or write-through. "There are only two hard things in CS" — stale data is a correctness bug, not a performance detail.

### 51–55: Release Engineering
51. **Feature Flags**: Decouple deploy from release. Every flag needs an owner and an expiry date; unremoved flags become permanent dead branches. Kill switches are the same mechanism used in reverse.
52. **Blue-Green Deployment**: Two identical environments, switch traffic at the router. Instant rollback, double infrastructure cost during switch. Needs DB migration compatibility both ways.
53. **Canary Releases**: Route a small percentage to the new version, watch error rate and latency, then ramp. Needs real metrics and automated abort, otherwise it is just a slow full rollout.
54. **Rolling Deployments**: Replace instances incrementally. Zero extra infra, but mixed versions run simultaneously — API and schema changes must be backward compatible for at least one release.
55. **Rollbacks**: Must be tested, not assumed. Keep previous artifact, ensure migrations are reversible or expand-contract, and know the exact command. An untested rollback is a rumor.

### 56–59: Health & Observability
56. **Health Checks**: An endpoint that actually verifies critical dependencies (DB reachable, migrations applied), not a hardcoded `200 OK`. Keep it cheap and unauthenticated internally.
57. **Liveness & Readiness Probes**: Liveness = "restart me" (process deadlocked); readiness = "send me traffic" (dependencies OK, warm). Conflating them causes restart loops under load. Startup probes for slow boots.
58. **Monitoring**: Metrics (RED: rate, errors, duration; USE: utilization, saturation, errors) plus alerting on symptoms users feel. Dashboards without alerts are decoration.
59. **Logging**: Structured JSON, correlation/request ID on every line, no secrets or PII, levels that mean something. Logs answer "what happened to this one request"; metrics answer "is it broken for everyone".

---

## 60–82: Observability Targets, Identity, Crypto & App Security

### 60–66: The Three Pillars & Reliability Targets
60. **Distributed Tracing**: Propagate a trace ID across every service, queue, and outbound call (OpenTelemetry). Span timing exposes where latency actually goes — logs tell you *that* it was slow, traces tell you *which hop*.
61. **Metrics**: Numeric time series, low cardinality labels only. Never put user IDs or raw URLs in labels — that is how a metrics bill becomes a second mortgage.
62. **Alerts**: Alert on symptoms (error rate, p99 latency, queue lag), not on CPU cosmetics. Every alert must be actionable, owned, and linked to a runbook. Alert fatigue kills the alerting.
63. **SLOs**: A numeric reliability promise to users ("99.9% of checkouts succeed within 500ms over 28 days"). Internal target, not a marketing number.
64. **SLIs**: The measurement that feeds the SLO (success ratio, latency percentile, throughput). Choose SLIs at the user boundary, not the CPU boundary.
65. **Error Budgets**: `100% − SLO` = allowed failure. Budget remaining decides whether you ship features or fix reliability. Exhausted budget freezes risky deploys — enforce it or the SLO is theatre.
66. **Observability**: The ability to ask new questions without shipping code. Logs + metrics + traces + correlation IDs, plus enough context to explain an unknown-unknown failure. Monitoring tells you *if* it broke; observability tells you *why*.

### 67–70: Identity & Secrets
67. **Secrets Management**: Secrets live in a manager (Vault, AWS Secrets Manager, Doppler, or platform env injection), never in git, images, or chat. Rotate on a schedule, scope per environment, and audit access.
68. **IAM**: Least privilege per role, not per person. Separate deploy/runtime/admin identities, avoid wildcard `*` actions, and review stale permissions quarterly.
69. **OAuth**: Delegated authorization via short-lived access tokens + refresh token rotation. Always validate `state` (CSRF), exact `redirect_uri`, and `aud`/`iss`. Never treat the implicit flow as modern.
70. **JWT Rotation**: Short access-token TTL (5–15 min) + rotating refresh tokens with reuse detection. Support `kid`-based key rotation so signing keys can change without logging everyone out. Never store JWTs in `localStorage` if an httpOnly cookie works.

### 71–73: Cryptography in Practice
71. **TLS**: TLS 1.2+ minimum, 1.3 preferred. Valid certs with automated renewal (Let's Encrypt/ACM), HSTS, and no mixed content. Internal service traffic encrypts too — the network is not trusted.
72. **Encryption at Rest**: Disk/volume encryption plus field-level encryption for PII and payment-adjacent data. Key management is the real problem: separate the key from the ciphertext and have a rotation path.
73. **Encryption in Transit**: TLS/mTLS between services, signed webhooks (HMAC), and no plaintext over private networks. Verify signatures on inbound, and pin to expected algorithms — never trust the algorithm in the header.

### 74–80: Application Security Attack Surface
74. **WAF**: Managed rule sets in front of the app (Cloudflare, AWS WAF). Catches commodity attacks; never a substitute for input validation in the app.
75. **DDoS Protection**: Edge absorption (Cloudflare, CloudFront Shield), rate limits, and autoscale headroom. Application-layer floods need per-identity quotas, not just IP blocks.
76. **CORS**: Explicit origin allowlist, no `*` with credentials, minimal allowed methods/headers, and correct preflight handling. CORS is a browser policy, not an auth control.
77. **CSRF**: SameSite cookies + per-session CSRF tokens on state-changing requests. If you rely on bearer tokens in headers only, say so explicitly — mixing models is where the hole is.
78. **SQL Injection**: Parameterized queries / prepared statements everywhere, no string concatenation. ORMs help only when you do not drop to raw SQL with interpolation.
79. **XSS**: Context-aware output encoding, framework auto-escaping (never `dangerouslySetInnerHTML`/`v-html` on user input), strict CSP, and httpOnly cookies.
80. **SSRF**: Any user-supplied URL fetched by the server is a hole. Allowlist schemes/hosts, block link-local and metadata IPs (`169.254.169.254`), disable redirects, and put egress behind a proxy.

### 81–82: Schema Evolution
81. **Database Migrations**: Versioned, reviewed, forward-only scripts run by CI, never by hand in production. Test on a production-size copy, keep them fast and lock-aware, and never edit an applied migration.
82. **Schema Versioning**: Expand-contract for zero-downtime: add nullable column → dual-write/backfill → switch reads → drop old. Old and new app versions must coexist during any rolling deploy.

---

## 83–101: Resilience, Performance Physics & Protocols

### 83–88: Business Continuity
83. **Disaster Recovery**: A written plan with RTO (how long you may be down) and RPO (how much data you may lose), plus a tested restore. A backup without a restore drill is a hypothesis.
84. **Backups**: Automated, encrypted, off-site/off-account, versioned against ransomware, with retention policy. Test restores on a schedule — the only backup that counts is a restored one.
85. **Failover**: Automatic promotion of a standby (DB, region, AZ). Must be tested under load; an untested failover usually fails at the moment it is needed. Watch for split-brain and stale DNS.
86. **Multi-Region Deployment**: Data residency, replication lag, and cross-region latency become design constraints. Only justified by hard latency or compliance requirements — not by ambition.
87. **Chaos Engineering**: Deliberately inject failures (kill pods, add latency, drop packets) in staging to prove resilience. Start small, blast-radius limited, always with an abort switch.
88. **Cost Optimization**: Know your top 3 cost drivers (egress, DB instance size, log volume, idle compute). Right-size before optimizing code — architecture, not cleverness, sets most of the bill.

### 89–90: Serverless Realities
89. **Cold Starts**: Cold boot latency per runtime (Node ~100–400ms, JVM/Spring seconds, Go/Rust tens of ms). Mitigate with provisioned concurrency, smaller bundles, or a warm path — but measure it, do not guess.
90. **Serverless Limits**: Execution timeout, memory ceiling, payload size, connection limits per instance, and no persistent local state. Pooled DB connections from many lambdas will exhaust your database — use a proxy (PgBouncer/RDS Proxy/Neon/Supabase pooler).

### 91–97: Performance Physics & Network Truths
91. **Latency**: Response time for one request. Decompose before optimizing: network + queue + compute + I/O + render. The dominant term is usually I/O or a serial dependency, not CPU.
92. **Throughput**: Requests per unit of time. Not the inverse of latency — concurrency (Little's Law: `L = λ × W`) links them. More throughput without concurrency limits just moves the backlog.
93. **P99 Latency**: The slow 1%. Averages hide pain; at P99 with 100 RPS, one user per second is having the worst experience. Set SLOs on percentiles, never on the mean.
94. **Tail Latency**: The extreme end (P99.9+) caused by GC pauses, retries, lock queues, cold caches, and head-of-line blocking. Fan-out amplifies it: one call to 100 services means the slowest of 100 dominates.
95. **Network Partitions**: Split brain between nodes. Decide per subsystem whether to be consistent or available (see #34), and ensure the minority side cannot accept writes it will later have to discard.
96. **Clock Skew**: Machine clocks drift. Never order events by wall-clock timestamps across nodes — use monotonic clocks, logical clocks (Lamport/vector), or DB sequence values. TTL and JWT `exp` also break under skew.
97. **DNS**: The first hop and the most common silent outage. TTLs control failover speed, CNAME chains add latency, and resolver caching ignores your "instant" change. Health-checked DNS failover plus low TTLs for critical records.

### 98–101: Protocols & Integration Contracts
98. **TCP vs UDP**: TCP orders, retransmits, and blocks under loss (HTTP, DB, queues). UDP is fire-and-forget with no delivery guarantee (DNS, realtime media, QUIC's base). Choose by whether loss is tolerable, not by habit.
99. **HTTP/2 & HTTP/3**: HTTP/2 multiplexes streams over one TCP connection (solves app-level head-of-line blocking, not TCP-level loss). HTTP/3 runs over QUIC/UDP with per-stream loss recovery. Enable at the edge/proxy; it is a transport win, not an architecture.
100. **gRPC**: Typed protobuf over HTTP/2, streaming (unary/server/client/bidi), code-generated clients. Excellent for internal service-to-service; poor for public browser APIs without a gateway/connect layer. Deadline propagation is mandatory.
101. **Webhooks**: Inbound HTTP callbacks from a provider. Must verify signatures (HMAC), be idempotent on replay, respond fast (enqueue, do not process inline), tolerate out-of-order delivery, and handle retries with your own dedupe store.

---

## 102–111: Contracts, Infrastructure as Code & Incident Response

### 102–103: Versioning Contracts
102. **API Versioning**: Version the contract consumers depend on (`/v1`, header, or media type). Never break a live version silently — run old and new in parallel, deprecate with a documented sunset window, and keep changelogs machine-readable. Breaking a mobile client you cannot roll back is the classic solo-dev foot-gun.
103. **Semantic Versioning**: `MAJOR.MINOR.PATCH` means breaking / additive / fix. Honour it for libraries and internal packages; a "patch" that breaks imports destroys trust in your own release pipeline. Pre-release tags (`-beta.1`) and pinned lockfiles are part of the discipline.

### 104–108: Infrastructure as Code & Build Reliability
104. **Infrastructure as Code**: Every resource declared in version control, applied by automation, never clicked in a console. Reproducible environments, reviewable diffs, and rollback by revert. Clickops leaves no history — the outage bequest.
105. **Terraform**: Declarative HCL with state as the source of truth. Remote backend with locking (never state in git), separate workspaces per environment, `plan` reviewed before `apply`, and module pinning to avoid surprise upgrades.
106. **Helm Charts**: Templated Kubernetes manifests with values per environment. Useful only once you actually run Kubernetes — for a solo SaaS it is a second YAML tax on top of a stack you did not need (see #8). Pin chart versions and render diffs before install.
107. **Build Caching**: Cache dependencies, compiled artifacts, and container layers keyed on lockfile hashes. Cuts CI from minutes to seconds; a broken cache key silently gives you stale builds, so cache on the lockfile, not the whole directory.
108. **Dependency Hell**: Transitive conflicts, peer-dependency mismatch, abandoned packages, and duplicated versions in one bundle. Mitigate with a single lockfile committed, minimal dependency count, automated update PRs (Dependabot/Renovate), and a real reason for every new package.

### 109–111: Incident Response & Learning
109. **Production Incidents**: Detect fast (alert), contain (rollback or feature-flag off), then diagnose. Declare severity and an incident commander even when it is you — write the timeline as it happens, because memory rewrites itself afterwards.
110. **On-Call**: Defined escalation path, paging only for actionable alerts, runbooks per alert, and a documented response time. Solo founder = you are on-call; make sure alerts reach a phone, and that a dead man's switch fires when the app is fully down.
111. **Postmortems**: Blameless, written within 48 hours: timeline, impact, root cause, contributing factors, and action items with owners and dates. An incident without a postmortem is a rehearsal for the same incident. Track the action items to closure or the document is fiction.

---

## Scale Enforcement (Anti-Overkill Rule)

- **Small / MVP (1–2 weeks)**: #1 Rate Limiting, #2 Caching, #4 Reverse Proxy, #6 CI/CD, #7 Docker, #11–#14 Timeouts/Retries/Backoff/Idempotency, #21 Cron guards, #25–#28 Indexing/Query/N+1/Pooling, #39–#41 Race/Deadlock/Leak hygiene, #50 Cache Invalidation, #55 Rollbacks, #56–#59 Health/Monitoring/Logging, #67 Secrets, #70 JWT rotation, #71–#73 encryption, #76–#82 CORS/CSRF/injection/XSS/SSRF/migrations, #84 Backups, #91–#93 latency basics, #97 DNS, #101 webhooks, #102 API versioning, #103 SemVer, #107 build caching, #108 dependency discipline, #109–#111 incident/on-call/postmortem basics. Skip #8, #9, #18, #19, #30.
- **Medium / Solo SaaS (2–4 weeks)**: Add #15 Message Queues, #16 Pub/Sub, #20 DLQ, #22–#24 realtime transport choice, #29 Read Replicas, #35 Eventual Consistency, #36–#38 locking strategy, #42–#45 GC/thread/backpressure/autoscaling, #48 CDN, #51 Feature Flags, #54 Rolling Deploys, #57 Probes, #61–#62 metrics/alerts, #68 IAM, #74 WAF, #83 DR plan with RTO/RPO, #85 Failover, #89–#90 serverless limits & pooling, #94 tail latency awareness, #98–#99 protocol choice at the edge, #104 Infrastructure as Code.
- **Large (1–3 months)**: Add #10 Circuit Breakers, #17 Event-Driven Architecture, #31 Partitioning, #32 Replication with documented RPO, #33 Leader Election, #46–#47 scaling decision, #49 Edge Caching, #60 Distributed Tracing, #63–#65 SLO/SLI/error budget, #66 Observability maturity, #75 DDoS, #95 network partition policy, #96 clock skew discipline, #100 gRPC for internal services, #105 Terraform state & workspaces.
- **Enterprise (3–6+ months)**: Full set including #5 API Gateway, #8 Kubernetes, #9 Service Discovery, #18 Distributed Transactions, #19 Sagas, #30 Sharding, #34 CAP statement per subsystem, #52–#53 Blue-Green/Canary, #69 OAuth federation at scale, #86 Multi-Region, #87 Chaos Engineering, #88 cost governance, #106 Helm chart governance.
