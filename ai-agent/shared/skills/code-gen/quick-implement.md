# Quick Implement Skill

Handles autonomous code generation and implementation without additional flags.

## Trigger

- Command: `/code-gen "implement X"`
- Loads: `../skills/code-gen/quick-implement.md`

## Workflow

### Step 1: Analyze Request
- Parse user prompt to identify technical stack
- Determine appropriate coder persona (coder-reactjs, coder-php, etc.)
- Consult `../agents/coder.md` for tech-specific guidance

### Step 2: Context Retrieval
- Load project context from `../../docs/`
- Retrieve domain knowledge from `../knowledge/`
- Apply coding conventions from `../rules/`

### Step 3: Codebase Analysis
- Identify relevant files and patterns
- Understand existing code structure
- Find similar implementations for reference

### Step 4: Implementation
- Generate code following project conventions
- Create necessary files in appropriate locations
- Apply naming and clean code rules

### Step 5: Verification
- Run lint/typecheck commands
- Verify code follows security guidelines
- Ensure no secrets or keys are exposed

## Constraints

- Do not commit changes unless explicitly requested
- Warn user about uncommitted git changes
- Suggest feature branch for significant changes
- Stop on destructive actions until confirmed

## Output Format

Before execution, present:
1. **Impacted Files:** List of files to create/modify/delete
2. **New Dependencies:** Any required packages
3. **Environment Context:** Server-side, client-side, etc.
4. **Breaking Changes:** Any schema/API modifications