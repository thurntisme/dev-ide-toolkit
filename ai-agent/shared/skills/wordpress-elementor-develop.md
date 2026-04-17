---
name: wordpress-elementor-develop
description: Elementor page builder development specialist. Use when user asks to create, modify, or debug Elementor widgets, extensions, or templates.
---

# Elementor Development

## When to use
- User asks to create an Elementor widget
- User asks to modify an existing Elementor widget
- User asks about Elementor extensions
- User asks about Elementor template development
- User asks about Elementor controls or dynamic content
- User asks about Elementor PRO features

## Widget Structure

```
my-elementor-widget/
├── widgets/
│   └── my-widget.php
├── controls/
│   └── my-control.php
├── base/
│   └── base-widget.php
├── my-elementor-widget.php    # Main plugin file
└── includes.php
```

## Basic Widget

```php
<?php
namespace MyPlugin\Widgets;

use Elementor\Widget_Base;
use Elementor\Controls_Manager;

class My_Widget extends Widget_Base {

    public function get_name() {
        return 'my-widget';
    }

    public function get_title() {
        return __('My Widget', 'my-plugin');
    }

    public function get_icon() {
        return 'eicon-kit-drag-n-drop';
    }

    public function get_categories() {
        return ['general'];
    }

    public function get_style_depends() {
        return ['my-widget-style'];
    }

    public function get_script_depends() {
        return ['my-widget-script'];
    }

    protected function register_controls() {
        $this->start_controls_section('content_section', [
            'label' => __('Content', 'my-plugin'),
            'tab' => Controls_Manager::TAB_CONTENT,
        ]);

        $this->add_control('heading', [
            'label' => __('Heading', 'my-plugin'),
            'type' => Controls_Manager::TEXT,
            'default' => __('Hello World', 'my-plugin'),
            'placeholder' => __('Enter heading', 'my-plugin'),
            'label_block' => true,
        ]);

        $this->add_control('description', [
            'label' => __('Description', 'my-plugin'),
            'type' => Controls_Manager::TEXTAREA,
            'default' => __('Enter description', 'my-plugin'),
            'rows' => 5,
        ]);

        $this->add_control('link', [
            'label' => __('Link', 'my-plugin'),
            'type' => Controls_Manager::URL,
            'placeholder' => 'https://example.com',
            'default' => [
                'url' => '',
            ],
        ]);

        $this->end_controls_section();

        $this->start_controls_section('style_section', [
            'label' => __('Style', 'my-plugin'),
            'tab' => Controls_Manager::TAB_STYLE,
        ]);

        $this->add_control('heading_color', [
            'label' => __('Heading Color', 'my-plugin'),
            'type' => Controls_Manager::COLOR,
            'selectors' => [
                '{{WRAPPER}} .my-heading' => 'color: {{VALUE}}',
            ],
        ]);

        $this->add_group_control(
            \Elementor\Group_Control_Typography::get_type(),
            [
                'name' => 'heading_typography',
                'label' => __('Heading Typography', 'my-plugin'),
                'selector' => '{{WRAPPER}} .my-heading',
            ]
        );

        $this->end_controls_section();
    }

    protected function render() {
        $settings = $this->get_settings_for_display();
        ?>
        <div class="my-widget">
            <?php if (!empty($settings['link']['url'])) : ?>
                <a href="<?php echo esc_url($settings['link']['url']); ?>">
            <?php endif; ?>
                    <h2 class="my-heading"><?php echo esc_html($settings['heading']); ?></h2>
            <?php if (!empty($settings['link']['url'])) : ?>
                </a>
            <?php endif; ?>
            <p class="my-description"><?php echo esc_html($settings['description']); ?></p>
        </div>
        <?php
    }

    protected function content_template() {
        ?>
        <#
        var link = settings.link.url ? 'href="' + settings.link.url + '"' : '';
        #>
        <div class="my-widget">
            <# if (settings.link.url) { #>
                <a {{{ link }}}>
            <# } #>
                    <h2 class="my-heading">{{{ settings.heading }}}</h2>
            <# if (settings.link.url) { #>
                </a>
            <# } #>
            <p class="my-description">{{{ settings.description }}}</p>
        </div>
        <?php
    }
}
```

