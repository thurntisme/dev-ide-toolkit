---
name: wordpress-ajax
description: WordPress AJAX. Use when user asks to implement AJAX in WordPress or handle async requests.
---

# WordPress AJAX Guide

## When to use
- User asks for AJAX in WordPress
- User needs async data loading
- User asks about wp_ajax hooks

## Frontend AJAX

### Enqueue Script

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

## Backend AJAX (Admin)

```php
add_action('wp_ajax_my_admin_action', 'my_admin_handler');

function my_admin_handler() {
    check_ajax_referer('my_admin_nonce', 'nonce');
    
    if (!current_user_can('edit_posts')) {
        wp_send_json_error('Unauthorized');
    }
    
    wp_send_json_success(['message' => 'Done']);
}
```

## Nonce Verification

```php
// Create nonce
wp_localize_script('my-script', 'myAjax', ['nonce' => wp_create_nonce('my_nonce')]);

// Verify
check_ajax_referer('my_nonce', 'nonce');
```

## Response Helpers

```php
wp_send_json_success(['data' => $data]);
wp_send_json_error(['message' => 'Error']);
wp_send_json_response($data);
```

## Common Errors

| Error | Fix |
|-------|-----|
| 400 | Check data parameters |
| 403 | Verify nonce |
| 0 | Check PHP errors |
| 400 Bad Request | JSON format |