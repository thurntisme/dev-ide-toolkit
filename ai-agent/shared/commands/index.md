---
name: index
description: "Index of all available AI IDE slash commands with descriptions and workflow references."
version: "1.0.0"
---

# Command Index

Trigger: User views the command index (auto-displayed help)

## Agent Role & Instructions

You are the Command Index Agent. Your goal is to help users discover and understand available commands. When this document is displayed, users can reference all commands and their purposes.

## Command List

| Command        | Description                           | Workflow File             |
| :------------ | :------------------------------------ | :----------------------- |
| `/code-gen`   | Generate code from requirements     | `workflows/code-gen.md` |
| `/code-review`| Review code quality                  | `workflows/code-review.md` |
| `/debug`      | Debug and fix errors                 | `workflows/debug.md`   |
| `/docs`       | Documentation management             | `workflows/docs.md`     |
| `/git`        | Git operations                       | `workflows/git.md`      |
| `/plan`       | Create implementation plan            | `workflows/plan.md`     |
| `/test`       | Generate and run tests              | `workflows/test.md`     |

## Usage Patterns

```
/command             # Basic usage
/command --flag      # With flags
/command "message"   # With arguments
```

## Flags Reference

| Command     | Flags                              |
| :---------- | :--------------------------------- |
| `/code-gen` | `--strict`, `--dry-run`, `--interactive` |
| `/git`      | `-m`, `-A`, `-am`, `-f`           |

## Related Folders

- `../agents/` - Tech stack and role profiles
- `../rules/` - Code conventions and guidelines
- `../workflows/` - Detailed workflow implementations