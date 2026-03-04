# Component Implementation Plan

> Replace `{theme_root}` and `{namespace}` with values from `references/project-context.md`.

## Component Details

**Component Name**: `{component-name}`
**Atomic Level**: `{atom|molecule|organism}`
**Location**: `{theme_root}/components/{directory}/{component-name}/`
**Directory Mapping**: atom -> `01-atoms`, molecule -> `02-molecules`, organism -> `03-organisms`

## Design Analysis

### Figma Context
- **File Key**: `{fileKey}`
- **Node ID**: `{nodeId}`
- **Design URL**: `{figma-url}`

### Visual Breakdown
{Describe the component's visual structure, layout, and composition}

### Component Composition
{List which atoms/molecules this component is composed of}

Example:
- Uses `{namespace}:button` for CTA
- Uses `{namespace}:heading` for title
- Uses `{namespace}:image` for visual
- Custom layout wrapper needed

## Reference Component

**Name**: `{reference-component-name}`
**Path**: `{theme_root}/components/{directory}/{reference-component-name}/`
**Why relevant**: {structural similarity explanation}

Review this component's `.twig` and `.component.yml` for patterns on atom includes, prop pass-through, and BEM naming.

## Atom Interfaces

Exact prop signatures for each composed atom. The implementation agent MUST use these — do not guess or invent props.

### {namespace}:{atom-name}

**Schema**: `{theme_root}/components/01-atoms/{atom-name}/{atom-name}.component.yml`

| Prop | Type | Required | Default | Values / Notes |
|------|------|----------|---------|----------------|
| {prop} | {type} | {yes/no} | {default} | {enum values or notes} |

**Props this component will pass**: {molecule-prop -> atom-prop mapping}

{Repeat for each composed atom}

## Props and Slots Analysis

### Required Props

| Prop Name | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| {prop} | {string\|boolean\|enum} | {yes\|no} | {value} | {description} |

### Slots

| Slot Name | Required | Description |
|-----------|----------|-------------|
| {slot} | {yes\|no} | {description} |

## Slot Child Component Dependencies

{For each slot that requires structured/repeating content, document the child component needed to fill it. Skip this section if no slots need child components.}

### Slot: `{slot_name}`

**Existing child component**: {name and path, or "None found"}
**Suggested child component**: `{kebab-case-name}`
**Suggested level**: {atom|molecule} ({01-atoms|02-molecules})
**Props needed**:
- `{prop}` ({type}) — {description}
**Visual**: {Brief description of what a single child item looks like}
**Note**: This child component must be created separately before the parent slot can be used in Canvas.

## Token Mappings

### Typography
- **Heading**: `{token-class}` (e.g., `text-h3`)
- **Body Text**: `{token-class}` (e.g., `text-body-md`)
- **Eyebrow**: `text-eyebrow` (single class, no size variants)

### Spacing
- **Container Padding**: `{token-class}` (e.g., `p-6`, `py-7`)
- **Element Gaps**: `{token-class}` (e.g., `gap-4`)
- **Margins**: `{token-class}` (e.g., `mb-2.5`)

### Colors
- **Background**: `{utility-class}` (e.g., `bg-scheme-bg`, `bg-brand-primary`)
- **Text**: `{utility-class}` (e.g., `text-scheme-text`, `text-scheme-head`)
- **Accents**: `{utility-class}` (e.g., `text-brand-secondary`, `border-neutral-300`)

### Layout
- **Container Width**: `{token or constraint}`
- **Grid/Flex**: `{tailwind classes}`
- **Breakpoints**: `{responsive behavior description}`

## Component Structure (Pseudo-code)

DOM hierarchy with Tailwind classes and atom composition. This is the **authoritative structure** for the implementation agent — translate this directly to Twig.

```
<wrapper: {tag}, class="{component-name} {tailwind-layout-classes}">
  <{namespace}:{atom} {key-prop}="{value}" {key-prop}="{value}">
  <content-wrapper: {tag}, class="{component-name}__content {tailwind-classes}">
    <{namespace}:{atom} {key-prop}="{value}">
    <{namespace}:{atom} {key-prop}="{value}">
  </content-wrapper>
  {% if condition %}
    <{namespace}:{atom} {key-prop}="{value}">
  {% endif %}
</wrapper>
```

**Notes**:
- Indentation shows nesting depth
- `{namespace}:{atom}` lines show key props only (see Atom Interfaces for full signatures)
- Tailwind classes are derived from Token Mappings above
- Conditional rendering (`{% if %}`) shown where elements are optional

## File Requirements

### Schema (.component.yml)
**Needed**: Yes
**Reason**: Define props and slots for Drupal Canvas integration

### Template (.twig)
**Needed**: Yes
**Reason**: Core component markup

### Styles (.pcss)
**Needed**: {Yes|No}
**Reason**: {Explanation — use only if Tailwind tokens insufficient}

### JavaScript (.src.js)
**Needed**: {Yes|No}
**Reason**: {Explanation — use only if interactive behavior required}

## Implementation Notes

### Atom Dependencies
{List any atoms that need to be composed}

### Custom CSS Requirements
{If .pcss needed, explain what custom styles are required and why}

### JavaScript Requirements
{If .src.js needed, explain what interactive behavior is needed}

### Accessibility Considerations
- **ARIA Labels**: {requirements}
- **Keyboard Navigation**: {requirements}
- **Screen Reader**: {requirements}

### Browser Compatibility
{Any specific compatibility concerns}

### Responsive Behavior
- **Mobile**: {behavior description}
- **Tablet**: {behavior description}
- **Desktop**: {behavior description}

## Anti-Pattern Checks

### Pre-Implementation Verification
- [ ] Component uses existing atoms where possible (not recreating)
- [ ] Props are properly typed (not all `type: string`)
- [ ] Color scheme variables used (not hardcoded colors)
- [ ] Typography tokens used (not custom font sizes)
- [ ] Spacing tokens used (not arbitrary values)
- [ ] BEM naming if custom CSS needed
- [ ] No inline styles in Twig
- [ ] No `!important` in CSS
- [ ] No hardcoded breakpoints (use Tailwind)

## Implementation Order

1. Generate `.component.yml` schema
2. Generate `.twig` template with atom composition
3. Generate `.pcss` (if needed)
4. Generate `.src.js` (if needed)
5. Validate build and lint
6. Check anti-patterns

## Success Criteria

- [ ] All files created in correct directory
- [ ] Schema validates against Drupal JSON schema
- [ ] Twig compiles without errors
- [ ] CSS builds successfully (if applicable)
- [ ] JS builds successfully (if applicable)
- [ ] All lints pass (Stylelint, ESLint)
- [ ] No anti-patterns detected
- [ ] Component matches Figma design
- [ ] Responsive behavior works correctly
- [ ] Accessibility requirements met
