# AI Agent Guidelines - Go Project

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
