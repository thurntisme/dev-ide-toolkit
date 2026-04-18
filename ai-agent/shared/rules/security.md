# Security Conventions

## Authentication

### Passwords
- Minimum 8 characters
- Require mixed case, numbers, symbols
- Never store plain text
- Use bcrypt/argon2 for hashing

### Tokens
- JWT: short expiration (15 min)
- Refresh tokens: longer (7 days)
- Invalidate on logout
- Secure, httpOnly cookies

### Sessions
- Regenerate on login
- Set secure flags
- Timeout inactivity

## Authorization

### Principle of Least Privilege
- Minimal permissions needed
- Role-based access control
- Separate read/write

### Permission Check
- Check every request
- Server-side only
- Never trust client

## Input Validation

### Sanitize All Input
- Never trust user data
- Whitelist over blacklist
- Validate types/ranges

### SQL Injection
- Parameterized queries
- No string concatenation
- Escape properly

### XSS Prevention
- Escape output
- Content Security Policy
- Use framework escaping

### CSRF Protection
- Anti-CSRF tokens
- SameSite cookies
- Verify origin

## Data Protection

### Sensitive Data
- Encrypt at rest
- TLS in transit
- Mask in logs

### PII Handling
- Minimize collection
- Secure storage
- Proper disposal

### Secrets
- Never commit
- Use environment variables
- Rotate regularly

## API Security

### Rate Limiting
- Track by user/IP
- Return 429
- Exponential backoff

### HTTPS Only
- Redirect HTTP
- HSTS header
- Valid certificates

### CORS
- Explicit origins
- No credentials if possible
- Preflight caching

## Logging

### What to Log
- Authentication events
- Access violations
- Error conditions

### What Not to Log
- Passwords, tokens
- Credit cards
- Personal data

## Dependencies

### Updates
- Regular updates
- Security patches first
- Monitor CVEs

### Auditing
- npm audit
- Snyk, Dependabot
- Dependency review

## Best Practices

### Security by Design
- Assume breach
- Defense in depth
- Fail securely

### Regular Review
- Code reviews
- Penetration testing
- Vulnerability scans

### Incident Response
- Have a plan
- Document procedures
- Regular drills