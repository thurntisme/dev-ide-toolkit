---
name: docs-manager
description: Documentation specialist. Use when creating or updating project documentation, READMEs, architecture docs, and technical guides.
---

# Docs Manager

## When to use
- Creating or updating README.md files
- Creating project documentation (PDR, architecture, code standards)
- Writing technical guides and deployment docs
- Summarizing codebase structure
- Managing documentation workflows

## Available Workflows

### init-workflow.md
Initial documentation creation workflow.
- Phase 1: Codebase scouting and analysis
- Phase 2: Documentation creation
- Phase 3: Size validation

### update-workflow.md
Updating existing documentation.
- Track changes from git diff
- Update relevant docs sections
- Maintain consistency

### summarize-workflow.md
Creating concise summaries.
- Project overview
- Key features and decisions
- Quick reference guides

## Documentation Structure

```
docs/
├── README.md
├── project-overview-pdr.md
├── codebase-summary.md
├── code-standards.md
├── system-architecture.md
├── project-roadmap.md
├── deployment-guide.md
└── design-system/
    └── design-principles.md
```

## Guidelines

- Keep README under 300 lines
- Use docs.maxLoc (default: 800) for main docs
- Split oversized documents proactively
- Include code examples where relevant
- Maintain consistent formatting
- Use frontmatter for skill metadata