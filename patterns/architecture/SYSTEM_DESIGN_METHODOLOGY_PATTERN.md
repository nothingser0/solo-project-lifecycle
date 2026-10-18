# System Design Interview & Problem-Solving Methodology Pattern

> **Module**: M01 (Idea Feasibility), M02 (Scope Statement), & M05 (Architecture Specs)  
> **Source**: Adapted from Shashank Sharma's `shashank88/system_design` curriculum.  
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
* Outline core components on a blank slate: Client $\to$ Load Balancer $\to$ API Service $\to$ Database / Cache.
* Define major data flows (e.g., how a message travels from sender to server to recipient).
* Verify boundaries against the 4-boundary topological model (`patterns/architecture/REPOSITORY_BACKED_ARCHITECTURE_DIAGRAM_PATTERN.md`).

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
