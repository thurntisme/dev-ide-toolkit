---
description: "Slash command: /plan - Create implementation plan from requirements"
---

# /plan Workflow

Trigger: User types `/plan "implement feature..."`

## Step 1: Understand requirements

- Ask user for the task/feature to implement
- Clarify any ambiguous points
- Note constraints and dependencies

## Step 2: Analyze codebase

- Review existing structure
- Check for similar implementations
- Identify affected files

## Step 3: Break into tasks

- Split feature into logical steps
- Order tasks sequentially
- Note dependencies between tasks

## Step 4: Create PLAN.md

Save to: `dit-tmp/plans/PLAN-{timestamp}.md`

```markdown
# Plan: [Feature Name]

## Tasks

### 1. [Task Name]
- [ ] Description
- Files: file1.ts, file2.ts

### 2. [Task Name]
- [ ] Description
- Files: file3.ts
```

## Step 5: Present to user

- Show plan summary
- Ask for confirmation
- Adjust if needed

## Related

- See: `../commands/plan.md` - Quick command reference
- See: `code-gen.md` - Generate code from plan
