# Architecture Decision Record (ADR) Template

> **Purpose**: Document significant architectural decisions for Enterprise projects  
> **When**: M05 Architecture phase or whenever major technical decision made  
> **Target**: Enterprise projects requiring governance and long-term maintainability

---

## ADR-001: [Short Title of Decision]

**Date**: YYYY-MM-DD  
**Status**: Proposed | Accepted | Deprecated | Superseded  
**Deciders**: [Names of decision makers]  
**Technical Story**: [Ticket/issue link]

---

## Context and Problem Statement

**What decision needs to be made?**

[Describe the architectural issue or problem that requires a decision. Include business context, technical constraints, and why this decision matters.]

**Example**:
```
Our monolithic API is experiencing performance issues at 5000+ concurrent users.
Response times exceed 2 seconds during peak hours. We need to decide how to scale
the system to support 50,000+ concurrent users within 6 months.

Business Context:
- Expected user growth: 10x in next 6 months
- SLA requirement: 99.9% uptime, <200ms API response
- Budget: $50k infrastructure, $200k development

Technical Context:
- Current: Single EC2 instance (16 vCPU, 64GB RAM)
- Database: PostgreSQL RDS (2TB, single primary)
- Framework: Node.js + Express
```

---

## Decision Drivers

**What factors influence this decision?**

- [ ] Performance requirements
- [ ] Scalability needs
- [ ] Cost constraints
- [ ] Team expertise
- [ ] Time to market
- [ ] Maintenance burden
- [ ] Security requirements
- [ ] Compliance requirements

**Constraints**:
- Budget: $X
- Timeline: X months
- Team size: X developers
- Current tech stack: [list]

---

## Considered Options

### Option 1: [Option Name]

**Description**: [Brief description]

**Pros**:
- ✅ [Advantage 1]
- ✅ [Advantage 2]

**Cons**:
- ❌ [Disadvantage 1]
- ❌ [Disadvantage 2]

**Cost**: $X (one-time) + $Y/month (recurring)

**Timeline**: X weeks to implement

**Risk Level**: Low | Medium | High

---

### Option 2: [Option Name]

[Same format as Option 1]

---

### Option 3: [Option Name]

[Same format as Option 1]

---

## Decision Outcome

**Chosen Option**: Option X - [Name]

**Rationale**:

[Explain why this option was chosen over alternatives. Reference decision drivers and how this option best satisfies them.]

**Example**:
```
Chosen: Microservices architecture with Kubernetes

Rationale:
- Performance: Horizontal scaling handles 50k+ users (tested in POC)
- Cost: $35k infrastructure (within $50k budget)
- Timeline: 4 months implementation (meets 6-month deadline)
- Team: 2 engineers have K8s experience (low learning curve)
- Risk: Medium (mitigated by staged rollout)

Rejected Options:
- Vertical scaling: Cannot reach 50k users (tested max 10k)
- Serverless: Cost $80k/month at scale (exceeds budget)
```

---

## Consequences

### Positive Consequences

- ✅ [Benefit 1]
- ✅ [Benefit 2]
- ✅ [Benefit 3]

### Negative Consequences

- ⚠️ [Tradeoff 1]
- ⚠️ [Tradeoff 2]

### Risks

- 🔴 **High Risk**: [Risk description] → Mitigation: [How to mitigate]
- 🟡 **Medium Risk**: [Risk description] → Mitigation: [How to mitigate]

---

## Implementation Plan

### Phase 1: Proof of Concept (Weeks 1-2)
- [ ] Build minimal microservice
- [ ] Load test with 10k users
- [ ] Measure latency and costs

### Phase 2: Core Services (Weeks 3-8)
- [ ] Split monolith into 5 services
- [ ] Set up Kubernetes cluster
- [ ] Implement service mesh

### Phase 3: Migration (Weeks 9-12)
- [ ] Blue-green deployment
- [ ] Gradual traffic shift (10% → 50% → 100%)
- [ ] Rollback plan ready

### Phase 4: Optimization (Weeks 13-16)
- [ ] Performance tuning
- [ ] Cost optimization
- [ ] Documentation

---

## Validation

**Success Criteria**:
- [ ] API response time <200ms (p95)
- [ ] System handles 50k concurrent users
- [ ] Infrastructure cost <$50k/month
- [ ] 99.9% uptime SLA met

**Measurement**:
- Load testing: k6 scripts
- Monitoring: Datadog APM
- SLA tracking: Pingdom

