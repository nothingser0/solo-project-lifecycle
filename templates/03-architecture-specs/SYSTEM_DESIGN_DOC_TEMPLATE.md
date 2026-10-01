# System Design Document: [Project Name]

**Version**: 1.0  
**Date**: [YYYY-MM-DD]  
**Author**: [Your Name]  
**Status**: [Draft / Review / Approved]

---

## 1. Executive Summary

**Purpose**: [One-sentence description of what this system does]

**Scale Target**:
- Expected MAU (Monthly Active Users): [Number]
- Expected RPS (Requests Per Second): [Number]
- Geographic scope: [Single region / Multi-region / Global]

**Key Constraints**:
- Performance: [e.g., p95 latency < 500ms]
- Availability: [e.g., 99.9% uptime SLA]
- Budget: [Monthly infrastructure budget]

---

## 2. Requirements & Scope

### 2.1 Functional Requirements

1. **[Feature 1]**: [Description]
   - Input: [Data/triggers]
   - Output: [Expected behavior]
   - Volume: [Expected usage]

2. **[Feature 2]**: [Description]

### 2.2 Non-Functional Requirements (NFR)

| Category | Requirement | Target | Measurement |
|----------|-------------|--------|-------------|
| **Performance** | API response time | p95 < 500ms | APM metrics |
| **Scalability** | Concurrent users | 10,000 CCU | Load test |
| **Availability** | Uptime | 99.9% (43 min downtime/month) | Uptime monitor |
| **Security** | Data encryption | AES-256 at rest, TLS 1.3 in transit | Audit |
| **Compliance** | Data residency | GDPR / UU PDP compliant | Legal review |

### 2.3 Out of Scope

- [Feature explicitly not included]
- [Future enhancement]

---

## 3. High-Level Architecture

### 3.1 System Overview Diagram

```
[User Devices]
      ↓
[CDN (Cloudflare)]
      ↓
[Load Balancer / API Gateway]
      ↓
[Application Servers (Auto-scaling)]
      ↓
[Database (Primary + Read Replicas)] ← → [Cache (Redis)]
      ↓
[Background Job Queue (Bull + Redis)]
      ↓
[External Services (Payment, Email, Storage)]
```

### 3.2 Technology Stack

**Frontend**: [Next.js 15 / React 19 / etc.]  
**Backend**: [Node.js 22 / Python 3.12 / etc.]  
**Database**: [PostgreSQL 16 (Supabase)]  
**Cache**: [Redis (Upstash)]  
**CDN**: [Cloudflare]  
**Hosting**: [Vercel / AWS / GCP]  
**Background Jobs**: [Bull + Redis / AWS SQS]  
**Monitoring**: [Sentry + Vercel Analytics / Datadog]

**Rationale**: [Explain why these choices (Boring Tech, team expertise, cost, managed services)]

---

## 4. Detailed Component Design

### 4.1 API Layer

**Endpoint Design**:
```
GET  /api/v1/users/:id         - Fetch user profile
POST /api/v1/users             - Create user
PUT  /api/v1/users/:id         - Update user
GET  /api/v1/orders            - List orders (paginated)
POST /api/v1/orders            - Create order
```

**Authentication**: JWT Bearer tokens (RS256), 1h expiry, refresh token rotation.

**Rate Limiting**: 100 req/min per IP (Upstash Redis sliding window).

**Caching Strategy**:
- User profile: Cache 5 min (cache-aside pattern)
- Product catalog: Cache 1 hour (write-through)
- CDN: Static assets 1 year, API responses 60s stale-while-revalidate

### 4.2 Database Design

**Schema** (PostgreSQL):
```sql
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email VARCHAR(255) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_users_email ON users(email);

CREATE TABLE orders (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  status VARCHAR(50) NOT NULL, -- pending, paid, shipped, completed
  total DECIMAL(10,2) NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_orders_user_status ON orders(user_id, status);
```

**Read/Write Split**:
- Writes → Primary DB
- Reads (user profiles, order history) → Read replica
- Replication lag monitoring: Target < 1s

**Connection Pooling**:
- Pool size: 20 connections per instance
- Pool timeout: 10s
- Idle timeout: 60s

### 4.3 Caching Strategy

**Redis Key Structure**:
```
user:{userId}          → User profile JSON (TTL: 300s)
product:{productId}    → Product details (TTL: 3600s)
session:{sessionId}    → Session data (TTL: 3600s)
rate:{ip}              → Rate limit counter (TTL: 60s)
```

