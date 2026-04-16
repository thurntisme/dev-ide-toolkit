---
name: wordpress-security
description: WordPress security best practices. Use when user asks about WordPress security or securing plugins/themes.
---

# WordPress Security Guide

## When to use
- User asks about WordPress security
- User asks to secure a plugin
- User asks about security vulnerabilities
- User asks about best practices

## Security Checklist

- [ ] Sanitize input
- [ ] Escape output
- [ ] Verify nonces
- [ ] Check capabilities
- [ ] Use prepared statements
- [ ] Rate limiting

## Sanitize Input

```php
$title = sanitize_text_field($_POST['title']);
$email = sanitize_email($_POST['email']);
$url = esc_url_raw($_POST['url']);
$content = wp_kses_post($_POST['content']);
$number = intval($_POST['number']);
```

## Escape Output

```php
echo esc_html($title);
echo esc_attr($class);
echo esc_url($url);
echo esc_textarea($content);
echo wp_kses_post($html);
```

## Nonce Verification

```php
// Create hidden field
<input type="hidden" name="my_nonce" value="<?php echo wp_create_nonce('my_action'); ?>">

// Verify
if (!wp_verify_nonce($_POST['my_nonce'], 'my_action')) {
    wp_die('Security check failed');
}
```

## Capability Check

```php
if (!current_user_can('edit_posts')) {
    wp_die('Unauthorized');
}

if (!current_user_can('manage_options')) {
    wp_die('Admin access only');
}
```

## SQL Injection Prevention

```php
global $wpdb;
$id = intval($_GET['id']);
$results = $wpdb->get_results($wpdb->prepare(
    "SELECT * FROM {$wpdb->posts} WHERE ID = %d",
    $id
));
```

## AJAX Security

```php
add_action('wp_ajax_my_action', 'my_handler');
add_action('wp_ajax_nopriv_my_action', function() {
    wp_send_json_error('Unauthorized', 401);
});

function my_handler() {
    check_ajax_referer('my_nonce', 'nonce');
    if (!current_user_can('edit_posts')) {
        wp_send_json_error('Unauthorized', 403);
    }
}
```

## File Access

```php
// Deny direct access
if (!defined('ABSPATH')) {
    exit;
}
```

## User Data

```php
// Get current user
$user = wp_get_current_user();

// Verify user role
if (in_array('administrator', $user->roles)) {
    // admin only
}

// Check capability
if (current_user_can('edit_others_posts')) {
    //
}
```

## Rate Limiting

```php
// Simple IP check
$ip = $_SERVER['REMOTE_ADDR'];
$transient = 'rate_' . md5($ip);
if (get_transient($transient)) {
    wp_send_json_error('Too many requests', 429);
}
set_transient($transient, 1, 60); // 1 per minute
```

## Data Validation

```php
// Email
if (!is_email($email)) {
    wp_send_json_error('Invalid email');
}

// URL
if (!url_exists($url)) {
    wp_send_json_error('Invalid URL');
}
```

## Logging Security Events

```php
error_log('Security event: ' . $event . ' by user: ' . get_current_user_id());
```