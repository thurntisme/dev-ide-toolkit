---
name: coder-wordpress
description: WordPress development. Use when user asks to create, modify, or debug WordPress plugins, themes, blocks, or work with any WordPress functionality.
---

# WordPress Complete Development Guide

## When to use
- User asks to create a WordPress plugin, theme, or block
- User asks about WordPress hooks, AJAX, or REST API
- User asks about WordPress security or customization
- User asks about Elementor or Gutenberg development

## Plugin Development

### File Structure

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

### Plugin Header

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

### Common Hooks

| Hook | Usage |
|------|-------|
| `register_activation_hook` | Run on activate |
| `register_deactivation_hook` | Run on deactivate |
| `add_action` | Core hooks |
| `add_filter` | Modify output |
| `add_shortcode` | Shortcodes |
| `wp_enqueue_scripts` | Load assets |

## Theme Development

### Theme Directory

```
wp-content/themes/my-theme/
├── style.css              # Theme stylesheet (required)
├── index.php            # Theme template (required)
├── functions.php        # Theme functions
├── header.php          # Header template
├── footer.php          # Footer template
├── single.php         # Single post
├── page.php           # Single page
├── archive.php        # Archive pages
└── screenshot.png     # Theme screenshot
```

### Template Hierarchy

```
index.php          # Fallback
single.php        # Single post
page.php          # Single page
front-page.php   # Front page
home.php         # Blog index
archive.php      # Archives
search.php       # Search results
404.php          # Not found
```

### Theme Support

```php
add_theme_support('title-tag');
add_theme_support('post-thumbnails');
add_theme_support('automatic-feed-links');
add_theme_support('html5', ['search-form', 'comment-form']);
add_theme_support('custom-logo');
add_theme_support('custom-background');
add_theme_support('custom-header');
```

## Custom Post Types & Taxonomies

### Custom Post Type

```php
register_post_type('book', [
    'labels'       => [
        'name'          => __('Books', 'my-plugin'),
        'singular_name' => __('Book', 'my-plugin'),
    ],
    'public'       => true,
    'has_archive'  => true,
    'show_in_rest' => true,
    'supports'    => ['title', 'editor', 'thumbnail', 'excerpt'],
    'menu_icon'   => 'dashicons-book',
    'rewrite'    => ['slug' => 'books'],
]);
```

### Custom Taxonomy

```php
register_taxonomy('genre', 'book', [
    'labels'       => [
        'name'          => __('Genres', 'my-plugin'),
        'singular_name' => __('Genre', 'my-plugin'),
    ],
    'public'       => true,
    'show_in_rest' => true,
    'rewrite'    => ['slug' => 'genre'],
]);
```

## AJAX

### Frontend

```php
add_action('wp_enqueue_scripts', function() {
    wp_enqueue_script('my-ajax', get_template_directory_uri() . '/js/ajax.js', ['jquery'], '1.0.0', true);
    wp_localize_script('my-ajax', 'myAjax', [
        'ajaxUrl' => admin_url('admin-ajax.php'),
        'nonce'  => wp_create_nonce('my_nonce'),
    ]);
});
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
        console.log(response);
    }
});
```

### PHP Handler

```php
add_action('wp_ajax_my_ajax_action', 'my_ajax_handler');
add_action('wp_ajax_nopriv_my_ajax_action', 'my_ajax_handler');

function my_ajax_handler() {
    check_ajax_referer('my_nonce', 'nonce');
    $id = $_POST['id'];
    $post = get_post($id);
    wp_send_json_success(['title' => $post->post_title]);
}
```

## REST API

### Register REST Route

```php
add_action('rest_api_init', function() {
    register_rest_route('my-plugin/v1', '/books', [
        'methods'  => WP_REST_Server::READABLE,
        'callback' => 'get_books',
        'permission_callback' => '__return_true',
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

### POST Request

```php
register_rest_route('my-plugin/v1', '/books', [
    'methods'  => WP_REST_Server::CREATABLE,
    'callback' => 'create_book',
    'permission_callback' => function() {
        return current_user_can('edit_posts');
    },
]);
```

## Gutenberg Blocks

### Block Structure

```
my-block/
├── block.json          # Block metadata
├── index.js          # Block registration
├── edit.js          # Editor component
├── save.js          # Frontend markup
└── style.css        # Frontend styles
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

## Block Theme (FSE)

### Theme Structure

```
wp-content/themes/my-block-theme/
├── theme.json           # Theme configuration
├── functions.php      # Theme functions
├── index.php          # Fallback template
├── templates/
│   ├── index.html
│   ├── front-page.html
│   ├── single.html
│   └── 404.html
└── parts/
    ├── header.html
    └── footer.html
```

### theme.json

```json
{
    "$schema": "https://schemas.wp.org/trunk/theme.json",
    "version": 2,
    "settings": {
        "appearanceTools": true,
        "layout": {
            "contentSize": "1200px",
            "wideSize": "1400px"
        }
    },
    "templateParts": [
        { "name": "header", "title": "Header" },
        { "name": "footer", "title": "Footer" }
    ]
}
```

### Templates

```html
<!-- wp:template-part {"slug": "header", "tagName": "header"} /-->
<!-- wp:post-content {"layout":"full"} /-->
<!-- wp:template-part {"slug": "footer", "tagName": "footer"} /-->
```

## Elementor

### Basic Widget

```php
namespace Plugin\Widgets;

use Elementor\Widget_Base;
use Elementor\Controls_Manager;

class My_Widget extends Widget_Base {

    public function get_name() {
        return 'my_widget';
    }

    public function get_title() {
        return __('My Widget', 'my-plugin');
    }

    public function get_icon() {
        return 'eicon-kit-drag-n-drop';
    }

    protected function register_controls() {
        $this->start_controls_section('content_section', [
            'label' => __('Content', 'my-plugin'),
            'tab' => Controls_Manager::TAB_CONTENT,
        ]);

        $this->add_control('heading', [
            'label' => __('Heading', 'my-plugin'),
            'type' => Controls_Manager::TEXT,
            'default' => __('Hello World', 'my-plugin'),
        ]);

        $this->end_controls_section();
    }

    protected function render() {
        $settings = $this->get_settings_for_display();
        ?>
        <h2 class="my-heading"><?php echo esc_html($settings['heading']); ?></h2>
        <?php
    }
}
```

### Register Widget

```php
function register_my_widget($widgets_manager) {
    require_once(__DIR__ . '/widgets/my-widget.php');
    $widgets_manager->register(new \Plugin\Widgets\My_Widget());
}
add_action('elementor/widgets/register', 'register_my_widget');
```

### Controls Reference

| Control | Class |
|---------|-------|
| Text | `Controls_Manager::TEXT` |
| Textarea | `Controls_Manager::TEXTAREA` |
| Select | `Controls_Manager::SELECT2` |
| Color | `Controls_Manager::COLOR` |
| Media | `Controls_Manager::MEDIA` |
| Slider | `Controls_Manager::SLIDER` |
| Typography | `Controls_Manager::TYPOGRAPHY` |

## Security

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
// Create hidden field
<input type="hidden" name="my_nonce" value="<?php echo wp_create_nonce('my_action'); ?>">

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

### AJAX Security

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

## Database

- Use `$wpdb` for custom tables
- Prefix with plugin slug
- Always use `$wpdb->prepare()` for queries

```php
global $wpdb;
$table_name = $wpdb->prefix . 'my_plugin_table';
$results = $wpdb->get_results($wpdb->prepare(
    "SELECT * FROM {$table_name} WHERE id = %d",
    $id
));
```
