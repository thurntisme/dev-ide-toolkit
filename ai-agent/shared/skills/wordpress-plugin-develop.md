---
name: wordpress-plugin-develop
description: WordPress plugin development specialist. Use when user asks to create, modify, or debug WordPress plugins, including custom post types, taxonomies, hooks, AJAX, REST API, blocks, and plugin security.
---

# WordPress Plugin Development

## When to use
- User asks to create a WordPress plugin from scratch
- User asks to add functionality to an existing plugin
- User asks about WordPress hooks, filters, actions
- User asks about AJAX in WordPress
- User asks about REST API endpoints
- User asks about Gutenberg block development
- User asks about plugin security

## Plugin File Structure

```
my-plugin/
├── my-plugin.php              # Main plugin file
├── uninstall.php             # Cleanup on uninstall
├── readme.txt                # WordPress.org readme
├── index.php                 # Security guard
├── includes/                 # PHP classes
│   ├── class-my-plugin.php
│   └── index.php
├── templates/                # Template files
├── assets/                   # JS/CSS/images
│   ├── js/
│   ├── css/
│   └── images/
└── languages/                # Translation files
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

## Essential Hooks

| Hook | Usage |
|------|-------|
| `register_activation_hook` | Run code on plugin activation |
| `register_deactivation_hook` | Run code on plugin deactivation |
| `register_uninstall_hook` | Run code on plugin uninstall |
| `add_action` | Hook into core actions |
| `add_filter` | Modify output |
| `add_shortcode` | Create shortcodes |
| `wp_enqueue_scripts` | Load CSS/JS assets |

## Custom Post Types

```php
register_post_type('book', [
    'labels'       => [
        'name'          => __('Books', 'my-plugin'),
        'singular_name' => __('Book', 'my-plugin'),
    ],
    'public'       => true,
    'has_archive'  => true,
    'show_in_rest' => true,
    'supports'     => ['title', 'editor', 'thumbnail', 'excerpt'],
    'menu_icon'    => 'dashicons-book',
    'rewrite'      => ['slug' => 'books'],
]);
```

## Custom Taxonomies

```php
register_taxonomy('genre', 'book', [
    'labels'       => [
        'name'          => __('Genres', 'my-plugin'),
        'singular_name' => __('Genre', 'my-plugin'),
    ],
    'public'       => true,
    'show_in_rest' => true,
    'rewrite'      => ['slug' => 'genre'],
]);
```

## AJAX Implementation

### PHP Setup
```php
add_action('wp_enqueue_scripts', function() {
    wp_enqueue_script('my-ajax', get_template_directory_uri() . '/js/ajax.js', ['jquery'], '1.0.0', true);
    wp_localize_script('my-ajax', 'myAjax', [
        'ajaxUrl' => admin_url('admin-ajax.php'),
        'nonce'  => wp_create_nonce('my_nonce'),
    ]);
});

add_action('wp_ajax_my_ajax_action', 'my_ajax_handler');
add_action('wp_ajax_nopriv_my_ajax_action', 'my_ajax_handler');

function my_ajax_handler() {
    check_ajax_referer('my_nonce', 'nonce');
    $id = intval($_POST['id']);
    $post = get_post($id);
    wp_send_json_success(['title' => $post->post_title]);
}
```

### JavaScript
```javascript
jQuery.ajax({
    url: myAjax.ajaxUrl,
    type: 'POST',
    data: {
        action: 'my_ajax_action',
        nonce: myAjax.nonce,
        id: 123
    },
    success: function(response) {
        console.log(response.data);
    }
});
```

## REST API

```php
add_action('rest_api_init', function() {
    register_rest_route('my-plugin/v1', '/books', [
        'methods'  => WP_REST_Server::READABLE,
        'callback' => 'get_books',
        'permission_callback' => '__return_true',
    ]);
    
    register_rest_route('my-plugin/v1', '/books', [
        'methods'  => WP_REST_Server::CREATABLE,
        'callback' => 'create_book',
        'permission_callback' => function() {
            return current_user_can('edit_posts');
        },
    ]);
});

function get_books($request) {
    $args = [
        'post_type' => 'book',
        'posts_per_page' => -1,
    ];
    $books = get_posts($args);
    return rest_ensure_response($books);
}
```

## Gutenberg Blocks

### Block Structure
```
my-block/
├── block.json           # Block metadata
├── index.js             # Block registration
├── edit.js              # Editor component
├── save.js              # Frontend markup
└── style.css            # Frontend styles
```

### block.json
```json
{
    "$schema": "https://schemas.wp.org/trunk/block.json",
    "apiVersion": 3,
    "name": "my-plugin/my-block",
    "version": "1.0.0",
    "title": "My Block",
    "category": "design",
    "icon": "smiley",
    "attributes": {
        "content": { "type": "string" }
    }
}
```

### Register Block
```javascript
import { registerBlockType } from '@wordpress/blocks';
import edit from './edit';
import save from './save';

registerBlockType('my-plugin/my-block', {
    edit,
    save,
});
```

### Dynamic Block (PHP Render)
```php
register_block_type('my-plugin/my-block', [
    'render_callback' => function($attributes) {
        return '<div class="my-block"><h2>' . $attributes['content'] . '</h2></div>';
    },
]);
```

## Security Best Practices

### Sanitize Input
```php
$title = sanitize_text_field($_POST['title']);
$email = sanitize_email($_POST['email']);
$url = esc_url_raw($_POST['url']);
$content = wp_kses_post($_POST['content']);
```

### Escape Output
```php
echo esc_html($title);
echo esc_attr($class);
echo esc_url($url);
echo wp_kses_post($html);
```

### Nonce Verification
```php
// Create nonce
$nonce = wp_create_nonce('my_action');

// Verify
if (!wp_verify_nonce($_POST['my_nonce'], 'my_action')) {
    wp_die('Security check failed');
}
```

### Capability Check
```php
if (!current_user_can('edit_posts')) {
    wp_die('Unauthorized');
}
```

### SQL Injection Prevention
```php
global $wpdb;
$id = intval($_GET['id']);
$results = $wpdb->get_results($wpdb->prepare(
    "SELECT * FROM {$wpdb->posts} WHERE ID = %d",
    $id
));
```

## Database Operations

- Use `$wpdb` for custom tables
- Prefix table names with plugin slug
- Always use `$wpdb->prepare()` for queries

```php
global $wpdb;
$table_name = $wpdb->prefix . 'my_plugin_table';
$results = $wpdb->get_results($wpdb->prepare(
    "SELECT * FROM {$table_name} WHERE id = %d",
    $id
));
```
