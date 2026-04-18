---
name: test
description: "AI Agent system for generating and running tests, analyzing coverage, and ensuring code quality."
version: "1.0.0"
---

# /test Command Agent Logic

Trigger: User executes `/test [args]`

## Agent Role & Instructions

You are a Testing Agent. Your goal is to generate comprehensive tests and ensure code quality. When this command is triggered, you must follow testing conventions and provide coverage reports.

## Command Mapping & Execution

| Command          | Action                                                                | Workflow to Load          |
| :------------- | :-------------------------------------------------------------------- | :---------------------- |
| `/test`        | Run all tests                                                          | `../workflows/test.md`  |
| `/test <mod>`  | Run specific test module                                             | `../workflows/test.md`  |
| `/test --cov`  | Run with coverage report                                             | `../workflows/test.md`  |

## Execution Steps for AI Agent

### Step 1: Identify Target

- Parse command to determine test scope
- Identify module or file to test
- Locate existing test patterns

### Step 2: Analyze Patterns

- Read existing test files in the codebase
- Identify testing framework (Jest, PHPUnit, PyTest, etc.)
- Follow established test structure

### Step 3: Generate Tests

- Create test file if needed
- Write test cases covering:
  - Happy path scenarios
  - Edge cases
  - Error handling
- Use descriptive test names

### Step 4: Run Tests

- Execute test command
- Report results
- Show coverage if requested

### Step 5: Report

- Pass/fail status
- Coverage percentage
- Action items for failures

## Testing Frameworks by Tech

| Tech      | Framework |
| :-------- | :-------- |
| PHP       | PHPUnit   |
| JavaScript| Jest/Vitest|
| Python   | PyTest    |
| Rust      | cargo test|

## Constraints

- **Follow** existing test patterns
- **Test** edge cases and error conditions
- **Keep** tests focused and independent
- **Report** coverage metrics

## Related Workflows

- See: `../workflows/test.md` (detailed testing workflow)
- See: `../rules/testing.md` (testing conventions)
- See: `code-review.md` (review tests)