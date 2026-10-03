# AI Agent Guidelines - Go Project

## CRITICAL: Read Official Documentation First

**BEFORE implementing any feature, check official docs for current syntax:**

- **Framework Docs**: Check version-specific pages for current API
- **ORM Docs**: Database query syntax, migrations, relationships
- **Validation Docs**: Input validation, form handling

**Why**: Framework syntax changes between versions. This project uses specific versions locked in FSD.md.

**When uncertain about syntax:**
1. Read official docs for installed version
2. Check migration guides for breaking changes
3. Verify with tests before committing

## CRITICAL: Read Project Design Specifications

**BEFORE implementing any UI component, read project design docs in docs/ folder:**

- **docs/specs/DESIGN_SYSTEM.md**: Design tokens, screen specifications, component styles
- **docs/specs/SITEMAP.md**: Route structure with Screen IDs (SCR-XX)
- **docs/design/stitch-output/**: Generated screen components (if using Google Stitch)
- **DESIGN.md** (root): Simplified tokens reference (copied from docs/)

**Why**: Generic styles ≠ project design. Must match brand identity.

**For each screen/component:**
1. Find screen ID in docs/specs/SITEMAP.md (e.g., SCR-09 Dashboard)
2. Read corresponding section in docs/specs/DESIGN_SYSTEM.md
3. Check docs/design/stitch-output/SCR-09/ if available
4. Extract design tokens from DESIGN.md (root)
5. Implement exactly as specified

---
## Code Style Rules
1. **gofmt/goimports**: Auto-format all code.
2. **Error Handling**: Always check errors, never ignore.
3. **File Naming**: snake_case for files (`user_service.go`), PascalCase for exported symbols.
4. **Validation**: Use validator package or custom validation functions.
5. **Package Structure**: Clean architecture (cmd, internal, pkg).

## Database
- ORM: sqlx (preferred) or GORM
- Migrations: golang-migrate or goose
- Queries: Use prepared statements

## Testing
- Run: `go test ./...`
- Coverage: `go test -cover ./...`
- Must pass before commit

## Build Commands
- Dev: `go run cmd/server/main.go`
- Build: `go build -o bin/app cmd/server/main.go`
- Lint: `golangci-lint run`

## Commit Format
```
feat: add user profile handler
fix: resolve token expiry logic
refactor: extract payment service
```

## Anti-Patterns (NEVER)
- ❌ No ignored errors (`_ = doSomething()`)
- ❌ No panics in production code
- ❌ No global state (use dependency injection)
- ❌ No fmt.Println in committed code (use logger)
- ❌ No SQL injection (use parameterized queries)
