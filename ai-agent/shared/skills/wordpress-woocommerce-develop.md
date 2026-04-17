---
name: wordpress-woocommerce-develop
description: WooCommerce development specialist. Use when user asks to create, modify, or debug WooCommerce themes, plugins, or extensions.
---

# WooCommerce Development

## When to use
- User asks to create a WooCommerce theme or plugin
- User asks about WooCommerce product types
- User asks about WooCommerce hooks and filters
- User asks about WooCommerce checkout/customization
- User asks about WooCommerce REST API
- User asks about WooCommerce admin settings

## File Structure

```
my-woocommerce-plugin/
├── my-woocommerce-plugin.php    # Main plugin file
├── uninstall.php
├── includes/
│   ├── class-my-plugin.php
│   ├── class-admin.php
│   ├── class-frontend.php
│   └── class-rest-api.php
├── templates/
│   └── my-template.php
└── assets/
    ├── css/
    └── js/
```

## Plugin Header

```php
/*
Plugin Name: My WooCommerce Plugin
Plugin URI:  https://example.com/
Description: Description here
Version:     1.0.0
Author:      Your Name
Author URI:  https://example.com/
Requires at least: 6.0
Requires PHP: 7.4
WC requires at least: 7.0
WC tested up to: 8.0
License:     GPLv2 or later
Text Domain: my-woocommerce-plugin
*/
```

## Check WooCommerce Active

```php
// Check if WooCommerce is active
function my_plugin_check_wc() {
    if (!class_exists('WooCommerce')) {
        add_action('admin_notices', function() {
            echo '<div class="notice notice-error"><p>';
            echo __('My Plugin requires WooCommerce to be installed and active.', 'my-plugin');
            echo '</p></div>';
        });
        return false;
    }
    return true;
}

// Get WooCommerce instance
$woo = WC();
```

## Product Types

### Simple Product

```php
$product = new WC_Product_Simple();
$product->set_name('My Product');
$product->set_status('publish');
$product->set_regular_price(29.99);
$product->set_description('Product description');
$product->set_short_description('Short description');
$product->set_sku('MY-SKU-001');
$product->set_stock_quantity(100);
$product->save();
```

### Variable Product

```php
$product = new WC_Product_Variable();
$product->set_name('Variable Product');
$product->set_status('publish');
$product->save();

$variation1 = new WC_Product_Variation();
$variation1->set_parent_id($product->get_id());
$variation1->set_regular_price(19.99);
$variation1->set_stock_quantity(50);
$variation1->set_attributes(['pa_color' => 'red']);
$variation1->save();

$variation2 = new WC_Product_Variation();
$variation2->set_parent_id($product->get_id());
$variation2->set_regular_price(24.99);
$variation2->set_stock_quantity(30);
$variation2->set_attributes(['pa_color' => 'blue']);
$variation2->save();
```

### Grouped Product

```php
$grouped = new WC_Product_Grouped();
$grouped->set_name('Grouped Product');
$grouped->set_children([$child1->get_id(), $child2->get_id()]);
$grouped->save();
```

### External/Affiliate Product

```php
$product = new WC_Product_External();
$product->set_name('Affiliate Product');
$product->set_product_url('https://affiliate-link.com/product');
$product->set_button_text('Buy Now');
$product->set_regular_price(49.99);
$product->save();
```

## Product Data Store

```php
// Get product by ID
$product = wc_get_product($product_id);

// Get product type
$product->get_type(); // 'simple', 'variable', 'grouped', 'external'

// Product methods
$product->get_name();
$product->get_price();
$product->get_regular_price();
$product->get_sale_price();
$product->get_stock_quantity();
$product->is_in_stock();
$product->get_sku();
$product->get_short_description();
$product->get_description();
$product->get_image();
$product->get_permalink();

// Set product data
$product->set_name('New Name');
$product->set_price(39.99);
$product->save();
```

## Product Attributes

### Global Attributes (Taxonomies)

```php
// Create attribute
$attribute = wc_create_attribute([
    'name' => 'Color',
    'slug' => 'pa_color',
    'type' => 'select',
    'order_by' => 'menu_order',
    'has_archives' => true,
]);

// Add terms to attribute
wp_insert_term('Red', 'pa_color', ['slug' => 'red']);
wp_insert_term('Blue', 'pa_color', ['slug' => 'blue']);

// Assign to product
$product = wc_get_product($product_id);
$product->set_attributes([
    [
        'id' => $attribute->attribute_id,
        'name' => 'pa_color',
        'options' => [get_term_by('slug', 'red', 'pa_color')->term_id],
    ]
]);
$product->save();
```

### Local Attributes

```php
$product->set_attributes([
    [
        'name' => 'Color',
        'value' => 'Red | Blue',
        'is_visible' => 1,
        'is_taxonomy' => 0,
    ]
]);
$product->save();
```

