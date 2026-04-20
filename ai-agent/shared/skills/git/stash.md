# Git Stash Skill

Handles analyzing changes and creating descriptive stashes.

## Trigger

- Command: `/git stash`
- Loads: `../skills/git/stash.md`

## Workflow

### Step 1: Check for Changes
- Run `git status` to verify there are changes to stash
- Identify staged and unstaged changes
- Review what will be stashed

### Step 2: Analyze Changes
- Determine the context of changes
- Identify what work is in progress
- Group related changes together

### Step 3: Generate Stash Message
- Create descriptive message based on changes:
  - What functionality is being worked on
  - Why changes are being stashed
  - Current progress

### Step 4: Create Stash
- Execute: `git stash save "description"`
- Or with untracked: `git stash save -u "description"`

### Step 5: Report Result
- Show stash index
- Confirm changes stashed
- Display stash message

## Additional Commands

### List Stashes
- `/git stash list` - Show all stashes

### Apply Stash
- `/git stash pop` - Apply and remove from stash list

## Constraints

- Verify changes exist before stashing
- Always provide descriptive message
- Inform user about stash index for later recovery