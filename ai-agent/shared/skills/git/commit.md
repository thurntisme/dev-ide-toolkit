# Git Commit Skill

Handles analyzing changes and generating commit messages.

## Trigger

- Command: `/git cm`
- Loads: `../skills/git/commit.md`

## Workflow

### Step 1: Analyze Changes
- Run `git status` to see staged and unstaged files
- Run `git diff` to view actual changes
- Group changes by type (feat, fix, refactor, docs, style, test, chore)

### Step 2: Generate Commit Message
- Analyze the nature of changes
- Generate message in conventional format:
  ```
  type(scope): description
  ```
- Types: feat, fix, refactor, docs, style, test, chore
- Provide optional body if needed

### Step 3: Present to User
- Show generated commit message
- Explain the reasoning behind type selection
- Ask for user confirmation

### Step 4: Create Commit (after confirmation)
- Stage relevant files: `git add <files>`
- Execute: `git commit -m "type: description"`

### Step 5: Report Result
- Display created commit with hash
- Show any remaining uncommitted changes

## Constraints

- Verify changes exist before generating
- Get user confirmation before committing
- Use conventional commit message format
- Never commit secrets or keys