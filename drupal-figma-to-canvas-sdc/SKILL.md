---
name: drupal-figma-to-canvas-sdc
description: Build a Drupal SDC component from a Figma design URL for projects using Drupal Canvas as a page builder. Handles the full workflow: analyze design, plan component structure, generate .component.yml + .twig + optional .pcss/.src.js files, then build and validate. Supports atoms, molecules, and organisms.
argument-hint: <figma-url>
disable-model-invocation: true
---

# Figma-to-Canvas-SDC Component Builder

Build production-ready Drupal SDC components from Figma designs using a three-phase Plan-Implement-Validate workflow with specialized sub-agents. Compatible with any Drupal project using Canvas + SDC + Tailwind CSS.

## Prerequisites

Before first use, copy `project-context.example.md` to `references/project-context.md` and fill in your project's theme name, paths, tokens, atoms, and build commands. All agents read this file for project-specific configuration.

## Usage

```
/drupal-figma-to-canvas-sdc https://www.figma.com/file/ABC123/Design?node-id=1-2
```

See `assets/worked-example.md` for a complete input-to-output example.

## Workflow Architecture

This skill orchestrates three sequential phases using specialized sub-agents:

1. **PLAN** (Explore agent): Analyze Figma design -> create implementation spec -> request user approval
2. **IMPLEMENT** (General-purpose agent): Generate component files automatically after approval
3. **VALIDATE** (General-purpose agent): Build, lint, verify quality, auto-fix errors with Edit tool

