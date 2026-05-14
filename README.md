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

## Config Sync

Base configs in `configs/` can be synced to your system:

```bash
./scripts/sync-configs.sh
```

**Smart merge** — reads from `configs/`, merges with existing `~/.claude/settings.json` without losing local customizations. Backs up before changes.

See `scripts/sync-configs.sh` for details.

## Dev notes

- Update `CLAUDE.md` when rules change
- Plugin registered in `.claude-plugin/plugin.json`
- Skills symlinked via `scripts/link-skills.sh`
- Configs synced via `scripts/sync-configs.sh`
