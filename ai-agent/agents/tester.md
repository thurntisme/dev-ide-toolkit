---
name: tester
description: Software testing and quality assurance. Use when user asks about testing, QA, or bug reporting.
---

# Testing Guide

## When to use
- User asks about testing strategies
- User asks to write tests
- User asks about bug reporting
- User asks about test automation

## Testing Types

| Type | Description |
|------|-------------|
| Unit | Test individual functions/methods |
| Integration | Test component interactions |
| E2E | Test complete user flows |
| Performance | Test load and speed |
| Security | Test for vulnerabilities |

## Test Pyramid

```
       /\
      /  \    E2E (few)
     /----\
    /      \   Integration (some)
   /--------\
  /          \  Unit (many)
```

## Unit Testing

### JavaScript/TypeScript
```javascript
import { sum } from './math';

test('adds two numbers', () => {
  expect(sum(2, 3)).toBe(5);
});
```

### Python
```python
def test_sum():
    assert sum(2, 3) == 5
```

### PHP
```php
function testSum() {
    $this->assertEquals(5, sum(2, 3));
}
```

## Integration Testing

```javascript
test('user can register', async () => {
  const response = await request(app)
    .post('/api/register')
    .send({ email: 'test@example.com' });
  
  expect(response.status).toBe(201);
  expect(response.body.email).toBe('test@example.com');
});
```

## E2E Testing (Playwright)

```javascript
import { test, expect } from '@playwright/test';

test('login flow', async ({ page }) => {
  await page.goto('/login');
  await page.fill('[name="email"]', 'user@example.com');
  await page.fill('[name="password"]', 'password');
  await page.click('[type="submit"]');
  
  await expect(page).toHaveURL('/dashboard');
});
```

## Test Coverage

- Aim for 80%+ coverage
- Focus on critical paths
- Test edge cases
- Don't test trivial code

## Bug Reporting

| Field | Description |
|-------|-------------|
| Title | Clear summary |
| Steps | Reproduce the issue |
| Expected | What should happen |
| Actual | What actually happened |
| Environment | OS, browser, version |
| Screenshots | Visual evidence |

## Automation

- Run tests in CI/CD pipeline
- Automate regression tests
- Use test fixtures
- Mock external services

## Tools

- Unit: Jest, pytest, PHPUnit
- E2E: Playwright, Cypress
- API: Postman, REST Assured
- Coverage: Istanbul, coverage.py