## Controls Reference

### Text Controls

```php
// Text
$this->add_control('text', [
    'label' => __('Text', 'my-plugin'),
    'type' => Controls_Manager::TEXT,
    'default' => '',
    'placeholder' => '',
]);

// Number
$this->add_control('number', [
    'label' => __('Number', 'my-plugin'),
    'type' => Controls_Manager::NUMBER,
    'min' => 0,
    'max' => 100,
    'step' => 1,
    'default' => 10,
]);

// Textarea
$this->add_control('textarea', [
    'label' => __('Textarea', 'my-plugin'),
    'type' => Controls_Manager::TEXTAREA,
    'rows' => 5,
]);

// WYSIWYG Editor
$this->add_control('wysiwyg', [
    'label' => __('WYSIWYG', 'my-plugin'),
    'type' => Controls_Manager::WYSIWYG,
]);
```

### Selection Controls

```php
// Select
$this->add_control('select', [
    'label' => __('Select', 'my-plugin'),
    'type' => Controls_Manager::SELECT,
    'options' => [
        'option1' => __('Option 1', 'my-plugin'),
        'option2' => __('Option 2', 'my-plugin'),
        'option3' => __('Option 3', 'my-plugin'),
    ],
    'default' => 'option1',
]);

// Select2
$this->add_control('select2', [
    'label' => __('Select2', 'my-plugin'),
    'type' => Controls_Manager::SELECT2,
    'options' => [
        'opt1' => 'Option 1',
        'opt2' => 'Option 2',
        'opt3' => 'Option 3',
    ],
    'multiple' => true,
]);

// Radio Buttons
$this->add_control('radio', [
    'label' => __('Radio', 'my-plugin'),
    'type' => Controls_Manager::RADIO,
    'options' => [
        'left' => __('Left', 'my-plugin'),
        'center' => __('Center', 'my-plugin'),
        'right' => __('Right', 'my-plugin'),
    ],
    'default' => 'center',
]);

// Checkbox
$this->add_control('checkbox', [
    'label' => __('Checkbox', 'my-plugin'),
    'type' => Controls_Manager::CHECKBOX,
    'return_value' => 'yes',
    'default' => '',
]);

// Switcher
$this->add_control('switcher', [
    'label' => __('Switcher', 'my-plugin'),
    'type' => Controls_Manager::SWITCHER,
    'label_on' => __('Yes', 'my-plugin'),
    'label_off' => __('No', 'my-plugin'),
    'return_value' => 'yes',
    'default' => '',
]);
```

### Media Controls

```php
// Media (Image)
$this->add_control('image', [
    'label' => __('Choose Image', 'my-plugin'),
    'type' => Controls_Manager::MEDIA,
    'default' => [
        'url' => \Elementor\Utils::get_placeholder_image_src(),
    ],
]);

// Get image URL in render
$image_url = $settings['image']['url'];
$image_alt = get_post_meta($settings['image']['id'], '_wp_attachment_image_alt', true);

// Media (Video)
$this->add_control('video', [
    'label' => __('Choose Video', 'my-plugin'),
    'type' => Controls_Manager::MEDIA,
    'media_types' => ['video'],
]);

// File Upload
$this->add_control('file', [
    'label' => __('Choose File', 'my-plugin'),
    'type' => Controls_Manager::MEDIA,
    'media_types' => ['application/pdf'],
]);
```

### Color Controls

```php
// Color
$this->add_control('color', [
    'label' => __('Color', 'my-plugin'),
    'type' => Controls_Manager::COLOR,
    'default' => '#000000',
]);

// Colors with alpha
$this->add_control('color_alpha', [
    'label' => __('Color with Alpha', 'my-plugin'),
    'type' => Controls_Manager::COLOR,
    'alpha' => true,
]);
```

### Layout Controls

