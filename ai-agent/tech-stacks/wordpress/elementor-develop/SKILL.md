---
name: elementor-develop
description: Elementor plugin development. Use when user asks to create Elementor widgets, extensions, or work with Elementor.
---

# Elementor Development Guide

## When to use
- User asks to create Elementor widget
- User asks to extend Elementor
- User asks about Elementor hooks
- User asks to add custom controls

## Widget Structure

```
my-elementor-widget/
├── widgets/
│   └── my-widget.php
├── controls/
│   └── my-control.php
├── my-elementor.php
└── composer.json
```

## Basic Widget

```php
namespace Plugin\Widgets;

use Elementor\Widget_Base;
use Elementor\Controls_Manager;

class My_Widget extends Widget_Base {

    public function get_name() {
        return 'my_widget';
    }

    public function get_title() {
        return __('My Widget', 'my-plugin');
    }

    public function get_icon() {
        return 'eicon-kit-drag-n-drop';
    }

    public function get_categories() {
        return ['basic'];
    }

    protected function register_controls() {
        // Content Section
        $this->start_controls_section('content_section', [
            'label' => __('Content', 'my-plugin'),
            'tab' => Controls_Manager::TAB_CONTENT,
        ]);

        $this->add_control('heading', [
            'label' => __('Heading', 'my-plugin'),
            'type' => Controls_Manager::TEXT,
            'default' => __('Hello World', 'my-plugin'),
        ]);

        $this->end_controls_section();

        // Style Section
        $this->start_controls_section('style_section', [
            'label' => __('Style', 'my-plugin'),
            'tab' => Controls_Manager::TAB_STYLE,
        ]);

        $this->add_control('color', [
            'label' => __('Color', 'my-plugin'),
            'type' => Controls_Manager::COLOR,
            'selectors' => [
                '{{WRAPPER}} .my-heading' => 'color: {{VALUE}}',
            ],
        ]);

        $this->end_controls_section();
    }

    protected function render() {
        $settings = $this->get_settings_for_display();
        ?>
        <h2 class="my-heading"><?php echo esc_html($settings['heading']); ?></h2>
        <?php
    }

    protected function content_template() {
        ?>
        <h2 class="my-heading">{{{ settings.heading }}}</h2>
        <?php
    }
}
```

## Controls Reference

| Control | Class |
|---------|-------|
| Text | `Controls_Manager::TEXT` |
| Textarea | `Controls_Manager::TEXTAREA` |
| Number | `Controls_Manager::NUMBER` |
| Select | `Controls_Manager::SELECT2` |
| Switcher | `Controls_Manager::SWITCHER` |
| Color | `Controls_Manager::COLOR` |
| Media | `Controls_Manager::MEDIA` |
| Slider | `Controls_Manager::SLIDER` |
| Dimensions | `Controls_Manager::DIMENSIONS` |
| Typography | `Controls_Manager::TYPOGRAPHY` |
| Box Shadow | `Controls_Manager::BOX_SHADOW` |

## Register Widget

```php
function register_my_widget($widgets_manager) {
    require_once(__DIR__ . '/widgets/my-widget.php');
    $widgets_manager->register(new \Plugin\Widgets\My_Widget());
}
add_action('elementor/widgets/register', 'register_my_widget');
```

## Section & Column

```php
// Section
$this->start_controls_section('section_id', [
    'label' => __('Section Title', 'my-plugin'),
    'tab' => Controls_Manager::TAB_CONTENT,
]);

// Column
protected function render() {
    $settings = $this->get_settings_for_display();
    ?>
    <div class="my-widget">
        <div class="my-column">
            <?php $this->print_rendered_content(); ?>
        </div>
    </div>
    <?php
}
```

## Dynamic Content

```php
use Elementor\Modules\DynamicTags\Module as DynamicTagsModule;

$this->add_control('heading', [
    'type' => Controls_Manager::TEXT,
    'dynamic' => [
        'active' => true,
        'default' => DynamicTagsModule::TAG_TYPE_TEXT,
    ],
]);
```

## Widgets Categories

```php
public function get_categories() {
    return [
        'basic',
        'general',
        'pro-elements',
        'theme-elements',
        'woocommerce',
        'slides',
    ];
}
```

## Extension Hooks

```php
// Add Actions
add_action('elementor/frontend/before_register_scripts', function() {});
add_action('elementor/frontend/before_enqueue_scripts', function() {});
add_action('elementor/editor/before_enqueue_styles', function() {});

// Add Controls to existing widget
add_action('elementor/element/button/section_style/before_section_start', function($element, $args) {
    $element->start_controls_section('my_section', [
        'label' => __('My Section', 'my-plugin'),
        'tab' => Controls_Manager::TAB_STYLE,
    ]);
    
    $element->add_control('my_color', [
        'label' => __('My Color', 'my-plugin'),
        'type' => Controls_Manager::COLOR,
        'selectors' => [
            '{{WRAPPER}} .button' => 'color: {{VALUE}}',
        ],
    ]);
    
    $element->end_controls_section();
}, 10, 2);
```

## Pro Widgets (requires Elementor Pro)

```php
require_once(__DIR__ . '/widgets/pro-widget.php');
$widgets_manager->register(new \Plugin\Widgets\Pro_Widget());
```

## AJAX in Elementor

```php
add_action('wp_ajax_elementor_get_data', 'elementor_get_data');
add_action('wp_ajax_nopriv_elementor_get_data', 'elementor_get_data');

function elementor_get_data() {
    wp_send_json_success(['data' => $data]);
}
```

## Enqueue Scripts

```php
function enqueue_elementor_scripts() {
    wp_enqueue_script('my-elementor-script', plugins_url('js/script.js', __FILE__), ['elementor-frontend'], '1.0.0', true);
}
add_action('elementor/frontend/before_enqueue_scripts', 'enqueue_elementor_scripts');
```