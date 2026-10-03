# Go 1.23 Quickstart Guide

**Stack**: Go 1.23 + Fiber/Echo + PostgreSQL 16 + Redis

**Timeline**: 2-4 weeks MVP for high-performance APIs

**Best for**: Microservices, high-throughput APIs, system tools, real-time applications

---

## Quick Setup (15 minutes)

### 1. Initialize Project

```bash
# Create project directory
mkdir myapp && cd myapp

# Initialize Go module
go mod init github.com/username/myapp

# Install dependencies
go get github.com/gofiber/fiber/v2
go get gorm.io/gorm
go get gorm.io/driver/postgres
go get github.com/joho/godotenv
go get github.com/golang-jwt/jwt/v5
```

---

### 2. Project Structure

```
myapp/
├── cmd/
│   └── api/
│       └── main.go
├── internal/
│   ├── handlers/
│   │   └── document.go
│   ├── models/
│   │   └── document.go
│   ├── database/
│   │   └── database.go
│   └── middleware/
│       └── auth.go
├── pkg/
│   └── utils/
├── .env
├── go.mod
└── go.sum
```

---

### 3. Environment Setup

**.env**:
```
DATABASE_URL=postgres://user:password@localhost:5432/myapp?sslmode=disable
JWT_SECRET=your-super-secret-jwt-key
PORT=3000
```

---

## Database Setup

**internal/database/database.go**:
```go
package database

import (
    "log"
    "os"
    
    "gorm.io/driver/postgres"
    "gorm.io/gorm"
    "gorm.io/gorm/logger"
)

var DB *gorm.DB

func Connect() {
    var err error
    dsn := os.Getenv("DATABASE_URL")
    
    DB, err = gorm.Open(postgres.Open(dsn), &gorm.Config{
        Logger: logger.Default.LogMode(logger.Info),
    })
    
    if err != nil {
        log.Fatal("Failed to connect to database:", err)
    }
    
    log.Println("Database connected")
}

func Migrate(models ...interface{}) {
    err := DB.AutoMigrate(models...)
    if err != nil {
        log.Fatal("Migration failed:", err)
    }
    log.Println("Migration completed")
}
```

---

## Models

**internal/models/document.go**:
```go
package models

import (
    "time"
    "gorm.io/gorm"
)

type Document struct {
    ID        uint           `gorm:"primarykey" json:"id"`
    Title     string         `gorm:"not null;size:255" json:"title" validate:"required,min=1,max=255"`
    Content   string         `json:"content"`
    UserID    uint           `gorm:"not null;index" json:"user_id"`
    CreatedAt time.Time      `json:"created_at"`
    UpdatedAt time.Time      `json:"updated_at"`
    DeletedAt gorm.DeletedAt `gorm:"index" json:"-"`
}

type User struct {
    ID        uint           `gorm:"primarykey" json:"id"`
    Email     string         `gorm:"uniqueIndex;not null" json:"email"`
    Password  string         `gorm:"not null" json:"-"`
    Name      string         `json:"name"`
    Documents []Document     `gorm:"foreignKey:UserID" json:"-"`
    CreatedAt time.Time      `json:"created_at"`
    UpdatedAt time.Time      `json:"updated_at"`
}
```

---

## HTTP Server (Fiber)

**cmd/api/main.go**:
```go
package main

import (
    "log"
    "os"
    
    "github.com/gofiber/fiber/v2"
    "github.com/gofiber/fiber/v2/middleware/cors"
    "github.com/gofiber/fiber/v2/middleware/logger"
    "github.com/gofiber/fiber/v2/middleware/recover"
    "github.com/joho/godotenv"
    
    "github.com/username/myapp/internal/database"
    "github.com/username/myapp/internal/handlers"
    "github.com/username/myapp/internal/models"
)

func main() {
    // Load environment
    if err := godotenv.Load(); err != nil {
        log.Println("No .env file found")
    }
    
    // Connect database
    database.Connect()
    database.Migrate(&models.User{}, &models.Document{})
    
    // Create Fiber app
    app := fiber.New(fiber.Config{
        ErrorHandler: customErrorHandler,
    })
    
    // Middleware
    app.Use(recover.New())
    app.Use(logger.New())
    app.Use(cors.New())
    
    // Routes
    api := app.Group("/api")
    
    // Public routes
    api.Post("/auth/register", handlers.Register)
    api.Post("/auth/login", handlers.Login)
    
    // Protected routes
    protected := api.Group("/documents", handlers.AuthRequired)
    protected.Get("/", handlers.GetDocuments)
    protected.Post("/", handlers.CreateDocument)
    protected.Get("/:id", handlers.GetDocument)
    protected.Put("/:id", handlers.UpdateDocument)
    protected.Delete("/:id", handlers.DeleteDocument)
    
    // Start server
    port := os.Getenv("PORT")
    if port == "" {
        port = "3000"
    }
    
    log.Fatal(app.Listen(":" + port))
}

func customErrorHandler(c *fiber.Ctx, err error) error {
    code := fiber.StatusInternalServerError
    
    if e, ok := err.(*fiber.Error); ok {
        code = e.Code
    }
    
    return c.Status(code).JSON(fiber.Map{
        "error": err.Error(),
    })
}
```

