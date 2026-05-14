# CLAUDE.md — irega/skills

Skills repo for Claude Code and Cursor.

## Organization

Skills in `skills/` are categorized by bucket:

- `irega/` — Personal skill about how I code (stack, patterns, testing, conventions)
- `engineering/` — Technical reusable skills (TDD, code review, etc.)
- `productivity/` — Workflow skills (caveman, handoff, planning, etc.)
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

## Adding a new skill

When creating a new skill, update these files in order:

1. **Create skill folder** — `skills/{bucket}/skill-name/`
2. **Add skill.json** — Metadata file with name, description, version
3. **Update bucket README** — Add entry to `skills/{bucket}/README.md` if public
4. **Update root README** — Add entry to top-level README.md under correct section if public (not `in-progress/` or `deprecated/`)
5. **Update plugin.json** — Add skill entry if public (not `in-progress/` or `deprecated/`)
6. **Link scripts** — Run `./scripts/link-skills.sh` to create symlinks
7. **Test installation** — Verify skill appears in Claude Code/Cursor

**Checklist template:**
```
- [ ] Skill folder created with SKILL.md
- [ ] Bucket README updated (skills/{bucket}/README.md)
- [ ] Root README updated (top-level README.md)
- [ ] plugin.json updated (if public bucket)
- [ ] Scripts run and symlinks created
- [ ] Plugin loads in Claude Code / Cursor
```

**Why checklist?** Docs and plugin system must stay in sync — missing updates means skill exists but users can't discover it.

## Configs

`configs/` holds base settings synced to your system:

- `claude/settings.json` — Claude Code settings (model, effort level, plugins)
- `cursor/rules/` — Cursor rules
- `cursor/hooks.json` — Cursor hooks configuration

### Sync mechanism

`scripts/sync-configs.sh` does **full overwrite** (repo is source of truth):

1. Backs up before changes (`~/.claude/settings.json`, `~/.cursor/rules/`, `~/.cursor/hooks.json`)
2. Copies `configs/claude/settings.json` → `~/.claude/settings.json`
3. Copies `configs/cursor/rules/` → `~/.cursor/rules/` (recursive)
4. Copies `configs/cursor/hooks.json` → `~/.cursor/hooks.json`

Usage:
```bash
./scripts/sync-configs.sh
```

Or included in `./scripts/install.sh` (prompts user).

**Why overwrite?** This repo is the source of truth for all configuration.
