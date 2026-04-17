---
name: laravel-testing
description: Laravel testing specialist. Use when user asks about testing Laravel applications, PHPUnit, feature tests, or unit tests.
---

# Laravel Testing

## When to use
- User asks about testing Laravel applications
- User asks about PHPUnit or Pest
- User asks about feature tests or unit tests
- User asks about testing APIs or databases

## Test Setup

### phpunit.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<phpunit xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:noNamespaceSchemaLocation="vendor/phpunit/phpunit/phpunit.xsd"
         bootstrap="vendor/autoload.php"
         colors="true"
>
    <testsuites>
        <testsuite name="Unit">
            <directory>tests/Unit</directory>
        </testsuite>
        <testsuite name="Feature">
            <directory>tests/Feature</directory>
        </testsuite>
    </testsuites>
    <source>
        <include>
            <directory>app</directory>
        </include>
    </source>
    <php>
        <env name="APP_ENV" value="testing"/>
        <env name="BCRYPT_ROUNDS" value="4"/>
        <env name="CACHE_DRIVER" value="array"/>
        <env name="DB_CONNECTION" value="sqlite"/>
        <env name="DB_DATABASE" value=":memory:"/>
        <env name="MAIL_MAILER" value="array"/>
        <env name="QUEUE_CONNECTION" value="sync"/>
        <env name="SESSION_DRIVER" value="array"/>
        <env name="TELESCOPE_ENABLED" value="false"/>
    </php>
</phpunit>
```

### Test Structure

```php
<?php

namespace Tests;

use Illuminate\Foundation\Testing\TestCase as BaseTestCase;

abstract class TestCase extends BaseTestCase
{
    use CreatesApplication;
}
```

## Unit Tests

### Basic Unit Test

```php
<?php

namespace Tests\Unit;

use PHPUnit\Framework\TestCase;

class StringHelperTest extends TestCase
{
    public function test_slug_generation(): void
    {
        $slug = Str::slug('Hello World');
        
        $this->assertEquals('hello-world', $slug);
    }
    
    public function test_string_truncation(): void
    {
        $text = Str::limit('The quick brown fox', 10);
        
        $this->assertEquals('The quick...', $text);
    }
}
```

### Model Unit Test

```php
<?php

namespace Tests\Unit;

use Tests\TestCase;
use App\Models\User;

class UserTest extends TestCase
{
    public function test_user_has_many_posts(): void
    {
        $user = new User();
        
        $this->assertInstanceOf(\Illuminate\Database\Eloquent\Relations\HasMany::class, $user->posts());
    }
    
    public function test_user_is_admin_attribute(): void
    {
        $user = new User(['role' => 'admin']);
        
        $this->assertTrue($user->isAdmin);
        
        $user2 = new User(['role' => 'user']);
        
        $this->assertFalse($user2->isAdmin);
    }
}
```

### Service Unit Test

```php
<?php

namespace Tests\Unit;

use Tests\TestCase;
use App\Services\CalculatorService;

class CalculatorServiceTest extends TestCase
{
    public function test_addition(): void
    {
        $calculator = new CalculatorService();
        
        $result = $calculator->add(2, 3);
        
        $this->assertEquals(5, $result);
    }
    
    public function test_division(): void
    {
        $calculator = new CalculatorService();
        
        $result = $calculator->divide(10, 2);
        
        $this->assertEquals(5, $result);
    }
    
    public function test_division_by_zero_throws_exception(): void
    {
        $calculator = new CalculatorService();
        
        $this->expectException(\InvalidArgumentException::class);
        
        $calculator->divide(10, 0);
    }
}
```

## Feature Tests

### HTTP Feature Test

```php
<?php

namespace Tests\Feature;

use Tests\TestCase;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;

class UserControllerTest extends TestCase
{
    use RefreshDatabase;
    
    public function test_users_index_returns_successful_response(): void
    {
        $response = $this->getJson('/api/users');
        
        $response->assertStatus(200);
    }
    
    public function test_users_index_returns_paginated_users(): void
    {
        User::factory()->count(20)->create();
        
        $response = $this->getJson('/api/users');
        
        $response->assertStatus(200)
            ->assertJsonCount(15, 'data') // Default pagination
            ->assertJsonStructure([
                'data' => [
                    '*' => ['id', 'name', 'email']
                ],
                'meta' => ['current_page', 'last_page', 'per_page', 'total']
            ]);
    }
    
    public function test_user_can_be_created(): void
    {
        $response = $this->postJson('/api/users', [
            'name' => 'John Doe',
            'email' => 'john@example.com',
            'password' => 'password123',
        ]);
        
        $response->assertStatus(201)
            ->assertJsonFragment(['email' => 'john@example.com']);
        
        $this->assertDatabaseHas('users', [
            'email' => 'john@example.com',
        ]);
    }
    