---

## Handlers

**internal/handlers/document.go**:
```go
package handlers

import (
    "github.com/gofiber/fiber/v2"
    "github.com/username/myapp/internal/database"
    "github.com/username/myapp/internal/models"
)

type CreateDocumentInput struct {
    Title   string `json:"title" validate:"required,min=1,max=255"`
    Content string `json:"content"`
}

func GetDocuments(c *fiber.Ctx) error {
    userID := c.Locals("user_id").(uint)
    
    var documents []models.Document
    result := database.DB.Where("user_id = ?", userID).
        Order("created_at DESC").
        Find(&documents)
    
    if result.Error != nil {
        return fiber.NewError(fiber.StatusInternalServerError, result.Error.Error())
    }
    
    return c.JSON(fiber.Map{
        "documents": documents,
    })
}

func CreateDocument(c *fiber.Ctx) error {
    userID := c.Locals("user_id").(uint)
    
    var input CreateDocumentInput
    if err := c.BodyParser(&input); err != nil {
        return fiber.NewError(fiber.StatusBadRequest, "Invalid request body")
    }
    
    document := models.Document{
        Title:   input.Title,
        Content: input.Content,
        UserID:  userID,
    }
    
    result := database.DB.Create(&document)
    if result.Error != nil {
        return fiber.NewError(fiber.StatusInternalServerError, result.Error.Error())
    }
    
    return c.Status(fiber.StatusCreated).JSON(fiber.Map{
        "document": document,
    })
}

func GetDocument(c *fiber.Ctx) error {
    userID := c.Locals("user_id").(uint)
    id := c.Params("id")
    
    var document models.Document
    result := database.DB.Where("id = ? AND user_id = ?", id, userID).
        First(&document)
    
    if result.Error != nil {
        return fiber.NewError(fiber.StatusNotFound, "Document not found")
    }
    
    return c.JSON(fiber.Map{
        "document": document,
    })
}

func UpdateDocument(c *fiber.Ctx) error {
    userID := c.Locals("user_id").(uint)
    id := c.Params("id")
    
    var document models.Document
    result := database.DB.Where("id = ? AND user_id = ?", id, userID).
        First(&document)
    
    if result.Error != nil {
        return fiber.NewError(fiber.StatusNotFound, "Document not found")
    }
    
    var input CreateDocumentInput
    if err := c.BodyParser(&input); err != nil {
        return fiber.NewError(fiber.StatusBadRequest, "Invalid request body")
    }
    
    document.Title = input.Title
    document.Content = input.Content
    
    database.DB.Save(&document)
    
    return c.JSON(fiber.Map{
        "document": document,
    })
}

func DeleteDocument(c *fiber.Ctx) error {
    userID := c.Locals("user_id").(uint)
    id := c.Params("id")
    
    result := database.DB.Where("id = ? AND user_id = ?", id, userID).
        Delete(&models.Document{})
    
    if result.RowsAffected == 0 {
        return fiber.NewError(fiber.StatusNotFound, "Document not found")
    }
    
    return c.SendStatus(fiber.StatusNoContent)
}
```

---

## JWT Authentication

**internal/middleware/auth.go**:
```go
package middleware

import (
    "os"
    "strings"
    
    "github.com/gofiber/fiber/v2"
    "github.com/golang-jwt/jwt/v5"
)

func AuthRequired(c *fiber.Ctx) error {
    authHeader := c.Get("Authorization")
    if authHeader == "" {
        return fiber.NewError(fiber.StatusUnauthorized, "Missing authorization header")
    }
    
    tokenString := strings.TrimPrefix(authHeader, "Bearer ")
    
    token, err := jwt.Parse(tokenString, func(token *jwt.Token) (interface{}, error) {
        return []byte(os.Getenv("JWT_SECRET")), nil
    })
    
    if err != nil || !token.Valid {
        return fiber.NewError(fiber.StatusUnauthorized, "Invalid token")
    }
    
    claims := token.Claims.(jwt.MapClaims)
    c.Locals("user_id", uint(claims["user_id"].(float64)))
    
    return c.Next()
}
```

