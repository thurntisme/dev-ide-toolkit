---
name: code-gen
description: "Core logic for autonomous code generation and implementation."
version: "1.2.0"
---

# /code-gen Command Execution Logic

## 1. Trigger & Context Initialization

- **Command:** `/code-gen [user_prompt] [arg]`
- **Initial Action:** Analyze `[user_prompt]` to identify the technical stack (e.g., WordPress/PHP, Next.js/React, or Tauri/Rust).
- **Dynamic Routing:** Load the specialized persona from `../agents/coder.md` based on the detected stack.

## 2. Mandatory Knowledge Retrieval

Before generating any code, the Agent **MUST** synchronize with the following local resources:

- **Project Context:** - Consult `../../docs/` to understand project source-base.
- **Knowledge Standards:** - Consult `../knowledge/` for the following domain-specific context.

## 3. Policy & Constraint Enforcement

The Agent must strictly adhere to the logic defined in the `../rules/` directory:

- **Coding Convention:** Follow `../rules/code-conventions.md`.
- **Naming Convention:** Follow `../rules/name-Convention.md`.
- **Clean Code:** Follow `../rules/clean-code.md`.
- **Security:** Follow `../rules/security.md`.

In case user request feature related to api, the agent should follow bellow files:

- **API Convention:** Follow `../rules/api-conventions.md`.
- **Error Handling:** Follow `../rules/error-handling.md`.

- **Environment Context:**
  - Follow specialized rules in `../rules/environment-context.md` (if exists).

## 4. Execution Workflow (Full Lifecycle)

Execute the task by following the step-by-step skills in `../skills/code-gen/`

## 5. Safety Guardrails

- **Git Safety:** Before applying any changes, the Agent **MUST** check the current Git status.
  - If there are uncommitted changes in the working directory, warn the user and suggest a commit or stash.
  - For significant features, recommend creating a new feature branch (e.g., `feat/ai-gen-...`) instead of applying directly to the current branch.
- If the request involves destructive actions (e.g., deleting directories), **STOP** and ask for user confirmation.
- If the project documentation is missing from the local `../../docs/` or this folder is not exist, the Agent should notice to the user to create it.
- If the required knowledge is missing from the local `../knowledge/` folder, the Agent must notify the user.

## Command Mapping & Execution

| Command                                 | Action                                                     | Sub-Workflow to Load                      |
| :-------------------------------------- | :--------------------------------------------------------- | :---------------------------------------- |
| `/code-gen "implement X"`               | Analyzes feature request and generates implementation plan | `../skills/code-gen/quick-implement.md`   |
| `/code-gen "implement X" --strict`      | Creates and verifies test cases after implementation       | `../skills/code-gen/strict-implement.md`  |
| `/code-gen "implement X" --dry-run`     | Preview changes without applying them                      | `../skills/code-gen/plan-implement.md`    |
| `/code-gen "implement X" --interactive` | Confirm each step before executing                         | `../skills/code-gen/confirm-implement.md` |
| `/code-gen "fix [error_log]"`           | Analyzes error logs and proposes bug fixes                 | `../skills/code-gen/debug-fix.md`         |
| `/code-gen "refactor X"`                | Optimizes existing code without changing its functionality | `../skills/code-gen/refactor.md`          |

## Code Generation Structure

The Agent must maintain and reference this workflow:

- Analyze the feature request and determine the tech stack (coder - refer to `../agents/coder.md` for coder types)
- Parse and understand the codebase to find relevant files
- Create implementation plan in `dit-tmp/plans/`
- Execute implementation tasks
- Run lint/typecheck commands
- If `--strict`: create and verify tests in `dit-tmp/testing/`

## Execution Steps for AI Agent

### Step 1: Context Retrieval

- Parse the user's feature request description
- Determine the appropriate coder type (e.g., coder-reactjs, coder-python, etc.)
- Identify relevant files and patterns in the codebase

### Step 2: Analysis & Generation

- Follow the **Code Standards** defined in `./docs/code-standards.md`.
- Use existing code patterns and conventions.
- Maintain consistent naming and structure.

### Step 3: Plan & Execution

- Create implementation plan in `dit-tmp/plans/` directory
- Execute tasks following the generated plan
- Run lint/typecheck commands to verify correctness
- Create tests if `--strict` flag is provided

## Constraints

- **Do not** generate code that exposes secrets, API keys, or credentials.
- **Do not** commit changes unless explicitly requested.
- **Always** run lint/typecheck before completing.
- **Follow** existing code patterns in the codebase.

## Output Structure Standards

Every `/code-gen` response must follow this structured preview before execution:

1.  **Impacted Files:** List all files to be created, modified, or deleted.
2.  **New Dependencies:** List any libraries/packages to be added if available.
3.  **Environment Context:** Explicitly state if the code belongs to Server-side, Client-side,.. if available.
4.  **Breaking Changes:** Highlight any modifications to existing shared components, types, or API schemas that might affect other parts of the system.

## Related Workflows

- See: `../skills/code-gen/` (main code generation workflow)
- See: `../skills/docs/` (planning workflow)