## Product Classes

```php
// CRUD operations
$product = wc_get_product($product_id);

// Read
$name = $product->get_name();
$price = $product->get_price();
$regular_price = $product->get_regular_price();
$sale_price = $product->get_sale_price();

// Update
$product->set_name('New Name');
$product->set_price(29.99);
$product->save();

// Delete
$product->delete(true); // true to force delete (skip trash)
```

## Orders

### Create Order

```php
$order = wc_create_order();
$order->add_product(wc_get_product($product_id), 2);
$order->set_address([
    'first_name' => 'John',
    'last_name' => 'Doe',
    'email' => 'john@example.com',
    'address_1' => '123 Main St',
    'city' => 'New York',
    'country' => 'US',
], 'billing');
$order->set_address([
    'first_name' => 'John',
    'last_name' => 'Doe',
    'address_1' => '123 Main St',
    'city' => 'New York',
    'country' => 'US',
], 'shipping');
$order->set_payment_method('bacs');
$order->calculate_totals();
$order->save();
```

### Order Statuses

```php
// Available statuses
'wc-pending'    // Pending payment
'wc-processing' // Processing
'wc-on-hold'    // On hold
'wc-completed'  // Completed
'wc-cancelled'  // Cancelled
'wc-refunded'   // Refunded
'wc-failed'     // Failed

// Update order status
$order->set_status('completed');
$order->save();

// Or use helper
wc_update_order($order_id, ['status' => 'completed']);
```

### Order Methods

```php
$order = wc_get_order($order_id);

$order->get_id();
$order->get_user_id();
$order->get_formatted_order_total();
$order->get_subtotal();
$order->get_total();
$order->get_total_tax();
$order->get_shipping_total();
$order->get_payment_method();
$order->get_billing_email();
$order->get_billing_first_name();
$order->get_billing_last_name();
$order->get_billing_address_1();
$order->get_billing_city();
$order->get_billing_country();

// Get order items
foreach ($order->get_items() as $item_id => $item) {
    $product = $item->get_product();
    $quantity = $item->get_quantity();
    $total = $item->get_total();
}
```

## Cart

### Add to Cart

```php
// Add product to cart
WC()->cart->add_to_cart($product_id, $quantity = 1, $variation_id = 0, $variation = [], $cart_item_data = []);

// Add with cart item data
WC()->cart->add_to_cart($product_id, 1, 0, [], ['custom_data' => 'value']);

// Add multiple products
WC()->cart->add_to_cart($product_id_1, 1);
WC()->cart->add_to_cart($product_id_2, 2);
```

### Cart Methods

```php
$cart = WC()->cart;

$cart->get_cart_contents_count();
$cart->get_cart_total();
$cart->get_subtotal();
$cart->get_shipping_total();
$cart->get_total_tax();
$cart->get_fee_total();
$cart->get_discount_total();

// Check if cart is empty
$cart->is_empty();

// Get cart contents
foreach ($cart->get_cart() as $cart_item_key => $cart_item) {
    $product = $cart_item['data'];
    $quantity = $cart_item['quantity'];
    $custom_data = $cart_item['custom_data'];
}
```

### Update Cart

```php
// Update quantity
WC()->cart->set_quantity($cart_item_key, $quantity);

// Remove item
WC()->cart->remove_cart_item($cart_item_key);

// Empty cart
WC()->cart->empty_cart();

// Recalculate totals
WC()->cart->calculate_totals();
```

## Hooks

### Product Hooks

```php
// Product save
add_action('woocommerce_new_product', 'my_new_product_function', 10, 1);
add_action('woocommerce_update_product', 'my_update_product_function', 10, 1);
add_action('woocommerce_delete_product', 'my_delete_product_function', 10, 1);

// Product display
add_filter('woocommerce_product_is_visible', function($visible, $product_id) {
    return $visible;
}, 10, 2);

add_filter('woocommerce_product_get_price', function($price, $product) {
    return $price;
}, 10, 2);

add_filter('woocommerce_product_single_add_to_cart_text', function($text, $product) {
    return __('Add to Cart', 'my-plugin');
}, 10, 2);
```

### Cart Hooks

```php
// Add to cart
add_action('woocommerce_add_to_cart', function($cart_item_key, $product_id, $quantity, $variation_id, $variation, $cart_item_data) {
    // Custom logic
}, 10, 6);

// Before calculate totals
add_action('woocommerce_before_calculate_totals', function($cart) {
    foreach ($cart->get_cart() as $cart_item) {
        // Modify cart item price
        $cart_item['data']->set_price(20);
    }
}, 10, 1);

// Cart item price
add_filter('woocommerce_cart_item_price', function($price, $cart_item, $cart_item_key) {
    return $price;
}, 10, 3);

// Cart item subtotal
add_filter('woocommerce_cart_item_subtotal', function($subtotal, $cart_item, $cart_item_key) {
    return $subtotal;
}, 10, 3);
```

