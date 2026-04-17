---
name: php-security
description: PHP security specialist. Use when user asks about PHP security, sanitization, authentication, or protecting PHP applications.
---

# PHP Security

## When to use
- User asks about PHP security best practices
- User asks about input validation and sanitization
- User asks about authentication and authorization
- User asks about securing APIs

## Input Validation

### Basic Validation

```php
function validateInput(array $data, array $rules): array
{
    $errors = [];
    
    foreach ($rules as $field => $ruleSet) {
        $value = $data[$field] ?? null;
        
        foreach ($ruleSet as $rule) {
            if (!$rule($value)) {
                $errors[$field][] = "Invalid {$field}";
            }
        }
    }
    
    return $errors;
}

// Usage
$errors = validateInput($_POST, [
    'email' => [
        fn($v) => !empty($v),
        fn($v) => filter_var($v, FILTER_VALIDATE_EMAIL),
    ],
    'age' => [
        fn($v) => is_numeric($v) && $v >= 0,
    ],
]);
```

### Filter Input

```php
// Sanitize strings
$name = filter_input(INPUT_POST, 'name', FILTER_SANITIZE_FULL_SPECIAL_CHARS);
$email = filter_input(INPUT_POST, 'email', FILTER_SANITIZE_EMAIL);
$url = filter_input(INPUT_POST, 'url', FILTER_SANITIZE_URL);
$int = filter_input(INPUT_POST, 'age', FILTER_SANITIZE_NUMBER_INT);

// Array of integers
$numbers = filter_input(INPUT_POST, 'numbers', FILTER_SANITIZE_NUMBER_INT, FILTER_REQUIRE_ARRAY);
```

### Validate Against Schema

```php
class UserRegistrationRequest
{
    public array $errors = [];
    
    public function __construct(array $data)
    {
        $this->validate($data);
    }
    
    private function validate(array $data): void
    {
        // Name validation
        if (empty($data['name'])) {
            $this->errors['name'] = 'Name is required';
        } elseif (strlen($data['name']) < 2) {
            $this->errors['name'] = 'Name must be at least 2 characters';
        } elseif (strlen($data['name']) > 100) {
            $this->errors['name'] = 'Name must not exceed 100 characters';
        }
        
        // Email validation
        if (empty($data['email'])) {
            $this->errors['email'] = 'Email is required';
        } elseif (!filter_var($data['email'], FILTER_VALIDATE_EMAIL)) {
            $this->errors['email'] = 'Invalid email format';
        }
        
        // Password validation
        if (empty($data['password'])) {
            $this->errors['password'] = 'Password is required';
        } elseif (strlen($data['password']) < 8) {
            $this->errors['password'] = 'Password must be at least 8 characters';
        }
        
        // Password complexity
        if (!preg_match('/[A-Z]/', $data['password'] ?? '')) {
            $this->errors['password'] = 'Password must contain uppercase letter';
        }
        if (!preg_match('/[a-z]/', $data['password'] ?? '')) {
            $this->errors['password'] = 'Password must contain lowercase letter';
        }
        if (!preg_match('/[0-9]/', $data['password'] ?? '')) {
            $this->errors['password'] = 'Password must contain number';
        }
    }
    
    public function fails(): bool
    {
        return !empty($this->errors);
    }
}
```

## SQL Injection Prevention

### Prepared Statements (PDO)

```php
$pdo = new PDO($dsn, $user, $pass, [
    PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
]);

// Safe query with placeholders
$stmt = $pdo->prepare('SELECT * FROM users WHERE id = :id');
$stmt->execute(['id' => $userId]);
$user = $stmt->fetch(PDO::FETCH_ASSOC);

// Multiple parameters
$stmt = $pdo->prepare('
    SELECT * FROM users 
    WHERE email = :email AND status = :status
');
$stmt->execute([
    'email' => $email,
    'status' => 'active'
]);
```

### LIKE Queries

```php
$stmt = $pdo->prepare('
    SELECT * FROM users 
    WHERE name LIKE :search
');
$stmt->execute([
    'search' => '%' . $pdo->quote($searchTerm) . '%'
]);
// Or escape manually
$search = addcslashes($searchTerm, '%_');
$stmt = $pdo->prepare('
    SELECT * FROM users 
    WHERE name LIKE :search
');
$stmt->execute(['search' => "%{$search}%"]);
```

### LIMIT/OFFSET

```php
$stmt = $pdo->prepare('
    SELECT * FROM posts 
    ORDER BY created_at DESC 
    LIMIT :limit OFFSET :offset
');
$stmt->bindValue('limit', (int) $limit, PDO::PARAM_INT);
$stmt->bindValue('offset', (int) $offset, PDO::PARAM_INT);
$stmt->execute();
```

## XSS Prevention

### Output Escaping

