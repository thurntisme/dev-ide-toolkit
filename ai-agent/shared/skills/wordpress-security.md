---
name: wordpress-security
description: WordPress security specialist. Use when user asks about WordPress security, hardening, malware removal, vulnerability fixes, or securing plugins/themes.
---

# WordPress Security

## When to use
- User asks about WordPress security hardening
- User asks about securing plugins or themes
- User asks about malware removal
- User asks about vulnerability fixes
- User asks about firewall or security plugins
- User asks about login security

## Security Checklist

- [ ] Keep WordPress, plugins, themes updated
- [ ] Use strong passwords
- [ ] Limit login attempts
- [ ] Use two-factor authentication
- [ ] Change default admin username
- [ ] Use SSL/HTTPS
- [ ] Set correct file permissions
- [ ] Disable file editor in admin
- [ ] Disable XML-RPC if not needed
- [ ] Use security headers

## File Permissions

| Path | Permission | Owner |
|------|------------|-------|
| `wp-config.php` | 400 or 440 | Owner only |
| `/wp-content/` | 755 | Owner/group |
| `/wp-content/themes/` | 755 | Owner/group |
| `/wp-content/plugins/` | 755 | Owner/group |
| `.htaccess` | 644 | Owner only |
| All files | 644 | Owner only |
| All directories | 755 | Owner only |

```bash
# Set correct permissions
find /path/to/wordpress -type f -exec chmod 644 {} \;
find /path/to/wordpress -type d -exec chmod 755 {} \;
chmod 440 /path/to/wordpress/wp-config.php
```

## wp-config.php Security

```php
// Disable file editing in admin
define('DISALLOW_FILE_EDIT', true);

// Disable XML-RPC
add_filter('xmlrpc_enabled', '__return_false');
add_filter('xmlrpc_methods', function($methods) {
    unset($methods['pingback.ping']);
    unset($methods['pingback.extensions.getPingbacks']);
    return $methods;
});

// Disable REST API for non-authenticated users
add_filter('rest_authentication_errors', function($result) {
    if (!is_user_logged_in()) {
        return new WP_Error('rest_not_logged_in', 'Authentication required', ['status' => 401]);
    }
    return $result;
});

// Change database prefix
$table_prefix = 'wp_custom_';

// Force SSL
define('FORCE_SSL_ADMIN', true);

// Disable debug display
define('WP_DEBUG_DISPLAY', false);
define('WP_DEBUG_LOG', false);
```

## Login Security

### Limit Login Attempts

```php
// In wp-config.php
define('WP_LIMIT_LOGIN_ATTEMPTS', true);

// Custom login limit
function check_login_attempts($user, $username, $password) {
    $transient_name = 'login_attempts_' . $_SERVER['REMOTE_ADDR'];
    $attempts = get_transient($transient_name);
    
    if ($attempts && $attempts >= 5) {
        return new WP_Error('too_many_attempts', 'Too many login attempts. Try again later.');
    }
    
    if (!username_exists($username) || !wp_check_password($password, get_user_by('login', $username)->user_pass)) {
        $attempts = ($attempts) ? $attempts + 1 : 1;
        set_transient($transient_name, $attempts, HOUR_IN_SECONDS);
    }
    
    return $user;
}
add_filter('authenticate', 'check_login_attempts', 30, 3);
```

### Rename Login URL

```php
// Disable default login
add_action('login_init', function() {
    if ($_SERVER['REQUEST_URI'] === '/wp-login.php') {
        wp_redirect(home_url());
        exit;
    }
});

// Custom login page
add_action('init', function() {
    add_rewrite_rule('^secure-login/?$', 'wp-login.php', 'top');
});
add_filter('login_url', function($login_url, $redirect, $force_reauth) {
    return home_url('/secure-login/?redirect_to=' . urlencode($redirect));
}, 10, 3);
```

## Sanitization & Escaping

### Input Sanitization

```php
// Text fields
$text = sanitize_text_field($_POST['text']);

// Email
$email = sanitize_email($_POST['email']);

// URLs
$url = esc_url_raw($_POST['url']);
$url = esc_url($_POST['url']);

// HTML content (allowed tags)
$html = wp_kses_post($_POST['html']);

// File names
$filename = sanitize_file_name($_POST['filename']);

// Keys
$key = sanitize_key($_POST['key']);

// Titles
$title = sanitize_title($_POST['title']);

// User roles/capabilities
$role = sanitize_key($_POST['role']);

// SQL identifiers (table/column names)
$column = esc_sql($column_name);
```

