# Code Style Guide

## General

- Use TypeScript for all new code
- Use 2 spaces for indentation
- Use single quotes for strings
- Add semicolons at end of statements
- Maximum line length: 100 characters

## Functions

- Use arrow functions for callbacks
- Use async/await over promises
- Add return types for exported functions
- Keep functions under 50 lines

## Classes

- Use PascalCase for class names
- Use camelCase for properties/methods
- Add type annotations
- Use strict mode

## Imports

```typescript
// External first
import { something } from 'package';

// Internal second
import { something } from '@/module';

// Types
import type { Something } from '@/types';
```

## Error Handling

- Always handle errors in async functions
- Use try/catch for risky operations
- Provide meaningful error messages

## Naming

- Files: kebab-case or PascalCase
- Variables: camelCase
- Constants: UPPER_SNAKE_CASE
- Interfaces: PascalCase with I prefix (optional)