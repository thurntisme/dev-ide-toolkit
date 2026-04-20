# Refactor Skill

Handles code optimization without changing functionality.

## Trigger

- Command: `/code-gen "refactor X"`
- Loads: `../skills/code-gen/refactor.md`

## Workflow

### Step 1: Analyze Request
- Parse the refactoring request
- Identify the code to be refactored
- Determine the technical stack involved

### Step 2: Context Retrieval
- Load project context from `../../docs/`
- Retrieve domain knowledge from `../knowledge/`
- Apply coding conventions from `../rules/`

### Step 3: Codebase Analysis
- Locate the code to be refactored
- Analyze current implementation
- Identify code smells and improvement opportunities

### Step 4: Refactoring Plan
- Create a plan in `dit-tmp/plans/`
- List all refactoring changes
- Ensure functionality will be preserved

### Step 5: Implementation
- Apply refactoring changes
- Follow clean code principles
- Maintain consistent naming

### Step 6: Verification
- Run lint/typecheck commands
- Run tests to ensure no functionality broken
- Verify code still works as expected

## Common Refactoring Patterns

- **Extract Method:** Break large functions into smaller ones
- **Rename:** Improve variable/function names
- **Remove Duplication:** Consolidate repeated code
- **Simplify Conditionals:** Make complex logic clearer
- **Improve Error Handling:** Better exception handling
- **Optimize Performance:** Improve efficiency

## Constraints

- Do not change functionality
- Preserve API contracts
- Run tests to verify no regressions
- Do not commit unless explicitly requested
- Document significant changes

## Code Smells to Address

- Long methods
- Duplicate code
- Tight coupling
- Poor naming
- Complex conditionals
- Missing error handling
- Inconsistent formatting