```php
// Slider
$this->add_control('padding', [
    'label' => __('Padding', 'my-plugin'),
    'type' => Controls_Manager::SLIDER,
    'size_units' => ['px', 'em', 'rem'],
    'range' => [
        'px' => ['min' => 0, 'max' => 100],
        'em' => ['min' => 0, 'max' => 10],
    ],
    'default' => ['unit' => 'px', 'size' => 20],
]);

// Dimensions
$this->add_control('margin', [
    'label' => __('Margin', 'my-plugin'),
    'type' => Controls_Manager::DIMENSIONS,
    'size_units' => ['px', '%', 'em'],
    'allowed_dimensions' => ['top', 'right', 'bottom', 'left'],
]);

// Alignment
$this->add_control('alignment', [
    'label' => __('Alignment', 'my-plugin'),
    'type' => Controls_Manager::CHOOSE,
    'options' => [
        'left' => ['title' => __('Left', 'my-plugin'), 'icon' => 'eicon-text-align-left'],
        'center' => ['title' => __('Center', 'my-plugin'), 'icon' => 'eicon-text-align-center'],
        'right' => ['title' => __('Right', 'my-plugin'), 'icon' => 'eicon-text-align-right'],
    ],
    'default' => 'center',
]);
```

### Content Controls

```php
// Posts Query
$this->add_control('posts_query', [
    'label' => __('Query', 'my-plugin'),
    'type' => Controls_Manager::SELECT2,
    'options' => [
        'wp_posts' => __('Posts', 'my-plugin'),
        'wp_pages' => __('Pages', 'my-plugin'),
    ],
]);

// Icon
$this->add_control('icon', [
    'label' => __('Icon', 'my-plugin'),
    'type' => Controls_Manager::ICONS,
    'default' => ['value' => 'fas fa-star', 'library' => 'fa-solid'],
]);

// Divider
$this->add_control('divider', [
    'type' => Controls_Manager::DIVIDER,
]);

// Heading
$this->add_control('section_heading', [
    'label' => __('Section', 'my-plugin'),
    'type' => Controls_Manager::HEADING,
]);
```

## Group Controls

```php
// Typography
$this->add_group_control(
    \Elementor\Group_Control_Typography::get_type(),
    [
        'name' => 'heading_typography',
        'label' => __('Typography', 'my-plugin'),
        'selector' => '{{WRAPPER}} .my-heading',
    ]
);

// Text Shadow
$this->add_group_control(
    \Elementor\Group_Control_Text_Shadow::get_type(),
    [
        'name' => 'text_shadow',
        'label' => __('Text Shadow', 'my-plugin'),
        'selector' => '{{WRAPPER}} .my-text',
    ]
);

// Box Shadow
$this->add_group_control(
    \Elementor\Group_Control_Box_Shadow::get_type(),
    [
        'name' => 'box_shadow',
        'label' => __('Box Shadow', 'my-plugin'),
        'selector' => '{{WRAPPER}} .my-box',
    ]
);

// Background
$this->add_group_control(
    \Elementor\Group_Control_Background::get_type(),
    [
        'name' => 'background',
        'label' => __('Background', 'my-plugin'),
        'types' => ['classic', 'gradient'],
        'selector' => '{{WRAPPER}} .my-background',
    ]
);

// Border
$this->add_group_control(
    \Elementor\Group_Control_Border::get_type(),
    [
        'name' => 'border',
        'label' => __('Border', 'my-plugin'),
        'selector' => '{{WRAPPER}} .my-border',
    ]
);

// Border Radius
$this->add_group_control(
    \Elementor\Group_Control_Border::get_type(),
    [
        'name' => 'border_radius',
        'label' => __('Border Radius', 'my-plugin'),
        'fields_options' => [
            'border' => ['name' => 'border_radius'],
            'radius' => ['label' => __('Border Radius', 'my-plugin')],
        ],
        'selector' => '{{WRAPPER}} .my-radius',
    ]
);

// Image Size
$this->add_group_control(
    \Elementor\Group_Control_Image_Size::get_type(),
    [
        'name' => 'image_size',
        'label' => __('Image Size', 'my-plugin'),
        'default' => 'large',
    ]
);
```

