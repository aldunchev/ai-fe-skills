# Shared Context — SDC Reference

> **Prerequisite for all phase agents.** Read `project-context.md` first for your project's tokens, atoms, paths, and commands. This file contains generic SDC rules that apply to any Drupal Canvas project.

## Directory Mapping

See `project-context.md` > Component Directories for your project's paths. Standard convention:

| Atomic Level | Numbered Directory |
|-------------|-------------------|
| atom | `components/01-atoms/` |
| molecule | `components/02-molecules/` |
| organism | `components/03-organisms/` |

Always use numbered directories. Never use bare `atoms/`, `molecules/`, or `organisms/`.

## Common Atoms for Composition

See `project-context.md` > Available Atoms for your project's atom library. Use `{% include '{namespace}:{atom}' with {...} only %}` to compose atoms — never recreate them with raw HTML.

## Design Tokens

See `project-context.md` > Design Tokens for your project's typography, spacing, and color tokens.

## Canvas Schema Compatibility

**CRITICAL**: Drupal Canvas requires every prop to map to a Drupal field type. If any prop uses an unsupported type, Canvas hides the **entire component** from the admin UI.

**Supported prop types:**
- `string`, `integer`, `number`, `boolean`
- `array` with scalar `items` (e.g., `items: { type: string }`)
- `object` with `$ref: json-schema-definitions://canvas.module/image`
- `object` with `$ref: json-schema-definitions://canvas.module/video`

**NOT supported (will break Canvas visibility):**
- `array` with `items: { type: object }` — arrays of objects
- `object` without a Canvas `$ref` — generic objects

**Solution**: Convert unsupported types to **slots**. Content editors compose slot content in Canvas using other components. Replace `{% for item in items %}` loops with `{% block slot_name %}{% endblock %}`.

## Golden Rules (Anti-Patterns to Avoid)

1. **Never recreate atoms** — Use `{% include '{namespace}:{atom}' with {...} only %}`
2. **Never use `type: string` for everything** — Use `boolean`, `enum` when appropriate
3. **Never hardcode colors** — Use your project's Tailwind color utilities (see `project-context.md`)
4. **Never use wrong typography tokens** — Use your project's heading/body/eyebrow classes (see `project-context.md`)
5. **Never use invented spacing utilities** — Use standard Tailwind `p-5`, `gap-4`
6. **Never add inline styles** — Use classes or CSS files
7. **Never use `!important`** — Increase specificity properly
8. **Never forget `only` keyword** — Always use `with {...} only` in includes
9. **Never use non-BEM naming** — Follow `.block__element--modifier` pattern
10. **Never create `.pcss`/`.src.js` unnecessarily** — Only when truly needed
11. **Never use Canvas-incompatible prop types** — See Canvas compatibility above
12. **Never include `slots: {}`** — Omit the `slots:` key entirely if no slots

## BEM Naming Convention

- Block: `.component-name`
- Element: `.component-name__element`
- Modifier: `.component-name--modifier`

Use BEM for all custom CSS classes. Tailwind utility classes do not need BEM.
