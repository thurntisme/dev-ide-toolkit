# WordPress Theme Development

Function reference library for WordPress theme development.

## Register Theme Support

### Function Name
`register_theme_support`

### Description
Registers theme support for a specific feature.

### Parameters
| Name | Type | Description |
|------|------|-------------|
| $feature | string | Feature to support |
| $args | array | Feature arguments |

### Code Example

```php
function register_theme_support($feature, $args = []) {
    add_theme_support($feature, $args);
}

// Usage
add_action('after_setup_theme', function() {
    register_theme_support('post-thumbnails');
    register_theme_support('title-tag');
    register_theme_support('custom-logo', ['height' => 100, 'width' => 400]);
    register_theme_support('html5', ['search-form', 'comment-form']);
});
```

---

## Register Navigation Menu

### Function Name
`register_nav_menu`

### Description
Registers a navigation menu location.

### Parameters
| Name | Type | Description |
|------|------|-------------|
| $location | string | Menu location |
| $description | string | Menu description |

### Code Example

```php
function register_nav_menu($location, $description) {
    register_nav_menu($location, $description);
}

// Usage
register_nav_menu('primary', 'Primary Menu');
register_nav_menu('footer', 'Footer Menu');
```

---

## Register Sidebar

### Function Name
`register_sidebar`

### Description
Registers a widget area.

### Parameters
| Name | Type | Description |
|------|------|-------------|
| $id | string | Sidebar ID |
| $name | string | Sidebar name |
| $args | array | Sidebar arguments |

### Code Example

```php
function register_sidebar($id, $name, $args = []) {
    $defaults = [
        'name' => $name,
        'id' => $id,
        'before_widget' => '<aside id="%1$s" class="widget %2$s">',
        'after_widget' => '</aside>',
        'before_title' => '<h3 class="widget-title">',
        'after_title' => '</h3>',
    ];

    register_sidebar(array_merge($defaults, $args));
}

// Usage
register_sidebar('primary-sidebar', 'Primary Sidebar');
```

---

## Enqueue Theme Styles

### Function Name
`enqueue_theme_style`

### Description
Enqueues a theme stylesheet.

### Parameters
| Name | Type | Description |
|------|------|-------------|
| $handle | string | Style handle |
| $src | string | Stylesheet URL |
| $deps | array | Dependencies |
| $ver | string | Version |
| $media | string | Media type |

### Code Example

```php
function enqueue_theme_style($handle, $src, $deps = [], $ver = null, $media = 'all') {
    wp_enqueue_style($handle, $src, $deps, $ver, $media);
}

// Usage
function my_theme_enqueue_styles() {
    enqueue_theme_style('main-style', get_stylesheet_uri());
}
add_action('wp_enqueue_scripts', 'my_theme_enqueue_styles');
```

---

## Enqueue Theme Script

### Function Name
`enqueue_theme_script`

### Description
Enqueues a theme JavaScript file.

### Parameters
| Name | Type | Description |
|------|------|-------------|
| $handle | string | Script handle |
| $src | string | Script URL |
| $deps | array | Dependencies |
| $ver | string | Version |
| $in_footer | bool | Load in footer |

### Code Example

```php
function enqueue_theme_script($handle, $src, $deps = [], $ver = null, $in_footer = true) {
    wp_enqueue_script($handle, $src, $deps, $ver, $in_footer);
}

// Usage
enqueue_theme_script('theme-script', get_template_directory_uri() . '/js/main.js', ['jquery'], '1.0', true);
```

---

## Get Template Part

### Function Name
`get_template_part`

### Description
Loads a template part into a template.

### Parameters
| Name | Type | Description |
|------|------|-------------|
| $slug | string | Template slug |
| $name | string | Template name |

### Code Example

```php
// In template files
get_template_part('partials/content', 'post');

// Looks for: partials/content-post.php
```

---

## Custom Walker Menu

### Function Name
`create_walker_menu`

### Description
Creates a custom navigation menu walker.

### Code Example

```php
class Custom_Walker_Nav_Menu extends Walker_Nav_Menu {
    public function start_lvl(&$output, $depth = 0, $args = null) {
        $indent = str_repeat("\t", $depth);
        $output .= "\n$indent<ul class=\"sub-menu\">\n";
    }

    public function start_el(&$output, $item, $depth = 0, $args = null, $current_object_id = 0) {
        $indent = ($depth) ? str_repeat("\t", $depth) : '';
        $classes = empty($item->classes) ? [] : (array) $item->classes;
        $class_names = join(' ', apply_filters('nav_menu_css_class', array_filter($classes), $item));
        $output .= '<li class="' . $class_names . '">';
        $attributes = ' href="' . esc_attr($item->url) . '"';
        $title = apply_filters('the_title', $item->title, $item->ID);
        $item_output = $args->before . "<a $attributes>$title</a>" . $args->after;
        $output .= apply_filters('walker_nav_menu_start_el', $item_output, $item, $depth, $args);
    }
}
```

