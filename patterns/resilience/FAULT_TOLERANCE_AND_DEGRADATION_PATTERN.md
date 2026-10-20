# Fault Tolerance, Resilience, & Graceful Degradation Pattern

> **Module**: M05 (Architecture & Technical Specs) & M06 (Development Execution)  
> **Source**: Adapted from a published system-design-skills resilience track & production reliability engineering.  
> **Scope**: Authoritative engineering rules to prevent outage amplification, cascading failures, retry storms, and service death-spirals in distributed or external API integrations.

---

## 1. Outage Amplification: The Core System Risk

The primary cause of severe outages is rarely the initial component failure; it is **the system's own reaction to that failure**.
* ❌ **Naïve Retries**: 1,000 clients immediately retrying a slow database every 500ms create a **Retry Storm**, multiplying load by $5\times$ and ensuring the database never recovers.
* ❌ **Missing Timeouts**: An un-timeouted HTTP request to an external SMS/AI provider holds application worker threads open indefinitely, leading to thread/connection pool exhaustion (HTTP 504 Gateway Timeout across the entire application).

---

## 2. The 4 Mandatory Resilience Defenses

### Defense 1: Bounded Timeouts Anchored to Measured p99
* Never guess a timeout (e.g. `timeout: 30000ms`).
* Anchor timeouts to the dependency's measured **p99 latency + $50\%$ buffer**:
  - Internal DB queries: `statement_timeout = 2500ms` (2.5 seconds max).
  - External SaaS APIs (Stripe/Midtrans/Resend): `timeout = 5000ms` (5 seconds max).
  - AI LLM Completion APIs: `timeout = 30000ms` (30 seconds with streaming).

### Defense 2: Exponential Backoff with Full Jitter
When retrying transient network errors (HTTP 502, 503, 504, 429), the retry schedule MUST include exponential backoff and randomized jitter to de-synchronize callers:

```typescript
// Production Exponential Backoff with Full Jitter (Zero Dependency)
async function fetchWithRetry<T>(
  fn: () => Promise<T>,
  maxRetries = 3,
  baseDelayMs = 200,
  maxDelayMs = 3000
): Promise<T> {
  let attempt = 0;
  while (true) {
    try {
      return await fn();
    } catch (error) {
      attempt++;
      if (attempt > maxRetries) throw error;
      
      // Full Jitter Formula: sleep = random_between(0, min(maxDelay, baseDelay * 2^attempt))
      const calculatedMax = Math.min(maxDelayMs, baseDelayMs * Math.pow(2, attempt));
      const jitteredSleep = Math.floor(Math.random() * calculatedMax);
      
      await new Promise((res) => setTimeout(res, jitteredSleep));
    }
  }
}
```

### Defense 3: Circuit Breaker State Machine
Prevent hammering a dead dependency. A circuit breaker trips open after consecutive errors, failing fast without hitting the network:
* **CLOSED (Normal)**: Requests pass through. If error rate exceeds $50\%$ over 10 requests $\to$ Trip to **OPEN**.
* **OPEN (Tripped)**: All requests fail immediately without calling the remote dependency. Fallback logic is executed. After 30 seconds $\to$ Transition to **HALF-OPEN**.
* **HALF-OPEN (Probe)**: Allow 1 test request through. If successful $\to$ Reset to **CLOSED**. If failed $\to$ Re-open for 60 seconds.

### Defense 4: Graceful Degradation ("Stale Beats Error")
When a secondary dependency (e.g. recommendation engine, exchange rates, analytics) fails or times out:
1. **Never crash the primary user journey**: Return cached data with explicit metadata:
   ```json
   {
     "data": [...],
     "stale": true,
     "source": "cache-fallback",
     "as_of": "2026-10-15T08:00:00Z"
   }
   ```
2. **Silent Degradation**: If an AI summary generation fails, display raw document text instead of an unhandled error toast.

---

## 3. Resilience Checklist for M05 & M06

- [ ] **No Unbounded Loops**: All remote API invocations carry an explicit timeout.
- [ ] **Idempotent Writes Only**: Retries are permitted ONLY for GET requests or POST requests equipped with a unique `Idempotency-Key` header.
- [ ] **Jitter Enforced**: No fixed-interval retries (`setInterval` or `setTimeout(1000)` loops are prohibited).
- [ ] **Stale-While-Revalidate**: Read caches serve slightly stale content if the authoritative database is temporarily unreachable.
