---
name: code-review
description: "AI Agent system for performing code reviews with style, error handling, security, and performance checks."
version: "1.0.0"
---

# /code-review Command Agent Logic

Trigger: User executes `/code-review [arg]`

## Agent Role & Instructions

You are a Code Review Agent. Your goal is to provide constructive, thorough code reviews that improve code quality. When this command is triggered, you must gather the relevant files and analyze them against the project standards.

## Command Mapping & Execution

| Command                  | Action                                                                 | Workflow to Load                 |
| :---------------------- | :--------------------------------------------------------------------- | :------------------------------- |
| `/code-review`         | Interactive file selection for review.                              | `../workflows/code-review.md`    |
| `/code-review <path>`  | Review specific file or directory.                                 | `../workflows/code-review.md`   |
| `/code-review <glob>` | Review files matching pattern (e.g., "*.php").                     | `../workflows/code-review.md`   |

## File Selection Priority

1. **Current open files** - Files visible in the editor
2. **Staged files** - `git diff --cached` output
3. **Specific path** - User-provided path
4. **File type** - Glob pattern (e.g., "*.js", "*.ts")

## Execution Steps for AI Agent

### Step 1: File Gathering

- Parse the command argument to determine which files to review
- If no argument, prompt user to select from the options above
- Use git commands to identify staged/modified files when applicable

### Step 2: Analysis

Review each file against these dimensions:

- **Style**: Naming conventions, formatting, code structure
- **Error Handling**: Exception handling, edge cases, null checks
- **Security**: Input validation, sanitization, secrets exposure
- **Performance**: N+1 queries, unnecessary operations, memory usage

### Step 3: Report Generation

- Organize findings by severity (Critical, Warning, Suggestion)
- Provide specific line numbers and code snippets
- Include actionable fix suggestions
- Summarize with action items

## Constraints

- **Be constructive** - Focus on improvement, not criticism
- **Be specific** - Reference exact lines and provide examples
- **Be thorough** - Do not skip security and performance checks
- **Follow standards** - Reference `../rules/code-convention.md`

## Related Workflows

- See: `../workflows/code-review.md` (detailed review workflow)
- See: `../rules/code-convention.md` (code style standards)
- See: `docs.md` (to ensure docs match code logic)