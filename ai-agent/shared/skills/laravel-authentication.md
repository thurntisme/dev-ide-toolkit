---
name: laravel-authentication
description: Laravel authentication specialist. Use when user asks about Laravel authentication, guards, policies, or authorization.
---

# Laravel Authentication

## When to use
- User asks about Laravel authentication
- User asks about guards and providers
- User asks about authorization policies
- User asks about role-based access control

## Authentication Scaffolding

```bash
# Install Laravel Breeze (recommended)
composer require laravel/breeze --dev
php artisan breeze:install

# Install Laravel Fortify
composer require laravel/fortify
php artisan fortify:install

# Install Laravel UI (legacy)
composer require laravel/ui
php artisan ui bootstrap --auth
```

## Custom User Model

```php
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    use HasApiTokens, HasFactory, Notifiable;
    
    protected $fillable = [
        'name',
        'email',
        'password',
        'role',
    ];
    
    protected $hidden = [
        'password',
        'remember_token',
    ];
    
    protected $casts = [
        'email_verified_at' => 'datetime',
        'password' => 'hashed',
    ];
    
    public function isAdmin(): bool
    {
        return $this->role === 'admin';
    }
    
    public function isModerator(): bool
    {
        return in_array($this->role, ['admin', 'moderator']);
    }
}
```

## Authentication Controller

```php
<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\ValidationException;

class AuthController extends Controller
{
    public function register(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'name' => ['required', 'string', 'max:255'],
            'email' => ['required', 'string', 'email', 'max:255', 'unique:users'],
            'password' => ['required', 'string', 'min:8', 'confirmed'],
        ]);
        
        $user = User::create([
            'name' => $validated['name'],
            'email' => $validated['email'],
            'password' => Hash::make($validated['password']),
        ]);
        
        $token = $user->createToken('auth-token')->plainTextToken;
        
        return response()->json([
            'message' => 'Registration successful',
            'user' => $user,
            'token' => $token,
        ], 201);
    }
    
    public function login(Request $request): JsonResponse
    {
        $credentials = $request->validate([
            'email' => ['required', 'email'],
            'password' => ['required'],
        ]);
        
        if (!Auth::attempt($credentials)) {
            throw ValidationException::withMessages([
                'email' => ['The provided credentials are incorrect.'],
            ]);
        }
        
        $request->session()->regenerate();
        
        $user = Auth::user();
        $token = $user->createToken('auth-token')->plainTextToken;
        
        return response()->json([
            'message' => 'Login successful',
            'user' => $user,
            'token' => $token,
        ]);
    }
    
    public function logout(Request $request): JsonResponse
    {
        Auth::guard('web')->logout();
        
        $request->session()->invalidate();
        $request->session()->regenerateToken();
        
        return response()->json([
            'message' => 'Logged out successfully',
        ]);
    }
    
    public function user(Request $request): JsonResponse
    {
        return response()->json([
            'user' => $request->user(),
        ]);
    }
}
```

## Guards Configuration

```php
// config/auth.php
'guards' => [
    'web' => [
        'driver' => 'session',
        'provider' => 'users',
    ],
    
    'api' => [
        'driver' => 'sanctum',
        'provider' => 'users',
    ],
    
    'admin' => [
        'driver' => 'session',
        'provider' => 'admins',
    ],
],

'providers' => [
    'users' => [
        'driver' => 'eloquent',
        'model' => App\Models\User::class,
    ],
    
    'admins' => [
        'driver' => 'eloquent',
        'model' => App\Models\Admin::class,
    ],
],
```

## Sanctum Setup

```bash
# Install Sanctum
composer require laravel/sanctum
php artisan install:api
```

```php
// User model with Sanctum
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    use HasApiTokens, HasFactory, Notifiable;
    
    // ...
}

// Create token
$token = $user->createToken('token-name')->plainTextToken;

// Revoke token
$user->currentAccessToken()->delete();

// Revoke all tokens
$user->tokens()->delete();

// Check ability
if ($user->tokenCan('posts:create')) {
    // Can create posts
}
```

## Middleware

