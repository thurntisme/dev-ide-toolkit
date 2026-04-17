---
name: reactjs-testing
description: React testing specialist. Use when user asks about testing React components, hooks, or setting up test environments.
---

# React Testing

## When to use
- User asks about testing React components
- User asks about writing unit tests for hooks
- User asks about setting up test environment
- User asks about testing user interactions

## Testing Setup

```tsx
// jest.config.js (or jest.config.ts)
module.exports = {
  testEnvironment: 'jsdom',
  setupFilesAfterEnv: ['<rootDir>/jest.setup.ts'],
  moduleNameMapper: {
    '^@/(.*)$': '<rootDir>/src/$1',
    '\\.(css|less|scss|sass)$': 'identity-obj-proxy',
  },
  transform: {
    '^.+\\.(ts|tsx)$': ['ts-jest', { tsconfig: 'tsconfig.json' }],
  },
};
```

```tsx
// jest.setup.ts
import '@testing-library/jest-dom';
import { cleanup } from '@testing-library/react';

afterEach(() => {
  cleanup();
});
```

## Testing Library

```tsx
import { render, screen, fireEvent, waitFor } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { describe, it, expect, vi } from 'vitest';

// Render component
const { container } = render(<MyComponent />);

// Query elements
screen.getByText('Submit'); // Throws if not found
screen.queryByText('Delete'); // Returns null if not found
screen.findByText('Loading'); // Returns promise

// Async queries
await waitFor(() => {
  expect(screen.getByText('Loaded')).toBeInTheDocument();
});
```

## Component Testing

```tsx
// Basic component test
describe('Button', () => {
  it('renders with correct text', () => {
    render(<Button>Click me</Button>);
    expect(screen.getByRole('button', { name: 'Click me' })).toBeInTheDocument();
  });

  it('calls onClick when clicked', async () => {
    const user = userEvent.setup();
    const handleClick = vi.fn();
    
    render(<Button onClick={handleClick}>Click me</Button>);
    
    await user.click(screen.getByRole('button'));
    
    expect(handleClick).toHaveBeenCalledTimes(1);
  });
});
```

```tsx
// Testing props
describe('UserCard', () => {
  it('displays user name and email', () => {
    render(<UserCard name="John" email="john@example.com" />);
    
    expect(screen.getByText('John')).toBeInTheDocument();
    expect(screen.getByText('john@example.com')).toBeInTheDocument();
  });

  it('shows admin badge for admin users', () => {
    render(<UserCard name="Jane" email="jane@example.com" role="admin" />);
    
    expect(screen.getByText('Admin')).toBeInTheDocument();
  });

  it('does not show admin badge for regular users', () => {
    render(<UserCard name="John" email="john@example.com" role="user" />);
    
    expect(screen.queryByText('Admin')).not.toBeInTheDocument();
  });
});
```

## Form Testing

```tsx
describe('LoginForm', () => {
  it('validates required fields', async () => {
    const user = userEvent.setup();
    render(<LoginForm />);
    
    await user.click(screen.getByRole('button', { name: 'Submit' }));
    
    expect(await screen.findByText('Email is required')).toBeInTheDocument();
    expect(screen.getByText('Password is required')).toBeInTheDocument();
  });

  it('submits form with valid data', async () => {
    const user = userEvent.setup();
    const onSubmit = vi.fn();
    
    render(<LoginForm onSubmit={onSubmit} />);
    
    await user.type(screen.getByLabelText(/email/i), 'test@example.com');
    await user.type(screen.getByLabelText(/password/i), 'password123');
    await user.click(screen.getByRole('button', { name: 'Submit' }));
    
    expect(onSubmit).toHaveBeenCalledWith({
      email: 'test@example.com',
      password: 'password123',
    });
  });
});
```

## Async Testing

```tsx
describe('DataFetcher', () => {
  it('displays loading state', () => {
    render(<DataFetcher url="/api/data" />);
    expect(screen.getByText(/loading/i)).toBeInTheDocument();
  });

  it('displays data when loaded', async () => {
    server.use(
      rest.get('/api/data', (req, res, ctx) => {
        return res(ctx.json({ name: 'Test Data' }));
      })
    );

    render(<DataFetcher url="/api/data" />);
    
    expect(await screen.findByText('Test Data')).toBeInTheDocument();
  });

  it('displays error state', async () => {
    server.use(
      rest.get('/api/data', (req, res, ctx) => {
        return res(ctx.status(500));
      })
    );

    render(<DataFetcher url="/api/data" />);
    
    expect(await screen.findByText(/error/i)).toBeInTheDocument();
  });
});
```

