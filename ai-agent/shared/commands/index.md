# Slash Commands

Available commands for the AI IDE. All commands start with `/`.

## Command List

| Command | Description | Workflow File |
|---------|-------------|---------------|
| `/code-gen` | Generate code from requirements | `workflows/code-gen.md` |
| `/code-review` | Review code quality | `workflows/code-review.md` |
| `/debug` | Debug and fix errors | `workflows/debug.md` |
| `/docs` | Documentation management | `workflows/docs.md` |
| `/git` | Git operations | `workflows/git.md` |
| `/plan` | Create implementation plan | `workflows/plan.md` |
| `/test` | Generate and run tests | `workflows/test.md` |

## Usage

```
/command             # Basic usage
/command --flag      # With flags
/command "message"   # With arguments
```

## Flags Reference

| Command | Flags |
|---------|-------|
| `/code-gen` | `--strict`, `--dry-run`, `--interactive` |
| `/git` | `-m`, `-A`, `-am`, `-f` |

## Related Folders

- `agents/` - Tech stack and role profiles
- `rules/` - Code conventions and guidelines
- `workflows/` - Detailed workflow implementations
