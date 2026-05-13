# irega/skills — Ubiquitous Language

## Terms

**Skill** — A Markdown file with YAML frontmatter that defines a behavior or workflow for Claude Code / Cursor. Invoked via `/skill-name` or auto-triggered by patterns.

**Bucket** — Directory under `skills/` that groups related skills (e.g., `engineering/`, `productivity/`).

**Plugin** — Claude Code plugin system. `.claude-plugin/plugin.json` registers skills so they're available in Claude.

**Symlink strategy** — Alternative to plugin: `scripts/link-skills.sh` creates symlinks from `~/.claude/skills/` → repo skills, bypassing the plugin system.

**Config template** — Exportable JSON/TOML in `configs/` (Claude settings, Cursor rules, etc.). Not auto-installed; reference as needed.

**Agent** — Claude Code, Cursor, Copilot, etc. This repo targets Claude Code first, Cursor second.

## Relationships

- A **Bucket** contains many **Skills**
- A **Skill** is consumed by one or more **Agents**
- A **Config template** supplements **Agent** setup

## Principles

- Skills are composable — they reference each other via docs, not code duplication
- Each skill owns one behavior; keeps scope tight
- Personal skill (`ivan/`) documents *why* I prefer certain approaches, not just *what*
