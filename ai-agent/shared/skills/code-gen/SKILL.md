# Code Generation Skill

Master skill for autonomous code generation and implementation tasks.

## Overview

This skill handles various code generation workflows including implementation, testing, debugging, and refactoring.

## Sub-skills

| Skill File | Trigger | Purpose |
|------------|---------|---------|
| `quick-implement.md` | `/code-gen "implement X"` | Autonomous implementation |
| `strict-implement.md` | `/code-gen "implement X" --strict` | Implementation with test verification |
| `plan-implement.md` | `/code-gen "implement X" --dry-run` | Preview without execution |
| `confirm-implement.md` | `/code-gen "implement X" --interactive` | Step-by-step with confirmation |
| `debug-fix.md` | `/code-gen "fix [error]"` | Error analysis and bug fixing |
| `refactor.md` | `/code-gen "refactor X"` | Code optimization |

## Common Workflow

All sub-skills follow this general pattern:

1. **Analyze Request** - Parse user prompt, determine tech stack
2. **Context Retrieval** - Load project context, knowledge, rules
3. **Codebase Analysis** - Find relevant files, understand patterns
4. **Implementation** - Generate or modify code
5. **Verification** - Run lint/typecheck, verify correctness

## Conventions

All code generation follows conventions from:
- `../rules/code-conventions.md`
- `../rules/naming-convention.md`
- `../rules/clean-code.md`
- `../rules/security.md`

For API-related work:
- `../rules/api-conventions.md`
- `../rules/error-handling.md`

## Safety

- Warn about uncommitted git changes
- Suggest feature branches for significant changes
- Stop on destructive actions until confirmed
- Never expose secrets or keys in generated code

## Output Standards

All responses must include:
1. **Impacted Files** - Files to create/modify/delete
2. **New Dependencies** - Required packages
3. **Environment Context** - Server/client side
4. **Breaking Changes** - Any schema/API modifications