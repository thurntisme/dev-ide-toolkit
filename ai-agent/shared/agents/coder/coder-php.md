---
name: coder-php
description: PHP development. Use when user asks to create, modify, or debug PHP applications.
---

# PHP Development Guide

## When to use
- User asks to create a PHP application
- User asks to add functionality to a PHP project
- User asks about PHP best practices
- User asks to debug PHP issues

## Conventions

- Follow PSR-12 coding standard
- Use type hints and return types
- Use namespaces
- Use Composer for dependency management
- Use PHP 8.x features

## File Structure

```
project/
├── src/
│   ├── Controllers/
│   ├── Models/
│   ├── Services/
│   └── Helpers/
├── config/
├── public/
│   └── index.php
├── tests/
├── vendor/
├── composer.json
└── phpunit.xml
```

## Composer

```bash
composer init
composer require <package>
composer require --dev <dev-package>
composer install
composer autoload-dump
```

## PHP 8 Features

```php
<?php

class User {
    public function __construct(
        public readonly string $name,
        public readonly string $email,
    ) {}

    public function greet(): string
    {
        return "Hello, {$this->name}!";
    }
}

// Named arguments
$user = new User(
    name: 'John',
    email: 'john@example.com',
);

// Match expression
$status = match($score) {
    90 => 'A',
    80 => 'B',
    default => 'C',
};
```

## Database (PDO)

```php
<?php

$pdo = new PDO(
    'mysql:host=localhost;dbname=test',
    'username',
    'password',
    [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]
);

$stmt = $pdo->prepare('SELECT * FROM users WHERE id = :id');
$stmt->execute(['id' => $userId]);
$user = $stmt->fetch(PDO::FETCH_ASSOC);
```

## Routing (Simple)

```php
<?php

$routes = [
    'GET /users' => 'UserController@index',
    'POST /users' => 'UserController@store',
    'GET /users/{id}' => 'UserController@show',
];

$method = $_SERVER['REQUEST_METHOD'];
$uri = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);

if (isset($routes["$method $uri"])) {
    [$controller, $method] = explode('@', $routes["$method $uri"]);
    (new $controller)->$method();
}
```

## Security Checklist

- [ ] Use prepared statements for database queries
- [ ] Escape output (htmlspecialchars)
- [ ] Validate and sanitize input
- [ ] Use CSRF tokens for forms
- [ ] Use secure session handling
- [ ] Never expose secrets in code

## Testing

```php
<?php

use PHPUnit\Framework\TestCase;

class UserTest extends TestCase
{
    public function testGreeting(): void
    {
        $user = new User('John', 'john@example.com');
        $this->assertEquals('Hello, John!', $user->greet());
    }
}
```
