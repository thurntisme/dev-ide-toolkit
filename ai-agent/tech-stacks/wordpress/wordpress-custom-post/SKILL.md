---
name: wordpress-custom-post
description: WordPress Custom Post Types and Taxonomies. Use when user asks to create CPT, custom taxonomies, or custom content types.
---

# WordPress Custom Post Types & Taxonomies

## When to use
- User asks to create custom post type
- User asks to create custom taxonomy
- User needs to register custom content types
- User asks about CPT UI

## Custom Post Type

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

## Custom Taxonomy

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

## Flush Rewrite

```php
function my_flush_rewrite() {
    register_post_type('book', ['public' => true]);
    flush_rewriteRules();
}
register_activation_hook(__FILE__, 'my_flush_rewrite');
```

## Archive Template

```php
// archive-book.php
get_header();
while (have_posts()) : the_post();
    get_template_part('content', 'book');
endwhile;
get_footer();
```

## Single Template

```php
// single-book.php
get_header();
while (have_posts()) : the_post();
    get_template_part('content', 'single-book');
endwhile;
get_footer();
```

## Labels Reference

| Label | Usage |
|-------|-------|
| name | Plural name |
| singular_name | Singular name |
| menu_name | Menu label |
| add_new | Add new |
| add_new_item | Add new item |
| edit_item | Edit item |
| new_item | New item |
| view_item | View item |
| search_items | Search items |