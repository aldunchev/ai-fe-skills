# Project Context

> **This is the single configuration file for the drupal-figma-to-canvas-sdc skill.**
> Edit the tables and sections below to match your Drupal project. All other skill files reference this file instead of hardcoding project-specific values.
> For a filled-in example, see `project-context.example.md` in the skill root.

## Theme Configuration

| Setting | Value |
|---------|-------|
| Theme name | `your_theme` |
| Theme root path | `web/themes/custom/your_theme/` |
| Component namespace | `your_theme` |
| SDC include pattern | `{% include 'your_theme:component' with {...} only %}` |

## Component Directories

| Atomic Level | Directory |
|-------------|-----------|
| atom | `components/01-atoms/` |
| molecule | `components/02-molecules/` |
| organism | `components/03-organisms/` |

Always use numbered directories. Never use bare `atoms/`, `molecules/`, or `organisms/`.

## Available Atoms for Composition

List your theme's reusable atoms that molecules/organisms should compose via `{% include %}`:

| Atom | Purpose | Key Props |
|------|---------|-----------|
| `your_theme:button` | Buttons and CTAs | `element`, `text`, `url`, `button_type`, `size` |
| `your_theme:heading` | Headings (h1-h6) | `text`, `heading_tag`, `text_variant` |
| `your_theme:eyebrow` | Eyebrow/kicker text | `text`, `color` |
| `your_theme:text-block` | Body text with rich text | `content`, `text_color` |
| `your_theme:image` | Responsive images | `image`, `ratio_mobile`, `loading` |

Add or remove rows to match your theme's atom library.

## Design Tokens

### Typography

| Token Category | Classes | Notes |
|---------------|---------|-------|
| Headings | `text-h1`, `text-h2`, `text-h3`, `text-h4`, `text-h5`, `text-h6` | Largest to smallest |
| Body | `text-body-lg`, `text-body-md`, `text-body-sm` | Standard body sizes |
| Eyebrow | `text-eyebrow` | Single class, no size variants |

### Spacing

- Use standard Tailwind spacing: `p-{0-96}`, `gap-{0-96}`, `m-{0-96}`
- Examples: `p-5`, `py-7`, `px-5`, `gap-4`, `mb-2.5`, `mt-auto`
- **No arbitrary values**: Never use `h-[218px]`, `w-[261px]`, `rounded-[10px]`. Map Figma pixel values to the closest standard Tailwind class.
- Custom spacing tokens (if any): _(list project-specific spacing tokens here)_

### Colors

#### Scheme / Themeable Colors (Tailwind utilities)

| Category | Utilities |
|----------|----------|
| Background | `bg-scheme-bg` |
| Text | `text-scheme-text`, `text-scheme-head`, `text-scheme-eyebrow`, `text-scheme-link` |
| Buttons | `bg-scheme-btn-primary-base`, `text-scheme-btn-primary-text`, etc. |

#### Brand Colors

| Category | Utilities |
|----------|----------|
| Brand | `bg-brand-primary`, `text-brand-primary`, `bg-brand-secondary`, etc. |

#### Neutral / System Colors

| Category | Utilities |
|----------|----------|
| Neutral | `bg-neutral-100`, `text-neutral-500`, `border-neutral-300`, etc. |
| System | `bg-system-success`, `text-system-error`, etc. |

**Never** use arbitrary color values like `bg-[var(--scheme-bg-color)]`. Always use the Tailwind utility classes above.

### Color Scheme CSS Variables (optional)

If your project uses CSS custom properties for dynamic theming, list them here:

```css
--scheme-bg-color           /* Background */
--scheme-text-color         /* Body text */
--scheme-head-color         /* Headings */
```

## Build Commands

| Command | Purpose | Run From |
|---------|---------|----------|
| `npm run build` | Production build | Theme root |
| `npm run lint:css` | Lint CSS (Stylelint) | Theme root |
| `npm run lint:js` | Lint JS (ESLint) | Theme root |
| `vendor/bin/twigcs {file}` | Lint Twig templates | Project root |
| `ddev drush cr` | Drupal cache rebuild + ComponentValidator | Project root |

Adjust commands to match your project's setup (e.g., `lando drush cr`, `drush cr`).

## Anti-Pattern: Wrong Token Patterns

Patterns that should never appear in your component code:

| Wrong Pattern | Correct Alternative |
|--------------|---------------------|
| `text-heading-*` | Use your heading token classes (e.g., `text-h3`) |
| `text-eyebrow-lg`, `text-eyebrow-sm` | `text-eyebrow` (single class, no variants) |
| `spacing-*`, `p-spacing-*`, `gap-spacing-*` | Standard Tailwind: `p-5`, `gap-4` |
| `bg-[var(--*)]`, `text-[var(--*)]` | Use Tailwind utilities: `bg-scheme-bg`, `text-brand-primary` |
| `h-[218px]`, `w-[261px]` | Map to closest Tailwind class: `h-56`, `w-64` |

## Page Builder Integration (Canvas)

Drupal Canvas requires every SDC prop to map to a storable Drupal field type. Unsupported types hide the **entire component** from the Canvas admin UI.

**Supported prop types:**
- `string`, `integer`, `number`, `boolean`
- `array` with scalar `items` (e.g., `items: { type: string }`)
- `object` with `$ref: json-schema-definitions://canvas.module/image`
- `object` with `$ref: json-schema-definitions://canvas.module/video`

**NOT supported (will break Canvas visibility):**
- `array` with `items: { type: object }` — arrays of objects
- `object` without a Canvas `$ref` — generic objects

**Solution**: Convert unsupported types to **slots**. Content editors compose slot content in Canvas using other components. Replace `{% for item in items %}` loops with `{% block slot_name %}{% endblock %}`.