### Output Escaping

```php
// Plain text
echo esc_html($text);

// HTML attributes
echo esc_attr($class);
echo esc_attr($id);

// URLs
echo esc_url($url);
echo esc_url_raw($url); // For href/src

// HTML content (trusted)
echo wp_kses_post($html);

// JavaScript
echo esc_js($text);
wp_add_inline_script($handle, 'var data = ' . wp_json_encode($data));

// HTML data attributes
echo 'data-value="' . esc_attr($value) . '"';

// Internationalized text
_e('Text', 'text-domain');
echo esc_html__('Text', 'text-domain');
```

## Nonce Verification

```php
// Create nonce in forms
wp_nonce_field('my_action', 'my_nonce');
wp_nonce_url($url, 'my_action');

// Create nonce for URLs
$delete_url = wp_nonce_url(admin_url('admin.php?action=delete&id=' . $id), 'delete_' . $id);

// Verify nonce in POST
if (!wp_verify_nonce($_POST['my_nonce'], 'my_action')) {
    wp_die('Security check failed');
}

// Verify nonce in GET
if (!wp_verify_nonce($_GET['_wpnonce'], 'delete_' . $_GET['id'])) {
    wp_die('Security check failed');
}

// Ajax nonce
wp_localize_script('my-script', 'myData', [
    'nonce' => wp_create_nonce('my_ajax_action')
]);

// Verify Ajax nonce
add_action('wp_ajax_my_action', function() {
    check_ajax_referer('my_ajax_action', 'nonce');
    // Process request
    wp_send_json_success($data);
});
```

## Capability Checks

```php
// Check current user capability
if (!current_user_can('edit_posts')) {
    wp_die('Unauthorized');
}

// Check specific post author
if (!current_user_can('edit_post', $post_id)) {
    wp_die('Unauthorized');
}

// Check user role
$user = wp_get_current_user();
if (!in_array('administrator', $user->roles)) {
    wp_die('Admin access required');
}

// Check capability with roles
add_cap('manage_options'); // Add to role
remove_cap('edit_posts');   // Remove from role
```

## SQL Injection Prevention

```php
global $wpdb;

// Use prepare() for all queries
$id = intval($_GET['id']);
$results = $wpdb->get_results($wpdb->prepare(
    "SELECT * FROM {$wpdb->posts} WHERE ID = %d",
    $id
));

// String queries with prepare
$search = '%' . $wpdb->esc_like($_GET['search']) . '%';
$results = $wpdb->get_results($wpdb->prepare(
    "SELECT * FROM {$wpdb->posts} WHERE post_title LIKE %s",
    $search
));

// Multiple placeholders
$wpdb->get_results($wpdb->prepare(
    "SELECT * FROM {$wpdb->posts} WHERE post_status = %s AND post_type = %s",
    $status,
    $type
));
```

## XSS Prevention

```php
// Never trust user input
$input = sanitize_text_field($_POST['input']);

// Escape before output
echo esc_html($input);

// For allowed HTML, use KSES
$allowed_html = [
    'a' => ['href' => [], 'title' => []],
    'br' => [],
    'em' => [],
    'strong' => [],
];
echo wp_kses($user_content, $allowed_html);

// Content that can contain all HTML
echo wp_kses_post($content);

// JavaScript variables
echo 'var config = ' . wp_json_encode($config) . ';';
```

## CSRF Protection

```php
// Generate token for forms
$token = wp_create_nonce('my_form_action');

// Verify on submission
if (!wp_verify_nonce($_POST['token'], 'my_form_action')) {
    wp_die('Invalid request');
}

// Double submit cookie pattern
// 1. Set cookie with token on page load
// 2. Send token in form
// 3. Verify both match
```

## Security Headers

```php
// In functions.php or .htaccess

// X-Content-Type-Options
header('X-Content-Type-Options: nosniff');

// X-Frame-Options
header('X-Frame-Options: SAMEORIGIN');

// X-XSS-Protection
header('X-XSS-Protection: 1; mode=block');

// Strict-Transport-Security (requires HTTPS)
header('Strict-Transport-Security: max-age=31536000; includeSubDomains');

// Content-Security-Policy
header("Content-Security-Policy: default-src 'self'; script-src 'self' 'unsafe-inline'; style-src 'self' 'unsafe-inline';");

// Referrer-Policy
header('Referrer-Policy: strict-origin-when-cross-origin');
```

