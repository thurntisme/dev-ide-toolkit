# Confirm Implement Skill

Handles interactive execution with step-by-step confirmation.

## Trigger

- Command: `/code-gen "implement X" --interactive`
- Loads: `../skills/code-gen/confirm-implement.md`

## Workflow

### Step 1: Analyze Request
- Parse user prompt to identify technical stack
- Determine appropriate coder persona
- Note: This mode requires user confirmation at each step

### Step 2: Context Retrieval
- Load project context from `../../docs/`
- Retrieve domain knowledge from `../knowledge/`
- Apply coding conventions from `../rules/`

### Step 3: Codebase Analysis
- Identify relevant files and patterns
- Understand existing code structure
- Find similar implementations for reference

### Step 4: Interactive Planning
- Create implementation plan in `dit-tmp/plans/`
- Present plan to user for confirmation
- Wait for user approval before proceeding

### Step 5: Step-by-Step Execution
For each step:
1. Present the action to be taken
2. Wait for user confirmation
3. Execute only after approval
4. Show results after completion
5. Proceed to next step upon approval

### Step 6: Verification
- Run lint/typecheck commands after each major step
- Confirm with user before continuing
- Allow user to abort at any point

## Constraints

- Must confirm each step before execution
- Allow user to skip or modify steps
- Provide clear feedback after each action
- Support aborting the process at any time

## Confirmation Points

1. **Plan Review:** Confirm implementation plan
2. **File Changes:** Confirm each file creation/modification
3. **Dependencies:** Confirm any package additions
4. **Final Review:** Confirm before running lint/typecheck