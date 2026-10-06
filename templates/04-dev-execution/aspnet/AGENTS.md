# AI Agent Guidelines - ASP.NET Core Project

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
