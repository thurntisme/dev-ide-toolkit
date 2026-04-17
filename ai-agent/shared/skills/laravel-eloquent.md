---
name: laravel-eloquent
description: Laravel Eloquent ORM specialist. Use when user asks about Eloquent models, relationships, scopes, or query optimization.
---

# Laravel Eloquent ORM

## When to use
- User asks about Eloquent models
- User asks about relationships
- User asks about scopes or query optimization
- User asks about model events

## Model Definition

```php
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class User extends Model
{
    use HasFactory;
    
    protected $table = 'users';
    
    protected $primaryKey = 'id';
    
    public $timestamps = true;
    
    protected $fillable = [
        'name',
        'email',
        'password',
    ];
    
    protected $hidden = [
        'password',
        'remember_token',
    ];
    
    protected $casts = [
        'email_verified_at' => 'datetime',
        'password' => 'hashed',
        'settings' => 'array',
        'is_active' => 'boolean',
    ];
    
    protected $attributes = [
        'role' => 'user',
    ];
}
```

## Query Builder

```php
// All records
User::all();

// Find by primary key
User::find(1);
User::findOrFail(1);

// Where clauses
User::where('status', 'active')->get();
User::where('age', '>=', 18)->get();
User::where('name', 'like', '%John%')->get();

// Multiple conditions
User::where('status', 'active')
    ->where('age', '>=', 18)
    ->orWhere('role', 'admin')
    ->get();

// WhereIn / WhereNotIn
User::whereIn('role', ['admin', 'moderator'])->get();
User::whereNotIn('id', [1, 2, 3])->get();

// Where between
User::whereBetween('age', [18, 30])->get();

// Ordering
User::orderBy('created_at', 'desc')->get();
User::latest()->get();
User::oldest()->get();

// Pagination
User::paginate(15);
User::simplePaginate(15);
$users->links();
```

## Relationships

### One to One

```php
// User model
public function phone(): HasOne
{
    return $this->hasOne(Phone::class);
}

// Phone model
public function user(): BelongsTo
{
    return $this->belongsTo(User::class);
}

// Usage
$phone = $user->phone;
$user = $phone->user;
```

### One to Many

```php
// User model
public function posts(): HasMany
{
    return $this->hasMany(Post::class);
}

// Post model
public function author(): BelongsTo
{
    return $this->belongsTo(User::class, 'user_id');
}

// Usage
$posts = $user->posts;
$author = $post->author;
```

### Many to Many

```php
// User model
public function roles(): BelongsToMany
{
    return $this->belongsToMany(Role::class, 'role_user', 'user_id', 'role_id')
        ->withTimestamps()
        ->withPivot('created_by');
}

// Role model
public function users(): BelongsToMany
{
    return $this->belongsToMany(User::class);
}

// Usage
$user->roles()->attach($roleId);
$user->roles()->detach($roleId);
$user->roles()->sync([1, 2, 3]);
$user->roles()->toggle([1, 2]);

// Check role
if ($user->roles->contains($roleId)) {
    // User has role
}
```

### Has Many Through

```php
// Country has many posts through users
public function posts(): HasManyThrough
{
    return $this->hasManyThrough(Post::class, User::class);
}

// Usage
$country->posts;
```

### Polymorphic

```php
// Image model
public function imageable(): MorphTo
{
    return $this->morphTo();
}

// User model
public function image(): MorphOne
{
    return $this->morphOne(Image::class, 'imageable');
}

// Post model
public function image(): MorphOne
{
    return $this->morphOne(Image::class, 'imageable');
}

// Usage
$user->image;
$post->image;
$image->imageable; // Returns User or Post
```

### Many to Many Polymorphic

```php
// Tag model
public function posts(): MorphToMany
{
    return $this->morphedByMany(Post::class, 'taggable');
}

public function videos(): MorphToMany
{
    return $this->morphedByMany(Video::class, 'taggable');
}

// Post model
public function tags(): MorphToMany
{
    return $this->morphToMany(Tag::class, 'taggable');
}

// Usage
$post->tags()->attach($tagId);
$post->tags;
```

## Scopes

### Local Scopes

```php
class User extends Model
{
    // scope + method name
    public function scopeActive($query)
    {
        return $query->where('status', 'active');
    }
    
    public function scopeAdmin($query)
    {
        return $query->where('role', 'admin');
    }
    
    public function scopeVerified($query)
    {
        return $query->whereNotNull('email_verified_at');
    }
    
    // Scopes with parameters
    public function scopeOfRole($query, string $role)
    {
        return $query->where('role', $role);
    }
    
    public function scopeCreatedBetween($query, $from, $to)
    {
        return $query->whereBetween('created_at', [$from, $to]);
    }
}

// Usage
User::active()->get();
User::admin()->verified()->get();
User::ofRole('moderator')->get();
```

### Global Scopes

