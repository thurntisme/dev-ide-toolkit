---
name: php-modern
description: Modern PHP development specialist. Use when user asks about PHP 8 features, Composer, PSR standards, or modern PHP patterns.
---

# Modern PHP Development

## When to use
- User asks about PHP 8.x features
- User asks about Composer packages
- User asks about PSR standards
- User asks about modern PHP patterns

## PHP 8.x Features

### Named Arguments

```php
function createUser(string $name, string $email, bool $active = true): User {
    // ...
}

// Using named arguments
$user = createUser(
    email: 'john@example.com',
    name: 'John',
    active: true
);
```

### Match Expression

```php
$status = match($httpCode) {
    200, 201 => 'Success',
    300, 301 => 'Redirect',
    400 => 'Bad Request',
    401, 403 => 'Unauthorized',
    404 => 'Not Found',
    default => 'Unknown',
};
```

### Nullsafe Operator

```php
// Before
$country = null;
if ($session !== null) {
    $user = $session->user;
    if ($user !== null) {
        $country = $user->getAddress()?->country;
    }
}

// After (PHP 8.0)
$country = $session?->user?->getAddress()?->country;
```

### Constructor Property Promotion

```php
// Before PHP 8.0
class User {
    public string $name;
    public string $email;
    
    public function __construct(string $name, string $email) {
        $this->name = $name;
        $this->email = $email;
    }
}

// PHP 8.0+
class User {
    public function __construct(
        public readonly string $name,
        public readonly string $email,
    ) {}
}
```

### Union Types

```php
class Number {
    public function __construct(
        public int|float $value
    ) {}
    
    public function getValue(): int|float {
        return $this->value;
    }
}
```

### Enums

```php
enum Status: string {
    case Draft = 'draft';
    case Published = 'published';
    case Archived = 'archived';
    
    public function label(): string {
        return match($this) {
            self::Draft => 'Draft',
            self::Published => 'Published',
            self::Archived => 'Archived',
        };
    }
}

// Usage
$status = Status::Published;
echo $status->value; // 'published'
echo $status->label(); // 'Published'
```

### Attributes

```php
use PHPUnit\Framework\TestCase;

#[TestCase(1, 2, 3)]
#[TestCase(4, 5, 9)]
class DataProviderTest extends TestCase
{
    public function testAddition(int $a, int $b, int $expected): void
    {
        $this->assertEquals($expected, $a + $b);
    }
}

// Custom attribute
#[Attribute(Attribute::TARGET_METHOD | Attribute::TARGET_CLASS)]
class Cacheable
{
    public function __construct(
        public int $ttl = 3600
    ) {}
}

#[Cacheable(ttl: 600)]
class UserService
{
    #[Cacheable(ttl: 300)]
    public function getUser(int $id): User
    {
        // ...
    }
}
```

### First-Class Callable Syntax

```php
// Before
$func = Closure::fromCallable([$controller, 'index']);

// PHP 8.1+
$func = $controller->index(...);
```

### Readonly Properties

```php
class Config {
    public function __construct(
        public readonly string $appName,
        public readonly string $environment,
        public readonly array $settings,
    ) {}
}

$config = new Config('MyApp', 'production', ['debug' => true]);
echo $config->appName; // 'MyApp'
$config->appName = 'NewApp'; // Error: Cannot modify readonly property
```

### New Functions

```php
// str_contains (PHP 8.0)
if (str_contains('Hello World', 'World')) {
    echo 'Found!';
}

// str_starts_with / str_ends_with (PHP 8.0)
str_starts_with($haystack, $needle);
str_ends_with($haystack, $needle);

// get_debug_type (PHP 8.0)
echo get_debug_type($var); // 'string', 'array', 'MyClass', etc.

// fdiv (PHP 8.0)
$result = fdiv(10, 3); // 3.3333... (no warning on division by zero)

// array_is_list (PHP 8.1)
array_is_list([1, 2, 3]); // true
array_is_list(['a' => 1, 'b' => 2]); // false
```

## Composer

### Basic Commands

```bash
# Initialize project
composer init

# Add dependencies
composer require monolog/monolog
composer require --dev phpunit/phpunit

# Install from lock file
composer install

# Update dependencies
composer update

# Update specific package
composer update monolog/monolog

# Remove package
composer remove monolog/monolog

# Autoload dump
composer dump-autoload
```

### composer.json

