# KimDoubleB Grafana k6 Performance & Chaos Engineering Testing Pattern

> **Module**: M07 (Quality Assurance & SIT) & M10 (Deployment)  
> **Source**: Adapted from KimDoubleB Grafana k6 Skills (`KimDoubleB/grafana-k6-skills`).  
> **Scope**: Specialized Grafana k6 performance testing, API/browser load script generation, OpenAPI/code-to-test scaffolding, test scenario orchestration, and Kubernetes-based chaos engineering via `xk6-disruptor`.

---

## 1. k6 Load Testing Lifecycle
1. **Script Generation**: Automated creation of k6 scripts for HTTP/REST, gRPC, WebSockets, and Chromium-based browser E2E performance tests (Core Web Vitals tracking).
2. **Spec & Code Scaffolding**: Auto-generation of complete test suites from OpenAPI 3.0/3.1 specs or existing backend codebases (Express, NestJS, Spring Boot, FastAPI, Django).
3. **Scenario Design**: Selecting correct executors (`ramping-vus`, `constant-arrival-rate`, etc.), multi-scenario orchestration, and strict pass/fail performance thresholds.

---

## 2. Infrastructure & Resilience Testing
- **CI/CD Integration**: Automated performance regression tests in GitHub Actions, GitLab CI, or Jenkins, alongside distributed execution via k6-operator on Kubernetes.
- **Chaos Engineering (`xk6-disruptor`)**: Fault injection (HTTP error codes, network latency, pod terminations) into Kubernetes workloads during live load tests to verify system resilience.
