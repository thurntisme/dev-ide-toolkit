---
name: laravel-queues
description: Laravel queues and jobs specialist. Use when user asks about queue workers, jobs, dispatching, or background processing.
---

# Laravel Queues & Jobs

## When to use
- User asks about Laravel queues
- User asks about background job processing
- User asks about job dispatching
- User asks about queue workers

## Queue Configuration

```php
// config/queue.php
return [
    'default' => env('QUEUE_CONNECTION', 'database'),
    
    'connections' => [
        'sync' => [
            'driver' => 'sync',
        ],
        
        'database' => [
            'driver' => 'database',
            'table' => 'jobs',
            'queue' => 'default',
            'retry_after' => 90,
        ],
        
        'redis' => [
            'driver' => 'redis',
            'connection' => 'default',
            'queue' => env('REDIS_QUEUE', 'default'),
            'retry_after' => 90,
            'block_for' => null,
        ],
        
        'sqs' => [
            'driver' => 'sqs',
            'key' => env('AWS_ACCESS_KEY_ID'),
            'secret' => env('AWS_SECRET_ACCESS_KEY'),
            'prefix' => env('SQS_PREFIX'),
            'queue' => env('SQS_QUEUE'),
        ],
    ],
    
    'batching' => [
        'database' => env('DB_CONNECTION', 'mysql'),
        'table' => 'job_batches',
    ],
    
    'failed' => [
        'driver' => 'database-uuuid',
        'database' => env('DB_CONNECTION', 'mysql'),
        'table' => 'failed_jobs',
    ],
];
```

## Creating Jobs

### Basic Job

```php
<?php

namespace App\Jobs;

use App\Models\User;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;

class SendWelcomeEmail implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;
    
    public int $tries = 3;
    public int $backoff = 60;
    public int $timeout = 120;
    
    public function __construct(
        public User $user
    ) {}
    
    public function handle(): void
    {
        Mail::to($this->user)->send(new WelcomeEmail($this->user));
    }
    
    public function failed(\Throwable $exception): void
    {
        Log::error('Welcome email failed', [
            'user_id' => $this->user->id,
            'error' => $exception->getMessage(),
        ]);
    }
}
```

### Job with Multiple Attempts

```php
<?php

namespace App\Jobs;

use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;

class ProcessVideo implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;
    
    public int $tries = 5;
    public array $backoff = [10, 60, 300, 600, 1800];
    public int $timeout = 3600;
    
    public function __construct(
        public string $videoId,
        public string $userId
    ) {}
    
    public function handle(): void
    {
        $video = Video::find($this->videoId);
        
        if (!$video) {
            $this->fail(new \Exception('Video not found'));
            return;
        }
        
        $video->process();
    }
    
    public function retryUntil(): \DateTime
    {
        return now()->addHours(1);
    }
}
```

## Dispatching Jobs

### Basic Dispatch

```php
// Dispatch immediately
SendWelcomeEmail::dispatch($user);

// Dispatch to specific queue
SendWelcomeEmail::dispatch($user)->onQueue('emails');

// Dispatch to specific connection
SendWelcomeEmail::dispatch($user)->onConnection('redis');

// Chain jobs
ProcessOrder::dispatch($order)
    ->onConnection('redis')
    ->onQueue('orders')
    ->delay(now()->addMinutes(5))
    ->dispatch();

// Dispatch sync (immediately)
SendWelcomeEmail::dispatchSync($user);

// Conditional dispatch
SendWelcomeEmail::dispatchIf($shouldSend, $user);
SendWelcomeEmail::dispatchUnless($shouldNotSend, $user);
```

### Job Chains

```php
// Sequential chain
ProcessOrder::dispatch($order)
    ->chain([
        new SendOrderConfirmation($order),
        new UpdateInventory($order),
        new NotifyAdmin($order),
    ]);

// Chain with delay between jobs
ProcessOrder::dispatch($order)
    ->delay(now()->addSeconds(10))
    ->chain([
        new SendOrderConfirmation($order),
    ])
    ->chainConnection('redis')
    ->chainQueue('high-priority');

// On queue chains
Bus::chain([
    new Job1,
    new Job2,
    new Job3,
])->dispatch();
```

### Job Batching

```php
use Illuminate\Bus\Batch;
use Illuminate\Support\Facades\Bus;

$batch = Bus::batch([
    new ImportCsv(1),
    new ImportCsv(2),
    new ImportCsv(3),
    new ImportCsv(4),
    new ImportCsv(5),
])->then(function (Batch $batch) {
    // All jobs completed
    Log::info('All imports completed', ['batch_id' => $batch->id]);
})->catch(function (Batch $batch, \Throwable $e) {
    // First job failure
    Log::error('Batch failed', ['batch_id' => $batch->id]);
})->finally(function (Batch $batch) {
    // Always runs
})->dispatch();

// Check batch progress
$batch = Bus::findBatch($batch->id);
$batch->progress(); // Returns percentage
$batch->totalJobs();
$batch->pendingJobs();
$batch->failedJobs();
$batch->succeeded();
```

### Job Middleware

```php
// Rate limiting middleware
class RateLimited implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;
    
    public int $tries = 3;
    public int $timeout = 60;
    
    public function middleware(): array
    {
        return [new RateLimited(RateLimiter::class, 'emails')];
    }
}

// Custom middleware
class PreventOverlapping implements ShouldQueue
{
    public function middleware(): array
    {
        return [new WithoutOverlapping($this->order->id)];
    }
}

// In Job
public function middleware(): array
{
    return [
        new RateLimited,
        new Timeout(60),
    ];
}
```

## Queue Workers

### Running Workers

