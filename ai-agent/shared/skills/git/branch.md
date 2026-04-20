# Git Branch Skill

Handles analyzing current work and suggesting branch names.

## Trigger

- Command: `/git branch-rcm`
- Loads: `../skills/git/branch.md`

## Workflow

### Step 1: Analyze Current Work
- Run `git status` to see current changes
- Run `git diff` to understand what is being worked on
- Identify the nature of changes

### Step 2: Determine Branch Type
Based on analysis:

| Change Type | Branch Type | Pattern |
|------------|-------------|---------|
| New feature | feature | `feature/description` |
| Bug fix | fix | `fix/description` |
| Hotfix/security | hotfix | `hotfix/description` |
| Refactoring | refactor | `refactor/description` |
| Documentation | docs | `docs/description` |
| Release prep | release | `release/version` |

### Step 3: Generate Branch Name
- Create descriptive name based on changes
- Use kebab-case for description
- Keep it concise but meaningful
- Provide 2-3 suggestions

### Step 4: Present to User
- Show branch name suggestions
- Explain the reasoning
- Ask user to choose or confirm

### Step 5: Create Branch (after confirmation)
- Execute: `git checkout -b <branch-name>`
- Confirm new branch is created

### Step 6: Report Result
- Show created branch name
- Confirm current branch switched

## Branch Naming Conventions

| Type | Pattern | Example |
|------|---------|---------|
| Feature | `feature/description` | `feature/user-auth` |
| Bugfix | `fix/description` | `fix/login-error` |
| Hotfix | `hotfix/description` | `hotfix/security-patch` |
| Refactor | `refactor/description` | `refactor/api-cleanup` |
| Docs | `docs/description` | `docs/readme-update` |
| Release | `release/version` | `release/v1.0.0` |

## Constraints

- Analyze changes before suggesting names
- Provide clear reasoning for suggestions
- Get user confirmation before creating branch
- Follow conventional branch naming