## Hook Testing

```tsx
import { renderHook, act } from '@testing-library/react';
import { useCounter } from './useCounter';

describe('useCounter', () => {
  it('initializes with default value', () => {
    const { result } = renderHook(() => useCounter());
    
    expect(result.current.count).toBe(0);
  });

  it('initializes with custom value', () => {
    const { result } = renderHook(() => useCounter(10));
    
    expect(result.current.count).toBe(10);
  });

  it('increments count', () => {
    const { result } = renderHook(() => useCounter());
    
    act(() => {
      result.current.increment();
    });
    
    expect(result.current.count).toBe(1);
  });

  it('decrements count', () => {
    const { result } = renderHook(() => useCounter(5));
    
    act(() => {
      result.current.decrement();
    });
    
    expect(result.current.count).toBe(4);
  });
});
```

```tsx
// Testing useEffect
describe('useWindowSize', () => {
  it('updates on window resize', () => {
    const { result } = renderHook(() => useWindowSize());
    
    expect(result.current.width).toBe(window.innerWidth);
    
    // Simulate resize
    (window.innerWidth as number) = 500;
    fireEvent.resize(window);
    
    expect(result.current.width).toBe(500);
  });
});
```

## Mocking

```tsx
// Mock modules
vi.mock('../utils/api', () => ({
  fetchUser: vi.fn(),
}));

// Mock functions
const mockFetchUser = vi.fn();
vi.mocked(fetchUser).mockResolvedValue({ name: 'John' });

// Mock components
vi.mock('./HeavyComponent', () => ({
  default: () => <div>Mocked</div>,
}));

// Mock timers
describe('Timer', () => {
  beforeEach(() => {
    vi.useFakeTimers();
  });

  afterEach(() => {
    vi.useRealTimers();
  });

  it('updates after 1 second', () => {
    render(<Timer />);
    
    act(() => {
      vi.advanceTimersByTime(1000);
    });
    
    expect(screen.getByText('1')).toBeInTheDocument();
  });
});
```

## Testing Accessibility

```tsx
import { axe, toHaveNoViolations } from 'jest-axe';

expect.extend(toHaveNoViolations);

describe('Button', () => {
  it('has no accessibility violations', async () => {
    const { container } = render(<Button>Click me</Button>);
    const results = await axe(container);
    
    expect(results).toHaveNoViolations();
  });
});
```

## Snapshot Testing

```tsx
describe('Button', () => {
  it('matches snapshot', () => {
    const { container } = render(<Button>Click me</Button>);
    
    expect(container).toMatchSnapshot();
  });

  it('matches inline snapshot', () => {
    const { container } = render(<Button>Click me</Button>);
    
    expect(container.innerHTML).toMatchInlineSnapshot(`
      <button class="btn">Click me</button>
    `);
  });
});
```

## Testing with Router

```tsx
import { MemoryRouter, Routes, Route } from 'react-router-dom';

function renderWithRouter(ui: ReactElement, { route = '/' } = {}) {
  return render(
    <MemoryRouter initialEntries={[route]}>
      <Routes>
        <Route path="/" element={ui} />
      </Routes>
    </MemoryRouter>
  );
}

// Usage
it('navigates to about page', () => {
  renderWithRouter(<App />, { route: '/' });
  
  fireEvent.click(screen.getByText('About'));
  
  expect(screen.getByText('About Page')).toBeInTheDocument();
});
```

## Testing with Context

```tsx
import { ThemeProvider } from '../context/ThemeContext';

function renderWithTheme(ui: ReactElement, theme = 'light') {
  return render(
    <ThemeProvider initialTheme={theme}>
      {ui}
    </ThemeProvider>
  );
}

// Usage
it('renders with dark theme', () => {
  renderWithTheme(<MyComponent />, 'dark');
  
  expect(document.body).toHaveClass('dark');
});
```

## Test Patterns

| Pattern | Use Case |
|---------|----------|
| AAA (Arrange, Act, Assert) | Standard test structure |
| Given-When-Then | BDD style tests |
| Test Doubles | Mocking dependencies |
| Smoke Tests | Quick sanity checks |
| Integration Tests | Testing component interactions |
