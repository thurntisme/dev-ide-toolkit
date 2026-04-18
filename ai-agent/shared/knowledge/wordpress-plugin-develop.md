# WordPress Plugin Development

Function reference library for WordPress plugin development.

## Register Custom Post Type

### Function Name
`register_custom_post_type`

### Description
Registers a custom post type for storing custom content.

### Parameters
| Name | Type | Description |
|------|------|-------------|
| $slug | string | Post type slug |
| $args | array | Post type arguments |

### Code Example

```php
function register_custom_post_type($slug, $args = []) {
    $defaults = [
        'labels' => [
            'name' => ucfirst($slug),
            'singular_name' => ucfirst($slug),
        ],
        'public' => true,
        'show_in_rest' => true,
        'supports' => ['title', 'editor', 'thumbnail'],
    ];

    register_post_type($slug, array_merge($defaults, $args));
}
```

---

## Register Custom Taxonomy

### Function Name
`register_custom_taxonomy`

### Description
Registers a custom taxonomy for organizing content.

### Parameters
| Name | Type | Description |
|------|------|-------------|
| $taxonomy | string | Taxonomy slug |
| $object_type | string | Post type to attach to |
| $args | array | Taxonomy arguments |

### Code Example

```php
function register_custom_taxonomy($taxonomy, $object_type, $args = []) {
    $defaults = [
        'labels' => [
            'name' => ucfirst($taxonomy),
            'singular_name' => ucfirst($taxonomy),
        ],
        'hierarchical' => true,
        'show_in_rest' => true,
    ];

    register_taxonomy($taxonomy, $object_type, array_merge($defaults, $args));
}
```

---

## Add Menu Page

### Function Name
`add_admin_menu_page`

### Description
Adds a top-level menu page to the WordPress admin.

### Parameters
| Name | Type | Description |
|------|------|-------------|
| $page_title | string | Page title |
| $menu_title | string | Menu title |
| $capability | string | Required capability |
| $menu_slug | string | Menu slug |
| $callback | callable | Page callback |
| $icon_url | string | Menu icon |
| $position | int | Menu position |

### Code Example

```php
function add_admin_menu_page($page_title, $menu_title, $capability, $menu_slug, $callback, $icon_url = 'dashicons-admin-generic', $position = null) {
    add_menu_page(
        $page_title,
        $menu_title,
        $capability,
        $menu_slug,
        $callback,
        $icon_url,
        $position
    );
}
```

---

## Enqueue Admin Script

### Function Name
`enqueue_admin_script`

### Description
Enqueues a script in the WordPress admin area.

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
function enqueue_admin_script($handle, $src, $deps = [], $ver = null, $in_footer = true) {
    wp_enqueue_script($handle, $src, $deps, $ver, $in_footer);
}
```

---

## Create Database Table on Activation

### Function Name
`create_table_on_activation`

### Description
Creates a custom database table when plugin activates.

### Parameters
| Name | Type | Description |
|------|------|-------------|
| $table_name | string | Table name |
| $sql | string | CREATE TABLE SQL |

### Code Example

```php
function create_table_on_activation($table_name, $sql) {
    global $wpdb;

    $charset_collate = $wpdb->get_charset_collate();
    $full_sql = str_replace('{$charset_collate}', $charset_collate, $sql);

    require_once(ABSPATH . 'wp-admin/includes/upgrade.php');
    dbDelta($full_sql);
}
```

---

## Add Plugin Action Link

### Function Name
`add_plugin_action_link`

### Description
Adds a link to the plugin row on the Plugins page.

### Parameters
| Name | Type | Description |
|------|------|-------------|
| $links | array | Plugin links array |
| $plugin_file | string | Plugin file path |

### Code Example

```php
function add_plugin_action_link($links, $plugin_file) {
    $settings_link = '<a href="' . admin_url('admin.php?page=plugin-settings') . '">Settings</a>';
    array_unshift($links, $settings_link);
    return $links;
}
add_filter('plugin_action_links_' . plugin_basename(__FILE__), 'add_plugin_action_link');
```

---

## Register REST API Endpoint

### Function Name
`register_rest_endpoint`

### Description
Registers a custom REST API endpoint.

### Parameters
| Name | Type | Description |
|------|------|-------------|
| $route | string | Route path |
| $args | array | Endpoint arguments |
| $method | string | HTTP method |

### Code Example

```php
function register_rest_endpoint($route, $args, $method = 'GET') {
    register_rest_route('my-plugin/v1', $route, [
        'methods' => $method,
        'callback' => $args['callback'],
        'permission_callback' => $args['permission'] ?? '__return_true',
    ]);
}
```

---

## Shortcode Definition

### Function Name
`register_shortcode`

### Description
Registers a WordPress shortcode.

### Parameters
| Name | Type | Description |
|------|------|-------------|
| $tag | string | Shortcode tag |
| $callback | callable | Callback function |

### Code Example

```php
function register_shortcode($tag, $callback) {
    add_shortcode($tag, $callback);
}
```

---

## AJAX Handler

### Function Name
`register_ajax_handler`

### Description
Registers an AJAX handler for logged-in users.

### Parameters
| Name | Type | Description |
|------|------|-------------|
| $action | string | AJAX action name |
| $callback | callable | Handler callback |

### Code Example

```php
function register_ajax_handler($action, $callback) {
    add_action('wp_ajax_' . $action, $callback);
    add_action('wp_ajax_nopriv_' . $action, $callback);
}
```

---

## Plugin Options

### Function Name
`get_plugin_option`

### Description
Retrieves a plugin option value.

### Parameters
| Name | Type | Description |
|------|------|-------------|
| $key | string | Option key |
| $default | mixed | Default value |

### Code Example

```php
function get_plugin_option($key, $default = false) {
    $options = get_option('my_plugin_settings', []);
    return $options[$key] ?? $default;
}
```

---

## Update Plugin Option

### Function Name
`update_plugin_option`

### Description
Updates a plugin option value.

### Parameters
| Name | Type | Description |
|------|------|-------------|
| $key | string | Option key |
| $value | mixed | Option value |

### Code Example

```php
function update_plugin_option($key, $value) {
    $options = get_option('my_plugin_settings', []);
    $options[$key] = $value;
    update_option('my_plugin_settings', $options);
}
```