# Worked Example: Content Card (Acme Theme)

A complete input-to-output example showing how the Figma-to-SDC workflow produces a real molecule, using the fictional "acme" theme from `project-context.example.md`.

## Input

- **Figma design**: Vertical card with headline, image, description, and CTA button
- **Component name**: `content-card`
- **Atomic level**: molecule (composes heading + image + text-block + button)

## Planning Output (excerpt)

### Atom Composition

| Figma Element | Atom | Key Props |
|---------------|------|-----------|
| Card title | `acme:heading` | `heading_tag: 'h3'`, `text_variant: 'text-h5'` |
| Card image | `acme:image` | `ratio_mobile: '16:9'`, `loading: 'lazy'` |
| Description | `acme:text-block` | `text_color: 'none'` |
| CTA button | `acme:button` | `element: 'link'`, `button_type: 'inverted'` |

### Token Mappings

- **Typography**: `text-h5` for headline
- **Spacing**: `gap-6` between sections, `px-6` for text padding, `py-8` for card padding
- **Colors**: `bg-scheme-bg` card background, scheme text colors via atoms
- **Layout**: `flex flex-col items-center`, `text-center` for text alignment

### Component Structure (Pseudo-code)

```
<wrapper: article, class="content-card flex flex-col items-center gap-6 overflow-hidden rounded-xl bg-scheme-bg py-8">
  {% if headline %}
    <headline-wrap: div, class="content-card__headline px-6 text-center">
      <acme:heading text="{headline}" heading_tag="h3" text_variant="text-h5" heading_color="none">
    </headline-wrap>
  {% endif %}
  {% if image %}
    <media: div, class="content-card__media w-full">
      <acme:image image="{image}" ratio_mobile="16:9" loading="lazy">
    </media>
  {% endif %}
  {% if description %}
    <desc: div, class="content-card__description px-6 text-center">
      <acme:text-block content="{description}" text_color="none">
    </desc>
  {% endif %}
  {% if button_text %}
    <action: div, class="content-card__action px-6">
      <acme:button element="link" text="{button_text}" url="{button_url}" button_type="inverted">
    </action>
  {% endif %}
</wrapper>
```

## Generated Files

### `content-card.component.yml`

```yaml
'$schema': https://git.drupalcode.org/project/drupal/-/raw/11.0.x/core/modules/sdc/src/component.schema.json

name: Content Card

description: 'A content card with headline, media, description and call-to-action button in a centered vertical layout.'

status: stable

group: Molecules

props:
  type: object
  properties:
    headline:
      type: string
      title: Headline
      description: 'Card headline text.'
      default: ''
      maxLength: 55
      examples:
        - 'Headline'
    description:
      type: [string, 'null']
      title: Description
      description: 'Card description text. Supports HTML formatting.'
      default: ''
      examples:
        - 'This is the description'
    button_text:
      type: string
      title: Button Text
      description: 'Call-to-action button label.'
      default: ''
      maxLength: 30
      examples:
        - 'Read more'
    button_url:
      type: string
      title: Button URL
      description: 'Call-to-action button destination URL.'
      default: '#'
      examples:
        - '/article/123'
    image:
      title: Card Image
      type: object
      $ref: json-schema-definitions://canvas.module/image
      description: 'Select an image for the card.'
      examples:
        - src: 'https://placehold.co/800x450/b6b9c2/8b8f99?text=Content+Card'
          alt: 'Placeholder image'
          width: 800
          height: 450
```

### `content-card.twig`

```twig
{#
/**
 * @file
 * Content Card
 *
 * A content card with headline, media, description and call-to-action button
 * in a centered vertical layout.
 *
 * @param {string} headline - Card headline text
 * @param {string} description - Card description text (supports HTML)
 * @param {string} button_text - CTA button label
 * @param {string} button_url - CTA button destination URL
 * @param {object} image - Card image object with src and alt properties
 */
#}

<article{{ attributes.addClass('content-card flex flex-col items-center gap-6 overflow-hidden rounded-xl bg-scheme-bg py-8') }}>
  {% if headline %}
    <div class="content-card__headline px-6 text-center">
      {{ include('acme:heading', {
        text: headline,
        heading_tag: 'h3',
        text_variant: 'text-h5',
        font_family: 'primary',
        heading_color: 'none',
        bottom_spacing: true,
      }, with_context: false) }}
    </div>
  {% endif %}

  {% if image and image.src %}
    <div class="content-card__media w-full">
      {{ include('acme:image', {
        image: image,
        ratio_mobile: '16:9',
        loading: 'lazy',
        width_context: 'Medium',
      }, with_context: false) }}
    </div>
  {% endif %}

  {% if description %}
    <div class="content-card__description px-6 text-center">
      {{ include('acme:text-block', {
        content: description,
        text_color: 'none',
      }, with_context: false) }}
    </div>
  {% endif %}

  {% if button_text %}
    <div class="content-card__action px-6">
      {{ include('acme:button', {
        element: 'link',
        text: button_text,
        url: button_url|default('#'),
        button_type: 'inverted',
        background_type: 'filled',
        size: 'medium',
      }, with_context: false) }}
    </div>
  {% endif %}
</article>
```

### Files not created

- **`.pcss`**: Not needed — all styling handled by Tailwind utilities
- **`.src.js`**: Not needed — component is purely presentational

## Validation Results

```
Anti-Pattern Validation: content-card
Directory: web/themes/custom/acme/components/02-molecules/content-card

  OK Check 1: No hardcoded atoms
  OK Check 2: All includes use 'only'
  OK Check 3: No inline styles
  -- Check 4: No hardcoded colors in CSS (skipped — file not found)
  OK Check 5: No wrong typography tokens
  -- Check 5b: No custom font-size in CSS (skipped — file not found)
  OK Check 6: No invented utilities
  OK Check 7: Props properly typed (not all strings)
  OK Check 8: Schema name is human-readable
  OK Check 9: No arbitrary color values
  OK Check 10: No fixed width/height
  OK Check 11: Schema has status and group
  OK Check 12: Schema has per-prop examples
  -- Check 13: CSS uses BEM naming (skipped — file not found)
  OK Check 14: JavaScript uses .src.js extension
  OK Check 15: No Canvas-incompatible prop types
  OK Check 16: No redundant image slots

Results: 14 PASS, 0 FAIL, 3 SKIP
```

## Key Decisions Explained

1. **No `.pcss` file**: The card layout is fully achievable with Tailwind (`flex`, `gap-6`, `rounded-xl`, etc.). No custom animations or pseudo-elements needed.
2. **`type: [string, 'null']` for description**: Allows Canvas to pass null when the field is empty, avoiding rendering empty wrappers.
3. **`image` prop with Canvas `$ref`**: Uses `json-schema-definitions://canvas.module/image` so Canvas can map to a Drupal image field — no image slot needed.
4. **`with_context: false` instead of `only`**: Both forms prevent context leak. This component uses the `{{ include() }}` function form, where `with_context: false` is the equivalent of `only` in `{% include %}` tag form.
5. **BEM wrapper divs**: Each section (`content-card__headline`, `content-card__media`, etc.) gets a BEM-named wrapper for targeted styling and layout control.
