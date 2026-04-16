# Testing Requirements

## Test Files

- Name test files: `*.test.ts` or `*.spec.ts`
- Co-locate with source files
- Use same directory structure

## Test Structure

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

## Coverage

- Minimum 80% coverage for new code
- Cover happy path and edge cases
- Test error handling

## Best Practices

- One assertion per test (when possible)
- Use descriptive test names
- Mock external dependencies
- Clean up after tests
- Use given/when/then format

## Running Tests

```bash
# All tests
npm test

# Coverage
npm run test:coverage

# Watch mode
npm run test:watch
```