**Cache Invalidation**:
- User updates → Delete `user:{userId}` key
- Product updates → Delete `product:{productId}` + purge CDN
- Order creation → No invalidation (not cached)

**Cache Stampede Prevention**: Probabilistic early expiration (10% chance at 90% TTL).

### 4.4 Background Jobs

**Job Types**:
1. **Email sending** (welcome, order confirmation, password reset)
   - Retry: 5 attempts with exponential backoff (2s, 4s, 8s, 16s, 32s)
   - Dead letter queue after 5 failures → alert admin
2. **Image processing** (resize, optimize, upload to CDN)
   - Timeout: 60s per job
3. **Analytics aggregation** (daily reports)
   - Scheduled: 02:00 UTC daily

**Queue Monitoring**:
- Alert if queue depth > 1000 jobs
- Alert if job processing time > 30s (p95)

---

## 5. Scalability Strategy

### 5.1 Vertical vs Horizontal Scaling Decision

**Current State** (MVP, < 10K MAU):
- Single VPS: 2 vCPU, 4GB RAM ($24/mo)
- Single PostgreSQL instance (Supabase Free tier)

**Scaling Triggers**:

| Metric | Threshold | Action |
|--------|-----------|--------|
| CPU > 70% sustained | 10 min | Vertical scale to 4 vCPU, 8GB RAM |
| DB connections > 80% pool | 5 min | Add read replica |
| RPS > 500 | Sustained | Horizontal scale to 2-3 instances + load balancer |
| MAU > 50K | — | Add Redis caching layer |
| MAU > 100K | — | Multi-region CDN + edge functions |

### 5.2 Load Balancing

**Algorithm**: Round-robin (default) → Least connections when WebSocket added.

**Health Checks**:
- Endpoint: `GET /api/health`
- Interval: 30s
- Failure threshold: 3 consecutive fails → remove from pool
- Success threshold: 2 consecutive success → add back to pool

### 5.3 Auto-Scaling Policy

**Vercel (serverless)**:
- Auto-scale 0-100 instances based on traffic
- Cold start: < 500ms (using edge runtime)

**AWS ECS (containerized)**:
- Min instances: 2 (for HA)
- Max instances: 10
- Scale-out trigger: CPU > 70% for 2 min
- Scale-in trigger: CPU < 30% for 10 min

---

## 6. Availability & Reliability

### 6.1 SLA/SLO Definition

**SLA (Contract)**: 99.5% uptime (3.6 hours downtime/month)  
**SLO (Internal Target)**: 99.9% uptime (43 minutes downtime/month)  
**SLI (Measurement)**: Uptime monitored via UptimeRobot (1-min intervals)

**Error Budget**: 0.1% (43 min/month). If exceeded, pause feature work and focus on reliability.

### 6.2 Disaster Recovery

**RPO (Recovery Point Objective)**: 1 hour (max acceptable data loss)  
**RTO (Recovery Time Objective)**: 30 minutes (max acceptable downtime)

**Backup Strategy**:
- Database: Automated daily backup to S3 (retained 7 daily, 4 weekly, 12 monthly)
- File storage: S3 versioning enabled (30-day retention)
- Secrets: Encrypted backup in Bitwarden vault

**Failover Plan**: See `docs/DISASTER_RECOVERY_PLAN.md`

### 6.3 Monitoring & Alerting

**Critical Alerts** (page on-call immediately):
- API error rate > 1% for 5 min
- p95 latency > 1s for 5 min
- Database connection pool exhausted
- Payment gateway down

**Warning Alerts** (Slack notification):
- CPU > 80% for 10 min
- Memory > 85% for 10 min
- Queue depth > 500 jobs

**Alert Channels**:
- Critical: PagerDuty → SMS + Phone call
- Warning: Slack #alerts channel

---

## 7. Security Architecture

### 7.1 Data Protection

**Encryption**:
- At rest: AES-256 (database, file storage)
- In transit: TLS 1.3 (all API traffic)

**Sensitive Data Handling**:
- Passwords: bcrypt (cost factor 12)
- PII masking: Email `j***@example.com`, phone `+62***1234` in logs
- Payment data: Never stored (Stripe tokenization)

### 7.2 Authentication & Authorization

**Auth Flow**:
1. User submits email + password
2. Server validates against bcrypt hash
3. Server issues JWT (RS256, 1h expiry) + refresh token (7 day expiry)
4. Client includes JWT in `Authorization: Bearer <token>`
5. Server validates JWT signature + expiry on each request

**RBAC** (Role-Based Access Control):
```
admin   → Full access (users, orders, products)
manager → Read/write orders, products
user    → Read/write own profile, orders
```

