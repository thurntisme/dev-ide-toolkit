---
description: "Slash command: /git - Git operations: commit, push, branch, stash, diff, log"
---

# /git Workflow

Trigger: User types `/git` or any git-related command

## Usage

```
/git cm:<message>           # Check changes and create commit(s)
/git commit "message"       # Commit with message
/git push                   # Push to remote
/git pull                   # Pull from remote
/git branch                 # List branches
/git branch feature/name    # Create new branch
/git checkout branch        # Switch branch
/git stash                  # Stash changes
/git stash pop              # Apply stashed changes
/git log                    # View commit history
/git diff                   # View changes
/git diff --staged          # View staged changes
/git status                 # Check status
```

## Execution Steps

### Step 1: Parse command
- If starts with `cm:` → execute commit workflow
- Else → show this info message

### Commit Workflow (`cm:`)

1. **Check changes**
   - Run `git status` to see staged and unstaged files
   - Run `git diff --staged` for staged changes

2. **Analyze logical groupings**
   - Group files by feature/fix/refactor type
   - Identify if multiple commits are appropriate
   - If no changes, show "No changes to commit"

3. **Create commit(s)**
   - For each group:
     - Stage relevant files: `git add <files>`
     - Generate commit message using conventional format
     - Create commit: `git commit -m "type(scope): description"`
   - If user provided message after `cm:`, use it as base

4. **Report result**
   - Show created commit(s)
   - Show remaining uncommitted changes if any

### Step 2: Check current state
- Run `git status` to see current branch and changes
- Note staged vs unstaged files

### Step 3: Execute operation

**For commit:**
- Ask for commit message if not provided
- Use conventional format: `type(scope): description`
- Stage files: `git add -A`
- Create commit

**For push:**
- Verify branch is not main/master (warn user)
- Push to remote: `git push`

**For pull:**
- Fetch latest from remote
- Pull changes: `git pull`

**For branch:**
- List branches: `git branch -a`
- Create new: `git checkout -b branch-name`
- Delete: `git branch -d branch-name`

**For checkout:**
- Switch to existing branch
- Create and switch: `git checkout -b new-branch`

**For stash:**
- Stash changes: `git stash push -m "description"`
- List stashes: `git stash list`
- Apply stash: `git stash pop`

**For log:**
- Show recent commits: `git log --oneline -10`
- Show with graph: `git log --oneline --graph -10`

**For diff:**
- Show unstaged: `git diff`
- Show staged: `git diff --staged`
- Show specific file: `git diff filename`

### Step 4: Report result
- Show command output
- Confirm success/failure
- Suggest next steps if needed

## Conventions

### Commit Message Format

```
type(scope): description

[optional body]
```

Types: `feat`, `fix`, `refactor`, `docs`, `style`, `test`, `chore`

### Branch Naming

| Type | Pattern | Example |
|------|---------|---------|
| Feature | `feature/description` | `feature/user-auth` |
| Bugfix | `fix/description` | `fix/login-error` |
| Hotfix | `hotfix/description` | `hotfix/security-patch` |

## Related

- See: `../commands/git.md` - Quick command reference
- See: `../rules/git-workflow.md` - Git conventions
- See: `code-review.md` - Review changes before commit
- See: `test.md` - Run tests before commit