**Review Date**: [Date 3 months post-implementation]

---

## Links

**Related ADRs**:
- ADR-002: Database sharding strategy
- ADR-005: API gateway selection

**References**:
- [POC results](link)
- [Load test report](link)
- [Cost analysis spreadsheet](link)
- [Architecture diagram](link)

**Discussion**:
- [Slack thread](link)
- [Design review meeting notes](link)

---

---

## Example: Filled ADR

```markdown
# ADR-003: Migrate from REST to GraphQL API

Date: 2024-10-04
Status: Accepted
Deciders: John (CTO), Sarah (Tech Lead), Mike (Backend Lead)
Technical Story: JIRA-1234

---

## Context

Our REST API has 150+ endpoints. Mobile team complains about:
- Over-fetching (GET /users returns 50 fields, only need 5)
- Under-fetching (Need 3 API calls to display one screen)
- API versioning hell (v1, v2, v3 coexist)

Mobile app performance:
- 10+ API calls per screen load
- 5 seconds average load time
- High data usage (200MB/hour)

Business impact:
- User churn: 30% abandon during slow load
- Support tickets: 50/week about "app is slow"

---

## Decision Drivers

- Performance: Target <2s screen load
- Developer experience: Reduce API calls from 10 to 1
- Mobile data usage: Reduce by 70%
- Cost: Backend cost must not increase >20%
- Team: 3 backend devs, 2 mobile devs
- Timeline: 3 months to MVP

---

## Considered Options

### Option 1: GraphQL (Apollo Server)

Pros:
✅ Single endpoint, client specifies fields
✅ Reduces over-fetching by 80% (tested)
✅ Strong typing, auto-generated docs
✅ Subscriptions for real-time features

Cons:
❌ Learning curve (team has no GraphQL experience)
❌ Complex caching strategy
❌ N+1 query problem (need DataLoader)

Cost: $0 (open source) + $5k training
Timeline: 3 months (2 months migration + 1 month optimization)
Risk: Medium (new tech, but mature ecosystem)

---

### Option 2: REST with Field Selection

Pros:
✅ No new tech (team already knows REST)
✅ Simple caching (HTTP cache headers)
✅ Fast implementation (2 weeks)

Cons:
❌ Still need multiple endpoints
❌ Field selection logic per endpoint (boilerplate)
❌ No auto-documentation

Cost: $0
Timeline: 2 weeks
Risk: Low

---

### Option 3: gRPC

Pros:
✅ High performance (binary protocol)
✅ Strong typing (Protobuf)

Cons:
❌ Not web-friendly (needs gRPC-web proxy)
❌ No browser support (mobile only)
❌ Steep learning curve

Cost: $0
Timeline: 4 months
Risk: High (complex setup)

---

## Decision

Chosen: Option 1 - GraphQL (Apollo Server)

Rationale:
- Performance: POC showed 70% reduction in data transfer
- Developer experience: 10 API calls → 1 GraphQL query
- Timeline: 3 months acceptable (meets Q4 deadline)
- Risk: Mitigated by 1-week training + POC validation
- Future-proof: Supports subscriptions for upcoming chat feature

Rejected:
- REST field selection: Doesn't solve multiple-calls problem
- gRPC: Overkill, web incompatible

---

## Consequences

Positive:
✅ Mobile app load time: 5s → <2s (60% improvement)
✅ Data usage: 200MB/hour → 60MB/hour (70% reduction)
✅ Developer velocity: Fewer backend changes when adding mobile features
✅ Auto-documentation: GraphQL Playground

Negative:
⚠️ Backend complexity increases (schema stitching, DataLoader)
⚠️ Caching strategy more complex (field-level caching)
⚠️ Team learning curve (1-2 weeks ramp-up)

Risks:
🔴 N+1 queries could slow down API
   Mitigation: DataLoader batching, monitoring slow queries
🟡 Schema breaking changes impact mobile
   Mitigation: Schema versioning, deprecation warnings

---

## Implementation

Phase 1: POC (Week 1-2)
✅ Build GraphQL API for User + Orders entities
✅ Load test with 1000 concurrent users
✅ Measure performance vs REST

Phase 2: Core Schema (Week 3-6)
- [ ] Migrate top 20 REST endpoints to GraphQL
- [ ] Implement DataLoader for all resolvers
- [ ] Set up Apollo Server monitoring

Phase 3: Mobile Migration (Week 7-10)
- [ ] Mobile app uses GraphQL for new screens
- [ ] A/B test GraphQL vs REST (measure performance)
- [ ] Migrate remaining screens if A/B test successful

Phase 4: Deprecate REST (Week 11-12)
- [ ] Add deprecation warnings to old REST endpoints
- [ ] Monitor usage, reach out to remaining consumers
- [ ] Shut down old endpoints

---

## Validation

Success Criteria:
✅ Mobile load time <2s (measured: 1.8s avg)
✅ Data usage reduced >60% (measured: 72% reduction)
✅ Zero performance regressions (p95 latency <200ms)
✅ Developer satisfaction score >4/5 (survey: 4.3/5)

Review Date: 2025-01-04 (3 months post-launch)

---

## Links

Related ADRs:
- ADR-004: Real-time chat architecture (uses GraphQL subscriptions)

References:
- POC results: https://docs.company.com/graphql-poc
- Load test: https://k6.io/reports/123
- Training materials: https://learn.company.com/graphql

Discussion:
- Slack: #architecture-decisions thread (Sep 15-20)
- Design review: https://meet.google.com/xyz (recording)
```

