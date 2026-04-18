# API Security Checklist

Security checklist for building secure APIs.

---

## Authentication

### JWT Token

- [ ] Token expiration set (15-30 minutes)
- [ ] Refresh token rotation implemented
- [ ] Token stored in httpOnly, secure cookies
- [ ] Algorithm set to HS256 or RS256
- [ ] Claims include: exp, iat, sub, role

```php
$payload = [
    'sub' => $user->id,
    'role' => $user->role,
    'iat' => time(),
    'exp' => time() + 3600, // 1 hour
];
$token = jwt_encode($payload, $secret_key, 'HS256');
```

---

### OAuth 2.0

- [ ] Authorization code flow for web apps
- [ ] PKCE extension for mobile apps
- [ ] State parameter for CSRF protection
- [ ] Scope limited to necessary permissions
- [ ] Token refresh handled securely

---

### Session Management

- [ ] Session regenerate on login
- [ ] Session timeout (30 minutes inactivity)
- [ ] Secure, httpOnly, SameSite cookies
- [ ] Session invalidation on logout
- [ ] Concurrent session handling option

---

## Authorization

### RBAC Implementation

- [ ] Role-based access control
- [ ] Middleware for permission check
- [ ] Default deny policy

```php
function authorize($required_role) {
    $user_role = get_current_user_role();
    $roles = ['admin' => 3, 'editor' => 2, 'user' => 1];
    return $roles[$user_role] >= $roles[$required_role];
}
```

---

### Resource Ownership

- [ ] Users can only access own resources
- [ ] Ownership verification on updates
- [ ] Admin can access all

```php
function verify_ownership($resource, $user_id) {
    return $resource->user_id === $user_id || is_admin();
}
```

---

## Input Validation

### Request Validation

- [ ] Validate required fields
- [ ] Validate data types
- [ ] Validate ranges and limits
- [ ] Sanitize all inputs

```php
function validate_input($data) {
    $rules = [
        'email' => 'required|email',
        'age' => 'required|integer|min:18|max:150',
        'name' => 'required|string|max:255',
    ];
    return validate($data, $rules);
}
```

---

### SQL Injection Prevention

- [ ] Use parameterized queries
- [ ] Never concatenate user input to SQL
- [ ] Use ORM when available

```php
// Good
$stmt = $pdo->prepare("SELECT * FROM users WHERE id = ?");
$stmt->execute([$user_id]);

// Bad
$pdo->query("SELECT * FROM users WHERE id = $user_id");
```

---

### XSS Prevention

- [ ] Escape output
- [ ] Content Security Policy header
- [ ] Input sanitization

```php
function escape_output($string) {
    return htmlspecialchars($string, ENT_QUOTES, 'UTF-8');
}
```

---

## Security Headers

### Required Headers

- [ ] Content-Security-Policy
- [ ] X-Content-Type-Options: nosniff
- [ ] X-Frame-Options: DENY
- [ ] X-XSS-Protection: 1; mode=block
- [ ] Strict-Transport-Security
- [ ] Referrer-Policy: strict-origin-when-cross-origin

```php
header('Strict-Transport-Security: max-age=31536000; includeSubDomains');
header('X-Content-Type-Options: nosniff');
header('X-Frame-Options: DENY');
header('X-XSS-Protection: 1; mode=block');
header('Referrer-Policy: strict-origin-when-cross-origin');
```

---

## Rate Limiting

### Implementation

- [ ] Rate limit by user ID or IP
- [ ] Return 429 on limit exceeded
- [ ] Include rate limit headers
- [ ] Exponential backoff

```php
function check_rate_limit($key, $limit = 60, $window = 60) {
    $current = get_rate_limit($key);
    if ($current >= $limit) {
        return response(['error' => 'Too many requests'], 429);
    }
    increment_rate_limit($key, $window);
    header("X-RateLimit-Limit: $limit");
    header("X-RateLimit-Remaining: " . ($limit - $current - 1));
}
```

---

## Data Protection

### Sensitive Data

- [ ] Passwords hashed (bcrypt/argon2)
- [ ] TLS in transit
- [ ] Encrypt at rest for sensitive data
- [ ] Mask in logs

---

### PII Handling

- [ ] Minimize PII collection
- [ ] GDPR compliance
- [ ] Data retention policy
- [ ] Right to deletion

---

## Error Handling

### Security Errors

- [ ] Generic error messages to users
- [ ] Detailed errors in logs only
- [ ] No stack traces in production
- [ ] Proper HTTP status codes

```php
// Good
return response(['error' => 'Invalid credentials'], 401);

// Bad
return response(['error' => 'SQL: Table not found - line 45'], 500);
```

---

## API-Specific

### CORS Configuration

- [ ] Explicit allowed origins
- [ ] Limit methods and headers
- [ ] credentials: true only with trusted origins
- [ ] Preflight response caching

```php
header('Access-Control-Allow-Origin: https://trusted.com');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');
header('Access-Control-Max-Age: 86400');
```

---

### File Upload Security

- [ ] File type validation (magic bytes)
- [ ] File size limit
- [ ] Rename uploaded files
- [ ] Store outside web root
- [ ] Execute permissions denied

---

## Monitoring

### Security Logging

- [ ] Log authentication events
- [ ] Log authorization failures
- [ ] Log suspicious activity
- [ ] Alert on multiple failures

---

### Incident Response

- [ ] Have response plan
- [ ] Documented procedures
- [ ] Regular drills