```php
// app/Http/Kernel.php
protected $middlewareAliases = [
    'auth' => \Illuminate\Auth\Middleware\Authenticate::class,
    'auth.basic' => \Illuminate\Auth\Middleware\AuthenticateWithBasicAuth::class,
    'auth.session' => \Illuminate\Session\Middleware\AuthenticateSession::class,
    'can' => \Illuminate\Auth\Middleware\Authorize::class,
    'guest' => \App\Http\Middleware\RedirectIfAuthenticated::class,
    'password.confirm' => \Illuminate\Auth\Middleware\RequirePassword::class,
    'signed' => \Illuminate\Routing\Middleware\ValidateSignature::class,
    'throttle' => \Illuminate\Routing\Middleware\ThrottleRequests::class,
    'verified' => \Illuminate\Auth\Middleware\EnsureEmailIsVerified::class,
    
    // Custom
    'role' => \App\Http\Middleware\CheckRole::class,
    'permission' => \App\Http\Middleware\CheckPermission::class,
];
```

### Custom Role Middleware

```php
<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;

class CheckRole
{
    public function handle(Request $request, Closure $next, string $role): Response
    {
        if (!$request->user() || $request->user()->role !== $role) {
            return response()->json([
                'message' => 'Unauthorized. Insufficient permissions.',
            ], 403);
        }
        
        return $next($request);
    }
}

// Usage in routes
Route::middleware(['auth:sanctum', 'role:admin'])->group(function () {
    // Admin only routes
});
```

### Custom Permission Middleware

```php
<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;

class CheckPermission
{
    public function handle(Request $request, Closure $next, string $permission): Response
    {
        if (!$request->user() || !$request->user()->hasPermission($permission)) {
            return response()->json([
                'message' => 'Forbidden. You do not have permission.',
            ], 403);
        }
        
        return $next($request);
    }
}

// Usage
Route::middleware(['auth:sanctum', 'permission:posts.delete'])->group(function () {
    // Routes requiring posts.delete permission
});
```

## Authorization Policies

### Creating Policies

```bash
php artisan make:policy PostPolicy --model=Post
```

```php
<?php

namespace App\Policies;

use App\Models\Post;
use App\Models\User;

class PostPolicy
{
    public function viewAny(User $user): bool
    {
        return true;
    }
    
    public function view(User $user, Post $post): bool
    {
        return $user->isAdmin() || $post->isPublished();
    }
    
    public function create(User $user): bool
    {
        return $user->isAdmin() || $user->isModerator();
    }
    
    public function update(User $user, Post $post): bool
    {
        return $user->isAdmin() || $user->id === $post->user_id;
    }
    
    public function delete(User $user, Post $post): bool
    {
        return $user->isAdmin() || $user->id === $post->user_id;
    }
    
    public function restore(User $user, Post $post): bool
    {
        return $user->isAdmin();
    }
    
    public function forceDelete(User $user, Post $post): bool
    {
        return $user->isAdmin();
    }
}
```

### Registering Policies

```php
// app/Providers/AuthServiceProvider.php
use App\Models\Post;
use App\Policies\PostPolicy;
use Illuminate\Foundation\Support\Providers\AuthServiceProvider as ServiceProvider;

class AuthServiceProvider extends ServiceProvider
{
    protected $policies = [
        Post::class => PostPolicy::class,
    ];
    
    public function boot(): void
    {
        $this->registerPolicies();
    }
}
```

### Using Policies

```php
// In Controller
public function update(Request $request, Post $post): JsonResponse
{
    $this->authorize('update', $post);
    
    $post->update($request->validated());
    
    return response()->json([
        'message' => 'Post updated',
        'data' => $post,
    ]);
}

// In Route
Route::put('/posts/{post}', function (Post $post) {
    Gate::authorize('update', $post);
})->middleware('auth:sanctum');

// Blade Directive
@can('update', $post)
    <a href="/posts/{{ $post->id }}/edit">Edit</a>
@endcan

// Gate
if (Gate::allows('update', $post)) {
    // Can update
}

if (Gate::denies('update', $post)) {
    // Cannot update
}
```

## Role-Based Access Control (RBAC)

### Role Model

```php
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;

class Role extends Model
{
    protected $fillable = ['name', 'slug'];
    
    public function users(): BelongsToMany
    {
        return $this->belongsToMany(User::class);
    }
}
```

### User with Roles

