---
name: wordpress-rest-api
description: WordPress REST API. Use when user asks to create REST API endpoints, APIs, or work with WP REST.
---

# WordPress REST API Guide

## When to use
- User asks to create REST API endpoints
- User asks to fetch data via REST
- User asks about WP REST routes
- User needs custom API

## Register REST Route

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

## Custom Endpoint with Params

```php
register_rest_route('my-plugin/v1', '/books/(?P<id>\d+)', [
    'methods'  => WP_REST_Server::READABLE,
    'callback' => 'get_book_by_id',
    'permission_callback' => '__return_true',
]);

function get_book_by_id($request) {
    $id = $request['id'];
    $book = get_post($id);
    return rest_ensure_response($book);
}
```

## POST Request

```php
register_rest_route('my-plugin/v1', '/books', [
    'methods'  => WP_REST_Server::CREATABLE,
    'callback' => 'create_book',
    'permission_callback' => function() {
        return current_user_can('edit_posts');
    },
]);

function create_book($request) {
    $title = $request->get_param('title');
    $post_id = wp_insert_post([
        'post_title' => $title,
        'post_type' => 'book',
        'post_status' => 'publish',
    ]);
    return rest_ensure_response(['id' => $post_id]);
}
```

## Custom Taxonomy in REST

```php
register_taxonomy('genre', 'book', [
    'show_in_rest' => true,
    'rest_base'  => 'genres',
]);
```

## Response Format

```php
return rest_ensure_response([
    'id'      => $book->ID,
    'title'   => $book->post_title,
    'content' => $book->post_content,
    'meta'    => get_post_meta($book->ID),
]);
```

## Error Handling

```php
return new WP_Error('no_book', 'Book not found', ['status' => 404]);
```