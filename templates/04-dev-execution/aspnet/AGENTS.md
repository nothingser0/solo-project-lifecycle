# AI Agent Guidelines - ASP.NET Core Project

## 0. Execution Protocol — One Task Per Turn (NON-NEGOTIABLE)

- **`TODO.md` is the queue.** Work its task list **one task at a time**.
- **Per task**: implement ONLY that task → run that task's `Verify` command → paste the raw output → report task ID + files touched + result → 🛑 **END TURN**.
- **Do NOT** start the next task, open a new sprint, or batch task IDs — unless the human names the specific task IDs to run in one instruction.
- **`[x]` is the human's mark, never yours.** Only after the human confirms may you record `Approved: <date> by <name>` in that task's `Evidence`.
- **If a spec, schema, or requirement is missing, STOP and ask** — never invent it to keep the queue moving.
- **Never run `git commit`, `git push`, or `git tag`** — hand the change to the human for review and commit.

---

## CRITICAL: Read Official Documentation First

**BEFORE implementing any feature, check official docs for current syntax:**

- **ASP.NET Core**: https://learn.microsoft.com/en-us/aspnet/core/
- **C# Docs**: https://learn.microsoft.com/en-us/dotnet/csharp/
- **Entity Framework Core**: https://learn.microsoft.com/en-us/ef/core/

**Why**: .NET versions have breaking changes. This project uses:
- .NET 8.0 or 9.0 (check .csproj for `<TargetFramework>`)
- Entity Framework Core 8.x or 9.x

### Version-Specific Syntax Enforcement

| API Category | Docs URL | Common Version Conflicts |
|:-------------|:---------|:-------------------------|
| **Minimal APIs** | https://learn.microsoft.com/en-us/aspnet/core/fundamentals/minimal-apis | New in .NET 6+ |
| **EF Core Queries** | https://learn.microsoft.com/en-us/ef/core/querying/ | LINQ syntax evolves |
| **Dependency Injection** | https://learn.microsoft.com/en-us/aspnet/core/fundamentals/dependency-injection | Service lifetime patterns |
| **Authentication** | https://learn.microsoft.com/en-us/aspnet/core/security/authentication/ | Identity changes per version |

**Enforcement Rules**:
1. Check .NET version: `dotnet --version`
2. Verify NuGet package versions in .csproj
3. Use async/await for all I/O operations
4. Follow Microsoft naming conventions (PascalCase)

## Anti-AI-Slop Directives (ENFORCED)
1. **BANNED: Redundant Explanatory Comments** — do not narrate obvious code.
   - ❌ `// Increment counter`  |  `// Import the model`
   - ❌ Stub comments: `// TODO: implement this later`  |  `// Add your logic here`
   - ✅ Comment ONLY non-obvious business logic, domain formulas, or deliberate workarounds.
   - ✅ Never leave commented-out dead code — delete it (git remembers).
2. **BANNED: Silent Failures** — no empty catch/except blocks; log, rethrow, or return a typed error.
3. **BANNED: Dead Code & Unused Imports** — remove unused variables, imports, and unreachable branches.
4. **RACE CONDITIONS (MANDATORY for any shared-state mutation)** — protect every read-modify-write on inventory, balances, counters, booking slots, or status transitions:
   - Use a DB transaction + row lock (SELECT ... FOR UPDATE), or a unique constraint / idempotency key.
   - Never "check then act" across two separate queries without a lock or constraint.
   - Webhooks and payment callbacks MUST be idempotent (dedupe on provider event ID).
   - Frontend: disable the submit button while pending + use an idempotency key to prevent double-submit.
5. **BANNED: Hallucinated APIs/Packages** — verify every import exists before using it.

---

## Code Style Rules
1. **PascalCase**: Classes, methods, properties
2. **camelCase**: Local variables, parameters
3. **Async Suffix**: Async methods end with `Async` (`GetUserAsync`)
4. **Nullable**: Enable nullable reference types
5. **LINQ**: Use LINQ for collections (not loops)

## Database (Entity Framework Core)
- **Migrations**: `dotnet ef migrations add InitialCreate`
- **Apply**: `dotnet ef database update`
- **Models**: DbContext + entity classes
- **Queries**: Use LINQ, avoid raw SQL

## Testing
- **Framework**: xUnit or NUnit
- **Run**: `dotnet test`
- **Mocking**: Moq or NSubstitute

## Security
- **Authentication**: ASP.NET Core Identity or JWT
- **Authorization**: Policy-based or role-based
- **SQL Injection**: EF Core prevents (use LINQ)
- ❌ No secrets in appsettings.json (use User Secrets or Azure Key Vault)

## Build Commands
- **Dev**: `dotnet run`
- **Build**: `dotnet build`
- **Publish**: `dotnet publish -c Release`
- **Watch**: `dotnet watch run`
