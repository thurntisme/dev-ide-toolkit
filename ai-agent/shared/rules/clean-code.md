# Clean Code Principles

## General Guidelines

- Write code for humans first, computers second
- Code is read more often than written
- If it's hard to explain, it's hard to maintain
- Duplication is the enemy of maintainability

## Naming

### Use Intention-Revealing Names
- Name should answer: why it exists, what it does, how it is used
- Avoid single letters except in loops
- No magic numbers or strings - use constants

### Function Names
- Use verbs: `getUser`, `calculateTotal`, `saveOrder`
- Describe the side effect: `validateInput`, `generateReport`
- Length is okay if it brings clarity

### Variables
- Use nouns: `user`, `orderItems`, `totalPrice`
- Boolean variables: `isValid`, `hasPermission`, `canEdit`

## Functions

### Single Responsibility
- Function does one thing and does it well
- Function fits on one screen (50 lines max)
- No flags as parameters - split into separate functions

### Few Arguments
- Max 3 arguments preferred
- If more, consider passing an object
- Output arguments are a code smell

### DRY (Don't Repeat Yourself)
- Extract repeated logic into functions
- Constants go in one place
- Use inheritance or composition for shared behavior

### Command Query Separation
- Either do something or answer something, not both
- `setPassword()` returns void
- `getPassword()` returns string

## Comments

### When to Use
- Explain WHY (not WHAT)
- Complex business rules
- TODO comments for future work
- Legal comments required

### Avoid
- Commented-out code
- Explaining obvious code
- Blame comments
- Writer's block comments

### Prefer
- Self-documenting code
- Well-named functions
- Clear variable names

## Error Handling

### Fail Fast
- Validate inputs early
- Check for null/undefined early
- Return early on invalid conditions

### Single Place for Errors
- Centralized error handling
- Consistent error format
- Log errors with context

### Don't Ignore Errors
- Never swallow exceptions silently
- Handle or propagate
- Use meaningful error messages

## Formatting

### Vertical Spacing
- Blank lines separate concepts
- Related code stays together
- Declaration and first use close together

### Horizontal Spacing
- Align related items
- Use consistent indentation
- Keep line length under 100

### Team Rules
- Use linter/formatter
- Follow project conventions
- Automate where possible

## Testing

### Test Behavior
- Test what, not how
- One assertion per test
- Tests are documentation

### Naming Tests
- `describe[Unit]_[ExpectedBehavior]`
- Given-When-Then format
- Clear failure messages

### Organization
- Tests mirror source structure
- AAA pattern: Arrange, Act, Assert
- No logic in tests

## Code Review

### Look For
- Logic errors
- Missing edge cases
- Security issues
- Performance problems

### Questions to Ask
- Could I understand this in 30 seconds?
- Is there a simpler solution?
- What happens if...?
- Is this tested?

## Refactoring

### When to Refactor
- Before adding new feature
- When copying code
- When code is hard to understand

### Steps
1. Make changes in small steps
2. Run tests after each change
3. Commit working state
4. Don't add features while refactoring

### Boy Scout Rule
- Leave code better than found
- Fix naming when seen
- Clean as you go