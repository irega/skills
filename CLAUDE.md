# CLAUDE.md — irega/skills

Skills repo for Claude Code and Cursor.

## Organization

Skills in `skills/` are categorized by bucket:

- `irega/` — Personal skill about how I code (stack, patterns, testing, conventions)
- `engineering/` — Technical reusable skills (TDD, code review, etc.)
- `productivity/` — Workflow skills (handoff, planning, etc.)
- `in-progress/` — Draft skills
- `deprecated/` — Old skills, not promoted

**Rule:** Only `irega/`, `engineering/`, `productivity/` appear in top-level README and `plugin.json`. Others excluded.

## Installation

**Option A: Plugin (recommended)**
```bash
# Auto-install via Claude Code plugin system
claude plugin install irega/skills
```

**Option B: Manual symlinks**
```bash
./scripts/link-skills.sh
```

Creates symlinks in `~/.claude/skills/` and `~/.cursor/skills/`.

## Plugin registration

`.claude-plugin/plugin.json` lists all active skills. Update when adding/removing skills.

## Configs

`configs/` holds exportable settings:
- `claude/settings.json` — Base Claude Code settings template
- `cursor/rules/` — Cursor rule templates

Not auto-installed; reference manually or via install script.
