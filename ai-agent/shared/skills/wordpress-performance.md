---
name: wordpress-performance
description: WordPress performance optimization specialist. Use when user asks about speeding up WordPress, optimizing database, caching, or reducing page load time.
---

# WordPress Performance Optimization

## When to use
- User asks about WordPress speed optimization
- User asks about caching setup
- User asks about database optimization
- User asks about image optimization
- User asks about reducing page load time
- User asks about Core Web Vitals improvements

## Performance Checklist

- [ ] Use a quality hosting provider
- [ ] Install a caching plugin
- [ ] Optimize images (WebP, lazy loading)
- [ ] Minify CSS/JS files
- [ ] Use a CDN
- [ ] Database optimization
- [ ] Remove unused plugins/themes
- [ ] Keep WordPress updated
- [ ] Use lightweight themes
- [ ] Implement lazy loading

## Caching

### Object Caching

```php
// Transients (stored in database)
set_transient('my_data', $data, HOUR_IN_SECONDS);
$cached = get_transient('my_data');
delete_transient('my_data');

// With site-wide transients (multisite)
set_site_transient('my_data', $data, HOUR_IN_SECONDS);
get_site_transient('my_data');

// Cache API (uses object cache backend)
wp_cache_set('key', $data, 'my_group', HOUR_IN_SECONDS);
$cached = wp_cache_get('key', 'my_group');
wp_cache_delete('key', 'my_group');
wp_cache_flush(); // Clear all cache
```

### Transient Example

```php
// Cache expensive query
function get_expensive_data() {
    $cached = get_transient('expensive_data_cache');
    
    if (false === $cached) {
        // Query database
        $args = ['posts_per_page' => -1, 'meta_key' => 'views'];
        $cached = get_posts($args);
        
        // Cache for 1 hour
        set_transient('expensive_data_cache', $cached, HOUR_IN_SECONDS);
    }
    
    return $cached;
}

// Clear on update
add_action('save_post', function($post_id) {
    delete_transient('expensive_data_cache');
});
```

## Database Optimization

### Clean Transients

```php
// Delete expired transients
add_action('wp_scheduled_delete', function() {
    global $wpdb;
    
    $expired = $wpdb->get_col(
        "SELECT option_name FROM {$wpdb->options} 
        WHERE option_name LIKE '_transient_timeout_%' 
        AND option_value < " . time()
    );
    
    foreach ($expired as $transient) {
        $key = str_replace('_transient_timeout_', '', $transient);
        delete_transient($key);
    }
});
```

### Clean Post Revisions

```php
// Limit post revisions
define('WP_POST_REVISIONS', 3);

// Or disable completely
define('WP_POST_REVISIONS', false);

// Delete existing revisions
function delete_all_revisions() {
    global $wpdb;
    
    $revision_ids = $wpdb->get_col(
        "SELECT ID FROM {$wpdb->posts} WHERE post_type = 'revision'"
    );
    
    foreach ($revision_ids as $revision_id) {
        wp_delete_post_revision($revision_id);
    }
}

// Schedule cleanup
if (!wp_next_scheduled('daily_revision_cleanup')) {
    wp_schedule_event(time(), 'daily', 'daily_revision_cleanup');
}
add_action('daily_revision_cleanup', 'delete_all_revisions');
```

### Clean Auto-Drafts

```php
function delete_auto_drafts() {
    global $wpdb;
    
    $wpdb->query(
        "DELETE FROM {$wpdb->posts} 
        WHERE post_status = 'auto-draft' 
        AND post_date < DATE_SUB(NOW(), INTERVAL 7 DAY)"
    );
}
```

### Clean Spam Comments

```php
function delete_spam_comments() {
    global $wpdb;
    
    $spam_count = $wpdb->get_var(
        "SELECT COUNT(*) FROM {$wpdb->comments} WHERE comment_approved = 'spam'"
    );
    
    if ($spam_count > 0) {
        $wpdb->query(
            "DELETE FROM {$wpdb->comments} WHERE comment_approved = 'spam'"
        );
        $wpdb->query(
            "OPTIMIZE TABLE {$wpdb->comments}"
        );
    }
}
```

