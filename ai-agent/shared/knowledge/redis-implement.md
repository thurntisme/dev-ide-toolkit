# Redis Implementation Patterns

Common Redis patterns and implementations.

---

## Connection

### PHP Redis Connection

```php
function get_redis_connection() {
    $redis = new Redis();
    $redis->connect('127.0.0.1', 6379);
    // $redis->auth('password');
    return $redis;
}
```

---

### Laravel Redis

```php
Redis::connection('default');
// or
Redis::get('key');
```

---

## String Operations

### Basic Get/Set

```php
$redis = get_redis_connection();

// Set value
$redis->set('user:1:name', 'John');
$redis->set('user:1:name', 'John', 3600); // with TTL

// Get value
$name = $redis->get('user:1:name');

// Mget/MSET
$redis->mset(['key1' => 'value1', 'key2' => 'value2']);
$values = $redis->mget(['key1', 'key2']);
```

---

### Increment/Decrement

```php
$redis->set('counter', 10);
$redis->incr('counter');     // 11
$redis->incrBy('counter', 5); // 16
$redis->decr('counter');    // 15
$redis->decrBy('counter', 5); // 10
```

---

## List Operations

### Push/Pop

```php
$redis->rPush('queue:tasks', json_encode(['task' => 'send_email']));
$redis->lPush('queue:tasks', json_encode(['task' => 'process']));

// Pop
$task = $redis->lPop('queue:tasks');
$task = $redis->rPop('queue:tasks');

// Get range
$tasks = $redis->lRange('queue:tasks', 0, -1);
```

---

### List Length

```php
$length = $redis->lLen('queue:tasks');
```

---

## Set Operations

### Set Operations

```php
$redis->sAdd('users:online', 'user1');
$redis->sAdd('users:online', 'user2', 'user3');

// Get all members
$members = $redis->sMembers('users:online');

// Check member exists
$exists = $redis->sIsMember('users:online', 'user1');

// Remove member
$redis->sRem('users:online', 'user1');

// Set operations
$redis->sUnion('set1', 'set2');           // Union
$redis->sInter('set1', 'set2');            // Intersection
$redis->sDiff('set1', 'set2');            // Difference
```

---

## Sorted Set (ZSet)

### Leaderboard

```php
$redis->zAdd('leaderboard', ['user1' => 100, 'user2' => 200, 'user3' => 150]);

// Get rank (0 = highest)
$rank = $redis->zRevRank('leaderboard', 'user1');
$score = $redis->zScore('leaderboard', 'user1');

// Get top N
$top = $redis->zRevRange('leaderboard', 0, 9, ['WITHSCORES' => true]);

// Update score
$redis->zIncrBy('leaderboard', 50, 'user1');
```

---

## Hash Operations

### Hash Get/Set

```php
$redis->hSet('user:1', 'name', 'John');
$redis->hSet('user:1', 'email', 'john@example.com');
$redis->hMSet('user:1', ['name' => 'John', 'email' => 'john@example.com']);

// Get single field
$name = $redis->hGet('user:1', 'name');

// Get all fields
$user = $redis->hGetAll('user:1');

// Get multiple fields
$data = $redis->hMGet('user:1', ['name', 'email']);

// Delete field
$redis->hDel('user:1', 'email');

// Check field exists
$exists = $redis->hExists('user:1', 'email');
```

---

## Keys and TTL

### Key Operations

```php
// Set with TTL (seconds)
$redis->setex('cache:key', 3600, 'value');

// Set with TTL (PX = milliseconds)
$redis->psetex('cache:key', 3600000, 'value');

// Get TTL
$ttl = $redis->ttl('cache:key');    // -1 = no expiry, -2 = doesn't exist

// Set expire
$redis->expire('key', 3600);

// Remove expire
$redis->persist('key');

// Delete keys
$redis->del('key1', 'key2');
$redis->del(['key1', 'key2']);

// Find keys
$keys = $redis->keys('user:*');
```

