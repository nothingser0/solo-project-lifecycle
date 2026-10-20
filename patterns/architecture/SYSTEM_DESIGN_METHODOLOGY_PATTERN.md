# System Design Interview & Problem-Solving Methodology Pattern

> **Module**: M01 (Idea Feasibility), M02 (Scope Statement), & M05 (Architecture Specs)  
> **Source**: Adapted from a published open-source system-design curriculum.  
> **Scope**: Authoritative engineering guidelines for structuring open-ended architectural problems, defining requirements step-by-step, identifying scale bottlenecks, and weighing system trade-offs.

---

## 1. The 4-Step Open-Ended System Design Approach

When faced with an ambiguous, open-ended architecture requirement (e.g., "Design WhatsApp", "Design Netflix", or "Design a Real-Time Collaborative Whiteboard"), do not jump straight into drawing boxes or coding. Follow this disciplined 4-step interview and system design methodology:

### Step 1: Clarify Use Cases, Constraints, & Assumptions
* **Functional Requirements**: Enumerate core features, read/write ratios, and primary actor interactions.
* **Non-Functional Requirements (NFRs)**: 
  - Scale (DAU/MAU, peak QPS, data growth per year).
  - Latency targets (p99 read/write thresholds).
  - Availability vs. Consistency (CAP trade-off).
  - Durability and retention policies.
* *Rule*: Never assume scale; establish explicit numbers via Back-of-the-Envelope sizing (`references/architecture/BACK_OF_THE_ENVELOPE_CAPACITY_PLAYBOOK.md`).

### Step 2: High-Level Abstract Design

**Draw it at the scale the project actually has, not the scale it might reach.** Sketch the system for its real current size first — for most solo and small projects that is one server and one database. Scaling is a later step, and doing it first hides which decisions were structural.

* Outline core components on a blank slate **at that scale**, then note what would change at 100x.
* Define major data flows (e.g., how a message travels from sender to server to recipient).
* Verify boundaries against the 4-boundary topological model (`patterns/architecture/REPOSITORY_BACKED_ARCHITECTURE_DIAGRAM_PATTERN.md`).
* Reference for the honest starting point: `docs/modules/deep-dives/05_ARCHITECTURE_SPECS.md` — *"<100 users: Monolith is sufficient (PostgreSQL single instance)"*.

### Step 2.1: The Component Sweep (before you deep-dive)

The four steps above tell you *how* to reason. This is the checklist that stops you leaving a layer out. Run it against Step 2's sketch and mark each line present, not needed, or a gap — silently skipping one is the usual way a design looks complete and is not.

| # | Component | Question to answer | Commonly forgotten when |
| :-: | :--- | :--- | :--- |
| 1 | **Processing & servers** | How many, doing what, stateless or not? | The design assumes one box forever |
| 2 | **Storage** | Which store, what shape, what grows without bound? | Media is treated like rows |
| 3 | **Caching** | What is cached, how invalidated, what is the hit ratio assumption? | Invalidation is never specified |
| 4 | **Concurrency & communication** | Sync or async, what happens when two writes collide? | The happy path has no second user |
| 5 | **Security** | Authn/authz, transport, at-rest, who may read this? | Added as a later "hardening" phase |
| 6 | **Load balancing & proxy** | Where does traffic split, and what is sticky? | Sessions are assumed shareable |
| 7 | **CDN** | Which assets, at which edge, what invalidates? | Treated as automatic |
| 8 | **Monetization** | If relevant: how does this make or cost money, and does the design permit it? | Only `PROJECT_LITE` asks it, and only as a pricing model |

**Items 1–7 are technical; item 8 is not, and that is why it is missed.** A design that cannot express a billing boundary, a plan limit, or a metered unit will need rework when pricing arrives — and pricing arrives before launch, not after.

**Run the sweep at the current scale too.** A row marked "not needed" is a legitimate answer — CDN and load balancer are not needed at 100 users. What is not legitimate is marking it "not needed" without knowing what would make it needed.

---

### Step 3: Deep Dive into Core Component Bottlenecks
* Isolate critical scaling hurdles:
  - Database sharding or indexing strategies for heavy writes.
  - Caching layers to absorb read spikes (Cache-Aside / Redis).
  - Asynchronous background processing for heavy payloads (Postgres `SKIP LOCKED` queues).
  - Real-time transport selection (SSE vs. WebSocket).

### Step 4: Address Trade-offs & Failure Modes
* **Everything is a trade-off**: Explicitly state why a particular architectural pattern was chosen over alternatives (e.g., choosing eventual consistency for feeds to maintain high availability).
* **Resilience**: Discuss single points of failure (SPOF), database replication fail-overs, rate limiting, and circuit breaker degradation patterns.

---

## 2. Common Architectural Design Questions & Core Solutions

| Problem Domain | Core Bottleneck | Standard Solution Architecture |
| :--- | :--- | :--- |
| **URL Shortener / Pastebin** | High read-to-write ratio, unique short key generation | Base62 encoding of auto-increment IDs or pre-generated Redis hash tokens; Key-value NoSQL store or indexed Postgres table. |
| **Chat / Messaging App (WhatsApp)** | Bi-directional real-time delivery, offline message queuing | Persistent WebSocket connections, message acknowledgment state machine, persistent message store with unread queue workers. |
| **News Feed / Timeline (Twitter)** | Fan-out on write vs. fan-out on read | Hybrid approach: Fan-out on write for regular users (push to follower timelines in Redis); Fan-out on read for celebrity accounts with millions of followers. |
| **Ride Sharing / Geo-spatial (Uber)** | Real-time GPS coordinate ingestion and proximity matching | Quadtree, Google S2 geometry library, or Redis Geospatial indices (`GEOADD`, `GEoradius`) updated every 4 seconds. |
| **Video Streaming (YouTube/Netflix)** | Massive bandwidth consumption, variable client speeds | Chunked video encoding, CDN edge caching (Push/Pull CDNs), adaptive bitrate streaming (HLS/DASH). |

---

## 3. Engineering Blog Integration Rule

For enterprise or custom projects, always review engineering architecture case studies from leading tech blogs (Netflix Tech Blog, Uber Engineering, Meta Engineering) before locking technical specifications in M05. Real-world precedents prevent reinventing broken wheels.