### Database Tables Optimization

```php
function optimize_database_tables() {
    global $wpdb;
    
    $tables = $wpdb->get_results('SHOW TABLES');
    
    foreach ($tables as $table) {
        foreach ($table as $table_name) {
            $wpdb->query("OPTIMIZE TABLE {$table_name}");
        }
    }
}
```

### Clean wp_options

```php
// Autoloaded options cleanup
function cleanup_autoloaded_options() {
    global $wpdb;
    
    // Find large autoloaded options
    $large_options = $wpdb->get_results(
        "SELECT option_name, LENGTH(option_value) as size 
        FROM {$wpdb->options} 
        WHERE autoload = 'yes' 
        ORDER BY size DESC 
        LIMIT 20"
    );
    
    return $large_options;
}

// Remove unnecessary autoload
$wpdb->update(
    $wpdb->options,
    ['autoload' => 'no'],
    ['option_name' => 'my_large_option']
);
```

## Asset Optimization

### Disable Emojis

```php
remove_action('wp_head', 'print_emoji_detection_script', 7);
remove_action('wp_print_styles', 'print_emoji_styles');
add_filter('emoji_svg_url', '__return_false');
```

### Disable Embeds

```php
// Disable oEmbed
add_action('wp_enqueue_scripts', function() {
    wp_deregister_script('wp-embed');
});

// Disable embed functionality
add_filter('embed_oembed_discover', '__return_false');
add_filter('oembed_dataparse', '__return_false');
remove_action('rest_api_init', 'wp_oembed_register_route');
remove_filter('oembed_response_data', 'get_oembed_response_data');
remove_action('wp_head', 'wp_oembed_add_discovery_links');
remove_action('wp_head', 'wp_oembed_add_host_js');
```

### Disable Dashicons

```php
add_action('wp_enqueue_scripts', function() {
    if (!current_user_can('edit_posts')) {
        wp_deregister_style('dashicons');
    }
});
```

### Dequeue Unused Scripts

```php
add_action('wp_enqueue_scripts', function() {
    // Remove on specific pages
    if (!is_page('contact')) {
        wp_dequeue_style('contact-form-7');
        wp_dequeue_script('contact-form-7');
    }
    
    // Remove on non-singular pages
    if (!is_singular()) {
        wp_dequeue_style('gallery-styles');
    }
}, 100);
```

### Lazy Loading

```php
// Add lazy loading to images
add_filter('the_content', function($content) {
    return str_replace(
        '<img ',
        '<img loading="lazy" ',
        $content
    );
});

// Add loading attribute to post thumbnails
add_filter('post_thumbnail_html', function($html) {
    if (empty($html)) return $html;
    return str_replace('src', 'loading="lazy" src', $html);
});
```

### Preload Critical Assets

```php
// Preload Google Fonts
add_action('wp_head', function() {
    echo '<link rel="preconnect" href="https://fonts.googleapis.com">';
    echo '<link rel="preload" as="style" href="https://fonts.googleapis.com/css2?family=Roboto&display=swap">';
}, 1);

// Async load styles
add_filter('style_loader_tag', function($tag, $handle, $href) {
    if ('my-plugin-style' !== $handle) {
        return $tag;
    }
    return str_replace(
        "rel='stylesheet'",
        "rel='preload' as='style' onload=\"this.onload=null;this.rel='stylesheet'\"",
        $tag
    );
}, 10, 3);

// Defer non-critical JS
add_filter('script_loader_tag', function($tag, $handle) {
    $defer_scripts = ['jquery-core', 'jquery-migrate', 'comment-reply'];
    
    if (!in_array($handle, $defer_scripts)) {
        return $tag;
    }
    
    return str_replace(' src', ' defer src', $tag);
}, 10, 2);
```

### Minification (Manual)

```php
// Minify HTML output
add_action('template_redirect', function() {
    ob_start('minify_html_output');
});

function minify_html_output($buffer) {
    $search = [
        '/\>[^\S]+/s',
        '/[^\S]+\</s',
        '/(\s)+/s',
    ];
    
    $replace = [
        '>',
        '<',
        '\\1',
    ];
    
    return preg_replace($search, $replace, $buffer);
}
```

