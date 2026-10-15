# Solo Architecture Guardrails: The Boring Tech Ladder

> **Core Philosophy**: "The best code is the code you never have to write or maintain." As a solo developer or single-person engineering team, operational overhead is your greatest enemy. Every distributed system, self-hosted infrastructure daemon, or microservice component steals engineering bandwidth from building high-value product features.

---

## 1. The Boring Tech Ladder (Enforced Hierarchy)

Before introducing any architectural abstraction, stop at the lowest rung that satisfies the requirement:

```text
[ RUNG 1: Native Platform / SQL Database Primitive ]
  (Constraints, Triggers, Generated Columns, ACID Transactions)
                        │
                        ▼
[ RUNG 2: In-Framework Native Capabilities ]
  (Next.js Server Actions, Laravel Queues, Django Signals, Go Goroutines)
                        │
                        ▼
[ RUNG 3: Single-Node Boring Dependency ]
  (PostgreSQL Queue via pg-boss/graphile-worker, SQLite, In-Memory Caching)
                        │
                        ▼
[ RUNG 4: Managed Cloud PaaS Primitive ]
  (Redis / Upstash, Supabase Auth/Storage, Cloudflare R2 / Workers)
                        │
                        ▼
[ RUNG 5: STOP! BEYOND SOLO CAPACITY (Advisory / Enterprise Only) ]
  (Kafka, Kubernetes, Distributed Microservices, Multi-Region Consensus)
```

---

## 2. Component-by-Component Decision Matrix

### A. Monolith vs Microservices
- **Default (Small, Medium, Solo SaaS)**: **Modular Monolith**.
  - A single codebase organized cleanly by domain boundaries (e.g., `modules/auth`, `modules/billing`, `modules/inventory`).
  - Single database, shared ACID transactions, in-memory function calls instead of network HTTP requests.
  - Zero network serialization overhead, zero distributed transaction bugs, zero cross-service tracing nightmare.
- **When to Split**: Never as a solo developer. Only split when distinct domains have vastly incompatible scaling requirements (e.g., an automated Python AI video rendering engine paired with a Next.js web dashboard).

### B. Background Jobs & Asynchronous Queues
- **Level 1 (Simplest)**: In-framework queue backed by primary PostgreSQL (e.g., `pg-boss`, `graphile-worker`, Laravel database queue). Zero extra infrastructure required.
- **Level 2 (High Throughput)**: Managed Redis with BullMQ (Node) or Celery (Python). Use managed providers (Upstash / Redis Cloud) so you do not maintain Linux Redis daemons.
- **Anti-Pattern (Prohibited for Solo)**: Apache Kafka, RabbitMQ cluster, or AWS SQS with dead-letter orchestration matrices for simple transaction emails or PDF exports.

### C. CI/CD & Automation
- **Default**: **GitHub Actions** or platform-native Git integrations (Vercel, Railway, Cloudflare Pages).
  - Fully declarative YAML stored in the repository.
  - Zero server maintenance, zero patch updates, zero downtime risk.
- **Anti-Pattern (Prohibited for Solo)**: Jenkins, TeamCity, or self-hosted GitLab runners requiring dedicated EC2/VPS infrastructure and manual Java runtime patching.

### D. Database & Infrastructure
- **Default**: Single-node Managed PostgreSQL (Supabase, Neon, AWS RDS, Railway).
  - Backups handled automatically.
  - Vertical scaling (upgrade CPU/RAM with a click) satisfies 99% of solo businesses up to 100K MAU.
  - Serverless runtimes MUST use transaction-mode connection poolers (PgBouncer / Supavisor).
- **Anti-Pattern (Prohibited for Solo)**: Kubernetes (K8s) clusters, self-hosted Cassandra, CockroachDB distributed consensus, or premature database sharding.

---

## 3. Solo Developer Red Flags & Over-Engineering Traps

If you catch yourself planning any of the following, pause immediately:

1. Setting up Docker Compose clusters with 6+ distinct service containers for an MVP.
2. Building custom authentication or custom cryptography instead of using battle-tested libraries/services.
3. Introducing Apache Kafka when total event volume is under 1,000,000 events per day.
4. Spending >2 hours configuring infrastructure before writing your first database table or UI route.
