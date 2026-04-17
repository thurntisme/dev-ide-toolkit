---
description: "Slash command: /test - Generate and run tests"
---

# /test Workflow

Trigger: User types `/test` or asks to write tests

## Usage

```
/test                 # Run all tests
/test "auth module"   # Run specific test file
/test --coverage     # Run with coverage
```

## Step 1: Identify files to test

- Ask user which files need tests
- Check for existing test patterns
- Review code to be tested

## Step 2: Analyze existing patterns

- Check project test structure
- Note test framework used (Jest, pytest, PHPUnit, etc.)
- Review existing test files for style

## Step 3: Generate test file

- Create test file in correct location
- Use appropriate naming convention:
  - `*.test.ts` / `*.spec.ts` (JavaScript)
  - `test_*.py` (Python)
  - `*Test.php` (PHP)

## Step 4: Write test cases

### Unit Tests
- Test one function/component at a time
- Use describe/it blocks
- Mock external dependencies
- Cover happy path and edge cases

### Integration Tests
- Test multiple modules together
- Use real DB/services when appropriate
- Clean up after tests

### E2E Tests
- Test complete user flows
- Use realistic data
- Handle async operations

## Step 5: Run tests

```bash
# JavaScript/TypeScript
npm test

# Python
pytest

# PHP
./vendor/bin/phpunit
```

## Step 6: Report coverage

- Show test results
- Report coverage percentage
- Note any failing tests

## Test Structure Example

```typescript
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

## Related

- See: `../commands/test.md` - Quick command reference
- See: `../rules/testing.md` - Testing requirements
- See: `debug.md` - Debug failing tests
