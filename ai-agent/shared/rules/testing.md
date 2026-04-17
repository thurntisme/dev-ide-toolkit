# Testing Requirements (Multi-Language)

## Test Files

| Language | Test File Pattern | Location |
|----------|-------------------|----------|
| TypeScript/JavaScript | `*.test.ts`, `*.spec.ts` | Co-located or `__tests__/` |
| Python | `test_*.py`, `*_test.py` | Same directory or `tests/` |
| PHP | `*Test.php` | `tests/` or `Test/` |
| Rust | `*_test.rs` | Same file or `tests/` |
| Go | `*_test.go` | Same package |

## Test Structure

```
describe('ModuleName', () => {
  beforeEach(() => {
    // Setup
  });

  it('should do something', () => {
    // Test
  });

  afterEach(() => {
    // Cleanup
  });
});
```

## Coverage

- Minimum 80% coverage for new code
- Cover happy path and edge cases
- Test error handling
- Test boundary conditions

## Best Practices

- One assertion per test (when possible)
- Use descriptive test names
- Mock external dependencies
- Clean up after tests
- Use given/when/then format
- Test units in isolation
- Keep tests deterministic

## Running Tests

```bash
# JavaScript/TypeScript
npm test
npm run test:coverage

# Python
pytest
pytest --cov

# PHP
./vendor/bin/phpunit

# Rust
cargo test
cargo test --coverage

# Go
go test -v ./...
```

## Test Types

| Type | Description |
|------|-------------|
| Unit | Test individual functions/methods |
| Integration | Test component interactions |
| E2E | Test complete user flows |
| Contract | Test API responses |
