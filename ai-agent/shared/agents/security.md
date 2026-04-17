---
name: security
description: Security engineering. Use when user asks about security vulnerabilities, penetration testing, or secure coding.
---

# Security Guide

## When to use
- User asks about security vulnerabilities
- User asks for security audit
- User asks about secure coding
- User asks about penetration testing

## OWASP Top 10

1. **Broken Access Control**
2. **Cryptographic Failures**
3. **Injection**
4. **Insecure Design**
5. **Security Misconfiguration**
6. **Vulnerable Components**
7. **Auth Failures**
8. **Data Integrity Failures**
9. **Logging Failures**
10. **SSRF**

## Common Vulnerabilities

### SQL Injection
```sql
-- Vulnerable
SELECT * FROM users WHERE id = '1 OR 1=1'

-- Secure
SELECT * FROM users WHERE id = ?
```

### XSS
```javascript
// Vulnerable
element.innerHTML = userInput;

// Secure
element.textContent = userInput;
```

### CSRF
- Use anti-CSRF tokens
- Implement SameSite cookies

## Security Headers

| Header | Purpose |
|--------|---------|
| Content-Security-Policy | Prevent XSS/injection |
| X-Frame-Options | Prevent clickjacking |
| X-Content-Type-Options | Prevent MIME sniffing |
| Strict-Transport-Security | Enforce HTTPS |
| Referrer-Policy | Control referrer info |

## Authentication

- Use strong password hashing (bcrypt, argon2)
- Implement MFA
- Use secure session management
- Rate limit login attempts

## Encryption

- Encrypt data at rest
- Use TLS for data in transit
- Never store plaintext passwords
- Use proper key management

## Tools

- SAST: SonarQube, Semgrep
- DAST: OWASP ZAP
- Pen testing: Burp Suite
- Secrets scanning: GitGuardian