    public function test_user_creation_validates_required_fields(): void
    {
        $response = $this->postJson('/api/users', []);
        
        $response->assertStatus(422)
            ->assertJsonValidationErrors(['name', 'email', 'password']);
    }
    
    public function test_user_can_be_shown(): void
    {
        $user = User::factory()->create();
        
        $response = $this->getJson("/api/users/{$user->id}");
        
        $response->assertStatus(200)
            ->assertJsonFragment(['email' => $user->email]);
    }
    
    public function test_user_returns_404_when_not_found(): void
    {
        $response = $this->getJson('/api/users/999');
        
        $response->assertStatus(404);
    }
    
    public function test_user_can_be_updated(): void
    {
        $user = User::factory()->create();
        
        $response = $this->putJson("/api/users/{$user->id}", [
            'name' => 'Updated Name',
        ]);
        
        $response->assertStatus(200)
            ->assertJsonFragment(['name' => 'Updated Name']);
        
        $this->assertDatabaseHas('users', [
            'id' => $user->id,
            'name' => 'Updated Name',
        ]);
    }
    
    public function test_user_can_be_deleted(): void
    {
        $user = User::factory()->create();
        
        $response = $this->deleteJson("/api/users/{$user->id}");
        
        $response->assertStatus(200);
        $this->assertDatabaseMissing('users', ['id' => $user->id]);
    }
}
```

### Authentication Tests

```php
<?php

namespace Tests\Feature;

use Tests\TestCase;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;

class AuthenticationTest extends TestCase
{
    use RefreshDatabase;
    
    public function test_user_can_register(): void
    {
        $response = $this->postJson('/api/register', [
            'name' => 'John Doe',
            'email' => 'john@example.com',
            'password' => 'password123',
            'password_confirmation' => 'password123',
        ]);
        
        $response->assertStatus(201)
            ->assertJsonStructure(['user', 'token']);
        
        $this->assertDatabaseHas('users', ['email' => 'john@example.com']);
    }
    
    public function test_user_can_login(): void
    {
        $user = User::factory()->create([
            'email' => 'john@example.com',
            'password' => bcrypt('password123'),
        ]);
        
        $response = $this->postJson('/api/login', [
            'email' => 'john@example.com',
            'password' => 'password123',
        ]);
        
        $response->assertStatus(200)
            ->assertJsonStructure(['user', 'token']);
    }
    
    public function test_user_cannot_login_with_wrong_credentials(): void
    {
        $user = User::factory()->create([
            'email' => 'john@example.com',
            'password' => bcrypt('password123'),
        ]);
        
        $response = $this->postJson('/api/login', [
            'email' => 'john@example.com',
            'password' => 'wrongpassword',
        ]);
        
        $response->assertStatus(422);
    }
    
    public function test_protected_route_requires_authentication(): void
    {
        $response = $this->getJson('/api/user');
        
        $response->assertStatus(401);
    }
    
    public function test_authenticated_user_can_access_protected_route(): void
    {
        $user = User::factory()->create();
        
        $response = $this->actingAs($user, 'sanctum')
            ->getJson('/api/user');
        
        $response->assertStatus(200)
            ->assertJsonFragment(['email' => $user->email]);
    }
}
```

### Form Request Tests

```php
<?php

namespace Tests\Feature;

use Tests\TestCase;
use App\Http\Requests\StorePostRequest;
use Illuminate\Foundation\Testing\RefreshDatabase;

class StorePostRequestTest extends TestCase
{
    use RefreshDatabase;
    
    public function test_store_post_request_validates_title(): void
    {
        $response = $this->postJson('/api/posts', [
            'content' => 'Post content',
        ]);
        
        $response->assertStatus(422)
            ->assertJsonValidationErrors(['title']);
    }
    
    public function test_store_post_request_validates_content(): void
    {
        $response = $this->postJson('/api/posts', [
            'title' => 'Post title',
        ]);
        
        $response->assertStatus(422)
            ->assertJsonValidationErrors(['content']);
    }
    
    public function test_store_post_request_validates_slug_uniqueness(): void
    {
        $post = \App\Models\Post::factory()->create(['slug' => 'existing-slug']);
        
        $response = $this->postJson('/api/posts', [
            'title' => 'New Post',
            'slug' => 'existing-slug',
            'content' => 'Post content',
        ]);
        
        $response->assertStatus(422)
            ->assertJsonValidationErrors(['slug']);
    }
}
```

### Database Tests

```php
<?php

namespace Tests\Feature;