## Query Optimization

### Use Transients for Queries

```php
function get_optimized_posts($args = []) {
    $cache_key = 'optimized_posts_' . md5(serialize($args));
    $cached = get_transient($cache_key);
    
    if ($cached !== false) {
        return $cached;
    }
    
    $query = new WP_Query($args);
    $results = $query->posts;
    
    set_transient($cache_key, $results, 12 * HOUR_IN_SECONDS);
    
    return $results;
}
```

### Optimize WP_Query

```php
// Select only needed fields
$query = new WP_Query([
    'post_type' => 'post',
    'posts_per_page' => 5,
    'fields' => 'ids', // Only get IDs
]);

// Use no_found_rows when pagination not needed
$query = new WP_Query([
    'no_found_rows' => true,
    'update_post_meta_cache' => false,
    'update_post_term_cache' => false,
]);

// Cache post meta
$query = new WP_Query([
    'update_post_meta_cache' => true,
    'update_post_term_cache' => true,
]);
```

### Use get_posts over query_posts

```php
// BAD - query_posts modifies main query
query_posts('posts_per_page=5');

// GOOD - get_posts uses separate query
$posts = get_posts([
    'posts_per_page' => 5,
    'post_status' => 'publish',
]);

// GOOD - pre_get_posts modifies main query
add_action('pre_get_posts', function($query) {
    if ($query->is_main_query() && !is_admin()) {
        $query->set('posts_per_page', 5);
    }
});
```

### Efficient Meta Queries

```php
// Index meta keys
function add_meta_key_index($keys = []) {
    global $wpdb;
    
    foreach ($keys as $key) {
        $wpdb->query(
            "CREATE INDEX IF NOT EXISTS idx_{$key} 
            ON {$wpdb->postmeta} (meta_key, meta_value(255))"
        );
    }
}

// Use meta_query efficiently
$query = new WP_Query([
    'meta_query' => [
        'relation' => 'AND',
        [
            'key' => 'featured',
            'value' => '1',
            'compare' => '=',
        ],
    ],
]);
```

## Image Optimization

### Generate Multiple Sizes

```php
// Add custom image size
add_image_size('thumbnail-square', 300, 300, true);
add_image_size('medium-large', 768, 0); // 0 = auto height

// Get specific size
$image_url = wp_get_attachment_image_src($attachment_id, 'thumbnail-square')[0];
```

### WebP Support

```php
// Serve WebP images
function serve_webp_image($image_url) {
    $webp_url = str_replace(['.jpg', '.jpeg', '.png'], '.webp', $image_url);
    
    if (file_exists(str_replace(home_url(), ABSPATH, $webp_url))) {
        return $webp_url;
    }
    
    return $image_url;
}
```

### Responsive Images

```php
// Generate srcset
$image_srcset = wp_get_attachment_image_srcset($attachment_id, 'large');
$image_sizes = wp_get_attachment_image_sizes($attachment_id, 'large');

echo '<img src="' . esc_url($image_url) . '" 
      srcset="' . esc_attr($image_srcset) . '" 
      sizes="' . esc_attr($image_sizes) . '"
      loading="lazy"
      alt="Image description">';
```

## CDN Integration

```php
// Rewrite URLs for CDN
function cdn_rewrite($url) {
    $cdn_url = 'https://cdn.yoursite.com';
    $upload_dir = wp_upload_dir();
    
    if (strpos($url, $upload_dir['baseurl']) !== false) {
        return str_replace($upload_dir['baseurl'], $cdn_url, $url);
    }
    
    return $url;
}

add_filter('wp_get_attachment_url', 'cdn_rewrite');
add_filter('stylesheet_directory_uri', function($stylesheet_dir) {
    return str_replace(home_url(), 'https://cdn.yoursite.com', $stylesheet_dir);
});
```

## PHP Performance

### Avoid Globals

```php
// BAD
global $post, $wpdb, $wp_query;

// GOOD - use function parameters
function process_post(WP_Post $post) {
    // process
}
```

