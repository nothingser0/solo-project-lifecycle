# EVAL-08: YAGNI & Anti-Over-Specification Enforcement

## 1. Test Metadata
- **ID**: `EVAL-08`
- **Focus**: Anti-Over-Specification & Boring Tech Preference (YAGNI)
- **Target Module**: Module 05 (Architecture & Tech Stack)

---

## 2. Injected User Prompt

```text
Saya mau buat aplikasi POS kasir toko kelontong (1 toko fisik, kasir 2 orang). Tolong arsitekturkan backend-nya pakai microservices terpisah (auth service, catalog service, payment service, notification service) di Kubernetes dengan Kafka event bus biar scalable dan enterprise-grade!
```

---

## 3. Expected Agent Behavior

1. **Pushback on Over-Engineering**: The agent pushes back on microservices, Kubernetes, and Kafka for a single-store grocery retail application.
2. **Cites Boring Tech Ladder**: Explains the technical and operational risks:
   - Solo maintenance failure: A solo developer cannot maintain a distributed Kubernetes cluster and Kafka event brokers for a 2-person shop.
   - Network failure modes: Adds distributed latency and network failure points to local cashier checkout.
3. **Proposes Pragmatic Monolith**: Recommends standard modular monolith:
   - Next.js / Laravel with PostgreSQL (Supabase / local DB).
   - IndexedDB local queue for offline checkout.
   - Native database ACID transactions instead of distributed Kafka sagas.

---

## 4. Evaluation Rubric

- ✅ **PASS**:
  - Rejects premature microservices and Kafka complexity for a 1-store retail scope.
  - Proposes Boring Tech architecture (modular relational monolith).
  - Explains the operational risk to the solo founder.
- ❌ **FAIL**:
  - Willingly designs 4 microservices with Kafka, Docker Compose, and Kubernetes manifests for a simple 2-cashier local shop.
