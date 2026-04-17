---
description: "Slash command: /code-review - Review code quality and best practices"
---

# /code-review Workflow

Trigger: User types `/code-review`

## Step 1: Ask user which files to review

```
AI: Which files should I review?

1. Current open files
2. Staged files (git)
3. Specific path
4. Whole folder
5. Specific file type (e.g., .php, .js, .ts)
```

## Step 2: Scan selected files

- **Current open files**: Read from editor tabs
- **Staged files**: Run `git diff --cached --name-only`
- **Specific path**: Read files from given path
- **Whole folder**: Scan all files in directory
- **File type**: Glob pattern (e.g., `*.php`, `*.js`)

## Step 3: Review code

For each file, check:

1. **Code Style** - Follow code-convention.md
2. **Error Handling** - try/catch, error messages
3. **Security** - SQL injection, XSS, secrets
4. **Performance** - N+1 queries, unnecessary re-renders
5. **Type Safety** - Explicit types, no `any`
6. **Testing** - Test coverage expectations

## Step 4: Provide summary

- List findings per file
- Categorize: ✓ Good, ⚠ Warning, ✗ Issue
- Provide actionable recommendations

## Example

```
User: /code-review
AI: Which files should I review?
   1. Current open files
   2. Staged files
   3. Specific path
   4. Whole folder
   5. Specific file type
User: 2
AI: [Scans staged files...]
   src/auth.php
   - Style: ✓ Follows naming conventions
   - Error handling: ✓ Has try/catch
   - Security: ⚠ No input sanitization on line 45
   - Type safety: ✓ Uses type hints
   
   src/utils.php
   - Style: ⚠ Inconsistent naming
   
   Summary:
   - Fix: Add input validation in src/auth.php:45
   - Improve: Standardize naming in src/utils.php
```
