---
description: "Slash command: /code-gen - Generate code following dev-ide-toolkit conventions"
---

# /code-gen Workflow

Trigger: User types `/code-gen "implement feature..."`

## Usage

```
/code-gen "implement feature"              # Normal
/code-gen "implement feature --strict"      # With test verification
/code-gen "add feature --dry-run"           # Preview only
/code-gen "add feature --interactive"       # Step-by-step confirmation
```

## Flags

| Flag | Description |
|------|-------------|
| `--strict` | Create and verify test cases |
| `--dry-run` | Preview changes without applying |
| `--interactive` | Confirm each step before executing |

## Execution Steps

### Step 1: Parse command flags
- Check all flags: `--strict`, `--dry-run`, `--interactive`
- Set corresponding mode flags

### Step 2: Ask user choose coder
- Ask: "Which tech stack?" (PHP, Python, React, Laravel, etc.)
- If no coder needed, use general coding conventions

### Step 3: Analyze feature
- Understand requirements from user input
- Identify dependencies and constraints
- Check existing code patterns in project

### Step 4: Create plan
- Break down feature into step-by-step tasks
- Create `dit-tmp/plans/PLAN-{timestamp}.md` with numbered steps
- Present plan to user for confirmation

### Step 5: Handle --dry-run
- If --dry-run: display generated code preview, skip execution
- Report "Changes previewed - not applied" and exit

### Step 6: Execute item from plan
- IF --interactive: confirm before each task
- Implement each task sequentially
- Add proper imports/exports
- Include error handling
- Run lint/typecheck after each task

### Step 7: Verify code
- Run lint/typecheck
- Verify against plan

### Step 8: IF --strict flag
- Create test cases in `dit-tmp/testing/TEST-{timestamp}.md`
- Follow project test patterns
- Run tests to verify passing
- Fix any failing tests
- Report test coverage

## Output Files

```
dit-tmp/
├── plans/
│   └── PLAN-{timestamp}.md    # Implementation plan
└── testing/
    └── TEST-{timestamp}.md   # Test cases (--strict only)
```

## Conventions

### File Structure
- Use TypeScript when possible
- Follow existing directory structure
- Name files with kebab-case or PascalCase

### Imports
- Use absolute imports for internal modules
- Group imports: external → internal → types

### Exports
- Use named exports preferred
- Export types alongside implementations

## Related Workflows

- plan.md - Create implementation plan
- implement.md - Generate code from plan
- test.md - Generate and run tests
- code-review.md - Code review
