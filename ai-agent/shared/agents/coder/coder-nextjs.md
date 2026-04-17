---
name: coder-nextjs
description: Next.js development. Use when user asks to create, modify, or debug Next.js applications.
---

# Next.js Development Guide

## When to use
- User asks to create a Next.js application
- User asks to add pages, components, or API routes
- User asks about Next.js best practices
- User asks to debug Next.js issues

## Conventions

- Use App Router (Next.js 13+) over Pages Router
- Use TypeScript for type safety
- Use Server Components by default
- Follow Next.js naming conventions
- Use Tailwind CSS for styling

## File Structure (App Router)

```
project/
├── app/
│   ├── layout.tsx          # Root layout
│   ├── page.tsx            # Home page
│   ├── globals.css         # Global styles
│   ├── (routes)/
│   │   ├── about/
│   │   │   └── page.tsx
│   │   └── dashboard/
│   │       ├── page.tsx
│   │       └── layout.tsx
│   ├── api/
│   │   └── users/
│   │       └── route.ts
│   └── not-found.tsx
├── components/
│   ├── ui/                 # Reusable UI
│   └── layouts/
├── lib/
│   ├── utils.ts
│   └── db.ts
├── public/
├── .env.local
├── next.config.js
├── tailwind.config.js
├── tsconfig.json
└── package.json
```

## Page Component (Server)

```tsx
import { notFound } from 'next/navigation';

async function getData() {
  const res = await fetch('https://api.example.com/data');
  if (!res.ok) return undefined;
  return res.json();
}

export default async function Page() {
  const data = await getData();
  
  if (!data) {
    notFound();
  }

  return (
    <main>
      <h1>{data.title}</h1>
    </main>
  );
}
```

## Page Component (Client)

```tsx
'use client';

import { useState, useEffect } from 'react';

export default function ClientPage() {
  const [data, setData] = useState<string>('');

  useEffect(() => {
    fetch('/api/data')
      .then(res => res.json())
      .then(setData);
  }, []);

  return <div>{data}</div>;
}
```

## Dynamic Routes

```tsx
// app/users/[id]/page.tsx
interface Props {
  params: { id: string };
}

export default async function UserPage({ params }: Props) {
  const user = await getUser(params.id);
  return <h1>{user.name}</h1>;
}

export async function generateStaticParams() {
  const users = await getAllUsers();
  return users.map((user) => ({ id: user.id }));
}
```

## Route Groups

```tsx
// app/(marketing)/layout.tsx
export default function MarketingLayout({ children }: { children: React.ReactNode }) {
  return (
    <div>
      <nav>Marketing Nav</nav>
      {children}
    </div>
  );
}

// app/(app)/layout.tsx
export default function AppLayout({ children }: { children: React.ReactNode }) {
  return (
    <div>
      <sidebar>App Sidebar</sidebar>
      {children}
    </div>
  );
}
```

## API Routes

```ts
import { NextRequest, NextResponse } from 'next/server';

export async function GET(request: NextRequest) {
  const users = await db.user.findMany();
  return NextResponse.json(users);
}

export async function POST(request: NextRequest) {
  const body = await request.json();
  
  const user = await db.user.create({
    data: { name: body.name, email: body.email }
  });
  
  return NextResponse.json(user, { status: 201 });
}

export async function PUT(request: NextRequest) {
  const { searchParams } = new URL(request.url);
  const id = searchParams.get('id');
  
  const body = await request.json();
  const user = await db.user.update({
    where: { id },
    data: body
  });
  
  return NextResponse.json(user);
}
```

## Server Actions

```ts
// app/actions.ts
'use server';

import { revalidatePath } from 'next/cache';

export async function createUser(formData: FormData) {
  const name = formData.get('name');
  
  await db.user.create({
    data: { name: String(name) }
  });
  
  revalidatePath('/users');
}

// Usage in component
<form action={createUser}>
  <input name="name" />
  <button type="submit">Create</button>
</form>
```

## Loading UI

```tsx
// app/users/loading.tsx
export default function Loading() {
  return <div>Loading...</div>;
}
```

## Error UI

```tsx
// app/users/error.tsx
'use client';

export default function Error({ reset }: { reset: () => void }) {
  return (
    <div>
      <h2>Something went wrong!</h2>
      <button onClick={() => reset()}>Try again</button>
    </div>
  );
}
```

## Middleware

```ts
// middleware.ts
import { NextResponse } from 'next/server';
import type { NextRequest } from 'next/server';

export function middleware(request: NextRequest) {
  const token = request.cookies.get('token');
  
  if (!token && request.nextUrl.pathname.startsWith('/dashboard')) {
    return NextResponse.redirect(new URL('/login', request.url));
  }
  
  return NextResponse.next();
}

export const config = {
  matcher: ['/dashboard/:path*'],
};
```

## Image Optimization

```tsx
import Image from 'next/image';

export default function MyPage() {
  return (
    <Image
      src="/hero.jpg"
      alt="Hero"
      width={800}
      height={600}
      priority
    />
  );
}
```

## Static Site Generation (SSG)

```tsx
export async function generateStaticParams() {
  const posts = await getPosts();
  return posts.map((post) => ({ slug: post.slug }));
}

export default async function Page({ params }: { params: { slug: string } }) {
  const post = await getPost(params.slug);
  return <article>{post.content}</article>;
}
```

## Incremental Static Regeneration (ISR)

```tsx
export const revalidate = 60; // Revalidate every 60 seconds

export default async function Page() {
  const data = await fetchData();
  return <div>{data.content}</div>;
}
```

## Server Components vs Client Components

| Server Components | Client Components |
|-----------------|-------------------|
| Default in App Router | Use 'use client' directive |
| No interactivity | Interactive (onClick, useState) |
| Fetch data directly | UseEffect for data |
| Smaller bundle | Larger bundle |
| SEO friendly | Not SEO friendly |

## Data Fetching

```tsx
// Parallel fetching
const [users, posts] = await Promise.all([
  fetch('/api/users').then(res => res.json()),
  fetch('/api/posts').then(res => res.json())
]);

// Sequential fetching
const user = await fetchUser(id);
const posts = await fetchPosts(user.id);

// Streaming
import { Suspense } from 'react';

<Suspense fallback={<Loading />}>
  <Comments />
</Suspense>
```

## Environment Variables

```bash
# .env.local (client-safe)
NEXT_PUBLIC_API_URL=https://api.example.com

# .env (server-only)
DATABASE_URL=postgresql://...
API_SECRET=secret
```

## Styling (Tailwind)

```tsx
export default function MyComponent() {
  return (
    <div className="flex flex-col gap-4 p-4">
      <h1 className="text-2xl font-bold">Title</h1>
      <button className="bg-blue-500 hover:bg-blue-600 text-white px-4 py-2 rounded">
        Click me
      </button>
    </div>
  );
}
```

## Metadata API

```tsx
import { Metadata } from 'next';

export const metadata: Metadata = {
  title: {
    default: 'My App',
    template: '%s | My App'
  },
  description: 'Description here',
  openGraph: {
    title: 'My App',
    description: 'Description here',
    images: ['/og-image.jpg'],
  },
};

export viewport = {
  width: 'device-width',
  initialScale: 1,
};
```

## Performance Checklist

- [ ] Use Server Components by default
- [ ] Mark interactive components with 'use client'
- [ ] Use next/image for images
- [ ] Use next/font for fonts
- [ ] Implement proper caching strategies
- [ ] Use generateStaticParams for SSG
- [ ] Use Suspense for streaming