```json
{
    "name": "vendor/package",
    "description": "Package description",
    "type": "project",
    "license": "MIT",
    "require": {
        "php": ">=8.1",
        "psr/log": "^3.0"
    },
    "require-dev": {
        "phpunit/phpunit": "^10.0",
        "phpstan/phpstan": "^1.0"
    },
    "autoload": {
        "psr-4": {
            "App\\": "src/"
        }
    },
    "autoload-dev": {
        "App\\Tests\\": "tests/"
    },
    "scripts": {
        "test": "phpunit",
        "analyse": "phpstan analyse"
    },
    "config": {
        "optimize-autoloader": true,
        "sort-packages": true
    }
}
```

## PSR Standards

### PSR-4 Autoloading

```json
{
    "autoload": {
        "psr-4": {
            "App\\": "src/",
            "App\\Tests\\": "tests/"
        }
    }
}
```

### PSR-3 Logger Interface

```php
use Psr\Log\LoggerInterface;

class UserService
{
    public function __construct(
        private LoggerInterface $logger
    ) {}
    
    public function createUser(array $data): User
    {
        $this->logger->info('Creating user', ['email' => $data['email']]);
        // ...
    }
}
```

### PSR-7 HTTP Messages

```php
use Psr\Http\Message\ServerRequestInterface;
use Psr\Http\Message\ResponseInterface;

function handleRequest(ServerRequestInterface $request): ResponseInterface
{
    $name = $request->getQueryParams()['name'] ?? 'Guest';
    
    return new Response(200, ['Content-Type' => 'text/plain'], "Hello, $name");
}
```

### PSR-11 Container

```php
use Psr\Container\ContainerInterface;

class UserController
{
    public function __construct(
        private ContainerInterface $container
    ) {}
    
    public function index()
    {
        $userService = $this->container->get(UserService::class);
        // ...
    }
}
```

## Design Patterns

### Dependency Injection

```php
interface MailerInterface
{
    public function send(string $to, string $subject, string $body): void;
}

class SmtpMailer implements MailerInterface
{
    public function __construct(
        private string $host,
        private int $port
    ) {}
    
    public function send(string $to, string $subject, string $body): void
    {
        // Send email via SMTP
    }
}

class UserService
{
    public function __construct(
        private MailerInterface $mailer
    ) {}
}
```

### Repository Pattern

```php
interface UserRepositoryInterface
{
    public function findById(int $id): ?User;
    public function findByEmail(string $email): ?User;
    public function save(User $user): void;
}

class UserRepository implements UserRepositoryInterface
{
    public function __construct(
        private PDO $pdo
    ) {}
    
    public function findById(int $id): ?User
    {
        $stmt = $this->pdo->prepare('SELECT * FROM users WHERE id = ?');
        $stmt->execute([$id]);
        $data = $stmt->fetch(PDO::FETCH_ASSOC);
        
        return $data ? User::fromArray($data) : null;
    }
    
    public function findByEmail(string $email): ?User
    {
        // ...
    }
    
    public function save(User $user): void
    {
        // ...
    }
}
```

### Data Transfer Object (DTO)

```php
readonly class CreateUserDTO
{
    public function __construct(
        public string $name,
        public string $email,
        public string $password
    ) {}
    
    public static function fromArray(array $data): self
    {
        return new self(
            name: $data['name'],
            email: $data['email'],
            password: $data['password']
        );
    }
}

class UserService
{
    public function create(CreateUserDTO $dto): User
    {
        // Use DTO data
    }
}
```

### Value Object

```php
readonly class Email
{
    public function __construct(
        private string $value
    ) {
        if (!filter_var($value, FILTER_VALIDATE_EMAIL)) {
            throw new InvalidArgumentException('Invalid email');
        }
    }
    
    public function value(): string
    {
        return $this->value;
    }
    
    public function equals(Email $other): bool
    {
        return $this->value === $other->value;
    }
}
```

## Error Handling

```php
// Throwable catch
try {
    $result = riskyOperation();
} catch (Throwable $e) {
    Log::error($e->getMessage(), [
        'exception' => $e,
        'context' => $context
    ]);
    throw $e;
}

// Multiple catch
try {
    // ...
} catch (ValidationException $e) {
    return response()->json(['error' => $e->getMessage()], 422);
} catch (NotFoundException $e) {
    return response()->json(['error' => 'Not found'], 404);
} catch (Throwable $e) {
    return response()->json(['error' => 'Server error'], 500);
}
```

## Type Declarations

```php
declare(strict_types=1);

function process(int|float $number): string
{
    return (string) $number;
}

class Container
{
    private array $items = [];
    
    public function set(string $key, mixed $value): void
    {
        $this->items[$key] = $value;
    }
    
    public function get(string $key): mixed
    {
        return $this->items[$key] ?? null;
    }
}
```
