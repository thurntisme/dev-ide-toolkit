---
name: nextjs-data-fetching
description: Next.js data fetching specialist. Use when user asks about data fetching, caching, revalidation, or server components in Next.js.
---

# Next.js Data Fetching

## When to use
- User asks about data fetching in Next.js
- User asks about caching strategies
- User asks about Server Components
- User asks about ISR or SSG patterns

## Server Component Fetching

```tsx
// app/users/page.tsx
async function getUsers() {
  const res = await fetch('https://api.example.com/users', {
    cache: 'force-cache', // Default in Server Components
  });
  
  if (!res.ok) {
    throw new Error('Failed to fetch users');
  }
  
  return res.json();
}

export default async function UsersPage() {
  const users = await getUsers();
  
  return (
    <ul>
      {users.map(user => (
        <li key={user.id}>{user.name}</li>
      ))}
    </ul>
  );
}
```

## Fetch with Dynamic Segments

```tsx
// app/users/[id]/page.tsx
interface Props {
  params: { id: string };
}

async function getUser(id: string) {
  const res = await fetch(`https://api.example.com/users/${id}`, {
    next: { revalidate: 60 },
  });
  
  if (!res.ok) {
    return null;
  }
  
  return res.json();
}

export default async function UserPage({ params }: Props) {
  const user = await getUser(params.id);
  
  if (!user) {
    notFound();
  }
  
  return <UserCard user={user} />;
}
```

## Static Generation with generateStaticParams

```tsx
// app/posts/[slug]/page.tsx
interface Props {
  params: { slug: string };
}

async function getPost(slug: string) {
  const res = await fetch(`https://api.example.com/posts/${slug}`);
  return res.json();
}

async function getAllSlugs() {
  const posts = await fetch('https://api.example.com/posts').then(r => r.json());
  return posts.map((post: any) => ({ slug: post.slug }));
}

export async function generateStaticParams() {
  const slugs = await getAllSlugs();
  return slugs;
}

export default async function PostPage({ params }: Props) {
  const post = await getPost(params.slug);
  
  return (
    <article>
      <h1>{post.title}</h1>
      <p>{post.content}</p>
    </article>
  );
}
```

## Revalidation Patterns

```tsx
// Per-fetch revalidation (5 minutes)
const data = await fetch('https://api.example.com/data', {
  next: { revalidate: 300 },
});

// Tag-based revalidation
const data = await fetch('https://api.example.com/users', {
  next: { tags: ['users'] },
});

// Later revalidate by tag
import { revalidateTag } from 'next/cache';
revalidateTag('users');
```

## Parallel Data Fetching

```tsx
// app/dashboard/page.tsx
async function getStats() {
  const res = await fetch('https://api.example.com/stats');
  return res.json();
}

async function getRecentPosts() {
  const res = await fetch('https://api.example.com/posts?limit=5');
  return res.json();
}

async function getNotifications() {
  const res = await fetch('https://api.example.com/notifications');
  return res.json();
}

export default async function Dashboard() {
  const [stats, posts, notifications] = await Promise.all([
    getStats(),
    getRecentPosts(),
    getNotifications(),
  ]);
  
  return (
    <DashboardLayout
      stats={stats}
      posts={posts}
      notifications={notifications}
    />
  );
}
```

## Sequential Data Fetching

```tsx
async function getUser(id: string) {
  const res = await fetch(`https://api.example.com/users/${id}`);
  return res.json();
}

async function getUserPosts(userId: string) {
  const res = await fetch(`https://api.example.com/users/${userId}/posts`);
  return res.json();
}

export default async function UserPostsPage({ params }: { params: { id: string } }) {
  const user = await getUser(params.id);
  const posts = await getUserPosts(params.id);
  
  return (
    <div>
      <UserHeader user={user} />
      <PostList posts={posts} />
    </div>
  );
}
```

## Using Database Directly

```tsx
import { db } from '@/lib/db';

export default async function UsersPage() {
  const users = await db.user.findMany({
    where: { active: true },
    orderBy: { createdAt: 'desc' },
    take: 10,
  });

  return (
    <UserList users={users} />
  );
}

// With caching
export default async function UsersPage() {
  const users = await db.user.findMany({
    next: { revalidate: 60 },
  });

  return <UserList users={users} />;
}
```

## Client-Side Fetching

```tsx
'use client';

import { useState, useEffect } from 'react';

