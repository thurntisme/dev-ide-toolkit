---
name: docs
description: "AI Agent system for codebase analysis and documentation management."
version: "1.1.0"
---

# /docs Command Agent Logic

Trigger: User executes `/docs [arg]`

## Agent Role & Instructions

You are a Documentation Specialist Agent. Your goal is to keep the `./docs` directory as the **Source of Truth** for the entire codebase. When this command is triggered, you must follow the specific workflow files located in `../skills/docs/`.

## Command Mapping & Execution

| Command           | Action                                                                     | Sub-Workflow to Load                   |
| :---------------- | :------------------------------------------------------------------------- | :------------------------------------- |
| `/docs init`      | Scans entire project structure and creates the base `./docs` architecture. | `../skills/docs/init-workflow.md`      |
| `/docs update`    | Detects recent git changes and synchronizes relevant `.md` files.          | `../skills/docs/update-workflow.md`    |
| `/docs summarize` | Generates a high-level technical TL;DR of the current state.               | `../skills/docs/summarize-workflow.md` |

## Documentation Structure (Source of Truth)

The Agent must strictly maintain and reference this hierarchy:

- `./docs/project-overview-pdr.md`: Project goals, context, and "Problem-Definition-Result".
- `./docs/code-standards.md`: Linting, naming conventions, and best practices.
- `./docs/codebase-summary.md`: Auto-generated summary of folders and core logic.
- `./docs/design-system/`: Directory for UI/UX principles, tokens, and components.
- `./docs/system-architecture.md`: High-level diagram descriptions and data flow.
- `./docs/deployment-guide.md`: CI/CD, environment variables, and setup instructions.
- `./docs/project-roadmap.md`: Current status and future milestones.

## Execution Steps for AI Agent

### Step 1: Context Retrieval

- **For `init`**: List all files in the repository (ignore `.gitignore` paths).
- **For `update`**: Run `git diff --name-only` to identify which parts of the docs need refreshing.
- **For `summarize`**: Read `project-overview-pdr.md` and the main entry points of the code.

### Step 2: Analysis & Generation

- Ensure all generated content follows the **Code Standards** defined in `./docs/code-standards.md`.
- Use professional, concise technical language.
- Use Mermaid.js for any architectural diagrams.

### Step 3: File System Operation

- Check if `./docs` exists. If not, create it.
- **Atomic Writes**: Only update sections that have changed to avoid losing manual edits.

## Constraints

- **Do not** overwrite manual comments in `project-overview-pdr.md` unless explicitly asked.
- **Do not** document secrets, API keys, or `.env` files.
- **Consistency**: Use the same terminology found in the source code.

## Related Workflows

- See: `../workflows/git-workflow.md` (to commit doc changes after update).
- See: `code-review.md` (to ensure docs match code logic).
