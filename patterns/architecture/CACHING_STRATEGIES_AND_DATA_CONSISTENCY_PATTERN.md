# Caching Strategies & Data Consistency Pattern

> **Module**: M05 (Architecture & Specs) & M06 (Development Execution)  
> **Source**: Adapted from Donne Martin (`donnemartin/system-design-primer`).  
> **Scope**: Authoritative engineering rules for designing multi-tier caching architectures (Cache-Aside, Write-Through, Write-Behind), mitigating cache stampedes and avalanches, applying CAP theorem trade-offs, and reasoning with foundational latency numbers.

---

## 1. Foundational Latency Numbers Every Engineer Must Know

When designing system bottlenecks, anchor estimates to hardware and network reality rather than guesswork:

| Operation | Latency | Real-World Scale Factor |
| :--- | :---: | :--- |
| **L1 cache reference** | $0.5\text{ ns}$ | 1 second (human scale analogy) |
| **L2 cache reference** | $7\text{ ns}$ | 14 seconds |
| **Main memory (RAM) reference** | $100\text{ ns}$ | 3.3 minutes |
| **Compress 1KB with Snappy/Zstd** | $10\text{ µs}$ | 5.5 hours |
| **Read 1MB sequentially from SSD** | $50\text{ µs}$ | ~1 day |
| **In-Memory Cache hit (Redis / Keyv)** | $0.5\text{–}1.5\text{ ms}$ | ~2 weeks |
| **Indexed PostgreSQL Query (`pk` lookup)**| $3\text{–}10\text{ ms}$ | ~2.5 months |
| **Round trip intra-datacenter (VPC)** | $0.5\text{ ms}$ | ~1.5 weeks |
| **Round trip cross-country (SG $\to$ Jakarta)** | $15\text{–}25\text{ ms}$ | ~6 months |
| **Round trip trans-Pacific (US $\to$ Jakarta)**| $160\text{–}200\text{ ms}$ | ~4 years |

*Key Lesson*: A single unindexed database query or cross-region network jump costs orders of magnitude more than hundreds of in-memory transformations.

---

## 2. The 4 Caching Strategies Decision Matrix

| Strategy | Read Path | Write Path | Optimal Use Case | Risks & Pitfalls |
| :--- | :--- | :--- | :--- | :--- |
| **1. Cache-Aside (Lazy Loading)** *(Solo Default)* | 1. Check cache.<br/>2. If miss, read DB.<br/>3. Write result to cache with TTL. | Write directly to primary DB; invalidate or delete cache key. | High-read/low-write data (product catalogs, user public profiles, static configs). | Cache miss penalty on cold start; potential stale data during race conditions. |
| **2. Write-Through** | Read from cache. | Application writes to cache; cache synchronously writes to DB before returning. | Critical read-heavy data where stale reads are unacceptable. | High write latency (waits for both cache and DB storage). |
| **3. Write-Behind (Write-Back)** | Read from cache. | Application writes to cache and returns immediately ($<2\text{ms}$). Asynchronous worker writes to DB in batches. | High-frequency telemetry, view counters, rate limit counters, clickstream logs. | **Data loss risk** if cache crashes before async flush to disk. |
| **4. Refresh-Ahead** | Read from cache. | Background worker refreshes cache key automatically before TTL expiration based on access predictions. | Extremely hot keys with expensive recomputations (e.g. homepage leaderboard). | Wasted compute resources if cached items stop being accessed. |

---

## 3. Classic Caching Pitfalls & Production Mitigations

### A. Cache Stampede (Thundering Herd)
* *The Bug*: A hot key expires, and 500 concurrent requests simultaneously experience a cache miss, all executing the expensive SQL query against the primary database at the same instant.
* *The Fix*:
  1. **Randomized TTL Jitter**: Never use a fixed TTL. Append random jitter:
     $$\text{TTL} = \text{base\_ttl} + \text{random}(0, \text{jitter\_window}) \quad (\text{e.g. } 3600\text{s} + \text{rand}(0, 300)\text{s})$$
  2. **Early Background Refresh (Probabilistic XFetch)** or single-flight mutex lock (`async-mutex` or Redis `SET NX`).

### B. Cache Penetration
* *The Bug*: Malicious requests query non-existent IDs (e.g. `/api/users/fake-id-999`), bypassing the cache entirely and hammering the database on every request.
* *The Fix*: **Cache the Miss**: Store a `null` or placeholder object with a short TTL ($60\text{ seconds}$) to prevent database re-queries for non-existent entities.

### C. Cache Avalanche
* *The Bug*: Thousands of keys are saved during a batch job with the exact same 24-hour expiration, causing them all to evaporate at 03:00 AM simultaneously.
* *The Fix*: Stagger batch job write TTLs across uniform distribution windows.

---

## 4. CAP Theorem & Data Consistency Matrix in M05 Specifications

When writing the Functional Specification Document (`docs/specs/FSD.md`), classify each system domain into its mandatory consistency model:

```text
               Consistency (C)
                    ▲
                   / \
                  /   \
                 /  ★  \
                / CP  CA\
               /─────────\
Partition     ◄───────────► Availability (A)
Tolerance (P)       AP
```

*Note on Distributed Systems*: Networks are imperfect ($P$ is non-negotiable). Therefore, architects must trade off **CP vs. AP**:

| System Domain | Model | Rationale & Architecture Rule |
| :--- | :---: | :--- |
| **Financial Ledgers & Payment Settlement** | **CP (Consistency)** | **Strong Consistency mandatory**. Single-primary PostgreSQL with strict row locks (`FOR UPDATE`). Rollback transaction on network disconnect. Under no circumstances tolerate duplicate balances. |
| **Inventory Stock Reservation** | **CP (Consistency)** | Atomic decrements with `CHECK (stock >= 0)`. Never use eventual consistency for scarce ticket/seat booking. |
| **User Notifications & Activity Feeds** | **AP (Availability)** | **Eventual Consistency allowed**. If the secondary replica or cache is out of date by 2 seconds, the user still sees their feed with zero 500 errors. |
| **Analytics & Page View Counters** | **AP (Availability)** | Write-behind in-memory aggregation. Dropping 5 view events during a partition is preferable to crashing the application. |
| **Authentication Sessions & Revocation** | **CP-skewed** | Fast local JWT validation with short TTL ($15\text{ min}$) paired with a centralized Redis blacklist for instant logout revocations. |
