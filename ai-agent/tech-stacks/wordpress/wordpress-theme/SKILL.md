---
name: wordpress-theme
description: WordPress theme development. Use when user asks to create, modify, or debug WordPress themes.
---

# WordPress Theme Development Guide

## When to use
- User asks to create a WordPress theme
- User asks to modify theme template files
- User asks about WordPress template hierarchy
- User asks to add theme support

## Theme Directory

```
wp-content/themes/my-theme/
├── style.css              # Theme stylesheet (required)
├── index.php            # Theme template (required)
├── functions.php        # Theme functions
├── header.php          # Header template
├── footer.php          # Footer template
├── sidebar.php         # Sidebar template
├── single.php         # Single post
├── page.php           # Single page
├── archive.php        # Archive pages
├── search.php         # Search results
├── 404.php           # 404 page
├── screenshot.png     # Theme screenshot
└── assets/           # JS/CSS/images
```

## style.css Header

```css
/*
Theme Name: My Theme
Theme URI:  https://example.com/
Author:     Your Name
Author URI: https://example.com/
Description: Description here
Version:    1.0.0
License:    GPLv2 or later
Text Domain: my-theme
*/
```

## Theme Support

```php
add_theme_support('title-tag');
add_theme_support('post-thumbnails');
add_theme_support('automatic-feed-links');
add_theme_support('html5', ['search-form', 'comment-form']);
add_theme_support('custom-logo');
add_theme_support('custom-background');
add_theme_support('custom-header');
```

## Template Hierarchy

```
index.php          # Fallback
single.php        # Single post
page.php          # Single page
front-page.php   # Front page
home.php         # Blog index
archive.php      # Archives
search.php       # Search results
404.php          # Not found
singular.php      # Any singular
```

## Common Functions

| Function | Usage |
|----------|-------|
| `have_posts()` | Check posts |
| `the_post()` | Get post |
| `the_title()` | Display title |
| `the_content()` | Display content |
| `the_excerpt()` | Display excerpt |
| `the_post_thumbnail()` | Featured image |
| `wp_nav_menu()` | Display menu |

## Enqueue Scripts

```php
function my_theme_scripts() {
    wp_enqueue_style('my-style', get_stylesheet_uri());
    wp_enqueue_script('my-script', get_template_directory_uri() . '/js/script.js', ['jquery'], '1.0.0', true);
}
add_action('wp_enqueue_scripts', 'my_theme_scripts');
```

## Widget Areas

```php
register_sidebar([
    'name'          => __('Sidebar', 'my-theme'),
    'id'            => 'sidebar-1',
    'description'   => __('Add widgets here', 'my-theme'),
    'before_widget' => '<section id="%1$s" class="widget %2$s">',
    'after_widget'  => '</section>',
]);
```

## Menus

```php
register_nav_menus([
    'primary' => __('Primary Menu', 'my-theme'),
    'footer' => __('Footer Menu', 'my-theme'),
]);
```