### Checkout Hooks

```php
// Checkout fields
add_filter('woocommerce_checkout_fields', function($fields) {
    unset($fields['billing']['billing_company']);
    return $fields;
});

// Validate checkout
add_action('woocommerce_after_checkout_validation', function($posted) {
    if (empty($_POST['my_custom_field'])) {
        wc_add_notice(__('Custom field is required', 'my-plugin'), 'error');
    }
});

// Order created
add_action('woocommerce_checkout_order_created', function($order) {
    // Add order meta
    $order->update_meta_data('_my_meta_key', 'value');
    $order->save();
});

// Order status changed
add_action('woocommerce_order_status_changed', function($order_id, $from, $to, $order) {
    // Send notification, update inventory, etc.
}, 10, 4);
```

### Order Hooks

```php
// New order
add_action('woocommerce_new_order', function($order_id) {
    $order = wc_get_order($order_id);
}, 10, 1);

// Order saved
add_action('woocommerce_saved_order_items', function($order_id, $items) {
    // Handle order item changes
}, 10, 2);
```

### AJAX Hooks

```php
// Add to cart AJAX
add_action('wp_ajax_woocommerce_add_to_cart', function() {
    WC_AJAX::get_refreshed_fragments();
});
add_action('wp_ajax_nopriv_woocommerce_add_to_cart', function() {
    WC_AJAX::get_refreshed_fragments();
});
```

## Shortcodes

```php
// Product shortcodes
[products limit="4" columns="4" orderby="popularity" on_sale="1"]
[product id="123"]
[product_page id="123"]
[product_category category="clothing"]
[product_categories parent="0" number="12"]
[recent_products per_page="12" columns="4"]
[sale_products per_page="12" columns="4"]
[best_selling_products per_page="12" columns="4"]
[top_rated_products per_page="12" columns="4"]
[product_attribute attribute="color" filter="red"]

// Cart & Checkout
[cart]
[checkout]
[my_account]
[woocommerce_cart]
[woocommerce_checkout]

// Order tracking
[woocommerce_order_tracking order_id="123"]
```

## REST API

### Register Endpoint

```php
add_action('rest_api_init', function() {
    register_rest_route('my-plugin/v1', '/products', [
        'methods' => 'GET',
        'callback' => function($request) {
            $args = [
                'post_type' => 'product',
                'posts_per_page' => $request->get_param('per_page') ?: 10,
            ];
            $products = wc_get_products($args);
            
            $data = [];
            foreach ($products as $product) {
                $data[] = [
                    'id' => $product->get_id(),
                    'name' => $product->get_name(),
                    'price' => $product->get_price(),
                ];
            }
            
            return rest_ensure_response($data);
        },
        'permission_callback' => '__return_true',
    ]);
});
```

### WooCommerce REST API Authentication

```php
// Consumer keys in WooCommerce Settings > Advanced > REST API
// Use OAuth 1.0a or JWT authentication

// Consumer Key: ck_xxxxx
// Consumer Secret: cs_xxxxx

// Example request
$headers = [
    'Authorization' => 'Basic ' . base64_encode($consumer_key . ':' . $consumer_secret)
];
```

## Admin Settings

### Add Settings Tab

```php
add_filter('woocommerce_settings_tabs_array', function($tabs) {
    $tabs['my_tab'] = __('My Tab', 'my-plugin');
    return $tabs;
}, 50);

// Section in tab
add_action('woocommerce_settings_my_tab', function() {
    woocommerce_admin_fields($this->get_settings());
});

// Save settings
add_action('woocommerce_update_options_my_tab', function() {
    woocommerce_update_options($this->get_settings());
});

// Get settings
public function get_settings() {
    return [
        [
            'title' => __('Section Title', 'my-plugin'),
            'type' => 'title',
            'id' => 'my_section',
        ],
        [
            'title' => __('Enable Feature', 'my-plugin'),
            'desc' => __('Enable my feature', 'my-plugin'),
            'id' => 'my_plugin_enabled',
            'default' => 'yes',
            'type' => 'checkbox',
        ],
        [
            'title' => __('API Key', 'my-plugin'),
            'desc' => __('Enter your API key', 'my-plugin'),
            'id' => 'my_plugin_api_key',
            'type' => 'text',
        ],
        [
            'type' => 'sectionend',
            'id' => 'my_section',
        ],
    ];
}
```

## Shipping Methods

