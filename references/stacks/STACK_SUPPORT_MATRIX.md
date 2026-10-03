# Tech Stack Support Matrix

**Last Updated**: 2026-10-03

## Currently Supported (Full M06 Support)

Stacks with complete scaffold, harness templates, version gates, and verification commands:

| Stack | Scaffold | AGENTS.md | ARCHITECTURE.md | Version Gate | VERIFY Commands | Status |
|:------|:---------|:----------|:----------------|:-------------|:----------------|:-------|
| **Next.js 15** | ✅ `pnpm create next-app@latest` | ✅ | ✅ | ✅ | `npm run type-check`, `npm run build` | **PRODUCTION** |
| **Laravel 11** | ✅ `composer create-project laravel/laravel` | ✅ | ✅ | ✅ | `php artisan test`, `composer audit` | **PRODUCTION** |
| **Django 5** | ✅ `django-admin startproject` | ✅ | ✅ | ✅ | `python manage.py test`, `pip-audit` | **PRODUCTION** |
| **Go 1.23** | ✅ `go mod init` | ✅ | ✅ | ✅ | `go test ./...`, `go build` | **PRODUCTION** |

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
- **Rapid Prototyping**: Next.js 15 (React + TypeScript)
- **API-Heavy Backend**: Laravel 11 or Django 5
- **Microservices**: Go 1.23

### Mobile Applications
- **Status**: Not yet supported by skill
- **Workaround**: Use Next.js + PWA for cross-platform web apps

### Enterprise/Legacy
- **PHP**: Use Laravel 11 (modern PHP framework)
- **.NET/Java**: Pending template development

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
