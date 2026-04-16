---
name: wordpress-block-theme
description: WordPress Full Site Editing (FSE) theme development. Use when user asks to create block themes or work with site editor.
---

# WordPress Block Theme Guide

## When to use
- User asks to create block theme
- User asks about Full Site Editing (FSE)
- User asks to create theme.json
- User asks about site editor

## Theme Structure

```
wp-content/themes/my-block-theme/
├── theme.json           # Theme configuration
├── functions.php      # Theme functions
├── index.php          # Fallback template
├── styles/
│   └── (optional style variations)
├── templates/
│   ├── index.html
│   ├── front-page.html
│   ├── single.html
│   ├── page.html
│   ├── archive.html
│   └── 404.html
└── parts/
    ├── header.html
    ├── footer.html
    ├── sidebar.html
    └── content.html
```

## theme.json

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
    "styles": {
        "color": { "background": "#ffffff" },
        "typography": { "fontSize": "16px" }
    },
    "templateParts": [
        { "name": "header", "title": "Header" },
        { "name": "footer", "title": "Footer" }
    ]
}
```

## index.php (Required)

```php
<?php
// Empty - block theme uses templates/
```

## templates/index.html

```html
<!-- wp:template-part {"slug": "header", "tagName": "header"} /-->
<!-- wp:post-content {"layout":"full"} /-->
<!-- wp:template-part {"slug": "footer", "tagName": "footer"} /-->
```

## parts/header.html

```html
<!-- wp:group {"layout":{"type":"flex","justifyContent":"space-between"}} -->
    <!-- wp:site-logo {"width":180,"height":60} /-->
    <!-- wp:navigation {"textColor":"white","backgroundColor":"black"} /-->
<!-- /wp:group -->
```

## parts/footer.html

```html
<!-- wp:group {"tagName":"footer"} -->
    <!-- wp:paragraph {"align":"center"} -->
    <p class="has-text-align-center">&copy; 2024 My Site</p>
    <!-- /wp:paragraph -->
<!-- /wp:group -->
```

## Theme Support

```php
add_theme_support('block-templates');
add_theme_support('editor-styles');
add_theme_support('wp-block-styles');
add_theme_support('responsive-embeds');
```

## Block Style Variations

```json
{
    "styles": {
        "variations": {
            "blue": {
                "title": "Blue",
                "color": { "background": "#0000ff" }
            }
        }
    }
}
```

## Patterns Registration

```php
register_block_pattern('my-theme/hero', [
    'title'    => __('Hero Section', 'my-theme'),
    'content' => '<!-- wp:cover {"url":""} -->...',
]);
```

## Locking Blocks

```html
<!-- wp:group {"lock":{"move":true,"remove":true}} -->
...
<!-- /wp:group -->
```