use Tests\TestCase;
use App\Models\Post;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;

class PostTest extends TestCase
{
    use RefreshDatabase;
    
    public function test_post_belongs_to_user(): void
    {
        $user = User::factory()->create();
        $post = Post::factory()->create(['user_id' => $user->id]);
        
        $this->assertInstanceOf(User::class, $post->user);
        $this->assertEquals($user->id, $post->user->id);
    }
    
    public function test_user_can_have_many_posts(): void
    {
        $user = User::factory()->hasPosts(5)->create();
        
        $this->assertCount(5, $user->posts);
    }
    
    public function test_post_can_add_tags(): void
    {
        $post = Post::factory()->create();
        $tag = \App\Models\Tag::factory()->create();
        
        $post->tags()->attach($tag->id);
        
        $this->assertTrue($post->tags->contains($tag));
    }
    
    public function test_cascade_delete_posts_when_user_deleted(): void
    {
        $user = User::factory()->hasPosts(3)->create();
        $postIds = $user->posts->pluck('id');
        
        $user->delete();
        
        foreach ($postIds as $id) {
            $this->assertDatabaseMissing('posts', ['id' => $id]);
        }
    }
}
```

## Mocking

### Mocking Services

```php
public function test_shipping_calculation(): void
{
    $calculator = Mockery::mock(ShippingCalculator::class);
    $calculator->shouldReceive('calculate')
        ->once()
        ->with(10.00, 'US')
        ->andReturn(5.00);
    
    $this->app->instance(ShippingCalculator::class, $calculator);
    
    $response = $this->postJson('/api/calculate-shipping', [
        'weight' => 10,
        'country' => 'US',
    ]);
    
    $response->assertStatus(200)
        ->assertJsonFragment(['shipping' => 5.00]);
}
```

### Mocking Mail

```php
public function test_welcome_email_sent_on_registration(): void
{
    Mail::fake();
    
    $response = $this->postJson('/api/register', [
        'name' => 'John Doe',
        'email' => 'john@example.com',
        'password' => 'password123',
        'password_confirmation' => 'password123',
    ]);
    
    Mail::assertSent(WelcomeEmail::class, function ($mail) {
        return $mail->hasTo('john@example.com');
    });
    
    Mail::assertNotSent(VerificationEmail::class);
}
```

### Mocking Events

```php
public function test_order_placed_event_dispatched(): void
{
    Event::fake();
    
    $response = $this->postJson('/api/orders', [
        'product_id' => 1,
        'quantity' => 2,
    ]);
    
    Event::assertDispatched(OrderPlaced::class);
    Event::assertNotDispatched(OrderCancelled::class);
}
```

### Mocking Queues

```php
public function test_email_job_dispatched_on_user_creation(): void
{
    Queue::fake();
    
    $response = $this->postJson('/api/users', [
        'name' => 'John Doe',
        'email' => 'john@example.com',
        'password' => 'password123',
    ]);
    
    Queue::assertPushed(SendWelcomeEmail::class, function ($job) {
        return $job->user->email === 'john@example.com';
    });
}
```

## Assertions Reference

### HTTP Assertions

| Method | Description |
|--------|-------------|
| `assertStatus($code)` | Assert response status code |
| `assertJson($data)` | Assert JSON response |
| `assertJsonFragment($data)` | Assert JSON contains fragment |
| `assertJsonStructure($structure)` | Assert JSON structure |
| `assertJsonValidationErrors($keys)` | Assert validation errors |
| `assertRedirect($uri)` | Assert redirect |
| `assertHeader($name, $value)` | Assert header value |
| `assertCookie($name, $value)` | Assert cookie value |
| `assertSessionHas($key, $value)` | Assert session has value |

### Database Assertions

| Method | Description |
|--------|-------------|
| `assertDatabaseHas($table, $data)` | Assert record exists |
| `assertDatabaseMissing($table, $data)` | Assert record doesn't exist |
| `assertSoftDeleted($table, $data)` | Assert soft deleted record |

### Authentication Assertions

| Method | Description |
|--------|-------------|
| `actingAs($user, $guard)` | Authenticate as user |
| `assertAuthenticated($guard)` | Assert authenticated |
| `assertGuest($guard)` | Assert not authenticated |

## Running Tests

```bash
# Run all tests
php artisan test

# Run specific test file
php artisan test tests/Feature/UserTest.php

# Run specific test method
php artisan test --filter=test_user_can_be_created

# Run with coverage
php artisan test --coverage

# Run with coverage report
php artisan test --coverage-html coverage/

# Run tests in parallel
php artisan test --parallel

# Run tests with specific group
php artisan test --group=api
```
