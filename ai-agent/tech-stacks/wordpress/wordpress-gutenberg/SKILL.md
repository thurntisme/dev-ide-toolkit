---
name: wordpress-gutenberg
description: WordPress Gutenberg block development. Use when user asks to create custom Gutenberg blocks or block editor functionality.
---

# Gutenberg Block Development

## When to use
- User asks to create Gutenberg block
- User asks to register custom blocks
- User asks about block editor
- User needs dynamic blocks

## Block Structure

```
my-block/
├── block.json          # Block metadata
├── index.js          # Block registration
├── edit.js          # Editor component
├── save.js          # Frontend markup
└── style.css        # Frontend styles
```

## block.json

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
    },
    "supports": {
        "html": false
    }
}
```

## index.js (Register Block)

```javascript
import { registerBlockType } from '@wordpress/blocks';
import edit from './edit';
import save from './save';

registerBlockType('my-plugin/my-block', {
    edit,
    save,
});
```

## edit.js (Editor)

```javascript
import { useBlockProps, RichText } from '@wordpress/block-editor';

export default function Edit({ attributes, setAttributes }) {
    const blockProps = useBlockProps();
    return (
        <div {...blockProps}>
            <RichText
                tagName="h2"
                value={attributes.content}
                onChange={(content) => setAttributes({ content })}
                placeholder="Enter heading..."
            />
        </div>
    );
}
```

## save.js (Frontend)

```javascript
import { useBlockProps, RichText } from '@wordpress/block-editor';

export default function Save({ attributes }) {
    return (
        <div {...useBlockProps.save()}>
            <h2>{attributes.content}</h2>
        </div>
    );
}
```

## Dynamic Block (PHP Render)

```php
register_block_type('my-plugin/my-block', [
    'render_callback' => function($attributes) {
        return '<div class="my-block"><h2>' . $attributes['content'] . '</h2></div>';
    },
]);
```

## Block Categories

```javascript
registerBlockType('my-plugin/my-block', {
    category: 'design',
    category: 'layout',
    category: 'widgets',
    category: 'text',
    category: 'media',
    category: 'theme',
    category: 'embed',
});
```

## Inner Blocks

```javascript
import { InnerBlocks } from '@wordpress/block-editor';

<InnerBlocksAllowedBlocks />
// or
<InnerBlocks template={[['core/paragraph']]} />
```

## Block Patterns

```php
register_block_pattern('my-plugin/my-pattern', [
    'title'    => __('My Pattern', 'my-plugin'),
    'content' => '<!-- wp:paragraph {"content":"Hello"} --><p>Hello</p><!-- /wp:paragraph -->',
]);
```