```php
class My_Shipping_Method extends WC_Shipping_Method {
    
    public function __construct($instance_id = 0) {
        $this->id = 'my_shipping';
        $this->method_title = __('My Shipping', 'my-plugin');
        $this->method_description = __('Custom shipping method', 'my-plugin');
        $this->enabled = 'yes';
        $this->title = __('My Shipping', 'my-plugin');
        
        $this->init();
    }
    
    public function init() {
        $this->form_fields = [
            'cost' => [
                'title' => __('Cost', 'my-plugin'),
                'type' => 'text',
                'description' => __('Shipping cost', 'my-plugin'),
            ],
        ];
        $this->init_form_fields();
        $this->instance_form_fields = $this->form_fields;
        $this->title = $this->get_option('title', __('My Shipping', 'my-plugin'));
    }
    
    public function calculate_shipping($package = []) {
        $cost = $this->get_option('cost', 0);
        
        $this->add_rate([
            'id' => $this->get_rate_id(),
            'label' => $this->title,
            'cost' => $cost,
            'calc_tax' => 'per_item',
        ]);
    }
}

// Register shipping method
add_filter('woocommerce_shipping_methods', function($methods) {
    $methods['my_shipping'] = 'My_Shipping_Method';
    return $methods;
});
```

## Payment Gateways

```php
class My_Payment_Gateway extends WC_Payment_Gateway {
    
    public function __construct() {
        $this->id = 'my_payment';
        $this->has_fields = true;
        $this->method_title = __('My Payment', 'my-plugin');
        $this->method_description = __('Payment gateway description', 'my-plugin');
        $this->supports = ['products', 'refunds'];
        
        $this->init_form_fields();
        $this->init_settings();
        
        $this->title = $this->get_option('title');
        $this->description = $this->get_option('description');
    }
    
    public function init_form_fields() {
        $this->form_fields = [
            'enabled' => [
                'title' => __('Enable', 'my-plugin'),
                'type' => 'checkbox',
            ],
            'title' => [
                'title' => __('Title', 'my-plugin'),
                'type' => 'text',
            ],
            'api_key' => [
                'title' => __('API Key', 'my-plugin'),
                'type' => 'password',
            ],
        ];
    }
    
    public function process_payment($order_id) {
        $order = wc_get_order($order_id);
        
        // Process payment logic
        $transaction_id = $this->process_payment_api($order);
        
        if ($transaction_id) {
            $order->payment_complete($transaction_id);
            $order->add_order_note(__('Payment received', 'my-plugin'));
            WC()->cart->empty_cart();
            
            return [
                'result' => 'success',
                'redirect' => $order->get_checkout_order_received_url(),
            ];
        } else {
            $order->add_order_note(__('Payment failed', 'my-plugin'));
            wc_add_notice(__('Payment error', 'my-plugin'), 'error');
            return ['result' => 'fail'];
        }
    }
    
    public function process_refund($order_id, $amount = null, $reason = '') {
        // Process refund
        return true;
    }
}

// Register gateway
add_filter('woocommerce_payment_gateways', function($gateways) {
    $gateways[] = 'My_Payment_Gateway';
    return $gateways;
});
```

## Template Overrides

```php
// Create template in theme
// wp-content/themes/my-theme/woocommerce/single-product/add-to-cart/variation-add-to-cart-button.php

// Check if template exists
if (wc_locate_template('single-product/add-to-cart/variation-add-to-cart-button.php')) {
    // Template exists
}

// Get template path
$template = locate_template('woocommerce/single-product/add-to-cart/variation.php');
```

## Email Templates

```php
// Custom email class
class My_Email extends WC_Email {
    
    public function __construct() {
        $this->id = 'my_email';
        $this->title = __('My Email', 'my-plugin');
        $this->description = __('Custom email', 'my-plugin');
        $this->template_html = 'emails/my-email.php';
        $this->template_plain = 'emails/plain/my-email.php';
        
        add_action('my_custom_trigger', [$this, 'trigger']);
    }
    
    public function trigger($order_id) {
        $this->object = wc_get_order($order_id);
        $this->send($this->object->get_billing_email(), $this->get_subject(), $this->get_content(), $this->get_headers(), $this->get_attachments());
    }
    
    public function get_content_html() {
        ob_start();
        wc_get_template($this->template_html, [
            'order' => $this->object,
            'email_heading' => $this->get_heading(),
        ]);
        return ob_get_clean();
    }
}

// Trigger email
do_action('my_custom_trigger', $order_id);
```

## Dashboard Widget

```php
add_action('wp_dashboard_setup', function() {
    wp_add_dashboard_widget('my_wc_widget', __('WooCommerce Stats', 'my-plugin'), function() {
        $order_count = wc_orders_count();
        $sales_total = wc_get_sales_summary_date_range();
        
        echo '<p>Orders: ' . esc_html($order_count) . '</p>';
        echo '<p>Sales: ' . wp_kses_post(wc_price($sales_total['net_sales'])) . '</p>';
    });
});
```
