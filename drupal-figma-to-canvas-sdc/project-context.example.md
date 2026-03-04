# Project Context — Acme Theme (Example)

> This is a filled-in example using a fictional "acme" theme. Copy `references/project-context.md` and fill it in like this for your project.

## Theme Configuration

| Setting | Value |
|---------|-------|
| Theme name | `acme` |
| Theme root path | `web/themes/custom/acme/` |
| Component namespace | `acme` |
| SDC include pattern | `{% include 'acme:component' with {...} only %}` |

## Component Directories

| Atomic Level | Directory |
|-------------|-----------|
| atom | `components/01-atoms/` |
| molecule | `components/02-molecules/` |
| organism | `components/03-organisms/` |

## Available Atoms for Composition

| Atom | Purpose | Key Props |
|------|---------|-----------|
| `acme:button` | Buttons and CTAs | `element`, `text`, `url`, `button_type`, `background_type`, `size` |
| `acme:heading` | Headings (h1-h6) | `text`, `heading_tag`, `text_variant`, `font_family`, `heading_color` |
| `acme:eyebrow` | Eyebrow/kicker text | `text`, `color` |
| `acme:text-block` | Body text with rich text | `content`, `text_color` |
| `acme:image` | Responsive images | `image`, `ratio_mobile`, `loading`, `width_context` |
| `acme:menu-link` | Navigation/menu links | `text`, `url`, `icon` |

## Design Tokens

### Typography

| Token Category | Classes | Notes |
|---------------|---------|-------|
| Headings | `text-h1`, `text-h2`, `text-h3`, `text-h4`, `text-h5`, `text-h6` | 1 = largest, 6 = smallest |
| Body | `text-body-xl`, `text-body-lg`, `text-body-md`, `text-body-sm`, `text-body-xs` | Standard body sizes |
| Eyebrow | `text-eyebrow` | Single class, no size variants |

### Spacing

- Standard Tailwind: `p-{0-96}`, `gap-{0-96}`, `m-{0-96}`
- Custom tokens: `--spacing-text-bottom` (text vertical rhythm), `--spacing-button-*` (button sizing)
- **No arbitrary values**: Map Figma pixels to nearest Tailwind class.

### Colors

#### Scheme / Themeable Colors

| Category | Utilities |
|----------|----------|
| Background | `bg-scheme-bg` |
| Text | `text-scheme-text`, `text-scheme-head`, `text-scheme-eyebrow`, `text-scheme-link` |
| Buttons | `bg/text/border-scheme-btn-primary-{base,text,hover-bg,hover-text}`, `bg/text/border-scheme-btn-inverted-{base,text,hover-bg,hover-text}` |

#### Brand Colors

| Category | Utilities |
|----------|----------|
| Brand | `bg/text/border-brand-{a,b,c,d,e,f}` |

#### Neutral / System Colors

| Category | Utilities |
|----------|----------|
| Base | `bg/text/border-base-{light,dark}` |
| Neutral | `bg/text/border-neutral-{100,200,300,400,500}` |
| System | `bg/text/border-system-{success,info,warning,error}` |

### Color Scheme CSS Variables

```css
--scheme-bg-color           /* Background */
--scheme-text-color         /* Body text */
--scheme-head-color         /* Headings */
--scheme-eyebrow-color      /* Eyebrow text */
--scheme-link-color         /* Links */
--scheme-button-primary-base    /* Primary button bg */
--scheme-button-inverted-base   /* Inverted button bg */
```

## Build Commands

| Command | Purpose | Run From |
|---------|---------|----------|
| `npm run build` | Production build (PostCSS + esbuild) | `web/themes/custom/acme/` |
| `npm run lint:css` | Lint CSS via Stylelint | `web/themes/custom/acme/` |
| `npm run lint:js` | Lint JS via ESLint | `web/themes/custom/acme/` |
| `vendor/bin/twigcs {file}` | Lint Twig templates | Project root |
| `ddev drush cr` | Drupal cache rebuild + ComponentValidator | Project root |

## Anti-Pattern: Wrong Token Patterns

| Wrong Pattern | Correct Alternative |
|--------------|---------------------|
| `text-heading-*` | `text-h1` through `text-h6` |
| `text-eyebrow-lg`, `text-eyebrow-sm` | `text-eyebrow` (single class) |
| `spacing-*`, `p-spacing-*`, `gap-spacing-*` | Standard Tailwind: `p-5`, `gap-4` |
| `bg-[var(--*)]`, `text-[var(--*)]` | Tailwind utilities: `bg-scheme-bg`, `text-brand-a` |
| `h-[218px]`, `w-[261px]` | Closest Tailwind class: `h-56`, `w-64` |

## Page Builder Integration (Canvas)

**Supported prop types:** `string`, `integer`, `number`, `boolean`, scalar arrays, `object` with `$ref: canvas.module/image` or `canvas.module/video`.

**NOT supported:** `array` of objects, generic `object` without Canvas `$ref`. Convert to **slots**.
