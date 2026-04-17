---
name: laravel-api
description: Laravel API development specialist. Use when user asks about Laravel REST APIs, JSON responses, API authentication, or versioning.
---

# Laravel API Development

## When to use
- User asks about creating REST APIs in Laravel
- User asks about API authentication
- User asks about JSON responses
- User asks about API versioning

## API Routes

```php
// routes/api.php
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\UserController;
use App\Http\Controllers\Api\PostController;
use Illuminate\Support\Facades\Route;

// API version group
Route::prefix('v1')->group(function () {
    
    // Public routes
    Route::post('/login', [AuthController::class, 'login']);
    Route::post('/register', [AuthController::class, 'register']);
    
    // Protected routes
    Route::middleware('auth:sanctum')->group(function () {
        Route::get('/user', [AuthController::class, 'user']);
        Route::post('/logout', [AuthController::class, 'logout']);
        
        // Resource routes
        Route::apiResource('posts', PostController::class);
        Route::apiResource('users', UserController::class)->only(['index', 'show']);
    });
});

// Fallback
Route::fallback(function () {
    return response()->json(['message' => 'Not Found'], 404);
});
```

## API Controller

```php
<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\StorePostRequest;
use App\Http\Requests\UpdatePostRequest;
use App\Http\Resources\PostResource;
use App\Http\Resources\PostCollection;
use App\Models\Post;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class PostController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $perPage = $request->get('per_page', 15);
        $posts = Post::with('author')
            ->published()
            ->latest()
            ->paginate($perPage);
        
        return response()->json([
            'data' => PostResource::collection($posts),
            'meta' => [
                'current_page' => $posts->currentPage(),
                'last_page' => $posts->lastPage(),
                'per_page' => $posts->perPage(),
                'total' => $posts->total(),
            ],
        ]);
    }
    
    public function store(StorePostRequest $request): JsonResponse
    {
        $post = Post::create([
            ...$request->validated(),
            'author_id' => $request->user()->id,
        ]);
        
        return response()->json([
            'message' => 'Post created successfully',
            'data' => new PostResource($post),
        ], 201);
    }
    
    public function show(Post $post): JsonResponse
    {
        $post->load('author', 'comments');
        
        return response()->json([
            'data' => new PostResource($post),
        ]);
    }
    
    public function update(UpdatePostRequest $request, Post $post): JsonResponse
    {
        $this->authorize('update', $post);
        
        $post->update($request->validated());
        
        return response()->json([
            'message' => 'Post updated successfully',
            'data' => new PostResource($post),
        ]);
    }
    
    public function destroy(Request $request, Post $post): JsonResponse
    {
        $this->authorize('delete', $post);
        
        $post->delete();
        
        return response()->json([
            'message' => 'Post deleted successfully',
        ]);
    }
}
```

## Form Requests

```php
<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Contracts\Validation\Validator;
use Illuminate\Http\Exceptions\HttpResponseException;

class StorePostRequest extends FormRequest
{
    public function authorize(): bool
    {
        return $this->user()->can('create', Post::class);
    }
    
    public function rules(): array
    {
        return [
            'title' => ['required', 'string', 'max:255'],
            'slug' => ['nullable', 'string', 'max:255', 'unique:posts,slug'],
            'content' => ['required', 'string'],
            'excerpt' => ['nullable', 'string', 'max:500'],
            'status' => ['in:draft,published'],
            'category_id' => ['nullable', 'exists:categories,id'],
            'tags' => ['nullable', 'array'],
            'tags.*' => ['exists:tags,id'],
        ];
    }
    
    public function messages(): array
    {
        return [
            'title.required' => 'The title field is required.',
            'slug.unique' => 'This slug is already in use.',
        ];
    }
    
    protected function failedValidation(Validator $validator): void
    {
        throw new HttpResponseException(
            response()->json([
                'message' => 'Validation failed',
                'errors' => $validator->errors(),
            ], 422)
        );
    }
}
```

## API Resources

```php
<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class PostResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'title' => $this->title,
            'slug' => $this->slug,
            'content' => $this->content,
            'excerpt' => $this->when($request->routeIs('posts.show'), $this->excerpt),
            'status' => $this->status,
            'author' => new UserResource($this->whenLoaded('author')),
            'category' => new CategoryResource($this->whenLoaded('category')),
            'tags' => TagResource::collection($this->whenLoaded('tags')),
            'comments_count' => $this->when(
                $this->comments_count !== null,
                $this->comments_count
            ),
            'created_at' => $this->created_at->toIso8601String(),
            'updated_at' => $this->updated_at->toIso8601String(),
            'published_at' => $this->when(
                $this->status === 'published',
                fn() => $this->published_at?->toIso8601String()
            ),
        ];
    }
}

// Collection resource
class PostCollection extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'data' => $this->collection->map(fn($post) => [
                'id' => $post->id,
                'title' => $post->title,
                'slug' => $post->slug,
                'author' => [
                    'id' => $post->author->id,
                    'name' => $post->author->name,
                ],
            ]),
        ];
    }
}
```

## Authentication (Sanctum)

```php
<?php

namespace App\Http\Controllers\Api;

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
        
        $token = $user->createToken('api-token')->plainTextToken;
        
        return response()->json([
            'message' => 'User registered successfully',
            'user' => $user,
            'token' => $token,
        ], 201);
    }
    
    public function login(Request $request): JsonResponse
    {
        $request->validate([
            'email' => ['required', 'email'],
            'password' => ['required'],
        ]);
        
        if (!Auth::attempt($request->only('email', 'password'))) {
            throw ValidationException::withMessages([
                'email' => ['The provided credentials are incorrect.'],
            ]);
        }
        
        $user = Auth::user();
        $token = $user->createToken('api-token')->plainTextToken;
        
        return response()->json([
            'message' => 'Login successful',
            'user' => $user,
            'token' => $token,
        ]);
    }
    
    public function logout(Request $request): JsonResponse
    {
        $request->user()->currentAccessToken()->delete();
        
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

### Sanctum Setup

```php
// app/Models/User.php
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    use HasApiTokens, HasFactory, Notifiable;
    
    // ...
}

