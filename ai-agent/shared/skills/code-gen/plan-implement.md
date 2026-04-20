# Plan Implement Skill

Handles dry-run preview without applying changes.

## Trigger

- Command: `/code-gen "implement X" --dry-run`
- Loads: `../skills/code-gen/plan-implement.md`

## Workflow

### Step 1: Analyze Request
- Parse user prompt to identify technical stack
- Determine appropriate coder persona
- Note: This is preview mode, no changes will be applied

### Step 2: Context Retrieval
- Load project context from `../../docs/`
- Retrieve domain knowledge from `../knowledge/`
- Apply coding conventions from `../rules/`

### Step 3: Codebase Analysis
- Identify relevant files and patterns
- Understand existing code structure
- Find similar implementations for reference

### Step 4: Generate Plan
- Create implementation plan in `dit-tmp/plans/`
- Document all files to be created/modified
- List all changes to be applied
- Do NOT apply any changes

### Step 5: Preview Output
- Present the full implementation plan
- Show all code that would be generated
- Display file paths and contents
- Do NOT execute any changes

## Constraints

- Never apply changes in dry-run mode
- Present complete preview of all changes
- Include file contents in preview
- Allow user to confirm before applying

## Output Format

Present as preview:
1. **Files to Create:** List with paths and contents
2. **Files to Modify:** Current vs proposed changes
3. **Dependencies:** Any required packages
4. **Execution Plan:** Step-by-step of what would run