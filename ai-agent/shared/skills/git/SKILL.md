# Git Skill

Master skill for Git operations: commit message generation, stash creation, and branch name analysis.

## Overview

This skill handles three main Git operations focused on analyzing changes and generating appropriate messages/names.

## Sub-skills

| Skill File | Trigger | Purpose |
|------------|---------|---------|
| `commit.md` | `/git cm` | Analyze changes, generate commit message |
| `stash.md` | `/git stash` | Analyze changes, create descriptive stash |
| `branch.md` | `/git branch-rcm` | Analyze work, suggest branch name |

## Common Workflow

All operations follow this general pattern:

1. **Analyze** - Run git status/diff to understand current state
2. **Generate** - Create appropriate message/name based on changes
3. **Present** - Show results to user for confirmation
4. **Execute** - Perform action only after user approval
5. **Report** - Show final result

## Supported Commands

| Command | Description |
|---------|-------------|
| `/git cm` | Analyze changes and generate commit message |
| `/git stash` | Analyze changes and create stash with message |
| `/git branch-rcm` | Analyze work and suggest branch name |

## Conventions

### Commit Message Format

```
type(scope): description
```

Types: feat, fix, refactor, docs, style, test, chore

### Branch Naming

| Type | Pattern | Example |
|------|---------|---------|
| Feature | `feature/description` | `feature/user-auth` |
| Bugfix | `fix/description` | `fix/login-error` |
| Hotfix | `hotfix/description` | `hotfix/security-patch` |
| Refactor | `refactor/description` | `refactor/api-cleanup` |
| Docs | `docs/description` | `docs/readme-update` |
| Release | `release/version` | `release/v1.0.0` |

## Safety Rules

- **Always** get user confirmation before executing
- **Verify** changes exist before generating messages
- **Never** commit secrets or keys
- **Use** conventional formats for messages and names