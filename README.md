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

### Productivity
- **caveman** — Ultra-compressed prose. Cuts ~75% tokens, full accuracy.
- **handoff** — Compact current conversation into handoff doc for next agent to pick up.
- **write-a-skill** — Create new agent skills with proper structure and bundled resources.

### Engineering
- **tdd** — Test-driven development with red-green-refactor loop

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

## Scripts

Automation for setup and config management:

| Script | Purpose |
|--------|---------|
| `install.sh` | One-time setup: symlink skills + sync configs |
| `link-skills.sh` | Symlink skills to system skill directories |
| `sync-configs.sh` | Overwrite system configs from `configs/` (repo is source of truth) |
| `clean-config-backups.sh` | Clean up config backups with dry-run support |

Full docs: [`scripts/README.md`](scripts/README.md)

## Dev notes

- Update `CLAUDE.md` when rules change
- Plugin registered in `.claude-plugin/plugin.json`
- See [`scripts/README.md`](scripts/README.md) for script details