### Use Closures

```php
// Register hooks with closures (PHP 7+)
add_action('init', function() {
    // do something
});
```

### Class Autoloading

```php
// Use spl_autoload_register
spl_autoload_register(function($class) {
    $prefix = 'MyPlugin\\';
    $base_dir = __DIR__ . '/includes/';
    
    $len = strlen($prefix);
    if (strncmp($prefix, $class, $len) !== 0) return;
    
    $relative_class = substr($class, $len);
    $file = $base_dir . str_replace('\\', '/', $relative_class) . '.php';
    
    if (file_exists($file)) require $file;
});
```

## Heartbeat API

```php
// Control Heartbeat
add_filter('heartbeat_settings', function($settings) {
    $settings['interval'] = 60; // Reduce to 1 minute
    return $settings;
});

// Disable on specific pages
add_action('admin_enqueue_scripts', function() {
    if (is_plugin_active('my-plugin/my-plugin.php')) {
        wp_deregister_script('heartbeat');
    }
});
```

## Cron Optimization

```php
// Use wp_next_scheduled
if (!wp_next_scheduled('my_daily_event')) {
    wp_schedule_event(time(), 'daily', 'my_daily_event');
}

add_action('my_daily_event', 'my_daily_function');

// Alternative: Use server cron instead of WordPress cron
define('DISABLE_WP_CRON', true);

// Schedule via server (crontab)
// */15 * * * * wget -q -O - https://yoursite.com/wp-cron.php?doing_cron > /dev/null 2>&1
```

## Object Cache

```php
// Use persistent object cache
// Configure in wp-config.php for Redis/Memcached

// Redis
define('WP_REDIS_HOST', '127.0.0.1');
define('WP_REDIS_PORT', 6379);
define('WP_CACHE', true);

// Memcached
// $memcached_servers = array('127.0.0.1:11211');
// define('WP_CACHE', true);

// Use cache consistently
function get_cached_data($key, $callback, $group = 'default', $expire = HOUR_IN_SECONDS) {
    $data = wp_cache_get($key, $group);
    
    if ($data === false) {
        $data = $callback();
        wp_cache_set($key, $data, $group, $expire);
    }
    
    return $data;
}
```

## Gzip Compression

```php
// Add to .htaccess
add_filter('mod_rewrite_rules', function($rules) {
    $gzip = <<<EOT
# Enable Gzip Compression
<IfModule mod_deflate.c>
AddOutputFilterByType DEFLATE text/html
AddOutputFilterByType DEFLATE text/css
AddOutputFilterByType DEFLATE text/javascript
AddOutputFilterByType DEFLATE application/javascript
AddOutputFilterByType DEFLATE application/json
AddOutputFilterByType DEFLATE application/xml
</IfModule>

# Browser Caching
<IfModule mod_expires.c>
ExpiresActive On
ExpiresByType image/jpg "access plus 1 year"
ExpiresByType image/jpeg "access plus 1 year"
ExpiresByType image/gif "access plus 1 year"
ExpiresByType image/png "access plus 1 year"
ExpiresByType image/svg+xml "access plus 1 year"
ExpiresByType text/css "access plus 1 month"
ExpiresByType text/javascript "access plus 1 month"
ExpiresByType application/javascript "access plus 1 month"
ExpiresByType application/pdf "access plus 1 month"
</IfModule>
EOT;
    return $gzip . "\n" . $rules;
});
```

## Query Monitoring

```php
// Log slow queries (add to wp-config.php)
// define('SAVEQUERIES', true);

// Performance monitor
function log_query_count() {
    global $wpdb;
    
    $queries = $wpdb->num_queries;
    $time = timer_stop(0);
    
    if (defined('SAVEQUERIES') && SAVEQUERIES) {
        error_log("Queries: {$queries}, Time: {$time}s");
    }
}
add_action('wp_footer', 'log_query_count');
```

## Measurement Tools

- Google PageSpeed Insights
- GTmetrix
- WebPageTest
- Chrome DevTools Performance tab
- Query Monitor plugin
- WP Debug plugin
- New Relic
