---
name: security
description: Security audit and best practices. Use when user asks for security review or mentions security concerns.
---

# Security Guide

## When to use
- User asks for security audit
- User asks to review security
- Handling sensitive data

## Security Checklist

### Authentication
- Verify auth flows
- Check password handling
- Check session management

### Data Protection
- No secrets in code
- Use environment variables
- Encrypt sensitive data

### Input Validation
- Validate all inputs
- Sanitize user data
- Use parameterized queries

### Dependencies
- Check for vulnerabilities
- Update dependencies
- Use locked versions

## Common Vulnerabilities

- SQL injection
- XSS attacks
- CSRF vulnerabilities
- Hardcoded secrets
- Insecure randomness

## Steps

1. Scan for hardcoded secrets
2. Check authentication flows
3. Verify input validation
4. Check dependency vulnerabilities
5. Report findings