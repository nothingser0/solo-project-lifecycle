# Software Architecture Quality Attributes & Risk Framework

> **Module**: M05 (Architecture & Technical Specifications) & M06 (Development Execution)  
> **Source**: Adapted from SEI (Software Engineering Institute), Bass/Clements/Kazman, and `45ck/software-architecture-skills`.  
> **Scope**: Authoritative engineering rules to translate vague non-functional goals into measurable Quality Attribute Scenarios, evaluate Monolith vs. Modular Monolith architectures, and maintain an empirical Architecture Risk Register.

---

## 1. The Anti-Vague NFR Mandate

> **"A requirement stating 'the system must be fast, scalable, and secure' is useless slop. An architectural quality attribute is only real if it specifies a stimulus, an environment, an affected artifact, and a measurable response."**

Solo developers and AI agents must discard generic buzzwords. Every non-functional requirement in M05 FSD or PRD must follow the **6-Part SEI Quality Attribute Scenario**.

---

## 2. The 6-Part Quality Attribute Scenario Standard

For each critical quality goal (Performance, Availability, Security, Maintainability), document the exact scenario:

```markdown
### Quality Scenario: Peak Ingestion Latency (Performance)
1. **Source of Stimulus**: 5,000 concurrent mobile/web users.
2. **Stimulus**: Submitting new transactions/records simultaneously (150 writes/sec).
3. **Environment**: Production deployment under peak hours (normal database load).
4. **Artifact**: Next.js Server Actions & PostgreSQL Transaction Pooler.
5. **Response**: System ingests mutations without dropping connections or triggering 504 timeouts.
6. **Response Measure**: p95 latency $\le 300\text{ms}$, p99 latency $\le 800\text{ms}$, 0 transaction deadlocks.
```

### Standard Scenario Attributes for Solo Projects:
* **Availability**: Recovery after worker crash $\to$ automated health check triggers container restart $\le 15\text{s}$, 0 dropped background jobs.
* **Security**: Brute-force login attempt $\to$ IP/account rate limiter trips at 5 failed attempts $\to$ HTTP 429 returned with `Retry-After: 900` header.
* **Maintainability**: Adding a new payment rail or export format $\to$ isolated within a single domain directory $\to$ zero modifications to core ledger tables $\le 1\text{ day of dev time}$.

---

## 3. Monolith vs. Modular Monolith vs. Microservices Decision Matrix

Solo developers are prone to over-engineering distributed architectures. Use this strict structural ladder:

| Structural Style | When to Choose (Solo Dev Rules) | When Prohibited | Why This Rule |
| :--- | :--- | :--- | :--- |
| **Simple Monolith** | Small scale (MVP, $< 10$ tables, 1 developer, fast prototype). | High-traffic multi-domain domains with distinct scaling profiles. | Zero abstraction tax; maximum development velocity. |
| **Modular Monolith** *(The Solo Sweet Spot)* | Medium to Large projects. Separate features into logical domain folders (`modules/billing/`, `modules/auth/`) with strict public interfaces. | Trivial $< 3$-page apps where module scaffolding adds needless indirection. | Single deployment unit, zero network latency between modules, ACID transactions across tables, clean boundaries ready for extraction later if needed. |
| **Microservices** | **STRICTLY PROHIBITED FOR SOLO DEVS** unless legally forced by air-gapped physical data compliance. | Standard SaaS, consumer apps, internal tools. | Network hops, distributed transactions (2PC/Sagas), dual-writes, complex observability, and deployment overhead destroy solo productivity. |

---

## 4. Architecture Risk Register & Empirical Experiments

Before writing production code in M06, document architectural risks and their concrete experimental validation in `docs/specs/FSD.md`:

| Risk | Trigger / Condition | Impact | Likelihood | Severity | Architectural Mitigation | Experiment / Proof Evidence |
| :--- | :--- | :--- | :---: | :---: | :--- | :--- |
| **Connection Slot Exhaustion** | 100 concurrent serverless lambdas query DB directly. | Total app outage (`FATAL: remaining connection slots are reserved`). | High | Critical | Route all serverless DB calls through Supavisor / PgBouncer in transaction mode (`port 6543`). | Verified via k6 load test script (`scripts/load-test.js`): 200 concurrent VUs sustained with $< 15$ active DB connections. |
| **Webhook Delivery Loss** | Third-party payment gateway sends webhook while server is restarting. | Undelivered orders, unpaid invoices. | Med | High | Ingest webhooks into an append-only raw events table; process via background worker queue. | Synthetic webhook replay test passed: killed app process mid-flight, verified job resumed on restart. |
| **Large File OOM Crash** | User uploads 50MB PDF invoice export. | Node.js process runs out of memory (heap limit reached). | Low | Med | Enforce streaming parser (`Busboy`) and direct-to-S3 signed URL uploads (zero server memory buffering). | Uploaded 100MB dummy payload; verified server memory delta remained $< 5\text{MB}$. |
