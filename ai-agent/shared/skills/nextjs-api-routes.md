---
name: nextjs-api-routes
description: Next.js API routes and server actions specialist. Use when user asks about Next.js API routes, server actions, or backend integration.
---

# Next.js API Routes & Server Actions

## When to use
- User asks about Next.js API routes
- User asks about server actions
- User asks about data fetching patterns
- User asks about form handling

## App Router API Routes

```ts
// app/api/users/route.ts
import { NextRequest, NextResponse } from 'next/server';
import { db } from '@/lib/db';

export async function GET(request: NextRequest) {
  const { searchParams } = new URL(request.url);
  const page = searchParams.get('page') || '1';
  const limit = searchParams.get('limit') || '10';

  const users = await db.user.findMany({
    skip: (Number(page) - 1) * Number(limit),
    take: Number(limit),
    orderBy: { createdAt: 'desc' },
  });

  const total = await db.user.count();

  return NextResponse.json({
    users,
    pagination: {
      page: Number(page),
      limit: Number(limit),
      total,
      pages: Math.ceil(total / Number(limit)),
    },
  });
}

export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    
    const { name, email, password } = body;

    if (!name || !email || !password) {
      return NextResponse.json(
        { error: 'Missing required fields' },
        { status: 400 }
      );
    }

    const existingUser = await db.user.findUnique({
      where: { email },
    });

    if (existingUser) {
      return NextResponse.json(
        { error: 'User already exists' },
        { status: 409 }
      );
    }

    const user = await db.user.create({
      data: { name, email, password },
    });

    return NextResponse.json(user, { status: 201 });
  } catch (error) {
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    );
  }
}
```

## Dynamic API Routes

```ts
// app/api/users/[id]/route.ts
import { NextRequest, NextResponse } from 'next/server';

interface Params {
  params: { id: string };
}

export async function GET(request: NextRequest, { params }: Params) {
  const user = await db.user.findUnique({
    where: { id: params.id },
  });

  if (!user) {
    return NextResponse.json(
      { error: 'User not found' },
      { status: 404 }
    );
  }

  return NextResponse.json(user);
}

export async function PUT(request: NextRequest, { params }: Params) {
  const body = await request.json();

  const user = await db.user.update({
    where: { id: params.id },
    data: body,
  });

  return NextResponse.json(user);
}

export async function DELETE(request: NextRequest, { params }: Params) {
  await db.user.delete({
    where: { id: params.id },
  });

  return NextResponse.json({ success: true });
}
```

## Route Handlers with Validation

```ts
// Using Zod for validation
import { z } from 'zod';

const userSchema = z.object({
  name: z.string().min(2),
  email: z.string().email(),
  age: z.number().min(0).optional(),
});

export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    const validatedData = userSchema.parse(body);

    const user = await db.user.create({
      data: validatedData,
    });

    return NextResponse.json(user, { status: 201 });
  } catch (error) {
    if (error instanceof z.ZodError) {
      return NextResponse.json(
        { error: error.errors },
        { status: 400 }
      );
    }
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    );
  }
}
```

## Server Actions

```ts
// app/actions.ts
'use server';

import { revalidatePath, revalidateTag } from 'next/cache';
import { redirect } from 'next/navigation';
import { db } from '@/lib/db';
import { auth } from '@/lib/auth';
import { z } from 'zod';

const createUserSchema = z.object({
  name: z.string().min(2),
  email: z.string().email(),
});

export async function createUser(formData: FormData) {
  const session = await auth();
  
  if (!session) {
    return { error: 'Unauthorized' };
  }

  const rawData = {
    name: formData.get('name'),
    email: formData.get('email'),
  };

  const validatedData = createUserSchema.safeParse(rawData);

  if (!validatedData.success) {
    return { error: validatedData.error.errors };
  }

  try {
    const user = await db.user.create({
      data: validatedData.data,
    });

    revalidatePath('/users');
    revalidateTag('users');

    return { success: true, user };
  } catch (error) {
    return { error: 'Failed to create user' };
  }
}

export async function deleteUser(userId: string) {
  const session = await auth();
  
  if (!session) {
    return { error: 'Unauthorized' };
  }

  try {
    await db.user.delete({
      where: { id: userId },
    });

    revalidatePath('/users');

    return { success: true };
  } catch (error) {
    return { error: 'Failed to delete user' };
  }
}
```

## Form with Server Actions

```tsx
// components/user-form.tsx
'use client';

import { createUser } from '@/app/actions';
import { useFormStatus } from 'react-dom';

function SubmitButton() {
  const { pending } = useFormStatus();

  return (
    <button type="submit" disabled={pending}>
      {pending ? 'Creating...' : 'Create User'}
    </button>
  );
}

export function UserForm() {
  return (
    <form action={createUser}>
      <div>
        <label htmlFor="name">Name</label>
        <input type="text" id="name" name="name" required />
      </div>
      <div>
        <label htmlFor="email">Email</label>
        <input type="email" id="email" name="email" required />
      </div>
      <SubmitButton />
    </form>
  );
}
```

