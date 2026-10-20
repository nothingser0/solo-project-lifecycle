# Back-of-the-Envelope Capacity & Sizing Playbook (BOTEC)

> **Module**: M01 (Idea & Feasibility) & M05 (Architecture & Technical Specifications)  
> **Source**: Adapted from Martin Kleppmann (*DDIA*), the *ByteByteGo* system-design curriculum, and a published system-design-skills library.  
> **Scope**: Authoritative engineering rules to convert vague scale descriptions ("high traffic", "huge data") into concrete arithmetic constraints. Prevents premature clustering, unnecessary distributed infra, and under-provisioned bottlenecks.

---

## 1. The Core Engineering Stance

> **"A design for 1,000 QPS and one for 1,000,000 QPS are fundamentally different systems. 10 GB fits in RAM on a $5/mo VPS; 10 TB requires distributed object storage. Estimate first, architect second."**

Solo developers must never select infrastructure based on brand names ("we need Kafka and Redis because everyone uses them"). Every architectural component must be justified by back-of-the-envelope numbers.

---

## 2. Hard Capacity Rules of Thumb (Orders of Magnitude)

Memorize these reference points to ground sizing discussions without external lookups.

> **Read the order of magnitude, then measure.** These are point-query baselines for a *simple* request on *modest* hardware. A range scan, a multi-table join, or a fat payload can be **10x worse**; a well-tuned node can be better. Use the table to decide whether you are one database or ten, then validate against your own benchmark before it reaches a quote, an SLA, or a capacity plan. A number copied from this table into a client promise is a guess wearing a unit.

| Component / Layer | Realistic Throughput Baseline | Architectural Limit / Transition Trigger |
| :--- | :---: | :--- |
| **Single SQL / RDBMS Node (PostgreSQL / MySQL)** | $\approx \mathbf{1,000\text{ QPS}}$ (mixed reads/writes) | $> 1,000\text{ QPS}$ requires read replicas or connection pooling. $> 10,000\text{ QPS}$ forces sharding or caching. |
| **Single Key-Value Cache (Redis / Keyv / Memcached)** | $\approx \mathbf{100,000\text{ – }1,000,000\text{ QPS}}$ | Bottlenecked by network I/O or single-core CPU saturation. |
| **Modern Application Worker (Node.js / Go / Python)** | $\approx \mathbf{500\text{ – }2,000\text{ req/s per CPU core}}$ | I/O-bound tasks depend strictly on database connection pools. |
| **Memory (RAM) vs. NVMe SSD vs. HDD Latency Ratio** | $\approx \mathbf{100\text{ ns} : 100\text{ }\mu\text{s} : 10\text{ ms}}$ | Memory access is $\sim 1,000\times$ faster than SSD, $\sim 100,000\times$ faster than spinning disk. |

---

## 3. The 4 Essential Estimation Formulas

### Formula 1: Daily Average & Peak QPS
$$\text{Average QPS} = \frac{\text{Daily Active Users (DAU)} \times \text{Actions Per User Per Day}}{86,400\text{ seconds}}$$
$$\text{Peak QPS} = \text{Average QPS} \times 2 \quad (\text{or } 3\text{–}5\text{ for flash-sale / bursty workloads})$$

*Worked Example (SaaS Task Manager)*:
* $50,000\text{ DAU}$, each user performs $40\text{ API requests/day}$.
* Total requests/day: $50,000 \times 40 = 2,000,000\text{ requests/day}$.
* Average QPS: $2,000,000 \div 86,400 \approx 23.1\text{ req/s}$.
* Peak QPS: $23.1 \times 2 \approx \mathbf{46.3\text{ req/s}}$.
* **Verdict**: $46\text{ QPS}$ is trivial for a single $5/month SQLite or PostgreSQL database. Zero Redis or microservices needed!

### Formula 2: Storage Ingestion & Growth per Year
$$\text{Daily Storage} = \text{Daily Writes} \times \text{Average Record Size in Bytes}$$
$$\text{Annual Storage} = \text{Daily Storage} \times 365\text{ days}$$

*Worked Example (FreePajak Freelance Invoices)*:
* $10,000\text{ invoices created/day}$, average payload (JSON + metadata) $= 2\text{ KB}$.
* Daily storage: $10,000 \times 2\text{ KB} = 20\text{ MB/day}$.
* Annual storage: $20\text{ MB} \times 365 \approx \mathbf{7.3\text{ GB/year}}$.
* **Verdict**: $7.3\text{ GB}$ fits entirely within a standard SSD volume on any entry-level cloud host. No data warehousing or distributed sharding needed.

### Formula 3: Media & File Storage Bandwidth
$$\text{Ingress Bandwidth} = \frac{\text{Daily Uploads} \times \text{Average File Size}}{86,400\text{ seconds}} \times 8\text{ bits}$$

### Formula 4: Compute Sizing
$$\text{Required CPU Cores} = \frac{\text{Peak QPS}}{\text{Throughput per Core (\sim 1,000 req/s)}} \times 1.5\text{ (Safety Margin)}$$

---

## 4. The 3 GUIDE Component Selection Questions (Anti-Name-Dropping)

Whenever introducing a major dependency or library in M05 FSD / ADR, answer all 3 questions:

1. **What problem does this solve?**  
   *Describe the measurable bottleneck or technical requirement this component satisfies (e.g., "Offloads 400 QPS of read-heavy product catalog traffic away from Postgres").*
2. **What does it make worse?**  
   *Describe the operational complexity, failure modes, or financial cost introduced (e.g., "Introduces cache invalidation bugs, requires memory monitoring, and risks serving stale data").*
3. **What would make you change this decision?**  
   *Specify the threshold or metric that invalidates this component (e.g., "If catalog read volume drops below 50 QPS, remove Redis and query PostgreSQL directly with a 60s memory cache").*