---

## Display Custom Logo

### Function Name
`display_custom_logo`

### Description
Displays the custom logo with customizer settings.

### Code Example

```php
function display_custom_logo() {
    if (function_exists('the_custom_logo')) {
        the_custom_logo();
    }
}

// Or with fallback
function display_custom_logo() {
    $custom_logo_id = get_theme_mod('custom_logo');
    $logo = wp_get_attachment_image($custom_logo_id, 'full', false, [
        'class' => 'custom-logo',
    ]);

    if ($logo) {
        echo '<a href="' . esc_url(home_url('/')) . '" class="custom-logo-link">';
        echo $logo;
        echo '</a>';
    } else {
        echo '<a href="' . esc_url(home_url('/')) . '" class="site-title">';
        bloginfo('name');
        echo '</a>';
    }
}
```

---

## Get PostThumbnail URL

### Function Name
`get_post_thumbnail_url`

### Description
Gets the featured image URL.

### Parameters
| Name | Type | Description |
|------|------|-------------|
| $post_id | int | Post ID |
| $size | string | Image size |

### Code Example

```php
function get_post_thumbnail_url($post_id = null, $size = 'full') {
    $post_id = $post_id ?: get_the_ID();
    $thumbnail_id = get_post_thumbnail_id($post_id);

    if ($thumbnail_id) {
        return wp_get_attachment_image_url($thumbnail_id, $size);
    }

    return false;
}
```

---

## Display Post Pagination

### Function Name
`display_post_pagination`

### Description
Displays pagination for post listings.

### Parameters
| Name | Type | Description |
|------|------|-------------|
| $query | WP_Query | Custom query |

### Code Example

```php
function display_post_pagination($query = null) {
    global $wp_query;

    $query = $query ?: $wp_query;
    $big = 999999999;

    $pagination = paginate_links([
        'base' => str_replace($big, '%#%', get_pagenum_link($big)),
        'format' => '?paged=%#%',
        'current' => max(1, get_query_var('paged')),
        'total' => $query->max_num_pages,
        'prev_text' => '&laquo; Previous',
        'next_text' => 'Next &raquo;',
        'mid_size' => 2,
    ]);

    if ($pagination) {
        echo '<div class="pagination">' . $pagination . '</div>';
    }
}
```

---

## Display Breadcrumbs

### Function Name
`display_breadcrumbs`

### Description
Displays navigation breadcrumbs.

### Code Example

```php
function display_breadcrumbs() {
    $delimiter = ' &raquo; ';
    $home = 'Home';
    $before = '<span class="current">';
    $after = '</span>';

    $home_link = home_url('/');

    echo '<nav class="breadcrumbs">';
    echo '<a href="' . $home_link . '">' . $home . '</a>' . $delimiter;

    if (is_category() || is_single()) {
        the_category(' &bull; ');
        if (is_single()) {
            echo $delimiter . $before . get_the_title() . $after;
        }
    } elseif (is_page()) {
        the_title();
    } elseif (is_search()) {
        echo $before . 'Search: ' . get_search_query() . $after;
    } elseif (is_404()) {
        echo $before . '404 Not Found' . $after;
    }

    echo '</nav>';
}
```

---

## Custom Excerpt Length

### Function Name
`custom_excerpt_length`

### Description
Sets a custom excerpt length.

### Parameters
| Name | Type | Description |
|------|------|-------------|
| $length | int | Word count |

### Code Example

```php
function custom_excerpt_length($length) {
    return 20;
}
add_filter('excerpt_length', 'custom_excerpt_length');
```

---

## Custom Excerpt More

### Function Name
`custom_excerpt_more`

### Description
Sets a custom excerpt more text.

### Parameters
| Name | Type | Description |
|------|------|-------------|
| $more | string | More text |

### Code Example

```php
function custom_excerpt_more($more) {
    return '...';
}
add_filter('excerpt_more', 'custom_excerpt_more');
```

---

## Theme Customizer Setting

### Function Name
`register_theme_customizer`

### Description
Adds customizer settings and controls.

### Parameters
| Name | Type | Description |
|------|------|-------------|
| $wp_customize | WP_Customize_Manager | Customizer object |
| $section_id | string | Section ID |
| $setting_id | string | Setting ID |
| $args | array | Arguments |

### Code Example

```php
function register_theme_customizer($wp_customize) {
    // Add Section
    $wp_customize->add_section('theme_options', [
        'title' => 'Theme Options',
        'priority' => 30,
    ]);

    // Add Setting
    $wp_customize->add_setting('header_text_color', [
        'default' => '#333333',
        'transport' => 'refresh',
    ]);

    // Add Control
    $wp_customize->add_control(new WP_Customize_Color_Control($wp_customize, 'header_text_color', [
        'label' => 'Header Text Color',
        'section' => 'theme_options',
        'settings' => 'header_text_color',
    ]));
}
add_action('customize_register', 'register_theme_customizer');
```