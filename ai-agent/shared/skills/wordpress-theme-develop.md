---
name: wordpress-theme-develop
description: WordPress theme development specialist. Use when user asks to create, modify, or debug WordPress themes, including template hierarchy, block themes, theme support, customizer, and theme security.
---

# WordPress Theme Development

## When to use
- User asks to create a WordPress theme from scratch
- User asks to modify an existing theme
- User asks about WordPress template hierarchy
- User asks about block themes (FSE)
- User asks about theme customizer
- User asks about child themes
- User asks about theme security

## Classic Theme Structure

```
wp-content/themes/my-theme/
├── style.css              # Theme stylesheet (required)
├── index.php              # Theme template (required)
├── functions.php          # Theme functions
├── header.php             # Header template
├── footer.php             # Footer template
├── sidebar.php            # Sidebar template
├── single.php             # Single post
├── page.php               # Single page
├── archive.php            # Archive pages
├── search.php             # Search results
├── 404.php                # Not found page
├── comments.php           # Comments template
├── screenshot.png         # Theme screenshot
├── assets/
│   ├── js/
│   └── css/
└── template-parts/
```

## Theme Stylesheet Header

```css
/*
Theme Name: My Theme
Theme URI:  https://example.com/
Author:     Your Name
Author URI: https://example.com.com/
Description: A custom theme
Version:    1.0.0
License:    GPLv2 or later
License URI: https://www.gnu.org/licenses/gpl-2.0.html
Text Domain: my-theme
*/
```

## Template Hierarchy

```
index.php          # Fallback template
single.php         # Single post
single-{post-type}.php  # Custom post type
page.php           # Single page
page-{slug}.php    # Specific page
front-page.php     # Front page
home.php           # Blog index
archive.php        # Archives
archive-{post-type}.php  # Custom post type archive
search.php         # Search results
404.php            # Not found
attachment.php     # Media attachments
singular.php       # Any singular entry
```

## Theme Support

```php
add_theme_support('title-tag');
add_theme_support('post-thumbnails');
add_theme_support('automatic-feed-links');
add_theme_support('html5', ['search-form', 'comment-form', 'gallery', 'caption']);
add_theme_support('custom-logo');
add_theme_support('custom-background');
add_theme_support('custom-header');
add_theme_support('align-wide');
add_theme_support('editor-styles');
add_theme_support('wp-block-styles');
```

## Block Theme (Full Site Editing)

### Block Theme Structure
```
wp-content/themes/my-block-theme/
├── theme.json              # Theme configuration
├── functions.php           # Theme functions
├── index.php               # Fallback template
├── styles/
│   └── variation-name.json  # Global styles variation
├── templates/
│   ├── index.html
│   ├── front-page.html
│   ├── single.html
│   ├── page.html
│   ├── archive.html
│   ├── search.html
│   └── 404.html
└── parts/
    ├── header.html
    ├── footer.html
    └── sidebar.html
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
        },
        "color": {
            "palette": [
                {
                    "slug": "primary",
                    "color": "#21759b",
                    "name": "Primary"
                }
            ]
        },
        "typography": {
            "fontSizes": [
                {
                    "slug": "small",
                    "size": "12px",
                    "name": "Small"
                }
            ]
        }
    },
    "styles": {
        "color": {
            "background": "#ffffff",
            "text": "#333333"
        }
    },
    "templateParts": [
        { "name": "header", "title": "Header" },
        { "name": "footer", "title": "Footer" }
    ]
}
```

### Block Theme Templates
```html
<!-- wp:template-part {"slug": "header", "tagName": "header"} /-->
<!-- wp:post-content {"layout":"full"} /-->
<!-- wp:template-part {"slug": "footer", "tagName": "footer"} /-->
```

## Theme Customizer

### Add Settings
```php
add_action('customize_register', function($wp_customize) {
    $wp_customize->add_section('my_theme_options', [
        'title' => __('Theme Options', 'my-theme'),
    ]);
    
    $wp_customize->add_setting('header_textcolor', [
        'default' => '#21759b',
        'sanitize_callback' => 'sanitize_hex_color',
    ]);
    
    $wp_customize->add_control('header_textcolor', [
        'label' => __('Header Color', 'my-theme'),
        'section' => 'my_theme_options',
        'type' => 'color',
    ]);
});
```

### Output in Template
```php
$header_color = get_theme_mod('header_textcolor', '#21759b');
```

## Child Themes

### Child Theme style.css
```css
/*
Theme Name: My Child Theme
Template: parent-theme
*/

@import url('../parent-theme/style.css');

/* Custom styles here */
```

## Common Template Tags

```php
get_header();
get_footer();
get_sidebar();
get_template_part('template-parts/content', 'single');
the_title();
the_content();
the_excerpt();
the_post_thumbnail();
get_permalink();
get_the_author();
the_date();
comments_template();
wp_nav_menu();
```

## Loop Examples

### Basic Loop
```php
if (have_posts()) :
    while (have_posts()) : the_post();
        the_title('<h2>', '</h2>');
        the_content();
    endwhile;
endif;
```

### WP_Query Loop
```php
$args = [
    'post_type' => 'post',
    'posts_per_page' => 10,
];
$query = new WP_Query($args);

if ($query->have_posts()) :
    while ($query->have_posts()) : $query->the_post();
        ?>
        <h2><?php the_title(); ?></h2>
        <?php
    endwhile;
    wp_reset_postdata();
endif;
```

## Theme Security

### Sanitize Everything
```php
$text = sanitize_text_field($input);
$email = sanitize_email($input);
$url = esc_url_raw($input);
$html = wp_kses_post($input);
```

### Escape Output
```php
echo esc_html(get_the_title());
echo esc_attr($class);
echo esc_url($link);
echo wp_kses_post($content);
```

### Nonce in Forms
```php
wp_nonce_field('my_action', 'my_nonce');
```

## Enqueue Scripts and Styles

```php
add_action('wp_enqueue_scripts', function() {
    wp_enqueue_style('my-theme-style', get_stylesheet_uri());
    wp_enqueue_style('my-theme-main', get_template_directory_uri() . '/assets/css/main.css');
    wp_enqueue_script('my-theme-script', get_template_directory_uri() . '/assets/js/main.js', ['jquery'], '1.0.0', true);
});
```

## Menu Registration

```php
register_nav_menus([
    'primary' => __('Primary Menu', 'my-theme'),
    'footer' => __('Footer Menu', 'my-theme'),
]);
```

### Walker Class for Custom Menus
```php
class My_Walker_Nav_Menu extends Walker_Nav_Menu {
    public function start_el(&$output, $item, $depth = 0, $args = null, $id = 0) {
        $output .= '<li class="nav-item">';
        $output .= '<a class="nav-link" href="' . esc_url($item->url) . '">' . esc_html($item->title) . '</a>';
    }
}
```

## Widget Areas

```php
register_sidebar([
    'name' => __('Main Sidebar', 'my-theme'),
    'id' => 'main-sidebar',
    'description' => __('Widgets for main sidebar', 'my-theme'),
    'before_widget' => '<div id="%1$s" class="widget %2$s">',
    'after_widget' => '</div>',
    'before_title' => '<h3 class="widget-title">',
    'after_title' => '</h3>',
]);

dynamic_sidebar('main-sidebar');
```