## Optimistic Updates

```tsx
'use client';

import { useOptimistic, startTransition } from 'react';
import { updateUser } from '@/app/actions';

type User = {
  id: string;
  name: string;
  email: string;
};

type ActionState = {
  error?: string;
  success?: boolean;
};

export function OptimisticUser({ user }: { user: User }) {
  const [optimisticUser, setOptimisticUser] = useOptimistic(
    user,
    (state, newName: string) => ({ ...state, name: newName })
  );

  const handleUpdate = async (formData: FormData) => {
    const newName = formData.get('name') as string;

    startTransition(() => {
      setOptimisticUser(newName);
    });

    await updateUser(user.id, { name: newName });
  };

  return (
    <div>
      <p>{optimisticUser.name}</p>
      <form action={handleUpdate}>
        <input type="text" name="name" defaultValue={user.name} />
        <button type="submit">Update</button>
      </form>
    </div>
  );
}
```

## API with Cookies & Headers

```ts
export async function GET(request: NextRequest) {
  const token = request.cookies.get('auth-token')?.value;

  if (!token) {
    return NextResponse.json(
      { error: 'Unauthorized' },
      { status: 401 }
    );
  }

  const response = await fetchProtectedData(token);

  const data = await response.json();

  const res = NextResponse.json(data);

  res.cookies.set('auth-token', token, {
    httpOnly: true,
    secure: process.env.NODE_ENV === 'production',
    sameSite: 'strict',
    maxAge: 60 * 60 * 24 * 7,
  });

  return res;
}
```

## Streaming with Server Components

```tsx
// app/dashboard/page.tsx
import { Suspense } from 'react';

async function Stats() {
  const stats = await fetchStats();
  return <StatsDisplay stats={stats} />;
}

async function RecentActivity() {
  const activity = await fetchActivity();
  return <ActivityList activity={activity} />;
}

export default function Dashboard() {
  return (
    <div>
      <h1>Dashboard</h1>
      <Suspense fallback={<StatsSkeleton />}>
        <Stats />
      </Suspense>
      <Suspense fallback={<ActivitySkeleton />}>
        <RecentActivity />
      </Suspense>
    </div>
  );
}
```

## CORS Headers

```ts
// app/api/data/route.ts
export async function GET(request: NextRequest) {
  const response = NextResponse.json({ data: 'test' });

  response.headers.set('Access-Control-Allow-Origin', 'https://example.com');
  response.headers.set('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE');
  response.headers.set('Access-Control-Allow-Headers', 'Content-Type, Authorization');

  return response;
}

export async function OPTIONS() {
  return new NextResponse(null, {
    status: 204,
    headers: {
      'Access-Control-Allow-Origin': 'https://example.com',
      'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE',
      'Access-Control-Allow-Headers': 'Content-Type, Authorization',
      'Access-Control-Max-Age': '86400',
    },
  });
}
```

## Error Handling

```ts
export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    
    const user = await db.user.create({
      data: body,
    });

    return NextResponse.json(user, { status: 201 });
  } catch (error) {
    console.error('Error creating user:', error);

    if (error instanceof Prisma.PrismaClientKnownRequestError) {
      if (error.code === 'P2002') {
        return NextResponse.json(
          { error: 'User with this email already exists' },
          { status: 409 }
        );
      }
    }

    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    );
  }
}
```

## Rate Limiting

```ts
import { NextRequest, NextResponse } from 'next/server';
import { ratelimit } from '@/lib/ratelimit';

export async function POST(request: NextRequest) {
  const ip = request.ip ?? 'anonymous';
  
  const { success, limit, reset, remaining } = await ratelimit.limit(ip);

  const headers = {
    'X-RateLimit-Limit': limit.toString(),
    'X-RateLimit-Remaining': remaining.toString(),
    'X-RateLimit-Reset': reset.toString(),
  };

  if (!success) {
    return NextResponse.json(
      { error: 'Too many requests' },
      { status: 429, headers }
    );
  }

  return NextResponse.json(
    { success: true },
    { headers }
  );
}
```

## Upload Handler

```ts
import { NextRequest, NextResponse } from 'next/server';
import { writeFile, mkdir } from 'fs/promises';
import path from 'path';

export async function POST(request: NextRequest) {
  const formData = await request.formData();
  const file = formData.get('file') as File;

  if (!file) {
    return NextResponse.json(
      { error: 'No file uploaded' },
      { status: 400 }
    );
  }

  const bytes = await file.arrayBuffer();
  const buffer = Buffer.from(bytes);

  const uploadDir = path.join(process.cwd(), 'public', 'uploads');
  await mkdir(uploadDir, { recursive: true });

  const filename = `${Date.now()}-${file.name}`;
  const filepath = path.join(uploadDir, filename);

  await writeFile(filepath, buffer);

  return NextResponse.json({
    success: true,
    url: `/uploads/${filename}`,
  });
}
```