```bash
# Basic worker
php artisan queue:work

# Multiple workers
php artisan queue:work --queue=high,default,low

# Redis connection
php artisan queue:work redis --queue=high,default

# With retry
php artisan queue:work --tries=3 --backoff=60

# Supervisor config (supervisord.conf)
[program:laravel-worker]
process_name=%(program_name)s_%(process_num)02d
command=php /var/www/html/artisan queue:work redis --queue=high,default --sleep=3 --tries=3
autostart=true
autorestart=true
stopasgroup=true
killasgroup=true
user=www-data
numprocs=4
redirect_stderr=true
stdout_logfile=/var/log/worker.log
stopwaitsecs=3600
```

### Queue Commands

```bash
# Work once (for cron)
php artisan queue:work --once

# Listen mode (auto-reload on code changes)
php artisan queue:listen

# Work with timeout
php artisan queue:work --timeout=60

# Work with memory limit
php artisan queue:work --memory=128

# Work with sleep
php artisan queue:work --sleep=3 --tries=3

# Restart workers on code changes
php artisan queue:work --restart-runtime
```

## Failed Jobs

### Configuration

```bash
# Create failed jobs table
php artisan queue:failed-table

# Create failed jobs table with UUID
php artisan queue:failed-table --uuids=true

# Run migrations
php artisan migrate
```

### Failed Job Handling

```php
// config/queue.php
'failed' => [
    'driver' => 'database-uuuid',
    'database' => env('DB_CONNECTION', 'mysql'),
    'table' => 'failed_jobs',
],
```

### Failed Job Callbacks

```php
// app/Providers/AppServiceProvider.php
use Illuminate\Support\Facades\Queue;
use Illuminate\Queue\Events\JobFailed;

public function boot(): void
{
    Queue::failing(function (JobFailed $event) {
        $job = $event->job;
        $exception = $event->exception;
        
        Log::error('Job failed', [
            'job' => $job->payload()['displayName'],
            'connection' => $event->connectionName,
            'queue' => $event->queue,
            'error' => $exception->getMessage(),
        ]);
        
        // Notify admin
        Notification::route('slack', config('services.slack.webhook'))
            ->notify(new JobFailedNotification($job, $exception));
    });
}
```

### Retrying Failed Jobs

```bash
# List failed jobs
php artisan queue:failed

# Retry all failed jobs
php artisan queue:retry --all

# Retry specific job
php artisan queue:retry 550e8400-e29b-41d4-a716-446655440000

# Retry jobs by queue
php artisan queue:retry --queue=high

# Forget (delete) failed job
php artisan queue:forget 550e8400-e29b-41d4-a716-446655440000

# Flush all failed jobs
php artisan queue:flush
```

## Job Events

```php
use Illuminate\Support\Facades\Queue;
use Illuminate\Queue\Events\JobProcessed;
use Illuminate\Queue\Events\JobProcessing;
use Illuminate\Queue\Events\JobQueued;

public function boot(): void
{
    // Before job processes
    Queue::before(function (JobProcessing $event) {
        Log::info('Job starting', [
            'connection' => $event->connection,
            'job' => $event->job->payload()['displayName'],
        ]);
    });
    
    // After job processed
    Queue::after(function (JobProcessed $event) {
        Log::info('Job completed', [
            'connection' => $event->connection,
            'job' => $event->job->payload()['displayName'],
        ]);
    });
    
    // When job is queued
    Queue::creating(function (JobQueued $event) {
        // Before job is queued
    });
}
```

## Jobs with Models

### Serialize Models

```php
// Models are automatically serialized
public function __construct(
    public User $user,
    public Order $order
) {}

// Access in handle()
public function handle(): void
{
    $this->user->notify(new OrderShipped($this->order));
}
```

### Load Relations

```php
class ProcessOrder implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;
    
    public array $relations = ['items', 'customer', 'shippingAddress'];
    
    public function __construct(
        public Order $order
    ) {}
    
    public function handle(): void
    {
        // Relations are auto-loaded
        foreach ($this->order->items as $item) {
            // Process item
        }
    }
}
```

## Controller with Jobs

```php
<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use App\Jobs\SendWelcomeEmail;
use App\Jobs\ProcessUpload;
use Illuminate\Http\Request;

class UserController extends Controller
{
    public function store(Request $request): RedirectResponse
    {
        $user = User::create($request->validated());
        
        // Dispatch job (fire and forget)
        SendWelcomeEmail::dispatch($user);
        
        return redirect()->route('users.show', $user);
    }
    
    public function upload(Request $request): JsonResponse
    {
        $request->validate([
            'file' => 'required|file|max:102400',
        ]);
        
        $path = $request->file('file')->store('uploads');
        
        // Dispatch with path
        ProcessUpload::dispatch($path, $request->user());
        
        return response()->json([
            'message' => 'Upload queued for processing',
            'path' => $path,
        ], 202);
    }
}
```

## Supervisor Configuration

```ini
; /etc/supervisor/conf.d/laravel.conf

[program:laravel-worker-high]
process_name=%(program_name)s_%(process_num)02d
command=php /var/www/html/artisan queue:work redis --queue=high --sleep=3 --tries=3 --max-time=3600
autostart=true
autorestart=true
stopasgroup=true
killasgroup=true
user=www-data
numprocs=2
redirect_stderr=true
stdout_logfile=/var/log/laravel-worker-high.log
stopwaitsecs=3600

[program:laravel-worker-default]
process_name=%(program_name)s_%(process_num)02d
command=php /var/www/html/artisan queue:work redis --queue=default,emails,notifications --sleep=3 --tries=3 --max-time=3600
autostart=true
autorestart=true
stopasgroup=true
killasgroup=true
user=www-data
numprocs=4
redirect_stderr=true
stdout_logfile=/var/log/laravel-worker-default.log
stopwaitsecs=3600
```