```php
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Relations\BelongsToMany;

class User extends Authenticatable
{
    public function roles(): BelongsToMany
    {
        return $this->belongsToMany(Role::class);
    }
    
    public function hasRole(string $role): bool
    {
        return $this->roles->contains('slug', $role);
    }
    
    public function hasAnyRole(array $roles): bool
    {
        return $this->roles->whereIn('slug', $roles)->isNotEmpty();
    }
    
    public function hasAllRoles(array $roles): bool
    {
        return !$this->roles->whereIn('slug', $roles)->isEmpty();
    }
    
    public function assignRole(Role $role): void
    {
        $this->roles()->attach($role);
    }
    
    public function removeRole(Role $role): void
    {
        $this->roles()->detach($role);
    }
}
```

### Permission Model

```php
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;

class Permission extends Model
{
    protected $fillable = ['name', 'slug'];
    
    public function roles(): BelongsToMany
    {
        return $this->belongsToMany(Role::class);
    }
}

class Role extends Model
{
    public function permissions(): BelongsToMany
    {
        return $this->belongsToMany(Permission::class);
    }
}

class User extends Authenticatable
{
    public function permissions(): BelongsToMany
    {
        return $this->roles->flatMap->permissions->unique('id');
    }
    
    public function hasPermission(string $permission): bool
    {
        return $this->permissions->contains('slug', $permission);
    }
}
```

## Email Verification

```php
// User model
use Illuminate\Contracts\Auth\MustVerifyEmail;

class User extends Authenticatable implements MustVerifyEmail
{
    public function hasVerifiedEmail(): bool
    {
        return !is_null($this->email_verified_at);
    }
    
    public function markEmailAsVerified(): bool
    {
        return $this->forceFill([
            'email_verified_at' => $this->freshTimestamp(),
        ])->save();
    }
}

// Routes with verified middleware
Route::middleware(['auth:sanctum', 'verified'])->group(function () {
    Route::post('/posts', [PostController::class, 'store']);
});
```

## Session Authentication (Web)

```php
// routes/web.php
use App\Http\Controllers\Auth\LoginController;

Route::get('/login', [LoginController::class, 'showLoginForm']);
Route::post('/login', [LoginController::class, 'login']);
Route::post('/logout', [LoginController::class, 'logout'])->name('logout');

// Protected routes
Route::middleware('auth')->group(function () {
    Route::get('/dashboard', [DashboardController::class, 'index']);
});

// Login throttling
Route::post('/login', [LoginController::class, 'login'])
    ->middleware('throttle:5,1');
```

## Social Authentication

```bash
composer require laravel/socialite
```

```php
// config/services.php
'google' => [
    'client_id' => env('GOOGLE_CLIENT_ID'),
    'client_secret' => env('GOOGLE_CLIENT_SECRET'),
    'redirect' => env('APP_URL') . '/auth/google/callback',
],

// Routes
Route::get('/auth/google', [SocialiteController::class, 'redirectToGoogle']);
Route::get('/auth/google/callback', [SocialiteController::class, 'handleGoogleCallback']);

// Controller
use Laravel\Socialite\Facades\Socialite;

public function redirectToGoogle()
{
    return Socialite::driver('google')->redirect();
}

public function handleGoogleCallback()
{
    $googleUser = Socialite::driver('google')->stateless()->user();
    
    $user = User::updateOrCreate([
        'email' => $googleUser->email,
    ], [
        'name' => $googleUser->name,
        'google_id' => $googleUser->id,
    ]);
    
    Auth::login($user);
    
    return redirect('/dashboard');
}
```

## Two-Factor Authentication

```bash
composer require laravel/fortify
php artisan vendor:publish --provider="Laravel\Fortify\FortifyServiceProvider"
```

```php
// config/fortify.php
'features' => [
    Features::registration(),
    Features::resetPasswords(),
    Features::emailVerification(),
    Features::updateProfileInformation(),
    Features::updatePasswords(),
    Features::twoFactorAuthentication([
        'confirm' => true,
        'confirmPassword' => true,
    ]),
],
```

## Password Reset

```php
// Send reset link
Password::sendResetLink($request->only('email'));

// Reset password
Password::reset($request->only('email', 'password', 'password_confirmation', 'token'), 
    function ($user, $password) {
        $user->forceFill([
            'password' => Hash::make($password)
        ])->save();
    }
);
```
