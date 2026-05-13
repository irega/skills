# irega/skills

Personal skills, configs, and conventions for Claude Code and Cursor.

## Quick Install

```bash
# Clone and install
git clone git@github.com:irega/skills.git ~/dev/skills
cd ~/dev/skills
./scripts/install.sh
```

Skills auto-available in Claude Code + Cursor.

## Skills

### Personal
- **irega** — Coding philosophy, conventions, and preferred approaches

### Engineering
- (coming soon)

## Structure

```
skills/
├── irega/             # Personal skill: my dev approach
└── engineering/       # Reusable technical skills

configs/
├── claude/            # Claude Code templates
└── cursor/            # Cursor rule templates
```

## What's a skill?

Markdown file with YAML frontmatter. Invoked via `/irega` or auto-triggered by the agent in Claude Code and Cursor.

See `skills/irega/SKILL.md` for structure.

## Dev notes

- Update `CLAUDE.md` when rules change
- Plugin registered in `.claude-plugin/plugin.json`
- Symlinks created by `scripts/link-skills.sh`