```php
// Define scope
class ActiveScope implements Scope
{
    public function apply(Builder $builder, Model $model): void
    {
        $builder->where('active', true);
    }
}

// Apply to model
class User extends Model
{
    protected static function booted(): void
    {
        static::addGlobalScope(new ActiveScope);
    }
}

// Anonymous global scope
static::addGlobalScope('active', function ($builder) {
    $builder->where('active', true);
});
```

## Eager Loading

```php
// With relationship
$users = User::with('posts')->get();

// Multiple relationships
$users = User::with(['posts', 'comments'])->get();

// Nested eager loading
$users = User::with(['posts.comments'])->get();

// Conditional eager loading
$users = User::with(['posts' => function ($query) {
    $query->where('published', true);
}])->get();

// Lazy eager loading
$users = User::all();
$users->load('posts');

// Load missing
$users->loadMissing('posts');

// Lazy loading count
$users->loadCount('posts');
$users->loadCount(['posts', 'comments']);
```

## Collections

```php
$users = User::all();

// Filter
$admins = $users->filter(fn($user) => $user->isAdmin());

// Map
$names = $users->map(fn($user) => $user->name);

// Reduce
$total = $users->reduce(fn($sum, $user) => $sum + $user->posts_count, 0);

// First / Last
$first = $users->first();
$last = $users->last();

// Sort
$sorted = $users->sortBy('name');

// Group
$grouped = $users->groupBy('role');

// Pluck (get specific column)
$names = $users->pluck('name');

// Contains
$hasJohn = $users->contains('name', 'John');

// Find by key
$user = $users->find(1);
```

## Accessors & Mutators

```php
class User extends Model
{
    // Accessor
    public function getFullNameAttribute(): string
    {
        return "{$this->first_name} {$this->last_name}";
    }
    
    // Usage: $user->full_name
    
    // Mutator
    public function setPasswordAttribute(string $value): void
    {
        $this->attributes['password'] = Hash::make($value);
    }
    
    // Array access
    public function getSettingsAttribute(array $value): array
    {
        return array_merge([
            'theme' => 'light',
            'language' => 'en',
        ], $value);
    }
}
```

## Model Events

```php
class User extends Model
{
    protected static function booted(): void
    {
        // Creating
        static::creating(function (User $user) {
            if (!$user->uuid) {
                $user->uuid = Str::uuid();
            }
        });
        
        // Created
        static::created(function (User $user) {
            Mail::to($user)->send(new WelcomeMail($user));
        });
        
        // Updating
        static::updating(function (User $user) {
            // Before update
        });
        
        // Updated
        static::updated(function (User $user) {
            Cache::forget("user.{$user->id}");
        });
        
        // Deleting
        static::deleting(function (User $user) {
            $user->posts()->delete();
        });
    }
}
```

## Factory & Seeding

```php
// database/factories/UserFactory.php
use Illuminate\Database\Eloquent\Factories\Factory;

class UserFactory extends Factory
{
    public function definition(): array
    {
        return [
            'name' => fake()->name(),
            'email' => fake()->unique()->safeEmail(),
            'email_verified_at' => now(),
            'password' => 'password',
            'remember_token' => Str::random(10),
        ];
    }
    
    public function unverified(): static
    {
        return $this->state(fn (array $attributes) => [
            'email_verified_at' => null,
        ]);
    }
    
    public function admin(): static
    {
        return $this->state(fn (array $attributes) => [
            'role' => 'admin',
        ]);
    }
}

// Usage
User::factory()->make();
User::factory()->count(10)->make();
User::factory()->create();
User::factory()->admin()->create();
User::factory()->count(5)->admin()->create();
```

## Optimizations

```php
// Select specific columns
User::select('id', 'name', 'email')->get();

// Join optimization
User::select('users.*')
    ->join('posts', 'users.id', '=', 'posts.user_id')
    ->where('posts.published', true)
    ->groupBy('users.id')
    ->get();

// Subqueries
$latestPosts = DB::table('posts')
    ->select('user_id', DB::raw('MAX(created_at) as latest_post'))
    ->groupBy('user_id');

$users = User::joinSub($latestPosts, 'latest_posts', function ($join) {
    $join->on('users.id', '=', 'latest_posts.user_id');
})->get();

// Chunk for large datasets
User::chunk(100, function ($users) {
    foreach ($users as $user) {
        // Process each user
    }
});

// Cursor for memory efficiency
foreach (User::where('active', true)->cursor() as $user) {
    // Process without loading all into memory
}

// Chunk by ID
User::where('active', true)
    ->chunkById(100, function ($users) {
        foreach ($users as $user) {
            // Process
        }
    });
```

## Raw Queries

```php
// Raw where
User::whereRaw('price > ? AND status = ?', [100, 'active'])

// Raw expressions
User::select(DB::raw('count(*) as user_count, status'))
    ->groupBy('status')
    ->get();

// DB::statement
DB::statement('SET FOREIGN_KEY_CHECKS=0');

// DB::unprepared
DB::unprepared('TRUNCATE TABLE users');
```