### 7.3 DDoS & Rate Limiting

**Cloudflare Protection**:
- Layer 3/4: AWS Shield Standard (auto-enabled)
- Layer 7: Cloudflare WAF (OWASP Core Ruleset)
- Rate limiting: 100 req/min per IP (Cloudflare rule)

**Application Rate Limiting**:
- Auth endpoints: 5 req/min per IP (Upstash Redis)
- API endpoints: 100 req/min per user (JWT-based)

---

## 8. Capacity Planning

### 8.1 Growth Projections

| Timeframe | MAU | RPS (avg) | RPS (peak) | DB Size | Bandwidth |
|-----------|-----|-----------|------------|---------|-----------|
| Launch (Month 1) | 1,000 | 5 | 20 | 1 GB | 100 GB/mo |
| Month 6 | 10,000 | 50 | 200 | 10 GB | 1 TB/mo |
| Year 1 | 50,000 | 250 | 1,000 | 50 GB | 5 TB/mo |

### 8.2 Cost Estimation

**Current (MVP)**:
- Vercel Pro: $20/mo
- Supabase Pro: $25/mo
- Cloudflare Pro: $20/mo
- Upstash Redis: $10/mo (10K req/day)
- **Total**: $75/mo

**At 50K MAU** (Year 1):
- Vercel Pro: $20/mo
- Supabase Pro: $25/mo (read replica +$25/mo)
- Cloudflare Pro: $20/mo
- Upstash Redis: $40/mo (1M req/day)
- Sentry: $26/mo
- **Total**: $156/mo

### 8.3 Load Testing Results

**Test Scenario**: 100 concurrent users, 5-minute sustained load  
**Tool**: k6  
**Results**:
- p50 latency: 120ms ✅
- p95 latency: 380ms ✅
- p99 latency: 850ms ⚠️ (target < 1s)
- Error rate: 0.02% ✅
- Throughput: 450 RPS ✅

**Bottleneck Identified**: Database query on `/api/orders` (missing index on `user_id, status`). Fixed by adding compound index → p99 reduced to 420ms.

---

## 9. Deployment Strategy

### 9.1 CI/CD Pipeline

**Git Workflow**:
```
feature branch → PR → code review → merge to main → auto-deploy staging → manual approval → deploy production
```

**Pre-deploy Checks**:
- [ ] All tests pass (unit, integration)
- [ ] Lighthouse CI score > 90
- [ ] No high/critical security vulnerabilities (npm audit)
- [ ] Database migrations tested in staging

### 9.2 Deployment Checklist

**Pre-deployment**:
- [ ] Backup database
- [ ] Lower DNS TTL to 60s (for quick rollback)
- [ ] Notify team in Slack #deployments
- [ ] No Friday deploys (unless emergency)

**Deployment**:
- [ ] Run database migrations (zero-downtime via expand-and-contract)
- [ ] Deploy new application version
- [ ] Run smoke tests on production
- [ ] Monitor error rate + latency for 30 min

**Post-deployment**:
- [ ] Verify key user flows (signup, login, checkout)
- [ ] Restore DNS TTL to 3600s
- [ ] Close deployment ticket

### 9.3 Rollback Plan

**Trigger**: Error rate > 5% OR p95 latency > 2s for 5 min

**Steps**:
1. Revert to previous deployment (Vercel: 1-click rollback)
2. If database migration was applied, run rollback migration
3. Clear CDN cache (`Purge Everything`)
4. Verify error rate returns to baseline
5. Post-mortem within 24h

---

## 10. Open Questions & Risks

### 10.1 Open Questions

1. **[Question 1]**: [Description]  
   **Owner**: [Name]  
   **Due**: [Date]

2. **[Question 2]**: [Description]

### 10.2 Risks & Mitigation

| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|------------|
| Third-party API downtime (Stripe) | Medium | High | Implement circuit breaker + retry logic; graceful degradation (allow "pay later") |
| Database connection exhaustion | Low | High | Connection pooling + read replicas; alert at 80% pool usage |
| DDoS attack | Medium | Medium | Cloudflare WAF + rate limiting; can upgrade to "Under Attack Mode" |

---

## 11. Appendix

### 11.1 References

- Original PRD: `[link]`
- FSD Technical Spec: `[link]`
- Load Testing Report: `[link]`

### 11.2 Change Log

| Date | Version | Author | Changes |
|------|---------|--------|---------|
| 2024-01-15 | 1.0 | [Name] | Initial system design |
| 2024-02-01 | 1.1 | [Name] | Added caching strategy, updated scaling triggers |
