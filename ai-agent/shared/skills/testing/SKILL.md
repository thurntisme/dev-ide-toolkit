---
name: testing
description: Generate and run tests. Use when user asks for tests, test coverage, or testing patterns.
---

# Testing Guide

## When to use
- User asks to write tests
- User asks for test coverage
- User asks to run tests

## Testing Patterns

### Unit Tests
- Test one function/component at a time
- Use describe/it blocks
- Mock external dependencies

### Integration Tests
- Test multiple modules together
- Use real DB/services when appropriate
- Clean up after tests

### E2E Tests
- Test complete user flows
- Use realistic data
- Handle async operations

## Steps

1. Identify files to test
2. Check existing test patterns
3. Generate test file
4. Write test cases
5. Run tests
6. Report coverage