**internal/handlers/auth.go**:
```go
package handlers

import (
    "os"
    "time"
    
    "github.com/gofiber/fiber/v2"
    "github.com/golang-jwt/jwt/v5"
    "golang.org/x/crypto/bcrypt"
    
    "github.com/username/myapp/internal/database"
    "github.com/username/myapp/internal/models"
)

type RegisterInput struct {
    Email    string `json:"email" validate:"required,email"`
    Password string `json:"password" validate:"required,min=8"`
    Name     string `json:"name"`
}

type LoginInput struct {
    Email    string `json:"email" validate:"required,email"`
    Password string `json:"password" validate:"required"`
}

func Register(c *fiber.Ctx) error {
    var input RegisterInput
    if err := c.BodyParser(&input); err != nil {
        return fiber.NewError(fiber.StatusBadRequest, "Invalid request body")
    }
    
    hashedPassword, err := bcrypt.GenerateFromPassword([]byte(input.Password), 10)
    if err != nil {
        return fiber.NewError(fiber.StatusInternalServerError, "Failed to hash password")
    }
    
    user := models.User{
        Email:    input.Email,
        Password: string(hashedPassword),
        Name:     input.Name,
    }
    
    result := database.DB.Create(&user)
    if result.Error != nil {
        return fiber.NewError(fiber.StatusConflict, "Email already exists")
    }
    
    token, err := generateToken(user.ID)
    if err != nil {
        return fiber.NewError(fiber.StatusInternalServerError, "Failed to generate token")
    }
    
    return c.Status(fiber.StatusCreated).JSON(fiber.Map{
        "user":  user,
        "token": token,
    })
}

func Login(c *fiber.Ctx) error {
    var input LoginInput
    if err := c.BodyParser(&input); err != nil {
        return fiber.NewError(fiber.StatusBadRequest, "Invalid request body")
    }
    
    var user models.User
    result := database.DB.Where("email = ?", input.Email).First(&user)
    if result.Error != nil {
        return fiber.NewError(fiber.StatusUnauthorized, "Invalid credentials")
    }
    
    err := bcrypt.CompareHashAndPassword([]byte(user.Password), []byte(input.Password))
    if err != nil {
        return fiber.NewError(fiber.StatusUnauthorized, "Invalid credentials")
    }
    
    token, err := generateToken(user.ID)
    if err != nil {
        return fiber.NewError(fiber.StatusInternalServerError, "Failed to generate token")
    }
    
    return c.JSON(fiber.Map{
        "user":  user,
        "token": token,
    })
}

func generateToken(userID uint) (string, error) {
    claims := jwt.MapClaims{
        "user_id": userID,
        "exp":     time.Now().Add(time.Hour * 24 * 7).Unix(),
    }
    
    token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
    return token.SignedString([]byte(os.Getenv("JWT_SECRET")))
}
```

---

## Testing

**Install testing tools**:
```bash
go get github.com/stretchr/testify
```

**internal/handlers/document_test.go**:
```go
package handlers

import (
    "testing"
    "github.com/stretchr/testify/assert"
)

func TestCreateDocument(t *testing.T) {
    // Setup test database
    // Create test request
    // Assert response
    assert.Equal(t, 201, statusCode)
}
```

**Run tests**:
```bash
go test ./...
go test -cover ./...
```

---

## Deployment

### Docker

**Dockerfile**:
```dockerfile
FROM golang:1.23-alpine AS builder

WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o main ./cmd/api

FROM alpine:latest
RUN apk --no-cache add ca-certificates
WORKDIR /root/
COPY --from=builder /app/main .
EXPOSE 3000
CMD ["./main"]
```

**Build and run**:
```bash
docker build -t myapp .
docker run -p 3000:3000 --env-file .env myapp
```

---

## Performance Optimization

### Connection Pooling

```go
sqlDB, err := database.DB.DB()
sqlDB.SetMaxIdleConns(10)
sqlDB.SetMaxOpenConns(100)
sqlDB.SetConnMaxLifetime(time.Hour)
```

### Caching with Redis

```bash
go get github.com/redis/go-redis/v9
```

```go
import (
    "context"
    "github.com/redis/go-redis/v9"
)

var ctx = context.Background()
var rdb = redis.NewClient(&redis.Options{
    Addr: "localhost:6379",
})

func CacheGet(key string) (string, error) {
    return rdb.Get(ctx, key).Result()
}

func CacheSet(key string, value string, expiration time.Duration) error {
    return rdb.Set(ctx, key, value, expiration).Err()
}
```

---

## Common Issues

### Port already in use
```bash
lsof -ti:3000 | xargs kill -9
```

### Database connection errors
Check `DATABASE_URL` in `.env` and ensure PostgreSQL is running.

---

## Next Steps

1. **Validation**: Add `go-playground/validator` for input validation
2. **Logging**: Add structured logging with `zerolog` or `zap`
3. **Monitoring**: Add Prometheus metrics
4. **Rate limiting**: Add `golang.org/x/time/rate`
5. **File uploads**: Add S3/R2 integration

---

## See Also

- [Go Docs](https://go.dev/doc/)
- [Fiber Docs](https://docs.gofiber.io/)
- [GORM Docs](https://gorm.io/)
- `patterns/validation/` - Validation patterns
- `patterns/security/` - Security best practices
