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
- Skill templates work across framework versions (Next.js 15, 16, 17+)

---

## Candidate Stacks (Research/Planning Only)

From "12 Tech Stacks Worth Considering 2026" - pending template development:

### JavaScript Ecosystem
1. **MERN/MEAN** (MongoDB + Express + React/Angular + Node)
   - **Overlap with Next.js**: Next.js already covers React + Node
   - **Gap**: MongoDB templates, Express backend structure
   - **Effort**: 2-3 days (add MongoDB ARCHITECTURE.md, seed templates)

2. **JAMstack** (JavaScript + APIs + Markup)
   - **Overlap with Next.js**: Next.js supports static generation
   - **Gap**: Pure static site scaffold (no API routes)
   - **Effort**: 1 day (subset of Next.js templates)

### Backend-Heavy
3. **Ruby on Rails**
   - **Status**: No templates
   - **Effort**: 5-7 days (AGENTS.md, ARCHITECTURE.md, version gate, Gemfile parsing)

4. **Microsoft .NET** (C# + ASP.NET Core)
   - **Status**: No templates
   - **Effort**: 5-7 days (.csproj parsing, NuGet version gate, C# conventions)

5. **Spring (Java)**
   - **Status**: No templates
   - **Effort**: 5-7 days (pom.xml/build.gradle, Maven/Gradle version gate)

### Legacy/Specialized
6. **LAMP** (Linux + Apache + MySQL + PHP)
   - **Overlap with Laravel**: Laravel is modern PHP
   - **Gap**: Raw PHP (no framework) support
   - **Note**: Recommend Laravel instead for new projects

7. **Python Django** - ✅ **ALREADY SUPPORTED**

### Mobile/Cross-Platform
8. **Flutter** (Dart + iOS/Android)
   - **Status**: No templates (mobile-first, different lifecycle)
   - **Effort**: 10+ days (mobile-specific M04 prototype, app store deployment)

9. **Android Kotlin**
   - **Status**: No templates
   - **Effort**: 10+ days (mobile architecture, separate from web flow)

### Specialized Architectures
10. **Serverless** (AWS Lambda, Azure Functions, Google Cloud Functions)
    - **Status**: No templates
    - **Gap**: Event-driven architecture (no traditional server scaffold)
    - **Effort**: 7-10 days (infrastructure-as-code, deployment templates)

11. **AI/ML Stack** (TensorFlow/PyTorch + Python)
    - **Status**: Not a web framework
    - **Note**: Complementary to backend stacks, not replacement

12. **Blockchain** (Ethereum, Hyperledger, Solidity)
    - **Status**: Not a web framework
    - **Note**: Specialized domain, different development lifecycle

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
go list -m -versions golang.org/x/mod    # Check Go releases

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

## Priority Roadmap

### Q4 2026 (If Requested)
1. **Ruby on Rails** (high demand for MVPs)
2. **MERN** (MongoDB templates for Next.js)

### Q1 2027
3. **.NET Core** (enterprise demand)
4. **Spring Boot** (Java enterprise)

### Future Consideration
- Serverless templates (infrastructure-as-code)
- Flutter/React Native (mobile pivot)

---

**Current Coverage**: 4/12 stacks fully supported (33%)  
**Recommended Action**: Focus on 4 production stacks, expand only on explicit client demand
