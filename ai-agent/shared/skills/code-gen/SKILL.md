---
name: code-gen
description: Generate code following dev-ide-toolkit conventions. Use when user asks to write code, create files, or implement features.
---

# Code Generation Guide

## When to use
- User asks to create new files
- User asks to implement features
- User asks to add functionality

## Conventions

### File Structure
- Use TypeScript when possible
- Follow existing directory structure
- Name files with kebab-case or PascalCase as appropriate

### Imports
- Use absolute imports for internal modules
- Add proper type imports
- Group imports: external, internal, types

### Exports
- Use named exports prefer
- Export types alongside implementations

## Steps

1. Analyze existing code patterns in project
2. Generate code following conventions
3. Add proper imports/exports
4. Include error handling
5. Verify code compiles
6. Add basic tests if applicable