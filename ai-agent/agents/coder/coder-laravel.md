---
name: coder-laravel
description: Laravel development. Use when user asks to create, modify, or debug Laravel applications.
---

# Laravel Development Guide

## When to use
- User asks to create a Laravel application
- User asks to add functionality to a Laravel project
- User asks about Laravel best practices
- User asks to debug Laravel issues

## Conventions

- Follow Laravel naming conventions
- Use Artisan CLI for common tasks
- Use Eloquent ORM for database
- Use Blade templates
- Use Laravel's service container

## File Structure

```
project/
├── app/
│   ├── Console/
│   ├── Exceptions/
│   ├── Http/
│   │   ├── Controllers/
│   │   ├── Middleware/
│   │   └── Requests/
│   ├── Models/
│   ├── Providers/
│   └── Services/
├── bootstrap/
├── config/
├── database/
│   ├── migrations/
│   ├── seeders/
│   └── factories/
├── public/
├── resources/
│   ├── js/
│   ├── sass/
│   └── views/
├── routes/
├── storage/
├── tests/
├── .env
├── artisan
├── composer.json
└── phpunit.xml
```

## Artisan Commands

```bash
# Create project
composer create-project laravel/laravel my-project

# Make commands
php artisan make:controller UserController
php artisan make:model User
php artisan make:migration create_users_table
php artisan make:seeder UserSeeder
php artisan make:request StoreUserRequest
php artisan make:middleware AuthMiddleware

# Database
php artisan migrate
php artisan migrate:rollback
php artisan migrate:fresh --seed

# Clear cache
php artisan cache:clear
php artisan config:clear
php artisan route:clear
php artisan view:clear
```

## Routing

```php
// routes/web.php
Route::get('/users', [UserController::class, 'index']);
Route::post('/users', [UserController::class, 'store']);
Route::get('/users/{id}', [UserController::class, 'show']);
Route::put('/users/{id}', [UserController::class, 'update']);
Route::delete('/users/{id}', [UserController::class, 'destroy']);

// Route groups
Route::prefix('api')->group(function () {
    Route::get('/users', [UserController::class, 'index']);
});

// Resource routes
Route::resource('posts', PostController::class);
```

## Controllers

```php
<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use App\Http\Requests\StoreUserRequest;

class UserController extends Controller
{
    public function index()
    {
        $users = User::all();
        return view('users.index', compact('users'));
    }

    public function store(StoreUserRequest $request)
    {
        $user = User::create($request->validated());
        return redirect()->route('users.show', $user->id);
    }

    public function show(User $user)
    {
        return view('users.show', compact('user'));
    }

    public function update(Request $request, User $user)
    {
        $user->update($request->validated());
        return response()->json($user);
    }

    public function destroy(User $user)
    {
        $user->delete();
        return redirect()->route('users.index');
    }
}
```

## Models & Eloquent

```php
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class User extends Model
{
    protected $fillable = ['name', 'email', 'password'];
    protected $hidden = ['password', 'remember_token'];
    protected $casts = ['email_verified_at' => 'datetime'];

    public function posts(): HasMany
    {
        return $this->hasMany(Post::class);
    }

    public function role(): BelongsTo
    {
        return $this->belongsTo(Role::class);
    }
}
```

## Migrations

```php
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up()
    {
        Schema::create('users', function (Blueprint $table) {
            $table->id();
            $table->string('name');
            $table->string('email')->unique();
            $table->timestamp('email_verified_at')->nullable();
            $table->string('password');
            $table->rememberToken();
            $table->timestamps();
        });
    }

    public function down()
    {
        Schema::dropIfExists('users');
    }
};
```

## Blade Templates

```blade
<!-- resources/views/users/index.blade.php -->
@extends('layouts.app')

@section('title', 'Users')

@section('content')
    @foreach($users as $user)
        <div class="user">
            <h2>{{ $user->name }}</h2>
            <p>{{ $user->email }}</p>
        </div>
    @endforeach

    @if($users->isEmpty())
        <p>No users found.</p>
    @endif
@endsection
```

## Form Requests

```php
<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class StoreUserRequest extends FormRequest
{
    public function authorize()
    {
        return true;
    }

    public function rules()
    {
        return [
            'name' => 'required|string|max:255',
            'email' => 'required|email|unique:users',
            'password' => 'required|string|min:8|confirmed',
        ];
    }

    public function messages()
    {
        return [
            'email.required' => 'Email is required',
            'email.email' => 'Please enter a valid email',
        ];
    }
}
```

## Database Query Builder

```php
use Illuminate\Support\Facades\DB;

// Select
$users = DB::table('users')->where('active', true)->get();

// Insert
DB::table('users')->insert([
    'name' => 'John',
    'email' => 'john@example.com',
]);

// Update
DB::table('users')->where('id', 1)->update(['name' => 'Jane']);

// Delete
DB::table('users')->where('id', 1)->delete();

// Joins
$orders = DB::table('orders')
    ->join('users', 'orders.user_id', '=', 'users.id')
    ->select('orders.*', 'users.name')
    ->get();
```

## Middleware

```php
<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;

class CheckAge
{
    public function handle(Request $request, Closure $next)
    {
        if ($request->age < 18) {
            return redirect('/home');
        }
        return $next($request);
    }
}
```

## Authentication

```bash
composer require laravel/ui
php artisan ui bootstrap --auth
```

```php
// Protect routes
Route::get('/dashboard', function () {
    // Only authenticated users
})->middleware('auth');

Route::middleware(['auth', 'verified'])->group(function () {
    // Protected routes
});
```

## API Routes

```php
// routes/api.php
Route::middleware('auth:sanctum')->group(function () {
    Route::get('/user', function (Request $request) {
        return $request->user();
    });
});

// API Resource
Route::apiResource('posts', PostController::class);
```

## Service Container

```php
// Binding
app()->bind(PaymentGateway::class, function ($app) {
    return new StripeGateway(config('services.stripe.secret'));
});

// Singleton
app()->singleton(Settings::class, function () {
    return new Settings(config('settings'));
});

// Resolve
$payment = app(PaymentGateway::class);
```

## Events & Listeners

```php
// Event
class OrderPlaced
{
    public function __construct(public Order $order) {}
}

// Listener
class SendOrderConfirmation
{
    public function handle(OrderPlaced $event)
    {
        Mail::to($event->order->user)->send(new OrderConfirmation($event->order));
    }
}

// Registration
protected $listen = [
    OrderPlaced::class => [
        SendOrderConfirmation::class,
    ],
];
```

## Queues

```php
// Dispatch job
SendEmail::dispatch($user);

// Dispatch with delay
SendEmail::dispatch($user)->delay(now()->addMinutes(10));

// Queue connection
SendEmail::dispatch($user)->onQueue('emails');

// Process queue
php artisan queue:work
php artisan queue:listen
```

## Security Checklist

- [ ] Use CSRF protection (@csrf in forms)
- [ ] Validate all input with Form Requests
- [ ] Use parameterized queries (Eloquent handles this)
- [ ] Hash passwords with bcrypt/Hash::make()
- [ ] Sanitize output in Blade ({{ } } escapes automatically)
- [ ] Use rate limiting for API routes
- [ ] Protect sensitive routes with middleware
