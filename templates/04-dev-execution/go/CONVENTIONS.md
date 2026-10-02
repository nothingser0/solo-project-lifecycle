# CONVENTIONS.md - Go Project

> Code style standards and technical conventions for AI agents

---

## File Naming

1. **Files**: snake_case
   - ✅ `user_service.go`, `auth_handler.go`
   - ❌ `UserService.go`, `authHandler.go`

2. **Packages**: lowercase, single word
   - ✅ `package user`
   - ❌ `package userService`

3. **Exported Names**: PascalCase
   ```go
   type UserService struct {}
   func NewUserService() *UserService {}
   ```

4. **Unexported Names**: camelCase
   ```go
   type userRepository struct {}
   func validateEmail(email string) bool {}
   ```

---

## Code Formatting

1. **gofmt/goimports**: Always format before commit
   ```bash
   gofmt -w .
   goimports -w .
   ```

2. **golangci-lint**: Run before commit
   ```bash
   golangci-lint run
   ```

---

## Error Handling

1. **Always Check Errors**
   ```go
   // ❌ Bad
   user, _ := repo.FindByID(id)
   
   // ✅ Good
   user, err := repo.FindByID(id)
   if err != nil {
       return nil, fmt.Errorf("find user: %w", err)
   }
   ```

2. **Wrap Errors**
   ```go
   if err != nil {
       return fmt.Errorf("create user: %w", err)
   }
   ```

3. **Never Panic in Production**
   - Use panic only for unrecoverable programmer errors
   - Prefer returning errors

---

## Package Structure (Clean Architecture)

```text
cmd/
└── server/
    └── main.go              # Entry point

internal/
├── domain/                  # Business entities
│   └── user.go
├── handler/                 # HTTP handlers
│   └── user_handler.go
├── service/                 # Business logic
│   └── user_service.go
├── repository/              # Data access
│   └── user_repository.go
└── middleware/              # HTTP middleware
    └── auth_middleware.go

pkg/                         # Public libraries
└── logger/
    └── logger.go

config/                      # Configuration
└── config.go
```

---

## Interface Design

```go
// Keep interfaces small
type UserRepository interface {
    FindByID(id string) (*User, error)
    Create(user *User) error
}

// Accept interfaces, return structs
func NewUserService(repo UserRepository) *UserService {
    return &UserService{repo: repo}
}
```

---

## Dependency Injection

```go
// Don't use global state
// ❌ Bad
var db *sql.DB

func GetUser(id string) (*User, error) {
    return db.QueryRow(...)
}

// ✅ Good
type UserRepository struct {
    db *sql.DB
}

func NewUserRepository(db *sql.DB) *UserRepository {
    return &UserRepository{db: db}
}

func (r *UserRepository) GetUser(id string) (*User, error) {
    return r.db.QueryRow(...)
}
```

---

## HTTP Handlers

```go
func (h *UserHandler) CreateUser(w http.ResponseWriter, r *http.Request) {
    // 1. Parse & validate input
    var req CreateUserRequest
    if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
        http.Error(w, "invalid request", http.StatusBadRequest)
        return
    }
    
    // 2. Call service
    user, err := h.service.CreateUser(r.Context(), &req)
    if err != nil {
        http.Error(w, err.Error(), http.StatusInternalServerError)
        return
    }
    
    // 3. Return response
    w.Header().Set("Content-Type", "application/json")
    w.WriteHeader(http.StatusCreated)
    json.NewEncoder(w).Encode(user)
}
```

---

## Testing

1. **Test File Naming**: `*_test.go`
   ```go
   // user_service_test.go
   func TestUserService_CreateUser(t *testing.T) {
       // Arrange
       repo := &mockUserRepository{}
       service := NewUserService(repo)
       
       // Act
       user, err := service.CreateUser(ctx, &req)
       
       // Assert
       assert.NoError(t, err)
       assert.NotNil(t, user)
   }
   ```

2. **Table-Driven Tests**
   ```go
   func TestValidateEmail(t *testing.T) {
       tests := []struct {
           name  string
           email string
           want  bool
       }{
           {"valid", "user@example.com", true},
           {"invalid", "not-an-email", false},
       }
       
       for _, tt := range tests {
           t.Run(tt.name, func(t *testing.T) {
               got := validateEmail(tt.email)
               assert.Equal(t, tt.want, got)
           })
       }
   }
   ```

---

## Database (sqlx)

```go
// Use prepared statements
func (r *UserRepository) FindByEmail(email string) (*User, error) {
    var user User
    query := `SELECT id, email, name FROM users WHERE email = $1`
    err := r.db.Get(&user, query, email)
    return &user, err
}

// Transactions
func (r *UserRepository) CreateUserWithProfile(user *User, profile *Profile) error {
    tx, err := r.db.Beginx()
    if err != nil {
        return err
    }
    defer tx.Rollback()
    
    if err := tx.Get(user, "INSERT INTO users ...", ...); err != nil {
        return err
    }
    
    if err := tx.Exec("INSERT INTO profiles ...", ...); err != nil {
        return err
    }
    
    return tx.Commit()
}
```
