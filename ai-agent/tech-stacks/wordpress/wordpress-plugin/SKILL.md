---
name: wordpress-plugin
description: WordPress plugin development. Use when user asks to create, modify, or debug WordPress plugins.
---

# WordPress Plugin Development Guide

## When to use
- User asks to create a WordPress plugin
- User asks to add functionality to a plugin
- User asks about WordPress hooks/filters
- User asks to debug WordPress issues

## Conventions

- Use `wp-content/plugins/` as base path
- Prefix all functions with plugin slug: `my_plugin_`
- Use text domain for i18n
- Follow WordPress coding standards

## File Structure

```
my-plugin/
├── my-plugin.php          # Main plugin file
├── uninstall.php         # Cleanup on uninstall
├── readme.txt           # WordPress.org readme
├── index.php            # Security guard
├── includes/            # PHP classes
├── templates/           # Theme templates
├── assets/              # JS/CSS/images
└── languages/           # Translation files
```

## Plugin Header

```php
/*
Plugin Name: My Plugin
Plugin URI:  https://example.com/
Description: Description here
Version:     1.0.0
Author:      Your Name
Author URI:  https://example.com/
License:     GPLv2 or later
Text Domain: my-plugin
Domain Path: /languages
*/
```

## Common Hooks

| Hook | Usage |
|------|-------|
| `register_activation_hook` | Run on activate |
| `register_deactivation_hook` | Run on deactivate |
| `add_action` | Core hooks |
| `add_filter` | Modify output |
| `add_shortcode` | Shortcodes |
| `wp_enqueue_scripts` | Load assets |

## Database

- Use `$wpdb` for custom tables
- Prefix with plugin slug
- Sanitize with `$wpdb->prepare()`

## REST API

```php
register_rest_route('my-plugin/v1', '/endpoint', [
    'methods'  => WP_REST_Server::READABLE,
    'callback' => 'my_callback',
]);
```

## Security Checklist

- [ ] Nonce verification
- [ ] Input sanitization
- [ ] Output escaping
- [ ] Capability checks
- [ ] Secure AJAX handlers
- [ ] Protect admin AJAX