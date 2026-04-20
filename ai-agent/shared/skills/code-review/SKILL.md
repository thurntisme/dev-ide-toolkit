# Code Review Skill

Master skill for comprehensive code review operations.

## Overview

This skill handles code review operations with focus on style, error handling, security, and performance checks.

## Sub-skills

| Skill File | Trigger | Purpose |
|------------|---------|---------|
| `review-staged.md` | `/code-review` | Review staged changes |
| `review-file.md` | `/code-review <path>` | Review specific file/directory |
| `review-glob.md` | `/code-review <glob>` | Review files matching pattern |

## Common Workflow

1. **Analyze Request** - Parse command argument to determine review scope
2. **Context Retrieval** - Load project context and domain knowledge
3. **Gather Files** - Identify files to review based on priority
4. **Analyze** - Review against four dimensions
5. **Generate Report** - Organize findings by severity
6. **Save Report** - Create report file in `dit-tmp/review-report/`
7. **Summary** - Display summary and report path

## Review Dimensions

| Dimension | Description | Rules Reference |
|-----------|-------------|-----------------|
| **Style** | Naming conventions, formatting, structure | `../rules/code-conventions.md` |
| **Error Handling** | Exceptions, edge cases, null checks | `../rules/error-handling.md` |
| **Security** | Validation, sanitization, secrets | `../rules/security.md` |
| **Performance** | Queries, operations, memory | `../rules/clean-code.md` |

## Severity Levels

| Level | Description |
|-------|-------------|
| **Critical** | Security vulnerability, data loss risk, potential bug |
| **Warning** | Code smell, anti-pattern, potential issue |
| **Suggestion** | Improvement opportunity, best practice deviation |

## Output

Every review generates two outputs:

1. **Console Output:** Summary and key findings
2. **Report File:** `dit-tmp/review-report/review-{timestamp}.md`

Report file content:
```
# Code Review Report - {timestamp}

## Summary
- Files Reviewed: {count}
- Critical: {count}
- Warning: {count}
- Suggestion: {count}

## Detailed Findings
### {filename}
- [Line X] {issue} ({severity}): {suggestion}
```

## Constraints

- Be constructive, not critical
- Reference exact lines and provide examples
- Follow project conventions from `../rules/`
- Skip binary and generated files