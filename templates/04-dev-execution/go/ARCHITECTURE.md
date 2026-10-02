# ARCHITECTURE.md - Go Project

> Technical architecture, directory layout, database schema, and API contracts

---

## System Topology

```text
[ Client (Browser/Mobile) ]
        │
        ▼ (HTTPS / JSON API)
    [ Go HTTP Server ]
        │
   ┌────┴────┬────────┐
   ▼         ▼        ▼
[ PostgreSQL ] [ Redis ] [ S3 ]
```

---

## Directory Structure (Clean Architecture)

```text
cmd/
└── server/
    └── main.go              # Application entry point

internal/
├── domain/                  # Business entities (models)
│   ├── user.go
│   └── errors.go
├── handler/                 # HTTP request handlers
│   └── user_handler.go
├── service/                 # Business logic
│   └── user_service.go
├── repository/              # Data access layer
│   └── user_repository.go
├── middleware/              # HTTP middleware
│   ├── auth.go
│   └── logger.go
└── config/                  # Configuration
    └── config.go

pkg/                         # Public reusable packages
├── database/
│   └── postgres.go
├── logger/
│   └── logger.go
└── validator/
    └── validator.go

migrations/                  # SQL migrations
├── 000001_create_users.up.sql
└── 000001_create_users.down.sql

.env.example
go.mod
Makefile
```

---

## Database Schema

Refer to `docs/specs/FSD.md` for complete schema.

Migrations managed by: `golang-migrate/migrate`

```bash
migrate create -ext sql -dir migrations -seq create_users
migrate -path migrations -database "postgres://..." up
```

---

## API Routes

| Endpoint | Method | Handler | Middleware | Response |
|----------|--------|---------|------------|----------|
| `/api/v1/auth/login` | POST | AuthHandler.Login | - | 200 + token |
| `/api/v1/users` | GET | UserHandler.List | AuthMiddleware | 200 + array |
| `/api/v1/users` | POST | UserHandler.Create | AuthMiddleware | 201 + object |
| `/api/v1/users/:id` | GET | UserHandler.Get | AuthMiddleware | 200 |
| `/api/v1/users/:id` | PUT | UserHandler.Update | AuthMiddleware | 200 |
| `/api/v1/users/:id` | DELETE | UserHandler.Delete | AuthMiddleware | 204 |

---

## Router Setup (chi/gorilla)

```go
// cmd/server/main.go
func main() {
    r := chi.NewRouter()
    
    // Middleware
    r.Use(middleware.Logger)
    r.Use(middleware.Recoverer)
    
    // Public routes
    r.Post("/api/v1/auth/login", authHandler.Login)
    
    // Protected routes
    r.Group(func(r chi.Router) {
        r.Use(authMiddleware.Authenticate)
        r.Get("/api/v1/users", userHandler.List)
        r.Post("/api/v1/users", userHandler.Create)
    })
    
    http.ListenAndServe(":8080", r)
}
```

---

## Dependency Injection

```go
// Wire dependencies in main.go
func main() {
    // Infrastructure
    db := database.NewPostgres(config.DB)
    redis := cache.NewRedis(config.Redis)
    logger := logger.New(config.Log)
    
    // Repositories
    userRepo := repository.NewUserRepository(db)
    
    // Services
    userService := service.NewUserService(userRepo, logger)
    
    // Handlers
    userHandler := handler.NewUserHandler(userService)
    
    // Setup router
    router := setupRouter(userHandler)
    
    http.ListenAndServe(":8080", router)
}
```

---

## Security Rules

1. **Parameterized Queries**: Always use placeholders ($1, $2)
2. **Error Wrapping**: Use `fmt.Errorf("context: %w", err)`
3. **Context Propagation**: Pass `context.Context` through call stack
4. **Input Validation**: Use validator package (go-playground/validator)
5. **No Panics**: Return errors, handle gracefully
