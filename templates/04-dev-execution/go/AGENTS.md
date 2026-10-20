# AI Agent Guidelines - Go Project

## 0. Execution Protocol — One Task Per Turn (NON-NEGOTIABLE)

- **`TODO.md` is the queue.** Work its task list **one task at a time**.
- **Per task**: implement ONLY that task → run that task's `Verify` command → paste the raw output → report task ID + files touched + result → 🛑 **END TURN**.
- **Do NOT** start the next task, open a new sprint, or batch task IDs — unless the human names the specific task IDs to run in one instruction.
- **`[x]` is the human's mark, never yours.** Only after the human confirms may you record `Approved: <date> by <name>` in that task's `Evidence`.
- **If a spec, schema, or requirement is missing, STOP and ask** — never invent it to keep the queue moving.

---

## 1. Absolute Agent Safety Directives (NON-NEGOTIABLE)
1. **NO Destructive Git Operations**: Running `git push --force` or `git push --force-with-lease` is STRICTLY PROHIBITED.
2. **NO Destructive Database Operations in Shared / Deployed Environments**: Running database reset scripts or issuing raw `DROP TABLE` / `DROP DATABASE` queries against shared, staging, or production environments is STRICTLY PROHIBITED. On local disposable test databases, execute resets only when explicitly instructed.
3. **Spec Document Integrity**: Documents marked `[FROZEN]` or `[APPROVED]` (`PRD.md`, `FSD.md`, `DESIGN_SPEC.md`, `DESIGN.md`, `SCOPE_STATEMENT.md`) are immutable. If specifications contradict, STOP AND ASK THE USER. Never alter frozen specifications unilaterally.
4. **Zero Ignored Errors**: Silencing errors via `_ = doSomething()` or unchecked type assertions is STRICTLY PROHIBITED.
5. **No Unrequested Commits**: Never execute commits or pushes unless explicitly instructed by the user.

---

## CRITICAL: Read Project Design Specifications

**BEFORE implementing any UI component, read project design docs in docs/ folder:**

- **docs/specs/DESIGN_SPEC.md**: Per-screen 5-state specifications (SCR-XX)
- **docs/specs/SITEMAP.md**: Route structure with Screen IDs (SCR-XX)
- **DESIGN.md** (root, staged at `docs/harness-root/DESIGN.md`): design tokens (colors, typography, z-index)

**Why**: Generic styles ≠ project design. Must match brand identity.

**For each screen/component:**
1. Find screen ID in docs/specs/SITEMAP.md (e.g., SCR-09 Dashboard)
2. Read corresponding screen section in docs/specs/DESIGN_SPEC.md
3. Check docs/design/screens/scr-09/ (or docs/design/prompts/scr-09/) if available
4. Extract design tokens from DESIGN.md (root)
5. Implement exactly as specified


## CRITICAL: Read Official Documentation First

**BEFORE implementing any feature, check official docs for current syntax:**

- **Go Docs**: https://go.dev/doc/ (check version-specific pages)
- **Standard Library**: https://pkg.go.dev/std
- **Go by Example**: https://gobyexample.com/ (practical patterns)

**Why**: Go syntax and stdlib evolve between versions. This project uses:
- Go 1.23.x (check go.mod for exact version)
- Breaking changes rare but stdlib additions common (generics in 1.18+, slices package in 1.21+)

### Version-Specific Syntax Enforcement

**MANDATORY: Check docs before using these APIs** (syntax/stdlib changes):

| API Category | Docs URL | Common Version Conflicts |
|:-------------|:---------|:-------------------------|
| **HTTP Server** | https://pkg.go.dev/net/http | Handler patterns evolve |
| **Context** | https://pkg.go.dev/context | Usage patterns standardized |
| **Generics** | https://go.dev/doc/tutorial/generics | Added in 1.18+ |
| **Slices Package** | https://pkg.go.dev/slices | Added in 1.21+ |
| **Database/SQL** | https://pkg.go.dev/database/sql | Connection pool changes |
| **Testing** | https://pkg.go.dev/testing | Subtests, fuzzing added |

**Red Flags (Outdated Patterns):**

❌ **Deprecated Packages (DO NOT USE)**:
```go
// ❌ OLD: io/ioutil (deprecated in Go 1.16+)
import "io/ioutil"
data, _ := ioutil.ReadFile("file.txt")

// ✅ NEW: Use os/io packages
import "os"
data, _ := os.ReadFile("file.txt")
```

**Note on Generics (Go 1.18+)**:
```go
// ✅ Use generics for type-parameterized operations
func Map[T, U any](slice []T, fn func(T) U) []U { }

// ✅ Keep interface{} for polymorphism/dynamic values
func HandleWebhook(payload interface{}) error { }

// Don't force generics where interface{}/any is correct
```

**Enforcement Rules**:
1. **Before using any package**: Search pkg.go.dev for exact package/function
2. **Check "Since" badge**: Verify feature exists in your Go version
3. **Run `go version`**: Confirm installed version
4. **If syntax error**: Update code to match docs, not vice versa

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

## Anti-AI-Slop Directives (ENFORCED)
1. **BANNED: Redundant Explanatory Comments** — do not narrate obvious code.
   - ❌ `// Increment counter`  |  `// Import fmt`
   - ❌ Stub comments: `// TODO: implement this later`  |  `// Add your logic here`
   - ✅ Comment ONLY non-obvious business logic, domain formulas, or deliberate workarounds.
   - ✅ Never leave commented-out dead code — delete it (git remembers).
2. **BANNED: Silent Failures** — no empty catch/except blocks; log, rethrow, or return a typed error.
3. **BANNED: Dead Code & Unused Imports** — remove unused variables, imports, and unreachable branches.
4. **RACE CONDITIONS (MANDATORY for any shared-state mutation)** — protect every read-modify-write on inventory, balances, counters, booking slots, or status transitions:
   - Use a DB transaction + row lock (SELECT ... FOR UPDATE in a tx), or a unique constraint / idempotency key.
   - Never "check then act" across two separate queries without a lock or constraint.
   - Webhooks and payment callbacks MUST be idempotent (dedupe on provider event ID).
   - Frontend: disable the submit button while pending + use an idempotency key to prevent double-submit.
5. **BANNED: Hallucinated APIs/Packages** — verify every import exists before using it.

---

## Anti-Patterns (NEVER)
- ❌ No ignored errors (`_ = doSomething()`)
- ❌ No panics in production code
- ❌ No global state (use dependency injection)
- ❌ No fmt.Println in committed code (use logger)
- ❌ No SQL injection (use parameterized queries)