```php
// Escape HTML entities
function e(string $string): string
{
    return htmlspecialchars($string, ENT_QUOTES | ENT_HTML5, 'UTF-8');
}

// Usage in HTML
echo e($userInput); // Safe output
echo htmlspecialchars($userInput, ENT_QUOTES, 'UTF-8');

// For attribute values (always quote attributes)
echo '<input value="' . e($value) . '">';
```

### Content Security Policy

```php
// In your entry point or .htaccess
header("Content-Security-Policy: default-src 'self'; script-src 'self' 'nonce-{random}'; style-src 'self' 'unsafe-inline';");

// Generate nonce for inline scripts
$nonce = base64_encode(random_bytes(16));
$_SESSION['csp_nonce'] = $nonce;
header("Content-Security-Policy: script-src 'self' 'nonce-{$nonce}';");
```

### HTML Purifier

```php
composer require mews/purifier

// Configure
$config = HTMLPurifier_Config::createDefault();
$config->set('Core.EscapeInvalidTags', true);
$config->set('HTML.Allowed', 'p,br,b,i,a[href],ul,ol,li');

$purifier = new HTMLPurifier($config);
$clean = $purifier->purify($dirty);
```

## CSRF Protection

### Generate Token

```php
function generateCsrfToken(): string
{
    if (empty($_SESSION['csrf_token'])) {
        $_SESSION['csrf_token'] = bin2hex(random_bytes(32));
    }
    return $_SESSION['csrf_token'];
}

function csrfField(): string
{
    $token = generateCsrfToken();
    return '<input type="hidden" name="csrf_token" value="' . e($token) . '">';
}
```

### Verify Token

```php
function validateCsrf(): bool
{
    $token = $_POST['csrf_token'] ?? $_SERVER['HTTP_X_CSRF_TOKEN'] ?? '';
    return hash_equals($_SESSION['csrf_token'] ?? '', $token);
}

// Usage in form handler
if (!validateCsrf()) {
    http_response_code(403);
    die('CSRF validation failed');
}
```

## Password Security

### Hashing

```php
// Hash password (PHP 5.5+)
$hash = password_hash($password, PASSWORD_DEFAULT);

// Verify password
if (password_verify($password, $hash)) {
    // Password correct
}

// Check if needs rehash (when changing algorithm)
if (password_needs_rehash($hash, PASSWORD_DEFAULT, ['cost' => 12])) {
    $newHash = password_hash($password, PASSWORD_DEFAULT, ['cost' => 12]);
    // Update hash in database
}
```

### Argon2

```php
// Argon2i (PHP 7.2+)
$hash = password_hash($password, PASSWORD_ARGON2I);

// Argon2id (PHP 7.3+)
$hash = password_hash($password, PASSWORD_ARGON2ID);

$options = [
    'memory_cost' => 65536,  // 64MB
    'time_cost' => 4,
    'threads' => 3,
];
$hash = password_hash($password, PASSWORD_ARGON2ID, $options);
```

## Session Security

```php
// Start session securely
session_start([
    'cookie_lifetime' => 0,
    'cookie_httponly' => true,
    'cookie_secure' => true,     // HTTPS only
    'cookie_samesite' => 'Strict',
    'use_strict_mode' => true,
    'use_only_cookies' => true,
]);

// Regenerate session ID after login
session_regenerate_id(true);

// Session fixation prevention
$_SESSION['user_id'] = $userId;
$_SESSION['created'] = time();
$_SESSION['fingerprint'] = hash('sha256', $_SERVER['HTTP_USER_AGENT'] . $_SERVER['REMOTE_ADDR']);

// Validate fingerprint
if (!hash_equals($_SESSION['fingerprint'] ?? '', hash('sha256', $_SERVER['HTTP_USER_AGENT'] . $_SERVER['REMOTE_ADDR']))) {
    session_destroy();
    header('Location: /login');
    exit;
}
```

## File Upload Security