---

## ADR Governance

### When to Write an ADR

**Required for**:
- ✅ Technology stack changes (framework, database, language)
- ✅ Architectural patterns (microservices, event-driven, monolith)
- ✅ Infrastructure decisions (cloud provider, CI/CD, hosting)
- ✅ Security architecture (auth, encryption, secrets management)
- ✅ Data architecture (schema, partitioning, caching)

**Not required for**:
- ❌ Library choices (unless mission-critical)
- ❌ Code style decisions (use linter config)
- ❌ Minor refactorings

**When in doubt**: If decision impacts >3 engineers or lasts >6 months → Write ADR

---

### ADR Lifecycle

```
[Proposed] → [Accepted] → [Implemented] → [Validated]
    ↓
[Rejected] (document why)
    ↓
[Deprecated] (superseded by newer ADR)
```

**Status Definitions**:
- **Proposed**: Under discussion, not yet decided
- **Accepted**: Decision made, implementation pending
- **Rejected**: Considered but not chosen (document why)
- **Deprecated**: No longer valid (link to superseding ADR)
- **Superseded**: Replaced by newer decision

---

### ADR Naming Convention

```
ADR-001-choose-database.md
ADR-002-api-authentication.md
ADR-003-microservices-vs-monolith.md
```

**Format**: `ADR-XXX-kebab-case-title.md`

**Storage**: `docs/architecture/adr/`

---

### ADR Review Process

**Before Accepting**:
1. Circulate ADR to stakeholders (Slack, email)
2. Collect feedback (comments, +1, concerns)
3. Hold design review meeting (if controversial)
4. Update ADR based on feedback
5. Mark as "Accepted" when consensus reached

**After Implementation**:
1. Update ADR with actual outcomes
2. Compare to success criteria
3. Document lessons learned
4. Schedule review (3-6 months post-implementation)

---

## Tools

**ADR Management**:
- Manual: Markdown files in Git
- `adr-tools`: CLI for managing ADRs (https://github.com/npryce/adr-tools)
- Notion/Confluence: Web-based ADR database

**Templates**:
- MADR: Markdown ADR (this template)
- Y-Statements: "In the context of X, facing Y, we decided Z"
- Alexandrian Pattern: More narrative format

---

## Checklist

Before writing ADR:
- [ ] Decision is significant (impacts architecture)
- [ ] Multiple options exist (not obvious choice)
- [ ] Stakeholders identified
- [ ] Success criteria defined

While writing ADR:
- [ ] Context clearly explained
- [ ] At least 2 options considered
- [ ] Pros/cons for each option
- [ ] Decision rationale documented
- [ ] Consequences (positive + negative) listed
- [ ] Implementation plan outlined

After ADR accepted:
- [ ] ADR reviewed by stakeholders
- [ ] ADR committed to repo
- [ ] Linked from relevant docs
- [ ] Announced to team (Slack, email)

Post-implementation:
- [ ] Validate against success criteria
- [ ] Update ADR with outcomes
- [ ] Schedule review meeting

---

## Notes

**ADRs are immutable**: Never edit old ADRs. If decision changes, write new ADR that supersedes old one.

**ADRs are not specs**: Keep them concise (1-2 pages). Link to detailed specs/docs.

**ADRs are for future you**: Write for someone reading this in 2 years who asks "Why did we choose X?"

**ADRs build institutional knowledge**: Prevents re-litigating old decisions