// routes/api.php
Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});
```

## Token Abilities

```php
// Create token with abilities
$token = $user->createToken('token-name', ['posts:create', 'posts:update']);

// Check ability in request
if ($request->user()->tokenCan('posts:update')) {
    // User can update posts
}

// Middleware for abilities
Route::middleware('auth:sanctum')->group(function () {
    Route::post('/posts', function () {
        // posts:create ability required
    })->middleware('can:posts:create');
});
```

## Pagination

```php
// Manual pagination
$posts = Post::paginate(15);

// Cursor pagination (faster for large datasets)
$posts = Post::cursorPaginate(15);

// Simple pagination
$posts = Post::simplePaginate(15);

// Custom pagination
$posts = Post::paginate(15, ['*'], 'page', request('page'));

// Response format
return response()->json([
    'data' => PostResource::collection($posts),
    'links' => [
        'first' => $posts->url(1),
        'last' => $posts->url($posts->lastPage()),
        'prev' => $posts->previousPageUrl(),
        'next' => $posts->nextPageUrl(),
    ],
    'meta' => [
        'current_page' => $posts->currentPage(),
        'from' => $posts->firstItem(),
        'last_page' => $posts->lastPage(),
        'per_page' => $posts->perPage(),
        'to' => $posts->lastItem(),
        'total' => $posts->total(),
    ],
]);
```

## Error Handling

```php
// Exception Handler
namespace App\Exceptions;

use Illuminate\Auth\AuthenticationException;
use Illuminate\Database\Eloquent\ModelNotFoundException;
use Illuminate\Validation\ValidationException;
use Symfony\Component\HttpKernel\Exception\NotFoundHttpException;
use Throwable;

class Handler extends ExceptionHandler
{
    public function render($request, Throwable $e)
    {
        if ($request->expectsJson()) {
            if ($e instanceof ModelNotFoundException) {
                return response()->json([
                    'message' => 'Resource not found',
                ], 404);
            }
            
            if ($e instanceof NotFoundHttpException) {
                return response()->json([
                    'message' => 'Endpoint not found',
                ], 404);
            }
            
            if ($e instanceof ValidationException) {
                return response()->json([
                    'message' => 'Validation failed',
                    'errors' => $e->errors(),
                ], 422);
            }
            
            if ($e instanceof AuthenticationException) {
                return response()->json([
                    'message' => 'Unauthenticated',
                ], 401);
            }
        }
        
        return parent::render($request, $e);
    }
}
```

## Rate Limiting

```php
// Route rate limit
Route::middleware('throttle:60,1')->group(function () {
    // 60 requests per minute
});

// Named throttle
Route::middleware('throttle:api')->group(function () {
    // Uses 'api' throttle from RouteServiceProvider
});

// Custom throttle
Route::middleware('throttle:5,1')->group(function () {
    Route::post('/login', [AuthController::class, 'login']);
});

// API Resource throttle
Route::apiResource('posts', PostController::class)->middleware('throttle:api');

// In RouteServiceProvider
RateLimiter::for('api', function (Request $request) {
    return Limit::perMinute(60)->by($request->user()?->id ?: $request->ip());
});
```

## CORS

```php
// config/cors.php
return [
    'paths' => ['api/*', 'sanctum/csrf-cookie'],
    'allowed_methods' => ['*'],
    'allowed_origins' => ['https://example.com'],
    'allowed_origins_patterns' => [],
    'allowed_headers' => ['*'],
    'exposed_headers' => [],
    'max_age' => 0,
    'supports_credentials' => true,
];
```

## API Response Macros

```php
// app/Providers/AppServiceProvider.php
use Illuminate\Support\Facades\Response;

public function boot(): void
{
    Response::macro('success', function ($data = null, string $message = 'Success', int $status = 200) {
        return response()->json([
            'success' => true,
            'message' => $message,
            'data' => $data,
        ], $status);
    });
    
    Response::macro('error', function (string $message = 'Error', int $status = 400, $errors = null) {
        $response = [
            'success' => false,
            'message' => $message,
        ];
        
        if ($errors) {
            $response['errors'] = $errors;
        }
        
        return response()->json($response, $status);
    });
    
    Response::macro('paginated', function ($paginator, $resource) {
        return response()->json([
            'success' => true,
            'data' => $resource::collection($paginator),
            'meta' => [
                'current_page' => $paginator->currentPage(),
                'last_page' => $paginator->lastPage(),
                'per_page' => $paginator->perPage(),
                'total' => $paginator->total(),
            ],
        ]);
    });
}

// Usage
return response()->success($post, 'Post created');
return response()->error('Validation failed', 422, $errors);
return response()->paginated($posts, PostResource::class);
```

## File Upload API

```php
public function upload(Request $request): JsonResponse
{
    $request->validate([
        'file' => ['required', 'file', 'max:10240', 'mimes:jpg,jpeg,png,pdf'],
    ]);
    
    $path = $request->file('file')->store('uploads', 's3');
    
    return response()->json([
        'message' => 'File uploaded',
        'path' => $path,
        'url' => Storage::disk('s3')->url($path),
    ], 201);
}
```
