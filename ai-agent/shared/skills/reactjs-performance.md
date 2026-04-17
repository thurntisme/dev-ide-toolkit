---
name: reactjs-performance
description: React performance optimization specialist. Use when user asks about React performance, memoization, code splitting, or bundle optimization.
---

# React Performance Optimization

## When to use
- User asks about React performance optimization
- User asks about memoization techniques
- User asks about reducing re-renders
- User asks about bundle size optimization

## React.memo

```tsx
// Basic memo
const MyComponent = React.memo(function MyComponent({ name }: { name: string }) {
  return <div>{name}</div>;
});

// With custom comparison
const MyComponent = React.memo(
  function MyComponent({ user, onClick }: Props) {
    return (
      <div onClick={onClick}>
        {user.name}
      </div>
    );
  },
  (prevProps, nextProps) => {
    return prevProps.user.id === nextProps.user.id;
  }
);
```

## useMemo

```tsx
// Memoize expensive calculations
const sortedData = useMemo(() => {
  return data
    .filter(item => item.active)
    .sort((a, b) => b.score - a.score)
    .slice(0, 10);
}, [data]);

// Memoize objects
const options = useMemo(() => ({
  enableSearch: true,
  pageSize: 20,
  maxResults: 100
}), []);

// Memoize derived data
const totalPrice = useMemo(() => {
  return cartItems.reduce((sum, item) => sum + item.price * item.quantity, 0);
}, [cartItems]);
```

## useCallback

```tsx
// Memoize callbacks
const handleSubmit = useCallback((data: FormData) => {
  submitForm(data);
}, [submitForm]);

// With dependencies
const handleItemClick = useCallback((id: string) => {
  setSelectedId(id);
  fetchItemDetails(id);
}, []);

// Prevent unnecessary re-renders in child components
const MemoizedChild = React.memo(ChildComponent);

function ParentComponent() {
  const handleClick = useCallback(() => {
    console.log('clicked');
  }, []);

  return <MemoizedChild onClick={handleClick} />;
}
```

## Virtualization

```tsx
// Using react-window
import { FixedSizeList } from 'react-window';

function VirtualizedList({ items }: { items: Item[] }) {
  return (
    <FixedSizeList
      height={400}
      width="100%"
      itemCount={items.length}
      itemSize={50}
    >
      {({ index, style }) => (
        <div style={style}>
          <ListItem item={items[index]} />
        </div>
      )}
    </FixedSizeList>
  );
}

// Using react-virtualized-auto-sizer
import AutoSizer from 'react-virtualized-auto-sizer';
import { VariableSizeList } from 'react-window';

function DynamicList({ items }: { items: Item[] }) {
  return (
    <AutoSizer>
      {({ height, width }) => (
        <VariableSizeList
          height={height}
          width={width}
          itemCount={items.length}
          itemSize={(index) => items[index].height}
        >
          {({ index, style }) => (
            <div style={style}>
              <ListItem item={items[index]} />
            </div>
          )}
        </VariableSizeList>
      )}
    </AutoSizer>
  );
}
```

## Code Splitting

```tsx
// Dynamic imports
const LazyComponent = lazy(() => import('./HeavyComponent'));

function App() {
  return (
    <Suspense fallback={<Loading />}>
      <LazyComponent />
    </Suspense>
  );
}

// With named exports
const LazyModal = lazy(() => import('./Modal').then(m => ({ default: m.Modal })));

// Preloading
const LazyDashboard = lazy(() => import('./Dashboard'));

function App() {
  const preloadDashboard = () => {
    import('./Dashboard');
  };

  return (
    <>
      <Suspense fallback={<Loading />}>
        <LazyDashboard />
      </Suspense>
      <button onClick={preloadDashboard}>Preload</button>
    </>
  );
}
```

## Lazy Loading Routes

```tsx
import { lazy, Suspense } from 'react';
import { BrowserRouter, Routes, Route } from 'react-router-dom';

const Home = lazy(() => import('./pages/Home'));
const About = lazy(() => import('./pages/About'));
const Dashboard = lazy(() => import('./pages/Dashboard'));

function App() {
  return (
    <BrowserRouter>
      <Suspense fallback={<PageLoader />}>
        <Routes>
          <Route path="/" element={<Home />} />
          <Route path="/about" element={<About />} />
          <Route path="/dashboard/*" element={<Dashboard />} />
        </Routes>
      </Suspense>
    </BrowserRouter>
  );
}
```

