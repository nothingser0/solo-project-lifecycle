# Production Distributed Systems Checklist (The "Vibe Coder" Reality Check)

> **Purpose**: A pragmatic production checklist covering all 19 distributed systems and backend infrastructure realities that pure prompt-based (vibe) coding typically misses. Use this checklist during **Module 05 (Architecture)** and **Module 10 (Production Deployment)** based on project scale.

---

## The 19 Production Realities

### 1–5: Edge, Traffic & Perimeter
1. **Rate Limiting**: Protect endpoints from brute-force and DDoS (Use Redis/Upstash sliding window or Cloudflare WAF).
2. **Caching**: Multi-layer caching strategy (Browser → CDN/Edge → Redis → DB query cache). Define TTL and invalidation hooks.
3. **Load Balancing**: Distribute ingress traffic across multiple nodes (Round-robin, least connections, IP hash).
4. **Reverse Proxies**: Terminate SSL/TLS, handle headers, strip backend internals (Nginx, Caddy, Cloudflare Tunnels).
5. **API Gateways**: Unified entry point for routing, auth validation, and protocol translation (Kong, Traefik, or Cloudflare Workers).

### 6–10: Infrastructure, Delivery & Resilience
6. **CI/CD**: Automated linting, test suites, container builds, and staging/production rollouts (`PROJECT_CI_TEMPLATE.yml`).
7. **Docker**: Immutable containerization with multi-stage builds for minimal image size and secure non-root execution.
8. **Kubernetes**: Container orchestration (*Enterprise / Large scale only* — avoid for simple solo SaaS/MVP).
9. **Service Discovery**: Dynamic service registration and lookup (*Microservices scale only*).
10. **Circuit Breakers**: Prevent cascading failures when downstream services or third-party APIs hang (Resilience4j, Envoy).

### 11–14: Network Resilience & Data Integrity
11. **Timeouts**: Explicit connection and read timeouts on every external HTTP/RPC call (Never use infinite hanging waits).
12. **Retries**: Configurable retry policies for transient network glitches (Always pair with jitter).
13. **Exponential Backoff**: Prevent retry stampedes by increasing delay exponentially between failed attempts.
14. **Idempotency**: Ensure duplicate requests (due to retries or network replays) produce the exact same outcome without double-charging or duplicate side-effects (Idempotency keys on API mutations).

### 15–19: Async Processing & Distributed Data
15. **Message Queues**: Decouple heavy background tasks from request-response cycles (RabbitMQ, AWS SQS, BullMQ).
16. **Pub/Sub**: Broadcast domain events to multiple independent subscribers asynchronously (Redis Pub/Sub, Kafka topics).
17. **Event-Driven Architecture**: Core domain state changes driven by immutable event logs rather than direct tightly-coupled synchronous DB calls.
18. **Distributed Transactions**: Managing state consistency across multiple independent databases or microservices (Two-Phase Commit or Outbox pattern).
19. **Saga Pattern**: Handling long-running business transactions across services via compensating transactions instead of locking distributed databases.

---

## Scale Enforcement (Anti-Overkill Rule)

- **Small / MVP (1–2 weeks)**: Focus on #1 (Rate Limiting via Upstash), #2 (Caching), #4 (Reverse Proxy/Caddy), #6 (CI/CD), #7 (Docker), #11 (Timeouts), #12–#14 (Retries & Idempotency). Skip Kubernetes, Service Discovery, and Distributed Sagas.
- **Medium / Solo SaaS (2–4 weeks)**: Add #15 (Message Queues) and #16 (Pub/Sub) for background jobs and webhook processing.
- **Large / Enterprise (1–6+ months)**: Full utilization of Kubernetes (#8), Circuit Breakers (#10), Event-Driven Architecture (#17), and Sagas (#19).
