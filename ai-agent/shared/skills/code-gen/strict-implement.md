# Strict Implement Skill

Handles implementation with full test verification.

## Trigger

- Command: `/code-gen "implement X" --strict`
- Loads: `../skills/code-gen/strict-implement.md`

## Workflow

### Step 1: Analyze Request
- Parse user prompt to identify technical stack
- Determine appropriate coder persona
- Note: This mode requires test creation

### Step 2: Context Retrieval
- Load project context from `../../docs/`
- Retrieve domain knowledge from `../knowledge/`
- Apply all coding conventions from `../rules/`

### Step 3: Codebase Analysis
- Identify relevant files and patterns
- Find existing test patterns for reference
- Review test directory structure

### Step 4: Implementation
- Generate code following project conventions
- Create necessary files in appropriate locations

### Step 5: Test Creation (Strict Mode)
- Create test files in `dit-tmp/testing/`
- Follow testing conventions from `../rules/testing.md`
- Write unit tests, integration tests as appropriate

### Step 6: Verification
- Run lint/typecheck commands
- Execute tests to verify implementation
- Ensure all tests pass

## Constraints

- Must create tests for new functionality
- All tests must pass before completion
- Do not commit changes unless explicitly requested
- Follow test naming conventions

## Output Format

Before execution, present:
1. **Impacted Files:** List of files to create/modify/delete
2. **New Dependencies:** Any required packages
3. **Test Files:** Tests to be created in `dit-tmp/testing/`
4. **Breaking Changes:** Any schema/API modifications