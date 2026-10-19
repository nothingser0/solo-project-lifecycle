# KimDoubleB Grafana k6 Performance & Chaos Engineering Testing Pattern

> **Module**: M07 (Quality Assurance & SIT) & M10 (Deployment)  
> **Source**: Adapted from KimDoubleB Grafana k6 Skills (`KimDoubleB/grafana-k6-skills`). §3 (request-phase decomposition, p95-vs-median rule) is from its `analyzing-test-results` skill.  
> **Scope**: Specialized Grafana k6 performance testing, API/browser load script generation, OpenAPI/code-to-test scaffolding, test scenario orchestration, Kubernetes-based chaos engineering via `xk6-disruptor`, and reading the resulting metrics (request-phase decomposition, p95-versus-median, thresholds as a gate).

---

## 1. k6 Load Testing Lifecycle
1. **Script Generation**: Automated creation of k6 scripts for HTTP/REST, gRPC, WebSockets, and Chromium-based browser E2E performance tests (Core Web Vitals tracking).
2. **Spec & Code Scaffolding**: Auto-generation of complete test suites from OpenAPI 3.0/3.1 specs or existing backend codebases (Express, NestJS, Spring Boot, FastAPI, Django).
3. **Scenario Design**: Selecting correct executors (`ramping-vus`, `constant-arrival-rate`, etc.), multi-scenario orchestration, and strict pass/fail performance thresholds.

---

## 2. Infrastructure & Resilience Testing
- **CI/CD Integration**: Automated performance regression tests in GitHub Actions, GitLab CI, or Jenkins, alongside distributed execution via k6-operator on Kubernetes.
- **Chaos Engineering (`xk6-disruptor`)**: Fault injection (HTTP error codes, network latency, pod terminations) into Kubernetes workloads during live load tests to verify system resilience.

---

## 3. Reading the Result Before Trusting the Number

A p95 of 800ms is not a finding. It is a symptom with three possible causes that look identical in a summary table. k6 breaks the request into phases — read them in order; the first phase with a high value names the cause.

```
blocked → connecting → tls_handshaking → sending → waiting → receiving
                                                      ↑
                                              (TTFB / server time)
```

| Phase | Measures | High value means |
| :--- | :--- | :--- |
| `http_req_blocked` | Queue before the request starts | Connection-pool exhaustion, DNS lookup |
| `http_req_connecting` | TCP connect | Network latency, distant region |
| `http_req_tls_handshaking` | TLS handshake | Missing keep-alive — a new connection per request |
| `http_req_sending` | Uploading the body | Large request payload |
| `http_req_waiting` | **Server processing (TTFB)** | Slow backend, slow query, overloaded server |
| `http_req_receiving` | Downloading the response | Large response body, slow link |

**`http_req_duration` = sending + waiting + receiving.** It excludes blocked, connecting, and TLS — so a high total with a low `waiting` is a **connection problem, not a server problem**. Optimising the backend in that case changes nothing, which is the most expensive misdiagnosis in load testing.

### The two rules that turn a number into a finding

**1. Compare p95 to the median.** If p95 is **2× or more** the median, some requests are hitting a different path — a cold cache, a lock, a slow row, a GC pause. A uniformly slow system has p95 close to the median; a system with a tail has a gap. Report the gap, not just the p95.

| Percentile | What it means to the reader |
| :--- | :--- |
| p(50) / med | Half the requests are faster — the typical experience |
| p(90) | Most users' experience |
| p(95) | The common SLA target |
| p(99) | Worst case for most users |
| p(99.9) | Tail latency — 1 in 1,000 |

**2. A threshold is a decision, not a decoration.** `http_req_failed` above 1% or `http_req_duration` p95 above the agreed budget must **fail the run** (`thresholds` in the script), otherwise the test reports and nobody acts. A load test whose thresholds always pass is a stopwatch, not a gate.

**What an average hides**: a 131ms average is compatible with 90% of requests at 5ms and 10% at 1.3s. Never report `avg` for latency — report p95 (and p99 when the SLA is strict), plus the error rate, because a fast response that failed is not a fast response.