export function UserList() {
  const [users, setUsers] = useState<User[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    async function fetchUsers() {
      try {
        const res = await fetch('/api/users');
        const data = await res.json();
        setUsers(data.users);
      } catch (error) {
        console.error('Failed to fetch users');
      } finally {
        setLoading(false);
      }
    }

    fetchUsers();
  }, []);

  if (loading) return <Skeleton />;

  return (
    <ul>
      {users.map(user => (
        <li key={user.id}>{user.name}</li>
      ))}
    </ul>
  );
}
```

## React Query (TanStack Query)

```tsx
'use client';

import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';

export function useUsers() {
  return useQuery({
    queryKey: ['users'],
    queryFn: async () => {
      const res = await fetch('/api/users');
      return res.json();
    },
    staleTime: 5 * 60 * 1000, // 5 minutes
  });
}

export function useCreateUser() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: async (data: CreateUserData) => {
      const res = await fetch('/api/users', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(data),
      });
      return res.json();
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['users'] });
    },
  });
}

// Usage
function CreateUserForm() {
  const createUser = useCreateUser();

  const handleSubmit = (data: CreateUserData) => {
    createUser.mutate(data);
  };

  return <Form onSubmit={handleSubmit} />;
}
```

## SWR

```tsx
'use client';

import useSWR from 'swr';

const fetcher = (url: string) => fetch(url).then(res => res.json());

export function useUsers() {
  const { data, error, isLoading, mutate } = useSWR('/api/users', fetcher, {
    revalidateOnFocus: false,
    revalidateOnReconnect: true,
  });

  return {
    users: data,
    isLoading,
    isError: error,
    mutate,
  };
}

function UserList() {
  const { users, isLoading, isError } = useUsers();

  if (isLoading) return <Skeleton />;
  if (isError) return <Error />;

  return (
    <ul>
      {users?.map(user => (
        <li key={user.id}>{user.name}</li>
      ))}
    </ul>
  );
}
```

## Streaming with Suspense

```tsx
// app/blog/page.tsx
import { Suspense } from 'react';

async function PopularPosts() {
  const posts = await fetchPopularPosts();
  return <PostList posts={posts} />;
}

async function RecentPosts() {
  const posts = await fetchRecentPosts();
  return <PostList posts={posts} />;
}

function PostSkeleton() {
  return <div className="animate-pulse">Loading posts...</div>;
}

export default function BlogPage() {
  return (
    <div className="grid grid-cols-2 gap-8">
      <section>
        <h2>Popular Posts</h2>
        <Suspense fallback={<PostSkeleton />}>
          <PopularPosts />
        </Suspense>
      </section>
      <section>
        <h2>Recent Posts</h2>
        <Suspense fallback={<PostSkeleton />}>
          <RecentPosts />
        </Suspense>
      </section>
    </div>
  );
}
```

## Caching Strategies

| Strategy | Use Case |
|----------|----------|
| `cache: 'force-cache'` | Static data, rarely changes |
| `cache: 'no-store'` | Dynamic data, always fresh |
| `revalidate: 60` | ISR, revalidate every 60s |
| `tags: ['users']` | Tag-based invalidation |

## Prefetching

```tsx
import Link from 'next/link';
import { useRouter } from 'next/navigation';

function UserCard({ user }: { user: User }) {
  const router = useRouter();

  const handleClick = () => {
    router.prefetch(`/users/${user.id}`);
  };

  return (
    <div onMouseEnter={handleClick}>
      <Link href={`/users/${user.id}`}>
        <h3>{user.name}</h3>
      </Link>
    </div>
  );
}
```

## Route Handler Fetching

```tsx
// app/api/posts/route.ts
export async function GET(request: NextRequest) {
  const { searchParams } = new URL(request.url);
  const page = searchParams.get('page') || '1';
  const limit = searchParams.get('limit') || '10';

  const posts = await db.post.findMany({
    skip: (Number(page) - 1) * Number(limit),
    take: Number(limit),
    orderBy: { publishedAt: 'desc' },
  });

  return NextResponse.json({
    posts,
    page: Number(page),
    hasMore: posts.length === Number(limit),
  });
}

// Client component
'use client';

import { useInfiniteScroll } from 'react';

function PostFeed() {
  const { posts, loadMore, hasMore } = useInfiniteScroll();

  return (
    <>
      {posts.map(post => (
        <PostCard key={post.id} post={post} />
      ))}
      {hasMore && (
        <button onClick={loadMore}>Load More</button>
      )}
    </>
  );
}
```