## List Performance

```tsx
// Key best practices
function List({ items }: { items: Item[] }) {
  return (
    <>
      {items.map(item => (
        // Use stable, unique IDs - NOT index
        <ListItem key={item.id} item={item} />
      ))}
    </>
  );
}

// Memoize list items
const ListItem = React.memo(function ListItem({ item }: { item: Item }) {
  return <div>{item.name}</div>;
});

function List({ items }: { items: Item[] }) {
  return (
    <>
      {items.map(item => (
        <ListItem key={item.id} item={item} />
      ))}
    </>
  );
}
```

## State Colocation

```tsx
// BAD - state at high level causes unnecessary renders
function App() {
  const [count, setCount] = useState(0); // Only used in Counter
  const [theme, setTheme] = useState('light'); // Only used in ThemeToggle

  return (
    <>
      <Header /> {/* Re-renders when count changes */}
      <Counter count={count} setCount={setCount} />
      <Footer /> {/* Re-renders when theme changes */}
    </>
  );
}

// GOOD - colocate state where it's used
function Counter() {
  const [count, setCount] = useState(0);
  return <div>{count}</div>;
}

function App() {
  return (
    <>
      <Header />
      <Counter />
      <Footer />
    </>
  );
}
```

## useDeferredValue

```tsx
import { useState, useDeferredValue } from 'react';

function SearchResults({ query }: { query: string }) {
  const deferredQuery = useDeferredValue(query);
  
  // Use deferred value for expensive filtering
  const results = useMemo(() => {
    return expensiveFilter(allItems, deferredQuery);
  }, [deferredQuery]);

  const isStale = query !== deferredQuery;

  return (
    <div style={{ opacity: isStale ? 0.5 : 1 }}>
      {results.map(result => (
        <SearchResult key={result.id} result={result} />
      ))}
    </div>
  );
}
```

## useTransition

```tsx
import { useState, useTransition } from 'react';

function TabContainer() {
  const [isPending, startTransition] = useTransition();
  const [activeTab, setActiveTab] = useState('posts');

  const handleTabChange = (tab: string) => {
    startTransition(() => {
      setActiveTab(tab);
    });
  };

  return (
    <>
      <TabBar onChange={handleTabChange} />
      {isPending ? <Spinner /> : <TabContent activeTab={activeTab} />}
    </>
  );
}
```

## Profiling

```tsx
// Wrap component with Profiler
function App() {
  return (
    <Profiler id="Navigation" onRender={onRenderCallback}>
      <Navigation />
    </Profiler>
  );
}

function onRenderCallback(
  id: string,
  phase: 'mount' | 'update',
  actualDuration: number,
  baseDuration: number,
  startTime: number,
  commitTime: number
) {
  console.log({
    id,
    phase,
    actualDuration,
    baseDuration,
    startTime,
    commitTime
  });

  if (actualDuration > baseDuration * 1.5) {
    console.warn(`Component ${id} is slow:`, actualDuration);
  }
}
```

## Bundle Analysis

```tsx
// webpack-bundle-analyzer
// Add to next.config.js or webpack.config.js
const withBundleAnalyzer = require('@next/bundle-analyzer')({
  enabled: process.env.ANALYZE === 'true',
});

module.exports = withBundleAnalyzer({
  // config
});

// Run analysis
// ANALYZE=true npm run build
```

## Web Vitals

```tsx
// Measure Core Web Vitals
import { getLCP, getFID, getCLS } from 'web-vitals';

function sendToAnalytics({ name, delta, id }: Metric) {
  console.log(`${name}: ${delta}`);
}

getLCP(sendToAnalytics);
getFID(sendToAnalytics);
getCLS(sendToAnalytics);
```

## Common Mistakes

| Mistake | Solution |
|---------|----------|
| Using index as key | Use unique ID |
| Creating new objects in render | Memoize with useMemo |
| Creating new functions in render | Memoize with useCallback |
| Putting all state at top | Colocate state |
| Not splitting large components | Extract sub-components |
| Missing dependencies in hooks | Always include all dependencies |
