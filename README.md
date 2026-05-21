# irega/skills

Personal skills, configs, and conventions for Claude Code and Cursor.

## Quick Install

**Prerequisites:** Install [RTK](https://github.com/rtk-ai/rtk) before running the install script.

```bash
brew install rtk  # or equivalent for your platform
```

```bash
# Clone and install
git clone git@github.com:irega/skills.git ~/dev/skills
cd ~/dev/skills
./scripts/install.sh
```

The install script:
1. Symlinks skills to `~/.claude/skills/` and `~/.cursor/skills/`
2. Runs `rtk init -g` — sets up RTK.md, filters.toml, and `@RTK.md` in global CLAUDE.md
3. Optionally syncs configs (Claude settings + Cursor hooks) from `configs/`

Skills auto-available in Claude Code + Cursor. RTK active on all Bash/Shell tool calls.

## Configuration

Optional setup for enhanced features:

- **[Playwright MCP](configs/cursor/README.md#playwright-mcp-server)** — Browser automation with Chrome extension token setup

## Skills

### Personal
- **irega** — Coding philosophy, conventions, and preferred approaches

### Productivity
- **caveman** — Ultra-compressed prose. Cuts ~75% tokens, full accuracy.
- **handoff** — Compact current conversation into handoff doc for next agent to pick up.
- **write-a-skill** — Create new agent skills with proper structure and bundled resources.

### Engineering
- **tdd** — Test-driven development with red-green-refactor loop
- **pr-description** — Generate PR descriptions from template and git changes, with Jira ticket extraction
- **code-review** — Multi-axis code review (correctness, readability, architecture, security, performance)
- **security-audit** — OWASP-focused security review and vulnerability detection
- **staff-review** — Technical design and architectural judgment from Staff Engineer perspective

## Structure

```
skills/
├── irega/             # Personal skill: my dev approach
├── engineering/       # Reusable technical skills
└── productivity/      # Workflow and efficiency skills

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

## Inspiration

Built with inspiration from:
- [saski/augmentedcode-configuration](https://github.com/saski/augmentedcode-configuration)
- [mattpocock/skills](https://github.com/mattpocock/skills)
