# Tech Stack Support Matrix

**Last Updated**: 2026-10-03

## Currently Supported (Full M06 Support)

Stacks with complete scaffold, harness templates, version gates, and verification commands:

| Stack | Scaffold | AGENTS.md | ARCHITECTURE.md | Version Gate | VERIFY Commands | Status |
|:------|:---------|:----------|:----------------|:-------------|:----------------|:-------|
| **Next.js** | ✅ `pnpm create next-app@latest` | ✅ | ✅ | ✅ package-lock.json | `npm run type-check`, `npm run build` | **PRODUCTION** |
| **Laravel** | ✅ `composer create-project laravel/laravel` | ✅ | ✅ | ✅ composer.lock | `php artisan test`, `composer audit` | **PRODUCTION** |
| **Django** | ✅ `django-admin startproject` | ✅ | ✅ | ✅ requirements.txt | `python manage.py test`, `pip-audit` | **PRODUCTION** |
| **Go** | ✅ `go mod init` | ✅ | ✅ | ✅ go.mod | `go test ./...`, `go build` | **PRODUCTION** |

**Note**: Versions determined by M05 real-time registry check, NOT hardcoded by skill.
- M05 runs `npm view next version` → locks result in FSD.md
- M06 scaffolds @latest → pins exact FSD version → version gate validates lockfile
- Templates tested with current stable versions (as of 2026-10-03)
- Cross-major-version compatibility not guaranteed (Next.js 15→16 may need template updates)

---

## Roadmap: 8 Additional Stacks

### Phase 1: JavaScript Ecosystem (Estimated 10-15 days)

**1. Ruby on Rails** (5-7 days)
- Scaffold: `rails new project-name --database=postgresql --skip-git`
- Version gate: Parse Gemfile.lock for `rails (x.x.x)`
- Templates needed:
  - `AGENTS.md`: Ruby style (snake_case), Rails conventions, ActiveRecord patterns
  - `ARCHITECTURE.md`: MVC structure, app/models, app/controllers, app/views
  - `CONVENTIONS.md`: Ruby gems, Bundler, RSpec/Minitest
- Verification: `bundle exec rspec`, `bundle audit`
- Use case: Rapid MVPs, startup prototyping, convention-over-configuration

**2. Remix** (2-3 days)
- Scaffold: `npx create-remix@latest`
- Version gate: package-lock.json (similar to Next.js)
- Templates needed:
  - `AGENTS.md`: Reuse Next.js base, add Remix-specific (loader/action patterns, nested routes)
  - `ARCHITECTURE.md`: app/routes structure, loader/action exports
- Verification: `npm run build`, `npm run typecheck`
- Use case: Progressive enhancement, web standards focus, nested routing

**3. MERN Stack** (3-4 days)
- Scaffold: Express.js generator + MongoDB setup scripts
- Version gate: package-lock.json
- Templates needed:
  - `AGENTS.md`: Express middleware patterns, Mongoose schemas
  - `ARCHITECTURE.md`: MongoDB collections, Express routes, React frontend
  - `CONVENTIONS.md`: NoSQL data modeling, aggregation pipelines
- Verification: `npm test`, `mongosh` validation
- Use case: Real-time apps, flexible NoSQL data, rapid iteration

---

### Phase 2: Enterprise Backends (Estimated 20-25 days)

**4. ASP.NET Core** (7-10 days)
- Scaffold: `dotnet new webapi -n ProjectName`
- Version gate: Parse .csproj for `<TargetFramework>net8.0</TargetFramework>` and NuGet packages
- Templates needed:
  - `AGENTS.md`: C# conventions (PascalCase, async/await, LINQ patterns)
  - `ARCHITECTURE.md`: Controllers, Models, Services pattern, Entity Framework
  - `CONVENTIONS.md`: Dependency injection, middleware pipeline, appsettings.json
- Verification: `dotnet test`, `dotnet build`
- Use case: Enterprise SaaS, finance, healthcare, Microsoft ecosystem integration

**5. Spring Boot** (7-10 days)
- Scaffold: `spring init --dependencies=web,data-jpa --build=maven`
- Version gate: Parse pom.xml (Maven) or build.gradle (Gradle) for Spring Boot version
- Templates needed:
  - `AGENTS.md`: Java conventions (camelCase, annotations, streams)
  - `ARCHITECTURE.md`: Controllers, Services, Repositories, JPA entities
  - `CONVENTIONS.md`: Maven/Gradle, application.properties, Bean lifecycle
- Verification: `mvn test` or `gradle test`, `mvn package`
- Use case: Banking, e-commerce, microservices, enterprise backends

**6. JAMstack** (3-5 days)
- Scaffold: `npm create astro@latest` or `npx degit 11ty/eleventy-base-blog`
- Version gate: package-lock.json
- Templates needed:
  - `AGENTS.md`: Subset of Next.js (no API routes, focus on SSG)
  - `ARCHITECTURE.md`: Static generation, content sources (Markdown/CMS)
  - `CONVENTIONS.md`: Build-time data fetching, CDN deployment
- Verification: `npm run build`, check dist/ output
- Use case: Marketing sites, blogs, documentation, high-performance static content

---

### Phase 3: Specialized Architectures (Estimated 25-30 days)

**7. Serverless** (10-15 days)
- Scaffold: `sam init` (AWS SAM) or `serverless create --template aws-nodejs`
- Version gate: Parse serverless.yml or template.yaml for runtime versions
- Templates needed:
  - `AGENTS.md`: Event-driven patterns, stateless functions, cold start optimization
  - `ARCHITECTURE.md`: Lambda functions, API Gateway, DynamoDB/S3 integration
  - `CONVENTIONS.md`: Infrastructure-as-code, environment variables, IAM policies