## Dynamic Content

```php
// Dynamic Tags
use Elementor\Modules\DynamicTags\Module as DynamicTagsModule;

$this->add_control('dynamic_content', [
    'label' => __('Dynamic Content', 'my-plugin'),
    'type' => Controls_Manager::TEXT,
    'dynamic' => [
        'active' => true,
        'categories' => [
            DynamicTagsModule::TEXT_CATEGORY,
            DynamicTagsModule::POST_META_CATEGORY,
        ],
    ],
]);

// Custom Dynamic Tag
add_action('elementor/dynamic_tags/register', function($dynamic_tags) {
    class My_Dynamic_Tag extends \Elementor\Core\DynamicTags\Tag {
        public function get_name() {
            return 'my-dynamic-tag';
        }

        public function get_title() {
            return __('My Dynamic Tag', 'my-plugin');
        }

        public function get_group() {
            return 'my-group';
        }

        public function get_categories() {
            return [\Elementor\Modules\DynamicTags\Module::TEXT_CATEGORY];
        }

        public function render() {
            echo get_post_meta(get_the_ID(), 'my_meta_key', true);
        }
    }

    $dynamic_tags->register(new My_Dynamic_Tag());
});
```

## Repeater Controls

```php
// Repeater field
$this->add_control('items_list', [
    'label' => __('Items', 'my-plugin'),
    'type' => Controls_Manager::REPEATER,
    'fields' => [
        [
            'name' => 'item_title',
            'label' => __('Title', 'my-plugin'),
            'type' => Controls_Manager::TEXT,
            'default' => __('Item', 'my-plugin'),
        ],
        [
            'name' => 'item_icon',
            'label' => __('Icon', 'my-plugin'),
            'type' => Controls_Manager::ICONS,
        ],
        [
            'name' => 'item_link',
            'label' => __('Link', 'my-plugin'),
            'type' => Controls_Manager::URL,
        ],
    ],
    'default' => [
        ['item_title' => __('Item 1', 'my-plugin')],
        ['item_title' => __('Item 2', 'my-plugin')],
    ],
    'title_field' => '<i class="{{{ item_icon.value }}}"></i> {{{ item_title }}}',
]);

// Render repeater
if ($settings['items_list']) {
    echo '<ul>';
    foreach ($settings['items_list'] as $item) {
        echo '<li>';
        if (!empty($item['item_link']['url'])) {
            echo '<a href="' . esc_url($item['item_link']['url']) . '">';
        }
        echo esc_html($item['item_title']);
        if (!empty($item['item_link']['url'])) {
            echo '</a>';
        }
        echo '</li>';
    }
    echo '</ul>';
}
```

## Conditions & Hiding Controls

```php
// Show control based on another control
$this->add_control('show_icon', [
    'label' => __('Show Icon', 'my-plugin'),
    'type' => Controls_Manager::SWITCHER,
    'return_value' => 'yes',
    'default' => '',
]);

$this->add_control('icon', [
    'label' => __('Icon', 'my-plugin'),
    'type' => Controls_Manager::ICONS,
    'condition' => [
        'show_icon' => 'yes',
    ],
]);

// Multiple conditions (AND)
$this->add_control('advanced_option', [
    'label' => __('Advanced Option', 'my-plugin'),
    'type' => Controls_Manager::TEXT,
    'condition' => [
        'show_icon' => 'yes',
        'layout' => 'advanced',
    ],
]);

// Multiple conditions (OR)
$this->add_control('fallback_option', [
    'label' => __('Fallback Option', 'my-plugin'),
    'type' => Controls_Manager::TEXT,
    'conditions' => [
        'relation' => 'or',
        'terms' => [
            ['name' => 'option1', 'operator' => '===', 'value' => 'yes'],
            ['name' => 'option2', 'operator' => '===', 'value' => 'yes'],
        ],
    ],
]);
```

## Register Widget

