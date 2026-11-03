# Production Distributed Systems Checklist (The "Vibe Coder" Reality Check)

> **Purpose**: A pragmatic production checklist covering 41 distributed systems, database, concurrency, and backend infrastructure realities that pure prompt-based (vibe) coding typically misses. Use during **Module 05 (Architecture)** and **Module 10 (Production Deployment)**, filtered by project scale.

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

## Scale Enforcement (Anti-Overkill Rule)

- **Small / MVP (1–2 weeks)**: #1 Rate Limiting, #2 Caching, #4 Reverse Proxy, #6 CI/CD, #7 Docker, #11–#14 Timeouts/Retries/Backoff/Idempotency, #21 Cron guards, #25–#28 Indexing/Query/N+1/Pooling, #39–#41 Race/Deadlock/Leak hygiene. Skip #8, #9, #18, #19, #30.
- **Medium / Solo SaaS (2–4 weeks)**: Add #15 Message Queues, #16 Pub/Sub, #20 DLQ, #22–#24 realtime transport choice, #29 Read Replicas, #35 Eventual Consistency, #36–#38 locking strategy.
- **Large (1–3 months)**: Add #10 Circuit Breakers, #17 Event-Driven Architecture, #31 Partitioning, #32 Replication with documented RPO, #33 Leader Election for singleton jobs.
- **Enterprise (3–6+ months)**: Full set including #5 API Gateway, #8 Kubernetes, #9 Service Discovery, #18 Distributed Transactions, #19 Sagas, #30 Sharding, #34 CAP statement per subsystem.