All agents share two common references:
- `references/project-context.md` (your project's tokens, atoms, paths, commands)
- `references/shared-context.md` (generic SDC rules, Canvas compatibility, golden rules)

## Orchestration Instructions

When this skill is invoked, follow these steps to coordinate the workflow:

### Step 1: Parse Figma URL

Extract the Figma URL from `$ARGUMENTS`:

Parse to extract:
- **File Key**: From URL path (e.g., `ABC123` from `/file/ABC123/`)
- **Node ID**: From query parameter (e.g., `1-2` from `?node-id=1-2`)

### Step 2: Prompt User for Component Name

Use AskUserQuestion to ask for a kebab-case component name (e.g., `hero-banner`, `product-card`). Provide 2-3 example options. Store the response as `component_name`.

### Step 3: Launch Planning Agent

Spawn an **Explore** sub-agent with these instructions:

1. Read these files and include their contents in the agent prompt:
   - `{skill_root}/references/project-context.md`
   - `{skill_root}/references/shared-context.md`
   - `{skill_root}/references/planning.md`
2. Provide context: Figma URL, File Key, Node ID, Component Name
3. Direct output to: `.claude/scratchpads/component-plan-{name}.md`
   using template: `{skill_root}/assets/component-plan.md`
4. Required output: all sections from the planning reference (component details, design analysis, reference component, atom interfaces, props/slots, token mappings, component structure pseudo-code, file requirements, implementation notes, anti-pattern checks, success criteria)

Wait for completion.

### Step 4: Present Plan and Request User Approval

Read the completed plan from `.claude/scratchpads/component-plan-{name}.md`.

Present key details to the user:
- Component name and atomic level
- Key design decisions
- Files that will be generated
- Token mappings used
- Whether CSS/JS files are needed and why

Use AskUserQuestion with options: "Yes, proceed" / "No, need changes".

If user approves: Continue to Step 5.
If user requests changes: Ask what needs to change, potentially re-run planning agent, then request approval again.

### Step 5: Launch Implementation Agent

Spawn a **general-purpose** sub-agent with these instructions:

1. Read these files and include their contents in the agent prompt:
   - `{skill_root}/references/project-context.md`
   - `{skill_root}/references/shared-context.md`
   - `{skill_root}/references/implementation.md`
2. Provide context: Component Name, Plan Location (`.claude/scratchpads/component-plan-{name}.md`)
3. Key tasks: Read plan, generate `.component.yml`, `.twig`, optional `.pcss`/`.src.js` in the correct numbered directory
4. The agent must use the plan's **Atom Interfaces** and **Component Structure pseudo-code** as its primary guides

Wait for completion. Collect the list of created files and component location.

### Step 6: Launch Validation Agent

Spawn a **general-purpose** sub-agent with these instructions:

1. Read these files and include their contents in the agent prompt:
   - `{skill_root}/references/project-context.md`
   - `{skill_root}/references/shared-context.md`
   - `{skill_root}/references/validation.md`
2. Provide context: Component Name, Component Location (from Step 5 output)
3. The agent has Bash, Read, Edit, Write, and Grep tools available
4. Key tasks: Verify files, run build command, run linters, run `validate-antipatterns.sh`, check manual anti-patterns (17-18), auto-fix errors (max 3 attempts), generate validation report
5. Direct output to: `.claude/scratchpads/validation-report-{name}.md`

Wait for completion.

### Step 7: Present Final Report

Read the validation report and present a summary to the user including:
- Files created
- Build and lint status
- Anti-pattern check results
- Auto-fix summary
- Manual review items (if any)
- Next steps (test in Canvas, test responsive, test color schemes, test accessibility)

## Phase Summary

| Phase | Agent Type | Key Tools | Input | Output |
|-------|-----------|-----------|-------|--------|
| Plan | Explore | Figma MCP, Read, Glob, Grep | Figma URL + name | `component-plan-{name}.md` |
| Implement | general-purpose | Read, Write, Edit, Glob | Approved plan | Component files |
| Validate | general-purpose | Bash, Read, Edit, Grep | Component location | `validation-report-{name}.md` |

## Error Handling

- **Figma fetch fails**: Report to user, request valid URL
- **Build fails**: Auto-fix syntax errors, re-build (max 3 attempts)
- **Lint fails**: Run with `--fix` flag, then manual fixes (max 3 attempts)
- **Anti-patterns found**: Fix with Edit tool, re-validate (max 3 attempts)
- **Still failing after 3 attempts**: Document remaining errors, provide manual fix instructions

## Success Criteria

- Build completes without errors
- All linters pass (Stylelint, ESLint, TwigCS)
- All 16 automated + 2 manual anti-pattern checks pass
- Component matches Figma design
- Accessible, responsive, themeable

## Troubleshooting

**Figma access issues**: Use `mcp__figma__get_screenshot` and `mcp__figma__get_design_context` (never WebFetch). Verify URL format and permissions.

**Build failures**: Check PostCSS syntax, Tailwind class names, JavaScript syntax. Review build error messages.

**Lint failures**: Run linters with `--fix` first. Check for `!important`, BEM naming, hardcoded values.

All reference material (tokens, atoms, Canvas rules, anti-patterns) is in `references/shared-context.md` and `references/project-context.md`.

---

## Quick Reference: Orchestration Flow

```
/drupal-figma-to-canvas-sdc <url>
    |
1. Parse Figma URL from $ARGUMENTS
2. Prompt user for component name (AskUserQuestion)
    |
3. Agent(Explore) -> Planning Agent
    |-- Fetch Figma design (MCP tools)
    |-- Analyze and determine atomic level
    |-- Map tokens, identify atoms
    +-- Create plan -> .claude/scratchpads/component-plan-{name}.md
    |
4. Present plan to user -> Request approval (AskUserQuestion)
    | (if approved)
5. Agent(general-purpose) -> Implementation Agent
    |-- Read plan
    |-- Generate .component.yml
    |-- Generate .twig
    |-- Generate .pcss (if needed)
    |-- Generate .src.js (if needed)
    +-- Return list of created files
    |
6. Agent(general-purpose) -> Validation Agent
    |-- Run build command
    |-- Run lint:css && lint:js && twigcs
    |-- Run `validate-antipatterns.sh` + manual checks 17-18
    |-- Auto-fix errors with Edit tool (max 3 attempts)
    +-- Generate report -> .claude/scratchpads/validation-report-{name}.md
    |
7. Present final report with all results
```

---

## Single-Pass Mode

For AI tools without sub-agent support, load context files manually in this sequence:

1. Read `references/project-context.md` and `references/shared-context.md`
2. Read `references/planning.md` — follow the planning steps, write the plan
3. Show the plan to the user for approval
4. Read `references/implementation.md` — generate component files from the plan
5. Read `references/validation.md` — run build, lint, anti-pattern checks, fix errors
6. Present final report

This produces the same output quality as the sub-agent workflow but requires following each phase sequentially.
