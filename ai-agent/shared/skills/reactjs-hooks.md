---
name: reactjs-hooks
description: React hooks specialist. Use when user asks about React hooks, custom hooks, or state management patterns.
---

# React Hooks

## When to use
- User asks about React hooks usage
- User asks to create custom hooks
- User asks about state management with hooks
- User asks about side effects in React

## useState

```tsx
// Basic usage
const [count, setCount] = useState(0);

// With type inference
const [name, setName] = useState<string>('');

// Complex state
const [user, setUser] = useState<{
  name: string;
  email: string;
} | null>(null);

// Functional update
setCount(prev => prev + 1);
```

## useEffect

```tsx
// Basic side effect
useEffect(() => {
  document.title = `Count: ${count}`;
}, [count]);

// Cleanup function
useEffect(() => {
  const subscription = subscribe(handleChange);
  
  return () => {
    subscription.unsubscribe();
  };
}, []);

// Run once on mount
useEffect(() => {
  fetchData();
}, []); // Empty dependency array
```

## useRef

```tsx
// DOM ref
const inputRef = useRef<HTMLInputElement>(null);

useEffect(() => {
  inputRef.current?.focus();
}, []);

return <input ref={inputRef} />;

// Mutable value without re-render
const timerRef = useRef<number | null>(null);

useEffect(() => {
  timerRef.current = setInterval(() => {
    console.log('tick');
  }, 1000);
  
  return () => {
    if (timerRef.current) clearInterval(timerRef.current);
  };
}, []);
```

## useCallback

```tsx
const handleClick = useCallback((id: string) => {
  setItems(prev => prev.filter(item => item.id !== id));
}, []); // Dependencies

// With dependencies
const handleSubmit = useCallback((data: FormData) => {
  submitForm(data);
}, [submitForm]); // Only changes when submitForm changes
```

## useMemo

```tsx
// Expensive calculation
const sortedItems = useMemo(() => {
  return items.sort((a, b) => a.name.localeCompare(b.name));
}, [items]); // Recalculate only when items changes

// Object reference
const options = useMemo(() => ({
  page: 1,
  pageSize: 10,
  sortBy: 'createdAt'
}), []);
```

## useReducer

```tsx
type State = {
  count: number;
  status: 'idle' | 'loading' | 'error';
};

type Action =
  | { type: 'increment' }
  | { type: 'decrement' }
  | { type: 'reset' }
  | { type: 'setStatus'; payload: State['status'] };

function reducer(state: State, action: Action): State {
  switch (action.type) {
    case 'increment':
      return { ...state, count: state.count + 1 };
    case 'decrement':
      return { ...state, count: state.count - 1 };
    case 'reset':
      return { ...state, count: 0 };
    case 'setStatus':
      return { ...state, status: action.payload };
    default:
      return state;
  }
}

const [state, dispatch] = useReducer(reducer, {
  count: 0,
  status: 'idle'
});

// Usage
dispatch({ type: 'increment' });
```

## useContext

```tsx
// Create context
const ThemeContext = createContext<'light' | 'dark'>('light');

// Provider component
function ThemeProvider({ children }: { children: React.ReactNode }) {
  const [theme, setTheme] = useState<'light' | 'dark'>('light');
  
  return (
    <ThemeContext.Provider value={theme}>
      {children}
    </ThemeContext.Provider>
  );
}

// Consumer component
function ThemedButton() {
  const theme = useContext(ThemeContext);
  
  return (
    <button className={theme}>
      Click me
    </button>
  );
}
```

## Custom Hooks

```tsx
// useLocalStorage
function useLocalStorage<T>(key: string, initialValue: T) {
  const [storedValue, setStoredValue] = useState<T>(() => {
    if (typeof window === 'undefined') return initialValue;
    
    const item = window.localStorage.getItem(key);
    return item ? JSON.parse(item) : initialValue;
  });

  const setValue = useCallback((value: T | ((val: T) => T)) => {
    const valueToStore = value instanceof Function ? value(storedValue) : value;
    setStoredValue(valueToStore);
    window.localStorage.setItem(key, JSON.stringify(valueToStore));
  }, [key, storedValue]);

  return [storedValue, setValue] as const;
}

// Usage
const [theme, setTheme] = useLocalStorage('theme', 'light');
```

```tsx
// useDebounce
function useDebounce<T>(value: T, delay: number): T {
  const [debouncedValue, setDebouncedValue] = useState(value);

  useEffect(() => {
    const handler = setTimeout(() => {
      setDebouncedValue(value);
    }, delay);

    return () => clearTimeout(handler);
  }, [value, delay]);

  return debouncedValue;
}

// Usage
const debouncedSearch = useDebounce(searchTerm, 300);
```

```tsx
// useFetch
function useFetch<T>(url: string) {
  const [data, setData] = useState<T | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const controller = new AbortController();
    
    fetch(url, { signal: controller.signal })
      .then(res => {
        if (!res.ok) throw new Error('Failed to fetch');
        return res.json();
      })
      .then(data => {
        setData(data);
        setLoading(false);
      })
      .catch(err => {
        if (err.name !== 'AbortError') {
          setError(err.message);
          setLoading(false);
        }
      });

    return () => controller.abort();
  }, [url]);

  return { data, loading, error };
}
```

```tsx
// useToggle
function useToggle(initialValue = false) {
  const [value, setValue] = useState(initialValue);
  
  const toggle = useCallback(() => setValue(v => !v), []);
  const setTrue = useCallback(() => setValue(true), []);
  const setFalse = useCallback(() => setValue(false), []);

  return { value, toggle, setTrue, setFalse };
}
```

```tsx
// useClickOutside
function useClickOutside(ref: RefObject<HTMLElement>, handler: () => void) {
  useEffect(() => {
    const listener = (event: MouseEvent | TouchEvent) => {
      if (!ref.current || ref.current.contains(event.target as Node)) {
        return;
      }
      handler();
    };

    document.addEventListener('mousedown', listener);
    document.addEventListener('touchstart', listener);

    return () => {
      document.removeEventListener('mousedown', listener);
      document.removeEventListener('touchstart', listener);
    };
  }, [ref, handler]);
}
```

```tsx
// useMediaQuery
function useMediaQuery(query: string): boolean {
  const [matches, setMatches] = useState(false);

  useEffect(() => {
    const media = window.matchMedia(query);
    
    if (media.matches !== matches) {
      setMatches(media.matches);
    }

    const listener = () => setMatches(media.matches);
    
    media.addEventListener('change', listener);
    
    return () => media.removeEventListener('change', listener);
  }, [matches, query]);

  return matches;
}

// Usage
const isMobile = useMediaQuery('(max-width: 768px)');
```

```tsx
// useAsync
function useAsync<T, E = string>(
  asyncFunction: () => Promise<T>,
  immediate = true
) {
  const [status, setStatus] = useState<'idle' | 'pending' | 'success' | 'error'>('idle');
  const [value, setValue] = useState<T | null>(null);
  const [error, setError] = useState<E | null>(null);

  const execute = useCallback(async () => {
    setStatus('pending');
    setValue(null);
    setError(null);
    
    try {
      const response = await asyncFunction();
      setValue(response);
      setStatus('success');
    } catch (error) {
      setError(error as E);
      setStatus('error');
    }
  }, [asyncFunction]);

  useEffect(() => {
    if (immediate) {
      execute();
    }
  }, [execute, immediate]);

  return { execute, status, value, error };
}
```

## Rules of Hooks

1. Only call hooks at the top level
2. Only call hooks from React functions or custom hooks
3. Custom hooks must start with "use"
4. Always include dependencies in useEffect/useCallback/useMemo