```php
// Main plugin file
function register_my_widgets($widgets_manager) {
    require_once(__DIR__ . '/widgets/my-widget.php');
    require_once(__DIR__ . '/widgets/another-widget.php');
    
    $widgets_manager->register(new \MyPlugin\Widgets\My_Widget());
    $widgets_manager->register(new \MyPlugin\Widgets\Another_Widget());
}
add_action('elementor/widgets/register', 'register_my_widgets');

// Register categories
function add_my_widget_categories($elements_manager) {
    $elements_manager->add_category('my-category', [
        'title' => __('My Category', 'my-plugin'),
        'icon' => 'fa fa-plug',
    ]);
}
add_action('elementor/elements/categories_registered', 'add_my_widget_categories');
```

## Extensions

```php
// Add custom controls to existing widgets
add_action('elementor/element/text-editor/document_elements/after_add_attributes', function($element) {
    $element->add_render_attribute('_wrapper', 'data-my-attribute', 'value');
});

// Custom Section/Column controls
add_action('elementor/element/column/layout/before_section_end', function($element) {
    $element->add_control('my_custom_control', [
        'label' => __('Custom Control', 'my-plugin'),
        'type' => \Elementor\Controls_Manager::TEXT,
        'separator' => 'before',
    ]);
});

// Frontend hooks
add_action('elementor/frontend/after_enqueue_styles', function() {
    wp_enqueue_style('my-style');
});

add_action('elementor/frontend/before_register_scripts', function() {
    wp_register_script('my-script', plugins_url('/assets/js/my-script.js', __FILE__), ['elementor-frontend'], '1.0.0', true);
});
```

## Template System

```php
// Include template
protected function render() {
    if (is_preview()) {
        $this->content_template();
        return;
    }
    
    include(__DIR__ . '/views/my-widget-view.php');
}

// Template with data
protected function render() {
    $settings = $this->get_settings_for_display();
    
    $template_data = [
        'heading' => $settings['heading'],
        'description' => $settings['description'],
        'items' => $settings['items_list'],
    ];
    
    include(__DIR__ . '/views/my-widget-view.php');
}

// view.php
// <div class="my-widget">
//     <h2><?php echo esc_html($data['heading']); ?></h2>
//     <p><?php echo esc_html($data['description']); ?></p>
// </div>
```

## AJAX in Widgets

```php
// Frontend JS
frontend.addAction('init', function() {
    elementorFrontend.elements.$body.on('click', '.my-widget button', function() {
        var $button = jQuery(this);
        var widgetId = $button.closest('.elementor-widget').data('elementor-id');
        
        jQuery.ajax({
            url: myWidget.ajaxUrl,
            type: 'POST',
            data: {
                action: 'my_widget_ajax',
                nonce: myWidget.nonce,
                widget_id: widgetId,
                post_id: elementorFrontend.getCurrentEditorElement().data['elementorId']
            },
            success: function(response) {
                console.log(response);
            }
        });
    });
});

// PHP Handler
add_action('wp_ajax_my_widget_ajax', 'my_widget_ajax_handler');
add_action('wp_ajax_nopriv_my_widget_ajax', 'my_widget_ajax_handler');

function my_widget_ajax_handler() {
    check_ajax_referer('my_widget_nonce', 'nonce');
    
    $widget_id = sanitize_text_field($_POST['widget_id']);
    
    wp_send_json_success(['message' => 'Success']);
}
```

## Skin (for loop widgets)

```php
class My_Widget extends Widget_Base {
    
    protected function register_skins() {
        $this->add_skin('skin_1', new \Elementor\Skin_Classic($this));
        $this->add_skin('skin_2', new \Elementor\Skin_Inline($this));
    }
}

class Skin_Classic extends \Elementor\Skin_Base {
    
    public function get_id() {
        return 'classic';
    }
    
    public function get_label() {
        return __('Classic', 'my-plugin');
    }
    
    public function render() {
        $settings = $this->parent->get_settings_for_display();
        // Render with classic style
    }
}
```
