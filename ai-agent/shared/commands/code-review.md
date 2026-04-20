---
name: code-review
description: "AI Agent system for performing code reviews with style, error handling, security, and performance checks."
version: "1.2.0"
---

# /code-review Command Execution Logic

## 1. Trigger & Context Initialization

- **Command:** `/code-review [arg]`
- **Initial Action:** Analyze `[arg]` to determine review scope
- **Dynamic Routing:** Load the appropriate review skill based on the provided argument

## 2. Mandatory Knowledge Retrieval

Before performing any review, the Agent **MUST** synchronize with the following local resources:

- **Project Context:** Consult `../../docs/` to understand project structure
- **Knowledge Standards:** Consult `../knowledge/` for domain-specific context

## 3. Policy & Constraint Enforcement

The Agent must strictly adhere to the rules defined in the `../rules/` directory:

- **Coding Convention:** Follow `../rules/code-conventions.md`
- **Naming Convention:** Follow `../rules/naming-convention.md`
- **Clean Code:** Follow `../rules/clean-code.md`
- **Security:** Follow `../rules/security.md`

For API-related code reviews:
- **API Convention:** Follow `../rules/api-conventions.md`
- **Error Handling:** Follow `../rules/error-handling.md`

## 4. Execution Workflow (Full Lifecycle)

Execute the review task by following the step-by-step skills in `../skills/code-review/`

## 5. Safety Guardrails

- **Read-only Operation:** Code review is a read-only operation that does not modify files
- **Git Safety:** Check git status to identify staged/modified files for review priority
- **Large Files:** Handle large files gracefully - limit review to critical sections
- **Binary Files:** Skip binary files and generated code (node_modules, vendor, etc.)

## Command Mapping & Execution

| Command | Action | Skill to Load |
| :---------------------- | :--------------------------------------------------------------------- | :------------------------------- |
| `/code-review` | Review staged changes or prompt for selection | `../skills/code-review/review-staged.md` |
| `/code-review <path>` | Review specific file or directory | `../skills/code-review/review-file.md` |
| `/code-review <glob>` | Review files matching pattern | `../skills/code-review/review-glob.md` |

## File Selection Priority

1. **Staged files** - `git diff --cached` output
2. **Specific path** - User-provided path
3. **Glob pattern** - User-provided pattern (e.g., "*.php")
4. **Current open files** - Files visible in the editor

## Analysis Dimensions

Each review checks four dimensions:

| Dimension | Description | Rules Reference |
|-----------|-------------|-----------------|
| **Style** | Naming conventions, formatting, code structure | `../rules/code-conventions.md` |
| **Error Handling** | Exception handling, edge cases, null checks | `../rules/error-handling.md` |
| **Security** | Input validation, sanitization, secrets exposure | `../rules/security.md` |
| **Performance** | N+1 queries, unnecessary operations, memory usage | `../rules/clean-code.md` |

## Report Format

Findings organized by severity:

| Severity | Description |
|----------|-------------|
| **Critical** | Security vulnerability, data loss risk, potential bug |
| **Warning** | Code smell, anti-pattern, potential issue |
| **Suggestion** | Improvement opportunity, best practice deviation |

Each finding includes:
- File path and line number
- Code snippet
- Issue description
- Actionable fix suggestion

## Execution Steps for AI Agent

### Step 1: Context Retrieval

- Parse the command argument to determine review scope
- Determine file(s) to review based on priority
- Identify the technical stack for context

### Step 2: Gather Files

- Use git commands to identify staged/modified files when applicable
- Gather files matching path or glob pattern
- Filter out binary and generated files

### Step 3: Analysis

- Review each file against the four dimensions
- Reference project rules and conventions
- Identify issues and categorize by severity

### Step 4: Report Generation

- Organize findings by severity
- Provide specific line numbers and code snippets
- Include actionable fix suggestions
- Summarize with priority action items

## Constraints

- **Be constructive** - Focus on improvement, not criticism
- **Be specific** - Reference exact lines and provide examples
- **Be thorough** - Do not skip security and performance checks
- **Follow standards** - Reference `../rules/` for all conventions

## Output Structure Standards

Every `/code-review` response must include:

1. **Files Reviewed:** List of files that were analyzed
2. **Summary Statistics:** Issues by severity (Critical, Warning, Suggestion)
3. **Detailed Findings:** Organized by file with line numbers and suggestions
4. **Priority Actions:** Top issues to address first

## Related Skills

- See: `../skills/code-review/SKILL.md` - Master code review skill
- See: `../skills/code-review/review-staged.md` - Staged changes review
- See: `../skills/code-review/review-file.md` - Specific file review
- See: `../skills/code-review/review-glob.md` - Pattern-based review
- See: `../rules/` - Project conventions and rules