```php
function validateFileUpload(array $file): array
{
    $errors = [];
    
    // Check for upload errors
    if ($file['error'] !== UPLOAD_ERR_OK) {
        $errors[] = 'File upload failed';
        return $errors;
    }
    
    // Check file size (e.g., 5MB max)
    if ($file['size'] > 5 * 1024 * 1024) {
        $errors[] = 'File too large (max 5MB)';
    }
    
    // Check MIME type
    $finfo = finfo_open(FILEINFO_MIME_TYPE);
    $mimeType = finfo_file($finfo, $file['tmp_name']);
    finfo_close($finfo);
    
    $allowedMimes = ['image/jpeg', 'image/png', 'image/gif', 'application/pdf'];
    if (!in_array($mimeType, $allowedMimes)) {
        $errors[] = 'Invalid file type';
    }
    
    // Check extension
    $allowedExtensions = ['jpg', 'jpeg', 'png', 'gif', 'pdf'];
    $extension = strtolower(pathinfo($file['name'], PATHINFO_EXTENSION));
    if (!in_array($extension, $allowedExtensions)) {
        $errors[] = 'Invalid file extension';
    }
    
    // Verify it's actually an image (for image uploads)
    if (in_array($mimeType, ['image/jpeg', 'image/png', 'image/gif'])) {
        $imageInfo = getimagesize($file['tmp_name']);
        if ($imageInfo === false) {
            $errors[] = 'Invalid image file';
        }
    }
    
    return $errors;
}

// Store outside webroot
function moveUploadedFile(array $file, string $directory): string
{
    $filename = bin2hex(random_bytes(16)) . '.' . pathinfo($file['name'], PATHINFO_EXTENSION);
    $destination = $directory . '/' . $filename;
    
    if (!move_uploaded_file($file['tmp_name'], $destination)) {
        throw new Exception('Failed to move uploaded file');
    }
    
    return $filename;
}
```

## Rate Limiting

```php
class RateLimiter
{
    private PDO $pdo;
    
    public function __construct(PDO $pdo)
    {
        $this->pdo = $pdo;
    }
    
    public function attempt(string $key, int $maxAttempts, int $decaySeconds): bool
    {
        $attempts = $this->getAttempts($key) + 1;
        
        if ($attempts > $maxAttempts) {
            return false;
        }
        
        $this->increment($key, $decaySeconds);
        return true;
    }
    
    private function getAttempts(string $key): int
    {
        $stmt = $this->pdo->prepare('
            SELECT attempts FROM rate_limits 
            WHERE key = ? AND expires_at > NOW()
        ');
        $stmt->execute([$key]);
        $result = $stmt->fetch();
        
        return $result ? (int) $result['attempts'] : 0;
    }
    
    private function increment(string $key, int $decaySeconds): void
    {
        $expiresAt = date('Y-m-d H:i:s', time() + $decaySeconds);
        
        $stmt = $this->pdo->prepare('
            INSERT INTO rate_limits (key, attempts, expires_at) 
            VALUES (?, 1, ?)
            ON DUPLICATE KEY UPDATE attempts = attempts + 1
        ');
        $stmt->execute([$key, $expiresAt]);
    }
}

// Usage
$limiter = new RateLimiter($pdo);
$ip = $_SERVER['REMOTE_ADDR'];

if (!$limiter->attempt("login:{$ip}", 5, 300)) {
    http_response_code(429);
    die('Too many attempts. Try again in 5 minutes.');
}
```

## HTTP Security Headers

```php
// Add security headers
header('X-Content-Type-Options: nosniff');
header('X-Frame-Options: DENY');
header('X-XSS-Protection: 1; mode=block');
header('Strict-Transport-Security: max-age=31536000; includeSubDomains');
header('Referrer-Policy: strict-origin-when-cross-origin');
header("Content-Security-Policy: default-src 'self';");
header('Permissions-Policy: geolocation=(), microphone=(), camera=()');
```

## Secure API Design

```php
// API key authentication
function validateApiKey(string $key): ?User
{
    $stmt = $pdo->prepare('
        SELECT u.* FROM users u
        JOIN api_keys k ON k.user_id = u.id
        WHERE k.key = ? AND k.expires_at > NOW()
    ');
    $stmt->execute([hash('sha256', $key)]);
    $data = $stmt->fetch(PDO::FETCH_ASSOC);
    
    return $data ? User::fromArray($data) : null;
}

// OAuth 2.0 Bearer Token
function getBearerToken(): ?string
{
    $header = $_SERVER['HTTP_AUTHORIZATION'] ?? '';
    
    if (preg_match('/Bearer\s+(.+)/i', $header, $matches)) {
        return $matches[1];
    }
    
    return null;
}
```

## Error Handling

```php
// Production error handling
error_reporting(0);
ini_set('display_errors', '0');
ini_set('log_errors', '1');

// Custom error handler
set_error_handler(function(int $errno, string $errstr, string $errfile, int $errline): bool {
    if (!(error_reporting() & $errno)) {
        return false;
    }
    
    Log::error($errstr, [
        'errno' => $errno,
        'file' => $errfile,
        'line' => $errline
    ]);
    
    if (ini_get('display_errors')) {
        echo "Error: {$errstr}";
    }
    
    return true;
});

// Exception handler
set_exception_handler(function(Throwable $e): void {
    Log::error($e->getMessage(), [
        'exception' => get_class($e),
        'file' => $e->getFile(),
        'line' => $e->getLine(),
        'trace' => $e->getTraceAsString()
    ]);
    
    if (!headers_sent()) {
        http_response_code(500);
        header('Content-Type: application/json');
        echo json_encode(['error' => 'Internal server error']);
    }
});
```
