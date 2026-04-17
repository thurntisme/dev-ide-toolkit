---
name: coder-reactjs
description: React.js development. Use when user asks to create, modify, or debug React applications.
---

# React.js Development Guide

## When to use
- User asks to create a React application
- User asks to add components, hooks, or state management
- User asks about React best practices
- User asks to debug React issues

## Conventions

- Use functional components with hooks
- Use TypeScript for type safety
- Follow React naming conventions (PascalCase for components, camelCase for functions)
- Use absolute imports with path aliases

## File Structure

```
src/
├── components/          # Reusable UI components
├── pages/              # Route pages
├── hooks/               # Custom hooks
├── contexts/            # React contexts
├── services/            # API services
├── utils/               # Utility functions
├── types/               # TypeScript types
└── assets/              # Static assets
```

## Component Pattern

```tsx
import { useState, useEffect } from 'react';

interface Props {
  title: string;
  onSubmit?: () => void;
}

export function MyComponent({ title, onSubmit }: Props) {
  const [state, setState] = useState<string>('');

  useEffect(() => {
    // side effects
  }, []);

  return (
    <div className="my-component">
      <h1>{title}</h1>
    </div>
  );
}
```

## State Management

| Approach | Use case |
|----------|----------|
| `useState` | Local component state |
| `useReducer` | Complex state logic |
| `useContext` | Shared state across components |
| Zustand/Redux | Global application state |

## Common Hooks

| Hook | Usage |
|------|-------|
| `useState` | Local state |
| `useEffect` | Side effects |
| `useRef` | DOM refs |
| `useMemo` | Expensive computations |
| `useCallback` | Memoized callbacks |

## API Calls

```tsx
import { useQuery, useMutation } from '@tanstack/react-query';

function MyComponent() {
  const { data, isLoading } = useQuery({
    queryKey: ['myData'],
    queryFn: () => fetch('/api/data').then(res => res.json())
  });

  const mutation = useMutation({
    mutationFn: (newData) => fetch('/api/data', {
      method: 'POST',
      body: JSON.stringify(newData)
    })
  });
}
```

## Performance Checklist

- [ ] Use `React.memo` for expensive components
- [ ] Use `useMemo` for expensive calculations
- [ ] Use `useCallback` for function props
- [ ] Implement code splitting with `React.lazy`
- [ ] Use virtualization for long lists
