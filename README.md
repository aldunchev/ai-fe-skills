# Skills

Agent skills for frontend development — Drupal, AEM, performance optimization.

Reusable [SKILL.md](https://docs.anthropic.com/en/docs/claude-code/skills) workflows that work across AI coding agents: Claude Code, Codex, Gemini CLI, Cursor, Windsurf, and others.

## Available Skills

| Skill | Description |
|-------|-------------|
| [drupal-figma-to-canvas-sdc](./drupal-figma-to-canvas-sdc) | Build production-ready Drupal SDC components from Figma designs. Three-phase Plan-Implement-Validate workflow for Canvas + SDC + Tailwind CSS projects. |

## Usage

### Claude Code

Install a skill directly:

```bash
claude skill add --from https://github.com/aldunchev/ai-fe-skills/tree/main/drupal-figma-to-canvas-sdc
```

Or clone and reference locally:

```bash
git clone https://github.com/aldunchev/ai-fe-skills.git
```

### Other Agents

Each skill folder contains a `SKILL.md` with YAML frontmatter following the cross-compatible Agent Skills format. Copy the skill folder into your project or reference it per your agent's documentation.

## Structure

```
skills/
└── <skill-name>/
    ├── SKILL.md              # Skill definition (YAML frontmatter + instructions)
    ├── references/           # Context files used by sub-agents
    ├── assets/               # Examples and templates
    └── scripts/              # Validation scripts
```

## License

MIT