## .htaccess Security

```apache
# Protect wp-config.php
<files wp-config.php>
    order allow,deny
    deny from all
</files>

# Disable directory listing
Options -Indexes

# Protect .htaccess itself
<files ~ "^.*\.(?:htaccess|htpasswd|git)">
    order allow,deny
    deny from all
</files>

# Block suspicious requests
<IfModule mod_rewrite.c>
    RewriteEngine On
    RewriteCond %{QUERY_STRING} eval\( [NC,OR]
    RewriteCond %{QUERY_STRING} base64_decode\( [NC,OR]
    RewriteCond %{QUERY_STRING} <script [NC]
    RewriteRule ^(.*)$ - [F,L]
</IfModule>

# Protect uploads directory
<Directory "wp-content/uploads">
    <FilesMatch "\.(php|phtml|php3|php4|php5|php6|phps)$">
        Order Allow,Deny
        Deny from all
    </FilesMatch>
</Directory>
```

## Disable XML-RPC

```php
// In functions.php
add_filter('xmlrpc_enabled', '__return_false');
add_filter('xmlrpc_methods', function($methods) {
    unset($methods['pingback.ping']);
    unset($methods['pingback.extensions.getPingbacks']);
    unset($methods['system.multicall']);
    unset($methods['system.listMethods']);
    return $methods;
});
```

## Hide WordPress Version

```php
// Remove from head
remove_action('wp_head', 'wp_generator');

// Remove from feeds
add_filter('the_generator', '__return_empty_string');

// Remove from CSS/JS versions
add_filter('style_loader_src', function($src) {
    return remove_query_arg('ver', $src);
});
add_filter('script_loader_src', function($src) {
    return remove_query_arg('ver', $src);
});
```

## Database Security

```php
// Use prepared statements
global $wpdb;
$stmt = $wpdb->prepare("SELECT * FROM %s WHERE id = %d", $table_name, $id);
$results = $wpdb->get_results($stmt);

// Prefix should be changed during install
$table_prefix = 'wp_custom_';

// Never store passwords in plain text
// WordPress uses wp_hash_password() automatically

// Use wp_salt() for encryption keys
$salt = wp_salt('auth');
```

## User Registration Security

```php
// Validate user registration
add_filter('registration_errors', function($errors, $sanitized_user_login) {
    // Check username length
    if (strlen($sanitized_user_login) < 4) {
        $errors->add('username_length', 'Username must be at least 4 characters');
    }
    
    // Block certain usernames
    $blocked = ['admin', 'administrator', 'root', 'test'];
    if (in_array(strtolower($sanitized_user_login), $blocked)) {
        $errors->add('username_blocked', 'This username is not allowed');
    }
    
    return $errors;
}, 10, 2);

// Password strength requirements
add_filter('registration_errors', function($errors) {
    $password = $_POST['password'];
    if (strlen($password) < 8) {
        $errors->add('password_too_short', 'Password must be at least 8 characters');
    }
    return $errors;
});
```

## API Security

```php
// REST API authentication
add_filter('rest_authentication_errors', function($result) {
    if (!is_user_logged_in()) {
        return new WP_Error('rest_not_logged_in', 'Authentication required', ['status' => 401]);
    }
    return $result;
});

// Custom REST API authentication
add_action('rest_api_init', function() {
    register_rest_route('my-plugin/v1', '/secure-data', [
        'methods' => 'GET',
        'callback' => 'get_secure_data',
        'permission_callback' => function() {
            return current_user_can('edit_posts');
        },
    ]);
});

// Rate limiting for REST API
add_filter('rest_pre_dispatch', function($result) {
    $ip = $_SERVER['REMOTE_ADDR'];
    $transient = 'rate_limit_' . md5($ip);
    
    if (get_transient($transient)) {
        return new WP_Error('rate_limit_exceeded', 'Too many requests', ['status' => 429]);
    }
    
    set_transient($transient, 1, MINUTE_IN_SECONDS);
    return $result;
}, 10, 1);
```

## Security Plugins (Recommendations)

- Wordfence Security
- Sucuri Security
- iThemes Security
- All In One WP Security & Firewall
- Jetpack Protect