---

## Pub/Sub

### Publisher

```php
$redis = get_redis_connection();
$redis->publish('notifications', json_encode([
    'type' => 'new_message',
    'data' => ['user' => 'john', 'message' => 'Hello']
]));
```

---

### Subscriber

```php
$redis = get_redis_connection();
$redis->subscribe(['notifications'], function($redis, $channel, $message) {
    $data = json_decode($message, true);
    // Handle notification
});
```

---

## Cache Patterns

### Cache Aside

```php
function get_user($user_id) {
    $redis = get_redis_connection();
    $cache_key = "user:$user_id";

    // Check cache
    $cached = $redis->get($cache_key);
    if ($cached) {
        return json_decode($cached, true);
    }

    // Fetch from database
    $user = db_fetch("SELECT * FROM users WHERE id = ?", [$user_id]);

    // Store in cache (1 hour)
    $redis->setex($cache_key, 3600, json_encode($user));

    return $user;
}

function invalidate_user($user_id) {
    $redis = get_redis_connection();
    $redis->del("user:$user_id");
}
```

---

### Distributed Lock

```php
function acquire_lock($lock_name, $timeout = 10) {
    $redis = get_redis_connection();
    $lock_key = "lock:$lock_name";
    $token = uniqid();

    $acquired = $redis->set($lock_key, $token, ['NX', 'EX' => $timeout]);
    return $acquired ? $token : false;
}

function release_lock($lock_name, $token) {
    $redis = get_redis_connection();
    $lock_key = "lock:$lock_name";

    // Check and delete (atomic)
    $script = "
        if redis.call('get', KEYS[1]) == ARGV[1] then
            return redis.call('del', KEYS[1])
        else
            return 0
        end
    ";
    return $redis->eval($script, [$lock_key, $token], 1);
}
```

---

### Rate Limiting

```php
function rate_limit($key, $limit = 60, $window = 60) {
    $redis = get_redis_connection();
    $now = time();
    $window_start = $now - $window;

    // Remove old entries
    $redis->zRemRangeByScore($key, 0, $window_start);

    // Count requests
    $count = $redis->zCard($key);

    if ($count >= $limit) {
        return false;
    }

    // Add current request
    $redis->zAdd($key, [$now => $now]);

    return true;
}
```

---

## Session Storage

### PHP Session

```php
function save_session($session_id, $data, $ttl = 3600) {
    $redis = get_redis_connection();
    $redis->setex("session:$session_id", $ttl, json_encode($data));
}

function get_session($session_id) {
    $redis = get_redis_connection();
    $data = $redis->get("session:$session_id");
    return $data ? json_decode($data, true) : null;
}

function destroy_session($session_id) {
    $redis = get_redis_connection();
    $redis->del("session:$session_id");
}
```

---

## Real-time Features

### Online Users

```php
function set_user_online($user_id) {
    $redis = get_redis_connection();
    $redis->zAdd('users:online', [time() => $user_id]);
}

function get_online_users() {
    $redis = get_redis_connection();
    $redis->zRemRangeByScore('users:online', 0, time() - 300); // 5 min timeout
    return $redis->zRange('users:online', 0, -1);
}

function is_user_online($user_id) {
    $redis = get_redis_connection();
    return $redis->zScore('users:online', $user_id) !== false;
}
```

---

### Recent Activity

```php
function add_recent_activity($user_id, $activity) {
    $redis = get_redis_connection();
    $key = "recent:$user_id";
    $redis->lPush($key, json_encode($activity));
    $redis->lTrim($key, 0, 49); // Keep 50 items
    $redis->expire($key, 86400);
}

function get_recent_activity($user_id, $limit = 10) {
    $redis = get_redis_connection();
    $activities = $redis->lRange("recent:$user_id", 0, $limit - 1);
    return array_map('json_decode', $activities);
}
```