- Verification: `sam validate`, `serverless package`
- Use case: Event-driven systems, variable workloads, pay-per-use cost model
- **Note**: Different deployment model (not traditional server), separate M07 deployment guide needed

**8. Flutter** (10-15 days)
- Scaffold: `flutter create project_name`
- Version gate: Parse pubspec.lock for Flutter SDK and package versions
- Templates needed:
  - `AGENTS.md`: Dart conventions (camelCase, async/await, widget composition)
  - `ARCHITECTURE.md`: lib/screens, lib/widgets, lib/services, state management (Riverpod/Bloc)
  - `CONVENTIONS.md`: pubspec.yaml, platform channels, asset management
- Verification: `flutter analyze`, `flutter test`, `flutter build apk --debug`
- Use case: iOS + Android apps from single Dart codebase
- **Note**: Mobile lifecycle (app stores, device testing, platform-specific features) differs from web development

---

### Excluded from Roadmap (Not Standalone Frameworks)

**LAMP** (Linux + Apache + MySQL + PHP)
- **Decision**: Raw PHP without framework → recommend Laravel instead
- Laravel is modern PHP with routing, ORM, security - no reason to support raw PHP

**Android Kotlin**
- **Decision**: Native single-platform mobile → recommend Flutter for cross-platform instead
- If user specifically needs Kotlin, they're doing native development (outside solo web workflow)

**AI/ML Stack** (TensorFlow/PyTorch)
- **Decision**: Not a web framework - it's a complementary layer added to backends
- Django/Flask + TensorFlow is supported via Django templates + custom integration

**Blockchain** (Ethereum, Hyperledger, Solidity)
- **Decision**: Specialized domain with fundamentally different development paradigm
- Smart contract deployment, gas optimization, consensus ≠ CRUD web apps
- Outside scope of solo web project lifecycle

---

## Recommendation for New Projects

### Web Applications (SaaS, Dashboards, CRMs)
- **Rapid Prototyping**: Next.js (React + TypeScript) - check latest stable in M05
- **API-Heavy Backend**: Laravel or Django - check latest stable in M05
- **Microservices**: Go - check latest stable in M05

### Mobile Applications
- **Status**: Not yet supported by skill
- **Workaround**: Use Next.js + PWA for cross-platform web apps

### Enterprise/Legacy
- **PHP**: Use Laravel (modern PHP framework, check latest in M05)
- **.NET/Java**: Pending template development

### Version Selection Process

**M05 Module: Real-Time Version Check**
```bash
# Step 1: Check registry for latest stable
npm view next version          # Output: 16.3.8 (example, actual varies)
composer show laravel/framework --latest  # Output: 11.5.2 (example)
pip index versions django | head -1       # Output: 5.1.3 (example)
go version                                # Check installed Go toolchain

# Step 2: Lock in FSD.md
## Framework Versions (Pinned):
- Next.js: 16.3.8
- React: 19.2.8
- Node.js: 22.11.0

# Step 3: Human approves locked versions
# Step 4: M06 scaffolds + pins exact versions from FSD
```

**Why Real-Time Check?**
- Skill written 2026-10-03, but used 2027-04-15 → Next.js might be 17.x
- Security patches: Django 5.0.1 → 5.0.8 (critical fixes)
- Breaking changes: User decides to lock known-stable version vs bleeding edge

---

## Adding New Stack Support

Required components for M06 production support:

### 1. Scaffold Command
```bash
# Example: Ruby on Rails
rails new project-name --database=postgresql --skip-git
```

### 2. Version Gate Script
- Parse lockfile format (Gemfile.lock, packages-lock.json, etc.)
- Extract major.minor versions
- Compare against FSD.md locked versions

### 3. Harness Templates
- `templates/04-dev-execution/{stack}/AGENTS.md`
- `templates/04-dev-execution/{stack}/ARCHITECTURE.md`
- `templates/04-dev-execution/{stack}/CONVENTIONS.md`
- `templates/04-dev-execution/{stack}/.env.example`

### 4. Verification Commands (Stack-Specific)
```markdown
# Next.js
npm run type-check && npm run build

# Laravel
php artisan test && composer audit

# Django
python manage.py test && pip-audit

# Go
go test ./... && go build

# Rails (example for new stack)
bundle exec rspec && bundle audit
```

### 5. VERIFY_LOCAL Template Adaptation
- Stack-specific test commands
- Framework-specific error patterns (hydration for SSR, N+1 for ORM)
- Ecosystem-specific security checks

---

## Implementation Status

**Current Coverage**: 4/12 stacks fully supported (33%)
**Roadmap**: 8 additional stacks across 3 phases
**Total Effort**: ~60 days development + testing
**Timeline**: 12 months to reach 12/12 (100%)

**Expansion Strategy**: Demand-driven
- Phase 1 (Rails/Remix/MERN): Implement when JavaScript/Ruby clients appear
- Phase 2 (.NET/Spring/JAMstack): Implement for enterprise clients
- Phase 3 (Serverless/Flutter): Implement for specialized projects

**Truth**: Skill supports FRAMEWORKS not VERSIONS
- ✅ Templates adapt to framework patterns (routing, ORM, validation)
- ✅ Version locked per-project in M05 via real-time registry check
- ✅ Cross-major-version compatibility requires template validation per major release
