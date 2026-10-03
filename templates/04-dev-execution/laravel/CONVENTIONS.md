# CONVENTIONS.md - Laravel Project

> Code style standards and technical conventions for AI agents

---

## File Naming

1. **Classes**: PascalCase
   - ✅ `UserController.php`, `CreateUserRequest.php`
   - ❌ `userController.php`, `create-user-request.php`

2. **Views**: kebab-case
   - ✅ `user-profile.blade.php`
   - ❌ `UserProfile.blade.php`

3. **Database Files**: snake_case
   - ✅ `2026_10_01_create_users_table.php`

---

## PSR-12 Standards

1. **Namespaces**: Match directory structure
   ```php
   <?php
   namespace App\Http\Controllers;
   
   class UserController extends Controller { }
   ```

2. **Method Names**: camelCase
   ```php
   public function getUserProfile() { }
   ```

3. **Properties**: camelCase
   ```php
   protected $userId;
   ```

---

## Eloquent ORM Rules

1. **No Raw SQL**
   - ❌ `DB::select('SELECT * FROM users')`
   - ✅ `User::query()->get()`

2. **Query Builder Patterns**
   ```php
   $users = User::query()
       ->where('active', true)
       ->with('profile')
       ->paginate(20);
   ```

3. **Prevent N+1**
   ```php
   // ❌ Bad
   foreach ($users as $user) {
       echo $user->profile->name;
   }
   
   // ✅ Good
   $users = User::with('profile')->get();
   foreach ($users as $user) {
       echo $user->profile->name;
   }
   ```

---

## Validation

1. **Form Requests** for complex validation
   ```php
   php artisan make:request StoreUserRequest
   ```

2. **Inline Validation** for simple cases
   ```php
   $validated = $request->validate([
       'email' => 'required|email',
       'name' => 'required|string|max:255',
   ]);
   ```

---

## Service Layer Pattern

```php
// app/Services/UserService.php
class UserService
{
    public function createUser(array $data): User
    {
        return DB::transaction(function () use ($data) {
            $user = User::create($data);
            $user->profile()->create($data['profile']);
            return $user;
        });
    }
}

// Controller
public function store(StoreUserRequest $request)
{
    $user = app(UserService::class)->createUser($request->validated());
    return response()->json($user, 201);
}
```

---

## Error Handling

1. **Never Empty Catch**
   ```php
   try {
       $result = $service->process();
   } catch (\Exception $e) {
       Log::error('Process failed', ['error' => $e->getMessage()]);
       throw $e;
   }
   ```

2. **API Error Responses**
   ```php
   return response()->json([
       'message' => 'Resource not found',
   ], 404);
   ```

---

## Configuration

1. **Use Config Files**
   - ❌ Hardcoded values: `if ($limit > 100)`
   - ✅ Config: `if ($limit > config('app.max_limit'))`

2. **Environment Variables**
   - Access via `env()` only in config files
   - Use `config()` in application code
