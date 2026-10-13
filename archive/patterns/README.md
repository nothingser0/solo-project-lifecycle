# Archive: Technical Architecture & Implementation Patterns

This directory preserves historical pattern guides, architectural deep dives, and reference implementations used in earlier iterations of the solo-project-lifecycle framework. For current authoritative modules and active templates, refer to `docs/modules/` and `templates/`.

## Catalog of Archived Patterns

### 1. API Design & Versioning
- [`api/rest-conventions.md`](./api/rest-conventions.md): Standard RESTful URL design, HTTP verbs, status codes, and error payload schemas.
- [`api/graphql-and-versioning.md`](./api/graphql-and-versioning.md): Schema design patterns, mutation handling, and API version evolution strategies.

### 2. Database & Data Management
- [`database/seeding-and-transactions.md`](./database/seeding-and-transactions.md): Deterministic seeding, ACID transaction wrappers, and isolation boundaries.
- [`database/supabase-migrations.md`](./database/supabase-migrations.md): Declarative database migrations and schema lifecycle management with Supabase CLI.

### 3. Architecture & Software Design Patterns
- [`design-patterns/SOFTWARE_DESIGN_PATTERNS.md`](./design-patterns/SOFTWARE_DESIGN_PATTERNS.md): Catalog of architectural patterns (Repository, Unit of Work, Factory, Event Dispatcher).
- [`error-handling/error-boundaries.md`](./error-handling/error-boundaries.md): Hierarchical error boundaries, panic recovery, and defensive UI fallbacks.
- [`git-workflow/branching-strategy.md`](./git-workflow/branching-strategy.md): Trunk-based development, feature branch lifecycles, and atomic commit practices.

### 4. Performance & Reliability
- [`performance/caching-strategies.md`](./performance/caching-strategies.md): Multi-tier caching patterns (HTTP cache-control, in-memory Redis, stale-while-revalidate).
- [`performance/n-plus-one-prevention.md`](./performance/n-plus-one-prevention.md): ORM eager loading, join batching, and query complexity monitoring.
- [`observability/logging-monitoring.md`](./observability/logging-monitoring.md): Structured logging, correlation IDs, and application metrics instrumentation.

### 5. Quality Assurance & Deployment
- [`testing/test-pyramid.md`](./testing/test-pyramid.md): Balance between unit tests, integration testing, and end-to-end smoke verification.
- [`security/authentication.md`](./security/authentication.md): Session management, JWT best practices, and password hashing standards.
- [`validation/zod-patterns.md`](./validation/zod-patterns.md): Runtime schema validation and boundary defensive programming with Zod.
- [`deployment/ci-cd-pipeline.md`](./deployment/ci-cd-pipeline.md): Pipeline automation, stage gates, and zero-downtime release deployment flow.
